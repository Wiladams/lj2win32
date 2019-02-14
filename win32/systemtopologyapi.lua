
-- ApiSet Contract for api-ms-win-core-systemtopology-l1

local ffi = require("ffi")

--#include <apiset.h>
--#include <apisetcconv.h>

require("win32.winapifamily")
require("win32.minwindef")
require("win32.minwinbase")



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
GetNumaHighestNodeNumber(
     PULONG HighestNodeNumber
    );
]]

if _WIN32_WINNT >= 0x0601 then

ffi.cdef[[
BOOL
__stdcall
GetNumaNodeProcessorMaskEx(
     USHORT Node,
     PGROUP_AFFINITY ProcessorMask
    );
]]

end -- (_WIN32_WINNT >=0x0601)

if _WIN32_WINNT >= 0x0601 then

ffi.cdef[[
BOOL
__stdcall
GetNumaProximityNodeEx(
     ULONG ProximityId,
     PUSHORT NodeNumber
    );
]]

end -- (_WIN32_WINNT >=0x0601)

end -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

