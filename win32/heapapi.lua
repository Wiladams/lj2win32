
-- HeapApi.h -- ApiSet Contract for api-ms-win-core-heap-l1                      *  



if not _HEAPAPI_H_ then
_HEAPAPI_H_ = true;


local ffi = require("ffi")

require("win32.minwindef")
require("win32.minwinbase")




ffi.cdef[[

typedef struct _HEAP_SUMMARY {
    DWORD cb;
    SIZE_T cbAllocated;
    SIZE_T cbCommitted;
    SIZE_T cbReserved;
    SIZE_T cbMaxReserve;
} HEAP_SUMMARY, *PHEAP_SUMMARY;
typedef PHEAP_SUMMARY LPHEAP_SUMMARY;
]]


ffi.cdef[[
HANDLE
__stdcall
HeapCreate(
     DWORD flOptions,
     SIZE_T dwInitialSize,
     SIZE_T dwMaximumSize
    );


BOOL __stdcall HeapDestroy(HANDLE hHeap);

    
LPVOID
__stdcall
HeapAlloc(
     HANDLE hHeap,
     DWORD dwFlags,
     SIZE_T dwBytes
    );


LPVOID
__stdcall
HeapReAlloc(
     HANDLE hHeap,
     DWORD dwFlags,
     LPVOID lpMem,
     SIZE_T dwBytes
    );


BOOL
__stdcall
HeapFree(
     HANDLE hHeap,
     DWORD dwFlags,
      LPVOID lpMem
    );


SIZE_T
__stdcall
HeapSize(
     HANDLE hHeap,
     DWORD dwFlags,
     LPCVOID lpMem
    );


HANDLE
__stdcall
GetProcessHeap(
    VOID
    );


SIZE_T
__stdcall
HeapCompact(
     HANDLE hHeap,
     DWORD dwFlags
    );


BOOL
__stdcall
HeapSetInformation(
     HANDLE HeapHandle,
     HEAP_INFORMATION_CLASS HeapInformationClass,
    PVOID HeapInformation,
     SIZE_T HeapInformationLength
    );



BOOL
__stdcall
HeapValidate(
     HANDLE hHeap,
     DWORD dwFlags,
     LPCVOID lpMem
    );


BOOL
__stdcall
HeapSummary(
     HANDLE hHeap,
     DWORD dwFlags,
     LPHEAP_SUMMARY lpSummary
    );


DWORD
__stdcall
GetProcessHeaps(
     DWORD NumberOfHeaps,
    PHANDLE ProcessHeaps
    );



BOOL
__stdcall
HeapLock(
     HANDLE hHeap
    );



BOOL
__stdcall
HeapUnlock(
     HANDLE hHeap
    );



BOOL
__stdcall
HeapWalk(
     HANDLE hHeap,
     LPPROCESS_HEAP_ENTRY lpEntry
    );


BOOL
__stdcall
HeapQueryInformation(
     HANDLE HeapHandle,
     HEAP_INFORMATION_CLASS HeapInformationClass,
     PVOID HeapInformation,
     SIZE_T HeapInformationLength,
     PSIZE_T ReturnLength
    );
]]

end
