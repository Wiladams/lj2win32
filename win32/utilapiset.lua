
--* UtilApiSet.h -- ApiSet Contract for api-ms-win-core-util-l1-1-0               *
local ffi = require("ffi")




--#include <apiset.h>
--#include <apisetcconv.h>
require("win32.minwindef")


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then


ffi.cdef[[
PVOID
__stdcall
EncodePointer(
     PVOID Ptr
    );




PVOID
__stdcall
DecodePointer(
     PVOID Ptr
    );
]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


ffi.cdef[[
PVOID
__stdcall
EncodeSystemPointer(
     PVOID Ptr
    );




PVOID
__stdcall
DecodeSystemPointer(
     PVOID Ptr
    );



HRESULT
__stdcall
EncodeRemotePointer(
     HANDLE ProcessHandle,
     PVOID Ptr,
     PVOID* EncodedPtr
    );



HRESULT
__stdcall
DecodeRemotePointer(
     HANDLE ProcessHandle,
     PVOID Ptr,
     PVOID* DecodedPtr
    );
]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_PC_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
Beep(
     DWORD dwFreq,
     DWORD dwDuration
    );
]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_PC_APP | WINAPI_PARTITION_SYSTEM) */

