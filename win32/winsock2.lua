
local ffi = require("ffi")
local bit = require("bit")
local band, bor = bit.band, bit.bor
local lshift, rshift = bit.lshift, bit.rshift

local byte = string.byte

--[[
/* Winsock2.h -- definitions to be used with the WinSock 2 DLL and
*               WinSock 2 applications.
*
* This header file corresponds to version 2.2.x of the WinSock API
* specification.
*
* This file includes parts which are Copyright (c) 1982-1986 Regents
* of the University of California.  All rights reserved.  The
* Berkeley Software License Agreement specifies the terms and
* conditions for redistribution.
*/
--]]

local exports = {}

if not _WINSOCK2API_ then
_WINSOCK2API_ = true
_WINSOCKAPI_ = true  --/* Prevent inclusion of winsock.h in windows.h */


require("win32.winapifamily")

--[[
#if !defined(_WINSOCK_DEPRECATED_BY)
#if ((defined(_WINSOCK_DEPRECATED_NO_WARNINGS) || defined(BUILD_WINDOWS)) && !defined(_WINSOCK_DEPRECATE_WARNINGS)) || defined(MIDL_PASS)
#define _WINSOCK_DEPRECATED_BY(replacement)
#else
#define _WINSOCK_DEPRECATED_BY(replacement) __declspec(deprecated("Use " ## replacement ## " instead or define _WINSOCK_DEPRECATED_NO_WARNINGS to disable deprecated API warnings"))
end
end

#if !defined(_WINSOCK_DEPRECATED)
#if ((defined(_WINSOCK_DEPRECATED_NO_WARNINGS) || defined(BUILD_WINDOWS)) && !defined(_WINSOCK_DEPRECATE_WARNINGS)) || defined(MIDL_PASS)
#define _WINSOCK_DEPRECATED
#else
#define _WINSOCK_DEPRECATED __declspec(deprecated("Define _WINSOCK_DEPRECATED_NO_WARNINGS to disable deprecated API warnings"))
end
end
--]]


--* Default: include function prototypes, dont include function typedefs.


if not INCL_WINSOCK_API_PROTOTYPES then
INCL_WINSOCK_API_PROTOTYPES = 1
end

if not INCL_WINSOCK_API_TYPEDEFS then
INCL_WINSOCK_API_TYPEDEFS = false
end


if not _INC_WINDOWS then
require("win32.windows")
end --/* _INC_WINDOWS */

--[[
/*
* Ensure structures are packed consistently.
* Not necessary for WIN32, it is already packed >=4 and there are
* no structures in this header that have alignment requirement 
* higher than 4.
* For WIN64 we do not have compatibility requirement because it is
* not possible to mix 32/16 bit code with 64 bit code in the same
* process.
*/
--]]
if not _WIN64 and  not WIN32 then
--#include <pshpack4.h>
ffi.cdef[[
#pragma pack (push, 4)
]]
--/* WIN32 can be defined between here and the required poppack 
--  so define this special macro to ensure poppack */
_NEED_POPPACK = true
end

--[[
/*
* Define the current Winsock version. To build an earlier Winsock version
* application redefine this value prior to including Winsock2.h.
*/
--]]

if not MAKEWORD then
function MAKEWORD(low,high)
    return   ffi.cast("WORD", bor(ffi.cast("BYTE",low) , lshift(ffi.cast("WORD",ffi.cast("BYTE",high)) , 8)))
end
end

if not WINSOCK_VERSION then
WINSOCK_VERSION = MAKEWORD(2,2)
end

--[[
/*
* Establish DLL function linkage if supported by the current build
* environment and not previously defined.
*/

if not 
#ifdef DECLSPEC_IMPORT
#define  DECLSPEC_IMPORT
#else
#define 
end
end
--]]


ffi.cdef[[
/*
* Basic system type definitions, taken from the BSD file sys/types.h.
*/
typedef unsigned char   u_char;
typedef unsigned short  u_short;
typedef unsigned int    u_int;
typedef unsigned long   u_long;
]]

if _WIN32_WINNT >= 0x0501 then
ffi.cdef[[
typedef uint64_t u_int64;
]]
end --//(_WIN32_WINNT >= 0x0501)

require("win32.ws2def")

ffi.cdef[[
/*
* The new type to be used in all
* instances which refer to sockets.
*/
typedef UINT_PTR        SOCKET;
]]

--[[
/*
* Select uses arrays of SOCKETs.  These macros manipulate such
* arrays.  FD_SETSIZE may be defined by the user before including
* this file, but the default here should be >= 64.
*
* CAVEAT IMPLEMENTOR and USER: THESE MACROS AND TYPES MUST BE
* INCLUDED  WINSOCK2.H EXACTLY AS SHOWN HERE.
*/
--]]
if not FD_SETSIZE then
ffi.cdef[[
static const int FD_SETSIZE     = 64;
]]
end --/* FD_SETSIZE */

ffi.cdef[[
typedef struct fd_set {
       u_int fd_count;               /* how many are SET? */
       SOCKET  fd_array[FD_SETSIZE];   /* an array of SOCKETs */
} fd_set;
]]

--extern int __stdcall  __WSAFDIsSet(SOCKET fd, fd_set  *);

--[[
#define FD_CLR(fd, set) do { \
   u_int __i; \
   for (__i = 0; __i < ((fd_set  *)(set))->fd_count ; __i++) { \
       if (((fd_set  *)(set))->fd_array[__i] == fd) { \
           while (__i < ((fd_set  *)(set))->fd_count-1) { \
               ((fd_set  *)(set))->fd_array[__i] = \
                   ((fd_set  *)(set))->fd_array[__i+1]; \
               __i++; \
           } \
           ((fd_set  *)(set))->fd_count--; \
           break; \
       } \
   } \
} while(0, 0)

#define FD_SET(fd, set) do { \
   u_int __i; \
   for (__i = 0; __i < ((fd_set  *)(set))->fd_count; __i++) { \
       if (((fd_set  *)(set))->fd_array[__i] == (fd)) { \
           break; \
       } \
   } \
   if (__i == ((fd_set  *)(set))->fd_count) { \
       if (((fd_set  *)(set))->fd_count < FD_SETSIZE) { \
           ((fd_set  *)(set))->fd_array[__i] = (fd); \
           ((fd_set  *)(set))->fd_count++; \
       } \
   } \
} while(0, 0)

#define FD_ZERO(set) (((fd_set  *)(set))->fd_count=0)

#define FD_ISSET(fd, set) __WSAFDIsSet((SOCKET)(fd), (fd_set  *)(set))
--]]

ffi.cdef[[
/*
* Structure used in select() call, taken from the BSD file sys/time.h.
*/
struct timeval {
       long    tv_sec;         /* seconds */
       long    tv_usec;        /* and microseconds */
};
]]

-- BUGBUG, create a metatype
--[[
/*
* Operations on timevals.
*
* NB: timercmp does not work for >= or <=.
*/
#define timerisset(tvp)         ((tvp)->tv_sec || (tvp)->tv_usec)
#define timercmp(tvp, uvp, cmp) \
       ((tvp)->tv_sec cmp (uvp)->tv_sec || \
        (tvp)->tv_sec == (uvp)->tv_sec && (tvp)->tv_usec cmp (uvp)->tv_usec)
#define timerclear(tvp)         (tvp)->tv_sec = (tvp)->tv_usec = 0
]]

ffi.cdef[[
/*
* Commands for ioctlsocket(),  taken from the BSD file fcntl.h.
*
*
* Ioctls have the command encoded in the lower word,
* and the size of any in or out parameters in the upper
* word.  The high 2 bits of the upper word are used
* to encode the in/out status of the parameter; for now
* we restrict parameters to at most 128 bytes.
*/
static const int IOCPARM_MASK   = 0x7f;            /* parameters must be < 128 bytes */
static const int IOC_VOID       = 0x20000000;      /* no parameters */
static const int IOC_OUT        = 0x40000000;      /* copy out parameters */
static const int IOC_IN         = 0x80000000;      /* copy in parameters */
static const int IOC_INOUT      = (IOC_IN|IOC_OUT);
                                       /* 0x20000000 distinguishes new &
                                          old ioctls */
]]

local function _IO(x,y)
    return bor(ffi.C.IOC_VOID, lshift(x,8), y)
end
                                        
local function _IOR(x,y,t)
    return bor(ffi.C.IOC_OUT, lshift(band(ffi.sizeof(t),ffi.C.IOCPARM_MASK), 16), lshift(x,8), y)
end
                                        
local function _IOW(x,y,t)
    return bor(ffi.C.IOC_IN, lshift(band(ffi.sizeof(t),ffi.C.IOCPARM_MASK),16), lshift(x,8), y)
end

--[[
#define _IO(x,y)        (IOC_VOID|((x)<<8)|(y))

#define _IOR(x,y,t)     (IOC_OUT|(((long)sizeof(t)&IOCPARM_MASK)<<16)|((x)<<8)|(y))

#define _IOW(x,y,t)     (IOC_IN|(((long)sizeof(t)&IOCPARM_MASK)<<16)|((x)<<8)|(y))
--]]

--[=[
#define FIONREAD    _IOR('f', 127, u_long) /* get # bytes to read */
#define FIONBIO     _IOW('f', 126, u_long) /* set/clear non-blocking i/o */
#define FIOASYNC    _IOW('f', 125, u_long) /* set/clear async i/o */

/* Socket I/O Controls */
#define SIOCSHIWAT  _IOW('s',  0, u_long)  /* set high watermark */
#define SIOCGHIWAT  _IOR('s',  1, u_long)  /* get high watermark */
#define SIOCSLOWAT  _IOW('s',  2, u_long)  /* set low watermark */
#define SIOCGLOWAT  _IOR('s',  3, u_long)  /* get low watermark */
#define SIOCATMARK  _IOR('s',  7, u_long)  /* at oob mark? */
--]=]

ffi.cdef[[
/*
* Structures returned by network data base library, taken from the
* BSD file netdb.h.  All addresses are supplied in host order, and
* returned in network order (suitable for use in system calls).
*/

struct  hostent {
       char     * h_name;           /* official name of host */
       char     *  * h_aliases;  /* alias list */
       short   h_addrtype;             /* host address type */
       short   h_length;               /* length of address */
       char     *  * h_addr_list; /* list of addresses */
//#define h_addr  h_addr_list[0]          /* address, for backward compat */
};
]]

ffi.cdef[[
/*
* It is assumed here that a network number
* fits in 32 bits.
*/
struct  netent {
       char     * n_name;           /* official name of net */
       char     *  * n_aliases;  /* alias list */
       short   n_addrtype;             /* net address type */
       u_long  n_net;                  /* network # */
};
]]

if _WIN64 then
ffi.cdef[[
    struct  servent {
        char     * s_name;           /* official service name */
        char     *  * s_aliases;  /* alias list */
        char     * s_proto;          /* protocol to use */
        short   s_port;                 /* port # */
 };
]]
else
ffi.cdef[[
    struct  servent {
        char     * s_name;           /* official service name */
        char     *  * s_aliases;  /* alias list */
        short   s_port;                 /* port # */
        char     * s_proto;          /* protocol to use */
 };
]]
end


ffi.cdef[[
struct  protoent {
       char     * p_name;           /* official protocol name */
       char     *  * p_aliases;  /* alias list */
       short   p_proto;                /* protocol # */
};
]]


-- BUGBUG
-- dont need these IPPORT declarations as they're in ws2def
--
--[[
/*
* Port/socket numbers: network standard functions
*/
#define IPPORT_ECHO             7
#define IPPORT_DISCARD          9
#define IPPORT_SYSTAT           11
#define IPPORT_DAYTIME          13
#define IPPORT_NETSTAT          15
#define IPPORT_FTP              21
#define IPPORT_TELNET           23
#define IPPORT_SMTP             25
#define IPPORT_TIMESERVER       37
#define IPPORT_NAMESERVER       42
#define IPPORT_WHOIS            43
#define IPPORT_MTP              57

/*
* Port/socket numbers: host specific functions
*/
#define IPPORT_TFTP             69
#define IPPORT_RJE              77
#define IPPORT_FINGER           79
#define IPPORT_TTYLINK          87
#define IPPORT_SUPDUP           95


/*
* UNIX TCP sockets
*/
#define IPPORT_EXECSERVER       512
#define IPPORT_LOGINSERVER      513
#define IPPORT_CMDSERVER        514
#define IPPORT_EFSSERVER        520

/*
* UNIX UDP sockets
*/
#define IPPORT_BIFFUDP          512
#define IPPORT_WHOSERVER        513
#define IPPORT_ROUTESERVER      520
                                       /* 520+1 also used */

/*
* Ports < IPPORT_RESERVED are reserved for
* privileged processes (e.g. root).
*/
#define IPPORT_RESERVED         1024
--]]

ffi.cdef[[
/*
* Link numbers
*/
static const int IMPLINK_IP            =  155;
static const int IMPLINK_LOWEXPER      =  156;
static const int IMPLINK_HIGHEXPER     =  158;
]]

--[[
-- BUGBUG, this is in inaddr, so don't do this here
if not s_addr
/*
* Internet address (old style... should be updated)
*/
struct in_addr {
       union {
               struct { u_char s_b1,s_b2,s_b3,s_b4; } S_un_b;
               struct { u_short s_w1,s_w2; } S_un_w;
               u_long S_addr;
       } S_un;
#define s_addr  S_un.S_addr
                               /* can be used for most tcp & ip code */
#define s_host  S_un.S_un_b.s_b2
                               /* host on imp */
#define s_net   S_un.S_un_b.s_b1
                               /* network */
#define s_imp   S_un.S_un_w.s_w2
                               /* imp */
#define s_impno S_un.S_un_b.s_b4
                               /* imp # */
#define s_lh    S_un.S_un_b.s_b3
                               /* logical host */
};
end
--]]

ffi.cdef[[
static const int ADDR_ANY               = INADDR_ANY;

static const int WSADESCRIPTION_LEN     = 256;
static const int WSASYS_STATUS_LEN      = 128;
]]

if _WIN64 then
ffi.cdef[[
typedef struct WSAData {
        WORD                    wVersion;
        WORD                    wHighVersion;
        unsigned short          iMaxSockets;
        unsigned short          iMaxUdpDg;
        char  *              lpVendorInfo;
        char                    szDescription[WSADESCRIPTION_LEN+1];
        char                    szSystemStatus[WSASYS_STATUS_LEN+1];
} WSADATA,  * LPWSADATA;
]]
else
ffi.cdef[[
    typedef struct WSAData {
        WORD                    wVersion;
        WORD                    wHighVersion;
        char                    szDescription[WSADESCRIPTION_LEN+1];
        char                    szSystemStatus[WSASYS_STATUS_LEN+1];
        unsigned short          iMaxSockets;
        unsigned short          iMaxUdpDg;
        char  *              lpVendorInfo;
 } WSADATA,  * LPWSADATA;
]]
end



-- SOCKET poses an interesting case.  INVALID_SOCKET
-- is defined as (SOCKET)~0 in the windows headers.
-- SOCKET_ERROR == -1
-- On a twos complement machine, these should be the same,
-- so which one to use for LuaJIT?
-- words on the definition of INVALID_SOCKET
-- http://stackoverflow.com/questions/10817252/why-is-invalid-socket-defined-as-0-in-winsock2-h-c
--
-- The bottom line is, we'll use -1 because it will work in all cases
ffi.cdef[[
static const int INVALID_SOCKET = -1;
static const int SOCKET_ERROR = -1;
]]
--#define INVALID_SOCKET  (SOCKET)(~0)
--#define SOCKET_ERROR            (-1)

ffi.cdef[[
static const int FROM_PROTOCOL_INFO = -1;
]]

--[[
-- these are in ws2def, so not needed here

/*
* Types
*/
#define SOCK_STREAM     1               /* stream socket */
#define SOCK_DGRAM      2               /* datagram socket */
#define SOCK_RAW        3               /* raw-protocol interface */
#define SOCK_RDM        4               /* reliably-delivered message */
#define SOCK_SEQPACKET  5               /* sequenced packet stream */


/*
* Option flags per-socket.
*/
#define SO_DEBUG        0x0001          /* turn on debugging info recording */
#define SO_ACCEPTCONN   0x0002          /* socket has had listen() */
#define SO_REUSEADDR    0x0004          /* allow local address reuse */
#define SO_KEEPALIVE    0x0008          /* keep connections alive */
#define SO_DONTROUTE    0x0010          /* just use interface addresses */
#define SO_BROADCAST    0x0020          /* permit sending of broadcast msgs */
#define SO_USELOOPBACK  0x0040          /* bypass hardware when possible */
#define SO_LINGER       0x0080          /* linger on close if data present */
#define SO_OOBINLINE    0x0100          /* leave received OOB data in line */

#define SO_DONTLINGER   (int)(~SO_LINGER)
#define SO_EXCLUSIVEADDRUSE ((int)(~SO_REUSEADDR)) /* disallow local address reuse */

/*
* Additional options.
*/
#define SO_SNDBUF       0x1001          /* send buffer size */
#define SO_RCVBUF       0x1002          /* receive buffer size */
#define SO_SNDLOWAT     0x1003          /* send low-water mark */
#define SO_RCVLOWAT     0x1004          /* receive low-water mark */
#define SO_SNDTIMEO     0x1005          /* send timeout */
#define SO_RCVTIMEO     0x1006          /* receive timeout */
#define SO_ERROR        0x1007          /* get error status and clear */
#define SO_TYPE         0x1008          /* get socket type */
--]]

--[[
/*
* WinSock 2 extension -- new options
*/
#define SO_GROUP_ID       0x2001      /* ID of a socket group */
#define SO_GROUP_PRIORITY 0x2002      /* the relative priority within a group*/
#define SO_MAX_MSG_SIZE   0x2003      /* maximum message size */
--]]

ffi.cdef[[
static const int SO_PROTOCOL_INFOA = 0x2004;      /* WSAPROTOCOL_INFOA structure */
static const int SO_PROTOCOL_INFOW = 0x2005;      /* WSAPROTOCOL_INFOW structure */
]]

--[[
#ifdef UNICODE
#define SO_PROTOCOL_INFO  SO_PROTOCOL_INFOW
#else
#define SO_PROTOCOL_INFO  SO_PROTOCOL_INFOA
end --/* UNICODE */
--]]

ffi.cdef[[
static const int PVD_CONFIG     =   0x3001;       /* configuration info for service provider */
]]

--[[
-- BUGBUG, already defined in ws2def
#define SO_CONDITIONAL_ACCEPT 0x3002   /* enable true conditional accept: */
                                      /*  connection is not ack-ed to the */
                                      /*  other side until conditional */
                                      /*  function returns CF_ACCEPT */
--]]

ffi.cdef[[
/*
* Structure used by kernel to pass protocol
* information in raw sockets.
*/
struct sockproto {
       u_short sp_family;              /* address family */
       u_short sp_protocol;            /* protocol */
};
]]

--[[
/*
* Protocol families, same as address families for now.
*/
#define PF_UNSPEC       AF_UNSPEC
#define PF_UNIX         AF_UNIX
#define PF_INET         AF_INET
#define PF_IMPLINK      AF_IMPLINK
#define PF_PUP          AF_PUP
#define PF_CHAOS        AF_CHAOS
#define PF_NS           AF_NS
#define PF_IPX          AF_IPX
#define PF_ISO          AF_ISO
#define PF_OSI          AF_OSI
#define PF_ECMA         AF_ECMA
#define PF_DATAKIT      AF_DATAKIT
#define PF_CCITT        AF_CCITT
#define PF_SNA          AF_SNA
#define PF_DECnet       AF_DECnet
#define PF_DLI          AF_DLI
#define PF_LAT          AF_LAT
#define PF_HYLINK       AF_HYLINK
#define PF_APPLETALK    AF_APPLETALK
#define PF_VOICEVIEW    AF_VOICEVIEW
#define PF_FIREFOX      AF_FIREFOX
#define PF_UNKNOWN1     AF_UNKNOWN1
#define PF_BAN          AF_BAN
#define PF_ATM          AF_ATM
#define PF_INET6        AF_INET6
if (_WIN32_WINNT >= 0x0600)
#define PF_BTH          AF_BTH
end --(_WIN32_WINNT >= 0x0600)

#define PF_MAX          AF_MAX
--]]

ffi.cdef[[

/*
* Structure used for manipulating linger option.
*/
struct  linger {
       u_short l_onoff;                /* option on/off */
       u_short l_linger;               /* linger time */
};
]]

--[[
-- BUGBUG, in ws2def
/*
* Level number for (get/set)sockopt() to apply to socket itself.
*/
#define SOL_SOCKET      0xffff          /* options for socket level */
--]]


ffi.cdef[[
static const int SOMAXCONN      = 0x7fffffff
]]

function exports.SOMAXCONN_HINT(b) return -(b) end

ffi.cdef[[
static const int MSG_OOB         = 0x1;             /* process out-of-band data */
static const int MSG_PEEK        = 0x2;             /* peek at incoming message */
static const int MSG_DONTROUTE   = 0x4;             /* send without using routing tables */
static const int MSG_WAITALL     = 0x8;             /* do not complete until packet is completely filled */
static const int MSG_PUSH_IMMEDIATE = 0x20;         /* Do not delay receive request completion if data is available */
static const int MSG_PARTIAL     = 0x8000;          /* partial send or recv for message xport */
static const int MSG_INTERRUPT   = 0x10;            /* send/recv in the interrupt context */

static const int MSG_MAXIOVLEN   = 16;
static const int MAXGETHOSTSTRUCT      =  1024;
]]

ffi.cdef[[
/*
* WinSock 2 extension -- bit values and indices for FD_XXX network events
*/
static const int FD_READ_BIT     = 0;
static const int FD_READ         = (1 << FD_READ_BIT);

static const int FD_WRITE_BIT    = 1;
static const int FD_WRITE        = (1 << FD_WRITE_BIT);

static const int FD_OOB_BIT      = 2;
static const int FD_OOB          = (1 << FD_OOB_BIT);

static const int FD_ACCEPT_BIT   = 3;
static const int FD_ACCEPT       = (1 << FD_ACCEPT_BIT);

static const int FD_CONNECT_BIT   =4;
static const int FD_CONNECT       =(1 << FD_CONNECT_BIT);

static const int FD_CLOSE_BIT     =5;
static const int FD_CLOSE         =(1 << FD_CLOSE_BIT);

static const int FD_QOS_BIT       =6;
static const int FD_QOS           =(1 << FD_QOS_BIT);

static const int FD_GROUP_QOS_BIT =7;
static const int FD_GROUP_QOS     =(1 << FD_GROUP_QOS_BIT);

static const int FD_ROUTING_INTERFACE_CHANGE_BIT =8;
static const int FD_ROUTING_INTERFACE_CHANGE   =  (1 << FD_ROUTING_INTERFACE_CHANGE_BIT);

static const int FD_ADDRESS_LIST_CHANGE_BIT =9;
static const int FD_ADDRESS_LIST_CHANGE    = (1 << FD_ADDRESS_LIST_CHANGE_BIT);

static const int FD_MAX_EVENTS   = 10;
static const int FD_ALL_EVENTS   = ((1 << FD_MAX_EVENTS) - 1);
]]


--[[
/*
* Compatibility macros.
*/

#define h_errno         WSAGetLastError()
#define HOST_NOT_FOUND          WSAHOST_NOT_FOUND
#define TRY_AGAIN               WSATRY_AGAIN
#define NO_RECOVERY             WSANO_RECOVERY
#define NO_DATA                 WSANO_DATA
/* no address, look for MX record */
#define WSANO_ADDRESS           WSANO_DATA
#define NO_ADDRESS              WSANO_ADDRESS
--]]





--* WinSock 2 extension -- new error codes and type definition


if WIN32 then

--#define __stdcall                   __stdcall
ffi.cdef[[
typedef HANDLE                  WSAEVENT;
typedef LPHANDLE                LPWSAEVENT;
typedef OVERLAPPED              WSAOVERLAPPED;
typedef struct _OVERLAPPED *    LPWSAOVERLAPPED;
]]

ffi.cdef[[
static const int WSA_IO_PENDING          = ERROR_IO_PENDING;
static const int WSA_IO_INCOMPLETE       = (ERROR_IO_INCOMPLETE);
static const int WSA_INVALID_HANDLE      = (ERROR_INVALID_HANDLE);
static const int WSA_INVALID_PARAMETER   =(ERROR_INVALID_PARAMETER);
static const int WSA_NOT_ENOUGH_MEMORY   =(ERROR_NOT_ENOUGH_MEMORY);
static const int WSA_OPERATION_ABORTED   =(ERROR_OPERATION_ABORTED);
]]



ffi.cdef[[
//static const int WSA_INVALID_EVENT    =   ((WSAEVENT)NULL);
static const int WSA_MAXIMUM_WAIT_EVENTS= (MAXIMUM_WAIT_OBJECTS);
static const int WSA_WAIT_FAILED        = (WAIT_FAILED);
static const int WSA_WAIT_EVENT_0       = (WAIT_OBJECT_0);
static const int WSA_WAIT_IO_COMPLETION = (WAIT_IO_COMPLETION);
static const int WSA_WAIT_TIMEOUT       = (WAIT_TIMEOUT);
static const int WSA_INFINITE           = (INFINITE);
]]



else --/* WIN16 */
--[[
#define __stdcall                   __stdcall
typedef DWORD                   WSAEVENT,  * LPWSAEVENT;

typedef struct _WSAOVERLAPPED {
   DWORD    Internal;
   DWORD    InternalHigh;
   DWORD    Offset;
   DWORD    OffsetHigh;
   WSAEVENT hEvent;
} WSAOVERLAPPED,  * LPWSAOVERLAPPED;

#define WSA_IO_PENDING          (WSAEWOULDBLOCK)
#define WSA_IO_INCOMPLETE       (WSAEWOULDBLOCK)
#define WSA_INVALID_HANDLE      (WSAENOTSOCK)
#define WSA_INVALID_PARAMETER   (WSAEINVAL)
#define WSA_NOT_ENOUGH_MEMORY   (WSAENOBUFS)
#define WSA_OPERATION_ABORTED   (WSAEINTR)

#define WSA_INVALID_EVENT       ((WSAEVENT)NULL)
#define WSA_MAXIMUM_WAIT_EVENTS (MAXIMUM_WAIT_OBJECTS)
#define WSA_WAIT_FAILED         ((DWORD)-1L)
#define WSA_WAIT_EVENT_0        ((DWORD)0)
#define WSA_WAIT_TIMEOUT        ((DWORD)0x102L)
#define WSA_INFINITE            ((DWORD)-1L)
--]]
end  --/* WIN32 */


--#define LPQOS LPVOID


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then
--#undef LPQOS


--* Include qos.h to pull in FLOWSPEC and related definitions

require("win32.qos")

ffi.cdef[[
typedef struct _QualityOfService
{
   FLOWSPEC      SendingFlowspec;       /* the flow spec for data sending */
   FLOWSPEC      ReceivingFlowspec;     /* the flow spec for data receiving */
   WSABUF        ProviderSpecific;      /* additional provider specific stuff */
} QOS, * LPQOS;
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */

ffi.cdef[[
/*
* WinSock 2 extension -- manifest constants for return values of the condition function
*/
static const int CF_ACCEPT     =  0x0000;
static const int CF_REJECT     =  0x0001;
static const int CF_DEFER      =  0x0002;

/*
* WinSock 2 extension -- manifest constants for shutdown()
*/
static const int SD_RECEIVE    =  0x00;
static const int SD_SEND       =  0x01;
static const int SD_BOTH       =  0x02;

/*
* WinSock 2 extension -- data type and manifest constants for socket groups
*/
typedef unsigned int             GROUP;

static const int SG_UNCONSTRAINED_GROUP  = 0x01;
static const int SG_CONSTRAINED_GROUP    = 0x02;
]]

ffi.cdef[[
/*
* WinSock 2 extension -- data type for WSAEnumNetworkEvents()
*/
typedef struct _WSANETWORKEVENTS {
      long lNetworkEvents;
      int iErrorCode[FD_MAX_EVENTS];
} WSANETWORKEVENTS,  * LPWSANETWORKEVENTS;
]]

--[[
* WinSock 2 extension -- WSAPROTOCOL_INFO structure and associated
* manifest constants
--]]

if not GUID_DEFINED then
require("win32.guiddef")
end --/* GUID_DEFINED */


ffi.cdef[[
static const int MAX_PROTOCOL_CHAIN = 7;

static const int BASE_PROTOCOL      = 1;
static const int LAYERED_PROTOCOL   = 0;

typedef struct _WSAPROTOCOLCHAIN {
   int ChainLen;                                 /* the length of the chain,     */
                                                 /* length = 0 means layered protocol, */
                                                 /* length = 1 means base protocol, */
                                                 /* length > 1 means protocol chain */
   DWORD ChainEntries[MAX_PROTOCOL_CHAIN];       /* a list of dwCatalogEntryIds */
} WSAPROTOCOLCHAIN,  * LPWSAPROTOCOLCHAIN;
]]

ffi.cdef[[
static const int WSAPROTOCOL_LEN = 255;

typedef struct _WSAPROTOCOL_INFOA {
   DWORD dwServiceFlags1;
   DWORD dwServiceFlags2;
   DWORD dwServiceFlags3;
   DWORD dwServiceFlags4;
   DWORD dwProviderFlags;
   GUID ProviderId;
   DWORD dwCatalogEntryId;
   WSAPROTOCOLCHAIN ProtocolChain;
   int iVersion;
   int iAddressFamily;
   int iMaxSockAddr;
   int iMinSockAddr;
   int iSocketType;
   int iProtocol;
   int iProtocolMaxOffset;
   int iNetworkByteOrder;
   int iSecurityScheme;
   DWORD dwMessageSize;
   DWORD dwProviderReserved;
   CHAR   szProtocol[WSAPROTOCOL_LEN+1];
} WSAPROTOCOL_INFOA,  * LPWSAPROTOCOL_INFOA;

typedef struct _WSAPROTOCOL_INFOW {
   DWORD dwServiceFlags1;
   DWORD dwServiceFlags2;
   DWORD dwServiceFlags3;
   DWORD dwServiceFlags4;
   DWORD dwProviderFlags;
   GUID ProviderId;
   DWORD dwCatalogEntryId;
   WSAPROTOCOLCHAIN ProtocolChain;
   int iVersion;
   int iAddressFamily;
   int iMaxSockAddr;
   int iMinSockAddr;
   int iSocketType;
   int iProtocol;
   int iProtocolMaxOffset;
   int iNetworkByteOrder;
   int iSecurityScheme;
   DWORD dwMessageSize;
   DWORD dwProviderReserved;
   WCHAR  szProtocol[WSAPROTOCOL_LEN+1];
} WSAPROTOCOL_INFOW,  * LPWSAPROTOCOL_INFOW;
]]

--[[
#ifdef UNICODE
typedef WSAPROTOCOL_INFOW WSAPROTOCOL_INFO;
typedef LPWSAPROTOCOL_INFOW LPWSAPROTOCOL_INFO;
#else
typedef WSAPROTOCOL_INFOA WSAPROTOCOL_INFO;
typedef LPWSAPROTOCOL_INFOA LPWSAPROTOCOL_INFO;
end --/* UNICODE */
--]]

--[[
/* Flag bit definitions for dwProviderFlags */
#define PFL_MULTIPLE_PROTO_ENTRIES       =   0x00000001;
#define PFL_RECOMMENDED_PROTO_ENTRY      =   0x00000002;
#define PFL_HIDDEN                       =   0x00000004;
#define PFL_MATCHES_PROTOCOL_ZERO        =   0x00000008;
#define PFL_NETWORKDIRECT_PROVIDER       =   0x00000010;

/* Flag bit definitions for dwServiceFlags1 */
#define XP1_CONNECTIONLESS               =   0x00000001;
#define XP1_GUARANTEED_DELIVERY          =   0x00000002;
#define XP1_GUARANTEED_ORDER             =   0x00000004;
#define XP1_MESSAGE_ORIENTED             =   0x00000008;
#define XP1_PSEUDO_STREAM                =   0x00000010;
#define XP1_GRACEFUL_CLOSE               =   0x00000020;
#define XP1_EXPEDITED_DATA               =   0x00000040;
#define XP1_CONNECT_DATA                 =   0x00000080;
#define XP1_DISCONNECT_DATA              =   0x00000100;
#define XP1_SUPPORT_BROADCAST            =   0x00000200;
#define XP1_SUPPORT_MULTIPOINT           =   0x00000400;
#define XP1_MULTIPOINT_CONTROL_PLANE     =   0x00000800;
#define XP1_MULTIPOINT_DATA_PLANE        =   0x00001000;
#define XP1_QOS_SUPPORTED                =   0x00002000;
#define XP1_INTERRUPT                    =   0x00004000;
#define XP1_UNI_SEND                     =   0x00008000;
#define XP1_UNI_RECV                     =   0x00010000;
#define XP1_IFS_HANDLES                  =   0x00020000;
#define XP1_PARTIAL_MESSAGE              =   0x00040000;
#define XP1_SAN_SUPPORT_SDP              =   0x00080000;
--]]

ffi.cdef[[
static const int BIGENDIAN                        =   0x0000;
static const int LITTLEENDIAN                     =   0x0001;

static const int SECURITY_PROTOCOL_NONE           =   0x0000;

/*
* WinSock 2 extension -- manifest constants for WSAJoinLeaf()
*/
static const int JL_SENDER_ONLY   = 0x01;
static const int JL_RECEIVER_ONLY = 0x02;
static const int JL_BOTH          = 0x04;
]]

ffi.cdef[[
/*
* WinSock 2 extension -- manifest constants for WSASocket()
*/
static const int WSA_FLAG_OVERLAPPED          = 0x01;
static const int WSA_FLAG_MULTIPOINT_C_ROOT   = 0x02;
static const int WSA_FLAG_MULTIPOINT_C_LEAF   = 0x04;
static const int WSA_FLAG_MULTIPOINT_D_ROOT   = 0x08;
static const int WSA_FLAG_MULTIPOINT_D_LEAF   = 0x10;
static const int WSA_FLAG_ACCESS_SYSTEM_SECURITY =0x40;
static const int WSA_FLAG_NO_HANDLE_INHERIT  =  0x80;
static const int WSA_FLAG_REGISTERED_IO      = 0x100;
]]

ffi.cdef[[


typedef
int
(__stdcall * LPCONDITIONPROC)(
    LPWSABUF lpCallerId,
    LPWSABUF lpCallerData,
     LPQOS lpSQOS,
     LPQOS lpGQOS,
    LPWSABUF lpCalleeId,
    LPWSABUF lpCalleeData,
    GROUP  * g,
    DWORD_PTR dwCallbackData
   );

typedef
void
(__stdcall * LPWSAOVERLAPPED_COMPLETION_ROUTINE)(
    DWORD dwError,
    DWORD cbTransferred,
    LPWSAOVERLAPPED lpOverlapped,
    DWORD dwFlags
   );
]]

if (_WIN32_WINNT >= 0x0501) then
ffi.cdef[[
/*
* WinSock 2 extension -- manifest constants and associated structures
* for WSANSPIoctl()
*/
//#define SIO_NSP_NOTIFY_CHANGE         _WSAIOW(IOC_WS2,25)

typedef enum _WSACOMPLETIONTYPE {
   NSP_NOTIFY_IMMEDIATELY = 0,
   NSP_NOTIFY_HWND,
   NSP_NOTIFY_EVENT,
   NSP_NOTIFY_PORT,
   NSP_NOTIFY_APC,
} WSACOMPLETIONTYPE, *PWSACOMPLETIONTYPE,  * LPWSACOMPLETIONTYPE;

typedef struct _WSACOMPLETION {
   WSACOMPLETIONTYPE Type;
   union {
       struct {
           HWND hWnd;
           UINT uMsg;
           WPARAM context;
       } WindowMessage;
       struct {
           LPWSAOVERLAPPED lpOverlapped;
       } Event;
       struct {
           LPWSAOVERLAPPED lpOverlapped;
           LPWSAOVERLAPPED_COMPLETION_ROUTINE lpfnCompletionProc;
       } Apc;
       struct {
           LPWSAOVERLAPPED lpOverlapped;
           HANDLE hPort;
           ULONG_PTR Key;
       } Port;
   } Parameters;
} WSACOMPLETION, *PWSACOMPLETION,  *LPWSACOMPLETION;
]]
end --(_WIN32_WINNT >= 0x0501)

ffi.cdef[[
/*
* WinSock 2 extension -- manifest constants for SIO_TRANSLATE_HANDLE ioctl
*/
static const int TH_NETDEV     =   0x00000001;
static const int TH_TAPI       =   0x00000002;
]]


if not _tagBLOB_DEFINED then
_tagBLOB_DEFINED = true
_BLOB_DEFINED = true
_LPBLOB_DEFINED = true
ffi.cdef[[
typedef struct _BLOB {
   ULONG cbSize ;
   BYTE *pBlobData ;
} BLOB, *LPBLOB ;
]]
end


ffi.cdef[[
static const int SERVICE_MULTIPLE      = (0x00000001);
]]

-- BUGBUG, some are defined in ws2def
ffi.cdef[[

//static const int NS_ALL                      = 0;

//static const int NS_SAP                      = 1;
//static const int NS_NDS                      = 2;
//static const int NS_PEER_BROWSE              = 3;
//static const int NS_SLP                      = 5;
//static const int NS_DHCP                     = 6;

//static const int NS_TCPIP_LOCAL              = 10;
//static const int NS_TCPIP_HOSTS              = 11;
//static const int NS_DNS                      = 12;
//static const int NS_NETBT                    = 13;
//static const int NS_WINS                     = 14;

//static const int NS_NLA                      = 15;    /* Network Location Awareness */

//static const int NS_BTH                      = 16;    /* Bluetooth SDP Namespace */

//static const int NS_NBP                      = 20;

//static const int NS_MS                       = 30;
//static const int NS_STDA                     = 31;
//static const int NS_NTDS                     = 32;


//static const int NS_EMAIL                    = 37;
//static const int NS_PNRPNAME                 = 38;
//static const int NS_PNRPCLOUD                = 39;


//static const int NS_X500                     = 40;
//static const int NS_NIS                      = 41;
//static const int NS_NISPLUS                  = 42;

//static const int NS_WRQ                      = 50;

//static const int NS_NETDES                   = 60;    /* Network Designers Limited */
]]



--[=[
/*
* Resolution flags for WSAGetAddressByName().
* Note these are also used by the 1.1 API GetAddressByName, so
* leave them around.
*/
#define RES_UNUSED_1                (0x00000001)
#define RES_FLUSH_CACHE             (0x00000002)
if not RES_SERVICE
#define RES_SERVICE                 (0x00000004)
end --/* RES_SERVICE */

/*
* Well known value names for Service Types
*/

#define SERVICE_TYPE_VALUE_IPXPORTA      "IpxSocket"
#define SERVICE_TYPE_VALUE_IPXPORTW     L"IpxSocket"
#define SERVICE_TYPE_VALUE_SAPIDA        "SapId"
#define SERVICE_TYPE_VALUE_SAPIDW       L"SapId"

#define SERVICE_TYPE_VALUE_TCPPORTA      "TcpPort"
#define SERVICE_TYPE_VALUE_TCPPORTW     L"TcpPort"

#define SERVICE_TYPE_VALUE_UDPPORTA      "UdpPort"
#define SERVICE_TYPE_VALUE_UDPPORTW     L"UdpPort"

#define SERVICE_TYPE_VALUE_OBJECTIDA     "ObjectId"
#define SERVICE_TYPE_VALUE_OBJECTIDW    L"ObjectId"
--]=]

--[[
#ifdef UNICODE

#define SERVICE_TYPE_VALUE_SAPID        SERVICE_TYPE_VALUE_SAPIDW
#define SERVICE_TYPE_VALUE_TCPPORT      SERVICE_TYPE_VALUE_TCPPORTW
#define SERVICE_TYPE_VALUE_UDPPORT      SERVICE_TYPE_VALUE_UDPPORTW
#define SERVICE_TYPE_VALUE_OBJECTID     SERVICE_TYPE_VALUE_OBJECTIDW

#else /* not UNICODE */

#define SERVICE_TYPE_VALUE_SAPID        SERVICE_TYPE_VALUE_SAPIDA
#define SERVICE_TYPE_VALUE_TCPPORT      SERVICE_TYPE_VALUE_TCPPORTA
#define SERVICE_TYPE_VALUE_UDPPORT      SERVICE_TYPE_VALUE_UDPPORTA
#define SERVICE_TYPE_VALUE_OBJECTID     SERVICE_TYPE_VALUE_OBJECTIDA

end
--]]

ffi.cdef[[
/*
*  Address Family/Protocol Tuples
*/
typedef struct _AFPROTOCOLS {
   INT iAddressFamily;
   INT iProtocol;
} AFPROTOCOLS, *PAFPROTOCOLS, *LPAFPROTOCOLS;
]]

ffi.cdef[[
typedef enum _WSAEcomparator
{
   COMP_EQUAL = 0,
   COMP_NOTLESS
} WSAECOMPARATOR, *PWSAECOMPARATOR, *LPWSAECOMPARATOR;

typedef struct _WSAVersion
{
   DWORD           dwVersion;
   WSAECOMPARATOR  ecHow;
}WSAVERSION, *PWSAVERSION, *LPWSAVERSION;
]]

--[[
typedef struct _WINSOCK_DEPRECATED_BY("WSAQUERYSETW") _WSAQuerySetA
{
   DWORD           dwSize;
   LPSTR           lpszServiceInstanceName;
   LPGUID          lpServiceClassId;
   LPWSAVERSION    lpVersion;
   LPSTR           lpszComment;
   DWORD           dwNameSpace;
   LPGUID          lpNSProviderId;
   LPSTR           lpszContext;
   DWORD           dwNumberOfProtocols;
   _Field_size_(dwNumberOfProtocols) LPAFPROTOCOLS   lpafpProtocols;
   LPSTR           lpszQueryString;
   DWORD           dwNumberOfCsAddrs;
   _Field_size_(dwNumberOfCsAddrs) LPCSADDR_INFO   lpcsaBuffer;
   DWORD           dwOutputFlags;
   LPBLOB          lpBlob;
} WSAQUERYSETA, *PWSAQUERYSETA, *LPWSAQUERYSETA;
--]]

ffi.cdef[[
typedef  struct _WSAQuerySetW
{
    DWORD           dwSize;
   LPWSTR          lpszServiceInstanceName;
   LPGUID          lpServiceClassId;
   LPWSAVERSION    lpVersion;
   LPWSTR          lpszComment;
   DWORD           dwNameSpace;
   LPGUID          lpNSProviderId;
   LPWSTR          lpszContext;
   DWORD           dwNumberOfProtocols;
   LPAFPROTOCOLS   lpafpProtocols;
   LPWSTR          lpszQueryString;
   DWORD           dwNumberOfCsAddrs;
    LPCSADDR_INFO   lpcsaBuffer;
   DWORD           dwOutputFlags;
   LPBLOB          lpBlob;
} WSAQUERYSETW, *PWSAQUERYSETW, *LPWSAQUERYSETW;
]]


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
--[[
typedef struct _WINSOCK_DEPRECATED_BY("WSAQUERYSET2W") _WSAQuerySet2A
{
   DWORD           dwSize;
   LPSTR           lpszServiceInstanceName;
   LPWSAVERSION    lpVersion;
   LPSTR           lpszComment;
   DWORD           dwNameSpace;
   LPGUID          lpNSProviderId;
   LPSTR           lpszContext;
   DWORD           dwNumberOfProtocols;
   LPAFPROTOCOLS   lpafpProtocols;
   LPSTR           lpszQueryString;
   DWORD           dwNumberOfCsAddrs;
   LPCSADDR_INFO   lpcsaBuffer;
   DWORD           dwOutputFlags;
   LPBLOB          lpBlob;   
} WSAQUERYSET2A, *PWSAQUERYSET2A, *LPWSAQUERYSET2A;
--]]

ffi.cdef[[
typedef struct _WSAQuerySet2W
{
   DWORD           dwSize;
   LPWSTR          lpszServiceInstanceName;
   LPWSAVERSION    lpVersion;
   LPWSTR          lpszComment;
   DWORD           dwNameSpace;
   LPGUID          lpNSProviderId;
   LPWSTR          lpszContext;
   DWORD           dwNumberOfProtocols;
    LPAFPROTOCOLS   lpafpProtocols;
   LPWSTR          lpszQueryString;
   DWORD           dwNumberOfCsAddrs;
    LPCSADDR_INFO   lpcsaBuffer;
   DWORD           dwOutputFlags;
   LPBLOB          lpBlob;   
} WSAQUERYSET2W, *PWSAQUERYSET2W, *LPWSAQUERYSET2W;
]]

--[[
#ifdef UNICODE
typedef WSAQUERYSETW WSAQUERYSET;
typedef PWSAQUERYSETW PWSAQUERYSET;
typedef LPWSAQUERYSETW LPWSAQUERYSET;
typedef WSAQUERYSET2W WSAQUERYSET2;
typedef PWSAQUERYSET2W PWSAQUERYSET2;
typedef LPWSAQUERYSET2W LPWSAQUERYSET2;
#else
typedef WSAQUERYSETA WSAQUERYSET;
typedef PWSAQUERYSETA PWSAQUERYSET;
typedef LPWSAQUERYSETA LPWSAQUERYSET;
typedef WSAQUERYSET2A WSAQUERYSET2;
typedef PWSAQUERYSET2A PWSAQUERYSET2;
typedef LPWSAQUERYSET2A LPWSAQUERYSET2;
end --/* UNICODE */
--]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */

ffi.cdef[[
static const int LUP_DEEP                = 0x0001;
static const int LUP_CONTAINERS          = 0x0002;
static const int LUP_NOCONTAINERS        = 0x0004;
static const int LUP_NEAREST             = 0x0008;
static const int LUP_RETURN_NAME         = 0x0010;
static const int LUP_RETURN_TYPE         = 0x0020;
static const int LUP_RETURN_VERSION      = 0x0040;
static const int LUP_RETURN_COMMENT      = 0x0080;
static const int LUP_RETURN_ADDR         = 0x0100;
static const int LUP_RETURN_BLOB         = 0x0200;
static const int LUP_RETURN_ALIASES      = 0x0400;
static const int LUP_RETURN_QUERY_STRING = 0x0800;
static const int LUP_RETURN_ALL          = 0x0FF0;
static const int LUP_RES_SERVICE         = 0x8000;

static const int LUP_FLUSHCACHE          = 0x1000;
static const int LUP_FLUSHPREVIOUS       = 0x2000;

static const int LUP_NON_AUTHORITATIVE   = 0x4000;
static const int LUP_SECURE              = 0x8000;
static const int LUP_RETURN_PREFERRED_NAMES  = 0x10000;
static const int LUP_DNS_ONLY            = 0x20000;

static const int LUP_ADDRCONFIG          = 0x00100000;
static const int LUP_DUAL_ADDR           = 0x00200000;
static const int LUP_FILESERVER          = 0x00400000;
static const int LUP_DISABLE_IDN_ENCODING    = 0x00800000;
static const int LUP_API_ANSI            = 0x01000000;

static const int LUP_RESOLUTION_HANDLE   = 0x80000000;
]]


ffi.cdef[[
static const int  RESULT_IS_ALIAS      = 0x0001;
]]

if (_WIN32_WINNT >= 0x0501) then
ffi.cdef[[
static const int  RESULT_IS_ADDED      = 0x0010;
static const int  RESULT_IS_CHANGED    = 0x0020;
static const int  RESULT_IS_DELETED    = 0x0040;
]]
end --(_WIN32_WINNT >= 0x0501)

ffi.cdef[[
/*
* Service Address Registration and Deregistration Data Types.
*/

typedef enum _WSAESETSERVICEOP
{
   RNRSERVICE_REGISTER=0,
   RNRSERVICE_DEREGISTER,
   RNRSERVICE_DELETE
} WSAESETSERVICEOP, *PWSAESETSERVICEOP, *LPWSAESETSERVICEOP;
]]


--[=[
if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP, WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
typedef struct _WINSOCK_DEPRECATED_BY("WSANSCLASSINFOW") _WSANSClassInfoA
{
   LPSTR   lpszName;
   DWORD   dwNameSpace;
   DWORD   dwValueType;
   DWORD   dwValueSize;
   LPVOID  lpValue;
}WSANSCLASSINFOA, *PWSANSCLASSINFOA, *LPWSANSCLASSINFOA;
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
--]=]

ffi.cdef[[
typedef struct _WSANSClassInfoW
{
   LPWSTR  lpszName;
   DWORD   dwNameSpace;
   DWORD   dwValueType;
   DWORD   dwValueSize;
   LPVOID  lpValue;
}WSANSCLASSINFOW, *PWSANSCLASSINFOW, *LPWSANSCLASSINFOW;
]]

--[[
#ifdef UNICODE
typedef WSANSCLASSINFOW WSANSCLASSINFO;
typedef PWSANSCLASSINFOW PWSANSCLASSINFO;
typedef LPWSANSCLASSINFOW LPWSANSCLASSINFO;
#else
#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)
typedef WSANSCLASSINFOA WSANSCLASSINFO;
typedef PWSANSCLASSINFOA PWSANSCLASSINFO;
typedef LPWSANSCLASSINFOA LPWSANSCLASSINFO;
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */

end --/* UNICODE */
--]]

--[=[
if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
typedef struct _WINSOCK_DEPRECATED_BY("WSASERVICECLASSINFOW") _WSAServiceClassInfoA
{
   LPGUID              lpServiceClassId;
   LPSTR               lpszServiceClassName;
   DWORD               dwCount;
   LPWSANSCLASSINFOA   lpClassInfos;
}WSASERVICECLASSINFOA, *PWSASERVICECLASSINFOA, *LPWSASERVICECLASSINFOA;
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
--]=]

ffi.cdef[[
typedef struct _WSAServiceClassInfoW
{
   LPGUID              lpServiceClassId;
   LPWSTR              lpszServiceClassName;
   DWORD               dwCount;
   LPWSANSCLASSINFOW   lpClassInfos;
}WSASERVICECLASSINFOW, *PWSASERVICECLASSINFOW, *LPWSASERVICECLASSINFOW;
]]

--[[
#ifdef UNICODE
typedef WSASERVICECLASSINFOW WSASERVICECLASSINFO;
typedef PWSASERVICECLASSINFOW PWSASERVICECLASSINFO;
typedef LPWSASERVICECLASSINFOW LPWSASERVICECLASSINFO;
#else
#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)
typedef WSASERVICECLASSINFOA WSASERVICECLASSINFO;
typedef PWSASERVICECLASSINFOA PWSASERVICECLASSINFO;
typedef LPWSASERVICECLASSINFOA LPWSASERVICECLASSINFO;
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */

end --/* UNICODE */
--]]

--[[
typedef struct _WINSOCK_DEPRECATED_BY("WSANAMESPACE_INFOW") _WSANAMESPACE_INFOA {
   GUID                NSProviderId;
   DWORD               dwNameSpace;
   BOOL                fActive;
   DWORD               dwVersion;
   LPSTR               lpszIdentifier;
} WSANAMESPACE_INFOA, *PWSANAMESPACE_INFOA, *LPWSANAMESPACE_INFOA;
--]]

ffi.cdef[[
typedef struct _WSANAMESPACE_INFOW {
   GUID                NSProviderId;
   DWORD               dwNameSpace;
   BOOL                fActive;
   DWORD               dwVersion;
   LPWSTR              lpszIdentifier;
} WSANAMESPACE_INFOW, *PWSANAMESPACE_INFOW, *LPWSANAMESPACE_INFOW;
]]

--[[
typedef struct _WINSOCK_DEPRECATED_BY("WSANAMESPACE_INFOEXW") _WSANAMESPACE_INFOEXA {
   GUID                NSProviderId;
   DWORD               dwNameSpace;
   BOOL                fActive;
   DWORD               dwVersion;
   LPSTR               lpszIdentifier;
   BLOB                ProviderSpecific;
} WSANAMESPACE_INFOEXA, *PWSANAMESPACE_INFOEXA, *LPWSANAMESPACE_INFOEXA;
--]]

ffi.cdef[[
typedef struct _WSANAMESPACE_INFOEXW {
   GUID                NSProviderId;
   DWORD               dwNameSpace;
   BOOL                fActive;
   DWORD               dwVersion;
   LPWSTR              lpszIdentifier;
   BLOB                ProviderSpecific;
} WSANAMESPACE_INFOEXW, *PWSANAMESPACE_INFOEXW, *LPWSANAMESPACE_INFOEXW;
]]

--[[
#ifdef UNICODE
typedef WSANAMESPACE_INFOW WSANAMESPACE_INFO;
typedef PWSANAMESPACE_INFOW PWSANAMESPACE_INFO;
typedef LPWSANAMESPACE_INFOW LPWSANAMESPACE_INFO;
typedef WSANAMESPACE_INFOEXW WSANAMESPACE_INFOEX;
typedef PWSANAMESPACE_INFOEXW PWSANAMESPACE_INFOEX;
typedef LPWSANAMESPACE_INFOEXW LPWSANAMESPACE_INFOEX;
#else
typedef WSANAMESPACE_INFOA WSANAMESPACE_INFO;
typedef PWSANAMESPACE_INFOA PWSANAMESPACE_INFO;
typedef LPWSANAMESPACE_INFOA LPWSANAMESPACE_INFO;
typedef WSANAMESPACE_INFOEXA WSANAMESPACE_INFOEX;
typedef PWSANAMESPACE_INFOEXA PWSANAMESPACE_INFOEX;
typedef LPWSANAMESPACE_INFOEXA LPWSANAMESPACE_INFOEX;
end --/* UNICODE */
--]]

if (_WIN32_WINNT >= 0x0600) then
ffi.cdef[[
/* Event flag definitions for WSAPoll(). */

static const int POLLRDNORM = 0x0100;
static const int POLLRDBAND = 0x0200;
static const int POLLIN     = (POLLRDNORM | POLLRDBAND);
static const int POLLPRI    = 0x0400;

static const int POLLWRNORM = 0x0010;
static const int POLLOUT    = (POLLWRNORM);
static const int POLLWRBAND = 0x0020;

static const int POLLERR    = 0x0001;
static const int POLLHUP    = 0x0002;
static const int POLLNVAL   = 0x0004;

typedef struct pollfd {

   SOCKET  fd;
   SHORT   events;
   SHORT   revents;

} WSAPOLLFD, *PWSAPOLLFD,  *LPWSAPOLLFD;
]]
end -- (_WIN32_WINNT >= 0x0600)




if INCL_WINSOCK_API_PROTOTYPES then

ffi.cdef[[
SOCKET
__stdcall
accept(
    SOCKET s,
    struct sockaddr  * addr,
    int  * addrlen
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
    typedef

SOCKET
(__stdcall * LPFN_ACCEPT)(
    SOCKET s,
    struct sockaddr  * addr,
    int  * addrlen
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
int
__stdcall
bind(
    SOCKET s,
    const struct sockaddr  * name,
    int namelen
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
int
(__stdcall * LPFN_BIND)(
    SOCKET s,
    const struct sockaddr  * name,
    int namelen
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
int
__stdcall
closesocket(
    SOCKET s
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
    typedef
int
(__stdcall * LPFN_CLOSESOCKET)(
    SOCKET s
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
int
__stdcall
connect(
    SOCKET s,
    const struct sockaddr  * name,
    int namelen
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
int
(__stdcall * LPFN_CONNECT)(
    SOCKET s,
    const struct sockaddr  * name,
    int namelen
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
int
__stdcall
ioctlsocket(
    SOCKET s,
    long cmd,
   u_long  * argp
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
int
(__stdcall * LPFN_IOCTLSOCKET)(
    SOCKET s,
    long cmd,
    u_long  * argp
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
int
__stdcall
getpeername(
    SOCKET s,
   struct sockaddr  * name,
    int  * namelen
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
int
(__stdcall * LPFN_GETPEERNAME)(
    SOCKET s,
    struct sockaddr  * name,
    int  * namelen
   );]]

end --/* INCL_WINSOCK_API_TYPEDEFS */


if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
int
__stdcall
getsockname(
    SOCKET s,
    struct sockaddr  * name,
    int  * namelen
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
int
(__stdcall * LPFN_GETSOCKNAME)(
    SOCKET s,
    struct sockaddr  * name,
    int  * namelen
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
int
__stdcall
getsockopt(
    SOCKET s,
    int level,
    int optname,
    char  * optval,
    int  * optlen
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
int
(__stdcall * LPFN_GETSOCKOPT)(
    SOCKET s,
    int level,
    int optname,
    char  * optval,
    int  * optlen
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
u_long
__stdcall
htonl(
    u_long hostlong
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
u_long
(__stdcall * LPFN_HTONL)(
    u_long hostlong
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
u_short
__stdcall
htons(
    u_short hostshort
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
u_short
(__stdcall * LPFN_HTONS)(
    u_short hostshort
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
--_WINSOCK_DEPRECATED_BY("inet_pton() or InetPton()")
ffi.cdef[[
unsigned long
__stdcall
inet_addr(
    const char  * cp
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
unsigned long
(__stdcall * LPFN_INET_ADDR)(
    const char  * cp
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
--_WINSOCK_DEPRECATED_BY("inet_ntop() or InetNtop()")
ffi.cdef[[
char  *
__stdcall
inet_ntoa(
    struct in_addr in
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
char  *
(__stdcall * LPFN_INET_NTOA)(
    struct in_addr in
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

--[=[
#if !defined(NO_EXTRA_HTON_FUNCTIONS) && !defined(__midl) && (defined(INCL_EXTRA_HTON_FUNCTIONS) || NTDDI_VERSION>=NTDDI_WIN8)
/*
* Byte order conversion functions for 64-bit integers and 32 + 64 bit 
* floating-point numbers.  IEEE big-endian format is used for the
* network floating point format.
*/
#define _WS2_32_WINSOCK_SWAP_LONG(l)                \
           ( ( ((l) >> 24) & 0x000000FFL ) |       \
             ( ((l) >>  8) & 0x0000FF00L ) |       \
             ( ((l) <<  8) & 0x00FF0000L ) |       \
             ( ((l) << 24) & 0xFF000000L ) )

#define _WS2_32_WINSOCK_SWAP_LONGLONG(l)            \
           ( ( ((l) >> 56) & 0x00000000000000FFLL ) |       \
             ( ((l) >> 40) & 0x000000000000FF00LL ) |       \
             ( ((l) >> 24) & 0x0000000000FF0000LL ) |       \
             ( ((l) >>  8) & 0x00000000FF000000LL ) |       \
             ( ((l) <<  8) & 0x000000FF00000000LL ) |       \
             ( ((l) << 24) & 0x0000FF0000000000LL ) |       \
             ( ((l) << 40) & 0x00FF000000000000LL ) |       \
             ( ((l) << 56) & 0xFF00000000000000LL ) )


if not htonll
__inline unsigned __int64 htonll ( unsigned __int64 Value ) 
{ 
   const unsigned __int64 Retval = _WS2_32_WINSOCK_SWAP_LONGLONG (Value);
   return Retval;
}
end --/* htonll */

if not ntohll
__inline unsigned __int64 ntohll ( unsigned __int64 Value ) 
{ 
   const unsigned __int64 Retval = _WS2_32_WINSOCK_SWAP_LONGLONG (Value);
   return Retval;
}
end --/* ntohll */

if not htonf
__inline unsigned __int32 htonf ( float Value ) 
{ 
   unsigned __int32 Tempval;
   unsigned __int32 Retval;
   Tempval = *(unsigned __int32*)(&Value);
   Retval = _WS2_32_WINSOCK_SWAP_LONG (Tempval);
   return Retval;
}
end --/* htonf */

if not ntohf
__inline float ntohf ( unsigned __int32 Value ) 
{ 
   const unsigned __int32 Tempval = _WS2_32_WINSOCK_SWAP_LONG (Value);
   float Retval;
   *((unsigned __int32*)&Retval) = Tempval;
   return Retval;
}
end --/* ntohf */

if not htond
__inline unsigned __int64 htond ( double Value ) 
{ 
   unsigned __int64 Tempval;
   unsigned __int64 Retval;
   Tempval = *(unsigned __int64*)(&Value);
   Retval = _WS2_32_WINSOCK_SWAP_LONGLONG (Tempval);
   return Retval;
}
end --/* htond */

if not ntohd
__inline double ntohd ( unsigned __int64 Value ) 
{ 
   const unsigned __int64 Tempval = _WS2_32_WINSOCK_SWAP_LONGLONG (Value);
   double Retval;
   *((unsigned __int64*)&Retval) = Tempval;
   return Retval;
}
end --/* ntohd */
end --/* NO_EXTRA_HTON_FUNCTIONS */
--]=]

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
int
__stdcall
listen(
    SOCKET s,
    int backlog
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
int
(__stdcall * LPFN_LISTEN)(
    SOCKET s,
    int backlog
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
u_long
__stdcall
ntohl(
    u_long netlong
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
u_long
(__stdcall * LPFN_NTOHL)(
    u_long netlong
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
u_short
__stdcall
ntohs(
    u_short netshort
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
u_short
(__stdcall * LPFN_NTOHS)(
    u_short netshort
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
int
__stdcall
recv(
    SOCKET s,
    char  * buf,
    int len,
    int flags
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
int
(__stdcall * LPFN_RECV)(
    SOCKET s,
    char  * buf,
    int len,
    int flags
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
int
__stdcall
recvfrom(
    SOCKET s,
    char  * buf,
    int len,
    int flags,
    struct sockaddr  * from,
    int  * fromlen
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
int
(__stdcall * LPFN_RECVFROM)(
    SOCKET s,
    char  * buf,
    int len,
    int flags,
    struct sockaddr  * from,
    int  * fromlen
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
int
__stdcall
select(
    int nfds,
    fd_set  * readfds,
    fd_set  * writefds,
    fd_set  * exceptfds,
    const struct timeval  * timeout
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
int
(__stdcall * LPFN_SELECT)(
    int nfds,
    fd_set  * readfds,
    fd_set  * writefds,
    fd_set  *exceptfds,
    const struct timeval  * timeout
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
int
__stdcall
send(
    SOCKET s,
    const char  * buf,
    int len,
    int flags
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
int
(__stdcall * LPFN_SEND)(
    SOCKET s,
    const char  * buf,
    int len,
    int flags
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
int
__stdcall
sendto(
    SOCKET s,
    const char  * buf,
    int len,
    int flags,
    const struct sockaddr  * to,
    int tolen
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

--[=[
if INCL_WINSOCK_API_TYPEDEFS then
typedef
int
(__stdcall * LPFN_SENDTO)(
    SOCKET s,
    const char  * buf,
    int len,
    int flags,
   _In_reads_bytes_(tolen) const struct sockaddr  * to,
    int tolen
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then

int
__stdcall
setsockopt(
    SOCKET s,
    int level,
    int optname,
   _In_reads_bytes_opt_(optlen) const char  * optval,
    int optlen
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
int
(__stdcall * LPFN_SETSOCKOPT)(
    SOCKET s,
    int level,
    int optname,
   _In_reads_bytes_(optlen) const char  * optval,
    int optlen
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then

int
__stdcall
shutdown(
    SOCKET s,
    int how
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
int
(__stdcall * LPFN_SHUTDOWN)(
    SOCKET s,
    int how
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then


SOCKET
__stdcall
socket(
    int af,
    int type,
    int protocol
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef

SOCKET
(__stdcall * LPFN_SOCKET)(
    int af,
    int type,
    int protocol
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

/* Database function prototypes */

if INCL_WINSOCK_API_PROTOTYPES then
_WINSOCK_DEPRECATED_BY("getnameinfo() or GetNameInfoW()")

struct hostent  *
__stdcall
gethostbyaddr(
    const char  * addr,
    int len,
    int type
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
struct hostent  *
(__stdcall * LPFN_GETHOSTBYADDR)(
    const char  * addr,
    int len,
    int type
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
_WINSOCK_DEPRECATED_BY("getaddrinfo() or GetAddrInfoW()")

struct hostent  *
__stdcall
gethostbyname(
    const char  * name
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
struct hostent  *
(__stdcall * LPFN_GETHOSTBYNAME)(
    const char  * name
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then

int
__stdcall
gethostname(
   _Out_writes_bytes_(namelen) char  * name,
    int namelen
   );

end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
int
(__stdcall * LPFN_GETHOSTNAME)(
   _Out_writes_bytes_(namelen) char  * name,
    int namelen
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then

int
__stdcall
GetHostNameW(
   _Out_writes_(namelen) PWSTR name,
    int namelen
   );

end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
int
(__stdcall * LPFN_GETHOSTNAMEW)(
   _Out_writes_(namelen) PWSTR name,
    int namelen
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then

struct servent  *
__stdcall
getservbyport(
    int port,
   z_ const char  * proto
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
struct servent  *
(__stdcall * LPFN_GETSERVBYPORT)(
    int port,
   z_ const char  * proto
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then

struct servent  *
__stdcall
getservbyname(
    const char  * name,
   z_ const char  * proto
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
struct servent  *
(__stdcall * LPFN_GETSERVBYNAME)(
    const char  * name,
   z_ const char  * proto
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then

struct protoent  *
__stdcall
getprotobynumber(
    int number
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
struct protoent  *
(__stdcall * LPFN_GETPROTOBYNUMBER)(
    int number
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then

struct protoent  *
__stdcall
getprotobyname(
    const char  * name
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
struct protoent  *
(__stdcall * LPFN_GETPROTOBYNAME)(
    const char  * name
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

/* Microsoft Windows Extension function prototypes */

if INCL_WINSOCK_API_PROTOTYPES then


int
__stdcall
WSAStartup(
    WORD wVersionRequested,
    LPWSADATA lpWSAData
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef

int
(__stdcall * LPFN_WSASTARTUP)(
    WORD wVersionRequested,
    LPWSADATA lpWSAData
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then

int
__stdcall
WSACleanup(
   void
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
int
(__stdcall * LPFN_WSACLEANUP)(
   void
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then

void
__stdcall
WSASetLastError(
    int iError
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
void
(__stdcall * LPFN_WSASETLASTERROR)(
   int iError
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then

int
__stdcall
WSAGetLastError(
   void
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
int
(__stdcall * LPFN_WSAGETLASTERROR)(
   void
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

if INCL_WINSOCK_API_PROTOTYPES then
_WINSOCK_DEPRECATED_BY("Winsock 2")

BOOL
__stdcall
WSAIsBlocking(
   void
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
BOOL
(__stdcall * LPFN_WSAISBLOCKING)(
   void
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
_WINSOCK_DEPRECATED_BY("Winsock 2")

int
__stdcall
WSAUnhookBlockingHook(
   void
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
int
(__stdcall * LPFN_WSAUNHOOKBLOCKINGHOOK)(
   void
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
_WINSOCK_DEPRECATED_BY("Winsock 2")

FARPROC
__stdcall
WSASetBlockingHook(
    FARPROC lpBlockFunc
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
FARPROC
(__stdcall * LPFN_WSASETBLOCKINGHOOK)(
    FARPROC lpBlockFunc
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
_WINSOCK_DEPRECATED_BY("Winsock 2")

int
__stdcall
WSACancelBlockingCall(
   void
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
int
(__stdcall * LPFN_WSACANCELBLOCKINGCALL)(
   void
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
_WINSOCK_DEPRECATED_BY("getservbyname()")

HANDLE
__stdcall
WSAAsyncGetServByName(
    HWND hWnd,
    u_int wMsg,
    const char  * name,
    const char  * proto,
   _Out_writes_bytes_(buflen) char  * buf,
    int buflen
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
HANDLE
(__stdcall * LPFN_WSAASYNCGETSERVBYNAME)(
    HWND hWnd,
    u_int wMsg,
    const char  * name,
    const char  * proto,
   _Out_writes_bytes_(buflen) char  * buf,
    int buflen
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
_WINSOCK_DEPRECATED_BY("getservbyport()")

HANDLE
__stdcall
WSAAsyncGetServByPort(
    HWND hWnd,
    u_int wMsg,
    int port,
    const char  * proto,
   _Out_writes_bytes_(buflen) char  * buf,
    int buflen
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
HANDLE
(__stdcall * LPFN_WSAASYNCGETSERVBYPORT)(
    HWND hWnd,
    u_int wMsg,
    int port,
    const char  * proto,
   _Out_writes_bytes_(buflen) char  * buf,
    int buflen
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
_WINSOCK_DEPRECATED_BY("getprotobyname()")

HANDLE
__stdcall
WSAAsyncGetProtoByName(
    HWND hWnd,
    u_int wMsg,
    const char  * name,
   _Out_writes_bytes_(buflen) char  * buf,
    int buflen
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
HANDLE
(__stdcall * LPFN_WSAASYNCGETPROTOBYNAME)(
    HWND hWnd,
    u_int wMsg,
    const char  * name,
   _Out_writes_bytes_(buflen) char  * buf,
    int buflen
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
_WINSOCK_DEPRECATED_BY("getprotobynumber()")

HANDLE
__stdcall
WSAAsyncGetProtoByNumber(
    HWND hWnd,
    u_int wMsg,
    int number,
   _Out_writes_bytes_(buflen) char  * buf,
    int buflen
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
HANDLE
(__stdcall * LPFN_WSAASYNCGETPROTOBYNUMBER)(
    HWND hWnd,
    u_int wMsg,
    int number,
   _Out_writes_bytes_(buflen) char  * buf,
    int buflen
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
_WINSOCK_DEPRECATED_BY("GetAddrInfoExW()")

HANDLE
__stdcall
WSAAsyncGetHostByName(
    HWND hWnd,
    u_int wMsg,
    const char  * name,
   _Out_writes_bytes_(buflen) char  * buf,
    int buflen
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
HANDLE
(__stdcall * LPFN_WSAASYNCGETHOSTBYNAME)(
    HWND hWnd,
    u_int wMsg,
    const char  * name,
   _Out_writes_bytes_(buflen) char  * buf,
    int buflen
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
_WINSOCK_DEPRECATED_BY("getnameinfo() or GetNameInfoW()")

HANDLE
__stdcall
WSAAsyncGetHostByAddr(
    HWND hWnd,
    u_int wMsg,
    const char  * addr,
    int len,
    int type,
   _Out_writes_bytes_(buflen) char  * buf,
    int buflen
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
HANDLE
(__stdcall * LPFN_WSAASYNCGETHOSTBYADDR)(
    HWND hWnd,
    u_int wMsg,
    const char  * addr,
    int len,
    int type,
   _Out_writes_bytes_(buflen) char  * buf,
    int buflen
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
_WINSOCK_DEPRECATED

int
__stdcall
WSACancelAsyncRequest(
    HANDLE hAsyncTaskHandle
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
int
(__stdcall * LPFN_WSACANCELASYNCREQUEST)(
    HANDLE hAsyncTaskHandle
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
_WINSOCK_DEPRECATED_BY("WSAEventSelect()")

int
__stdcall
WSAAsyncSelect(
    SOCKET s,
    HWND hWnd,
    u_int wMsg,
    long lEvent
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
int
(__stdcall * LPFN_WSAASYNCSELECT)(
    SOCKET s,
    HWND hWnd,
    u_int wMsg,
    long lEvent
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
--]=]


if INCL_WINSOCK_API_PROTOTYPES then

ffi.cdef[[
SOCKET
__stdcall
WSAAccept(
    SOCKET s,
    struct sockaddr  * addr,
    LPINT addrlen,
    LPCONDITIONPROC lpfnCondition,
    DWORD_PTR dwCallbackData
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef

SOCKET
(__stdcall * LPFN_WSAACCEPT)(
    SOCKET s,
    struct sockaddr  * addr,
    LPINT addrlen,
    LPCONDITIONPROC lpfnCondition,
    DWORD_PTR dwCallbackData
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
BOOL
__stdcall
WSACloseEvent(
    WSAEVENT hEvent
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
BOOL
(__stdcall * LPFN_WSACLOSEEVENT)(
    WSAEVENT hEvent
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
int
__stdcall
WSAConnect(
    SOCKET s,
    const struct sockaddr  * name,
    int namelen,
    LPWSABUF lpCallerData,
    LPWSABUF lpCalleeData,
    LPQOS lpSQOS,
    LPQOS lpGQOS
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_PROTOTYPES then
--[[
#ifdef UNICODE
#define WSAConnectByName    WSAConnectByNameW
#else
#define WSAConnectByName    WSAConnectByNameA
end
--]]

ffi.cdef[[
BOOL
__stdcall
WSAConnectByNameW(
    SOCKET s,
    LPWSTR nodename,
    LPWSTR servicename,
    LPDWORD LocalAddressLength,
    LPSOCKADDR LocalAddress,
    LPDWORD RemoteAddressLength,
    LPSOCKADDR RemoteAddress,
    const struct timeval * timeout,
    LPWSAOVERLAPPED Reserved);
]]

--[[
_WINSOCK_DEPRECATED_BY("WSAConnectByNameW()")
BOOL
__stdcall
WSAConnectByNameA(
    SOCKET s,
    LPCSTR nodename,
    LPCSTR servicename,
    LPDWORD LocalAddressLength,
    LPSOCKADDR LocalAddress,
    LPDWORD RemoteAddressLength,
    LPSOCKADDR RemoteAddress,
    const struct timeval * timeout,
    LPWSAOVERLAPPED Reserved);
--]]

ffi.cdef[[
BOOL
__stdcall
WSAConnectByList(
    SOCKET s,
    PSOCKET_ADDRESS_LIST SocketAddress,
    LPDWORD LocalAddressLength,
    LPSOCKADDR LocalAddress,
    LPDWORD RemoteAddressLength,
    LPSOCKADDR RemoteAddress,
    const struct timeval * timeout,
    LPWSAOVERLAPPED Reserved);
]]
end

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
int
(__stdcall * LPFN_WSACONNECT)(
    SOCKET s,
    const struct sockaddr  * name,
    int namelen,
    LPWSABUF lpCallerData,
    LPWSABUF lpCalleeData,
    LPQOS lpSQOS,
    LPQOS lpGQOS
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
WSAEVENT
__stdcall
WSACreateEvent(
   void
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
WSAEVENT
(__stdcall * LPFN_WSACREATEEVENT)(
   void
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
--[[
_WINSOCK_DEPRECATED_BY("WSADuplicateSocketW()")

int
__stdcall
WSADuplicateSocketA(
    SOCKET s,
    DWORD dwProcessId,
    LPWSAPROTOCOL_INFOA lpProtocolInfo
   );
]]

ffi.cdef[[
int
__stdcall
WSADuplicateSocketW(
    SOCKET s,
    DWORD dwProcessId,
    LPWSAPROTOCOL_INFOW lpProtocolInfo
   );
]]

--[[
#ifdef UNICODE
#define WSADuplicateSocket  WSADuplicateSocketW
#else
#define WSADuplicateSocket  WSADuplicateSocketA
end --/* !UNICODE */
--]]

end --/* INCL_WINSOCK_API_PROTOTYPES */

--[=[
if INCL_WINSOCK_API_TYPEDEFS then
typedef
int
(__stdcall * LPFN_WSADUPLICATESOCKETA)(
    SOCKET s,
    DWORD dwProcessId,
    LPWSAPROTOCOL_INFOA lpProtocolInfo
   );

typedef
int
(__stdcall * LPFN_WSADUPLICATESOCKETW)(
    SOCKET s,
    DWORD dwProcessId,
    LPWSAPROTOCOL_INFOW lpProtocolInfo
   );

--[[
#ifdef UNICODE
#define LPFN_WSADUPLICATESOCKET  LPFN_WSADUPLICATESOCKETW
#else
#define LPFN_WSADUPLICATESOCKET  LPFN_WSADUPLICATESOCKETA
end --/* !UNICODE */
--]]

end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then

int
__stdcall
WSAEnumNetworkEvents(
    SOCKET s,
    WSAEVENT hEventObject,
    LPWSANETWORKEVENTS lpNetworkEvents
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
int
(__stdcall * LPFN_WSAENUMNETWORKEVENTS)(
    SOCKET s,
    WSAEVENT hEventObject,
    LPWSANETWORKEVENTS lpNetworkEvents
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
_WINSOCK_DEPRECATED_BY("WSAEnumProtocolsW()")

int
__stdcall
WSAEnumProtocolsA(
    LPINT lpiProtocols,
   _Out_writes_bytes_to_opt_(*lpdwBufferLength,*lpdwBufferLength) LPWSAPROTOCOL_INFOA lpProtocolBuffer,
    LPDWORD lpdwBufferLength
   );


int
__stdcall
WSAEnumProtocolsW(
    LPINT lpiProtocols,
   _Out_writes_bytes_to_opt_(*lpdwBufferLength,*lpdwBufferLength) LPWSAPROTOCOL_INFOW lpProtocolBuffer,
    LPDWORD lpdwBufferLength
   );
#ifdef UNICODE
#define WSAEnumProtocols  WSAEnumProtocolsW
#else
#define WSAEnumProtocols  WSAEnumProtocolsA
end --/* !UNICODE */
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
int
(__stdcall * LPFN_WSAENUMPROTOCOLSA)(
    LPINT lpiProtocols,
   _Out_writes_bytes_to_opt_(*lpdwBufferLength,*lpdwBufferLength) LPWSAPROTOCOL_INFOA lpProtocolBuffer,
    LPDWORD lpdwBufferLength
   );

typedef
int
(__stdcall * LPFN_WSAENUMPROTOCOLSW)(
    LPINT lpiProtocols,
   _Out_writes_bytes_to_opt_(*lpdwBufferLength,*lpdwBufferLength) LPWSAPROTOCOL_INFOW lpProtocolBuffer,
    LPDWORD lpdwBufferLength
   );
#ifdef UNICODE
#define LPFN_WSAENUMPROTOCOLS  LPFN_WSAENUMPROTOCOLSW
#else
#define LPFN_WSAENUMPROTOCOLS  LPFN_WSAENUMPROTOCOLSA
end --/* !UNICODE */
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then

int
__stdcall
WSAEventSelect(
    SOCKET s,
    WSAEVENT hEventObject,
    long lNetworkEvents
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
int
(__stdcall * LPFN_WSAEVENTSELECT)(
    SOCKET s,
    WSAEVENT hEventObject,
    long lNetworkEvents
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then

BOOL
__stdcall
WSAGetOverlappedResult(
    SOCKET s,
    LPWSAOVERLAPPED lpOverlapped,
    LPDWORD lpcbTransfer,
    BOOL fWait,
    LPDWORD lpdwFlags
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
BOOL
(__stdcall * LPFN_WSAGETOVERLAPPEDRESULT)(
    SOCKET s,
    LPWSAOVERLAPPED lpOverlapped,
    LPDWORD lpcbTransfer,
    BOOL fWait,
    LPDWORD lpdwFlags
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

if INCL_WINSOCK_API_PROTOTYPES then
_WINSOCK_DEPRECATED

BOOL
__stdcall
WSAGetQOSByName(
    SOCKET s,
    LPWSABUF lpQOSName,
    LPQOS lpQOS
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
BOOL
(__stdcall * LPFN_WSAGETQOSBYNAME)(
    SOCKET s,
    LPWSABUF lpQOSName,
    LPQOS lpQOS
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


if INCL_WINSOCK_API_PROTOTYPES then

int
__stdcall
WSAHtonl(
     SOCKET s,
     u_long hostlong,
     u_long  * lpnetlong
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
int
(__stdcall * LPFN_WSAHTONL)(
    SOCKET s,
    u_long hostlong,
    u_long  * lpnetlong
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then

int
__stdcall
WSAHtons(
     SOCKET s,
     u_short hostshort,
     u_short  * lpnetshort
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
int
(__stdcall * LPFN_WSAHTONS)(
    SOCKET s,
    u_short hostshort,
    u_short  * lpnetshort
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then

int
__stdcall
WSAIoctl(
    SOCKET s,
    DWORD dwIoControlCode,
    LPVOID lpvInBuffer,
    DWORD cbInBuffer,
    LPVOID lpvOutBuffer,
    DWORD cbOutBuffer,
    LPDWORD lpcbBytesReturned,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
int
(__stdcall * LPFN_WSAIOCTL)(
    SOCKET s,
    DWORD dwIoControlCode,
    LPVOID lpvInBuffer,
    DWORD cbInBuffer,
    LPVOID lpvOutBuffer,
    DWORD cbOutBuffer,
    LPDWORD lpcbBytesReturned,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then

SOCKET
__stdcall
WSAJoinLeaf(
    SOCKET s,
    const struct sockaddr  * name,
    int namelen,
    LPWSABUF lpCallerData,
    LPWSABUF lpCalleeData,
    LPQOS lpSQOS,
    LPQOS lpGQOS,
    DWORD dwFlags
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
SOCKET
(__stdcall * LPFN_WSAJOINLEAF)(
    SOCKET s,
    const struct sockaddr  * name,
    int namelen,
    LPWSABUF lpCallerData,
    LPWSABUF lpCalleeData,
    LPQOS lpSQOS,
    LPQOS lpGQOS,
    DWORD dwFlags
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */
--]=]

--[[
if INCL_WINSOCK_API_PROTOTYPES then

int
__stdcall
WSANtohl(
    SOCKET s,
    u_long netlong,
    u_long  * lphostlong
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
int
(__stdcall * LPFN_WSANTOHL)(
    SOCKET s,
    u_long netlong,
    u_long  * lphostlong
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then

int
__stdcall
WSANtohs(
    SOCKET s,
    u_short netshort,
    u_short  * lphostshort
   );
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
typedef
int
(__stdcall * LPFN_WSANTOHS)(
    SOCKET s,
    u_short netshort,
    u_short  * lphostshort
   );
end --/* INCL_WINSOCK_API_TYPEDEFS */
--]]

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
int
__stdcall
WSARecv(
    SOCKET s,
     LPWSABUF lpBuffers,
    DWORD dwBufferCount,
    LPDWORD lpNumberOfBytesRecvd,
    LPDWORD lpFlags,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
int
(__stdcall * LPFN_WSARECV)(
    SOCKET s,
    LPWSABUF lpBuffers,
    DWORD dwBufferCount,
    LPDWORD lpNumberOfBytesRecvd,
    LPDWORD lpFlags,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
--[[
if INCL_WINSOCK_API_PROTOTYPES then
_WINSOCK_DEPRECATED_BY("WSARecv()")

int
__stdcall
WSARecvDisconnect(
    SOCKET s,
     LPWSABUF lpInboundDisconnectData
   );

end --/* INCL_WINSOCK_API_PROTOTYPES */
--]]

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
int
(__stdcall * LPFN_WSARECVDISCONNECT)(
    SOCKET s,
    LPWSABUF lpInboundDisconnectData
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
int
__stdcall
WSARecvFrom(
    SOCKET s,
     LPWSABUF lpBuffers,
    DWORD dwBufferCount,
    LPDWORD lpNumberOfBytesRecvd,
    LPDWORD lpFlags,
    struct sockaddr  * lpFrom,
    LPINT lpFromlen,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
int
(__stdcall * LPFN_WSARECVFROM)(
    SOCKET s,
    LPWSABUF lpBuffers,
    DWORD dwBufferCount,
    LPDWORD lpNumberOfBytesRecvd,
    LPDWORD lpFlags,
    struct sockaddr  * lpFrom,
    LPINT lpFromlen,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
BOOL
__stdcall
WSAResetEvent(
    WSAEVENT hEvent
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
BOOL
(__stdcall * LPFN_WSARESETEVENT)(
    WSAEVENT hEvent
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
int
__stdcall
WSASend(
    SOCKET s,
    LPWSABUF lpBuffers,
    DWORD dwBufferCount,
    LPDWORD lpNumberOfBytesSent,
    DWORD dwFlags,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
int
(__stdcall * LPFN_WSASEND)(
    SOCKET s,
    LPWSABUF lpBuffers,
    DWORD dwBufferCount,
    LPDWORD lpNumberOfBytesSent,
     DWORD dwFlags,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if (_WIN32_WINNT >= 0x0600) then
if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
int 
__stdcall 
WSASendMsg(
    SOCKET Handle,
    LPWSAMSG lpMsg,
    DWORD dwFlags,
    LPDWORD lpNumberOfBytesSent,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */
end -- (_WIN32_WINNT >= 0x0600)


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
--[[
if INCL_WINSOCK_API_PROTOTYPES then
_WINSOCK_DEPRECATED_BY("WSASend()")

int
__stdcall
WSASendDisconnect(
    SOCKET s,
    LPWSABUF lpOutboundDisconnectData
   );

end --/* INCL_WINSOCK_API_PROTOTYPES */
--]]

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
int
(__stdcall * LPFN_WSASENDDISCONNECT)(
    SOCKET s,
    LPWSABUF lpOutboundDisconnectData
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
int
__stdcall
WSASendTo(
    SOCKET s,
    LPWSABUF lpBuffers,
    DWORD dwBufferCount,
    LPDWORD lpNumberOfBytesSent,
    DWORD dwFlags,
    const struct sockaddr  * lpTo,
    int iTolen,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
int
(__stdcall * LPFN_WSASENDTO)(
    SOCKET s,
    LPWSABUF lpBuffers,
    DWORD dwBufferCount,
    LPDWORD lpNumberOfBytesSent,
    DWORD dwFlags,
    const struct sockaddr  * lpTo,
    int iTolen,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
BOOL
__stdcall
WSASetEvent(
    WSAEVENT hEvent
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
BOOL
(__stdcall * LPFN_WSASETEVENT)(
    WSAEVENT hEvent
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */


if INCL_WINSOCK_API_PROTOTYPES then

ffi.cdef[[
SOCKET
__stdcall
WSASocketA(
    int af,
    int type,
    int protocol,
    LPWSAPROTOCOL_INFOA lpProtocolInfo,
    GROUP g,
    DWORD dwFlags
   );

SOCKET
__stdcall
WSASocketW(
    int af,
    int type,
    int protocol,
    LPWSAPROTOCOL_INFOW lpProtocolInfo,
    GROUP g,
    DWORD dwFlags
   );
]]

--[[
#ifdef UNICODE
#define WSASocket  WSASocketW
#else
#define WSASocket  WSASocketA
end --/* !UNICODE */
--]]

end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef

SOCKET
(__stdcall * LPFN_WSASOCKETA)(
    int af,
    int type,
    int protocol,
    LPWSAPROTOCOL_INFOA lpProtocolInfo,
    GROUP g,
    DWORD dwFlags
   );

typedef

SOCKET
(__stdcall * LPFN_WSASOCKETW)(
    int af,
    int type,
    int protocol,
    LPWSAPROTOCOL_INFOW lpProtocolInfo,
    GROUP g,
    DWORD dwFlags
   );
]]

--[[
#ifdef UNICODE
#define LPFN_WSASOCKET  LPFN_WSASOCKETW
#else
#define LPFN_WSASOCKET  LPFN_WSASOCKETA
end --/* !UNICODE */
--]]

end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
DWORD
__stdcall
WSAWaitForMultipleEvents(
    DWORD cEvents,
    const WSAEVENT  * lphEvents,
    BOOL fWaitAll,
    DWORD dwTimeout,
    BOOL fAlertable
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
DWORD
(__stdcall * LPFN_WSAWAITFORMULTIPLEEVENTS)(
    DWORD cEvents,
    const WSAEVENT  * lphEvents,
    BOOL fWaitAll,
    DWORD dwTimeout,
    BOOL fAlertable
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
--[[
_WINSOCK_DEPRECATED_BY("WSAAddressToStringW()")

INT
__stdcall
WSAAddressToStringA(
    LPSOCKADDR lpsaAddress,
        DWORD               dwAddressLength,
    LPWSAPROTOCOL_INFOA lpProtocolInfo,
    LPSTR lpszAddressString,
     LPDWORD             lpdwAddressStringLength
   );
]]

ffi.cdef[[
INT
__stdcall
WSAAddressToStringW(
    LPSOCKADDR lpsaAddress,
        DWORD               dwAddressLength,
    LPWSAPROTOCOL_INFOW lpProtocolInfo,
    LPWSTR lpszAddressString,
     LPDWORD             lpdwAddressStringLength
   );
]]

--[[
#ifdef UNICODE
#define WSAAddressToString  WSAAddressToStringW
#else
#define WSAAddressToString  WSAAddressToStringA
end --/* !UNICODE */
--]]

end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
INT
(__stdcall * LPFN_WSAADDRESSTOSTRINGA)(
    LPSOCKADDR lpsaAddress,
        DWORD               dwAddressLength,
    LPWSAPROTOCOL_INFOA lpProtocolInfo,
    LPSTR lpszAddressString,
     LPDWORD             lpdwAddressStringLength
   );

typedef
INT
(__stdcall * LPFN_WSAADDRESSTOSTRINGW)(
    LPSOCKADDR lpsaAddress,
        DWORD               dwAddressLength,
    LPWSAPROTOCOL_INFOW lpProtocolInfo,
    LPWSTR lpszAddressString,
     LPDWORD             lpdwAddressStringLength
   );
]]

--[[
#ifdef UNICODE
#define LPFN_WSAADDRESSTOSTRING  LPFN_WSAADDRESSTOSTRINGW
#else
#define LPFN_WSAADDRESSTOSTRING  LPFN_WSAADDRESSTOSTRINGA
end --/* !UNICODE */
--]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
--[[
_WINSOCK_DEPRECATED_BY("WSAStringToAddressW()")

INT
__stdcall
WSAStringToAddressA(
       LPSTR               AddressString,
       INT                 AddressFamily,
    LPWSAPROTOCOL_INFOA lpProtocolInfo,
    LPSOCKADDR lpAddress,
    LPINT               lpAddressLength
   );
--]]

ffi.cdef[[
INT
__stdcall
WSAStringToAddressW(
       LPWSTR             AddressString,
       INT                AddressFamily,
    LPWSAPROTOCOL_INFOW lpProtocolInfo,
    LPSOCKADDR lpAddress,
    LPINT              lpAddressLength
   );
]]

--[[
#ifdef UNICODE
#define WSAStringToAddress  WSAStringToAddressW
#else
#define WSAStringToAddress  WSAStringToAddressA
end --/* !UNICODE */
--]]

end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
INT
(__stdcall * LPFN_WSASTRINGTOADDRESSA)(
       LPSTR              AddressString,
       INT                AddressFamily,
    LPWSAPROTOCOL_INFOA lpProtocolInfo,
    LPSOCKADDR lpAddress,
    LPINT              lpAddressLength
   );

typedef
INT
(__stdcall * LPFN_WSASTRINGTOADDRESSW)(
       LPWSTR             AddressString,
       INT                AddressFamily,
    LPWSAPROTOCOL_INFOW lpProtocolInfo,
    LPSOCKADDR lpAddress,
    LPINT              lpAddressLength
   );
]]

--[[
#ifdef UNICODE
#define LPFN_WSASTRINGTOADDRESS  LPFN_WSASTRINGTOADDRESSW
#else
#define LPFN_WSASTRINGTOADDRESS  LPFN_WSASTRINGTOADDRESSA
end --/* !UNICODE */
--]]
end --/* INCL_WINSOCK_API_TYPEDEFS */


--/* Registration and Name Resolution API functions */


if INCL_WINSOCK_API_PROTOTYPES then
--[[
_WINSOCK_DEPRECATED_BY("WSALookupServiceBeginW()")

INT
__stdcall
WSALookupServiceBeginA(
    LPWSAQUERYSETA lpqsRestrictions,
    DWORD          dwControlFlags,
    LPHANDLE       lphLookup
   );
--]]

ffi.cdef[[
INT
__stdcall
WSALookupServiceBeginW(
    LPWSAQUERYSETW lpqsRestrictions,
    DWORD          dwControlFlags,
    LPHANDLE       lphLookup
   );
]]

--[[
#ifdef UNICODE
#define WSALookupServiceBegin  WSALookupServiceBeginW
#else
#define WSALookupServiceBegin  WSALookupServiceBeginA
end --/* !UNICODE */
--]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
INT
(__stdcall * LPFN_WSALOOKUPSERVICEBEGINA)(
     LPWSAQUERYSETA lpqsRestrictions,
     DWORD          dwControlFlags,
    LPHANDLE       lphLookup
   );

typedef
INT
(__stdcall * LPFN_WSALOOKUPSERVICEBEGINW)(
     LPWSAQUERYSETW lpqsRestrictions,
     DWORD          dwControlFlags,
    LPHANDLE       lphLookup
   );
]]

--[[
#ifdef UNICODE
#define LPFN_WSALOOKUPSERVICEBEGIN  LPFN_WSALOOKUPSERVICEBEGINW
#else
#define LPFN_WSALOOKUPSERVICEBEGIN  LPFN_WSALOOKUPSERVICEBEGINA
end --/* !UNICODE */
--]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
--[[
_WINSOCK_DEPRECATED_BY("WSALookupServiceNextW()")

INT
__stdcall
WSALookupServiceNextA(
    HANDLE           hLookup,
    DWORD            dwControlFlags,
    LPDWORD       lpdwBufferLength,
    LPWSAQUERYSETA lpqsResults
   );
]]

ffi.cdef[[
INT
__stdcall
WSALookupServiceNextW(
    HANDLE           hLookup,
    DWORD            dwControlFlags,
    LPDWORD       lpdwBufferLength,
    LPWSAQUERYSETW lpqsResults
   );
]]

--[[
#ifdef UNICODE
#define WSALookupServiceNext  WSALookupServiceNextW
#else
#define WSALookupServiceNext  WSALookupServiceNextA
end --/* !UNICODE */
--]]

end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
INT
(__stdcall * LPFN_WSALOOKUPSERVICENEXTA)(
      HANDLE           hLookup,
      DWORD            dwControlFlags,
    LPDWORD         lpdwBufferLength,
    LPWSAQUERYSETA   lpqsResults
   );

typedef
INT
(__stdcall * LPFN_WSALOOKUPSERVICENEXTW)(
      HANDLE           hLookup,
      DWORD            dwControlFlags,
    LPDWORD         lpdwBufferLength,
   _Out_writes_bytes_to_opt_(*lpdwBufferLength,*lpdwBufferLength) LPWSAQUERYSETW   lpqsResults
   );
]]

--[[
#ifdef UNICODE
#define LPFN_WSALOOKUPSERVICENEXT  LPFN_WSALOOKUPSERVICENEXTW
#else
#define LPFN_WSALOOKUPSERVICENEXT  LPFN_WSALOOKUPSERVICENEXTA
end --/* !UNICODE */
--]]

end --/* INCL_WINSOCK_API_TYPEDEFS */

if (_WIN32_WINNT >= 0x0501) then
if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
INT
__stdcall
WSANSPIoctl(
    HANDLE           hLookup,
    DWORD            dwControlCode,
    LPVOID lpvInBuffer,
    DWORD            cbInBuffer,
    LPVOID lpvOutBuffer,
    DWORD            cbOutBuffer,
    LPDWORD        lpcbBytesReturned,
    LPWSACOMPLETION lpCompletion
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
INT
(__stdcall * LPFN_WSANSPIOCTL)(
     HANDLE           hLookup,
     DWORD            dwControlCode,
    LPVOID lpvInBuffer,
     DWORD            cbInBuffer,
    LPVOID lpvOutBuffer,
     DWORD            cbOutBuffer,
    LPDWORD        lpcbBytesReturned,
    LPWSACOMPLETION lpCompletion
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */
end --(_WIN32_WINNT >= 0x0501)

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
INT
__stdcall
WSALookupServiceEnd(
    HANDLE  hLookup
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
INT
(__stdcall * LPFN_WSALOOKUPSERVICEEND)(
    HANDLE  hLookup
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

if INCL_WINSOCK_API_PROTOTYPES then
--[[
    _WINSOCK_DEPRECATED_BY("WSAInstallServiceClassW()")

INT
__stdcall
WSAInstallServiceClassA(
     LPWSASERVICECLASSINFOA   lpServiceClassInfo
   );
--]]

ffi.cdef[[
INT
__stdcall
WSAInstallServiceClassW(
     LPWSASERVICECLASSINFOW   lpServiceClassInfo
   );
]]

--[[
#ifdef UNICODE
#define WSAInstallServiceClass  WSAInstallServiceClassW
#else
#define WSAInstallServiceClass  WSAInstallServiceClassA
end --/* !UNICODE */
--]]

end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
INT
(__stdcall * LPFN_WSAINSTALLSERVICECLASSA)(
     LPWSASERVICECLASSINFOA   lpServiceClassInfo
   );

   typedef
INT
(__stdcall * LPFN_WSAINSTALLSERVICECLASSW)(
     LPWSASERVICECLASSINFOW   lpServiceClassInfo
   );
]]

--[[
#ifdef UNICODE
#define LPFN_WSAINSTALLSERVICECLASS  LPFN_WSAINSTALLSERVICECLASSW
#else
#define LPFN_WSAINSTALLSERVICECLASS  LPFN_WSAINSTALLSERVICECLASSA
end --/* !UNICODE */
--]]
end --/* INCL_WINSOCK_API_TYPEDEFS */


if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
INT
__stdcall
WSARemoveServiceClass(
     LPGUID  lpServiceClassId
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
INT
(__stdcall * LPFN_WSAREMOVESERVICECLASS)(
     LPGUID  lpServiceClassId
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


if INCL_WINSOCK_API_PROTOTYPES then
--[[
if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

    _WINSOCK_DEPRECATED_BY("WSAGetServiceClassInfoW()")

INT
__stdcall
WSAGetServiceClassInfoA(
     LPGUID  lpProviderId,
     LPGUID  lpServiceClassId,
    LPDWORD  lpdwBufSize,
    LPWSASERVICECLASSINFOA lpServiceClassInfo
   );
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
--]]

ffi.cdef[[
INT
__stdcall
WSAGetServiceClassInfoW(
     LPGUID  lpProviderId,
     LPGUID  lpServiceClassId,
    LPDWORD  lpdwBufSize,
    LPWSASERVICECLASSINFOW lpServiceClassInfo
   );
]]

--[[
#ifdef UNICODE
#define WSAGetServiceClassInfo  WSAGetServiceClassInfoW
#else
#define WSAGetServiceClassInfo  WSAGetServiceClassInfoA
end --/* !UNICODE */
--]]

end --/* INCL_WINSOCK_API_PROTOTYPES */


if INCL_WINSOCK_API_TYPEDEFS then

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
typedef
INT
(__stdcall * LPFN_WSAGETSERVICECLASSINFOA)(
     LPGUID  lpProviderId,
     LPGUID  lpServiceClassId,
    LPDWORD  lpdwBufSize,
    LPWSASERVICECLASSINFOA lpServiceClassInfo
   );
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */

ffi.cdef[[
typedef
INT
(__stdcall * LPFN_WSAGETSERVICECLASSINFOW)(
     LPGUID  lpProviderId,
     LPGUID  lpServiceClassId,
    LPDWORD  lpdwBufSize,
    LPWSASERVICECLASSINFOW lpServiceClassInfo
   );
]]

--[[
#ifdef UNICODE
#define LPFN_WSAGETSERVICECLASSINFO  LPFN_WSAGETSERVICECLASSINFOW
#else
#define LPFN_WSAGETSERVICECLASSINFO  LPFN_WSAGETSERVICECLASSINFOA
end --/* !UNICODE */
--]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
--[[
    _WINSOCK_DEPRECATED_BY("WSAEnumNameSpaceProvidersW()")

INT
__stdcall
WSAEnumNameSpaceProvidersA(
    LPDWORD             lpdwBufferLength,
    LPWSANAMESPACE_INFOA lpnspBuffer
   );
--]]

ffi.cdef[[
INT
__stdcall
WSAEnumNameSpaceProvidersW(
    LPDWORD             lpdwBufferLength,
    LPWSANAMESPACE_INFOW lpnspBuffer
   );
]]
--[[
#ifdef UNICODE
#define WSAEnumNameSpaceProviders   WSAEnumNameSpaceProvidersW
#else
#define WSAEnumNameSpaceProviders   WSAEnumNameSpaceProvidersA
end --/* !UNICODE */
--]]

if (_WIN32_WINNT >= 0x0600 ) then
--[[
_WINSOCK_DEPRECATED_BY("WSAEnumNameSpaceProvidersW()")

INT
__stdcall
WSAEnumNameSpaceProvidersExA(
    LPDWORD             lpdwBufferLength,
    LPWSANAMESPACE_INFOEXA lpnspBuffer
   );
--]]

ffi.cdef[[
INT
__stdcall
WSAEnumNameSpaceProvidersExW(
    LPDWORD             lpdwBufferLength,
    LPWSANAMESPACE_INFOEXW lpnspBuffer
   );
]]
--[[
#ifdef UNICODE
#define WSAEnumNameSpaceProvidersEx WSAEnumNameSpaceProvidersExW
#else
#define WSAEnumNameSpaceProvidersEx WSAEnumNameSpaceProvidersExA
end --/* !UNICODE */
--]]

end --(_WIN32_WINNT >= 0x0600 )


end --/* INCL_WINSOCK_API_PROTOTYPES */
--]=]

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
INT
(__stdcall * LPFN_WSAENUMNAMESPACEPROVIDERSA)(
    LPDWORD              lpdwBufferLength,
    LPWSANAMESPACE_INFOA lpnspBuffer
   );

typedef
INT
(__stdcall * LPFN_WSAENUMNAMESPACEPROVIDERSW)(
    LPDWORD              lpdwBufferLength,
    LPWSANAMESPACE_INFOW lpnspBuffer
   );
]]

 --[[
#ifdef UNICODE
#define LPFN_WSAENUMNAMESPACEPROVIDERS  LPFN_WSAENUMNAMESPACEPROVIDERSW
#else
#define LPFN_WSAENUMNAMESPACEPROVIDERS  LPFN_WSAENUMNAMESPACEPROVIDERSA
end --/* !UNICODE */
--]]

if (_WIN32_WINNT >= 0x0600) then
ffi.cdef[[
typedef
INT
(__stdcall * LPFN_WSAENUMNAMESPACEPROVIDERSEXA)(
    LPDWORD              lpdwBufferLength,
    LPWSANAMESPACE_INFOEXA lpnspBuffer
   );

typedef
INT
(__stdcall * LPFN_WSAENUMNAMESPACEPROVIDERSEXW)(
    LPDWORD              lpdwBufferLength,
    LPWSANAMESPACE_INFOEXW lpnspBuffer
   );
]]
--[[
#ifdef UNICODE
#define LPFN_WSAENUMNAMESPACEPROVIDERSEX  LPFN_WSAENUMNAMESPACEPROVIDERSEXW
#else
#define LPFN_WSAENUMNAMESPACEPROVIDERSEX  LPFN_WSAENUMNAMESPACEPROVIDERSEXA
end --/* !UNICODE */
--]]

end --(_WIN32_WINNT >= 0x600)

end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
--[[
_WINSOCK_DEPRECATED_BY("WSAGetServiceClassNameByClassIdW()")

 INT
__stdcall
WSAGetServiceClassNameByClassIdA(
          LPGUID  lpServiceClassId,
    LPSTR lpszServiceClassName,
    LPDWORD lpdwBufferLength
   );
--]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


ffi.cdef[[
 INT
__stdcall
WSAGetServiceClassNameByClassIdW(
          LPGUID  lpServiceClassId,
    LPWSTR lpszServiceClassName,
    LPDWORD lpdwBufferLength
   );
]]

--[[
#ifdef UNICODE
#define WSAGetServiceClassNameByClassId  WSAGetServiceClassNameByClassIdW
#else
#define WSAGetServiceClassNameByClassId  WSAGetServiceClassNameByClassIdA
end --/* !UNICODE */
--]]

end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
typedef
INT
(__stdcall * LPFN_WSAGETSERVICECLASSNAMEBYCLASSIDA)(
         LPGUID  lpServiceClassId,
    LPSTR lpszServiceClassName,
    LPDWORD lpdwBufferLength
   );
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */

ffi.cdef[[
typedef
INT
(__stdcall * LPFN_WSAGETSERVICECLASSNAMEBYCLASSIDW)(
         LPGUID  lpServiceClassId,
    LPWSTR lpszServiceClassName,
    LPDWORD lpdwBufferLength
   );
]]

--[[
#ifdef UNICODE
#define LPFN_WSAGETSERVICECLASSNAMEBYCLASSID  LPFN_WSAGETSERVICECLASSNAMEBYCLASSIDW
#else
#define LPFN_WSAGETSERVICECLASSNAMEBYCLASSID  LPFN_WSAGETSERVICECLASSNAMEBYCLASSIDA
end --/* !UNICODE */
--]]
end --/* INCL_WINSOCK_API_TYPEDEFS */



if INCL_WINSOCK_API_PROTOTYPES then
--[[
    _WINSOCK_DEPRECATED_BY("WSASetServiceW()")

INT
__stdcall
WSASetServiceA(
    LPWSAQUERYSETA lpqsRegInfo,
    WSAESETSERVICEOP essoperation,
    DWORD dwControlFlags
   );
--]]

ffi.cdef[[
INT
__stdcall
WSASetServiceW(
    LPWSAQUERYSETW lpqsRegInfo,
    WSAESETSERVICEOP essoperation,
    DWORD dwControlFlags
   );
]]

--[[
#ifdef UNICODE
#define WSASetService  WSASetServiceW
#else
#define WSASetService  WSASetServiceA
end --/* !UNICODE */
--]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
INT
(__stdcall * LPFN_WSASETSERVICEA)(
    LPWSAQUERYSETA lpqsRegInfo,
    WSAESETSERVICEOP essoperation,
    DWORD dwControlFlags
   );

typedef
INT
(__stdcall * LPFN_WSASETSERVICEW)(
    LPWSAQUERYSETW lpqsRegInfo,
    WSAESETSERVICEOP essoperation,
    DWORD dwControlFlags
   );
]]

--[[
#ifdef UNICODE
#define LPFN_WSASETSERVICE  LPFN_WSASETSERVICEW
#else
#define LPFN_WSASETSERVICE  LPFN_WSASETSERVICEA
end --/* !UNICODE */
--]]

end --/* INCL_WINSOCK_API_TYPEDEFS */

if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
INT
__stdcall
WSAProviderConfigChange(
    LPHANDLE lpNotificationHandle,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */

if INCL_WINSOCK_API_TYPEDEFS then
ffi.cdef[[
typedef
INT
(__stdcall * LPFN_WSAPROVIDERCONFIGCHANGE)(
    LPHANDLE lpNotificationHandle,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
   );
]]
end --/* INCL_WINSOCK_API_TYPEDEFS */

if(_WIN32_WINNT >= 0x0600) then
if INCL_WINSOCK_API_PROTOTYPES then
ffi.cdef[[
int
__stdcall
WSAPoll(
    LPWSAPOLLFD fdArray,
    ULONG fds,
    INT timeout
   );
]]
end --/* INCL_WINSOCK_API_PROTOTYPES */
end -- (_WIN32_WINNT >= 0x0600)


ffi.cdef[[
/* Microsoft Windows Extended data types */
typedef struct sockaddr_in  *LPSOCKADDR_IN;

typedef struct linger LINGER;
typedef struct linger *PLINGER;
typedef struct linger  *LPLINGER;

typedef struct fd_set FD_SET;
typedef struct fd_set *PFD_SET;
typedef struct fd_set  *LPFD_SET;

typedef struct hostent HOSTENT;
typedef struct hostent *PHOSTENT;
typedef struct hostent  *LPHOSTENT;

typedef struct servent SERVENT;
typedef struct servent *PSERVENT;
typedef struct servent  *LPSERVENT;

typedef struct protoent PROTOENT;
typedef struct protoent *PPROTOENT;
typedef struct protoent  *LPPROTOENT;

typedef struct timeval TIMEVAL;
typedef struct timeval *PTIMEVAL;
typedef struct timeval  *LPTIMEVAL;
]]

--[[
/*
* Windows message parameter composition and decomposition
* macros.
*
* WSAMAKEASYNCREPLY is intended for use by the Windows Sockets implementation
* when constructing the response to a WSAAsyncGetXByY() routine.
*/
#define WSAMAKEASYNCREPLY(buflen,error)     MAKELONG(buflen,error)
/*
* WSAMAKESELECTREPLY is intended for use by the Windows Sockets implementation
* when constructing the response to WSAAsyncSelect().
*/
#define WSAMAKESELECTREPLY(event,error)     MAKELONG(event,error)
/*
* WSAGETASYNCBUFLEN is intended for use by the Windows Sockets application
* to extract the buffer length from the lParam in the response
* to a WSAAsyncGetXByY().
*/
#define WSAGETASYNCBUFLEN(lParam)           LOWORD(lParam)
/*
* WSAGETASYNCERROR is intended for use by the Windows Sockets application
* to extract the error code from the lParam in the response
* to a WSAGetXByY().
*/
#define WSAGETASYNCERROR(lParam)            HIWORD(lParam)
/*
* WSAGETSELECTEVENT is intended for use by the Windows Sockets application
* to extract the event code from the lParam in the response
* to a WSAAsyncSelect().
*/
#define WSAGETSELECTEVENT(lParam)           LOWORD(lParam)
/*
* WSAGETSELECTERROR is intended for use by the Windows Sockets application
* to extract the error code from the lParam in the response
* to a WSAAsyncSelect().
*/
#define WSAGETSELECTERROR(lParam)           HIWORD(lParam)
--]]


if _NEED_POPPACK then
ffi.cdef[[
    #pragma pack(pop)
]]
end

--[[
if (_WIN32_WINNT >= 0x0501)
#ifdef IPV6STRICT
#include <wsipv6ok.h>
end -- IPV6STRICT
end --(_WIN32_WINNT >= 0x0501)
--]]

end  --/* _WINSOCK2API_ */

exports.Lib = ffi.load("ws2_32");

return exports