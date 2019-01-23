
if not _APISETDEBUG_ then
_APISETDEBUG_ = true

local ffi = require("ffi")

--#include <apiset.h>
--#include <apisetcconv.h>
require("win32.minwindef")
require("win32.minwinbase")


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

if (_WIN32_WINNT >= 0x0400) or (_WIN32_WINDOWS > 0x0400) then
ffi.cdef[[
BOOL
__stdcall
IsDebuggerPresent(void);
]]
end

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
void
__stdcall
DebugBreak(void);

void
__stdcall
OutputDebugStringA(LPCSTR lpOutputString);

void
__stdcall
OutputDebugStringW(LPCWSTR lpOutputString);
]]

--[[
#ifdef UNICODE
#define OutputDebugString  OutputDebugStringW
#else
#define OutputDebugString  OutputDebugStringA
#endif // !UNICODE
--]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
BOOL
__stdcall
ContinueDebugEvent(
     DWORD dwProcessId,
     DWORD dwThreadId,
     DWORD dwContinueStatus
    );

BOOL
__stdcall
WaitForDebugEvent(
     LPDEBUG_EVENT lpDebugEvent,
     DWORD dwMilliseconds
    );

BOOL
__stdcall
DebugActiveProcess(
     DWORD dwProcessId
    );

BOOL
__stdcall
DebugActiveProcessStop(
     DWORD dwProcessId
    );
]]

if (_WIN32_WINNT >= 0x0501) then

ffi.cdef[[
BOOL
__stdcall
CheckRemoteDebuggerPresent(
     HANDLE hProcess,
     PBOOL pbDebuggerPresent
    );
]]

end --// (_WIN32_WINNT >= 0x0501)

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[

BOOL
__stdcall
WaitForDebugEventEx(
     LPDEBUG_EVENT lpDebugEvent,
     DWORD dwMilliseconds
    );
]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


end --// _APISETDEBUG_
