
local ffi = require("ffi")
local C = ffi.C 

if not _FIBERS_H_ then
_FIBERS_H_ = true

--#include <apiset.h>
--#include <apisetcconv.h>
require("win32.minwindef")



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

if (_WIN32_WINNT >= 0x0600) then

if not FLS_OUT_OF_INDEXES then
ffi.cdef[[
static const int FLS_OUT_OF_INDEXES = ((DWORD)0xFFFFFFFF);
]]
FLS_OUT_OF_INDEXES = C.FLS_OUT_OF_INDEXES
end

ffi.cdef[[
DWORD
__stdcall
FlsAlloc(
     PFLS_CALLBACK_FUNCTION lpCallback
    );



PVOID
__stdcall
FlsGetValue(
     DWORD dwFlsIndex
    );



BOOL
__stdcall
FlsSetValue(
     DWORD dwFlsIndex,
     PVOID lpFlsData
    );



BOOL
__stdcall
FlsFree(
     DWORD dwFlsIndex
    );
]]

end --// (_WIN32_WINNT >= 0x0600)

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

if (_WIN32_WINNT >= 0x0600) then
ffi.cdef[[

BOOL
__stdcall
IsThreadAFiber(
    void
    );
]]

end --// (_WIN32_WINNT >= 0x0600)

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */




end --// _FIBERS_H_
