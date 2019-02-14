
-- securityappcontainer.h -- ApiSet Contract for api-ms-win-security-appcontainer-l1 *
local ffi = require("ffi")

--#include <apiset.h>
--#include <apisetcconv.h>

require("win32.winapifamily")
require("win32.minwindef")
require("win32.minwinbase")


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


if NTDDI_VERSION >= NTDDI_WIN8 then

ffi.cdef[[
BOOL
__stdcall
GetAppContainerNamedObjectPath(
     HANDLE Token,
     PSID AppContainerSid,
     ULONG ObjectPathLength,
     LPWSTR ObjectPath,
     PULONG ReturnLength
    );
]]

end

end -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


