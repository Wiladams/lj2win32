--[[
/*++

Copyright (c) Microsoft Corporation. All rights reserved.

Module Name:

    ws2ipdef.h

Abstract:

    This file contains TCP/IP specific information for use
    by WinSock2 compatible applications.

   Copyright (c) Microsoft Corporation. All rights reserved.

    To provide the backward compatibility, all the TCP/IP
    specific definitions that were included in the WINSOCK.H
    file are now included in WINSOCK2.H file. WS2TCPIP.H
    file includes only the definitions  introduced in the
    "WinSock 2 Protocol-Specific Annex" document.

    Rev 0.3 Nov 13, 1995
        Rev 0.4 Dec 15, 1996

Environment:

    user mode or kernel mode

--*/
--]]

local ffi = require("ffi")
local C = ffi.C 

local C_ASSERT = assert

if not _WS2IPDEF_ then
_WS2IPDEF_ = true


require("win32.winapifamily")



if not  WS2IPDEF_ASSERT then
local function WS2IPDEF_ASSERT(exp) return (0) end
end


require("win32.in6addr")

ffi.cdef[[
//
// Old IPv6 socket address structure (retained for sockaddr_gen definition).
//

struct sockaddr_in6_old {
    SHORT sin6_family;          // AF_INET6.
    USHORT sin6_port;           // Transport level port number.
    ULONG sin6_flowinfo;        // IPv6 flow information.
    IN6_ADDR sin6_addr;         // IPv6 address.
};
]]

ffi.cdef[[
typedef union sockaddr_gen {
    struct sockaddr Address;
    struct sockaddr_in AddressIn;
    struct sockaddr_in6_old AddressIn6;
} sockaddr_gen;
]]

ffi.cdef[[
//
// Structure to keep interface specific information
//

typedef struct _INTERFACE_INFO {
    ULONG iiFlags;              // Interface flags.
    sockaddr_gen iiAddress;     // Interface address.
    sockaddr_gen iiBroadcastAddress; // Broadcast address.
    sockaddr_gen iiNetmask;     // Network mask.
} INTERFACE_INFO,  *LPINTERFACE_INFO;
]]

ffi.cdef[[
//
// New structure that does not have dependency on the address size.
//

typedef struct _INTERFACE_INFO_EX {
    ULONG iiFlags;              // Interface flags.
    SOCKET_ADDRESS iiAddress;   // Interface address.
    SOCKET_ADDRESS iiBroadcastAddress; // Broadcast address.
    SOCKET_ADDRESS iiNetmask;   // Network mask.
} INTERFACE_INFO_EX,  *LPINTERFACE_INFO_EX;
]]

ffi.cdef[[
//
// Possible flags for the  iiFlags - bitmask.
//

static const int IFF_UP             = 0x00000001; // Interface is up.
static const int IFF_BROADCAST      = 0x00000002; // Broadcast is  supported.
static const int IFF_LOOPBACK       = 0x00000004; // This is loopback interface.
static const int IFF_POINTTOPOINT   = 0x00000008; // This is point-to-point interface.
static const int IFF_MULTICAST      = 0x00000010; // Multicast is supported.
]]

ffi.cdef[[
//
// Path MTU discovery states.
//

typedef enum _PMTUD_STATE {
    IP_PMTUDISC_NOT_SET,
    IP_PMTUDISC_DO,
    IP_PMTUDISC_DONT,
    IP_PMTUDISC_PROBE,
    IP_PMTUDISC_MAX
} PMTUD_STATE, *PPMTUD_STATE;
]]

ffi.cdef[[
//
// Options to use with [gs]etsockopt at the IPPROTO_IP level.
// The values should be consistent with the IPv6 equivalents.
//
static const int IP_OPTIONS               =  1; // Set/get IP options.
static const int IP_HDRINCL               =  2; // Header is included with data.
static const int IP_TOS                   =  3; // IP type of service.
static const int IP_TTL                   =  4; // IP TTL (hop limit).
static const int IP_MULTICAST_IF          =  9; // IP multicast interface.
static const int IP_MULTICAST_TTL         = 10; // IP multicast TTL (hop limit).
static const int IP_MULTICAST_LOOP        = 11; // IP multicast loopback.
static const int IP_ADD_MEMBERSHIP        = 12; // Add an IP group membership.
static const int IP_DROP_MEMBERSHIP       = 13; // Drop an IP group membership.
static const int IP_DONTFRAGMENT          = 14; // Don't fragment IP datagrams.
static const int IP_ADD_SOURCE_MEMBERSHIP = 15; // Join IP group/source.
static const int IP_DROP_SOURCE_MEMBERSHIP= 16; // Leave IP group/source.
static const int IP_BLOCK_SOURCE          = 17; // Block IP group/source.
static const int IP_UNBLOCK_SOURCE        = 18; // Unblock IP group/source.
static const int IP_PKTINFO               = 19; // Receive packet information.
static const int IP_HOPLIMIT              = 21; // Receive packet hop limit.
static const int IP_RECVTTL               = 21; // Receive packet Time To Live (TTL).
static const int IP_RECEIVE_BROADCAST     = 22; // Allow/block broadcast reception.
static const int IP_RECVIF                = 24; // Receive arrival interface.
static const int IP_RECVDSTADDR           = 25; // Receive destination address.
static const int IP_IFLIST                = 28; // Enable/Disable an interface list.
static const int IP_ADD_IFLIST            = 29; // Add an interface list entry.
static const int IP_DEL_IFLIST            = 30; // Delete an interface list entry.
static const int IP_UNICAST_IF            = 31; // IP unicast interface.
static const int IP_RTHDR                 = 32; // Set/get IPv6 routing header.
static const int IP_GET_IFLIST            = 33; // Get an interface list.
static const int IP_RECVRTHDR             = 38; // Receive the routing header.
static const int IP_TCLASS                = 39; // Packet traffic class.
static const int IP_RECVTCLASS            = 40; // Receive packet traffic class.
static const int IP_RECVTOS               = 40; // Receive packet Type Of Service (TOS).
static const int IP_ORIGINAL_ARRIVAL_IF   = 47; // Original Arrival Interface Index.
static const int IP_ECN                   = 50; // Receive ECN codepoints in the IP header.
static const int IP_PKTINFO_EX            = 51; // Receive extended packet information.
static const int IP_WFP_REDIRECT_RECORDS  = 60; // WFP's Connection Redirect Records.
static const int IP_WFP_REDIRECT_CONTEXT  = 70; // WFP's Connection Redirect Context.
static const int IP_MTU_DISCOVER          = 71; // Set/get path MTU discover state.
static const int IP_MTU                   = 73; // Get path MTU.
static const int IP_NRT_INTERFACE         = 74; // Set NRT interface constraint (outbound).
static const int IP_RECVERR               = 75; // Receive ICMP errors.
]]

ffi.cdef[[
static const int IP_UNSPECIFIED_TYPE_OF_SERVICE = -1;
]]

--#define IPV6_ADDRESS_BITS RTL_BITS_OF(IN6_ADDR)

--[[
//
// IPv6 socket address structure, RFC 3493.
//

//
// NB: The LH version of sockaddr_in6 has the struct tag sockaddr_in6 rather
// than sockaddr_in6_lh.  This is to make sure that standard sockets apps
// that conform to RFC 2553 (Basic Socket Interface Extensions for IPv6).
//
--]]

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
typedef struct sockaddr_in6 {
    ADDRESS_FAMILY sin6_family; // AF_INET6.
    USHORT sin6_port;           // Transport level port number.
    ULONG  sin6_flowinfo;       // IPv6 flow information.
    IN6_ADDR sin6_addr;         // IPv6 address.
    union {
        ULONG sin6_scope_id;     // Set of interfaces for a scope.
        SCOPE_ID sin6_scope_struct;
    };
} SOCKADDR_IN6_LH, *PSOCKADDR_IN6_LH,  *LPSOCKADDR_IN6_LH;
]]

ffi.cdef[[
typedef struct sockaddr_in6_w2ksp1 {
    short   sin6_family;        /* AF_INET6 */
    USHORT sin6_port;          /* Transport level port number */
    ULONG  sin6_flowinfo;      /* IPv6 flow information */
    struct in6_addr sin6_addr;  /* IPv6 address */
    ULONG sin6_scope_id;       /* set of interfaces for a scope */
} SOCKADDR_IN6_W2KSP1, *PSOCKADDR_IN6_W2KSP1,  *LPSOCKADDR_IN6_W2KSP1;
]]

if (NTDDI_VERSION >= NTDDI_VISTA) then
ffi.cdef[[
typedef SOCKADDR_IN6_LH SOCKADDR_IN6;
typedef SOCKADDR_IN6_LH *PSOCKADDR_IN6;
typedef SOCKADDR_IN6_LH  *LPSOCKADDR_IN6;
]]
elseif(NTDDI_VERSION >= NTDDI_WIN2KSP1) then
ffi.cdef[[
typedef SOCKADDR_IN6_W2KSP1 SOCKADDR_IN6;
typedef SOCKADDR_IN6_W2KSP1 *PSOCKADDR_IN6;
typedef SOCKADDR_IN6_W2KSP1  *LPSOCKADDR_IN6;
]]
else
ffi.cdef[[
typedef SOCKADDR_IN6_LH SOCKADDR_IN6;
typedef SOCKADDR_IN6_LH *PSOCKADDR_IN6;
typedef SOCKADDR_IN6_LH  *LPSOCKADDR_IN6;
]]
end

ffi.cdef[[
typedef union _SOCKADDR_INET {
    SOCKADDR_IN Ipv4;
    SOCKADDR_IN6 Ipv6;
    ADDRESS_FAMILY si_family;
} SOCKADDR_INET, *PSOCKADDR_INET;
]]

ffi.cdef[[
//
// Structure to hold a pair of source, destination addresses.
//
typedef struct _sockaddr_in6_pair
{
    PSOCKADDR_IN6 SourceAddress;
    PSOCKADDR_IN6 DestinationAddress;
} SOCKADDR_IN6_PAIR, *PSOCKADDR_IN6_PAIR;
]]

--[[
//
// Macro that works for both IPv4 and IPv6
//
#define SS_PORT(ssp) (((PSOCKADDR_IN)(ssp))->sin_port)
--]]

if (NTDDI_VERSION >= NTDDI_WIN2KSP1) then
--[[
    //
// N.B. These addresses are in network byte order.
//

#define IN6ADDR_ANY_INIT {{{ 0 }}}

#define IN6ADDR_LOOPBACK_INIT { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 }

#define IN6ADDR_ALLNODESONNODE_INIT { \
    0xff, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01 \
}

#define IN6ADDR_ALLNODESONLINK_INIT { \
    0xff, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01 \
}

#define IN6ADDR_ALLROUTERSONLINK_INIT { \
    0xff, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02 \
}

#define IN6ADDR_ALLMLDV2ROUTERSONLINK_INIT { \
    0xff, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x16 \
}

#define IN6ADDR_TEREDOINITIALLINKLOCALADDRESS_INIT { \
    0xfe, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
    0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe \
}

//
// The old link local address for XP-SP2/Win2K3 machines.
//
#define IN6ADDR_TEREDOOLDLINKLOCALADDRESSXP_INIT {   \
    0xfe, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
    0x00, 0x00,  'T',   'E',  'R',  'E',  'D',  'O' \
}

//
// The old link local address for Vista Beta-2 and earlier machines.
//
#define IN6ADDR_TEREDOOLDLINKLOCALADDRESSVISTA_INIT {       \
    0xfe, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
    0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff \
}

#define IN6ADDR_LINKLOCALPREFIX_INIT { 0xfe, 0x80, }

#define IN6ADDR_MULTICASTPREFIX_INIT { 0xff, 0x00, }

#define IN6ADDR_SOLICITEDNODEMULTICASTPREFIX_INIT { \
    0xff, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
    0x00, 0x00, 0x00, 0x01, 0xff, \
}

#define IN6ADDR_V4MAPPEDPREFIX_INIT { \
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
    0x00, 0x00, 0xff, 0xff, \
}

#define IN6ADDR_6TO4PREFIX_INIT { 0x20, 0x02, }

#define IN6ADDR_TEREDOPREFIX_INIT { 0x20, 0x01, 0x00, 0x00, }

#define IN6ADDR_TEREDOPREFIX_INIT_OLD { 0x3f, 0xfe, 0x83, 0x1f, }

#define IN6ADDR_ULAPREFIX_INIT {0xfc }

#define IN6ADDR_SITELOCALPREFIX_INIT {0xfe, 0xc0 }

#define IN6ADDR_6BONETESTPREFIX_INIT { 0x3f, 0xfe }
--]]

ffi.cdef[[
static const int IN6ADDR_LINKLOCALPREFIX_LENGTH = 64;
static const int IN6ADDR_MULTICASTPREFIX_LENGTH = 8;
static const int IN6ADDR_SOLICITEDNODEMULTICASTPREFIX_LENGTH = 104;
static const int IN6ADDR_V4MAPPEDPREFIX_LENGTH = 96;
static const int IN6ADDR_6TO4PREFIX_LENGTH = 16;
static const int IN6ADDR_TEREDOPREFIX_LENGTH = 32;
]]

--[[
//
// N.B. These addresses are in network byte order.
//
extern CONST SCOPE_ID scopeid_unspecified;

extern CONST IN_ADDR in4addr_any;
extern CONST IN_ADDR in4addr_loopback;
extern CONST IN_ADDR in4addr_broadcast;
extern CONST IN_ADDR in4addr_allnodesonlink;
extern CONST IN_ADDR in4addr_allroutersonlink;
extern CONST IN_ADDR in4addr_alligmpv3routersonlink;
extern CONST IN_ADDR in4addr_allteredohostsonlink;
extern CONST IN_ADDR in4addr_linklocalprefix;
extern CONST IN_ADDR in4addr_multicastprefix;

extern CONST IN6_ADDR in6addr_any;
extern CONST IN6_ADDR in6addr_loopback;
extern CONST IN6_ADDR in6addr_allnodesonnode;
extern CONST IN6_ADDR in6addr_allnodesonlink;
extern CONST IN6_ADDR in6addr_allroutersonlink;
extern CONST IN6_ADDR in6addr_allmldv2routersonlink;
extern CONST IN6_ADDR in6addr_teredoinitiallinklocaladdress;
extern CONST IN6_ADDR in6addr_linklocalprefix;
extern CONST IN6_ADDR in6addr_multicastprefix;
extern CONST IN6_ADDR in6addr_solicitednodemulticastprefix;
extern CONST IN6_ADDR in6addr_v4mappedprefix;
extern CONST IN6_ADDR in6addr_6to4prefix;
extern CONST IN6_ADDR in6addr_teredoprefix;
extern CONST IN6_ADDR in6addr_teredoprefix_old;
--]]



--if not __midl then
--[=[

BOOLEAN
IN6_ADDR_EQUAL(CONST IN6_ADDR *x, CONST IN6_ADDR *y)
{
    __int64 UNALIGNED *a;
    __int64 UNALIGNED *b;

    a = (__int64 UNALIGNED *)x;
    b = (__int64 UNALIGNED *)y;

    return (BOOLEAN)((a[1] == b[1]) && (a[0] == b[0]));
}

//
// RFC 3542 uses IN6_ARE_ADDR_EQUAL().
//
#define IN6_ARE_ADDR_EQUAL IN6_ADDR_EQUAL


BOOLEAN
IN6_IS_ADDR_UNSPECIFIED(CONST IN6_ADDR *a)
{
    //
    // We cant use the in6addr_any variable, since that would
    // require existing callers to link with a specific library.
    //
    return (BOOLEAN)((a->s6_words[0] == 0) &&
                     (a->s6_words[1] == 0) &&
                     (a->s6_words[2] == 0) &&
                     (a->s6_words[3] == 0) &&
                     (a->s6_words[4] == 0) &&
                     (a->s6_words[5] == 0) &&
                     (a->s6_words[6] == 0) &&
                     (a->s6_words[7] == 0));
}


BOOLEAN
IN6_IS_ADDR_LOOPBACK(CONST IN6_ADDR *a)
{
    //
    // We cant use the in6addr_loopback variable, since that would
    // require existing callers to link with a specific library.
    //
    return (BOOLEAN)((a->s6_words[0] == 0) &&
                     (a->s6_words[1] == 0) &&
                     (a->s6_words[2] == 0) &&
                     (a->s6_words[3] == 0) &&
                     (a->s6_words[4] == 0) &&
                     (a->s6_words[5] == 0) &&
                     (a->s6_words[6] == 0) &&
                     (a->s6_words[7] == 0x0100));
}


BOOLEAN
IN6_IS_ADDR_MULTICAST(CONST IN6_ADDR *a)
{
    return (BOOLEAN)(a->s6_bytes[0] == 0xff);
}

//
//  Does the address have a format prefix
//  that indicates it uses EUI-64 interface identifiers?
//

BOOLEAN
IN6_IS_ADDR_EUI64(CONST IN6_ADDR *a)
{
    //
    // Format prefixes 001 through 111, except for multicast.
    //
    return (BOOLEAN)(((a->s6_bytes[0] & 0xe0) != 0) &&
                     !IN6_IS_ADDR_MULTICAST(a));
}

//
//  Is this the subnet router anycast address?
//  See RFC 2373.
//

BOOLEAN
IN6_IS_ADDR_SUBNET_ROUTER_ANYCAST(CONST IN6_ADDR *a)
{
    return (BOOLEAN)(IN6_IS_ADDR_EUI64(a) &&
                     (a->s6_words[4] == 0) &&
                     (a->s6_words[5] == 0) &&
                     (a->s6_words[6] == 0) &&
                     (a->s6_words[7] == 0));
}

//
//  Is this a subnet reserved anycast address?
//  See RFC 2526. It talks about non-EUI-64
//  addresses as well, but IMHO that part
//  of the RFC doesn't make sense. For example,
//  it shouldn't apply to multicast or v4-compatible
//  addresses.
//

BOOLEAN
IN6_IS_ADDR_SUBNET_RESERVED_ANYCAST(CONST IN6_ADDR *a)
{
    return (BOOLEAN)(IN6_IS_ADDR_EUI64(a) &&
                     (a->s6_words[4] == 0xfffd) &&
                     (a->s6_words[5] == 0xffff) &&
                     (a->s6_words[6] == 0xffff) &&
                     ((a->s6_words[7] & 0x80ff) == 0x80ff));
}

//
//  As best we can tell from simple inspection,
//  is this an anycast address?
//

BOOLEAN
IN6_IS_ADDR_ANYCAST(CONST IN6_ADDR *a)
{
    return (IN6_IS_ADDR_SUBNET_RESERVED_ANYCAST(a) ||
            IN6_IS_ADDR_SUBNET_ROUTER_ANYCAST(a));
}


BOOLEAN
IN6_IS_ADDR_LINKLOCAL(CONST IN6_ADDR *a)
{
    return (BOOLEAN)((a->s6_bytes[0] == 0xfe) &&
                     ((a->s6_bytes[1] & 0xc0) == 0x80));
}


BOOLEAN
IN6_IS_ADDR_SITELOCAL(CONST IN6_ADDR *a)
{
    return (BOOLEAN)((a->s6_bytes[0] == 0xfe) &&
                     ((a->s6_bytes[1] & 0xc0) == 0xc0));
}


BOOLEAN
IN6_IS_ADDR_GLOBAL(CONST IN6_ADDR *a)
{
    //
    // Check the format prefix and exclude addresses
    // whose high 4 bits are all zero or all one.
    // This is a cheap way of excluding v4-compatible,
    // v4-mapped, loopback, multicast, link-local, site-local.
    //
    ULONG High = (a->s6_bytes[0] & 0xf0);
    return (BOOLEAN)((High != 0) && (High != 0xf0));
}


BOOLEAN
IN6_IS_ADDR_V4MAPPED(CONST IN6_ADDR *a)
{
    return (BOOLEAN)((a->s6_words[0] == 0) &&
                     (a->s6_words[1] == 0) &&
                     (a->s6_words[2] == 0) &&
                     (a->s6_words[3] == 0) &&
                     (a->s6_words[4] == 0) &&
                     (a->s6_words[5] == 0xffff));
}


BOOLEAN
IN6_IS_ADDR_V4COMPAT(CONST IN6_ADDR *a)
{
    return (BOOLEAN)((a->s6_words[0] == 0) &&
                     (a->s6_words[1] == 0) &&
                     (a->s6_words[2] == 0) &&
                     (a->s6_words[3] == 0) &&
                     (a->s6_words[4] == 0) &&
                     (a->s6_words[5] == 0) &&
                     !((a->s6_words[6] == 0) &&
                       (a->s6_addr[14] == 0) &&
                       ((a->s6_addr[15] == 0) || (a->s6_addr[15] == 1))));
}


BOOLEAN
IN6_IS_ADDR_V4TRANSLATED(CONST IN6_ADDR *a)
{
    return (BOOLEAN)((a->s6_words[0] == 0) &&
                     (a->s6_words[1] == 0) &&
                     (a->s6_words[2] == 0) &&
                     (a->s6_words[3] == 0) &&
                     (a->s6_words[4] == 0xffff) &&
                     (a->s6_words[5] == 0));
}


BOOLEAN
IN6_IS_ADDR_MC_NODELOCAL(CONST IN6_ADDR *a)
{
    return (BOOLEAN)(IN6_IS_ADDR_MULTICAST(a) &&
                     ((a->s6_bytes[1] & 0xf) == 1));
}


BOOLEAN
IN6_IS_ADDR_MC_LINKLOCAL(CONST IN6_ADDR *a)
{
    return (BOOLEAN)(IN6_IS_ADDR_MULTICAST(a) &&
                     ((a->s6_bytes[1] & 0xf) == 2));
}


BOOLEAN
IN6_IS_ADDR_MC_SITELOCAL(CONST IN6_ADDR *a)
{
    return (BOOLEAN)(IN6_IS_ADDR_MULTICAST(a) &&
                     ((a->s6_bytes[1] & 0xf) == 5));
}


BOOLEAN
IN6_IS_ADDR_MC_ORGLOCAL(CONST IN6_ADDR *a)
{
    return (BOOLEAN)(IN6_IS_ADDR_MULTICAST(a) &&
                     ((a->s6_bytes[1] & 0xf) == 8));
}


BOOLEAN
IN6_IS_ADDR_MC_GLOBAL(CONST IN6_ADDR *a)
{
    return (BOOLEAN)(IN6_IS_ADDR_MULTICAST(a) &&
                     ((a->s6_bytes[1] & 0xf) == 0xe));
}


VOID
IN6_SET_ADDR_UNSPECIFIED(PIN6_ADDR a)
{
    //
    // We can't use the in6addr_any variable, since that would
    // require existing callers to link with a specific library.
    //
    memset(a->s6_bytes, 0, sizeof(IN6_ADDR));
}


VOID
IN6_SET_ADDR_LOOPBACK(PIN6_ADDR a)
{
    //
    // We can't use the in6addr_loopback variable, since that would
    // require existing callers to link with a specific library.
    //
    memset(a->s6_bytes, 0, sizeof(IN6_ADDR));
    a->s6_bytes[15] = 1;
}


VOID
IN6ADDR_SETANY(PSOCKADDR_IN6 a)
{
    a->sin6_family = AF_INET6;
    a->sin6_port = 0;
    a->sin6_flowinfo = 0;
    IN6_SET_ADDR_UNSPECIFIED(&a->sin6_addr);
    a->sin6_scope_id = 0;
}


VOID
IN6ADDR_SETLOOPBACK(PSOCKADDR_IN6 a)
{
    a->sin6_family = AF_INET6;
    a->sin6_port = 0;
    a->sin6_flowinfo = 0;
    IN6_SET_ADDR_LOOPBACK(&a->sin6_addr);
    a->sin6_scope_id = 0;
}


BOOLEAN
IN6ADDR_ISANY(CONST SOCKADDR_IN6 *a)
{
    WS2IPDEF_ASSERT(a->sin6_family == AF_INET6);
    return IN6_IS_ADDR_UNSPECIFIED(&a->sin6_addr);
}


BOOLEAN
IN6ADDR_ISLOOPBACK(CONST SOCKADDR_IN6 *a)
{
    WS2IPDEF_ASSERT(a->sin6_family == AF_INET6);
    return IN6_IS_ADDR_LOOPBACK(&a->sin6_addr);
}


BOOLEAN
IN6ADDR_ISEQUAL(CONST SOCKADDR_IN6 *a, CONST SOCKADDR_IN6 *b)
{
    WS2IPDEF_ASSERT(a->sin6_family == AF_INET6);
    return (BOOLEAN)(a->sin6_scope_id == b->sin6_scope_id &&
                     IN6_ADDR_EQUAL(&a->sin6_addr, &b->sin6_addr));
}


BOOLEAN
IN6ADDR_ISUNSPECIFIED(CONST SOCKADDR_IN6 *a)
{
    WS2IPDEF_ASSERT(a->sin6_family == AF_INET6);
    return (BOOLEAN)(a->sin6_scope_id == 0 &&
                     IN6_IS_ADDR_UNSPECIFIED(&a->sin6_addr));
}
--]=]
--end --// __midl

end --// (NTDDI_VERSION >= NTDDI_WIN2KSP1)

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */

--[=[
//
// TCP/IP specific Ioctl codes.
//
#define SIO_GET_INTERFACE_LIST     _IOR('t', 127, ULONG)
#define SIO_GET_INTERFACE_LIST_EX  _IOR('t', 126, ULONG)
#define SIO_SET_MULTICAST_FILTER   _IOW('t', 125, ULONG)
#define SIO_GET_MULTICAST_FILTER   _IOW('t', 124 | IOC_IN, ULONG)

#define SIOCSIPMSFILTER            SIO_SET_MULTICAST_FILTER
#define SIOCGIPMSFILTER            SIO_GET_MULTICAST_FILTER

//
// Protocol independent ioctls for setting and retrieving multicast filters.
//
#define SIOCSMSFILTER     _IOW('t', 126, ULONG)
#define SIOCGMSFILTER     _IOW('t', 127 | IOC_IN, ULONG)
--]=]

if (NTDDI_VERSION >= NTDDI_VISTASP1) then

IDEAL_SEND_BACKLOG_IOCTLS = true

--[=[
//
// Query and change notification ioctls for the ideal send backlog size
// for a given connection. Clients should use the wrappers defined in
// ws2tcpip.h rather than using these ioctls directly.
//

#define SIO_IDEAL_SEND_BACKLOG_QUERY   _IOR('t', 123, ULONG)
#define SIO_IDEAL_SEND_BACKLOG_CHANGE   _IO('t', 122)
--]=]
end

ffi.cdef[[
//
// Protocol independent multicast source filter options.
//
static const int MCAST_JOIN_GROUP           = 41;	// Join all sources for a group.
static const int MCAST_LEAVE_GROUP          = 42;  // Drop all sources for a group.
static const int MCAST_BLOCK_SOURCE         = 43;	// Block IP group/source.
static const int MCAST_UNBLOCK_SOURCE       = 44;	// Unblock IP group/source.
static const int MCAST_JOIN_SOURCE_GROUP    = 45;	// Join IP group/source.
static const int MCAST_LEAVE_SOURCE_GROUP   = 46;	// Leave IP group/source.
]]

ffi.cdef[[
//
// Definitions of MCAST_INCLUDE and MCAST_EXCLUDE for multicast source filter.
//
typedef enum {
    MCAST_INCLUDE = 0,
    MCAST_EXCLUDE
} MULTICAST_MODE_TYPE;

//
// Structure for IP_MREQ (used by IP_ADD_MEMBERSHIP and IP_DROP_MEMBERSHIP).
//
typedef struct ip_mreq {
    IN_ADDR imr_multiaddr;  // IP multicast address of group.
    IN_ADDR imr_interface;  // Local IP address of interface.
} IP_MREQ, *PIP_MREQ;

//
// Structure for IP_MREQ_SOURCE (used by IP_BLOCK_SOURCE, IP_UNBLOCK_SOURCE
// etc.).
//
typedef struct ip_mreq_source {
    IN_ADDR imr_multiaddr;  // IP multicast address of group.
    IN_ADDR imr_sourceaddr; // IP address of source.
    IN_ADDR imr_interface;  // Local IP address of interface.
} IP_MREQ_SOURCE, *PIP_MREQ_SOURCE;

//
// Structure for IP_MSFILTER (used by SIOCSIPMSFILTER and SIOCGIPMSFILTER).
//
typedef struct ip_msfilter {
    IN_ADDR imsf_multiaddr;  // IP multicast address of group.
    IN_ADDR imsf_interface;  // Local IP address of interface.
    MULTICAST_MODE_TYPE imsf_fmode;        // Filter mode.
    ULONG imsf_numsrc;       // Number of sources in src_list.
    IN_ADDR imsf_slist[1];   // Start of source list.
} IP_MSFILTER, *PIP_MSFILTER;
]]

local function IP_MSFILTER_SIZE(NumSources)
    return (ffi.sizeof("IP_MSFILTER") - ffi.sizeof("IN_ADDR") + (NumSources) * ffi.sizeof("IN_ADDR"))
end

ffi.cdef[[
//
// Options to use with [gs]etsockopt at the IPPROTO_IPV6 level.
// These are specified in RFCs 3493 and 3542.
// The values should be consistent with the IPv6 equivalents.
//
static const int IPV6_HOPOPTS         =  1; // Set/get IPv6 hop-by-hop options.
static const int IPV6_HDRINCL         =  2; // Header is included with data.
static const int IPV6_UNICAST_HOPS    =  4; // IP unicast hop limit.
static const int IPV6_MULTICAST_IF    =  9; // IP multicast interface.
static const int IPV6_MULTICAST_HOPS  = 10; // IP multicast hop limit.
static const int IPV6_MULTICAST_LOOP  = 11; // IP multicast loopback.
static const int IPV6_ADD_MEMBERSHIP  = 12; // Add an IP group membership.
static const int IPV6_JOIN_GROUP      = IPV6_ADD_MEMBERSHIP;
static const int IPV6_DROP_MEMBERSHIP = 13; // Drop an IP group membership.
static const int IPV6_LEAVE_GROUP     = IPV6_DROP_MEMBERSHIP;
static const int IPV6_DONTFRAG        = 14; // Don't fragment IP datagrams.
static const int IPV6_PKTINFO         = 19; // Receive packet information.
static const int IPV6_HOPLIMIT        = 21; // Receive packet hop limit.
static const int IPV6_PROTECTION_LEVEL= 23; // Set/get IPv6 protection level.
static const int IPV6_RECVIF          = 24; // Receive arrival interface.
static const int IPV6_RECVDSTADDR     = 25; // Receive destination address.
static const int IPV6_CHECKSUM        = 26; // Offset to checksum for raw IP socket send.
static const int IPV6_V6ONLY          = 27; // Treat wildcard bind as AF_INET6-only.
static const int IPV6_IFLIST          = 28; // Enable/Disable an interface list.
static const int IPV6_ADD_IFLIST      = 29; // Add an interface list entry.
static const int IPV6_DEL_IFLIST      = 30; // Delete an interface list entry.
static const int IPV6_UNICAST_IF      = 31; // IP unicast interface.
static const int IPV6_RTHDR           = 32; // Set/get IPv6 routing header.
static const int IPV6_GET_IFLIST      = 33; // Get an interface list.
static const int IPV6_RECVRTHDR       = 38; // Receive the routing header.
static const int IPV6_TCLASS          = 39; // Packet traffic class.
static const int IPV6_RECVTCLASS      = 40; // Receive packet traffic class.
static const int IPV6_ECN             = 50; // Receive ECN codepoints in the IP header.
static const int IPV6_PKTINFO_EX      = 51; // Receive extended packet information.
static const int IPV6_WFP_REDIRECT_RECORDS  = 60; // WFP's Connection Redirect Records
static const int IPV6_WFP_REDIRECT_CONTEXT  = 70; // WFP's Connection Redirect Context
static const int IPV6_MTU_DISCOVER          = 71; // Set/get path MTU discover state.
static const int IPV6_MTU                   = 72; // Get path MTU.
static const int IPV6_NRT_INTERFACE         = 74; // Set NRT interface constraint (outbound).
static const int IPV6_RECVERR               = 75; // Receive ICMPv6 errors.
]]

ffi.cdef[[
static const int IP_UNSPECIFIED_HOP_LIMIT = -1;

static const int  IP_PROTECTION_LEVEL  = IPV6_PROTECTION_LEVEL;
]]

ffi.cdef[[
//
// Values of IPV6_PROTECTION_LEVEL.
//
static const int PROTECTION_LEVEL_UNRESTRICTED  = 10; // For peer-to-peer apps.
static const int PROTECTION_LEVEL_EDGERESTRICTED= 20; // Same as unrestricted. Except for
                                           // Teredo.
static const int PROTECTION_LEVEL_RESTRICTED    = 30; // For Intranet apps.
]]

if (NTDDI_VERSION < NTDDI_VISTA) then
--#define PROTECTION_LEVEL_DEFAULT        PROTECTION_LEVEL_EDGERESTRICTED
else
--#define PROTECTION_LEVEL_DEFAULT        ((UINT)-1)
end

ffi.cdef[[
//
// Structure for IPV6_JOIN_GROUP and IPV6_LEAVE_GROUP (also,
// IPV6_ADD_MEMBERSHIP and IPV6_DROP_MEMBERSHIP).
//
typedef struct ipv6_mreq {
    IN6_ADDR ipv6mr_multiaddr;  // IPv6 multicast address.
    ULONG ipv6mr_interface;     // Interface index.
} IPV6_MREQ, *PIPV6_MREQ;
]]

if (NTDDI_VERSION >= NTDDI_WINXP) then
ffi.cdef[[
//
// Structure for GROUP_REQ used by protocol independent source filters
// (MCAST_JOIN_GROUP and MCAST_LEAVE_GROUP).
//
typedef struct group_req {
    ULONG gr_interface;         // Interface index.
    SOCKADDR_STORAGE gr_group;  // Multicast address.
} GROUP_REQ, *PGROUP_REQ;
]]

ffi.cdef[[
//
// Structure for GROUP_SOURCE_REQ used by protocol independent source filters
// (MCAST_JOIN_SOURCE_GROUP, MCAST_LEAVE_SOURCE_GROUP etc.).
//
typedef struct group_source_req {
    ULONG gsr_interface;        // Interface index.
    SOCKADDR_STORAGE gsr_group; // Group address.
    SOCKADDR_STORAGE gsr_source; // Source address.
} GROUP_SOURCE_REQ, *PGROUP_SOURCE_REQ;
]]

ffi.cdef[[
//
// Structure for GROUP_FILTER used by protocol independent source filters
// (SIOCSMSFILTER and SIOCGMSFILTER).
//
typedef struct group_filter {
    ULONG gf_interface;         // Interface index.
    SOCKADDR_STORAGE gf_group;  // Multicast address.
    MULTICAST_MODE_TYPE gf_fmode; // Filter mode.
    ULONG gf_numsrc;            // Number of sources.
    SOCKADDR_STORAGE gf_slist[1]; // Source address.
} GROUP_FILTER, *PGROUP_FILTER;
]]

local function GROUP_FILTER_SIZE(numsrc)
   return (ffi.sizeof("GROUP_FILTER") - ffi.sizeof("SOCKADDR_STORAGE") 
   + numsrc * ffi.sizeof("SOCKADDR_STORAGE"));
end

end     -- (NTDDI_VERSION >= NTDDI_WINXP)

ffi.cdef[[
//
// Structure for IP_PKTINFO option.
//
typedef struct in_pktinfo {
    IN_ADDR ipi_addr;     // Source/destination IPv4 address.
    ULONG ipi_ifindex;    // Send/receive interface index.
} IN_PKTINFO, *PIN_PKTINFO;
]]

C_ASSERT(ffi.sizeof("IN_PKTINFO") == 8);

ffi.cdef[[
//
// Structure for IPV6_PKTINFO option.
//
typedef struct in6_pktinfo {
    IN6_ADDR ipi6_addr;    // Source/destination IPv6 address.
    ULONG ipi6_ifindex;    // Send/receive interface index.
} IN6_PKTINFO, *PIN6_PKTINFO;
]]

C_ASSERT(ffi.sizeof("IN6_PKTINFO") == 20);

ffi.cdef[[
//
// Structure for IP_PKTINFO_EX option.
//
typedef struct in_pktinfo_ex {
    IN_PKTINFO pkt_info;
    SCOPE_ID scope_id;
} IN_PKTINFO_EX, *PIN_PKTINFO_EX;
]]

C_ASSERT(ffi.sizeof("IN_PKTINFO_EX") == 12);

ffi.cdef[[
//
// Structure for IPV6_PKTINFO_EX option.
//
typedef struct in6_pktinfo_ex {
    IN6_PKTINFO pkt_info;
    SCOPE_ID scope_id;
} IN6_PKTINFO_EX, *PIN6_PKTINFO_EX;
]]

C_ASSERT(ffi.sizeof("IN6_PKTINFO_EX") == 24);

ffi.cdef[[
//
// Structure for IP_RECVERR option.
//
typedef struct in_recverr {
    IPPROTO protocol;   // IPPROTO_ICMP or IPPROTO_ICMPV6.
    ULONG info;         // MTU if frag needed or pkt too big message.
    UINT8 type;
    UINT8 code;
} IN_RECVERR, *PIN_RECVERR;
]]

ffi.cdef[[
//
// Maximum length of address literals (potentially including a port number)
// generated by any address-to-string conversion routine.  This length can
// be used when declaring buffers used with getnameinfo, WSAAddressToString,
// inet_ntoa, etc.  We just provide one define, rather than one per api,
// to avoid confusion.
//
// The totals are derived from the following data:
//  15: IPv4 address
//  45: IPv6 address including embedded IPv4 address
//  11: Scope Id
//   2: Brackets around IPv6 address when port is present
//   6: Port (including colon)
//   1: Terminating null byte
//
static const int INET_ADDRSTRLEN  = 22;
static const int INET6_ADDRSTRLEN = 65;
]]


ffi.cdef[[
//
// Options to use with [gs]etsockopt at the IPPROTO_TCP level.
// TCP_NODELAY is defined in ws2def.h for historical reasons.
//

//
// Offload preferences supported.
//
static const int TCP_OFFLOAD_NO_PREFERENCE	= 0;
static const int TCP_OFFLOAD_NOT_PREFERRED	= 1;
static const int TCP_OFFLOAD_PREFERRED		= 2;

//      TCP_NODELAY         	 0x0001
static const int TCP_EXPEDITED_1122  	 = 0x0002;
static const int TCP_KEEPALIVE       	 = 3;
static const int TCP_MAXSEG          	 = 4;
static const int TCP_MAXRT           	 = 5;
static const int TCP_STDURG          	 = 6;
static const int TCP_NOURG           	 = 7;
static const int TCP_ATMARK          	 = 8;
static const int TCP_NOSYNRETRIES    	 = 9;
static const int TCP_TIMESTAMPS      	 = 10;
static const int TCP_OFFLOAD_PREFERENCE	 = 11;
static const int TCP_CONGESTION_ALGORITHM= 12;
static const int TCP_DELAY_FIN_ACK       = 13;
static const int TCP_MAXRTMS             = 14;
static const int TCP_FASTOPEN            = 15;
static const int TCP_KEEPCNT             = 16;
static const int TCP_KEEPIDLE            = TCP_KEEPALIVE;
static const int TCP_KEEPINTVL           = 17;
]]


end  -- _WS2IPDEF_