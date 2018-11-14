package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local bit = require("bit")
local band, bor = bit.band, bit.bor

local heapapi = require("win32.heapapi")

local procHeap = ffi.C.GetProcessHeap();
if procHeap == nil then 
    print("Could not get Process Heap Handle")
    return false 
end


local function heapInformation(handle)
    local HeapInformationClass = ffi.C.HeapCompatibilityInformation;
    local HeapInformation = ffi.new("ULONG[1]")
    local HeapInformationLength = ffi.sizeof("ULONG");
    local ReturnLength = ffi.new("SIZE_T[1]")

    local success = ffi.C.HeapQueryInformation(handle, HeapInformationClass, HeapInformation, HeapInformationLength, ReturnLength) ~= 0;

    print("heapInformation: ", success)
    print("  Info: ", HeapInformation[0])
end



--[[
    typedef struct _PROCESS_HEAP_ENTRY {
    PVOID lpData;
    DWORD cbData;
    BYTE cbOverhead;
    BYTE iRegionIndex;
    WORD wFlags;
    union {
        struct {
            HANDLE hMem;
            DWORD dwReserved[ 3 ];
        } Block;
        struct {
            DWORD dwCommittedSize;
            DWORD dwUnCommittedSize;
            LPVOID lpFirstBlock;
            LPVOID lpLastBlock;
        } Region;
    } ;
} PROCESS_HEAP_ENTRY, *LPPROCESS_HEAP_ENTRY, *PPROCESS_HEAP_ENTRY;
]]

local function heapWalk(hHeap)
	local heapEntry = ffi.new("PROCESS_HEAP_ENTRY");
    heapEntry.lpData = nil;

    local res = {};
    
    ffi.C.HeapLock(hHeap)


    while ffi.C.HeapWalk(hHeap, heapEntry) ~= 0 do
        local newEntry = {};
        newEntry.size = heapEntry.cbData
        newEntry.data = tonumber(ffi.cast("intptr_t",heapEntry.lpData))
        newEntry.flags = heapEntry.wFlags

		if band(heapEntry.wFlags, ffi.C.PROCESS_HEAP_ENTRY_BUSY) ~= 0 then
            -- Allocated block
            newEntry.kind = "allocated"
             if band(heapEntry.wFlags, ffi.C.PROCESS_HEAP_ENTRY_MOVEABLE) ~= 0 then
                newEntry.moveable = tonumber(ffi.cast("intptr_t",heapEntry.Block.hMem))
            end
		elseif band(heapEntry.wFlags, ffi.C.PROCESS_HEAP_REGION) ~= 0 then
            newEntry.index = heapEntry.iRegionIndex;
			newEntry.kind = "region";
			newEntry.committed = heapEntry.Region.dwCommittedSize; 
			newEntry.uncommitted = heapEntry.Region.dwUnCommittedSize;
		elseif band(heapEntry.wFlags, ffi.C.PROCESS_HEAP_UNCOMMITTED_RANGE) ~= 0 then
			newEntry.kind = "uncommitted";
		else
            newEntry.kind = "block";
            
        end
        
        table.insert(res, newEntry)
	end

	ffi.C.HeapUnlock(hHeap);

	return res;
end

local function printRegion(entry)
    print("Region: ", entry.index)
    print(string.format("         Size: 0x%08x", entry.committed + entry.uncommitted));
    print(string.format("    Committed: 0x%08x", entry.committed))
    print(string.format("  UnCommitted: 0x%08x", entry.uncommitted))
    print("__________________________")
end

local function test_heapWalk()
    local procHeap = ffi.C.GetProcessHeap();
    local entries = heapWalk(procHeap)

    for i, entry in ipairs(entries) do
        if entry.kind == "region" then
            printRegion(entry)
        elseif entry.kind == "allocated" then
            print(string.format("{kind = '%s', data = 0x%x, size = 0x%x};",
                entry.kind, entry.data, entry.size))
        elseif entry.kind == "uncommitted" then
            print(string.format("{kind='%s', data = 0x%x, size = 0x%x};",
                entry.kind, entry.data, entry.size))
        else
            print(string.format("{kind = '%s', data = 0x%x, size = 0x%x, flags = 0x%x};",
                entry.kind, entry.data, entry.size, entry.flags))
        end
    end
end


--heapInformation(procHeap)
test_heapWalk(procHeap)
