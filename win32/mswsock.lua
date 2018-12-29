
local ffi = require("ffi")

if not _MSWSOCK_ then
_MSWSOCK_ = true

require("win32.winapifamily")


require("win32.mswsockdef")


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
/*
 * Options for connect and disconnect data and options.  Used only by
 * non-TCP/IP transports such as DECNet, OSI TP4, etc.
 */
static const int SO_CONNDATA                = 0x7000;
static const int SO_CONNOPT                 = 0x7001;
static const int SO_DISCDATA                = 0x7002;
static const int SO_DISCOPT                 = 0x7003;
static const int SO_CONNDATALEN             = 0x7004;
static const int SO_CONNOPTLEN              = 0x7005;
static const int SO_DISCDATALEN             = 0x7006;
static const int SO_DISCOPTLEN              = 0x7007;

/*
 * Option for opening sockets for synchronous access.
 */
static const int SO_OPENTYPE                = 0x7008;

static const int SO_SYNCHRONOUS_ALERT       = 0x10;
static const int SO_SYNCHRONOUS_NONALERT    = 0x20;
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */

--[[
/*
 * Other NT-specific options.
 */
#define SO_MAXDG                  =  0x7009;
#define SO_MAXPATHDG              =  0x700A;
#define SO_UPDATE_ACCEPT_CONTEXT  =  0x700B;
#define SO_CONNECT_TIME           =  0x700C;
#if(_WIN32_WINNT >= 0x0501)
#define SO_UPDATE_CONNECT_CONTEXT =  0x7010;
#endif //(_WIN32_WINNT >= 0x0501)

/*
 * TCP options.
 */
#define TCP_BSDURGENT              = 0x7000;
--]]

--[[
/*
 * MS Transport Provider IOCTL to control
 * reporting PORT_UNREACHABLE messages
 * on UDP sockets via recv/WSARecv/etc.
 * Pass TRUE in input buffer to enable (default if supported),
 * FALSE to disable.
 */
#define SIO_UDP_CONNRESET           _WSAIOW(IOC_VENDOR,12)
--]]

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
if((_WIN32_WINNT < 0x0600) and (_WIN32_WINNT >= 0x0501)) then
--[[
/*
 * MS Transport Provider IOCTL to request
 * notification when a given socket is closed.
 * Input buffer must be a pointer to the socket handle.
 * Input buffer size must be exactly sizeof(HANDLE).
 * Output buffer and output buffer length must be
 * NULL and 0 respectively. This IOCTL must always
 * be issued with an overlapped structure.
 *
 * This Ioctl code is available only on WinXP SP2 and Win2k3 SP1.
 */
#define SIO_SOCKET_CLOSE_NOTIFY     _WSAIOW(IOC_VENDOR,13)
--]]

end --//(_WIN32_WINNT < 0x0600 && _WIN32_WINNT >= 0x0501)
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */

--[[
/*
 * MS Transport Provider IOCTL to control
 * reporting NET_UNREACHABLE (TTL expired) messages
 * on UDP sockets via recv/WSARecv/Etc.
 * Pass TRUE in input buffer to enabled (default if supported),
 * FALSE to disable.
 */
#define SIO_UDP_NETRESET            _WSAIOW(IOC_VENDOR,15)
--]]



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
--_WINSOCK_DEPRECATED_BY("WSARecv()")
if(_WIN32_WINNT < 0x0600) then
ffi.cdef[[
int 
WSARecvEx( then
     SOCKET s,
     char  *buf,
     int len,
     int  *flags
    );
]]
else --//(_WIN32_WINNT < 0x0600)
ffi.cdef[[
INT
WSARecvEx(
     SOCKET s,
     CHAR  *buf,
     INT len,
     INT  *flags
    );
]]
end --//(_WIN32_WINNT < 0x0600)
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */

ffi.cdef[[
typedef struct _TRANSMIT_FILE_BUFFERS {
    LPVOID Head;
    DWORD HeadLength;
    LPVOID Tail;
    DWORD TailLength;
} TRANSMIT_FILE_BUFFERS, *PTRANSMIT_FILE_BUFFERS,  *LPTRANSMIT_FILE_BUFFERS;
]]

ffi.cdef[[
static const int TF_DISCONNECT      = 0x01;
static const int TF_REUSE_SOCKET    = 0x02;
static const int TF_WRITE_BEHIND    = 0x04;
static const int TF_USE_DEFAULT_WORKER =0x00;
static const int TF_USE_SYSTEM_THREAD = 0x10;
static const int TF_USE_KERNEL_APC    = 0x20;
]]

ffi.cdef[[
BOOL
TransmitFile (
     SOCKET hSocket,
     HANDLE hFile,
     DWORD nNumberOfBytesToWrite,
     DWORD nNumberOfBytesPerSend,
     LPOVERLAPPED lpOverlapped,
     LPTRANSMIT_FILE_BUFFERS lpTransmitBuffers,
      DWORD dwReserved
    );

BOOL
AcceptEx (
     SOCKET sListenSocket,
     SOCKET sAcceptSocket,
     PVOID lpOutputBuffer,
     DWORD dwReceiveDataLength,
     DWORD dwLocalAddressLength,
     DWORD dwRemoteAddressLength,
     LPDWORD lpdwBytesReceived,
     LPOVERLAPPED lpOverlapped
    );

VOID
GetAcceptExSockaddrs (
    PVOID lpOutputBuffer,
     DWORD dwReceiveDataLength,
     DWORD dwLocalAddressLength,
     DWORD dwRemoteAddressLength,
     struct sockaddr **LocalSockaddr,
     LPINT LocalSockaddrLength,
     struct sockaddr **RemoteSockaddr,
     LPINT RemoteSockaddrLength
    );
]]

ffi.cdef[[
/*
 * "QueryInterface" versions of the above APIs.
 */

typedef
BOOL
(  * LPFN_TRANSMITFILE)(
     SOCKET hSocket,
     HANDLE hFile,
     DWORD nNumberOfBytesToWrite,
     DWORD nNumberOfBytesPerSend,
     LPOVERLAPPED lpOverlapped,
     LPTRANSMIT_FILE_BUFFERS lpTransmitBuffers,
     DWORD dwReserved
    );
]]

--[[
#define WSAID_TRANSMITFILE \
        {0xb5367df0,0xcbac,0x11cf,{0x95,0xca,0x00,0x80,0x5f,0x48,0xa1,0x92}}
--]]

ffi.cdef[[
typedef
BOOL
(  * LPFN_ACCEPTEX)(
     SOCKET sListenSocket,
     SOCKET sAcceptSocket,
     PVOID lpOutputBuffer,
     DWORD dwReceiveDataLength,
     DWORD dwLocalAddressLength,
     DWORD dwRemoteAddressLength,
     LPDWORD lpdwBytesReceived,
     LPOVERLAPPED lpOverlapped
    );
]]

--[[
#define WSAID_ACCEPTEX \
        {0xb5367df1,0xcbac,0x11cf,{0x95,0xca,0x00,0x80,0x5f,0x48,0xa1,0x92}}
--]]

ffi.cdef[[
typedef
VOID
(  * LPFN_GETACCEPTEXSOCKADDRS)(
    PVOID lpOutputBuffer,
     DWORD dwReceiveDataLength,
     DWORD dwLocalAddressLength,
     DWORD dwRemoteAddressLength,
     struct sockaddr **LocalSockaddr,
     LPINT LocalSockaddrLength,
     struct sockaddr **RemoteSockaddr,
     LPINT RemoteSockaddrLength
    );
]]

--[[
#define WSAID_GETACCEPTEXSOCKADDRS \
        {0xb5367df2,0xcbac,0x11cf,{0x95,0xca,0x00,0x80,0x5f,0x48,0xa1,0x92}}
--]]

if(_WIN32_WINNT >= 0x0501) then

ffi.cdef[[
typedef struct _TRANSMIT_PACKETS_ELEMENT {
    ULONG dwElFlags;
static const int TP_ELEMENT_MEMORY  = 1;
static const int TP_ELEMENT_FILE    = 2;
static const int TP_ELEMENT_EOP     = 4;
    ULONG cLength;
    union {
        struct {
            LARGE_INTEGER nFileOffset;
            HANDLE        hFile;
        };
        PVOID             pBuffer;
    };
} TRANSMIT_PACKETS_ELEMENT, *PTRANSMIT_PACKETS_ELEMENT,  *LPTRANSMIT_PACKETS_ELEMENT;
]]

ffi.cdef[[
static const int TP_DISCONNECT          = TF_DISCONNECT;
static const int TP_REUSE_SOCKET        = TF_REUSE_SOCKET;
static const int TP_USE_DEFAULT_WORKER  = TF_USE_DEFAULT_WORKER;
static const int TP_USE_SYSTEM_THREAD   = TF_USE_SYSTEM_THREAD;
static const int TP_USE_KERNEL_APC      = TF_USE_KERNEL_APC;
]]

ffi.cdef[[
typedef
BOOL
(  * LPFN_TRANSMITPACKETS) (
     SOCKET hSocket,      
     LPTRANSMIT_PACKETS_ELEMENT lpPacketArray,        
     DWORD nElementCount,
     DWORD nSendSize,
     LPOVERLAPPED lpOverlapped,
     DWORD dwFlags        
    );
]]

--[[
#define WSAID_TRANSMITPACKETS \
    {0xd9689da0,0x1f90,0x11d3,{0x99,0x71,0x00,0xc0,0x4f,0x68,0xc8,0x76}}
--]]

ffi.cdef[[
typedef
BOOL
(  * LPFN_CONNECTEX) (
     SOCKET s,
     const struct sockaddr  *name,
     int namelen,
     PVOID lpSendBuffer,
     DWORD dwSendDataLength,
     LPDWORD lpdwBytesSent,
     LPOVERLAPPED lpOverlapped
    );
]]

--[[
#define WSAID_CONNECTEX \
    {0x25a207b9,0xddf3,0x4660,{0x8e,0xe9,0x76,0xe5,0x8c,0x74,0x06,0x3e}}
--]]

ffi.cdef[[
typedef
BOOL
(  * LPFN_DISCONNECTEX) (
     SOCKET s,
     LPOVERLAPPED lpOverlapped,
     DWORD  dwFlags,
     DWORD  dwReserved
    );
]]

--[[
#define WSAID_DISCONNECTEX \
    {0x7fda2e11,0x8630,0x436f,{0xa0, 0x31, 0xf5, 0x36, 0xa6, 0xee, 0xc1, 0x57}}
--]]

ffi.cdef[[
static const int DE_REUSE_SOCKET = TF_REUSE_SOCKET;
]]

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

--[[
/*
 * Network-location awareness -- Name registration values for use
 * with WSASetService and other structures.
 */

// {6642243A-3BA8-4aa6-BAA5-2E0BD71FDD83}
#define NLA_NAMESPACE_GUID \
    {0x6642243a,0x3ba8,0x4aa6,{0xba,0xa5,0x2e,0xb,0xd7,0x1f,0xdd,0x83}}

// {6642243A-3BA8-4aa6-BAA5-2E0BD71FDD83}
#define NLA_SERVICE_CLASS_GUID \
    {0x37e515,0xb5c9,0x4a43,{0xba,0xda,0x8b,0x48,0xa8,0x7a,0xd2,0x39}}
--]]

ffi.cdef[[
static const int NLA_ALLUSERS_NETWORK  = 0x00000001;
static const int NLA_FRIENDLY_NAME     = 0x00000002;
]]

ffi.cdef[[
typedef enum _NLA_BLOB_DATA_TYPE {
    NLA_RAW_DATA          = 0,
    NLA_INTERFACE         = 1,
    NLA_802_1X_LOCATION   = 2,
    NLA_CONNECTIVITY      = 3,
    NLA_ICS               = 4,
} NLA_BLOB_DATA_TYPE, *PNLA_BLOB_DATA_TYPE;

typedef enum _NLA_CONNECTIVITY_TYPE {
    NLA_NETWORK_AD_HOC    = 0,
    NLA_NETWORK_MANAGED   = 1,
    NLA_NETWORK_UNMANAGED = 2,
    NLA_NETWORK_UNKNOWN   = 3,
} NLA_CONNECTIVITY_TYPE, *PNLA_CONNECTIVITY_TYPE;

typedef enum _NLA_INTERNET {
    NLA_INTERNET_UNKNOWN  = 0,
    NLA_INTERNET_NO       = 1,
    NLA_INTERNET_YES      = 2,
} NLA_INTERNET, *PNLA_INTERNET;

typedef struct _NLA_BLOB {

    struct {
        NLA_BLOB_DATA_TYPE type;
        DWORD dwSize;
        DWORD nextOffset;
    } header;

    union {

        // header.type -> NLA_RAW_DATA
        CHAR rawData[1];

        // header.type -> NLA_INTERFACE
        struct {
            DWORD dwType;
            DWORD dwSpeed;
            CHAR adapterName[1];
        } interfaceData;

        // header.type -> NLA_802_1X_LOCATION
        struct {
            CHAR information[1];
        } locationData;

        // header.type -> NLA_CONNECTIVITY
        struct {
            NLA_CONNECTIVITY_TYPE type;
            NLA_INTERNET internet;
        } connectivity;

        // header.type -> NLA_ICS
        struct {
            struct {
                DWORD speed;
                DWORD type;
                DWORD state;
                WCHAR machineName[256];
                WCHAR sharedAdapterName[256];
            } remote;
        } ICS;

    } data;

} NLA_BLOB, *PNLA_BLOB, *  LPNLA_BLOB;
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */

ffi.cdef[[
/*
 * WSARecvMsg -- support for receiving ancilliary
 * data/control information with a message.
 */
typedef
INT
(  * LPFN_WSARECVMSG) (
     SOCKET s,
     LPWSAMSG lpMsg,
     LPDWORD lpdwNumberOfBytesRecvd,
     LPWSAOVERLAPPED lpOverlapped,
     LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    );
]]

--[[
#define WSAID_WSARECVMSG \
    {0xf689d7c8,0x6f1f,0x436b,{0x8a,0x53,0xe5,0x4f,0xe3,0x51,0xc3,0x22}}
--]]
end --//(_WIN32_WINNT >= 0x0501)

if(_WIN32_WINNT >= 0x0600) then


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

--[[
/*
 * Ioctl codes for translating socket handles to the base provider handle.
 * This is performed to prevent breaking non-IFS LSPs when new Winsock extension
 * funtions are added.
 */
#define SIO_BSP_HANDLE         = _WSAIOR(IOC_WS2,27);
#define SIO_BSP_HANDLE_SELECT  = _WSAIOR(IOC_WS2,28);
#define SIO_BSP_HANDLE_POLL    = _WSAIOR(IOC_WS2,29);

/*
 * Ioctl code used to translate a socket handle into the base providers handle.
 * This is not used by any Winsock extension function and should not be intercepted
 * by Winsock LSPs.
 */
#define SIO_BASE_HANDLE         _WSAIOR(IOC_WS2,34)
--]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */

--[[
/*
 * Ioctl codes for Winsock extension functions.
 */
#define SIO_EXT_SELECT          _WSAIORW(IOC_WS2,30)
#define SIO_EXT_POLL            _WSAIORW(IOC_WS2,31)
#define SIO_EXT_SENDMSG         _WSAIORW(IOC_WS2,32)
--]]

ffi.cdef[[
/*
 * Data structure for passing WSAPoll arugments through WSAIoctl
 */
typedef struct {
    int result;
    ULONG fds;
    INT timeout;
    WSAPOLLFD fdArray[0];
} WSAPOLLDATA, *LPWSAPOLLDATA;
]]

ffi.cdef[[
/*
 * Data structure for passing WSASendMsg arguments through WSAIoctl
 */
typedef struct {
    LPWSAMSG lpMsg;
    DWORD dwFlags;
    LPDWORD lpNumberOfBytesSent;
    LPWSAOVERLAPPED lpOverlapped;
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine;
} WSASENDMSG, *LPWSASENDMSG;


/*
 * WSASendMsg -- send data to a specific destination, with options, using
 *    overlapped I/O where applicable.
 *
 * Valid flags for dwFlags parameter:
 *    MSG_DONTROUTE
 *    MSG_PARTIAL (a.k.a. MSG_EOR) (only for non-stream sockets)
 *    MSG_OOB (only for stream style sockets) (NYI)
 *
 * Caller must provide either lpOverlapped or lpCompletionRoutine
 * or neither (both NULL).
 */
typedef
INT
(  * LPFN_WSASENDMSG) (
     SOCKET s,
     LPWSAMSG lpMsg,
     DWORD dwFlags,
     LPDWORD lpNumberOfBytesSent,
     LPWSAOVERLAPPED lpOverlapped,
     LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    );
]]

--[[
#define WSAID_WSASENDMSG /* a441e712-754f-43ca-84a7-0dee44cf606d */ \
    {0xa441e712,0x754f,0x43ca,{0x84,0xa7,0x0d,0xee,0x44,0xcf,0x60,0x6d}}
--]]

ffi.cdef[[
//
// WSAPoll
//
typedef
INT
(__stdcall *LPFN_WSAPOLL)(
     LPWSAPOLLFD fdarray,
     ULONG nfds,
     INT timeout
    );
]]

--[[
#define WSAID_WSAPOLL \
        {0x18C76F85,0xDC66,0x4964,{0x97,0x2E,0x23,0xC2,0x72,0x38,0x31,0x2B}}
--]]

end --//(_WIN32_WINNT >= 0x0600)

ffi.cdef[[
typedef BOOL (  * LPFN_RIORECEIVE)(
     RIO_RQ SocketQueue,
     PRIO_BUF pData,
     ULONG DataBufferCount,
     DWORD Flags,
     PVOID RequestContext
    );

typedef int (  * LPFN_RIORECEIVEEX)(
     RIO_RQ SocketQueue,
     PRIO_BUF pData,
     ULONG DataBufferCount,
     PRIO_BUF pLocalAddress,
     PRIO_BUF pRemoteAddress,
     PRIO_BUF pControlContext,
     PRIO_BUF pFlags,
     DWORD Flags,
     PVOID RequestContext
);

typedef BOOL (  * LPFN_RIOSEND)(
     RIO_RQ SocketQueue,
     PRIO_BUF pData,
     ULONG DataBufferCount,
     DWORD Flags,
     PVOID RequestContext
);

typedef BOOL (  * LPFN_RIOSENDEX)(
     RIO_RQ SocketQueue,
     PRIO_BUF pData,
     ULONG DataBufferCount,
     PRIO_BUF pLocalAddress,
     PRIO_BUF pRemoteAddress,
     PRIO_BUF pControlContext,
     PRIO_BUF pFlags,
     DWORD Flags,
     PVOID RequestContext
);

typedef VOID (  * LPFN_RIOCLOSECOMPLETIONQUEUE)(
     RIO_CQ CQ
);

typedef enum _RIO_NOTIFICATION_COMPLETION_TYPE {
    RIO_EVENT_COMPLETION      = 1,
    RIO_IOCP_COMPLETION       = 2,
} RIO_NOTIFICATION_COMPLETION_TYPE, *PRIO_NOTIFICATION_COMPLETION_TYPE;
]]

ffi.cdef[[
typedef struct _RIO_NOTIFICATION_COMPLETION {
    RIO_NOTIFICATION_COMPLETION_TYPE Type;
    union {
        struct {
            HANDLE EventHandle;
            BOOL NotifyReset;
        } Event;
        struct {
            HANDLE IocpHandle;
            PVOID CompletionKey;
            PVOID Overlapped;
        } Iocp;
    };
} RIO_NOTIFICATION_COMPLETION, *PRIO_NOTIFICATION_COMPLETION;



typedef RIO_CQ (  * LPFN_RIOCREATECOMPLETIONQUEUE)(
     DWORD QueueSize,
     PRIO_NOTIFICATION_COMPLETION NotificationCompletion
);

typedef RIO_RQ (  * LPFN_RIOCREATEREQUESTQUEUE)(
     SOCKET Socket,
     ULONG MaxOutstandingReceive,
     ULONG MaxReceiveDataBuffers,
     ULONG MaxOutstandingSend,
     ULONG MaxSendDataBuffers,
     RIO_CQ ReceiveCQ,
     RIO_CQ SendCQ,
     PVOID SocketContext
);

typedef ULONG (  * LPFN_RIODEQUEUECOMPLETION)(
     RIO_CQ CQ,
     PRIORESULT Array,
     ULONG ArraySize
);

typedef VOID (  * LPFN_RIODEREGISTERBUFFER)(
     RIO_BUFFERID BufferId
);

typedef INT (  * LPFN_RIONOTIFY)(
     RIO_CQ CQ
);

typedef RIO_BUFFERID (  * LPFN_RIOREGISTERBUFFER)(
     PCHAR DataBuffer,
     DWORD DataLength
);

typedef BOOL (  * LPFN_RIORESIZECOMPLETIONQUEUE) (
     RIO_CQ CQ,
     DWORD QueueSize
);

typedef BOOL (  * LPFN_RIORESIZEREQUESTQUEUE) (
     RIO_RQ RQ,
     DWORD MaxOutstandingReceive,
     DWORD MaxOutstandingSend
);
]]

ffi.cdef[[
typedef struct _RIO_EXTENSION_FUNCTION_TABLE {
    DWORD cbSize;

    LPFN_RIORECEIVE RIOReceive;
    LPFN_RIORECEIVEEX RIOReceiveEx;
    LPFN_RIOSEND RIOSend;
    LPFN_RIOSENDEX RIOSendEx;
    LPFN_RIOCLOSECOMPLETIONQUEUE RIOCloseCompletionQueue;
    LPFN_RIOCREATECOMPLETIONQUEUE RIOCreateCompletionQueue;
    LPFN_RIOCREATEREQUESTQUEUE RIOCreateRequestQueue;
    LPFN_RIODEQUEUECOMPLETION RIODequeueCompletion;
    LPFN_RIODEREGISTERBUFFER RIODeregisterBuffer;
    LPFN_RIONOTIFY RIONotify;
    LPFN_RIOREGISTERBUFFER RIORegisterBuffer;
    LPFN_RIORESIZECOMPLETIONQUEUE RIOResizeCompletionQueue;
    LPFN_RIORESIZEREQUESTQUEUE RIOResizeRequestQueue;
} RIO_EXTENSION_FUNCTION_TABLE, *PRIO_EXTENSION_FUNCTION_TABLE;
]]

--[[
#define WSAID_MULTIPLE_RIO /* 8509e081-96dd-4005-b165-9e2ee8c79e3f */ \
    {0x8509e081,0x96dd,0x4005,{0xb1,0x65,0x9e,0x2e,0xe8,0xc7,0x9e,0x3f}}
--]]


end  --/* _MSWSOCK_ */

return ffi.load("mswsock") 
