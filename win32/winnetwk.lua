local ffi = require("ffi")



require("win32.wnnc")

ffi.cdef[[
//
//  Network Resources.
//

static const int RESOURCE_CONNECTED      = 0x00000001;
static const int RESOURCE_GLOBALNET      = 0x00000002;
static const int RESOURCE_REMEMBERED     = 0x00000003;
static const int RESOURCE_RECENT         = 0x00000004;
static const int RESOURCE_CONTEXT        = 0x00000005;


static const int RESOURCETYPE_ANY        = 0x00000000;
static const int RESOURCETYPE_DISK       = 0x00000001;
static const int RESOURCETYPE_PRINT      = 0x00000002;
static const int RESOURCETYPE_RESERVED   = 0x00000008;
static const int RESOURCETYPE_UNKNOWN    = 0xFFFFFFFF;

static const int RESOURCEUSAGE_CONNECTABLE   = 0x00000001;
static const int RESOURCEUSAGE_CONTAINER     = 0x00000002;
static const int RESOURCEUSAGE_NOLOCALDEVICE = 0x00000004;
static const int RESOURCEUSAGE_SIBLING       = 0x00000008;
static const int RESOURCEUSAGE_ATTACHED      = 0x00000010;
static const int RESOURCEUSAGE_ALL           = (RESOURCEUSAGE_CONNECTABLE | RESOURCEUSAGE_CONTAINER | RESOURCEUSAGE_ATTACHED);
static const int RESOURCEUSAGE_RESERVED      = 0x80000000;

static const int RESOURCEDISPLAYTYPE_GENERIC        = 0x00000000;
static const int RESOURCEDISPLAYTYPE_DOMAIN         = 0x00000001;
static const int RESOURCEDISPLAYTYPE_SERVER         = 0x00000002;
static const int RESOURCEDISPLAYTYPE_SHARE          = 0x00000003;
static const int RESOURCEDISPLAYTYPE_FILE           = 0x00000004;
static const int RESOURCEDISPLAYTYPE_GROUP          = 0x00000005;
static const int RESOURCEDISPLAYTYPE_NETWORK        = 0x00000006;
static const int RESOURCEDISPLAYTYPE_ROOT           = 0x00000007;
static const int RESOURCEDISPLAYTYPE_SHAREADMIN     = 0x00000008;
static const int RESOURCEDISPLAYTYPE_DIRECTORY      = 0x00000009;
static const int RESOURCEDISPLAYTYPE_TREE           = 0x0000000A;
static const int RESOURCEDISPLAYTYPE_NDSCONTAINER   = 0x0000000B;
]]

ffi.cdef[[
typedef struct  _NETRESOURCEA {
    DWORD    dwScope;
    DWORD    dwType;
    DWORD    dwDisplayType;
    DWORD    dwUsage;
    LPSTR    lpLocalName;
    LPSTR    lpRemoteName;
    LPSTR    lpComment ;
    LPSTR    lpProvider;
}NETRESOURCEA, *LPNETRESOURCEA;

typedef struct  _NETRESOURCEW {
    DWORD    dwScope;
    DWORD    dwType;
    DWORD    dwDisplayType;
    DWORD    dwUsage;
    LPWSTR   lpLocalName;
    LPWSTR   lpRemoteName;
    LPWSTR   lpComment ;
    LPWSTR   lpProvider;
}NETRESOURCEW, *LPNETRESOURCEW;
]]

--[[
#ifdef UNICODE
typedef NETRESOURCEW NETRESOURCE;
typedef LPNETRESOURCEW LPNETRESOURCE;
#else
typedef NETRESOURCEA NETRESOURCE;
typedef LPNETRESOURCEA LPNETRESOURCE;
#endif // UNICODE
--]]

--[=[
ffi.cdef[[
//
//  Network Connections.
//

#define NETPROPERTY_PERSISTENT       1

#define CONNECT_UPDATE_PROFILE      0x00000001
#define CONNECT_UPDATE_RECENT       0x00000002
#define CONNECT_TEMPORARY           0x00000004
#define CONNECT_INTERACTIVE         0x00000008
#define CONNECT_PROMPT              0x00000010
#define CONNECT_NEED_DRIVE          0x00000020
#define CONNECT_REFCOUNT            0x00000040
#define CONNECT_REDIRECT            0x00000080
#define CONNECT_LOCALDRIVE          0x00000100
#define CONNECT_CURRENT_MEDIA       0x00000200
#define CONNECT_DEFERRED            0x00000400
#define CONNECT_RESERVED            0xFF000000
#define CONNECT_COMMANDLINE         0x00000800
#define CONNECT_CMD_SAVECRED        0x00001000
#define CONNECT_CRED_RESET          0x00002000
#define CONNECT_REQUIRE_INTEGRITY      0x00004000
#define CONNECT_REQUIRE_PRIVACY        0x00008000
]]
--]=]

ffi.cdef[[
DWORD 
WNetAddConnectionA(
         LPCSTR   lpRemoteName,
     LPCSTR   lpPassword,
     LPCSTR   lpLocalName
    );

DWORD 
WNetAddConnectionW(
         LPCWSTR   lpRemoteName,
     LPCWSTR   lpPassword,
     LPCWSTR   lpLocalName
    );
]]

--[[
#ifdef UNICODE
#define WNetAddConnection  WNetAddConnectionW
#else
#define WNetAddConnection  WNetAddConnectionA
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD 
WNetAddConnection2A(
         LPNETRESOURCEA lpNetResource,
     LPCSTR       lpPassword,
     LPCSTR       lpUserName,
         DWORD          dwFlags
    );

DWORD 
WNetAddConnection2W(
         LPNETRESOURCEW lpNetResource,
     LPCWSTR       lpPassword,
     LPCWSTR       lpUserName,
         DWORD          dwFlags
    );
]]

--[[
#ifdef UNICODE
#define WNetAddConnection2  WNetAddConnection2W
#else
#define WNetAddConnection2  WNetAddConnection2A
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD 
WNetAddConnection3A(
     HWND           hwndOwner,
         LPNETRESOURCEA lpNetResource,
     LPCSTR       lpPassword,
     LPCSTR       lpUserName,
         DWORD          dwFlags
    );

DWORD 
WNetAddConnection3W(
     HWND           hwndOwner,
         LPNETRESOURCEW lpNetResource,
     LPCWSTR       lpPassword,
     LPCWSTR       lpUserName,
         DWORD          dwFlags
    );
]]

--[[
#ifdef UNICODE
#define WNetAddConnection3  WNetAddConnection3W
#else
#define WNetAddConnection3  WNetAddConnection3A
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD 
WNetCancelConnectionA(
     LPCSTR lpName,
     BOOL     fForce
    );

DWORD 
WNetCancelConnectionW(
     LPCWSTR lpName,
     BOOL     fForce
    );
]]

--[[
#ifdef UNICODE
#define WNetCancelConnection  WNetCancelConnectionW
#else
#define WNetCancelConnection  WNetCancelConnectionA
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD 
WNetCancelConnection2A(
     LPCSTR lpName,
     DWORD    dwFlags,
     BOOL     fForce
    );

DWORD 
WNetCancelConnection2W(
     LPCWSTR lpName,
     DWORD    dwFlags,
     BOOL     fForce
    );
]]

--[[
#ifdef UNICODE
#define WNetCancelConnection2  WNetCancelConnection2W
#else
#define WNetCancelConnection2  WNetCancelConnection2A
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD 
WNetGetConnectionA(
     LPCSTR lpLocalName,
     LPSTR  lpRemoteName,
     LPDWORD lpnLength
    );

DWORD 
WNetGetConnectionW(
     LPCWSTR lpLocalName,
     LPWSTR  lpRemoteName,
     LPDWORD lpnLength
    );
]]

--[[
#ifdef UNICODE
#define WNetGetConnection  WNetGetConnectionW
#else
#define WNetGetConnection  WNetGetConnectionA
#endif // !UNICODE
--]]




ffi.cdef[[
DWORD 
WNetRestoreSingleConnectionW(
     HWND    hwndParent,
         LPCWSTR lpDevice,
         BOOL    fUseUI
    );




DWORD 
WNetUseConnectionA(
     HWND            hwndOwner,
         LPNETRESOURCEA  lpNetResource,
     LPCSTR        lpPassword,
     LPCSTR        lpUserId,
         DWORD           dwFlags,
     LPSTR lpAccessName,
     LPDWORD lpBufferSize,
     LPDWORD   lpResult
    );

DWORD 
WNetUseConnectionW(
     HWND            hwndOwner,
         LPNETRESOURCEW  lpNetResource,
     LPCWSTR        lpPassword,
     LPCWSTR        lpUserId,
         DWORD           dwFlags,
     LPWSTR lpAccessName,
     LPDWORD lpBufferSize,
     LPDWORD   lpResult
    );
]]

--[[
#ifdef UNICODE
#define WNetUseConnection  WNetUseConnectionW
#else
#define WNetUseConnection  WNetUseConnectionA
#endif // !UNICODE
--]]

ffi.cdef[[
//
//  Network Connection Dialogs.
//

DWORD 
WNetConnectionDialog(
     HWND  hwnd,
     DWORD dwType
    );


DWORD 
WNetDisconnectDialog(
     HWND hwnd,
     DWORD dwType
    );
]]

--[=[
#if(WINVER >= 0x0400)
typedef struct _CONNECTDLGSTRUCTA{
    DWORD cbStructure;       /* size of this structure in bytes */
    HWND hwndOwner;          /* owner window for the dialog */
    LPNETRESOURCEA lpConnRes;/* Requested Resource info    */
    DWORD dwFlags;           /* flags (see below) */
    DWORD dwDevNum;          /* number of devices connected to */
} CONNECTDLGSTRUCTA, FAR *LPCONNECTDLGSTRUCTA;
typedef struct _CONNECTDLGSTRUCTW{
    DWORD cbStructure;       /* size of this structure in bytes */
    HWND hwndOwner;          /* owner window for the dialog */
    LPNETRESOURCEW lpConnRes;/* Requested Resource info    */
    DWORD dwFlags;           /* flags (see below) */
    DWORD dwDevNum;          /* number of devices connected to */
} CONNECTDLGSTRUCTW, FAR *LPCONNECTDLGSTRUCTW;

#ifdef UNICODE
typedef CONNECTDLGSTRUCTW CONNECTDLGSTRUCT;
typedef LPCONNECTDLGSTRUCTW LPCONNECTDLGSTRUCT;
#else
typedef CONNECTDLGSTRUCTA CONNECTDLGSTRUCT;
typedef LPCONNECTDLGSTRUCTA LPCONNECTDLGSTRUCT;
#endif // UNICODE

#define CONNDLG_RO_PATH     0x00000001 /* Resource path should be read-only    */
#define CONNDLG_CONN_POINT  0x00000002 /* Netware -style movable connection point enabled */
#define CONNDLG_USE_MRU     0x00000004 /* Use MRU combobox  */
#define CONNDLG_HIDE_BOX    0x00000008 /* Hide persistent connect checkbox  */

/*
 * NOTE:  Set at most ONE of the below flags.  If neither flag is set,
 *        then the persistence is set to whatever the user chose during
 *        a previous connection
 */
#define CONNDLG_PERSIST     0x00000010 /* Force persistent connection */
#define CONNDLG_NOT_PERSIST 0x00000020 /* Force connection NOT persistent */


DWORD 
WNetConnectionDialog1A(
     LPCONNECTDLGSTRUCTA lpConnDlgStruct
    );

DWORD 
WNetConnectionDialog1W(
     LPCONNECTDLGSTRUCTW lpConnDlgStruct
    );
#ifdef UNICODE
#define WNetConnectionDialog1  WNetConnectionDialog1W
#else
#define WNetConnectionDialog1  WNetConnectionDialog1A
#endif // !UNICODE

typedef struct _DISCDLGSTRUCTA{
    DWORD           cbStructure;      /* size of this structure in bytes */
    HWND            hwndOwner;        /* owner window for the dialog */
    LPSTR           lpLocalName;      /* local device name */
    LPSTR           lpRemoteName;     /* network resource name */
    DWORD           dwFlags;          /* flags */
} DISCDLGSTRUCTA, FAR *LPDISCDLGSTRUCTA;
typedef struct _DISCDLGSTRUCTW{
    DWORD           cbStructure;      /* size of this structure in bytes */
    HWND            hwndOwner;        /* owner window for the dialog */
    LPWSTR          lpLocalName;      /* local device name */
    LPWSTR          lpRemoteName;     /* network resource name */
    DWORD           dwFlags;          /* flags */
} DISCDLGSTRUCTW, FAR *LPDISCDLGSTRUCTW;
#ifdef UNICODE
typedef DISCDLGSTRUCTW DISCDLGSTRUCT;
typedef LPDISCDLGSTRUCTW LPDISCDLGSTRUCT;
#else
typedef DISCDLGSTRUCTA DISCDLGSTRUCT;
typedef LPDISCDLGSTRUCTA LPDISCDLGSTRUCT;
#endif // UNICODE

#define DISC_UPDATE_PROFILE         0x00000001
#define DISC_NO_FORCE               0x00000040


DWORD 
WNetDisconnectDialog1A(
     LPDISCDLGSTRUCTA lpConnDlgStruct
    );

DWORD 
WNetDisconnectDialog1W(
     LPDISCDLGSTRUCTW lpConnDlgStruct
    );

--[[
#ifdef UNICODE
#define WNetDisconnectDialog1  WNetDisconnectDialog1W
#else
#define WNetDisconnectDialog1  WNetDisconnectDialog1A
#endif // !UNICODE
#endif /* WINVER >= 0x0400 */
--]]
--]=]

ffi.cdef[[
//
//  Network Browsing.
//


DWORD 
WNetOpenEnumA(
      DWORD          dwScope,
      DWORD          dwType,
      DWORD          dwUsage,
     LPNETRESOURCEA lpNetResource,
     LPHANDLE       lphEnum
    );

DWORD 
WNetOpenEnumW(
      DWORD          dwScope,
      DWORD          dwType,
      DWORD          dwUsage,
     LPNETRESOURCEW lpNetResource,
     LPHANDLE       lphEnum
    );
]]

--[[
#ifdef UNICODE
#define WNetOpenEnum  WNetOpenEnumW
#else
#define WNetOpenEnum  WNetOpenEnumA
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD 
WNetEnumResourceA(
        HANDLE  hEnum,
     LPDWORD lpcCount,
     LPVOID  lpBuffer,
     LPDWORD lpBufferSize
    );

DWORD 
WNetEnumResourceW(
        HANDLE  hEnum,
     LPDWORD lpcCount,
     LPVOID  lpBuffer,
     LPDWORD lpBufferSize
    );
]]

--[[
#ifdef UNICODE
#define WNetEnumResource  WNetEnumResourceW
#else
#define WNetEnumResource  WNetEnumResourceA
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD 
WNetCloseEnum(
     HANDLE   hEnum
    );
]]

--[=[
#if(WINVER >= 0x0400)

DWORD 
WNetGetResourceParentA(
     LPNETRESOURCEA lpNetResource,
     LPVOID lpBuffer,
     LPDWORD lpcbBuffer
    );

DWORD 
WNetGetResourceParentW(
     LPNETRESOURCEW lpNetResource,
     LPVOID lpBuffer,
     LPDWORD lpcbBuffer
    );

--[[
#ifdef UNICODE
#define WNetGetResourceParent  WNetGetResourceParentW
#else
#define WNetGetResourceParent  WNetGetResourceParentA
#endif // !UNICODE
--]]

DWORD 
WNetGetResourceInformationA(
     LPNETRESOURCEA  lpNetResource,
     LPVOID lpBuffer,
     LPDWORD lpcbBuffer,
    _Outptr_ LPSTR *lplpSystem
    );

DWORD 
WNetGetResourceInformationW(
     LPNETRESOURCEW  lpNetResource,
     LPVOID lpBuffer,
     LPDWORD lpcbBuffer,
    _Outptr_ LPWSTR *lplpSystem
    );
#ifdef UNICODE
#define WNetGetResourceInformation  WNetGetResourceInformationW
#else
#define WNetGetResourceInformation  WNetGetResourceInformationA
#endif // !UNICODE
#endif /* WINVER >= 0x0400 */

//
//  Universal Naming.
//

#define UNIVERSAL_NAME_INFO_LEVEL   0x00000001
#define REMOTE_NAME_INFO_LEVEL      0x00000002

typedef struct  _UNIVERSAL_NAME_INFOA {
    LPSTR    lpUniversalName;
}UNIVERSAL_NAME_INFOA, *LPUNIVERSAL_NAME_INFOA;
typedef struct  _UNIVERSAL_NAME_INFOW {
    LPWSTR   lpUniversalName;
}UNIVERSAL_NAME_INFOW, *LPUNIVERSAL_NAME_INFOW;
#ifdef UNICODE
typedef UNIVERSAL_NAME_INFOW UNIVERSAL_NAME_INFO;
typedef LPUNIVERSAL_NAME_INFOW LPUNIVERSAL_NAME_INFO;
#else
typedef UNIVERSAL_NAME_INFOA UNIVERSAL_NAME_INFO;
typedef LPUNIVERSAL_NAME_INFOA LPUNIVERSAL_NAME_INFO;
#endif // UNICODE

typedef struct  _REMOTE_NAME_INFOA {
    LPSTR    lpUniversalName;
    LPSTR    lpConnectionName;
    LPSTR    lpRemainingPath;
}REMOTE_NAME_INFOA, *LPREMOTE_NAME_INFOA;
typedef struct  _REMOTE_NAME_INFOW {
    LPWSTR   lpUniversalName;
    LPWSTR   lpConnectionName;
    LPWSTR   lpRemainingPath;
}REMOTE_NAME_INFOW, *LPREMOTE_NAME_INFOW;
#ifdef UNICODE
typedef REMOTE_NAME_INFOW REMOTE_NAME_INFO;
typedef LPREMOTE_NAME_INFOW LPREMOTE_NAME_INFO;
#else
typedef REMOTE_NAME_INFOA REMOTE_NAME_INFO;
typedef LPREMOTE_NAME_INFOA LPREMOTE_NAME_INFO;
#endif // UNICODE


DWORD 
WNetGetUniversalNameA(
     LPCSTR lpLocalPath,
     DWORD    dwInfoLevel,
     LPVOID lpBuffer,
     LPDWORD lpBufferSize
    );

DWORD 
WNetGetUniversalNameW(
     LPCWSTR lpLocalPath,
     DWORD    dwInfoLevel,
     LPVOID lpBuffer,
     LPDWORD lpBufferSize
    );
#ifdef UNICODE
#define WNetGetUniversalName  WNetGetUniversalNameW
#else
#define WNetGetUniversalName  WNetGetUniversalNameA
#endif // !UNICODE

//
//  Authentication and Logon/Logoff.
//

DWORD 
WNetGetUserA(
     LPCSTR  lpName,
    _Out_writes_(*lpnLength) LPSTR lpUserName,
      LPDWORD lpnLength
    );
//
//  Authentication and Logon/Logoff.
//

DWORD 
WNetGetUserW(
     LPCWSTR  lpName,
    _Out_writes_(*lpnLength) LPWSTR lpUserName,
      LPDWORD lpnLength
    );
#ifdef UNICODE
#define WNetGetUser  WNetGetUserW
#else
#define WNetGetUser  WNetGetUserA
#endif // !UNICODE



//
// Other.
//

#if(WINVER >= 0x0400)
#define WNFMT_MULTILINE         0x01
#define WNFMT_ABBREVIATED       0x02
#define WNFMT_INENUM            0x10
#define WNFMT_CONNECTION        0x20
#endif /* WINVER >= 0x0400 */


#if(WINVER >= 0x0400)

DWORD 
WNetGetProviderNameA(
        DWORD   dwNetType,
    _Out_writes_(*lpBufferSize) LPSTR lpProviderName,
     LPDWORD lpBufferSize
    );

DWORD 
WNetGetProviderNameW(
        DWORD   dwNetType,
    _Out_writes_(*lpBufferSize) LPWSTR lpProviderName,
     LPDWORD lpBufferSize
    );
#ifdef UNICODE
#define WNetGetProviderName  WNetGetProviderNameW
#else
#define WNetGetProviderName  WNetGetProviderNameA
#endif // !UNICODE

typedef struct _NETINFOSTRUCT{
    DWORD cbStructure;
    DWORD dwProviderVersion;
    DWORD dwStatus;
    DWORD dwCharacteristics;
    ULONG_PTR dwHandle;
    WORD  wNetType;
    DWORD dwPrinters;
    DWORD dwDrives;
} NETINFOSTRUCT, FAR *LPNETINFOSTRUCT;

#define NETINFO_DLL16       0x00000001  /* Provider running as 16 bit Winnet Driver */
#define NETINFO_DISKRED     0x00000004  /* Provider requires disk redirections to connect */
#define NETINFO_PRINTERRED  0x00000008  /* Provider requires printer redirections to connect */


DWORD 
WNetGetNetworkInformationA(
      LPCSTR        lpProvider,
     LPNETINFOSTRUCT lpNetInfoStruct
    );

DWORD 
WNetGetNetworkInformationW(
      LPCWSTR        lpProvider,
     LPNETINFOSTRUCT lpNetInfoStruct
    );
#ifdef UNICODE
#define WNetGetNetworkInformation  WNetGetNetworkInformationW
#else
#define WNetGetNetworkInformation  WNetGetNetworkInformationA
#endif // !UNICODE

#endif /* WINVER >= 0x0400 */

//
//  Error handling.
//


DWORD 
WNetGetLastErrorA(
     LPDWORD    lpError,
    _Out_writes_(nErrorBufSize) LPSTR lpErrorBuf,
     DWORD      nErrorBufSize,
    _Out_writes_(nNameBufSize) LPSTR  lpNameBuf,
     DWORD      nNameBufSize
    );

DWORD 
WNetGetLastErrorW(
     LPDWORD    lpError,
    _Out_writes_(nErrorBufSize) LPWSTR lpErrorBuf,
     DWORD      nErrorBufSize,
    _Out_writes_(nNameBufSize) LPWSTR  lpNameBuf,
     DWORD      nNameBufSize
    );
#ifdef UNICODE
#define WNetGetLastError  WNetGetLastErrorW
#else
#define WNetGetLastError  WNetGetLastErrorA
#endif // !UNICODE

//
//  STATUS CODES
//

// General

#define WN_SUCCESS                      NO_ERROR
#define WN_NO_ERROR                     NO_ERROR
#define WN_NOT_SUPPORTED                ERROR_NOT_SUPPORTED
#define WN_CANCEL                       ERROR_CANCELLED
#define WN_RETRY                        ERROR_RETRY
#define WN_NET_ERROR                    ERROR_UNEXP_NET_ERR
#define WN_MORE_DATA                    ERROR_MORE_DATA
#define WN_BAD_POINTER                  ERROR_INVALID_ADDRESS
#define WN_BAD_VALUE                    ERROR_INVALID_PARAMETER
#define WN_BAD_USER                     ERROR_BAD_USERNAME
#define WN_BAD_PASSWORD                 ERROR_INVALID_PASSWORD
#define WN_ACCESS_DENIED                ERROR_ACCESS_DENIED
#define WN_FUNCTION_BUSY                ERROR_BUSY
#define WN_WINDOWS_ERROR                ERROR_UNEXP_NET_ERR
#define WN_OUT_OF_MEMORY                ERROR_NOT_ENOUGH_MEMORY
#define WN_NO_NETWORK                   ERROR_NO_NETWORK
#define WN_EXTENDED_ERROR               ERROR_EXTENDED_ERROR
#define WN_BAD_LEVEL                    ERROR_INVALID_LEVEL
#define WN_BAD_HANDLE                   ERROR_INVALID_HANDLE
#if(WINVER >= 0x0400)
#define WN_NOT_INITIALIZING             ERROR_ALREADY_INITIALIZED
#define WN_NO_MORE_DEVICES              ERROR_NO_MORE_DEVICES
#endif /* WINVER >= 0x0400 */

// Connection

#define WN_NOT_CONNECTED                       ERROR_NOT_CONNECTED
#define WN_OPEN_FILES                          ERROR_OPEN_FILES
#define WN_DEVICE_IN_USE                       ERROR_DEVICE_IN_USE
#define WN_BAD_NETNAME                         ERROR_BAD_NET_NAME
#define WN_BAD_LOCALNAME                       ERROR_BAD_DEVICE
#define WN_ALREADY_CONNECTED                   ERROR_ALREADY_ASSIGNED
#define WN_DEVICE_ERROR                        ERROR_GEN_FAILURE
#define WN_CONNECTION_CLOSED                   ERROR_CONNECTION_UNAVAIL
#define WN_NO_NET_OR_BAD_PATH                  ERROR_NO_NET_OR_BAD_PATH
#define WN_BAD_PROVIDER                        ERROR_BAD_PROVIDER
#define WN_CANNOT_OPEN_PROFILE                 ERROR_CANNOT_OPEN_PROFILE
#define WN_BAD_PROFILE                         ERROR_BAD_PROFILE
#define WN_BAD_DEV_TYPE                        ERROR_BAD_DEV_TYPE
#define WN_DEVICE_ALREADY_REMEMBERED           ERROR_DEVICE_ALREADY_REMEMBERED
#define WN_CONNECTED_OTHER_PASSWORD            ERROR_CONNECTED_OTHER_PASSWORD
#if(WINVER >= 0x0501)
#define WN_CONNECTED_OTHER_PASSWORD_DEFAULT    ERROR_CONNECTED_OTHER_PASSWORD_DEFAULT
#endif /* WINVER >= 0x0501 */

// Enumeration

#define WN_NO_MORE_ENTRIES              ERROR_NO_MORE_ITEMS
#define WN_NOT_CONTAINER                ERROR_NOT_CONTAINER

#if(WINVER >= 0x0400)
// Authentication

#define WN_NOT_AUTHENTICATED            ERROR_NOT_AUTHENTICATED
#define WN_NOT_LOGGED_ON                ERROR_NOT_LOGGED_ON
#define WN_NOT_VALIDATED                ERROR_NO_LOGON_SERVERS
#endif /* WINVER >= 0x0400 */

//
//  For Shell
//

#if(WINVER >= 0x0400)
typedef struct _NETCONNECTINFOSTRUCT{
    DWORD cbStructure;
    DWORD dwFlags;
    DWORD dwSpeed;
    DWORD dwDelay;
    DWORD dwOptDataSize;
} NETCONNECTINFOSTRUCT,  *LPNETCONNECTINFOSTRUCT;

#define WNCON_FORNETCARD        0x00000001
#define WNCON_NOTROUTED         0x00000002
#define WNCON_SLOWLINK          0x00000004
#define WNCON_DYNAMIC           0x00000008


DWORD 
MultinetGetConnectionPerformanceA(
      LPNETRESOURCEA lpNetResource,
     LPNETCONNECTINFOSTRUCT lpNetConnectInfoStruct
    );

DWORD 
MultinetGetConnectionPerformanceW(
      LPNETRESOURCEW lpNetResource,
     LPNETCONNECTINFOSTRUCT lpNetConnectInfoStruct
    );

#ifdef UNICODE
#define MultinetGetConnectionPerformance  MultinetGetConnectionPerformanceW
#else
#define MultinetGetConnectionPerformance  MultinetGetConnectionPerformanceA
#endif // !UNICODE

#endif /* WINVER >= 0x0400 */


--]=]

return ffi.load('mpr')