--[[
    errhandlingapi.h - ApiSet Contract for api-ms-win-core-errorhandling-l1

--]]
local ffi = require("ffi")

if not _ERRHANDLING_H_ then
_ERRHANDLING_H_ = true

--require("win32.apiset")
require("win32.minwindef")

ffi.cdef[[

typedef LONG (__stdcall *PTOP_LEVEL_EXCEPTION_FILTER)(struct _EXCEPTION_POINTERS *ExceptionInfo);
typedef PTOP_LEVEL_EXCEPTION_FILTER LPTOP_LEVEL_EXCEPTION_FILTER;
]]

ffi.cdef[[
void
__stdcall
RaiseException(
     DWORD dwExceptionCode,
     DWORD dwExceptionFlags,
     DWORD nNumberOfArguments,
    const ULONG_PTR* lpArguments
    );
]]


ffi.cdef[[
//__callback
LONG __stdcall UnhandledExceptionFilter(struct _EXCEPTION_POINTERS* ExceptionInfo);


LPTOP_LEVEL_EXCEPTION_FILTER
__stdcall
SetUnhandledExceptionFilter(LPTOP_LEVEL_EXCEPTION_FILTER lpTopLevelExceptionFilter);
]]

ffi.cdef[[
DWORD __stdcall GetLastError(void);

VOID
__stdcall
SetLastError(
     DWORD dwErrCode
    );
]]


ffi.cdef[[
UINT
__stdcall
GetErrorMode(
    VOID
    );

UINT
__stdcall
SetErrorMode(
     UINT uMode
    );
]]


ffi.cdef[[
PVOID
__stdcall
AddVectoredExceptionHandler(
     ULONG First,
     PVECTORED_EXCEPTION_HANDLER Handler
    );

ULONG
__stdcall
RemoveVectoredExceptionHandler(
     PVOID Handle
    );

PVOID
__stdcall
AddVectoredContinueHandler(
     ULONG First,
     PVECTORED_EXCEPTION_HANDLER Handler
    );

ULONG
__stdcall
RemoveVectoredContinueHandler(
     PVOID Handle
    );
]]

--// RC warns because "WINBASE_DECLARE_RESTORE_LAST_ERROR" is a bit long.
--#if !defined(RC_INVOKED)
--//#if _WIN32_WINNT >= 0x0501 || defined(WINBASE_DECLARE_RESTORE_LAST_ERROR)
--#if defined(WINBASE_DECLARE_RESTORE_LAST_ERROR)

ffi.cdef[[
VOID
__stdcall
RestoreLastError(
     DWORD dwErrCode
    );


typedef void (__stdcall* PRESTORE_LAST_ERROR)(DWORD);


]]
--[[
#define RESTORE_LAST_ERROR_NAME_A      "RestoreLastError"
#define RESTORE_LAST_ERROR_NAME_W     L"RestoreLastError"
#define RESTORE_LAST_ERROR_NAME   TEXT("RestoreLastError")
]]

--#endif 
--#endif


ffi.cdef[[
VOID
__stdcall
RaiseFailFastException(
    PEXCEPTION_RECORD pExceptionRecord,
    PCONTEXT pContextRecord,
     DWORD dwFlags
    );

VOID
__stdcall
FatalAppExitA(
     UINT uAction,
     LPCSTR lpMessageText
    );


VOID
__stdcall
FatalAppExitW(
     UINT uAction,
     LPCWSTR lpMessageText
    );
]]

--[[
#ifdef UNICODE
#define FatalAppExit  FatalAppExitW
#else
#define FatalAppExit  FatalAppExitA
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD
__stdcall
GetThreadErrorMode(
    VOID
    );

BOOL
__stdcall
SetThreadErrorMode(
     DWORD dwNewMode,
    LPDWORD lpOldMode
    );

void
__stdcall
TerminateProcessOnMemoryExhaustion(
     SIZE_T FailedAllocationSize
    );
]]

end -- _ERRHANDLING_H_
