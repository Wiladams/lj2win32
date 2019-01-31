--
-- powerbase.h -- ApiSet Contract for api-ms-win-power-base-l1-1-0              
--
local ffi = require("ffi")
local C = ffi.C

--#ifndef _POWERBASE_H_
--#define _POWERBASE_H_

--#include <apiset.h>
--#include <apisetcconv.h>

--[[
#ifdef _CONTRACT_GEN
#include <nt.h>
#include <ntrtl.h>
#include <nturtl.h>
#include <minwindef.h>
#endif
--]]


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

if not _HPOWERNOTIFY_DEF_ then
_HPOWERNOTIFY_DEF_ = true
ffi.cdef[[
typedef PVOID HPOWERNOTIFY, *PHPOWERNOTIFY;
]]
end --// _HPOWERNOTIFY_DEF_

--#ifndef NT_SUCCESS
--#define NTSTATUS LONG
--#define _OVERRIDE_NTSTATUS_
--#endif
ffi.cdef[[
LONG
__stdcall
CallNtPowerInformation(
     POWER_INFORMATION_LEVEL InformationLevel,
     PVOID InputBuffer,
     ULONG InputBufferLength,
     PVOID OutputBuffer,
     ULONG OutputBufferLength
    );
]]

--#ifdef _OVERRIDE_NTSTATUS_
--#undef NTSTATUS
--#endif
ffi.cdef[[
BOOLEAN
__stdcall
GetPwrCapabilities(
     PSYSTEM_POWER_CAPABILITIES lpspc
    );
]]

if (NTDDI_VERSION >= NTDDI_WIN8) then
ffi.cdef[[
POWER_PLATFORM_ROLE
__stdcall
PowerDeterminePlatformRoleEx(
     ULONG Version
    );

DWORD
__stdcall
PowerRegisterSuspendResumeNotification(
     DWORD Flags,
     HANDLE Recipient,
     PHPOWERNOTIFY RegistrationHandle
    );

    DWORD
__stdcall
PowerUnregisterSuspendResumeNotification(
     HPOWERNOTIFY RegistrationHandle
    );
]]
end

end --// WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


--#endif // _POWERBASE_H_

