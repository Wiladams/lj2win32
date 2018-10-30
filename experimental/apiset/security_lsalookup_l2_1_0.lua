-- security_lsalookup_l2_1_0.lua
-- api-ms-win-security-lsalookup-l2-1-0.dll

local ffi = require("ffi");	

require("win32.ntstatus");
require("win32.winnt");
require("win32.ntsecapi");


ffi.cdef[[
BOOL
LookupAccountNameW(
    LPCWSTR lpSystemName,
    LPCWSTR lpAccountName,
    PSID Sid,
    LPDWORD cbSid,
    LPWSTR ReferencedDomainName,
    LPDWORD cchReferencedDomainName,
    PSID_NAME_USE peUse
    );

BOOL
LookupAccountSidW(
    LPCWSTR lpSystemName,
    PSID Sid,
    LPWSTR Name,
    LPDWORD cchName,
    LPWSTR ReferencedDomainName,
    LPDWORD cchReferencedDomainName,
    PSID_NAME_USE peUse
    );

BOOL
LookupPrivilegeDisplayNameW(
    LPCWSTR lpSystemName,
    LPCWSTR lpName,
    LPWSTR lpDisplayName,
    LPDWORD cchDisplayName,
    LPDWORD lpLanguageId
    );

BOOL
LookupPrivilegeNameW(
    LPCWSTR lpSystemName,
    PLUID   lpLuid,
    LPWSTR lpName,
    LPDWORD cchName
    );

BOOL
LookupPrivilegeValueW(
    LPCWSTR lpSystemName,
    LPCWSTR lpName,
    PLUID   lpLuid
    );

NTSTATUS
LsaEnumerateTrustedDomains(
    LSA_HANDLE PolicyHandle,
    PLSA_ENUMERATION_HANDLE EnumerationContext,
    PVOID *Buffer,
    ULONG PreferedMaximumLength,
    PULONG CountReturned
    );
]]

--local advapiLib = ffi.load("advapi32");
local Lib = ffi.load("api-ms-win-security-lsalookup-l2-1-0");

return {
    Lib = Lib,
    
	LookupAccountNameW = Lib.LookupAccountNameW,
	LookupAccountSidW = Lib.LookupAccountSidW,
	LookupPrivilegeDisplayNameW = Lib.LookupPrivilegeDisplayNameW,
	LookupPrivilegeNameW = Lib.LookupPrivilegeNameW,
	LookupPrivilegeValueW = Lib.LookupPrivilegeValueW,
	LsaEnumerateTrustedDomains = Lib.LsaEnumerateTrustedDomains,
}

