
local ffi = require("ffi")

if not _NAMEDPIPE_H_ then
_NAMEDPIPE_H_ = true

--#include <apiset.h>
--#include <apisetcconv.h>
require ("win32.minwindef")
require ("win32.minwinbase")



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
CreatePipe(
     PHANDLE hReadPipe,
     PHANDLE hWritePipe,
     LPSECURITY_ATTRIBUTES lpPipeAttributes,
     DWORD nSize
    );

BOOL
__stdcall
ConnectNamedPipe(
     HANDLE hNamedPipe,
     LPOVERLAPPED lpOverlapped
    );

BOOL
__stdcall
DisconnectNamedPipe(
     HANDLE hNamedPipe
    );

BOOL
__stdcall
SetNamedPipeHandleState(
     HANDLE hNamedPipe,
     LPDWORD lpMode,
     LPDWORD lpMaxCollectionCount,
     LPDWORD lpCollectDataTimeout
    );

BOOL
__stdcall
PeekNamedPipe(
     HANDLE hNamedPipe,
     LPVOID lpBuffer,
     DWORD nBufferSize,
     LPDWORD lpBytesRead,
     LPDWORD lpTotalBytesAvail,
     LPDWORD lpBytesLeftThisMessage
    );

BOOL
__stdcall
TransactNamedPipe(
     HANDLE hNamedPipe,
     LPVOID lpInBuffer,
     DWORD nInBufferSize,
     LPVOID lpOutBuffer,
     DWORD nOutBufferSize,
     LPDWORD lpBytesRead,
     LPOVERLAPPED lpOverlapped
    );

HANDLE
__stdcall
CreateNamedPipeW(
     LPCWSTR lpName,
     DWORD dwOpenMode,
     DWORD dwPipeMode,
     DWORD nMaxInstances,
     DWORD nOutBufferSize,
     DWORD nInBufferSize,
     DWORD nDefaultTimeOut,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
]]

--[[
#ifdef UNICODE
#define CreateNamedPipe  CreateNamedPipeW
#endif
--]]

ffi.cdef[[
BOOL
__stdcall
WaitNamedPipeW(
     LPCWSTR lpNamedPipeName,
     DWORD nTimeOut
    );
]]

--[[
#ifdef UNICODE
#define WaitNamedPipe  WaitNamedPipeW
#endif
--]]

if (_WIN32_WINNT >= 0x0600) then

ffi.cdef[[
BOOL
__stdcall
GetNamedPipeClientComputerNameW(
     HANDLE Pipe,
     LPWSTR ClientComputerName,
     ULONG ClientComputerNameLength
    );
]]

end --// (_WIN32_WINNT >= 0x0600)

--[[
#ifdef UNICODE
#define GetNamedPipeClientComputerName  GetNamedPipeClientComputerNameW
#endif
--]]

ffi.cdef[[
BOOL
__stdcall
ImpersonateNamedPipeClient(
     HANDLE hNamedPipe
    );
]]                               

end --// WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
BOOL
__stdcall
GetNamedPipeInfo(
     HANDLE hNamedPipe,
     LPDWORD lpFlags,
     LPDWORD lpOutBufferSize,
     LPDWORD lpInBufferSize,
     LPDWORD lpMaxInstances
    );

BOOL
__stdcall
GetNamedPipeHandleStateW(
     HANDLE hNamedPipe,
     LPDWORD lpState,
     LPDWORD lpCurInstances,
     LPDWORD lpMaxCollectionCount,
     LPDWORD lpCollectDataTimeout,
     LPWSTR lpUserName,
     DWORD nMaxUserNameSize
    );
]]

--[[
#ifdef UNICODE
#define GetNamedPipeHandleState  GetNamedPipeHandleStateW
#endif
--]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
BOOL
__stdcall
CallNamedPipeW(
     LPCWSTR lpNamedPipeName,
     LPVOID lpInBuffer,
     DWORD nInBufferSize,
     LPVOID lpOutBuffer,
     DWORD nOutBufferSize,
     LPDWORD lpBytesRead,
     DWORD nTimeOut
    );
]]

--[[
#ifdef UNICODE
#define CallNamedPipe  CallNamedPipeW
#endif
--]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


end --// _NAMEDPIPE_H_
