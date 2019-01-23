
local ffi = require("ffi")

require("win32.winapifamily")

--#include <apiset.h>
--#include <apisetcconv.h>
require("win32.minwindef")
require("win32.minwinbase")





if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


if not WINVER then
WINVER = 0x0500;   -- version 5.0
end -- !WINVER */

ffi.cdef[[
typedef  LONG LSTATUS;
]]

ffi.cdef[[
//
// RRF - Registry Routine Flags (for RegGetValue)
//
static const int RRF_RT_REG_NONE      =  0x00000001;  // restrict type to REG_NONE      (other data types will not return ERROR_SUCCESS)
static const int RRF_RT_REG_SZ        =  0x00000002;  // restrict type to REG_SZ        (other data types will not return ERROR_SUCCESS) (automatically converts REG_EXPAND_SZ to REG_SZ unless RRF_NOEXPAND is specified)
static const int RRF_RT_REG_EXPAND_SZ =  0x00000004;  // restrict type to REG_EXPAND_SZ (other data types will not return ERROR_SUCCESS) (must specify RRF_NOEXPAND or RegGetValue will fail with ERROR_INVALID_PARAMETER)
static const int RRF_RT_REG_BINARY    =  0x00000008;  // restrict type to REG_BINARY    (other data types will not return ERROR_SUCCESS)
static const int RRF_RT_REG_DWORD     =  0x00000010;  // restrict type to REG_DWORD     (other data types will not return ERROR_SUCCESS)
static const int RRF_RT_REG_MULTI_SZ  =  0x00000020;  // restrict type to REG_MULTI_SZ  (other data types will not return ERROR_SUCCESS)
static const int RRF_RT_REG_QWORD     =  0x00000040;  // restrict type to REG_QWORD     (other data types will not return ERROR_SUCCESS)

static const int RRF_RT_DWORD         =  (RRF_RT_REG_BINARY | RRF_RT_REG_DWORD); // restrict type to *32-bit* RRF_RT_REG_BINARY or RRF_RT_REG_DWORD (other data types will not return ERROR_SUCCESS)
static const int RRF_RT_QWORD         =  (RRF_RT_REG_BINARY | RRF_RT_REG_QWORD); // restrict type to *64-bit* RRF_RT_REG_BINARY or RRF_RT_REG_DWORD (other data types will not return ERROR_SUCCESS)
static const int RRF_RT_ANY           =  0x0000ffff;                             // no type restriction
]]

if (_WIN32_WINNT >= _WIN32_WINNT_WINTHRESHOLD) then
ffi.cdef[[
static const int RRF_SUBKEY_WOW6464KEY = 0x00010000;  // when opening the subkey (if provided) force open from the 64bit location (only one SUBKEY_WOW64* flag can be set or RegGetValue will fail with ERROR_INVALID_PARAMETER)
static const int RRF_SUBKEY_WOW6432KEY = 0x00020000;  // when opening the subkey (if provided) force open from the 32bit location (only one SUBKEY_WOW64* flag can be set or RegGetValue will fail with ERROR_INVALID_PARAMETER)
static const int RRF_WOW64_MASK        = 0x00030000;
]]
end

ffi.cdef[[
static const int RRF_NOEXPAND          = 0x10000000;  // do not automatically expand environment strings if value is of type REG_EXPAND_SZ
static const int RRF_ZEROONFAILURE     = 0x20000000;  // if pvData is not NULL, set content to all zeros on failure

//
// Flags for RegLoadAppKey
//
static const int REG_PROCESS_APPKEY     =     0x00000001;
]]

ffi.cdef[[
//
// Requested Key access mask type.
//

typedef ACCESS_MASK REGSAM;
]]



-- Reserved Key Handles.

HKEY_CLASSES_ROOT           =       ffi.cast("HKEY", ffi.cast("ULONG_PTR",0x80000000));
HKEY_CURRENT_USER           =       ffi.cast("HKEY", ffi.cast("ULONG_PTR",0x80000001));
HKEY_LOCAL_MACHINE          =       ffi.cast("HKEY", ffi.cast("ULONG_PTR",0x80000002));
HKEY_USERS                  =       ffi.cast("HKEY", ffi.cast("ULONG_PTR",0x80000003));
HKEY_PERFORMANCE_DATA       =       ffi.cast("HKEY", ffi.cast("ULONG_PTR",0x80000004));
HKEY_PERFORMANCE_TEXT       =       ffi.cast("HKEY", ffi.cast("ULONG_PTR",0x80000050));
HKEY_PERFORMANCE_NLSTEXT    =       ffi.cast("HKEY", ffi.cast("ULONG_PTR",0x80000060));


if (WINVER >= 0x0400) then
--[[
ffi.cdef[[
static const int HKEY_CURRENT_CONFIG               =  (( HKEY ) (ULONG_PTR)((LONG)0x80000005) );
static const int HKEY_DYN_DATA                     =  (( HKEY ) (ULONG_PTR)((LONG)0x80000006) );
static const int HKEY_CURRENT_USER_LOCAL_SETTINGS  =  (( HKEY ) (ULONG_PTR)((LONG)0x80000007) );
]]
--]]

--/*NOINC*/
if not _PROVIDER_STRUCTS_DEFINED then
_PROVIDER_STRUCTS_DEFINED = true

ffi.cdef[[
static const int PROVIDER_KEEPS_VALUE_LENGTH = 0x1;
struct val_context {
    int valuelen;       // the total length of this value
    LPVOID value_context;   // providers context
    LPVOID val_buff_ptr;    // where in the ouput buffer the value is.
};

typedef struct val_context  *PVALCONTEXT;

typedef struct pvalueA {           // Provider supplied value/context.
    LPSTR   pv_valuename;          // The value name pointer
    int pv_valuelen;
    LPVOID pv_value_context;
    DWORD pv_type;
}PVALUEA,  *PPVALUEA;
typedef struct pvalueW {           // Provider supplied value/context.
    LPWSTR  pv_valuename;          // The value name pointer
    int pv_valuelen;
    LPVOID pv_value_context;
    DWORD pv_type;
}PVALUEW,  *PPVALUEW;
]]

--[[
#ifdef UNICODE
typedef PVALUEW PVALUE;
typedef PPVALUEW PPVALUE;
#else
typedef PVALUEA PVALUE;
typedef PPVALUEA PPVALUE;
end // UNICODE
--]]

ffi.cdef[[
typedef
DWORD __cdecl
QUERYHANDLER (LPVOID keycontext, PVALCONTEXT val_list, DWORD num_vals,
          LPVOID outputbuffer, DWORD  *total_outlen, DWORD input_blen);

typedef QUERYHANDLER  *PQUERYHANDLER;

typedef struct provider_info {
    PQUERYHANDLER pi_R0_1val;
    PQUERYHANDLER pi_R0_allvals;
    PQUERYHANDLER pi_R3_1val;
    PQUERYHANDLER pi_R3_allvals;
    DWORD pi_flags;    // capability flags (none defined yet).
    LPVOID pi_key_context;
}REG_PROVIDER;

typedef struct provider_info  *PPROVIDER;

typedef struct value_entA {
    LPSTR   ve_valuename;
    DWORD ve_valuelen;
    DWORD_PTR ve_valueptr;
    DWORD ve_type;
}VALENTA,  *PVALENTA;
typedef struct value_entW {
    LPWSTR  ve_valuename;
    DWORD ve_valuelen;
    DWORD_PTR ve_valueptr;
    DWORD ve_type;
}VALENTW,  *PVALENTW;
]]

--[[
#ifdef UNICODE
typedef VALENTW VALENT;
typedef PVALENTW PVALENT;
#else
typedef VALENTA VALENT;
typedef PVALENTA PVALENT;
end // UNICODE
--]]
end -- not(_PROVIDER_STRUCTS_DEFINED)


end --/* WINVER >= 0x0400 */


-- Default values for parameters that do not exist in the Win 3.1
-- compatible APIs.


WIN31_CLASS            = nil

end --// WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
--[=[
//
// Flags for RegLoadMUIString
//
#define REG_MUI_STRING_TRUNCATE   =  0x00000001
--]=]

if (WINVER >= 0x0400) then
ffi.cdef[[
static const int REG_SECURE_CONNECTION  = 1;
]]
end --/* WINVER >= 0x0400 */


ffi.cdef[[
//
// API Prototypes.
//


LSTATUS
__stdcall
RegCloseKey(
     HKEY hKey
    );



LSTATUS
__stdcall
RegOverridePredefKey (
     HKEY hKey,
     HKEY hNewHKey
    );


LSTATUS
__stdcall
RegOpenUserClassesRoot(
     HANDLE hToken,
     DWORD dwOptions,
     REGSAM samDesired,
     PHKEY phkResult
    );



LSTATUS
__stdcall
RegOpenCurrentUser(
     REGSAM samDesired,
     PHKEY phkResult
    );



LSTATUS
__stdcall
RegDisablePredefinedCache(
    VOID
    );


LSTATUS
__stdcall
RegDisablePredefinedCacheEx(
    VOID
    );

LSTATUS
__stdcall
RegConnectRegistryA (
     LPCSTR lpMachineName,
     HKEY hKey,
     PHKEY phkResult
    );

LSTATUS
__stdcall
RegConnectRegistryW (
     LPCWSTR lpMachineName,
     HKEY hKey,
     PHKEY phkResult
    );
]]

--[[
#ifdef UNICODE
#define RegConnectRegistry  RegConnectRegistryW
#else
#define RegConnectRegistry  RegConnectRegistryA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegConnectRegistryExA (
     LPCSTR lpMachineName,
     HKEY hKey,
     ULONG Flags,
     PHKEY phkResult
    );

LSTATUS
__stdcall
RegConnectRegistryExW (
     LPCWSTR lpMachineName,
     HKEY hKey,
     ULONG Flags,
     PHKEY phkResult
    );
]]

--[[
#ifdef UNICODE
#define RegConnectRegistryEx  RegConnectRegistryExW
#else
#define RegConnectRegistryEx  RegConnectRegistryExA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegCreateKeyA (
     HKEY hKey,
     LPCSTR lpSubKey,
     PHKEY phkResult
    );

LSTATUS
__stdcall
RegCreateKeyW (
     HKEY hKey,
     LPCWSTR lpSubKey,
     PHKEY phkResult
    );
]]

--[[
#ifdef UNICODE
#define RegCreateKey  RegCreateKeyW
#else
#define RegCreateKey  RegCreateKeyA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegCreateKeyExA(
     HKEY hKey,
     LPCSTR lpSubKey,
     DWORD Reserved,
     LPSTR lpClass,
     DWORD dwOptions,
     REGSAM samDesired,
     const LPSECURITY_ATTRIBUTES lpSecurityAttributes,
     PHKEY phkResult,
     LPDWORD lpdwDisposition
    );


LSTATUS
__stdcall
RegCreateKeyExW(
     HKEY hKey,
     LPCWSTR lpSubKey,
     DWORD Reserved,
     LPWSTR lpClass,
     DWORD dwOptions,
     REGSAM samDesired,
     const LPSECURITY_ATTRIBUTES lpSecurityAttributes,
     PHKEY phkResult,
     LPDWORD lpdwDisposition
    );
]]

--[[
#ifdef UNICODE
#define RegCreateKeyEx  RegCreateKeyExW
#else
#define RegCreateKeyEx  RegCreateKeyExA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegCreateKeyTransactedA (
     HKEY hKey,
     LPCSTR lpSubKey,
     DWORD Reserved,
     LPSTR lpClass,
     DWORD dwOptions,
     REGSAM samDesired,
     const LPSECURITY_ATTRIBUTES lpSecurityAttributes,
     PHKEY phkResult,
     LPDWORD lpdwDisposition,
            HANDLE hTransaction,
     PVOID  pExtendedParemeter
    );

LSTATUS
__stdcall
RegCreateKeyTransactedW (
     HKEY hKey,
     LPCWSTR lpSubKey,
     DWORD Reserved,
     LPWSTR lpClass,
     DWORD dwOptions,
     REGSAM samDesired,
     const LPSECURITY_ATTRIBUTES lpSecurityAttributes,
     PHKEY phkResult,
     LPDWORD lpdwDisposition,
            HANDLE hTransaction,
     PVOID  pExtendedParemeter
    );
]]

--[[
#ifdef UNICODE
#define RegCreateKeyTransacted  RegCreateKeyTransactedW
#else
#define RegCreateKeyTransacted  RegCreateKeyTransactedA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegDeleteKeyA (
     HKEY hKey,
     LPCSTR lpSubKey
    );

LSTATUS
__stdcall
RegDeleteKeyW (
     HKEY hKey,
     LPCWSTR lpSubKey
    );
]]

--[[
#ifdef UNICODE
#define RegDeleteKey  RegDeleteKeyW
#else
#define RegDeleteKey  RegDeleteKeyA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegDeleteKeyExA(
     HKEY hKey,
     LPCSTR lpSubKey,
     REGSAM samDesired,
     DWORD Reserved
    );


LSTATUS
__stdcall
RegDeleteKeyExW(
     HKEY hKey,
     LPCWSTR lpSubKey,
     REGSAM samDesired,
     DWORD Reserved
    );
]]

--[[
#ifdef UNICODE
#define RegDeleteKeyEx  RegDeleteKeyExW
#else
#define RegDeleteKeyEx  RegDeleteKeyExA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegDeleteKeyTransactedA (
     HKEY hKey,
     LPCSTR lpSubKey,
     REGSAM samDesired,
     DWORD Reserved,
            HANDLE hTransaction,
     PVOID  pExtendedParameter
    );

LSTATUS
__stdcall
RegDeleteKeyTransactedW (
     HKEY hKey,
     LPCWSTR lpSubKey,
     REGSAM samDesired,
     DWORD Reserved,
            HANDLE hTransaction,
     PVOID  pExtendedParameter
    );
]]

--[[
#ifdef UNICODE
#define RegDeleteKeyTransacted  RegDeleteKeyTransactedW
#else
#define RegDeleteKeyTransacted  RegDeleteKeyTransactedA
end // !UNICODE
--]]

ffi.cdef[[
LONG
__stdcall
RegDisableReflectionKey (
     HKEY hBase
    );


LONG
__stdcall
RegEnableReflectionKey (
     HKEY hBase
    );


LONG
__stdcall
RegQueryReflectionKey (
     HKEY hBase,
     BOOL *bIsReflectionDisabled
    );


LSTATUS
__stdcall
RegDeleteValueA(
     HKEY hKey,
     LPCSTR lpValueName
    );


LSTATUS
__stdcall
RegDeleteValueW(
     HKEY hKey,
     LPCWSTR lpValueName
    );
]]

--[[
#ifdef UNICODE
#define RegDeleteValue  RegDeleteValueW
#else
#define RegDeleteValue  RegDeleteValueA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegEnumKeyA (
     HKEY hKey,
     DWORD dwIndex,
     LPSTR lpName,
     DWORD cchName
    );

LSTATUS
__stdcall
RegEnumKeyW (
     HKEY hKey,
     DWORD dwIndex,
     LPWSTR lpName,
     DWORD cchName
    );
]]

--[[
#ifdef UNICODE
#define RegEnumKey  RegEnumKeyW
#else
#define RegEnumKey  RegEnumKeyA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegEnumKeyExA(
     HKEY hKey,
     DWORD dwIndex,
     LPSTR lpName,
     LPDWORD lpcchName,
     LPDWORD lpReserved,
     LPSTR lpClass,
     LPDWORD lpcchClass,
     PFILETIME lpftLastWriteTime
    );


LSTATUS
__stdcall
RegEnumKeyExW(
     HKEY hKey,
     DWORD dwIndex,
     LPWSTR lpName,
     LPDWORD lpcchName,
     LPDWORD lpReserved,
     LPWSTR lpClass,
     LPDWORD lpcchClass,
     PFILETIME lpftLastWriteTime
    );
]]

--[[
#ifdef UNICODE
#define RegEnumKeyEx  RegEnumKeyExW
#else
#define RegEnumKeyEx  RegEnumKeyExA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegEnumValueA(
     HKEY hKey,
     DWORD dwIndex,
     LPSTR lpValueName,
     LPDWORD lpcchValueName,
     LPDWORD lpReserved,
     LPDWORD lpType,
      LPBYTE lpData,
     LPDWORD lpcbData
    );


LSTATUS
__stdcall
RegEnumValueW(
     HKEY hKey,
     DWORD dwIndex,
     LPWSTR lpValueName,
     LPDWORD lpcchValueName,
     LPDWORD lpReserved,
     LPDWORD lpType,
      LPBYTE lpData,
     LPDWORD lpcbData
    );
]]

--[[
#ifdef UNICODE
#define RegEnumValue  RegEnumValueW
#else
#define RegEnumValue  RegEnumValueA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegFlushKey(
     HKEY hKey
    );



LSTATUS
__stdcall
RegGetKeySecurity(
     HKEY hKey,
     SECURITY_INFORMATION SecurityInformation,
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
     LPDWORD lpcbSecurityDescriptor
    );



LSTATUS
__stdcall
RegLoadKeyA(
     HKEY hKey,
     LPCSTR lpSubKey,
     LPCSTR lpFile
    );


LSTATUS
__stdcall
RegLoadKeyW(
     HKEY hKey,
     LPCWSTR lpSubKey,
     LPCWSTR lpFile
    );
]]

--[[
#ifdef UNICODE
#define RegLoadKey  RegLoadKeyW
#else
#define RegLoadKey  RegLoadKeyA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegNotifyChangeKeyValue(
     HKEY hKey,
     BOOL bWatchSubtree,
     DWORD dwNotifyFilter,
     HANDLE hEvent,
     BOOL fAsynchronous
    );
]]

--[=[
-- for 16-bit windows only
ffi.cdef[[
LSTATUS
__stdcall
RegOpenKeyA (
     HKEY hKey,
     LPCSTR lpSubKey,
     PHKEY phkResult
    );

LSTATUS
__stdcall
RegOpenKeyW (
     HKEY hKey,
     LPCWSTR lpSubKey,
     PHKEY phkResult
    );
]]

--[[
#ifdef UNICODE
#define RegOpenKey  RegOpenKeyW
#else
#define RegOpenKey  RegOpenKeyA
end // !UNICODE
--]]
--]=]

ffi.cdef[[
LSTATUS
__stdcall
RegOpenKeyExA(
     HKEY hKey,
     LPCSTR lpSubKey,
     DWORD ulOptions,
     REGSAM samDesired,
     PHKEY phkResult
    );


LSTATUS
__stdcall
RegOpenKeyExW(
     HKEY hKey,
     LPCWSTR lpSubKey,
     DWORD ulOptions,
     REGSAM samDesired,
     PHKEY phkResult
    );
]]

--[[
#ifdef UNICODE
#define RegOpenKeyEx  RegOpenKeyExW
#else
#define RegOpenKeyEx  RegOpenKeyExA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegOpenKeyTransactedA (
     HKEY hKey,
     LPCSTR lpSubKey,
     DWORD ulOptions,
     REGSAM samDesired,
     PHKEY phkResult,
            HANDLE hTransaction,
     PVOID  pExtendedParemeter
    );

LSTATUS
__stdcall
RegOpenKeyTransactedW (
     HKEY hKey,
     LPCWSTR lpSubKey,
     DWORD ulOptions,
     REGSAM samDesired,
     PHKEY phkResult,
            HANDLE hTransaction,
     PVOID  pExtendedParemeter
    );
]]

--[[
#ifdef UNICODE
#define RegOpenKeyTransacted  RegOpenKeyTransactedW
#else
#define RegOpenKeyTransacted  RegOpenKeyTransactedA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegQueryInfoKeyA(
     HKEY hKey,
     LPSTR lpClass,
     LPDWORD lpcchClass,
     LPDWORD lpReserved,
     LPDWORD lpcSubKeys,
     LPDWORD lpcbMaxSubKeyLen,
     LPDWORD lpcbMaxClassLen,
     LPDWORD lpcValues,
     LPDWORD lpcbMaxValueNameLen,
     LPDWORD lpcbMaxValueLen,
     LPDWORD lpcbSecurityDescriptor,
     PFILETIME lpftLastWriteTime
    );


LSTATUS
__stdcall
RegQueryInfoKeyW(
     HKEY hKey,
     LPWSTR lpClass,
     LPDWORD lpcchClass,
     LPDWORD lpReserved,
     LPDWORD lpcSubKeys,
     LPDWORD lpcbMaxSubKeyLen,
     LPDWORD lpcbMaxClassLen,
     LPDWORD lpcValues,
     LPDWORD lpcbMaxValueNameLen,
     LPDWORD lpcbMaxValueLen,
     LPDWORD lpcbSecurityDescriptor,
     PFILETIME lpftLastWriteTime
    );
]]

--[[
#ifdef UNICODE
#define RegQueryInfoKey  RegQueryInfoKeyW
#else
#define RegQueryInfoKey  RegQueryInfoKeyA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegQueryValueA (
     HKEY hKey,
     LPCSTR lpSubKey,
      LPSTR lpData,
     PLONG lpcbData
    );

LSTATUS
__stdcall
RegQueryValueW (
     HKEY hKey,
     LPCWSTR lpSubKey,
      LPWSTR lpData,
     PLONG lpcbData
    );
]]

--[[
#ifdef UNICODE
#define RegQueryValue  RegQueryValueW
#else
#define RegQueryValue  RegQueryValueA
end // !UNICODE
--]]

if (WINVER >= 0x0400) then

ffi.cdef[[
LSTATUS
__stdcall
RegQueryMultipleValuesA(
     HKEY hKey,
     PVALENTA val_list,
     DWORD num_vals,
      LPSTR lpValueBuf,
     LPDWORD ldwTotsize
    );


LSTATUS
__stdcall
RegQueryMultipleValuesW(
     HKEY hKey,
     PVALENTW val_list,
     DWORD num_vals,
      LPWSTR lpValueBuf,
     LPDWORD ldwTotsize
    );
]]

--[[
#ifdef UNICODE
#define RegQueryMultipleValues  RegQueryMultipleValuesW
#else
#define RegQueryMultipleValues  RegQueryMultipleValuesA
end // !UNICODE
--]]

end --/* WINVER >= 0x0400 */

ffi.cdef[[
LSTATUS
__stdcall
RegQueryValueExA(
     HKEY hKey,
     LPCSTR lpValueName,
     LPDWORD lpReserved,
     LPDWORD lpType,
      LPBYTE lpData,
     LPDWORD lpcbData
    );


LSTATUS
__stdcall
RegQueryValueExW(
     HKEY hKey,
     LPCWSTR lpValueName,
     LPDWORD lpReserved,
     LPDWORD lpType,
      LPBYTE lpData,
     LPDWORD lpcbData
    );
]]

--[[
#ifdef UNICODE
#define RegQueryValueEx  RegQueryValueExW
#else
#define RegQueryValueEx  RegQueryValueExA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegReplaceKeyA (
     HKEY hKey,
     LPCSTR lpSubKey,
     LPCSTR lpNewFile,
     LPCSTR lpOldFile
    );

LSTATUS
__stdcall
RegReplaceKeyW (
     HKEY hKey,
     LPCWSTR lpSubKey,
     LPCWSTR lpNewFile,
     LPCWSTR lpOldFile
    );
]]

--[[
#ifdef UNICODE
#define RegReplaceKey  RegReplaceKeyW
#else
#define RegReplaceKey  RegReplaceKeyA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegRestoreKeyA(
     HKEY hKey,
     LPCSTR lpFile,
     DWORD dwFlags
    );


LSTATUS
__stdcall
RegRestoreKeyW(
     HKEY hKey,
     LPCWSTR lpFile,
     DWORD dwFlags
    );
]]

--[[
#ifdef UNICODE
#define RegRestoreKey  RegRestoreKeyW
#else
#define RegRestoreKey  RegRestoreKeyA
end // !UNICODE
--]]

if (WINVER >= 0x0600) then

ffi.cdef[[
LSTATUS
__stdcall
RegRenameKey(
     HKEY hKey,
     LPCWSTR lpSubKeyName,
     LPCWSTR lpNewKeyName
    );
]]
end --/* WINVER >= 0x0600 */

ffi.cdef[[
LSTATUS
__stdcall
RegSaveKeyA (
     HKEY hKey,
     LPCSTR lpFile,
     const LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );

LSTATUS
__stdcall
RegSaveKeyW (
     HKEY hKey,
     LPCWSTR lpFile,
     const LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
]]

--[[
#ifdef UNICODE
#define RegSaveKey  RegSaveKeyW
#else
#define RegSaveKey  RegSaveKeyA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegSetKeySecurity(
     HKEY hKey,
     SECURITY_INFORMATION SecurityInformation,
     PSECURITY_DESCRIPTOR pSecurityDescriptor
    );



LSTATUS
__stdcall
RegSetValueA (
     HKEY hKey,
     LPCSTR lpSubKey,
     DWORD dwType,
     LPCSTR lpData,
     DWORD cbData
    );

LSTATUS
__stdcall
RegSetValueW (
     HKEY hKey,
     LPCWSTR lpSubKey,
     DWORD dwType,
     LPCWSTR lpData,
     DWORD cbData
    );
]]

--[[
#ifdef UNICODE
#define RegSetValue  RegSetValueW
#else
#define RegSetValue  RegSetValueA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegSetValueExA(
     HKEY hKey,
     LPCSTR lpValueName,
     DWORD Reserved,
     DWORD dwType,
     const BYTE* lpData,
     DWORD cbData
    );


LSTATUS
__stdcall
RegSetValueExW(
     HKEY hKey,
     LPCWSTR lpValueName,
     DWORD Reserved,
     DWORD dwType,
     const BYTE* lpData,
     DWORD cbData
    );
]]

--[[
#ifdef UNICODE
#define RegSetValueEx  RegSetValueExW
#else
#define RegSetValueEx  RegSetValueExA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegUnLoadKeyA(
     HKEY hKey,
     LPCSTR lpSubKey
    );


LSTATUS
__stdcall
RegUnLoadKeyW(
     HKEY hKey,
     LPCWSTR lpSubKey
    );
]]

--[[
#ifdef UNICODE
#define RegUnLoadKey  RegUnLoadKeyW
#else
#define RegUnLoadKey  RegUnLoadKeyA
end // !UNICODE
--]]


-- Utils wrappers

if _WIN32_WINNT >= 0x0600 then

ffi.cdef[[
LSTATUS
__stdcall
RegDeleteKeyValueA(
     HKEY hKey,
     LPCSTR lpSubKey,
     LPCSTR lpValueName
    );


LSTATUS
__stdcall
RegDeleteKeyValueW(
     HKEY hKey,
     LPCWSTR lpSubKey,
     LPCWSTR lpValueName
    );
]]

--[[
#ifdef UNICODE
#define RegDeleteKeyValue  RegDeleteKeyValueW
#else
#define RegDeleteKeyValue  RegDeleteKeyValueA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegSetKeyValueA(
     HKEY hKey,
     LPCSTR lpSubKey,
     LPCSTR lpValueName,
     DWORD dwType,
     LPCVOID lpData,
     DWORD cbData
    );


LSTATUS
__stdcall
RegSetKeyValueW(
     HKEY hKey,
     LPCWSTR lpSubKey,
     LPCWSTR lpValueName,
     DWORD dwType,
     LPCVOID lpData,
     DWORD cbData
    );
]]

--[[
#ifdef UNICODE
#define RegSetKeyValue  RegSetKeyValueW
#else
#define RegSetKeyValue  RegSetKeyValueA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegDeleteTreeA(
     HKEY hKey,
     LPCSTR lpSubKey
    );


LSTATUS
__stdcall
RegDeleteTreeW(
     HKEY hKey,
     LPCWSTR lpSubKey
    );
]]

--[[
#ifdef UNICODE
#define RegDeleteTree  RegDeleteTreeW
#else
#define RegDeleteTree  RegDeleteTreeA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegCopyTreeA (
            HKEY     hKeySrc,
        LPCSTR  lpSubKey,
            HKEY     hKeyDest
    );
]]

--[[
if not UNICODE then
#define RegCopyTree  RegCopyTreeA
end // !UNICODE
--]]

end -- _WIN32_WINNT >= 0x0600

if (_WIN32_WINNT >= 0x0502) then

ffi.cdef[[
LSTATUS
__stdcall
RegGetValueA(
     HKEY hkey,
     LPCSTR lpSubKey,
     LPCSTR lpValue,
     DWORD dwFlags,
     LPDWORD pdwType,
     PVOID pvData,
     LPDWORD pcbData
    );


LSTATUS
__stdcall
RegGetValueW(
     HKEY hkey,
     LPCWSTR lpSubKey,
     LPCWSTR lpValue,
     DWORD dwFlags,
     LPDWORD pdwType,
     PVOID pvData,
     LPDWORD pcbData
    );
]]

--[[
#ifdef UNICODE
#define RegGetValue  RegGetValueW
#else
#define RegGetValue  RegGetValueA
end // !UNICODE
--]]

end --// (_WIN32_WINNT >= 0x0502)

if (_WIN32_WINNT >= 0x0600) then

ffi.cdef[[
LSTATUS
__stdcall
RegCopyTreeW(
     HKEY hKeySrc,
     LPCWSTR lpSubKey,
     HKEY hKeyDest
    );
]]

--[[
#ifdef UNICODE
#define RegCopyTree  RegCopyTreeW
end
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegLoadMUIStringA(
     HKEY hKey,
     LPCSTR pszValue,
     LPSTR pszOutBuf,
     DWORD cbOutBuf,
     LPDWORD pcbData,
     DWORD Flags,
     LPCSTR pszDirectory
    );


LSTATUS
__stdcall
RegLoadMUIStringW(
     HKEY hKey,
     LPCWSTR pszValue,
     LPWSTR pszOutBuf,
     DWORD cbOutBuf,
     LPDWORD pcbData,
     DWORD Flags,
     LPCWSTR pszDirectory
    );
]]

--[[
#ifdef UNICODE
#define RegLoadMUIString  RegLoadMUIStringW
#else
#define RegLoadMUIString  RegLoadMUIStringA
end // !UNICODE
--]]

ffi.cdef[[
LSTATUS
__stdcall
RegLoadAppKeyA(
     LPCSTR lpFile,
     PHKEY phkResult,
     REGSAM samDesired,
     DWORD dwOptions,
     DWORD Reserved
    );


LSTATUS
__stdcall
RegLoadAppKeyW(
     LPCWSTR lpFile,
     PHKEY phkResult,
     REGSAM samDesired,
     DWORD dwOptions,
     DWORD Reserved
    );
]]

--[[
#ifdef UNICODE
#define RegLoadAppKey  RegLoadAppKeyW
#else
#define RegLoadAppKey  RegLoadAppKeyA
end // !UNICODE
--]]

end --// _WIN32_WINNT >= 0x0600


-- Remoteable System Shutdown APIs


--__drv_preferredFunction("InitiateSystemShutdownEx", "Legacy API. Rearchitect to avoid Reboot")
ffi.cdef[[
BOOL
__stdcall
InitiateSystemShutdownA(
     LPSTR lpMachineName,
     LPSTR lpMessage,
     DWORD dwTimeout,
     BOOL bForceAppsClosed,
     BOOL bRebootAfterShutdown
    );
]]
--__drv_preferredFunction("InitiateSystemShutdownEx", "Legacy API. Rearchitect to avoid Reboot")

ffi.cdef[[
BOOL
__stdcall
InitiateSystemShutdownW(
     LPWSTR lpMachineName,
     LPWSTR lpMessage,
     DWORD dwTimeout,
     BOOL bForceAppsClosed,
     BOOL bRebootAfterShutdown
    );
]]

--[[
#ifdef UNICODE
#define InitiateSystemShutdown  InitiateSystemShutdownW
#else
#define InitiateSystemShutdown  InitiateSystemShutdownA
end // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
AbortSystemShutdownA(
     LPSTR lpMachineName
    );

BOOL
__stdcall
AbortSystemShutdownW(
     LPWSTR lpMachineName
    );
]]

--[[
#ifdef UNICODE
#define AbortSystemShutdown  AbortSystemShutdownW
#else
#define AbortSystemShutdown  AbortSystemShutdownA
end // !UNICODE
--]]

require("win32.reason")             

--[[
//
// Then for Historical reasons support some old symbols, internal only

#define REASON_SWINSTALL    (SHTDN_REASON_MAJOR_SOFTWARE|SHTDN_REASON_MINOR_INSTALLATION)
#define REASON_HWINSTALL    (SHTDN_REASON_MAJOR_HARDWARE|SHTDN_REASON_MINOR_INSTALLATION)
#define REASON_SERVICEHANG  (SHTDN_REASON_MAJOR_SOFTWARE|SHTDN_REASON_MINOR_HUNG)
#define REASON_UNSTABLE     (SHTDN_REASON_MAJOR_SYSTEM|SHTDN_REASON_MINOR_UNSTABLE)
#define REASON_SWHWRECONF   (SHTDN_REASON_MAJOR_SOFTWARE|SHTDN_REASON_MINOR_RECONFIG)
#define REASON_OTHER        (SHTDN_REASON_MAJOR_OTHER|SHTDN_REASON_MINOR_OTHER)
#define REASON_UNKNOWN      SHTDN_REASON_UNKNOWN
#define REASON_LEGACY_API   SHTDN_REASON_LEGACY_API
#define REASON_PLANNED_FLAG SHTDN_REASON_FLAG_PLANNED
--]]

ffi.cdef[[
//
// MAX Shutdown TimeOut == 10 Years in seconds
//
static const int MAX_SHUTDOWN_TIMEOUT = (10*365*24*60*60);
]]



ffi.cdef[[
BOOL
__stdcall
InitiateSystemShutdownExA(
     LPSTR lpMachineName,
     LPSTR lpMessage,
     DWORD dwTimeout,
     BOOL bForceAppsClosed,
     BOOL bRebootAfterShutdown,
     DWORD dwReason
    );


BOOL
__stdcall
InitiateSystemShutdownExW(
     LPWSTR lpMachineName,
     LPWSTR lpMessage,
     DWORD dwTimeout,
     BOOL bForceAppsClosed,
     BOOL bRebootAfterShutdown,
     DWORD dwReason
    );
]]

--[[
#ifdef UNICODE
#define InitiateSystemShutdownEx  InitiateSystemShutdownExW
#else
#define InitiateSystemShutdownEx  InitiateSystemShutdownExA
end // !UNICODE
--]]

ffi.cdef[[
//
// Shutdown flags
//

static const int SHUTDOWN_FORCE_OTHERS         =  0x00000001;
static const int SHUTDOWN_FORCE_SELF           =  0x00000002;
static const int SHUTDOWN_RESTART              =  0x00000004;
static const int SHUTDOWN_POWEROFF             =  0x00000008;
static const int SHUTDOWN_NOREBOOT             =  0x00000010;
static const int SHUTDOWN_GRACE_OVERRIDE       =  0x00000020;
static const int SHUTDOWN_INSTALL_UPDATES      =  0x00000040;
static const int SHUTDOWN_RESTARTAPPS          =  0x00000080;
static const int SHUTDOWN_SKIP_SVC_PRESHUTDOWN =  0x00000100;
static const int SHUTDOWN_HYBRID               =  0x00000200;
static const int SHUTDOWN_RESTART_BOOTOPTIONS  =  0x00000400;
static const int SHUTDOWN_SOFT_REBOOT          =  0x00000800;
static const int SHUTDOWN_MOBILE_UI            =  0x00001000;
]]

ffi.cdef[[
DWORD
__stdcall
InitiateShutdownA(
     LPSTR lpMachineName,
     LPSTR lpMessage,
         DWORD dwGracePeriod,
         DWORD dwShutdownFlags,
         DWORD dwReason
    );

DWORD
__stdcall
InitiateShutdownW(
     LPWSTR lpMachineName,
     LPWSTR lpMessage,
         DWORD dwGracePeriod,
         DWORD dwShutdownFlags,
         DWORD dwReason
    );
]]

--[[
#ifdef UNICODE
#define InitiateShutdown  InitiateShutdownW
#else
#define InitiateShutdown  InitiateShutdownA
end // !UNICODE
--]]

ffi.cdef[[
DWORD
__stdcall
CheckForHiberboot(
     PBOOLEAN pHiberboot,
     BOOLEAN bClearFlag
    );


LSTATUS
__stdcall
RegSaveKeyExA(
     HKEY hKey,
     LPCSTR lpFile,
     const LPSECURITY_ATTRIBUTES lpSecurityAttributes,
     DWORD Flags
    );


LSTATUS
__stdcall
RegSaveKeyExW(
     HKEY hKey,
     LPCWSTR lpFile,
     const LPSECURITY_ATTRIBUTES lpSecurityAttributes,
     DWORD Flags
    );
]]

--[[
#ifdef UNICODE
#define RegSaveKeyEx  RegSaveKeyExW
#else
#define RegSaveKeyEx  RegSaveKeyExA
end // !UNICODE
--]]

end --// WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


