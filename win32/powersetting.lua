--[[
* powersetting.h -- ApiSet Contract for api-ms-win-power-setting-l1-1-0         *  
--]]

local ffi = require("ffi")


--#ifndef _POWERSETTING_H_
--#define _POWERSETTING_H_

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

if (NTDDI_VERSION >= NTDDI_VISTA) then
ffi.cdef[[
DWORD
__stdcall
PowerReadACValue(
     HKEY RootPowerKey,
     const GUID* SchemeGuid,
     const GUID* SubGroupOfPowerSettingsGuid,
     const GUID* PowerSettingGuid,
     PULONG Type,
    LPBYTE Buffer,
     LPDWORD BufferSize
    );

DWORD
__stdcall
PowerReadDCValue(
     HKEY RootPowerKey,
     const GUID* SchemeGuid,
     const GUID* SubGroupOfPowerSettingsGuid,
     const GUID* PowerSettingGuid,
     PULONG Type,
    PUCHAR Buffer,
     LPDWORD BufferSize
    );


DWORD
__stdcall
PowerWriteACValueIndex(
     HKEY RootPowerKey,
     const GUID* SchemeGuid,
     const GUID* SubGroupOfPowerSettingsGuid,
     const GUID* PowerSettingGuid,
     DWORD AcValueIndex
    );


DWORD
__stdcall
PowerWriteDCValueIndex(
     HKEY RootPowerKey,
     const GUID* SchemeGuid,
     const GUID* SubGroupOfPowerSettingsGuid,
     const GUID* PowerSettingGuid,
     DWORD DcValueIndex
    );



DWORD
__stdcall
PowerGetActiveScheme(
     HKEY UserRootPowerKey,
     GUID** ActivePolicyGuid
    );


DWORD
__stdcall
PowerSetActiveScheme(
     HKEY UserRootPowerKey,
     const GUID* SchemeGuid
    );
]]
end

if (NTDDI_VERSION >= NTDDI_WIN7) then
ffi.cdef[[
DWORD
__stdcall
PowerSettingRegisterNotification(
     LPCGUID SettingGuid,
     DWORD Flags,
     HANDLE Recipient,
     PHPOWERNOTIFY RegistrationHandle
    );



DWORD
__stdcall
PowerSettingUnregisterNotification(
     HPOWERNOTIFY RegistrationHandle
    );
]]
end

end --// WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


-- end --// _POWERSETTING_H_
