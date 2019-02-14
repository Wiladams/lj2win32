
-- processtopologyapi.h -- ApiSet Contract for api-ms-win-core-processtopology-l1 *

local ffi = require("ffi")

--#include <apiset.h>
--#include <apisetcconv.h>
require("win32.minwindef")
require("win32.minwinbase")


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

if (_WIN32_WINNT >= 0x0601) then

ffi.cdef[[
BOOL
__stdcall
GetProcessGroupAffinity(
     HANDLE hProcess,
     PUSHORT GroupCount,
     PUSHORT GroupArray
    );
]]

end -- (_WIN32_WINNT >= 0x0601)

end -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

if (_WIN32_WINNT >= 0x0601) then
ffi.cdef[[

BOOL
__stdcall
GetThreadGroupAffinity(
     HANDLE hThread,
     PGROUP_AFFINITY GroupAffinity
    );



BOOL
__stdcall
SetThreadGroupAffinity(
     HANDLE hThread,
     const GROUP_AFFINITY* GroupAffinity,
     PGROUP_AFFINITY PreviousGroupAffinity
    );
]]

end -- (_WIN32_WINNT >= 0x0601)

end -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)



