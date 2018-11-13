package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

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

    print("== heapWalk ==")

    -- Get the regions
    local hEntry = ffi.new("PROCESS_HEAP_ENTRY");
    hEntry.lpData = nil;    -- to start, just to be sure
    hEntry.wFlags = ffi.C.PROCESS_HEAP_REGION;

    -- Get allocated chunks of memory
    print(" -- REGIONS --")
    ffi.C.HeapLock(hHeap)
    while ffi.C.HeapWalk(hHeap, hEntry) ~= 0 do 
        print(string.format("{size =%d, overhead=%d, region=%d, committed=%d, uncommitted=%d };", 
            hEntry.cbData, hEntry.cbOverhead, 
            hEntry.iRegionIndex, 
            hEntry.Region.dwCommittedSize, hEntry.Region.dwUnCommittedSize))
    end
    ffi.C.HeapUnlock(hHeap)

--[[
    ffi.C.HeapLock(hHeap)
    while ffi.C.HeapWalk(hHeap, hEntry) ~= 0 do 
        print(string.format("{size =%d, region=%d};", hEntry.cbData, hEntry.iRegionIndex))
    end
    ffi.C.HeapUnlock(hHeap)
--]]
end


heapInformation(procHeap)
heapWalk(procHeap)
