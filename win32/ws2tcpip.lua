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
if !defined(_WINSOCK_DEPRECATED_BY)
if ((defined(_WINSOCK_DEPRECATED_NO_WARNINGS) or defined(BUILD_WINDOWS)) && !defined(_WINSOCK_DEPRECATE_WARNINGS)) or defined(MIDL_PASS)
#define _WINSOCK_DEPRECATED_BY(replacement)
else
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


if (NTDDI_VERSION >= NTDDI_WINXPSP2) or (_WIN32_WINNT >= 0x0502) then

ffi.cdef[[
INT
__stdcall
GetAddrInfoW(
            PCWSTR              pNodeName,
            PCWSTR              pServiceName,
            const ADDRINFOW *   pHints,
            PADDRINFOW *        ppResult
    );
]]

--#define GetAddrInfoA    getaddrinfo

--[[
if UNICODE then
#define GetAddrInfo     GetAddrInfoW
else
#define GetAddrInfo     GetAddrInfoA
end
--]]

end


if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
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

typedef LPFN_GETADDRINFO  LPFN_GETADDRINFOA;
]]

--[[
if UNICODE then
#define LPFN_GETADDRINFOT      LPFN_GETADDRINFOW
else
#define LPFN_GETADDRINFOT      LPFN_GETADDRINFOA
#endif
--]]

end


if (_WIN32_WINNT >= 0x0600) then
ffi.cdef[[
typedef
void
(__stdcall * LPLOOKUPSERVICE_COMPLETION_ROUTINE)(
          DWORD    dwError,
          DWORD    dwBytes,
          LPWSAOVERLAPPED lpOverlapped
    );
]]

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
--_WINSOCK_DEPRECATED_BY("GetAddrInfoExW()")

ffi.cdef[[
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
       LPHANDLE        lpNameHandle
    );
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


ffi.cdef[[
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
       LPHANDLE        lpHandle
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
]]

--[[
if UNICODE then
#define GetAddrInfoEx       GetAddrInfoExW
else
#define GetAddrInfoEx       GetAddrInfoExA
#endif
--]]

if INCL_WINSOCK_API_TYPEDEFS then

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
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
       LPHANDLE        lpNameHandle
    );
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */

ffi.cdef[[
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
       LPHANDLE        lpHandle
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
]]

--[[
if UNICODE then
#define LPFN_GETADDRINFOEX      LPFN_GETADDRINFOEXW
else
#define LPFN_GETADDRINFOEX      LPFN_GETADDRINFOEXA
end
--]]

end

end


if (_WIN32_WINNT >= 0x0600) then

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
--_WINSOCK_DEPRECATED_BY("SetAddrInfoExW()")

ffi.cdef[[
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
       LPHANDLE        lpNameHandle
    );
]]
end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


ffi.cdef[[
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
       LPHANDLE        lpNameHandle
    );
]]

--[[
if UNICODE then
#define SetAddrInfoEx       SetAddrInfoExW
else
#define SetAddrInfoEx       SetAddrInfoExA
#endif
--]]

if INCL_WINSOCK_API_TYPEDEFS then

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then
ffi.cdef[[
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
       LPHANDLE        lpNameHandle
    );
]]
end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */

ffi.cdef[[
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
       LPHANDLE        lpNameHandle
    );
]]

--[[
if UNICODE then
#define LPFN_SETADDRINFOEX      LPFN_SETADDRINFOEXW
else
#define LPFN_SETADDRINFOEX      LPFN_SETADDRINFOEXA
#endif
--]]

end


end


ffi.cdef[[
VOID
__stdcall
freeaddrinfo(
            PADDRINFOA      pAddrInfo
    );
]]


if (NTDDI_VERSION >= NTDDI_WINXPSP2) or (_WIN32_WINNT >= 0x0502) then
ffi.cdef[[
VOID
__stdcall
FreeAddrInfoW(
            PADDRINFOW      pAddrInfo
    );
]]

--#define FreeAddrInfoA   freeaddrinfo

--[[
if UNICODE then
#define FreeAddrInfo    FreeAddrInfoW
else
#define FreeAddrInfo    FreeAddrInfoA
#endif
--]]

end


if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
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
]]

--#define LPFN_FREEADDRINFOA      LPFN_FREEADDRINFO

--[[
if UNICODE then
#define LPFN_FREEADDRINFOT      LPFN_FREEADDRINFOW
else
#define LPFN_FREEADDRINFOT      LPFN_FREEADDRINFOA
#endif
--]]

end

if (_WIN32_WINNT >= 0x0600) then


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
--_WINSOCK_DEPRECATED_BY("FreeAddrInfoExW()")
ffi.cdef[[
void
__stdcall
FreeAddrInfoEx(
      PADDRINFOEXA    pAddrInfoEx
    );
]]
end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


ffi.cdef[[
void
__stdcall
FreeAddrInfoExW(
      PADDRINFOEXW    pAddrInfoEx
    );
]]

--#define FreeAddrInfoExA     FreeAddrInfoEx

--[[
if UNICODE then
#define FreeAddrInfoEx      FreeAddrInfoExW
#endif
--]]

if INCL_WINSOCK_API_TYPEDEFS then

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
typedef
void
(__stdcall *LPFN_FREEADDRINFOEXA)(
        PADDRINFOEXA    pAddrInfoEx
    );
    ]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */

ffi.cdef[[
typedef
void
(__stdcall *LPFN_FREEADDRINFOEXW)(
        PADDRINFOEXW    pAddrInfoEx
    );
]]

--[[
if UNICODE then
#define LPFN_FREEADDRINFOEX     LPFN_FREEADDRINFOEXW
else
#define LPFN_FREEADDRINFOEX     LPFN_FREEADDRINFOEXA
end
--]]

end
end


ffi.cdef[[
typedef int socklen_t;


INT
__stdcall
getnameinfo(
        const SOCKADDR *    pSockaddr,
                                    socklen_t           SockaddrLength,
        PCHAR               pNodeBuffer,
                                    DWORD               NodeBufferSize,
     PCHAR               pServiceBuffer,
                                    DWORD               ServiceBufferSize,
                                    INT                 Flags
    );
]]


if (NTDDI_VERSION >= NTDDI_WINXPSP2) or (_WIN32_WINNT >= 0x0502) then
ffi.cdef[[
INT
__stdcall
GetNameInfoW(
    const SOCKADDR *    pSockaddr,
    socklen_t           SockaddrLength,
    PWCHAR              pNodeBuffer,
    DWORD               NodeBufferSize,
    PWCHAR              pServiceBuffer,
    DWORD               ServiceBufferSize,
    INT                 Flags
    );
]]

--#define GetNameInfoA    getnameinfo

--[[
if UNICODE then
#define GetNameInfo     GetNameInfoW
else
#define GetNameInfo     GetNameInfoA
end
--]]

end


if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
int
(__stdcall * LPFN_GETNAMEINFO)(
        const SOCKADDR *    pSockaddr,
                                    socklen_t           SockaddrLength,
        PCHAR               pNodeBuffer,
                                    DWORD               NodeBufferSize,
     PCHAR               pServiceBuffer,
                                    DWORD               ServiceBufferSize,
                                    INT                 Flags
    );

typedef
INT
(__stdcall * LPFN_GETNAMEINFOW)(
        const SOCKADDR *    pSockaddr,
                                    socklen_t           SockaddrLength,
        PWCHAR              pNodeBuffer,
                                    DWORD               NodeBufferSize,
     PWCHAR              pServiceBuffer,
                                    DWORD               ServiceBufferSize,
                                    INT                 Flags
    );

typedef LPFN_GETNAMEINFO  LPFN_GETNAMEINFOA;
]]

--[[
if UNICODE then
#define LPFN_GETNAMEINFOT      LPFN_GETNAMEINFOW
else
#define LPFN_GETNAMEINFOT      LPFN_GETNAMEINFOA
end
--]]

end


if (NTDDI_VERSION >= NTDDI_VISTA) then
ffi.cdef[[
INT
__stdcall
inet_pton(
    INT             Family,
    PCSTR           pszAddrString,
    PVOID           pAddrBuf
    );

INT
__stdcall
InetPtonW(
    INT             Family,
    PCWSTR          pszAddrString,
    PVOID           pAddrBuf
    );

PCSTR
__stdcall
inet_ntop(
    INT             Family,
    const VOID *    pAddr,
    PSTR            pStringBuf,
    size_t          StringBufSize
    );

PCWSTR
__stdcall
InetNtopW(
    INT             Family,
    const VOID *    pAddr,
    PWSTR           pStringBuf,
    size_t          StringBufSize
    );
]]

--#define InetPtonA       inet_pton
--#define InetNtopA       inet_ntop

--[[
if UNICODE then
#define InetPton        InetPtonW
#define InetNtop        InetNtopW
else
#define InetPton        InetPtonA
#define InetNtop        InetNtopA
#endif
--]]

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
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
             PSTR            pStringBuf,
                                    size_t          StringBufSize
    );

typedef
PCWSTR
(__stdcall * LPFN_INET_NTOPW)(
                                    INT             Family,
                                    PVOID           pAddr,
             PWSTR           pStringBuf,
                                    size_t          StringBufSize
    );
]]

--[[
if UNICODE then
#define LPFN_INET_PTON          LPFN_INET_PTONW
#define LPFN_INET_NTOP          LPFN_INET_NTOPW
else
#define LPFN_INET_PTON          LPFN_INET_PTONA
#define LPFN_INET_NTOP          LPFN_INET_NTOPA
#endif
--]]

end  --  TYPEDEFS
end  --  (NTDDI_VERSION >= NTDDI_VISTA)


--[=[
if INCL_WINSOCK_API_PROTOTYPES
if UNICODE then
#define gai_strerror   gai_strerrorW
else
#define gai_strerror   gai_strerrorA
#endif  /* UNICODE */

// WARNING: The gai_strerror inline functions below use static buffers,
// and hence are not thread-safe.  Well use buffers long enough to hold
// 1k characters.  Any system error messages longer than this will be
// returned as empty strings.  However 1k should work for the error codes
// used by getaddrinfo().
#define GAI_STRERROR_BUFFER_SIZE 1024


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
end  -- INCL_WINSOCK_API_PROTOTYPES */
--]=]

-- Multicast source filter APIs from RFC 3678. */

--[=[
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



int
getipv4sourcefilter(
     SOCKET Socket,
     IN_ADDR Interface,
     IN_ADDR Group,
     MULTICAST_MODE_TYPE *FilterMode,
     ULONG *SourceCount,
     IN_ADDR *SourceList
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

if (NTDDI_VERSION >= NTDDI_WINXP) then
if  then
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



int
getsourcefilter(
     SOCKET Socket,
     ULONG Interface,
     CONST SOCKADDR *Group,
     int GroupLength,
     MULTICAST_MODE_TYPE *FilterMode,
     ULONG *SourceCount,
     SOCKADDR_STORAGE *SourceList
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

end
--]=]

if IDEAL_SEND_BACKLOG_IOCTLS then
--[[
//
// Wrapper functions for the ideal send backlog query and change notification
// ioctls
//

 
int  
idealsendbacklogquery(
     SOCKET s,
     ULONG *pISB
    )
{
    DWORD bytes;

    return WSAIoctl(s, SIO_IDEAL_SEND_BACKLOG_QUERY, 
                    NULL, 0, pISB, sizeof(*pISB), &bytes, NULL, NULL);
}


 
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
end


if (_WIN32_WINNT >= 0x0600) then
if _SECURE_SOCKET_TYPES_DEFINED_ then

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_PKG_APPRUNTIME) then
ffi.cdef[[
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
    const struct sockaddr* PeerAddr,
    ULONG PeerAddrLen
);


INT
__stdcall
WSARevertImpersonation ();
]]
end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_PKG_APPRUNTIME) */

end  --_SECURE_SOCKET_TYPES_DEFINED_
end  --(_WIN32_WINNT >= 0x0600)



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then
--[[
// Unless the build environment is explicitly targeting only
// platforms that include built-in getaddrinfo() support, include
// the backwards-compatibility version of the relevant APIs.
--]]
if not _WIN32_WINNT or (_WIN32_WINNT <= 0x0500) then
--require("win32.wspiapi")
end
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */




end  -- _WS2TCPIP_H_

return ffi.load("Ws2_32")
