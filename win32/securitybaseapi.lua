
-- securitybaseapi.h -- ApiSet Contract for api-ms-win-security-base-l1          *

local ffi = require("ffi")
local C = ffi.C 



if not _APISECUREBASE_ then
_APISECUREBASE_ = true

--#include <apiset.h>
--#include <apisetcconv.h>
require("win32.minwindef")
require("win32.minwinbase")



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
AccessCheck(
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
     HANDLE ClientToken,
     DWORD DesiredAccess,
     PGENERIC_MAPPING GenericMapping,
     PPRIVILEGE_SET PrivilegeSet,
     LPDWORD PrivilegeSetLength,
     LPDWORD GrantedAccess,
     LPBOOL AccessStatus);

BOOL
__stdcall
AccessCheckAndAuditAlarmW(
     LPCWSTR SubsystemName,
     LPVOID HandleId,
     LPWSTR ObjectTypeName,
     LPWSTR ObjectName,
     PSECURITY_DESCRIPTOR SecurityDescriptor,
     DWORD DesiredAccess,
     PGENERIC_MAPPING GenericMapping,
     BOOL ObjectCreation,
     LPDWORD GrantedAccess,
     LPBOOL AccessStatus,
     LPBOOL pfGenerateOnClose
    );
]]

--[[
#ifdef UNICODE
#define AccessCheckAndAuditAlarm  AccessCheckAndAuditAlarmW
#endif
--]]

ffi.cdef[[
BOOL
__stdcall
AccessCheckByType(
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
     PSID PrincipalSelfSid,
     HANDLE ClientToken,
     DWORD DesiredAccess,
     POBJECT_TYPE_LIST ObjectTypeList,
     DWORD ObjectTypeListLength,
     PGENERIC_MAPPING GenericMapping,
     PPRIVILEGE_SET PrivilegeSet,
     LPDWORD PrivilegeSetLength,
     LPDWORD GrantedAccess,
     LPBOOL AccessStatus
    );



BOOL
__stdcall
AccessCheckByTypeResultList(
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
     PSID PrincipalSelfSid,
     HANDLE ClientToken,
     DWORD DesiredAccess,
     POBJECT_TYPE_LIST ObjectTypeList,
     DWORD ObjectTypeListLength,
     PGENERIC_MAPPING GenericMapping,
     PPRIVILEGE_SET PrivilegeSet,
     LPDWORD PrivilegeSetLength,
     LPDWORD GrantedAccessList,
     LPDWORD AccessStatusList
    );



BOOL
__stdcall
AccessCheckByTypeAndAuditAlarmW(
     LPCWSTR SubsystemName,
     LPVOID HandleId,
     LPCWSTR ObjectTypeName,
     LPCWSTR ObjectName,
     PSECURITY_DESCRIPTOR SecurityDescriptor,
     PSID PrincipalSelfSid,
     DWORD DesiredAccess,
     AUDIT_EVENT_TYPE AuditType,
     DWORD Flags,
     POBJECT_TYPE_LIST ObjectTypeList,
     DWORD ObjectTypeListLength,
     PGENERIC_MAPPING GenericMapping,
     BOOL ObjectCreation,
     LPDWORD GrantedAccess,
     LPBOOL AccessStatus,
     LPBOOL pfGenerateOnClose
    );
]]

--[[
#ifdef UNICODE
#define AccessCheckByTypeAndAuditAlarm  AccessCheckByTypeAndAuditAlarmW
#endif
--]]

ffi.cdef[[
BOOL
__stdcall
AccessCheckByTypeResultListAndAuditAlarmW(
     LPCWSTR SubsystemName,
     LPVOID HandleId,
     LPCWSTR ObjectTypeName,
     LPCWSTR ObjectName,
     PSECURITY_DESCRIPTOR SecurityDescriptor,
     PSID PrincipalSelfSid,
     DWORD DesiredAccess,
     AUDIT_EVENT_TYPE AuditType,
     DWORD Flags,
     POBJECT_TYPE_LIST ObjectTypeList,
     DWORD ObjectTypeListLength,
     PGENERIC_MAPPING GenericMapping,
     BOOL ObjectCreation,
     LPDWORD GrantedAccessList,
     LPDWORD AccessStatusList,
     LPBOOL pfGenerateOnClose
    );
]]

--[[
#ifdef UNICODE
#define AccessCheckByTypeResultListAndAuditAlarm  AccessCheckByTypeResultListAndAuditAlarmW
#endif
--]]

ffi.cdef[[
BOOL
__stdcall
AccessCheckByTypeResultListAndAuditAlarmByHandleW(
     LPCWSTR SubsystemName,
     LPVOID HandleId,
     HANDLE ClientToken,
     LPCWSTR ObjectTypeName,
     LPCWSTR ObjectName,
     PSECURITY_DESCRIPTOR SecurityDescriptor,
     PSID PrincipalSelfSid,
     DWORD DesiredAccess,
     AUDIT_EVENT_TYPE AuditType,
     DWORD Flags,
     POBJECT_TYPE_LIST ObjectTypeList,
     DWORD ObjectTypeListLength,
     PGENERIC_MAPPING GenericMapping,
     BOOL ObjectCreation,
     LPDWORD GrantedAccessList,
     LPDWORD AccessStatusList,
     LPBOOL pfGenerateOnClose
    );
]]

--[[
#ifdef UNICODE
#define AccessCheckByTypeResultListAndAuditAlarmByHandle  AccessCheckByTypeResultListAndAuditAlarmByHandleW
#endif
--]]
end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
AddAccessAllowedAce(
     PACL pAcl,
     DWORD dwAceRevision,
     DWORD AccessMask,
     PSID pSid
    );



BOOL
__stdcall
AddAccessAllowedAceEx(
     PACL pAcl,
     DWORD dwAceRevision,
     DWORD AceFlags,
     DWORD AccessMask,
     PSID pSid
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
AddAccessAllowedObjectAce(
     PACL pAcl,
     DWORD dwAceRevision,
     DWORD AceFlags,
     DWORD AccessMask,
     GUID* ObjectTypeGuid,
     GUID* InheritedObjectTypeGuid,
     PSID pSid
    );



BOOL
__stdcall
AddAccessDeniedAce(
     PACL pAcl,
     DWORD dwAceRevision,
     DWORD AccessMask,
     PSID pSid
    );



BOOL
__stdcall
AddAccessDeniedAceEx(
     PACL pAcl,
     DWORD dwAceRevision,
     DWORD AceFlags,
     DWORD AccessMask,
     PSID pSid
    );



BOOL
__stdcall
AddAccessDeniedObjectAce(
     PACL pAcl,
     DWORD dwAceRevision,
     DWORD AceFlags,
     DWORD AccessMask,
     GUID* ObjectTypeGuid,
     GUID* InheritedObjectTypeGuid,
     PSID pSid
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
AddAce(
     PACL pAcl,
     DWORD dwAceRevision,
     DWORD dwStartingAceIndex,
     LPVOID pAceList,
     DWORD nAceListLength
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
AddAuditAccessAce(
     PACL pAcl,
     DWORD dwAceRevision,
     DWORD dwAccessMask,
     PSID pSid,
     BOOL bAuditSuccess,
     BOOL bAuditFailure
    );



BOOL
__stdcall
AddAuditAccessAceEx(
     PACL pAcl,
     DWORD dwAceRevision,
     DWORD AceFlags,
     DWORD dwAccessMask,
     PSID pSid,
     BOOL bAuditSuccess,
     BOOL bAuditFailure
    );



BOOL
__stdcall
AddAuditAccessObjectAce(
     PACL pAcl,
     DWORD dwAceRevision,
     DWORD AceFlags,
     DWORD AccessMask,
     GUID* ObjectTypeGuid,
     GUID* InheritedObjectTypeGuid,
     PSID pSid,
     BOOL bAuditSuccess,
     BOOL bAuditFailure
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

if (_WIN32_WINNT >= 0x0600) then

ffi.cdef[[
BOOL
__stdcall
AddMandatoryAce(
     PACL pAcl,
     DWORD dwAceRevision,
     DWORD AceFlags,
     DWORD MandatoryPolicy,
     PSID pLabelSid
    );
]]

end  -- _WIN32_WINNT >=  0x0600 */

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


if (_WIN32_WINNT >= _WIN32_WINNT_WIN8) then


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
AddResourceAttributeAce(
     PACL pAcl,
     DWORD dwAceRevision,
     DWORD AceFlags,
     DWORD AccessMask,
     PSID pSid,
     PCLAIM_SECURITY_ATTRIBUTES_INFORMATION pAttributeInfo,
     PDWORD pReturnLength
    );



BOOL
__stdcall
AddScopedPolicyIDAce(
     PACL pAcl,
     DWORD dwAceRevision,
     DWORD AceFlags,
     DWORD AccessMask,
     PSID pSid
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


end  -- (_WIN32_WINNT >= _WIN32_WINNT_WIN8)


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
AdjustTokenGroups(
     HANDLE TokenHandle,
     BOOL ResetToDefault,
     PTOKEN_GROUPS NewState,
     DWORD BufferLength,
     PTOKEN_GROUPS PreviousState,
     PDWORD ReturnLength
    );



BOOL
__stdcall
AdjustTokenPrivileges(
     HANDLE TokenHandle,
     BOOL DisableAllPrivileges,
     PTOKEN_PRIVILEGES NewState,
     DWORD BufferLength,
     PTOKEN_PRIVILEGES PreviousState,
     PDWORD ReturnLength
    );



BOOL
__stdcall
AllocateAndInitializeSid(
     PSID_IDENTIFIER_AUTHORITY pIdentifierAuthority,
     BYTE nSubAuthorityCount,
     DWORD nSubAuthority0,
     DWORD nSubAuthority1,
     DWORD nSubAuthority2,
     DWORD nSubAuthority3,
     DWORD nSubAuthority4,
     DWORD nSubAuthority5,
     DWORD nSubAuthority6,
     DWORD nSubAuthority7,
     PSID* pSid
    );



BOOL
__stdcall
AllocateLocallyUniqueId(
     PLUID Luid
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
AreAllAccessesGranted(
     DWORD GrantedAccess,
     DWORD DesiredAccess
    );



BOOL
__stdcall
AreAnyAccessesGranted(
     DWORD GrantedAccess,
     DWORD DesiredAccess
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
CheckTokenMembership(
     HANDLE TokenHandle,
     PSID SidToCheck,
     PBOOL IsMember
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


if (_WIN32_WINNT >= _WIN32_WINNT_WIN8) then


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
CheckTokenCapability(
     HANDLE TokenHandle,
     PSID CapabilitySidToCheck,
     PBOOL HasCapability
    );



BOOL
__stdcall
GetAppContainerAce(
     PACL Acl,
     DWORD StartingAceIndex,
     PVOID* AppContainerAce,
     DWORD* AppContainerAceIndex
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
CheckTokenMembershipEx(
     HANDLE TokenHandle,
     PSID SidToCheck,
     DWORD Flags,
     PBOOL IsMember
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


end  -- (_WIN32_WINNT >= _WIN32_WINNT_WIN8)


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
ConvertToAutoInheritPrivateObjectSecurity(
     PSECURITY_DESCRIPTOR ParentDescriptor,
     PSECURITY_DESCRIPTOR CurrentSecurityDescriptor,
     PSECURITY_DESCRIPTOR* NewSecurityDescriptor,
     GUID* ObjectType,
     BOOLEAN IsDirectoryObject,
     PGENERIC_MAPPING GenericMapping
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
CopySid(
     DWORD nDestinationSidLength,
     PSID pDestinationSid,
     PSID pSourceSid
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
CreatePrivateObjectSecurity(
     PSECURITY_DESCRIPTOR ParentDescriptor,
     PSECURITY_DESCRIPTOR CreatorDescriptor,
     PSECURITY_DESCRIPTOR* NewDescriptor,
     BOOL IsDirectoryObject,
     HANDLE Token,
     PGENERIC_MAPPING GenericMapping
    );



BOOL
__stdcall
CreatePrivateObjectSecurityEx(
     PSECURITY_DESCRIPTOR ParentDescriptor,
     PSECURITY_DESCRIPTOR CreatorDescriptor,
     PSECURITY_DESCRIPTOR* NewDescriptor,
     GUID* ObjectType,
     BOOL IsContainerObject,
     ULONG AutoInheritFlags,
     HANDLE Token,
     PGENERIC_MAPPING GenericMapping
    );



BOOL
__stdcall
CreatePrivateObjectSecurityWithMultipleInheritance(
     PSECURITY_DESCRIPTOR ParentDescriptor,
     PSECURITY_DESCRIPTOR CreatorDescriptor,
     PSECURITY_DESCRIPTOR* NewDescriptor,
     GUID** ObjectTypes,
     ULONG GuidCount,
     BOOL IsContainerObject,
     ULONG AutoInheritFlags,
     HANDLE Token,
     PGENERIC_MAPPING GenericMapping
    );



BOOL
__stdcall
CreateRestrictedToken(
     HANDLE ExistingTokenHandle,
     DWORD Flags,
     DWORD DisableSidCount,
     PSID_AND_ATTRIBUTES SidsToDisable,
     DWORD DeletePrivilegeCount,
     PLUID_AND_ATTRIBUTES PrivilegesToDelete,
     DWORD RestrictedSidCount,
     PSID_AND_ATTRIBUTES SidsToRestrict,
     PHANDLE NewTokenHandle);
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

if (_WIN32_WINNT >= 0x0501) then


ffi.cdef[[
BOOL
__stdcall
CreateWellKnownSid(
     WELL_KNOWN_SID_TYPE WellKnownSidType,
     PSID DomainSid,
     PSID pSid,
     DWORD* cbSid
    );




BOOL
__stdcall
EqualDomainSid(
     PSID pSid1,
     PSID pSid2,
     BOOL* pfEqual
    );
]]

end  --(_WIN32_WINNT >= 0x0501)

ffi.cdef[[
BOOL
__stdcall
DeleteAce(
     PACL pAcl,
     DWORD dwAceIndex
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
DestroyPrivateObjectSecurity(
      PSECURITY_DESCRIPTOR* ObjectDescriptor
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
DuplicateToken(
     HANDLE ExistingTokenHandle,
     SECURITY_IMPERSONATION_LEVEL ImpersonationLevel,
     PHANDLE DuplicateTokenHandle
    );



BOOL
__stdcall
DuplicateTokenEx(
     HANDLE hExistingToken,
     DWORD dwDesiredAccess,
     LPSECURITY_ATTRIBUTES lpTokenAttributes,
     SECURITY_IMPERSONATION_LEVEL ImpersonationLevel,
     TOKEN_TYPE TokenType,
     PHANDLE phNewToken
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
EqualPrefixSid(
     PSID pSid1,
     PSID pSid2
    );



BOOL
__stdcall
EqualSid(
     PSID pSid1,
     PSID pSid2
    );



BOOL
__stdcall
FindFirstFreeAce(
     PACL pAcl,
     LPVOID* pAce
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
PVOID
__stdcall
FreeSid(
     PSID pSid
    );



BOOL
__stdcall
GetAce(
     PACL pAcl,
     DWORD dwAceIndex,
     LPVOID* pAce
    );



BOOL
__stdcall
GetAclInformation(
     PACL pAcl,
     LPVOID pAclInformation,
     DWORD nAclInformationLength,
     ACL_INFORMATION_CLASS dwAclInformationClass
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
GetFileSecurityW(
     LPCWSTR lpFileName,
     SECURITY_INFORMATION RequestedInformation,
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
     DWORD nLength,
     LPDWORD lpnLengthNeeded
    );
]]

--[[
#ifdef UNICODE
#define GetFileSecurity  GetFileSecurityW
#endif
--]]
end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
GetKernelObjectSecurity(
     HANDLE Handle,
     SECURITY_INFORMATION RequestedInformation,
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
     DWORD nLength,
     LPDWORD lpnLengthNeeded
    );





DWORD
__stdcall
GetLengthSid(
      PSID pSid
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


ffi.cdef[[
BOOL
__stdcall
GetPrivateObjectSecurity(
     PSECURITY_DESCRIPTOR ObjectDescriptor,
     SECURITY_INFORMATION SecurityInformation,
     PSECURITY_DESCRIPTOR ResultantDescriptor,
     DWORD DescriptorLength,
     PDWORD ReturnLength
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
GetSecurityDescriptorControl(
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
     PSECURITY_DESCRIPTOR_CONTROL pControl,
     LPDWORD lpdwRevision
    );



BOOL
__stdcall
GetSecurityDescriptorDacl(
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
     LPBOOL lpbDaclPresent,
     PACL* pDacl,
     LPBOOL lpbDaclDefaulted
    );



BOOL
__stdcall
GetSecurityDescriptorGroup(
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
     PSID* pGroup,
     LPBOOL lpbGroupDefaulted
    );



DWORD
__stdcall
GetSecurityDescriptorLength(
     PSECURITY_DESCRIPTOR pSecurityDescriptor
    );



BOOL
__stdcall
GetSecurityDescriptorOwner(
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
     PSID* pOwner,
     LPBOOL lpbOwnerDefaulted
    );



DWORD
__stdcall
GetSecurityDescriptorRMControl(
     PSECURITY_DESCRIPTOR SecurityDescriptor,
     PUCHAR RMControl
    );



BOOL
__stdcall
GetSecurityDescriptorSacl(
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
     LPBOOL lpbSaclPresent,
     PACL* pSacl,
     LPBOOL lpbSaclDefaulted
    );



PSID_IDENTIFIER_AUTHORITY
__stdcall
GetSidIdentifierAuthority(
     PSID pSid
    );



DWORD
__stdcall
GetSidLengthRequired(
     UCHAR nSubAuthorityCount
    );



PDWORD
__stdcall
GetSidSubAuthority(
     PSID pSid,
     DWORD nSubAuthority
    );



PUCHAR
__stdcall
GetSidSubAuthorityCount(
     PSID pSid
    );



BOOL
__stdcall
GetTokenInformation(
     HANDLE TokenHandle,
     TOKEN_INFORMATION_CLASS TokenInformationClass,
     LPVOID TokenInformation,
     DWORD TokenInformationLength,
     PDWORD ReturnLength
    );
]]

if (_WIN32_WINNT >= 0x0501) then


ffi.cdef[[
BOOL
__stdcall
GetWindowsAccountDomainSid(
     PSID pSid,
     PSID pDomainSid,
     DWORD* cbDomainSid
    );
]]

end  --(_WIN32_WINNT >= 0x0501)

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
ImpersonateAnonymousToken(
     HANDLE ThreadHandle
    );




BOOL
__stdcall
ImpersonateLoggedOnUser(
     HANDLE hToken
    );




BOOL
__stdcall
ImpersonateSelf(
     SECURITY_IMPERSONATION_LEVEL ImpersonationLevel
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
InitializeAcl(
     PACL pAcl,
     DWORD nAclLength,
     DWORD dwAclRevision
    );



BOOL
__stdcall
InitializeSecurityDescriptor(
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
     DWORD dwRevision
    );



BOOL
__stdcall
InitializeSid(
     PSID Sid,
     PSID_IDENTIFIER_AUTHORITY pIdentifierAuthority,
     BYTE nSubAuthorityCount
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
IsTokenRestricted(
     HANDLE TokenHandle
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
IsValidAcl(
     PACL pAcl
    );



BOOL
__stdcall
IsValidSecurityDescriptor(
     PSECURITY_DESCRIPTOR pSecurityDescriptor
    );



BOOL
__stdcall
IsValidSid(
     PSID pSid
    );
]]

if (_WIN32_WINNT >= 0x0501) then

ffi.cdef[[
BOOL
__stdcall
IsWellKnownSid(
     PSID pSid,
     WELL_KNOWN_SID_TYPE WellKnownSidType
    );
]]

end  -- (_WIN32_WINNT >= 0x0501)


ffi.cdef[[
BOOL
__stdcall
MakeAbsoluteSD(
     PSECURITY_DESCRIPTOR pSelfRelativeSecurityDescriptor,
     PSECURITY_DESCRIPTOR pAbsoluteSecurityDescriptor,
     LPDWORD lpdwAbsoluteSecurityDescriptorSize,
     PACL pDacl,
     LPDWORD lpdwDaclSize,
     PACL pSacl,
     LPDWORD lpdwSaclSize,
     PSID pOwner,
     LPDWORD lpdwOwnerSize,
     PSID pPrimaryGroup,
     LPDWORD lpdwPrimaryGroupSize);

BOOL
__stdcall
MakeSelfRelativeSD(
     PSECURITY_DESCRIPTOR pAbsoluteSecurityDescriptor,
     PSECURITY_DESCRIPTOR pSelfRelativeSecurityDescriptor,
     LPDWORD lpdwBufferLength);
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
VOID
__stdcall
MapGenericMask(
     PDWORD AccessMask,
     PGENERIC_MAPPING GenericMapping
    );

BOOL
__stdcall
ObjectCloseAuditAlarmW(
     LPCWSTR SubsystemName,
     LPVOID HandleId,
     BOOL GenerateOnClose);
]]

--[[
#ifdef UNICODE
#define ObjectCloseAuditAlarm  ObjectCloseAuditAlarmW
#endif
--]]

ffi.cdef[[
BOOL
__stdcall
ObjectDeleteAuditAlarmW(
     LPCWSTR SubsystemName,
     LPVOID HandleId,
     BOOL GenerateOnClose);
]]

--[[
#ifdef UNICODE
#define ObjectDeleteAuditAlarm  ObjectDeleteAuditAlarmW
#endif
--]]

ffi.cdef[[
BOOL
__stdcall
ObjectOpenAuditAlarmW(
     LPCWSTR SubsystemName,
     LPVOID HandleId,
     LPWSTR ObjectTypeName,
     LPWSTR ObjectName,
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
     HANDLE ClientToken,
     DWORD DesiredAccess,
     DWORD GrantedAccess,
     PPRIVILEGE_SET Privileges,
     BOOL ObjectCreation,
     BOOL AccessGranted,
     LPBOOL GenerateOnClose);
]]

--[[
#ifdef UNICODE
#define ObjectOpenAuditAlarm  ObjectOpenAuditAlarmW
#endif
--]]

ffi.cdef[[
BOOL
__stdcall
ObjectPrivilegeAuditAlarmW(
     LPCWSTR SubsystemName,
     LPVOID HandleId,
     HANDLE ClientToken,
     DWORD DesiredAccess,
     PPRIVILEGE_SET Privileges,
     BOOL AccessGranted);
]]

--[[
#ifdef UNICODE
#define ObjectPrivilegeAuditAlarm  ObjectPrivilegeAuditAlarmW
#endif
--]]

ffi.cdef[[
BOOL
__stdcall
PrivilegeCheck(
     HANDLE ClientToken,
     PPRIVILEGE_SET RequiredPrivileges,
     LPBOOL pfResult);



BOOL
__stdcall
PrivilegedServiceAuditAlarmW(
     LPCWSTR SubsystemName,
     LPCWSTR ServiceName,
     HANDLE ClientToken,
     PPRIVILEGE_SET Privileges,
     BOOL AccessGranted);
]]

--[[
#ifdef UNICODE
#define PrivilegedServiceAuditAlarm  PrivilegedServiceAuditAlarmW
#endif
--]]

if (_WIN32_WINNT >= 0x0600) then

ffi.cdef[[
VOID
__stdcall
QuerySecurityAccessMask(
     SECURITY_INFORMATION SecurityInformation,
     LPDWORD DesiredAccess);
]]

end  -- (_WIN32_WINNT >= 0x0600)

ffi.cdef[[
BOOL
__stdcall
RevertToSelf(VOID);



BOOL
__stdcall
SetAclInformation(
     PACL pAcl,
     LPVOID pAclInformation,
     DWORD nAclInformationLength,
     ACL_INFORMATION_CLASS dwAclInformationClass);



BOOL
__stdcall
SetFileSecurityW(
     LPCWSTR lpFileName,
     SECURITY_INFORMATION SecurityInformation,
     PSECURITY_DESCRIPTOR pSecurityDescriptor);
]]

--[[
#ifdef UNICODE
#define SetFileSecurity  SetFileSecurityW
#endif
--]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
SetKernelObjectSecurity(
     HANDLE Handle,
     SECURITY_INFORMATION SecurityInformation,
     PSECURITY_DESCRIPTOR SecurityDescriptor);
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
SetPrivateObjectSecurity(
     SECURITY_INFORMATION SecurityInformation,
     PSECURITY_DESCRIPTOR ModificationDescriptor,
     PSECURITY_DESCRIPTOR* ObjectsSecurityDescriptor,
     PGENERIC_MAPPING GenericMapping,
     HANDLE Token);

BOOL
__stdcall
SetPrivateObjectSecurityEx(
     SECURITY_INFORMATION SecurityInformation,
     PSECURITY_DESCRIPTOR ModificationDescriptor,
     PSECURITY_DESCRIPTOR* ObjectsSecurityDescriptor,
     ULONG AutoInheritFlags,
     PGENERIC_MAPPING GenericMapping,
     HANDLE Token);
]]

if (_WIN32_WINNT >= 0x0600) then

ffi.cdef[[
VOID
__stdcall
SetSecurityAccessMask(
     SECURITY_INFORMATION SecurityInformation,
     LPDWORD DesiredAccess);
]]

end  -- (_WIN32_WINNT >= 0x0600)

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
SetSecurityDescriptorControl(
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
     SECURITY_DESCRIPTOR_CONTROL ControlBitsOfInterest,
     SECURITY_DESCRIPTOR_CONTROL ControlBitsToSet);



BOOL
__stdcall
SetSecurityDescriptorDacl(
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
     BOOL bDaclPresent,
     PACL pDacl,
     BOOL bDaclDefaulted);



BOOL
__stdcall
SetSecurityDescriptorGroup(
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
     PSID pGroup,
     BOOL bGroupDefaulted);



BOOL
__stdcall
SetSecurityDescriptorOwner(
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
     PSID pOwner,
     BOOL bOwnerDefaulted);

DWORD
__stdcall
SetSecurityDescriptorRMControl(
     PSECURITY_DESCRIPTOR SecurityDescriptor,
     PUCHAR RMControl);

BOOL
__stdcall
SetSecurityDescriptorSacl(
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
     BOOL bSaclPresent,
     PACL pSacl,
     BOOL bSaclDefaulted);

BOOL
__stdcall
SetTokenInformation(
     HANDLE TokenHandle,
     TOKEN_INFORMATION_CLASS TokenInformationClass,
     LPVOID TokenInformation,
     DWORD TokenInformationLength
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


if (_WIN32_WINNT >= _WIN32_WINNT_WIN8) then


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
SetCachedSigningLevel(
     PHANDLE SourceFiles,
     ULONG SourceFileCount,
     ULONG Flags,
     HANDLE TargetFile
    );



BOOL
__stdcall
GetCachedSigningLevel(
     HANDLE File,
     PULONG Flags,
     PULONG SigningLevel,
     PUCHAR Thumbprint,
     PULONG ThumbprintSize,
     PULONG ThumbprintAlgorithm
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


end  -- (_WIN32_WINNT >= _WIN32_WINNT_WIN8)
 
if (_WIN32_WINNT >= _WIN32_WINNT_WIN10) then


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
LONG
__stdcall
CveEventWrite(
     PCWSTR CveId,
     PCWSTR AdditionalDetails
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


end  -- (_WIN32_WINNT >= _WIN32_WINNT_WIN10)
if (_WIN32_WINNT >= _WIN32_WINNT_WIN10) then


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
DeriveCapabilitySidsFromName(
     LPCWSTR CapName,
     PSID** CapabilityGroupSids,
     DWORD* CapabilityGroupSidCount,
     PSID** CapabilitySids,
     DWORD* CapabilitySidCount
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


end  -- (_WIN32_WINNT >= _WIN32_WINNT_WIN10)
 


end  -- _APISECUREBASE_

return ffi.load("advapi32")