local ffi = require("ffi")
local C = ffi.C 

--#ifndef _POWRPROF_H_
--#define _POWRPROF_H_

require("win32.winapifamily")
require("win32.powerbase")
require("win32.powersetting")



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

ffi.cdef[[
// Registry storage structures for the GLOBAL_POWER_POLICY data. There are two
// structures, GLOBAL_MACHINE_POWER_POLICY and GLOBAL_USER_POWER_POLICY. the
// GLOBAL_MACHINE_POWER_POLICY stores per machine data for which there is no UI.
// GLOBAL_USER_POWER_POLICY stores the per user data.

typedef struct _GLOBAL_MACHINE_POWER_POLICY{
    ULONG                   Revision;
    SYSTEM_POWER_STATE      LidOpenWakeAc;
    SYSTEM_POWER_STATE      LidOpenWakeDc;
    ULONG                   BroadcastCapacityResolution;
} GLOBAL_MACHINE_POWER_POLICY, *PGLOBAL_MACHINE_POWER_POLICY;

typedef struct _GLOBAL_USER_POWER_POLICY{
    ULONG                   Revision;
    POWER_ACTION_POLICY     PowerButtonAc;
    POWER_ACTION_POLICY     PowerButtonDc;
    POWER_ACTION_POLICY     SleepButtonAc;
    POWER_ACTION_POLICY     SleepButtonDc;
    POWER_ACTION_POLICY     LidCloseAc;
    POWER_ACTION_POLICY     LidCloseDc;
    SYSTEM_POWER_LEVEL      DischargePolicy[NUM_DISCHARGE_POLICIES];
    ULONG                   GlobalFlags;
} GLOBAL_USER_POWER_POLICY, *PGLOBAL_USER_POWER_POLICY;
]]

ffi.cdef[[
// Structure to manage global power policies at the user level. This structure
// contains data which is common across all power policy profiles.

typedef struct _GLOBAL_POWER_POLICY{
    GLOBAL_USER_POWER_POLICY    user;
    GLOBAL_MACHINE_POWER_POLICY mach;
} GLOBAL_POWER_POLICY, *PGLOBAL_POWER_POLICY;
]]

ffi.cdef[[
// Registry storage structures for the POWER_POLICY data. There are three
// structures, MACHINE_POWER_POLICY, MACHINE_PROCESSOR_POWER_POLICY and
// USER_POWER_POLICY. the MACHINE_POWER_POLICY stores per machine data for
// which there is no UI.  USER_POWER_POLICY stores the per user data.

typedef struct _MACHINE_POWER_POLICY{
    ULONG                   Revision;       // 1

    // meaning of power action "sleep"
    SYSTEM_POWER_STATE      MinSleepAc;
    SYSTEM_POWER_STATE      MinSleepDc;
    SYSTEM_POWER_STATE      ReducedLatencySleepAc;
    SYSTEM_POWER_STATE      ReducedLatencySleepDc;

    // parameters for dozing
    ULONG                   DozeTimeoutAc;
    ULONG                   DozeTimeoutDc;
    ULONG                   DozeS4TimeoutAc;
    ULONG                   DozeS4TimeoutDc;

    // processor policies
    UCHAR                   MinThrottleAc;
    UCHAR                   MinThrottleDc;
    UCHAR                   pad1[2];
    POWER_ACTION_POLICY     OverThrottledAc;
    POWER_ACTION_POLICY     OverThrottledDc;

} MACHINE_POWER_POLICY, *PMACHINE_POWER_POLICY;
]]

ffi.cdef[[
//
// deprecated
//

typedef struct _MACHINE_PROCESSOR_POWER_POLICY {
    ULONG                   Revision;       // 1

    PROCESSOR_POWER_POLICY  ProcessorPolicyAc;
    PROCESSOR_POWER_POLICY  ProcessorPolicyDc;

} MACHINE_PROCESSOR_POWER_POLICY, *PMACHINE_PROCESSOR_POWER_POLICY;
]]

ffi.cdef[[
typedef struct _USER_POWER_POLICY {
    ULONG                   Revision;       // 1

    // "system idle" detection
    POWER_ACTION_POLICY     IdleAc;
    POWER_ACTION_POLICY     IdleDc;
    ULONG                   IdleTimeoutAc;
    ULONG                   IdleTimeoutDc;
    UCHAR                   IdleSensitivityAc;
    UCHAR                   IdleSensitivityDc;

    // Throttling Policy
    UCHAR                   ThrottlePolicyAc;
    UCHAR                   ThrottlePolicyDc;

    // meaning of power action "sleep"
    SYSTEM_POWER_STATE      MaxSleepAc;
    SYSTEM_POWER_STATE      MaxSleepDc;

    // For future use
    ULONG                   Reserved[2];

    // video policies
    ULONG                   VideoTimeoutAc;
    ULONG                   VideoTimeoutDc;

    // hard disk policies
    ULONG                   SpindownTimeoutAc;
    ULONG                   SpindownTimeoutDc;

    // processor policies
    BOOLEAN                 OptimizeForPowerAc;
    BOOLEAN                 OptimizeForPowerDc;
    UCHAR                   FanThrottleToleranceAc;
    UCHAR                   FanThrottleToleranceDc;
    UCHAR                   ForcedThrottleAc;
    UCHAR                   ForcedThrottleDc;

} USER_POWER_POLICY, *PUSER_POWER_POLICY;
]]

ffi.cdef[[
// Structure to manage power policies at the user level. This structure
// contains data which is unique across power policy profiles.

typedef struct _POWER_POLICY {
    USER_POWER_POLICY       user;
    MACHINE_POWER_POLICY    mach;
} POWER_POLICY, *PPOWER_POLICY;
]]

ffi.cdef[[
// Constants for GlobalFlags

static const int EnableSysTrayBatteryMeter  = 0x01;
static const int EnableMultiBatteryDisplay  = 0x02;
static const int EnablePasswordLogon        = 0x04;
static const int EnableWakeOnRing           = 0x08;
static const int EnableVideoDimDisplay      = 0x10;
]]

ffi.cdef[[
//
// Power setting attribute flags
//

static const int POWER_ATTRIBUTE_HIDE       = 0x00000001;
static const int POWER_ATTRIBUTE_SHOW_AOAC  = 0x00000002;

// This constant is passed as a uiID to WritePwrScheme.
static const int NEWSCHEME = (UINT)-1;
]]

ffi.cdef[[
// Prototype for EnumPwrSchemes callback proceedures.

typedef
BOOLEAN
__stdcall
PWRSCHEMESENUMPROC_V1 (
     UINT Index,
     DWORD NameSize,
     LPTSTR Name,
     DWORD DescriptionSize,
     LPTSTR Description,
     PPOWER_POLICY Policy,
     LPARAM Context
    );

typedef
BOOLEAN
__stdcall
PWRSCHEMESENUMPROC_V2 (
     UINT Index,
     DWORD NameSize,
     LPWSTR Name,
     DWORD DescriptionSize,
     LPWSTR Description,
     PPOWER_POLICY Policy,
     LPARAM Context
    );
]]

if (NTDDI_VERSION >= NTDDI_VISTA) then
ffi.cdef[[
typedef PWRSCHEMESENUMPROC_V2 *PWRSCHEMESENUMPROC;
]]
else
ffi.cdef[[
typedef PWRSCHEMESENUMPROC_V1 *PWRSCHEMESENUMPROC;
]]
end

ffi.cdef[[
// Public function prototypes

BOOLEAN
GetPwrDiskSpindownRange(
     PUINT puiMax,
     PUINT puiMin
    );

BOOLEAN
EnumPwrSchemes(
     PWRSCHEMESENUMPROC lpfn,
     LPARAM lParam
    );

BOOLEAN
ReadGlobalPwrPolicy(
     PGLOBAL_POWER_POLICY pGlobalPowerPolicy
    );

BOOLEAN
ReadPwrScheme(
     UINT uiID,
     PPOWER_POLICY pPowerPolicy
    );

BOOLEAN
WritePwrScheme(
     PUINT puiID,
     LPCWSTR lpszSchemeName,
     LPCWSTR lpszDescription,
     PPOWER_POLICY lpScheme
    );

BOOLEAN
WriteGlobalPwrPolicy(
         PGLOBAL_POWER_POLICY pGlobalPowerPolicy
    );

BOOLEAN
DeletePwrScheme(
         UINT uiID
        );

BOOLEAN
GetActivePwrScheme(
         PUINT puiID
    );

BOOLEAN
SetActivePwrScheme(
     UINT uiID,
     PGLOBAL_POWER_POLICY pGlobalPowerPolicy,
     PPOWER_POLICY pPowerPolicy
    );

BOOLEAN
IsPwrSuspendAllowed(
        VOID
        );

BOOLEAN
IsPwrHibernateAllowed(
        VOID
        );

BOOLEAN
IsPwrShutdownAllowed(
        VOID
        );

BOOLEAN
IsAdminOverrideActive(
     PADMINISTRATOR_POWER_POLICY papp
    );

BOOLEAN
SetSuspendState(
     BOOLEAN bHibernate,
     BOOLEAN bForce,
     BOOLEAN bWakeupEventsDisabled
    );

BOOLEAN
GetCurrentPowerPolicies(
     PGLOBAL_POWER_POLICY pGlobalPowerPolicy,
     PPOWER_POLICY pPowerPolicy
    );

BOOLEAN
CanUserWritePwrScheme(
        VOID
        );
]]

if (NTDDI_VERSION >= NTDDI_WINXP) then
ffi.cdef[[
//
// deprecated.
//
BOOLEAN
ReadProcessorPwrScheme(
     UINT uiID,
     PMACHINE_PROCESSOR_POWER_POLICY pMachineProcessorPowerPolicy
    );
]]
end

if (NTDDI_VERSION >= NTDDI_WINXP) then
ffi.cdef[[
//
// deprecated.
//
BOOLEAN
WriteProcessorPwrScheme(
     UINT uiID,
     PMACHINE_PROCESSOR_POWER_POLICY pMachineProcessorPowerPolicy
    );
]]
end

ffi.cdef[[
BOOLEAN
ValidatePowerPolicies(
     PGLOBAL_POWER_POLICY pGlobalPowerPolicy,
     PPOWER_POLICY pPowerPolicy
    );
]]

ffi.cdef[[
//
// Enum which defines which field inside of a
// power setting is being accessed.
//
typedef enum _POWER_DATA_ACCESSOR {

        //
        // Used by read/write and enumeration engines
        //
        ACCESS_AC_POWER_SETTING_INDEX = 0,
        ACCESS_DC_POWER_SETTING_INDEX,
        ACCESS_FRIENDLY_NAME,
        ACCESS_DESCRIPTION,
        ACCESS_POSSIBLE_POWER_SETTING,
        ACCESS_POSSIBLE_POWER_SETTING_FRIENDLY_NAME,
        ACCESS_POSSIBLE_POWER_SETTING_DESCRIPTION,
        ACCESS_DEFAULT_AC_POWER_SETTING,
        ACCESS_DEFAULT_DC_POWER_SETTING,
        ACCESS_POSSIBLE_VALUE_MIN,
        ACCESS_POSSIBLE_VALUE_MAX,
        ACCESS_POSSIBLE_VALUE_INCREMENT,
        ACCESS_POSSIBLE_VALUE_UNITS,
        ACCESS_ICON_RESOURCE,
        ACCESS_DEFAULT_SECURITY_DESCRIPTOR,
        ACCESS_ATTRIBUTES,

        //
        // Used by enumeration engine.
        //
        ACCESS_SCHEME,
        ACCESS_SUBGROUP,
        ACCESS_INDIVIDUAL_SETTING,

        //
        // Used by access check
        //
        ACCESS_ACTIVE_SCHEME,
        ACCESS_CREATE_SCHEME,

        //
        // Used by override ranges.
        //

        ACCESS_AC_POWER_SETTING_MAX,
        ACCESS_DC_POWER_SETTING_MAX,
        ACCESS_AC_POWER_SETTING_MIN,
        ACCESS_DC_POWER_SETTING_MIN,

        //
        // Used by enumeration engine.
        //

        ACCESS_PROFILE,
        ACCESS_OVERLAY_SCHEME,
        ACCESS_ACTIVE_OVERLAY_SCHEME,

} POWER_DATA_ACCESSOR, *PPOWER_DATA_ACCESSOR;
]]

--[[
// =========================================
// Power Scheme APIs
// =========================================
--]]
ffi.cdef[[
static const int DEVICE_NOTIFY_CALLBACK = 2;

typedef
ULONG
__stdcall
DEVICE_NOTIFY_CALLBACK_ROUTINE (
     PVOID Context,
     ULONG Type,
     PVOID Setting
    );
typedef DEVICE_NOTIFY_CALLBACK_ROUTINE* PDEVICE_NOTIFY_CALLBACK_ROUTINE;

typedef struct _DEVICE_NOTIFY_SUBSCRIBE_PARAMETERS {
    PDEVICE_NOTIFY_CALLBACK_ROUTINE Callback;
    PVOID Context;
} DEVICE_NOTIFY_SUBSCRIBE_PARAMETERS, *PDEVICE_NOTIFY_SUBSCRIBE_PARAMETERS;
]]


if (NTDDI_VERSION >= NTDDI_WIN7) then
ffi.cdef[[
BOOLEAN
PowerIsSettingRangeDefined (
     const GUID *SubKeyGuid ,
     const GUID *SettingGuid 
    );
]]
end


if (NTDDI_VERSION >= NTDDI_WIN7) then
ffi.cdef[[
DWORD
PowerSettingAccessCheckEx (
     POWER_DATA_ACCESSOR AccessFlags,
     const GUID *PowerGuid,
     REGSAM AccessType
    );
]]
end


if (NTDDI_VERSION >= NTDDI_VISTA) then
ffi.cdef[[
DWORD
PowerSettingAccessCheck (
     POWER_DATA_ACCESSOR AccessFlags,
     const GUID *PowerGuid
    );



// Read functions.

DWORD
PowerReadACValueIndex (
     HKEY RootPowerKey,
     const GUID *SchemeGuid,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     LPDWORD AcValueIndex
    );

DWORD
PowerReadDCValueIndex (
     HKEY RootPowerKey,
     const GUID *SchemeGuid,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     LPDWORD DcValueIndex
    );

DWORD
PowerReadFriendlyName (
     HKEY RootPowerKey,
     const GUID *SchemeGuid,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     PUCHAR Buffer,
     LPDWORD BufferSize
    );

DWORD
PowerReadDescription (
     HKEY RootPowerKey,
     const GUID *SchemeGuid,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     PUCHAR Buffer,
     LPDWORD BufferSize
    );

DWORD
PowerReadPossibleValue (
     HKEY RootPowerKey,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     PULONG Type,
     ULONG PossibleSettingIndex,
     PUCHAR Buffer,
     LPDWORD BufferSize
    );

DWORD
PowerReadPossibleFriendlyName (
     HKEY RootPowerKey,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     ULONG PossibleSettingIndex,
     PUCHAR Buffer,
     LPDWORD BufferSize
    );

DWORD
PowerReadPossibleDescription (
     HKEY RootPowerKey,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     ULONG PossibleSettingIndex,
     PUCHAR Buffer,
     LPDWORD BufferSize
    );

DWORD
PowerReadValueMin (
     HKEY RootPowerKey,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     LPDWORD ValueMinimum
    );

DWORD
PowerReadValueMax (
     HKEY RootPowerKey,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     LPDWORD ValueMaximum
    );

DWORD
PowerReadValueIncrement (
     HKEY RootPowerKey,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     LPDWORD ValueIncrement
    );

DWORD
PowerReadValueUnitsSpecifier (
     HKEY RootPowerKey,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     UCHAR *Buffer,
     LPDWORD BufferSize
    );

DWORD
PowerReadACDefaultIndex (
     HKEY RootPowerKey,
     const GUID *SchemePersonalityGuid,
     const GUID *SubGroupOfPowerSettingsGuid ,
     const GUID *PowerSettingGuid,
     LPDWORD AcDefaultIndex
    );

DWORD
PowerReadDCDefaultIndex (
     HKEY RootPowerKey,
     const GUID *SchemePersonalityGuid,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     LPDWORD DcDefaultIndex
    );

DWORD
PowerReadIconResourceSpecifier (
     HKEY RootPowerKey,
     const GUID *SchemeGuid,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     PUCHAR Buffer,
     LPDWORD BufferSize
    );

DWORD
PowerReadSettingAttributes (
     const GUID *SubGroupGuid,
     const GUID *PowerSettingGuid
    );
]]

ffi.cdef[[
//
// Write functions.
//

DWORD
PowerWriteFriendlyName (
     HKEY RootPowerKey,
     const GUID *SchemeGuid,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     UCHAR *Buffer,
     DWORD BufferSize
    );



DWORD
PowerWriteDescription (
     HKEY RootPowerKey,
     const GUID *SchemeGuid,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     UCHAR *Buffer,
     DWORD BufferSize
    );



DWORD
PowerWritePossibleValue (
     HKEY RootPowerKey,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     ULONG Type,
     ULONG PossibleSettingIndex,
     UCHAR *Buffer,
     DWORD BufferSize
    );



DWORD
PowerWritePossibleFriendlyName (
     HKEY RootPowerKey,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     ULONG PossibleSettingIndex,
     UCHAR *Buffer,
     DWORD BufferSize
    );



DWORD
PowerWritePossibleDescription (
     HKEY RootPowerKey,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     ULONG PossibleSettingIndex,
     UCHAR *Buffer,
     DWORD BufferSize
    );



DWORD
PowerWriteValueMin (
     HKEY RootPowerKey,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     DWORD ValueMinimum
    );



DWORD
PowerWriteValueMax (
     HKEY RootPowerKey,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     DWORD ValueMaximum
    );



DWORD
PowerWriteValueIncrement (
     HKEY RootPowerKey,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     DWORD ValueIncrement
    );



DWORD
PowerWriteValueUnitsSpecifier (
     HKEY RootPowerKey,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     UCHAR *Buffer,
     DWORD BufferSize
    );



DWORD
PowerWriteACDefaultIndex (
     HKEY RootSystemPowerKey,
     const GUID *SchemePersonalityGuid,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     DWORD DefaultAcIndex
    );



DWORD
PowerWriteDCDefaultIndex (
     HKEY RootSystemPowerKey,
     const GUID *SchemePersonalityGuid,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     DWORD DefaultDcIndex
    );



DWORD
PowerWriteIconResourceSpecifier (
     HKEY RootPowerKey,
     const GUID *SchemeGuid,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     UCHAR *Buffer,
     DWORD BufferSize
    );



DWORD
PowerWriteSettingAttributes (
     const GUID *SubGroupGuid,
     const GUID *PowerSettingGuid,
     DWORD Attributes
    );
]]

ffi.cdef[[
DWORD
PowerDuplicateScheme (
     HKEY RootPowerKey,
     const GUID *SourceSchemeGuid,
     GUID **DestinationSchemeGuid
    );



DWORD
PowerImportPowerScheme (
     HKEY RootPowerKey,
     LPCWSTR ImportFileNamePath,
     GUID **DestinationSchemeGuid
    );



DWORD
PowerDeleteScheme (
     HKEY RootPowerKey,
     const GUID *SchemeGuid
    );



DWORD
PowerRemovePowerSetting (
    const GUID *PowerSettingSubKeyGuid,
    const GUID *PowerSettingGuid
   );



DWORD
PowerCreateSetting (
     HKEY RootSystemPowerKey,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid
    );



DWORD
PowerCreatePossibleSetting (
     HKEY RootSystemPowerKey,
     const GUID *SubGroupOfPowerSettingsGuid,
     const GUID *PowerSettingGuid,
     ULONG PossibleSettingIndex
    );
]]

ffi.cdef[[
//
// Enumerate Functions.
//

DWORD
PowerEnumerate (
     HKEY RootPowerKey,
     const GUID *SchemeGuid,
     const GUID *SubGroupOfPowerSettingsGuid,
     POWER_DATA_ACCESSOR AccessFlags,
     ULONG Index,
     UCHAR *Buffer,
     DWORD *BufferSize
    );



DWORD
PowerOpenUserPowerKey (
     HKEY *phUserPowerKey,
     REGSAM Access,
     BOOL OpenExisting
    );



DWORD
PowerOpenSystemPowerKey (
     HKEY *phSystemPowerKey,
     REGSAM Access,
     BOOL OpenExisting
    );


DWORD
PowerCanRestoreIndividualDefaultPowerScheme (
     const GUID *SchemeGuid
    );

DWORD
PowerRestoreIndividualDefaultPowerScheme (
     const GUID *SchemeGuid
    );

DWORD
PowerRestoreDefaultPowerSchemes(
    VOID
    );



DWORD
PowerReplaceDefaultPowerSchemes(
    VOID
    );



POWER_PLATFORM_ROLE
PowerDeterminePlatformRole(
    VOID
    );
]]

end  -- (NTDDI_VERSION >= NTDDI_VISTA)

ffi.cdef[[
static const int DEVICEPOWER_HARDWAREID             = (0x80000000);
static const int DEVICEPOWER_AND_OPERATION          = (0x40000000);
static const int DEVICEPOWER_FILTER_DEVICES_PRESENT = (0x20000000);
static const int DEVICEPOWER_FILTER_HARDWARE        = (0x10000000);
static const int DEVICEPOWER_FILTER_WAKEENABLED     = (0x08000000);
static const int DEVICEPOWER_FILTER_WAKEPROGRAMMABLE = (0x04000000);
static const int DEVICEPOWER_FILTER_ON_NAME         = (0x02000000);
static const int DEVICEPOWER_SET_WAKEENABLED        = (0x00000001);
static const int DEVICEPOWER_CLEAR_WAKEENABLED      = (0x00000002);
]]

ffi.cdef[[
static const int PDCAP_S0_SUPPORTED            =  0x00010000;
static const int PDCAP_S1_SUPPORTED            =  0x00020000;
static const int PDCAP_S2_SUPPORTED            =  0x00040000;
static const int PDCAP_S3_SUPPORTED            =  0x00080000;
static const int PDCAP_WAKE_FROM_S0_SUPPORTED  =  0x00100000;
static const int PDCAP_WAKE_FROM_S1_SUPPORTED  =  0x00200000;
static const int PDCAP_WAKE_FROM_S2_SUPPORTED  =  0x00400000;
static const int PDCAP_WAKE_FROM_S3_SUPPORTED  =  0x00800000;
static const int PDCAP_S4_SUPPORTED            =  0x01000000;
static const int PDCAP_S5_SUPPORTED            =  0x02000000;
]]


if (NTDDI_VERSION >= NTDDI_WS03) then
ffi.cdef[[
BOOLEAN
DevicePowerEnumDevices(
     ULONG  QueryIndex,
     ULONG  QueryInterpretationFlags,
     ULONG  QueryFlags,
     PBYTE  pReturnBuffer,
     PULONG pBufferSize
    );



DWORD
DevicePowerSetDeviceState(
     LPCWSTR DeviceDescription,
     ULONG SetFlags,
     PVOID SetData
    );



BOOLEAN
DevicePowerOpen(
     ULONG DebugMask
    );



BOOLEAN
DevicePowerClose(
    VOID
    );
]]
end  -- (NTDDI_VERSION >= NTDDI_WS03)

ffi.cdef[[
//
// Thermal event notifications
//

static const int THERMAL_EVENT_VERSION = 1;

typedef struct _THERMAL_EVENT {
    ULONG Version;
    ULONG Size;
    ULONG Type;
    ULONG Temperature;
    ULONG TripPointTemperature;
    LPWSTR Initiator; 
} THERMAL_EVENT, *PTHERMAL_EVENT; 
]]

if (NTDDI_VERSION >= NTDDI_WINBLUE) then
ffi.cdef[[
DWORD
PowerReportThermalEvent (
     PTHERMAL_EVENT Event
    );
]]
end



end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


-- end --// _POWRPROF_H_

return ffi.load("powrprof")
