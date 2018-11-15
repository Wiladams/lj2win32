--[[
    Depending on which version of windows you are using.
    These calls are either in the psapi.dll, or in kernel32


--]]

local ffi = require("ffi")

--require("win32.intsafe")
require("win32.minwindef")


ffi.cdef[[
static const int LIST_MODULES_DEFAULT = 0x00;  // This is the default one app would get without any flag.
static const int LIST_MODULES_32BIT   = 0x01;  // list 32bit modules in the target process.
static const int LIST_MODULES_64BIT   = 0x02;  // list all 64bit modules. 32bit exe will be stripped off.

// list all the modules
static const int LIST_MODULES_ALL  = (LIST_MODULES_32BIT | LIST_MODULES_64BIT);
]]

--[[
//
// Give teams a choice of using a downlevel version of psapi.h for an OS versions.
// Teams can set C_DEFINES=$(C_DEFINES) -DPSAPI_VERSION=1 for downlevel psapi
// on windows 7 and higher.  We found that test code needs this capability.
//
-- We're going to assume PSAPI_VERSION == 2
-- and ignore downlevel clients
#ifndef PSAPI_VERSION
#if (NTDDI_VERSION >= NTDDI_WIN7)
#define PSAPI_VERSION 2
#else
#define PSAPI_VERSION 1
#endif
#endif
--]]

--[[
#if (PSAPI_VERSION > 1)
#define EnumProcessModules          K32EnumProcessModules
#define EnumProcessModulesEx        K32EnumProcessModulesEx
#define GetModuleBaseNameA          K32GetModuleBaseNameA
#define GetModuleBaseNameW          K32GetModuleBaseNameW
#define GetModuleFileNameExA        K32GetModuleFileNameExA
#define GetModuleFileNameExW        K32GetModuleFileNameExW
#define EmptyWorkingSet             K32EmptyWorkingSet
#define QueryWorkingSet             K32QueryWorkingSet
#define QueryWorkingSetEx           K32QueryWorkingSetEx
#define InitializeProcessForWsWatch K32InitializeProcessForWsWatch
#define GetWsChanges                K32GetWsChanges
#define GetWsChangesEx              K32GetWsChangesEx
#define GetMappedFileNameW          K32GetMappedFileNameW
#define GetMappedFileNameA          K32GetMappedFileNameA
#define EnumDeviceDrivers           K32EnumDeviceDrivers
#define GetDeviceDriverBaseNameA    K32GetDeviceDriverBaseNameA
#define GetDeviceDriverBaseNameW    K32GetDeviceDriverBaseNameW
#define GetDeviceDriverFileNameA    K32GetDeviceDriverFileNameA
#define GetDeviceDriverFileNameW    K32GetDeviceDriverFileNameW
#define GetPerformanceInfo          K32GetPerformanceInfo
#define EnumPageFilesW              K32EnumPageFilesW
#define EnumPageFilesA              K32EnumPageFilesA
#define GetProcessImageFileNameA    K32GetProcessImageFileNameA
#define GetProcessImageFileNameW    K32GetProcessImageFileNameW
#endif



#if (PSAPI_VERSION > 1)

#define EnumProcesses               K32EnumProcesses
#define GetProcessMemoryInfo        K32GetProcessMemoryInfo
#define GetModuleInformation        K32GetModuleInformation
#define GetModuleBaseNameA          K32GetModuleBaseNameA
#define GetModuleBaseNameW          K32GetModuleBaseNameW
#define GetModuleFileNameExA        K32GetModuleFileNameExA
#define GetModuleFileNameExW        K32GetModuleFileNameExW
#endif
--]]


ffi.cdef[[
BOOL
WINAPI
K32EnumProcesses(
     DWORD* lpidProcess,
     DWORD cb,
     LPDWORD lpcbNeeded
    );
]]


ffi.cdef[[
BOOL
WINAPI
K32EnumProcessModules(
     HANDLE hProcess,
     HMODULE* lphModule,
     DWORD cb,
     LPDWORD lpcbNeeded
    );


BOOL
WINAPI
K32EnumProcessModulesEx(
     HANDLE hProcess,
     HMODULE* lphModule,
     DWORD cb,
     LPDWORD lpcbNeeded,
     DWORD dwFilterFlag
    );
]]


ffi.cdef[[
DWORD
WINAPI
K32GetModuleBaseNameA(
     HANDLE hProcess,
     HMODULE hModule,
     LPSTR lpBaseName,
     DWORD nSize
    );

DWORD
WINAPI
K32GetModuleBaseNameW(
     HANDLE hProcess,
     HMODULE hModule,
     LPWSTR lpBaseName,
     DWORD nSize
    );
]]

--[[
#ifdef UNICODE
#define GetModuleBaseName  K32GetModuleBaseNameW
#else
#define GetModuleBaseName  K32GetModuleBaseNameA
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD
WINAPI
K32GetModuleFileNameExA(
     HANDLE hProcess,
     HMODULE hModule,
    
    
         LPSTR lpFilename,
     DWORD nSize
    );


DWORD
WINAPI
K32GetModuleFileNameExW(
     HANDLE hProcess,
     HMODULE hModule,
    
    
         LPWSTR lpFilename,
     DWORD nSize
    );
]]

--[[
#ifdef UNICODE
#define GetModuleFileNameEx  K32GetModuleFileNameExW
#else
#define GetModuleFileNameEx  K32GetModuleFileNameExA
#endif // !UNICODE
--]]

ffi.cdef[[
typedef struct _MODULEINFO {
    LPVOID lpBaseOfDll;
    DWORD SizeOfImage;
    LPVOID EntryPoint;
} MODULEINFO, *LPMODULEINFO;

BOOL
WINAPI
K32GetModuleInformation(
     HANDLE hProcess,
     HMODULE hModule,
     LPMODULEINFO lpmodinfo,
     DWORD cb
    );



BOOL
WINAPI
K32EmptyWorkingSet(
     HANDLE hProcess
    );
]]

//
// Working set information structures. All non-specified bits are reserved.
//

#if _MSC_VER >= 1200
#pragma warning(push)
#endif
#pragma warning(disable:4201)   // unnamed struct
#pragma warning(disable:4214)   // bit fields other than int

typedef union _PSAPI_WORKING_SET_BLOCK {
    ULONG_PTR Flags;
    struct {
        ULONG_PTR Protection : 5;
        ULONG_PTR ShareCount : 3;
        ULONG_PTR Shared : 1;
        ULONG_PTR Reserved : 3;
#if defined(_WIN64)
        ULONG_PTR VirtualPage : 52;
#else
        ULONG_PTR VirtualPage : 20;
#endif
    };
} PSAPI_WORKING_SET_BLOCK, *PPSAPI_WORKING_SET_BLOCK;

typedef struct _PSAPI_WORKING_SET_INFORMATION {
    ULONG_PTR NumberOfEntries;
    PSAPI_WORKING_SET_BLOCK WorkingSetInfo[1];
} PSAPI_WORKING_SET_INFORMATION, *PPSAPI_WORKING_SET_INFORMATION;

typedef union _PSAPI_WORKING_SET_EX_BLOCK {
    ULONG_PTR Flags;
    union {
        struct {
            ULONG_PTR Valid : 1;
            ULONG_PTR ShareCount : 3;
            ULONG_PTR Win32Protection : 11;
            ULONG_PTR Shared : 1;
            ULONG_PTR Node : 6;
            ULONG_PTR Locked : 1;
            ULONG_PTR LargePage : 1;
            ULONG_PTR Reserved : 7;
            ULONG_PTR Bad : 1;

#if defined(_WIN64)
            ULONG_PTR ReservedUlong : 32;
#endif
        };
        struct {
            ULONG_PTR Valid : 1;            // Valid = 0 in this format.
            ULONG_PTR Reserved0 : 14;
            ULONG_PTR Shared : 1;
            ULONG_PTR Reserved1 : 15;
            ULONG_PTR Bad : 1;

#if defined(_WIN64)
            ULONG_PTR ReservedUlong : 32;
#endif
        } Invalid;
    };
} PSAPI_WORKING_SET_EX_BLOCK, *PPSAPI_WORKING_SET_EX_BLOCK;

typedef struct _PSAPI_WORKING_SET_EX_INFORMATION {
    PVOID VirtualAddress;
    PSAPI_WORKING_SET_EX_BLOCK VirtualAttributes;
} PSAPI_WORKING_SET_EX_INFORMATION, *PPSAPI_WORKING_SET_EX_INFORMATION;

#if _MSC_VER >= 1200
#pragma warning(pop)
#else
#pragma warning(default:4214)
#pragma warning(default:4201)
#endif

ffi.cdef[[
BOOL
WINAPI
K32QueryWorkingSet(
     HANDLE hProcess,
     PVOID pv,
     DWORD cb
    );

BOOL
WINAPI
K32QueryWorkingSetEx(
     HANDLE hProcess,
     PVOID pv,
     DWORD cb
    );

BOOL
WINAPI
K32InitializeProcessForWsWatch(
     HANDLE hProcess
    );
]]


ffi.cdef[[
typedef struct _PSAPI_WS_WATCH_INFORMATION {
    LPVOID FaultingPc;
    LPVOID FaultingVa;
} PSAPI_WS_WATCH_INFORMATION, *PPSAPI_WS_WATCH_INFORMATION;

typedef struct _PSAPI_WS_WATCH_INFORMATION_EX {
    PSAPI_WS_WATCH_INFORMATION BasicInfo;
    ULONG_PTR FaultingThreadId;
    ULONG_PTR Flags;    // Reserved
} PSAPI_WS_WATCH_INFORMATION_EX, *PPSAPI_WS_WATCH_INFORMATION_EX;

BOOL
WINAPI
K32GetWsChanges(
     HANDLE hProcess,
     PPSAPI_WS_WATCH_INFORMATION lpWatchInfo,
     DWORD cb
    );

BOOL
WINAPI
K32GetWsChangesEx(
     HANDLE hProcess,
     PPSAPI_WS_WATCH_INFORMATION_EX lpWatchInfoEx,
     PDWORD cb
    );

DWORD
WINAPI
K32GetMappedFileNameW (
     HANDLE hProcess,
     LPVOID lpv,
     LPWSTR lpFilename,
     DWORD nSize
    );

DWORD
WINAPI
GetMappedFileNameA (
     HANDLE hProcess,
     LPVOID lpv,
     LPSTR lpFilename,
     DWORD nSize
    );
]]

--[[
#ifdef UNICODE
#define GetMappedFileName  K32GetMappedFileNameW
#else
#define GetMappedFileName  GetMappedFileNameA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
WINAPI
K32EnumDeviceDrivers (
     LPVOID *lpImageBase,
     DWORD cb,
     LPDWORD lpcbNeeded
    );


DWORD
WINAPI
K32GetDeviceDriverBaseNameA (
     LPVOID ImageBase,
     LPSTR lpFilename,
     DWORD nSize
    );

DWORD
WINAPI
K32GetDeviceDriverBaseNameW (
     LPVOID ImageBase,
     LPWSTR lpBaseName,
     DWORD nSize
    );
]]

--[[
#ifdef UNICODE
#define GetDeviceDriverBaseName  K32GetDeviceDriverBaseNameW
#else
#define GetDeviceDriverBaseName  K32GetDeviceDriverBaseNameA
#endif // !UNICODE
--]]

DWORD
WINAPI
K32GetDeviceDriverFileNameA (
     LPVOID ImageBase,
     LPSTR lpFilename,
     DWORD nSize
    );

DWORD
WINAPI
K32GetDeviceDriverFileNameW (
     LPVOID ImageBase,
     LPWSTR lpFilename,
     DWORD nSize
    );

--[[
#ifdef UNICODE
#define GetDeviceDriverFileName  K32GetDeviceDriverFileNameW
#else
#define GetDeviceDriverFileName  K32GetDeviceDriverFileNameA
#endif // !UNICODE
--]]


ffi.cdef[[
typedef struct _PROCESS_MEMORY_COUNTERS {
    DWORD cb;
    DWORD PageFaultCount;
    SIZE_T PeakWorkingSetSize;
    SIZE_T WorkingSetSize;
    SIZE_T QuotaPeakPagedPoolUsage;
    SIZE_T QuotaPagedPoolUsage;
    SIZE_T QuotaPeakNonPagedPoolUsage;
    SIZE_T QuotaNonPagedPoolUsage;
    SIZE_T PagefileUsage;
    SIZE_T PeakPagefileUsage;
} PROCESS_MEMORY_COUNTERS;
typedef PROCESS_MEMORY_COUNTERS *PPROCESS_MEMORY_COUNTERS;



typedef struct _PROCESS_MEMORY_COUNTERS_EX {
    DWORD cb;
    DWORD PageFaultCount;
    SIZE_T PeakWorkingSetSize;
    SIZE_T WorkingSetSize;
    SIZE_T QuotaPeakPagedPoolUsage;
    SIZE_T QuotaPagedPoolUsage;
    SIZE_T QuotaPeakNonPagedPoolUsage;
    SIZE_T QuotaNonPagedPoolUsage;
    SIZE_T PagefileUsage;
    SIZE_T PeakPagefileUsage;
    SIZE_T PrivateUsage;
} PROCESS_MEMORY_COUNTERS_EX;
typedef PROCESS_MEMORY_COUNTERS_EX *PPROCESS_MEMORY_COUNTERS_EX;


BOOL
WINAPI
K32GetProcessMemoryInfo(
    HANDLE Process,
    PPROCESS_MEMORY_COUNTERS ppsmemCounters,
    DWORD cb
    );



typedef struct _PERFORMANCE_INFORMATION {
    DWORD cb;
    SIZE_T CommitTotal;
    SIZE_T CommitLimit;
    SIZE_T CommitPeak;
    SIZE_T PhysicalTotal;
    SIZE_T PhysicalAvailable;
    SIZE_T SystemCache;
    SIZE_T KernelTotal;
    SIZE_T KernelPaged;
    SIZE_T KernelNonpaged;
    SIZE_T PageSize;
    DWORD HandleCount;
    DWORD ProcessCount;
    DWORD ThreadCount;
} PERFORMANCE_INFORMATION, *PPERFORMANCE_INFORMATION, PERFORMACE_INFORMATION, *PPERFORMACE_INFORMATION;

BOOL
WINAPI
K32GetPerformanceInfo (
    PPERFORMANCE_INFORMATION pPerformanceInformation,
    DWORD cb
    );

typedef struct _ENUM_PAGE_FILE_INFORMATION {
    DWORD cb;
    DWORD Reserved;
    SIZE_T TotalSize;
    SIZE_T TotalInUse;
    SIZE_T PeakUsage;
} ENUM_PAGE_FILE_INFORMATION, *PENUM_PAGE_FILE_INFORMATION;

typedef BOOL (__stdcall *PENUM_PAGE_FILE_CALLBACKW) (LPVOID pContext, PENUM_PAGE_FILE_INFORMATION pPageFileInfo, LPCWSTR lpFilename);

typedef BOOL (__stdcall *PENUM_PAGE_FILE_CALLBACKA) (LPVOID pContext, PENUM_PAGE_FILE_INFORMATION pPageFileInfo, LPCSTR lpFilename);

BOOL
WINAPI
K32EnumPageFilesW (
    PENUM_PAGE_FILE_CALLBACKW pCallBackRoutine,
    LPVOID pContext
    );

BOOL
WINAPI
K32EnumPageFilesA (
    PENUM_PAGE_FILE_CALLBACKA pCallBackRoutine,
    LPVOID pContext
    );
]]

--[[
#ifdef UNICODE
#define PENUM_PAGE_FILE_CALLBACK PENUM_PAGE_FILE_CALLBACKW
#define EnumPageFiles K32EnumPageFilesW
#else
#define PENUM_PAGE_FILE_CALLBACK PENUM_PAGE_FILE_CALLBACKA
#define EnumPageFiles K32EnumPageFilesA
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD
WINAPI
K32GetProcessImageFileNameA (
     HANDLE hProcess,
     LPSTR lpImageFileName,
     DWORD nSize
    );

DWORD
WINAPI
K32GetProcessImageFileNameW (
     HANDLE hProcess,
     LPWSTR lpImageFileName,
     DWORD nSize
    );
]]

--[[
#ifdef UNICODE
#define GetProcessImageFileName  K32GetProcessImageFileNameW
#else
#define GetProcessImageFileName  K32GetProcessImageFileNameA
#endif // !UNICODE
--]]


