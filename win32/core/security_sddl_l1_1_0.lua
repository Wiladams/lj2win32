-- security-sddl-l1-1-0.dll	
--api-ms-win-security-sddl-l1-1-0.dll	

local ffi = require("ffi");

require("win32.wtypes");
require("win32.winnt");


ffi.cdef[[
BOOL
ConvertSecurityDescriptorToStringSecurityDescriptorW(
    PSECURITY_DESCRIPTOR  SecurityDescriptor,
    DWORD RequestedStringSDRevision,
    SECURITY_INFORMATION SecurityInformation,
    LPWSTR  *StringSecurityDescriptor,
    PULONG StringSecurityDescriptorLen
    );

BOOL
ConvertSidToStringSidW(PSID Sid, LPWSTR  *StringSid);

BOOL
ConvertStringSecurityDescriptorToSecurityDescriptorW(
     LPCWSTR StringSecurityDescriptor,
     DWORD StringSDRevision,
    PSECURITY_DESCRIPTOR  *SecurityDescriptor,
    PULONG  SecurityDescriptorSize
    );

BOOL
ConvertStringSidToSidW(
    LPCWSTR   StringSid,
    PSID   *Sid
    );
]]

--local advapiLib = ffi.load("advapi32");
local Lib = ffi.load("api-ms-win-security-sddl-l1-1-0");

return {
    Lib = Lib,
    
	ConvertSecurityDescriptorToStringSecurityDescriptorW = Lib.ConvertSecurityDescriptorToStringSecurityDescriptorW,
	ConvertSidToStringSidW = Lib.ConvertSidToStringSidW,
	ConvertStringSecurityDescriptorToSecurityDescriptorW= Lib.ConvertStringSecurityDescriptorToSecurityDescriptorW,
	ConvertStringSidToSidW = Lib.ConvertStringSidToSidW,
}
