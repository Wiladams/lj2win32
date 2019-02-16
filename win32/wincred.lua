local ffi = require("ffi")
local C = ffi.C 


require("win32.winapifamily")

--require("win32.minwindef")
--require("win32.minwinbase")
require("win32.windef")

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

if not __SECHANDLE_DEFINED__ then
ffi.cdef[[
typedef struct _SecHandle
{
    ULONG_PTR dwLower ;
    ULONG_PTR dwUpper ;
} SecHandle, * PSecHandle ;
]]
__SECHANDLE_DEFINED__ = true
end -- __SECHANDLE_DEFINED__

ffi.cdef[[
typedef PSecHandle PCtxtHandle;
]]

if not _WINBASE_ then
if not _FILETIME_ then
_FILETIME_ = true
ffi.cdef[[
typedef struct _FILETIME
    {
    DWORD dwLowDateTime;
    DWORD dwHighDateTime;
    }   FILETIME;

typedef struct _FILETIME *PFILETIME;
typedef struct _FILETIME *LPFILETIME;
]]
end -- !_FILETIME
end -- _WINBASE_


if not _NTDEF_ then
ffi.cdef[[
typedef LONG NTSTATUS, *PNTSTATUS;
]]
end


--[=[
// Dont require ntstatus.h
#define STATUS_LOGON_FAILURE             ((NTSTATUS)0xC000006DL)     // ntsubauth
#define STATUS_WRONG_PASSWORD            ((NTSTATUS)0xC000006AL)     // ntsubauth
#define STATUS_PASSWORD_EXPIRED          ((NTSTATUS)0xC0000071L)     // ntsubauth
#define STATUS_PASSWORD_MUST_CHANGE      ((NTSTATUS)0xC0000224L)    // ntsubauth
#define STATUS_ACCESS_DENIED             ((NTSTATUS)0xC0000022L)
#define STATUS_DOWNGRADE_DETECTED        ((NTSTATUS)0xC0000388L)
#define STATUS_AUTHENTICATION_FIREWALL_FAILED ((NTSTATUS)0xC0000413L)
#define STATUS_ACCOUNT_DISABLED          ((NTSTATUS)0xC0000072L)     // ntsubauth
#define STATUS_ACCOUNT_RESTRICTION       ((NTSTATUS)0xC000006EL)     // ntsubauth
#define STATUS_ACCOUNT_LOCKED_OUT        ((NTSTATUS)0xC0000234L)    // ntsubauth
#define STATUS_ACCOUNT_EXPIRED           ((NTSTATUS)0xC0000193L)    // ntsubauth
#define STATUS_LOGON_TYPE_NOT_GRANTED    ((NTSTATUS)0xC000015BL)
#define STATUS_NO_SUCH_LOGON_SESSION     ((NTSTATUS)0xC000005FL)
#define STATUS_NO_SUCH_USER              ((NTSTATUS)0xC0000064L)     // ntsubauth

// Don't require lmerr.h
#define NERR_BASE       2100
#define NERR_PasswordExpired    (NERR_BASE+142) /* The password of this user has expired. */

#define CREDUIP_IS_USER_PASSWORD_ERROR( _Status ) ( \
        (_Status) == ERROR_LOGON_FAILURE || \
        (_Status) == __HRESULT_FROM_WIN32( ERROR_LOGON_FAILURE ) || \
        (_Status) == STATUS_LOGON_FAILURE || \
        (_Status) == HRESULT_FROM_NT( STATUS_LOGON_FAILURE ) || \
        (_Status) == ERROR_ACCESS_DENIED || \
        (_Status) == __HRESULT_FROM_WIN32( ERROR_ACCESS_DENIED ) || \
        (_Status) == STATUS_ACCESS_DENIED || \
        (_Status) == HRESULT_FROM_NT( STATUS_ACCESS_DENIED ) || \
        (_Status) == ERROR_INVALID_PASSWORD || \
        (_Status) == __HRESULT_FROM_WIN32( ERROR_INVALID_PASSWORD ) || \
        (_Status) == STATUS_WRONG_PASSWORD || \
        (_Status) == HRESULT_FROM_NT( STATUS_WRONG_PASSWORD ) || \
        (_Status) == STATUS_NO_SUCH_USER || \
        (_Status) == HRESULT_FROM_NT( STATUS_NO_SUCH_USER ) || \
        (_Status) == ERROR_NO_SUCH_USER || \
        (_Status) == __HRESULT_FROM_WIN32( ERROR_NO_SUCH_USER ) || \
        (_Status) == ERROR_NO_SUCH_LOGON_SESSION || \
        (_Status) == __HRESULT_FROM_WIN32( ERROR_NO_SUCH_LOGON_SESSION ) || \
        (_Status) == STATUS_NO_SUCH_LOGON_SESSION || \
        (_Status) == HRESULT_FROM_NT( STATUS_NO_SUCH_LOGON_SESSION ) || \
        (_Status) == SEC_E_NO_CREDENTIALS || \
        (_Status) == SEC_E_LOGON_DENIED || \
        (_Status) == SEC_E_NO_CONTEXT || \
        (_Status) == STATUS_NO_SECURITY_CONTEXT )

#define CREDUIP_IS_DOWNGRADE_ERROR( _Status ) ( \
        (_Status) == ERROR_DOWNGRADE_DETECTED || \
        (_Status) == __HRESULT_FROM_WIN32( ERROR_DOWNGRADE_DETECTED ) || \
        (_Status) == STATUS_DOWNGRADE_DETECTED || \
        (_Status) == HRESULT_FROM_NT( STATUS_DOWNGRADE_DETECTED ) \
)

#define CREDUIP_IS_EXPIRED_ERROR( _Status ) ( \
        (_Status) == ERROR_PASSWORD_EXPIRED || \
        (_Status) == __HRESULT_FROM_WIN32( ERROR_PASSWORD_EXPIRED ) || \
        (_Status) == STATUS_PASSWORD_EXPIRED || \
        (_Status) == HRESULT_FROM_NT( STATUS_PASSWORD_EXPIRED ) || \
        (_Status) == ERROR_PASSWORD_MUST_CHANGE || \
        (_Status) == __HRESULT_FROM_WIN32( ERROR_PASSWORD_MUST_CHANGE ) || \
        (_Status) == STATUS_PASSWORD_MUST_CHANGE || \
        (_Status) == HRESULT_FROM_NT( STATUS_PASSWORD_MUST_CHANGE ) || \
        (_Status) == NERR_PasswordExpired || \
        (_Status) == __HRESULT_FROM_WIN32( NERR_PasswordExpired ) \
)

#define CREDUI_IS_AUTHENTICATION_ERROR( _Status ) ( \
        CREDUIP_IS_USER_PASSWORD_ERROR( _Status ) || \
        CREDUIP_IS_DOWNGRADE_ERROR( _Status ) || \
        CREDUIP_IS_EXPIRED_ERROR( _Status ) \
)

#define CREDUI_NO_PROMPT_AUTHENTICATION_ERROR( _Status ) ( \
        (_Status) == ERROR_AUTHENTICATION_FIREWALL_FAILED || \
        (_Status) == __HRESULT_FROM_WIN32( ERROR_AUTHENTICATION_FIREWALL_FAILED ) || \
        (_Status) == STATUS_AUTHENTICATION_FIREWALL_FAILED || \
        (_Status) == HRESULT_FROM_NT( STATUS_AUTHENTICATION_FIREWALL_FAILED ) || \
        (_Status) == ERROR_ACCOUNT_DISABLED || \
        (_Status) == __HRESULT_FROM_WIN32( ERROR_ACCOUNT_DISABLED ) || \
        (_Status) == STATUS_ACCOUNT_DISABLED || \
        (_Status) == HRESULT_FROM_NT( STATUS_ACCOUNT_DISABLED ) || \
        (_Status) == ERROR_ACCOUNT_RESTRICTION || \
        (_Status) == __HRESULT_FROM_WIN32( ERROR_ACCOUNT_RESTRICTION ) || \
        (_Status) == STATUS_ACCOUNT_RESTRICTION || \
        (_Status) == HRESULT_FROM_NT( STATUS_ACCOUNT_RESTRICTION ) || \
        (_Status) == ERROR_ACCOUNT_LOCKED_OUT || \
        (_Status) == __HRESULT_FROM_WIN32( ERROR_ACCOUNT_LOCKED_OUT ) || \
        (_Status) == STATUS_ACCOUNT_LOCKED_OUT || \
        (_Status) == HRESULT_FROM_NT( STATUS_ACCOUNT_LOCKED_OUT ) || \
        (_Status) == ERROR_ACCOUNT_EXPIRED || \
        (_Status) == __HRESULT_FROM_WIN32( ERROR_ACCOUNT_EXPIRED ) || \
        (_Status) == STATUS_ACCOUNT_EXPIRED || \
        (_Status) == HRESULT_FROM_NT( STATUS_ACCOUNT_EXPIRED ) || \
        (_Status) == ERROR_LOGON_TYPE_NOT_GRANTED || \
        (_Status) == __HRESULT_FROM_WIN32( ERROR_LOGON_TYPE_NOT_GRANTED ) || \
        (_Status) == STATUS_LOGON_TYPE_NOT_GRANTED || \
        (_Status) == HRESULT_FROM_NT( STATUS_LOGON_TYPE_NOT_GRANTED ) \
)
--]=]

-----------------------------------------------------------------------------
-- Structures
-----------------------------------------------------------------------------
ffi.cdef[[
//
// Credential Attribute
//

// Maximum length of the various credential string fields (in characters)
static const int CRED_MAX_STRING_LENGTH = 256;

// Maximum length of the UserName field.  The worst case is <User>@<DnsDomain>
static const int CRED_MAX_USERNAME_LENGTH = (256+1+256);

// Maximum length of the TargetName field for CRED_TYPE_GENERIC (in characters)
static const int CRED_MAX_GENERIC_TARGET_NAME_LENGTH = 32767;

// Maximum length of the TargetName field for CRED_TYPE_DOMAIN_* (in characters)
//      Largest one is <DfsRoot>\<DfsShare>
static const int CRED_MAX_DOMAIN_TARGET_NAME_LENGTH = (256+1+80);

// Maximum length of a target namespace
static const int CRED_MAX_TARGETNAME_NAMESPACE_LENGTH = (256);

// Maximum length of a target attribute
static const int CRED_MAX_TARGETNAME_ATTRIBUTE_LENGTH = (256);

// Maximum size of the Credential Attribute Value field (in bytes)
static const int CRED_MAX_VALUE_SIZE = (256);

// Maximum number of attributes per credential
static const int CRED_MAX_ATTRIBUTES = 64;
]]

ffi.cdef[[
typedef struct _CREDENTIAL_ATTRIBUTEA {
    LPSTR Keyword;
    DWORD Flags;
    DWORD ValueSize;
    LPBYTE Value;
} CREDENTIAL_ATTRIBUTEA, *PCREDENTIAL_ATTRIBUTEA;

typedef struct _CREDENTIAL_ATTRIBUTEW {
    LPWSTR  Keyword;
    DWORD Flags;
    DWORD ValueSize;
    LPBYTE Value;
} CREDENTIAL_ATTRIBUTEW, *PCREDENTIAL_ATTRIBUTEW;
]]


if UNICODE then
ffi.cdef[[
typedef CREDENTIAL_ATTRIBUTEW CREDENTIAL_ATTRIBUTE;
typedef PCREDENTIAL_ATTRIBUTEW PCREDENTIAL_ATTRIBUTE;
]]
else
ffi.cdef[[
typedef CREDENTIAL_ATTRIBUTEA CREDENTIAL_ATTRIBUTE;
typedef PCREDENTIAL_ATTRIBUTEA PCREDENTIAL_ATTRIBUTE;
]]
end --// UNICODE

--[=[
//
// Special values of the TargetName field
//
#define CRED_SESSION_WILDCARD_NAME_W L"*Session"
#define CRED_SESSION_WILDCARD_NAME_A "*Session"
#define CRED_UNIVERSAL_WILDCARD_W L'*'
#define CRED_UNIVERSAL_WILDCARD_A '*'
#define CRED_SESSION_WILDCARD_NAME_LENGTH (sizeof(CRED_SESSION_WILDCARD_NAME_A)-1)
#define CRED_TARGETNAME_DOMAIN_NAMESPACE_W L"Domain"
#define CRED_TARGETNAME_DOMAIN_NAMESPACE_A "Domain"
#define CRED_TARGETNAME_DOMAIN_NAMESPACE_LENGTH (sizeof(CRED_TARGETNAME_DOMAIN_NAMESPACE_A)-1)
#define CRED_UNIVERSAL_WILDCARD_W L'*'
#define CRED_UNIVERSAL_WILDCARD_A '*'
#define CRED_TARGETNAME_LEGACYGENERIC_NAMESPACE_W L"LegacyGeneric"
#define CRED_TARGETNAME_LEGACYGENERIC_NAMESPACE_A "LegacyGeneric"
#define CRED_TARGETNAME_LEGACYGENERIC_NAMESPACE_LENGTH (sizeof(CRED_TARGETNAME_LEGACYGENERIC_NAMESPACE_A)-1)
#define CRED_TARGETNAME_NAMESPACE_SEPERATOR_W L':'
#define CRED_TARGETNAME_NAMESPACE_SEPERATOR_A ':'
#define CRED_TARGETNAME_ATTRIBUTE_SEPERATOR_W L'='
#define CRED_TARGETNAME_ATTRIBUTE_SEPERATOR_A '='
#define CRED_TARGETNAME_DOMAIN_EXTENDED_USERNAME_SEPARATOR_W L'|'
#define CRED_TARGETNAME_DOMAIN_EXTENDED_USERNAME_SEPARATOR_A '|'
#define CRED_TARGETNAME_ATTRIBUTE_TARGET_W L"target"
#define CRED_TARGETNAME_ATTRIBUTE_TARGET_A "target"
#define CRED_TARGETNAME_ATTRIBUTE_TARGET_LENGTH (sizeof(CRED_TARGETNAME_ATTRIBUTE_TARGET_A)-1)
#define CRED_TARGETNAME_ATTRIBUTE_NAME_W L"name"
#define CRED_TARGETNAME_ATTRIBUTE_NAME_A "name"
#define CRED_TARGETNAME_ATTRIBUTE_NAME_LENGTH (sizeof(CRED_TARGETNAME_ATTRIBUTE_NAME_A)-1)
#define CRED_TARGETNAME_ATTRIBUTE_BATCH_W L"batch"
#define CRED_TARGETNAME_ATTRIBUTE_BATCH_A "batch"
#define CRED_TARGETNAME_ATTRIBUTE_BATCH_LENGTH (sizeof(CRED_TARGETNAME_ATTRIBUTE_BATCH_A)-1)
#define CRED_TARGETNAME_ATTRIBUTE_INTERACTIVE_W L"interactive"
#define CRED_TARGETNAME_ATTRIBUTE_INTERACTIVE_A "interactive"
#define CRED_TARGETNAME_ATTRIBUTE_INTERACTIVE_LENGTH (sizeof(CRED_TARGETNAME_ATTRIBUTE_INTERACTIVE_A)-1)
#define CRED_TARGETNAME_ATTRIBUTE_SERVICE_W L"service"
#define CRED_TARGETNAME_ATTRIBUTE_SERVICE_A "service"
#define CRED_TARGETNAME_ATTRIBUTE_SERVICE_LENGTH (sizeof(CRED_TARGETNAME_ATTRIBUTE_SERVICE_A)-1)
#define CRED_TARGETNAME_ATTRIBUTE_NETWORK_W L"network"
#define CRED_TARGETNAME_ATTRIBUTE_NETWORK_A "network"
#define CRED_TARGETNAME_ATTRIBUTE_NETWORK_LENGTH (sizeof(CRED_TARGETNAME_ATTRIBUTE_NETWORK_A)-1)
#define CRED_TARGETNAME_ATTRIBUTE_NETWORKCLEARTEXT_W L"networkcleartext"
#define CRED_TARGETNAME_ATTRIBUTE_NETWORKCLEARTEXT_A "networkcleartext"
#define CRED_TARGETNAME_ATTRIBUTE_NETWORKCLEARTEXT_LENGTH (sizeof(CRED_TARGETNAME_ATTRIBUTE_NETWORKCLEARTEXT_A)-1)
#define CRED_TARGETNAME_ATTRIBUTE_REMOTEINTERACTIVE_W L"remoteinteractive"
#define CRED_TARGETNAME_ATTRIBUTE_REMOTEINTERACTIVE_A "remoteinteractive"
#define CRED_TARGETNAME_ATTRIBUTE_REMOTEINTERACTIVE_LENGTH (sizeof(CRED_TARGETNAME_ATTRIBUTE_REMOTEINTERACTIVE_A)-1)
#define CRED_TARGETNAME_ATTRIBUTE_CACHEDINTERACTIVE_W L"cachedinteractive"
#define CRED_TARGETNAME_ATTRIBUTE_CACHEDINTERACTIVE_A "cachedinteractive"
#define CRED_TARGETNAME_ATTRIBUTE_CACHEDINTERACTIVE_LENGTH (sizeof(CRED_TARGETNAME_ATTRIBUTE_CACHEDINTERACTIVE_A)-1)

#ifdef UNICODE
#define CRED_SESSION_WILDCARD_NAME CRED_SESSION_WILDCARD_NAME_W
#define CRED_TARGETNAME_DOMAIN_NAMESPACE CRED_TARGETNAME_DOMAIN_NAMESPACE_W
#define CRED_UNIVERSAL_WILDCARD = CRED_UNIVERSAL_WILDCARD_W
#define CRED_TARGETNAME_NAMESPACE_SEPERATOR = CRED_TARGETNAME_NAMESPACE_SEPERATOR_W
#define CRED_TARGETNAME_ATTRIBUTE_SEPERATOR = CRED_TARGETNAME_ATTRIBUTE_SEPERATOR_W
#define CRED_TARGETNAME_ATTRIBUTE_NAME CRED_TARGETNAME_ATTRIBUTE_NAME_W
#define CRED_TARGETNAME_ATTRIBUTE_TARGET CRED_TARGETNAME_ATTRIBUTE_TARGET_W
#define CRED_TARGETNAME_ATTRIBUTE_BATCH CRED_TARGETNAME_ATTRIBUTE_BATCH_W
#define CRED_TARGETNAME_ATTRIBUTE_INTERACTIVE CRED_TARGETNAME_ATTRIBUTE_INTERACTIVE_W
#define CRED_TARGETNAME_ATTRIBUTE_SERVICE CRED_TARGETNAME_ATTRIBUTE_SERVICE_W
#define CRED_TARGETNAME_ATTRIBUTE_NETWORK CRED_TARGETNAME_ATTRIBUTE_NETWORK_W
#define CRED_TARGETNAME_ATTRIBUTE_NETWORKCLEARTEXT CRED_TARGETNAME_ATTRIBUTE_NETWORKCLEARTEXT_W
#define CRED_TARGETNAME_ATTRIBUTE_REMOTEINTERACTIVE CRED_TARGETNAME_ATTRIBUTE_REMOTEINTERACTIVE_W
#define CRED_TARGETNAME_ATTRIBUTE_CACHEDINTERACTIVE CRED_TARGETNAME_ATTRIBUTE_CACHEDINTERACTIVE_W

#else
#define CRED_SESSION_WILDCARD_NAME CRED_SESSION_WILDCARD_NAME_A
#define CRED_TARGETNAME_DOMAIN_NAMESPACE CRED_TARGETNAME_DOMAIN_NAMESPACE_A
#define CRED_UNIVERSAL_WILDCARD = CRED_UNIVERSAL_WILDCARD_A
#define CRED_TARGETNAME_NAMESPACE_SEPERATOR = CRED_TARGETNAME_NAMESPACE_SEPERATOR_A
#define CRED_TARGETNAME_ATTRIBUTE_SEPERATOR = CRED_TARGETNAME_ATTRIBUTE_SEPERATOR_A
#define CRED_TARGETNAME_ATTRIBUTE_NAME CRED_TARGETNAME_ATTRIBUTE_NAME_A
#define CRED_TARGETNAME_ATTRIBUTE_TARGET CRED_TARGETNAME_ATTRIBUTE_TARGET_A
#define CRED_TARGETNAME_ATTRIBUTE_BATCH CRED_TARGETNAME_ATTRIBUTE_BATCH_A
#define CRED_TARGETNAME_ATTRIBUTE_INTERACTIVE CRED_TARGETNAME_ATTRIBUTE_INTERACTIVE_A
#define CRED_TARGETNAME_ATTRIBUTE_SERVICE CRED_TARGETNAME_ATTRIBUTE_SERVICE_A
#define CRED_TARGETNAME_ATTRIBUTE_NETWORK CRED_TARGETNAME_ATTRIBUTE_NETWORK_A
#define CRED_TARGETNAME_ATTRIBUTE_NETWORKCLEARTEXT CRED_TARGETNAME_ATTRIBUTE_NETWORKCLEARTEXT_A
#define CRED_TARGETNAME_ATTRIBUTE_REMOTEINTERACTIVE CRED_TARGETNAME_ATTRIBUTE_REMOTEINTERACTIVE_A
#define CRED_TARGETNAME_ATTRIBUTE_CACHEDINTERACTIVE CRED_TARGETNAME_ATTRIBUTE_CACHEDINTERACTIVE_A
#endif // UNICODE
--]=]

--[=[
//
// Add\Extract Logon type from flags
//
#define CRED_LOGON_TYPES_MASK             0xF000  // Mask to get logon types

#define CredAppendLogonTypeToFlags(Flags, LogonType)      (Flags) |= ((LogonType) << 12)
#define CredGetLogonTypeFromFlags(Flags)                  ((SECURITY_LOGON_TYPE)(((Flags) & CRED_LOGON_TYPES_MASK) >> 12))
#define CredRemoveLogonTypeFromFlags(Flags)               (Flags) &= ~CRED_LOGON_TYPES_MASK

//
// Values of the Credential Flags field.
//
#define CRED_FLAGS_PASSWORD_FOR_CERT    0x0001
#define CRED_FLAGS_PROMPT_NOW           0x0002
#define CRED_FLAGS_USERNAME_TARGET      0x0004
#define CRED_FLAGS_OWF_CRED_BLOB        0x0008
#define CRED_FLAGS_REQUIRE_CONFIRMATION 0x0010

//
//  Valid only for return and only with CredReadDomainCredentials().
//  Indicates credential was returned due to wildcard match
//  of targetname with credential.
//

#define CRED_FLAGS_WILDCARD_MATCH       0x0020

//
// Valid only for return
// Indicates that the credential is VSM protected
//

#define CRED_FLAGS_VSM_PROTECTED        0x0040

#define CRED_FLAGS_NGC_CERT             0x0080

//
// Mask of all valid flags
//

#define CRED_FLAGS_VALID_FLAGS          0xF0FF

//
//  Bit mask for only those flags which can be passed to the credman
//  APIs.
//

#define CRED_FLAGS_VALID_INPUT_FLAGS    0xF09F

//
// Values of the Credential Type field.
//
#define CRED_TYPE_GENERIC               1
#define CRED_TYPE_DOMAIN_PASSWORD       2
#define CRED_TYPE_DOMAIN_CERTIFICATE    3
#define CRED_TYPE_DOMAIN_VISIBLE_PASSWORD 4
#define CRED_TYPE_GENERIC_CERTIFICATE   5
#define CRED_TYPE_DOMAIN_EXTENDED       6
#define CRED_TYPE_MAXIMUM               7       // Maximum supported cred type
#define CRED_TYPE_MAXIMUM_EX  (CRED_TYPE_MAXIMUM+1000)  // Allow new applications to run on old OSes

//
// Maximum size of the CredBlob field (in bytes)
//

#define CRED_MAX_CREDENTIAL_BLOB_SIZE   (5*512)

//
// Values of the Credential Persist field
//
#define CRED_PERSIST_NONE               0
#define CRED_PERSIST_SESSION            1
#define CRED_PERSIST_LOCAL_MACHINE      2
#define CRED_PERSIST_ENTERPRISE         3
--]=]

ffi.cdef[[
//
// A credential
//
typedef struct _CREDENTIALA {
    DWORD Flags;
    DWORD Type;
    LPSTR TargetName;
    LPSTR Comment;
    FILETIME LastWritten;
    DWORD CredentialBlobSize;
     LPBYTE CredentialBlob;
    DWORD Persist;
    DWORD AttributeCount;
    PCREDENTIAL_ATTRIBUTEA Attributes;
    LPSTR TargetAlias;
    LPSTR UserName;
} CREDENTIALA, *PCREDENTIALA;

typedef struct _CREDENTIALW {
    DWORD Flags;
    DWORD Type;
    LPWSTR TargetName;
    LPWSTR Comment;
    FILETIME LastWritten;
    DWORD CredentialBlobSize;
    LPBYTE CredentialBlob;
    DWORD Persist;
    DWORD AttributeCount;
    PCREDENTIAL_ATTRIBUTEW Attributes;
    LPWSTR TargetAlias;
    LPWSTR UserName;
} CREDENTIALW, *PCREDENTIALW;
]]

--[[
#ifdef UNICODE
typedef CREDENTIALW CREDENTIAL;
typedef PCREDENTIALW PCREDENTIAL;
#else
typedef CREDENTIALA CREDENTIAL;
typedef PCREDENTIALA PCREDENTIAL;
#endif // UNICODE
--]]

ffi.cdef[[
//
// Value of the Flags field in CREDENTIAL_TARGET_INFORMATION
//

static const int CRED_TI_SERVER_FORMAT_UNKNOWN  = 0x0001;  // Don't know if server name is DNS or netbios format
static const int CRED_TI_DOMAIN_FORMAT_UNKNOWN  = 0x0002;  // Don't know if domain name is DNS or netbios format
static const int CRED_TI_ONLY_PASSWORD_REQUIRED = 0x0004;  // Server only requires a password and not a username
static const int CRED_TI_USERNAME_TARGET        = 0x0008;  // TargetName is username
static const int CRED_TI_CREATE_EXPLICIT_CRED   = 0x0010;  // When creating a cred, create one named TargetInfo->TargetName
static const int CRED_TI_WORKGROUP_MEMBER       = 0x0020;  // Indicates the machine is a member of a workgroup
static const int CRED_TI_DNSTREE_IS_DFS_SERVER  = 0x0040;  // used to tell credman that the DNSTreeName could be DFS server
static const int CRED_TI_VALID_FLAGS            = 0xF07F;
]]


ffi.cdef[[
//
// A credential target
//

typedef struct _CREDENTIAL_TARGET_INFORMATIONA {
    LPSTR TargetName;
    LPSTR NetbiosServerName;
    LPSTR DnsServerName;
    LPSTR NetbiosDomainName;
    LPSTR DnsDomainName;
    LPSTR DnsTreeName;
    LPSTR PackageName;
    ULONG Flags;
    DWORD CredTypeCount;
    LPDWORD CredTypes;
} CREDENTIAL_TARGET_INFORMATIONA, *PCREDENTIAL_TARGET_INFORMATIONA;

typedef struct _CREDENTIAL_TARGET_INFORMATIONW {

    LPWSTR TargetName;
    LPWSTR NetbiosServerName;
    LPWSTR DnsServerName;
    LPWSTR NetbiosDomainName;
    LPWSTR DnsDomainName;
    LPWSTR DnsTreeName;
    LPWSTR PackageName;
    ULONG Flags;
    DWORD CredTypeCount;
    LPDWORD CredTypes;
} CREDENTIAL_TARGET_INFORMATIONW, *PCREDENTIAL_TARGET_INFORMATIONW;
]]


if UNICODE then
ffi.cdef[[
typedef CREDENTIAL_TARGET_INFORMATIONW CREDENTIAL_TARGET_INFORMATION;
typedef PCREDENTIAL_TARGET_INFORMATIONW PCREDENTIAL_TARGET_INFORMATION;
]]
else
ffi.cdef[[
typedef CREDENTIAL_TARGET_INFORMATIONA CREDENTIAL_TARGET_INFORMATION;
typedef PCREDENTIAL_TARGET_INFORMATIONA PCREDENTIAL_TARGET_INFORMATION;
]]
end --// UNICODE

ffi.cdef[[
//
// Certificate credential information
//
// The cbSize should be the size of the structure, sizeof(CERT_CREDENTIAL_INFO),
// rgbHashofCert is the hash of the cert which is to be used as the credential.
//

static const int CERT_HASH_LENGTH      =  20;  // SHA1 hashes are used for cert hashes

typedef struct _CERT_CREDENTIAL_INFO {
    ULONG cbSize;
    UCHAR rgbHashOfCert[CERT_HASH_LENGTH];
} CERT_CREDENTIAL_INFO, *PCERT_CREDENTIAL_INFO;

//
// Username Target credential information
//
// This credential can be pass to LsaLogonUser to ask it to find a credential with a
// TargetName of UserName.
//

typedef struct _USERNAME_TARGET_CREDENTIAL_INFO {
    LPWSTR UserName;
} USERNAME_TARGET_CREDENTIAL_INFO, *PUSERNAME_TARGET_CREDENTIAL_INFO;

//
// Marshaled credential blob information.
//

typedef struct _BINARY_BLOB_CREDENTIAL_INFO {
    ULONG cbBlob;
    LPBYTE pbBlob;
} BINARY_BLOB_CREDENTIAL_INFO, *PBINARY_BLOB_CREDENTIAL_INFO;

//
// Credential type for credential marshaling routines
//

typedef enum _CRED_MARSHAL_TYPE {
    CertCredential = 1,
    UsernameTargetCredential,
    BinaryBlobCredential,
    UsernameForPackedCredentials,  // internal only, reserved
} CRED_MARSHAL_TYPE, *PCRED_MARSHAL_TYPE;

//
// Protection type for credential providers secret protection routines
//

typedef enum _CRED_PROTECTION_TYPE {
    CredUnprotected,
    CredUserProtection,
    CredTrustedProtection
} CRED_PROTECTION_TYPE, *PCRED_PROTECTION_TYPE;
]]

ffi.cdef[[
//
// Values for authentication buffers packing
//
static const int CRED_PACK_PROTECTED_CREDENTIALS     = 0x1;
static const int CRED_PACK_WOW_BUFFER                = 0x2;
static const int CRED_PACK_GENERIC_CREDENTIALS       = 0x4;
static const int CRED_PACK_ID_PROVIDER_CREDENTIALS   = 0x8;
]]


-- Credential UI info


_CREDUI_INFO_DEFINED = true

ffi.cdef[[
typedef struct _CREDUI_INFOA
{
    DWORD cbSize;
    HWND hwndParent;
    PCSTR pszMessageText;
    PCSTR pszCaptionText;
    HBITMAP hbmBanner;
} CREDUI_INFOA, *PCREDUI_INFOA;

typedef struct _CREDUI_INFOW
{
    DWORD cbSize;
    HWND hwndParent;
    PCWSTR pszMessageText;
    PCWSTR pszCaptionText;
    HBITMAP hbmBanner;
} CREDUI_INFOW, *PCREDUI_INFOW;
]]

if UNICODE then
ffi.cdef[[
typedef CREDUI_INFOW CREDUI_INFO;
typedef PCREDUI_INFOW PCREDUI_INFO;
]]
else
ffi.cdef[[
typedef CREDUI_INFOA CREDUI_INFO;
typedef PCREDUI_INFOA PCREDUI_INFO;
]]
end

ffi.cdef[[
//-----------------------------------------------------------------------------
// Values
//-----------------------------------------------------------------------------
// BUGBUG
static const int MAXUSHORT = 0xffff;

// String length limits:

static const int CREDUI_MAX_MESSAGE_LENGTH          = 1024;
static const int CREDUI_MAX_CAPTION_LENGTH          = 128;
static const int CREDUI_MAX_GENERIC_TARGET_LENGTH   = CRED_MAX_GENERIC_TARGET_NAME_LENGTH;
static const int CREDUI_MAX_DOMAIN_TARGET_LENGTH    = CRED_MAX_DOMAIN_TARGET_NAME_LENGTH;

//
//  Username can be in <domain>\<user> or <user>@<domain>
//  Length in characters, not including NULL termination.
//

static const int CREDUI_MAX_USERNAME_LENGTH         = CRED_MAX_USERNAME_LENGTH;
static const int CREDUI_MAX_PASSWORD_LENGTH         = (512 / 2);


//  Packed credential returned by SspiEncodeAuthIdentityAsStrings().
//  Length in characters, not including NULL termination.
//

static const int CREDUI_MAX_PACKED_CREDENTIALS_LENGTH   = ((MAXUSHORT / 2) - 2);

// maximum length in bytes for binary credential blobs

static const int CREDUI_MAX_CREDENTIALS_BLOB_SIZE       = (MAXUSHORT);

//
// Flags for CredUIPromptForCredentials and/or CredUICmdLinePromptForCredentials
//

static const int CREDUI_FLAGS_INCORRECT_PASSWORD    = 0x00001;     // indicates the username is valid, but password is not
static const int CREDUI_FLAGS_DO_NOT_PERSIST        = 0x00002;     // Do not show "Save" checkbox, and do not persist credentials
static const int CREDUI_FLAGS_REQUEST_ADMINISTRATOR = 0x00004;     // Populate list box with admin accounts
static const int CREDUI_FLAGS_EXCLUDE_CERTIFICATES  = 0x00008;    // do not include certificates in the drop list
static const int CREDUI_FLAGS_REQUIRE_CERTIFICATE   = 0x00010;
static const int CREDUI_FLAGS_SHOW_SAVE_CHECK_BOX   = 0x00040;
static const int CREDUI_FLAGS_ALWAYS_SHOW_UI        = 0x00080;
static const int CREDUI_FLAGS_REQUIRE_SMARTCARD     = 0x00100;
static const int CREDUI_FLAGS_PASSWORD_ONLY_OK      = 0x00200;
static const int CREDUI_FLAGS_VALIDATE_USERNAME     = 0x00400;
static const int CREDUI_FLAGS_COMPLETE_USERNAME     = 0x00800;     //
static const int CREDUI_FLAGS_PERSIST               = 0x01000;     // Do not show "Save" checkbox, but persist credentials anyway
static const int CREDUI_FLAGS_SERVER_CREDENTIAL     = 0x04000;
static const int CREDUI_FLAGS_EXPECT_CONFIRMATION   = 0x20000;     // do not persist unless caller later confirms credential via CredUIConfirmCredential() api
static const int CREDUI_FLAGS_GENERIC_CREDENTIALS   = 0x40000;     // Credential is a generic credential
static const int CREDUI_FLAGS_USERNAME_TARGET_CREDENTIALS = 0x80000; // Credential has a username as the target
static const int CREDUI_FLAGS_KEEP_USERNAME         = 0x100000;             // dont allow the user to change the supplied username
]]

--[=[
//
// Mask of flags valid for CredUIPromptForCredentials
//
#define CREDUI_FLAGS_PROMPT_VALID ( \
        CREDUI_FLAGS_INCORRECT_PASSWORD | \
        CREDUI_FLAGS_DO_NOT_PERSIST | \
        CREDUI_FLAGS_REQUEST_ADMINISTRATOR | \
        CREDUI_FLAGS_EXCLUDE_CERTIFICATES | \
        CREDUI_FLAGS_REQUIRE_CERTIFICATE | \
        CREDUI_FLAGS_SHOW_SAVE_CHECK_BOX | \
        CREDUI_FLAGS_ALWAYS_SHOW_UI | \
        CREDUI_FLAGS_REQUIRE_SMARTCARD | \
        CREDUI_FLAGS_PASSWORD_ONLY_OK | \
        CREDUI_FLAGS_VALIDATE_USERNAME | \
        CREDUI_FLAGS_COMPLETE_USERNAME | \
        CREDUI_FLAGS_PERSIST | \
        CREDUI_FLAGS_SERVER_CREDENTIAL | \
        CREDUI_FLAGS_EXPECT_CONFIRMATION | \
        CREDUI_FLAGS_GENERIC_CREDENTIALS | \
        CREDUI_FLAGS_USERNAME_TARGET_CREDENTIALS | \
        CREDUI_FLAGS_KEEP_USERNAME )


//
// Flags for CredUIPromptForWindowsCredentials and CPUS_CREDUI Usage Scenarios
//

#define CREDUIWIN_GENERIC                  = 0x00000001;  // Plain text username/password is being requested
#define CREDUIWIN_CHECKBOX                 = 0x00000002;  // Show the Save Credential checkbox
#define CREDUIWIN_AUTHPACKAGE_ONLY         = 0x00000010;  // Only Cred Providers that support the input auth package should enumerate
#define CREDUIWIN_IN_CRED_ONLY             = 0x00000020;  // Only the incoming cred for the specific auth package should be enumerated
#define CREDUIWIN_ENUMERATE_ADMINS         = 0x00000100;  // Cred Providers should enumerate administrators only
#define CREDUIWIN_ENUMERATE_CURRENT_USER   = 0x00000200;  // Only the incoming cred for the specific auth package should be enumerated
#define CREDUIWIN_SECURE_PROMPT            = 0x00001000;  // The Credui prompt should be displayed on the secure desktop
#define CREDUIWIN_PREPROMPTING             = 0X00002000;  // CredUI is invoked by SspiPromptForCredentials and the client is prompting before a prior handshake
#define CREDUIWIN_PACK_32_WOW              = 0x10000000;  // Tell the credential provider it should be packing its Auth Blob 32 bit even though it is running 64 native


#define CREDUIWIN_VALID_FLAGS            ( \
        CREDUIWIN_GENERIC                | \
        CREDUIWIN_CHECKBOX               | \
        CREDUIWIN_AUTHPACKAGE_ONLY       | \
        CREDUIWIN_IN_CRED_ONLY           | \
        CREDUIWIN_ENUMERATE_ADMINS       | \
        CREDUIWIN_ENUMERATE_CURRENT_USER | \
        CREDUIWIN_SECURE_PROMPT          | \
        CREDUIWIN_PREPROMPTING           | \
        CREDUIWIN_PACK_32_WOW            )
--]=]

-----------------------------------------------------------------------------
-- Functions
-----------------------------------------------------------------------------

ffi.cdef[[
//
// Values of flags to CredWrite and CredWriteDomainCredentials
//

static const int CRED_PRESERVE_CREDENTIAL_BLOB = 0x1;


BOOL
__stdcall
CredWriteW (
     PCREDENTIALW Credential,
     DWORD Flags
    );


BOOL
__stdcall
CredWriteA (
     PCREDENTIALA Credential,
     DWORD Flags
    );
]]

--[[
#ifdef UNICODE
#define CredWrite CredWriteW
#else
#define CredWrite CredWriteA
#endif // UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
CredReadW (
     LPCWSTR TargetName,
     DWORD Type,
     DWORD Flags,
     PCREDENTIALW *Credential
    );


BOOL
__stdcall
CredReadA (
     LPCSTR TargetName,
     DWORD Type,
     DWORD Flags,
     PCREDENTIALA *Credential
    );
]]

--[[
#ifdef UNICODE
#define CredRead CredReadW
#else
#define CredRead CredReadA
#endif // UNICODE
--]]

ffi.cdef[[
//
// Values of flags to CredEnumerate
//

static const int CRED_ENUMERATE_ALL_CREDENTIALS = 0x1;


BOOL
__stdcall
CredEnumerateW (
     LPCWSTR Filter,
     DWORD Flags,
     DWORD *Count,
     PCREDENTIALW **Credential
    );


BOOL
__stdcall
CredEnumerateA (
     LPCSTR Filter,
     DWORD Flags,
     DWORD *Count,
     PCREDENTIALA **Credential
    );
]]

--[[
#ifdef UNICODE
#define CredEnumerate CredEnumerateW
#else
#define CredEnumerate CredEnumerateA
#endif // UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
CredWriteDomainCredentialsW (
     PCREDENTIAL_TARGET_INFORMATIONW TargetInfo,
     PCREDENTIALW Credential,
     DWORD Flags
    );


BOOL
__stdcall
CredWriteDomainCredentialsA (
     PCREDENTIAL_TARGET_INFORMATIONA TargetInfo,
     PCREDENTIALA Credential,
     DWORD Flags
    );
]]

--[[
#ifdef UNICODE
#define CredWriteDomainCredentials CredWriteDomainCredentialsW
#else
#define CredWriteDomainCredentials CredWriteDomainCredentialsA
#endif // UNICODE
--]]

ffi.cdef[[
//
// Values of flags to CredReadDomainCredentials
//

static const int CRED_CACHE_TARGET_INFORMATION = 0x1;



BOOL
__stdcall
CredReadDomainCredentialsW (
     PCREDENTIAL_TARGET_INFORMATIONW TargetInfo,
     DWORD Flags,
     DWORD *Count,
     PCREDENTIALW **Credential
    );


BOOL
__stdcall
CredReadDomainCredentialsA (
     PCREDENTIAL_TARGET_INFORMATIONA TargetInfo,
     DWORD Flags,
     DWORD *Count,
     PCREDENTIALA **Credential
    );
]]

--[[
#ifdef UNICODE
#define CredReadDomainCredentials CredReadDomainCredentialsW
#else
#define CredReadDomainCredentials CredReadDomainCredentialsA
#endif // UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
CredDeleteW (
     LPCWSTR TargetName,
     DWORD Type,
     DWORD Flags
    );


BOOL
__stdcall
CredDeleteA (
     LPCSTR TargetName,
     DWORD Type,
     DWORD Flags
    );
]]

--[[
#ifdef UNICODE
#define CredDelete CredDeleteW
#else
#define CredDelete CredDeleteA
#endif // UNICODE
--]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

ffi.cdef[[
BOOL
__stdcall
CredRenameW (
     LPCWSTR OldTargetName,
     LPCWSTR NewTargetName,
     DWORD Type,
     DWORD Flags
    );


BOOL
__stdcall
CredRenameA (
     LPCSTR OldTargetName,
     LPCSTR NewTargetName,
     DWORD Type,
     DWORD Flags
    );
]]

--[[
#ifdef UNICODE
#define CredRename CredRenameW
#else
#define CredRename CredRenameA
#endif // UNICODE
--]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
//
// Values of flags to CredGetTargetInfo
//

static const int CRED_ALLOW_NAME_RESOLUTION = 0x1;



BOOL
__stdcall
CredGetTargetInfoW (
     LPCWSTR TargetName,
     DWORD Flags,
     PCREDENTIAL_TARGET_INFORMATIONW *TargetInfo
    );


BOOL
__stdcall
CredGetTargetInfoA (
     LPCSTR TargetName,
     DWORD Flags,
     PCREDENTIAL_TARGET_INFORMATIONA *TargetInfo
    );
]]

--[[
#ifdef UNICODE
#define CredGetTargetInfo CredGetTargetInfoW
#else
#define CredGetTargetInfo CredGetTargetInfoA
#endif // UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
CredMarshalCredentialW(
     CRED_MARSHAL_TYPE CredType,
     PVOID Credential,
     LPWSTR *MarshaledCredential
    );


BOOL
__stdcall
CredMarshalCredentialA(
     CRED_MARSHAL_TYPE CredType,
     PVOID Credential,
     LPSTR *MarshaledCredential
    );
]]

--[[
#ifdef UNICODE
#define CredMarshalCredential CredMarshalCredentialW
#else
#define CredMarshalCredential CredMarshalCredentialA
#endif // UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
CredUnmarshalCredentialW(
     LPCWSTR MarshaledCredential,
     PCRED_MARSHAL_TYPE CredType,
     PVOID *Credential
    );


BOOL
__stdcall
CredUnmarshalCredentialA(
     LPCSTR MarshaledCredential,
     PCRED_MARSHAL_TYPE CredType,
     PVOID *Credential
    );
]]

--[[
#ifdef UNICODE
#define CredUnmarshalCredential CredUnmarshalCredentialW
#else
#define CredUnmarshalCredential CredUnmarshalCredentialA
#endif // UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
CredIsMarshaledCredentialW(
     LPCWSTR MarshaledCredential
    );
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

ffi.cdef[[
BOOL
__stdcall
CredIsMarshaledCredentialA(
     LPCSTR MarshaledCredential
    );
]]

--[[
#ifdef UNICODE
#define CredIsMarshaledCredential CredIsMarshaledCredentialW
#else
#define CredIsMarshaledCredential CredIsMarshaledCredentialA
#endif // UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
CredUnPackAuthenticationBufferW(
     DWORD                                      dwFlags,
     PVOID                 pAuthBuffer,
     DWORD                                      cbAuthBuffer,
     LPWSTR       pszUserName,
     DWORD*                                  pcchMaxUserName,
     LPWSTR     pszDomainName,
     DWORD*                              pcchMaxDomainName,
     LPWSTR       pszPassword,
     DWORD*                                  pcchMaxPassword
    );


BOOL
__stdcall
CredUnPackAuthenticationBufferA(
     DWORD                                      dwFlags,
     PVOID                 pAuthBuffer,
     DWORD                                      cbAuthBuffer,
     LPSTR       pszUserName,
     DWORD*                                  pcchlMaxUserName,
     LPSTR      pszDomainName,
     DWORD*                              pcchMaxDomainName,
     LPSTR        pszPassword,
     DWORD*                                  pcchMaxPassword
    );
]]

--[[
#ifdef UNICODE
#define CredUnPackAuthenticationBuffer CredUnPackAuthenticationBufferW
#else
#define CredUnPackAuthenticationBuffer CredUnPackAuthenticationBufferA
#endif //UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
CredPackAuthenticationBufferW(
     DWORD                                      dwFlags,
     LPWSTR                                     pszUserName,
     LPWSTR                                     pszPassword,
     PBYTE   pPackedCredentials,
     DWORD*                                  pcbPackedCredentials
    );


BOOL
__stdcall
CredPackAuthenticationBufferA(
     DWORD                                      dwFlags,
     LPSTR                                      pszUserName,
     LPSTR                                      pszPassword,
     PBYTE   pPackedCredentials,
     DWORD*                                  pcbPackedCredentials
    );
]]

--[[
#ifdef UNICODE
#define CredPackAuthenticationBuffer CredPackAuthenticationBufferW
#else
#define CredPackAuthenticationBuffer CredPackAuthenticationBufferA
#endif //UNICODE
--]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


ffi.cdef[[
BOOL
__stdcall
CredProtectW(
     BOOL                               fAsSelf,
     LPWSTR      pszCredentials,
     DWORD                              cchCredentials,
     LPWSTR pszProtectedCredentials,
     DWORD*                          pcchMaxChars,
     CRED_PROTECTION_TYPE*         ProtectionType
    );


BOOL
__stdcall
CredProtectA(
     BOOL                            fAsSelf,
     LPSTR    pszCredentials,
     DWORD                           cchCredentials,
     LPSTR    pszProtectedCredentials,
     DWORD*                       pcchMaxChars,
     CRED_PROTECTION_TYPE*      ProtectionType
    );
]]

--[[
#ifdef UNICODE
#define CredProtect CredProtectW
#else
#define CredProtect CredProtectA
#endif //UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
CredUnprotectW(
     BOOL                                   fAsSelf,
     LPWSTR pszProtectedCredentials,
     DWORD                                  cchProtectedCredentials,
     LPWSTR pszCredentials,
     DWORD*                              pcchMaxChars
    );


BOOL
__stdcall
CredUnprotectA(
     BOOL                                   fAsSelf,
     LPSTR  pszProtectedCredentials,
     DWORD                                  cchProtectedCredentials,
     LPSTR       pszCredentials,
     DWORD*                              pcchMaxChars
    );
]]

--[[
#ifdef UNICODE
#define CredUnprotect CredUnprotectW
#else
#define CredUnprotect CredUnprotectA
#endif //UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
CredIsProtectedW(
     LPWSTR                 pszProtectedCredentials,
     CRED_PROTECTION_TYPE* pProtectionType
    );


BOOL
__stdcall
CredIsProtectedA(
     LPSTR                  pszProtectedCredentials,
     CRED_PROTECTION_TYPE* pProtectionType
    );
]]

--[[
#ifdef UNICODE
#define CredIsProtected CredIsProtectedW
#else
#define CredIsProtected CredIsProtectedA
#endif //UNICODE
--]]


ffi.cdef[[
BOOL
__stdcall
CredFindBestCredentialW (
      LPCWSTR       TargetName,
      DWORD         Type,
      DWORD         Flags,
     PCREDENTIALW *Credential
    );


BOOL
__stdcall
CredFindBestCredentialA (
      LPCSTR        TargetName,
      DWORD         Type,
      DWORD         Flags,
     PCREDENTIALA *Credential
    );
]]

--[[
#ifdef UNICODE
#define CredFindBestCredential CredFindBestCredentialW
#else
#define CredFindBestCredential CredFindBestCredentialA
#endif // UNICODE
--]]


ffi.cdef[[

BOOL
__stdcall
CredGetSessionTypes (
     DWORD MaximumPersistCount,
     LPDWORD MaximumPersist
    );



VOID
__stdcall
CredFree (
     PVOID Buffer
    );
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then
ffi.cdef[[

DWORD
__stdcall
CredUIPromptForCredentialsW(
     PCREDUI_INFOW pUiInfo,
     PCWSTR pszTargetName,
     PCtxtHandle pContext,
     DWORD dwAuthError,
     PWSTR pszUserName,
     ULONG ulUserNameBufferSize,
     PWSTR pszPassword,
     ULONG ulPasswordBufferSize,
     BOOL *save,
     DWORD dwFlags
    );


DWORD
__stdcall
CredUIPromptForCredentialsA(
     PCREDUI_INFOA pUiInfo,
     PCSTR pszTargetName,
     PCtxtHandle pContext,
     DWORD dwAuthError,
     PSTR  pszUserName,
     ULONG ulUserNameBufferSize,
     PSTR pszPassword,
     ULONG ulPasswordBufferSize,
     BOOL *save,
     DWORD dwFlags
    );
]]

--[[
#ifdef UNICODE
#define CredUIPromptForCredentials CredUIPromptForCredentialsW
#else
#define CredUIPromptForCredentials CredUIPromptForCredentialsA
#endif
--]]

ffi.cdef[[

DWORD
__stdcall
CredUIPromptForWindowsCredentialsW(
     PCREDUI_INFOW pUiInfo,
     DWORD dwAuthError,
     ULONG *pulAuthPackage,
     LPCVOID pvInAuthBuffer,
     ULONG ulInAuthBufferSize,
     LPVOID * ppvOutAuthBuffer,
     ULONG * pulOutAuthBufferSize,
     BOOL *pfSave,
     DWORD dwFlags
    );


DWORD
__stdcall
CredUIPromptForWindowsCredentialsA(
     PCREDUI_INFOA pUiInfo,
     DWORD dwAuthError,
     ULONG *pulAuthPackage,
     LPCVOID pvInAuthBuffer,
     ULONG ulInAuthBufferSize,
     LPVOID * ppvOutAuthBuffer,
     ULONG * pulOutAuthBufferSize,
     BOOL *pfSave,
     DWORD dwFlags
    );
]]

--[[
#ifdef UNICODE
#define CredUIPromptForWindowsCredentials CredUIPromptForWindowsCredentialsW
#else
#define CredUIPromptForWindowsCredentials CredUIPromptForWindowsCredentialsA
#endif
--]]

ffi.cdef[[

DWORD
__stdcall
CredUIParseUserNameW(
     PCWSTR UserName,
     WCHAR *user,
     ULONG userBufferSize,
     WCHAR *domain,
     ULONG domainBufferSize
    );


DWORD
__stdcall
CredUIParseUserNameA(
     PCSTR userName,
     CHAR *user,
     ULONG userBufferSize,
     CHAR *domain,
     ULONG domainBufferSize
    );
]]

--[[
#ifdef UNICODE
#define CredUIParseUserName CredUIParseUserNameW
#else
#define CredUIParseUserName CredUIParseUserNameA
#endif
--]]

ffi.cdef[[

DWORD
__stdcall
CredUICmdLinePromptForCredentialsW(
     PCWSTR pszTargetName,
     PCtxtHandle pContext,
     DWORD dwAuthError,
     PWSTR UserName,
     ULONG ulUserBufferSize,
     PWSTR pszPassword,
     ULONG ulPasswordBufferSize,
     PBOOL pfSave,
     DWORD dwFlags
    );


DWORD
__stdcall
CredUICmdLinePromptForCredentialsA(
     PCSTR pszTargetName,
     PCtxtHandle pContext,
     DWORD dwAuthError,
     PSTR UserName,
     ULONG ulUserBufferSize,
     PSTR pszPassword,
     ULONG ulPasswordBufferSize,
     PBOOL pfSave,
     DWORD dwFlags
    );
]]

--[[
#ifdef UNICODE
#define CredUICmdLinePromptForCredentials CredUICmdLinePromptForCredentialsW
#else
#define CredUICmdLinePromptForCredentials CredUICmdLinePromptForCredentialsA
#endif
--]]

ffi.cdef[[
//
// Call this API with bConfirm set to TRUE to confirm that the credential (previously created
// via CredUIGetCredentials or CredUIPromptForCredentials worked, or with bConfirm set to FALSE
// to indicate it didnt


DWORD
__stdcall
CredUIConfirmCredentialsW(
     PCWSTR pszTargetName,
     BOOL  bConfirm
    );


DWORD
__stdcall
CredUIConfirmCredentialsA(
     PCSTR pszTargetName,
     BOOL  bConfirm
    );
]]

--[[
#ifdef UNICODE
#define CredUIConfirmCredentials CredUIConfirmCredentialsW
#else
#define CredUIConfirmCredentials CredUIConfirmCredentialsA
#endif
--]]

ffi.cdef[[

DWORD
__stdcall
CredUIStoreSSOCredW (
     PCWSTR pszRealm,
     PCWSTR pszUsername,
     PCWSTR pszPassword,
     BOOL   bPersist
    );


DWORD
__stdcall
CredUIReadSSOCredW (
     PCWSTR pszRealm,
     PWSTR* ppszUsername
    );
]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */

return ffi.load("AdvApi32")