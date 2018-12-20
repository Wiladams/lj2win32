local ffi = require("ffi")
local bit = require("bit")
local band, bor = bit.band, bit.bor
local lshift, rshift = bit.lshift, bit.rshift

if not _WS2DEF_ then
_WS2DEF_ = true

local exports = {}

require("win32.winapifamily")



if not _WINSOCK2API_ and _WINSOCKAPI_ then
error ("Do not include winsock.h and ws2def.h in the same module. Instead include only winsock2.h.")
end


--[[
#if defined(_PREFAST_) && defined(IPV6_PREFAST_SAFE)
#include <ipv6prefast.h>
#endif // _PREFAST_
--]]


require("win32.inaddr")


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
typedef USHORT ADDRESS_FAMILY;
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) */



ffi.cdef[[
static const int AF_UNSPEC      = 0;               // unspecified
static const int AF_UNIX        = 1;               // local to host (pipes, portals)
static const int AF_INET        = 2;               // internetwork: UDP, TCP, etc.
static const int AF_IMPLINK     = 3;               // arpanet imp addresses
static const int AF_PUP         = 4;               // pup protocols: e.g. BSP
static const int AF_CHAOS       = 5;               // mit CHAOS protocols
static const int AF_NS          = 6;               // XEROX NS protocols
static const int AF_IPX         = AF_NS;           // IPX protocols: IPX, SPX, etc.
static const int AF_ISO         = 7;               // ISO protocols
static const int AF_OSI         = AF_ISO;          // OSI is ISO
static const int AF_ECMA        = 8;               // european computer manufacturers
static const int AF_DATAKIT     = 9;               // datakit protocols
static const int AF_CCITT       = 10;              // CCITT protocols, X.25 etc
static const int AF_SNA         = 11;              // IBM SNA
static const int AF_DECnet      = 12;              // DECnet
static const int AF_DLI         = 13;              // Direct data link interface
static const int AF_LAT         = 14;              // LAT
static const int AF_HYLINK      = 15;              // NSC Hyperchannel
static const int AF_APPLETALK   = 16;              // AppleTalk
static const int AF_NETBIOS     = 17;              // NetBios-style addresses
static const int AF_VOICEVIEW   = 18;              // VoiceView
static const int AF_FIREFOX     = 19;              // Protocols from Firefox
static const int AF_UNKNOWN1    = 20;              // Somebody is using this!
static const int AF_BAN         = 21;              // Banyan
static const int AF_ATM         = 22;              // Native ATM Services
static const int AF_INET6       = 23;              // Internetwork Version 6
static const int AF_CLUSTER     = 24;              // Microsoft Wolfpack
static const int AF_12844       = 25;              // IEEE 1284.4 WG AF
static const int AF_IRDA        = 26;              // IrDA
static const int AF_NETDES      = 28;              // Network Designers OSI & gateway
]]

if (_WIN32_WINNT < 0x0501) then
    ffi.cdef[[
    static const int AF_MAX         = 29;
    ]]
else --(_WIN32_WINNT < 0x0501)
    ffi.cdef[[
    static const int AF_TCNPROCESS  = 29;
    static const int AF_TCNMESSAGE  = 30;
    static const int AF_ICLFXBM     = 31;
    ]]

    if(_WIN32_WINNT < 0x0600) then
        ffi.cdef[[
        static const int AF_MAX        =  32;
        ]]
    else --(_WIN32_WINNT < 0x0600)
        ffi.cdef[[
        static const int AF_BTH         = 32;             
        ]]
        
        if(_WIN32_WINNT < 0x0601) then
            ffi.cdef[[
            static const int AF_MAX         = 33;
            ]]
        else --(_WIN32_WINNT < 0x0601)
            ffi.cdef[[
            static const int AF_LINK        = 33;
            ]]
            if(_WIN32_WINNT < 0x0604) then
                ffi.cdef[[
                static const int AF_MAX         = 34;
                ]]
            else --(_WIN32_WINNT < 0x0604)
                ffi.cdef[[
                static const int AF_HYPERV      = 34;
                static const int AF_MAX        =  35;
                ]]
            end --//(_WIN32_WINNT < 0x0604)
        end --//(_WIN32_WINNT < 0x0601)
    end --//(_WIN32_WINNT < 0x0600)
end --(_WIN32_WINNT < 0x0501)

ffi.cdef[[

static const int SOCK_STREAM     = 1;
static const int SOCK_DGRAM      = 2;
static const int SOCK_RAW        = 3;
static const int SOCK_RDM        = 4;
static const int SOCK_SEQPACKET  = 5;
]]

ffi.cdef[[
//
// Define a level for socket I/O controls in the same numbering space as
// IPPROTO_TCP, IPPROTO_IP, etc.
//

static const int SOL_SOCKET = 0xffff;


static const int SO_DEBUG        = 0x0001;      // turn on debugging info recording
static const int SO_ACCEPTCONN   = 0x0002;      // socket has had listen()
static const int SO_REUSEADDR    = 0x0004;      // allow local address reuse
static const int SO_KEEPALIVE    = 0x0008;      // keep connections alive
static const int SO_DONTROUTE    = 0x0010;      // just use interface addresses
static const int SO_BROADCAST    = 0x0020;      // permit sending of broadcast msgs
static const int SO_USELOOPBACK  = 0x0040;      // bypass hardware when possible
static const int SO_LINGER       = 0x0080;      // linger on close if data present
static const int SO_OOBINLINE    = 0x0100;      // leave received OOB data in line

static const int SO_DONTLINGER   = (int)(~SO_LINGER);
static const int SO_EXCLUSIVEADDRUSE = ((int)(~SO_REUSEADDR));          // disallow local address reuse

static const int SO_SNDBUF       = 0x1001;      // send buffer size
static const int SO_RCVBUF       = 0x1002;      // receive buffer size
static const int SO_SNDLOWAT     = 0x1003;      // send low-water mark
static const int SO_RCVLOWAT     = 0x1004;      // receive low-water mark
static const int SO_SNDTIMEO     = 0x1005;      // send timeout
static const int SO_RCVTIMEO     = 0x1006;      // receive timeout
static const int SO_ERROR        = 0x1007;      // get error status and clear
static const int SO_TYPE         = 0x1008;      // get socket type
static const int SO_BSP_STATE    = 0x1009;      // get socket 5-tuple state

static const int SO_GROUP_ID     = 0x2001;      // ID of a socket group
static const int SO_GROUP_PRIORITY = 0x2002;    // the relative priority within a group
static const int SO_MAX_MSG_SIZE = 0x2003;      // maximum message size

static const int SO_CONDITIONAL_ACCEPT = 0x3002; // enable true conditional accept:
                                    // connection is not ack-ed to the
                                    // other side until conditional
                                    // function returns CF_ACCEPT
static const int SO_PAUSE_ACCEPT = 0x3003;      // pause accepting new connections
static const int SO_COMPARTMENT_ID = 0x3004;    // get/set the compartment for a socket
]]


if (_WIN32_WINNT >= 0x0600) then
ffi.cdef[[
static const int SO_RANDOMIZE_PORT = 0x3005;    // randomize assignment of wildcard ports
static const int  SO_PORT_SCALABILITY = 0x3006;  // enable port scalability
static const int  SO_REUSE_UNICASTPORT = 0x3007; // defer ephemeral port allocation for
                                    // outbound connections
static const int  SO_REUSE_MULTICASTPORT = 0x3008; // enable port reuse and disable unicast
                                    //reception.
]]
end --(_WIN32_WINNT >= 0x0600)


ffi.cdef[[
static const int  WSK_SO_BASE = 0x4000;
static const int  TCP_NODELAY  =       0x0001;
]]


--if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

if (_WIN32_WINNT < 0x0600) then
ffi.cdef[[
typedef struct sockaddr {
    ADDRESS_FAMILY sa_family;           // Address family.
    CHAR sa_data[14];                   // Up to 14 bytes of direct address.
} SOCKADDR, *PSOCKADDR,  *LPSOCKADDR;
]]
else 
ffi.cdef[[
typedef struct sockaddr {
    ADDRESS_FAMILY sa_family;           // Address family.
    CHAR sa_data[14];                   // Up to 14 bytes of direct address.
} SOCKADDR, *PSOCKADDR,  *LPSOCKADDR;
]]
end

if not __CSADDR_DEFINED__ then
__CSADDR_DEFINED__ = true

ffi.cdef[[
/*
 * SockAddr Information
 */
typedef struct _SOCKET_ADDRESS {
   LPSOCKADDR lpSockaddr;
    INT iSockaddrLength;
} SOCKET_ADDRESS, *PSOCKET_ADDRESS, *LPSOCKET_ADDRESS;
]]
--end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) */


ffi.cdef[[
/*
 * Address list returned via SIO_ADDRESS_LIST_QUERY
 */
typedef struct _SOCKET_ADDRESS_LIST {
    INT             iAddressCount;
    SOCKET_ADDRESS  Address[1];
} SOCKET_ADDRESS_LIST, *PSOCKET_ADDRESS_LIST,  *LPSOCKET_ADDRESS_LIST;
]]

if (_WIN32_WINNT >= 0x0600) then
--[[
#define SIZEOF_SOCKET_ADDRESS_LIST(AddressCount) \
    (FIELD_OFFSET(SOCKET_ADDRESS_LIST, Address) + \
     AddressCount * sizeof(SOCKET_ADDRESS))
--]]
end --//(_WIN32_WINNT >= 0x0600)

ffi.cdef[[
/*
 * CSAddr Information
 */
typedef struct _CSADDR_INFO {
    SOCKET_ADDRESS LocalAddr ;
    SOCKET_ADDRESS RemoteAddr ;
    INT iSocketType ;
    INT iProtocol ;
} CSADDR_INFO, *PCSADDR_INFO,  * LPCSADDR_INFO ;
]]
end --/* __CSADDR_DEFINED__ */

ffi.cdef[[
static const int _SS_MAXSIZE = 128;                 // Maximum size
static const int _SS_ALIGNSIZE = sizeof(int64_t); // Desired alignment
]]

if (_WIN32_WINNT >= 0x0600) then
ffi.cdef[[
static const int _SS_PAD1SIZE = (_SS_ALIGNSIZE - sizeof(USHORT));
static const int _SS_PAD2SIZE = (_SS_MAXSIZE - (sizeof(USHORT) + _SS_PAD1SIZE + _SS_ALIGNSIZE));
]]
else
ffi.cdef[[
static const int _SS_PAD1SIZE = (_SS_ALIGNSIZE - sizeof (short));
static const int _SS_PAD2SIZE = (_SS_MAXSIZE - (sizeof (short) + _SS_PAD1SIZE + _SS_ALIGNSIZE));
]]
end --//(_WIN32_WINNT >= 0x0600)

ffi.cdef[[
typedef struct sockaddr_storage {
    ADDRESS_FAMILY ss_family;      // address family

    CHAR __ss_pad1[_SS_PAD1SIZE];  // 6 byte pad, this is to make
                                   //   implementation specific pad up to
                                   //   alignment field that follows explicit
                                   //   in the data structure
    __int64 __ss_align;            // Field to force desired structure
    CHAR __ss_pad2[_SS_PAD2SIZE];  // 112 byte pad to achieve desired size;
                                   //   _SS_MAXSIZE value minus size of
                                   //   ss_family, __ss_pad1, and
                                   //   __ss_align fields is 112
} SOCKADDR_STORAGE_LH, *PSOCKADDR_STORAGE_LH,  *LPSOCKADDR_STORAGE_LH;
]]


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then
ffi.cdef[[
typedef struct sockaddr_storage_xp {
    short ss_family;               // Address family.

    CHAR __ss_pad1[_SS_PAD1SIZE];  // 6 byte pad, this is to make
                                   //   implementation specific pad up to
                                   //   alignment field that follows explicit
                                   //   in the data structure
    __int64 __ss_align;            // Field to force desired structure
    CHAR __ss_pad2[_SS_PAD2SIZE];  // 112 byte pad to achieve desired size;
                                   //   _SS_MAXSIZE value minus size of
                                   //   ss_family, __ss_pad1, and
                                   //   __ss_align fields is 112
} SOCKADDR_STORAGE_XP, *PSOCKADDR_STORAGE_XP,  *LPSOCKADDR_STORAGE_XP;
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


if (_WIN32_WINNT >= 0x0600) then
ffi.cdef[[
typedef SOCKADDR_STORAGE_LH SOCKADDR_STORAGE;
typedef SOCKADDR_STORAGE *PSOCKADDR_STORAGE,  *LPSOCKADDR_STORAGE;
]]
elseif (_WIN32_WINNT >= 0x0501) then
ffi.cdef[[
typedef SOCKADDR_STORAGE_XP SOCKADDR_STORAGE;
typedef SOCKADDR_STORAGE *PSOCKADDR_STORAGE,  *LPSOCKADDR_STORAGE;
]]
end

if (_WIN32_WINNT >= 0x0602) then
ffi.cdef[[
typedef struct _SOCKET_PROCESSOR_AFFINITY {
    PROCESSOR_NUMBER Processor;
    USHORT NumaNodeId;
    USHORT Reserved;
} SOCKET_PROCESSOR_AFFINITY, *PSOCKET_PROCESSOR_AFFINITY;
]]
end --//(_WIN32_WINNT >= 0x0602)

ffi.cdef[[

static const int IOCPARM_MASK   = 0x7f;            /* parameters must be < 128 bytes */
static const int IOC_VOID       = 0x20000000;      /* no parameters */
static const int IOC_OUT        = 0x40000000;      /* copy out parameters */
static const int IOC_IN         = 0x80000000;      /* copy in parameters */
static const int IOC_INOUT      = (IOC_IN|IOC_OUT);
                                       /* 0x20000000 distinguishes new &
                                          old ioctls */
]]


function _IO(x,y)
    return bor(ffi.C.IOC_VOID, lshift(x,8), y)
end
                                        
function _IOR(x,y,t)
    return bor(ffi.C.IOC_OUT, lshift(band(ffi.sizeof(t),ffi.C.IOCPARM_MASK), 16), lshift(x,8), y)
end
                                        
function _IOW(x,y,t)
    return bor(ffi.C.IOC_IN, lshift(band(ffi.sizeof(t),ffi.C.IOCPARM_MASK),16), lshift(x,8), y)
end

ffi.cdef[[
/*
 * WinSock 2 extension -- manifest constants for WSAIoctl()
 */
static const int IOC_UNIX                    =  0x00000000;
static const int IOC_WS2                     =  0x08000000;
static const int IOC_PROTOCOL                =  0x10000000;
static const int IOC_VENDOR                  =  0x18000000;
]]


if (_WIN32_WINNT >= 0x0600) then
ffi.cdef[[
static const int IOC_WSK              =         (IOC_WS2|0x07000000);
]]
end --//(_WIN32_WINNT >= 0x0600)


local function _WSAIO(x,y)                   
    return bor(ffi.C.IOC_VOID, x, y)
end

local function _WSAIOR(x,y)                  
    return bor(ffi.C.IOC_OUT, x,y)
end

local function _WSAIOW(x,y)
    return bor(ffi.C.IOC_IN,x,y)
end

local function _WSAIORW(x,y) 
    return  bor(ffi.C.IOC_INOUT,x,y)
end




makeStatic("SIO_ASSOCIATE_HANDLE",          _WSAIOW(ffi.C.IOC_WS2,1))
makeStatic("SIO_ENABLE_CIRCULAR_QUEUEING",  _WSAIO(ffi.C.IOC_WS2,2))
makeStatic("SIO_FIND_ROUTE",                _WSAIOR(ffi.C.IOC_WS2,3))
makeStatic("SIO_FLUSH",                     _WSAIO(ffi.C.IOC_WS2,4))
makeStatic("SIO_GET_BROADCAST_ADDRESS",     _WSAIOR(ffi.C.IOC_WS2,5))
makeStatic("SIO_GET_EXTENSION_FUNCTION_POINTER",  _WSAIORW(ffi.C.IOC_WS2,6))
makeStatic("SIO_GET_QOS",                   _WSAIORW(ffi.C.IOC_WS2,7))
makeStatic("SIO_GET_GROUP_QOS",             _WSAIORW(ffi.C.IOC_WS2,8))
makeStatic("SIO_MULTIPOINT_LOOPBACK",       _WSAIOW(ffi.C.IOC_WS2,9))
makeStatic("SIO_MULTICAST_SCOPE",           _WSAIOW(ffi.C.IOC_WS2,10))
makeStatic("SIO_SET_QOS",                   _WSAIOW(ffi.C.IOC_WS2,11))
makeStatic("SIO_SET_GROUP_QOS",             _WSAIOW(ffi.C.IOC_WS2,12))
makeStatic("SIO_TRANSLATE_HANDLE",          _WSAIORW(ffi.C.IOC_WS2,13))
makeStatic("SIO_ROUTING_INTERFACE_QUERY",   _WSAIORW(ffi.C.IOC_WS2,20))
makeStatic("SIO_ROUTING_INTERFACE_CHANGE",  _WSAIOW(ffi.C.IOC_WS2,21))
makeStatic("SIO_ADDRESS_LIST_QUERY",        _WSAIOR(ffi.C.IOC_WS2,22))
makeStatic("SIO_ADDRESS_LIST_CHANGE",       _WSAIO(ffi.C.IOC_WS2,23))
makeStatic("SIO_QUERY_TARGET_PNP_HANDLE",   _WSAIOR(ffi.C.IOC_WS2,24))
makeStatic("SIO_QUERY_RSS_PROCESSOR_INFO",  _WSAIOR(ffi.C.IOC_WS2,37))

--[[
#if(_WIN32_WINNT >= 0x0501)
#define SIO_ADDRESS_LIST_SORT         _WSAIORW(IOC_WS2,25)
#endif //(_WIN32_WINNT >= 0x0501)

#if (_WIN32_WINNT >= 0x0600)
#define SIO_RESERVED_1                _WSAIOW(IOC_WS2,26)
#define SIO_RESERVED_2                _WSAIOW(IOC_WS2,33)
#endif //(_WIN32_WINNT >= 0x0600)

#define SIO_GET_MULTIPLE_EXTENSION_FUNCTION_POINTER _WSAIORW(IOC_WS2,36)
--]]

ffi.cdef[[
static const int IPPROTO_IP       =       0;
]]

ffi.cdef[[
typedef enum {
    IPPROTO_HOPOPTS       = 0,  // IPv6 Hop-by-Hop options
    IPPROTO_ICMP          = 1,
    IPPROTO_IGMP          = 2,
    IPPROTO_GGP           = 3,
    IPPROTO_IPV4          = 4,
    IPPROTO_ST            = 5,
    IPPROTO_TCP           = 6,
    IPPROTO_CBT           = 7,
    IPPROTO_EGP           = 8,
    IPPROTO_IGP           = 9,
    IPPROTO_PUP           = 12,
    IPPROTO_UDP           = 17,
    IPPROTO_IDP           = 22,
    IPPROTO_RDP           = 27,
    IPPROTO_IPV6          = 41, // IPv6 header
    IPPROTO_ROUTING       = 43, // IPv6 Routing header
    IPPROTO_FRAGMENT      = 44, // IPv6 fragmentation header
    IPPROTO_ESP           = 50, // encapsulating security payload
    IPPROTO_AH            = 51, // authentication header
    IPPROTO_ICMPV6        = 58, // ICMPv6
    IPPROTO_NONE          = 59, // IPv6 no next header
    IPPROTO_DSTOPTS       = 60, // IPv6 Destination options
    IPPROTO_ND            = 77,
    IPPROTO_ICLFXBM       = 78,
    IPPROTO_PIM           = 103,
    IPPROTO_PGM           = 113,
    IPPROTO_L2TP          = 115,
    IPPROTO_SCTP          = 132,
    IPPROTO_RAW           = 255,
    IPPROTO_MAX           = 256,

    IPPROTO_RESERVED_RAW  = 257,
    IPPROTO_RESERVED_IPSEC  = 258,
    IPPROTO_RESERVED_IPSECOFFLOAD  = 259,
    IPPROTO_RESERVED_WNV = 260,
    IPPROTO_RESERVED_MAX  = 261
} IPPROTO, *PIPROTO;
]]

ffi.cdef[[
//
// Port/socket numbers: network standard functions
//
static const int IPPORT_TCPMUX         =  1;
static const int IPPORT_ECHO           =  7;
static const int IPPORT_DISCARD        =  9;
static const int IPPORT_SYSTAT         =  11;
static const int IPPORT_DAYTIME        =  13;
static const int IPPORT_NETSTAT        =  15;
static const int IPPORT_QOTD           =  17;
static const int IPPORT_MSP            =  18;
static const int IPPORT_CHARGEN        =  19;
static const int IPPORT_FTP_DATA       =  20;
static const int IPPORT_FTP            =  21;
static const int IPPORT_TELNET         =  23;
static const int IPPORT_SMTP           =  25;
static const int IPPORT_TIMESERVER     =  37;
static const int IPPORT_NAMESERVER     =  42;
static const int IPPORT_WHOIS          =  43;
static const int IPPORT_MTP            =  57;

/*
 * Port/socket numbers: host specific functions
 */
static const int IPPORT_TFTP           =  69;
static const int IPPORT_RJE            =  77;
static const int IPPORT_FINGER         =  79;
static const int IPPORT_TTYLINK        =  87;
static const int IPPORT_SUPDUP         =  95;

/*
 * UNIX TCP sockets
 */
static const int IPPORT_POP3            = 110;
static const int IPPORT_NTP             = 123;
static const int IPPORT_EPMAP           = 135;
static const int IPPORT_NETBIOS_NS      = 137;
static const int IPPORT_NETBIOS_DGM     = 138;
static const int IPPORT_NETBIOS_SSN     = 139;
static const int IPPORT_IMAP            = 143;
static const int IPPORT_SNMP            = 161;
static const int IPPORT_SNMP_TRAP       = 162;
static const int IPPORT_IMAP3           = 220;
static const int IPPORT_LDAP            = 389;
static const int IPPORT_HTTPS           = 443;
static const int IPPORT_MICROSOFT_DS    = 445;
static const int IPPORT_EXECSERVER      = 512;
static const int IPPORT_LOGINSERVER     = 513;
static const int IPPORT_CMDSERVER       = 514;
static const int IPPORT_EFSSERVER       = 520;

/*
 * UNIX UDP sockets
 */
static const int IPPORT_BIFFUDP         = 512;
static const int IPPORT_WHOSERVER       = 513;
static const int IPPORT_ROUTESERVER     = 520;
                                        /* 520+1 also used */
]]


ffi.cdef[[
 static const int IPPORT_RESERVED        = 1024;
]]

if (_WIN32_WINNT >= 0x0600) then
ffi.cdef[[
static const int IPPORT_REGISTERED_MIN  = IPPORT_RESERVED;
static const int IPPORT_REGISTERED_MAX  = 0xbfff;
static const int IPPORT_DYNAMIC_MIN     = 0xc000;
static const int IPPORT_DYNAMIC_MAX     = 0xffff;
]]
end --//(_WIN32_WINNT >= 0x0600)



ffi.cdef[[
static const int IN_CLASSA_NET        =   0xff000000;
static const int IN_CLASSA_NSHIFT     =   24;
static const int IN_CLASSA_HOST       =   0x00ffffff;
static const int IN_CLASSA_MAX        =   128;


static const int IN_CLASSB_NET        =   0xffff0000;
static const int IN_CLASSB_NSHIFT     =   16;
static const int IN_CLASSB_HOST       =   0x0000ffff;
static const int IN_CLASSB_MAX        =   65536;


static const int IN_CLASSC_NET        =   0xffffff00;
static const int IN_CLASSC_NSHIFT     =   8;
static const int IN_CLASSC_HOST       =   0x000000ff;


static const int IN_CLASSD_NET        =   0xf0000000;       /* These ones aren't really */
static const int IN_CLASSD_NSHIFT     =   28;               /* net and host fields, but */
static const int IN_CLASSD_HOST       =   0x0fffffff;       /* routing needn't know.    */
]]


function exports.IN_CLASSA(i)       return      (band(ffi.cast("LONG",i) , 0x80000000) == 0) end
function exports.IN_CLASSB(i)       return     (band(ffi.case("LONG",i) , 0xc0000000) == 0x80000000) end
function exports.IN_CLASSC(i)       return      (band(ffi.cast("LONG",i) , 0xe0000000) == 0xc0000000) end
function exports.IN_CLASSD(i)       return     (band(ffi.cast("LONG",i) , 0xf0000000) == 0xe0000000) end
function exports.IN_MULTICAST(i)    return      exports.IN_CLASSD(i)  end

ffi.cdef[[
static const int INADDR_ANY           =   (ULONG)0x00000000;
static const int INADDR_LOOPBACK      =   0x7f000001;
static const int INADDR_BROADCAST     =   (ULONG)0xffffffff;
static const int INADDR_NONE          =   0xffffffff;
]]

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
//
// Scope ID definition
//
typedef enum {
    ScopeLevelInterface    = 1,
    ScopeLevelLink         = 2,
    ScopeLevelSubnet       = 3,
    ScopeLevelAdmin        = 4,
    ScopeLevelSite         = 5,
    ScopeLevelOrganization = 8,
    ScopeLevelGlobal       = 14,
    ScopeLevelCount        = 16
} SCOPE_LEVEL;

typedef struct {
    union {
        struct {
            ULONG Zone : 28;
            ULONG Level : 4;
        };
        ULONG Value;
    };
} SCOPE_ID, *PSCOPE_ID;
]]

--#define SCOPEID_UNSPECIFIED_INIT    { 0 }

-- IPv4 Socket address, Internet style

if(_WIN32_WINNT < 0x0600) then
ffi.cdef[[
typedef struct sockaddr_in {
        short   sin_family;
        USHORT sin_port;
        IN_ADDR sin_addr;
        CHAR sin_zero[8];
} SOCKADDR_IN, *PSOCKADDR_IN;
]]
else
ffi.cdef[[
typedef struct sockaddr_in {
    ADDRESS_FAMILY sin_family;
    USHORT sin_port;
    IN_ADDR sin_addr;
    CHAR sin_zero[8];
} SOCKADDR_IN, *PSOCKADDR_IN;
]]
end

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) */




if(_WIN32_WINNT >= 0x0601) then
ffi.cdef[[
typedef struct sockaddr_dl {
    ADDRESS_FAMILY sdl_family;
    UCHAR sdl_data[8];
    UCHAR sdl_zero[4];
} SOCKADDR_DL, *PSOCKADDR_DL;
]]
end --(_WIN32_WINNT >= 0x0601)




ffi.cdef[[
typedef struct _WSABUF {
    ULONG len;     /* the length of the buffer */
    CHAR  *buf; /* the pointer to the buffer */
} WSABUF,  * LPWSABUF;
]]

if (_WIN32_WINNT >= 0x0600) then
ffi.cdef[[
typedef struct _WSAMSG {
    LPSOCKADDR       name;              /* Remote address */
    INT              namelen;           /* Remote address length */
    LPWSABUF         lpBuffers;         /* Data buffer array */
    ULONG            dwBufferCount;     /* Number of elements in the array */
    WSABUF           Control;           /* Control buffer */
    ULONG            dwFlags;           /* Flags */
} WSAMSG, *PWSAMSG, *  LPWSAMSG;
]]
else
ffi.cdef[[
typedef struct _WSAMSG {
     LPSOCKADDR       name;              /* Remote address */
        INT              namelen;           /* Remote address length */
        LPWSABUF         lpBuffers;         /* Data buffer array */
        DWORD            dwBufferCount;     /* Number of elements in the array */
        WSABUF           Control;           /* Control buffer */
        DWORD            dwFlags;           /* Flags */
} WSAMSG, *PWSAMSG, *  LPWSAMSG;
]]
end


if (_WIN32_WINNT >= 0x0600) then
--#define _WSACMSGHDR cmsghdr
end --(_WIN32_WINNT>=0x0600)

ffi.cdef[[
typedef struct _WSACMSGHDR {
    SIZE_T      cmsg_len;
    INT         cmsg_level;
    INT         cmsg_type;
    /* followed by UCHAR cmsg_data[] */
} WSACMSGHDR, *PWSACMSGHDR,  *LPWSACMSGHDR;
]]

if(_WIN32_WINNT >= 0x0600) then
ffi.cdef[[
typedef WSACMSGHDR CMSGHDR, *PCMSGHDR;
]]
end --(_WIN32_WINNT>=0x0600)

--[[
/*
 * Alignment macros for header and data members of
 * the control buffer.
 */
#define WSA_CMSGHDR_ALIGN(length)                           \
            ( ((length) + TYPE_ALIGNMENT(WSACMSGHDR)-1) &   \
                (~(TYPE_ALIGNMENT(WSACMSGHDR)-1)) )         \

#define WSA_CMSGDATA_ALIGN(length)                          \
            ( ((length) + MAX_NATURAL_ALIGNMENT-1) &        \
                (~(MAX_NATURAL_ALIGNMENT-1)) )

#if(_WIN32_WINNT >= 0x0600)
#define CMSGHDR_ALIGN WSA_CMSGHDR_ALIGN
#define CMSGDATA_ALIGN WSA_CMSGDATA_ALIGN
#endif //(_WIN32_WINNT>=0x0600)
--]]

--[[
/*
 *  WSA_CMSG_FIRSTHDR
 *
 *  Returns a pointer to the first ancillary data object,
 *  or a null pointer if there is no ancillary data in the
 *  control buffer of the WSAMSG structure.
 *
 *  LPCMSGHDR
 *  WSA_CMSG_FIRSTHDR (
 *      LPWSAMSG    msg
 *      );
 */
#define WSA_CMSG_FIRSTHDR(msg) \
    ( ((msg)->Control.len >= sizeof(WSACMSGHDR))            \
        ? (LPWSACMSGHDR)(msg)->Control.buf                  \
        : (LPWSACMSGHDR)NULL )

#if(_WIN32_WINNT >= 0x0600)
#define CMSG_FIRSTHDR WSA_CMSG_FIRSTHDR
#endif //(_WIN32_WINNT>=0x0600)

/*
 *  WSA_CMSG_NXTHDR
 *
 *  Returns a pointer to the next ancillary data object,
 *  or a null if there are no more data objects.
 *
 *  LPCMSGHDR
 *  WSA_CMSG_NEXTHDR (
 *      LPWSAMSG        msg,
 *      LPWSACMSGHDR    cmsg
 *      );
 */
#define WSA_CMSG_NXTHDR(msg, cmsg)                          \
    ( ((cmsg) == NULL)                                      \
        ? WSA_CMSG_FIRSTHDR(msg)                            \
        : ( ( ((PUCHAR)(cmsg) +                             \
                    WSA_CMSGHDR_ALIGN((cmsg)->cmsg_len) +   \
                    sizeof(WSACMSGHDR) ) >                  \
                (PUCHAR)((msg)->Control.buf) +              \
                    (msg)->Control.len )                    \
            ? (LPWSACMSGHDR)NULL                            \
            : (LPWSACMSGHDR)((PUCHAR)(cmsg) +               \
                WSA_CMSGHDR_ALIGN((cmsg)->cmsg_len)) ) )

#if(_WIN32_WINNT >= 0x0600)
#define CMSG_NXTHDR WSA_CMSG_NXTHDR
#endif //(_WIN32_WINNT>=0x0600)

/*
 *  WSA_CMSG_DATA
 *
 *  Returns a pointer to the first byte of data (what is referred
 *  to as the cmsg_data member though it is not defined in
 *  the structure).
 *
 *  Note that RFC 2292 defines this as CMSG_DATA, but that name
 *  is already used by wincrypt.h, and so Windows has used WSA_CMSG_DATA.
 *
 *  PUCHAR
 *  WSA_CMSG_DATA (
 *      LPWSACMSGHDR   pcmsg
 *      );
 */
#define WSA_CMSG_DATA(cmsg)             \
            ( (PUCHAR)(cmsg) + WSA_CMSGDATA_ALIGN(sizeof(WSACMSGHDR)) )

/*
 *  WSA_CMSG_SPACE
 *
 *  Returns total size of an ancillary data object given
 *  the amount of data. Used to allocate the correct amount
 *  of space.
 *
 *  SIZE_T
 *  WSA_CMSG_SPACE (
 *      SIZE_T length
 *      );
 */
#define WSA_CMSG_SPACE(length)  \
        (WSA_CMSGDATA_ALIGN(sizeof(WSACMSGHDR) + WSA_CMSGHDR_ALIGN(length)))

#if(_WIN32_WINNT >= 0x0600)
#define CMSG_SPACE WSA_CMSG_SPACE
#endif //(_WIN32_WINNT>=0x0600)

/*
 *  WSA_CMSG_LEN
 *
 *  Returns the value to store in cmsg_len given the amount of data.
 *
 *  SIZE_T
 *  WSA_CMSG_LEN (
 *      SIZE_T length
 *  );
 */
#define WSA_CMSG_LEN(length)    \
         (WSA_CMSGDATA_ALIGN(sizeof(WSACMSGHDR)) + length)

#if(_WIN32_WINNT >= 0x0600)
#define CMSG_LEN WSA_CMSG_LEN
#endif //(_WIN32_WINNT>=0x0600)
--]]

ffi.cdef[[

static const int MSG_TRUNC      = 0x0100;
static const int MSG_CTRUNC     = 0x0200;
static const int MSG_BCAST      = 0x0400;
static const int MSG_MCAST      = 0x0800;
static const int MSG_ERRQUEUE   = 0x1000;
]]

ffi.cdef[[
static const int AI_PASSIVE                 = 0x00000001;  // Socket address will be used in bind() call
static const int AI_CANONNAME               = 0x00000002;  // Return canonical name in first ai_canonname
static const int AI_NUMERICHOST             = 0x00000004;  // Nodename must be a numeric address string
static const int AI_NUMERICSERV             = 0x00000008;  // Servicename must be a numeric port number
static const int AI_DNS_ONLY                = 0x00000010;  // Restrict queries to unicast DNS only (no LLMNR, netbios, etc.)

static const int AI_ALL                     = 0x00000100;  // Query both IP6 and IP4 with AI_V4MAPPED
static const int AI_ADDRCONFIG              = 0x00000400;  // Resolution only if global address configured
static const int AI_V4MAPPED                = 0x00000800;  // On v6 failure, query v4 and convert to V4MAPPED format

static const int AI_NON_AUTHORITATIVE       = 0x00004000;  // LUP_NON_AUTHORITATIVE
static const int AI_SECURE                  = 0x00008000;  // LUP_SECURE
static const int AI_RETURN_PREFERRED_NAMES  = 0x00010000;  // LUP_RETURN_PREFERRED_NAMES

static const int AI_FQDN                    = 0x00020000;  // Return the FQDN in ai_canonname
static const int AI_FILESERVER              = 0x00040000;  // Resolving fileserver name resolution
static const int AI_DISABLE_IDN_ENCODING    = 0x00080000;  // Disable Internationalized Domain Names handling
static const int AI_EXTENDED                = 0x80000000;      // Indicates this is extended ADDRINFOEX(2/..) struct
static const int AI_RESOLUTION_HANDLE       = 0x40000000;  // Request resolution handle
]]

ffi.cdef[[

typedef struct addrinfo
{
    int                 ai_flags;       // AI_PASSIVE, AI_CANONNAME, AI_NUMERICHOST
    int                 ai_family;      // PF_xxx
    int                 ai_socktype;    // SOCK_xxx
    int                 ai_protocol;    // 0 or IPPROTO_xxx for IPv4 and IPv6
    size_t              ai_addrlen;     // Length of ai_addr
    char *              ai_canonname;   // Canonical name for nodename
     struct sockaddr *   ai_addr;        // Binary address
    struct addrinfo *   ai_next;        // Next structure in linked list
}
ADDRINFOA, *PADDRINFOA;

typedef struct addrinfoW
{
    int                 ai_flags;       // AI_PASSIVE, AI_CANONNAME, AI_NUMERICHOST
    int                 ai_family;      // PF_xxx
    int                 ai_socktype;    // SOCK_xxx
    int                 ai_protocol;    // 0 or IPPROTO_xxx for IPv4 and IPv6
    size_t              ai_addrlen;     // Length of ai_addr
    PWSTR               ai_canonname;   // Canonical name for nodename
     struct sockaddr *   ai_addr;        // Binary address
    struct addrinfoW *  ai_next;        // Next structure in linked list
}
ADDRINFOW, *PADDRINFOW;
]]

if (_WIN32_WINNT >= 0x0600) then


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
typedef struct addrinfoexA
{
    int                 ai_flags;       // AI_PASSIVE, AI_CANONNAME, AI_NUMERICHOST
    int                 ai_family;      // PF_xxx
    int                 ai_socktype;    // SOCK_xxx
    int                 ai_protocol;    // 0 or IPPROTO_xxx for IPv4 and IPv6
    size_t              ai_addrlen;     // Length of ai_addr
    char               *ai_canonname;   // Canonical name for nodename
    struct sockaddr    *ai_addr;        // Binary address
    void               *ai_blob;
    size_t              ai_bloblen;
    LPGUID              ai_provider;
    struct addrinfoexA *ai_next;        // Next structure in linked list
} ADDRINFOEXA, *PADDRINFOEXA, *LPADDRINFOEXA;
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */

ffi.cdef[[
typedef struct addrinfoexW
{
    int                 ai_flags;       // AI_PASSIVE, AI_CANONNAME, AI_NUMERICHOST
    int                 ai_family;      // PF_xxx
    int                 ai_socktype;    // SOCK_xxx
    int                 ai_protocol;    // 0 or IPPROTO_xxx for IPv4 and IPv6
    size_t              ai_addrlen;     // Length of ai_addr
    PWSTR               ai_canonname;   // Canonical name for nodename
     struct sockaddr    *ai_addr;        // Binary address
     void               *ai_blob;
    size_t              ai_bloblen;
    LPGUID              ai_provider;
    struct addrinfoexW *ai_next;        // Next structure in linked list
} ADDRINFOEXW, *PADDRINFOEXW, *LPADDRINFOEXW;
]]
end


if (_WIN32_WINNT >= 0x0602) then
ffi.cdef[[
static const int ADDRINFOEX_VERSION_2   = 2;
static const int ADDRINFOEX_VERSION_3   = 3;
static const int ADDRINFOEX_VERSION_4   = 4;
]]

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then
ffi.cdef[[
typedef struct  addrinfoex2A
{
    int                  ai_flags;       // AI_PASSIVE, AI_CANONNAME, AI_NUMERICHOST
    int                  ai_family;      // PF_xxx
    int                  ai_socktype;    // SOCK_xxx
    int                  ai_protocol;    // 0 or IPPROTO_xxx for IPv4 and IPv6
    size_t               ai_addrlen;     // Length of ai_addr
    char                *ai_canonname;   // Canonical name for nodename
    struct sockaddr     *ai_addr;        // Binary address
    void                *ai_blob;
    size_t              ai_bloblen;
    LPGUID               ai_provider;
    struct addrinfoex2A *ai_next;        // Next structure in linked list
    int                  ai_version;
    char                *ai_fqdn;
} ADDRINFOEX2A, *PADDRINFOEX2A, *LPADDRINFOEX2A;
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */

ffi.cdef[[
typedef struct addrinfoex2W
{
    int                  ai_flags;       // AI_PASSIVE, AI_CANONNAME, AI_NUMERICHOST
    int                  ai_family;      // PF_xxx
    int                  ai_socktype;    // SOCK_xxx
    int                  ai_protocol;    // 0 or IPPROTO_xxx for IPv4 and IPv6
    size_t               ai_addrlen;     // Length of ai_addr
    PWSTR                ai_canonname;   // Canonical name for nodename
     struct sockaddr    *ai_addr;        // Binary address
     void               *ai_blob;
    size_t               ai_bloblen;
    LPGUID               ai_provider;
    struct addrinfoex2W *ai_next;        // Next structure in linked list
    int                  ai_version;
    PWSTR                ai_fqdn;
} ADDRINFOEX2W, *PADDRINFOEX2W, *LPADDRINFOEX2W;

typedef struct addrinfoex3
{
    int                  ai_flags;       // AI_PASSIVE, AI_CANONNAME, AI_NUMERICHOST
    int                  ai_family;      // PF_xxx
    int                  ai_socktype;    // SOCK_xxx
    int                  ai_protocol;    // 0 or IPPROTO_xxx for IPv4 and IPv6
    size_t               ai_addrlen;     // Length of ai_addr
    PWSTR                ai_canonname;   // Canonical name for nodename
     struct sockaddr    *ai_addr;        // Binary address
     void               *ai_blob;
    size_t               ai_bloblen;
    LPGUID                 ai_provider;
    struct addrinfoex3   *ai_next;        // Next structure in linked list
    int                  ai_version;
    PWSTR                ai_fqdn;
    int                  ai_interfaceindex;
} ADDRINFOEX3, *PADDRINFOEX3, *LPADDRINFOEX3;

typedef struct addrinfoex4
{
    int                  ai_flags;       // AI_PASSIVE, AI_CANONNAME, AI_NUMERICHOST
    int                  ai_family;      // PF_xxx
    int                  ai_socktype;    // SOCK_xxx
    int                  ai_protocol;    // 0 or IPPROTO_xxx for IPv4 and IPv6
    size_t               ai_addrlen;     // Length of ai_addr
    PWSTR                ai_canonname;   // Canonical name for nodename
     struct sockaddr    *ai_addr;        // Binary address
     void               *ai_blob;
    size_t               ai_bloblen;
    GUID                 *ai_provider;
    struct addrinfoex4   *ai_next;        // Next structure in linked list
    int                  ai_version;
    PWSTR                ai_fqdn;
    int                  ai_interfaceindex;
    HANDLE               ai_resolutionhandle;
} ADDRINFOEX4, *PADDRINFOEX4, *LPADDRINFOEX4;
]]
end

ffi.cdef[[
static const int NS_ALL                   =   (0);

static const int NS_SAP                   =   (1);
static const int NS_NDS                   =   (2);
static const int NS_PEER_BROWSE           =   (3);
static const int NS_SLP                   =   (5);
static const int NS_DHCP                  =   (6);

static const int NS_TCPIP_LOCAL           =   (10);
static const int NS_TCPIP_HOSTS           =   (11);
static const int NS_DNS                   =   (12);
static const int NS_NETBT                 =   (13);
static const int NS_WINS                  =   (14);
]]


if(_WIN32_WINNT >= 0x0501) then
ffi.cdef[[
static const int NS_NLA                   =   (15);    /* Network Location Awareness */
]]
end --(_WIN32_WINNT >= 0x0501)

if(_WIN32_WINNT >= 0x0600) then
ffi.cdef[[
static const int NS_BTH                     = (16);    /* Bluetooth SDP Namespace */
]]
end --(_WIN32_WINNT >= 0x0600)

ffi.cdef[[
static const int NS_NBP                    =  (20);

static const int NS_MS                     =  (30);
static const int NS_STDA                   =  (31);
static const int NS_NTDS                   =  (32);
]]

if(_WIN32_WINNT >= 0x0600) then
ffi.cdef[[
    static const int NS_EMAIL               = (37);
static const int NS_PNRPNAME                = (38);
static const int NS_PNRPCLOUD               = (39);
]]
end --//(_WIN32_WINNT >= 0x0600)

ffi.cdef[[
static const int NS_X500                    = (40);
static const int NS_NIS                     = (41);
static const int NS_NISPLUS                 = (42);

static const int NS_WRQ                     = (50);

static const int NS_NETDES                  = (60);    /* Network Designers Limited */
]]

ffi.cdef[[
//
// Flags for getnameinfo()
//

static const int NI_NOFQDN      = 0x01;  /* Only return nodename portion for local hosts */
static const int NI_NUMERICHOST = 0x02;  /* Return numeric form of the host's address */
static const int NI_NAMEREQD    = 0x04;  /* Error if the host's name not in DNS */
static const int NI_NUMERICSERV = 0x08;  /* Return numeric form of the service (port #) */
static const int NI_DGRAM       = 0x10;  /* Service is a datagram service */

static const int NI_MAXHOST     = 1025;  /* Max size of a fully-qualified domain name */
static const int NI_MAXSERV     = 32;    /* Max size of a service name */
]]


end
