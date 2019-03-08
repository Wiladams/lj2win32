local ffi = require("ffi")

require("win32.minwindef")
require("win32.minwinbase")

-- APISET contracts
require("win32.processenv")
require("win32.fileapi")
require("win32.debugapi")
require("win32.utilapiset")
require("win32.handleapi")
require("win32.errhandlingapi")
require("win32.fibersapi")
require("win32.namedpipeapi")
require("win32.profileapi")
require("win32.heapapi")
require("win32.ioapiset")
require("win32.synchapi")
--require("win32.interlockedapi")     -- NYI, not sure if it can be done
require("win32.processthreadsapi")
require("win32.sysinfoapi")
require("win32.memoryapi")
--require("win32.enclaveapi")           -- NYI, depends on SDK version
--require("win32.threadpoollegacyapiset") -- NYI, not sure if it's needed
--require("win32.threadpoolapiset")   -- NYI
--require("win32.jobapi")             -- NYI
--require("win32.jobapi2")            -- NYI
--require("win32.wow64apiset")        -- NYI
require("win32.libloaderapi")
require("win32.securitybaseapi")
require("win32.namespaceapi")
require("win32.systemtopologyapi")
require("win32.processtopologyapi")
require("win32.securityappcontainer")
require("win32.realtimeapiset")



--[=[
/*
 * Compatibility macros
 */

#define DefineHandleTable(w)            ((w),TRUE)
#define LimitEmsPages(dw)
#define SetSwapAreaSize(w)              (w)
#define LockSegment(w)                  GlobalFix((HANDLE)(w))
#define UnlockSegment(w)                GlobalUnfix((HANDLE)(w))

#define GetCurrentTime()                GetTickCount()

#define Yield()
--]=]


ffi.cdef[[
static const int FILE_BEGIN         =  0;
static const int FILE_CURRENT       =  1;
static const int FILE_END           =  2;

static const int WAIT_FAILED = ((DWORD)0xFFFFFFFF);
static const int WAIT_OBJECT_0      = STATUS_WAIT_0;

static const int WAIT_ABANDONED     =    ((STATUS_ABANDONED_WAIT_0 ) + 0 );
static const int WAIT_ABANDONED_0   =    ((STATUS_ABANDONED_WAIT_0 ) + 0 );

static const int WAIT_IO_COMPLETION =                 STATUS_USER_APC;
]]

--#define SecureZeroMemory RtlSecureZeroMemory
--#define CaptureStackBackTrace RtlCaptureStackBackTrace


ffi.cdef[[
//
// File creation flags must start at the high end since they
// are combined with the attributes
//

//
//  These are flags supported through CreateFile (W7) and CreateFile2 (W8 and beyond)
//

static const int FILE_FLAG_WRITE_THROUGH       =  0x80000000;
static const int FILE_FLAG_OVERLAPPED          =  0x40000000;
static const int FILE_FLAG_NO_BUFFERING        =  0x20000000;
static const int FILE_FLAG_RANDOM_ACCESS       =  0x10000000;
static const int FILE_FLAG_SEQUENTIAL_SCAN     =  0x08000000;
static const int FILE_FLAG_DELETE_ON_CLOSE     =  0x04000000;
static const int FILE_FLAG_BACKUP_SEMANTICS    =  0x02000000;
static const int FILE_FLAG_POSIX_SEMANTICS     =  0x01000000;
static const int FILE_FLAG_SESSION_AWARE       =  0x00800000;
static const int FILE_FLAG_OPEN_REPARSE_POINT  =  0x00200000;
static const int FILE_FLAG_OPEN_NO_RECALL      =  0x00100000;
static const int FILE_FLAG_FIRST_PIPE_INSTANCE =  0x00080000;
]]


if (_WIN32_WINNT >= _WIN32_WINNT_WIN8) then
ffi.cdef[[
static const int FILE_FLAG_OPEN_REQUIRING_OPLOCK = 0x00040000;
]]
end


if (_WIN32_WINNT >= 0x0400) then
ffi.cdef[[
static const int PROGRESS_CONTINUE  = 0;
static const int PROGRESS_CANCEL    = 1;
static const int PROGRESS_STOP      = 2;
static const int PROGRESS_QUIET     = 3;

static const int CALLBACK_CHUNK_FINISHED        = 0x00000000;
static const int CALLBACK_STREAM_SWITCH         = 0x00000001;

static const int COPY_FILE_FAIL_IF_EXISTS               = 0x00000001;
static const int COPY_FILE_RESTARTABLE                  = 0x00000002;
static const int COPY_FILE_OPEN_SOURCE_FOR_WRITE        = 0x00000004;
static const int COPY_FILE_ALLOW_DECRYPTED_DESTINATION  = 0x00000008;
]]


if (_WIN32_WINNT >= 0x0600) then
ffi.cdef[[
static const int COPY_FILE_COPY_SYMLINK               = 0x00000800;
static const int COPY_FILE_NO_BUFFERING               = 0x00001000;
]]
end


if (_WIN32_WINNT >= _WIN32_WINNT_WIN8) then
ffi.cdef[[
static const int COPY_FILE_REQUEST_SECURITY_PRIVILEGES      =  0x00002000;
static const int COPY_FILE_RESUME_FROM_PAUSE                =  0x00004000;

static const int COPY_FILE_NO_OFFLOAD                       =  0x00040000;
]]
end

if (_WIN32_WINNT >= _WIN32_WINNT_WIN10) then
ffi.cdef[[
static const int COPY_FILE_IGNORE_EDP_BLOCK                =   0x00400000;
static const int COPY_FILE_IGNORE_SOURCE_ENCRYPTION        =   0x00800000;
]]
end

end --/* _WIN32_WINNT >= 0x0400 */

if (_WIN32_WINNT >= 0x0500) then
ffi.cdef[[
static const int REPLACEFILE_WRITE_THROUGH       = 0x00000001;
static const int REPLACEFILE_IGNORE_MERGE_ERRORS = 0x00000002;
]]

if (_WIN32_WINNT >= 0x0600) then
ffi.cdef[[
static const int REPLACEFILE_IGNORE_ACL_ERRORS  = 0x00000004;
]]
end

end --// #if (_WIN32_WINNT >= 0x0500)


ffi.cdef[[
//
// Define the dwOpenMode values for CreateNamedPipe
//

static const int PIPE_ACCESS_INBOUND        = 0x00000001;
static const int PIPE_ACCESS_OUTBOUND       = 0x00000002;
static const int PIPE_ACCESS_DUPLEX         = 0x00000003;

//
// Define the Named Pipe End flags for GetNamedPipeInfo
//

static const int PIPE_CLIENT_END            = 0x00000000;
static const int PIPE_SERVER_END            = 0x00000001;

//
// Define the dwPipeMode values for CreateNamedPipe
//

static const int PIPE_WAIT                  = 0x00000000;
static const int PIPE_NOWAIT                = 0x00000001;
static const int PIPE_READMODE_BYTE         = 0x00000000;
static const int PIPE_READMODE_MESSAGE      = 0x00000002;
static const int PIPE_TYPE_BYTE             = 0x00000000;
static const int PIPE_TYPE_MESSAGE          = 0x00000004;
static const int PIPE_ACCEPT_REMOTE_CLIENTS = 0x00000000;
static const int PIPE_REJECT_REMOTE_CLIENTS = 0x00000008;

//
// Define the well known values for CreateNamedPipe nMaxInstances
//

static const int PIPE_UNLIMITED_INSTANCES   = 255;
]]

--[=[
//
// Define the Security Quality of Service bits to be passed
// into CreateFile
//

#define SECURITY_ANONYMOUS          ( SecurityAnonymous      << 16 )
#define SECURITY_IDENTIFICATION     ( SecurityIdentification << 16 )
#define SECURITY_IMPERSONATION      ( SecurityImpersonation  << 16 )
#define SECURITY_DELEGATION         ( SecurityDelegation     << 16 )

#define SECURITY_CONTEXT_TRACKING  0x00040000
#define SECURITY_EFFECTIVE_ONLY    0x00080000

#define SECURITY_SQOS_PRESENT      0x00100000
#define SECURITY_VALID_SQOS_FLAGS  0x001F0000


//
// Fiber structures
//

#if(_WIN32_WINNT >= 0x0400)
typedef VOID (__stdcall *PFIBER_START_ROUTINE)(
    LPVOID lpFiberParameter
    );
typedef PFIBER_START_ROUTINE LPFIBER_START_ROUTINE;

typedef LPVOID (__stdcall *PFIBER_CALLOUT_ROUTINE)(
    LPVOID lpParameter
    );
#endif /* _WIN32_WINNT >= 0x0400 */

//
// FailFast Exception Flags
//

#define FAIL_FAST_GENERATE_EXCEPTION_ADDRESS    0x1
#define FAIL_FAST_NO_HARD_ERROR_DLG             0x2

#if defined(_X86_)
typedef PLDT_ENTRY LPLDT_ENTRY;
else
typedef LPVOID LPLDT_ENTRY;
#endif

//
// Serial provider type.
//

#define SP_SERIALCOMM    ((DWORD)0x00000001)

//
// Provider SubTypes
//

#define PST_UNSPECIFIED      ((DWORD)0x00000000)
#define PST_RS232            ((DWORD)0x00000001)
#define PST_PARALLELPORT     ((DWORD)0x00000002)
#define PST_RS422            ((DWORD)0x00000003)
#define PST_RS423            ((DWORD)0x00000004)
#define PST_RS449            ((DWORD)0x00000005)
#define PST_MODEM            ((DWORD)0x00000006)
#define PST_FAX              ((DWORD)0x00000021)
#define PST_SCANNER          ((DWORD)0x00000022)
#define PST_NETWORK_BRIDGE   ((DWORD)0x00000100)
#define PST_LAT              ((DWORD)0x00000101)
#define PST_TCPIP_TELNET     ((DWORD)0x00000102)
#define PST_X25              ((DWORD)0x00000103)

//
// Provider capabilities flags.
//

#define PCF_DTRDSR        ((DWORD)0x0001)
#define PCF_RTSCTS        ((DWORD)0x0002)
#define PCF_RLSD          ((DWORD)0x0004)
#define PCF_PARITY_CHECK  ((DWORD)0x0008)
#define PCF_XONXOFF       ((DWORD)0x0010)
#define PCF_SETXCHAR      ((DWORD)0x0020)
#define PCF_TOTALTIMEOUTS ((DWORD)0x0040)
#define PCF_INTTIMEOUTS   ((DWORD)0x0080)
#define PCF_SPECIALCHARS  ((DWORD)0x0100)
#define PCF_16BITMODE     ((DWORD)0x0200)

//
// Comm provider settable parameters.
//

#define SP_PARITY         ((DWORD)0x0001)
#define SP_BAUD           ((DWORD)0x0002)
#define SP_DATABITS       ((DWORD)0x0004)
#define SP_STOPBITS       ((DWORD)0x0008)
#define SP_HANDSHAKING    ((DWORD)0x0010)
#define SP_PARITY_CHECK   ((DWORD)0x0020)
#define SP_RLSD           ((DWORD)0x0040)

//
// Settable baud rates in the provider.
//

#define BAUD_075          ((DWORD)0x00000001)
#define BAUD_110          ((DWORD)0x00000002)
#define BAUD_134_5        ((DWORD)0x00000004)
#define BAUD_150          ((DWORD)0x00000008)
#define BAUD_300          ((DWORD)0x00000010)
#define BAUD_600          ((DWORD)0x00000020)
#define BAUD_1200         ((DWORD)0x00000040)
#define BAUD_1800         ((DWORD)0x00000080)
#define BAUD_2400         ((DWORD)0x00000100)
#define BAUD_4800         ((DWORD)0x00000200)
#define BAUD_7200         ((DWORD)0x00000400)
#define BAUD_9600         ((DWORD)0x00000800)
#define BAUD_14400        ((DWORD)0x00001000)
#define BAUD_19200        ((DWORD)0x00002000)
#define BAUD_38400        ((DWORD)0x00004000)
#define BAUD_56K          ((DWORD)0x00008000)
#define BAUD_128K         ((DWORD)0x00010000)
#define BAUD_115200       ((DWORD)0x00020000)
#define BAUD_57600        ((DWORD)0x00040000)
#define BAUD_USER         ((DWORD)0x10000000)

//
// Settable Data Bits
//

#define DATABITS_5        ((WORD)0x0001)
#define DATABITS_6        ((WORD)0x0002)
#define DATABITS_7        ((WORD)0x0004)
#define DATABITS_8        ((WORD)0x0008)
#define DATABITS_16       ((WORD)0x0010)
#define DATABITS_16X      ((WORD)0x0020)

//
// Settable Stop and Parity bits.
//

#define STOPBITS_10       ((WORD)0x0001)
#define STOPBITS_15       ((WORD)0x0002)
#define STOPBITS_20       ((WORD)0x0004)
#define PARITY_NONE       ((WORD)0x0100)
#define PARITY_ODD        ((WORD)0x0200)
#define PARITY_EVEN       ((WORD)0x0400)
#define PARITY_MARK       ((WORD)0x0800)
#define PARITY_SPACE      ((WORD)0x1000)

typedef struct _COMMPROP {
    WORD wPacketLength;
    WORD wPacketVersion;
    DWORD dwServiceMask;
    DWORD dwReserved1;
    DWORD dwMaxTxQueue;
    DWORD dwMaxRxQueue;
    DWORD dwMaxBaud;
    DWORD dwProvSubType;
    DWORD dwProvCapabilities;
    DWORD dwSettableParams;
    DWORD dwSettableBaud;
    WORD wSettableData;
    WORD wSettableStopParity;
    DWORD dwCurrentTxQueue;
    DWORD dwCurrentRxQueue;
    DWORD dwProvSpec1;
    DWORD dwProvSpec2;
    WCHAR wcProvChar[1];
} COMMPROP,*LPCOMMPROP;

//
// Set dwProvSpec1 to COMMPROP_INITIALIZED to indicate that wPacketLength
// is valid before a call to GetCommProperties().
//
#define COMMPROP_INITIALIZED ((DWORD)0xE73CF52E)

typedef struct _COMSTAT {
    DWORD fCtsHold : 1;
    DWORD fDsrHold : 1;
    DWORD fRlsdHold : 1;
    DWORD fXoffHold : 1;
    DWORD fXoffSent : 1;
    DWORD fEof : 1;
    DWORD fTxim : 1;
    DWORD fReserved : 25;
    DWORD cbInQue;
    DWORD cbOutQue;
} COMSTAT, *LPCOMSTAT;

//
// DTR Control Flow Values.
//
#define DTR_CONTROL_DISABLE    0x00
#define DTR_CONTROL_ENABLE     0x01
#define DTR_CONTROL_HANDSHAKE  0x02

//
// RTS Control Flow Values
//
#define RTS_CONTROL_DISABLE    0x00
#define RTS_CONTROL_ENABLE     0x01
#define RTS_CONTROL_HANDSHAKE  0x02
#define RTS_CONTROL_TOGGLE     0x03

typedef struct _DCB {
    DWORD DCBlength;      /* sizeof(DCB)                     */
    DWORD BaudRate;       /* Baudrate at which running       */
    DWORD fBinary: 1;     /* Binary Mode (skip EOF check)    */
    DWORD fParity: 1;     /* Enable parity checking          */
    DWORD fOutxCtsFlow:1; /* CTS handshaking on output       */
    DWORD fOutxDsrFlow:1; /* DSR handshaking on output       */
    DWORD fDtrControl:2;  /* DTR Flow control                */
    DWORD fDsrSensitivity:1; /* DSR Sensitivity              */
    DWORD fTXContinueOnXoff: 1; /* Continue TX when Xoff sent */
    DWORD fOutX: 1;       /* Enable output X-ON/X-OFF        */
    DWORD fInX: 1;        /* Enable input X-ON/X-OFF         */
    DWORD fErrorChar: 1;  /* Enable Err Replacement          */
    DWORD fNull: 1;       /* Enable Null stripping           */
    DWORD fRtsControl:2;  /* Rts Flow control                */
    DWORD fAbortOnError:1; /* Abort all reads and writes on Error */
    DWORD fDummy2:17;     /* Reserved                        */
    WORD wReserved;       /* Not currently used              */
    WORD XonLim;          /* Transmit X-ON threshold         */
    WORD XoffLim;         /* Transmit X-OFF threshold        */
    BYTE ByteSize;        /* Number of bits/byte, 4-8        */
    BYTE Parity;          /* 0-4=None,Odd,Even,Mark,Space    */
    BYTE StopBits;        /* 0,1,2 = 1, 1.5, 2               */
    char XonChar;         /* Tx and Rx X-ON character        */
    char XoffChar;        /* Tx and Rx X-OFF character       */
    char ErrorChar;       /* Error replacement char          */
    char EofChar;         /* End of Input character          */
    char EvtChar;         /* Received Event character        */
    WORD wReserved1;      /* Fill for now.                   */
} DCB, *LPDCB;

typedef struct _COMMTIMEOUTS {
    DWORD ReadIntervalTimeout;          /* Maximum time between read chars. */
    DWORD ReadTotalTimeoutMultiplier;   /* Multiplier of characters.        */
    DWORD ReadTotalTimeoutConstant;     /* Constant in milliseconds.        */
    DWORD WriteTotalTimeoutMultiplier;  /* Multiplier of characters.        */
    DWORD WriteTotalTimeoutConstant;    /* Constant in milliseconds.        */
} COMMTIMEOUTS,*LPCOMMTIMEOUTS;

typedef struct _COMMCONFIG {
    DWORD dwSize;               /* Size of the entire struct */
    WORD wVersion;              /* version of the structure */
    WORD wReserved;             /* alignment */
    DCB dcb;                    /* device control block */
    DWORD dwProviderSubType;    /* ordinal value for identifying
                                   provider-defined data structure format*/
    DWORD dwProviderOffset;     /* Specifies the offset of provider specific
                                   data field in bytes from the start */
    DWORD dwProviderSize;       /* size of the provider-specific data field */
    WCHAR wcProviderData[1];    /* provider-specific data */
} COMMCONFIG,*LPCOMMCONFIG;

//
//


#define FreeModule(hLibModule) FreeLibrary((hLibModule))
#define MakeProcInstance(lpProc,hInstance) (lpProc)
#define FreeProcInstance(lpProc) (lpProc)

/* Global Memory Flags */
#define GMEM_FIXED          0x0000
#define GMEM_MOVEABLE       0x0002
#define GMEM_NOCOMPACT      0x0010
#define GMEM_NODISCARD      0x0020
#define GMEM_ZEROINIT       0x0040
#define GMEM_MODIFY         0x0080
#define GMEM_DISCARDABLE    0x0100
#define GMEM_NOT_BANKED     0x1000
#define GMEM_SHARE          0x2000
#define GMEM_DDESHARE       0x2000
#define GMEM_NOTIFY         0x4000
#define GMEM_LOWER          GMEM_NOT_BANKED
#define GMEM_VALID_FLAGS    0x7F72
#define GMEM_INVALID_HANDLE 0x8000

#define GHND                (GMEM_MOVEABLE | GMEM_ZEROINIT)
#define GPTR                (GMEM_FIXED | GMEM_ZEROINIT)

#define GlobalLRUNewest( h )    ((HANDLE)(h))
#define GlobalLRUOldest( h )    ((HANDLE)(h))
#define GlobalDiscard( h )      GlobalReAlloc( (h), 0, GMEM_MOVEABLE )
--]=]

ffi.cdef[[
/* Flags returned by GlobalFlags (in addition to GMEM_DISCARDABLE) */
static const int GMEM_DISCARDED    =  0x4000;
static const int GMEM_LOCKCOUNT    =  0x00FF;
]]

ffi.cdef[[
typedef struct _MEMORYSTATUS {
    DWORD dwLength;
    DWORD dwMemoryLoad;
    SIZE_T dwTotalPhys;
    SIZE_T dwAvailPhys;
    SIZE_T dwTotalPageFile;
    SIZE_T dwAvailPageFile;
    SIZE_T dwTotalVirtual;
    SIZE_T dwAvailVirtual;
} MEMORYSTATUS, *LPMEMORYSTATUS;

//
// Process dwCreationFlag values
//

static const int DEBUG_PROCESS                     = 0x00000001;
static const int DEBUG_ONLY_THIS_PROCESS           = 0x00000002;
static const int CREATE_SUSPENDED                  = 0x00000004;
static const int DETACHED_PROCESS                  = 0x00000008;

static const int CREATE_NEW_CONSOLE                = 0x00000010;
static const int NORMAL_PRIORITY_CLASS             = 0x00000020;
static const int IDLE_PRIORITY_CLASS               = 0x00000040;
static const int HIGH_PRIORITY_CLASS               = 0x00000080;

static const int REALTIME_PRIORITY_CLASS           = 0x00000100;
static const int CREATE_NEW_PROCESS_GROUP          = 0x00000200;
static const int CREATE_UNICODE_ENVIRONMENT        = 0x00000400;
static const int CREATE_SEPARATE_WOW_VDM           = 0x00000800;

static const int CREATE_SHARED_WOW_VDM             = 0x00001000;
static const int CREATE_FORCEDOS                   = 0x00002000;
static const int BELOW_NORMAL_PRIORITY_CLASS       = 0x00004000;
static const int ABOVE_NORMAL_PRIORITY_CLASS       = 0x00008000;

static const int INHERIT_PARENT_AFFINITY           = 0x00010000;
static const int INHERIT_CALLER_PRIORITY           = 0x00020000;    // Deprecated
static const int CREATE_PROTECTED_PROCESS          = 0x00040000;
static const int EXTENDED_STARTUPINFO_PRESENT      = 0x00080000;

static const int PROCESS_MODE_BACKGROUND_BEGIN     = 0x00100000;
static const int PROCESS_MODE_BACKGROUND_END       = 0x00200000;
static const int CREATE_SECURE_PROCESS             = 0x00400000;

static const int CREATE_BREAKAWAY_FROM_JOB         = 0x01000000;
static const int CREATE_PRESERVE_CODE_AUTHZ_LEVEL  = 0x02000000;
static const int CREATE_DEFAULT_ERROR_MODE         = 0x04000000;
static const int CREATE_NO_WINDOW                  = 0x08000000;

static const int PROFILE_USER                      = 0x10000000;
static const int PROFILE_KERNEL                    = 0x20000000;
static const int PROFILE_SERVER                    = 0x40000000;
static const int CREATE_IGNORE_SYSTEM_DEFAULT      = 0x80000000;
]]

--[=[
//
// Thread dwCreationFlag values
//

//#define CREATE_SUSPENDED                  0x00000004

#define STACK_SIZE_PARAM_IS_A_RESERVATION   0x00010000    // Threads only

//
// Priority flags
//

#define THREAD_PRIORITY_LOWEST          THREAD_BASE_PRIORITY_MIN
#define THREAD_PRIORITY_BELOW_NORMAL    (THREAD_PRIORITY_LOWEST+1)
#define THREAD_PRIORITY_NORMAL          0
#define THREAD_PRIORITY_HIGHEST         THREAD_BASE_PRIORITY_MAX
#define THREAD_PRIORITY_ABOVE_NORMAL    (THREAD_PRIORITY_HIGHEST-1)
#define THREAD_PRIORITY_ERROR_RETURN    (MAXLONG)

#define THREAD_PRIORITY_TIME_CRITICAL   THREAD_BASE_PRIORITY_LOWRT
#define THREAD_PRIORITY_IDLE            THREAD_BASE_PRIORITY_IDLE

#define THREAD_MODE_BACKGROUND_BEGIN    0x00010000
#define THREAD_MODE_BACKGROUND_END      0x00020000

//
// GetFinalPathNameByHandle
//

#define VOLUME_NAME_DOS  0x0      //default
#define VOLUME_NAME_GUID 0x1
#define VOLUME_NAME_NT   0x2
#define VOLUME_NAME_NONE 0x4

#define FILE_NAME_NORMALIZED 0x0  //default
#define FILE_NAME_OPENED     0x8

//
// JIT Debugging Info. This structure is defined to have constant size in
// both the emulated and native environment.
//

typedef struct _JIT_DEBUG_INFO {
    DWORD dwSize;
    DWORD dwProcessorArchitecture;
    DWORD dwThreadID;
    DWORD dwReserved0;
    ULONG64 lpExceptionAddress;
    ULONG64 lpExceptionRecord;
    ULONG64 lpContextRecord;
} JIT_DEBUG_INFO, *LPJIT_DEBUG_INFO;

typedef JIT_DEBUG_INFO JIT_DEBUG_INFO32, *LPJIT_DEBUG_INFO32;
typedef JIT_DEBUG_INFO JIT_DEBUG_INFO64, *LPJIT_DEBUG_INFO64;

#if !defined(MIDL_PASS)
typedef PEXCEPTION_RECORD LPEXCEPTION_RECORD;
typedef PEXCEPTION_POINTERS LPEXCEPTION_POINTERS;
#endif

#define DRIVE_UNKNOWN     0
#define DRIVE_NO_ROOT_DIR 1
#define DRIVE_REMOVABLE   2
#define DRIVE_FIXED       3
#define DRIVE_REMOTE      4
#define DRIVE_CDROM       5
#define DRIVE_RAMDISK     6


#ifndef _MAC
#define GetFreeSpace(w)                 (0x100000L)
else
 DWORD __stdcall GetFreeSpace( UINT);
#endif


#define FILE_TYPE_UNKNOWN   0x0000
#define FILE_TYPE_DISK      0x0001
#define FILE_TYPE_CHAR      0x0002
#define FILE_TYPE_PIPE      0x0003
#define FILE_TYPE_REMOTE    0x8000


#define STD_INPUT_HANDLE    ((DWORD)-10)
#define STD_OUTPUT_HANDLE   ((DWORD)-11)
#define STD_ERROR_HANDLE    ((DWORD)-12)

#define NOPARITY            0
#define ODDPARITY           1
#define EVENPARITY          2
#define MARKPARITY          3
#define SPACEPARITY         4

#define ONESTOPBIT          0
#define ONE5STOPBITS        1
#define TWOSTOPBITS         2

#define IGNORE              0       // Ignore signal
--]=]

ffi.cdef[[
static const int INFINITE   =         0xFFFFFFFF;  // Infinite timeout
]]

--[=[
//
// Baud rates at which the communication device operates
//

#define CBR_110             110
#define CBR_300             300
#define CBR_600             600
#define CBR_1200            1200
#define CBR_2400            2400
#define CBR_4800            4800
#define CBR_9600            9600
#define CBR_14400           14400
#define CBR_19200           19200
#define CBR_38400           38400
#define CBR_56000           56000
#define CBR_57600           57600
#define CBR_115200          115200
#define CBR_128000          128000
#define CBR_256000          256000

//
// Error Flags
//

#define CE_RXOVER           0x0001  // Receive Queue overflow
#define CE_OVERRUN          0x0002  // Receive Overrun Error
#define CE_RXPARITY         0x0004  // Receive Parity Error
#define CE_FRAME            0x0008  // Receive Framing error
#define CE_BREAK            0x0010  // Break Detected
#define CE_TXFULL           0x0100  // TX Queue is full
#define CE_PTO              0x0200  // LPTx Timeout
#define CE_IOE              0x0400  // LPTx I/O Error
#define CE_DNS              0x0800  // LPTx Device not selected
#define CE_OOP              0x1000  // LPTx Out-Of-Paper
#define CE_MODE             0x8000  // Requested mode unsupported

#define IE_BADID            (-1)    // Invalid or unsupported id
#define IE_OPEN             (-2)    // Device Already Open
#define IE_NOPEN            (-3)    // Device Not Open
#define IE_MEMORY           (-4)    // Unable to allocate queues
#define IE_DEFAULT          (-5)    // Error in default parameters
#define IE_HARDWARE         (-10)   // Hardware Not Present
#define IE_BYTESIZE         (-11)   // Illegal Byte Size
#define IE_BAUDRATE         (-12)   // Unsupported BaudRate

//
// Events
//

#define EV_RXCHAR           0x0001  // Any Character received
#define EV_RXFLAG           0x0002  // Received certain character
#define EV_TXEMPTY          0x0004  // Transmitt Queue Empty
#define EV_CTS              0x0008  // CTS changed state
#define EV_DSR              0x0010  // DSR changed state
#define EV_RLSD             0x0020  // RLSD changed state
#define EV_BREAK            0x0040  // BREAK received
#define EV_ERR              0x0080  // Line status error occurred
#define EV_RING             0x0100  // Ring signal detected
#define EV_PERR             0x0200  // Printer error occured
#define EV_RX80FULL         0x0400  // Receive buffer is 80 percent full
#define EV_EVENT1           0x0800  // Provider specific event 1
#define EV_EVENT2           0x1000  // Provider specific event 2

//
// Escape Functions
//

#define SETXOFF             1       // Simulate XOFF received
#define SETXON              2       // Simulate XON received
#define SETRTS              3       // Set RTS high
#define CLRRTS              4       // Set RTS low
#define SETDTR              5       // Set DTR high
#define CLRDTR              6       // Set DTR low
#define RESETDEV            7       // Reset device if possible
#define SETBREAK            8       // Set the device break line.
#define CLRBREAK            9       // Clear the device break line.

//
// PURGE function flags.
//
#define PURGE_TXABORT       0x0001  // Kill the pending/current writes to the comm port.
#define PURGE_RXABORT       0x0002  // Kill the pending/current reads to the comm port.
#define PURGE_TXCLEAR       0x0004  // Kill the transmit queue if there.
#define PURGE_RXCLEAR       0x0008  // Kill the typeahead buffer if there.

#define LPTx                0x80    // Set if ID is for LPT device

//
// Modem Status Flags
//
#define MS_CTS_ON           ((DWORD)0x0010)
#define MS_DSR_ON           ((DWORD)0x0020)
#define MS_RING_ON          ((DWORD)0x0040)
#define MS_RLSD_ON          ((DWORD)0x0080)

//
// WaitSoundState() Constants
//

#define S_QUEUEEMPTY        0
#define S_THRESHOLD         1
#define S_ALLTHRESHOLD      2

//
// Accent Modes
//

#define S_NORMAL      0
#define S_LEGATO      1
#define S_STACCATO    2

//
// SetSoundNoise() Sources
//

#define S_PERIOD512   0     // Freq = N/512 high pitch, less coarse hiss
#define S_PERIOD1024  1     // Freq = N/1024
#define S_PERIOD2048  2     // Freq = N/2048 low pitch, more coarse hiss
#define S_PERIODVOICE 3     // Source is frequency from voice channel (3)
#define S_WHITE512    4     // Freq = N/512 high pitch, less coarse hiss
#define S_WHITE1024   5     // Freq = N/1024
#define S_WHITE2048   6     // Freq = N/2048 low pitch, more coarse hiss
#define S_WHITEVOICE  7     // Source is frequency from voice channel (3)

#define S_SERDVNA     (-1)  // Device not available
#define S_SEROFM      (-2)  // Out of memory
#define S_SERMACT     (-3)  // Music active
#define S_SERQFUL     (-4)  // Queue full
#define S_SERBDNT     (-5)  // Invalid note
#define S_SERDLN      (-6)  // Invalid note length
#define S_SERDCC      (-7)  // Invalid note count
#define S_SERDTP      (-8)  // Invalid tempo
#define S_SERDVL      (-9)  // Invalid volume
#define S_SERDMD      (-10) // Invalid mode
#define S_SERDSH      (-11) // Invalid shape
#define S_SERDPT      (-12) // Invalid pitch
#define S_SERDFQ      (-13) // Invalid frequency
#define S_SERDDR      (-14) // Invalid duration
#define S_SERDSR      (-15) // Invalid source
#define S_SERDST      (-16) // Invalid state

#define NMPWAIT_WAIT_FOREVER            0xffffffff
#define NMPWAIT_NOWAIT                  0x00000001
#define NMPWAIT_USE_DEFAULT_WAIT        0x00000000

#define FS_CASE_IS_PRESERVED            FILE_CASE_PRESERVED_NAMES
#define FS_CASE_SENSITIVE               FILE_CASE_SENSITIVE_SEARCH
#define FS_UNICODE_STORED_ON_DISK       FILE_UNICODE_ON_DISK
#define FS_PERSISTENT_ACLS              FILE_PERSISTENT_ACLS
#define FS_VOL_IS_COMPRESSED            FILE_VOLUME_IS_COMPRESSED
#define FS_FILE_COMPRESSION             FILE_FILE_COMPRESSION
#define FS_FILE_ENCRYPTION              FILE_SUPPORTS_ENCRYPTION

#define OF_READ             0x00000000
#define OF_WRITE            0x00000001
#define OF_READWRITE        0x00000002
#define OF_SHARE_COMPAT     0x00000000
#define OF_SHARE_EXCLUSIVE  0x00000010
#define OF_SHARE_DENY_WRITE 0x00000020
#define OF_SHARE_DENY_READ  0x00000030
#define OF_SHARE_DENY_NONE  0x00000040
#define OF_PARSE            0x00000100
#define OF_DELETE           0x00000200
#define OF_VERIFY           0x00000400
#define OF_CANCEL           0x00000800
#define OF_CREATE           0x00001000
#define OF_PROMPT           0x00002000
#define OF_EXIST            0x00004000
#define OF_REOPEN           0x00008000

#define OFS_MAXPATHNAME 128
typedef struct _OFSTRUCT {
    BYTE cBytes;
    BYTE fFixedDisk;
    WORD nErrCode;
    WORD Reserved1;
    WORD Reserved2;
    CHAR szPathName[OFS_MAXPATHNAME];
} OFSTRUCT, *LPOFSTRUCT, *POFSTRUCT;

#define UnlockResource(hResData) ((hResData), 0)
#define MAXINTATOM 0xC000
#define MAKEINTATOM(i)  (LPTSTR)((ULONG_PTR)((WORD)(i)))
#define INVALID_ATOM ((ATOM)0)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

int
#if !defined(_MAC)
#if defined(_M_CEE_PURE)
__clrcall
else
__stdcall
#endif
else
CALLBACK
#endif
WinMain (
     HINSTANCE hInstance,
     HINSTANCE hPrevInstance,
     LPSTR lpCmdLine,
     int nShowCmd
    );

int
#if defined(_M_CEE_PURE)
__clrcall
else
__stdcall
#endif
wWinMain(
     HINSTANCE hInstance,
     HINSTANCE hPrevInstance,
     LPWSTR lpCmdLine,
     int nShowCmd
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


_Success_(return != NULL)
_Post_writable_byte_size_(dwBytes)
DECLSPEC_ALLOCATOR
HGLOBAL
__stdcall
GlobalAlloc(
     UINT uFlags,
     SIZE_T dwBytes
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP)


_Ret_reallocated_bytes_(hMem, dwBytes)
DECLSPEC_ALLOCATOR
HGLOBAL
__stdcall
GlobalReAlloc (
    _Frees_ptr_ HGLOBAL hMem,
     SIZE_T dwBytes,
     UINT uFlags
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


SIZE_T
__stdcall
GlobalSize (
     HGLOBAL hMem
    );


BOOL
__stdcall
GlobalUnlock(
     HGLOBAL hMem
    );



LPVOID
__stdcall
GlobalLock (
     HGLOBAL hMem
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


UINT
__stdcall
GlobalFlags (
     HGLOBAL hMem
    );



HGLOBAL
__stdcall
GlobalHandle (
     LPCVOID pMem
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)



_Success_(return==0)
HGLOBAL
__stdcall
GlobalFree(
    _Frees_ptr_opt_ HGLOBAL hMem
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


SIZE_T
__stdcall
GlobalCompact(
     DWORD dwMinFree
    );


VOID
__stdcall
GlobalFix(
     HGLOBAL hMem
    );


VOID
__stdcall
GlobalUnfix(
     HGLOBAL hMem
    );


LPVOID
__stdcall
GlobalWire(
     HGLOBAL hMem
    );


BOOL
__stdcall
GlobalUnWire(
     HGLOBAL hMem
    );

__drv_preferredFunction("GlobalMemoryStatusEx","Deprecated. See MSDN for details")

VOID
__stdcall
GlobalMemoryStatus(
     LPMEMORYSTATUS lpBuffer
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


_Success_(return != NULL)
_Post_writable_byte_size_(uBytes)
DECLSPEC_ALLOCATOR
HLOCAL
__stdcall
LocalAlloc(
     UINT uFlags,
     SIZE_T uBytes
    );


_Ret_reallocated_bytes_(hMem, uBytes)
DECLSPEC_ALLOCATOR
HLOCAL
__stdcall
LocalReAlloc(
    _Frees_ptr_opt_ HLOCAL hMem,
     SIZE_T uBytes,
     UINT uFlags
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)*/



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)



LPVOID
__stdcall
LocalLock(
     HLOCAL hMem
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then



HLOCAL
__stdcall
LocalHandle(
     LPCVOID pMem
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


BOOL
__stdcall
LocalUnlock(
     HLOCAL hMem
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


SIZE_T
__stdcall
LocalSize(
     HLOCAL hMem
    );


UINT
__stdcall
LocalFlags(
     HLOCAL hMem
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


_Success_(return==0)

HLOCAL
__stdcall
LocalFree(
    _Frees_ptr_opt_ HLOCAL hMem
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


SIZE_T
__stdcall
LocalShrink(
     HLOCAL hMem,
     UINT cbNewSize
    );


SIZE_T
__stdcall
LocalCompact(
     UINT uMinFree
    );

// GetBinaryType return values.

#define SCS_32BIT_BINARY    0
#define SCS_DOS_BINARY      1
#define SCS_WOW_BINARY      2
#define SCS_PIF_BINARY      3
#define SCS_POSIX_BINARY    4
#define SCS_OS216_BINARY    5
#define SCS_64BIT_BINARY    6

#if defined(_WIN64)
# define SCS_THIS_PLATFORM_BINARY SCS_64BIT_BINARY
else
# define SCS_THIS_PLATFORM_BINARY SCS_32BIT_BINARY
#endif


BOOL
__stdcall
GetBinaryTypeA(
      LPCSTR lpApplicationName,
     LPDWORD  lpBinaryType
    );

BOOL
__stdcall
GetBinaryTypeW(
      LPCWSTR lpApplicationName,
     LPDWORD  lpBinaryType
    );
#ifdef UNICODE
#define GetBinaryType  GetBinaryTypeW
else
#define GetBinaryType  GetBinaryTypeA
end  -- !UNICODE


_Success_(return != 0 && return < cchBuffer)
DWORD
__stdcall
GetShortPathNameA(
     LPCSTR lpszLongPath,
    _Out_writes_to_opt_(cchBuffer, return + 1) LPSTR  lpszShortPath,
     DWORD cchBuffer
    );
#ifndef UNICODE
#define GetShortPathName  GetShortPathNameA
#endif

#if _WIN32_WINNT >= 0x0600


_Success_(return != 0 && return < cchBuffer)
DWORD
__stdcall
GetLongPathNameTransactedA(
         LPCSTR lpszShortPath,
    _Out_writes_to_opt_(cchBuffer, return + 1) LPSTR  lpszLongPath,
         DWORD cchBuffer,
         HANDLE hTransaction
    );

_Success_(return != 0 && return < cchBuffer)
DWORD
__stdcall
GetLongPathNameTransactedW(
         LPCWSTR lpszShortPath,
    _Out_writes_to_opt_(cchBuffer, return + 1) LPWSTR  lpszLongPath,
         DWORD cchBuffer,
         HANDLE hTransaction
    );
#ifdef UNICODE
#define GetLongPathNameTransacted  GetLongPathNameTransactedW
else
#define GetLongPathNameTransacted  GetLongPathNameTransactedA
end  -- !UNICODE

end  -- _WIN32_WINNT >= 0x0600

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


BOOL
__stdcall
GetProcessAffinityMask(
      HANDLE hProcess,
     PDWORD_PTR lpProcessAffinityMask,
     PDWORD_PTR lpSystemAffinityMask
    );


BOOL
__stdcall
SetProcessAffinityMask(
     HANDLE hProcess,
     DWORD_PTR dwProcessAffinityMask
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


BOOL
__stdcall
GetProcessIoCounters(
      HANDLE hProcess,
     PIO_COUNTERS lpIoCounters
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


BOOL
__stdcall
GetProcessWorkingSetSize(
      HANDLE hProcess,
     PSIZE_T lpMinimumWorkingSetSize,
     PSIZE_T lpMaximumWorkingSetSize
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


BOOL
__stdcall
SetProcessWorkingSetSize(
     HANDLE hProcess,
     SIZE_T dwMinimumWorkingSetSize,
     SIZE_T dwMaximumWorkingSetSize
    );


__analysis_noreturn
VOID
__stdcall
FatalExit(
     int ExitCode
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


BOOL
__stdcall
SetEnvironmentStringsA(
     _Pre_ _NullNull_terminated_ LPCH NewEnvironment
    );
#ifndef UNICODE
#define SetEnvironmentStrings  SetEnvironmentStringsA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


#if(_WIN32_WINNT >= 0x0400)

//
// Fiber begin
//


#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

#define FIBER_FLAG_FLOAT_SWITCH 0x1     // context switch floating point


VOID
__stdcall
SwitchToFiber(
     LPVOID lpFiber
    );


VOID
__stdcall
DeleteFiber(
     LPVOID lpFiber
    );

#if (_WIN32_WINNT >= 0x0501)


BOOL
__stdcall
ConvertFiberToThread(
    VOID
    );

#endif



LPVOID
__stdcall
CreateFiberEx(
         SIZE_T dwStackCommitSize,
         SIZE_T dwStackReserveSize,
         DWORD dwFlags,
         LPFIBER_START_ROUTINE lpStartAddress,
     LPVOID lpParameter
    );



LPVOID
__stdcall
ConvertThreadToFiberEx(
     LPVOID lpParameter,
         DWORD dwFlags
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)



LPVOID
__stdcall
CreateFiber(
         SIZE_T dwStackSize,
         LPFIBER_START_ROUTINE lpStartAddress,
     LPVOID lpParameter
    );



LPVOID
__stdcall
ConvertThreadToFiber(
     LPVOID lpParameter
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


//
// Fiber end
//

//
// UMS begin
//


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

#if (_WIN32_WINNT >= 0x0601) && !defined(MIDL_PASS)

#define UMS_VERSION RTL_UMS_VERSION

typedef void *PUMS_CONTEXT;

typedef void *PUMS_COMPLETION_LIST;

typedef enum _RTL_UMS_THREAD_INFO_CLASS UMS_THREAD_INFO_CLASS, *PUMS_THREAD_INFO_CLASS;

typedef enum _RTL_UMS_SCHEDULER_REASON UMS_SCHEDULER_REASON;

typedef PRTL_UMS_SCHEDULER_ENTRY_POINT PUMS_SCHEDULER_ENTRY_POINT;

typedef struct _UMS_SCHEDULER_STARTUP_INFO {

    //
    // UMS Version the application was built to. Should be set to UMS_VERSION
    //
    ULONG UmsVersion;

    //
    // Completion List to associate the new User Scheduler to.
    //
    PUMS_COMPLETION_LIST CompletionList;

    //
    // A pointer to the application-defined function that represents the starting
    // address of the Sheduler.
    //
    PUMS_SCHEDULER_ENTRY_POINT SchedulerProc;

    //
    // pointer to a variable to be passed to the scheduler uppon first activation.
    //
    PVOID SchedulerParam;

} UMS_SCHEDULER_STARTUP_INFO, *PUMS_SCHEDULER_STARTUP_INFO;

typedef struct _UMS_SYSTEM_THREAD_INFORMATION {
    ULONG UmsVersion;
    union {
        struct {
            ULONG IsUmsSchedulerThread : 1;
            ULONG IsUmsWorkerThread : 1;
        } DUMMYSTRUCTNAME;
        ULONG ThreadUmsFlags;
    } DUMMYUNIONNAME;
} UMS_SYSTEM_THREAD_INFORMATION, *PUMS_SYSTEM_THREAD_INFORMATION;



BOOL
__stdcall
CreateUmsCompletionList(
     PUMS_COMPLETION_LIST* UmsCompletionList
    );


BOOL
__stdcall
DequeueUmsCompletionListItems(
     PUMS_COMPLETION_LIST UmsCompletionList,
     DWORD WaitTimeOut,
     PUMS_CONTEXT* UmsThreadList
    );


BOOL
__stdcall
GetUmsCompletionListEvent(
     PUMS_COMPLETION_LIST UmsCompletionList,
     PHANDLE UmsCompletionEvent
    );


BOOL
__stdcall
ExecuteUmsThread(
     PUMS_CONTEXT UmsThread
    );


BOOL
__stdcall
UmsThreadYield(
     PVOID SchedulerParam
    );


BOOL
__stdcall
DeleteUmsCompletionList(
     PUMS_COMPLETION_LIST UmsCompletionList
    );


PUMS_CONTEXT
__stdcall
GetCurrentUmsThread(
    VOID
    );


PUMS_CONTEXT
__stdcall
GetNextUmsListItem(
     PUMS_CONTEXT UmsContext
    );


BOOL
__stdcall
QueryUmsThreadInformation(
     PUMS_CONTEXT UmsThread,
     UMS_THREAD_INFO_CLASS UmsThreadInfoClass,
    _Out_writes_bytes_to_(UmsThreadInformationLength, *ReturnLength) PVOID UmsThreadInformation,
     ULONG UmsThreadInformationLength,
     PULONG ReturnLength
    );


BOOL
__stdcall
SetUmsThreadInformation(
     PUMS_CONTEXT UmsThread,
     UMS_THREAD_INFO_CLASS UmsThreadInfoClass,
     PVOID UmsThreadInformation,
     ULONG UmsThreadInformationLength
    );


BOOL
__stdcall
DeleteUmsThreadContext(
     PUMS_CONTEXT UmsThread
    );


BOOL
__stdcall
CreateUmsThreadContext(
     PUMS_CONTEXT *lpUmsThread
    );


BOOL
__stdcall
EnterUmsSchedulingMode(
     PUMS_SCHEDULER_STARTUP_INFO SchedulerStartupInfo
    );


BOOL
__stdcall
GetUmsSystemThreadInformation(
     HANDLE ThreadHandle,
     PUMS_SYSTEM_THREAD_INFORMATION SystemThreadInfo
    );

end  -- (_WIN32_WINNT >= 0x0601) && !defined(MIDL_PASS)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


//
// UMS end
//

#endif /* _WIN32_WINNT >= 0x0400 */


#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


DWORD_PTR
__stdcall
SetThreadAffinityMask(
     HANDLE hThread,
     DWORD_PTR dwThreadAffinityMask
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

#if (_WIN32_WINNT >= 0x0600)

#define PROCESS_DEP_ENABLE                          0x00000001
#define PROCESS_DEP_DISABLE_ATL_THUNK_EMULATION     0x00000002


BOOL
__stdcall
SetProcessDEPPolicy(
     DWORD dwFlags
    );


BOOL
__stdcall
GetProcessDEPPolicy(
     HANDLE hProcess,
     LPDWORD lpFlags,
     PBOOL lpPermanent
    );

end  -- _WIN32_WINNT >= 0x0600


BOOL
__stdcall
RequestWakeupLatency(
     LATENCY_TIME latency
    );


BOOL
__stdcall
IsSystemResumeAutomatic(
    VOID
    );


BOOL
__stdcall
GetThreadSelectorEntry(
      HANDLE hThread,
      DWORD dwSelector,
     LPLDT_ENTRY lpSelectorEntry
    );


EXECUTION_STATE
__stdcall
SetThreadExecutionState(
     EXECUTION_STATE esFlags
    );

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN7)

//
// Power Request APIs
//

typedef REASON_CONTEXT POWER_REQUEST_CONTEXT, *PPOWER_REQUEST_CONTEXT, *LPPOWER_REQUEST_CONTEXT;


HANDLE
__stdcall
PowerCreateRequest (
     PREASON_CONTEXT Context
    );


BOOL
__stdcall
PowerSetRequest (
     HANDLE PowerRequest,
     POWER_REQUEST_TYPE RequestType
    );


BOOL
__stdcall
PowerClearRequest (
     HANDLE PowerRequest,
     POWER_REQUEST_TYPE RequestType
    );

end  -- (_WIN32_WINNT >= _WIN32_WINNT_WIN7)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP)

#ifdef _M_CEE_PURE
#define GetLastError System::Runtime::InteropServices::Marshal::GetLastWin32Error
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

#if !defined(RC_INVOKED) // RC warns because "WINBASE_DECLARE_RESTORE_LAST_ERROR" is a bit long.
//#if _WIN32_WINNT >= 0x0501 || defined(WINBASE_DECLARE_RESTORE_LAST_ERROR)
#if defined(WINBASE_DECLARE_RESTORE_LAST_ERROR)


VOID
__stdcall
RestoreLastError(
     DWORD dwErrCode
    );

typedef VOID (__stdcall* PRESTORE_LAST_ERROR)(DWORD);
#define RESTORE_LAST_ERROR_NAME_A      "RestoreLastError"
#define RESTORE_LAST_ERROR_NAME_W     L"RestoreLastError"
#define RESTORE_LAST_ERROR_NAME   TEXT("RestoreLastError")

#endif
#endif

#define HasOverlappedIoCompleted(lpOverlapped) (((DWORD)(lpOverlapped)->Internal) != STATUS_PENDING)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

#if (_WIN32_WINNT >= 0x0600)

//
// The following flags allows an application to change
// the semantics of IO completion notification.
//

//
// Don't queue an entry to an associated completion port if returning success
// synchronously.
//
#define FILE_SKIP_COMPLETION_PORT_ON_SUCCESS    0x1

//
// Don't set the file handle event on IO completion.
//
#define FILE_SKIP_SET_EVENT_ON_HANDLE           0x2


BOOL
__stdcall
SetFileCompletionNotificationModes(
     HANDLE FileHandle,
     UCHAR Flags
    );

end  -- _WIN32_WINNT >= 0x0600

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

#define SEM_FAILCRITICALERRORS      0x0001
#define SEM_NOGPFAULTERRORBOX       0x0002
#define SEM_NOALIGNMENTFAULTEXCEPT  0x0004
#define SEM_NOOPENFILEERRORBOX      0x8000

#if !defined(MIDL_PASS)

#if (_WIN32_WINNT >= 0x0600)


BOOL
__stdcall
Wow64GetThreadContext(
        HANDLE hThread,
     PWOW64_CONTEXT lpContext
    );


BOOL
__stdcall
Wow64SetThreadContext(
     HANDLE hThread,
     const WOW64_CONTEXT *lpContext
    );

end  -- (_WIN32_WINNT >= 0x0600)

#if (_WIN32_WINNT >= 0x0601)


BOOL
__stdcall
Wow64GetThreadSelectorEntry(
     HANDLE hThread,
     DWORD dwSelector,
     PWOW64_LDT_ENTRY lpSelectorEntry
    );

end  -- (_WIN32_WINNT >= 0x0601)

end  -- !defined(MIDL_PASS)

#if (_WIN32_WINNT >= 0x0600)


DWORD
__stdcall
Wow64SuspendThread(
     HANDLE hThread
    );

end  -- (_WIN32_WINNT >= 0x0600)


BOOL
__stdcall
DebugSetProcessKillOnExit(
     BOOL KillOnExit
    );


BOOL
__stdcall
DebugBreakProcess (
     HANDLE Process
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP)

#if (_WIN32_WINNT >= 0x0403)
#define CRITICAL_SECTION_NO_DEBUG_INFO  RTL_CRITICAL_SECTION_FLAG_NO_DEBUG_INFO
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


BOOL
__stdcall
PulseEvent(
     HANDLE hEvent
    );


ATOM
__stdcall
GlobalDeleteAtom(
     ATOM nAtom
    );


BOOL
__stdcall
InitAtomTable(
     DWORD nSize
    );


ATOM
__stdcall
DeleteAtom(
     ATOM nAtom
    );


UINT
__stdcall
SetHandleCount(
     UINT uNumber
    );


BOOL
__stdcall
RequestDeviceWakeup(
     HANDLE hDevice
    );


BOOL
__stdcall
CancelDeviceWakeupRequest(
     HANDLE hDevice
    );


BOOL
__stdcall
GetDevicePowerState(
      HANDLE hDevice,
     BOOL *pfOn
    );


BOOL
__stdcall
SetMessageWaitingIndicator(
     HANDLE hMsgIndicator,
     ULONG ulMsgCount
    );



BOOL
__stdcall
SetFileShortNameA(
     HANDLE hFile,
     LPCSTR lpShortName
    );

BOOL
__stdcall
SetFileShortNameW(
     HANDLE hFile,
     LPCWSTR lpShortName
    );
#ifdef UNICODE
#define SetFileShortName  SetFileShortNameW
else
#define SetFileShortName  SetFileShortNameA
end  -- !UNICODE

#define HANDLE_FLAG_INHERIT             0x00000001
#define HANDLE_FLAG_PROTECT_FROM_CLOSE  0x00000002

#define HINSTANCE_ERROR 32


DWORD
__stdcall
LoadModule(
     LPCSTR lpModuleName,
     LPVOID lpParameterBlock
    );


__drv_preferredFunction("CreateProcess","Deprecated. See MSDN for details")

UINT
__stdcall
WinExec(
     LPCSTR lpCmdLine,
     UINT uCmdShow
    );


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


 or OneCore or App Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM | WINAPI_PARTITION_APP)


BOOL
__stdcall
ClearCommBreak(
     HANDLE hFile
    );


BOOL
__stdcall
ClearCommError(
          HANDLE hFile,
     LPDWORD lpErrors,
     LPCOMSTAT lpStat
    );


BOOL
__stdcall
SetupComm(
     HANDLE hFile,
     DWORD dwInQueue,
     DWORD dwOutQueue
    );


BOOL
__stdcall
EscapeCommFunction(
     HANDLE hFile,
     DWORD dwFunc
    );



BOOL
__stdcall
GetCommConfig(
          HANDLE hCommDev,
    _Out_writes_bytes_opt_(*lpdwSize) LPCOMMCONFIG lpCC,
       LPDWORD lpdwSize
    );


BOOL
__stdcall
GetCommMask(
      HANDLE hFile,
     LPDWORD lpEvtMask
    );


BOOL
__stdcall
GetCommProperties(
        HANDLE hFile,
     LPCOMMPROP lpCommProp
    );


BOOL
__stdcall
GetCommModemStatus(
      HANDLE hFile,
     LPDWORD lpModemStat
    );


BOOL
__stdcall
GetCommState(
      HANDLE hFile,
     LPDCB lpDCB
    );


BOOL
__stdcall
GetCommTimeouts(
      HANDLE hFile,
     LPCOMMTIMEOUTS lpCommTimeouts
    );


BOOL
__stdcall
PurgeComm(
     HANDLE hFile,
     DWORD dwFlags
    );


BOOL
__stdcall
SetCommBreak(
     HANDLE hFile
    );


BOOL
__stdcall
SetCommConfig(
     HANDLE hCommDev,
     LPCOMMCONFIG lpCC,
     DWORD dwSize
    );


BOOL
__stdcall
SetCommMask(
     HANDLE hFile,
     DWORD dwEvtMask
    );


BOOL
__stdcall
SetCommState(
     HANDLE hFile,
     LPDCB lpDCB
    );


BOOL
__stdcall
SetCommTimeouts(
     HANDLE hFile,
     LPCOMMTIMEOUTS lpCommTimeouts
    );


BOOL
__stdcall
TransmitCommChar(
     HANDLE hFile,
     char cChar
    );


BOOL
__stdcall
WaitCommEvent(
            HANDLE hFile,
         LPDWORD lpEvtMask,
     LPOVERLAPPED lpOverlapped
    );


#if (NTDDI_VERSION >= NTDDI_WIN10_RS3)


HANDLE
__stdcall
OpenCommPort(
     ULONG uPortNumber,
     DWORD dwDesiredAccess,
     DWORD dwFlagsAndAttributes
    );

end  -- (NTDDI_VERSION >= NTDDI_WIN10_RS3)

#if (NTDDI_VERSION >= NTDDI_WIN10_RS3) // NTDDI_WIN10_RS4NTDDI_WIN10_RS4


ULONG
__stdcall
GetCommPorts(
    _Out_writes_(uPortNumbersCount) PULONG lpPortNumbers,
                                ULONG uPortNumbersCount,
                               PULONG puPortNumbersFound
    );

end  -- (NTDDI_VERSION >= NTDDI_WIN10_RS3) // NTDDI_WIN10_RS4NTDDI_WIN10_RS4

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM | WINAPI_PARTITION_APP) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


DWORD
__stdcall
SetTapePosition(
     HANDLE hDevice,
     DWORD dwPositionMethod,
     DWORD dwPartition,
     DWORD dwOffsetLow,
     DWORD dwOffsetHigh,
     BOOL bImmediate
    );


DWORD
__stdcall
GetTapePosition(
      HANDLE hDevice,
      DWORD dwPositionType,
     LPDWORD lpdwPartition,
     LPDWORD lpdwOffsetLow,
     LPDWORD lpdwOffsetHigh
    );


DWORD
__stdcall
PrepareTape(
     HANDLE hDevice,
     DWORD dwOperation,
     BOOL bImmediate
    );


DWORD
__stdcall
EraseTape(
     HANDLE hDevice,
     DWORD dwEraseType,
     BOOL bImmediate
    );


DWORD
__stdcall
CreateTapePartition(
     HANDLE hDevice,
     DWORD dwPartitionMethod,
     DWORD dwCount,
     DWORD dwSize
    );


DWORD
__stdcall
WriteTapemark(
     HANDLE hDevice,
     DWORD dwTapemarkType,
     DWORD dwTapemarkCount,
     BOOL bImmediate
    );


DWORD
__stdcall
GetTapeStatus(
     HANDLE hDevice
    );


DWORD
__stdcall
GetTapeParameters(
        HANDLE hDevice,
        DWORD dwOperation,
     LPDWORD lpdwSize,
    _Out_writes_bytes_(*lpdwSize) LPVOID lpTapeInformation
    );

#define GET_TAPE_MEDIA_INFORMATION 0
#define GET_TAPE_DRIVE_INFORMATION 1


DWORD
__stdcall
SetTapeParameters(
     HANDLE hDevice,
     DWORD dwOperation,
     LPVOID lpTapeInformation
    );

#define SET_TAPE_MEDIA_INFORMATION 0
#define SET_TAPE_DRIVE_INFORMATION 1

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


int
__stdcall
MulDiv(
     int nNumber,
     int nNumerator,
     int nDenominator
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

typedef enum _DEP_SYSTEM_POLICY_TYPE {
    DEPPolicyAlwaysOff = 0,
    DEPPolicyAlwaysOn,
    DEPPolicyOptIn,
    DEPPolicyOptOut,
    DEPTotalPolicyCount
} DEP_SYSTEM_POLICY_TYPE;

#if (NTDDI_VERSION >= NTDDI_WINXPSP3)


DEP_SYSTEM_POLICY_TYPE
__stdcall
GetSystemDEPPolicy(
    VOID
    );

end  -- (NTDDI_VERSION >= NTDDI_WINXPSP3)

#if _WIN32_WINNT >= 0x0501


BOOL
__stdcall
GetSystemRegistryQuota(
     PDWORD pdwQuotaAllowed,
     PDWORD pdwQuotaUsed
    );

end  -- (_WIN32_WINNT >= 0x0501)

//
// Routines to convert back and forth between system time and file time
//


BOOL
__stdcall
FileTimeToDosDateTime(
      const FILETIME *lpFileTime,
     LPWORD lpFatDate,
     LPWORD lpFatTime
    );


BOOL
__stdcall
DosDateTimeToFileTime(
      WORD wFatDate,
      WORD wFatTime,
     LPFILETIME lpFileTime
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

//
// FORMAT_MESSAGE_ALLOCATE_BUFFER requires use of HeapFree
//

#define FORMAT_MESSAGE_ALLOCATE_BUFFER 0x00000100

#if !defined(MIDL_PASS)

_Success_(return != 0)
DWORD
__stdcall
FormatMessageA(
         DWORD dwFlags,
     LPCVOID lpSource,
         DWORD dwMessageId,
         DWORD dwLanguageId,
    _When_((dwFlags & FORMAT_MESSAGE_ALLOCATE_BUFFER) != 0, _At_((LPSTR*)lpBuffer, _Outptr_result_z_))
    _When_((dwFlags & FORMAT_MESSAGE_ALLOCATE_BUFFER) == 0, _Out_writes_z_(nSize))
             LPSTR lpBuffer,
         DWORD nSize,
     va_list *Arguments
    );

_Success_(return != 0)
DWORD
__stdcall
FormatMessageW(
         DWORD dwFlags,
     LPCVOID lpSource,
         DWORD dwMessageId,
         DWORD dwLanguageId,
    _When_((dwFlags & FORMAT_MESSAGE_ALLOCATE_BUFFER) != 0, _At_((LPWSTR*)lpBuffer, _Outptr_result_z_))
    _When_((dwFlags & FORMAT_MESSAGE_ALLOCATE_BUFFER) == 0, _Out_writes_z_(nSize))
             LPWSTR lpBuffer,
         DWORD nSize,
     va_list *Arguments
    );
#ifdef UNICODE
#define FormatMessage  FormatMessageW
else
#define FormatMessage  FormatMessageA
end  -- !UNICODE

#if defined(_M_CEE)
#undef FormatMessage
__inline
DWORD
FormatMessage(
    DWORD dwFlags,
    LPCVOID lpSource,
    DWORD dwMessageId,
    DWORD dwLanguageId,
    LPTSTR lpBuffer,
    DWORD nSize,
    va_list *Arguments
    )
{
#ifdef UNICODE
    return FormatMessageW(
else
    return FormatMessageA(
#endif
        dwFlags,
        lpSource,
        dwMessageId,
        dwLanguageId,
        lpBuffer,
        nSize,
        Arguments
        );
}
#endif  /* _M_CEE */
#endif  /* MIDL_PASS */

#define FORMAT_MESSAGE_IGNORE_INSERTS  0x00000200
#define FORMAT_MESSAGE_FROM_STRING     0x00000400
#define FORMAT_MESSAGE_FROM_HMODULE    0x00000800
#define FORMAT_MESSAGE_FROM_SYSTEM     0x00001000
#define FORMAT_MESSAGE_ARGUMENT_ARRAY  0x00002000
#define FORMAT_MESSAGE_MAX_WIDTH_MASK  0x000000FF

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then



HANDLE
__stdcall
CreateMailslotA(
         LPCSTR lpName,
         DWORD nMaxMessageSize,
         DWORD lReadTimeout,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );

HANDLE
__stdcall
CreateMailslotW(
         LPCWSTR lpName,
         DWORD nMaxMessageSize,
         DWORD lReadTimeout,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
#ifdef UNICODE
#define CreateMailslot  CreateMailslotW
else
#define CreateMailslot  CreateMailslotA
end  -- !UNICODE


BOOL
__stdcall
GetMailslotInfo(
          HANDLE hMailslot,
     LPDWORD lpMaxMessageSize,
     LPDWORD lpNextSize,
     LPDWORD lpMessageCount,
     LPDWORD lpReadTimeout
    );


BOOL
__stdcall
SetMailslotInfo(
     HANDLE hMailslot,
     DWORD lReadTimeout
    );

//
// File Encryption API
//


BOOL
__stdcall
EncryptFileA(
     LPCSTR lpFileName
    );

BOOL
__stdcall
EncryptFileW(
     LPCWSTR lpFileName
    );
#ifdef UNICODE
#define EncryptFile  EncryptFileW
else
#define EncryptFile  EncryptFileA
end  -- !UNICODE


BOOL
__stdcall
DecryptFileA(
           LPCSTR lpFileName,
     DWORD dwReserved
    );

BOOL
__stdcall
DecryptFileW(
           LPCWSTR lpFileName,
     DWORD dwReserved
    );
#ifdef UNICODE
#define DecryptFile  DecryptFileW
else
#define DecryptFile  DecryptFileA
end  -- !UNICODE

//
//  Encryption Status Value
//

#define FILE_ENCRYPTABLE                0
#define FILE_IS_ENCRYPTED               1
#define FILE_SYSTEM_ATTR                2
#define FILE_ROOT_DIR                   3
#define FILE_SYSTEM_DIR                 4
#define FILE_UNKNOWN                    5
#define FILE_SYSTEM_NOT_SUPPORT         6
#define FILE_USER_DISALLOWED            7
#define FILE_READ_ONLY                  8
#define FILE_DIR_DISALLOWED             9


BOOL
__stdcall
FileEncryptionStatusA(
      LPCSTR lpFileName,
     LPDWORD  lpStatus
    );

BOOL
__stdcall
FileEncryptionStatusW(
      LPCWSTR lpFileName,
     LPDWORD  lpStatus
    );
#ifdef UNICODE
#define FileEncryptionStatus  FileEncryptionStatusW
else
#define FileEncryptionStatus  FileEncryptionStatusA
end  -- !UNICODE

//
// Currently defined recovery flags
//

#define EFS_USE_RECOVERY_KEYS  (0x1)

typedef
DWORD
(__stdcall *PFE_EXPORT_FUNC)(
    _In_reads_bytes_(ulLength) PBYTE pbData,
     PVOID pvCallbackContext,
         ULONG ulLength
    );

typedef
DWORD
(__stdcall *PFE_IMPORT_FUNC)(
    _Out_writes_bytes_to_(*ulLength, *ulLength) PBYTE pbData,
     PVOID pvCallbackContext,
      PULONG ulLength
    );


//
//  OpenRaw flag values
//

#define CREATE_FOR_IMPORT              = (1);
#define CREATE_FOR_DIR                 = (2);
#define OVERWRITE_HIDDEN               = (4);
#define EFSRPC_SECURE_ONLY             = (8);
#define EFS_DROP_ALTERNATE_STREAMS     = (0x10);


ffi.cdef[[
DWORD
__stdcall
OpenEncryptedFileRawA(
            LPCSTR lpFileName,
            ULONG    ulFlags,
     PVOID   *pvContext
    );

DWORD
__stdcall
OpenEncryptedFileRawW(
            LPCWSTR lpFileName,
            ULONG    ulFlags,
     PVOID   *pvContext
    );
]]

--[[
#ifdef UNICODE
#define OpenEncryptedFileRaw  OpenEncryptedFileRawW
else
#define OpenEncryptedFileRaw  OpenEncryptedFileRawA
end  -- !UNICODE
--]]

ffi.cdef[[
DWORD
__stdcall
ReadEncryptedFileRaw(
         PFE_EXPORT_FUNC pfExportCallback,
     PVOID           pvCallbackContext,
         PVOID           pvContext
    );


DWORD
__stdcall
WriteEncryptedFileRaw(
         PFE_IMPORT_FUNC pfImportCallback,
     PVOID           pvCallbackContext,
         PVOID           pvContext
    );


VOID
__stdcall
CloseEncryptedFileRaw(
     PVOID           pvContext
    );
]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


//
// _l Compat Functions
//


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
int
__stdcall
lstrcmpA(
     LPCSTR lpString1,
     LPCSTR lpString2
    );

int
__stdcall
lstrcmpW(
     LPCWSTR lpString1,
     LPCWSTR lpString2
    );
]]

--[[
#ifdef UNICODE
#define lstrcmp  lstrcmpW
else
#define lstrcmp  lstrcmpA
end  -- !UNICODE
--]]

ffi.cdef[[
int
__stdcall
lstrcmpiA(
     LPCSTR lpString1,
     LPCSTR lpString2
    );

int
__stdcall
lstrcmpiW(
     LPCWSTR lpString1,
     LPCWSTR lpString2
    );
]]

--[[
#ifdef UNICODE
#define lstrcmpi  lstrcmpiW
else
#define lstrcmpi  lstrcmpiA
end  -- !UNICODE
--]]



ffi.cdef[[
LPSTR
__stdcall
lstrcpynA(
     LPSTR lpString1,
     LPCSTR lpString2,
     int iMaxLength
    );
]]

ffi.cdef[[
LPWSTR
__stdcall
lstrcpynW(
     LPWSTR lpString1,
     LPCWSTR lpString2,
     int iMaxLength
    );
]]

--[[
#ifdef UNICODE
#define lstrcpyn  lstrcpynW
else
#define lstrcpyn  lstrcpynA
end  -- !UNICODE
--]]

ffi.cdef[[
LPSTR
__stdcall
lstrcpyA(
     LPSTR lpString1, // deprecated: annotation is as good as it gets
      LPCSTR lpString2
    );

LPWSTR
__stdcall
lstrcpyW(
     LPWSTR lpString1, // deprecated: annotation is as good as it gets
      LPCWSTR lpString2
    );
]]

--[[
#ifdef UNICODE
#define lstrcpy  lstrcpyW
else
#define lstrcpy  lstrcpyA
end  -- !UNICODE
--]]

ffi.cdef[[
LPSTR
__stdcall
lstrcatA(
    _Inout_updates_z_(_String_length_(lpString1) + _String_length_(lpString2) + 1) LPSTR lpString1, // deprecated: annotation is as good as it gets
        LPCSTR lpString2
    );

LPWSTR
__stdcall
lstrcatW(
    _Inout_updates_z_(_String_length_(lpString1) + _String_length_(lpString2) + 1) LPWSTR lpString1, // deprecated: annotation is as good as it gets
        LPCWSTR lpString2
    );
]]

--[[
#ifdef UNICODE
#define lstrcat  lstrcatW
else
#define lstrcat  lstrcatA
end  -- !UNICODE
--]]



ffi.cdef[[
int
__stdcall
lstrlenA(
     LPCSTR lpString
    );

int
__stdcall
lstrlenW(
     LPCWSTR lpString
    );
]]

--[[
#ifdef UNICODE
#define lstrlen  lstrlenW
else
#define lstrlen  lstrlenA
end  -- !UNICODE
--]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

ffi.cdef[[
HFILE
__stdcall
OpenFile(
        LPCSTR lpFileName,
     LPOFSTRUCT lpReOpenBuff,
        UINT uStyle
    );


HFILE
__stdcall
_lopen(
     LPCSTR lpPathName,
     int iReadWrite
    );


HFILE
__stdcall
_lcreat(
     LPCSTR lpPathName,
     int  iAttribute
    );


UINT
__stdcall
_lread(
     HFILE hFile,
     LPVOID lpBuffer,
     UINT uBytes
    );


UINT
__stdcall
_lwrite(
     HFILE hFile,
     LPCCH lpBuffer,
     UINT uBytes
    );


long
__stdcall
_hread(
     HFILE hFile,
     LPVOID lpBuffer,
     long lBytes
    );


long
__stdcall
_hwrite(
     HFILE hFile,
     LPCCH lpBuffer,
     long lBytes
    );


HFILE
__stdcall
_lclose(
     HFILE hFile
    );


LONG
__stdcall
_llseek(
     HFILE hFile,
     LONG lOffset,
     int iOrigin
    );


BOOL
__stdcall
IsTextUnicode(
     const VOID* lpv,
            int iSize,
     LPINT lpiResult
    );
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

if(_WIN32_WINNT >= 0x0400) then
ffi.cdef[[
DWORD
__stdcall
SignalObjectAndWait(
     HANDLE hObjectToSignal,
     HANDLE hObjectToWaitOn,
     DWORD dwMilliseconds,
     BOOL bAlertable
    );
]]
end --/* _WIN32_WINNT >= 0x0400 */

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

ffi.cdef[[
BOOL
__stdcall
BackupRead(
        HANDLE hFile,
     LPBYTE lpBuffer,
        DWORD nNumberOfBytesToRead,
       LPDWORD lpNumberOfBytesRead,
        BOOL bAbort,
        BOOL bProcessSecurity,
     LPVOID *lpContext
    );


BOOL
__stdcall
BackupSeek(
        HANDLE hFile,
        DWORD  dwLowBytesToSeek,
        DWORD  dwHighBytesToSeek,
       LPDWORD lpdwLowByteSeeked,
       LPDWORD lpdwHighByteSeeked,
     LPVOID *lpContext
    );


BOOL
__stdcall
BackupWrite(
        HANDLE hFile,
     LPBYTE lpBuffer,
        DWORD nNumberOfBytesToWrite,
       LPDWORD lpNumberOfBytesWritten,
        BOOL bAbort,
        BOOL bProcessSecurity,
     LPVOID *lpContext
    );

//
//  Stream id structure
//
typedef struct _WIN32_STREAM_ID {
        DWORD          dwStreamId ;
        DWORD          dwStreamAttributes ;
        LARGE_INTEGER  Size ;
        DWORD          dwStreamNameSize ;
        WCHAR          cStreamName[ ANYSIZE_ARRAY ] ;
} WIN32_STREAM_ID, *LPWIN32_STREAM_ID ;
]]

ffi.cdef[[
//
//  Stream Ids
//

static const int BACKUP_INVALID         = 0x00000000;
static const int BACKUP_DATA            = 0x00000001;
static const int BACKUP_EA_DATA         = 0x00000002;
static const int BACKUP_SECURITY_DATA   = 0x00000003;
static const int BACKUP_ALTERNATE_DATA  = 0x00000004;
static const int BACKUP_LINK            = 0x00000005;
static const int BACKUP_PROPERTY_DATA   = 0x00000006;
static const int BACKUP_OBJECT_ID       = 0x00000007;
static const int BACKUP_REPARSE_DATA    = 0x00000008;
static const int BACKUP_SPARSE_BLOCK    = 0x00000009;
static const int BACKUP_TXFS_DATA       = 0x0000000a;
static const int BACKUP_GHOSTED_FILE_EXTENTS =0x0000000b;

//
//  Stream Attributes
//

static const int STREAM_NORMAL_ATTRIBUTE        = 0x00000000;
static const int STREAM_MODIFIED_WHEN_READ      = 0x00000001;
static const int STREAM_CONTAINS_SECURITY       = 0x00000002;
static const int STREAM_CONTAINS_PROPERTIES     = 0x00000004;
static const int STREAM_SPARSE_ATTRIBUTE        = 0x00000008;
static const int STREAM_CONTAINS_GHOSTED_FILE_EXTENTS =0x00000010;

//
// Dual Mode API below this line. Dual Mode Structures also included.
//

static const int STARTF_USESHOWWINDOW      = 0x00000001;
static const int STARTF_USESIZE            = 0x00000002;
static const int STARTF_USEPOSITION        = 0x00000004;
static const int STARTF_USECOUNTCHARS      = 0x00000008;
static const int STARTF_USEFILLATTRIBUTE   = 0x00000010;
static const int STARTF_RUNFULLSCREEN      = 0x00000020;  // ignored for non-x86 platforms
static const int STARTF_FORCEONFEEDBACK    = 0x00000040;
static const int STARTF_FORCEOFFFEEDBACK   = 0x00000080;
static const int STARTF_USESTDHANDLES      = 0x00000100;
]]

if(WINVER >= 0x0400) then
ffi.cdef[[
static const int STARTF_USEHOTKEY          = 0x00000200;
static const int STARTF_TITLEISLINKNAME    = 0x00000800;
static const int STARTF_TITLEISAPPID       = 0x00001000;
static const int STARTF_PREVENTPINNING     = 0x00002000;
]]
end  --/* WINVER >= 0x0400 */

if(WINVER >= 0x0600) then
ffi.cdef[[
static const int STARTF_UNTRUSTEDSOURCE    = 0x00008000;
]]
end --/* WINVER >= 0x0600 */

if (_WIN32_WINNT >= 0x0600) then
ffi.cdef[[
typedef struct _STARTUPINFOEXA {
    STARTUPINFOA StartupInfo;
    LPPROC_THREAD_ATTRIBUTE_LIST lpAttributeList;
} STARTUPINFOEXA, *LPSTARTUPINFOEXA;
typedef struct _STARTUPINFOEXW {
    STARTUPINFOW StartupInfo;
    LPPROC_THREAD_ATTRIBUTE_LIST lpAttributeList;
} STARTUPINFOEXW, *LPSTARTUPINFOEXW;
]]

--[[
if UNICODE then
typedef STARTUPINFOEXW STARTUPINFOEX;
typedef LPSTARTUPINFOEXW LPSTARTUPINFOEX;
else
typedef STARTUPINFOEXA STARTUPINFOEX;
typedef LPSTARTUPINFOEXA LPSTARTUPINFOEX;
end  -- UNICODE
--]]

end  -- (_WIN32_WINNT >= 0x0600)

static const int SHUTDOWN_NORETRY              =  0x00000001;

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then


ffi.cdef[[
HANDLE
__stdcall
OpenMutexA(
     DWORD dwDesiredAccess,
     BOOL bInheritHandle,
     LPCSTR lpName
    );
]]

--[[
#ifndef UNICODE
#define OpenMutex  OpenMutexA
#endif
--]]

ffi.cdef[[
HANDLE
__stdcall
CreateSemaphoreA(
     LPSECURITY_ATTRIBUTES lpSemaphoreAttributes,
         LONG lInitialCount,
         LONG lMaximumCount,
     LPCSTR lpName
    );
]]

--[[
#ifndef UNICODE
#define CreateSemaphore  CreateSemaphoreA
#endif
--]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


ffi.cdef[[
HANDLE
__stdcall
OpenSemaphoreA(
     DWORD dwDesiredAccess,
     BOOL bInheritHandle,
     LPCSTR lpName
    );
]]

--[[
#ifndef UNICODE
#define OpenSemaphore  OpenSemaphoreA
#endif
--]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


if (_WIN32_WINNT >= 0x0400) or (_WIN32_WINDOWS > 0x0400) then


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then


ffi.cdef[[
HANDLE
__stdcall
CreateWaitableTimerA(
     LPSECURITY_ATTRIBUTES lpTimerAttributes,
         BOOL bManualReset,
     LPCSTR lpTimerName
    );
]]

--[[
#ifndef UNICODE
#define CreateWaitableTimer  CreateWaitableTimerA
#endif
--]]

ffi.cdef[[
HANDLE
__stdcall
OpenWaitableTimerA(
     DWORD dwDesiredAccess,
     BOOL bInheritHandle,
     LPCSTR lpTimerName
    );
]]

--[[
#ifndef UNICODE
#define OpenWaitableTimer  OpenWaitableTimerA
#endif
--]]

if (_WIN32_WINNT >= 0x0600) then


ffi.cdef[[
HANDLE
__stdcall
CreateSemaphoreExA(
        LPSECURITY_ATTRIBUTES lpSemaphoreAttributes,
            LONG lInitialCount,
            LONG lMaximumCount,
        LPCSTR lpName,
      DWORD dwFlags,
            DWORD dwDesiredAccess
    );
]]

#ifndef UNICODE
#define CreateSemaphoreEx  CreateSemaphoreExA
#endif



HANDLE
__stdcall
CreateWaitableTimerExA(
     LPSECURITY_ATTRIBUTES lpTimerAttributes,
     LPCSTR lpTimerName,
         DWORD dwFlags,
         DWORD dwDesiredAccess
    );
#ifndef UNICODE
#define CreateWaitableTimerEx  CreateWaitableTimerExA
#endif

#endif /* (_WIN32_WINNT >= 0x0600) */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */

#endif /* (_WIN32_WINNT >= 0x0400) || (_WIN32_WINDOWS > 0x0400) */




if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then



HANDLE
__stdcall
CreateFileMappingA(
         HANDLE hFile,
     LPSECURITY_ATTRIBUTES lpFileMappingAttributes,
         DWORD flProtect,
         DWORD dwMaximumSizeHigh,
         DWORD dwMaximumSizeLow,
     LPCSTR lpName
    );
#ifndef UNICODE
#define CreateFileMapping  CreateFileMappingA
#endif

#if _WIN32_WINNT >= 0x0600



HANDLE
__stdcall
CreateFileMappingNumaA(
         HANDLE hFile,
     LPSECURITY_ATTRIBUTES lpFileMappingAttributes,
         DWORD flProtect,
         DWORD dwMaximumSizeHigh,
         DWORD dwMaximumSizeLow,
     LPCSTR lpName,
         DWORD nndPreferred
    );

#ifndef UNICODE
#define CreateFileMappingNuma  CreateFileMappingNumaA
#endif

end  -- _WIN32_WINNT >= 0x0600


HANDLE
__stdcall
OpenFileMappingA(
     DWORD dwDesiredAccess,
     BOOL bInheritHandle,
     LPCSTR lpName
    );
#ifndef UNICODE
#define OpenFileMapping  OpenFileMappingA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


_Success_(return != 0 && return <= nBufferLength)
DWORD
__stdcall
GetLogicalDriveStringsA(
     DWORD nBufferLength,
    _Out_writes_to_opt_(nBufferLength, return + 1) LPSTR lpBuffer
    );
#ifndef UNICODE
#define GetLogicalDriveStrings  GetLogicalDriveStringsA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

#if (_WIN32_WINNT >= 0x0602)


ffi.cdef[[
HMODULE
__stdcall
LoadPackagedLibrary (
           LPCWSTR lpwLibFileName,
     DWORD Reserved
    );
]]
end  -- _WIN32_WINNT >= 0x0602

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


if (_WIN32_WINNT >= 0x0600) then

//
// Supported process protection levels.
//

#define PROTECTION_LEVEL_WINTCB_LIGHT       0x00000000
#define PROTECTION_LEVEL_WINDOWS            0x00000001
#define PROTECTION_LEVEL_WINDOWS_LIGHT      0x00000002
#define PROTECTION_LEVEL_ANTIMALWARE_LIGHT  0x00000003
#define PROTECTION_LEVEL_LSA_LIGHT          0x00000004

//
// The following protection levels are supplied for testing only (no win32
// callers need these).
//

#define PROTECTION_LEVEL_WINTCB             0x00000005
#define PROTECTION_LEVEL_CODEGEN_LIGHT      0x00000006
#define PROTECTION_LEVEL_AUTHENTICODE       0x00000007
#define PROTECTION_LEVEL_PPL_APP            0x00000008

#define PROTECTION_LEVEL_SAME               0xFFFFFFFF

//
// The following is only used as a value for ProtectionLevel
// when querying ProcessProtectionLevelInfo in GetProcessInformation.
//
#define PROTECTION_LEVEL_NONE               0xFFFFFFFE

end  -- _WIN32_WINNT >= 0x0600


#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

#if (_WIN32_WINNT >= 0x0600)

#define PROCESS_NAME_NATIVE     0x00000001


BOOL
__stdcall
QueryFullProcessImageNameA(
     HANDLE hProcess,
     DWORD dwFlags,
    _Out_writes_to_(*lpdwSize, *lpdwSize) LPSTR lpExeName,
     PDWORD lpdwSize
    );

BOOL
__stdcall
QueryFullProcessImageNameW(
     HANDLE hProcess,
     DWORD dwFlags,
    _Out_writes_to_(*lpdwSize, *lpdwSize) LPWSTR lpExeName,
     PDWORD lpdwSize
    );
#ifdef UNICODE
#define QueryFullProcessImageName  QueryFullProcessImageNameW
else
#define QueryFullProcessImageName  QueryFullProcessImageNameA
end  -- !UNICODE

end  -- _WIN32_WINNT >= 0x0600

#if (_WIN32_WINNT >= 0x0600)

//
// Extended process and thread attribute support
//

#define PROC_THREAD_ATTRIBUTE_NUMBER    0x0000FFFF
#define PROC_THREAD_ATTRIBUTE_THREAD    0x00010000  // Attribute may be used with thread creation
#define PROC_THREAD_ATTRIBUTE_INPUT     0x00020000  // Attribute is input only
#define PROC_THREAD_ATTRIBUTE_ADDITIVE  0x00040000  // Attribute may be "accumulated," e.g. bitmasks, counters, etc.


#ifndef _USE_FULL_PROC_THREAD_ATTRIBUTE
typedef enum _PROC_THREAD_ATTRIBUTE_NUM {
    ProcThreadAttributeParentProcess                = 0,
    ProcThreadAttributeHandleList                   = 2,
#if (_WIN32_WINNT >= _WIN32_WINNT_WIN7)
    ProcThreadAttributeGroupAffinity                = 3,
    ProcThreadAttributePreferredNode                = 4,
    ProcThreadAttributeIdealProcessor               = 5,
    ProcThreadAttributeUmsThread                    = 6,
    ProcThreadAttributeMitigationPolicy             = 7,
#endif
#if (_WIN32_WINNT >= _WIN32_WINNT_WIN8)
    ProcThreadAttributeSecurityCapabilities         = 9,
#endif
    ProcThreadAttributeProtectionLevel              = 11,
#if (_WIN32_WINNT >= _WIN32_WINNT_WINBLUE)
#endif
#if (_WIN32_WINNT >= _WIN32_WINNT_WINTHRESHOLD)
    ProcThreadAttributeJobList                      = 13,
    ProcThreadAttributeChildProcessPolicy           = 14,
    ProcThreadAttributeAllApplicationPackagesPolicy = 15,
    ProcThreadAttributeWin32kFilter                 = 16,
#endif
#if (NTDDI_VERSION >= NTDDI_WIN10_RS1)
    ProcThreadAttributeSafeOpenPromptOriginClaim    = 17,
#endif
#if (NTDDI_VERSION >= NTDDI_WIN10_RS2)
    ProcThreadAttributeDesktopAppPolicy = 18,
#endif
} PROC_THREAD_ATTRIBUTE_NUM;
#endif

#define ProcThreadAttributeValue(Number, Thread, Input, Additive) \
    (((Number) & PROC_THREAD_ATTRIBUTE_NUMBER) | \
     ((Thread != FALSE) ? PROC_THREAD_ATTRIBUTE_THREAD : 0) | \
     ((Input != FALSE) ? PROC_THREAD_ATTRIBUTE_INPUT : 0) | \
     ((Additive != FALSE) ? PROC_THREAD_ATTRIBUTE_ADDITIVE : 0))

#define PROC_THREAD_ATTRIBUTE_PARENT_PROCESS \
    ProcThreadAttributeValue (ProcThreadAttributeParentProcess, FALSE, TRUE, FALSE)
#define PROC_THREAD_ATTRIBUTE_HANDLE_LIST \
    ProcThreadAttributeValue (ProcThreadAttributeHandleList, FALSE, TRUE, FALSE)

end  -- (_WIN32_WINNT >= 0x0600)

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN7)
#define PROC_THREAD_ATTRIBUTE_GROUP_AFFINITY \
    ProcThreadAttributeValue (ProcThreadAttributeGroupAffinity, TRUE, TRUE, FALSE)
#define PROC_THREAD_ATTRIBUTE_PREFERRED_NODE \
    ProcThreadAttributeValue (ProcThreadAttributePreferredNode, FALSE, TRUE, FALSE)
#define PROC_THREAD_ATTRIBUTE_IDEAL_PROCESSOR \
    ProcThreadAttributeValue (ProcThreadAttributeIdealProcessor, TRUE, TRUE, FALSE)
#define PROC_THREAD_ATTRIBUTE_UMS_THREAD \
    ProcThreadAttributeValue (ProcThreadAttributeUmsThread, TRUE, TRUE, FALSE)
#define PROC_THREAD_ATTRIBUTE_MITIGATION_POLICY \
    ProcThreadAttributeValue (ProcThreadAttributeMitigationPolicy, FALSE, TRUE, FALSE)
#endif

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN8)
#define PROC_THREAD_ATTRIBUTE_SECURITY_CAPABILITIES \
    ProcThreadAttributeValue (ProcThreadAttributeSecurityCapabilities, FALSE, TRUE, FALSE)
#endif

#define PROC_THREAD_ATTRIBUTE_PROTECTION_LEVEL \
    ProcThreadAttributeValue (ProcThreadAttributeProtectionLevel, FALSE, TRUE, FALSE)

#if (_WIN32_WINNT >= _WIN32_WINNT_WINBLUE)
#endif

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN7)
//
// Define legacy creation mitigation policy options, which are straight
// bitmasks.  Bits 0-5 are legacy bits.
//

#define PROCESS_CREATION_MITIGATION_POLICY_DEP_ENABLE            0x01
#define PROCESS_CREATION_MITIGATION_POLICY_DEP_ATL_THUNK_ENABLE  0x02
#define PROCESS_CREATION_MITIGATION_POLICY_SEHOP_ENABLE          0x04
#endif


#if (_WIN32_WINNT >= _WIN32_WINNT_WIN8)
//
// Define mandatory ASLR options.  Mandatory ASLR forcibly rebases images that
// are not dynamic base compatible by acting as though there were an image base
// collision at load time.
//
// Note that 'require relocations' mode refuses load of images that do not have
// a base relocation section.
//

#define PROCESS_CREATION_MITIGATION_POLICY_FORCE_RELOCATE_IMAGES_MASK                     (0x00000003 <<  8)
#define PROCESS_CREATION_MITIGATION_POLICY_FORCE_RELOCATE_IMAGES_DEFER                    (0x00000000 <<  8)
#define PROCESS_CREATION_MITIGATION_POLICY_FORCE_RELOCATE_IMAGES_ALWAYS_ON                (0x00000001 <<  8)
#define PROCESS_CREATION_MITIGATION_POLICY_FORCE_RELOCATE_IMAGES_ALWAYS_OFF               (0x00000002 <<  8)
#define PROCESS_CREATION_MITIGATION_POLICY_FORCE_RELOCATE_IMAGES_ALWAYS_ON_REQ_RELOCS     (0x00000003 <<  8)

//
// Define heap terminate on corruption options.  Note that 'always off' does
// not override the default opt-in for binaries with current subsystem versions
// set in the image header.
//
// Heap terminate on corruption is user mode enforced.
//

#define PROCESS_CREATION_MITIGATION_POLICY_HEAP_TERMINATE_MASK                            (0x00000003 << 12)
#define PROCESS_CREATION_MITIGATION_POLICY_HEAP_TERMINATE_DEFER                           (0x00000000 << 12)
#define PROCESS_CREATION_MITIGATION_POLICY_HEAP_TERMINATE_ALWAYS_ON                       (0x00000001 << 12)
#define PROCESS_CREATION_MITIGATION_POLICY_HEAP_TERMINATE_ALWAYS_OFF                      (0x00000002 << 12)
#define PROCESS_CREATION_MITIGATION_POLICY_HEAP_TERMINATE_RESERVED                        (0x00000003 << 12)

//
// Define bottom up randomization (includes stack randomization) options,
// i.e. randomization of the lowest user address.
//

#define PROCESS_CREATION_MITIGATION_POLICY_BOTTOM_UP_ASLR_MASK                            (0x00000003 << 16)
#define PROCESS_CREATION_MITIGATION_POLICY_BOTTOM_UP_ASLR_DEFER                           (0x00000000 << 16)
#define PROCESS_CREATION_MITIGATION_POLICY_BOTTOM_UP_ASLR_ALWAYS_ON                       (0x00000001 << 16)
#define PROCESS_CREATION_MITIGATION_POLICY_BOTTOM_UP_ASLR_ALWAYS_OFF                      (0x00000002 << 16)
#define PROCESS_CREATION_MITIGATION_POLICY_BOTTOM_UP_ASLR_RESERVED                        (0x00000003 << 16)

//
// Define high entropy bottom up randomization.  Note that high entropy bottom
// up randomization is effective if and only if bottom up ASLR is also enabled.
//
// N.B.  High entropy mode is only meaningful for native 64-bit processes.  in
//       high entropy mode, up to 1TB of bottom up variance is enabled.
//

#define PROCESS_CREATION_MITIGATION_POLICY_HIGH_ENTROPY_ASLR_MASK                         (0x00000003 << 20)
#define PROCESS_CREATION_MITIGATION_POLICY_HIGH_ENTROPY_ASLR_DEFER                        (0x00000000 << 20)
#define PROCESS_CREATION_MITIGATION_POLICY_HIGH_ENTROPY_ASLR_ALWAYS_ON                    (0x00000001 << 20)
#define PROCESS_CREATION_MITIGATION_POLICY_HIGH_ENTROPY_ASLR_ALWAYS_OFF                   (0x00000002 << 20)
#define PROCESS_CREATION_MITIGATION_POLICY_HIGH_ENTROPY_ASLR_RESERVED                     (0x00000003 << 20)

//
// Define handle checking enforcement options.  Handle checking enforcement
// causes an exception to be raised immediately on a bad handle reference,
// versus simply returning a failure status from the handle reference.
//

#define PROCESS_CREATION_MITIGATION_POLICY_STRICT_HANDLE_CHECKS_MASK                      (0x00000003 << 24)
#define PROCESS_CREATION_MITIGATION_POLICY_STRICT_HANDLE_CHECKS_DEFER                     (0x00000000 << 24)
#define PROCESS_CREATION_MITIGATION_POLICY_STRICT_HANDLE_CHECKS_ALWAYS_ON                 (0x00000001 << 24)
#define PROCESS_CREATION_MITIGATION_POLICY_STRICT_HANDLE_CHECKS_ALWAYS_OFF                (0x00000002 << 24)
#define PROCESS_CREATION_MITIGATION_POLICY_STRICT_HANDLE_CHECKS_RESERVED                  (0x00000003 << 24)

//
// Define win32k system call disable options.  Win32k system call disable
// prevents a process from making Win32k calls.
//

#define PROCESS_CREATION_MITIGATION_POLICY_WIN32K_SYSTEM_CALL_DISABLE_MASK                (0x00000003 << 28)
#define PROCESS_CREATION_MITIGATION_POLICY_WIN32K_SYSTEM_CALL_DISABLE_DEFER               (0x00000000 << 28)
#define PROCESS_CREATION_MITIGATION_POLICY_WIN32K_SYSTEM_CALL_DISABLE_ALWAYS_ON           (0x00000001 << 28)
#define PROCESS_CREATION_MITIGATION_POLICY_WIN32K_SYSTEM_CALL_DISABLE_ALWAYS_OFF          (0x00000002 << 28)
#define PROCESS_CREATION_MITIGATION_POLICY_WIN32K_SYSTEM_CALL_DISABLE_RESERVED            (0x00000003 << 28)

//
// Define the extension point disable options.  Extension point disable allows
// a process to opt-out of loading various arbitrary extension point DLLs.
//

#define PROCESS_CREATION_MITIGATION_POLICY_EXTENSION_POINT_DISABLE_MASK                   (0x00000003ui64 << 32)
#define PROCESS_CREATION_MITIGATION_POLICY_EXTENSION_POINT_DISABLE_DEFER                  (0x00000000ui64 << 32)
#define PROCESS_CREATION_MITIGATION_POLICY_EXTENSION_POINT_DISABLE_ALWAYS_ON              (0x00000001ui64 << 32)
#define PROCESS_CREATION_MITIGATION_POLICY_EXTENSION_POINT_DISABLE_ALWAYS_OFF             (0x00000002ui64 << 32)
#define PROCESS_CREATION_MITIGATION_POLICY_EXTENSION_POINT_DISABLE_RESERVED               (0x00000003ui64 << 32)

#if (_WIN32_WINNT >= _WIN32_WINNT_WINBLUE)
//
// Define dynamic code options.
//

#define PROCESS_CREATION_MITIGATION_POLICY_PROHIBIT_DYNAMIC_CODE_MASK                     (0x00000003ui64 << 36)
#define PROCESS_CREATION_MITIGATION_POLICY_PROHIBIT_DYNAMIC_CODE_DEFER                    (0x00000000ui64 << 36)
#define PROCESS_CREATION_MITIGATION_POLICY_PROHIBIT_DYNAMIC_CODE_ALWAYS_ON                (0x00000001ui64 << 36)
#define PROCESS_CREATION_MITIGATION_POLICY_PROHIBIT_DYNAMIC_CODE_ALWAYS_OFF               (0x00000002ui64 << 36)
#define PROCESS_CREATION_MITIGATION_POLICY_PROHIBIT_DYNAMIC_CODE_ALWAYS_ON_ALLOW_OPT_OUT  (0x00000003ui64 << 36)

//
// Define Control Flow Guard (CFG) mitigation policy options.  Control Flow
// Guard allows indirect control transfers to be checked at runtime.
//

#define PROCESS_CREATION_MITIGATION_POLICY_CONTROL_FLOW_GUARD_MASK                        (0x00000003ui64 << 40)
#define PROCESS_CREATION_MITIGATION_POLICY_CONTROL_FLOW_GUARD_DEFER                       (0x00000000ui64 << 40)
#define PROCESS_CREATION_MITIGATION_POLICY_CONTROL_FLOW_GUARD_ALWAYS_ON                   (0x00000001ui64 << 40)
#define PROCESS_CREATION_MITIGATION_POLICY_CONTROL_FLOW_GUARD_ALWAYS_OFF                  (0x00000002ui64 << 40)
#define PROCESS_CREATION_MITIGATION_POLICY_CONTROL_FLOW_GUARD_EXPORT_SUPPRESSION          (0x00000003ui64 << 40)

//
// Define module signature options.  When enabled, this option will
// block mapping of non-microsoft binaries.
//

#define PROCESS_CREATION_MITIGATION_POLICY_BLOCK_NON_MICROSOFT_BINARIES_MASK              (0x00000003ui64 << 44)
#define PROCESS_CREATION_MITIGATION_POLICY_BLOCK_NON_MICROSOFT_BINARIES_DEFER             (0x00000000ui64 << 44)
#define PROCESS_CREATION_MITIGATION_POLICY_BLOCK_NON_MICROSOFT_BINARIES_ALWAYS_ON         (0x00000001ui64 << 44)
#define PROCESS_CREATION_MITIGATION_POLICY_BLOCK_NON_MICROSOFT_BINARIES_ALWAYS_OFF        (0x00000002ui64 << 44)
#define PROCESS_CREATION_MITIGATION_POLICY_BLOCK_NON_MICROSOFT_BINARIES_ALLOW_STORE       (0x00000003ui64 << 44)

#if (_WIN32_WINNT >= _WIN32_WINNT_WINTHRESHOLD)

//
// Define Font Disable Policy.  When enabled, this option will
// block loading Non System Fonts.
//

#define PROCESS_CREATION_MITIGATION_POLICY_FONT_DISABLE_MASK                              (0x00000003ui64 << 48)
#define PROCESS_CREATION_MITIGATION_POLICY_FONT_DISABLE_DEFER                             (0x00000000ui64 << 48)
#define PROCESS_CREATION_MITIGATION_POLICY_FONT_DISABLE_ALWAYS_ON                         (0x00000001ui64 << 48)
#define PROCESS_CREATION_MITIGATION_POLICY_FONT_DISABLE_ALWAYS_OFF                        (0x00000002ui64 << 48)
#define PROCESS_CREATION_MITIGATION_POLICY_AUDIT_NONSYSTEM_FONTS                          (0x00000003ui64 << 48)

//
// Define remote image load options.  When enabled, this option will
// block mapping of images from remote devices.
//

#define PROCESS_CREATION_MITIGATION_POLICY_IMAGE_LOAD_NO_REMOTE_MASK                      (0x00000003ui64 << 52)
#define PROCESS_CREATION_MITIGATION_POLICY_IMAGE_LOAD_NO_REMOTE_DEFER                     (0x00000000ui64 << 52)
#define PROCESS_CREATION_MITIGATION_POLICY_IMAGE_LOAD_NO_REMOTE_ALWAYS_ON                 (0x00000001ui64 << 52)
#define PROCESS_CREATION_MITIGATION_POLICY_IMAGE_LOAD_NO_REMOTE_ALWAYS_OFF                (0x00000002ui64 << 52)
#define PROCESS_CREATION_MITIGATION_POLICY_IMAGE_LOAD_NO_REMOTE_RESERVED                  (0x00000003ui64 << 52)

//
// Define low IL image load options.  When enabled, this option will
// block mapping of images that have the low mandatory label.
//

#define PROCESS_CREATION_MITIGATION_POLICY_IMAGE_LOAD_NO_LOW_LABEL_MASK                   (0x00000003ui64 << 56)
#define PROCESS_CREATION_MITIGATION_POLICY_IMAGE_LOAD_NO_LOW_LABEL_DEFER                  (0x00000000ui64 << 56)
#define PROCESS_CREATION_MITIGATION_POLICY_IMAGE_LOAD_NO_LOW_LABEL_ALWAYS_ON              (0x00000001ui64 << 56)
#define PROCESS_CREATION_MITIGATION_POLICY_IMAGE_LOAD_NO_LOW_LABEL_ALWAYS_OFF             (0x00000002ui64 << 56)
#define PROCESS_CREATION_MITIGATION_POLICY_IMAGE_LOAD_NO_LOW_LABEL_RESERVED               (0x00000003ui64 << 56)

//
// Define image load options to prefer System32 images compared to
// the same images in application directory. When enabled, this option
// will prefer loading images from system32 folder.
//

#define PROCESS_CREATION_MITIGATION_POLICY_IMAGE_LOAD_PREFER_SYSTEM32_MASK                (0x00000003ui64 << 60)
#define PROCESS_CREATION_MITIGATION_POLICY_IMAGE_LOAD_PREFER_SYSTEM32_DEFER               (0x00000000ui64 << 60)
#define PROCESS_CREATION_MITIGATION_POLICY_IMAGE_LOAD_PREFER_SYSTEM32_ALWAYS_ON           (0x00000001ui64 << 60)
#define PROCESS_CREATION_MITIGATION_POLICY_IMAGE_LOAD_PREFER_SYSTEM32_ALWAYS_OFF          (0x00000002ui64 << 60)
#define PROCESS_CREATION_MITIGATION_POLICY_IMAGE_LOAD_PREFER_SYSTEM32_RESERVED            (0x00000003ui64 << 60)

//
// Define Loader Integrity Continuity mitigation policy options.  This mitigation
// enforces OS signing levels for depenedent module loads.
//

#define PROCESS_CREATION_MITIGATION_POLICY2_LOADER_INTEGRITY_CONTINUITY_MASK              (0x00000003ui64 << 4)
#define PROCESS_CREATION_MITIGATION_POLICY2_LOADER_INTEGRITY_CONTINUITY_DEFER             (0x00000000ui64 << 4)
#define PROCESS_CREATION_MITIGATION_POLICY2_LOADER_INTEGRITY_CONTINUITY_ALWAYS_ON         (0x00000001ui64 << 4)
#define PROCESS_CREATION_MITIGATION_POLICY2_LOADER_INTEGRITY_CONTINUITY_ALWAYS_OFF        (0x00000002ui64 << 4)
#define PROCESS_CREATION_MITIGATION_POLICY2_LOADER_INTEGRITY_CONTINUITY_AUDIT             (0x00000003ui64 << 4)

//
// Define the strict Control Flow Guard (CFG) mitigation policy options. This mitigation
// requires all images that load in the process to be instrumented by CFG.
//

#define PROCESS_CREATION_MITIGATION_POLICY2_STRICT_CONTROL_FLOW_GUARD_MASK                (0x00000003ui64 << 8)
#define PROCESS_CREATION_MITIGATION_POLICY2_STRICT_CONTROL_FLOW_GUARD_DEFER               (0x00000000ui64 << 8)
#define PROCESS_CREATION_MITIGATION_POLICY2_STRICT_CONTROL_FLOW_GUARD_ALWAYS_ON           (0x00000001ui64 << 8)
#define PROCESS_CREATION_MITIGATION_POLICY2_STRICT_CONTROL_FLOW_GUARD_ALWAYS_OFF          (0x00000002ui64 << 8)
#define PROCESS_CREATION_MITIGATION_POLICY2_STRICT_CONTROL_FLOW_GUARD_RESERVED            (0x00000003ui64 << 8)

//
// Define the module tampering mitigation policy options.
//

#define PROCESS_CREATION_MITIGATION_POLICY2_MODULE_TAMPERING_PROTECTION_MASK              (0x00000003ui64 << 12)
#define PROCESS_CREATION_MITIGATION_POLICY2_MODULE_TAMPERING_PROTECTION_DEFER             (0x00000000ui64 << 12)
#define PROCESS_CREATION_MITIGATION_POLICY2_MODULE_TAMPERING_PROTECTION_ALWAYS_ON         (0x00000001ui64 << 12)
#define PROCESS_CREATION_MITIGATION_POLICY2_MODULE_TAMPERING_PROTECTION_ALWAYS_OFF        (0x00000002ui64 << 12)
#define PROCESS_CREATION_MITIGATION_POLICY2_MODULE_TAMPERING_PROTECTION_NOINHERIT         (0x00000003ui64 << 12)

//
// Define the restricted indirect branch prediction mitigation policy options.
//

#define PROCESS_CREATION_MITIGATION_POLICY2_RESTRICT_INDIRECT_BRANCH_PREDICTION_MASK        (0x00000003ui64 << 16)
#define PROCESS_CREATION_MITIGATION_POLICY2_RESTRICT_INDIRECT_BRANCH_PREDICTION_DEFER       (0x00000000ui64 << 16)
#define PROCESS_CREATION_MITIGATION_POLICY2_RESTRICT_INDIRECT_BRANCH_PREDICTION_ALWAYS_ON   (0x00000001ui64 << 16)
#define PROCESS_CREATION_MITIGATION_POLICY2_RESTRICT_INDIRECT_BRANCH_PREDICTION_ALWAYS_OFF  (0x00000002ui64 << 16)
#define PROCESS_CREATION_MITIGATION_POLICY2_RESTRICT_INDIRECT_BRANCH_PREDICTION_RESERVED    (0x00000003ui64 << 16)

end  -- _WIN32_WINNT_WINTHRESHOLD
end  -- _WIN32_WINNT_WINBLUE
end  -- _WIN32_WINNT_WIN8

#if (_WIN32_WINNT >= _WIN32_WINNT_WINTHRESHOLD)

#define PROC_THREAD_ATTRIBUTE_JOB_LIST \
    ProcThreadAttributeValue (ProcThreadAttributeJobList, FALSE, TRUE, FALSE)

//
// Define Attribute to disable creation of child process
//

#define PROCESS_CREATION_CHILD_PROCESS_RESTRICTED                                         0x01
#define PROCESS_CREATION_CHILD_PROCESS_OVERRIDE                                           0x02
#define PROCESS_CREATION_CHILD_PROCESS_RESTRICTED_UNLESS_SECURE                           0x04

#define PROC_THREAD_ATTRIBUTE_CHILD_PROCESS_POLICY \
    ProcThreadAttributeValue (ProcThreadAttributeChildProcessPolicy, FALSE, TRUE, FALSE)

//
// Define Attribute to opt out of matching All Application Packages
//

#define PROCESS_CREATION_ALL_APPLICATION_PACKAGES_OPT_OUT                                 0x01

#define PROC_THREAD_ATTRIBUTE_ALL_APPLICATION_PACKAGES_POLICY \
    ProcThreadAttributeValue (ProcThreadAttributeAllApplicationPackagesPolicy, FALSE, TRUE, FALSE)

#define PROC_THREAD_ATTRIBUTE_WIN32K_FILTER \
    ProcThreadAttributeValue (ProcThreadAttributeWin32kFilter, FALSE, TRUE, FALSE)

end  -- _WIN32_WINNT_WINTHRESHOLD

#if (NTDDI_VERSION >= NTDDI_WIN10_RS1)


end  -- NTDDI_WIN10_RS1

#if (NTDDI_VERSION >= NTDDI_WIN10_RS2)

//
// Define Attribute for Desktop App Override
//

#define PROCESS_CREATION_DESKTOP_APP_BREAKAWAY_ENABLE_PROCESS_TREE                        0x01
#define PROCESS_CREATION_DESKTOP_APP_BREAKAWAY_DISABLE_PROCESS_TREE                       0x02
#define PROCESS_CREATION_DESKTOP_APP_BREAKAWAY_OVERRIDE                                   0x04

#define PROC_THREAD_ATTRIBUTE_DESKTOP_APP_POLICY \
    ProcThreadAttributeValue (ProcThreadAttributeDesktopAppPolicy, FALSE, TRUE, FALSE)


end  -- NTDDI_WIN10_RS2

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then



VOID
__stdcall
GetStartupInfoA(
     LPSTARTUPINFOA lpStartupInfo
    );
#ifndef UNICODE
#define GetStartupInfo  GetStartupInfoA
#endif

#if defined(_M_CEE)
#undef GetEnvironmentVariable

#if _MSC_VER >= 1400
#pragma warning(push)
#pragma warning(disable: 6103)
#endif /* _MSC_VER >= 1400 */

_Success_(return != 0 && return < nSize)
__inline
DWORD
GetEnvironmentVariable(
     LPCTSTR lpName,
    _Out_writes_to_opt_(nSize, return + 1) LPTSTR lpBuffer,
     DWORD nSize
    )
{
#ifdef UNICODE
    return GetEnvironmentVariableW(
else
    return GetEnvironmentVariableA(
#endif
        lpName,
        lpBuffer,
        nSize
        );
}

#if _MSC_VER >= 1400
#pragma warning(pop)
#endif /* _MSC_VER >= 1400 */

#endif  /* _M_CEE */

#if defined(_M_CEE)
#undef SetEnvironmentVariable
__inline
BOOL
SetEnvironmentVariable(
    LPCTSTR lpName,
    LPCTSTR lpValue
    )
{
#ifdef UNICODE
    return SetEnvironmentVariableW(
else
    return SetEnvironmentVariableA(
#endif
        lpName,
        lpValue
        );
}
#endif  /* _M_CEE */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


#pragma region OneCore Family or App Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_SYSTEM | WINAPI_PARTITION_APP)


DWORD
__stdcall
GetFirmwareEnvironmentVariableA(
     LPCSTR lpName,
     LPCSTR lpGuid,
    _Out_writes_bytes_to_opt_(nSize, return) PVOID pBuffer,
     DWORD    nSize
    );

DWORD
__stdcall
GetFirmwareEnvironmentVariableW(
     LPCWSTR lpName,
     LPCWSTR lpGuid,
    _Out_writes_bytes_to_opt_(nSize, return) PVOID pBuffer,
     DWORD    nSize
    );
#ifdef UNICODE
#define GetFirmwareEnvironmentVariable  GetFirmwareEnvironmentVariableW
else
#define GetFirmwareEnvironmentVariable  GetFirmwareEnvironmentVariableA
end  -- !UNICODE

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN8)


DWORD
__stdcall
GetFirmwareEnvironmentVariableExA(
     LPCSTR lpName,
     LPCSTR lpGuid,
    _Out_writes_bytes_to_opt_(nSize, return) PVOID pBuffer,
     DWORD    nSize,
     PDWORD pdwAttribubutes
    );

DWORD
__stdcall
GetFirmwareEnvironmentVariableExW(
     LPCWSTR lpName,
     LPCWSTR lpGuid,
    _Out_writes_bytes_to_opt_(nSize, return) PVOID pBuffer,
     DWORD    nSize,
     PDWORD pdwAttribubutes
    );
#ifdef UNICODE
#define GetFirmwareEnvironmentVariableEx  GetFirmwareEnvironmentVariableExW
else
#define GetFirmwareEnvironmentVariableEx  GetFirmwareEnvironmentVariableExA
end  -- !UNICODE

#endif


BOOL
__stdcall
SetFirmwareEnvironmentVariableA(
     LPCSTR lpName,
     LPCSTR lpGuid,
    _In_reads_bytes_opt_(nSize) PVOID pValue,
     DWORD    nSize
    );

BOOL
__stdcall
SetFirmwareEnvironmentVariableW(
     LPCWSTR lpName,
     LPCWSTR lpGuid,
    _In_reads_bytes_opt_(nSize) PVOID pValue,
     DWORD    nSize
    );
#ifdef UNICODE
#define SetFirmwareEnvironmentVariable  SetFirmwareEnvironmentVariableW
else
#define SetFirmwareEnvironmentVariable  SetFirmwareEnvironmentVariableA
end  -- !UNICODE

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN8)


BOOL
__stdcall
SetFirmwareEnvironmentVariableExA(
     LPCSTR lpName,
     LPCSTR lpGuid,
    _In_reads_bytes_opt_(nSize) PVOID pValue,
     DWORD    nSize,
     DWORD    dwAttributes
    );

BOOL
__stdcall
SetFirmwareEnvironmentVariableExW(
     LPCWSTR lpName,
     LPCWSTR lpGuid,
    _In_reads_bytes_opt_(nSize) PVOID pValue,
     DWORD    nSize,
     DWORD    dwAttributes
    );
#ifdef UNICODE
#define SetFirmwareEnvironmentVariableEx  SetFirmwareEnvironmentVariableExW
else
#define SetFirmwareEnvironmentVariableEx  SetFirmwareEnvironmentVariableExA
end  -- !UNICODE

#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_SYSTEM | WINAPI_PARTITION_APP) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN8)


BOOL
__stdcall
GetFirmwareType (
     PFIRMWARE_TYPE FirmwareType
    );



BOOL
__stdcall
IsNativeVhdBoot (
     PBOOL NativeVhdBoot
    );

end  -- _WIN32_WINNT >= _WIN32_WINNT_WIN8



HRSRC
__stdcall
FindResourceA(
     HMODULE hModule,
         LPCSTR lpName,
         LPCSTR lpType
    );
#ifndef UNICODE
#define FindResource  FindResourceA
#endif



HRSRC
__stdcall
FindResourceExA(
     HMODULE hModule,
         LPCSTR lpType,
         LPCSTR lpName,
         WORD    wLanguage
    );
#ifndef UNICODE
#define FindResourceEx  FindResourceExA
#endif


BOOL
__stdcall
EnumResourceTypesA(
     HMODULE hModule,
         ENUMRESTYPEPROCA lpEnumFunc,
         LONG_PTR lParam
    );

BOOL
__stdcall
EnumResourceTypesW(
     HMODULE hModule,
         ENUMRESTYPEPROCW lpEnumFunc,
         LONG_PTR lParam
    );
#ifdef UNICODE
#define EnumResourceTypes  EnumResourceTypesW
else
#define EnumResourceTypes  EnumResourceTypesA
end  -- !UNICODE


BOOL
__stdcall
EnumResourceNamesA(
     HMODULE hModule,
         LPCSTR lpType,
         ENUMRESNAMEPROCA lpEnumFunc,
         LONG_PTR lParam
    );

#ifndef UNICODE
#define EnumResourceNames  EnumResourceNamesA
#endif


BOOL
__stdcall
EnumResourceLanguagesA(
     HMODULE hModule,
         LPCSTR lpType,
         LPCSTR lpName,
         ENUMRESLANGPROCA lpEnumFunc,
         LONG_PTR lParam
    );

BOOL
__stdcall
EnumResourceLanguagesW(
     HMODULE hModule,
         LPCWSTR lpType,
         LPCWSTR lpName,
         ENUMRESLANGPROCW lpEnumFunc,
         LONG_PTR lParam
    );
#ifdef UNICODE
#define EnumResourceLanguages  EnumResourceLanguagesW
else
#define EnumResourceLanguages  EnumResourceLanguagesA
end  -- !UNICODE


HANDLE
__stdcall
BeginUpdateResourceA(
     LPCSTR pFileName,
     BOOL bDeleteExistingResources
    );

HANDLE
__stdcall
BeginUpdateResourceW(
     LPCWSTR pFileName,
     BOOL bDeleteExistingResources
    );
#ifdef UNICODE
#define BeginUpdateResource  BeginUpdateResourceW
else
#define BeginUpdateResource  BeginUpdateResourceA
end  -- !UNICODE


BOOL
__stdcall
UpdateResourceA(
     HANDLE hUpdate,
     LPCSTR lpType,
     LPCSTR lpName,
     WORD wLanguage,
    _In_reads_bytes_opt_(cb) LPVOID lpData,
     DWORD cb
    );

BOOL
__stdcall
UpdateResourceW(
     HANDLE hUpdate,
     LPCWSTR lpType,
     LPCWSTR lpName,
     WORD wLanguage,
    _In_reads_bytes_opt_(cb) LPVOID lpData,
     DWORD cb
    );
#ifdef UNICODE
#define UpdateResource  UpdateResourceW
else
#define UpdateResource  UpdateResourceA
end  -- !UNICODE


BOOL
__stdcall
EndUpdateResourceA(
     HANDLE hUpdate,
     BOOL   fDiscard
    );

BOOL
__stdcall
EndUpdateResourceW(
     HANDLE hUpdate,
     BOOL   fDiscard
    );
#ifdef UNICODE
#define EndUpdateResource  EndUpdateResourceW
else
#define EndUpdateResource  EndUpdateResourceA
end  -- !UNICODE

#define ATOM_FLAG_GLOBAL 0x2


ATOM
__stdcall
GlobalAddAtomA(
     LPCSTR lpString
    );

ATOM
__stdcall
GlobalAddAtomW(
     LPCWSTR lpString
    );
#ifdef UNICODE
#define GlobalAddAtom  GlobalAddAtomW
else
#define GlobalAddAtom  GlobalAddAtomA
end  -- !UNICODE


ATOM
__stdcall
GlobalAddAtomExA(
     LPCSTR lpString,
     DWORD Flags
    );

ATOM
__stdcall
GlobalAddAtomExW(
     LPCWSTR lpString,
     DWORD Flags
    );
#ifdef UNICODE
#define GlobalAddAtomEx  GlobalAddAtomExW
else
#define GlobalAddAtomEx  GlobalAddAtomExA
end  -- !UNICODE


ATOM
__stdcall
GlobalFindAtomA(
     LPCSTR lpString
    );

ATOM
__stdcall
GlobalFindAtomW(
     LPCWSTR lpString
    );
#ifdef UNICODE
#define GlobalFindAtom  GlobalFindAtomW
else
#define GlobalFindAtom  GlobalFindAtomA
end  -- !UNICODE


UINT
__stdcall
GlobalGetAtomNameA(
     ATOM nAtom,
    _Out_writes_to_(nSize, return + 1) LPSTR lpBuffer,
     int nSize
    );

UINT
__stdcall
GlobalGetAtomNameW(
     ATOM nAtom,
    _Out_writes_to_(nSize, return + 1) LPWSTR lpBuffer,
     int nSize
    );
#ifdef UNICODE
#define GlobalGetAtomName  GlobalGetAtomNameW
else
#define GlobalGetAtomName  GlobalGetAtomNameA
end  -- !UNICODE


ATOM
__stdcall
AddAtomA(
     LPCSTR lpString
    );

ATOM
__stdcall
AddAtomW(
     LPCWSTR lpString
    );
#ifdef UNICODE
#define AddAtom  AddAtomW
else
#define AddAtom  AddAtomA
end  -- !UNICODE


ATOM
__stdcall
FindAtomA(
     LPCSTR lpString
    );

ATOM
__stdcall
FindAtomW(
     LPCWSTR lpString
    );
#ifdef UNICODE
#define FindAtom  FindAtomW
else
#define FindAtom  FindAtomA
end  -- !UNICODE


UINT
__stdcall
GetAtomNameA(
     ATOM nAtom,
    _Out_writes_to_(nSize, return + 1) LPSTR lpBuffer,
     int nSize
    );

UINT
__stdcall
GetAtomNameW(
     ATOM nAtom,
    _Out_writes_to_(nSize, return + 1) LPWSTR lpBuffer,
     int nSize
    );
#ifdef UNICODE
#define GetAtomName  GetAtomNameW
else
#define GetAtomName  GetAtomNameA
end  -- !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


UINT
__stdcall
GetProfileIntA(
     LPCSTR lpAppName,
     LPCSTR lpKeyName,
     INT nDefault
    );

UINT
__stdcall
GetProfileIntW(
     LPCWSTR lpAppName,
     LPCWSTR lpKeyName,
     INT nDefault
    );
#ifdef UNICODE
#define GetProfileInt  GetProfileIntW
else
#define GetProfileInt  GetProfileIntA
end  -- !UNICODE


DWORD
__stdcall
GetProfileStringA(
     LPCSTR lpAppName,
     LPCSTR lpKeyName,
     LPCSTR lpDefault,
    _Out_writes_to_opt_(nSize, return + 1) LPSTR lpReturnedString,
         DWORD nSize
    );

DWORD
__stdcall
GetProfileStringW(
     LPCWSTR lpAppName,
     LPCWSTR lpKeyName,
     LPCWSTR lpDefault,
    _Out_writes_to_opt_(nSize, return + 1) LPWSTR lpReturnedString,
         DWORD nSize
    );
#ifdef UNICODE
#define GetProfileString  GetProfileStringW
else
#define GetProfileString  GetProfileStringA
end  -- !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


BOOL
__stdcall
WriteProfileStringA(
     LPCSTR lpAppName,
     LPCSTR lpKeyName,
     LPCSTR lpString
    );

BOOL
__stdcall
WriteProfileStringW(
     LPCWSTR lpAppName,
     LPCWSTR lpKeyName,
     LPCWSTR lpString
    );
#ifdef UNICODE
#define WriteProfileString  WriteProfileStringW
else
#define WriteProfileString  WriteProfileStringA
end  -- !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


DWORD
__stdcall
GetProfileSectionA(
     LPCSTR lpAppName,
    _Out_writes_to_opt_(nSize, return + 1) LPSTR lpReturnedString,
     DWORD nSize
    );

DWORD
__stdcall
GetProfileSectionW(
     LPCWSTR lpAppName,
    _Out_writes_to_opt_(nSize, return + 1) LPWSTR lpReturnedString,
     DWORD nSize
    );
#ifdef UNICODE
#define GetProfileSection  GetProfileSectionW
else
#define GetProfileSection  GetProfileSectionA
end  -- !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


BOOL
__stdcall
WriteProfileSectionA(
     LPCSTR lpAppName,
     LPCSTR lpString
    );

BOOL
__stdcall
WriteProfileSectionW(
     LPCWSTR lpAppName,
     LPCWSTR lpString
    );
#ifdef UNICODE
#define WriteProfileSection  WriteProfileSectionW
else
#define WriteProfileSection  WriteProfileSectionA
end  -- !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


UINT
__stdcall
GetPrivateProfileIntA(
         LPCSTR lpAppName,
         LPCSTR lpKeyName,
         INT nDefault,
     LPCSTR lpFileName
    );

UINT
__stdcall
GetPrivateProfileIntW(
         LPCWSTR lpAppName,
         LPCWSTR lpKeyName,
         INT nDefault,
     LPCWSTR lpFileName
    );
#ifdef UNICODE
#define GetPrivateProfileInt  GetPrivateProfileIntW
else
#define GetPrivateProfileInt  GetPrivateProfileIntA
end  -- !UNICODE

#if defined(_M_CEE)
#undef GetPrivateProfileInt
__inline
UINT
GetPrivateProfileInt(
    LPCTSTR lpAppName,
    LPCTSTR lpKeyName,
    INT nDefault,
    LPCTSTR lpFileName
    )
{
#ifdef UNICODE
    return GetPrivateProfileIntW(
else
    return GetPrivateProfileIntA(
#endif
        lpAppName,
        lpKeyName,
        nDefault,
        lpFileName
        );
}
#endif  /* _M_CEE */


DWORD
__stdcall
GetPrivateProfileStringA(
     LPCSTR lpAppName,
     LPCSTR lpKeyName,
     LPCSTR lpDefault,
    _Out_writes_to_opt_(nSize, return + 1) LPSTR lpReturnedString,
         DWORD nSize,
     LPCSTR lpFileName
    );

DWORD
__stdcall
GetPrivateProfileStringW(
     LPCWSTR lpAppName,
     LPCWSTR lpKeyName,
     LPCWSTR lpDefault,
    _Out_writes_to_opt_(nSize, return + 1) LPWSTR lpReturnedString,
         DWORD nSize,
     LPCWSTR lpFileName
    );
#ifdef UNICODE
#define GetPrivateProfileString  GetPrivateProfileStringW
else
#define GetPrivateProfileString  GetPrivateProfileStringA
end  -- !UNICODE

#if defined(_M_CEE)
#undef GetPrivateProfileString
__inline
DWORD
GetPrivateProfileString(
    LPCTSTR lpAppName,
    LPCTSTR lpKeyName,
    LPCTSTR lpDefault,
    LPTSTR lpReturnedString,
    DWORD nSize,
    LPCTSTR lpFileName
    )
{
#ifdef UNICODE
    return GetPrivateProfileStringW(
else
    return GetPrivateProfileStringA(
#endif
        lpAppName,
        lpKeyName,
        lpDefault,
        lpReturnedString,
        nSize,
        lpFileName
        );
}
#endif  /* _M_CEE */


BOOL
__stdcall
WritePrivateProfileStringA(
     LPCSTR lpAppName,
     LPCSTR lpKeyName,
     LPCSTR lpString,
     LPCSTR lpFileName
    );

BOOL
__stdcall
WritePrivateProfileStringW(
     LPCWSTR lpAppName,
     LPCWSTR lpKeyName,
     LPCWSTR lpString,
     LPCWSTR lpFileName
    );
#ifdef UNICODE
#define WritePrivateProfileString  WritePrivateProfileStringW
else
#define WritePrivateProfileString  WritePrivateProfileStringA
end  -- !UNICODE


DWORD
__stdcall
GetPrivateProfileSectionA(
         LPCSTR lpAppName,
    _Out_writes_to_opt_(nSize, return + 1) LPSTR lpReturnedString,
         DWORD nSize,
     LPCSTR lpFileName
    );

DWORD
__stdcall
GetPrivateProfileSectionW(
         LPCWSTR lpAppName,
    _Out_writes_to_opt_(nSize, return + 1) LPWSTR lpReturnedString,
         DWORD nSize,
     LPCWSTR lpFileName
    );
#ifdef UNICODE
#define GetPrivateProfileSection  GetPrivateProfileSectionW
else
#define GetPrivateProfileSection  GetPrivateProfileSectionA
end  -- !UNICODE

#if defined(_M_CEE)
#undef GetPrivateProfileSection
__inline
DWORD
GetPrivateProfileSection(
    LPCTSTR lpAppName,
    LPTSTR lpReturnedString,
    DWORD nSize,
    LPCTSTR lpFileName
    )
{
#ifdef UNICODE
    return GetPrivateProfileSectionW(
else
    return GetPrivateProfileSectionA(
#endif
        lpAppName,
        lpReturnedString,
        nSize,
        lpFileName
        );
}
#endif  /* _M_CEE */


BOOL
__stdcall
WritePrivateProfileSectionA(
     LPCSTR lpAppName,
     LPCSTR lpString,
     LPCSTR lpFileName
    );

BOOL
__stdcall
WritePrivateProfileSectionW(
     LPCWSTR lpAppName,
     LPCWSTR lpString,
     LPCWSTR lpFileName
    );
#ifdef UNICODE
#define WritePrivateProfileSection  WritePrivateProfileSectionW
else
#define WritePrivateProfileSection  WritePrivateProfileSectionA
end  -- !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


DWORD
__stdcall
GetPrivateProfileSectionNamesA(
    _Out_writes_to_opt_(nSize, return + 1) LPSTR lpszReturnBuffer,
         DWORD nSize,
     LPCSTR lpFileName
    );

DWORD
__stdcall
GetPrivateProfileSectionNamesW(
    _Out_writes_to_opt_(nSize, return + 1) LPWSTR lpszReturnBuffer,
         DWORD nSize,
     LPCWSTR lpFileName
    );
#ifdef UNICODE
#define GetPrivateProfileSectionNames  GetPrivateProfileSectionNamesW
else
#define GetPrivateProfileSectionNames  GetPrivateProfileSectionNamesA
end  -- !UNICODE

#if defined(_M_CEE)
#undef GetPrivateProfileSectionNames
__inline
DWORD
GetPrivateProfileSectionNames(
    LPTSTR lpszReturnBuffer,
    DWORD nSize,
    LPCTSTR lpFileName
    )
{
#ifdef UNICODE
    return GetPrivateProfileSectionNamesW(
else
    return GetPrivateProfileSectionNamesA(
#endif
        lpszReturnBuffer,
        nSize,
        lpFileName
        );
}
#endif  /* _M_CEE */


BOOL
__stdcall
GetPrivateProfileStructA(
         LPCSTR lpszSection,
         LPCSTR lpszKey,
    _Out_writes_bytes_opt_(uSizeStruct) LPVOID   lpStruct,
         UINT     uSizeStruct,
     LPCSTR szFile
    );

BOOL
__stdcall
GetPrivateProfileStructW(
         LPCWSTR lpszSection,
         LPCWSTR lpszKey,
    _Out_writes_bytes_opt_(uSizeStruct) LPVOID   lpStruct,
         UINT     uSizeStruct,
     LPCWSTR szFile
    );
#ifdef UNICODE
#define GetPrivateProfileStruct  GetPrivateProfileStructW
else
#define GetPrivateProfileStruct  GetPrivateProfileStructA
end  -- !UNICODE

#if defined(_M_CEE)
#undef GetPrivateProfileStruct
__inline
BOOL
GetPrivateProfileStruct(
    LPCTSTR lpszSection,
    LPCTSTR lpszKey,
    LPVOID   lpStruct,
    UINT     uSizeStruct,
    LPCTSTR szFile
    )
{
#ifdef UNICODE
    return GetPrivateProfileStructW(
else
    return GetPrivateProfileStructA(
#endif
        lpszSection,
        lpszKey,
        lpStruct,
        uSizeStruct,
        szFile
        );
}
#endif  /* _M_CEE */


BOOL
__stdcall
WritePrivateProfileStructA(
         LPCSTR lpszSection,
         LPCSTR lpszKey,
    _In_reads_bytes_opt_(uSizeStruct) LPVOID lpStruct,
         UINT     uSizeStruct,
     LPCSTR szFile
    );

BOOL
__stdcall
WritePrivateProfileStructW(
         LPCWSTR lpszSection,
         LPCWSTR lpszKey,
    _In_reads_bytes_opt_(uSizeStruct) LPVOID lpStruct,
         UINT     uSizeStruct,
     LPCWSTR szFile
    );
#ifdef UNICODE
#define WritePrivateProfileStruct  WritePrivateProfileStructW
else
#define WritePrivateProfileStruct  WritePrivateProfileStructA
end  -- !UNICODE

#if defined(_M_CEE)
#undef GetTempFileName
__inline
UINT
GetTempFileName(
    LPCTSTR lpPathName,
    LPCTSTR lpPrefixString,
    UINT uUnique,
    LPTSTR lpTempFileName
    )
{
#ifdef UNICODE
    return GetTempFileNameW(
else
    return GetTempFileNameA(
#endif
        lpPathName,
        lpPrefixString,
        uUnique,
        lpTempFileName
        );
}
#endif  /* _M_CEE */

#if !defined(RC_INVOKED) // RC warns because "WINBASE_DECLARE_GET_SYSTEM_WOW64_DIRECTORY" is a bit long.
#if _WIN32_WINNT >= 0x0501 || defined(WINBASE_DECLARE_GET_SYSTEM_WOW64_DIRECTORY)


BOOLEAN
__stdcall
Wow64EnableWow64FsRedirection (
     BOOLEAN Wow64FsEnableRedirection
    );

//
// for GetProcAddress
//
typedef UINT (__stdcall* PGET_SYSTEM_WOW64_DIRECTORY_A)(_Out_writes_to_opt_(uSize, return + 1) LPSTR lpBuffer,  UINT uSize);
typedef UINT (__stdcall* PGET_SYSTEM_WOW64_DIRECTORY_W)(_Out_writes_to_opt_(uSize, return + 1) LPWSTR lpBuffer,  UINT uSize);

//
// GetProcAddress only accepts GET_SYSTEM_WOW64_DIRECTORY_NAME_A_A,
// GET_SYSTEM_WOW64_DIRECTORY_NAME_W_A, GET_SYSTEM_WOW64_DIRECTORY_NAME_T_A.
// The others are if you want to use the strings in some other way.
//
#define GET_SYSTEM_WOW64_DIRECTORY_NAME_A_A      "GetSystemWow64DirectoryA"
#define GET_SYSTEM_WOW64_DIRECTORY_NAME_A_W     L"GetSystemWow64DirectoryA"
#define GET_SYSTEM_WOW64_DIRECTORY_NAME_A_T TEXT("GetSystemWow64DirectoryA")
#define GET_SYSTEM_WOW64_DIRECTORY_NAME_W_A      "GetSystemWow64DirectoryW"
#define GET_SYSTEM_WOW64_DIRECTORY_NAME_W_W     L"GetSystemWow64DirectoryW"
#define GET_SYSTEM_WOW64_DIRECTORY_NAME_W_T TEXT("GetSystemWow64DirectoryW")

#ifdef UNICODE
#define GET_SYSTEM_WOW64_DIRECTORY_NAME_T_A GET_SYSTEM_WOW64_DIRECTORY_NAME_W_A
#define GET_SYSTEM_WOW64_DIRECTORY_NAME_T_W GET_SYSTEM_WOW64_DIRECTORY_NAME_W_W
#define GET_SYSTEM_WOW64_DIRECTORY_NAME_T_T GET_SYSTEM_WOW64_DIRECTORY_NAME_W_T
else
#define GET_SYSTEM_WOW64_DIRECTORY_NAME_T_A GET_SYSTEM_WOW64_DIRECTORY_NAME_A_A
#define GET_SYSTEM_WOW64_DIRECTORY_NAME_T_W GET_SYSTEM_WOW64_DIRECTORY_NAME_A_W
#define GET_SYSTEM_WOW64_DIRECTORY_NAME_T_T GET_SYSTEM_WOW64_DIRECTORY_NAME_A_T
#endif

end  -- _WIN32_WINNT >= 0x0501
#endif

#if defined(_M_CEE)
#undef SetCurrentDirectory
__inline
BOOL
SetCurrentDirectory(
    LPCTSTR lpPathName
    )
{
#ifdef UNICODE
    return SetCurrentDirectoryW(
else
    return SetCurrentDirectoryA(
#endif
        lpPathName
        );
}
#endif  /* _M_CEE */

#if defined(_M_CEE)
#undef GetCurrentDirectory
__inline
DWORD
GetCurrentDirectory(
    DWORD nBufferLength,
    LPTSTR lpBuffer
    )
{
#ifdef UNICODE
    return GetCurrentDirectoryW(
else
    return GetCurrentDirectoryA(
#endif
        nBufferLength,
        lpBuffer
        );
}
#endif  /* _M_CEE */

#if _WIN32_WINNT >= 0x0502


BOOL
__stdcall
SetDllDirectoryA(
     LPCSTR lpPathName
    );

BOOL
__stdcall
SetDllDirectoryW(
     LPCWSTR lpPathName
    );
#ifdef UNICODE
#define SetDllDirectory  SetDllDirectoryW
else
#define SetDllDirectory  SetDllDirectoryA
end  -- !UNICODE


_Success_(return != 0 && return < nBufferLength)
DWORD
__stdcall
GetDllDirectoryA(
     DWORD nBufferLength,
    _Out_writes_to_opt_(nBufferLength, return + 1) LPSTR lpBuffer
    );

_Success_(return != 0 && return < nBufferLength)
DWORD
__stdcall
GetDllDirectoryW(
     DWORD nBufferLength,
    _Out_writes_to_opt_(nBufferLength, return + 1) LPWSTR lpBuffer
    );
#ifdef UNICODE
#define GetDllDirectory  GetDllDirectoryW
else
#define GetDllDirectory  GetDllDirectoryA
end  -- !UNICODE

end  -- _WIN32_WINNT >= 0x0502

#define BASE_SEARCH_PATH_ENABLE_SAFE_SEARCHMODE 0x1
#define BASE_SEARCH_PATH_DISABLE_SAFE_SEARCHMODE 0x10000
#define BASE_SEARCH_PATH_PERMANENT 0x8000
#define BASE_SEARCH_PATH_INVALID_FLAGS ~0x18001


BOOL
__stdcall
SetSearchPathMode (
     DWORD Flags
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP)

#if defined(_M_CEE)
#undef CreateDirectory
__inline
BOOL
CreateDirectory(
    LPCTSTR lpPathName,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes
    )
{
#ifdef UNICODE
    return CreateDirectoryW(
else
    return CreateDirectoryA(
#endif
        lpPathName,
        lpSecurityAttributes
        );
}
#endif  /* _M_CEE */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


BOOL
__stdcall
CreateDirectoryExA(
         LPCSTR lpTemplateDirectory,
         LPCSTR lpNewDirectory,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );

BOOL
__stdcall
CreateDirectoryExW(
         LPCWSTR lpTemplateDirectory,
         LPCWSTR lpNewDirectory,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
#ifdef UNICODE
#define CreateDirectoryEx  CreateDirectoryExW
else
#define CreateDirectoryEx  CreateDirectoryExA
end  -- !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

#if _WIN32_WINNT >= 0x0600


BOOL
__stdcall
CreateDirectoryTransactedA(
     LPCSTR lpTemplateDirectory,
         LPCSTR lpNewDirectory,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes,
         HANDLE hTransaction
    );

BOOL
__stdcall
CreateDirectoryTransactedW(
     LPCWSTR lpTemplateDirectory,
         LPCWSTR lpNewDirectory,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes,
         HANDLE hTransaction
    );
#ifdef UNICODE
#define CreateDirectoryTransacted  CreateDirectoryTransactedW
else
#define CreateDirectoryTransacted  CreateDirectoryTransactedA
end  -- !UNICODE


BOOL
__stdcall
RemoveDirectoryTransactedA(
     LPCSTR lpPathName,
         HANDLE hTransaction
    );

BOOL
__stdcall
RemoveDirectoryTransactedW(
     LPCWSTR lpPathName,
         HANDLE hTransaction
    );
#ifdef UNICODE
#define RemoveDirectoryTransacted  RemoveDirectoryTransactedW
else
#define RemoveDirectoryTransacted  RemoveDirectoryTransactedA
end  -- !UNICODE


_Success_(return != 0 && return < nBufferLength)
DWORD
__stdcall
GetFullPathNameTransactedA(
                LPCSTR lpFileName,
                DWORD nBufferLength,
    _Out_writes_to_opt_(nBufferLength, return + 1) LPSTR lpBuffer,
     LPSTR *lpFilePart,
                HANDLE hTransaction
    );

_Success_(return != 0 && return < nBufferLength)
DWORD
__stdcall
GetFullPathNameTransactedW(
                LPCWSTR lpFileName,
                DWORD nBufferLength,
    _Out_writes_to_opt_(nBufferLength, return + 1) LPWSTR lpBuffer,
     LPWSTR *lpFilePart,
                HANDLE hTransaction
    );
#ifdef UNICODE
#define GetFullPathNameTransacted  GetFullPathNameTransactedW
else
#define GetFullPathNameTransacted  GetFullPathNameTransactedA
end  -- !UNICODE

end  -- _WIN32_WINNT >= 0x0600

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

#define DDD_RAW_TARGET_PATH         0x00000001
#define DDD_REMOVE_DEFINITION       0x00000002
#define DDD_EXACT_MATCH_ON_REMOVE   0x00000004
#define DDD_NO_BROADCAST_SYSTEM     0x00000008
#define DDD_LUID_BROADCAST_DRIVE    0x00000010


BOOL
__stdcall
DefineDosDeviceA(
         DWORD dwFlags,
         LPCSTR lpDeviceName,
     LPCSTR lpTargetPath
    );
#ifndef UNICODE
#define DefineDosDevice  DefineDosDeviceA
#endif


DWORD
__stdcall
QueryDosDeviceA(
     LPCSTR lpDeviceName,
    _Out_writes_to_opt_(ucchMax, return) LPSTR lpTargetPath,
         DWORD ucchMax
    );
#ifndef UNICODE
#define QueryDosDevice  QueryDosDeviceA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

#define EXPAND_LOCAL_DRIVES

#if _WIN32_WINNT >= 0x0600


HANDLE
__stdcall
CreateFileTransactedA(
           LPCSTR lpFileName,
           DWORD dwDesiredAccess,
           DWORD dwShareMode,
       LPSECURITY_ATTRIBUTES lpSecurityAttributes,
           DWORD dwCreationDisposition,
           DWORD dwFlagsAndAttributes,
       HANDLE hTemplateFile,
           HANDLE hTransaction,
       PUSHORT pusMiniVersion,
     PVOID  lpExtendedParameter
    );

HANDLE
__stdcall
CreateFileTransactedW(
           LPCWSTR lpFileName,
           DWORD dwDesiredAccess,
           DWORD dwShareMode,
       LPSECURITY_ATTRIBUTES lpSecurityAttributes,
           DWORD dwCreationDisposition,
           DWORD dwFlagsAndAttributes,
       HANDLE hTemplateFile,
           HANDLE hTransaction,
       PUSHORT pusMiniVersion,
     PVOID  lpExtendedParameter
    );
#ifdef UNICODE
#define CreateFileTransacted  CreateFileTransactedW
else
#define CreateFileTransacted  CreateFileTransactedA
end  -- !UNICODE

end  -- _WIN32_WINNT >= 0x0600

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

#if _WIN32_WINNT >= 0x0502


HANDLE
__stdcall
ReOpenFile(
     HANDLE  hOriginalFile,
     DWORD   dwDesiredAccess,
     DWORD   dwShareMode,
     DWORD   dwFlagsAndAttributes
    );

end  -- _WIN32_WINNT >= 0x0502

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */




if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

#if _WIN32_WINNT >= 0x0600


BOOL
__stdcall
SetFileAttributesTransactedA(
         LPCSTR lpFileName,
         DWORD dwFileAttributes,
         HANDLE hTransaction
    );

BOOL
__stdcall
SetFileAttributesTransactedW(
         LPCWSTR lpFileName,
         DWORD dwFileAttributes,
         HANDLE hTransaction
    );
#ifdef UNICODE
#define SetFileAttributesTransacted  SetFileAttributesTransactedW
else
#define SetFileAttributesTransacted  SetFileAttributesTransactedA
end  -- !UNICODE


BOOL
__stdcall
GetFileAttributesTransactedA(
      LPCSTR lpFileName,
      GET_FILEEX_INFO_LEVELS fInfoLevelId,
    _Out_writes_bytes_(sizeof(WIN32_FILE_ATTRIBUTE_DATA)) LPVOID lpFileInformation,
         HANDLE hTransaction
    );

BOOL
__stdcall
GetFileAttributesTransactedW(
      LPCWSTR lpFileName,
      GET_FILEEX_INFO_LEVELS fInfoLevelId,
    _Out_writes_bytes_(sizeof(WIN32_FILE_ATTRIBUTE_DATA)) LPVOID lpFileInformation,
         HANDLE hTransaction
    );
#ifdef UNICODE
#define GetFileAttributesTransacted  GetFileAttributesTransactedW
else
#define GetFileAttributesTransacted  GetFileAttributesTransactedA
end  -- !UNICODE


DWORD
__stdcall
GetCompressedFileSizeTransactedA(
          LPCSTR lpFileName,
     LPDWORD  lpFileSizeHigh,
          HANDLE hTransaction
    );

DWORD
__stdcall
GetCompressedFileSizeTransactedW(
          LPCWSTR lpFileName,
     LPDWORD  lpFileSizeHigh,
          HANDLE hTransaction
    );
#ifdef UNICODE
#define GetCompressedFileSizeTransacted  GetCompressedFileSizeTransactedW
else
#define GetCompressedFileSizeTransacted  GetCompressedFileSizeTransactedA
end  -- !UNICODE


BOOL
__stdcall
DeleteFileTransactedA(
         LPCSTR lpFileName,
         HANDLE hTransaction
    );

BOOL
__stdcall
DeleteFileTransactedW(
         LPCWSTR lpFileName,
         HANDLE hTransaction
    );
#ifdef UNICODE
#define DeleteFileTransacted  DeleteFileTransactedW
else
#define DeleteFileTransacted  DeleteFileTransactedA
end  -- !UNICODE

end  -- _WIN32_WINNT >= 0x0600

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP)

#if defined(_M_CEE)
#undef DeleteFile
__inline
BOOL
DeleteFile(
    LPCTSTR lpFileName
    )
{
#ifdef UNICODE
    return DeleteFileW(
else
    return DeleteFileA(
#endif
        lpFileName
        );
}
#endif  /* _M_CEE */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

#if _WIN32_WINNT >= 0x0501


BOOL
__stdcall
CheckNameLegalDOS8Dot3A(
          LPCSTR lpName,
    _Out_writes_opt_(OemNameSize) LPSTR lpOemName,
          DWORD OemNameSize,
     PBOOL pbNameContainsSpaces OPTIONAL,
         PBOOL pbNameLegal
    );

BOOL
__stdcall
CheckNameLegalDOS8Dot3W(
          LPCWSTR lpName,
    _Out_writes_opt_(OemNameSize) LPSTR lpOemName,
          DWORD OemNameSize,
     PBOOL pbNameContainsSpaces OPTIONAL,
         PBOOL pbNameLegal
    );
#ifdef UNICODE
#define CheckNameLegalDOS8Dot3  CheckNameLegalDOS8Dot3W
else
#define CheckNameLegalDOS8Dot3  CheckNameLegalDOS8Dot3A
end  -- !UNICODE

end  -- (_WIN32_WINNT >= 0x0501)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


#if(_WIN32_WINNT >= 0x0400)


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

#if _WIN32_WINNT >= 0x0600


HANDLE
__stdcall
FindFirstFileTransactedA(
           LPCSTR lpFileName,
           FINDEX_INFO_LEVELS fInfoLevelId,
    _Out_writes_bytes_(sizeof(WIN32_FIND_DATAA)) LPVOID lpFindFileData,
           FINDEX_SEARCH_OPS fSearchOp,
     LPVOID lpSearchFilter,
           DWORD dwAdditionalFlags,
           HANDLE hTransaction
    );

HANDLE
__stdcall
FindFirstFileTransactedW(
           LPCWSTR lpFileName,
           FINDEX_INFO_LEVELS fInfoLevelId,
    _Out_writes_bytes_(sizeof(WIN32_FIND_DATAW)) LPVOID lpFindFileData,
           FINDEX_SEARCH_OPS fSearchOp,
     LPVOID lpSearchFilter,
           DWORD dwAdditionalFlags,
           HANDLE hTransaction
    );
#ifdef UNICODE
#define FindFirstFileTransacted  FindFirstFileTransactedW
else
#define FindFirstFileTransacted  FindFirstFileTransactedA
end  -- !UNICODE

#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


#endif /* _WIN32_WINNT >= 0x0400 */


#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)



BOOL
__stdcall
CopyFileA(
     LPCSTR lpExistingFileName,
     LPCSTR lpNewFileName,
     BOOL bFailIfExists
    );

BOOL
__stdcall
CopyFileW(
     LPCWSTR lpExistingFileName,
     LPCWSTR lpNewFileName,
     BOOL bFailIfExists
    );
#ifdef UNICODE
#define CopyFile  CopyFileW
else
#define CopyFile  CopyFileA
end  -- !UNICODE

#if defined(_M_CEE)
#undef CopyFile
__inline
BOOL
CopyFile(
    LPCTSTR lpExistingFileName,
    LPCTSTR lpNewFileName,
    BOOL bFailIfExists
    )
{
#ifdef UNICODE
    return CopyFileW(
else
    return CopyFileA(
#endif
        lpExistingFileName,
        lpNewFileName,
        bFailIfExists
        );
}
#endif  /* _M_CEE */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


#if(_WIN32_WINNT >= 0x0400)
--]=]

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
typedef
DWORD
(__stdcall *LPPROGRESS_ROUTINE)(
         LARGE_INTEGER TotalFileSize,
         LARGE_INTEGER TotalBytesTransferred,
         LARGE_INTEGER StreamSize,
         LARGE_INTEGER StreamBytesTransferred,
         DWORD dwStreamNumber,
         DWORD dwCallbackReason,
         HANDLE hSourceFile,
         HANDLE hDestinationFile,
     LPVOID lpData
    );


BOOL
__stdcall
CopyFileExA(
            LPCSTR lpExistingFileName,
            LPCSTR lpNewFileName,
        LPPROGRESS_ROUTINE lpProgressRoutine,
        LPVOID lpData,
    
     LPBOOL pbCancel,
            DWORD dwCopyFlags
    );

BOOL
__stdcall
CopyFileExW(
            LPCWSTR lpExistingFileName,
            LPCWSTR lpNewFileName,
        LPPROGRESS_ROUTINE lpProgressRoutine,
        LPVOID lpData,
    
     LPBOOL pbCancel,
            DWORD dwCopyFlags
    );
]]

--[[
#ifdef UNICODE
#define CopyFileEx  CopyFileExW
else
#define CopyFileEx  CopyFileExA
end  -- !UNICODE
--]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

if _WIN32_WINNT >= 0x0600 then
ffi.cdef[[

BOOL
__stdcall
CopyFileTransactedA(
         LPCSTR lpExistingFileName,
         LPCSTR lpNewFileName,
     LPPROGRESS_ROUTINE lpProgressRoutine,
     LPVOID lpData,
     LPBOOL pbCancel,
         DWORD dwCopyFlags,
         HANDLE hTransaction
    );

BOOL
__stdcall
CopyFileTransactedW(
         LPCWSTR lpExistingFileName,
         LPCWSTR lpNewFileName,
     LPPROGRESS_ROUTINE lpProgressRoutine,
     LPVOID lpData,
     LPBOOL pbCancel,
         DWORD dwCopyFlags,
         HANDLE hTransaction
    );
]]

--[[
#ifdef UNICODE
#define CopyFileTransacted  CopyFileTransactedW
else
#define CopyFileTransacted  CopyFileTransactedA
end  -- !UNICODE
--]]

end  -- _WIN32_WINNT >= 0x0600

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then



if _WIN32_WINNT >= 0x0601 then


ffi.cdef[[
typedef enum _COPYFILE2_MESSAGE_TYPE {
     COPYFILE2_CALLBACK_NONE = 0,
     COPYFILE2_CALLBACK_CHUNK_STARTED,
     COPYFILE2_CALLBACK_CHUNK_FINISHED,
     COPYFILE2_CALLBACK_STREAM_STARTED,
     COPYFILE2_CALLBACK_STREAM_FINISHED,
     COPYFILE2_CALLBACK_POLL_CONTINUE,
     COPYFILE2_CALLBACK_ERROR,
     COPYFILE2_CALLBACK_MAX,
} COPYFILE2_MESSAGE_TYPE;

typedef enum _COPYFILE2_MESSAGE_ACTION {
    COPYFILE2_PROGRESS_CONTINUE = 0,
    COPYFILE2_PROGRESS_CANCEL,
    COPYFILE2_PROGRESS_STOP,
    COPYFILE2_PROGRESS_QUIET,
    COPYFILE2_PROGRESS_PAUSE,
} COPYFILE2_MESSAGE_ACTION;

typedef enum _COPYFILE2_COPY_PHASE {
    COPYFILE2_PHASE_NONE = 0,
    COPYFILE2_PHASE_PREPARE_SOURCE,
    COPYFILE2_PHASE_PREPARE_DEST,
    COPYFILE2_PHASE_READ_SOURCE,
    COPYFILE2_PHASE_WRITE_DESTINATION,
    COPYFILE2_PHASE_SERVER_COPY,
    COPYFILE2_PHASE_NAMEGRAFT_COPY,
    // ... etc phases.
    COPYFILE2_PHASE_MAX,
} COPYFILE2_COPY_PHASE;
]]

ffi.cdef[[
static const int COPYFILE2_MESSAGE_COPY_OFFLOAD    = (0x00000001L);

typedef struct COPYFILE2_MESSAGE {

    COPYFILE2_MESSAGE_TYPE  Type;
    DWORD                   dwPadding;

    union {

        struct {
            DWORD           dwStreamNumber; // monotonically increasing stream number
            DWORD           dwReserved;
            HANDLE           hSourceFile; // handle to the source stream
            HANDLE           hDestinationFile; // handle to the destination stream
            ULARGE_INTEGER  uliChunkNumber; // monotonically increasing chunk number
            ULARGE_INTEGER  uliChunkSize;  // size of the copied chunk
            ULARGE_INTEGER  uliStreamSize; // size of the current stream
            ULARGE_INTEGER  uliTotalFileSize; // size of all streams for this file
        } ChunkStarted;

        struct {
            DWORD           dwStreamNumber; // monotonically increasing stream number
            DWORD           dwFlags;
            HANDLE           hSourceFile; // handle to the source stream
            HANDLE           hDestinationFile; // handle to the destination stream
            ULARGE_INTEGER  uliChunkNumber; // monotonically increasing chunk number
            ULARGE_INTEGER  uliChunkSize;  // size of the copied chunk
            ULARGE_INTEGER  uliStreamSize; // size of the current stream
            ULARGE_INTEGER  uliStreamBytesTransferred; // bytes copied for this stream so far
            ULARGE_INTEGER  uliTotalFileSize; // size of all streams for this file
            ULARGE_INTEGER  uliTotalBytesTransferred; // total bytes copied so far
        } ChunkFinished;

        struct {
            DWORD           dwStreamNumber;
            DWORD           dwReserved;
            HANDLE           hSourceFile; // handle to the source stream
            HANDLE           hDestinationFile; // handle to the destination stream
            ULARGE_INTEGER  uliStreamSize; // size of this stream
            ULARGE_INTEGER  uliTotalFileSize; // total size of all streams for this file
        } StreamStarted;

        struct {
            DWORD           dwStreamNumber;
            DWORD           dwReserved;
            HANDLE           hSourceFile; // handle to the source stream
            HANDLE           hDestinationFile; // handle to the destination stream
            ULARGE_INTEGER  uliStreamSize;
            ULARGE_INTEGER  uliStreamBytesTransferred;
            ULARGE_INTEGER  uliTotalFileSize;
            ULARGE_INTEGER  uliTotalBytesTransferred;
        } StreamFinished;

        struct {
            DWORD           dwReserved;
        } PollContinue;

        struct {
            COPYFILE2_COPY_PHASE    CopyPhase;
            DWORD                   dwStreamNumber;
            HRESULT                 hrFailure;
            DWORD                   dwReserved;
            ULARGE_INTEGER          uliChunkNumber;
            ULARGE_INTEGER          uliStreamSize;
            ULARGE_INTEGER          uliStreamBytesTransferred;
            ULARGE_INTEGER          uliTotalFileSize;
            ULARGE_INTEGER          uliTotalBytesTransferred;
        } Error;

    } Info;

} COPYFILE2_MESSAGE;

typedef
COPYFILE2_MESSAGE_ACTION (__stdcall *PCOPYFILE2_PROGRESS_ROUTINE)(
        const COPYFILE2_MESSAGE     *pMessage,
    PVOID                       pvCallbackContext
);

typedef struct COPYFILE2_EXTENDED_PARAMETERS {
  DWORD                         dwSize;
  DWORD                         dwCopyFlags;
  BOOL                          *pfCancel;
  PCOPYFILE2_PROGRESS_ROUTINE   pProgressRoutine;
  PVOID                         pvCallbackContext;
} COPYFILE2_EXTENDED_PARAMETERS;


HRESULT
__stdcall
CopyFile2(
        PCWSTR                          pwszExistingFileName,
        PCWSTR                          pwszNewFileName,
    COPYFILE2_EXTENDED_PARAMETERS   *pExtendedParameters
);
]]

end --// _WIN32_WINNT >= 0x0601


end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */

--[=[
#endif /* _WIN32_WINNT >= 0x0400 */


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


BOOL
__stdcall
MoveFileA(
     LPCSTR lpExistingFileName,
     LPCSTR lpNewFileName
    );

BOOL
__stdcall
MoveFileW(
     LPCWSTR lpExistingFileName,
     LPCWSTR lpNewFileName
    );
#ifdef UNICODE
#define MoveFile  MoveFileW
else
#define MoveFile  MoveFileA
end  -- !UNICODE

#if defined(_M_CEE)
#undef MoveFile
__inline
BOOL
MoveFile(
    LPCTSTR lpExistingFileName,
    LPCTSTR lpNewFileName
    )
{
#ifdef UNICODE
    return MoveFileW(
else
    return MoveFileA(
#endif
        lpExistingFileName,
        lpNewFileName
        );
}
#endif  /* _M_CEE */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


BOOL
__stdcall
MoveFileExA(
         LPCSTR lpExistingFileName,
     LPCSTR lpNewFileName,
         DWORD    dwFlags
    );

BOOL
__stdcall
MoveFileExW(
         LPCWSTR lpExistingFileName,
     LPCWSTR lpNewFileName,
         DWORD    dwFlags
    );
#ifdef UNICODE
#define MoveFileEx  MoveFileExW
else
#define MoveFileEx  MoveFileExA
end  -- !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

#if (_WIN32_WINNT >= 0x0500)

BOOL
__stdcall
MoveFileWithProgressA(
         LPCSTR lpExistingFileName,
     LPCSTR lpNewFileName,
     LPPROGRESS_ROUTINE lpProgressRoutine,
     LPVOID lpData,
         DWORD dwFlags
    );

BOOL
__stdcall
MoveFileWithProgressW(
         LPCWSTR lpExistingFileName,
     LPCWSTR lpNewFileName,
     LPPROGRESS_ROUTINE lpProgressRoutine,
     LPVOID lpData,
         DWORD dwFlags
    );
#ifdef UNICODE
#define MoveFileWithProgress  MoveFileWithProgressW
else
#define MoveFileWithProgress  MoveFileWithProgressA
end  -- !UNICODE
end  -- (_WIN32_WINNT >= 0x0500)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

#if (_WIN32_WINNT >= 0x0600)

BOOL
__stdcall
MoveFileTransactedA(
         LPCSTR lpExistingFileName,
     LPCSTR lpNewFileName,
     LPPROGRESS_ROUTINE lpProgressRoutine,
     LPVOID lpData,
         DWORD dwFlags,
         HANDLE hTransaction
    );

BOOL
__stdcall
MoveFileTransactedW(
         LPCWSTR lpExistingFileName,
     LPCWSTR lpNewFileName,
     LPPROGRESS_ROUTINE lpProgressRoutine,
     LPVOID lpData,
         DWORD dwFlags,
         HANDLE hTransaction
    );
#ifdef UNICODE
#define MoveFileTransacted  MoveFileTransactedW
else
#define MoveFileTransacted  MoveFileTransactedA
end  -- !UNICODE
end  -- (_WIN32_WINNT >= 0x0600)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP)

#define MOVEFILE_REPLACE_EXISTING       0x00000001
#define MOVEFILE_COPY_ALLOWED           0x00000002
#define MOVEFILE_DELAY_UNTIL_REBOOT     0x00000004
#define MOVEFILE_WRITE_THROUGH          0x00000008
#if (_WIN32_WINNT >= 0x0500)
#define MOVEFILE_CREATE_HARDLINK        0x00000010
#define MOVEFILE_FAIL_IF_NOT_TRACKABLE  0x00000020
end  -- (_WIN32_WINNT >= 0x0500)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

#if (_WIN32_WINNT >= 0x0500)


BOOL
__stdcall
ReplaceFileA(
           LPCSTR lpReplacedFileName,
           LPCSTR lpReplacementFileName,
       LPCSTR lpBackupFileName,
           DWORD    dwReplaceFlags,
     LPVOID   lpExclude,
     LPVOID  lpReserved
    );

BOOL
__stdcall
ReplaceFileW(
           LPCWSTR lpReplacedFileName,
           LPCWSTR lpReplacementFileName,
       LPCWSTR lpBackupFileName,
           DWORD    dwReplaceFlags,
     LPVOID   lpExclude,
     LPVOID  lpReserved
    );
#ifdef UNICODE
#define ReplaceFile  ReplaceFileW
else
#define ReplaceFile  ReplaceFileA
end  -- !UNICODE
end  -- (_WIN32_WINNT >= 0x0500)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

#if (_WIN32_WINNT >= 0x0500)
//
// API call to create hard links.
//


BOOL
__stdcall
CreateHardLinkA(
           LPCSTR lpFileName,
           LPCSTR lpExistingFileName,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );

BOOL
__stdcall
CreateHardLinkW(
           LPCWSTR lpFileName,
           LPCWSTR lpExistingFileName,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
#ifdef UNICODE
#define CreateHardLink  CreateHardLinkW
else
#define CreateHardLink  CreateHardLinkA
end  -- !UNICODE

end  -- (_WIN32_WINNT >= 0x0500)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

#if (_WIN32_WINNT >= 0x0600)
//
// API call to create hard links.
//


BOOL
__stdcall
CreateHardLinkTransactedA(
           LPCSTR lpFileName,
           LPCSTR lpExistingFileName,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes,
           HANDLE hTransaction
    );

BOOL
__stdcall
CreateHardLinkTransactedW(
           LPCWSTR lpFileName,
           LPCWSTR lpExistingFileName,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes,
           HANDLE hTransaction
    );
#ifdef UNICODE
#define CreateHardLinkTransacted  CreateHardLinkTransactedW
else
#define CreateHardLinkTransacted  CreateHardLinkTransactedA
end  -- !UNICODE

end  -- (_WIN32_WINNT >= 0x0600)

#if _WIN32_WINNT >= 0x0600


HANDLE
__stdcall
FindFirstStreamTransactedW (
           LPCWSTR lpFileName,
           STREAM_INFO_LEVELS InfoLevel,
    _Out_writes_bytes_(sizeof(WIN32_FIND_STREAM_DATA)) LPVOID lpFindStreamData,
     DWORD dwFlags,
           HANDLE hTransaction
    );


HANDLE
__stdcall
FindFirstFileNameTransactedW (
         LPCWSTR lpFileName,
         DWORD dwFlags,
      LPDWORD StringLength,
    _Out_writes_(*StringLength) PWSTR LinkName,
     HANDLE hTransaction
    );

#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


HANDLE
__stdcall
CreateNamedPipeA(
         LPCSTR lpName,
         DWORD dwOpenMode,
         DWORD dwPipeMode,
         DWORD nMaxInstances,
         DWORD nOutBufferSize,
         DWORD nInBufferSize,
         DWORD nDefaultTimeOut,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
#ifndef UNICODE
#define CreateNamedPipe  CreateNamedPipeA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


BOOL
__stdcall
GetNamedPipeHandleStateA(
          HANDLE hNamedPipe,
     LPDWORD lpState,
     LPDWORD lpCurInstances,
     LPDWORD lpMaxCollectionCount,
     LPDWORD lpCollectDataTimeout,
    _Out_writes_opt_(nMaxUserNameSize) LPSTR lpUserName,
          DWORD nMaxUserNameSize
    );
#ifndef UNICODE
#define GetNamedPipeHandleState  GetNamedPipeHandleStateA
#endif


BOOL
__stdcall
CallNamedPipeA(
      LPCSTR lpNamedPipeName,
     LPVOID lpInBuffer,
      DWORD nInBufferSize,
     LPVOID lpOutBuffer,
      DWORD nOutBufferSize,
     LPDWORD lpBytesRead,
      DWORD nTimeOut
    );

#ifndef UNICODE
#define CallNamedPipe  CallNamedPipeA
#endif


BOOL
__stdcall
WaitNamedPipeA(
     LPCSTR lpNamedPipeName,
     DWORD nTimeOut
    );
#ifndef UNICODE
#define WaitNamedPipe  WaitNamedPipeA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


#if (_WIN32_WINNT >= 0x0600)


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


BOOL
__stdcall
GetNamedPipeClientComputerNameA(
     HANDLE Pipe,
      LPSTR ClientComputerName,
     ULONG ClientComputerNameLength
    );

#ifndef UNICODE
#define GetNamedPipeClientComputerName  GetNamedPipeClientComputerNameA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


BOOL
__stdcall
GetNamedPipeClientProcessId(
     HANDLE Pipe,
     PULONG ClientProcessId
    );


BOOL
__stdcall
GetNamedPipeClientSessionId(
     HANDLE Pipe,
     PULONG ClientSessionId
    );


BOOL
__stdcall
GetNamedPipeServerProcessId(
     HANDLE Pipe,
     PULONG ServerProcessId
    );


BOOL
__stdcall
GetNamedPipeServerSessionId(
     HANDLE Pipe,
     PULONG ServerSessionId
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


end  -- (_WIN32_WINNT >= 0x0600)


#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP)


BOOL
__stdcall
SetVolumeLabelA(
     LPCSTR lpRootPathName,
     LPCSTR lpVolumeName
    );

BOOL
__stdcall
SetVolumeLabelW(
     LPCWSTR lpRootPathName,
     LPCWSTR lpVolumeName
    );
#ifdef UNICODE
#define SetVolumeLabel  SetVolumeLabelW
else
#define SetVolumeLabel  SetVolumeLabelA
end  -- !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


#if (_WIN32_WINNT >= 0x0600)


BOOL
__stdcall
SetFileBandwidthReservation(
      HANDLE  hFile,
      DWORD   nPeriodMilliseconds,
      DWORD   nBytesPerPeriod,
      BOOL    bDiscardable,
     LPDWORD lpTransferSize,
     LPDWORD lpNumOutstandingRequests
    );


BOOL
__stdcall
GetFileBandwidthReservation(
      HANDLE  hFile,
     LPDWORD lpPeriodMilliseconds,
     LPDWORD lpBytesPerPeriod,
     LPBOOL  pDiscardable,
     LPDWORD lpTransferSize,
     LPDWORD lpNumOutstandingRequests
    );

end  -- (_WIN32_WINNT >= 0x0600)

//
// Event logging APIs
//


BOOL
__stdcall
ClearEventLogA (
         HANDLE hEventLog,
     LPCSTR lpBackupFileName
    );

BOOL
__stdcall
ClearEventLogW (
         HANDLE hEventLog,
     LPCWSTR lpBackupFileName
    );
#ifdef UNICODE
#define ClearEventLog  ClearEventLogW
else
#define ClearEventLog  ClearEventLogA
end  -- !UNICODE


BOOL
__stdcall
BackupEventLogA (
     HANDLE hEventLog,
     LPCSTR lpBackupFileName
    );

BOOL
__stdcall
BackupEventLogW (
     HANDLE hEventLog,
     LPCWSTR lpBackupFileName
    );
#ifdef UNICODE
#define BackupEventLog  BackupEventLogW
else
#define BackupEventLog  BackupEventLogA
end  -- !UNICODE


BOOL
__stdcall
CloseEventLog (
     HANDLE hEventLog
    );


BOOL
__stdcall
DeregisterEventSource (
     HANDLE hEventLog
    );


BOOL
__stdcall
NotifyChangeEventLog(
     HANDLE  hEventLog,
     HANDLE  hEvent
    );


BOOL
__stdcall
GetNumberOfEventLogRecords (
      HANDLE hEventLog,
     PDWORD NumberOfRecords
    );


BOOL
__stdcall
GetOldestEventLogRecord (
      HANDLE hEventLog,
     PDWORD OldestRecord
    );


HANDLE
__stdcall
OpenEventLogA (
     LPCSTR lpUNCServerName,
         LPCSTR lpSourceName
    );

HANDLE
__stdcall
OpenEventLogW (
     LPCWSTR lpUNCServerName,
         LPCWSTR lpSourceName
    );

--[[
#ifdef UNICODE
#define OpenEventLog  OpenEventLogW
else
#define OpenEventLog  OpenEventLogA
end  -- !UNICODE
--]]

HANDLE
__stdcall
RegisterEventSourceA (
     LPCSTR lpUNCServerName,
         LPCSTR lpSourceName
    );

HANDLE
__stdcall
RegisterEventSourceW (
     LPCWSTR lpUNCServerName,
         LPCWSTR lpSourceName
    );

--[[
#ifdef UNICODE
#define RegisterEventSource  RegisterEventSourceW
else
#define RegisterEventSource  RegisterEventSourceA
end  -- !UNICODE
--]]

HANDLE
__stdcall
OpenBackupEventLogA (
     LPCSTR lpUNCServerName,
         LPCSTR lpFileName
    );

HANDLE
__stdcall
OpenBackupEventLogW (
     LPCWSTR lpUNCServerName,
         LPCWSTR lpFileName
    );

--[[
#ifdef UNICODE
#define OpenBackupEventLog  OpenBackupEventLogW
else
#define OpenBackupEventLog  OpenBackupEventLogA
end  -- !UNICODE
--]]

BOOL
__stdcall
ReadEventLogA (
      HANDLE     hEventLog,
      DWORD      dwReadFlags,
      DWORD      dwRecordOffset,
     LPVOID     lpBuffer,
      DWORD      nNumberOfBytesToRead,
     DWORD      *pnBytesRead,
     DWORD      *pnMinNumberOfBytesNeeded
    );

BOOL
__stdcall
ReadEventLogW (
      HANDLE     hEventLog,
      DWORD      dwReadFlags,
      DWORD      dwRecordOffset,
     LPVOID     lpBuffer,
      DWORD      nNumberOfBytesToRead,
     DWORD      *pnBytesRead,
     DWORD      *pnMinNumberOfBytesNeeded
    );
#ifdef UNICODE
#define ReadEventLog  ReadEventLogW
else
#define ReadEventLog  ReadEventLogA
end  -- !UNICODE


BOOL
__stdcall
ReportEventA (
         HANDLE     hEventLog,
         WORD       wType,
         WORD       wCategory,
         DWORD      dwEventID,
     PSID       lpUserSid,
         WORD       wNumStrings,
         DWORD      dwDataSize,
     LPCSTR *lpStrings,
     LPVOID lpRawData
    );

BOOL
__stdcall
ReportEventW (
         HANDLE     hEventLog,
         WORD       wType,
         WORD       wCategory,
         DWORD      dwEventID,
     PSID       lpUserSid,
         WORD       wNumStrings,
         DWORD      dwDataSize,
     LPCWSTR *lpStrings,
     LPVOID lpRawData
    );
#ifdef UNICODE
#define ReportEvent  ReportEventW
else
#define ReportEvent  ReportEventA
end  -- !UNICODE


#define EVENTLOG_FULL_INFO      0

typedef struct _EVENTLOG_FULL_INFORMATION
{
    DWORD    dwFull;
}
EVENTLOG_FULL_INFORMATION, *LPEVENTLOG_FULL_INFORMATION;


BOOL
__stdcall
GetEventLogInformation (
      HANDLE     hEventLog,
      DWORD      dwInfoLevel,
     LPVOID lpBuffer,
      DWORD      cbBufSize,
     LPDWORD    pcbBytesNeeded
    );

#if (_WIN32_WINNT >= 0x0602)

//
// Operation prefetch API.
//

#define OPERATION_API_VERSION                   1
typedef ULONG OPERATION_ID;

//
// OperationStart() parameters.
//

typedef struct _OPERATION_START_PARAMETERS {
    ULONG Version;
    OPERATION_ID OperationId;
    ULONG Flags;
} OPERATION_START_PARAMETERS, *POPERATION_START_PARAMETERS;

#define OPERATION_START_TRACE_CURRENT_THREAD    0x1

//
// OperationEnd() parameters.
//

typedef struct _OPERATION_END_PARAMETERS {
    ULONG Version;
    OPERATION_ID OperationId;
    ULONG Flags;
} OPERATION_END_PARAMETERS, *POPERATION_END_PARAMETERS;

#define OPERATION_END_DISCARD                   0x1


BOOL
__stdcall
OperationStart (
     OPERATION_START_PARAMETERS* OperationStartParams
    );


BOOL
__stdcall
OperationEnd (
     OPERATION_END_PARAMETERS* OperationEndParams
    );

end  -- _WIN32_WINNT >= 0x0602

//
//
// Security APIs
//



BOOL
__stdcall
AccessCheckAndAuditAlarmA (
         LPCSTR SubsystemName,
     LPVOID HandleId,
         LPSTR ObjectTypeName,
     LPSTR ObjectName,
         PSECURITY_DESCRIPTOR SecurityDescriptor,
         DWORD DesiredAccess,
         PGENERIC_MAPPING GenericMapping,
         BOOL ObjectCreation,
        LPDWORD GrantedAccess,
        LPBOOL AccessStatus,
        LPBOOL pfGenerateOnClose
    );
#ifndef UNICODE
#define AccessCheckAndAuditAlarm  AccessCheckAndAuditAlarmA
#endif

#if(_WIN32_WINNT >= 0x0500)


BOOL
__stdcall
AccessCheckByTypeAndAuditAlarmA (
         LPCSTR SubsystemName,
         LPVOID HandleId,
         LPCSTR ObjectTypeName,
     LPCSTR ObjectName,
         PSECURITY_DESCRIPTOR SecurityDescriptor,
     PSID PrincipalSelfSid,
         DWORD DesiredAccess,
         AUDIT_EVENT_TYPE AuditType,
         DWORD Flags,
     POBJECT_TYPE_LIST ObjectTypeList,
         DWORD ObjectTypeListLength,
         PGENERIC_MAPPING GenericMapping,
         BOOL ObjectCreation,
        LPDWORD GrantedAccess,
        LPBOOL AccessStatus,
        LPBOOL pfGenerateOnClose
    );
#ifndef UNICODE
#define AccessCheckByTypeAndAuditAlarm  AccessCheckByTypeAndAuditAlarmA
#endif


BOOL
__stdcall
AccessCheckByTypeResultListAndAuditAlarmA (
         LPCSTR SubsystemName,
         LPVOID HandleId,
         LPCSTR ObjectTypeName,
     LPCSTR ObjectName,
         PSECURITY_DESCRIPTOR SecurityDescriptor,
     PSID PrincipalSelfSid,
         DWORD DesiredAccess,
         AUDIT_EVENT_TYPE AuditType,
         DWORD Flags,
     POBJECT_TYPE_LIST ObjectTypeList,
         DWORD ObjectTypeListLength,
         PGENERIC_MAPPING GenericMapping,
         BOOL ObjectCreation,
           LPDWORD GrantedAccess,
           LPDWORD AccessStatusList,
        LPBOOL pfGenerateOnClose
    );
#ifndef UNICODE
#define AccessCheckByTypeResultListAndAuditAlarm  AccessCheckByTypeResultListAndAuditAlarmA
#endif


BOOL
__stdcall
AccessCheckByTypeResultListAndAuditAlarmByHandleA (
         LPCSTR SubsystemName,
         LPVOID HandleId,
         HANDLE ClientToken,
         LPCSTR ObjectTypeName,
     LPCSTR ObjectName,
         PSECURITY_DESCRIPTOR SecurityDescriptor,
     PSID PrincipalSelfSid,
         DWORD DesiredAccess,
         AUDIT_EVENT_TYPE AuditType,
         DWORD Flags,
     POBJECT_TYPE_LIST ObjectTypeList,
         DWORD ObjectTypeListLength,
         PGENERIC_MAPPING GenericMapping,
         BOOL ObjectCreation,
           LPDWORD GrantedAccess,
           LPDWORD AccessStatusList,
        LPBOOL pfGenerateOnClose
    );
#ifndef UNICODE
#define AccessCheckByTypeResultListAndAuditAlarmByHandle  AccessCheckByTypeResultListAndAuditAlarmByHandleA
#endif
end  --(_WIN32_WINNT >= 0x0500)


BOOL
__stdcall
ObjectOpenAuditAlarmA (
         LPCSTR SubsystemName,
         LPVOID HandleId,
         LPSTR ObjectTypeName,
     LPSTR ObjectName,
         PSECURITY_DESCRIPTOR pSecurityDescriptor,
         HANDLE ClientToken,
         DWORD DesiredAccess,
         DWORD GrantedAccess,
     PPRIVILEGE_SET Privileges,
         BOOL ObjectCreation,
         BOOL AccessGranted,
        LPBOOL GenerateOnClose
    );
#ifndef UNICODE
#define ObjectOpenAuditAlarm  ObjectOpenAuditAlarmA
#endif


BOOL
__stdcall
ObjectPrivilegeAuditAlarmA (
     LPCSTR SubsystemName,
     LPVOID HandleId,
     HANDLE ClientToken,
     DWORD DesiredAccess,
     PPRIVILEGE_SET Privileges,
     BOOL AccessGranted
    );
#ifndef UNICODE
#define ObjectPrivilegeAuditAlarm  ObjectPrivilegeAuditAlarmA
#endif


BOOL
__stdcall
ObjectCloseAuditAlarmA (
     LPCSTR SubsystemName,
     LPVOID HandleId,
     BOOL GenerateOnClose
    );
#ifndef UNICODE
#define ObjectCloseAuditAlarm  ObjectCloseAuditAlarmA
#endif


BOOL
__stdcall
ObjectDeleteAuditAlarmA (
     LPCSTR SubsystemName,
     LPVOID HandleId,
     BOOL GenerateOnClose
    );
#ifndef UNICODE
#define ObjectDeleteAuditAlarm  ObjectDeleteAuditAlarmA
#endif


BOOL
__stdcall
PrivilegedServiceAuditAlarmA (
     LPCSTR SubsystemName,
     LPCSTR ServiceName,
     HANDLE ClientToken,
     PPRIVILEGE_SET Privileges,
     BOOL AccessGranted
    );
#ifndef UNICODE
#define PrivilegedServiceAuditAlarm  PrivilegedServiceAuditAlarmA
#endif

#if(_WIN32_WINNT >= 0x0601)

BOOL
__stdcall
AddConditionalAce (
     PACL pAcl,
        DWORD dwAceRevision,
        DWORD AceFlags,
        UCHAR AceType,
        DWORD AccessMask,
        PSID pSid,
      PWCHAR ConditionStr,
     DWORD *ReturnLength
    );
#endif /* _WIN32_WINNT >=  0x0601 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


BOOL
__stdcall
SetFileSecurityA (
     LPCSTR lpFileName,
     SECURITY_INFORMATION SecurityInformation,
     PSECURITY_DESCRIPTOR pSecurityDescriptor
    );
#ifndef UNICODE
#define SetFileSecurity  SetFileSecurityA
#endif


BOOL
__stdcall
GetFileSecurityA (
      LPCSTR lpFileName,
      SECURITY_INFORMATION RequestedInformation,
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
      DWORD nLength,
     LPDWORD lpnLengthNeeded
    );
#ifndef UNICODE
#define GetFileSecurity  GetFileSecurityA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
--]=]

--[=[
if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

if(_WIN32_WINNT >= 0x0400) then
ffi.cdef[[
BOOL
__stdcall
ReadDirectoryChangesW(
    HANDLE hDirectory,
    LPVOID lpBuffer,
    DWORD nBufferLength,
    BOOL bWatchSubtree,
    DWORD dwNotifyFilter,
    LPDWORD lpBytesReturned,
    LPOVERLAPPED lpOverlapped,
    LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine);
]]

if (NTDDI_VERSION >= NTDDI_WIN10_RS3) then
ffi.cdef[[
BOOL
__stdcall
ReadDirectoryChangesExW(
            HANDLE hDirectory,
     LPVOID lpBuffer,
            DWORD nBufferLength,
            BOOL bWatchSubtree,
            DWORD dwNotifyFilter,
       LPDWORD lpBytesReturned,
     LPOVERLAPPED lpOverlapped,
        LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine,
            READ_DIRECTORY_NOTIFY_INFORMATION_CLASS ReadDirectoryNotifyInformationClass
    );
]]
end
end --/* _WIN32_WINNT >= 0x0400 */

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
--]=]


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

if _WIN32_WINNT >= 0x0600 then


ffi.cdef[[ 
LPVOID
__stdcall
MapViewOfFileExNuma(
    HANDLE hFileMappingObject,
    DWORD dwDesiredAccess,
    DWORD dwFileOffsetHigh,
    DWORD dwFileOffsetLow,
    SIZE_T dwNumberOfBytesToMap,
    LPVOID lpBaseAddress,
    DWORD nndPreferred);
]]

end  -- _WIN32_WINNT >= 0x0600

ffi.cdef[[
BOOL
__stdcall
IsBadReadPtr(
     const VOID *lp,
         UINT_PTR ucb
    );


BOOL
__stdcall
IsBadWritePtr(
     LPVOID lp,
         UINT_PTR ucb
    );


BOOL
__stdcall
IsBadHugeReadPtr(
     const VOID *lp,
         UINT_PTR ucb
    );


BOOL
__stdcall
IsBadHugeWritePtr(
     LPVOID lp,
         UINT_PTR ucb
    );


BOOL
__stdcall
IsBadCodePtr(
     FARPROC lpfn
    );


BOOL
__stdcall
IsBadStringPtrA(
     LPCSTR lpsz,
         UINT_PTR ucchMax
    );

BOOL
__stdcall
IsBadStringPtrW(
     LPCWSTR lpsz,
         UINT_PTR ucchMax
    );
]]

--[[
#ifdef UNICODE
#define IsBadStringPtr  IsBadStringPtrW
else
#define IsBadStringPtr  IsBadStringPtrA
end  -- !UNICODE
--]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
 BOOL
__stdcall
LookupAccountSidA(
     LPCSTR lpSystemName,
     PSID Sid,
     LPSTR Name,
      LPDWORD cchName,
     LPSTR ReferencedDomainName,
     LPDWORD cchReferencedDomainName,
     PSID_NAME_USE peUse
    );

 BOOL
__stdcall
LookupAccountSidW(
     LPCWSTR lpSystemName,
     PSID Sid,
     LPWSTR Name,
      LPDWORD cchName,
     LPWSTR ReferencedDomainName,
     LPDWORD cchReferencedDomainName,
     PSID_NAME_USE peUse
    );
]]

--[[
#ifdef UNICODE
#define LookupAccountSid  LookupAccountSidW
else
#define LookupAccountSid  LookupAccountSidA
end  -- !UNICODE
--]]

ffi.cdef[[
 BOOL
__stdcall
LookupAccountNameA(
     LPCSTR lpSystemName,
         LPCSTR lpAccountName,
     PSID Sid,
      LPDWORD cbSid,
     LPSTR ReferencedDomainName,
      LPDWORD cchReferencedDomainName,
        PSID_NAME_USE peUse
    );

 BOOL
__stdcall
LookupAccountNameW(
     LPCWSTR lpSystemName,
         LPCWSTR lpAccountName,
     PSID Sid,
      LPDWORD cbSid,
     LPWSTR ReferencedDomainName,
      LPDWORD cchReferencedDomainName,
        PSID_NAME_USE peUse
    );
]]

--[[
#ifdef UNICODE
#define LookupAccountName  LookupAccountNameW
else
#define LookupAccountName  LookupAccountNameA
end  -- !UNICODE
--]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


--[=[
if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

if _WIN32_WINNT >= 0x0601 then


 BOOL
__stdcall
LookupAccountNameLocalA(
         LPCSTR lpAccountName,
     PSID Sid,
      LPDWORD cbSid,
     LPSTR ReferencedDomainName,
      LPDWORD cchReferencedDomainName,
        PSID_NAME_USE peUse
    );

 BOOL
__stdcall
LookupAccountNameLocalW(
         LPCWSTR lpAccountName,
     PSID Sid,
      LPDWORD cbSid,
     LPWSTR ReferencedDomainName,
      LPDWORD cchReferencedDomainName,
        PSID_NAME_USE peUse
    );
#ifdef UNICODE
#define LookupAccountNameLocal  LookupAccountNameLocalW
else
#define LookupAccountNameLocal  LookupAccountNameLocalA
end  -- !UNICODE


 BOOL
__stdcall
LookupAccountSidLocalA(
     PSID Sid,
     LPSTR Name,
      LPDWORD cchName,
     LPSTR ReferencedDomainName,
     LPDWORD cchReferencedDomainName,
     PSID_NAME_USE peUse
    );

 BOOL
__stdcall
LookupAccountSidLocalW(
     PSID Sid,
     LPWSTR Name,
      LPDWORD cchName,
     LPWSTR ReferencedDomainName,
     LPDWORD cchReferencedDomainName,
     PSID_NAME_USE peUse
    );
#ifdef UNICODE
#define LookupAccountSidLocal  LookupAccountSidLocalW
else
#define LookupAccountSidLocal  LookupAccountSidLocalA
end  -- !UNICODE

else // _WIN32_WINNT >= 0x0601

#define LookupAccountNameLocalA(n, s, cs, d, cd, u) \
    LookupAccountNameA(NULL, n, s, cs, d, cd, u)
#define LookupAccountNameLocalW(n, s, cs, d, cd, u) \
    LookupAccountNameW(NULL, n, s, cs, d, cd, u)
#ifdef UNICODE
#define LookupAccountNameLocal  LookupAccountNameLocalW
else
#define LookupAccountNameLocal  LookupAccountNameLocalA
end  -- !UNICODE

#define LookupAccountSidLocalA(s, n, cn, d, cd, u)  \
    LookupAccountSidA(NULL, s, n, cn, d, cd, u)
#define LookupAccountSidLocalW(s, n, cn, d, cd, u)  \
    LookupAccountSidW(NULL, s, n, cn, d, cd, u)
#ifdef UNICODE
#define LookupAccountSidLocal  LookupAccountSidLocalW
else
#define LookupAccountSidLocal  LookupAccountSidLocalA
end  -- !UNICODE

end  -- _WIN32_WINNT >= 0x0601

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


BOOL
__stdcall
LookupPrivilegeValueA(
     LPCSTR lpSystemName,
         LPCSTR lpName,
        PLUID   lpLuid
    );

BOOL
__stdcall
LookupPrivilegeValueW(
     LPCWSTR lpSystemName,
         LPCWSTR lpName,
        PLUID   lpLuid
    );
#ifdef UNICODE
#define LookupPrivilegeValue  LookupPrivilegeValueW
else
#define LookupPrivilegeValue  LookupPrivilegeValueA
end  -- !UNICODE


 BOOL
__stdcall
LookupPrivilegeNameA(
     LPCSTR lpSystemName,
         PLUID   lpLuid,
     LPSTR lpName,
      LPDWORD cchName
    );

 BOOL
__stdcall
LookupPrivilegeNameW(
     LPCWSTR lpSystemName,
         PLUID   lpLuid,
     LPWSTR lpName,
      LPDWORD cchName
    );
#ifdef UNICODE
#define LookupPrivilegeName  LookupPrivilegeNameW
else
#define LookupPrivilegeName  LookupPrivilegeNameA
end  -- !UNICODE


 BOOL
__stdcall
LookupPrivilegeDisplayNameA(
     LPCSTR lpSystemName,
         LPCSTR lpName,
     LPSTR lpDisplayName,
      LPDWORD cchDisplayName,
        LPDWORD lpLanguageId
    );

 BOOL
__stdcall
LookupPrivilegeDisplayNameW(
     LPCWSTR lpSystemName,
         LPCWSTR lpName,
     LPWSTR lpDisplayName,
      LPDWORD cchDisplayName,
        LPDWORD lpLanguageId
    );
#ifdef UNICODE
#define LookupPrivilegeDisplayName  LookupPrivilegeDisplayNameW
else
#define LookupPrivilegeDisplayName  LookupPrivilegeDisplayNameA
end  -- !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


BOOL
__stdcall
BuildCommDCBA(
      LPCSTR lpDef,
     LPDCB lpDCB
    );

BOOL
__stdcall
BuildCommDCBW(
      LPCWSTR lpDef,
     LPDCB lpDCB
    );
#ifdef UNICODE
#define BuildCommDCB  BuildCommDCBW
else
#define BuildCommDCB  BuildCommDCBA
end  -- !UNICODE


BOOL
__stdcall
BuildCommDCBAndTimeoutsA(
      LPCSTR lpDef,
     LPDCB lpDCB,
     LPCOMMTIMEOUTS lpCommTimeouts
    );

BOOL
__stdcall
BuildCommDCBAndTimeoutsW(
      LPCWSTR lpDef,
     LPDCB lpDCB,
     LPCOMMTIMEOUTS lpCommTimeouts
    );
#ifdef UNICODE
#define BuildCommDCBAndTimeouts  BuildCommDCBAndTimeoutsW
else
#define BuildCommDCBAndTimeouts  BuildCommDCBAndTimeoutsA
end  -- !UNICODE


BOOL
__stdcall
CommConfigDialogA(
         LPCSTR lpszName,
     HWND hWnd,
      LPCOMMCONFIG lpCC
    );

BOOL
__stdcall
CommConfigDialogW(
         LPCWSTR lpszName,
     HWND hWnd,
      LPCOMMCONFIG lpCC
    );
#ifdef UNICODE
#define CommConfigDialog  CommConfigDialogW
else
#define CommConfigDialog  CommConfigDialogA
end  -- !UNICODE


BOOL
__stdcall
GetDefaultCommConfigA(
        LPCSTR lpszName,
     LPCOMMCONFIG lpCC,
     LPDWORD lpdwSize
    );

BOOL
__stdcall
GetDefaultCommConfigW(
        LPCWSTR lpszName,
     LPCOMMCONFIG lpCC,
     LPDWORD lpdwSize
    );
#ifdef UNICODE
#define GetDefaultCommConfig  GetDefaultCommConfigW
else
#define GetDefaultCommConfig  GetDefaultCommConfigA
end  -- !UNICODE


BOOL
__stdcall
SetDefaultCommConfigA(
     LPCSTR lpszName,
     LPCOMMCONFIG lpCC,
     DWORD dwSize
    );

BOOL
__stdcall
SetDefaultCommConfigW(
     LPCWSTR lpszName,
     LPCOMMCONFIG lpCC,
     DWORD dwSize
    );
#ifdef UNICODE
#define SetDefaultCommConfig  SetDefaultCommConfigW
else
#define SetDefaultCommConfig  SetDefaultCommConfigA
end  -- !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

#ifndef _MAC
#define MAX_COMPUTERNAME_LENGTH 15
else
#define MAX_COMPUTERNAME_LENGTH 31
#endif


_Success_(return != 0)
BOOL
__stdcall
GetComputerNameA (
     LPSTR lpBuffer,
     LPDWORD nSize
    );

_Success_(return != 0)
BOOL
__stdcall
GetComputerNameW (
     LPWSTR lpBuffer,
     LPDWORD nSize
    );
#ifdef UNICODE
#define GetComputerName  GetComputerNameW
else
#define GetComputerName  GetComputerNameA
end  -- !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
--]=]


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

if (_WIN32_WINNT >= 0x0500) then
ffi.cdef[[
BOOL
__stdcall
DnsHostnameToComputerNameA (
        LPCSTR Hostname,
     LPSTR ComputerName,
     LPDWORD nSize
    );


BOOL
__stdcall
DnsHostnameToComputerNameW (
        LPCWSTR Hostname,
     LPWSTR ComputerName,
     LPDWORD nSize
    );
]]

--[[
#ifdef UNICODE
#define DnsHostnameToComputerName  DnsHostnameToComputerNameW
else
#define DnsHostnameToComputerName  DnsHostnameToComputerNameA
end  -- !UNICODE
--]]
end  -- _WIN32_WINNT

ffi.cdef[[
BOOL
__stdcall
GetUserNameA (
     LPSTR lpBuffer,
     LPDWORD pcbBuffer
    );

BOOL
__stdcall
GetUserNameW (
     LPWSTR lpBuffer,
     LPDWORD pcbBuffer
    );
]]

--[[
#ifdef UNICODE
#define GetUserName  GetUserNameW
else
#define GetUserName  GetUserNameA
end  -- !UNICODE
--]]

--[[
//
// Logon Support APIs
//

#define LOGON32_LOGON_INTERACTIVE       2
#define LOGON32_LOGON_NETWORK           3
#define LOGON32_LOGON_BATCH             4
#define LOGON32_LOGON_SERVICE           5
#define LOGON32_LOGON_UNLOCK            7
#if(_WIN32_WINNT >= 0x0500)
#define LOGON32_LOGON_NETWORK_CLEARTEXT 8
#define LOGON32_LOGON_NEW_CREDENTIALS   9
end  -- (_WIN32_WINNT >= 0x0500)

#define LOGON32_PROVIDER_DEFAULT    0
#define LOGON32_PROVIDER_WINNT35    1
#if(_WIN32_WINNT >= 0x0400)
#define LOGON32_PROVIDER_WINNT40    2
#endif /* _WIN32_WINNT >= 0x0400 */
#if(_WIN32_WINNT >= 0x0500)
#define LOGON32_PROVIDER_WINNT50    3
end  -- (_WIN32_WINNT >= 0x0500)
#if(_WIN32_WINNT >= 0x0600)
#define LOGON32_PROVIDER_VIRTUAL    4
end  -- (_WIN32_WINNT >= 0x0600)
--]]

--[=[
ffi.cdef[[
BOOL
__stdcall
LogonUserA (
            LPCSTR lpszUsername,
        LPCSTR lpszDomain,
        LPCSTR lpszPassword,
            DWORD dwLogonType,
            DWORD dwLogonProvider,
     PHANDLE phToken
    );

BOOL
__stdcall
LogonUserW (
            LPCWSTR lpszUsername,
        LPCWSTR lpszDomain,
        LPCWSTR lpszPassword,
            DWORD dwLogonType,
            DWORD dwLogonProvider,
     PHANDLE phToken
    );
]]

--[[
#ifdef UNICODE
#define LogonUser  LogonUserW
else
#define LogonUser  LogonUserA
end  -- !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
LogonUserExA (
                LPCSTR lpszUsername,
            LPCSTR lpszDomain,
            LPCSTR lpszPassword,
                DWORD dwLogonType,
                DWORD dwLogonProvider,
     PHANDLE phToken,
     PSID  *ppLogonSid,
     PVOID *ppProfileBuffer,
           LPDWORD pdwProfileLength,
           PQUOTA_LIMITS pQuotaLimits
    );

BOOL
__stdcall
LogonUserExW (
                LPCWSTR lpszUsername,
            LPCWSTR lpszDomain,
            LPCWSTR lpszPassword,
                DWORD dwLogonType,
                DWORD dwLogonProvider,
     PHANDLE phToken,
     PSID  *ppLogonSid,
     PVOID *ppProfileBuffer,
           LPDWORD pdwProfileLength,
           PQUOTA_LIMITS pQuotaLimits
    );
]]
--]=]
--[[
#ifdef UNICODE
#define LogonUserEx  LogonUserExW
else
#define LogonUserEx  LogonUserExA
end  -- !UNICODE
--]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */

--[=[
#if(_WIN32_WINNT >= 0x0600)


end  -- (_WIN32_WINNT >= 0x0600)


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

#if(_WIN32_WINNT >= 0x0500)

//
// LogonFlags
//
#define LOGON_WITH_PROFILE              0x00000001
#define LOGON_NETCREDENTIALS_ONLY       0x00000002
#define LOGON_ZERO_PASSWORD_BUFFER      0x80000000

//@[comment("MVI_tracked")]

 BOOL
__stdcall
CreateProcessWithLogonW(
            LPCWSTR lpUsername,
        LPCWSTR lpDomain,
            LPCWSTR lpPassword,
            DWORD dwLogonFlags,
        LPCWSTR lpApplicationName,
     LPWSTR lpCommandLine,
            DWORD dwCreationFlags,
        LPVOID lpEnvironment,
        LPCWSTR lpCurrentDirectory,
            LPSTARTUPINFOW lpStartupInfo,
           LPPROCESS_INFORMATION lpProcessInformation
      );


 BOOL
__stdcall
CreateProcessWithTokenW(
            HANDLE hToken,
            DWORD dwLogonFlags,
        LPCWSTR lpApplicationName,
     LPWSTR lpCommandLine,
            DWORD dwCreationFlags,
        LPVOID lpEnvironment,
        LPCWSTR lpCurrentDirectory,
            LPSTARTUPINFOW lpStartupInfo,
           LPPROCESS_INFORMATION lpProcessInformation
      );

end  -- (_WIN32_WINNT >= 0x0500)


BOOL
__stdcall
IsTokenUntrusted(
     HANDLE TokenHandle
    );

//
// Thread pool API's
//

#if (_WIN32_WINNT >= 0x0500)


BOOL
__stdcall
RegisterWaitForSingleObject(
     PHANDLE phNewWaitObject,
            HANDLE hObject,
            WAITORTIMERCALLBACK Callback,
        PVOID Context,
            ULONG dwMilliseconds,
            ULONG dwFlags
    );



BOOL
__stdcall
UnregisterWait(
     HANDLE WaitHandle
    );


BOOL
__stdcall
BindIoCompletionCallback (
     HANDLE FileHandle,
     LPOVERLAPPED_COMPLETION_ROUTINE Function,
     ULONG Flags
    );


HANDLE
__stdcall
SetTimerQueueTimer(
     HANDLE TimerQueue,
         WAITORTIMERCALLBACK Callback,
     PVOID Parameter,
         DWORD DueTime,
         DWORD Period,
         BOOL PreferIo
    );



BOOL
__stdcall
CancelTimerQueueTimer(
     HANDLE TimerQueue,
         HANDLE Timer
    );



BOOL
__stdcall
DeleteTimerQueue(
     HANDLE TimerQueue
    );

end  -- _WIN32_WINNT >= 0x0500

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */

#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP)

#if (_WIN32_WINNT >= 0x0500)

#if (_WIN32_WINNT >= 0x0600)

#if !defined(MIDL_PASS)

FORCEINLINE
VOID
InitializeThreadpoolEnvironment(
     PTP_CALLBACK_ENVIRON pcbe
    )
{
    TpInitializeCallbackEnviron(pcbe);
}

FORCEINLINE
VOID
SetThreadpoolCallbackPool(
     PTP_CALLBACK_ENVIRON pcbe,
        PTP_POOL             ptpp
    )
{
    TpSetCallbackThreadpool(pcbe, ptpp);
}

FORCEINLINE
VOID
SetThreadpoolCallbackCleanupGroup(
      PTP_CALLBACK_ENVIRON              pcbe,
         PTP_CLEANUP_GROUP                 ptpcg,
     PTP_CLEANUP_GROUP_CANCEL_CALLBACK pfng
    )
{
    TpSetCallbackCleanupGroup(pcbe, ptpcg, pfng);
}

FORCEINLINE
VOID
SetThreadpoolCallbackRunsLong(
     PTP_CALLBACK_ENVIRON pcbe
    )
{
    TpSetCallbackLongFunction(pcbe);
}

FORCEINLINE
VOID
SetThreadpoolCallbackLibrary(
     PTP_CALLBACK_ENVIRON pcbe,
        PVOID                mod
    )
{
    TpSetCallbackRaceWithDll(pcbe, mod);
}

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN7)

FORCEINLINE
VOID
SetThreadpoolCallbackPriority(
     PTP_CALLBACK_ENVIRON pcbe,
        TP_CALLBACK_PRIORITY Priority
    )
{
    TpSetCallbackPriority(pcbe, Priority);
}

#endif

FORCEINLINE
VOID
DestroyThreadpoolEnvironment(
     PTP_CALLBACK_ENVIRON pcbe
    )
{
    TpDestroyCallbackEnviron(pcbe);
}

end  -- !defined(MIDL_PASS)

end  -- _WIN32_WINNT >= 0x0600

end  -- _WIN32_WINNT >= 0x0500

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */

#if (_WIN32_WINNT >= 0x0600)


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

#if !defined(MIDL_PASS)

FORCEINLINE
VOID
SetThreadpoolCallbackPersistent(
     PTP_CALLBACK_ENVIRON pcbe
    )
{
    TpSetCallbackPersistent(pcbe);
}

end  -- !defined(MIDL_PASS)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

//
//  Private Namespaces support
//



HANDLE
__stdcall
CreatePrivateNamespaceA(
     LPSECURITY_ATTRIBUTES lpPrivateNamespaceAttributes,
         LPVOID lpBoundaryDescriptor,
         LPCSTR lpAliasPrefix
    );

#ifndef UNICODE
#define CreatePrivateNamespace CreatePrivateNamespaceA
else
#define CreatePrivateNamespace CreatePrivateNamespaceW
#endif



HANDLE
__stdcall
OpenPrivateNamespaceA(
         LPVOID lpBoundaryDescriptor,
         LPCSTR lpAliasPrefix
    );

#ifndef UNICODE
#define OpenPrivateNamespace OpenPrivateNamespaceA
else
#define OpenPrivateNamespace OpenPrivateNamespaceW
#endif


//
//  Boundary descriptors support
//



HANDLE
APIENTRY
CreateBoundaryDescriptorA(
     LPCSTR Name,
     ULONG Flags
    );

#ifndef UNICODE
#define CreateBoundaryDescriptor CreateBoundaryDescriptorA
else
#define CreateBoundaryDescriptor CreateBoundaryDescriptorW
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


BOOL
__stdcall
AddIntegrityLabelToBoundaryDescriptor(
     HANDLE * BoundaryDescriptor,
     PSID IntegrityLabel
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


end  -- _WIN32_WINNT >= 0x0600


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

#if(_WIN32_WINNT >= 0x0400)
//
// Plug-and-Play API's
//

#define HW_PROFILE_GUIDLEN         39      // 36-characters plus NULL terminator
#define MAX_PROFILE_LEN            80

#define DOCKINFO_UNDOCKED          (0x1)
#define DOCKINFO_DOCKED            (0x2)
#define DOCKINFO_USER_SUPPLIED     (0x4)
#define DOCKINFO_USER_UNDOCKED     (DOCKINFO_USER_SUPPLIED | DOCKINFO_UNDOCKED)
#define DOCKINFO_USER_DOCKED       (DOCKINFO_USER_SUPPLIED | DOCKINFO_DOCKED)

typedef struct tagHW_PROFILE_INFOA {
    DWORD  dwDockInfo;
    CHAR   szHwProfileGuid[HW_PROFILE_GUIDLEN];
    CHAR   szHwProfileName[MAX_PROFILE_LEN];
} HW_PROFILE_INFOA, *LPHW_PROFILE_INFOA;
typedef struct tagHW_PROFILE_INFOW {
    DWORD  dwDockInfo;
    WCHAR  szHwProfileGuid[HW_PROFILE_GUIDLEN];
    WCHAR  szHwProfileName[MAX_PROFILE_LEN];
} HW_PROFILE_INFOW, *LPHW_PROFILE_INFOW;
#ifdef UNICODE
typedef HW_PROFILE_INFOW HW_PROFILE_INFO;
typedef LPHW_PROFILE_INFOW LPHW_PROFILE_INFO;
else
typedef HW_PROFILE_INFOA HW_PROFILE_INFO;
typedef LPHW_PROFILE_INFOA LPHW_PROFILE_INFO;
end  -- UNICODE



BOOL
__stdcall
GetCurrentHwProfileA (
     LPHW_PROFILE_INFOA  lpHwProfileInfo
    );

BOOL
__stdcall
GetCurrentHwProfileW (
     LPHW_PROFILE_INFOW  lpHwProfileInfo
    );
#ifdef UNICODE
#define GetCurrentHwProfile  GetCurrentHwProfileW
else
#define GetCurrentHwProfile  GetCurrentHwProfileA
end  -- !UNICODE
#endif /* _WIN32_WINNT >= 0x0400 */


BOOL
__stdcall
VerifyVersionInfoA(
     LPOSVERSIONINFOEXA lpVersionInformation,
        DWORD dwTypeMask,
        DWORDLONG dwlConditionMask
    );

BOOL
__stdcall
VerifyVersionInfoW(
     LPOSVERSIONINFOEXW lpVersionInformation,
        DWORD dwTypeMask,
        DWORDLONG dwlConditionMask
    );
#ifdef UNICODE
#define VerifyVersionInfo  VerifyVersionInfoW
else
#define VerifyVersionInfo  VerifyVersionInfoA
end  -- !UNICODE


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
--]=]

--// DOS and OS/2 Compatible Error Code definitions returned by the Win32 Base
--// API functions.


require("win32.winerror")
require("win32.timezoneapi")

--[=[
if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

/* Abnormal termination codes */

#define TC_NORMAL       0
#define TC_HARDERR      1
#define TC_GP_TRAP      2
#define TC_SIGNAL       3

#if(WINVER >= 0x0400)
//
// Power Management APIs
//


BOOL
__stdcall
SetSystemPowerState(
     BOOL fSuspend,
     BOOL fForce
    );

#endif /* WINVER >= 0x0400 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


#pragma region  Desktop or PC Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_PC_APP)

#if(WINVER >= 0x0400)
//
// Power Management APIs
//

#define AC_LINE_OFFLINE                 0x00
#define AC_LINE_ONLINE                  0x01
#define AC_LINE_BACKUP_POWER            0x02
#define AC_LINE_UNKNOWN                 0xFF

#define BATTERY_FLAG_HIGH               0x01
#define BATTERY_FLAG_LOW                0x02
#define BATTERY_FLAG_CRITICAL           0x04
#define BATTERY_FLAG_CHARGING           0x08
#define BATTERY_FLAG_NO_BATTERY         0x80
#define BATTERY_FLAG_UNKNOWN            0xFF

#define BATTERY_PERCENTAGE_UNKNOWN      0xFF

#define SYSTEM_STATUS_FLAG_POWER_SAVING_ON      0x01

#define BATTERY_LIFE_UNKNOWN        0xFFFFFFFF

typedef struct _SYSTEM_POWER_STATUS {
    BYTE ACLineStatus;
    BYTE BatteryFlag;
    BYTE BatteryLifePercent;
    BYTE SystemStatusFlag;
    DWORD BatteryLifeTime;
    DWORD BatteryFullLifeTime;
}   SYSTEM_POWER_STATUS, *LPSYSTEM_POWER_STATUS;


BOOL
__stdcall
GetSystemPowerStatus(
     LPSYSTEM_POWER_STATUS lpSystemPowerStatus
    );

#endif /* WINVER >= 0x0400 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_PC_APP) */


#if (_WIN32_WINNT >= 0x0500)
//
// Very Large Memory API Subset
//


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


BOOL
__stdcall
MapUserPhysicalPagesScatter(
    _In_reads_(NumberOfPages) PVOID *VirtualAddresses,
     ULONG_PTR NumberOfPages,
    _In_reads_opt_(NumberOfPages) PULONG_PTR PageArray
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then



HANDLE
__stdcall
CreateJobObjectA(
     LPSECURITY_ATTRIBUTES lpJobAttributes,
     LPCSTR lpName
    );

#ifdef UNICODE
#define CreateJobObject  CreateJobObjectW
else
#define CreateJobObject  CreateJobObjectA
end  -- !UNICODE



HANDLE
__stdcall
OpenJobObjectA(
     DWORD dwDesiredAccess,
     BOOL bInheritHandle,
     LPCSTR lpName
    );

#ifdef UNICODE
#define OpenJobObject  OpenJobObjectW
else
#define OpenJobObject  OpenJobObjectA
end  -- !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


BOOL
__stdcall
CreateJobSet (
     ULONG NumJob,
    _In_reads_(NumJob) PJOB_SET_ARRAY UserJobSet,
     ULONG Flags);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


HANDLE
__stdcall
FindFirstVolumeA(
     LPSTR lpszVolumeName,
     DWORD cchBufferLength
    );
#ifndef UNICODE
#define FindFirstVolume FindFirstVolumeA
#endif


BOOL
__stdcall
FindNextVolumeA(
     HANDLE hFindVolume,
     LPSTR lpszVolumeName,
        DWORD cchBufferLength
    );
#ifndef UNICODE
#define FindNextVolume FindNextVolumeA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
--]=]


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

ffi.cdef[[
HANDLE
__stdcall
FindFirstVolumeMountPointA(
     LPCSTR lpszRootPathName,
     LPSTR lpszVolumeMountPoint,
     DWORD cchBufferLength
    );

HANDLE
__stdcall
FindFirstVolumeMountPointW(
     LPCWSTR lpszRootPathName,
     LPWSTR lpszVolumeMountPoint,
     DWORD cchBufferLength
    );
]]

--[[
#ifdef UNICODE
#define FindFirstVolumeMountPoint FindFirstVolumeMountPointW
else
#define FindFirstVolumeMountPoint FindFirstVolumeMountPointA
end  -- !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
FindNextVolumeMountPointA(
     HANDLE hFindVolumeMountPoint,
     LPSTR lpszVolumeMountPoint,
     DWORD cchBufferLength
    );

BOOL
__stdcall
FindNextVolumeMountPointW(
     HANDLE hFindVolumeMountPoint,
     LPWSTR lpszVolumeMountPoint,
     DWORD cchBufferLength
    );
]]

--[[
#ifdef UNICODE
#define FindNextVolumeMountPoint FindNextVolumeMountPointW
else
#define FindNextVolumeMountPoint FindNextVolumeMountPointA
end  -- !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
FindVolumeMountPointClose(
     HANDLE hFindVolumeMountPoint
    );
]]

ffi.cdef[[
BOOL
__stdcall
SetVolumeMountPointA(
     LPCSTR lpszVolumeMountPoint,
     LPCSTR lpszVolumeName
    );

BOOL
__stdcall
SetVolumeMountPointW(
     LPCWSTR lpszVolumeMountPoint,
     LPCWSTR lpszVolumeName
    );
]]

--[[
#ifdef UNICODE
#define SetVolumeMountPoint  SetVolumeMountPointW
else
#define SetVolumeMountPoint  SetVolumeMountPointA
end  -- !UNICODE
--]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


--[=[
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


BOOL
__stdcall
DeleteVolumeMountPointA(
     LPCSTR lpszVolumeMountPoint
    );
#ifndef UNICODE
#define DeleteVolumeMountPoint  DeleteVolumeMountPointA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

#ifndef UNICODE
#define GetVolumeNameForVolumeMountPoint  GetVolumeNameForVolumeMountPointA
#endif


BOOL
__stdcall
GetVolumeNameForVolumeMountPointA(
     LPCSTR lpszVolumeMountPoint,
     LPSTR lpszVolumeName,
     DWORD cchBufferLength
);


BOOL
__stdcall
GetVolumePathNameA(
     LPCSTR lpszFileName,
     LPSTR lpszVolumePathName,
     DWORD cchBufferLength
    );
#ifndef UNICODE
#define GetVolumePathName  GetVolumePathNameA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


#endif


#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

#if(_WIN32_WINNT >= 0x0501)


BOOL
__stdcall
GetVolumePathNamesForVolumeNameA(
      LPCSTR lpszVolumeName,
    _Out_writes_to_opt_(cchBufferLength, *lpcchReturnLength) _Post_ _NullNull_terminated_ LPCH lpszVolumePathNames,
      DWORD cchBufferLength,
     PDWORD lpcchReturnLength
    );

#ifndef UNICODE
#define GetVolumePathNamesForVolumeName  GetVolumePathNamesForVolumeNameA
#endif

end  -- (_WIN32_WINNT >= 0x0501)

#if (_WIN32_WINNT >= 0x0500) || (_WIN32_FUSION >= 0x0100) || ISOLATION_AWARE_ENABLED

#define ACTCTX_FLAG_PROCESSOR_ARCHITECTURE_VALID    (0x00000001)
#define ACTCTX_FLAG_LANGID_VALID                    (0x00000002)
#define ACTCTX_FLAG_ASSEMBLY_DIRECTORY_VALID        (0x00000004)
#define ACTCTX_FLAG_RESOURCE_NAME_VALID             (0x00000008)
#define ACTCTX_FLAG_SET_PROCESS_DEFAULT             (0x00000010)
#define ACTCTX_FLAG_APPLICATION_NAME_VALID          (0x00000020)
#define ACTCTX_FLAG_SOURCE_IS_ASSEMBLYREF           (0x00000040)
#define ACTCTX_FLAG_HMODULE_VALID                   (0x00000080)

typedef struct tagACTCTXA {
    ULONG       cbSize;
    DWORD       dwFlags;
    LPCSTR      lpSource;
    USHORT      wProcessorArchitecture;
    LANGID      wLangId;
    LPCSTR      lpAssemblyDirectory;
    LPCSTR      lpResourceName;
    LPCSTR      lpApplicationName;
    HMODULE     hModule;
} ACTCTXA, *PACTCTXA;
typedef struct tagACTCTXW {
    ULONG       cbSize;
    DWORD       dwFlags;
    LPCWSTR     lpSource;
    USHORT      wProcessorArchitecture;
    LANGID      wLangId;
    LPCWSTR     lpAssemblyDirectory;
    LPCWSTR     lpResourceName;
    LPCWSTR     lpApplicationName;
    HMODULE     hModule;
} ACTCTXW, *PACTCTXW;
#ifdef UNICODE
typedef ACTCTXW ACTCTX;
typedef PACTCTXW PACTCTX;
else
typedef ACTCTXA ACTCTX;
typedef PACTCTXA PACTCTX;
end  -- UNICODE

typedef const ACTCTXA *PCACTCTXA;
typedef const ACTCTXW *PCACTCTXW;
#ifdef UNICODE
typedef PCACTCTXW PCACTCTX;
else
typedef PCACTCTXA PCACTCTX;
end  -- UNICODE




HANDLE
__stdcall
CreateActCtxA(
     PCACTCTXA pActCtx
    );

HANDLE
__stdcall
CreateActCtxW(
     PCACTCTXW pActCtx
    );
#ifdef UNICODE
#define CreateActCtx  CreateActCtxW
else
#define CreateActCtx  CreateActCtxA
end  -- !UNICODE


VOID
__stdcall
AddRefActCtx(
     HANDLE hActCtx
    );



VOID
__stdcall
ReleaseActCtx(
     HANDLE hActCtx
    );


BOOL
__stdcall
ZombifyActCtx(
     HANDLE hActCtx
    );


_Success_(return)

BOOL
__stdcall
ActivateActCtx(
     HANDLE hActCtx,
       ULONG_PTR *lpCookie
    );


#define DEACTIVATE_ACTCTX_FLAG_FORCE_EARLY_DEACTIVATION (0x00000001)

_Success_(return)

BOOL
__stdcall
DeactivateActCtx(
     DWORD dwFlags,
     ULONG_PTR ulCookie
    );


BOOL
__stdcall
GetCurrentActCtx(
     HANDLE *lphActCtx);


typedef struct tagACTCTX_SECTION_KEYED_DATA_2600 {
    ULONG cbSize;
    ULONG ulDataFormatVersion;
    PVOID lpData;
    ULONG ulLength;
    PVOID lpSectionGlobalData;
    ULONG ulSectionGlobalDataLength;
    PVOID lpSectionBase;
    ULONG ulSectionTotalLength;
    HANDLE hActCtx;
    ULONG ulAssemblyRosterIndex;
} ACTCTX_SECTION_KEYED_DATA_2600, *PACTCTX_SECTION_KEYED_DATA_2600;
typedef const ACTCTX_SECTION_KEYED_DATA_2600 * PCACTCTX_SECTION_KEYED_DATA_2600;

typedef struct tagACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA {
    PVOID lpInformation;
    PVOID lpSectionBase;
    ULONG ulSectionLength;
    PVOID lpSectionGlobalDataBase;
    ULONG ulSectionGlobalDataLength;
} ACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA, *PACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA;
typedef const ACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA *PCACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA;

typedef struct tagACTCTX_SECTION_KEYED_DATA {
    ULONG cbSize;
    ULONG ulDataFormatVersion;
    PVOID lpData;
    ULONG ulLength;
    PVOID lpSectionGlobalData;
    ULONG ulSectionGlobalDataLength;
    PVOID lpSectionBase;
    ULONG ulSectionTotalLength;
    HANDLE hActCtx;
    ULONG ulAssemblyRosterIndex;
// 2600 stops here
    ULONG ulFlags;
    ACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA AssemblyMetadata;
} ACTCTX_SECTION_KEYED_DATA, *PACTCTX_SECTION_KEYED_DATA;
typedef const ACTCTX_SECTION_KEYED_DATA * PCACTCTX_SECTION_KEYED_DATA;

#define FIND_ACTCTX_SECTION_KEY_RETURN_HACTCTX (0x00000001)
#define FIND_ACTCTX_SECTION_KEY_RETURN_FLAGS   (0x00000002)
#define FIND_ACTCTX_SECTION_KEY_RETURN_ASSEMBLY_METADATA (0x00000004)



_Success_(return)

BOOL
__stdcall
FindActCtxSectionStringA(
           DWORD dwFlags,
     const GUID *lpExtensionGuid,
           ULONG ulSectionId,
           LPCSTR lpStringToFind,
          PACTCTX_SECTION_KEYED_DATA ReturnedData
    );
_Success_(return)

BOOL
__stdcall
FindActCtxSectionStringW(
           DWORD dwFlags,
     const GUID *lpExtensionGuid,
           ULONG ulSectionId,
           LPCWSTR lpStringToFind,
          PACTCTX_SECTION_KEYED_DATA ReturnedData
    );
#ifdef UNICODE
#define FindActCtxSectionString  FindActCtxSectionStringW
else
#define FindActCtxSectionString  FindActCtxSectionStringA
end  -- !UNICODE


BOOL
__stdcall
FindActCtxSectionGuid(
           DWORD dwFlags,
     const GUID *lpExtensionGuid,
           ULONG ulSectionId,
       const GUID *lpGuidToFind,
          PACTCTX_SECTION_KEYED_DATA ReturnedData
    );


#if !defined(RC_INVOKED) /* RC complains about long symbols in #ifs */
#if !defined(ACTIVATION_CONTEXT_BASIC_INFORMATION_DEFINED)

typedef struct _ACTIVATION_CONTEXT_BASIC_INFORMATION {
    HANDLE  hActCtx;
    DWORD   dwFlags;
} ACTIVATION_CONTEXT_BASIC_INFORMATION, *PACTIVATION_CONTEXT_BASIC_INFORMATION;

typedef const struct _ACTIVATION_CONTEXT_BASIC_INFORMATION *PCACTIVATION_CONTEXT_BASIC_INFORMATION;

#define ACTIVATION_CONTEXT_BASIC_INFORMATION_DEFINED 1

end  -- !defined(ACTIVATION_CONTEXT_BASIC_INFORMATION_DEFINED)
#endif

#define QUERY_ACTCTX_FLAG_USE_ACTIVE_ACTCTX (0x00000004)
#define QUERY_ACTCTX_FLAG_ACTCTX_IS_HMODULE (0x00000008)
#define QUERY_ACTCTX_FLAG_ACTCTX_IS_ADDRESS (0x00000010)
#define QUERY_ACTCTX_FLAG_NO_ADDREF         (0x80000000)



//
// switch (ulInfoClass)
//
//  case ActivationContextBasicInformation:
//    pvSubInstance == NULL
//    pvBuffer is of type PACTIVATION_CONTEXT_BASIC_INFORMATION
//
//  case ActivationContextDetailedInformation:
//    pvSubInstance == NULL
//    pvBuffer is of type PACTIVATION_CONTEXT_DETAILED_INFORMATION
//
//  case AssemblyDetailedInformationInActivationContext:
//    pvSubInstance is of type PULONG
//      *pvSubInstance < ACTIVATION_CONTEXT_DETAILED_INFORMATION::ulAssemblyCount
//    pvBuffer is of type PACTIVATION_CONTEXT_ASSEMBLY_DETAILED_INFORMATION
//
//  case FileInformationInAssemblyOfAssemblyInActivationContext:
//    pvSubInstance is of type PACTIVATION_CONTEXT_QUERY_INDEX
//      pvSubInstance->ulAssemblyIndex < ACTIVATION_CONTEXT_DETAILED_INFORMATION::ulAssemblyCount
//      pvSubInstance->ulFileIndexInAssembly < ACTIVATION_CONTEXT_ASSEMBLY_DETAILED_INFORMATION::ulFileCount
//    pvBuffer is of type PASSEMBLY_FILE_DETAILED_INFORMATION
//
//  case RunlevelInformationInActivationContext :
//    pvSubInstance == NULL
//    pvBuffer is of type PACTIVATION_CONTEXT_RUN_LEVEL_INFORMATION
//
// String are placed after the structs.
//
_Success_(return)

BOOL
__stdcall
QueryActCtxW(
          DWORD dwFlags,
          HANDLE hActCtx,
      PVOID pvSubInstance,
          ULONG ulInfoClass,
    _Out_writes_bytes_to_opt_(cbBuffer, *pcbWrittenOrRequired) PVOID pvBuffer,
          SIZE_T cbBuffer,
     SIZE_T *pcbWrittenOrRequired
    );

typedef _Success_(return) BOOL (__stdcall * PQUERYACTCTXW_FUNC)(
          DWORD dwFlags,
          HANDLE hActCtx,
      PVOID pvSubInstance,
          ULONG ulInfoClass,
    _Out_writes_bytes_to_opt_(cbBuffer, *pcbWrittenOrRequired) PVOID pvBuffer,
          SIZE_T cbBuffer,
     SIZE_T *pcbWrittenOrRequired
    );

end  -- (_WIN32_WINNT > 0x0500) || (_WIN32_FUSION >= 0x0100) || ISOLATION_AWARE_ENABLED

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


#if _WIN32_WINNT >= 0x0501


DWORD
__stdcall
WTSGetActiveConsoleSessionId(
    VOID
    );

end  -- (_WIN32_WINNT >= 0x0501)

#if (_WIN32_WINNT >= _WIN32_WINNT_WINTHRESHOLD)


DWORD
__stdcall
WTSGetServiceSessionId(
    VOID
    );


BOOLEAN
__stdcall
WTSIsServerContainer(
    VOID
    );

end  -- (_WIN32_WINNT >= _WIN32_WINNT_WINTHRESHOLD)

#if _WIN32_WINNT >= 0x0601


WORD
__stdcall
GetActiveProcessorGroupCount(
    VOID
    );


WORD
__stdcall
GetMaximumProcessorGroupCount(
    VOID
    );


DWORD
__stdcall
GetActiveProcessorCount(
     WORD GroupNumber
    );


DWORD
__stdcall
GetMaximumProcessorCount(
     WORD GroupNumber
    );

end  -- (_WIN32_WINNT >=0x0601)

//
// NUMA Information routines.
//


BOOL
__stdcall
GetNumaProcessorNode(
      UCHAR Processor,
     PUCHAR NodeNumber
    );

#if _WIN32_WINNT >= 0x0601


BOOL
__stdcall
GetNumaNodeNumberFromHandle(
      HANDLE hFile,
     PUSHORT NodeNumber
    );

end  -- (_WIN32_WINNT >=0x0601)

#if _WIN32_WINNT >= 0x0601


BOOL
__stdcall
GetNumaProcessorNodeEx(
      PPROCESSOR_NUMBER Processor,
     PUSHORT NodeNumber
    );

end  -- (_WIN32_WINNT >=0x0601)


BOOL
__stdcall
GetNumaNodeProcessorMask(
      UCHAR Node,
     PULONGLONG ProcessorMask
    );


BOOL
__stdcall
GetNumaAvailableMemoryNode(
      UCHAR Node,
     PULONGLONG AvailableBytes
    );

#if _WIN32_WINNT >= 0x0601


BOOL
__stdcall
GetNumaAvailableMemoryNodeEx(
      USHORT Node,
     PULONGLONG AvailableBytes
    );

end  -- (_WIN32_WINNT >=0x0601)

#if (_WIN32_WINNT >= 0x0600)


BOOL
__stdcall
GetNumaProximityNode(
      ULONG ProximityId,
     PUCHAR NodeNumber
    );

#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

//
// Application restart and data recovery callback
//
typedef DWORD (__stdcall *APPLICATION_RECOVERY_CALLBACK)(PVOID pvParameter);

//
// Max length of commandline in characters (including the NULL character that can be registered for restart)
//
#define RESTART_MAX_CMD_LINE    1024

//
// Do not restart the process for termination due to application crashes
//
#define RESTART_NO_CRASH        1

//
// Do not restart the process for termination due to application hangs
//
#define RESTART_NO_HANG         2

//
// Do not restart the process for termination due to patch installations
//
#define RESTART_NO_PATCH        4

//
// Do not restart the process when the system is rebooted due to patch installations
//
#define RESTART_NO_REBOOT        8

#define RECOVERY_DEFAULT_PING_INTERVAL  5000
#define RECOVERY_MAX_PING_INTERVAL      (5 * 60 * 1000)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

#if (_WIN32_WINNT >= 0x0600)


HRESULT
__stdcall
RegisterApplicationRecoveryCallback(
      APPLICATION_RECOVERY_CALLBACK pRecoveyCallback,
      PVOID pvParameter,
     DWORD dwPingInterval,
     DWORD dwFlags
    );


HRESULT
__stdcall
UnregisterApplicationRecoveryCallback(void);


HRESULT
__stdcall
RegisterApplicationRestart(
     PCWSTR pwzCommandline,
     DWORD dwFlags
    );


HRESULT
__stdcall
UnregisterApplicationRestart(void);

end  -- _WIN32_WINNT >= 0x0600

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

#if (_WIN32_WINNT >= 0x0600)


HRESULT
__stdcall
GetApplicationRecoveryCallback(
      HANDLE hProcess,
     APPLICATION_RECOVERY_CALLBACK* pRecoveryCallback,
    _Outptr_opt_result_maybenull_ PVOID* ppvParameter,
     PDWORD pdwPingInterval,
     PDWORD pdwFlags
    );


HRESULT
__stdcall
GetApplicationRestartSettings(
     HANDLE hProcess,
    _Out_writes_opt_(*pcchSize) PWSTR pwzCommandline,
     PDWORD pcchSize,
     PDWORD pdwFlags
    );

end  -- _WIN32_WINNT >= 0x0600

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

#if (_WIN32_WINNT >= 0x0600)


HRESULT
__stdcall
ApplicationRecoveryInProgress(
     PBOOL pbCancelled
    );


VOID
__stdcall
ApplicationRecoveryFinished(
     BOOL bSuccess
    );

end  -- _WIN32_WINNT >= 0x0600

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


#if (_WIN32_WINNT >= 0x0600)


#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

typedef struct _FILE_BASIC_INFO {
    LARGE_INTEGER CreationTime;
    LARGE_INTEGER LastAccessTime;
    LARGE_INTEGER LastWriteTime;
    LARGE_INTEGER ChangeTime;
    DWORD FileAttributes;
} FILE_BASIC_INFO, *PFILE_BASIC_INFO;

typedef struct _FILE_STANDARD_INFO {
    LARGE_INTEGER AllocationSize;
    LARGE_INTEGER EndOfFile;
    DWORD NumberOfLinks;
    BOOLEAN DeletePending;
    BOOLEAN Directory;
} FILE_STANDARD_INFO, *PFILE_STANDARD_INFO;

typedef struct _FILE_NAME_INFO {
    DWORD FileNameLength;
    WCHAR FileName[1];
} FILE_NAME_INFO, *PFILE_NAME_INFO;

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN10_RS1)
#define FILE_RENAME_FLAG_REPLACE_IF_EXISTS                  0x00000001
#define FILE_RENAME_FLAG_POSIX_SEMANTICS                    0x00000002
#endif

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN10_RS3)
#define FILE_RENAME_FLAG_SUPPRESS_PIN_STATE_INHERITANCE     0x00000004
#endif

typedef struct _FILE_RENAME_INFO {
#if (_WIN32_WINNT >= _WIN32_WINNT_WIN10_RS1)
    union {
        BOOLEAN ReplaceIfExists;  // FileRenameInfo
        DWORD Flags;              // FileRenameInfoEx
    } DUMMYUNIONNAME;
else
    BOOLEAN ReplaceIfExists;
#endif
    HANDLE RootDirectory;
    DWORD FileNameLength;
    WCHAR FileName[1];
} FILE_RENAME_INFO, *PFILE_RENAME_INFO;

typedef struct _FILE_ALLOCATION_INFO {
    LARGE_INTEGER AllocationSize;
} FILE_ALLOCATION_INFO, *PFILE_ALLOCATION_INFO;

typedef struct _FILE_END_OF_FILE_INFO {
    LARGE_INTEGER EndOfFile;
} FILE_END_OF_FILE_INFO, *PFILE_END_OF_FILE_INFO;

typedef struct _FILE_STREAM_INFO {
    DWORD NextEntryOffset;
    DWORD StreamNameLength;
    LARGE_INTEGER StreamSize;
    LARGE_INTEGER StreamAllocationSize;
    WCHAR StreamName[1];
} FILE_STREAM_INFO, *PFILE_STREAM_INFO;

typedef struct _FILE_COMPRESSION_INFO {
    LARGE_INTEGER CompressedFileSize;
    WORD CompressionFormat;
    UCHAR CompressionUnitShift;
    UCHAR ChunkShift;
    UCHAR ClusterShift;
    UCHAR Reserved[3];
} FILE_COMPRESSION_INFO, *PFILE_COMPRESSION_INFO;

typedef struct _FILE_ATTRIBUTE_TAG_INFO {
    DWORD FileAttributes;
    DWORD ReparseTag;
} FILE_ATTRIBUTE_TAG_INFO, *PFILE_ATTRIBUTE_TAG_INFO;

typedef struct _FILE_DISPOSITION_INFO {
    BOOLEAN DeleteFile;
} FILE_DISPOSITION_INFO, *PFILE_DISPOSITION_INFO;

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN10_RS1)
#define FILE_DISPOSITION_FLAG_DO_NOT_DELETE              0x00000000
#define FILE_DISPOSITION_FLAG_DELETE                     0x00000001
#define FILE_DISPOSITION_FLAG_POSIX_SEMANTICS            0x00000002
#define FILE_DISPOSITION_FLAG_FORCE_IMAGE_SECTION_CHECK  0x00000004
#define FILE_DISPOSITION_FLAG_ON_CLOSE                   0x00000008

typedef struct _FILE_DISPOSITION_INFO_EX {
    DWORD Flags;
} FILE_DISPOSITION_INFO_EX, *PFILE_DISPOSITION_INFO_EX;
#endif

typedef struct _FILE_ID_BOTH_DIR_INFO {
    DWORD NextEntryOffset;
    DWORD FileIndex;
    LARGE_INTEGER CreationTime;
    LARGE_INTEGER LastAccessTime;
    LARGE_INTEGER LastWriteTime;
    LARGE_INTEGER ChangeTime;
    LARGE_INTEGER EndOfFile;
    LARGE_INTEGER AllocationSize;
    DWORD FileAttributes;
    DWORD FileNameLength;
    DWORD EaSize;
    CCHAR ShortNameLength;
    WCHAR ShortName[12];
    LARGE_INTEGER FileId;
    WCHAR FileName[1];
} FILE_ID_BOTH_DIR_INFO, *PFILE_ID_BOTH_DIR_INFO;

typedef struct _FILE_FULL_DIR_INFO {
    ULONG NextEntryOffset;
    ULONG FileIndex;
    LARGE_INTEGER CreationTime;
    LARGE_INTEGER LastAccessTime;
    LARGE_INTEGER LastWriteTime;
    LARGE_INTEGER ChangeTime;
    LARGE_INTEGER EndOfFile;
    LARGE_INTEGER AllocationSize;
    ULONG FileAttributes;
    ULONG FileNameLength;
    ULONG EaSize;
    WCHAR FileName[1];
} FILE_FULL_DIR_INFO, *PFILE_FULL_DIR_INFO;

typedef enum _PRIORITY_HINT {
      IoPriorityHintVeryLow = 0,
      IoPriorityHintLow,
      IoPriorityHintNormal,
      MaximumIoPriorityHintType
} PRIORITY_HINT;

typedef struct _FILE_IO_PRIORITY_HINT_INFO {
    PRIORITY_HINT PriorityHint;
} FILE_IO_PRIORITY_HINT_INFO, *PFILE_IO_PRIORITY_HINT_INFO;

// Structure and constants must match those in ntioapi_x.w

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN8)

typedef struct _FILE_ALIGNMENT_INFO {
    ULONG AlignmentRequirement;
} FILE_ALIGNMENT_INFO, *PFILE_ALIGNMENT_INFO;


//
//  Flag definitions for FILE_STORAGE_INFO structure
//

//
//  If this flag is set then the partition is correctly aligned with the
//  physical sector size of the device for optimial performance.
//
#define STORAGE_INFO_FLAGS_ALIGNED_DEVICE                 0x00000001
#define STORAGE_INFO_FLAGS_PARTITION_ALIGNED_ON_DEVICE    0x00000002

//
//  If this value is set for the Sector and Parition alignment
//  fields then it means the alignment is not known and the
//  alignment flags have no meaning
//
#define STORAGE_INFO_OFFSET_UNKNOWN (0xffffffff)

typedef struct _FILE_STORAGE_INFO {
    ULONG LogicalBytesPerSector;
    ULONG PhysicalBytesPerSectorForAtomicity;
    ULONG PhysicalBytesPerSectorForPerformance;
    ULONG FileSystemEffectivePhysicalBytesPerSectorForAtomicity;
    ULONG Flags;
    ULONG ByteOffsetForSectorAlignment;
    ULONG ByteOffsetForPartitionAlignment;
} FILE_STORAGE_INFO, *PFILE_STORAGE_INFO;

//
//  Structure definition for FileIdInfo
//
typedef struct _FILE_ID_INFO {
    ULONGLONG VolumeSerialNumber;
    FILE_ID_128 FileId;
} FILE_ID_INFO, *PFILE_ID_INFO;

//
//  Structure definition for FileIdExtdDirectoryInfo
//
typedef struct _FILE_ID_EXTD_DIR_INFO {
    ULONG NextEntryOffset;
    ULONG FileIndex;
    LARGE_INTEGER CreationTime;
    LARGE_INTEGER LastAccessTime;
    LARGE_INTEGER LastWriteTime;
    LARGE_INTEGER ChangeTime;
    LARGE_INTEGER EndOfFile;
    LARGE_INTEGER AllocationSize;
    ULONG FileAttributes;
    ULONG FileNameLength;
    ULONG EaSize;
    ULONG ReparsePointTag;
    FILE_ID_128 FileId;
    WCHAR FileName[1];
} FILE_ID_EXTD_DIR_INFO, *PFILE_ID_EXTD_DIR_INFO;

#endif

//
// File Remote protocol info (FileRemoteProtocolInfo)
//

// Protocol generic flags.

#define REMOTE_PROTOCOL_INFO_FLAG_LOOPBACK              0x00000001
#define REMOTE_PROTOCOL_INFO_FLAG_OFFLINE               0x00000002

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN8)
#define REMOTE_PROTOCOL_INFO_FLAG_PERSISTENT_HANDLE     0x00000004
#endif

// Protocol specific SMB2 share capability flags.

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN8)
#define RPI_FLAG_SMB2_SHARECAP_TIMEWARP                0x00000002
#define RPI_FLAG_SMB2_SHARECAP_DFS                     0x00000008
#define RPI_FLAG_SMB2_SHARECAP_CONTINUOUS_AVAILABILITY 0x00000010
#define RPI_FLAG_SMB2_SHARECAP_SCALEOUT                0x00000020
#define RPI_FLAG_SMB2_SHARECAP_CLUSTER                 0x00000040
#endif

// Protocol specific SMB2 server capability flags.

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN8)
#define RPI_SMB2_FLAG_SERVERCAP_DFS                    0x00000001
#define RPI_SMB2_FLAG_SERVERCAP_LEASING                0x00000002
#define RPI_SMB2_FLAG_SERVERCAP_LARGEMTU               0x00000004
#define RPI_SMB2_FLAG_SERVERCAP_MULTICHANNEL           0x00000008
#define RPI_SMB2_FLAG_SERVERCAP_PERSISTENT_HANDLES     0x00000010
#define RPI_SMB2_FLAG_SERVERCAP_DIRECTORY_LEASING      0x00000020
#endif

typedef struct _FILE_REMOTE_PROTOCOL_INFO
{
    // Structure Version
    USHORT StructureVersion;     // 1 for Win7, 2 for Win8 SMB3, 3 for Blue SMB3.
    USHORT StructureSize;        // sizeof(FILE_REMOTE_PROTOCOL_INFO)

    ULONG  Protocol;             // Protocol (WNNC_NET_*) defined in winnetwk.h or ntifs.h.

    // Protocol Version & Type
    USHORT ProtocolMajorVersion;
    USHORT ProtocolMinorVersion;
    USHORT ProtocolRevision;

    USHORT Reserved;

    // Protocol-Generic Information
    ULONG  Flags;

    struct {
        ULONG Reserved[8];
    } GenericReserved;

    // Protocol specific information

#if (_WIN32_WINNT < _WIN32_WINNT_WIN8)
    struct {
        ULONG Reserved[16];
    } ProtocolSpecificReserved;
#endif

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN8)
    union {

        struct {

            struct {
                ULONG Capabilities;
            } Server;

            struct {
                ULONG Capabilities;
                ULONG CachingFlags;
            } Share;

        } Smb2;

        ULONG Reserved[16];

    } ProtocolSpecific;

#endif

} FILE_REMOTE_PROTOCOL_INFO, *PFILE_REMOTE_PROTOCOL_INFO;


BOOL
__stdcall
GetFileInformationByHandleEx(
      HANDLE hFile,
      FILE_INFO_BY_HANDLE_CLASS FileInformationClass,
    _Out_writes_bytes_(dwBufferSize) LPVOID lpFileInformation,
      DWORD dwBufferSize
);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

typedef enum _FILE_ID_TYPE {
      FileIdType,
      ObjectIdType,
      ExtendedFileIdType,
      MaximumFileIdType
} FILE_ID_TYPE, *PFILE_ID_TYPE;

typedef struct FILE_ID_DESCRIPTOR {
    DWORD dwSize;  // Size of the struct
    FILE_ID_TYPE Type; // Describes the type of identifier passed in.
    union {
        LARGE_INTEGER FileId;
        GUID ObjectId;
#if (_WIN32_WINNT >= _WIN32_WINNT_WIN8)
        FILE_ID_128 ExtendedFileId;
#endif
    } DUMMYUNIONNAME;
} FILE_ID_DESCRIPTOR, *LPFILE_ID_DESCRIPTOR;


HANDLE
__stdcall
OpenFileById (
         HANDLE hVolumeHint,
         LPFILE_ID_DESCRIPTOR lpFileId,
         DWORD dwDesiredAccess,
         DWORD dwShareMode,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes,
         DWORD dwFlagsAndAttributes
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


#endif


#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

#if (_WIN32_WINNT >= 0x0600)

//
//  Flag values for the dwFlags parameter of the CreateSymbolicLink API
//

//  Request to create a directory symbolic link
#define SYMBOLIC_LINK_FLAG_DIRECTORY                    (0x1)

//  Specify this flag if you want to allow creation of symbolic links when the
//  process is not elevated.  As of now enabling DEVELOPER MODE on a system
//  is the only scenario that allow unprivileged symlink creation. There may
//  be future scenarios that this flag will enable in the future.
//
//  Also be aware that the behavior of this API with this flag set will likely
//  be different between a development environment and an and customers
//  environment so please be careful with the usage of this flag.

#define SYMBOLIC_LINK_FLAG_ALLOW_UNPRIVILEGED_CREATE    (0x2)



BOOLEAN
APIENTRY
CreateSymbolicLinkA (
     LPCSTR lpSymlinkFileName,
     LPCSTR lpTargetFileName,
     DWORD dwFlags
    );

BOOLEAN
APIENTRY
CreateSymbolicLinkW (
     LPCWSTR lpSymlinkFileName,
     LPCWSTR lpTargetFileName,
     DWORD dwFlags
    );
#ifdef UNICODE
#define CreateSymbolicLink  CreateSymbolicLinkW
else
#define CreateSymbolicLink  CreateSymbolicLinkA
end  -- !UNICODE

end  -- (_WIN32_WINNT >= 0x0600)

#if (_WIN32_WINNT >= 0x0600)


BOOL
__stdcall
QueryActCtxSettingsW(
          DWORD dwFlags,
          HANDLE hActCtx,
          PCWSTR settingsNameSpace,
              PCWSTR settingName,
    _Out_writes_bytes_to_opt_(dwBuffer, *pdwWrittenOrRequired) PWSTR pvBuffer,
          SIZE_T dwBuffer,
     SIZE_T *pdwWrittenOrRequired
    );

#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

#if (_WIN32_WINNT >= 0x0600)


BOOLEAN
APIENTRY
CreateSymbolicLinkTransactedA (
         LPCSTR lpSymlinkFileName,
         LPCSTR lpTargetFileName,
         DWORD dwFlags,
         HANDLE hTransaction
    );

BOOLEAN
APIENTRY
CreateSymbolicLinkTransactedW (
         LPCWSTR lpSymlinkFileName,
         LPCWSTR lpTargetFileName,
         DWORD dwFlags,
         HANDLE hTransaction
    );
#ifdef UNICODE
#define CreateSymbolicLinkTransacted  CreateSymbolicLinkTransactedW
else
#define CreateSymbolicLinkTransacted  CreateSymbolicLinkTransactedA
end  -- !UNICODE

end  -- (_WIN32_WINNT >= 0x0600)

#if (_WIN32_WINNT >= 0x0600)


BOOL
__stdcall
ReplacePartitionUnit (
     PWSTR TargetPartition,
     PWSTR SparePartition,
     ULONG Flags
    );

#endif


#if (_WIN32_WINNT >= 0x0600)


BOOL
__stdcall
AddSecureMemoryCacheCallback(
     __callback PSECURE_MEMORY_CACHE_CALLBACK pfnCallBack
    );


BOOL
__stdcall
RemoveSecureMemoryCacheCallback(
     __callback PSECURE_MEMORY_CACHE_CALLBACK pfnCallBack
    );

#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


#if (NTDDI_VERSION >= NTDDI_WIN7SP1)


#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)



BOOL
__stdcall
CopyContext(
     PCONTEXT Destination,
     DWORD ContextFlags,
     PCONTEXT Source
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)



BOOL
__stdcall
InitializeContext(
    _Out_writes_bytes_opt_(*ContextLength) PVOID Buffer,
     DWORD ContextFlags,
     PCONTEXT* Context,
     PDWORD ContextLength
    );
#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


#if defined(_AMD64_) || defined(_X86_)


#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


DWORD64
__stdcall
GetEnabledXStateFeatures(
    VOID
    );



BOOL
__stdcall
GetXStateFeaturesMask(
     PCONTEXT Context,
     PDWORD64 FeatureMask
    );

_Success_(return != NULL)

PVOID
__stdcall
LocateXStateFeature(
     PCONTEXT Context,
     DWORD FeatureId,
     PDWORD Length
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)



BOOL
__stdcall
SetXStateFeaturesMask(
     PCONTEXT Context,
     DWORD64 FeatureMask
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


#endif /* defined(_AMD64_) || defined(_X86_) */

#endif /* (NTDDI_VERSION >= NTDDI_WIN7SP1) */

#if (_WIN32_WINNT >= 0x0601)


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

ffi.cdef[[
DWORD
APIENTRY
EnableThreadProfiling(
     HANDLE ThreadHandle,
     DWORD Flags,
     DWORD64 HardwareCounters,
     HANDLE *PerformanceDataHandle
    );


DWORD
APIENTRY
DisableThreadProfiling(
     HANDLE PerformanceDataHandle
    );


DWORD
APIENTRY
QueryThreadProfiling(
     HANDLE ThreadHandle,
     PBOOLEAN Enabled
    );


DWORD
APIENTRY
ReadThreadProfilingData(
     HANDLE PerformanceDataHandle,
     DWORD Flags,
     PPERFORMANCE_DATA PerformanceData
    );
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


end --/* (_WIN32_WINNT >= 0x0601) */

if (NTDDI_VERSION >= NTDDI_WIN10_RS4) then


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
DWORD
__stdcall
RaiseCustomSystemEventTrigger(
     PCUSTOM_SYSTEM_EVENT_TRIGGER_CONFIG CustomSystemEventTriggerConfig
    );
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


end --/* (NTDDI_VERSION >= NTDDI_WIN10_RS4) */



#if !defined(RC_INVOKED) /* RC complains about long symbols in #ifs */
#if defined(ISOLATION_AWARE_ENABLED) && (ISOLATION_AWARE_ENABLED != 0)
#include "winbase.inl"
#endif /* ISOLATION_AWARE_ENABLED */
#endif /* RC */

#ifdef __cplusplus
}
#endif

#if defined (_MSC_VER)
#if _MSC_VER >= 1200
#pragma warning(pop)
else
#pragma warning(default:4001) /* nonstandard extension : single line comment */
#pragma warning(default:4201) /* nonstandard extension used : nameless struct/union */
#pragma warning(default:4214) /* nonstandard extension used : bit field types other then int */
#endif
#endif



end  -- _WINBASE_

#if !defined(RC_INVOKED)
#if !defined(NOWINBASEINTERLOCK)
#if !defined(_NTOS_)
/*++

Copyright (c) Microsoft Corporation.  All rights reserved.

Module Name:

    winbase_interlockedcplusplus.h

Abstract:

    C++ function overloads in place of "manual name mangling".
    This file is meant to be #included by winbase.h or any other file declaring the signed interlocked functions.

Author:

    Jay Krell (JayKrell) April 2002

--*/

#if !defined(RC_INVOKED) /* { */

#if !defined(MICROSOFT_WINDOWS_WINBASE_INTERLOCKED_CPLUSPLUS_H_INCLUDED) /* { */
#define MICROSOFT_WINDOWS_WINBASE_INTERLOCKED_CPLUSPLUS_H_INCLUDED
#if _MSC_VER > 1000
#pragma once
#endif

#if !defined(MIDL_PASS) /* { */

/*
To turn off/hide the contents of this file:
 #define MICROSOFT_WINDOWS_WINBASE_H_DEFINE_INTERLOCKED_CPLUSPLUS_OVERLOADS 0
*/

#if !defined(MICROSOFT_WINDOWS_WINBASE_H_DEFINE_INTERLOCKED_CPLUSPLUS_OVERLOADS)
#define MICROSOFT_WINDOWS_WINBASE_H_DEFINE_INTERLOCKED_CPLUSPLUS_OVERLOADS (_WIN32_WINNT >= 0x0502 || !defined(_WINBASE_))
#endif

#if MICROSOFT_WINDOWS_WINBASE_H_DEFINE_INTERLOCKED_CPLUSPLUS_OVERLOADS  /* { */

#if defined(__cplusplus) /* { */

extern "C++" {

FORCEINLINE
unsigned
InterlockedIncrement(
     _Interlocked_operand_ unsigned volatile *Addend
    )
{
    return (unsigned) _InterlockedIncrement((volatile long*) Addend);
}

FORCEINLINE
unsigned long
InterlockedIncrement(
     _Interlocked_operand_ unsigned long volatile *Addend
    )
{
    return (unsigned long) _InterlockedIncrement((volatile long*) Addend);
}

// ARM64_WORKAROUND : should this work for managed code?
#if (defined(_WIN64) && !defined(_ARM64_)) || ((_WIN32_WINNT >= 0x0502) && defined(_WINBASE_) && !defined(_MANAGED))

FORCEINLINE
unsigned __int64
InterlockedIncrement(
     _Interlocked_operand_ unsigned __int64 volatile *Addend
    )
{
    return (unsigned __int64) (InterlockedIncrement64)((volatile __int64*) Addend);
}

#endif

FORCEINLINE
unsigned
InterlockedDecrement(
     _Interlocked_operand_ unsigned volatile *Addend
    )
{
    return (unsigned long) _InterlockedDecrement((volatile long*) Addend);
}

FORCEINLINE
unsigned long
InterlockedDecrement(
     _Interlocked_operand_ unsigned long volatile *Addend
    )
{
    return (unsigned long) _InterlockedDecrement((volatile long*) Addend);
}

// ARM64_WORKAROUND : should this work for managed code?
#if (defined(_WIN64) && !defined(_ARM64_)) || ((_WIN32_WINNT >= 0x0502) && defined(_WINBASE_) && !defined(_MANAGED))

FORCEINLINE
unsigned __int64
InterlockedDecrement(
     _Interlocked_operand_ unsigned __int64 volatile *Addend
    )
{
    return (unsigned __int64) (InterlockedDecrement64)((volatile __int64*) Addend);
}

#endif

#if !defined(_M_CEE_PURE)

FORCEINLINE
unsigned
InterlockedExchange(
     _Interlocked_operand_ unsigned volatile *Target,
     unsigned Value
    )
{
    return (unsigned) _InterlockedExchange((volatile long*) Target, (long) Value);
}

FORCEINLINE
unsigned long
InterlockedExchange(
     _Interlocked_operand_ unsigned long volatile *Target,
     unsigned long Value
    )
{
    return (unsigned long) _InterlockedExchange((volatile long*) Target, (long) Value);
}

#if defined(_WIN64) || ((_WIN32_WINNT >= 0x0502) && defined(_WINBASE_) && !defined(_MANAGED))

FORCEINLINE
unsigned __int64
InterlockedExchange(
     _Interlocked_operand_ unsigned __int64 volatile *Target,
     unsigned __int64 Value
    )
{
    return (unsigned __int64) InterlockedExchange64((volatile __int64*) Target, (__int64) Value);
}

#endif

FORCEINLINE
unsigned
InterlockedExchangeAdd(
     _Interlocked_operand_ unsigned volatile *Addend,
     unsigned Value
    )
{
    return (unsigned) _InterlockedExchangeAdd((volatile long*) Addend, (long) Value);
}

FORCEINLINE
unsigned
InterlockedExchangeSubtract(
     _Interlocked_operand_ unsigned volatile *Addend,
     unsigned Value
    )
{
    return (unsigned) _InterlockedExchangeAdd((volatile long*) Addend,  - (long) Value);
}

FORCEINLINE
unsigned long
InterlockedExchangeAdd(
     _Interlocked_operand_ unsigned long volatile *Addend,
     unsigned long Value
    )
{
    return (unsigned long) _InterlockedExchangeAdd((volatile long*) Addend, (long) Value);
}

FORCEINLINE
unsigned long
InterlockedExchangeSubtract(
     _Interlocked_operand_ unsigned long volatile *Addend,
     unsigned long Value
    )
{
    return (unsigned long) _InterlockedExchangeAdd((volatile long*) Addend,  - (long) Value);
}

#if defined(_WIN64) || ((_WIN32_WINNT >= 0x0502) && defined(_WINBASE_) && !defined(_MANAGED))

FORCEINLINE
unsigned __int64
InterlockedExchangeAdd(
     _Interlocked_operand_ unsigned __int64 volatile *Addend,
     unsigned __int64 Value
    )
{
    return (unsigned __int64) InterlockedExchangeAdd64((volatile __int64*) Addend,  (__int64) Value);
}

FORCEINLINE
unsigned __int64
InterlockedExchangeSubtract(
     _Interlocked_operand_ unsigned __int64 volatile *Addend,
     unsigned __int64 Value
    )
{
    return (unsigned __int64) InterlockedExchangeAdd64((volatile __int64*) Addend,  - (__int64) Value);
}

#endif

FORCEINLINE
unsigned
InterlockedCompareExchange(
     _Interlocked_operand_ unsigned volatile *Destination,
     unsigned Exchange,
     unsigned Comperand
    )
{
    return (unsigned) _InterlockedCompareExchange((volatile long*) Destination, (long) Exchange, (long) Comperand);
}

FORCEINLINE
unsigned long
InterlockedCompareExchange(
     _Interlocked_operand_ unsigned long volatile *Destination,
     unsigned long Exchange,
     unsigned long Comperand
    )
{
    return (unsigned long) _InterlockedCompareExchange((volatile long*) Destination, (long) Exchange, (long) Comperand);
}

#if defined(_WIN64) || ((_WIN32_WINNT >= 0x0502) && defined(_WINBASE_) && !defined(_MANAGED))

FORCEINLINE
unsigned __int64
InterlockedCompareExchange(
     _Interlocked_operand_ unsigned __int64 volatile *Destination,
     unsigned __int64 Exchange,
     unsigned __int64 Comperand
    )
{
    return (unsigned __int64) _InterlockedCompareExchange64((volatile __int64*) Destination, (__int64) Exchange, (__int64) Comperand);
}

FORCEINLINE
unsigned __int64
InterlockedAnd(
     _Interlocked_operand_ unsigned __int64 volatile *Destination,
     unsigned __int64 Value
    )
{
    return (unsigned __int64) InterlockedAnd64((volatile __int64*) Destination, (__int64) Value);
}

FORCEINLINE
unsigned __int64
InterlockedOr(
     _Interlocked_operand_ unsigned __int64 volatile *Destination,
     unsigned __int64 Value
    )
{
    return (unsigned __int64) InterlockedOr64((volatile __int64*) Destination, (__int64) Value);
}

FORCEINLINE
unsigned __int64
InterlockedXor(
     _Interlocked_operand_ unsigned __int64 volatile *Destination,
     unsigned __int64 Value
    )
{
    return (unsigned __int64) InterlockedXor64((volatile __int64*) Destination, (__int64) Value);
}

#endif

#endif /* !defined(_M_CEE_PURE) */

} /* extern "C++" */
#endif /* } __cplusplus */

#endif /* } MICROSOFT_WINBASE_H_DEFINE_INTERLOCKED_CPLUSPLUS_OVERLOADS */

#undef MICROSOFT_WINBASE_H_DEFINE_INTERLOCKED_CPLUSPLUS_OVERLOADS
#define MICROSOFT_WINBASE_H_DEFINE_INTERLOCKED_CPLUSPLUS_OVERLOADS 0

#endif /* } MIDL_PASS */
#endif /* } MICROSOFT_WINDOWS_WINBASE_INTERLOCKED_CPLUSPLUS_H_INCLUDED */
#endif /* } RC_INVOKED */
#endif /* _NTOS_ */
#endif /* NOWINBASEINTERLOCK */
#endif /* RC_INVOKED */
--]=]