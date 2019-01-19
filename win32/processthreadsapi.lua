--[[                                                                              *
 processthreadsapi.h -- ApiSet Contract for api-ms-win-core-processthreads-l1     *
--]]


local ffi = require("ffi")


require("win32.minwindef")
require("win32.minwinbase")


ffi.cdef[[
typedef struct _PROCESS_INFORMATION {
    HANDLE hProcess;
    HANDLE hThread;
    DWORD dwProcessId;
    DWORD dwThreadId;
} PROCESS_INFORMATION, *PPROCESS_INFORMATION, *LPPROCESS_INFORMATION;

typedef struct _STARTUPINFOA {
    DWORD   cb;
    LPSTR   lpReserved;
    LPSTR   lpDesktop;
    LPSTR   lpTitle;
    DWORD   dwX;
    DWORD   dwY;
    DWORD   dwXSize;
    DWORD   dwYSize;
    DWORD   dwXCountChars;
    DWORD   dwYCountChars;
    DWORD   dwFillAttribute;
    DWORD   dwFlags;
    WORD    wShowWindow;
    WORD    cbReserved2;
    LPBYTE  lpReserved2;
    HANDLE  hStdInput;
    HANDLE  hStdOutput;
    HANDLE  hStdError;
} STARTUPINFOA, *LPSTARTUPINFOA;
typedef struct _STARTUPINFOW {
    DWORD   cb;
    LPWSTR  lpReserved;
    LPWSTR  lpDesktop;
    LPWSTR  lpTitle;
    DWORD   dwX;
    DWORD   dwY;
    DWORD   dwXSize;
    DWORD   dwYSize;
    DWORD   dwXCountChars;
    DWORD   dwYCountChars;
    DWORD   dwFillAttribute;
    DWORD   dwFlags;
    WORD    wShowWindow;
    WORD    cbReserved2;
    LPBYTE  lpReserved2;
    HANDLE  hStdInput;
    HANDLE  hStdOutput;
    HANDLE  hStdError;
} STARTUPINFOW, *LPSTARTUPINFOW;
]]

--[[
#ifdef UNICODE
typedef STARTUPINFOW STARTUPINFO;
typedef LPSTARTUPINFOW LPSTARTUPINFO;
#else
typedef STARTUPINFOA STARTUPINFO;
typedef LPSTARTUPINFOA LPSTARTUPINFO;
#endif // UNICODE
--]]


ffi.cdef[[
DWORD
__stdcall
QueueUserAPC(
     PAPCFUNC pfnAPC,
     HANDLE hThread,
     ULONG_PTR dwData
    );



BOOL
__stdcall
GetProcessTimes(
     HANDLE hProcess,
     LPFILETIME lpCreationTime,
     LPFILETIME lpExitTime,
     LPFILETIME lpKernelTime,
     LPFILETIME lpUserTime
    );
]]

ffi.cdef[[

HANDLE
__stdcall
GetCurrentProcess(
    VOID
    );



DWORD
__stdcall
GetCurrentProcessId(
    VOID
    );
]]

ffi.cdef[[
void
__stdcall
ExitProcess(
     UINT uExitCode
    );

BOOL
__stdcall
TerminateProcess(
     HANDLE hProcess,
     UINT uExitCode
    );

BOOL
__stdcall
GetExitCodeProcess(
     HANDLE hProcess,
     LPDWORD lpExitCode
    );

BOOL
__stdcall
SwitchToThread(
    VOID
    );




HANDLE
__stdcall
CreateThread(
     LPSECURITY_ATTRIBUTES lpThreadAttributes,
     SIZE_T dwStackSize,
     LPTHREAD_START_ROUTINE lpStartAddress,
      LPVOID lpParameter,
     DWORD dwCreationFlags,
     LPDWORD lpThreadId
    );

HANDLE
__stdcall
CreateRemoteThread(
     HANDLE hProcess,
     LPSECURITY_ATTRIBUTES lpThreadAttributes,
     SIZE_T dwStackSize,
     LPTHREAD_START_ROUTINE lpStartAddress,
     LPVOID lpParameter,
     DWORD dwCreationFlags,
     LPDWORD lpThreadId
    );

HANDLE
__stdcall
GetCurrentThread(
    VOID
    );

DWORD
__stdcall
GetCurrentThreadId(
    VOID
    );

HANDLE
__stdcall
OpenThread(
     DWORD dwDesiredAccess,
     BOOL bInheritHandle,
     DWORD dwThreadId
    );

BOOL
__stdcall
SetThreadPriority(
     HANDLE hThread,
     int nPriority
    );



BOOL
__stdcall
SetThreadPriorityBoost(
     HANDLE hThread,
     BOOL bDisablePriorityBoost
    );



BOOL
__stdcall
GetThreadPriorityBoost(
     HANDLE hThread,
     PBOOL pDisablePriorityBoost
    );



int
__stdcall
GetThreadPriority(
     HANDLE hThread
    );


VOID
__stdcall
ExitThread(
     DWORD dwExitCode
    );



BOOL
__stdcall
TerminateThread(
     HANDLE hThread,
     DWORD dwExitCode
    );





BOOL
__stdcall
GetExitCodeThread(
     HANDLE hThread,
     LPDWORD lpExitCode
    );



DWORD
__stdcall
SuspendThread(
     HANDLE hThread
    );



DWORD
__stdcall
ResumeThread(
     HANDLE hThread
    );
]]


--#ifndef TLS_OUT_OF_INDEXES
ffi.cdef[[
static const int TLS_OUT_OF_INDEXES = ((DWORD)0xFFFFFFFF);
]]
--#endif

ffi.cdef[[
DWORD
__stdcall
TlsAlloc(
    VOID
    );



LPVOID
__stdcall
TlsGetValue(
     DWORD dwTlsIndex
    );



BOOL
__stdcall
TlsSetValue(
     DWORD dwTlsIndex,
     LPVOID lpTlsValue
    );



BOOL
__stdcall
TlsFree(
     DWORD dwTlsIndex
    );
]]

ffi.cdef[[
BOOL
__stdcall
CreateProcessA(
     LPCSTR lpApplicationName,
     LPSTR lpCommandLine,
     LPSECURITY_ATTRIBUTES lpProcessAttributes,
     LPSECURITY_ATTRIBUTES lpThreadAttributes,
     BOOL bInheritHandles,
     DWORD dwCreationFlags,
     LPVOID lpEnvironment,
     LPCSTR lpCurrentDirectory,
     LPSTARTUPINFOA lpStartupInfo,
     LPPROCESS_INFORMATION lpProcessInformation
    );


BOOL
__stdcall
CreateProcessW(
     LPCWSTR lpApplicationName,
     LPWSTR lpCommandLine,
     LPSECURITY_ATTRIBUTES lpProcessAttributes,
     LPSECURITY_ATTRIBUTES lpThreadAttributes,
     BOOL bInheritHandles,
     DWORD dwCreationFlags,
     LPVOID lpEnvironment,
     LPCWSTR lpCurrentDirectory,
     LPSTARTUPINFOW lpStartupInfo,
     LPPROCESS_INFORMATION lpProcessInformation
    );
]]

--[[
#ifdef UNICODE
#define CreateProcess  CreateProcessW
#else
#define CreateProcess  CreateProcessA
#endif // !UNICODE
--]]

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
SetProcessShutdownParameters(
     DWORD dwLevel,
     DWORD dwFlags
    );



DWORD
__stdcall
GetProcessVersion(
     DWORD ProcessId
    );



VOID
__stdcall
GetStartupInfoW(
     LPSTARTUPINFOW lpStartupInfo
    );
]]

--[[
#ifdef UNICODE
#define GetStartupInfo  GetStartupInfoW
#endif
--]]

ffi.cdef[[
BOOL
__stdcall
CreateProcessAsUserW(
     HANDLE hToken,
     LPCWSTR lpApplicationName,
     LPWSTR lpCommandLine,
     LPSECURITY_ATTRIBUTES lpProcessAttributes,
     LPSECURITY_ATTRIBUTES lpThreadAttributes,
     BOOL bInheritHandles,
     DWORD dwCreationFlags,
     LPVOID lpEnvironment,
     LPCWSTR lpCurrentDirectory,
     LPSTARTUPINFOW lpStartupInfo,
     LPPROCESS_INFORMATION lpProcessInformation
    );
]]

--[[
#ifdef UNICODE
#define CreateProcessAsUser  CreateProcessAsUserW
#endif
--]]


if (_WIN32_WINNT >= _WIN32_WINNT_WIN8) then
--[[
local function GetCurrentProcessToken (void)
{
    return (HANDLE)(LONG_PTR) -4;
}

local function GetCurrentThreadToken (void)
{
    return (HANDLE)(LONG_PTR) -5;
}

local function GetCurrentThreadEffectiveToken (void)
    return ffi.cast("HANDLE", ffi.cast("LONG_PTR", -6));
end
--]]
end --// (_WIN32_WINNT >= _WIN32_WINNT_WIN8)

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then


ffi.cdef[[
BOOL
SetThreadToken(
     PHANDLE Thread,
     HANDLE Token
    );



BOOL
__stdcall
OpenProcessToken(
     HANDLE ProcessHandle,
     DWORD DesiredAccess,
     PHANDLE TokenHandle
    );



BOOL
__stdcall
OpenThreadToken(
     HANDLE ThreadHandle,
     DWORD DesiredAccess,
     BOOL OpenAsSelf,
     PHANDLE TokenHandle
    );



BOOL
__stdcall
SetPriorityClass(
     HANDLE hProcess,
     DWORD dwPriorityClass
    );



DWORD
__stdcall
GetPriorityClass(
     HANDLE hProcess
    );
]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
SetThreadStackGuarantee(
     PULONG StackSizeInBytes
    );



BOOL
__stdcall
ProcessIdToSessionId(
     DWORD dwProcessId,
     DWORD* pSessionId
    );


typedef struct _PROC_THREAD_ATTRIBUTE_LIST *PPROC_THREAD_ATTRIBUTE_LIST, *LPPROC_THREAD_ATTRIBUTE_LIST;
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

if (_WIN32_WINNT >= 0x0501) then

ffi.cdef[[
DWORD
__stdcall
GetProcessId(
     HANDLE Process
    );
]]

end --// _WIN32_WINNT >= 0x0501

if (_WIN32_WINNT >= 0x0502) then

ffi.cdef[[
DWORD
__stdcall
GetThreadId(
     HANDLE Thread
    );
]]

end --// _WIN32_WINNT >= 0x0502

if (_WIN32_WINNT >= 0x0600) then

ffi.cdef[[
VOID
__stdcall
FlushProcessWriteBuffers(void);
]]

end --// _WIN32_WINNT >= 0x0600

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


if (_WIN32_WINNT >= 0x0600) then

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
DWORD
__stdcall
GetProcessIdOfThread(
     HANDLE Thread
    );

BOOL
__stdcall
InitializeProcThreadAttributeList(
     LPPROC_THREAD_ATTRIBUTE_LIST lpAttributeList,
     DWORD dwAttributeCount,
     DWORD dwFlags,
     PSIZE_T lpSize
    );

VOID
__stdcall
DeleteProcThreadAttributeList(
     LPPROC_THREAD_ATTRIBUTE_LIST lpAttributeList
    );
]]

ffi.cdef[[
static const int PROCESS_AFFINITY_ENABLE_AUTO_UPDATE = 0x00000001UL;
]]

ffi.cdef[[
BOOL
__stdcall
SetProcessAffinityUpdateMode(
     HANDLE hProcess,
     DWORD dwFlags
    );



BOOL
__stdcall
QueryProcessAffinityUpdateMode(
     HANDLE hProcess,
     LPDWORD lpdwFlags
    );
]]

ffi.cdef[[
static const int PROC_THREAD_ATTRIBUTE_REPLACE_VALUE   =  0x00000001;
]]

ffi.cdef[[
BOOL
__stdcall
UpdateProcThreadAttribute(
     LPPROC_THREAD_ATTRIBUTE_LIST lpAttributeList,
     DWORD dwFlags,
     DWORD_PTR Attribute,
     PVOID lpValue,
     SIZE_T cbSize,
     PVOID lpPreviousValue,
     PSIZE_T lpReturnSize
    );
]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


end --// (_WIN32_WINNT >= 0x0600)


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


ffi.cdef[[
HANDLE
__stdcall
CreateRemoteThreadEx(
     HANDLE hProcess,
     LPSECURITY_ATTRIBUTES lpThreadAttributes,
     SIZE_T dwStackSize,
     LPTHREAD_START_ROUTINE lpStartAddress,
     LPVOID lpParameter,
     DWORD dwCreationFlags,
     LPPROC_THREAD_ATTRIBUTE_LIST lpAttributeList,
     LPDWORD lpThreadId
    );
]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

if (_WIN32_WINNT >= 0x0602) then

ffi.cdef[[
void
__stdcall
GetCurrentThreadStackLimits(
     PULONG_PTR LowLimit,
     PULONG_PTR HighLimit
    );
]]

end

ffi.cdef[[
BOOL
__stdcall
GetThreadContext(
     HANDLE hThread,
     LPCONTEXT lpContext
    );
]]

if (_WIN32_WINNT >= 0x0602) then

ffi.cdef[[
BOOL
__stdcall
GetProcessMitigationPolicy(
     HANDLE hProcess,
     PROCESS_MITIGATION_POLICY MitigationPolicy,
     PVOID lpBuffer,
     SIZE_T dwLength
    );
]]

end

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
--]==]

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
SetThreadContext(
     HANDLE hThread,
     const CONTEXT* lpContext
    );
]]

if (_WIN32_WINNT >= 0x0602) then

ffi.cdef[[
BOOL
__stdcall
SetProcessMitigationPolicy(
     PROCESS_MITIGATION_POLICY MitigationPolicy,
     PVOID lpBuffer,
     SIZE_T dwLength
    );
]]

end

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


ffi.cdef[[
BOOL
__stdcall
FlushInstructionCache(
     HANDLE hProcess,
     LPCVOID lpBaseAddress,
     SIZE_T dwSize
    );



BOOL
__stdcall
GetThreadTimes(
     HANDLE hThread,
     LPFILETIME lpCreationTime,
     LPFILETIME lpExitTime,
     LPFILETIME lpKernelTime,
     LPFILETIME lpUserTime
    );
]]


ffi.cdef[[
HANDLE
__stdcall
OpenProcess(
     DWORD dwDesiredAccess,
     BOOL bInheritHandle,
     DWORD dwProcessId
    );

BOOL
__stdcall
IsProcessorFeaturePresent(
     DWORD ProcessorFeature
    );

BOOL
__stdcall
GetProcessHandleCount(
     HANDLE hProcess,
     PDWORD pdwHandleCount
    );
]]


ffi.cdef[[
DWORD
__stdcall
GetCurrentProcessorNumber(
    VOID
    );
]]



ffi.cdef[[
BOOL
__stdcall
SetThreadIdealProcessorEx(
     HANDLE hThread,
     PPROCESSOR_NUMBER lpIdealProcessor,
     PPROCESSOR_NUMBER lpPreviousIdealProcessor
    );


BOOL
__stdcall
GetThreadIdealProcessorEx(
     HANDLE hThread,
     PPROCESSOR_NUMBER lpIdealProcessor
    );



VOID
__stdcall
GetCurrentProcessorNumberEx(
     PPROCESSOR_NUMBER ProcNumber
    );
]]




ffi.cdef[[
BOOL
__stdcall
GetProcessPriorityBoost(
     HANDLE hProcess,
     PBOOL pDisablePriorityBoost
    );



BOOL
__stdcall
SetProcessPriorityBoost(
     HANDLE hProcess,
     BOOL bDisablePriorityBoost
    );
]]


ffi.cdef[[
BOOL
__stdcall
GetThreadIOPendingFlag(
     HANDLE hThread,
     PBOOL lpIOIsPending
    );



BOOL
__stdcall
GetSystemTimes(
     PFILETIME lpIdleTime,
     PFILETIME lpKernelTime,
     PFILETIME lpUserTime
    );
]]


ffi.cdef[[
//
// Thread information classes.
//

typedef enum _THREAD_INFORMATION_CLASS {
    ThreadMemoryPriority,
    ThreadAbsoluteCpuPriority,
    ThreadDynamicCodePolicy,
    ThreadPowerThrottling,
    ThreadInformationClassMax
} THREAD_INFORMATION_CLASS;
]]



ffi.cdef[[
typedef struct _MEMORY_PRIORITY_INFORMATION {
    ULONG MemoryPriority;
} MEMORY_PRIORITY_INFORMATION, *PMEMORY_PRIORITY_INFORMATION;
]]

ffi.cdef[[
BOOL
__stdcall
GetThreadInformation(
     HANDLE hThread,
     THREAD_INFORMATION_CLASS ThreadInformationClass,
     LPVOID ThreadInformation,
     DWORD ThreadInformationSize
    );



BOOL
__stdcall
SetThreadInformation(
     HANDLE hThread,
     THREAD_INFORMATION_CLASS ThreadInformationClass,
     LPVOID ThreadInformation,
     DWORD ThreadInformationSize
    );
]]

ffi.cdef[[
static const int THREAD_POWER_THROTTLING_CURRENT_VERSION = 1;
static const int THREAD_POWER_THROTTLING_EXECUTION_SPEED = 0x1;

static const int THREAD_POWER_THROTTLING_VALID_FLAGS = (THREAD_POWER_THROTTLING_EXECUTION_SPEED);
]]

ffi.cdef[[
typedef struct _THREAD_POWER_THROTTLING_STATE {
    ULONG Version;
    ULONG ControlMask;
    ULONG StateMask;
} THREAD_POWER_THROTTLING_STATE;
]]

ffi.cdef[[
BOOL
__stdcall
IsProcessCritical(
     HANDLE hProcess,
     PBOOL Critical
    );



BOOL
__stdcall
SetProtectedPolicy(
     LPCGUID PolicyGuid,
     ULONG_PTR PolicyValue,
     PULONG_PTR OldPolicyValue
    );



BOOL
__stdcall
QueryProtectedPolicy(
     LPCGUID PolicyGuid,
     PULONG_PTR PolicyValue
    );
]]

ffi.cdef[[
DWORD
__stdcall
SetThreadIdealProcessor(
     HANDLE hThread,
     DWORD dwIdealProcessor
    );
]]

ffi.cdef[[
typedef enum _PROCESS_INFORMATION_CLASS {
    ProcessMemoryPriority,
    ProcessMemoryExhaustionInfo,
    ProcessAppMemoryInfo,
    ProcessInPrivateInfo,
    ProcessPowerThrottling,
    ProcessReservedValue1,           // Used to be for ProcessActivityThrottlePolicyInfo
    ProcessTelemetryCoverageInfo,
    ProcessProtectionLevelInfo,
    ProcessInformationClassMax
} PROCESS_INFORMATION_CLASS;

typedef struct _APP_MEMORY_INFORMATION {
    ULONG64 AvailableCommit;
    ULONG64 PrivateCommitUsage;
    ULONG64 PeakPrivateCommitUsage;
    ULONG64 TotalCommitUsage;
} APP_MEMORY_INFORMATION, *PAPP_MEMORY_INFORMATION;
]]

ffi.cdef[[
//
// Constants and structures needed to enable the fail fast on commit failure
// feature.
//

static const int PME_CURRENT_VERSION = 1;

typedef enum _PROCESS_MEMORY_EXHAUSTION_TYPE {
    PMETypeFailFastOnCommitFailure,
    PMETypeMax
} PROCESS_MEMORY_EXHAUSTION_TYPE, *PPROCESS_MEMORY_EXHAUSTION_TYPE;

static const int PME_FAILFAST_ON_COMMIT_FAIL_DISABLE   = 0x0;
static const int PME_FAILFAST_ON_COMMIT_FAIL_ENABLE    = 0x1;
]]

ffi.cdef[[
typedef struct _PROCESS_MEMORY_EXHAUSTION_INFO {
    USHORT Version;
    USHORT Reserved;
    PROCESS_MEMORY_EXHAUSTION_TYPE Type;
    ULONG_PTR Value;
} PROCESS_MEMORY_EXHAUSTION_INFO, *PPROCESS_MEMORY_EXHAUSTION_INFO;

static const int PROCESS_POWER_THROTTLING_CURRENT_VERSION = 1;

static const int PROCESS_POWER_THROTTLING_EXECUTION_SPEED = 0x1;

static const int PROCESS_POWER_THROTTLING_VALID_FLAGS =(PROCESS_POWER_THROTTLING_EXECUTION_SPEED);
]]

ffi.cdef[[
typedef struct _PROCESS_POWER_THROTTLING_STATE {
    ULONG Version;
    ULONG ControlMask;
    ULONG StateMask;
} PROCESS_POWER_THROTTLING_STATE, *PPROCESS_POWER_THROTTLING_STATE;

typedef struct PROCESS_PROTECTION_LEVEL_INFORMATION {
    DWORD ProtectionLevel;
} PROCESS_PROTECTION_LEVEL_INFORMATION;
]]


ffi.cdef[[
BOOL
__stdcall
SetProcessInformation(
     HANDLE hProcess,
     PROCESS_INFORMATION_CLASS ProcessInformationClass,
     LPVOID ProcessInformation,
     DWORD ProcessInformationSize
    );



BOOL
__stdcall
GetProcessInformation(
     HANDLE hProcess,
     PROCESS_INFORMATION_CLASS ProcessInformationClass,
     LPVOID ProcessInformation,
     DWORD ProcessInformationSize
    );
]]

ffi.cdef[[
BOOL
__stdcall
GetSystemCpuSetInformation(
     PSYSTEM_CPU_SET_INFORMATION Information,
     ULONG BufferLength,
     PULONG ReturnedLength,
     HANDLE Process,
     ULONG Flags
    );



BOOL
__stdcall
GetProcessDefaultCpuSets(
     HANDLE Process,
     PULONG CpuSetIds,
     ULONG CpuSetIdCount,
     PULONG RequiredIdCount
    );



BOOL
__stdcall
SetProcessDefaultCpuSets(
     HANDLE Process,
    const ULONG* CpuSetIds,
     ULONG CpuSetIdCount
    );

BOOL
__stdcall
GetThreadSelectedCpuSets(
     HANDLE Thread,
     PULONG CpuSetIds,
     ULONG CpuSetIdCount,
     PULONG RequiredIdCount
    );

BOOL
__stdcall
SetThreadSelectedCpuSets(
     HANDLE Thread,
     const ULONG* CpuSetIds,
     ULONG CpuSetIdCount
    );

BOOL
__stdcall
CreateProcessAsUserA(
     HANDLE hToken,
     LPCSTR lpApplicationName,
     LPSTR lpCommandLine,
     LPSECURITY_ATTRIBUTES lpProcessAttributes,
     LPSECURITY_ATTRIBUTES lpThreadAttributes,
     BOOL bInheritHandles,
     DWORD dwCreationFlags,
     LPVOID lpEnvironment,
     LPCSTR lpCurrentDirectory,
     LPSTARTUPINFOA lpStartupInfo,
     LPPROCESS_INFORMATION lpProcessInformation
    );
]]

--[[
#ifndef UNICODE
#define CreateProcessAsUser  CreateProcessAsUserA
#endif
--]]

ffi.cdef[[
BOOL
__stdcall
GetProcessShutdownParameters(
     LPDWORD lpdwLevel,
     LPDWORD lpdwFlags
    );

HRESULT
__stdcall
SetThreadDescription(
     HANDLE hThread,
     PCWSTR lpThreadDescription
    );

HRESULT
__stdcall
GetThreadDescription(
     HANDLE hThread,
     PWSTR* ppszThreadDescription
    );
]]

