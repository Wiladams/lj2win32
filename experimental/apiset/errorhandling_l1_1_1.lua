-- core_errorhandling_l1_1_1.lua	
-- api-ms-win-core-errorhandling-l1-1-1.dll	

local ffi = require("ffi");


local WTypes = require ("win32.wtypes");
local WinNT = require("win32.winnt");


ffi.cdef[[
static const int SEM_FAILCRITICALERRORS      =0x0001;
static const int SEM_NOGPFAULTERRORBOX       =0x0002;
static const int SEM_NOALIGNMENTFAULTEXCEPT  =0x0004;
static const int SEM_NOOPENFILEERRORBOX      =0x8000;
]]

ffi.cdef[[
typedef LONG (* PTOP_LEVEL_EXCEPTION_FILTER)(struct _EXCEPTION_POINTERS *ExceptionInfo);
typedef PTOP_LEVEL_EXCEPTION_FILTER LPTOP_LEVEL_EXCEPTION_FILTER;
]]

ffi.cdef[[
PVOID
AddVectoredContinueHandler (ULONG First, PVECTORED_EXCEPTION_HANDLER Handler);

PVOID
AddVectoredExceptionHandler (ULONG First, PVECTORED_EXCEPTION_HANDLER Handler);

UINT
GetErrorMode(void);

DWORD 
GetLastError(void);

void
RaiseException(
    DWORD dwExceptionCode,
    DWORD dwExceptionFlags,
    DWORD nNumberOfArguments,
    const ULONG_PTR *lpArguments);

ULONG
RemoveVectoredContinueHandler (PVOID Handle);

ULONG
RemoveVectoredExceptionHandler (PVOID Handle);

void
RestoreLastError(DWORD dwErrCode);

UINT
SetErrorMode(UINT uMode);

void
SetLastError(DWORD dwErrCode);

LPTOP_LEVEL_EXCEPTION_FILTER
SetUnhandledExceptionFilter(LPTOP_LEVEL_EXCEPTION_FILTER lpTopLevelExceptionFilter);

LONG
UnhandledExceptionFilter(struct _EXCEPTION_POINTERS *ExceptionInfo);

]]

ffi.cdef[[
static const int ERROR_ALREADY_EXISTS = 183;

static const int ERROR_IO_PENDING 	= 0x03E5;	// 997
static const int ERROR_NOACCESS 	= 0x03E6;	// 998
static const int ERROR_SWAPERROR 	= 0x03E7;	// 999
]]

--local k32Lib = ffi.load("kernel32");
local Lib = ffi.load("api-ms-win-core-errorhandling-l1-1-1");

return {
	Lib = Lib,
	
	AddVectoredContinueHandler = Lib.AddVectoredContinueHandler,
	AddVectoredExceptionHandler = Lib.AddVectoredExceptionHandler,
	GetErrorMode = Lib.GetErrorMode,
	GetLastError = Lib.GetLastError,
	RaiseException = Lib.RaiseException,
	RemoveVectoredContinueHandler = Lib.RemoveVectoredContinueHandler,
	RemoveVectoredExceptionHandler = Lib.RemoveVectoredExceptionHandler,
	RestoreLastError = Lib.RestoreLastError,
	SetErrorMode = Lib.SetErrorMode,
	SetLastError = Lib.SetLastError,
	SetUnhandledExceptionFilter = Lib.SetUnhandledExceptionFilter,
	UnhandledExceptionFilter = Lib.UnhandledExceptionFilter,
}
