
local ffi = require("ffi");

require("win32.wtypes");

ffi.cdef[[
BOOL CloseHandle(HANDLE hObject);

BOOL DuplicateHandle(
    HANDLE hSourceProcessHandle,
    HANDLE hSourceHandle,
    HANDLE hTargetProcessHandle,
    LPHANDLE lpTargetHandle,
    DWORD dwDesiredAccess,
    BOOL bInheritHandle,
    DWORD dwOptions);

BOOL GetHandleInformation(HANDLE hObject, LPDWORD lpdwFlags);

BOOL SetHandleInformation(HANDLE hObject, DWORD dwMask, DWORD dwFlags);

static const int HANDLE_FLAG_INHERIT            = 0x00000001;
static const int HANDLE_FLAG_PROTECT_FROM_CLOSE = 0x00000002;
]]

local Lib = ffi.load("api-ms-win-core-handle-l1-1-0.dll")

return {
    Lib = Lib;

    CloseHandle = Lib.CloseHandle;
    DuplicateHandle = Lib.DuplicateHandle;
    GetHandleInformation = Lib.GetHandleInformation;
    SetHandleInformation = Lib.SetHandleInformation;
}