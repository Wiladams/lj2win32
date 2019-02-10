--[[
* synchapi.h -- ApiSet Contract for api-ms-win-core-synch-l1                    *
--]]

local ffi = require("ffi")

require("win32.winapifamily")
require("win32.minwindef")
require("win32.minwinbase")

ffi.cdef[[
//
// Define the slim R/W lock.
//
//#define SRWLOCK_INIT RTL_SRWLOCK_INIT


typedef RTL_SRWLOCK SRWLOCK, *PSRWLOCK;
]]


ffi.cdef[[
VOID
__stdcall
InitializeSRWLock(
     PSRWLOCK SRWLock
    );

VOID
__stdcall
ReleaseSRWLockExclusive(
     PSRWLOCK SRWLock
    );

VOID
__stdcall
ReleaseSRWLockShared(
     PSRWLOCK SRWLock
    );

VOID
__stdcall
AcquireSRWLockExclusive(
     PSRWLOCK SRWLock
    );

VOID
__stdcall
AcquireSRWLockShared(
     PSRWLOCK SRWLock
    );

BOOLEAN
__stdcall
TryAcquireSRWLockExclusive(
     PSRWLOCK SRWLock
    );

BOOLEAN
__stdcall
TryAcquireSRWLockShared(
     PSRWLOCK SRWLock
    );

VOID
__stdcall
InitializeCriticalSection(
     LPCRITICAL_SECTION lpCriticalSection
    );

VOID
__stdcall
EnterCriticalSection(
     LPCRITICAL_SECTION lpCriticalSection
    );

VOID
__stdcall
LeaveCriticalSection(
     LPCRITICAL_SECTION lpCriticalSection
    );

BOOL
__stdcall
InitializeCriticalSectionAndSpinCount(
     LPCRITICAL_SECTION lpCriticalSection,
     DWORD dwSpinCount
    );

BOOL
__stdcall
InitializeCriticalSectionEx(
     LPCRITICAL_SECTION lpCriticalSection,
     DWORD dwSpinCount,
     DWORD Flags
    );

DWORD
__stdcall
SetCriticalSectionSpinCount(
     LPCRITICAL_SECTION lpCriticalSection,
     DWORD dwSpinCount
    );

BOOL
__stdcall
TryEnterCriticalSection(
     LPCRITICAL_SECTION lpCriticalSection
    );

VOID
__stdcall
DeleteCriticalSection(
     LPCRITICAL_SECTION lpCriticalSection
    );
]]

ffi.cdef[[
//
// Define one-time initialization primitive
//

typedef RTL_RUN_ONCE INIT_ONCE;
typedef PRTL_RUN_ONCE PINIT_ONCE;
typedef PRTL_RUN_ONCE LPINIT_ONCE;
]]

--#define INIT_ONCE_STATIC_INIT   RTL_RUN_ONCE_INIT

ffi.cdef[[
//
// Run once flags
//

static const int INIT_ONCE_CHECK_ONLY      =  RTL_RUN_ONCE_CHECK_ONLY;
static const int INIT_ONCE_ASYNC           =  RTL_RUN_ONCE_ASYNC;
static const int INIT_ONCE_INIT_FAILED     =  RTL_RUN_ONCE_INIT_FAILED;
]]

ffi.cdef[[
//
// The context stored in the run once structure must leave the following number
// of low order bits unused.
//

//static const int INIT_ONCE_CTXBITS = RTL_RUN_ONCE_CTXBITS;

typedef
BOOL
(__stdcall *PINIT_ONCE_FN) (
     PINIT_ONCE InitOnce,
     PVOID Parameter,
     PVOID *Context
    );
]]

if (_WIN32_WINNT >= 0x0600) then

ffi.cdef[[
VOID
__stdcall
InitOnceInitialize(
     PINIT_ONCE InitOnce
    );



BOOL
__stdcall
InitOnceExecuteOnce(
    PINIT_ONCE InitOnce,
    PINIT_ONCE_FN InitFn,
    PVOID Parameter,
    LPVOID* Context);

BOOL
__stdcall
InitOnceBeginInitialize(
     LPINIT_ONCE lpInitOnce,
     DWORD dwFlags,
     PBOOL fPending,
     LPVOID* lpContext
    );

BOOL
__stdcall
InitOnceComplete(
     LPINIT_ONCE lpInitOnce,
     DWORD dwFlags,
     LPVOID lpContext
    );
]]

end -- (_WIN32_WINNT >= 0x0600)


ffi.cdef[[
//
// Define condition variable
//

typedef RTL_CONDITION_VARIABLE CONDITION_VARIABLE, *PCONDITION_VARIABLE;

//
// Static initializer for the condition variable
//

//#define CONDITION_VARIABLE_INIT = RTL_CONDITION_VARIABLE_INIT;

//
// Flags for condition variables
//

static const int CONDITION_VARIABLE_LOCKMODE_SHARED = RTL_CONDITION_VARIABLE_LOCKMODE_SHARED;
]]

if (_WIN32_WINNT >= 0x0600) then

ffi.cdef[[
VOID
__stdcall
InitializeConditionVariable(
     PCONDITION_VARIABLE ConditionVariable
    );



VOID
__stdcall
WakeConditionVariable(
     PCONDITION_VARIABLE ConditionVariable
    );



VOID
__stdcall
WakeAllConditionVariable(
     PCONDITION_VARIABLE ConditionVariable
    );



BOOL
__stdcall
SleepConditionVariableCS(
     PCONDITION_VARIABLE ConditionVariable,
     PCRITICAL_SECTION CriticalSection,
     DWORD dwMilliseconds
    );



BOOL
__stdcall
SleepConditionVariableSRW(
     PCONDITION_VARIABLE ConditionVariable,
     PSRWLOCK SRWLock,
     DWORD dwMilliseconds,
     ULONG Flags
    );
]]

end --// (_WIN32_WINNT >= 0x0600)


ffi.cdef[[
BOOL
__stdcall
SetEvent(
     HANDLE hEvent
    );



BOOL
__stdcall
ResetEvent(
     HANDLE hEvent
    );



BOOL
__stdcall
ReleaseSemaphore(
     HANDLE hSemaphore,
     LONG lReleaseCount,
     LPLONG lpPreviousCount
    );



BOOL
__stdcall
ReleaseMutex(
     HANDLE hMutex
    );



DWORD
__stdcall
WaitForSingleObject(
     HANDLE hHandle,
     DWORD dwMilliseconds
    );



DWORD
__stdcall
SleepEx(
     DWORD dwMilliseconds,
     BOOL bAlertable
    );



DWORD
__stdcall
WaitForSingleObjectEx(
     HANDLE hHandle,
     DWORD dwMilliseconds,
     BOOL bAlertable
    );



DWORD
__stdcall
WaitForMultipleObjectsEx(
     DWORD nCount,
     const HANDLE* lpHandles,
     BOOL bWaitAll,
     DWORD dwMilliseconds,
     BOOL bAlertable
    );
]]

ffi.cdef[[
//
// Synchronization APIs
//

static const int MUTEX_MODIFY_STATE = MUTANT_QUERY_STATE;
static const int MUTEX_ALL_ACCESS   = MUTANT_ALL_ACCESS;
]]

ffi.cdef[[
HANDLE
__stdcall
CreateMutexA(
     LPSECURITY_ATTRIBUTES lpMutexAttributes,
     BOOL bInitialOwner,
     LPCSTR lpName
    );



HANDLE
__stdcall
CreateMutexW(
     LPSECURITY_ATTRIBUTES lpMutexAttributes,
     BOOL bInitialOwner,
     LPCWSTR lpName
    );
]]

--[[
#ifdef UNICODE
#define CreateMutex  CreateMutexW
#else
#define CreateMutex  CreateMutexA
#endif // !UNICODE
--]]

ffi.cdef[[
HANDLE
__stdcall
OpenMutexW(
     DWORD dwDesiredAccess,
     BOOL bInheritHandle,
     LPCWSTR lpName
    );
]]

--[[
#ifdef UNICODE
#define OpenMutex  OpenMutexW
#endif
--]]

ffi.cdef[[
HANDLE
__stdcall
CreateEventA(
     LPSECURITY_ATTRIBUTES lpEventAttributes,
     BOOL bManualReset,
     BOOL bInitialState,
     LPCSTR lpName
    );



HANDLE
__stdcall
CreateEventW(
     LPSECURITY_ATTRIBUTES lpEventAttributes,
     BOOL bManualReset,
     BOOL bInitialState,
     LPCWSTR lpName
    );
]]

--[[
#ifdef UNICODE
#define CreateEvent  CreateEventW
#else
#define CreateEvent  CreateEventA
#endif // !UNICODE
--]]

ffi.cdef[[
HANDLE
__stdcall
OpenEventA(
     DWORD dwDesiredAccess,
     BOOL bInheritHandle,
     LPCSTR lpName
    );



HANDLE
__stdcall
OpenEventW(
     DWORD dwDesiredAccess,
     BOOL bInheritHandle,
     LPCWSTR lpName
    );
]]

--[[
#ifdef UNICODE
#define OpenEvent  OpenEventW
#else
#define OpenEvent  OpenEventA
#endif // !UNICODE
--]]

ffi.cdef[[
HANDLE
__stdcall
OpenSemaphoreW(
     DWORD dwDesiredAccess,
     BOOL bInheritHandle,
     LPCWSTR lpName
    );
]]

--[[
#ifdef UNICODE
#define OpenSemaphore  OpenSemaphoreW
#endif
--]]


--if (_WIN32_WINNT >= 0x0400) or (_WIN32_WINDOWS > 0x0400) then
ffi.cdef[[
typedef
VOID
(__stdcall *PTIMERAPCROUTINE)(
     LPVOID lpArgToCompletionRoutine,
         DWORD dwTimerLowValue,
         DWORD dwTimerHighValue
    );



HANDLE
__stdcall
OpenWaitableTimerW(
     DWORD dwDesiredAccess,
     BOOL bInheritHandle,
     LPCWSTR lpTimerName
    );
]]

--[[
#ifdef UNICODE
#define OpenWaitableTimer  OpenWaitableTimerW
#endif
--]]

if (_WIN32_WINNT >= _WIN32_WINNT_WIN7) then
ffi.cdef[[
BOOL
__stdcall
SetWaitableTimerEx(
     HANDLE hTimer,
     const LARGE_INTEGER* lpDueTime,
     LONG lPeriod,
     PTIMERAPCROUTINE pfnCompletionRoutine,
     LPVOID lpArgToCompletionRoutine,
     PREASON_CONTEXT WakeContext,
     ULONG TolerableDelay
    );
]]

end -- (_WIN32_WINNT >= _WIN32_WINNT_WIN7)

ffi.cdef[[
BOOL
__stdcall
SetWaitableTimer(
     HANDLE hTimer,
     const LARGE_INTEGER* lpDueTime,
     LONG lPeriod,
     PTIMERAPCROUTINE pfnCompletionRoutine,
     LPVOID lpArgToCompletionRoutine,
     BOOL fResume
    );



BOOL
__stdcall
CancelWaitableTimer(
     HANDLE hTimer
    );
]]

if (_WIN32_WINNT >= 0x0600) then
ffi.cdef[[
static const int CREATE_MUTEX_INITIAL_OWNER  = 0x00000001;



HANDLE
__stdcall
CreateMutexExA(
     LPSECURITY_ATTRIBUTES lpMutexAttributes,
     LPCSTR lpName,
     DWORD dwFlags,
     DWORD dwDesiredAccess
    );



HANDLE
__stdcall
CreateMutexExW(
     LPSECURITY_ATTRIBUTES lpMutexAttributes,
     LPCWSTR lpName,
     DWORD dwFlags,
     DWORD dwDesiredAccess
    );
]]

--[[
#ifdef UNICODE
#define CreateMutexEx  CreateMutexExW
#else
#define CreateMutexEx  CreateMutexExA
#endif // !UNICODE
--]]

ffi.cdef[[
static const int CREATE_EVENT_MANUAL_RESET =  0x00000001;
static const int CREATE_EVENT_INITIAL_SET  =  0x00000002;



HANDLE
__stdcall
CreateEventExA(
     LPSECURITY_ATTRIBUTES lpEventAttributes,
     LPCSTR lpName,
     DWORD dwFlags,
     DWORD dwDesiredAccess
    );



HANDLE
__stdcall
CreateEventExW(
     LPSECURITY_ATTRIBUTES lpEventAttributes,
     LPCWSTR lpName,
     DWORD dwFlags,
     DWORD dwDesiredAccess
    );
]]

--[[
#ifdef UNICODE
#define CreateEventEx  CreateEventExW
#else
#define CreateEventEx  CreateEventExA
#endif // !UNICODE
--]]

ffi.cdef[[
HANDLE
__stdcall
CreateSemaphoreExW(
     LPSECURITY_ATTRIBUTES lpSemaphoreAttributes,
     LONG lInitialCount,
     LONG lMaximumCount,
     LPCWSTR lpName,
     DWORD dwFlags,
     DWORD dwDesiredAccess
    );
]]

--[[
#ifdef UNICODE
#define CreateSemaphoreEx  CreateSemaphoreExW
#endif
--]]

ffi.cdef[[
static const int  CREATE_WAITABLE_TIMER_MANUAL_RESET = 0x00000001;
]]

--if (_WIN32_WINNT >= _NT_TARGET_VERSION_WIN10_RS4) then
ffi.cdef[[
static const int CREATE_WAITABLE_TIMER_HIGH_RESOLUTION = 0x00000002;
]]
--end


ffi.cdef[[
HANDLE
__stdcall
CreateWaitableTimerExW(
     LPSECURITY_ATTRIBUTES lpTimerAttributes,
     LPCWSTR lpTimerName,
     DWORD dwFlags,
     DWORD dwDesiredAccess
    );
]]

--[[
#ifdef UNICODE
#define CreateWaitableTimerEx  CreateWaitableTimerExW
#endif
--]]
end -- (_WIN32_WINNT >= 0x0600)

--end -- (_WIN32_WINNT >= 0x0400) || (_WIN32_WINDOWS > 0x0400)

--end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



--if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
typedef RTL_BARRIER SYNCHRONIZATION_BARRIER;
typedef PRTL_BARRIER PSYNCHRONIZATION_BARRIER;
typedef PRTL_BARRIER LPSYNCHRONIZATION_BARRIER;
]]

ffi.cdef[[
static const int SYNCHRONIZATION_BARRIER_FLAGS_SPIN_ONLY  = 0x01;
static const int SYNCHRONIZATION_BARRIER_FLAGS_BLOCK_ONLY = 0x02;
static const int SYNCHRONIZATION_BARRIER_FLAGS_NO_DELETE  = 0x04;

BOOL
__stdcall
EnterSynchronizationBarrier(
     LPSYNCHRONIZATION_BARRIER lpBarrier,
     DWORD dwFlags
    );


BOOL
__stdcall
InitializeSynchronizationBarrier(
     LPSYNCHRONIZATION_BARRIER lpBarrier,
     LONG lTotalThreads,
     LONG lSpinCount
    );


BOOL
__stdcall
DeleteSynchronizationBarrier(
     LPSYNCHRONIZATION_BARRIER lpBarrier
    );
]]

ffi.cdef[[
VOID
__stdcall
Sleep(
     DWORD dwMilliseconds
    );


BOOL
__stdcall
WaitOnAddress(
     volatile VOID* Address,
     PVOID CompareAddress,
     SIZE_T AddressSize,
     DWORD dwMilliseconds
    );


VOID
__stdcall
WakeByAddressSingle(
     PVOID Address
    );


VOID
__stdcall
WakeByAddressAll(
     PVOID Address
    );
]]


ffi.cdef[[
DWORD
__stdcall
SignalObjectAndWait(
     HANDLE hObjectToSignal,
     HANDLE hObjectToWaitOn,
     DWORD dwMilliseconds,
     BOOL bAlertable
    );
]]

ffi.cdef[[
DWORD
__stdcall
WaitForMultipleObjects(
     DWORD nCount,
     const HANDLE* lpHandles,
     BOOL bWaitAll,
     DWORD dwMilliseconds
    );



HANDLE
__stdcall
CreateSemaphoreW(
     LPSECURITY_ATTRIBUTES lpSemaphoreAttributes,
     LONG lInitialCount,
     LONG lMaximumCount,
     LPCWSTR lpName
    );
]]

--[[
#ifdef UNICODE
#define CreateSemaphore  CreateSemaphoreW
#endif
--]]

ffi.cdef[[
HANDLE
__stdcall
CreateWaitableTimerW(
     LPSECURITY_ATTRIBUTES lpTimerAttributes,
     BOOL bManualReset,
     LPCWSTR lpTimerName
    );
]]

--[[
#ifdef UNICODE
#define CreateWaitableTimer  CreateWaitableTimerW
#endif
--]]

