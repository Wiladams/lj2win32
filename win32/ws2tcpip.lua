--[[
/*
**  WS2TCPIP.H - WinSock2 Extension for TCP/IP protocols
**
**  This file contains TCP/IP specific information for use
**  by WinSock2 compatible applications.
**
**  Copyright (c) Microsoft Corporation. All rights reserved.
**
**  To provide the backward compatibility, all the TCP/IP
**  specific definitions that were included in the WINSOCK.H
**   file are now included in WINSOCK2.H file. WS2TCPIP.H
**  file includes only the definitions  introduced in the
**  "WinSock 2 Protocol-Specific Annex" document.
**
**  Rev 0.3 Nov 13, 1995
**      Rev 0.4 Dec 15, 1996
*/
--]]

local ffi = require("ffi")
local C = ffi.C

if not _WS2TCPIP_H_ then
_WS2TCPIP_H_ = true


require("win32.winapifamily")


--[[
#if !defined(_WINSOCK_DEPRECATED_BY)
#if ((defined(_WINSOCK_DEPRECATED_NO_WARNINGS) || defined(BUILD_WINDOWS)) && !defined(_WINSOCK_DEPRECATE_WARNINGS)) || defined(MIDL_PASS)
#define _WINSOCK_DEPRECATED_BY(replacement)
#else
#define _WINSOCK_DEPRECATED_BY(replacement) __declspec(deprecated("Use " replacement " instead or define _WINSOCK_DEPRECATED_NO_WARNINGS to disable deprecated API warnings"))
#endif
#endif
--]]

require("win32.winsock2")
require("win32.ws2ipdef")
--#include <limits.h>


ffi.cdef[[
/* Option to use with [gs]etsockopt at the IPPROTO_UDP level */

static const int UDP_NOCHECKSUM = 1;
static const int UDP_CHECKSUM_COVERAGE  = 20;  /* Set/get UDP-Lite checksum coverage */
]]

ffi.cdef[[
/* Error codes from getaddrinfo() */

static const int EAI_AGAIN         =  WSATRY_AGAIN;
static const int EAI_BADFLAGS      =  WSAEINVAL;
static const int EAI_FAIL          =  WSANO_RECOVERY;
static const int EAI_FAMILY        =  WSAEAFNOSUPPORT;
static const int EAI_MEMORY        =  WSA_NOT_ENOUGH_MEMORY;
static const int EAI_NOSECURENAME  =  WSA_SECURE_HOST_NOT_FOUND;
//static const int EAI_NODATA      =  WSANO_DATA;
static const int EAI_NONAME        =  WSAHOST_NOT_FOUND;
static const int EAI_SERVICE       =  WSATYPE_NOT_FOUND;
static const int EAI_SOCKTYPE      =  WSAESOCKTNOSUPPORT;
static const int EAI_IPSECPOLICY   =  WSA_IPSEC_NAME_POLICY_ERROR;
//
//  DCR_FIX:  EAI_NODATA remove or fix
//
//  EAI_NODATA was removed from rfc2553bis
//  need to find out from the authors why and
//  determine the error for "no records of this type"
//  temporarily, we'll keep static const int to avoid changing
//  code that could change back;  use NONAME
//

static const int EAI_NODATA     = EAI_NONAME;
]]

--  Switchable definition for GetAddrInfo()

if UNICODE then
ffi.cdef[[
typedef ADDRINFOW       ADDRINFOT, *PADDRINFOT;
]]
else
ffi.cdef[[
typedef ADDRINFOA       ADDRINFOT, *PADDRINFOT;
]]
end

ffi.cdef[[
//  RFC standard definition for getaddrinfo()

typedef ADDRINFOA       ADDRINFO,  * LPADDRINFO;
]]

if (_WIN32_WINNT >= 0x0600) then

if UNICODE then
ffi.cdef[[
typedef ADDRINFOEXW     ADDRINFOEX, *PADDRINFOEX;
]]
else

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then
ffi.cdef[[
typedef ADDRINFOEXA     ADDRINFOEX, *PADDRINFOEX;
]]
end -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) 

end     -- UNICODE

end  -- (_WIN32_WINNT >= 0x0600)



ffi.cdef[[
INT
__stdcall
getaddrinfo(
            PCSTR               pNodeName,
            PCSTR               pServiceName,
            const ADDRINFOA *   pHints,
            PADDRINFOA *        ppResult
    );
]]

--[=[
#if (NTDDI_VERSION >= NTDDI_WINXPSP2) || (_WIN32_WINNT >= 0x0502)

INT
__stdcall
GetAddrInfoW(
            PCWSTR              pNodeName,
            PCWSTR              pServiceName,
            const ADDRINFOW *   pHints,
            PADDRINFOW *        ppResult
    );

#define GetAddrInfoA    getaddrinfo

#ifdef UNICODE
#define GetAddrInfo     GetAddrInfoW
#else
#define GetAddrInfo     GetAddrInfoA
#endif
#endif

#if INCL_WINSOCK_API_TYPEDEFS
typedef
INT
(__stdcall * LPFN_GETADDRINFO)(
            PCSTR               pNodeName,
            PCSTR               pServiceName,
            const ADDRINFOA *   pHints,
            PADDRINFOA *        ppResult
    );

typedef
INT
(__stdcall * LPFN_GETADDRINFOW)(
            PCWSTR              pNodeName,
            PCWSTR              pServiceName,
            const ADDRINFOW *   pHints,
            PADDRINFOW *        ppResult
    );

#define LPFN_GETADDRINFOA      LPFN_GETADDRINFO

#ifdef UNICODE
#define LPFN_GETADDRINFOT      LPFN_GETADDRINFOW
#else
#define LPFN_GETADDRINFOT      LPFN_GETADDRINFOA
#endif
#endif

#if (_WIN32_WINNT >= 0x0600)

typedef
void
(CALLBACK * LPLOOKUPSERVICE_COMPLETION_ROUTINE)(
          DWORD    dwError,
          DWORD    dwBytes,
          LPWSAOVERLAPPED lpOverlapped
    );

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)
_WINSOCK_DEPRECATED_BY("GetAddrInfoExW()")

INT
__stdcall
GetAddrInfoExA(
        PCSTR           pName,
        PCSTR           pServiceName,
            DWORD           dwNameSpace,
        LPGUID          lpNspId,
        const ADDRINFOEXA *hints,
        PADDRINFOEXA *  ppResult,
        struct timeval *timeout,
        LPOVERLAPPED    lpOverlapped,
        LPLOOKUPSERVICE_COMPLETION_ROUTINE  lpCompletionRoutine,
    _Out_opt_   LPHANDLE        lpNameHandle
    );
#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



INT
__stdcall
GetAddrInfoExW(
        PCWSTR          pName,
        PCWSTR          pServiceName,
            DWORD           dwNameSpace,
        LPGUID          lpNspId,
        const ADDRINFOEXW *hints,
        PADDRINFOEXW *  ppResult,
        struct timeval *timeout,
        LPOVERLAPPED    lpOverlapped,
        LPLOOKUPSERVICE_COMPLETION_ROUTINE  lpCompletionRoutine,
    _Out_opt_   LPHANDLE        lpHandle
    );


INT
__stdcall
GetAddrInfoExCancel(
            LPHANDLE        lpHandle
    );


INT
__stdcall
GetAddrInfoExOverlappedResult(
            LPOVERLAPPED    lpOverlapped
    );

#ifdef UNICODE
#define GetAddrInfoEx       GetAddrInfoExW
#else
#define GetAddrInfoEx       GetAddrInfoExA
#endif

#if INCL_WINSOCK_API_TYPEDEFS
#pragma region Desktop Family or OneCore Family 
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)
typedef
INT
(__stdcall *LPFN_GETADDRINFOEXA)(
            PCSTR           pName,
        PCSTR           pServiceName,
            DWORD           dwNameSpace,
        LPGUID          lpNspId,
        const ADDRINFOEXA *hints,
        PADDRINFOEXA   *ppResult,
        struct timeval *timeout,
        LPOVERLAPPED    lpOverlapped,
        LPLOOKUPSERVICE_COMPLETION_ROUTINE  lpCompletionRoutine,
    _Out_opt_   LPHANDLE        lpNameHandle
    );
#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


typedef
INT
(__stdcall *LPFN_GETADDRINFOEXW)(
            PCWSTR          pName,
        PCWSTR          pServiceName,
            DWORD           dwNameSpace,
        LPGUID          lpNspId,
        const ADDRINFOEXW *hints,
        PADDRINFOEXW   *ppResult,
        struct timeval *timeout,
        LPOVERLAPPED    lpOverlapped,
        LPLOOKUPSERVICE_COMPLETION_ROUTINE  lpCompletionRoutine,
    _Out_opt_   LPHANDLE        lpHandle
    );

typedef
INT
(__stdcall *LPFN_GETADDRINFOEXCANCEL)(
            LPHANDLE        lpHandle
    );

typedef
INT
(__stdcall *LPFN_GETADDRINFOEXOVERLAPPEDRESULT)(
            LPOVERLAPPED    lpOverlapped
    );


#ifdef UNICODE
#define LPFN_GETADDRINFOEX      LPFN_GETADDRINFOEXW
#else
#define LPFN_GETADDRINFOEX      LPFN_GETADDRINFOEXA
#endif
#endif

#endif

#if (_WIN32_WINNT >= 0x0600)
#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)
_WINSOCK_DEPRECATED_BY("SetAddrInfoExW()")

INT
__stdcall
SetAddrInfoExA(
            PCSTR           pName,
        PCSTR           pServiceName,
        SOCKET_ADDRESS *pAddresses,
            DWORD           dwAddressCount,
        LPBLOB          lpBlob,
            DWORD           dwFlags,
            DWORD           dwNameSpace,
        LPGUID          lpNspId,
        struct timeval *timeout,
        LPOVERLAPPED    lpOverlapped,
        LPLOOKUPSERVICE_COMPLETION_ROUTINE  lpCompletionRoutine,
    _Out_opt_   LPHANDLE        lpNameHandle
    );
#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



INT
__stdcall
SetAddrInfoExW(
            PCWSTR          pName,
        PCWSTR          pServiceName,
        SOCKET_ADDRESS *pAddresses,
            DWORD           dwAddressCount,
        LPBLOB          lpBlob,
            DWORD           dwFlags,
            DWORD           dwNameSpace,
        LPGUID          lpNspId,
        struct timeval *timeout,
        LPOVERLAPPED    lpOverlapped,
        LPLOOKUPSERVICE_COMPLETION_ROUTINE  lpCompletionRoutine,
    _Out_opt_   LPHANDLE        lpNameHandle
    );

#ifdef UNICODE
#define SetAddrInfoEx       SetAddrInfoExW
#else
#define SetAddrInfoEx       SetAddrInfoExA
#endif

#if INCL_WINSOCK_API_TYPEDEFS
#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)
typedef
INT
(__stdcall *LPFN_SETADDRINFOEXA)(
            PCSTR           pName,
        PCSTR           pServiceName,
        SOCKET_ADDRESS *pAddresses,
            DWORD           dwAddressCount,
        LPBLOB          lpBlob,
            DWORD           dwFlags,
            DWORD           dwNameSpace,
        LPGUID          lpNspId,
        struct timeval *timeout,
        LPOVERLAPPED    lpOverlapped,
        LPLOOKUPSERVICE_COMPLETION_ROUTINE  lpCompletionRoutine,
    _Out_opt_   LPHANDLE        lpNameHandle
    );
#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


typedef
INT
(__stdcall *LPFN_SETADDRINFOEXW)(
            PCWSTR          pName,
        PCWSTR          pServiceName,
        SOCKET_ADDRESS *pAddresses,
            DWORD           dwAddressCount,
        LPBLOB          lpBlob,
            DWORD           dwFlags,
            DWORD           dwNameSpace,
        LPGUID          lpNspId,
        struct timeval *timeout,
        LPOVERLAPPED    lpOverlapped,
        LPLOOKUPSERVICE_COMPLETION_ROUTINE  lpCompletionRoutine,
    _Out_opt_   LPHANDLE        lpNameHandle
    );

#ifdef UNICODE
#define LPFN_SETADDRINFOEX      LPFN_SETADDRINFOEXW
#else
#define LPFN_SETADDRINFOEX      LPFN_SETADDRINFOEXA
#endif
#endif

#endif
--]=]

ffi.cdef[[
VOID
__stdcall
freeaddrinfo(
            PADDRINFOA      pAddrInfo
    );
]]

--[=[
#if (NTDDI_VERSION >= NTDDI_WINXPSP2) || (_WIN32_WINNT >= 0x0502)

VOID
__stdcall
FreeAddrInfoW(
            PADDRINFOW      pAddrInfo
    );

#define FreeAddrInfoA   freeaddrinfo

#ifdef UNICODE
#define FreeAddrInfo    FreeAddrInfoW
#else
#define FreeAddrInfo    FreeAddrInfoA
#endif
#endif


#if INCL_WINSOCK_API_TYPEDEFS
typedef
VOID
(__stdcall * LPFN_FREEADDRINFO)(
            PADDRINFOA      pAddrInfo
    );
typedef
VOID
(__stdcall * LPFN_FREEADDRINFOW)(
            PADDRINFOW      pAddrInfo
    );

#define LPFN_FREEADDRINFOA      LPFN_FREEADDRINFO

#ifdef UNICODE
#define LPFN_FREEADDRINFOT      LPFN_FREEADDRINFOW
#else
#define LPFN_FREEADDRINFOT      LPFN_FREEADDRINFOA
#endif
#endif

#if (_WIN32_WINNT >= 0x0600)

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)
_WINSOCK_DEPRECATED_BY("FreeAddrInfoExW()")

void
__stdcall
FreeAddrInfoEx(
      PADDRINFOEXA    pAddrInfoEx
    );
#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



void
__stdcall
FreeAddrInfoExW(
      PADDRINFOEXW    pAddrInfoEx
    );

#define FreeAddrInfoExA     FreeAddrInfoEx

#ifdef UNICODE
#define FreeAddrInfoEx      FreeAddrInfoExW
#endif

#if INCL_WINSOCK_API_TYPEDEFS
#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)
typedef
void
(__stdcall *LPFN_FREEADDRINFOEXA)(
        PADDRINFOEXA    pAddrInfoEx
    );
#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


typedef
void
(__stdcall *LPFN_FREEADDRINFOEXW)(
        PADDRINFOEXW    pAddrInfoEx
    );


#ifdef UNICODE
#define LPFN_FREEADDRINFOEX     LPFN_FREEADDRINFOEXW
#else
#define LPFN_FREEADDRINFOEX     LPFN_FREEADDRINFOEXA
#endif

#endif
#endif

typedef int socklen_t;


INT
__stdcall
getnameinfo(
    _In_reads_bytes_(SockaddrLength)    const SOCKADDR *    pSockaddr,
                                    socklen_t           SockaddrLength,
    _Out_writes_opt_(NodeBufferSize)    PCHAR               pNodeBuffer,
                                    DWORD               NodeBufferSize,
    _Out_writes_opt_(ServiceBufferSize) PCHAR               pServiceBuffer,
                                    DWORD               ServiceBufferSize,
                                    INT                 Flags
    );

#if (NTDDI_VERSION >= NTDDI_WINXPSP2) || (_WIN32_WINNT >= 0x0502)

INT
__stdcall
GetNameInfoW(
    _In_reads_bytes_(SockaddrLength)    const SOCKADDR *    pSockaddr,
                                    socklen_t           SockaddrLength,
    _Out_writes_opt_(NodeBufferSize)    PWCHAR              pNodeBuffer,
                                    DWORD               NodeBufferSize,
    _Out_writes_opt_(ServiceBufferSize) PWCHAR              pServiceBuffer,
                                    DWORD               ServiceBufferSize,
                                    INT                 Flags
    );

#define GetNameInfoA    getnameinfo

#ifdef UNICODE
#define GetNameInfo     GetNameInfoW
#else
#define GetNameInfo     GetNameInfoA
#endif
#endif

#if INCL_WINSOCK_API_TYPEDEFS
typedef
int
(__stdcall * LPFN_GETNAMEINFO)(
    _In_reads_bytes_(SockaddrLength)    const SOCKADDR *    pSockaddr,
                                    socklen_t           SockaddrLength,
    _Out_writes_opt_(NodeBufferSize)    PCHAR               pNodeBuffer,
                                    DWORD               NodeBufferSize,
    _Out_writes_opt_(ServiceBufferSize) PCHAR               pServiceBuffer,
                                    DWORD               ServiceBufferSize,
                                    INT                 Flags
    );

typedef
INT
(__stdcall * LPFN_GETNAMEINFOW)(
    _In_reads_bytes_(SockaddrLength)    const SOCKADDR *    pSockaddr,
                                    socklen_t           SockaddrLength,
    _Out_writes_opt_(NodeBufferSize)    PWCHAR              pNodeBuffer,
                                    DWORD               NodeBufferSize,
    _Out_writes_opt_(ServiceBufferSize) PWCHAR              pServiceBuffer,
                                    DWORD               ServiceBufferSize,
                                    INT                 Flags
    );

#define LPFN_GETNAMEINFOA      LPFN_GETNAMEINFO

#ifdef UNICODE
#define LPFN_GETNAMEINFOT      LPFN_GETNAMEINFOW
#else
#define LPFN_GETNAMEINFOT      LPFN_GETNAMEINFOA
#endif
#endif


#if (NTDDI_VERSION >= NTDDI_VISTA)

INT
__stdcall
inet_pton(
                                          INT             Family,
                                          PCSTR           pszAddrString,
    _When_(Family == AF_INET, _Out_writes_bytes_(sizeof(IN_ADDR)))
    _When_(Family == AF_INET6, _Out_writes_bytes_(sizeof(IN6_ADDR)))
                                              PVOID           pAddrBuf
    );

INT
__stdcall
InetPtonW(
                                          INT             Family,
                                          PCWSTR          pszAddrString,
    _When_(Family == AF_INET, _Out_writes_bytes_(sizeof(IN_ADDR)))
    _When_(Family == AF_INET6, _Out_writes_bytes_(sizeof(IN6_ADDR)))
                                              PVOID           pAddrBuf
    );

PCSTR
__stdcall
inet_ntop(
                                    INT             Family,
                                    const VOID *    pAddr,
    _Out_writes_(StringBufSize)         PSTR            pStringBuf,
                                    size_t          StringBufSize
    );

PCWSTR
__stdcall
InetNtopW(
                                    INT             Family,
                                    const VOID *    pAddr,
    _Out_writes_(StringBufSize)         PWSTR           pStringBuf,
                                    size_t          StringBufSize
    );

#define InetPtonA       inet_pton
#define InetNtopA       inet_ntop

#ifdef UNICODE
#define InetPton        InetPtonW
#define InetNtop        InetNtopW
#else
#define InetPton        InetPtonA
#define InetNtop        InetNtopA
#endif

#if INCL_WINSOCK_API_TYPEDEFS
typedef
INT
(__stdcall * LPFN_INET_PTONA)(
                                          INT             Family,
                                          PCSTR           pszAddrString,
    _Out_writes_bytes_(sizeof(IN6_ADDR))      PVOID           pAddrBuf
    );

typedef
INT
(__stdcall * LPFN_INET_PTONW)(
                                    INT             Family,
                                          PCWSTR          pszAddrString,
    _Out_writes_bytes_(sizeof(IN6_ADDR))      PVOID           pAddrBuf
    );

typedef
PCSTR
(__stdcall * LPFN_INET_NTOPA)(
                                    INT             Family,
                                    PVOID           pAddr,
    _Out_writes_(StringBufSize)         PSTR            pStringBuf,
                                    size_t          StringBufSize
    );

typedef
PCWSTR
(__stdcall * LPFN_INET_NTOPW)(
                                    INT             Family,
                                    PVOID           pAddr,
    _Out_writes_(StringBufSize)         PWSTR           pStringBuf,
                                    size_t          StringBufSize
    );

#ifdef UNICODE
#define LPFN_INET_PTON          LPFN_INET_PTONW
#define LPFN_INET_NTOP          LPFN_INET_NTOPW
#else
#define LPFN_INET_PTON          LPFN_INET_PTONA
#define LPFN_INET_NTOP          LPFN_INET_NTOPA
#endif

#endif  //  TYPEDEFS
#endif  //  (NTDDI_VERSION >= NTDDI_VISTA)



#if INCL_WINSOCK_API_PROTOTYPES
#ifdef UNICODE
#define gai_strerror   gai_strerrorW
#else
#define gai_strerror   gai_strerrorA
#endif  /* UNICODE */

// WARNING: The gai_strerror inline functions below use static buffers,
// and hence are not thread-safe.  Well use buffers long enough to hold
// 1k characters.  Any system error messages longer than this will be
// returned as empty strings.  However 1k should work for the error codes
// used by getaddrinfo().
#define GAI_STRERROR_BUFFER_SIZE 1024

WS2TCPIP_INLINE
char *
gai_strerrorA(
     int ecode)
{
    static char buff[GAI_STRERROR_BUFFER_SIZE + 1];

    (void)FormatMessageA(FORMAT_MESSAGE_FROM_SYSTEM
                             |FORMAT_MESSAGE_IGNORE_INSERTS
                             |FORMAT_MESSAGE_MAX_WIDTH_MASK,
                              NULL,
                              ecode,
                              MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
                              (LPSTR)buff,
                              GAI_STRERROR_BUFFER_SIZE,
                              NULL);

    return buff;
}

WS2TCPIP_INLINE
WCHAR *
gai_strerrorW(
     int ecode
    )
{
    static WCHAR buff[GAI_STRERROR_BUFFER_SIZE + 1];

    (void)FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM
                             |FORMAT_MESSAGE_IGNORE_INSERTS
                             |FORMAT_MESSAGE_MAX_WIDTH_MASK,
                              NULL,
                              ecode,
                              MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
                              (LPWSTR)buff,
                              GAI_STRERROR_BUFFER_SIZE,
                              NULL);

    return buff;
}
#endif /* INCL_WINSOCK_API_PROTOTYPES */


/* Multicast source filter APIs from RFC 3678. */

WS2TCPIP_INLINE
int
setipv4sourcefilter(
     SOCKET Socket,
     IN_ADDR Interface,
     IN_ADDR Group,
     MULTICAST_MODE_TYPE FilterMode,
     ULONG SourceCount,
    _In_reads_(SourceCount) CONST IN_ADDR *SourceList
    )
{
    int Error;
    DWORD Size, Returned;
    PIP_MSFILTER Filter;

    if (SourceCount >
        (((ULONG) (ULONG_MAX - sizeof(*Filter))) / sizeof(*SourceList))) {
        WSASetLastError(WSAENOBUFS);
        return SOCKET_ERROR;
    }

    Size = IP_MSFILTER_SIZE(SourceCount);
    Filter = (PIP_MSFILTER) HeapAlloc(GetProcessHeap(), 0, Size);
    if (Filter == NULL) {
        WSASetLastError(WSAENOBUFS);
        return SOCKET_ERROR;
    }

    Filter->imsf_multiaddr = Group;
    Filter->imsf_interface = Interface;
    Filter->imsf_fmode = FilterMode;
    Filter->imsf_numsrc = SourceCount;
    if (SourceCount > 0) {
        CopyMemory(Filter->imsf_slist, SourceList,
                   SourceCount * sizeof(*SourceList));
    }

    Error = WSAIoctl(Socket, SIOCSIPMSFILTER, Filter, Size, NULL, 0,
                     &Returned, NULL, NULL);

    HeapFree(GetProcessHeap(), 0, Filter);

    return Error;
}

_Success_(return == 0)
WS2TCPIP_INLINE
int
getipv4sourcefilter(
     SOCKET Socket,
     IN_ADDR Interface,
     IN_ADDR Group,
    _Out_ MULTICAST_MODE_TYPE *FilterMode,
     ULONG *SourceCount,
    _Out_writes_(*SourceCount) IN_ADDR *SourceList
    )
{
    int Error;
    DWORD Size, Returned;
    PIP_MSFILTER Filter;

    if (*SourceCount >
        (((ULONG) (ULONG_MAX - sizeof(*Filter))) / sizeof(*SourceList))) {
        WSASetLastError(WSAENOBUFS);
        return SOCKET_ERROR;
    }

    Size = IP_MSFILTER_SIZE(*SourceCount);
    Filter = (PIP_MSFILTER) HeapAlloc(GetProcessHeap(), 0, Size);
    if (Filter == NULL) {
        WSASetLastError(WSAENOBUFS);
        return SOCKET_ERROR;
    }

    Filter->imsf_multiaddr = Group;
    Filter->imsf_interface = Interface;
    Filter->imsf_numsrc = *SourceCount;

    Error = WSAIoctl(Socket, SIOCGIPMSFILTER, Filter, Size, Filter, Size,
                     &Returned, NULL, NULL);

    if (Error == 0) {
        if (*SourceCount > 0) {
            CopyMemory(SourceList, Filter->imsf_slist,
                       *SourceCount * sizeof(*SourceList));
            *SourceCount = Filter->imsf_numsrc;
        }
        *FilterMode = Filter->imsf_fmode;
    }

    HeapFree(GetProcessHeap(), 0, Filter);

    return Error;
}

#if (NTDDI_VERSION >= NTDDI_WINXP)
WS2TCPIP_INLINE
int
setsourcefilter(
     SOCKET Socket,
     ULONG Interface,
     CONST SOCKADDR *Group,
     int GroupLength,
     MULTICAST_MODE_TYPE FilterMode,
     ULONG SourceCount,
    _In_reads_(SourceCount) CONST SOCKADDR_STORAGE *SourceList
    )
{
    int Error;
    DWORD Size, Returned;
    PGROUP_FILTER Filter;

    if (SourceCount >=
        (((ULONG) (ULONG_MAX - sizeof(*Filter))) / sizeof(*SourceList))) {
        WSASetLastError(WSAENOBUFS);
        return SOCKET_ERROR;
    }

    Size = GROUP_FILTER_SIZE(SourceCount);
    Filter = (PGROUP_FILTER) HeapAlloc(GetProcessHeap(), 0, Size);
    if (Filter == NULL) {
        WSASetLastError(WSAENOBUFS);
        return SOCKET_ERROR;
    }

    Filter->gf_interface = Interface;
    ZeroMemory(&Filter->gf_group, sizeof(Filter->gf_group));
    CopyMemory(&Filter->gf_group, Group, GroupLength);
    Filter->gf_fmode = FilterMode;
    Filter->gf_numsrc = SourceCount;
    if (SourceCount > 0) {
        CopyMemory(Filter->gf_slist, SourceList,
                   SourceCount * sizeof(*SourceList));
    }

    Error = WSAIoctl(Socket, SIOCSMSFILTER, Filter, Size, NULL, 0,
                     &Returned, NULL, NULL);

    HeapFree(GetProcessHeap(), 0, Filter);

    return Error;
}

_Success_(return == 0)
WS2TCPIP_INLINE
int
getsourcefilter(
     SOCKET Socket,
     ULONG Interface,
     CONST SOCKADDR *Group,
     int GroupLength,
    _Out_ MULTICAST_MODE_TYPE *FilterMode,
     ULONG *SourceCount,
    _Out_writes_(*SourceCount) SOCKADDR_STORAGE *SourceList
    )
{
    int Error;
    DWORD Size, Returned;
    PGROUP_FILTER Filter;

    if (*SourceCount >
        (((ULONG) (ULONG_MAX - sizeof(*Filter))) / sizeof(*SourceList))) {
        WSASetLastError(WSAENOBUFS);
        return SOCKET_ERROR;
    }

    Size = GROUP_FILTER_SIZE(*SourceCount);
    Filter = (PGROUP_FILTER) HeapAlloc(GetProcessHeap(), 0, Size);
    if (Filter == NULL) {
        WSASetLastError(WSAENOBUFS);
        return SOCKET_ERROR;
    }

    Filter->gf_interface = Interface;
    ZeroMemory(&Filter->gf_group, sizeof(Filter->gf_group));
    CopyMemory(&Filter->gf_group, Group, GroupLength);
    Filter->gf_numsrc = *SourceCount;

    Error = WSAIoctl(Socket, SIOCGMSFILTER, Filter, Size, Filter, Size,
                     &Returned, NULL, NULL);

    if (Error == 0) {
        if (*SourceCount > 0) {
            CopyMemory(SourceList, Filter->gf_slist,
                       *SourceCount * sizeof(*SourceList));
            *SourceCount = Filter->gf_numsrc;
        }
        *FilterMode = Filter->gf_fmode;
    }

    HeapFree(GetProcessHeap(), 0, Filter);

    return Error;
}
#endif

#ifdef IDEAL_SEND_BACKLOG_IOCTLS
--[[
//
// Wrapper functions for the ideal send backlog query and change notification
// ioctls
//

WS2TCPIP_INLINE 
int  
idealsendbacklogquery(
     SOCKET s,
    _Out_ ULONG *pISB
    )
{
    DWORD bytes;

    return WSAIoctl(s, SIO_IDEAL_SEND_BACKLOG_QUERY, 
                    NULL, 0, pISB, sizeof(*pISB), &bytes, NULL, NULL);
}


WS2TCPIP_INLINE 
int  
idealsendbacklognotify(
     SOCKET s,
     LPWSAOVERLAPPED lpOverlapped,
     LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    )
{
    DWORD bytes;

    return WSAIoctl(s, SIO_IDEAL_SEND_BACKLOG_CHANGE, 
                    NULL, 0, NULL, 0, &bytes, 
                    lpOverlapped, lpCompletionRoutine);
}
--]]
#endif

#if (_WIN32_WINNT >= 0x0600)
#ifdef _SECURE_SOCKET_TYPES_DEFINED_
#pragma region Desktop Family or AppRuntime Package
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_PKG_APPRUNTIME)

//
// Secure socket API definitions
//


INT
__stdcall
WSASetSocketSecurity (
    SOCKET Socket,
   const SOCKET_SECURITY_SETTINGS* SecuritySettings,
    ULONG SecuritySettingsLen,
    LPWSAOVERLAPPED Overlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE CompletionRoutine
);


INT
__stdcall
WSAQuerySocketSecurity (
    SOCKET Socket,
    const SOCKET_SECURITY_QUERY_TEMPLATE* SecurityQueryTemplate,
    ULONG SecurityQueryTemplateLen,
   SOCKET_SECURITY_QUERY_INFO* SecurityQueryInfo,
    ULONG* SecurityQueryInfoLen,
    LPWSAOVERLAPPED Overlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE CompletionRoutine
);


INT
__stdcall
WSASetSocketPeerTargetName (
    SOCKET Socket,
    const SOCKET_PEER_TARGET_NAME* PeerTargetName,
    ULONG PeerTargetNameLen,
    LPWSAOVERLAPPED Overlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE CompletionRoutine
);


INT
__stdcall
WSADeleteSocketPeerTargetName (
    SOCKET Socket,
    const struct sockaddr* PeerAddr,
    ULONG PeerAddrLen,
    LPWSAOVERLAPPED Overlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE CompletionRoutine
);


INT
__stdcall
WSAImpersonateSocketPeer (
    SOCKET Socket,
   _In_reads_bytes_opt_(PeerAddrLen) const struct sockaddr* PeerAddr,
    ULONG PeerAddrLen
);


INT
__stdcall
WSARevertImpersonation ();

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_PKG_APPRUNTIME) */

#endif //_SECURE_SOCKET_TYPES_DEFINED_
#endif //(_WIN32_WINNT >= 0x0600)

#ifdef __cplusplus
}
#endif



#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)
//
// Unless the build environment is explicitly targeting only
// platforms that include built-in getaddrinfo() support, include
// the backwards-compatibility version of the relevant APIs.
//
if not _WIN32_WINNT or (_WIN32_WINNT <= 0x0500) then
require("win32.wspiapi")
end
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



--]=]
end  -- _WS2TCPIP_H_

return ffi.load("Ws2_32")
