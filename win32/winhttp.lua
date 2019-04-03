--[[
/*++

Copyright (c) Microsoft Corporation. All rights reserved.

Module Name:

    winhttp.h

Abstract:

    Contains manifests, macros, types and prototypes for Windows HTTP Services

--*/
--]]

local ffi = require("ffi")

if not _WINHTTPX_ then
_WINHTTPX_ = true

require("win32.winapifamily")


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

--[[
/*
 * Set up Structure Packing to be 4 bytes for all winhttp structures
 */

#if defined(_WIN64)
#include <pshpack8.h>
#else
#include <pshpack4.h>
#endif
--]]

--[[
#if !defined(_WINHTTP_INTERNAL_)
#define  DECLSPEC_IMPORT
#else
#define 

#endif
--]]

ffi.cdef[[
//
// types
//

typedef LPVOID HINTERNET;
typedef HINTERNET * LPHINTERNET;

typedef WORD INTERNET_PORT;
typedef INTERNET_PORT * LPINTERNET_PORT;
]]

ffi.cdef[[
//
// manifests
//

static const int INTERNET_DEFAULT_PORT         =  0;           // use the protocol-specific default
static const int INTERNET_DEFAULT_HTTP_PORT    =  80;          //    "     "  HTTP   "
static const int INTERNET_DEFAULT_HTTPS_PORT   =  443;         //    "     "  HTTPS  "
]]

ffi.cdef[[
// flags for WinHttpOpen():
static const int WINHTTP_FLAG_ASYNC            =  0x10000000;  // this session is asynchronous (where supported)

// flags for WinHttpOpenRequest():
static const int WINHTTP_FLAG_SECURE              =  0x00800000;  // use SSL if applicable (HTTPS)
static const int WINHTTP_FLAG_ESCAPE_PERCENT      =  0x00000004;  // if escaping enabled, escape percent as well
static const int WINHTTP_FLAG_NULL_CODEPAGE       =  0x00000008;  // assume all symbols are ASCII, use fast convertion
static const int WINHTTP_FLAG_BYPASS_PROXY_CACHE  =  0x00000100; // add "pragma: no-cache" request header
static const int WINHTTP_FLAG_REFRESH             =  WINHTTP_FLAG_BYPASS_PROXY_CACHE;
static const int WINHTTP_FLAG_ESCAPE_DISABLE      =  0x00000040;  // disable escaping
static const int WINHTTP_FLAG_ESCAPE_DISABLE_QUERY=  0x00000080;  // if escaping enabled escape path part, but do not escape query


static const int SECURITY_FLAG_IGNORE_UNKNOWN_CA        = 0x00000100;
static const int SECURITY_FLAG_IGNORE_CERT_DATE_INVALID = 0x00002000; // expired X509 Cert.
static const int SECURITY_FLAG_IGNORE_CERT_CN_INVALID   = 0x00001000; // bad common name in X509 Cert.
static const int SECURITY_FLAG_IGNORE_CERT_WRONG_USAGE  = 0x00000200;
]]

ffi.cdef[[
//
// WINHTTP_ASYNC_RESULT - this structure is returned to the application via
// the callback with WINHTTP_CALLBACK_STATUS_REQUEST_COMPLETE. It is not sufficient to
// just return the result of the async operation. If the API failed then the
// app cannot call GetLastError() because the thread context will be incorrect.
// Both the value returned by the async API and any resultant error code are
// made available. The app need not check dwError if dwResult indicates that
// the API succeeded (in this case dwError will be ERROR_SUCCESS)
//

typedef struct
{
    DWORD_PTR dwResult;  // indicates which async API has encountered an error
    DWORD dwError;       // the error code if the API failed
}
WINHTTP_ASYNC_RESULT, * LPWINHTTP_ASYNC_RESULT;


//
// HTTP_VERSION_INFO - query or set global HTTP version (1.0 or 1.1)
//

typedef struct
{
    DWORD dwMajorVersion;
    DWORD dwMinorVersion;
}
HTTP_VERSION_INFO, * LPHTTP_VERSION_INFO;
]]

ffi.cdef[[
//
// INTERNET_SCHEME - URL scheme type
//

typedef int INTERNET_SCHEME, * LPINTERNET_SCHEME;

static const int INTERNET_SCHEME_HTTP       = (1);
static const int INTERNET_SCHEME_HTTPS      = (2);
static const int INTERNET_SCHEME_FTP        = (3);
static const int INTERNET_SCHEME_SOCKS      = (4);
]]

ffi.cdef[[
//
// URL_COMPONENTS - the constituent parts of an URL. Used in WinHttpCrackUrl()
// and WinHttpCreateUrl()
//
// For WinHttpCrackUrl(), if a pointer field and its corresponding length field
// are both 0 then that component is not returned. If the pointer field is NULL
// but the length field is not zero, then both the pointer and length fields are
// returned if both pointer and corresponding length fields are non-zero then
// the pointer field points to a buffer where the component is copied. The
// component may be un-escaped, depending on dwFlags
//
// For WinHttpCreateUrl(), the pointer fields should be NULL if the component
// is not required. If the corresponding length field is zero then the pointer
// field is the address of a zero-terminated string. If the length field is not
// zero then it is the string length of the corresponding pointer field
//

typedef struct
{
    DWORD   dwStructSize;       // size of this structure. Used in version check
    LPWSTR  lpszScheme;         // pointer to scheme name
    DWORD   dwSchemeLength;     // length of scheme name
    INTERNET_SCHEME nScheme;    // enumerated scheme type (if known)
    LPWSTR  lpszHostName;       // pointer to host name
    DWORD   dwHostNameLength;   // length of host name
    INTERNET_PORT nPort;        // converted port number
    LPWSTR  lpszUserName;       // pointer to user name
    DWORD   dwUserNameLength;   // length of user name
    LPWSTR  lpszPassword;       // pointer to password
    DWORD   dwPasswordLength;   // length of password
    LPWSTR  lpszUrlPath;        // pointer to URL-path
    DWORD   dwUrlPathLength;    // length of URL-path
    LPWSTR  lpszExtraInfo;      // pointer to extra information (e.g. ?foo or #foo)
    DWORD   dwExtraInfoLength;  // length of extra information
}
URL_COMPONENTS, * LPURL_COMPONENTS;

typedef URL_COMPONENTS URL_COMPONENTSW;
typedef LPURL_COMPONENTS LPURL_COMPONENTSW;
]]

ffi.cdef[[
//
// WINHTTP_PROXY_INFO - structure supplied with WINHTTP_OPTION_PROXY to get/
// set proxy information on a WinHttpOpen() handle
//

typedef struct
{
    DWORD  dwAccessType;      // see WINHTTP_ACCESS_* types below
    LPWSTR lpszProxy;         // proxy server list
    LPWSTR lpszProxyBypass;   // proxy bypass list
}
WINHTTP_PROXY_INFO, * LPWINHTTP_PROXY_INFO;

typedef WINHTTP_PROXY_INFO WINHTTP_PROXY_INFOW;
typedef LPWINHTTP_PROXY_INFO LPWINHTTP_PROXY_INFOW;
]]

ffi.cdef[[
typedef struct
{
    DWORD   dwFlags;
    DWORD   dwAutoDetectFlags;
    LPCWSTR lpszAutoConfigUrl;
    LPVOID  lpvReserved;
    DWORD   dwReserved;
    BOOL    fAutoLogonIfChallenged;
}
WINHTTP_AUTOPROXY_OPTIONS;
]]

ffi.cdef[[
static const int WINHTTP_AUTOPROXY_AUTO_DETECT           = 0x00000001;
static const int WINHTTP_AUTOPROXY_CONFIG_URL            = 0x00000002;
static const int WINHTTP_AUTOPROXY_HOST_KEEPCASE         = 0x00000004;
static const int WINHTTP_AUTOPROXY_HOST_LOWERCASE        = 0x00000008;
static const int WINHTTP_AUTOPROXY_ALLOW_AUTOCONFIG      = 0x00000100;
static const int WINHTTP_AUTOPROXY_ALLOW_STATIC          = 0x00000200;
static const int WINHTTP_AUTOPROXY_ALLOW_CM              = 0x00000400;
static const int WINHTTP_AUTOPROXY_RUN_INPROCESS         = 0x00010000;
static const int WINHTTP_AUTOPROXY_RUN_OUTPROCESS_ONLY   = 0x00020000;
static const int WINHTTP_AUTOPROXY_NO_DIRECTACCESS       = 0x00040000;
static const int WINHTTP_AUTOPROXY_NO_CACHE_CLIENT       = 0x00080000;
static const int WINHTTP_AUTOPROXY_NO_CACHE_SVC          = 0x00100000;


static const int WINHTTP_AUTOPROXY_SORT_RESULTS          = 0x00400000;
]]

ffi.cdef[[
//
// Flags for dwAutoDetectFlags
//
static const int WINHTTP_AUTO_DETECT_TYPE_DHCP           = 0x00000001;
static const int WINHTTP_AUTO_DETECT_TYPE_DNS_A          = 0x00000002;
]]

ffi.cdef[[
//
// WINHTTP_PROXY_RESULT - structure containing parsed proxy result,
// see WinHttpGetProxyForUrlEx and WinHttpGetProxyResult, use WinHttpFreeProxyResult to free its members.
//

typedef struct _WINHTTP_PROXY_RESULT_ENTRY
{
    BOOL            fProxy;                // Is this a proxy or DIRECT?
    BOOL            fBypass;               // If DIRECT, is it bypassing a proxy (intranet) or is all traffic DIRECT (internet)
    INTERNET_SCHEME ProxyScheme;           // The scheme of the proxy, SOCKS, HTTP (CERN Proxy), HTTPS (SSL through Proxy)
    PWSTR           pwszProxy;             // Hostname of the proxy.
    INTERNET_PORT   ProxyPort;             // Port of the proxy.
} WINHTTP_PROXY_RESULT_ENTRY;

typedef struct _WINHTTP_PROXY_RESULT
{
    DWORD cEntries;
    WINHTTP_PROXY_RESULT_ENTRY *pEntries;
} WINHTTP_PROXY_RESULT;

typedef struct _WINHTTP_PROXY_RESULT_EX
{
    DWORD cEntries;
    WINHTTP_PROXY_RESULT_ENTRY *pEntries;
    HANDLE hProxyDetectionHandle;
    DWORD dwProxyInterfaceAffinity;
} WINHTTP_PROXY_RESULT_EX;
]]

ffi.cdef[[
static const int NETWORKING_KEY_BUFSIZE = 128;

typedef struct _WinHttpProxyNetworkKey
{
    unsigned char pbBuffer[NETWORKING_KEY_BUFSIZE];
} WINHTTP_PROXY_NETWORKING_KEY, *PWINHTTP_PROXY_NETWORKING_KEY;

typedef struct _WINHTTP_PROXY_SETTINGS
{
    DWORD dwStructSize;
    DWORD dwFlags;
    DWORD dwCurrentSettingsVersion;
    PWSTR pwszConnectionName;
    PWSTR pwszProxy;
    PWSTR pwszProxyBypass;
    PWSTR pwszAutoconfigUrl;
    PWSTR pwszAutoconfigSecondaryUrl;
    DWORD dwAutoDiscoveryFlags;
    PWSTR pwszLastKnownGoodAutoConfigUrl;
    DWORD dwAutoconfigReloadDelayMins;
    FILETIME ftLastKnownDetectTime;
    DWORD dwDetectedInterfaceIpCount;
    PDWORD pdwDetectedInterfaceIp;
    DWORD cNetworkKeys;
    PWINHTTP_PROXY_NETWORKING_KEY pNetworkKeys;
} WINHTTP_PROXY_SETTINGS, *PWINHTTP_PROXY_SETTINGS;
]]

ffi.cdef[[
//
// WINHTTP_CERTIFICATE_INFO lpBuffer - contains the certificate returned from
// the server
//

typedef struct
{
    //
    // ftExpiry - date the certificate expires.
    //

    FILETIME ftExpiry;

    //
    // ftStart - date the certificate becomes valid.
    //

    FILETIME ftStart;

    //
    // lpszSubjectInfo - the name of organization, site, and server
    //   the cert. was issued for.
    //

    LPWSTR lpszSubjectInfo;

    //
    // lpszIssuerInfo - the name of orgainzation, site, and server
    //   the cert was issues by.
    //

    LPWSTR lpszIssuerInfo;

    //
    // lpszProtocolName - the name of the protocol used to provide the secure
    //   connection.
    //

    LPWSTR lpszProtocolName;

    //
    // lpszSignatureAlgName - the name of the algorithm used for signing
    //  the certificate.
    //

    LPWSTR lpszSignatureAlgName;

    //
    // lpszEncryptionAlgName - the name of the algorithm used for
    //  doing encryption over the secure channel (SSL) connection.
    //

    LPWSTR lpszEncryptionAlgName;

    //
    // dwKeySize - size of the key.
    //

    DWORD dwKeySize;

} WINHTTP_CERTIFICATE_INFO;
]]

if _WS2DEF_ then
ffi.cdef[[
typedef struct
{
    DWORD cbSize;
    SOCKADDR_STORAGE LocalAddress;  // local ip, local port
    SOCKADDR_STORAGE RemoteAddress; // remote ip, remote port

} WINHTTP_CONNECTION_INFO;
]]
end

ffi.cdef[[
//
// constants for WinHttpTimeFromSystemTime
//

static const int  WINHTTP_TIME_FORMAT_BUFSIZE   = 62;
]]

ffi.cdef[[
//
// options manifests for WinHttp{Query|Set}Option
//


static const int WINHTTP_OPTION_CALLBACK                      =  1;
static const int WINHTTP_OPTION_RESOLVE_TIMEOUT               =  2;
static const int WINHTTP_OPTION_CONNECT_TIMEOUT               =  3;
static const int WINHTTP_OPTION_CONNECT_RETRIES               =  4;
static const int WINHTTP_OPTION_SEND_TIMEOUT                  =  5;
static const int WINHTTP_OPTION_RECEIVE_TIMEOUT               =  6;
static const int WINHTTP_OPTION_RECEIVE_RESPONSE_TIMEOUT      =  7;
static const int WINHTTP_OPTION_HANDLE_TYPE                   =  9;
static const int WINHTTP_OPTION_READ_BUFFER_SIZE              = 12;
static const int WINHTTP_OPTION_WRITE_BUFFER_SIZE             = 13;
static const int WINHTTP_OPTION_PARENT_HANDLE                 = 21;
static const int WINHTTP_OPTION_EXTENDED_ERROR                = 24;
static const int WINHTTP_OPTION_SECURITY_FLAGS                = 31;
static const int WINHTTP_OPTION_SECURITY_CERTIFICATE_STRUCT   = 32;
static const int WINHTTP_OPTION_URL                           = 34;
static const int WINHTTP_OPTION_SECURITY_KEY_BITNESS          = 36;
static const int WINHTTP_OPTION_PROXY                         = 38;
static const int WINHTTP_OPTION_PROXY_RESULT_ENTRY            = 39;


static const int WINHTTP_OPTION_USER_AGENT                    = 41;
static const int WINHTTP_OPTION_CONTEXT_VALUE                 = 45;
static const int WINHTTP_OPTION_CLIENT_CERT_CONTEXT           = 47;
static const int WINHTTP_OPTION_REQUEST_PRIORITY              = 58;
static const int WINHTTP_OPTION_HTTP_VERSION                  = 59;
static const int WINHTTP_OPTION_DISABLE_FEATURE               = 63;

static const int WINHTTP_OPTION_CODEPAGE                      = 68;
static const int WINHTTP_OPTION_MAX_CONNS_PER_SERVER          = 73;
static const int WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER      = 74;
static const int WINHTTP_OPTION_AUTOLOGON_POLICY              = 77;
static const int WINHTTP_OPTION_SERVER_CERT_CONTEXT           = 78;
static const int WINHTTP_OPTION_ENABLE_FEATURE                = 79;
static const int WINHTTP_OPTION_WORKER_THREAD_COUNT           = 80;
static const int WINHTTP_OPTION_PASSPORT_COBRANDING_TEXT      = 81;
static const int WINHTTP_OPTION_PASSPORT_COBRANDING_URL       = 82;
static const int WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH       = 83;
static const int WINHTTP_OPTION_SECURE_PROTOCOLS              = 84;
static const int WINHTTP_OPTION_ENABLETRACING                 = 85;
static const int WINHTTP_OPTION_PASSPORT_SIGN_OUT             = 86;
static const int WINHTTP_OPTION_PASSPORT_RETURN_URL           = 87;
static const int WINHTTP_OPTION_REDIRECT_POLICY               = 88;
static const int WINHTTP_OPTION_MAX_HTTP_AUTOMATIC_REDIRECTS  = 89;
static const int WINHTTP_OPTION_MAX_HTTP_STATUS_CONTINUE      = 90;
static const int WINHTTP_OPTION_MAX_RESPONSE_HEADER_SIZE      = 91;
static const int WINHTTP_OPTION_MAX_RESPONSE_DRAIN_SIZE       = 92;
static const int WINHTTP_OPTION_CONNECTION_INFO               = 93;
static const int WINHTTP_OPTION_CLIENT_CERT_ISSUER_LIST       = 94;
static const int WINHTTP_OPTION_SPN                           = 96;

static const int WINHTTP_OPTION_GLOBAL_PROXY_CREDS             =97;
static const int WINHTTP_OPTION_GLOBAL_SERVER_CREDS            =98;

static const int WINHTTP_OPTION_UNLOAD_NOTIFY_EVENT            =99;
static const int WINHTTP_OPTION_REJECT_USERPWD_IN_URL          =100;
static const int WINHTTP_OPTION_USE_GLOBAL_SERVER_CREDENTIALS  =101;


static const int WINHTTP_OPTION_RECEIVE_PROXY_CONNECT_RESPONSE =103;
static const int WINHTTP_OPTION_IS_PROXY_CONNECT_RESPONSE      =104;


static const int WINHTTP_OPTION_SERVER_SPN_USED               = 106;
static const int WINHTTP_OPTION_PROXY_SPN_USED                = 107;

static const int WINHTTP_OPTION_SERVER_CBT                    = 108;


static const int WINHTTP_OPTION_UNSAFE_HEADER_PARSING          =110;
static const int WINHTTP_OPTION_ASSURED_NON_BLOCKING_CALLBACKS =111;


static const int WINHTTP_OPTION_UPGRADE_TO_WEB_SOCKET         = 114;
static const int WINHTTP_OPTION_WEB_SOCKET_CLOSE_TIMEOUT      = 115;
static const int WINHTTP_OPTION_WEB_SOCKET_KEEPALIVE_INTERVAL = 116;


static const int WINHTTP_OPTION_DECOMPRESSION                 = 118;


static const int WINHTTP_OPTION_WEB_SOCKET_RECEIVE_BUFFER_SIZE= 122;
static const int WINHTTP_OPTION_WEB_SOCKET_SEND_BUFFER_SIZE   = 123;


static const int WINHTTP_OPTION_TCP_PRIORITY_HINT           =   128;


static const int WINHTTP_OPTION_CONNECTION_FILTER           =   131;


static const int WINHTTP_OPTION_ENABLE_HTTP_PROTOCOL        =   133;
static const int WINHTTP_OPTION_HTTP_PROTOCOL_USED          =   134;


static const int WINHTTP_OPTION_KDC_PROXY_SETTINGS          =   136;


static const int WINHTTP_OPTION_ENCODE_EXTRA                =   138;
static const int WINHTTP_OPTION_DISABLE_STREAM_QUEUE        =   139;

static const int WINHTTP_LAST_OPTION                        =   WINHTTP_OPTION_DISABLE_STREAM_QUEUE;

static const int WINHTTP_OPTION_USERNAME                    =  0x1000;
static const int WINHTTP_OPTION_PASSWORD                    =  0x1001;
static const int WINHTTP_OPTION_PROXY_USERNAME              =  0x1002;
static const int WINHTTP_OPTION_PROXY_PASSWORD              =  0x1003;

static const int WINHTTP_FIRST_OPTION                       =  WINHTTP_OPTION_CALLBACK;
]]

ffi.cdef[[
// manifest value for WINHTTP_OPTION_MAX_CONNS_PER_SERVER and WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER
static const int WINHTTP_CONNS_PER_SERVER_UNLIMITED    = 0xFFFFFFFF;

//
// Values for WINHTTP_OPTION_DECOMPRESSION
//

static const int WINHTTP_DECOMPRESSION_FLAG_GZIP     = 0x00000001;
static const int WINHTTP_DECOMPRESSION_FLAG_DEFLATE  = 0x00000002;

static const int WINHTTP_DECOMPRESSION_FLAG_ALL = ( \
    WINHTTP_DECOMPRESSION_FLAG_GZIP    | \
    WINHTTP_DECOMPRESSION_FLAG_DEFLATE);
]]

ffi.cdef[[
//
// Values for WINHTTP_OPTION_ENABLE_HTTP_PROTOCOL / WINHTTP_OPTION_HTTP_PROTOCOL_USED
//

static const int WINHTTP_PROTOCOL_FLAG_HTTP2 =0x1;
static const int WINHTTP_PROTOCOL_MASK =(WINHTTP_PROTOCOL_FLAG_HTTP2);
]]

ffi.cdef[[
// values for WINHTTP_OPTION_AUTOLOGON_POLICY
static const int WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM  = 0;
static const int WINHTTP_AUTOLOGON_SECURITY_LEVEL_LOW     = 1;
static const int WINHTTP_AUTOLOGON_SECURITY_LEVEL_HIGH    = 2;

static const int WINHTTP_AUTOLOGON_SECURITY_LEVEL_DEFAULT      =  WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM;
]]

ffi.cdef[[
// values for WINHTTP_OPTION_REDIRECT_POLICY
static const int WINHTTP_OPTION_REDIRECT_POLICY_NEVER                       = 0;
static const int WINHTTP_OPTION_REDIRECT_POLICY_DISALLOW_HTTPS_TO_HTTP      = 1;
static const int WINHTTP_OPTION_REDIRECT_POLICY_ALWAYS                      = 2;

static const int WINHTTP_OPTION_REDIRECT_POLICY_LAST          =  WINHTTP_OPTION_REDIRECT_POLICY_ALWAYS;
static const int WINHTTP_OPTION_REDIRECT_POLICY_DEFAULT       =  WINHTTP_OPTION_REDIRECT_POLICY_DISALLOW_HTTPS_TO_HTTP;

static const int WINHTTP_DISABLE_PASSPORT_AUTH   = 0x00000000;
static const int WINHTTP_ENABLE_PASSPORT_AUTH    = 0x10000000;
static const int WINHTTP_DISABLE_PASSPORT_KEYRING= 0x20000000;
static const int WINHTTP_ENABLE_PASSPORT_KEYRING = 0x40000000;
]]

ffi.cdef[[
// values for WINHTTP_OPTION_DISABLE_FEATURE
static const int WINHTTP_DISABLE_COOKIES                =   0x00000001;
static const int WINHTTP_DISABLE_REDIRECTS              =   0x00000002;
static const int WINHTTP_DISABLE_AUTHENTICATION         =   0x00000004;
static const int WINHTTP_DISABLE_KEEP_ALIVE             =   0x00000008;
]]

ffi.cdef[[
// values for WINHTTP_OPTION_ENABLE_FEATURE
static const int WINHTTP_ENABLE_SSL_REVOCATION           =  0x00000001;
static const int WINHTTP_ENABLE_SSL_REVERT_IMPERSONATION =  0x00000002;
]]

ffi.cdef[[
// values for WINHTTP_OPTION_SPN
static const int WINHTTP_DISABLE_SPN_SERVER_PORT          = 0x00000000;
static const int WINHTTP_ENABLE_SPN_SERVER_PORT           = 0x00000001;
static const int WINHTTP_OPTION_SPN_MASK                  = WINHTTP_ENABLE_SPN_SERVER_PORT;
]]

ffi.cdef[[
typedef struct tagWINHTTP_CREDS
{
    LPSTR lpszUserName;
    LPSTR lpszPassword;
    LPSTR lpszRealm;
    DWORD dwAuthScheme;
    LPSTR lpszHostName;
    DWORD dwPort;
} WINHTTP_CREDS, *PWINHTTP_CREDS;

// structure for WINHTTP_OPTION_GLOBAL_SERVER_CREDS and
// WINHTTP_OPTION_GLOBAL_PROXY_CREDS
typedef struct tagWINHTTP_CREDS_EX
{
    LPSTR lpszUserName;
    LPSTR lpszPassword;
    LPSTR lpszRealm;
    DWORD dwAuthScheme;
    LPSTR lpszHostName;
    DWORD dwPort;
    LPSTR lpszUrl;
} WINHTTP_CREDS_EX, *PWINHTTP_CREDS_EX;
]]

ffi.cdef[[
//
// winhttp handle types
//
static const int WINHTTP_HANDLE_TYPE_SESSION                =  1;
static const int WINHTTP_HANDLE_TYPE_CONNECT                =  2;
static const int WINHTTP_HANDLE_TYPE_REQUEST                =  3;

//
// values for auth schemes
//
static const int WINHTTP_AUTH_SCHEME_BASIC      = 0x00000001;
static const int WINHTTP_AUTH_SCHEME_NTLM       = 0x00000002;
static const int WINHTTP_AUTH_SCHEME_PASSPORT   = 0x00000004;
static const int WINHTTP_AUTH_SCHEME_DIGEST     = 0x00000008;
static const int WINHTTP_AUTH_SCHEME_NEGOTIATE  = 0x00000010;

// WinHttp supported Authentication Targets

static const int WINHTTP_AUTH_TARGET_SERVER = 0x00000000;
static const int WINHTTP_AUTH_TARGET_PROXY  = 0x00000001;

//
// values for WINHTTP_OPTION_SECURITY_FLAGS
//

// query only
static const int SECURITY_FLAG_SECURE                    = 0x00000001; // can query only
static const int SECURITY_FLAG_STRENGTH_WEAK             = 0x10000000;
static const int SECURITY_FLAG_STRENGTH_MEDIUM           = 0x40000000;
static const int SECURITY_FLAG_STRENGTH_STRONG           = 0x20000000;



// Secure connection error status flags
static const int WINHTTP_CALLBACK_STATUS_FLAG_CERT_REV_FAILED         = 0x00000001;
static const int WINHTTP_CALLBACK_STATUS_FLAG_INVALID_CERT            = 0x00000002;
static const int WINHTTP_CALLBACK_STATUS_FLAG_CERT_REVOKED            = 0x00000004;
static const int WINHTTP_CALLBACK_STATUS_FLAG_INVALID_CA              = 0x00000008;
static const int WINHTTP_CALLBACK_STATUS_FLAG_CERT_CN_INVALID         = 0x00000010;
static const int WINHTTP_CALLBACK_STATUS_FLAG_CERT_DATE_INVALID       = 0x00000020;
static const int WINHTTP_CALLBACK_STATUS_FLAG_CERT_WRONG_USAGE        = 0x00000040;
static const int WINHTTP_CALLBACK_STATUS_FLAG_SECURITY_CHANNEL_ERROR  = 0x80000000;


static const int WINHTTP_FLAG_SECURE_PROTOCOL_SSL2   = 0x00000008;
static const int WINHTTP_FLAG_SECURE_PROTOCOL_SSL3   = 0x00000020;
static const int WINHTTP_FLAG_SECURE_PROTOCOL_TLS1   = 0x00000080;
static const int WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_1 = 0x00000200;
static const int WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_2 = 0x00000800;
static const int WINHTTP_FLAG_SECURE_PROTOCOL_ALL   = (WINHTTP_FLAG_SECURE_PROTOCOL_SSL2 | \
                                             WINHTTP_FLAG_SECURE_PROTOCOL_SSL3 | \
                                             WINHTTP_FLAG_SECURE_PROTOCOL_TLS1);
]]

ffi.cdef[[
//
// callback function for WinHttpSetStatusCallback
//

typedef VOID (__stdcall * WINHTTP_STATUS_CALLBACK)(
     HINTERNET hInternet,
     DWORD_PTR dwContext,
     DWORD dwInternetStatus,
     LPVOID lpvStatusInformation,
     DWORD dwStatusInformationLength
    );

typedef WINHTTP_STATUS_CALLBACK * LPWINHTTP_STATUS_CALLBACK;
]]

ffi.cdef[[
//
// status manifests for WinHttp status callback
//

static const int WINHTTP_CALLBACK_STATUS_RESOLVING_NAME          = 0x00000001;
static const int WINHTTP_CALLBACK_STATUS_NAME_RESOLVED           = 0x00000002;
static const int WINHTTP_CALLBACK_STATUS_CONNECTING_TO_SERVER    = 0x00000004;
static const int WINHTTP_CALLBACK_STATUS_CONNECTED_TO_SERVER     = 0x00000008;
static const int WINHTTP_CALLBACK_STATUS_SENDING_REQUEST         = 0x00000010;
static const int WINHTTP_CALLBACK_STATUS_REQUEST_SENT            = 0x00000020;
static const int WINHTTP_CALLBACK_STATUS_RECEIVING_RESPONSE      = 0x00000040;
static const int WINHTTP_CALLBACK_STATUS_RESPONSE_RECEIVED       = 0x00000080;
static const int WINHTTP_CALLBACK_STATUS_CLOSING_CONNECTION      = 0x00000100;
static const int WINHTTP_CALLBACK_STATUS_CONNECTION_CLOSED       = 0x00000200;
static const int WINHTTP_CALLBACK_STATUS_HANDLE_CREATED          = 0x00000400;
static const int WINHTTP_CALLBACK_STATUS_HANDLE_CLOSING          = 0x00000800;
static const int WINHTTP_CALLBACK_STATUS_DETECTING_PROXY         = 0x00001000;
static const int WINHTTP_CALLBACK_STATUS_REDIRECT                = 0x00004000;
static const int WINHTTP_CALLBACK_STATUS_INTERMEDIATE_RESPONSE   = 0x00008000;
static const int WINHTTP_CALLBACK_STATUS_SECURE_FAILURE          = 0x00010000;
static const int WINHTTP_CALLBACK_STATUS_HEADERS_AVAILABLE       = 0x00020000;
static const int WINHTTP_CALLBACK_STATUS_DATA_AVAILABLE          = 0x00040000;
static const int WINHTTP_CALLBACK_STATUS_READ_COMPLETE           = 0x00080000;
static const int WINHTTP_CALLBACK_STATUS_WRITE_COMPLETE          = 0x00100000;
static const int WINHTTP_CALLBACK_STATUS_REQUEST_ERROR           = 0x00200000;
static const int WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE    = 0x00400000;


static const int WINHTTP_CALLBACK_STATUS_GETPROXYFORURL_COMPLETE = 0x01000000;
static const int WINHTTP_CALLBACK_STATUS_CLOSE_COMPLETE          = 0x02000000;
static const int WINHTTP_CALLBACK_STATUS_SHUTDOWN_COMPLETE       = 0x04000000;
static const int WINHTTP_CALLBACK_STATUS_SETTINGS_WRITE_COMPLETE = 0x10000000;
static const int WINHTTP_CALLBACK_STATUS_SETTINGS_READ_COMPLETE  = 0x20000000;
]]

ffi.cdef[[
// API Enums for WINHTTP_CALLBACK_STATUS_REQUEST_ERROR:
static const int API_RECEIVE_RESPONSE         = (1);
static const int API_QUERY_DATA_AVAILABLE     = (2);
static const int API_READ_DATA                = (3);
static const int API_WRITE_DATA               = (4);
static const int API_SEND_REQUEST             = (5);
static const int API_GET_PROXY_FOR_URL        = (6);
]]

ffi.cdef[[
static const int WINHTTP_CALLBACK_FLAG_RESOLVE_NAME           =   (WINHTTP_CALLBACK_STATUS_RESOLVING_NAME | WINHTTP_CALLBACK_STATUS_NAME_RESOLVED);
static const int WINHTTP_CALLBACK_FLAG_CONNECT_TO_SERVER      =   (WINHTTP_CALLBACK_STATUS_CONNECTING_TO_SERVER | WINHTTP_CALLBACK_STATUS_CONNECTED_TO_SERVER);
static const int WINHTTP_CALLBACK_FLAG_SEND_REQUEST           =   (WINHTTP_CALLBACK_STATUS_SENDING_REQUEST | WINHTTP_CALLBACK_STATUS_REQUEST_SENT);
static const int WINHTTP_CALLBACK_FLAG_RECEIVE_RESPONSE       =   (WINHTTP_CALLBACK_STATUS_RECEIVING_RESPONSE | WINHTTP_CALLBACK_STATUS_RESPONSE_RECEIVED);
static const int WINHTTP_CALLBACK_FLAG_CLOSE_CONNECTION       =   (WINHTTP_CALLBACK_STATUS_CLOSING_CONNECTION | WINHTTP_CALLBACK_STATUS_CONNECTION_CLOSED);
static const int WINHTTP_CALLBACK_FLAG_HANDLES                =   (WINHTTP_CALLBACK_STATUS_HANDLE_CREATED | WINHTTP_CALLBACK_STATUS_HANDLE_CLOSING);
static const int WINHTTP_CALLBACK_FLAG_DETECTING_PROXY        =   WINHTTP_CALLBACK_STATUS_DETECTING_PROXY;
static const int WINHTTP_CALLBACK_FLAG_REDIRECT               =   WINHTTP_CALLBACK_STATUS_REDIRECT;
static const int WINHTTP_CALLBACK_FLAG_INTERMEDIATE_RESPONSE  =   WINHTTP_CALLBACK_STATUS_INTERMEDIATE_RESPONSE;
static const int WINHTTP_CALLBACK_FLAG_SECURE_FAILURE         =   WINHTTP_CALLBACK_STATUS_SECURE_FAILURE;
static const int WINHTTP_CALLBACK_FLAG_SENDREQUEST_COMPLETE   =   WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE;
static const int WINHTTP_CALLBACK_FLAG_HEADERS_AVAILABLE      =   WINHTTP_CALLBACK_STATUS_HEADERS_AVAILABLE;
static const int WINHTTP_CALLBACK_FLAG_DATA_AVAILABLE         =   WINHTTP_CALLBACK_STATUS_DATA_AVAILABLE;
static const int WINHTTP_CALLBACK_FLAG_READ_COMPLETE          =   WINHTTP_CALLBACK_STATUS_READ_COMPLETE;
static const int WINHTTP_CALLBACK_FLAG_WRITE_COMPLETE         =   WINHTTP_CALLBACK_STATUS_WRITE_COMPLETE;
static const int WINHTTP_CALLBACK_FLAG_REQUEST_ERROR          =   WINHTTP_CALLBACK_STATUS_REQUEST_ERROR;


static const int WINHTTP_CALLBACK_FLAG_GETPROXYFORURL_COMPLETE =  WINHTTP_CALLBACK_STATUS_GETPROXYFORURL_COMPLETE;

static const int WINHTTP_CALLBACK_FLAG_ALL_COMPLETIONS       =    (WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE   \
                                                        | WINHTTP_CALLBACK_STATUS_HEADERS_AVAILABLE     \
                                                        | WINHTTP_CALLBACK_STATUS_DATA_AVAILABLE        \
                                                        | WINHTTP_CALLBACK_STATUS_READ_COMPLETE         \
                                                        | WINHTTP_CALLBACK_STATUS_WRITE_COMPLETE        \
                                                        | WINHTTP_CALLBACK_STATUS_REQUEST_ERROR         \
                                                        | WINHTTP_CALLBACK_STATUS_GETPROXYFORURL_COMPLETE);
static const int WINHTTP_CALLBACK_FLAG_ALL_NOTIFICATIONS         = 0xffffffff;

//
// if the following value is returned by WinHttpSetStatusCallback, then
// probably an invalid (non-code) address was supplied for the callback
//

static const int WINHTTP_INVALID_STATUS_CALLBACK      =  ((WINHTTP_STATUS_CALLBACK)(-1L));
]]

ffi.cdef[[
//
// WinHttpQueryHeaders info levels. Generally, there is one info level
// for each potential RFC822/HTTP/MIME header that an HTTP server
// may send as part of a request response.
//
// The WINHTTP_QUERY_RAW_HEADERS info level is provided for clients
// that choose to perform their own header parsing.
//


static const int WINHTTP_QUERY_MIME_VERSION                = 0;
static const int WINHTTP_QUERY_CONTENT_TYPE                = 1;
static const int WINHTTP_QUERY_CONTENT_TRANSFER_ENCODING   = 2;
static const int WINHTTP_QUERY_CONTENT_ID                  = 3;
static const int WINHTTP_QUERY_CONTENT_DESCRIPTION         = 4;
static const int WINHTTP_QUERY_CONTENT_LENGTH              = 5;
static const int WINHTTP_QUERY_CONTENT_LANGUAGE            = 6;
static const int WINHTTP_QUERY_ALLOW                       = 7;
static const int WINHTTP_QUERY_PUBLIC                      = 8;
static const int WINHTTP_QUERY_DATE                        = 9;
static const int WINHTTP_QUERY_EXPIRES                     = 10;
static const int WINHTTP_QUERY_LAST_MODIFIED               = 11;
static const int WINHTTP_QUERY_MESSAGE_ID                  = 12;
static const int WINHTTP_QUERY_URI                         = 13;
static const int WINHTTP_QUERY_DERIVED_FROM                = 14;
static const int WINHTTP_QUERY_COST                        = 15;
static const int WINHTTP_QUERY_LINK                        = 16;
static const int WINHTTP_QUERY_PRAGMA                      = 17;
static const int WINHTTP_QUERY_VERSION                     = 18;  // special: part of status line
static const int WINHTTP_QUERY_STATUS_CODE                 = 19;  // special: part of status line
static const int WINHTTP_QUERY_STATUS_TEXT                 = 20;  // special: part of status line
static const int WINHTTP_QUERY_RAW_HEADERS                 = 21;  // special: all headers as ASCIIZ
static const int WINHTTP_QUERY_RAW_HEADERS_CRLF            = 22;  // special: all headers
static const int WINHTTP_QUERY_CONNECTION                  = 23;
static const int WINHTTP_QUERY_ACCEPT                      = 24;
static const int WINHTTP_QUERY_ACCEPT_CHARSET              = 25;
static const int WINHTTP_QUERY_ACCEPT_ENCODING             = 26;
static const int WINHTTP_QUERY_ACCEPT_LANGUAGE             = 27;
static const int WINHTTP_QUERY_AUTHORIZATION               = 28;
static const int WINHTTP_QUERY_CONTENT_ENCODING            = 29;
static const int WINHTTP_QUERY_FORWARDED                   = 30;
static const int WINHTTP_QUERY_FROM                        = 31;
static const int WINHTTP_QUERY_IF_MODIFIED_SINCE           = 32;
static const int WINHTTP_QUERY_LOCATION                    = 33;
static const int WINHTTP_QUERY_ORIG_URI                    = 34;
static const int WINHTTP_QUERY_REFERER                     = 35;
static const int WINHTTP_QUERY_RETRY_AFTER                 = 36;
static const int WINHTTP_QUERY_SERVER                      = 37;
static const int WINHTTP_QUERY_TITLE                       = 38;
static const int WINHTTP_QUERY_USER_AGENT                  = 39;
static const int WINHTTP_QUERY_WWW_AUTHENTICATE            = 40;
static const int WINHTTP_QUERY_PROXY_AUTHENTICATE          = 41;
static const int WINHTTP_QUERY_ACCEPT_RANGES               = 42;
static const int WINHTTP_QUERY_SET_COOKIE                  = 43;
static const int WINHTTP_QUERY_COOKIE                      = 44;
static const int WINHTTP_QUERY_REQUEST_METHOD              = 45;  // special: GET/POST etc.
static const int WINHTTP_QUERY_REFRESH                     = 46;
static const int WINHTTP_QUERY_CONTENT_DISPOSITION         = 47;
]]

ffi.cdef[[
//
// HTTP 1.1 defined headers
//

static const int WINHTTP_QUERY_AGE                         = 48;
static const int WINHTTP_QUERY_CACHE_CONTROL               = 49;
static const int WINHTTP_QUERY_CONTENT_BASE                = 50;
static const int WINHTTP_QUERY_CONTENT_LOCATION            = 51;
static const int WINHTTP_QUERY_CONTENT_MD5                 = 52;
static const int WINHTTP_QUERY_CONTENT_RANGE               = 53;
static const int WINHTTP_QUERY_ETAG                        = 54;
static const int WINHTTP_QUERY_HOST                        = 55;
static const int WINHTTP_QUERY_IF_MATCH                    = 56;
static const int WINHTTP_QUERY_IF_NONE_MATCH               = 57;
static const int WINHTTP_QUERY_IF_RANGE                    = 58;
static const int WINHTTP_QUERY_IF_UNMODIFIED_SINCE         = 59;
static const int WINHTTP_QUERY_MAX_FORWARDS                = 60;
static const int WINHTTP_QUERY_PROXY_AUTHORIZATION         = 61;
static const int WINHTTP_QUERY_RANGE                       = 62;
static const int WINHTTP_QUERY_TRANSFER_ENCODING           = 63;
static const int WINHTTP_QUERY_UPGRADE                     = 64;
static const int WINHTTP_QUERY_VARY                        = 65;
static const int WINHTTP_QUERY_VIA                         = 66;
static const int WINHTTP_QUERY_WARNING                     = 67;
static const int WINHTTP_QUERY_EXPECT                      = 68;
static const int WINHTTP_QUERY_PROXY_CONNECTION            = 69;
static const int WINHTTP_QUERY_UNLESS_MODIFIED_SINCE       = 70;



static const int WINHTTP_QUERY_PROXY_SUPPORT               = 75;
static const int WINHTTP_QUERY_AUTHENTICATION_INFO         = 76;
static const int WINHTTP_QUERY_PASSPORT_URLS               = 77;
static const int WINHTTP_QUERY_PASSPORT_CONFIG             = 78;

static const int WINHTTP_QUERY_MAX                       =   78;
]]

ffi.cdef[[
//
// WINHTTP_QUERY_CUSTOM - if this special value is supplied as the dwInfoLevel
// parameter of WinHttpQueryHeaders() then the lpBuffer parameter contains the name
// of the header we are to query
//

static const int WINHTTP_QUERY_CUSTOM                      = 65535;

//
// WINHTTP_QUERY_FLAG_REQUEST_HEADERS - if this bit is set in the dwInfoLevel
// parameter of WinHttpQueryHeaders() then the request headers will be queried for the
// request information
//

static const int WINHTTP_QUERY_FLAG_REQUEST_HEADERS         = 0x80000000;

//
// WINHTTP_QUERY_FLAG_SYSTEMTIME - if this bit is set in the dwInfoLevel parameter
// of WinHttpQueryHeaders() AND the header being queried contains date information,
// e.g. the "Expires:" header then lpBuffer will contain a SYSTEMTIME structure
// containing the date and time information converted from the header string
//

static const int WINHTTP_QUERY_FLAG_SYSTEMTIME              = 0x40000000;

//
// WINHTTP_QUERY_FLAG_NUMBER - if this bit is set in the dwInfoLevel parameter of
// HttpQueryHeader(), then the value of the header will be converted to a number
// before being returned to the caller, if applicable
//

static const int WINHTTP_QUERY_FLAG_NUMBER                  = 0x20000000;

//
// HTTP_QUERY_FLAG_NUMBER64 - if this bit is set in the dwInfoLevel parameter of
// HttpQueryInfo(), then the value of the header will be converted to a 64bit
// number before being returned to the caller, if applicable
//

static const int WINHTTP_QUERY_FLAG_NUMBER64                = 0x08000000;
]]

ffi.cdef[[
//
// HTTP Response Status Codes:
//

static const int HTTP_STATUS_CONTINUE            =100; // OK to continue with request
static const int HTTP_STATUS_SWITCH_PROTOCOLS    =101; // server has switched protocols in upgrade header

static const int HTTP_STATUS_OK                  =200; // request completed
static const int HTTP_STATUS_CREATED             =201; // object created, reason = new URI
static const int HTTP_STATUS_ACCEPTED            =202; // async completion (TBS)
static const int HTTP_STATUS_PARTIAL             =203; // partial completion
static const int HTTP_STATUS_NO_CONTENT          =204; // no info to return
static const int HTTP_STATUS_RESET_CONTENT       =205; // request completed, but clear form
static const int HTTP_STATUS_PARTIAL_CONTENT     =206; // partial GET fulfilled
static const int HTTP_STATUS_WEBDAV_MULTI_STATUS =207; // WebDAV Multi-Status

static const int HTTP_STATUS_AMBIGUOUS          = 300; // server couldnt decide what to return
static const int HTTP_STATUS_MOVED              = 301; // object permanently moved
static const int HTTP_STATUS_REDIRECT           = 302; // object temporarily moved
static const int HTTP_STATUS_REDIRECT_METHOD    = 303; // redirection w/ new access method
static const int HTTP_STATUS_NOT_MODIFIED       = 304; // if-modified-since was not modified
static const int HTTP_STATUS_USE_PROXY          = 305; // redirection to proxy, location header specifies proxy to use
static const int HTTP_STATUS_REDIRECT_KEEP_VERB = 307; // HTTP/1.1: keep same verb
static const int HTTP_STATUS_PERMANENT_REDIRECT = 308; // Object permanently moved keep verb

static const int HTTP_STATUS_BAD_REQUEST        = 400; // invalid syntax
static const int HTTP_STATUS_DENIED             = 401; // access denied
static const int HTTP_STATUS_PAYMENT_REQ        = 402; // payment required
static const int HTTP_STATUS_FORBIDDEN          = 403; // request forbidden
static const int HTTP_STATUS_NOT_FOUND          = 404; // object not found
static const int HTTP_STATUS_BAD_METHOD         = 405; // method is not allowed
static const int HTTP_STATUS_NONE_ACCEPTABLE    = 406; // no response acceptable to client found
static const int HTTP_STATUS_PROXY_AUTH_REQ     = 407; // proxy authentication required
static const int HTTP_STATUS_REQUEST_TIMEOUT    = 408; // server timed out waiting for request
static const int HTTP_STATUS_CONFLICT           = 409; // user should resubmit with more info
static const int HTTP_STATUS_GONE               = 410; // the resource is no longer available
static const int HTTP_STATUS_LENGTH_REQUIRED    = 411; // the server refused to accept request w/o a length
static const int HTTP_STATUS_PRECOND_FAILED     = 412; // precondition given in request failed
static const int HTTP_STATUS_REQUEST_TOO_LARGE  = 413; // request entity was too large
static const int HTTP_STATUS_URI_TOO_LONG       = 414; // request URI too long
static const int HTTP_STATUS_UNSUPPORTED_MEDIA  = 415; // unsupported media type
static const int HTTP_STATUS_RETRY_WITH         = 449; // retry after doing the appropriate action.

static const int HTTP_STATUS_SERVER_ERROR       = 500; // internal server error
static const int HTTP_STATUS_NOT_SUPPORTED      = 501; // required not supported
static const int HTTP_STATUS_BAD_GATEWAY        = 502; // error response received from gateway
static const int HTTP_STATUS_SERVICE_UNAVAIL    = 503; // temporarily overloaded
static const int HTTP_STATUS_GATEWAY_TIMEOUT    = 504; // timed out waiting for gateway
static const int HTTP_STATUS_VERSION_NOT_SUP    = 505; // HTTP version not supported

static const int HTTP_STATUS_FIRST              = HTTP_STATUS_CONTINUE;
static const int HTTP_STATUS_LAST               = HTTP_STATUS_VERSION_NOT_SUP;
]]

ffi.cdef[[
//
// flags for CrackUrl() and CombineUrl()
//

static const int ICU_NO_ENCODE   = 0x20000000;  // Dont convert unsafe characters to escape sequence
static const int ICU_DECODE      = 0x10000000;  // Convert %XX escape sequences to characters
static const int ICU_NO_META     = 0x08000000;  // Dont convert .. etc. meta path sequences
static const int ICU_ENCODE_SPACES_ONLY = 0x04000000;  // Encode spaces only
static const int ICU_BROWSER_MODE = 0x02000000; // Special encode/decode rules for browser
static const int ICU_ENCODE_PERCENT      = 0x00001000;      // Encode any percent (ASCII25)

        // signs encountered, default is to not encode percent.
]]

ffi.cdef[[
//
// flags for WinHttpCrackUrl() and WinHttpCreateUrl()
//
static const int ICU_ESCAPE      = 0x80000000;  // (un)escape URL characters
static const int ICU_ESCAPE_AUTHORITY = 0x00002000; //causes InternetCreateUrlA to escape chars in authority components (user, pwd, host)
static const int ICU_REJECT_USERPWD  = 0x00004000;  // rejects usrls whick have username/pwd sections
]]

ffi.cdef[[
// WinHttpOpen dwAccessType values (also for WINHTTP_PROXY_INFO::dwAccessType)
static const int WINHTTP_ACCESS_TYPE_DEFAULT_PROXY             =  0;
static const int WINHTTP_ACCESS_TYPE_NO_PROXY                  =  1;
static const int WINHTTP_ACCESS_TYPE_NAMED_PROXY               =  3;
static const int WINHTTP_ACCESS_TYPE_AUTOMATIC_PROXY           =  4;
]]

--[[
// WinHttpOpen prettifiers for optional parameters
#define WINHTTP_NO_PROXY_NAME     NULL
#define WINHTTP_NO_PROXY_BYPASS   NULL

#define WINHTTP_NO_CLIENT_CERT_CONTEXT NULL

// WinHttpOpenRequest prettifers for optional parameters
#define WINHTTP_NO_REFERER             NULL
#define WINHTTP_DEFAULT_ACCEPT_TYPES   NULL
--]]

ffi.cdef[[
//
// values for dwModifiers parameter of WinHttpAddRequestHeaders()
//

static const int WINHTTP_ADDREQ_INDEX_MASK     = 0x0000FFFF;
static const int WINHTTP_ADDREQ_FLAGS_MASK     = 0xFFFF0000;

//
// WINHTTP_ADDREQ_FLAG_ADD_IF_NEW - the header will only be added if it doesnt
// already exist
//

static const int WINHTTP_ADDREQ_FLAG_ADD_IF_NEW = 0x10000000;

//
// WINHTTP_ADDREQ_FLAG_ADD - if WINHTTP_ADDREQ_FLAG_REPLACE is set but the header is
// not found then if this flag is set, the header is added anyway, so long as
// there is a valid header-value
//

static const int WINHTTP_ADDREQ_FLAG_ADD      =  0x20000000;

//
// WINHTTP_ADDREQ_FLAG_COALESCE - coalesce headers with same name. e.g.
// "Accept: text/*" and "Accept: audio/*" with this flag results in a single
// header: "Accept: text/*, audio/*"
//

static const int WINHTTP_ADDREQ_FLAG_COALESCE_WITH_COMMA     =  0x40000000;
static const int WINHTTP_ADDREQ_FLAG_COALESCE_WITH_SEMICOLON =  0x01000000;
static const int WINHTTP_ADDREQ_FLAG_COALESCE                =  WINHTTP_ADDREQ_FLAG_COALESCE_WITH_COMMA;

//
// WINHTTP_ADDREQ_FLAG_REPLACE - replaces the specified header. Only one header can
// be supplied in the buffer. If the header to be replaced is not the first
// in a list of headers with the same name, then the relative index should be
// supplied in the low 8 bits of the dwModifiers parameter. If the header-value
// part is missing, then the header is removed
//

static const int WINHTTP_ADDREQ_FLAG_REPLACE    = 0x80000000;

static const int WINHTTP_IGNORE_REQUEST_TOTAL_LENGTH = 0;
]]

--[[
// WinHttpSendRequest prettifiers for optional parameters.
#define WINHTTP_NO_ADDITIONAL_HEADERS   NULL
#define WINHTTP_NO_REQUEST_DATA         NULL
--]]

--[[
// WinHttpQueryHeaders prettifiers for optional parameters.
#define WINHTTP_HEADER_NAME_BY_INDEX           NULL
#define WINHTTP_NO_OUTPUT_BUFFER               NULL
#define WINHTTP_NO_HEADER_INDEX                NULL
--]]

ffi.cdef[[
typedef struct
{
    BOOL    fAutoDetect;
    LPWSTR  lpszAutoConfigUrl;
    LPWSTR  lpszProxy;
    LPWSTR  lpszProxyBypass;
} WINHTTP_CURRENT_USER_IE_PROXY_CONFIG;
]]

--//#if !defined(_WINERROR_)

ffi.cdef[[
//
// WinHttp API error returns
//

static const int WINHTTP_ERROR_BASE                    = 12000;

static const int ERROR_WINHTTP_OUT_OF_HANDLES          = (WINHTTP_ERROR_BASE + 1);
static const int ERROR_WINHTTP_TIMEOUT                 = (WINHTTP_ERROR_BASE + 2);
static const int ERROR_WINHTTP_INTERNAL_ERROR          = (WINHTTP_ERROR_BASE + 4);
static const int ERROR_WINHTTP_INVALID_URL             = (WINHTTP_ERROR_BASE + 5);
static const int ERROR_WINHTTP_UNRECOGNIZED_SCHEME     = (WINHTTP_ERROR_BASE + 6);
static const int ERROR_WINHTTP_NAME_NOT_RESOLVED       = (WINHTTP_ERROR_BASE + 7);
static const int ERROR_WINHTTP_INVALID_OPTION          = (WINHTTP_ERROR_BASE + 9);
static const int ERROR_WINHTTP_OPTION_NOT_SETTABLE     = (WINHTTP_ERROR_BASE + 11);
static const int ERROR_WINHTTP_SHUTDOWN                = (WINHTTP_ERROR_BASE + 12);


static const int ERROR_WINHTTP_LOGIN_FAILURE           = (WINHTTP_ERROR_BASE + 15);
static const int ERROR_WINHTTP_OPERATION_CANCELLED     = (WINHTTP_ERROR_BASE + 17);
static const int ERROR_WINHTTP_INCORRECT_HANDLE_TYPE   = (WINHTTP_ERROR_BASE + 18);
static const int ERROR_WINHTTP_INCORRECT_HANDLE_STATE  = (WINHTTP_ERROR_BASE + 19);
static const int ERROR_WINHTTP_CANNOT_CONNECT          = (WINHTTP_ERROR_BASE + 29);
static const int ERROR_WINHTTP_CONNECTION_ERROR        = (WINHTTP_ERROR_BASE + 30);
static const int ERROR_WINHTTP_RESEND_REQUEST          = (WINHTTP_ERROR_BASE + 32);

static const int ERROR_WINHTTP_CLIENT_AUTH_CERT_NEEDED  =(WINHTTP_ERROR_BASE + 44);


//
// WinHttpRequest Component errors
//
static const int ERROR_WINHTTP_CANNOT_CALL_BEFORE_OPEN	=(WINHTTP_ERROR_BASE + 100);
static const int ERROR_WINHTTP_CANNOT_CALL_BEFORE_SEND	=(WINHTTP_ERROR_BASE + 101);
static const int ERROR_WINHTTP_CANNOT_CALL_AFTER_SEND	=(WINHTTP_ERROR_BASE + 102);
static const int ERROR_WINHTTP_CANNOT_CALL_AFTER_OPEN	=(WINHTTP_ERROR_BASE + 103);


//
// HTTP API errors
//

static const int ERROR_WINHTTP_HEADER_NOT_FOUND          =   (WINHTTP_ERROR_BASE + 150);
static const int ERROR_WINHTTP_INVALID_SERVER_RESPONSE   =   (WINHTTP_ERROR_BASE + 152);
static const int ERROR_WINHTTP_INVALID_HEADER            =   (WINHTTP_ERROR_BASE + 153);
static const int ERROR_WINHTTP_INVALID_QUERY_REQUEST     =   (WINHTTP_ERROR_BASE + 154);
static const int ERROR_WINHTTP_HEADER_ALREADY_EXISTS     =   (WINHTTP_ERROR_BASE + 155);
static const int ERROR_WINHTTP_REDIRECT_FAILED           =   (WINHTTP_ERROR_BASE + 156);



//
// additional WinHttp API error codes
//

//
// additional WinHttp API error codes
//

static const int ERROR_WINHTTP_AUTO_PROXY_SERVICE_ERROR  =(WINHTTP_ERROR_BASE + 178);
static const int ERROR_WINHTTP_BAD_AUTO_PROXY_SCRIPT     =(WINHTTP_ERROR_BASE + 166);
static const int ERROR_WINHTTP_UNABLE_TO_DOWNLOAD_SCRIPT =(WINHTTP_ERROR_BASE + 167);
static const int ERROR_WINHTTP_UNHANDLED_SCRIPT_TYPE     =(WINHTTP_ERROR_BASE + 176);
static const int ERROR_WINHTTP_SCRIPT_EXECUTION_ERROR    =(WINHTTP_ERROR_BASE + 177);

static const int ERROR_WINHTTP_NOT_INITIALIZED         = (WINHTTP_ERROR_BASE + 172);
static const int ERROR_WINHTTP_SECURE_FAILURE          = (WINHTTP_ERROR_BASE + 175);


//
// Certificate security errors. These are raised only by the WinHttpRequest
// component. The WinHTTP Win32 API will return ERROR_WINHTTP_SECURE_FAILE and
// provide additional information via the WINHTTP_CALLBACK_STATUS_SECURE_FAILURE
// callback notification.
//
static const int ERROR_WINHTTP_SECURE_CERT_DATE_INVALID  =  (WINHTTP_ERROR_BASE + 37);
static const int ERROR_WINHTTP_SECURE_CERT_CN_INVALID    =  (WINHTTP_ERROR_BASE + 38);
static const int ERROR_WINHTTP_SECURE_INVALID_CA         =  (WINHTTP_ERROR_BASE + 45);
static const int ERROR_WINHTTP_SECURE_CERT_REV_FAILED    =  (WINHTTP_ERROR_BASE + 57);
static const int ERROR_WINHTTP_SECURE_CHANNEL_ERROR      =  (WINHTTP_ERROR_BASE + 157);
static const int ERROR_WINHTTP_SECURE_INVALID_CERT       =  (WINHTTP_ERROR_BASE + 169);
static const int ERROR_WINHTTP_SECURE_CERT_REVOKED       =  (WINHTTP_ERROR_BASE + 170);
static const int ERROR_WINHTTP_SECURE_CERT_WRONG_USAGE   =  (WINHTTP_ERROR_BASE + 179);


static const int ERROR_WINHTTP_AUTODETECTION_FAILED                 = (WINHTTP_ERROR_BASE + 180);
static const int ERROR_WINHTTP_HEADER_COUNT_EXCEEDED                = (WINHTTP_ERROR_BASE + 181);
static const int ERROR_WINHTTP_HEADER_SIZE_OVERFLOW                 = (WINHTTP_ERROR_BASE + 182);
static const int ERROR_WINHTTP_CHUNKED_ENCODING_HEADER_SIZE_OVERFLOW = (WINHTTP_ERROR_BASE + 183);
static const int ERROR_WINHTTP_RESPONSE_DRAIN_OVERFLOW              = (WINHTTP_ERROR_BASE + 184);
static const int ERROR_WINHTTP_CLIENT_CERT_NO_PRIVATE_KEY           = (WINHTTP_ERROR_BASE + 185);
static const int ERROR_WINHTTP_CLIENT_CERT_NO_ACCESS_PRIVATE_KEY    = (WINHTTP_ERROR_BASE + 186);

static const int ERROR_WINHTTP_CLIENT_AUTH_CERT_NEEDED_PROXY        = (WINHTTP_ERROR_BASE + 187);
static const int ERROR_WINHTTP_SECURE_FAILURE_PROXY                 = (WINHTTP_ERROR_BASE + 188);


static const int WINHTTP_ERROR_LAST                                 = (WINHTTP_ERROR_BASE + 188);

static const int WINHTTP_RESET_STATE                    = 0x00000001;
static const int WINHTTP_RESET_SWPAD_CURRENT_NETWORK    = 0x00000002;
static const int WINHTTP_RESET_SWPAD_ALL                = 0x00000004;
static const int WINHTTP_RESET_SCRIPT_CACHE             = 0x00000008;
static const int WINHTTP_RESET_ALL                      = 0x0000FFFF;
static const int WINHTTP_RESET_NOTIFY_NETWORK_CHANGED   = 0x00010000;
static const int WINHTTP_RESET_OUT_OF_PROC              = 0x00020000;
static const int WINHTTP_RESET_DISCARD_RESOLVERS        = 0x00040000;
]]

--//#endif // !defined(_WINERROR_)

ffi.cdef[[
//
// prototypes
//


WINHTTP_STATUS_CALLBACK
__stdcall
WinHttpSetStatusCallback
(
     HINTERNET hInternet,
     WINHTTP_STATUS_CALLBACK lpfnInternetCallback,
     DWORD dwNotificationFlags,
     DWORD_PTR dwReserved
);
]]

ffi.cdef[[
BOOL  __stdcall
WinHttpTimeFromSystemTime
(
     const SYSTEMTIME *pst,  // input GMT time
     LPWSTR pwszTime // output string buffer
);

BOOL  __stdcall
WinHttpTimeToSystemTime
(
     LPCWSTR pwszTime,        // NULL terminated string
     SYSTEMTIME *pst           // output in GMT time
);
]]

ffi.cdef[[
BOOL  __stdcall
WinHttpCrackUrl
(
     LPCWSTR pwszUrl,
     DWORD dwUrlLength,
     DWORD dwFlags,
     LPURL_COMPONENTS lpUrlComponents
);


BOOL  __stdcall
WinHttpCreateUrl
(
     LPURL_COMPONENTS lpUrlComponents,
     DWORD dwFlags,
     LPWSTR pwszUrl,
     LPDWORD pdwUrlLength
);
]]

ffi.cdef[[
BOOL  __stdcall WinHttpCheckPlatform(void);
]]

ffi.cdef[[
 BOOL __stdcall WinHttpGetDefaultProxyConfiguration(   WINHTTP_PROXY_INFO * pProxyInfo);
 BOOL __stdcall WinHttpSetDefaultProxyConfiguration(  WINHTTP_PROXY_INFO * pProxyInfo);
]]

ffi.cdef[[
HINTERNET
__stdcall
WinHttpOpen(
     LPCWSTR pszAgentW,
     DWORD dwAccessType,
     LPCWSTR pszProxyW,
     LPCWSTR pszProxyBypassW,
     DWORD dwFlags
);


BOOL  __stdcall
WinHttpCloseHandle(
     HINTERNET hInternet
);



HINTERNET
__stdcall
WinHttpConnect(
     HINTERNET hSession,
     LPCWSTR pswzServerName,
     INTERNET_PORT nServerPort,
     DWORD dwReserved
);


BOOL  __stdcall
WinHttpReadData(
     HINTERNET hRequest,
      LPVOID lpBuffer,
     DWORD dwNumberOfBytesToRead,
     LPDWORD lpdwNumberOfBytesRead
);

BOOL  __stdcall
WinHttpWriteData(
     HINTERNET hRequest,
     LPCVOID lpBuffer,
     DWORD dwNumberOfBytesToWrite,
     LPDWORD lpdwNumberOfBytesWritten
);


BOOL  __stdcall
WinHttpQueryDataAvailable(
     HINTERNET hRequest,
     LPDWORD lpdwNumberOfBytesAvailable
);



BOOL  __stdcall
WinHttpQueryOption(
     HINTERNET hInternet,
     DWORD dwOption,
      LPVOID lpBuffer,
      LPDWORD lpdwBufferLength
);

BOOL  __stdcall
WinHttpSetOption(
     HINTERNET hInternet,
     DWORD dwOption, 
    LPVOID lpBuffer,
     DWORD dwBufferLength
);
]]

ffi.cdef[[
BOOL  __stdcall
WinHttpSetTimeouts(
     HINTERNET    hInternet,           // Session/Request handle.
     int          nResolveTimeout,
     int          nConnectTimeout,
     int          nSendTimeout,
     int          nReceiveTimeout
);


DWORD
__stdcall
WinHttpIsHostInProxyBypassList(
     const WINHTTP_PROXY_INFO *pProxyInfo,
     PCWSTR pwszHost,
     INTERNET_SCHEME tScheme,
     INTERNET_PORT nPort,
     BOOL *pfIsInBypassList
);
]]

ffi.cdef[[
//
// prototypes
//
HINTERNET
__stdcall
WinHttpOpenRequest(
     HINTERNET hConnect,
     LPCWSTR pwszVerb,
     LPCWSTR pwszObjectName,
     LPCWSTR pwszVersion,
     LPCWSTR pwszReferrer ,
     LPCWSTR * ppwszAcceptTypes ,
     DWORD dwFlags
);

BOOL  __stdcall
WinHttpAddRequestHeaders(
     HINTERNET hRequest,
    LPCWSTR lpszHeaders,
     DWORD dwHeadersLength,
     DWORD dwModifiers
);

BOOL  __stdcall
WinHttpSendRequest(
     HINTERNET hRequest,
     LPCWSTR lpszHeaders,
     DWORD dwHeadersLength,
     LPVOID lpOptional,
     DWORD dwOptionalLength,
     DWORD dwTotalLength,
     DWORD_PTR dwContext
);
]]

ffi.cdef[[
BOOL  __stdcall WinHttpSetCredentials(

     HINTERNET   hRequest,        // HINTERNET handle returned by WinHttpOpenRequest.


     DWORD       AuthTargets,      // Only WINHTTP_AUTH_TARGET_SERVER and
                                    // WINHTTP_AUTH_TARGET_PROXY are supported
                                    // in this version and they are mutually
                                    // exclusive

     DWORD       AuthScheme,      // must be one of the supported Auth Schemes
                                    // returned from WinHttpQueryAuthSchemes()

     LPCWSTR     pwszUserName,    // 1) NULL if default creds is to be used, in
                                    // which case pszPassword will be ignored

     LPCWSTR     pwszPassword,    // 1) "" == Blank Password; 2)Parameter ignored
                                    // if pszUserName is NULL; 3) Invalid to pass in
                                    // NULL if pszUserName is not NULL
     LPVOID      pAuthParams
);
]]

ffi.cdef[[
BOOL  __stdcall WinHttpQueryAuthSchemes(
      HINTERNET   hRequest,             // HINTERNET handle returned by WinHttpOpenRequest
     LPDWORD     lpdwSupportedSchemes, // a bitmap of available Authentication Schemes
     LPDWORD     lpdwFirstScheme,      // returns the first auth scheme returned by the server
     LPDWORD     pdwAuthTarget
);

BOOL  __stdcall WinHttpQueryAuthParams(
      HINTERNET   hRequest,        // HINTERNET handle returned by WinHttpOpenRequest
      DWORD       AuthScheme,
     LPVOID*     pAuthParams      // Scheme-specific Advanced auth parameters
    );



BOOL
__stdcall
WinHttpReceiveResponse(
     HINTERNET hRequest,
     LPVOID lpReserved
);
]]

ffi.cdef[[
BOOL  __stdcall
WinHttpQueryHeaders(
         HINTERNET hRequest,
         DWORD     dwInfoLevel,
         LPCWSTR   pwszName ,
      LPVOID lpBuffer,
      LPDWORD   lpdwBufferLength,
      LPDWORD   lpdwIndex 
);

BOOL  __stdcall
WinHttpDetectAutoProxyConfigUrl(
    DWORD dwAutoDetectFlags,
     LPWSTR * ppwstrAutoConfigUrl
);

BOOL  __stdcall
WinHttpGetProxyForUrl(
      HINTERNET                   hSession,
      LPCWSTR                     lpcwszUrl,
      WINHTTP_AUTOPROXY_OPTIONS * pAutoProxyOptions,
     WINHTTP_PROXY_INFO *        pProxyInfo
);


DWORD
__stdcall
WinHttpCreateProxyResolver(
     HINTERNET hSession,
     HINTERNET *phResolver
);


DWORD
__stdcall
WinHttpGetProxyForUrlEx(
     HINTERNET hResolver,
     PCWSTR pcwszUrl,
     WINHTTP_AUTOPROXY_OPTIONS *pAutoProxyOptions,
     DWORD_PTR pContext
);


DWORD
__stdcall
WinHttpGetProxyForUrlEx2(
     HINTERNET hResolver,
     PCWSTR pcwszUrl,
     WINHTTP_AUTOPROXY_OPTIONS *pAutoProxyOptions,
     DWORD cbInterfaceSelectionContext,
     BYTE *pInterfaceSelectionContext,
     DWORD_PTR pContext
);
]]

ffi.cdef[[
DWORD
__stdcall
WinHttpGetProxyResult(
     HINTERNET hResolver,
     WINHTTP_PROXY_RESULT *pProxyResult
);


DWORD
__stdcall
WinHttpGetProxyResultEx(
     HINTERNET hResolver,
     WINHTTP_PROXY_RESULT_EX *pProxyResultEx
);


VOID
__stdcall
WinHttpFreeProxyResult(
     WINHTTP_PROXY_RESULT *pProxyResult
);


VOID
__stdcall
WinHttpFreeProxyResultEx(
     WINHTTP_PROXY_RESULT_EX *pProxyResultEx
);


DWORD
__stdcall
WinHttpResetAutoProxy(
     HINTERNET hSession,
     DWORD dwFlags
);

BOOL  __stdcall
WinHttpGetIEProxyConfigForCurrentUser(
      WINHTTP_CURRENT_USER_IE_PROXY_CONFIG * pProxyConfig
);
]]

ffi.cdef[[
DWORD
__stdcall
WinHttpWriteProxySettings(
     HINTERNET hSession,
     BOOL fForceUpdate,
     WINHTTP_PROXY_SETTINGS *pWinHttpProxySettings
);


DWORD
__stdcall
WinHttpReadProxySettings(
     HINTERNET hSession,
     PCWSTR pcwszConnectionName,
     BOOL fFallBackToDefaultSettings,
     BOOL fSetAutoDiscoverForDefaultSettings,
     DWORD *pdwSettingsVersion,
     BOOL *pfDefaultSettingsAreReturned,
     WINHTTP_PROXY_SETTINGS *pWinHttpProxySettings
);


VOID
__stdcall
WinHttpFreeProxySettings(
     WINHTTP_PROXY_SETTINGS *pWinHttpProxySettings
);


DWORD
__stdcall
WinHttpGetProxySettingsVersion(
     HINTERNET hSession,
     DWORD *pdwProxySettingsVersion
);
]]

ffi.cdef[[
typedef enum _WINHTTP_WEB_SOCKET_OPERATION
{
    WINHTTP_WEB_SOCKET_SEND_OPERATION                   = 0,
    WINHTTP_WEB_SOCKET_RECEIVE_OPERATION                = 1,
    WINHTTP_WEB_SOCKET_CLOSE_OPERATION                  = 2,
    WINHTTP_WEB_SOCKET_SHUTDOWN_OPERATION               = 3
} WINHTTP_WEB_SOCKET_OPERATION;

typedef enum _WINHTTP_WEB_SOCKET_BUFFER_TYPE
{
    WINHTTP_WEB_SOCKET_BINARY_MESSAGE_BUFFER_TYPE       = 0,
    WINHTTP_WEB_SOCKET_BINARY_FRAGMENT_BUFFER_TYPE      = 1,
    WINHTTP_WEB_SOCKET_UTF8_MESSAGE_BUFFER_TYPE         = 2,
    WINHTTP_WEB_SOCKET_UTF8_FRAGMENT_BUFFER_TYPE        = 3,
    WINHTTP_WEB_SOCKET_CLOSE_BUFFER_TYPE                = 4
} WINHTTP_WEB_SOCKET_BUFFER_TYPE;

typedef enum _WINHTTP_WEB_SOCKET_CLOSE_STATUS
{
    WINHTTP_WEB_SOCKET_SUCCESS_CLOSE_STATUS                = 1000,
    WINHTTP_WEB_SOCKET_ENDPOINT_TERMINATED_CLOSE_STATUS    = 1001,
    WINHTTP_WEB_SOCKET_PROTOCOL_ERROR_CLOSE_STATUS         = 1002,
    WINHTTP_WEB_SOCKET_INVALID_DATA_TYPE_CLOSE_STATUS      = 1003,
    WINHTTP_WEB_SOCKET_EMPTY_CLOSE_STATUS                  = 1005,
    WINHTTP_WEB_SOCKET_ABORTED_CLOSE_STATUS                = 1006,
    WINHTTP_WEB_SOCKET_INVALID_PAYLOAD_CLOSE_STATUS        = 1007,
    WINHTTP_WEB_SOCKET_POLICY_VIOLATION_CLOSE_STATUS       = 1008,
    WINHTTP_WEB_SOCKET_MESSAGE_TOO_BIG_CLOSE_STATUS        = 1009,
    WINHTTP_WEB_SOCKET_UNSUPPORTED_EXTENSIONS_CLOSE_STATUS = 1010,
    WINHTTP_WEB_SOCKET_SERVER_ERROR_CLOSE_STATUS           = 1011,
    WINHTTP_WEB_SOCKET_SECURE_HANDSHAKE_ERROR_CLOSE_STATUS = 1015
} WINHTTP_WEB_SOCKET_CLOSE_STATUS;

typedef struct _WINHTTP_WEB_SOCKET_ASYNC_RESULT
{
    WINHTTP_ASYNC_RESULT AsyncResult;
    WINHTTP_WEB_SOCKET_OPERATION Operation;
} WINHTTP_WEB_SOCKET_ASYNC_RESULT;

typedef struct _WINHTTP_WEB_SOCKET_STATUS
{
    DWORD dwBytesTransferred;
    WINHTTP_WEB_SOCKET_BUFFER_TYPE eBufferType;
} WINHTTP_WEB_SOCKET_STATUS;
]]

ffi.cdef[[
static const int WINHTTP_WEB_SOCKET_MAX_CLOSE_REASON_LENGTH = 123;
static const int WINHTTP_WEB_SOCKET_MIN_KEEPALIVE_VALUE = 15000;
]]

ffi.cdef[[
HINTERNET
__stdcall
WinHttpWebSocketCompleteUpgrade(
     HINTERNET hRequest,
     DWORD_PTR pContext
);


DWORD
__stdcall
WinHttpWebSocketSend(
     HINTERNET hWebSocket,
     WINHTTP_WEB_SOCKET_BUFFER_TYPE eBufferType,
     PVOID pvBuffer,
     DWORD dwBufferLength
);


DWORD
__stdcall
WinHttpWebSocketReceive(
     HINTERNET hWebSocket,
     PVOID pvBuffer,
     DWORD dwBufferLength,
     DWORD *pdwBytesRead,
     WINHTTP_WEB_SOCKET_BUFFER_TYPE *peBufferType
);


DWORD
__stdcall
WinHttpWebSocketShutdown(
     HINTERNET hWebSocket,
     USHORT usStatus,
     PVOID pvReason,
     DWORD dwReasonLength
);


DWORD
__stdcall
WinHttpWebSocketClose(
     HINTERNET hWebSocket,
     USHORT usStatus,
     PVOID pvReason,
     DWORD dwReasonLength
);


DWORD
__stdcall
WinHttpWebSocketQueryCloseStatus(
     HINTERNET hWebSocket,
     USHORT *pusStatus,
     PVOID pvReason,
     DWORD dwReasonLength,
     DWORD *pdwReasonLengthConsumed
);
]]




--[[
/*
 * Return packing to whatever it was before we
 * entered this file
 */
#include <poppack.h>
--]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


end --// !defined(_WINHTTPX_)


return ffi.load("winhttp")
