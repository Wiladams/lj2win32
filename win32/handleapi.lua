--[[
* handleapi.h -- ApiSet Contract for api-ms-win-core-handle-l1-1-0              *
--]]

local ffi = require("ffi")


if not _APISETHANDLE_ then
_APISETHANDLE_ = true


require("win32.minwindef")


ffi.cdef[[
//
// Constants
//
static const int INVALID_HANDLE_VALUE = ((HANDLE)(LONG_PTR)-1);


BOOL
__stdcall
CloseHandle(
      HANDLE hObject
    );



BOOL
__stdcall
DuplicateHandle(
     HANDLE hSourceProcessHandle,
     HANDLE hSourceHandle,
     HANDLE hTargetProcessHandle,
     LPHANDLE lpTargetHandle,
     DWORD dwDesiredAccess,
     BOOL bInheritHandle,
     DWORD dwOptions
    );



BOOL
__stdcall
CompareObjectHandles(
     HANDLE hFirstObjectHandle,
     HANDLE hSecondObjectHandle
    );
]]

ffi.cdef[[
BOOL
__stdcall
GetHandleInformation(
     HANDLE hObject,
     LPDWORD lpdwFlags
    );



BOOL
__stdcall
SetHandleInformation(
     HANDLE hObject,
     DWORD dwMask,
     DWORD dwFlags
    );
]]


end -- _APISETHANDLE_
