-- security_lsalookup_l2_1_0.lua
-- api-ms-win-security-lsalookup-l2-1-0.dll

local ffi = require("ffi");	

require("win32.ntstatus");
require("win32.winnt");
require("win32.ntsecapi");

ffi.cdef[[

NTSTATUS
LsaEnumerateTrustedDomains(
    LSA_HANDLE PolicyHandle,
    PLSA_ENUMERATION_HANDLE EnumerationContext,
    PVOID *Buffer,
    ULONG PreferedMaximumLength,
    PULONG CountReturned
    );
]]

local Lib = ffi.load("api-ms-win-security-lsalookup-l2-1-0");

return {
    Lib = Lib,

	LsaEnumerateTrustedDomains = Lib.LsaEnumerateTrustedDomains,
}

