
local ffi = require("ffi")



--/* verify that the <rpcndr.h> version is high enough to compile this file*/
if not __REQUIRED_RPCNDR_H_VERSION__ then
__REQUIRED_RPCNDR_H_VERSION__ = 500
end

--[[
/* verify that the <rpcsal.h> version is high enough to compile this file*/
#ifndef __REQUIRED_RPCSAL_H_VERSION__
#define __REQUIRED_RPCSAL_H_VERSION__ 100
#endif
--]]

--require("win32.rpc")
require("win32.rpcndr")

--[[]
#ifndef __RPCNDR_H_VERSION__
#error this stub requires an updated version of <rpcndr.h>
#endif /* __RPCNDR_H_VERSION__ */
--]]


require("win32.basetsd")
require("win32.guiddef")





if _WIN32 and not OLE2ANSI then
ffi.cdef[[
typedef WCHAR OLECHAR;
typedef    OLECHAR *LPOLESTR;
typedef    const OLECHAR *LPCOLESTR;
]]

local function  OLESTR(str) 
    -- convert to a unicode string
    --return L##str
end

else
ffi.cdef[[
typedef char      OLECHAR;
typedef LPSTR     LPOLESTR;
typedef LPCSTR    LPCOLESTR;
]]
local function OLESTR(str) return str end
end

if not _WINDEF_ then
if not _MINWINDEF_ then
ffi.cdef[[
typedef void *PVOID;
typedef void *LPVOID;
typedef float FLOAT;
]]
end  --//_MINWINDEF_
end  --_WINDEF_

ffi.cdef[[
typedef unsigned char UCHAR;
typedef short SHORT;
typedef unsigned short USHORT;
typedef DWORD ULONG;
typedef double DOUBLE;
]]

if not _DWORDLONG_ then
ffi.cdef[[
typedef uint64_t DWORDLONG;
typedef DWORDLONG *PDWORDLONG;
]]
end -- !_DWORDLONG_

if not _ULONGLONG_ then
ffi.cdef[[
typedef int64_t LONGLONG;
typedef uint64_t ULONGLONG;
typedef LONGLONG *PLONGLONG;
typedef ULONGLONG *PULONGLONG;
]]
end -- _ULONGLONG_


if not _WINBASE_ then
if not _FILETIME_ then
_FILETIME_ = true
ffi.cdef[[
typedef struct _FILETIME
   {
   DWORD dwLowDateTime;
   DWORD dwHighDateTime;
   } 	FILETIME;

typedef struct _FILETIME *PFILETIME;

typedef struct _FILETIME *LPFILETIME;
]]
end -- !_FILETIME

if not _SYSTEMTIME_ then
_SYSTEMTIME_ = true;
ffi.cdef[[
typedef struct _SYSTEMTIME
   {
   WORD wYear;
   WORD wMonth;
   WORD wDayOfWeek;
   WORD wDay;
   WORD wHour;
   WORD wMinute;
   WORD wSecond;
   WORD wMilliseconds;
   } 	SYSTEMTIME;

typedef struct _SYSTEMTIME *PSYSTEMTIME;

typedef struct _SYSTEMTIME *LPSYSTEMTIME;
]]
end -- !_SYSTEMTIME

if not _SECURITY_ATTRIBUTES_ then
_SECURITY_ATTRIBUTES_ = true
ffi.cdef[[
typedef struct _SECURITY_ATTRIBUTES
   {
   DWORD nLength;
   LPVOID lpSecurityDescriptor;
   BOOL bInheritHandle;
   } 	SECURITY_ATTRIBUTES;

typedef struct _SECURITY_ATTRIBUTES *PSECURITY_ATTRIBUTES;

typedef struct _SECURITY_ATTRIBUTES *LPSECURITY_ATTRIBUTES;
]]
end -- !_SECURITY_ATTRIBUTES_

if not SECURITY_DESCRIPTOR_REVISION then
ffi.cdef[[
typedef USHORT SECURITY_DESCRIPTOR_CONTROL;

typedef USHORT *PSECURITY_DESCRIPTOR_CONTROL;

typedef PVOID PSID;

typedef struct _ACL
   {
   UCHAR AclRevision;
   UCHAR Sbz1;
   USHORT AclSize;
   USHORT AceCount;
   USHORT Sbz2;
   } 	ACL;

typedef ACL *PACL;

typedef struct _SECURITY_DESCRIPTOR
   {
   UCHAR Revision;
   UCHAR Sbz1;
   SECURITY_DESCRIPTOR_CONTROL Control;
   PSID Owner;
   PSID Group;
   PACL Sacl;
   PACL Dacl;
   } 	SECURITY_DESCRIPTOR;

typedef struct _SECURITY_DESCRIPTOR *PISECURITY_DESCRIPTOR;
]]
end -- !SECURITY_DESCRIPTOR_REVISION
end --_WINBASE_

ffi.cdef[[
typedef struct _COAUTHIDENTITY
   {
   /* [size_is] */ USHORT *User;
   /* [range] */ ULONG UserLength;
   /* [size_is] */ USHORT *Domain;
   /* [range] */ ULONG DomainLength;
   /* [size_is] */ USHORT *Password;
   /* [range] */ ULONG PasswordLength;
   ULONG Flags;
   } 	COAUTHIDENTITY;

typedef struct _COAUTHINFO
   {
   DWORD dwAuthnSvc;
   DWORD dwAuthzSvc;
   LPWSTR pwszServerPrincName;
   DWORD dwAuthnLevel;
   DWORD dwImpersonationLevel;
   COAUTHIDENTITY *pAuthIdentityData;
   DWORD dwCapabilities;
   } 	COAUTHINFO;

typedef LONG SCODE;
typedef SCODE *PSCODE;
]]

if not _HRESULT_DEFINED then
_HRESULT_DEFINED = true
ffi.cdef[[
typedef LONG HRESULT;
]]
end -- !_HRESULT_DEFINED

if not __OBJECTID_DEFINED then
__OBJECTID_DEFINED = true
_OBJECTID_DEFINED = true
ffi.cdef[[
typedef struct _OBJECTID
   {
   GUID Lineage;
   ULONG Uniquifier;
   } 	OBJECTID;
]]
end -- !_OBJECTID_DEFINED

ffi.cdef[[
typedef 
enum tagMEMCTX
   {
       MEMCTX_TASK	= 1,
       MEMCTX_SHARED	= 2,
       MEMCTX_MACSYSTEM	= 3,
       MEMCTX_UNKNOWN	= -1,
       MEMCTX_SAME	= -2
   } 	MEMCTX;
]]


if not _ROTREGFLAGS_DEFINED then
_ROTREGFLAGS_DEFINED = true
ffi.cdef[[
static const int ROTREGFLAGS_ALLOWANYCLIENT = 0x1;
]]
end -- !_ROTREGFLAGS_DEFINED

if not _APPIDREGFLAGS_DEFINED then
_APPIDREGFLAGS_DEFINED = true
ffi.cdef[[
static const int APPIDREGFLAGS_ACTIVATE_IUSERVER_INDESKTOP = 0x1;
static const int APPIDREGFLAGS_SECURE_SERVER_PROCESS_SD_AND_BIND = 0x2;
static const int APPIDREGFLAGS_ISSUE_ACTIVATION_RPC_AT_IDENTIFY = 0x4;
static const int APPIDREGFLAGS_IUSERVER_UNMODIFIED_LOGON_TOKEN = 0x8;
static const int APPIDREGFLAGS_IUSERVER_SELF_SID_IN_LAUNCH_PERMISSION = 0x10;
static const int APPIDREGFLAGS_IUSERVER_ACTIVATE_IN_CLIENT_SESSION_ONLY = 0x20;
static const int APPIDREGFLAGS_RESERVED1 = 0x40;
static const int APPIDREGFLAGS_RESERVED2 = 0x80;
static const int APPIDREGFLAGS_RESERVED3 = 0x100;
static const int APPIDREGFLAGS_RESERVED4 = 0x200;
static const int APPIDREGFLAGS_RESERVED5 = 0x400;
static const int APPIDREGFLAGS_AAA_NO_IMPLICIT_ACTIVATE_AS_IU = 0x800;
static const int APPIDREGFLAGS_RESERVED7 = 0x1000;
static const int APPIDREGFLAGS_RESERVED8 = 0x2000;
]]
end -- !_APPIDREGFLAGS_DEFINED

if not _DCOMSCM_REMOTECALL_FLAGS_DEFINED then
_DCOMSCM_REMOTECALL_FLAGS_DEFINED = true
ffi.cdef[[
static const int DCOMSCM_ACTIVATION_USE_ALL_AUTHNSERVICES =0x1;
static const int DCOMSCM_ACTIVATION_DISALLOW_UNSECURE_CALL =0x2;
static const int DCOMSCM_RESOLVE_USE_ALL_AUTHNSERVICES =0x4;
static const int DCOMSCM_RESOLVE_DISALLOW_UNSECURE_CALL =0x8;
static const int DCOMSCM_PING_USE_MID_AUTHNSERVICE =0x10;
static const int DCOMSCM_PING_DISALLOW_UNSECURE_CALL =0x20;
]]
end -- !_DCOMSCM_REMOTECALL_FLAGS_DEFINED


ffi.cdef[[
typedef 
enum tagCLSCTX
   {
       CLSCTX_INPROC_SERVER	= 0x1,
       CLSCTX_INPROC_HANDLER	= 0x2,
       CLSCTX_LOCAL_SERVER	= 0x4,
       CLSCTX_INPROC_SERVER16	= 0x8,
       CLSCTX_REMOTE_SERVER	= 0x10,
       CLSCTX_INPROC_HANDLER16	= 0x20,
       CLSCTX_RESERVED1	= 0x40,
       CLSCTX_RESERVED2	= 0x80,
       CLSCTX_RESERVED3	= 0x100,
       CLSCTX_RESERVED4	= 0x200,
       CLSCTX_NO_CODE_DOWNLOAD	= 0x400,
       CLSCTX_RESERVED5	= 0x800,
       CLSCTX_NO_CUSTOM_MARSHAL	= 0x1000,
       CLSCTX_ENABLE_CODE_DOWNLOAD	= 0x2000,
       CLSCTX_NO_FAILURE_LOG	= 0x4000,
       CLSCTX_DISABLE_AAA	= 0x8000,
       CLSCTX_ENABLE_AAA	= 0x10000,
       CLSCTX_FROM_DEFAULT_CONTEXT	= 0x20000,
       CLSCTX_ACTIVATE_X86_SERVER	= 0x40000,
       CLSCTX_ACTIVATE_32_BIT_SERVER	= CLSCTX_ACTIVATE_X86_SERVER,
       CLSCTX_ACTIVATE_64_BIT_SERVER	= 0x80000,
       CLSCTX_ENABLE_CLOAKING	= 0x100000,
       CLSCTX_APPCONTAINER	= 0x400000,
       CLSCTX_ACTIVATE_AAA_AS_IU	= 0x800000,
       CLSCTX_RESERVED6	= 0x1000000,
       CLSCTX_ACTIVATE_ARM32_SERVER	= 0x2000000,
       CLSCTX_PS_DLL	= 0x80000000
   } 	CLSCTX;
]]

ffi.cdef[[
static const int CLSCTX_VALID_MASK = \
  (CLSCTX_INPROC_SERVER | \
   CLSCTX_INPROC_HANDLER | \
   CLSCTX_LOCAL_SERVER | \
   CLSCTX_INPROC_SERVER16 | \
   CLSCTX_REMOTE_SERVER | \
   CLSCTX_NO_CODE_DOWNLOAD | \
   CLSCTX_NO_CUSTOM_MARSHAL | \
   CLSCTX_ENABLE_CODE_DOWNLOAD | \
   CLSCTX_NO_FAILURE_LOG | \
   CLSCTX_DISABLE_AAA | \
   CLSCTX_ENABLE_AAA | \
   CLSCTX_FROM_DEFAULT_CONTEXT | \
   CLSCTX_ACTIVATE_X86_SERVER | \
   CLSCTX_ACTIVATE_64_BIT_SERVER | \
   CLSCTX_ENABLE_CLOAKING | \
   CLSCTX_APPCONTAINER | \
   CLSCTX_ACTIVATE_AAA_AS_IU | \
   CLSCTX_RESERVED6 | \
   CLSCTX_ACTIVATE_ARM32_SERVER | \
   CLSCTX_PS_DLL)
]]

ffi.cdef[[
typedef enum tagMSHLFLAGS
   {
       MSHLFLAGS_NORMAL	= 0,
       MSHLFLAGS_TABLESTRONG	= 1,
       MSHLFLAGS_TABLEWEAK	= 2,
       MSHLFLAGS_NOPING	= 4,
       MSHLFLAGS_RESERVED1	= 8,
       MSHLFLAGS_RESERVED2	= 16,
       MSHLFLAGS_RESERVED3	= 32,
       MSHLFLAGS_RESERVED4	= 64
   } 	MSHLFLAGS;

typedef enum tagMSHCTX
   {
       MSHCTX_LOCAL	= 0,
       MSHCTX_NOSHAREDMEM	= 1,
       MSHCTX_DIFFERENTMACHINE	= 2,
       MSHCTX_INPROC	= 3,
       MSHCTX_CROSSCTX	= 4,
       MSHCTX_RESERVED1	= 5
   } 	MSHCTX;
]]

ffi.cdef[[
typedef struct _BYTE_BLOB
   {
   ULONG clSize;
    int8_t abData[ 1 ];
   } 	BYTE_BLOB;

typedef    BYTE_BLOB *UP_BYTE_BLOB;

typedef struct _WORD_BLOB
   {
   ULONG clSize;
    unsigned short asData[ 1 ];
   } 	WORD_BLOB;

typedef  WORD_BLOB *UP_WORD_BLOB;

typedef struct _DWORD_BLOB
   {
   ULONG clSize;
    ULONG alData[ 1 ];
   } 	DWORD_BLOB;

typedef  DWORD_BLOB *UP_DWORD_BLOB;

typedef struct _FLAGGED_BYTE_BLOB
   {
   ULONG fFlags;
   ULONG clSize;
    uint8_t abData[ 1 ];
   } 	FLAGGED_BYTE_BLOB;

typedef    FLAGGED_BYTE_BLOB *UP_FLAGGED_BYTE_BLOB;

typedef struct _FLAGGED_WORD_BLOB
   {
   ULONG fFlags;
   ULONG clSize;
    unsigned short asData[ 1 ];
   } 	FLAGGED_WORD_BLOB;

typedef    FLAGGED_WORD_BLOB *UP_FLAGGED_WORD_BLOB;
]]

ffi.cdef[[
typedef struct _BYTE_SIZEDARR
   {
   ULONG clSize;
    uint8_t *pData;
   } 	BYTE_SIZEDARR;

typedef struct _SHORT_SIZEDARR
   {
   ULONG clSize;
    unsigned short *pData;
   } 	WORD_SIZEDARR;

typedef struct _LONG_SIZEDARR
   {
   ULONG clSize;
    ULONG *pData;
   } 	DWORD_SIZEDARR;

typedef struct _HYPER_SIZEDARR
   {
   ULONG clSize;
    int64_t *pData;
   } 	HYPER_SIZEDARR;
]]



ffi.cdef[[
typedef boolean BOOLEAN;
]]

if not _tagBLOB_DEFINED then
_tagBLOB_DEFINED = true;
_BLOB_DEFINED = true;
_LPBLOB_DEFINED = true;
ffi.cdef[[
typedef struct tagBLOB
   {
   ULONG cbSize;
   BYTE *pBlobData;
   } 	BLOB;

typedef struct tagBLOB *LPBLOB;
]]
end

if not SID_IDENTIFIER_AUTHORITY_DEFINED then
SID_IDENTIFIER_AUTHORITY_DEFINED = true;
ffi.cdef[[
typedef struct _SID_IDENTIFIER_AUTHORITY
   {
   UCHAR Value[ 6 ];
   } 	SID_IDENTIFIER_AUTHORITY;

typedef struct _SID_IDENTIFIER_AUTHORITY *PSID_IDENTIFIER_AUTHORITY;
]]
end

if not SID_DEFINED then
SID_DEFINED = true
ffi.cdef[[
typedef struct _SID
   {
   BYTE Revision;
   BYTE SubAuthorityCount;
   SID_IDENTIFIER_AUTHORITY IdentifierAuthority;
   /* [size_is] */ ULONG SubAuthority[ 1 ];
   } 	SID;

typedef struct _SID *PISID;

typedef struct _SID_AND_ATTRIBUTES
   {
   SID *Sid;
   DWORD Attributes;
   } 	SID_AND_ATTRIBUTES;

typedef struct _SID_AND_ATTRIBUTES *PSID_AND_ATTRIBUTES;
]]
end


