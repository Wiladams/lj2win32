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
local function heapSummary(handle)
    local res = ffi.C.HeapSummary(
        handle,
        DWORD dwFlags,
        LPHEAP_SUMMARY lpSummary
       ) == 1;
   print("summarize heap: ", res)
end
--]]


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
		if band(heapEntry.wFlags, ffi.C.PROCESS_HEAP_ENTRY_BUSY) > 0 then
			-- Allocated block
			table.insert(res, {
						Kind = "allocated",
						Size = heapEntry.cbData,
						});
		elseif band(heapEntry.wFlags, ffi.C.PROCESS_HEAP_REGION) > 0 then
			table.insert(res, {
                        index = heapEntry.iRegionIndex,
						Kind = "region",
						Committed = heapEntry.Region.dwCommittedSize, 
						uncommitted=heapEntry.Region.dwUnCommittedSize});
		elseif band(heapEntry.wFlags, ffi.C.PROCESS_HEAP_UNCOMMITTED_RANGE) > 0 then
			table.insert(res, {
						Kind = "uncommitted",
						});
		else
			table.insert(res, {
						Kind = "block",
						}); 
		end
				
	end

	ffi.C.HeapUnlock(hHeap);

	return res;
end

local function printRegion(entry)
    print("Region: ", entry.index)
    print(string.format("         Size: 0x%08x", entry.Committed + entry.uncommitted));
    print(string.format("    Committed: 0x%08x", entry.Committed))
    print(string.format("  UnCommitted: 0x%08x", entry.uncommitted))
end

local function test_heapWalk()
    local procHeap = ffi.C.GetProcessHeap();
    local entries = heapWalk(procHeap)

    for i, entry in ipairs(entries) do
        if entry.Kind == "region" then
            printRegion(entry)
        else
            print(entry.Kind)
        end
    end
end


--heapInformation(procHeap)
test_heapWalk(procHeap)
