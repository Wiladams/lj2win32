--[[
 memoryapi.h -- ApiSet Contract for api-ms-win-core-memory-l1-1-0
--]]

--#include <apiset.h>
--#include <apisetcconv.h>
require("win32.minwindef")
require("win32.minwinbase")
local ffi = require("ffi")

local exports = {}

--[[
/* APISET_NAME: api-ms-win-core-memory-l1 */

#if !defined(RC_INVOKED)

#ifndef _APISET_MEMORY_VER
#ifdef _APISET_TARGET_VERSION
#if _APISET_TARGET_VERSION >= _APISET_TARGET_VERSION_WIN10_RS1
#define _APISET_MEMORY_VER 0x0104
#elif _APISET_TARGET_VERSION >= _APISET_TARGET_VERSION_WINTHRESHOLD
#define _APISET_MEMORY_VER 0x0103
#elif _APISET_TARGET_VERSION == _APISET_TARGET_VERSION_WINBLUE
#define _APISET_MEMORY_VER 0x0102
#elif _APISET_TARGET_VERSION == _APISET_TARGET_VERSION_WIN8
#define _APISET_MEMORY_VER 0x0101
#elif _APISET_TARGET_VERSION == _APISET_TARGET_VERSION_WIN7
#define _APISET_MEMORY_VER 0x0100
#endif
#endif
#endif

#endif // !defined(RC_INVOKED)
--]]


ffi.cdef[[
static const int FILE_MAP_WRITE    =  SECTION_MAP_WRITE;
static const int FILE_MAP_READ     =  SECTION_MAP_READ;
static const int FILE_MAP_ALL_ACCESS =SECTION_ALL_ACCESS;

static const int FILE_MAP_EXECUTE   = SECTION_MAP_EXECUTE_EXPLICIT;    // not included in FILE_MAP_ALL_ACCESS

static const int FILE_MAP_COPY      = 0x00000001;
static const int FILE_MAP_RESERVE   = 0x80000000;
]]


ffi.cdef[[
LPVOID
__stdcall
VirtualAlloc(
     LPVOID lpAddress,
     SIZE_T dwSize,
     DWORD flAllocationType,
     DWORD flProtect
    );




BOOL
__stdcall
VirtualProtect(
     LPVOID lpAddress,
     SIZE_T dwSize,
     DWORD flNewProtect,
     PDWORD lpflOldProtect
    );
]]

--[[
_When_(((dwFreeType&(MEM_RELEASE|MEM_DECOMMIT)))==(MEM_RELEASE|MEM_DECOMMIT),
    __drv_reportError("Passing both MEM_RELEASE and MEM_DECOMMIT to VirtualFree is not allowed. This results in the failure of this call"))

_When_(dwFreeType==0,
    __drv_reportError("Passing zero as the dwFreeType parameter to VirtualFree is not allowed. This results in the failure of this call"))

_When_(((dwFreeType&MEM_RELEASE))!=0 && dwSize!=0,
    __drv_reportError("Passing MEM_RELEASE and a non-zero dwSize parameter to VirtualFree is not allowed. This results in the failure of this call"))
_Success_(return != FALSE)
--]]

ffi.cdef[[
BOOL
__stdcall
VirtualFree(
    LPVOID lpAddress,
     SIZE_T dwSize,
     DWORD dwFreeType
    );

SIZE_T
__stdcall
VirtualQuery(
     LPCVOID lpAddress,
    PMEMORY_BASIC_INFORMATION lpBuffer,
     SIZE_T dwLength
    );

LPVOID
__stdcall
VirtualAllocEx(
     HANDLE hProcess,
     LPVOID lpAddress,
     SIZE_T dwSize,
     DWORD flAllocationType,
     DWORD flProtect
    );
]]

--[[
_When_(((dwFreeType&(MEM_RELEASE|MEM_DECOMMIT)))==(MEM_RELEASE|MEM_DECOMMIT),
    __drv_reportError("Passing both MEM_RELEASE and MEM_DECOMMIT to VirtualFree is not allowed. This results in the failure of this call"))

_When_(dwFreeType==0,
    __drv_reportError("Passing zero as the dwFreeType parameter to VirtualFree is not allowed. This results in the failure of this call"))

_When_(((dwFreeType&MEM_RELEASE))!=0 && dwSize!=0,
    __drv_reportError("Passing MEM_RELEASE and a non-zero dwSize parameter to VirtualFree is not allowed. This results in the failure of this call"))

_When_(((dwFreeType&MEM_DECOMMIT))!=0,
    __drv_reportError("Calling VirtualFreeEx without the MEM_RELEASE flag frees memory but not address descriptors (VADs); results in address space leaks"))
_Success_(return != FALSE)
--]]

ffi.cdef[[
BOOL
__stdcall
VirtualFreeEx(
     HANDLE hProcess,
    LPVOID lpAddress,
     SIZE_T dwSize,
     DWORD dwFreeType
    );




BOOL
__stdcall
VirtualProtectEx(
     HANDLE hProcess,
     LPVOID lpAddress,
     SIZE_T dwSize,
     DWORD flNewProtect,
     PDWORD lpflOldProtect
    );



SIZE_T
__stdcall
VirtualQueryEx(
     HANDLE hProcess,
     LPCVOID lpAddress,
    PMEMORY_BASIC_INFORMATION lpBuffer,
     SIZE_T dwLength
    );




BOOL
__stdcall
ReadProcessMemory(
     HANDLE hProcess,
     LPCVOID lpBaseAddress,
    LPVOID lpBuffer,
     SIZE_T nSize,
    SIZE_T * lpNumberOfBytesRead
    );




BOOL
__stdcall
WriteProcessMemory(
     HANDLE hProcess,
     LPVOID lpBaseAddress,
    LPCVOID lpBuffer,
     SIZE_T nSize,
    SIZE_T * lpNumberOfBytesWritten
    );

HANDLE
__stdcall
CreateFileMappingW(
     HANDLE hFile,
     LPSECURITY_ATTRIBUTES lpFileMappingAttributes,
     DWORD flProtect,
     DWORD dwMaximumSizeHigh,
     DWORD dwMaximumSizeLow,
     LPCWSTR lpName
    );
]]

if UNICODE then
exports.CreateFileMapping  = ffi.C.CreateFileMappingW;
end

ffi.cdef[[
HANDLE
__stdcall
OpenFileMappingW(
     DWORD dwDesiredAccess,
     BOOL bInheritHandle,
     LPCWSTR lpName
    );
]]

if UNICODE then
exports.OpenFileMapping  = ffi.C.OpenFileMappingW;
end

ffi.cdef[[
LPVOID
__stdcall
MapViewOfFile(
     HANDLE hFileMappingObject,
     DWORD dwDesiredAccess,
     DWORD dwFileOffsetHigh,
     DWORD dwFileOffsetLow,
     SIZE_T dwNumberOfBytesToMap
    );

LPVOID
__stdcall
MapViewOfFileEx(
     HANDLE hFileMappingObject,
     DWORD dwDesiredAccess,
     DWORD dwFileOffsetHigh,
     DWORD dwFileOffsetLow,
     SIZE_T dwNumberOfBytesToMap,
     LPVOID lpBaseAddress
    );
]]

ffi.cdef[[
BOOL
__stdcall
FlushViewOfFile(
     LPCVOID lpBaseAddress,
     SIZE_T dwNumberOfBytesToFlush
    );



BOOL
__stdcall
UnmapViewOfFile(
     LPCVOID lpBaseAddress
    );
]]


ffi.cdef[[
SIZE_T
__stdcall
GetLargePageMinimum(void);


BOOL
__stdcall
GetProcessWorkingSetSizeEx(
     HANDLE hProcess,
     PSIZE_T lpMinimumWorkingSetSize,
     PSIZE_T lpMaximumWorkingSetSize,
     PDWORD Flags
    );



BOOL
__stdcall
SetProcessWorkingSetSizeEx(
     HANDLE hProcess,
     SIZE_T dwMinimumWorkingSetSize,
     SIZE_T dwMaximumWorkingSetSize,
     DWORD Flags
    );



BOOL
__stdcall
VirtualLock(
     LPVOID lpAddress,
     SIZE_T dwSize
    );



BOOL
__stdcall
VirtualUnlock(
     LPVOID lpAddress,
     SIZE_T dwSize
    );
]]

ffi.cdef[[
UINT
__stdcall
GetWriteWatch(
     DWORD dwFlags,
     PVOID lpBaseAddress,
     SIZE_T dwRegionSize,
    PVOID * lpAddresses,
    ULONG_PTR * lpdwCount,
    LPDWORD lpdwGranularity
    );



UINT
__stdcall
ResetWriteWatch(
     LPVOID lpBaseAddress,
     SIZE_T dwRegionSize
    );
]]


ffi.cdef[[
typedef enum _MEMORY_RESOURCE_NOTIFICATION_TYPE {
    LowMemoryResourceNotification,
    HighMemoryResourceNotification
} MEMORY_RESOURCE_NOTIFICATION_TYPE;


HANDLE
__stdcall
CreateMemoryResourceNotification(
     MEMORY_RESOURCE_NOTIFICATION_TYPE NotificationType
    );


BOOL
__stdcall
QueryMemoryResourceNotification(
     HANDLE ResourceNotificationHandle,
     PBOOL ResourceState
    );
]]

FILE_CACHE_FLAGS_DEFINED = true;
ffi.cdef[[

static const int FILE_CACHE_MAX_HARD_ENABLE     = 0x00000001;
static const int FILE_CACHE_MAX_HARD_DISABLE    = 0x00000002;
static const int FILE_CACHE_MIN_HARD_ENABLE     = 0x00000004;
static const int FILE_CACHE_MIN_HARD_DISABLE    = 0x00000008;
]]

ffi.cdef[[

BOOL
__stdcall
GetSystemFileCacheSize(
     PSIZE_T lpMinimumFileCacheSize,
     PSIZE_T lpMaximumFileCacheSize,
     PDWORD lpFlags
    );



BOOL
__stdcall
SetSystemFileCacheSize(
     SIZE_T MinimumFileCacheSize,
     SIZE_T MaximumFileCacheSize,
     DWORD Flags
    );
]]


ffi.cdef[[
HANDLE
__stdcall
CreateFileMappingNumaW(
     HANDLE hFile,
     LPSECURITY_ATTRIBUTES lpFileMappingAttributes,
     DWORD flProtect,
     DWORD dwMaximumSizeHigh,
     DWORD dwMaximumSizeLow,
     LPCWSTR lpName,
     DWORD nndPreferred
    );
]]

if UNICODE then
exports.CreateFileMappingNuma = ffi.C.CreateFileMappingNumaW;
end


ffi.cdef[[
typedef struct _WIN32_MEMORY_RANGE_ENTRY {
    PVOID VirtualAddress;
    SIZE_T NumberOfBytes;
} WIN32_MEMORY_RANGE_ENTRY, *PWIN32_MEMORY_RANGE_ENTRY;


BOOL
__stdcall
PrefetchVirtualMemory(
     HANDLE hProcess,
     ULONG_PTR NumberOfEntries,
    PWIN32_MEMORY_RANGE_ENTRY VirtualAddresses,
     ULONG Flags
    );
]]


ffi.cdef[[
HANDLE
__stdcall
CreateFileMappingFromApp(
     HANDLE hFile,
     PSECURITY_ATTRIBUTES SecurityAttributes,
     ULONG PageProtection,
     ULONG64 MaximumSize,
     PCWSTR Name
    );


PVOID
__stdcall
MapViewOfFileFromApp(
     HANDLE hFileMappingObject,
     ULONG DesiredAccess,
     ULONG64 FileOffset,
     SIZE_T NumberOfBytesToMap
    );



BOOL
__stdcall
UnmapViewOfFileEx(
     PVOID BaseAddress,
     ULONG UnmapFlags
    );
]]


ffi.cdef[[
BOOL
__stdcall
AllocateUserPhysicalPages(
     HANDLE hProcess,
    PULONG_PTR NumberOfPages,
    PULONG_PTR PageArray
    );


BOOL
__stdcall
FreeUserPhysicalPages(
     HANDLE hProcess,
    PULONG_PTR NumberOfPages,
    PULONG_PTR PageArray
    );

BOOL
__stdcall
MapUserPhysicalPages(
     PVOID VirtualAddress,
     ULONG_PTR NumberOfPages,
    PULONG_PTR PageArray
    );
]]

ffi.cdef[[
BOOL
__stdcall
AllocateUserPhysicalPagesNuma(
     HANDLE hProcess,
    PULONG_PTR NumberOfPages,
    PULONG_PTR PageArray,
     DWORD nndPreferred
    );


LPVOID
__stdcall
VirtualAllocExNuma(
     HANDLE hProcess,
     LPVOID lpAddress,
     SIZE_T dwSize,
     DWORD flAllocationType,
     DWORD flProtect,
     DWORD nndPreferred
    );
]]

ffi.cdef[[

BOOL
__stdcall
GetMemoryErrorHandlingCapabilities(
     PULONG Capabilities
    );



typedef void __stdcall BAD_MEMORY_CALLBACK_ROUTINE(void);

typedef BAD_MEMORY_CALLBACK_ROUTINE *PBAD_MEMORY_CALLBACK_ROUTINE;



PVOID
__stdcall
RegisterBadMemoryNotification(
     PBAD_MEMORY_CALLBACK_ROUTINE Callback
    );




BOOL
__stdcall
UnregisterBadMemoryNotification(
     PVOID RegistrationHandle
    );
]]

--[[
// This API is not actually available in all blue builds since it is part
// of the S14 GDR release, however because there is no new version for GDR
// this is the most accurate version available.  To safely use this API on
// BLUE builds callers will need to use LoadLibrary and GetProcAddress to 
// check for the existance of the API's before calling them.
--]]

ffi.cdef[[
typedef enum OFFER_PRIORITY {
    VmOfferPriorityVeryLow = 1,
    VmOfferPriorityLow,
    VmOfferPriorityBelowNormal,
    VmOfferPriorityNormal
} OFFER_PRIORITY;

DWORD
__stdcall
OfferVirtualMemory(
    PVOID VirtualAddress,
     SIZE_T Size,
     OFFER_PRIORITY Priority
    );


DWORD
__stdcall
ReclaimVirtualMemory(
    void const * VirtualAddress,
     SIZE_T Size
    );


DWORD
__stdcall
DiscardVirtualMemory(
    PVOID VirtualAddress,
     SIZE_T Size
    );
]]


ffi.cdef[[
static const int FILE_MAP_TARGETS_INVALID     =  0x40000000;


BOOL
__stdcall
SetProcessValidCallTargets(
     HANDLE hProcess,
     PVOID VirtualAddress,
     SIZE_T RegionSize,
     ULONG NumberOfOffsets,
    PCFG_CALL_TARGET_INFO OffsetInformation
    );
]]

ffi.cdef[[
PVOID
__stdcall
VirtualAllocFromApp(
     PVOID BaseAddress,
     SIZE_T Size,
     ULONG AllocationType,
     ULONG Protection
    );

BOOL
__stdcall
VirtualProtectFromApp(
     PVOID Address,
     SIZE_T Size,
     ULONG NewProtection,
     PULONG OldProtection
    );


HANDLE
__stdcall
OpenFileMappingFromApp(
     ULONG DesiredAccess,
     BOOL InheritHandle,
     PCWSTR Name
    );
]]


-- CreateFileMapping  CreateFileMappingW
--[[
FORCEINLINE
_Ret_maybenull_
HANDLE
__stdcall
CreateFileMappingW(
         HANDLE hFile,
     LPSECURITY_ATTRIBUTES lpFileMappingAttributes,
         DWORD flProtect,
         DWORD dwMaximumSizeHigh,
         DWORD dwMaximumSizeLow,
     LPCWSTR lpName
    )
{
    return CreateFileMappingFromApp (hFile,
                                     lpFileMappingAttributes,
                                     flProtect,
                                     (((ULONG64) dwMaximumSizeHigh) << 32) | dwMaximumSizeLow,
                                     lpName);
}

FORCEINLINE
_Ret_maybenull_  __out_data_source(FILE)
LPVOID
__stdcall
MapViewOfFile(
     HANDLE hFileMappingObject,
     DWORD dwDesiredAccess,
     DWORD dwFileOffsetHigh,
     DWORD dwFileOffsetLow,
     SIZE_T dwNumberOfBytesToMap
    )
{
    return MapViewOfFileFromApp (hFileMappingObject,
                                 dwDesiredAccess,
                                 (((ULONG64) dwFileOffsetHigh) << 32) | dwFileOffsetLow,
                                 dwNumberOfBytesToMap);
}
--]]



--[[

FORCEINLINE
_Ret_maybenull_ _Post_writable_byte_size_(dwSize)
LPVOID
__stdcall
VirtualAlloc(
     LPVOID lpAddress,
         SIZE_T dwSize,
         DWORD flAllocationType,
         DWORD flProtect
    )
{
    return VirtualAllocFromApp (lpAddress, dwSize, flAllocationType, flProtect);
}

FORCEINLINE
_Success_(return != FALSE)
BOOL
__stdcall
VirtualProtect(
      LPVOID lpAddress,
      SIZE_T dwSize,
      DWORD flNewProtect,
     PDWORD lpflOldProtect
    )
{
    return VirtualProtectFromApp (lpAddress, dwSize, flNewProtect, lpflOldProtect);
}

#define OpenFileMapping  OpenFileMappingW

FORCEINLINE
_Ret_maybenull_
HANDLE
__stdcall
OpenFileMappingW(
     DWORD dwDesiredAccess,
     BOOL bInheritHandle,
     LPCWSTR lpName
    )
{
    return OpenFileMappingFromApp (dwDesiredAccess, bInheritHandle, lpName);
}
--]]

ffi.cdef[[
typedef enum WIN32_MEMORY_INFORMATION_CLASS {
    MemoryRegionInfo
} WIN32_MEMORY_INFORMATION_CLASS;


typedef struct WIN32_MEMORY_REGION_INFORMATION {
    PVOID AllocationBase;
    ULONG AllocationProtect;

    union {
        ULONG Flags;

        struct {
            ULONG Private : 1;
            ULONG MappedDataFile : 1;
            ULONG MappedImage : 1;
            ULONG MappedPageFile : 1;
            ULONG MappedPhysical : 1;
            ULONG DirectMapped : 1;
            ULONG Reserved : 26;
        } ;
    } ;

    SIZE_T RegionSize;
    SIZE_T CommitSize;
} WIN32_MEMORY_REGION_INFORMATION;
]]



ffi.cdef[[
BOOL
__stdcall
QueryVirtualMemoryInformation(
     HANDLE Process,
     const VOID * VirtualAddress,
     WIN32_MEMORY_INFORMATION_CLASS MemoryInformationClass,
    PVOID MemoryInformation,
     SIZE_T MemoryInformationSize,
    PSIZE_T ReturnSize
    );
]]

return exports