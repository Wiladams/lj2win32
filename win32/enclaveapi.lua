
--* enclaveapi.h -- ApiSet Contract for api-ms-win-core-enclave-l1-1-0            *
local ffi = require("ffi")



if not _ENCLAVEAPI_H_ then
_ENCLAVEAPI_H_ = true

--#include <apiset.h>
--#include <apisetcconv.h>
require("win32.minwindef")
require("win32.minwinbase")
require("win32.winapifamily")


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM , WINAPI_PARTITION_APP) then


ffi.cdef[[
BOOL
__stdcall
IsEnclaveTypeSupported(
     DWORD flEnclaveType
    );





LPVOID
__stdcall
CreateEnclave(
     HANDLE hProcess,
     LPVOID lpAddress,
     SIZE_T dwSize,
     SIZE_T dwInitialCommitment,
     DWORD flEnclaveType,
     LPCVOID lpEnclaveInformation,
     DWORD dwInfoLength,
     LPDWORD lpEnclaveError
    );




BOOL
__stdcall
LoadEnclaveData(
     HANDLE hProcess,
     LPVOID lpAddress,
     LPCVOID lpBuffer,
     SIZE_T nSize,
     DWORD flProtect,
     LPCVOID lpPageInformation,
     DWORD dwInfoLength,
     PSIZE_T lpNumberOfBytesWritten,
     LPDWORD lpEnclaveError
    );




BOOL
__stdcall
InitializeEnclave(
     HANDLE hProcess,
     LPVOID lpAddress,
     LPCVOID lpEnclaveInformation,
     DWORD dwInfoLength,
     LPDWORD lpEnclaveError
    );
]]

end  --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM | WINAPI_PARTITION_APP) */




if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


ffi.cdef[[
BOOL
__stdcall
LoadEnclaveImageA(
     LPVOID lpEnclaveAddress,
     LPCSTR lpImageName
    );



BOOL
__stdcall
LoadEnclaveImageW(
     LPVOID lpEnclaveAddress,
     LPCWSTR lpImageName
    );
]]

--[[
#ifdef UNICODE
#define LoadEnclaveImage  LoadEnclaveImageW
#else
#define LoadEnclaveImage  LoadEnclaveImageA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
CallEnclave(
     LPENCLAVE_ROUTINE lpRoutine,
     LPVOID lpParameter,
     BOOL fWaitForThread,
     LPVOID* lpReturnValue
    );




BOOL
__stdcall
TerminateEnclave(
     LPVOID lpAddress,
     BOOL fWait
    );




BOOL
__stdcall
DeleteEnclave(
     LPVOID lpAddress
    );
]]

end  --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



end  --// _ENCLAVEAPI_H_

