local ffi = require("ffi")




require("win32.minwinbase")


-- APISET contracts


require("win32.processenv")
require("win32.fileapi")            -- NYI
--require("win32.debugapi")           -- dbghelp
require("win32.utilapiset")
require("win32.handleapi")
require("win32.errhandlingapi")
--require("win32.fibersapi")          -- NYI
--require("win32.namedpipeapi")       -- NYI
require("win32.profileapi")
require("win32.heapapi")
require("win32.ioapiset")
require("win32.synchapi")
--require("win32.interlockedapi")     -- NYI, not sure if it can be done
require("win32.processthreadsapi")
require("win32.sysinfoapi")
require("win32.memoryapi")
--require("win32.enclaveapi")         -- NYI
--require("win32.threadpoollegacyapiset") -- NYI, not sure if it's needed
--require("win32.threadpoolapiset")   -- NYI
--require("win32.jobapi")             -- NYI
--require("win32.jobapi2")            -- NYI
--require("win32.wow64apiset")        -- NYI
require("win32.libloaderapi")
--require("win32.securitybaseapi")    -- NYI, experimental
--require("win32.namespaceapi")       -- NYI
--require("win32.systemtopologyapi")  -- NYI
--require("win32.processtopologyapi") -- NYI
--require("win32.securityappcontainer")   -- NYI
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

--[=[
#if (_WIN32_WINNT >= _WIN32_WINNT_WIN8)

//
//  These are flags supported only through CreateFile2 (W8 and beyond)
//
//  Due to the multiplexing of file creation flags, file attribute flags and
//  security QoS flags into a single DWORD (dwFlagsAndAttributes) parameter for
//  CreateFile, there is no way to add any more flags to CreateFile. Additional
//  flags for the create operation must be added to CreateFile2 only
//

#define FILE_FLAG_OPEN_REQUIRING_OPLOCK 0x00040000

#endif



#if(_WIN32_WINNT >= 0x0400)
//
// Define possible return codes from the CopyFileEx callback routine
//

#define PROGRESS_CONTINUE  = 0;
#define PROGRESS_CANCEL    = 1;
#define PROGRESS_STOP      = 2;
#define PROGRESS_QUIET     = 3;

//
// Define CopyFileEx callback routine state change values
//

#define CALLBACK_CHUNK_FINISHED        = 0x00000000;
#define CALLBACK_STREAM_SWITCH         = 0x00000001;

//
// Define CopyFileEx option flags
//

#define COPY_FILE_FAIL_IF_EXISTS               = 0x00000001;
#define COPY_FILE_RESTARTABLE                  = 0x00000002;
#define COPY_FILE_OPEN_SOURCE_FOR_WRITE        = 0x00000004;
#define COPY_FILE_ALLOW_DECRYPTED_DESTINATION  = 0x00000008;

//
//  Gap for private copyfile flags
//

#if (_WIN32_WINNT >= 0x0600)
#define COPY_FILE_COPY_SYMLINK               = 0x00000800;
#define COPY_FILE_NO_BUFFERING               = 0x00001000;
#endif


#if (_WIN32_WINNT >= _WIN32_WINNT_WIN8)

//
//  CopyFile2 flags
//

#define COPY_FILE_REQUEST_SECURITY_PRIVILEGES        0x00002000
#define COPY_FILE_RESUME_FROM_PAUSE                  0x00004000


#define COPY_FILE_NO_OFFLOAD                         0x00040000

#endif

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN10)

#define COPY_FILE_IGNORE_EDP_BLOCK                   0x00400000
#define COPY_FILE_IGNORE_SOURCE_ENCRYPTION           0x00800000

#endif

#endif /* _WIN32_WINNT >= 0x0400 */

#if (_WIN32_WINNT >= 0x0500)
//
// Define ReplaceFile option flags
//

#define REPLACEFILE_WRITE_THROUGH       0x00000001
#define REPLACEFILE_IGNORE_MERGE_ERRORS 0x00000002

#if (_WIN32_WINNT >= 0x0600)
#define REPLACEFILE_IGNORE_ACL_ERRORS   0x00000004
#endif

#endif // #if (_WIN32_WINNT >= 0x0500)

//
// Define the NamedPipe definitions
//


//
// Define the dwOpenMode values for CreateNamedPipe
//

#define PIPE_ACCESS_INBOUND         0x00000001
#define PIPE_ACCESS_OUTBOUND        0x00000002
#define PIPE_ACCESS_DUPLEX          0x00000003

//
// Define the Named Pipe End flags for GetNamedPipeInfo
//

#define PIPE_CLIENT_END             0x00000000
#define PIPE_SERVER_END             0x00000001

//
// Define the dwPipeMode values for CreateNamedPipe
//

#define PIPE_WAIT                   0x00000000
#define PIPE_NOWAIT                 0x00000001
#define PIPE_READMODE_BYTE          0x00000000
#define PIPE_READMODE_MESSAGE       0x00000002
#define PIPE_TYPE_BYTE              0x00000000
#define PIPE_TYPE_MESSAGE           0x00000004
#define PIPE_ACCEPT_REMOTE_CLIENTS  0x00000000
#define PIPE_REJECT_REMOTE_CLIENTS  0x00000008

//
// Define the well known values for CreateNamedPipe nMaxInstances
//

#define PIPE_UNLIMITED_INSTANCES    255

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
typedef VOID (WINAPI *PFIBER_START_ROUTINE)(
    LPVOID lpFiberParameter
    );
typedef PFIBER_START_ROUTINE LPFIBER_START_ROUTINE;

typedef LPVOID (WINAPI *PFIBER_CALLOUT_ROUTINE)(
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
#else
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

/* Flags returned by GlobalFlags (in addition to GMEM_DISCARDABLE) */
#define GMEM_DISCARDED      0x4000
#define GMEM_LOCKCOUNT      0x00FF

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

#define DEBUG_PROCESS                     0x00000001
#define DEBUG_ONLY_THIS_PROCESS           0x00000002
#define CREATE_SUSPENDED                  0x00000004
#define DETACHED_PROCESS                  0x00000008

#define CREATE_NEW_CONSOLE                0x00000010
#define NORMAL_PRIORITY_CLASS             0x00000020
#define IDLE_PRIORITY_CLASS               0x00000040
#define HIGH_PRIORITY_CLASS               0x00000080

#define REALTIME_PRIORITY_CLASS           0x00000100
#define CREATE_NEW_PROCESS_GROUP          0x00000200
#define CREATE_UNICODE_ENVIRONMENT        0x00000400
#define CREATE_SEPARATE_WOW_VDM           0x00000800

#define CREATE_SHARED_WOW_VDM             0x00001000
#define CREATE_FORCEDOS                   0x00002000
#define BELOW_NORMAL_PRIORITY_CLASS       0x00004000
#define ABOVE_NORMAL_PRIORITY_CLASS       0x00008000

#define INHERIT_PARENT_AFFINITY           0x00010000
#define INHERIT_CALLER_PRIORITY           0x00020000    // Deprecated
#define CREATE_PROTECTED_PROCESS          0x00040000
#define EXTENDED_STARTUPINFO_PRESENT      0x00080000

#define PROCESS_MODE_BACKGROUND_BEGIN     0x00100000
#define PROCESS_MODE_BACKGROUND_END       0x00200000
#define CREATE_SECURE_PROCESS             0x00400000

#define CREATE_BREAKAWAY_FROM_JOB         0x01000000
#define CREATE_PRESERVE_CODE_AUTHZ_LEVEL  0x02000000
#define CREATE_DEFAULT_ERROR_MODE         0x04000000
#define CREATE_NO_WINDOW                  0x08000000

#define PROFILE_USER                      0x10000000
#define PROFILE_KERNEL                    0x20000000
#define PROFILE_SERVER                    0x40000000
#define CREATE_IGNORE_SYSTEM_DEFAULT      0x80000000

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
#else
WINBASEAPI DWORD WINAPI GetFreeSpace( UINT);
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
#define INFINITE            0xFFFFFFFF  // Infinite timeout

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
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

int
#if !defined(_MAC)
#if defined(_M_CEE_PURE)
__clrcall
#else
WINAPI
#endif
#else
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
#else
WINAPI
#endif
wWinMain(
     HINSTANCE hInstance,
     HINSTANCE hPrevInstance,
     LPWSTR lpCmdLine,
     int nShowCmd
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
_Success_(return != NULL)
_Post_writable_byte_size_(dwBytes)
DECLSPEC_ALLOCATOR
HGLOBAL
WINAPI
GlobalAlloc(
     UINT uFlags,
     SIZE_T dwBytes
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Application Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP)

WINBASEAPI
_Ret_reallocated_bytes_(hMem, dwBytes)
DECLSPEC_ALLOCATOR
HGLOBAL
WINAPI
GlobalReAlloc (
    _Frees_ptr_ HGLOBAL hMem,
     SIZE_T dwBytes,
     UINT uFlags
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
SIZE_T
WINAPI
GlobalSize (
     HGLOBAL hMem
    );

WINBASEAPI
BOOL
WINAPI
GlobalUnlock(
     HGLOBAL hMem
    );

WINBASEAPI
_Ret_maybenull_
LPVOID
WINAPI
GlobalLock (
     HGLOBAL hMem
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
UINT
WINAPI
GlobalFlags (
     HGLOBAL hMem
    );

WINBASEAPI
_Ret_maybenull_
HGLOBAL
WINAPI
GlobalHandle (
     LPCVOID pMem
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
_Ret_maybenull_
_Success_(return==0)
HGLOBAL
WINAPI
GlobalFree(
    _Frees_ptr_opt_ HGLOBAL hMem
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
SIZE_T
WINAPI
GlobalCompact(
     DWORD dwMinFree
    );

WINBASEAPI
VOID
WINAPI
GlobalFix(
     HGLOBAL hMem
    );

WINBASEAPI
VOID
WINAPI
GlobalUnfix(
     HGLOBAL hMem
    );

WINBASEAPI
LPVOID
WINAPI
GlobalWire(
     HGLOBAL hMem
    );

WINBASEAPI
BOOL
WINAPI
GlobalUnWire(
     HGLOBAL hMem
    );

__drv_preferredFunction("GlobalMemoryStatusEx","Deprecated. See MSDN for details")
WINBASEAPI
VOID
WINAPI
GlobalMemoryStatus(
    _Out_ LPMEMORYSTATUS lpBuffer
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
_Success_(return != NULL)
_Post_writable_byte_size_(uBytes)
DECLSPEC_ALLOCATOR
HLOCAL
WINAPI
LocalAlloc(
     UINT uFlags,
     SIZE_T uBytes
    );

WINBASEAPI
_Ret_reallocated_bytes_(hMem, uBytes)
DECLSPEC_ALLOCATOR
HLOCAL
WINAPI
LocalReAlloc(
    _Frees_ptr_opt_ HLOCAL hMem,
     SIZE_T uBytes,
     UINT uFlags
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)*/
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
_Ret_maybenull_
LPVOID
WINAPI
LocalLock(
     HLOCAL hMem
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
_Ret_maybenull_
HLOCAL
WINAPI
LocalHandle(
     LPCVOID pMem
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
BOOL
WINAPI
LocalUnlock(
     HLOCAL hMem
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
SIZE_T
WINAPI
LocalSize(
     HLOCAL hMem
    );

WINBASEAPI
UINT
WINAPI
LocalFlags(
     HLOCAL hMem
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
_Success_(return==0)
_Ret_maybenull_
HLOCAL
WINAPI
LocalFree(
    _Frees_ptr_opt_ HLOCAL hMem
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
SIZE_T
WINAPI
LocalShrink(
     HLOCAL hMem,
     UINT cbNewSize
    );

WINBASEAPI
SIZE_T
WINAPI
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
#else
# define SCS_THIS_PLATFORM_BINARY SCS_32BIT_BINARY
#endif

WINBASEAPI
BOOL
WINAPI
GetBinaryTypeA(
      LPCSTR lpApplicationName,
    _Out_ LPDWORD  lpBinaryType
    );
WINBASEAPI
BOOL
WINAPI
GetBinaryTypeW(
      LPCWSTR lpApplicationName,
    _Out_ LPDWORD  lpBinaryType
    );
#ifdef UNICODE
#define GetBinaryType  GetBinaryTypeW
#else
#define GetBinaryType  GetBinaryTypeA
#endif // !UNICODE

WINBASEAPI
_Success_(return != 0 && return < cchBuffer)
DWORD
WINAPI
GetShortPathNameA(
     LPCSTR lpszLongPath,
    _Out_writes_to_opt_(cchBuffer, return + 1) LPSTR  lpszShortPath,
     DWORD cchBuffer
    );
#ifndef UNICODE
#define GetShortPathName  GetShortPathNameA
#endif

#if _WIN32_WINNT >= 0x0600

WINBASEAPI
_Success_(return != 0 && return < cchBuffer)
DWORD
WINAPI
GetLongPathNameTransactedA(
         LPCSTR lpszShortPath,
    _Out_writes_to_opt_(cchBuffer, return + 1) LPSTR  lpszLongPath,
         DWORD cchBuffer,
         HANDLE hTransaction
    );
WINBASEAPI
_Success_(return != 0 && return < cchBuffer)
DWORD
WINAPI
GetLongPathNameTransactedW(
         LPCWSTR lpszShortPath,
    _Out_writes_to_opt_(cchBuffer, return + 1) LPWSTR  lpszLongPath,
         DWORD cchBuffer,
         HANDLE hTransaction
    );
#ifdef UNICODE
#define GetLongPathNameTransacted  GetLongPathNameTransactedW
#else
#define GetLongPathNameTransacted  GetLongPathNameTransactedA
#endif // !UNICODE

#endif // _WIN32_WINNT >= 0x0600

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
BOOL
WINAPI
GetProcessAffinityMask(
      HANDLE hProcess,
    _Out_ PDWORD_PTR lpProcessAffinityMask,
    _Out_ PDWORD_PTR lpSystemAffinityMask
    );

WINBASEAPI
BOOL
WINAPI
SetProcessAffinityMask(
     HANDLE hProcess,
     DWORD_PTR dwProcessAffinityMask
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
BOOL
WINAPI
GetProcessIoCounters(
      HANDLE hProcess,
    _Out_ PIO_COUNTERS lpIoCounters
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
BOOL
WINAPI
GetProcessWorkingSetSize(
      HANDLE hProcess,
    _Out_ PSIZE_T lpMinimumWorkingSetSize,
    _Out_ PSIZE_T lpMaximumWorkingSetSize
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
BOOL
WINAPI
SetProcessWorkingSetSize(
     HANDLE hProcess,
     SIZE_T dwMinimumWorkingSetSize,
     SIZE_T dwMaximumWorkingSetSize
    );

WINBASEAPI
__analysis_noreturn
VOID
WINAPI
FatalExit(
     int ExitCode
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
BOOL
WINAPI
SetEnvironmentStringsA(
     _Pre_ _NullNull_terminated_ LPCH NewEnvironment
    );
#ifndef UNICODE
#define SetEnvironmentStrings  SetEnvironmentStringsA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#if(_WIN32_WINNT >= 0x0400)

//
// Fiber begin
//

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

#define FIBER_FLAG_FLOAT_SWITCH 0x1     // context switch floating point

WINBASEAPI
VOID
WINAPI
SwitchToFiber(
     LPVOID lpFiber
    );

WINBASEAPI
VOID
WINAPI
DeleteFiber(
     LPVOID lpFiber
    );

#if (_WIN32_WINNT >= 0x0501)

WINBASEAPI
BOOL
WINAPI
ConvertFiberToThread(
    VOID
    );

#endif

WINBASEAPI
_Ret_maybenull_
LPVOID
WINAPI
CreateFiberEx(
         SIZE_T dwStackCommitSize,
         SIZE_T dwStackReserveSize,
         DWORD dwFlags,
         LPFIBER_START_ROUTINE lpStartAddress,
     LPVOID lpParameter
    );

WINBASEAPI
_Ret_maybenull_
LPVOID
WINAPI
ConvertThreadToFiberEx(
     LPVOID lpParameter,
         DWORD dwFlags
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
_Ret_maybenull_
LPVOID
WINAPI
CreateFiber(
         SIZE_T dwStackSize,
         LPFIBER_START_ROUTINE lpStartAddress,
     LPVOID lpParameter
    );

WINBASEAPI
_Ret_maybenull_
LPVOID
WINAPI
ConvertThreadToFiber(
     LPVOID lpParameter
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

//
// Fiber end
//

//
// UMS begin
//

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

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

_Must_inspect_result_
WINBASEAPI
BOOL
WINAPI
CreateUmsCompletionList(
    _Outptr_ PUMS_COMPLETION_LIST* UmsCompletionList
    );

WINBASEAPI
BOOL
WINAPI
DequeueUmsCompletionListItems(
     PUMS_COMPLETION_LIST UmsCompletionList,
     DWORD WaitTimeOut,
    _Out_ PUMS_CONTEXT* UmsThreadList
    );

WINBASEAPI
BOOL
WINAPI
GetUmsCompletionListEvent(
     PUMS_COMPLETION_LIST UmsCompletionList,
    _Inout_ PHANDLE UmsCompletionEvent
    );

WINBASEAPI
BOOL
WINAPI
ExecuteUmsThread(
    _Inout_ PUMS_CONTEXT UmsThread
    );

WINBASEAPI
BOOL
WINAPI
UmsThreadYield(
     PVOID SchedulerParam
    );

WINBASEAPI
BOOL
WINAPI
DeleteUmsCompletionList(
     PUMS_COMPLETION_LIST UmsCompletionList
    );

WINBASEAPI
PUMS_CONTEXT
WINAPI
GetCurrentUmsThread(
    VOID
    );

WINBASEAPI
PUMS_CONTEXT
WINAPI
GetNextUmsListItem(
    _Inout_ PUMS_CONTEXT UmsContext
    );

WINBASEAPI
BOOL
WINAPI
QueryUmsThreadInformation(
     PUMS_CONTEXT UmsThread,
     UMS_THREAD_INFO_CLASS UmsThreadInfoClass,
    _Out_writes_bytes_to_(UmsThreadInformationLength, *ReturnLength) PVOID UmsThreadInformation,
     ULONG UmsThreadInformationLength,
    _Out_opt_ PULONG ReturnLength
    );

WINBASEAPI
BOOL
WINAPI
SetUmsThreadInformation(
     PUMS_CONTEXT UmsThread,
     UMS_THREAD_INFO_CLASS UmsThreadInfoClass,
     PVOID UmsThreadInformation,
     ULONG UmsThreadInformationLength
    );

WINBASEAPI
BOOL
WINAPI
DeleteUmsThreadContext(
     PUMS_CONTEXT UmsThread
    );

WINBASEAPI
BOOL
WINAPI
CreateUmsThreadContext(
    _Outptr_ PUMS_CONTEXT *lpUmsThread
    );

WINBASEAPI
BOOL
WINAPI
EnterUmsSchedulingMode(
     PUMS_SCHEDULER_STARTUP_INFO SchedulerStartupInfo
    );

WINBASEAPI
BOOL
WINAPI
GetUmsSystemThreadInformation(
     HANDLE ThreadHandle,
    _Inout_ PUMS_SYSTEM_THREAD_INFORMATION SystemThreadInfo
    );

#endif // (_WIN32_WINNT >= 0x0601) && !defined(MIDL_PASS)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

//
// UMS end
//

#endif /* _WIN32_WINNT >= 0x0400 */

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
DWORD_PTR
WINAPI
SetThreadAffinityMask(
     HANDLE hThread,
     DWORD_PTR dwThreadAffinityMask
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if (_WIN32_WINNT >= 0x0600)

#define PROCESS_DEP_ENABLE                          0x00000001
#define PROCESS_DEP_DISABLE_ATL_THUNK_EMULATION     0x00000002

WINBASEAPI
BOOL
WINAPI
SetProcessDEPPolicy(
     DWORD dwFlags
    );

WINBASEAPI
BOOL
WINAPI
GetProcessDEPPolicy(
     HANDLE hProcess,
    _Out_ LPDWORD lpFlags,
    _Out_ PBOOL lpPermanent
    );

#endif // _WIN32_WINNT >= 0x0600

WINBASEAPI
BOOL
WINAPI
RequestWakeupLatency(
     LATENCY_TIME latency
    );

WINBASEAPI
BOOL
WINAPI
IsSystemResumeAutomatic(
    VOID
    );

WINBASEAPI
BOOL
WINAPI
GetThreadSelectorEntry(
      HANDLE hThread,
      DWORD dwSelector,
    _Out_ LPLDT_ENTRY lpSelectorEntry
    );

WINBASEAPI
EXECUTION_STATE
WINAPI
SetThreadExecutionState(
     EXECUTION_STATE esFlags
    );

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN7)

//
// Power Request APIs
//

typedef REASON_CONTEXT POWER_REQUEST_CONTEXT, *PPOWER_REQUEST_CONTEXT, *LPPOWER_REQUEST_CONTEXT;

WINBASEAPI
HANDLE
WINAPI
PowerCreateRequest (
     PREASON_CONTEXT Context
    );

WINBASEAPI
BOOL
WINAPI
PowerSetRequest (
     HANDLE PowerRequest,
     POWER_REQUEST_TYPE RequestType
    );

WINBASEAPI
BOOL
WINAPI
PowerClearRequest (
     HANDLE PowerRequest,
     POWER_REQUEST_TYPE RequestType
    );

#endif // (_WIN32_WINNT >= _WIN32_WINNT_WIN7)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP)

#ifdef _M_CEE_PURE
#define GetLastError System::Runtime::InteropServices::Marshal::GetLastWin32Error
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if !defined(RC_INVOKED) // RC warns because "WINBASE_DECLARE_RESTORE_LAST_ERROR" is a bit long.
//#if _WIN32_WINNT >= 0x0501 || defined(WINBASE_DECLARE_RESTORE_LAST_ERROR)
#if defined(WINBASE_DECLARE_RESTORE_LAST_ERROR)

WINBASEAPI
VOID
WINAPI
RestoreLastError(
     DWORD dwErrCode
    );

typedef VOID (WINAPI* PRESTORE_LAST_ERROR)(DWORD);
#define RESTORE_LAST_ERROR_NAME_A      "RestoreLastError"
#define RESTORE_LAST_ERROR_NAME_W     L"RestoreLastError"
#define RESTORE_LAST_ERROR_NAME   TEXT("RestoreLastError")

#endif
#endif

#define HasOverlappedIoCompleted(lpOverlapped) (((DWORD)(lpOverlapped)->Internal) != STATUS_PENDING)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family or OneCore Family
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

WINBASEAPI
BOOL
WINAPI
SetFileCompletionNotificationModes(
     HANDLE FileHandle,
     UCHAR Flags
    );

#endif // _WIN32_WINNT >= 0x0600

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#define SEM_FAILCRITICALERRORS      0x0001
#define SEM_NOGPFAULTERRORBOX       0x0002
#define SEM_NOALIGNMENTFAULTEXCEPT  0x0004
#define SEM_NOOPENFILEERRORBOX      0x8000

#if !defined(MIDL_PASS)

#if (_WIN32_WINNT >= 0x0600)

WINBASEAPI
BOOL
WINAPI
Wow64GetThreadContext(
        HANDLE hThread,
    _Inout_ PWOW64_CONTEXT lpContext
    );

WINBASEAPI
BOOL
WINAPI
Wow64SetThreadContext(
     HANDLE hThread,
     CONST WOW64_CONTEXT *lpContext
    );

#endif // (_WIN32_WINNT >= 0x0600)

#if (_WIN32_WINNT >= 0x0601)

WINBASEAPI
BOOL
WINAPI
Wow64GetThreadSelectorEntry(
     HANDLE hThread,
     DWORD dwSelector,
    _Out_ PWOW64_LDT_ENTRY lpSelectorEntry
    );

#endif // (_WIN32_WINNT >= 0x0601)

#endif // !defined(MIDL_PASS)

#if (_WIN32_WINNT >= 0x0600)

WINBASEAPI
DWORD
WINAPI
Wow64SuspendThread(
     HANDLE hThread
    );

#endif // (_WIN32_WINNT >= 0x0600)

WINBASEAPI
BOOL
WINAPI
DebugSetProcessKillOnExit(
     BOOL KillOnExit
    );

WINBASEAPI
BOOL
WINAPI
DebugBreakProcess (
     HANDLE Process
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP)

#if (_WIN32_WINNT >= 0x0403)
#define CRITICAL_SECTION_NO_DEBUG_INFO  RTL_CRITICAL_SECTION_FLAG_NO_DEBUG_INFO
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
BOOL
WINAPI
PulseEvent(
     HANDLE hEvent
    );

WINBASEAPI
ATOM
WINAPI
GlobalDeleteAtom(
     ATOM nAtom
    );

WINBASEAPI
BOOL
WINAPI
InitAtomTable(
     DWORD nSize
    );

WINBASEAPI
ATOM
WINAPI
DeleteAtom(
     ATOM nAtom
    );

WINBASEAPI
UINT
WINAPI
SetHandleCount(
     UINT uNumber
    );

WINBASEAPI
BOOL
WINAPI
RequestDeviceWakeup(
     HANDLE hDevice
    );

WINBASEAPI
BOOL
WINAPI
CancelDeviceWakeupRequest(
     HANDLE hDevice
    );

WINBASEAPI
BOOL
WINAPI
GetDevicePowerState(
      HANDLE hDevice,
    _Out_ BOOL *pfOn
    );

WINBASEAPI
BOOL
WINAPI
SetMessageWaitingIndicator(
     HANDLE hMsgIndicator,
     ULONG ulMsgCount
    );


WINBASEAPI
BOOL
WINAPI
SetFileShortNameA(
     HANDLE hFile,
     LPCSTR lpShortName
    );
WINBASEAPI
BOOL
WINAPI
SetFileShortNameW(
     HANDLE hFile,
     LPCWSTR lpShortName
    );
#ifdef UNICODE
#define SetFileShortName  SetFileShortNameW
#else
#define SetFileShortName  SetFileShortNameA
#endif // !UNICODE

#define HANDLE_FLAG_INHERIT             0x00000001
#define HANDLE_FLAG_PROTECT_FROM_CLOSE  0x00000002

#define HINSTANCE_ERROR 32

WINBASEAPI
DWORD
WINAPI
LoadModule(
     LPCSTR lpModuleName,
     LPVOID lpParameterBlock
    );


__drv_preferredFunction("CreateProcess","Deprecated. See MSDN for details")
WINBASEAPI
UINT
WINAPI
WinExec(
     LPCSTR lpCmdLine,
     UINT uCmdShow
    );


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Desktop Family or OneCore or App Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM | WINAPI_PARTITION_APP)

WINBASEAPI
BOOL
WINAPI
ClearCommBreak(
     HANDLE hFile
    );

WINBASEAPI
BOOL
WINAPI
ClearCommError(
          HANDLE hFile,
    _Out_opt_ LPDWORD lpErrors,
    _Out_opt_ LPCOMSTAT lpStat
    );

WINBASEAPI
BOOL
WINAPI
SetupComm(
     HANDLE hFile,
     DWORD dwInQueue,
     DWORD dwOutQueue
    );

WINBASEAPI
BOOL
WINAPI
EscapeCommFunction(
     HANDLE hFile,
     DWORD dwFunc
    );

WINBASEAPI
_Success_(return != FALSE)
BOOL
WINAPI
GetCommConfig(
          HANDLE hCommDev,
    _Out_writes_bytes_opt_(*lpdwSize) LPCOMMCONFIG lpCC,
    _Inout_   LPDWORD lpdwSize
    );

WINBASEAPI
BOOL
WINAPI
GetCommMask(
      HANDLE hFile,
    _Out_ LPDWORD lpEvtMask
    );

WINBASEAPI
BOOL
WINAPI
GetCommProperties(
        HANDLE hFile,
    _Inout_ LPCOMMPROP lpCommProp
    );

WINBASEAPI
BOOL
WINAPI
GetCommModemStatus(
      HANDLE hFile,
    _Out_ LPDWORD lpModemStat
    );

WINBASEAPI
BOOL
WINAPI
GetCommState(
      HANDLE hFile,
    _Out_ LPDCB lpDCB
    );

WINBASEAPI
BOOL
WINAPI
GetCommTimeouts(
      HANDLE hFile,
    _Out_ LPCOMMTIMEOUTS lpCommTimeouts
    );

WINBASEAPI
BOOL
WINAPI
PurgeComm(
     HANDLE hFile,
     DWORD dwFlags
    );

WINBASEAPI
BOOL
WINAPI
SetCommBreak(
     HANDLE hFile
    );

WINBASEAPI
BOOL
WINAPI
SetCommConfig(
     HANDLE hCommDev,
    _In_reads_bytes_(dwSize) LPCOMMCONFIG lpCC,
     DWORD dwSize
    );

WINBASEAPI
BOOL
WINAPI
SetCommMask(
     HANDLE hFile,
     DWORD dwEvtMask
    );

WINBASEAPI
BOOL
WINAPI
SetCommState(
     HANDLE hFile,
     LPDCB lpDCB
    );

WINBASEAPI
BOOL
WINAPI
SetCommTimeouts(
     HANDLE hFile,
     LPCOMMTIMEOUTS lpCommTimeouts
    );

WINBASEAPI
BOOL
WINAPI
TransmitCommChar(
     HANDLE hFile,
     char cChar
    );

WINBASEAPI
BOOL
WINAPI
WaitCommEvent(
            HANDLE hFile,
    _Inout_     LPDWORD lpEvtMask,
    _Inout_opt_ LPOVERLAPPED lpOverlapped
    );


#if (NTDDI_VERSION >= NTDDI_WIN10_RS3)

WINBASEAPI
HANDLE
WINAPI
OpenCommPort(
     ULONG uPortNumber,
     DWORD dwDesiredAccess,
     DWORD dwFlagsAndAttributes
    );

#endif // (NTDDI_VERSION >= NTDDI_WIN10_RS3)

#if (NTDDI_VERSION >= NTDDI_WIN10_RS3) // NTDDI_WIN10_RS4NTDDI_WIN10_RS4

WINBASEAPI
ULONG
WINAPI
GetCommPorts(
    _Out_writes_(uPortNumbersCount) PULONG lpPortNumbers,
                                ULONG uPortNumbersCount,
    _Out_                           PULONG puPortNumbersFound
    );

#endif // (NTDDI_VERSION >= NTDDI_WIN10_RS3) // NTDDI_WIN10_RS4NTDDI_WIN10_RS4

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM | WINAPI_PARTITION_APP) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
DWORD
WINAPI
SetTapePosition(
     HANDLE hDevice,
     DWORD dwPositionMethod,
     DWORD dwPartition,
     DWORD dwOffsetLow,
     DWORD dwOffsetHigh,
     BOOL bImmediate
    );

WINBASEAPI
DWORD
WINAPI
GetTapePosition(
      HANDLE hDevice,
      DWORD dwPositionType,
    _Out_ LPDWORD lpdwPartition,
    _Out_ LPDWORD lpdwOffsetLow,
    _Out_ LPDWORD lpdwOffsetHigh
    );

WINBASEAPI
DWORD
WINAPI
PrepareTape(
     HANDLE hDevice,
     DWORD dwOperation,
     BOOL bImmediate
    );

WINBASEAPI
DWORD
WINAPI
EraseTape(
     HANDLE hDevice,
     DWORD dwEraseType,
     BOOL bImmediate
    );

WINBASEAPI
DWORD
WINAPI
CreateTapePartition(
     HANDLE hDevice,
     DWORD dwPartitionMethod,
     DWORD dwCount,
     DWORD dwSize
    );

WINBASEAPI
DWORD
WINAPI
WriteTapemark(
     HANDLE hDevice,
     DWORD dwTapemarkType,
     DWORD dwTapemarkCount,
     BOOL bImmediate
    );

WINBASEAPI
DWORD
WINAPI
GetTapeStatus(
     HANDLE hDevice
    );

WINBASEAPI
DWORD
WINAPI
GetTapeParameters(
        HANDLE hDevice,
        DWORD dwOperation,
    _Inout_ LPDWORD lpdwSize,
    _Out_writes_bytes_(*lpdwSize) LPVOID lpTapeInformation
    );

#define GET_TAPE_MEDIA_INFORMATION 0
#define GET_TAPE_DRIVE_INFORMATION 1

WINBASEAPI
DWORD
WINAPI
SetTapeParameters(
     HANDLE hDevice,
     DWORD dwOperation,
     LPVOID lpTapeInformation
    );

#define SET_TAPE_MEDIA_INFORMATION 0
#define SET_TAPE_DRIVE_INFORMATION 1

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
int
WINAPI
MulDiv(
     int nNumber,
     int nNumerator,
     int nDenominator
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

typedef enum _DEP_SYSTEM_POLICY_TYPE {
    DEPPolicyAlwaysOff = 0,
    DEPPolicyAlwaysOn,
    DEPPolicyOptIn,
    DEPPolicyOptOut,
    DEPTotalPolicyCount
} DEP_SYSTEM_POLICY_TYPE;

#if (NTDDI_VERSION >= NTDDI_WINXPSP3)

WINBASEAPI
DEP_SYSTEM_POLICY_TYPE
WINAPI
GetSystemDEPPolicy(
    VOID
    );

#endif // (NTDDI_VERSION >= NTDDI_WINXPSP3)

#if _WIN32_WINNT >= 0x0501

WINBASEAPI
BOOL
WINAPI
GetSystemRegistryQuota(
    _Out_opt_ PDWORD pdwQuotaAllowed,
    _Out_opt_ PDWORD pdwQuotaUsed
    );

#endif // (_WIN32_WINNT >= 0x0501)

//
// Routines to convert back and forth between system time and file time
//

WINBASEAPI
BOOL
WINAPI
FileTimeToDosDateTime(
      CONST FILETIME *lpFileTime,
    _Out_ LPWORD lpFatDate,
    _Out_ LPWORD lpFatTime
    );

WINBASEAPI
BOOL
WINAPI
DosDateTimeToFileTime(
      WORD wFatDate,
      WORD wFatTime,
    _Out_ LPFILETIME lpFileTime
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

//
// FORMAT_MESSAGE_ALLOCATE_BUFFER requires use of HeapFree
//

#define FORMAT_MESSAGE_ALLOCATE_BUFFER 0x00000100

#if !defined(MIDL_PASS)
WINBASEAPI
_Success_(return != 0)
DWORD
WINAPI
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
WINBASEAPI
_Success_(return != 0)
DWORD
WINAPI
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
#else
#define FormatMessage  FormatMessageA
#endif // !UNICODE

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
#else
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
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


WINBASEAPI
HANDLE
WINAPI
CreateMailslotA(
         LPCSTR lpName,
         DWORD nMaxMessageSize,
         DWORD lReadTimeout,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
WINBASEAPI
HANDLE
WINAPI
CreateMailslotW(
         LPCWSTR lpName,
         DWORD nMaxMessageSize,
         DWORD lReadTimeout,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
#ifdef UNICODE
#define CreateMailslot  CreateMailslotW
#else
#define CreateMailslot  CreateMailslotA
#endif // !UNICODE

WINBASEAPI
BOOL
WINAPI
GetMailslotInfo(
          HANDLE hMailslot,
    _Out_opt_ LPDWORD lpMaxMessageSize,
    _Out_opt_ LPDWORD lpNextSize,
    _Out_opt_ LPDWORD lpMessageCount,
    _Out_opt_ LPDWORD lpReadTimeout
    );

WINBASEAPI
BOOL
WINAPI
SetMailslotInfo(
     HANDLE hMailslot,
     DWORD lReadTimeout
    );

//
// File Encryption API
//


BOOL
WINAPI
EncryptFileA(
     LPCSTR lpFileName
    );

BOOL
WINAPI
EncryptFileW(
     LPCWSTR lpFileName
    );
#ifdef UNICODE
#define EncryptFile  EncryptFileW
#else
#define EncryptFile  EncryptFileA
#endif // !UNICODE


BOOL
WINAPI
DecryptFileA(
           LPCSTR lpFileName,
    _Reserved_ DWORD dwReserved
    );

BOOL
WINAPI
DecryptFileW(
           LPCWSTR lpFileName,
    _Reserved_ DWORD dwReserved
    );
#ifdef UNICODE
#define DecryptFile  DecryptFileW
#else
#define DecryptFile  DecryptFileA
#endif // !UNICODE

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
WINAPI
FileEncryptionStatusA(
      LPCSTR lpFileName,
    _Out_ LPDWORD  lpStatus
    );

BOOL
WINAPI
FileEncryptionStatusW(
      LPCWSTR lpFileName,
    _Out_ LPDWORD  lpStatus
    );
#ifdef UNICODE
#define FileEncryptionStatus  FileEncryptionStatusW
#else
#define FileEncryptionStatus  FileEncryptionStatusA
#endif // !UNICODE

//
// Currently defined recovery flags
//

#define EFS_USE_RECOVERY_KEYS  (0x1)

typedef
DWORD
(WINAPI *PFE_EXPORT_FUNC)(
    _In_reads_bytes_(ulLength) PBYTE pbData,
     PVOID pvCallbackContext,
         ULONG ulLength
    );

typedef
DWORD
(WINAPI *PFE_IMPORT_FUNC)(
    _Out_writes_bytes_to_(*ulLength, *ulLength) PBYTE pbData,
     PVOID pvCallbackContext,
    _Inout_  PULONG ulLength
    );


//
//  OpenRaw flag values
//

#define CREATE_FOR_IMPORT               (1)
#define CREATE_FOR_DIR                  (2)
#define OVERWRITE_HIDDEN                (4)
#define EFSRPC_SECURE_ONLY              (8)
#define EFS_DROP_ALTERNATE_STREAMS      (0x10)



DWORD
WINAPI
OpenEncryptedFileRawA(
            LPCSTR lpFileName,
            ULONG    ulFlags,
    _Outptr_ PVOID   *pvContext
    );

DWORD
WINAPI
OpenEncryptedFileRawW(
            LPCWSTR lpFileName,
            ULONG    ulFlags,
    _Outptr_ PVOID   *pvContext
    );
#ifdef UNICODE
#define OpenEncryptedFileRaw  OpenEncryptedFileRawW
#else
#define OpenEncryptedFileRaw  OpenEncryptedFileRawA
#endif // !UNICODE


DWORD
WINAPI
ReadEncryptedFileRaw(
         PFE_EXPORT_FUNC pfExportCallback,
     PVOID           pvCallbackContext,
         PVOID           pvContext
    );


DWORD
WINAPI
WriteEncryptedFileRaw(
         PFE_IMPORT_FUNC pfImportCallback,
     PVOID           pvCallbackContext,
         PVOID           pvContext
    );


VOID
WINAPI
CloseEncryptedFileRaw(
     PVOID           pvContext
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

//
// _l Compat Functions
//

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
int
WINAPI
lstrcmpA(
     LPCSTR lpString1,
     LPCSTR lpString2
    );
WINBASEAPI
int
WINAPI
lstrcmpW(
     LPCWSTR lpString1,
     LPCWSTR lpString2
    );
#ifdef UNICODE
#define lstrcmp  lstrcmpW
#else
#define lstrcmp  lstrcmpA
#endif // !UNICODE

WINBASEAPI
int
WINAPI
lstrcmpiA(
     LPCSTR lpString1,
     LPCSTR lpString2
    );
WINBASEAPI
int
WINAPI
lstrcmpiW(
     LPCWSTR lpString1,
     LPCWSTR lpString2
    );
#ifdef UNICODE
#define lstrcmpi  lstrcmpiW
#else
#define lstrcmpi  lstrcmpiA
#endif // !UNICODE

#if defined(DEPRECATE_SUPPORTED)
#pragma warning(push)
#pragma warning(disable:4995)
#endif

WINBASEAPI
_Check_return_
_Success_(return != NULL)
_Post_satisfies_(return == lpString1)
_Ret_maybenull_
LPSTR
WINAPI
lstrcpynA(
    _Out_writes_(iMaxLength) LPSTR lpString1,
     LPCSTR lpString2,
     int iMaxLength
    );
WINBASEAPI
_Check_return_
_Success_(return != NULL)
_Post_satisfies_(return == lpString1)
_Ret_maybenull_
LPWSTR
WINAPI
lstrcpynW(
    _Out_writes_(iMaxLength) LPWSTR lpString1,
     LPCWSTR lpString2,
     int iMaxLength
    );
#ifdef UNICODE
#define lstrcpyn  lstrcpynW
#else
#define lstrcpyn  lstrcpynA
#endif // !UNICODE

WINBASEAPI
LPSTR
WINAPI
lstrcpyA(
    _Out_writes_(_String_length_(lpString2) + 1) LPSTR lpString1, // deprecated: annotation is as good as it gets
      LPCSTR lpString2
    );
WINBASEAPI
LPWSTR
WINAPI
lstrcpyW(
    _Out_writes_(_String_length_(lpString2) + 1) LPWSTR lpString1, // deprecated: annotation is as good as it gets
      LPCWSTR lpString2
    );
#ifdef UNICODE
#define lstrcpy  lstrcpyW
#else
#define lstrcpy  lstrcpyA
#endif // !UNICODE

WINBASEAPI
LPSTR
WINAPI
lstrcatA(
    _Inout_updates_z_(_String_length_(lpString1) + _String_length_(lpString2) + 1) LPSTR lpString1, // deprecated: annotation is as good as it gets
        LPCSTR lpString2
    );
WINBASEAPI
LPWSTR
WINAPI
lstrcatW(
    _Inout_updates_z_(_String_length_(lpString1) + _String_length_(lpString2) + 1) LPWSTR lpString1, // deprecated: annotation is as good as it gets
        LPCWSTR lpString2
    );
#ifdef UNICODE
#define lstrcat  lstrcatW
#else
#define lstrcat  lstrcatA
#endif // !UNICODE

#if defined(DEPRECATE_SUPPORTED)
#pragma warning(pop)
#endif

WINBASEAPI
int
WINAPI
lstrlenA(
     LPCSTR lpString
    );
WINBASEAPI
int
WINAPI
lstrlenW(
     LPCWSTR lpString
    );
#ifdef UNICODE
#define lstrlen  lstrlenW
#else
#define lstrlen  lstrlenA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
HFILE
WINAPI
OpenFile(
        LPCSTR lpFileName,
    _Inout_ LPOFSTRUCT lpReOpenBuff,
        UINT uStyle
    );

WINBASEAPI
HFILE
WINAPI
_lopen(
     LPCSTR lpPathName,
     int iReadWrite
    );

WINBASEAPI
HFILE
WINAPI
_lcreat(
     LPCSTR lpPathName,
     int  iAttribute
    );

WINBASEAPI
UINT
WINAPI
_lread(
     HFILE hFile,
    _Out_writes_bytes_to_(uBytes, return) LPVOID lpBuffer,
     UINT uBytes
    );

WINBASEAPI
UINT
WINAPI
_lwrite(
     HFILE hFile,
    _In_reads_bytes_(uBytes) LPCCH lpBuffer,
     UINT uBytes
    );

WINBASEAPI
long
WINAPI
_hread(
     HFILE hFile,
    _Out_writes_bytes_to_(lBytes, return) LPVOID lpBuffer,
     long lBytes
    );

WINBASEAPI
long
WINAPI
_hwrite(
     HFILE hFile,
    _In_reads_bytes_(lBytes) LPCCH lpBuffer,
     long lBytes
    );

WINBASEAPI
HFILE
WINAPI
_lclose(
     HFILE hFile
    );

WINBASEAPI
LONG
WINAPI
_llseek(
     HFILE hFile,
     LONG lOffset,
     int iOrigin
    );


BOOL
WINAPI
IsTextUnicode(
    _In_reads_bytes_(iSize) CONST VOID* lpv,
            int iSize,
    _Inout_opt_ LPINT lpiResult
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

#if(_WIN32_WINNT >= 0x0400)
WINBASEAPI
DWORD
WINAPI
SignalObjectAndWait(
     HANDLE hObjectToSignal,
     HANDLE hObjectToWaitOn,
     DWORD dwMilliseconds,
     BOOL bAlertable
    );
#endif /* _WIN32_WINNT >= 0x0400 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
BOOL
WINAPI
BackupRead(
        HANDLE hFile,
    _Out_writes_bytes_to_(nNumberOfBytesToRead, *lpNumberOfBytesRead) LPBYTE lpBuffer,
        DWORD nNumberOfBytesToRead,
    _Out_   LPDWORD lpNumberOfBytesRead,
        BOOL bAbort,
        BOOL bProcessSecurity,
    _Inout_ LPVOID *lpContext
    );

WINBASEAPI
BOOL
WINAPI
BackupSeek(
        HANDLE hFile,
        DWORD  dwLowBytesToSeek,
        DWORD  dwHighBytesToSeek,
    _Out_   LPDWORD lpdwLowByteSeeked,
    _Out_   LPDWORD lpdwHighByteSeeked,
    _Inout_ LPVOID *lpContext
    );

WINBASEAPI
BOOL
WINAPI
BackupWrite(
        HANDLE hFile,
    _In_reads_bytes_(nNumberOfBytesToWrite) LPBYTE lpBuffer,
        DWORD nNumberOfBytesToWrite,
    _Out_   LPDWORD lpNumberOfBytesWritten,
        BOOL bAbort,
        BOOL bProcessSecurity,
    _Inout_ LPVOID *lpContext
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

//
//  Stream Ids
//

#define BACKUP_INVALID          0x00000000
#define BACKUP_DATA             0x00000001
#define BACKUP_EA_DATA          0x00000002
#define BACKUP_SECURITY_DATA    0x00000003
#define BACKUP_ALTERNATE_DATA   0x00000004
#define BACKUP_LINK             0x00000005
#define BACKUP_PROPERTY_DATA    0x00000006
#define BACKUP_OBJECT_ID        0x00000007
#define BACKUP_REPARSE_DATA     0x00000008
#define BACKUP_SPARSE_BLOCK     0x00000009
#define BACKUP_TXFS_DATA        0x0000000a
#define BACKUP_GHOSTED_FILE_EXTENTS 0x0000000b

//
//  Stream Attributes
//

#define STREAM_NORMAL_ATTRIBUTE         0x00000000
#define STREAM_MODIFIED_WHEN_READ       0x00000001
#define STREAM_CONTAINS_SECURITY        0x00000002
#define STREAM_CONTAINS_PROPERTIES      0x00000004
#define STREAM_SPARSE_ATTRIBUTE         0x00000008
#define STREAM_CONTAINS_GHOSTED_FILE_EXTENTS 0x00000010

//
// Dual Mode API below this line. Dual Mode Structures also included.
//

#define STARTF_USESHOWWINDOW       0x00000001
#define STARTF_USESIZE             0x00000002
#define STARTF_USEPOSITION         0x00000004
#define STARTF_USECOUNTCHARS       0x00000008
#define STARTF_USEFILLATTRIBUTE    0x00000010
#define STARTF_RUNFULLSCREEN       0x00000020  // ignored for non-x86 platforms
#define STARTF_FORCEONFEEDBACK     0x00000040
#define STARTF_FORCEOFFFEEDBACK    0x00000080
#define STARTF_USESTDHANDLES       0x00000100

#if(WINVER >= 0x0400)

#define STARTF_USEHOTKEY           0x00000200
#define STARTF_TITLEISLINKNAME     0x00000800
#define STARTF_TITLEISAPPID        0x00001000
#define STARTF_PREVENTPINNING      0x00002000
#endif /* WINVER >= 0x0400 */

#if(WINVER >= 0x0600)
#define STARTF_UNTRUSTEDSOURCE     0x00008000
#endif /* WINVER >= 0x0600 */

#if (_WIN32_WINNT >= 0x0600)

typedef struct _STARTUPINFOEXA {
    STARTUPINFOA StartupInfo;
    LPPROC_THREAD_ATTRIBUTE_LIST lpAttributeList;
} STARTUPINFOEXA, *LPSTARTUPINFOEXA;
typedef struct _STARTUPINFOEXW {
    STARTUPINFOW StartupInfo;
    LPPROC_THREAD_ATTRIBUTE_LIST lpAttributeList;
} STARTUPINFOEXW, *LPSTARTUPINFOEXW;
#ifdef UNICODE
typedef STARTUPINFOEXW STARTUPINFOEX;
typedef LPSTARTUPINFOEXW LPSTARTUPINFOEX;
#else
typedef STARTUPINFOEXA STARTUPINFOEX;
typedef LPSTARTUPINFOEXA LPSTARTUPINFOEX;
#endif // UNICODE

#endif // (_WIN32_WINNT >= 0x0600)

#define SHUTDOWN_NORETRY                0x00000001

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
_Ret_maybenull_
HANDLE
WINAPI
OpenMutexA(
     DWORD dwDesiredAccess,
     BOOL bInheritHandle,
     LPCSTR lpName
    );
#ifndef UNICODE
#define OpenMutex  OpenMutexA
#endif

WINBASEAPI
_Ret_maybenull_
HANDLE
WINAPI
CreateSemaphoreA(
     LPSECURITY_ATTRIBUTES lpSemaphoreAttributes,
         LONG lInitialCount,
         LONG lMaximumCount,
     LPCSTR lpName
    );
#ifndef UNICODE
#define CreateSemaphore  CreateSemaphoreA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
_Ret_maybenull_
HANDLE
WINAPI
OpenSemaphoreA(
     DWORD dwDesiredAccess,
     BOOL bInheritHandle,
     LPCSTR lpName
    );
#ifndef UNICODE
#define OpenSemaphore  OpenSemaphoreA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#if (_WIN32_WINNT >= 0x0400) || (_WIN32_WINDOWS > 0x0400)

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
_Ret_maybenull_
HANDLE
WINAPI
CreateWaitableTimerA(
     LPSECURITY_ATTRIBUTES lpTimerAttributes,
         BOOL bManualReset,
     LPCSTR lpTimerName
    );
#ifndef UNICODE
#define CreateWaitableTimer  CreateWaitableTimerA
#endif

WINBASEAPI
_Ret_maybenull_
HANDLE
WINAPI
OpenWaitableTimerA(
     DWORD dwDesiredAccess,
     BOOL bInheritHandle,
     LPCSTR lpTimerName
    );
#ifndef UNICODE
#define OpenWaitableTimer  OpenWaitableTimerA
#endif

#if (_WIN32_WINNT >= 0x0600)

WINBASEAPI
_Ret_maybenull_
HANDLE
WINAPI
CreateSemaphoreExA(
        LPSECURITY_ATTRIBUTES lpSemaphoreAttributes,
            LONG lInitialCount,
            LONG lMaximumCount,
        LPCSTR lpName,
    _Reserved_  DWORD dwFlags,
            DWORD dwDesiredAccess
    );
#ifndef UNICODE
#define CreateSemaphoreEx  CreateSemaphoreExA
#endif

WINBASEAPI
_Ret_maybenull_
HANDLE
WINAPI
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

#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
_Ret_maybenull_
HANDLE
WINAPI
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

WINBASEAPI
_Ret_maybenull_
HANDLE
WINAPI
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

#endif // _WIN32_WINNT >= 0x0600

WINBASEAPI
HANDLE
WINAPI
OpenFileMappingA(
     DWORD dwDesiredAccess,
     BOOL bInheritHandle,
     LPCSTR lpName
    );
#ifndef UNICODE
#define OpenFileMapping  OpenFileMappingA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
_Success_(return != 0 && return <= nBufferLength)
DWORD
WINAPI
GetLogicalDriveStringsA(
     DWORD nBufferLength,
    _Out_writes_to_opt_(nBufferLength, return + 1) LPSTR lpBuffer
    );
#ifndef UNICODE
#define GetLogicalDriveStrings  GetLogicalDriveStringsA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

#if (_WIN32_WINNT >= 0x0602)

WINBASEAPI
_Ret_maybenull_
HMODULE
WINAPI
LoadPackagedLibrary (
           LPCWSTR lpwLibFileName,
    _Reserved_ DWORD Reserved
    );

#endif // _WIN32_WINNT >= 0x0602

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#if (_WIN32_WINNT >= 0x0600)

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

#endif // _WIN32_WINNT >= 0x0600

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

#if (_WIN32_WINNT >= 0x0600)

#define PROCESS_NAME_NATIVE     0x00000001

WINBASEAPI
BOOL
WINAPI
QueryFullProcessImageNameA(
     HANDLE hProcess,
     DWORD dwFlags,
    _Out_writes_to_(*lpdwSize, *lpdwSize) LPSTR lpExeName,
    _Inout_ PDWORD lpdwSize
    );
WINBASEAPI
BOOL
WINAPI
QueryFullProcessImageNameW(
     HANDLE hProcess,
     DWORD dwFlags,
    _Out_writes_to_(*lpdwSize, *lpdwSize) LPWSTR lpExeName,
    _Inout_ PDWORD lpdwSize
    );
#ifdef UNICODE
#define QueryFullProcessImageName  QueryFullProcessImageNameW
#else
#define QueryFullProcessImageName  QueryFullProcessImageNameA
#endif // !UNICODE

#endif // _WIN32_WINNT >= 0x0600

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

#endif // (_WIN32_WINNT >= 0x0600)

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

#endif // _WIN32_WINNT_WINTHRESHOLD
#endif // _WIN32_WINNT_WINBLUE
#endif // _WIN32_WINNT_WIN8

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

#endif // _WIN32_WINNT_WINTHRESHOLD

#if (NTDDI_VERSION >= NTDDI_WIN10_RS1)


#endif // NTDDI_WIN10_RS1

#if (NTDDI_VERSION >= NTDDI_WIN10_RS2)

//
// Define Attribute for Desktop App Override
//

#define PROCESS_CREATION_DESKTOP_APP_BREAKAWAY_ENABLE_PROCESS_TREE                        0x01
#define PROCESS_CREATION_DESKTOP_APP_BREAKAWAY_DISABLE_PROCESS_TREE                       0x02
#define PROCESS_CREATION_DESKTOP_APP_BREAKAWAY_OVERRIDE                                   0x04

#define PROC_THREAD_ATTRIBUTE_DESKTOP_APP_POLICY \
    ProcThreadAttributeValue (ProcThreadAttributeDesktopAppPolicy, FALSE, TRUE, FALSE)


#endif // NTDDI_WIN10_RS2

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


WINBASEAPI
VOID
WINAPI
GetStartupInfoA(
    _Out_ LPSTARTUPINFOA lpStartupInfo
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
#else
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
#else
    return SetEnvironmentVariableA(
#endif
        lpName,
        lpValue
        );
}
#endif  /* _M_CEE */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region OneCore Family or App Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_SYSTEM | WINAPI_PARTITION_APP)

WINBASEAPI
DWORD
WINAPI
GetFirmwareEnvironmentVariableA(
     LPCSTR lpName,
     LPCSTR lpGuid,
    _Out_writes_bytes_to_opt_(nSize, return) PVOID pBuffer,
     DWORD    nSize
    );
WINBASEAPI
DWORD
WINAPI
GetFirmwareEnvironmentVariableW(
     LPCWSTR lpName,
     LPCWSTR lpGuid,
    _Out_writes_bytes_to_opt_(nSize, return) PVOID pBuffer,
     DWORD    nSize
    );
#ifdef UNICODE
#define GetFirmwareEnvironmentVariable  GetFirmwareEnvironmentVariableW
#else
#define GetFirmwareEnvironmentVariable  GetFirmwareEnvironmentVariableA
#endif // !UNICODE

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN8)

WINBASEAPI
DWORD
WINAPI
GetFirmwareEnvironmentVariableExA(
     LPCSTR lpName,
     LPCSTR lpGuid,
    _Out_writes_bytes_to_opt_(nSize, return) PVOID pBuffer,
     DWORD    nSize,
    _Out_opt_ PDWORD pdwAttribubutes
    );
WINBASEAPI
DWORD
WINAPI
GetFirmwareEnvironmentVariableExW(
     LPCWSTR lpName,
     LPCWSTR lpGuid,
    _Out_writes_bytes_to_opt_(nSize, return) PVOID pBuffer,
     DWORD    nSize,
    _Out_opt_ PDWORD pdwAttribubutes
    );
#ifdef UNICODE
#define GetFirmwareEnvironmentVariableEx  GetFirmwareEnvironmentVariableExW
#else
#define GetFirmwareEnvironmentVariableEx  GetFirmwareEnvironmentVariableExA
#endif // !UNICODE

#endif

WINBASEAPI
BOOL
WINAPI
SetFirmwareEnvironmentVariableA(
     LPCSTR lpName,
     LPCSTR lpGuid,
    _In_reads_bytes_opt_(nSize) PVOID pValue,
     DWORD    nSize
    );
WINBASEAPI
BOOL
WINAPI
SetFirmwareEnvironmentVariableW(
     LPCWSTR lpName,
     LPCWSTR lpGuid,
    _In_reads_bytes_opt_(nSize) PVOID pValue,
     DWORD    nSize
    );
#ifdef UNICODE
#define SetFirmwareEnvironmentVariable  SetFirmwareEnvironmentVariableW
#else
#define SetFirmwareEnvironmentVariable  SetFirmwareEnvironmentVariableA
#endif // !UNICODE

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN8)

WINBASEAPI
BOOL
WINAPI
SetFirmwareEnvironmentVariableExA(
     LPCSTR lpName,
     LPCSTR lpGuid,
    _In_reads_bytes_opt_(nSize) PVOID pValue,
     DWORD    nSize,
     DWORD    dwAttributes
    );
WINBASEAPI
BOOL
WINAPI
SetFirmwareEnvironmentVariableExW(
     LPCWSTR lpName,
     LPCWSTR lpGuid,
    _In_reads_bytes_opt_(nSize) PVOID pValue,
     DWORD    nSize,
     DWORD    dwAttributes
    );
#ifdef UNICODE
#define SetFirmwareEnvironmentVariableEx  SetFirmwareEnvironmentVariableExW
#else
#define SetFirmwareEnvironmentVariableEx  SetFirmwareEnvironmentVariableExA
#endif // !UNICODE

#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_SYSTEM | WINAPI_PARTITION_APP) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN8)

WINBASEAPI
BOOL
WINAPI
GetFirmwareType (
    _Inout_ PFIRMWARE_TYPE FirmwareType
    );


WINBASEAPI
BOOL
WINAPI
IsNativeVhdBoot (
    _Out_ PBOOL NativeVhdBoot
    );

#endif // _WIN32_WINNT >= _WIN32_WINNT_WIN8

WINBASEAPI
_Ret_maybenull_
HRSRC
WINAPI
FindResourceA(
     HMODULE hModule,
         LPCSTR lpName,
         LPCSTR lpType
    );
#ifndef UNICODE
#define FindResource  FindResourceA
#endif

WINBASEAPI
_Ret_maybenull_
HRSRC
WINAPI
FindResourceExA(
     HMODULE hModule,
         LPCSTR lpType,
         LPCSTR lpName,
         WORD    wLanguage
    );
#ifndef UNICODE
#define FindResourceEx  FindResourceExA
#endif

WINBASEAPI
BOOL
WINAPI
EnumResourceTypesA(
     HMODULE hModule,
         ENUMRESTYPEPROCA lpEnumFunc,
         LONG_PTR lParam
    );
WINBASEAPI
BOOL
WINAPI
EnumResourceTypesW(
     HMODULE hModule,
         ENUMRESTYPEPROCW lpEnumFunc,
         LONG_PTR lParam
    );
#ifdef UNICODE
#define EnumResourceTypes  EnumResourceTypesW
#else
#define EnumResourceTypes  EnumResourceTypesA
#endif // !UNICODE

WINBASEAPI
BOOL
WINAPI
EnumResourceNamesA(
     HMODULE hModule,
         LPCSTR lpType,
         ENUMRESNAMEPROCA lpEnumFunc,
         LONG_PTR lParam
    );

#ifndef UNICODE
#define EnumResourceNames  EnumResourceNamesA
#endif

WINBASEAPI
BOOL
WINAPI
EnumResourceLanguagesA(
     HMODULE hModule,
         LPCSTR lpType,
         LPCSTR lpName,
         ENUMRESLANGPROCA lpEnumFunc,
         LONG_PTR lParam
    );
WINBASEAPI
BOOL
WINAPI
EnumResourceLanguagesW(
     HMODULE hModule,
         LPCWSTR lpType,
         LPCWSTR lpName,
         ENUMRESLANGPROCW lpEnumFunc,
         LONG_PTR lParam
    );
#ifdef UNICODE
#define EnumResourceLanguages  EnumResourceLanguagesW
#else
#define EnumResourceLanguages  EnumResourceLanguagesA
#endif // !UNICODE

WINBASEAPI
HANDLE
WINAPI
BeginUpdateResourceA(
     LPCSTR pFileName,
     BOOL bDeleteExistingResources
    );
WINBASEAPI
HANDLE
WINAPI
BeginUpdateResourceW(
     LPCWSTR pFileName,
     BOOL bDeleteExistingResources
    );
#ifdef UNICODE
#define BeginUpdateResource  BeginUpdateResourceW
#else
#define BeginUpdateResource  BeginUpdateResourceA
#endif // !UNICODE

WINBASEAPI
BOOL
WINAPI
UpdateResourceA(
     HANDLE hUpdate,
     LPCSTR lpType,
     LPCSTR lpName,
     WORD wLanguage,
    _In_reads_bytes_opt_(cb) LPVOID lpData,
     DWORD cb
    );
WINBASEAPI
BOOL
WINAPI
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
#else
#define UpdateResource  UpdateResourceA
#endif // !UNICODE

WINBASEAPI
BOOL
WINAPI
EndUpdateResourceA(
     HANDLE hUpdate,
     BOOL   fDiscard
    );
WINBASEAPI
BOOL
WINAPI
EndUpdateResourceW(
     HANDLE hUpdate,
     BOOL   fDiscard
    );
#ifdef UNICODE
#define EndUpdateResource  EndUpdateResourceW
#else
#define EndUpdateResource  EndUpdateResourceA
#endif // !UNICODE

#define ATOM_FLAG_GLOBAL 0x2

WINBASEAPI
ATOM
WINAPI
GlobalAddAtomA(
     LPCSTR lpString
    );
WINBASEAPI
ATOM
WINAPI
GlobalAddAtomW(
     LPCWSTR lpString
    );
#ifdef UNICODE
#define GlobalAddAtom  GlobalAddAtomW
#else
#define GlobalAddAtom  GlobalAddAtomA
#endif // !UNICODE

WINBASEAPI
ATOM
WINAPI
GlobalAddAtomExA(
     LPCSTR lpString,
     DWORD Flags
    );
WINBASEAPI
ATOM
WINAPI
GlobalAddAtomExW(
     LPCWSTR lpString,
     DWORD Flags
    );
#ifdef UNICODE
#define GlobalAddAtomEx  GlobalAddAtomExW
#else
#define GlobalAddAtomEx  GlobalAddAtomExA
#endif // !UNICODE

WINBASEAPI
ATOM
WINAPI
GlobalFindAtomA(
     LPCSTR lpString
    );
WINBASEAPI
ATOM
WINAPI
GlobalFindAtomW(
     LPCWSTR lpString
    );
#ifdef UNICODE
#define GlobalFindAtom  GlobalFindAtomW
#else
#define GlobalFindAtom  GlobalFindAtomA
#endif // !UNICODE

WINBASEAPI
UINT
WINAPI
GlobalGetAtomNameA(
     ATOM nAtom,
    _Out_writes_to_(nSize, return + 1) LPSTR lpBuffer,
     int nSize
    );
WINBASEAPI
UINT
WINAPI
GlobalGetAtomNameW(
     ATOM nAtom,
    _Out_writes_to_(nSize, return + 1) LPWSTR lpBuffer,
     int nSize
    );
#ifdef UNICODE
#define GlobalGetAtomName  GlobalGetAtomNameW
#else
#define GlobalGetAtomName  GlobalGetAtomNameA
#endif // !UNICODE

WINBASEAPI
ATOM
WINAPI
AddAtomA(
     LPCSTR lpString
    );
WINBASEAPI
ATOM
WINAPI
AddAtomW(
     LPCWSTR lpString
    );
#ifdef UNICODE
#define AddAtom  AddAtomW
#else
#define AddAtom  AddAtomA
#endif // !UNICODE

WINBASEAPI
ATOM
WINAPI
FindAtomA(
     LPCSTR lpString
    );
WINBASEAPI
ATOM
WINAPI
FindAtomW(
     LPCWSTR lpString
    );
#ifdef UNICODE
#define FindAtom  FindAtomW
#else
#define FindAtom  FindAtomA
#endif // !UNICODE

WINBASEAPI
UINT
WINAPI
GetAtomNameA(
     ATOM nAtom,
    _Out_writes_to_(nSize, return + 1) LPSTR lpBuffer,
     int nSize
    );
WINBASEAPI
UINT
WINAPI
GetAtomNameW(
     ATOM nAtom,
    _Out_writes_to_(nSize, return + 1) LPWSTR lpBuffer,
     int nSize
    );
#ifdef UNICODE
#define GetAtomName  GetAtomNameW
#else
#define GetAtomName  GetAtomNameA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
UINT
WINAPI
GetProfileIntA(
     LPCSTR lpAppName,
     LPCSTR lpKeyName,
     INT nDefault
    );
WINBASEAPI
UINT
WINAPI
GetProfileIntW(
     LPCWSTR lpAppName,
     LPCWSTR lpKeyName,
     INT nDefault
    );
#ifdef UNICODE
#define GetProfileInt  GetProfileIntW
#else
#define GetProfileInt  GetProfileIntA
#endif // !UNICODE

WINBASEAPI
DWORD
WINAPI
GetProfileStringA(
     LPCSTR lpAppName,
     LPCSTR lpKeyName,
     LPCSTR lpDefault,
    _Out_writes_to_opt_(nSize, return + 1) LPSTR lpReturnedString,
         DWORD nSize
    );
WINBASEAPI
DWORD
WINAPI
GetProfileStringW(
     LPCWSTR lpAppName,
     LPCWSTR lpKeyName,
     LPCWSTR lpDefault,
    _Out_writes_to_opt_(nSize, return + 1) LPWSTR lpReturnedString,
         DWORD nSize
    );
#ifdef UNICODE
#define GetProfileString  GetProfileStringW
#else
#define GetProfileString  GetProfileStringA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
BOOL
WINAPI
WriteProfileStringA(
     LPCSTR lpAppName,
     LPCSTR lpKeyName,
     LPCSTR lpString
    );
WINBASEAPI
BOOL
WINAPI
WriteProfileStringW(
     LPCWSTR lpAppName,
     LPCWSTR lpKeyName,
     LPCWSTR lpString
    );
#ifdef UNICODE
#define WriteProfileString  WriteProfileStringW
#else
#define WriteProfileString  WriteProfileStringA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
DWORD
WINAPI
GetProfileSectionA(
     LPCSTR lpAppName,
    _Out_writes_to_opt_(nSize, return + 1) LPSTR lpReturnedString,
     DWORD nSize
    );
WINBASEAPI
DWORD
WINAPI
GetProfileSectionW(
     LPCWSTR lpAppName,
    _Out_writes_to_opt_(nSize, return + 1) LPWSTR lpReturnedString,
     DWORD nSize
    );
#ifdef UNICODE
#define GetProfileSection  GetProfileSectionW
#else
#define GetProfileSection  GetProfileSectionA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
BOOL
WINAPI
WriteProfileSectionA(
     LPCSTR lpAppName,
     LPCSTR lpString
    );
WINBASEAPI
BOOL
WINAPI
WriteProfileSectionW(
     LPCWSTR lpAppName,
     LPCWSTR lpString
    );
#ifdef UNICODE
#define WriteProfileSection  WriteProfileSectionW
#else
#define WriteProfileSection  WriteProfileSectionA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
UINT
WINAPI
GetPrivateProfileIntA(
         LPCSTR lpAppName,
         LPCSTR lpKeyName,
         INT nDefault,
     LPCSTR lpFileName
    );
WINBASEAPI
UINT
WINAPI
GetPrivateProfileIntW(
         LPCWSTR lpAppName,
         LPCWSTR lpKeyName,
         INT nDefault,
     LPCWSTR lpFileName
    );
#ifdef UNICODE
#define GetPrivateProfileInt  GetPrivateProfileIntW
#else
#define GetPrivateProfileInt  GetPrivateProfileIntA
#endif // !UNICODE

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
#else
    return GetPrivateProfileIntA(
#endif
        lpAppName,
        lpKeyName,
        nDefault,
        lpFileName
        );
}
#endif  /* _M_CEE */

WINBASEAPI
DWORD
WINAPI
GetPrivateProfileStringA(
     LPCSTR lpAppName,
     LPCSTR lpKeyName,
     LPCSTR lpDefault,
    _Out_writes_to_opt_(nSize, return + 1) LPSTR lpReturnedString,
         DWORD nSize,
     LPCSTR lpFileName
    );
WINBASEAPI
DWORD
WINAPI
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
#else
#define GetPrivateProfileString  GetPrivateProfileStringA
#endif // !UNICODE

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
#else
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

WINBASEAPI
BOOL
WINAPI
WritePrivateProfileStringA(
     LPCSTR lpAppName,
     LPCSTR lpKeyName,
     LPCSTR lpString,
     LPCSTR lpFileName
    );
WINBASEAPI
BOOL
WINAPI
WritePrivateProfileStringW(
     LPCWSTR lpAppName,
     LPCWSTR lpKeyName,
     LPCWSTR lpString,
     LPCWSTR lpFileName
    );
#ifdef UNICODE
#define WritePrivateProfileString  WritePrivateProfileStringW
#else
#define WritePrivateProfileString  WritePrivateProfileStringA
#endif // !UNICODE

WINBASEAPI
DWORD
WINAPI
GetPrivateProfileSectionA(
         LPCSTR lpAppName,
    _Out_writes_to_opt_(nSize, return + 1) LPSTR lpReturnedString,
         DWORD nSize,
     LPCSTR lpFileName
    );
WINBASEAPI
DWORD
WINAPI
GetPrivateProfileSectionW(
         LPCWSTR lpAppName,
    _Out_writes_to_opt_(nSize, return + 1) LPWSTR lpReturnedString,
         DWORD nSize,
     LPCWSTR lpFileName
    );
#ifdef UNICODE
#define GetPrivateProfileSection  GetPrivateProfileSectionW
#else
#define GetPrivateProfileSection  GetPrivateProfileSectionA
#endif // !UNICODE

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
#else
    return GetPrivateProfileSectionA(
#endif
        lpAppName,
        lpReturnedString,
        nSize,
        lpFileName
        );
}
#endif  /* _M_CEE */

WINBASEAPI
BOOL
WINAPI
WritePrivateProfileSectionA(
     LPCSTR lpAppName,
     LPCSTR lpString,
     LPCSTR lpFileName
    );
WINBASEAPI
BOOL
WINAPI
WritePrivateProfileSectionW(
     LPCWSTR lpAppName,
     LPCWSTR lpString,
     LPCWSTR lpFileName
    );
#ifdef UNICODE
#define WritePrivateProfileSection  WritePrivateProfileSectionW
#else
#define WritePrivateProfileSection  WritePrivateProfileSectionA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
DWORD
WINAPI
GetPrivateProfileSectionNamesA(
    _Out_writes_to_opt_(nSize, return + 1) LPSTR lpszReturnBuffer,
         DWORD nSize,
     LPCSTR lpFileName
    );
WINBASEAPI
DWORD
WINAPI
GetPrivateProfileSectionNamesW(
    _Out_writes_to_opt_(nSize, return + 1) LPWSTR lpszReturnBuffer,
         DWORD nSize,
     LPCWSTR lpFileName
    );
#ifdef UNICODE
#define GetPrivateProfileSectionNames  GetPrivateProfileSectionNamesW
#else
#define GetPrivateProfileSectionNames  GetPrivateProfileSectionNamesA
#endif // !UNICODE

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
#else
    return GetPrivateProfileSectionNamesA(
#endif
        lpszReturnBuffer,
        nSize,
        lpFileName
        );
}
#endif  /* _M_CEE */

WINBASEAPI
BOOL
WINAPI
GetPrivateProfileStructA(
         LPCSTR lpszSection,
         LPCSTR lpszKey,
    _Out_writes_bytes_opt_(uSizeStruct) LPVOID   lpStruct,
         UINT     uSizeStruct,
     LPCSTR szFile
    );
WINBASEAPI
BOOL
WINAPI
GetPrivateProfileStructW(
         LPCWSTR lpszSection,
         LPCWSTR lpszKey,
    _Out_writes_bytes_opt_(uSizeStruct) LPVOID   lpStruct,
         UINT     uSizeStruct,
     LPCWSTR szFile
    );
#ifdef UNICODE
#define GetPrivateProfileStruct  GetPrivateProfileStructW
#else
#define GetPrivateProfileStruct  GetPrivateProfileStructA
#endif // !UNICODE

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
#else
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

WINBASEAPI
BOOL
WINAPI
WritePrivateProfileStructA(
         LPCSTR lpszSection,
         LPCSTR lpszKey,
    _In_reads_bytes_opt_(uSizeStruct) LPVOID lpStruct,
         UINT     uSizeStruct,
     LPCSTR szFile
    );
WINBASEAPI
BOOL
WINAPI
WritePrivateProfileStructW(
         LPCWSTR lpszSection,
         LPCWSTR lpszKey,
    _In_reads_bytes_opt_(uSizeStruct) LPVOID lpStruct,
         UINT     uSizeStruct,
     LPCWSTR szFile
    );
#ifdef UNICODE
#define WritePrivateProfileStruct  WritePrivateProfileStructW
#else
#define WritePrivateProfileStruct  WritePrivateProfileStructA
#endif // !UNICODE

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
#else
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

WINBASEAPI
BOOLEAN
WINAPI
Wow64EnableWow64FsRedirection (
     BOOLEAN Wow64FsEnableRedirection
    );

//
// for GetProcAddress
//
typedef UINT (WINAPI* PGET_SYSTEM_WOW64_DIRECTORY_A)(_Out_writes_to_opt_(uSize, return + 1) LPSTR lpBuffer,  UINT uSize);
typedef UINT (WINAPI* PGET_SYSTEM_WOW64_DIRECTORY_W)(_Out_writes_to_opt_(uSize, return + 1) LPWSTR lpBuffer,  UINT uSize);

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
#else
#define GET_SYSTEM_WOW64_DIRECTORY_NAME_T_A GET_SYSTEM_WOW64_DIRECTORY_NAME_A_A
#define GET_SYSTEM_WOW64_DIRECTORY_NAME_T_W GET_SYSTEM_WOW64_DIRECTORY_NAME_A_W
#define GET_SYSTEM_WOW64_DIRECTORY_NAME_T_T GET_SYSTEM_WOW64_DIRECTORY_NAME_A_T
#endif

#endif // _WIN32_WINNT >= 0x0501
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
#else
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
#else
    return GetCurrentDirectoryA(
#endif
        nBufferLength,
        lpBuffer
        );
}
#endif  /* _M_CEE */

#if _WIN32_WINNT >= 0x0502

WINBASEAPI
BOOL
WINAPI
SetDllDirectoryA(
     LPCSTR lpPathName
    );
WINBASEAPI
BOOL
WINAPI
SetDllDirectoryW(
     LPCWSTR lpPathName
    );
#ifdef UNICODE
#define SetDllDirectory  SetDllDirectoryW
#else
#define SetDllDirectory  SetDllDirectoryA
#endif // !UNICODE

WINBASEAPI
_Success_(return != 0 && return < nBufferLength)
DWORD
WINAPI
GetDllDirectoryA(
     DWORD nBufferLength,
    _Out_writes_to_opt_(nBufferLength, return + 1) LPSTR lpBuffer
    );
WINBASEAPI
_Success_(return != 0 && return < nBufferLength)
DWORD
WINAPI
GetDllDirectoryW(
     DWORD nBufferLength,
    _Out_writes_to_opt_(nBufferLength, return + 1) LPWSTR lpBuffer
    );
#ifdef UNICODE
#define GetDllDirectory  GetDllDirectoryW
#else
#define GetDllDirectory  GetDllDirectoryA
#endif // !UNICODE

#endif // _WIN32_WINNT >= 0x0502

#define BASE_SEARCH_PATH_ENABLE_SAFE_SEARCHMODE 0x1
#define BASE_SEARCH_PATH_DISABLE_SAFE_SEARCHMODE 0x10000
#define BASE_SEARCH_PATH_PERMANENT 0x8000
#define BASE_SEARCH_PATH_INVALID_FLAGS ~0x18001

WINBASEAPI
BOOL
WINAPI
SetSearchPathMode (
     DWORD Flags
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family
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
#else
    return CreateDirectoryA(
#endif
        lpPathName,
        lpSecurityAttributes
        );
}
#endif  /* _M_CEE */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
BOOL
WINAPI
CreateDirectoryExA(
         LPCSTR lpTemplateDirectory,
         LPCSTR lpNewDirectory,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
WINBASEAPI
BOOL
WINAPI
CreateDirectoryExW(
         LPCWSTR lpTemplateDirectory,
         LPCWSTR lpNewDirectory,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
#ifdef UNICODE
#define CreateDirectoryEx  CreateDirectoryExW
#else
#define CreateDirectoryEx  CreateDirectoryExA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if _WIN32_WINNT >= 0x0600

WINBASEAPI
BOOL
WINAPI
CreateDirectoryTransactedA(
     LPCSTR lpTemplateDirectory,
         LPCSTR lpNewDirectory,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes,
         HANDLE hTransaction
    );
WINBASEAPI
BOOL
WINAPI
CreateDirectoryTransactedW(
     LPCWSTR lpTemplateDirectory,
         LPCWSTR lpNewDirectory,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes,
         HANDLE hTransaction
    );
#ifdef UNICODE
#define CreateDirectoryTransacted  CreateDirectoryTransactedW
#else
#define CreateDirectoryTransacted  CreateDirectoryTransactedA
#endif // !UNICODE

WINBASEAPI
BOOL
WINAPI
RemoveDirectoryTransactedA(
     LPCSTR lpPathName,
         HANDLE hTransaction
    );
WINBASEAPI
BOOL
WINAPI
RemoveDirectoryTransactedW(
     LPCWSTR lpPathName,
         HANDLE hTransaction
    );
#ifdef UNICODE
#define RemoveDirectoryTransacted  RemoveDirectoryTransactedW
#else
#define RemoveDirectoryTransacted  RemoveDirectoryTransactedA
#endif // !UNICODE

WINBASEAPI
_Success_(return != 0 && return < nBufferLength)
DWORD
WINAPI
GetFullPathNameTransactedA(
                LPCSTR lpFileName,
                DWORD nBufferLength,
    _Out_writes_to_opt_(nBufferLength, return + 1) LPSTR lpBuffer,
    _Outptr_opt_ LPSTR *lpFilePart,
                HANDLE hTransaction
    );
WINBASEAPI
_Success_(return != 0 && return < nBufferLength)
DWORD
WINAPI
GetFullPathNameTransactedW(
                LPCWSTR lpFileName,
                DWORD nBufferLength,
    _Out_writes_to_opt_(nBufferLength, return + 1) LPWSTR lpBuffer,
    _Outptr_opt_ LPWSTR *lpFilePart,
                HANDLE hTransaction
    );
#ifdef UNICODE
#define GetFullPathNameTransacted  GetFullPathNameTransactedW
#else
#define GetFullPathNameTransacted  GetFullPathNameTransactedA
#endif // !UNICODE

#endif // _WIN32_WINNT >= 0x0600

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

#define DDD_RAW_TARGET_PATH         0x00000001
#define DDD_REMOVE_DEFINITION       0x00000002
#define DDD_EXACT_MATCH_ON_REMOVE   0x00000004
#define DDD_NO_BROADCAST_SYSTEM     0x00000008
#define DDD_LUID_BROADCAST_DRIVE    0x00000010

WINBASEAPI
BOOL
WINAPI
DefineDosDeviceA(
         DWORD dwFlags,
         LPCSTR lpDeviceName,
     LPCSTR lpTargetPath
    );
#ifndef UNICODE
#define DefineDosDevice  DefineDosDeviceA
#endif

WINBASEAPI
DWORD
WINAPI
QueryDosDeviceA(
     LPCSTR lpDeviceName,
    _Out_writes_to_opt_(ucchMax, return) LPSTR lpTargetPath,
         DWORD ucchMax
    );
#ifndef UNICODE
#define QueryDosDevice  QueryDosDeviceA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#define EXPAND_LOCAL_DRIVES

#if _WIN32_WINNT >= 0x0600

WINBASEAPI
HANDLE
WINAPI
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
    _Reserved_ PVOID  lpExtendedParameter
    );
WINBASEAPI
HANDLE
WINAPI
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
    _Reserved_ PVOID  lpExtendedParameter
    );
#ifdef UNICODE
#define CreateFileTransacted  CreateFileTransactedW
#else
#define CreateFileTransacted  CreateFileTransactedA
#endif // !UNICODE

#endif // _WIN32_WINNT >= 0x0600

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

#if _WIN32_WINNT >= 0x0502

WINBASEAPI
HANDLE
WINAPI
ReOpenFile(
     HANDLE  hOriginalFile,
     DWORD   dwDesiredAccess,
     DWORD   dwShareMode,
     DWORD   dwFlagsAndAttributes
    );

#endif // _WIN32_WINNT >= 0x0502

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion


#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if _WIN32_WINNT >= 0x0600

WINBASEAPI
BOOL
WINAPI
SetFileAttributesTransactedA(
         LPCSTR lpFileName,
         DWORD dwFileAttributes,
         HANDLE hTransaction
    );
WINBASEAPI
BOOL
WINAPI
SetFileAttributesTransactedW(
         LPCWSTR lpFileName,
         DWORD dwFileAttributes,
         HANDLE hTransaction
    );
#ifdef UNICODE
#define SetFileAttributesTransacted  SetFileAttributesTransactedW
#else
#define SetFileAttributesTransacted  SetFileAttributesTransactedA
#endif // !UNICODE

WINBASEAPI
BOOL
WINAPI
GetFileAttributesTransactedA(
      LPCSTR lpFileName,
      GET_FILEEX_INFO_LEVELS fInfoLevelId,
    _Out_writes_bytes_(sizeof(WIN32_FILE_ATTRIBUTE_DATA)) LPVOID lpFileInformation,
         HANDLE hTransaction
    );
WINBASEAPI
BOOL
WINAPI
GetFileAttributesTransactedW(
      LPCWSTR lpFileName,
      GET_FILEEX_INFO_LEVELS fInfoLevelId,
    _Out_writes_bytes_(sizeof(WIN32_FILE_ATTRIBUTE_DATA)) LPVOID lpFileInformation,
         HANDLE hTransaction
    );
#ifdef UNICODE
#define GetFileAttributesTransacted  GetFileAttributesTransactedW
#else
#define GetFileAttributesTransacted  GetFileAttributesTransactedA
#endif // !UNICODE

WINBASEAPI
DWORD
WINAPI
GetCompressedFileSizeTransactedA(
          LPCSTR lpFileName,
    _Out_opt_ LPDWORD  lpFileSizeHigh,
          HANDLE hTransaction
    );
WINBASEAPI
DWORD
WINAPI
GetCompressedFileSizeTransactedW(
          LPCWSTR lpFileName,
    _Out_opt_ LPDWORD  lpFileSizeHigh,
          HANDLE hTransaction
    );
#ifdef UNICODE
#define GetCompressedFileSizeTransacted  GetCompressedFileSizeTransactedW
#else
#define GetCompressedFileSizeTransacted  GetCompressedFileSizeTransactedA
#endif // !UNICODE

WINBASEAPI
BOOL
WINAPI
DeleteFileTransactedA(
         LPCSTR lpFileName,
         HANDLE hTransaction
    );
WINBASEAPI
BOOL
WINAPI
DeleteFileTransactedW(
         LPCWSTR lpFileName,
         HANDLE hTransaction
    );
#ifdef UNICODE
#define DeleteFileTransacted  DeleteFileTransactedW
#else
#define DeleteFileTransacted  DeleteFileTransactedA
#endif // !UNICODE

#endif // _WIN32_WINNT >= 0x0600

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family
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
#else
    return DeleteFileA(
#endif
        lpFileName
        );
}
#endif  /* _M_CEE */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if _WIN32_WINNT >= 0x0501

WINBASEAPI
BOOL
WINAPI
CheckNameLegalDOS8Dot3A(
          LPCSTR lpName,
    _Out_writes_opt_(OemNameSize) LPSTR lpOemName,
          DWORD OemNameSize,
    _Out_opt_ PBOOL pbNameContainsSpaces OPTIONAL,
    _Out_     PBOOL pbNameLegal
    );
WINBASEAPI
BOOL
WINAPI
CheckNameLegalDOS8Dot3W(
          LPCWSTR lpName,
    _Out_writes_opt_(OemNameSize) LPSTR lpOemName,
          DWORD OemNameSize,
    _Out_opt_ PBOOL pbNameContainsSpaces OPTIONAL,
    _Out_     PBOOL pbNameLegal
    );
#ifdef UNICODE
#define CheckNameLegalDOS8Dot3  CheckNameLegalDOS8Dot3W
#else
#define CheckNameLegalDOS8Dot3  CheckNameLegalDOS8Dot3A
#endif // !UNICODE

#endif // (_WIN32_WINNT >= 0x0501)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#if(_WIN32_WINNT >= 0x0400)

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if _WIN32_WINNT >= 0x0600

WINBASEAPI
HANDLE
WINAPI
FindFirstFileTransactedA(
           LPCSTR lpFileName,
           FINDEX_INFO_LEVELS fInfoLevelId,
    _Out_writes_bytes_(sizeof(WIN32_FIND_DATAA)) LPVOID lpFindFileData,
           FINDEX_SEARCH_OPS fSearchOp,
    _Reserved_ LPVOID lpSearchFilter,
           DWORD dwAdditionalFlags,
           HANDLE hTransaction
    );
WINBASEAPI
HANDLE
WINAPI
FindFirstFileTransactedW(
           LPCWSTR lpFileName,
           FINDEX_INFO_LEVELS fInfoLevelId,
    _Out_writes_bytes_(sizeof(WIN32_FIND_DATAW)) LPVOID lpFindFileData,
           FINDEX_SEARCH_OPS fSearchOp,
    _Reserved_ LPVOID lpSearchFilter,
           DWORD dwAdditionalFlags,
           HANDLE hTransaction
    );
#ifdef UNICODE
#define FindFirstFileTransacted  FindFirstFileTransactedW
#else
#define FindFirstFileTransacted  FindFirstFileTransactedA
#endif // !UNICODE

#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* _WIN32_WINNT >= 0x0400 */

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


WINBASEAPI
BOOL
WINAPI
CopyFileA(
     LPCSTR lpExistingFileName,
     LPCSTR lpNewFileName,
     BOOL bFailIfExists
    );
WINBASEAPI
BOOL
WINAPI
CopyFileW(
     LPCWSTR lpExistingFileName,
     LPCWSTR lpNewFileName,
     BOOL bFailIfExists
    );
#ifdef UNICODE
#define CopyFile  CopyFileW
#else
#define CopyFile  CopyFileA
#endif // !UNICODE

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
#else
    return CopyFileA(
#endif
        lpExistingFileName,
        lpNewFileName,
        bFailIfExists
        );
}
#endif  /* _M_CEE */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#if(_WIN32_WINNT >= 0x0400)

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

typedef
DWORD
(WINAPI *LPPROGRESS_ROUTINE)(
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

WINBASEAPI
BOOL
WINAPI
CopyFileExA(
            LPCSTR lpExistingFileName,
            LPCSTR lpNewFileName,
        LPPROGRESS_ROUTINE lpProgressRoutine,
        LPVOID lpData,
    _When_(pbCancel != NULL, _Pre_satisfies_(*pbCancel == FALSE))
    _Inout_opt_ LPBOOL pbCancel,
            DWORD dwCopyFlags
    );
WINBASEAPI
BOOL
WINAPI
CopyFileExW(
            LPCWSTR lpExistingFileName,
            LPCWSTR lpNewFileName,
        LPPROGRESS_ROUTINE lpProgressRoutine,
        LPVOID lpData,
    _When_(pbCancel != NULL, _Pre_satisfies_(*pbCancel == FALSE))
    _Inout_opt_ LPBOOL pbCancel,
            DWORD dwCopyFlags
    );
#ifdef UNICODE
#define CopyFileEx  CopyFileExW
#else
#define CopyFileEx  CopyFileExA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if _WIN32_WINNT >= 0x0600

WINBASEAPI
BOOL
WINAPI
CopyFileTransactedA(
         LPCSTR lpExistingFileName,
         LPCSTR lpNewFileName,
     LPPROGRESS_ROUTINE lpProgressRoutine,
     LPVOID lpData,
     LPBOOL pbCancel,
         DWORD dwCopyFlags,
         HANDLE hTransaction
    );
WINBASEAPI
BOOL
WINAPI
CopyFileTransactedW(
         LPCWSTR lpExistingFileName,
         LPCWSTR lpNewFileName,
     LPPROGRESS_ROUTINE lpProgressRoutine,
     LPVOID lpData,
     LPBOOL pbCancel,
         DWORD dwCopyFlags,
         HANDLE hTransaction
    );
#ifdef UNICODE
#define CopyFileTransacted  CopyFileTransactedW
#else
#define CopyFileTransacted  CopyFileTransactedA
#endif // !UNICODE

#endif // _WIN32_WINNT >= 0x0600

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

//
// TODO: Win7 for now, when we roll over the version number this needs to be updated.
//

#if _WIN32_WINNT >= 0x0601

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

#define COPYFILE2_MESSAGE_COPY_OFFLOAD     (0x00000001L)

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
COPYFILE2_MESSAGE_ACTION (CALLBACK *PCOPYFILE2_PROGRESS_ROUTINE)(
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

WINBASEAPI
HRESULT
WINAPI
CopyFile2(
        PCWSTR                          pwszExistingFileName,
        PCWSTR                          pwszNewFileName,
    COPYFILE2_EXTENDED_PARAMETERS   *pExtendedParameters
);

#endif // _WIN32_WINNT >= 0x0601

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#endif /* _WIN32_WINNT >= 0x0400 */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
BOOL
WINAPI
MoveFileA(
     LPCSTR lpExistingFileName,
     LPCSTR lpNewFileName
    );
WINBASEAPI
BOOL
WINAPI
MoveFileW(
     LPCWSTR lpExistingFileName,
     LPCWSTR lpNewFileName
    );
#ifdef UNICODE
#define MoveFile  MoveFileW
#else
#define MoveFile  MoveFileA
#endif // !UNICODE

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
#else
    return MoveFileA(
#endif
        lpExistingFileName,
        lpNewFileName
        );
}
#endif  /* _M_CEE */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
BOOL
WINAPI
MoveFileExA(
         LPCSTR lpExistingFileName,
     LPCSTR lpNewFileName,
         DWORD    dwFlags
    );
WINBASEAPI
BOOL
WINAPI
MoveFileExW(
         LPCWSTR lpExistingFileName,
     LPCWSTR lpNewFileName,
         DWORD    dwFlags
    );
#ifdef UNICODE
#define MoveFileEx  MoveFileExW
#else
#define MoveFileEx  MoveFileExA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

#if (_WIN32_WINNT >= 0x0500)
WINBASEAPI
BOOL
WINAPI
MoveFileWithProgressA(
         LPCSTR lpExistingFileName,
     LPCSTR lpNewFileName,
     LPPROGRESS_ROUTINE lpProgressRoutine,
     LPVOID lpData,
         DWORD dwFlags
    );
WINBASEAPI
BOOL
WINAPI
MoveFileWithProgressW(
         LPCWSTR lpExistingFileName,
     LPCWSTR lpNewFileName,
     LPPROGRESS_ROUTINE lpProgressRoutine,
     LPVOID lpData,
         DWORD dwFlags
    );
#ifdef UNICODE
#define MoveFileWithProgress  MoveFileWithProgressW
#else
#define MoveFileWithProgress  MoveFileWithProgressA
#endif // !UNICODE
#endif // (_WIN32_WINNT >= 0x0500)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if (_WIN32_WINNT >= 0x0600)
WINBASEAPI
BOOL
WINAPI
MoveFileTransactedA(
         LPCSTR lpExistingFileName,
     LPCSTR lpNewFileName,
     LPPROGRESS_ROUTINE lpProgressRoutine,
     LPVOID lpData,
         DWORD dwFlags,
         HANDLE hTransaction
    );
WINBASEAPI
BOOL
WINAPI
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
#else
#define MoveFileTransacted  MoveFileTransactedA
#endif // !UNICODE
#endif // (_WIN32_WINNT >= 0x0600)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP)

#define MOVEFILE_REPLACE_EXISTING       0x00000001
#define MOVEFILE_COPY_ALLOWED           0x00000002
#define MOVEFILE_DELAY_UNTIL_REBOOT     0x00000004
#define MOVEFILE_WRITE_THROUGH          0x00000008
#if (_WIN32_WINNT >= 0x0500)
#define MOVEFILE_CREATE_HARDLINK        0x00000010
#define MOVEFILE_FAIL_IF_NOT_TRACKABLE  0x00000020
#endif // (_WIN32_WINNT >= 0x0500)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

#if (_WIN32_WINNT >= 0x0500)

WINBASEAPI
BOOL
WINAPI
ReplaceFileA(
           LPCSTR lpReplacedFileName,
           LPCSTR lpReplacementFileName,
       LPCSTR lpBackupFileName,
           DWORD    dwReplaceFlags,
    _Reserved_ LPVOID   lpExclude,
    _Reserved_ LPVOID  lpReserved
    );
WINBASEAPI
BOOL
WINAPI
ReplaceFileW(
           LPCWSTR lpReplacedFileName,
           LPCWSTR lpReplacementFileName,
       LPCWSTR lpBackupFileName,
           DWORD    dwReplaceFlags,
    _Reserved_ LPVOID   lpExclude,
    _Reserved_ LPVOID  lpReserved
    );
#ifdef UNICODE
#define ReplaceFile  ReplaceFileW
#else
#define ReplaceFile  ReplaceFileA
#endif // !UNICODE
#endif // (_WIN32_WINNT >= 0x0500)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

#if (_WIN32_WINNT >= 0x0500)
//
// API call to create hard links.
//

WINBASEAPI
BOOL
WINAPI
CreateHardLinkA(
           LPCSTR lpFileName,
           LPCSTR lpExistingFileName,
    _Reserved_ LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
WINBASEAPI
BOOL
WINAPI
CreateHardLinkW(
           LPCWSTR lpFileName,
           LPCWSTR lpExistingFileName,
    _Reserved_ LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
#ifdef UNICODE
#define CreateHardLink  CreateHardLinkW
#else
#define CreateHardLink  CreateHardLinkA
#endif // !UNICODE

#endif // (_WIN32_WINNT >= 0x0500)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if (_WIN32_WINNT >= 0x0600)
//
// API call to create hard links.
//

WINBASEAPI
BOOL
WINAPI
CreateHardLinkTransactedA(
           LPCSTR lpFileName,
           LPCSTR lpExistingFileName,
    _Reserved_ LPSECURITY_ATTRIBUTES lpSecurityAttributes,
           HANDLE hTransaction
    );
WINBASEAPI
BOOL
WINAPI
CreateHardLinkTransactedW(
           LPCWSTR lpFileName,
           LPCWSTR lpExistingFileName,
    _Reserved_ LPSECURITY_ATTRIBUTES lpSecurityAttributes,
           HANDLE hTransaction
    );
#ifdef UNICODE
#define CreateHardLinkTransacted  CreateHardLinkTransactedW
#else
#define CreateHardLinkTransacted  CreateHardLinkTransactedA
#endif // !UNICODE

#endif // (_WIN32_WINNT >= 0x0600)

#if _WIN32_WINNT >= 0x0600

WINBASEAPI
HANDLE
WINAPI
FindFirstStreamTransactedW (
           LPCWSTR lpFileName,
           STREAM_INFO_LEVELS InfoLevel,
    _Out_writes_bytes_(sizeof(WIN32_FIND_STREAM_DATA)) LPVOID lpFindStreamData,
    _Reserved_ DWORD dwFlags,
           HANDLE hTransaction
    );

WINBASEAPI
HANDLE
WINAPI
FindFirstFileNameTransactedW (
         LPCWSTR lpFileName,
         DWORD dwFlags,
    _Inout_  LPDWORD StringLength,
    _Out_writes_(*StringLength) PWSTR LinkName,
     HANDLE hTransaction
    );

#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
HANDLE
WINAPI
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
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
BOOL
WINAPI
GetNamedPipeHandleStateA(
          HANDLE hNamedPipe,
    _Out_opt_ LPDWORD lpState,
    _Out_opt_ LPDWORD lpCurInstances,
    _Out_opt_ LPDWORD lpMaxCollectionCount,
    _Out_opt_ LPDWORD lpCollectDataTimeout,
    _Out_writes_opt_(nMaxUserNameSize) LPSTR lpUserName,
          DWORD nMaxUserNameSize
    );
#ifndef UNICODE
#define GetNamedPipeHandleState  GetNamedPipeHandleStateA
#endif

WINBASEAPI
BOOL
WINAPI
CallNamedPipeA(
      LPCSTR lpNamedPipeName,
    _In_reads_bytes_opt_(nInBufferSize) LPVOID lpInBuffer,
      DWORD nInBufferSize,
    _Out_writes_bytes_to_opt_(nOutBufferSize, *lpBytesRead) LPVOID lpOutBuffer,
      DWORD nOutBufferSize,
    _Out_ LPDWORD lpBytesRead,
      DWORD nTimeOut
    );

#ifndef UNICODE
#define CallNamedPipe  CallNamedPipeA
#endif

WINBASEAPI
BOOL
WINAPI
WaitNamedPipeA(
     LPCSTR lpNamedPipeName,
     DWORD nTimeOut
    );
#ifndef UNICODE
#define WaitNamedPipe  WaitNamedPipeA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#if (_WIN32_WINNT >= 0x0600)

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
BOOL
WINAPI
GetNamedPipeClientComputerNameA(
     HANDLE Pipe,
    _Out_writes_bytes_(ClientComputerNameLength)  LPSTR ClientComputerName,
     ULONG ClientComputerNameLength
    );

#ifndef UNICODE
#define GetNamedPipeClientComputerName  GetNamedPipeClientComputerNameA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
BOOL
WINAPI
GetNamedPipeClientProcessId(
     HANDLE Pipe,
    _Out_ PULONG ClientProcessId
    );

WINBASEAPI
BOOL
WINAPI
GetNamedPipeClientSessionId(
     HANDLE Pipe,
    _Out_ PULONG ClientSessionId
    );

WINBASEAPI
BOOL
WINAPI
GetNamedPipeServerProcessId(
     HANDLE Pipe,
    _Out_ PULONG ServerProcessId
    );

WINBASEAPI
BOOL
WINAPI
GetNamedPipeServerSessionId(
     HANDLE Pipe,
    _Out_ PULONG ServerSessionId
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif // (_WIN32_WINNT >= 0x0600)

#pragma region Application Family or Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP)

WINBASEAPI
BOOL
WINAPI
SetVolumeLabelA(
     LPCSTR lpRootPathName,
     LPCSTR lpVolumeName
    );
WINBASEAPI
BOOL
WINAPI
SetVolumeLabelW(
     LPCWSTR lpRootPathName,
     LPCWSTR lpVolumeName
    );
#ifdef UNICODE
#define SetVolumeLabel  SetVolumeLabelW
#else
#define SetVolumeLabel  SetVolumeLabelA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


#if (_WIN32_WINNT >= 0x0600)

WINBASEAPI
BOOL
WINAPI
SetFileBandwidthReservation(
      HANDLE  hFile,
      DWORD   nPeriodMilliseconds,
      DWORD   nBytesPerPeriod,
      BOOL    bDiscardable,
    _Out_ LPDWORD lpTransferSize,
    _Out_ LPDWORD lpNumOutstandingRequests
    );

WINBASEAPI
BOOL
WINAPI
GetFileBandwidthReservation(
      HANDLE  hFile,
    _Out_ LPDWORD lpPeriodMilliseconds,
    _Out_ LPDWORD lpBytesPerPeriod,
    _Out_ LPBOOL  pDiscardable,
    _Out_ LPDWORD lpTransferSize,
    _Out_ LPDWORD lpNumOutstandingRequests
    );

#endif // (_WIN32_WINNT >= 0x0600)

//
// Event logging APIs
//


BOOL
WINAPI
ClearEventLogA (
         HANDLE hEventLog,
     LPCSTR lpBackupFileName
    );

BOOL
WINAPI
ClearEventLogW (
         HANDLE hEventLog,
     LPCWSTR lpBackupFileName
    );
#ifdef UNICODE
#define ClearEventLog  ClearEventLogW
#else
#define ClearEventLog  ClearEventLogA
#endif // !UNICODE


BOOL
WINAPI
BackupEventLogA (
     HANDLE hEventLog,
     LPCSTR lpBackupFileName
    );

BOOL
WINAPI
BackupEventLogW (
     HANDLE hEventLog,
     LPCWSTR lpBackupFileName
    );
#ifdef UNICODE
#define BackupEventLog  BackupEventLogW
#else
#define BackupEventLog  BackupEventLogA
#endif // !UNICODE


BOOL
WINAPI
CloseEventLog (
     HANDLE hEventLog
    );


BOOL
WINAPI
DeregisterEventSource (
     HANDLE hEventLog
    );


BOOL
WINAPI
NotifyChangeEventLog(
     HANDLE  hEventLog,
     HANDLE  hEvent
    );


BOOL
WINAPI
GetNumberOfEventLogRecords (
      HANDLE hEventLog,
    _Out_ PDWORD NumberOfRecords
    );


BOOL
WINAPI
GetOldestEventLogRecord (
      HANDLE hEventLog,
    _Out_ PDWORD OldestRecord
    );


HANDLE
WINAPI
OpenEventLogA (
     LPCSTR lpUNCServerName,
         LPCSTR lpSourceName
    );

HANDLE
WINAPI
OpenEventLogW (
     LPCWSTR lpUNCServerName,
         LPCWSTR lpSourceName
    );
#ifdef UNICODE
#define OpenEventLog  OpenEventLogW
#else
#define OpenEventLog  OpenEventLogA
#endif // !UNICODE


HANDLE
WINAPI
RegisterEventSourceA (
     LPCSTR lpUNCServerName,
         LPCSTR lpSourceName
    );

HANDLE
WINAPI
RegisterEventSourceW (
     LPCWSTR lpUNCServerName,
         LPCWSTR lpSourceName
    );
#ifdef UNICODE
#define RegisterEventSource  RegisterEventSourceW
#else
#define RegisterEventSource  RegisterEventSourceA
#endif // !UNICODE


HANDLE
WINAPI
OpenBackupEventLogA (
     LPCSTR lpUNCServerName,
         LPCSTR lpFileName
    );

HANDLE
WINAPI
OpenBackupEventLogW (
     LPCWSTR lpUNCServerName,
         LPCWSTR lpFileName
    );
#ifdef UNICODE
#define OpenBackupEventLog  OpenBackupEventLogW
#else
#define OpenBackupEventLog  OpenBackupEventLogA
#endif // !UNICODE


BOOL
WINAPI
ReadEventLogA (
      HANDLE     hEventLog,
      DWORD      dwReadFlags,
      DWORD      dwRecordOffset,
    _Out_writes_bytes_to_(nNumberOfBytesToRead, *pnBytesRead) LPVOID     lpBuffer,
      DWORD      nNumberOfBytesToRead,
    _Out_ DWORD      *pnBytesRead,
    _Out_ DWORD      *pnMinNumberOfBytesNeeded
    );

BOOL
WINAPI
ReadEventLogW (
      HANDLE     hEventLog,
      DWORD      dwReadFlags,
      DWORD      dwRecordOffset,
    _Out_writes_bytes_to_(nNumberOfBytesToRead, *pnBytesRead) LPVOID     lpBuffer,
      DWORD      nNumberOfBytesToRead,
    _Out_ DWORD      *pnBytesRead,
    _Out_ DWORD      *pnMinNumberOfBytesNeeded
    );
#ifdef UNICODE
#define ReadEventLog  ReadEventLogW
#else
#define ReadEventLog  ReadEventLogA
#endif // !UNICODE


BOOL
WINAPI
ReportEventA (
         HANDLE     hEventLog,
         WORD       wType,
         WORD       wCategory,
         DWORD      dwEventID,
     PSID       lpUserSid,
         WORD       wNumStrings,
         DWORD      dwDataSize,
    _In_reads_opt_(wNumStrings) LPCSTR *lpStrings,
    _In_reads_bytes_opt_(dwDataSize) LPVOID lpRawData
    );

BOOL
WINAPI
ReportEventW (
         HANDLE     hEventLog,
         WORD       wType,
         WORD       wCategory,
         DWORD      dwEventID,
     PSID       lpUserSid,
         WORD       wNumStrings,
         DWORD      dwDataSize,
    _In_reads_opt_(wNumStrings) LPCWSTR *lpStrings,
    _In_reads_bytes_opt_(dwDataSize) LPVOID lpRawData
    );
#ifdef UNICODE
#define ReportEvent  ReportEventW
#else
#define ReportEvent  ReportEventA
#endif // !UNICODE


#define EVENTLOG_FULL_INFO      0

typedef struct _EVENTLOG_FULL_INFORMATION
{
    DWORD    dwFull;
}
EVENTLOG_FULL_INFORMATION, *LPEVENTLOG_FULL_INFORMATION;


BOOL
WINAPI
GetEventLogInformation (
      HANDLE     hEventLog,
      DWORD      dwInfoLevel,
    _Out_writes_bytes_to_(cbBufSize, *pcbBytesNeeded) LPVOID lpBuffer,
      DWORD      cbBufSize,
    _Out_ LPDWORD    pcbBytesNeeded
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
WINAPI
OperationStart (
     OPERATION_START_PARAMETERS* OperationStartParams
    );


BOOL
WINAPI
OperationEnd (
     OPERATION_END_PARAMETERS* OperationEndParams
    );

#endif // _WIN32_WINNT >= 0x0602

//
//
// Security APIs
//



BOOL
WINAPI
AccessCheckAndAuditAlarmA (
         LPCSTR SubsystemName,
     LPVOID HandleId,
         LPSTR ObjectTypeName,
     LPSTR ObjectName,
         PSECURITY_DESCRIPTOR SecurityDescriptor,
         DWORD DesiredAccess,
         PGENERIC_MAPPING GenericMapping,
         BOOL ObjectCreation,
    _Out_    LPDWORD GrantedAccess,
    _Out_    LPBOOL AccessStatus,
    _Out_    LPBOOL pfGenerateOnClose
    );
#ifndef UNICODE
#define AccessCheckAndAuditAlarm  AccessCheckAndAuditAlarmA
#endif

#if(_WIN32_WINNT >= 0x0500)


BOOL
WINAPI
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
    _Inout_updates_opt_(ObjectTypeListLength) POBJECT_TYPE_LIST ObjectTypeList,
         DWORD ObjectTypeListLength,
         PGENERIC_MAPPING GenericMapping,
         BOOL ObjectCreation,
    _Out_    LPDWORD GrantedAccess,
    _Out_    LPBOOL AccessStatus,
    _Out_    LPBOOL pfGenerateOnClose
    );
#ifndef UNICODE
#define AccessCheckByTypeAndAuditAlarm  AccessCheckByTypeAndAuditAlarmA
#endif


BOOL
WINAPI
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
    _Inout_updates_opt_(ObjectTypeListLength) POBJECT_TYPE_LIST ObjectTypeList,
         DWORD ObjectTypeListLength,
         PGENERIC_MAPPING GenericMapping,
         BOOL ObjectCreation,
    _Out_writes_(ObjectTypeListLength)       LPDWORD GrantedAccess,
    _Out_writes_(ObjectTypeListLength)       LPDWORD AccessStatusList,
    _Out_    LPBOOL pfGenerateOnClose
    );
#ifndef UNICODE
#define AccessCheckByTypeResultListAndAuditAlarm  AccessCheckByTypeResultListAndAuditAlarmA
#endif


BOOL
WINAPI
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
    _Inout_updates_opt_(ObjectTypeListLength) POBJECT_TYPE_LIST ObjectTypeList,
         DWORD ObjectTypeListLength,
         PGENERIC_MAPPING GenericMapping,
         BOOL ObjectCreation,
    _Out_writes_(ObjectTypeListLength)       LPDWORD GrantedAccess,
    _Out_writes_(ObjectTypeListLength)       LPDWORD AccessStatusList,
    _Out_    LPBOOL pfGenerateOnClose
    );
#ifndef UNICODE
#define AccessCheckByTypeResultListAndAuditAlarmByHandle  AccessCheckByTypeResultListAndAuditAlarmByHandleA
#endif
#endif //(_WIN32_WINNT >= 0x0500)


BOOL
WINAPI
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
    _Out_    LPBOOL GenerateOnClose
    );
#ifndef UNICODE
#define ObjectOpenAuditAlarm  ObjectOpenAuditAlarmA
#endif


BOOL
WINAPI
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
WINAPI
ObjectCloseAuditAlarmA (
     LPCSTR SubsystemName,
     LPVOID HandleId,
     BOOL GenerateOnClose
    );
#ifndef UNICODE
#define ObjectCloseAuditAlarm  ObjectCloseAuditAlarmA
#endif


BOOL
WINAPI
ObjectDeleteAuditAlarmA (
     LPCSTR SubsystemName,
     LPVOID HandleId,
     BOOL GenerateOnClose
    );
#ifndef UNICODE
#define ObjectDeleteAuditAlarm  ObjectDeleteAuditAlarmA
#endif


BOOL
WINAPI
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
WINAPI
AddConditionalAce (
    _Inout_ PACL pAcl,
        DWORD dwAceRevision,
        DWORD AceFlags,
        UCHAR AceType,
        DWORD AccessMask,
        PSID pSid,
     _Null_terminated_ PWCHAR ConditionStr,
    _Out_ DWORD *ReturnLength
    );
#endif /* _WIN32_WINNT >=  0x0601 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


BOOL
WINAPI
SetFileSecurityA (
     LPCSTR lpFileName,
     SECURITY_INFORMATION SecurityInformation,
     PSECURITY_DESCRIPTOR pSecurityDescriptor
    );
#ifndef UNICODE
#define SetFileSecurity  SetFileSecurityA
#endif


BOOL
WINAPI
GetFileSecurityA (
      LPCSTR lpFileName,
      SECURITY_INFORMATION RequestedInformation,
    _Out_writes_bytes_to_opt_(nLength, *lpnLengthNeeded) PSECURITY_DESCRIPTOR pSecurityDescriptor,
      DWORD nLength,
    _Out_ LPDWORD lpnLengthNeeded
    );
#ifndef UNICODE
#define GetFileSecurity  GetFileSecurityA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

#if(_WIN32_WINNT >= 0x0400)
WINBASEAPI
BOOL
WINAPI
ReadDirectoryChangesW(
            HANDLE hDirectory,
    _Out_writes_bytes_to_(nBufferLength, *lpBytesReturned) LPVOID lpBuffer,
            DWORD nBufferLength,
            BOOL bWatchSubtree,
            DWORD dwNotifyFilter,
    _Out_opt_   LPDWORD lpBytesReturned,
    _Inout_opt_ LPOVERLAPPED lpOverlapped,
        LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    );

#if (NTDDI_VERSION >= NTDDI_WIN10_RS3)
WINBASEAPI
BOOL
WINAPI
ReadDirectoryChangesExW(
            HANDLE hDirectory,
    _Out_writes_bytes_to_(nBufferLength, *lpBytesReturned) LPVOID lpBuffer,
            DWORD nBufferLength,
            BOOL bWatchSubtree,
            DWORD dwNotifyFilter,
    _Out_opt_   LPDWORD lpBytesReturned,
    _Inout_opt_ LPOVERLAPPED lpOverlapped,
        LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine,
            READ_DIRECTORY_NOTIFY_INFORMATION_CLASS ReadDirectoryNotifyInformationClass
    );
#endif
#endif /* _WIN32_WINNT >= 0x0400 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if _WIN32_WINNT >= 0x0600

WINBASEAPI
_Ret_maybenull_ __out_data_source(FILE)
LPVOID
WINAPI
MapViewOfFileExNuma(
         HANDLE hFileMappingObject,
         DWORD dwDesiredAccess,
         DWORD dwFileOffsetHigh,
         DWORD dwFileOffsetLow,
         SIZE_T dwNumberOfBytesToMap,
     LPVOID lpBaseAddress,
         DWORD nndPreferred
    );

#endif // _WIN32_WINNT >= 0x0600

WINBASEAPI
BOOL
WINAPI
IsBadReadPtr(
     CONST VOID *lp,
         UINT_PTR ucb
    );

WINBASEAPI
BOOL
WINAPI
IsBadWritePtr(
     LPVOID lp,
         UINT_PTR ucb
    );

WINBASEAPI
BOOL
WINAPI
IsBadHugeReadPtr(
     CONST VOID *lp,
         UINT_PTR ucb
    );

WINBASEAPI
BOOL
WINAPI
IsBadHugeWritePtr(
     LPVOID lp,
         UINT_PTR ucb
    );

WINBASEAPI
BOOL
WINAPI
IsBadCodePtr(
     FARPROC lpfn
    );

WINBASEAPI
BOOL
WINAPI
IsBadStringPtrA(
     LPCSTR lpsz,
         UINT_PTR ucchMax
    );
WINBASEAPI
BOOL
WINAPI
IsBadStringPtrW(
     LPCWSTR lpsz,
         UINT_PTR ucchMax
    );
#ifdef UNICODE
#define IsBadStringPtr  IsBadStringPtrW
#else
#define IsBadStringPtr  IsBadStringPtrA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


_Success_(return != FALSE) BOOL
WINAPI
LookupAccountSidA(
     LPCSTR lpSystemName,
     PSID Sid,
    _Out_writes_to_opt_(*cchName, *cchName + 1) LPSTR Name,
    _Inout_  LPDWORD cchName,
    _Out_writes_to_opt_(*cchReferencedDomainName, *cchReferencedDomainName + 1) LPSTR ReferencedDomainName,
    _Inout_ LPDWORD cchReferencedDomainName,
    _Out_ PSID_NAME_USE peUse
    );

_Success_(return != FALSE) BOOL
WINAPI
LookupAccountSidW(
     LPCWSTR lpSystemName,
     PSID Sid,
    _Out_writes_to_opt_(*cchName, *cchName + 1) LPWSTR Name,
    _Inout_  LPDWORD cchName,
    _Out_writes_to_opt_(*cchReferencedDomainName, *cchReferencedDomainName + 1) LPWSTR ReferencedDomainName,
    _Inout_ LPDWORD cchReferencedDomainName,
    _Out_ PSID_NAME_USE peUse
    );
#ifdef UNICODE
#define LookupAccountSid  LookupAccountSidW
#else
#define LookupAccountSid  LookupAccountSidA
#endif // !UNICODE


_Success_(return != FALSE) BOOL
WINAPI
LookupAccountNameA(
     LPCSTR lpSystemName,
         LPCSTR lpAccountName,
    _Out_writes_bytes_to_opt_(*cbSid, *cbSid) PSID Sid,
    _Inout_  LPDWORD cbSid,
    _Out_writes_to_opt_(*cchReferencedDomainName, *cchReferencedDomainName + 1) LPSTR ReferencedDomainName,
    _Inout_  LPDWORD cchReferencedDomainName,
    _Out_    PSID_NAME_USE peUse
    );

_Success_(return != FALSE) BOOL
WINAPI
LookupAccountNameW(
     LPCWSTR lpSystemName,
         LPCWSTR lpAccountName,
    _Out_writes_bytes_to_opt_(*cbSid, *cbSid) PSID Sid,
    _Inout_  LPDWORD cbSid,
    _Out_writes_to_opt_(*cchReferencedDomainName, *cchReferencedDomainName + 1) LPWSTR ReferencedDomainName,
    _Inout_  LPDWORD cchReferencedDomainName,
    _Out_    PSID_NAME_USE peUse
    );
#ifdef UNICODE
#define LookupAccountName  LookupAccountNameW
#else
#define LookupAccountName  LookupAccountNameA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if _WIN32_WINNT >= 0x0601


_Success_(return != FALSE) BOOL
WINAPI
LookupAccountNameLocalA(
         LPCSTR lpAccountName,
    _Out_writes_bytes_to_opt_(*cbSid, *cbSid) PSID Sid,
    _Inout_  LPDWORD cbSid,
    _Out_writes_to_opt_(*cchReferencedDomainName, *cchReferencedDomainName + 1) LPSTR ReferencedDomainName,
    _Inout_  LPDWORD cchReferencedDomainName,
    _Out_    PSID_NAME_USE peUse
    );

_Success_(return != FALSE) BOOL
WINAPI
LookupAccountNameLocalW(
         LPCWSTR lpAccountName,
    _Out_writes_bytes_to_opt_(*cbSid, *cbSid) PSID Sid,
    _Inout_  LPDWORD cbSid,
    _Out_writes_to_opt_(*cchReferencedDomainName, *cchReferencedDomainName + 1) LPWSTR ReferencedDomainName,
    _Inout_  LPDWORD cchReferencedDomainName,
    _Out_    PSID_NAME_USE peUse
    );
#ifdef UNICODE
#define LookupAccountNameLocal  LookupAccountNameLocalW
#else
#define LookupAccountNameLocal  LookupAccountNameLocalA
#endif // !UNICODE


_Success_(return != FALSE) BOOL
WINAPI
LookupAccountSidLocalA(
     PSID Sid,
    _Out_writes_to_opt_(*cchName, *cchName + 1) LPSTR Name,
    _Inout_  LPDWORD cchName,
    _Out_writes_to_opt_(*cchReferencedDomainName, *cchReferencedDomainName + 1) LPSTR ReferencedDomainName,
    _Inout_ LPDWORD cchReferencedDomainName,
    _Out_ PSID_NAME_USE peUse
    );

_Success_(return != FALSE) BOOL
WINAPI
LookupAccountSidLocalW(
     PSID Sid,
    _Out_writes_to_opt_(*cchName, *cchName + 1) LPWSTR Name,
    _Inout_  LPDWORD cchName,
    _Out_writes_to_opt_(*cchReferencedDomainName, *cchReferencedDomainName + 1) LPWSTR ReferencedDomainName,
    _Inout_ LPDWORD cchReferencedDomainName,
    _Out_ PSID_NAME_USE peUse
    );
#ifdef UNICODE
#define LookupAccountSidLocal  LookupAccountSidLocalW
#else
#define LookupAccountSidLocal  LookupAccountSidLocalA
#endif // !UNICODE

#else // _WIN32_WINNT >= 0x0601

#define LookupAccountNameLocalA(n, s, cs, d, cd, u) \
    LookupAccountNameA(NULL, n, s, cs, d, cd, u)
#define LookupAccountNameLocalW(n, s, cs, d, cd, u) \
    LookupAccountNameW(NULL, n, s, cs, d, cd, u)
#ifdef UNICODE
#define LookupAccountNameLocal  LookupAccountNameLocalW
#else
#define LookupAccountNameLocal  LookupAccountNameLocalA
#endif // !UNICODE

#define LookupAccountSidLocalA(s, n, cn, d, cd, u)  \
    LookupAccountSidA(NULL, s, n, cn, d, cd, u)
#define LookupAccountSidLocalW(s, n, cn, d, cd, u)  \
    LookupAccountSidW(NULL, s, n, cn, d, cd, u)
#ifdef UNICODE
#define LookupAccountSidLocal  LookupAccountSidLocalW
#else
#define LookupAccountSidLocal  LookupAccountSidLocalA
#endif // !UNICODE

#endif // _WIN32_WINNT >= 0x0601

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


BOOL
WINAPI
LookupPrivilegeValueA(
     LPCSTR lpSystemName,
         LPCSTR lpName,
    _Out_    PLUID   lpLuid
    );

BOOL
WINAPI
LookupPrivilegeValueW(
     LPCWSTR lpSystemName,
         LPCWSTR lpName,
    _Out_    PLUID   lpLuid
    );
#ifdef UNICODE
#define LookupPrivilegeValue  LookupPrivilegeValueW
#else
#define LookupPrivilegeValue  LookupPrivilegeValueA
#endif // !UNICODE


_Success_(return != FALSE) BOOL
WINAPI
LookupPrivilegeNameA(
     LPCSTR lpSystemName,
         PLUID   lpLuid,
    _Out_writes_to_opt_(*cchName, *cchName + 1) LPSTR lpName,
    _Inout_  LPDWORD cchName
    );

_Success_(return != FALSE) BOOL
WINAPI
LookupPrivilegeNameW(
     LPCWSTR lpSystemName,
         PLUID   lpLuid,
    _Out_writes_to_opt_(*cchName, *cchName + 1) LPWSTR lpName,
    _Inout_  LPDWORD cchName
    );
#ifdef UNICODE
#define LookupPrivilegeName  LookupPrivilegeNameW
#else
#define LookupPrivilegeName  LookupPrivilegeNameA
#endif // !UNICODE


_Success_(return != FALSE) BOOL
WINAPI
LookupPrivilegeDisplayNameA(
     LPCSTR lpSystemName,
         LPCSTR lpName,
    _Out_writes_to_opt_(*cchDisplayName, *cchDisplayName + 1) LPSTR lpDisplayName,
    _Inout_  LPDWORD cchDisplayName,
    _Out_    LPDWORD lpLanguageId
    );

_Success_(return != FALSE) BOOL
WINAPI
LookupPrivilegeDisplayNameW(
     LPCWSTR lpSystemName,
         LPCWSTR lpName,
    _Out_writes_to_opt_(*cchDisplayName, *cchDisplayName + 1) LPWSTR lpDisplayName,
    _Inout_  LPDWORD cchDisplayName,
    _Out_    LPDWORD lpLanguageId
    );
#ifdef UNICODE
#define LookupPrivilegeDisplayName  LookupPrivilegeDisplayNameW
#else
#define LookupPrivilegeDisplayName  LookupPrivilegeDisplayNameA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
BOOL
WINAPI
BuildCommDCBA(
      LPCSTR lpDef,
    _Out_ LPDCB lpDCB
    );
WINBASEAPI
BOOL
WINAPI
BuildCommDCBW(
      LPCWSTR lpDef,
    _Out_ LPDCB lpDCB
    );
#ifdef UNICODE
#define BuildCommDCB  BuildCommDCBW
#else
#define BuildCommDCB  BuildCommDCBA
#endif // !UNICODE

WINBASEAPI
BOOL
WINAPI
BuildCommDCBAndTimeoutsA(
      LPCSTR lpDef,
    _Out_ LPDCB lpDCB,
    _Out_ LPCOMMTIMEOUTS lpCommTimeouts
    );
WINBASEAPI
BOOL
WINAPI
BuildCommDCBAndTimeoutsW(
      LPCWSTR lpDef,
    _Out_ LPDCB lpDCB,
    _Out_ LPCOMMTIMEOUTS lpCommTimeouts
    );
#ifdef UNICODE
#define BuildCommDCBAndTimeouts  BuildCommDCBAndTimeoutsW
#else
#define BuildCommDCBAndTimeouts  BuildCommDCBAndTimeoutsA
#endif // !UNICODE

WINBASEAPI
BOOL
WINAPI
CommConfigDialogA(
         LPCSTR lpszName,
     HWND hWnd,
    _Inout_  LPCOMMCONFIG lpCC
    );
WINBASEAPI
BOOL
WINAPI
CommConfigDialogW(
         LPCWSTR lpszName,
     HWND hWnd,
    _Inout_  LPCOMMCONFIG lpCC
    );
#ifdef UNICODE
#define CommConfigDialog  CommConfigDialogW
#else
#define CommConfigDialog  CommConfigDialogA
#endif // !UNICODE

WINBASEAPI
BOOL
WINAPI
GetDefaultCommConfigA(
        LPCSTR lpszName,
    _Out_writes_bytes_to_(*lpdwSize, *lpdwSize) LPCOMMCONFIG lpCC,
    _Inout_ LPDWORD lpdwSize
    );
WINBASEAPI
BOOL
WINAPI
GetDefaultCommConfigW(
        LPCWSTR lpszName,
    _Out_writes_bytes_to_(*lpdwSize, *lpdwSize) LPCOMMCONFIG lpCC,
    _Inout_ LPDWORD lpdwSize
    );
#ifdef UNICODE
#define GetDefaultCommConfig  GetDefaultCommConfigW
#else
#define GetDefaultCommConfig  GetDefaultCommConfigA
#endif // !UNICODE

WINBASEAPI
BOOL
WINAPI
SetDefaultCommConfigA(
     LPCSTR lpszName,
    _In_reads_bytes_(dwSize) LPCOMMCONFIG lpCC,
     DWORD dwSize
    );
WINBASEAPI
BOOL
WINAPI
SetDefaultCommConfigW(
     LPCWSTR lpszName,
    _In_reads_bytes_(dwSize) LPCOMMCONFIG lpCC,
     DWORD dwSize
    );
#ifdef UNICODE
#define SetDefaultCommConfig  SetDefaultCommConfigW
#else
#define SetDefaultCommConfig  SetDefaultCommConfigA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

#ifndef _MAC
#define MAX_COMPUTERNAME_LENGTH 15
#else
#define MAX_COMPUTERNAME_LENGTH 31
#endif

WINBASEAPI
_Success_(return != 0)
BOOL
WINAPI
GetComputerNameA (
    _Out_writes_to_opt_(*nSize, *nSize + 1) LPSTR lpBuffer,
    _Inout_ LPDWORD nSize
    );
WINBASEAPI
_Success_(return != 0)
BOOL
WINAPI
GetComputerNameW (
    _Out_writes_to_opt_(*nSize, *nSize + 1) LPWSTR lpBuffer,
    _Inout_ LPDWORD nSize
    );
#ifdef UNICODE
#define GetComputerName  GetComputerNameW
#else
#define GetComputerName  GetComputerNameA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if (_WIN32_WINNT >= 0x0500)


WINBASEAPI
_Success_(return != FALSE)
BOOL
WINAPI
DnsHostnameToComputerNameA (
        LPCSTR Hostname,
    _Out_writes_to_opt_(*nSize, *nSize + 1) LPSTR ComputerName,
    _Inout_ LPDWORD nSize
    );
WINBASEAPI
_Success_(return != FALSE)
BOOL
WINAPI
DnsHostnameToComputerNameW (
        LPCWSTR Hostname,
    _Out_writes_to_opt_(*nSize, *nSize + 1) LPWSTR ComputerName,
    _Inout_ LPDWORD nSize
    );
#ifdef UNICODE
#define DnsHostnameToComputerName  DnsHostnameToComputerNameW
#else
#define DnsHostnameToComputerName  DnsHostnameToComputerNameA
#endif // !UNICODE

#endif // _WIN32_WINNT


BOOL
WINAPI
GetUserNameA (
    _Out_writes_to_opt_(*pcbBuffer, *pcbBuffer) LPSTR lpBuffer,
    _Inout_ LPDWORD pcbBuffer
    );

BOOL
WINAPI
GetUserNameW (
    _Out_writes_to_opt_(*pcbBuffer, *pcbBuffer) LPWSTR lpBuffer,
    _Inout_ LPDWORD pcbBuffer
    );
#ifdef UNICODE
#define GetUserName  GetUserNameW
#else
#define GetUserName  GetUserNameA
#endif // !UNICODE

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
#endif // (_WIN32_WINNT >= 0x0500)

#define LOGON32_PROVIDER_DEFAULT    0
#define LOGON32_PROVIDER_WINNT35    1
#if(_WIN32_WINNT >= 0x0400)
#define LOGON32_PROVIDER_WINNT40    2
#endif /* _WIN32_WINNT >= 0x0400 */
#if(_WIN32_WINNT >= 0x0500)
#define LOGON32_PROVIDER_WINNT50    3
#endif // (_WIN32_WINNT >= 0x0500)
#if(_WIN32_WINNT >= 0x0600)
#define LOGON32_PROVIDER_VIRTUAL    4
#endif // (_WIN32_WINNT >= 0x0600)




BOOL
WINAPI
LogonUserA (
            LPCSTR lpszUsername,
        LPCSTR lpszDomain,
        LPCSTR lpszPassword,
            DWORD dwLogonType,
            DWORD dwLogonProvider,
    _Outptr_ PHANDLE phToken
    );

BOOL
WINAPI
LogonUserW (
            LPCWSTR lpszUsername,
        LPCWSTR lpszDomain,
        LPCWSTR lpszPassword,
            DWORD dwLogonType,
            DWORD dwLogonProvider,
    _Outptr_ PHANDLE phToken
    );
#ifdef UNICODE
#define LogonUser  LogonUserW
#else
#define LogonUser  LogonUserA
#endif // !UNICODE


BOOL
WINAPI
LogonUserExA (
                LPCSTR lpszUsername,
            LPCSTR lpszDomain,
            LPCSTR lpszPassword,
                DWORD dwLogonType,
                DWORD dwLogonProvider,
    _Outptr_opt_ PHANDLE phToken,
    _Outptr_opt_ PSID  *ppLogonSid,
    _Outptr_opt_result_bytebuffer_all_(*pdwProfileLength) PVOID *ppProfileBuffer,
    _Out_opt_       LPDWORD pdwProfileLength,
    _Out_opt_       PQUOTA_LIMITS pQuotaLimits
    );

BOOL
WINAPI
LogonUserExW (
                LPCWSTR lpszUsername,
            LPCWSTR lpszDomain,
            LPCWSTR lpszPassword,
                DWORD dwLogonType,
                DWORD dwLogonProvider,
    _Outptr_opt_ PHANDLE phToken,
    _Outptr_opt_ PSID  *ppLogonSid,
    _Outptr_opt_result_bytebuffer_all_(*pdwProfileLength) PVOID *ppProfileBuffer,
    _Out_opt_       LPDWORD pdwProfileLength,
    _Out_opt_       PQUOTA_LIMITS pQuotaLimits
    );
#ifdef UNICODE
#define LogonUserEx  LogonUserExW
#else
#define LogonUserEx  LogonUserExA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#if(_WIN32_WINNT >= 0x0600)


#endif // (_WIN32_WINNT >= 0x0600)

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if(_WIN32_WINNT >= 0x0500)

//
// LogonFlags
//
#define LOGON_WITH_PROFILE              0x00000001
#define LOGON_NETCREDENTIALS_ONLY       0x00000002
#define LOGON_ZERO_PASSWORD_BUFFER      0x80000000

//@[comment("MVI_tracked")]

_Must_inspect_result_ BOOL
WINAPI
CreateProcessWithLogonW(
            LPCWSTR lpUsername,
        LPCWSTR lpDomain,
            LPCWSTR lpPassword,
            DWORD dwLogonFlags,
        LPCWSTR lpApplicationName,
    _Inout_opt_ LPWSTR lpCommandLine,
            DWORD dwCreationFlags,
        LPVOID lpEnvironment,
        LPCWSTR lpCurrentDirectory,
            LPSTARTUPINFOW lpStartupInfo,
    _Out_       LPPROCESS_INFORMATION lpProcessInformation
      );


_Must_inspect_result_ BOOL
WINAPI
CreateProcessWithTokenW(
            HANDLE hToken,
            DWORD dwLogonFlags,
        LPCWSTR lpApplicationName,
    _Inout_opt_ LPWSTR lpCommandLine,
            DWORD dwCreationFlags,
        LPVOID lpEnvironment,
        LPCWSTR lpCurrentDirectory,
            LPSTARTUPINFOW lpStartupInfo,
    _Out_       LPPROCESS_INFORMATION lpProcessInformation
      );

#endif // (_WIN32_WINNT >= 0x0500)


BOOL
WINAPI
IsTokenUntrusted(
     HANDLE TokenHandle
    );

//
// Thread pool API's
//

#if (_WIN32_WINNT >= 0x0500)

WINBASEAPI
BOOL
WINAPI
RegisterWaitForSingleObject(
    _Outptr_ PHANDLE phNewWaitObject,
            HANDLE hObject,
            WAITORTIMERCALLBACK Callback,
        PVOID Context,
            ULONG dwMilliseconds,
            ULONG dwFlags
    );

WINBASEAPI
_Must_inspect_result_
BOOL
WINAPI
UnregisterWait(
     HANDLE WaitHandle
    );

WINBASEAPI
BOOL
WINAPI
BindIoCompletionCallback (
     HANDLE FileHandle,
     LPOVERLAPPED_COMPLETION_ROUTINE Function,
     ULONG Flags
    );

WINBASEAPI
HANDLE
WINAPI
SetTimerQueueTimer(
     HANDLE TimerQueue,
         WAITORTIMERCALLBACK Callback,
     PVOID Parameter,
         DWORD DueTime,
         DWORD Period,
         BOOL PreferIo
    );

WINBASEAPI
_Must_inspect_result_
BOOL
WINAPI
CancelTimerQueueTimer(
     HANDLE TimerQueue,
         HANDLE Timer
    );

WINBASEAPI
_Must_inspect_result_
BOOL
WINAPI
DeleteTimerQueue(
     HANDLE TimerQueue
    );

#endif // _WIN32_WINNT >= 0x0500

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */

#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP)

#if (_WIN32_WINNT >= 0x0500)

#if (_WIN32_WINNT >= 0x0600)

#if !defined(MIDL_PASS)

FORCEINLINE
VOID
InitializeThreadpoolEnvironment(
    _Out_ PTP_CALLBACK_ENVIRON pcbe
    )
{
    TpInitializeCallbackEnviron(pcbe);
}

FORCEINLINE
VOID
SetThreadpoolCallbackPool(
    _Inout_ PTP_CALLBACK_ENVIRON pcbe,
        PTP_POOL             ptpp
    )
{
    TpSetCallbackThreadpool(pcbe, ptpp);
}

FORCEINLINE
VOID
SetThreadpoolCallbackCleanupGroup(
    _Inout_  PTP_CALLBACK_ENVIRON              pcbe,
         PTP_CLEANUP_GROUP                 ptpcg,
     PTP_CLEANUP_GROUP_CANCEL_CALLBACK pfng
    )
{
    TpSetCallbackCleanupGroup(pcbe, ptpcg, pfng);
}

FORCEINLINE
VOID
SetThreadpoolCallbackRunsLong(
    _Inout_ PTP_CALLBACK_ENVIRON pcbe
    )
{
    TpSetCallbackLongFunction(pcbe);
}

FORCEINLINE
VOID
SetThreadpoolCallbackLibrary(
    _Inout_ PTP_CALLBACK_ENVIRON pcbe,
        PVOID                mod
    )
{
    TpSetCallbackRaceWithDll(pcbe, mod);
}

#if (_WIN32_WINNT >= _WIN32_WINNT_WIN7)

FORCEINLINE
VOID
SetThreadpoolCallbackPriority(
    _Inout_ PTP_CALLBACK_ENVIRON pcbe,
        TP_CALLBACK_PRIORITY Priority
    )
{
    TpSetCallbackPriority(pcbe, Priority);
}

#endif

FORCEINLINE
VOID
DestroyThreadpoolEnvironment(
    _Inout_ PTP_CALLBACK_ENVIRON pcbe
    )
{
    TpDestroyCallbackEnviron(pcbe);
}

#endif // !defined(MIDL_PASS)

#endif // _WIN32_WINNT >= 0x0600

#endif // _WIN32_WINNT >= 0x0500

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */

#if (_WIN32_WINNT >= 0x0600)

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if !defined(MIDL_PASS)

FORCEINLINE
VOID
SetThreadpoolCallbackPersistent(
    _Inout_ PTP_CALLBACK_ENVIRON pcbe
    )
{
    TpSetCallbackPersistent(pcbe);
}

#endif // !defined(MIDL_PASS)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

//
//  Private Namespaces support
//

WINBASEAPI
_Ret_maybenull_
HANDLE
WINAPI
CreatePrivateNamespaceA(
     LPSECURITY_ATTRIBUTES lpPrivateNamespaceAttributes,
         LPVOID lpBoundaryDescriptor,
         LPCSTR lpAliasPrefix
    );

#ifndef UNICODE
#define CreatePrivateNamespace CreatePrivateNamespaceA
#else
#define CreatePrivateNamespace CreatePrivateNamespaceW
#endif

WINBASEAPI
_Ret_maybenull_
HANDLE
WINAPI
OpenPrivateNamespaceA(
         LPVOID lpBoundaryDescriptor,
         LPCSTR lpAliasPrefix
    );

#ifndef UNICODE
#define OpenPrivateNamespace OpenPrivateNamespaceA
#else
#define OpenPrivateNamespace OpenPrivateNamespaceW
#endif


//
//  Boundary descriptors support
//

WINBASEAPI
_Ret_maybenull_
HANDLE
APIENTRY
CreateBoundaryDescriptorA(
     LPCSTR Name,
     ULONG Flags
    );

#ifndef UNICODE
#define CreateBoundaryDescriptor CreateBoundaryDescriptorA
#else
#define CreateBoundaryDescriptor CreateBoundaryDescriptorW
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
BOOL
WINAPI
AddIntegrityLabelToBoundaryDescriptor(
    _Inout_ HANDLE * BoundaryDescriptor,
     PSID IntegrityLabel
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif // _WIN32_WINNT >= 0x0600

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

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
#else
typedef HW_PROFILE_INFOA HW_PROFILE_INFO;
typedef LPHW_PROFILE_INFOA LPHW_PROFILE_INFO;
#endif // UNICODE



BOOL
WINAPI
GetCurrentHwProfileA (
    _Out_ LPHW_PROFILE_INFOA  lpHwProfileInfo
    );

BOOL
WINAPI
GetCurrentHwProfileW (
    _Out_ LPHW_PROFILE_INFOW  lpHwProfileInfo
    );
#ifdef UNICODE
#define GetCurrentHwProfile  GetCurrentHwProfileW
#else
#define GetCurrentHwProfile  GetCurrentHwProfileA
#endif // !UNICODE
#endif /* _WIN32_WINNT >= 0x0400 */

WINBASEAPI
BOOL
WINAPI
VerifyVersionInfoA(
    _Inout_ LPOSVERSIONINFOEXA lpVersionInformation,
        DWORD dwTypeMask,
        DWORDLONG dwlConditionMask
    );
WINBASEAPI
BOOL
WINAPI
VerifyVersionInfoW(
    _Inout_ LPOSVERSIONINFOEXW lpVersionInformation,
        DWORD dwTypeMask,
        DWORDLONG dwlConditionMask
    );
#ifdef UNICODE
#define VerifyVersionInfo  VerifyVersionInfoW
#else
#define VerifyVersionInfo  VerifyVersionInfoA
#endif // !UNICODE


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

// DOS and OS/2 Compatible Error Code definitions returned by the Win32 Base
// API functions.
//

require("win32.winerror")
require("win32.timezoneapi")

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

/* Abnormal termination codes */

#define TC_NORMAL       0
#define TC_HARDERR      1
#define TC_GP_TRAP      2
#define TC_SIGNAL       3

#if(WINVER >= 0x0400)
//
// Power Management APIs
//

WINBASEAPI
BOOL
WINAPI
SetSystemPowerState(
     BOOL fSuspend,
     BOOL fForce
    );

#endif /* WINVER >= 0x0400 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

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

WINBASEAPI
BOOL
WINAPI
GetSystemPowerStatus(
    _Out_ LPSYSTEM_POWER_STATUS lpSystemPowerStatus
    );

#endif /* WINVER >= 0x0400 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_PC_APP) */
#pragma endregion

#if (_WIN32_WINNT >= 0x0500)
//
// Very Large Memory API Subset
//

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
BOOL
WINAPI
MapUserPhysicalPagesScatter(
    _In_reads_(NumberOfPages) PVOID *VirtualAddresses,
     ULONG_PTR NumberOfPages,
    _In_reads_opt_(NumberOfPages) PULONG_PTR PageArray
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
_Ret_maybenull_
HANDLE
WINAPI
CreateJobObjectA(
     LPSECURITY_ATTRIBUTES lpJobAttributes,
     LPCSTR lpName
    );

#ifdef UNICODE
#define CreateJobObject  CreateJobObjectW
#else
#define CreateJobObject  CreateJobObjectA
#endif // !UNICODE

WINBASEAPI
_Ret_maybenull_
HANDLE
WINAPI
OpenJobObjectA(
     DWORD dwDesiredAccess,
     BOOL bInheritHandle,
     LPCSTR lpName
    );

#ifdef UNICODE
#define OpenJobObject  OpenJobObjectW
#else
#define OpenJobObject  OpenJobObjectA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
BOOL
WINAPI
CreateJobSet (
     ULONG NumJob,
    _In_reads_(NumJob) PJOB_SET_ARRAY UserJobSet,
     ULONG Flags);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
HANDLE
WINAPI
FindFirstVolumeA(
    _Out_writes_(cchBufferLength) LPSTR lpszVolumeName,
     DWORD cchBufferLength
    );
#ifndef UNICODE
#define FindFirstVolume FindFirstVolumeA
#endif

WINBASEAPI
BOOL
WINAPI
FindNextVolumeA(
    _Inout_ HANDLE hFindVolume,
    _Out_writes_(cchBufferLength) LPSTR lpszVolumeName,
        DWORD cchBufferLength
    );
#ifndef UNICODE
#define FindNextVolume FindNextVolumeA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
HANDLE
WINAPI
FindFirstVolumeMountPointA(
     LPCSTR lpszRootPathName,
    _Out_writes_(cchBufferLength) LPSTR lpszVolumeMountPoint,
     DWORD cchBufferLength
    );
WINBASEAPI
HANDLE
WINAPI
FindFirstVolumeMountPointW(
     LPCWSTR lpszRootPathName,
    _Out_writes_(cchBufferLength) LPWSTR lpszVolumeMountPoint,
     DWORD cchBufferLength
    );
#ifdef UNICODE
#define FindFirstVolumeMountPoint FindFirstVolumeMountPointW
#else
#define FindFirstVolumeMountPoint FindFirstVolumeMountPointA
#endif // !UNICODE

WINBASEAPI
BOOL
WINAPI
FindNextVolumeMountPointA(
     HANDLE hFindVolumeMountPoint,
    _Out_writes_(cchBufferLength) LPSTR lpszVolumeMountPoint,
     DWORD cchBufferLength
    );
WINBASEAPI
BOOL
WINAPI
FindNextVolumeMountPointW(
     HANDLE hFindVolumeMountPoint,
    _Out_writes_(cchBufferLength) LPWSTR lpszVolumeMountPoint,
     DWORD cchBufferLength
    );
#ifdef UNICODE
#define FindNextVolumeMountPoint FindNextVolumeMountPointW
#else
#define FindNextVolumeMountPoint FindNextVolumeMountPointA
#endif // !UNICODE

WINBASEAPI
BOOL
WINAPI
FindVolumeMountPointClose(
     HANDLE hFindVolumeMountPoint
    );

WINBASEAPI
BOOL
WINAPI
SetVolumeMountPointA(
     LPCSTR lpszVolumeMountPoint,
     LPCSTR lpszVolumeName
    );
WINBASEAPI
BOOL
WINAPI
SetVolumeMountPointW(
     LPCWSTR lpszVolumeMountPoint,
     LPCWSTR lpszVolumeName
    );
#ifdef UNICODE
#define SetVolumeMountPoint  SetVolumeMountPointW
#else
#define SetVolumeMountPoint  SetVolumeMountPointA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
BOOL
WINAPI
DeleteVolumeMountPointA(
     LPCSTR lpszVolumeMountPoint
    );
#ifndef UNICODE
#define DeleteVolumeMountPoint  DeleteVolumeMountPointA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

#ifndef UNICODE
#define GetVolumeNameForVolumeMountPoint  GetVolumeNameForVolumeMountPointA
#endif

WINBASEAPI
BOOL
WINAPI
GetVolumeNameForVolumeMountPointA(
     LPCSTR lpszVolumeMountPoint,
    _Out_writes_(cchBufferLength) LPSTR lpszVolumeName,
     DWORD cchBufferLength
);

WINBASEAPI
BOOL
WINAPI
GetVolumePathNameA(
     LPCSTR lpszFileName,
    _Out_writes_(cchBufferLength) LPSTR lpszVolumePathName,
     DWORD cchBufferLength
    );
#ifndef UNICODE
#define GetVolumePathName  GetVolumePathNameA
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#endif

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

#if(_WIN32_WINNT >= 0x0501)

WINBASEAPI
BOOL
WINAPI
GetVolumePathNamesForVolumeNameA(
      LPCSTR lpszVolumeName,
    _Out_writes_to_opt_(cchBufferLength, *lpcchReturnLength) _Post_ _NullNull_terminated_ LPCH lpszVolumePathNames,
      DWORD cchBufferLength,
    _Out_ PDWORD lpcchReturnLength
    );

#ifndef UNICODE
#define GetVolumePathNamesForVolumeName  GetVolumePathNamesForVolumeNameA
#endif

#endif // (_WIN32_WINNT >= 0x0501)

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
#else
typedef ACTCTXA ACTCTX;
typedef PACTCTXA PACTCTX;
#endif // UNICODE

typedef const ACTCTXA *PCACTCTXA;
typedef const ACTCTXW *PCACTCTXW;
#ifdef UNICODE
typedef PCACTCTXW PCACTCTX;
#else
typedef PCACTCTXA PCACTCTX;
#endif // UNICODE



WINBASEAPI
HANDLE
WINAPI
CreateActCtxA(
     PCACTCTXA pActCtx
    );
WINBASEAPI
HANDLE
WINAPI
CreateActCtxW(
     PCACTCTXW pActCtx
    );
#ifdef UNICODE
#define CreateActCtx  CreateActCtxW
#else
#define CreateActCtx  CreateActCtxA
#endif // !UNICODE

WINBASEAPI
VOID
WINAPI
AddRefActCtx(
    _Inout_ HANDLE hActCtx
    );


WINBASEAPI
VOID
WINAPI
ReleaseActCtx(
    _Inout_ HANDLE hActCtx
    );

WINBASEAPI
BOOL
WINAPI
ZombifyActCtx(
    _Inout_ HANDLE hActCtx
    );


_Success_(return)
WINBASEAPI
BOOL
WINAPI
ActivateActCtx(
    _Inout_opt_ HANDLE hActCtx,
    _Out_   ULONG_PTR *lpCookie
    );


#define DEACTIVATE_ACTCTX_FLAG_FORCE_EARLY_DEACTIVATION (0x00000001)

_Success_(return)
WINBASEAPI
BOOL
WINAPI
DeactivateActCtx(
     DWORD dwFlags,
     ULONG_PTR ulCookie
    );

WINBASEAPI
BOOL
WINAPI
GetCurrentActCtx(
    _Outptr_ HANDLE *lphActCtx);


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
WINBASEAPI
BOOL
WINAPI
FindActCtxSectionStringA(
           DWORD dwFlags,
    _Reserved_ const GUID *lpExtensionGuid,
           ULONG ulSectionId,
           LPCSTR lpStringToFind,
    _Out_      PACTCTX_SECTION_KEYED_DATA ReturnedData
    );
_Success_(return)
WINBASEAPI
BOOL
WINAPI
FindActCtxSectionStringW(
           DWORD dwFlags,
    _Reserved_ const GUID *lpExtensionGuid,
           ULONG ulSectionId,
           LPCWSTR lpStringToFind,
    _Out_      PACTCTX_SECTION_KEYED_DATA ReturnedData
    );
#ifdef UNICODE
#define FindActCtxSectionString  FindActCtxSectionStringW
#else
#define FindActCtxSectionString  FindActCtxSectionStringA
#endif // !UNICODE

WINBASEAPI
BOOL
WINAPI
FindActCtxSectionGuid(
           DWORD dwFlags,
    _Reserved_ const GUID *lpExtensionGuid,
           ULONG ulSectionId,
       const GUID *lpGuidToFind,
    _Out_      PACTCTX_SECTION_KEYED_DATA ReturnedData
    );


#if !defined(RC_INVOKED) /* RC complains about long symbols in #ifs */
#if !defined(ACTIVATION_CONTEXT_BASIC_INFORMATION_DEFINED)

typedef struct _ACTIVATION_CONTEXT_BASIC_INFORMATION {
    HANDLE  hActCtx;
    DWORD   dwFlags;
} ACTIVATION_CONTEXT_BASIC_INFORMATION, *PACTIVATION_CONTEXT_BASIC_INFORMATION;

typedef const struct _ACTIVATION_CONTEXT_BASIC_INFORMATION *PCACTIVATION_CONTEXT_BASIC_INFORMATION;

#define ACTIVATION_CONTEXT_BASIC_INFORMATION_DEFINED 1

#endif // !defined(ACTIVATION_CONTEXT_BASIC_INFORMATION_DEFINED)
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
WINBASEAPI
BOOL
WINAPI
QueryActCtxW(
          DWORD dwFlags,
          HANDLE hActCtx,
      PVOID pvSubInstance,
          ULONG ulInfoClass,
    _Out_writes_bytes_to_opt_(cbBuffer, *pcbWrittenOrRequired) PVOID pvBuffer,
          SIZE_T cbBuffer,
    _Out_opt_ SIZE_T *pcbWrittenOrRequired
    );

typedef _Success_(return) BOOL (WINAPI * PQUERYACTCTXW_FUNC)(
          DWORD dwFlags,
          HANDLE hActCtx,
      PVOID pvSubInstance,
          ULONG ulInfoClass,
    _Out_writes_bytes_to_opt_(cbBuffer, *pcbWrittenOrRequired) PVOID pvBuffer,
          SIZE_T cbBuffer,
    _Out_opt_ SIZE_T *pcbWrittenOrRequired
    );

#endif // (_WIN32_WINNT > 0x0500) || (_WIN32_FUSION >= 0x0100) || ISOLATION_AWARE_ENABLED

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


#if _WIN32_WINNT >= 0x0501

WINBASEAPI
DWORD
WINAPI
WTSGetActiveConsoleSessionId(
    VOID
    );

#endif // (_WIN32_WINNT >= 0x0501)

#if (_WIN32_WINNT >= _WIN32_WINNT_WINTHRESHOLD)

WINBASEAPI
DWORD
WINAPI
WTSGetServiceSessionId(
    VOID
    );

WINBASEAPI
BOOLEAN
WINAPI
WTSIsServerContainer(
    VOID
    );

#endif // (_WIN32_WINNT >= _WIN32_WINNT_WINTHRESHOLD)

#if _WIN32_WINNT >= 0x0601

WINBASEAPI
WORD
WINAPI
GetActiveProcessorGroupCount(
    VOID
    );

WINBASEAPI
WORD
WINAPI
GetMaximumProcessorGroupCount(
    VOID
    );

WINBASEAPI
DWORD
WINAPI
GetActiveProcessorCount(
     WORD GroupNumber
    );

WINBASEAPI
DWORD
WINAPI
GetMaximumProcessorCount(
     WORD GroupNumber
    );

#endif // (_WIN32_WINNT >=0x0601)

//
// NUMA Information routines.
//

WINBASEAPI
BOOL
WINAPI
GetNumaProcessorNode(
      UCHAR Processor,
    _Out_ PUCHAR NodeNumber
    );

#if _WIN32_WINNT >= 0x0601

WINBASEAPI
BOOL
WINAPI
GetNumaNodeNumberFromHandle(
      HANDLE hFile,
    _Out_ PUSHORT NodeNumber
    );

#endif // (_WIN32_WINNT >=0x0601)

#if _WIN32_WINNT >= 0x0601

WINBASEAPI
BOOL
WINAPI
GetNumaProcessorNodeEx(
      PPROCESSOR_NUMBER Processor,
    _Out_ PUSHORT NodeNumber
    );

#endif // (_WIN32_WINNT >=0x0601)

WINBASEAPI
BOOL
WINAPI
GetNumaNodeProcessorMask(
      UCHAR Node,
    _Out_ PULONGLONG ProcessorMask
    );

WINBASEAPI
BOOL
WINAPI
GetNumaAvailableMemoryNode(
      UCHAR Node,
    _Out_ PULONGLONG AvailableBytes
    );

#if _WIN32_WINNT >= 0x0601

WINBASEAPI
BOOL
WINAPI
GetNumaAvailableMemoryNodeEx(
      USHORT Node,
    _Out_ PULONGLONG AvailableBytes
    );

#endif // (_WIN32_WINNT >=0x0601)

#if (_WIN32_WINNT >= 0x0600)

WINBASEAPI
BOOL
WINAPI
GetNumaProximityNode(
      ULONG ProximityId,
    _Out_ PUCHAR NodeNumber
    );

#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

//
// Application restart and data recovery callback
//
typedef DWORD (WINAPI *APPLICATION_RECOVERY_CALLBACK)(PVOID pvParameter);

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
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if (_WIN32_WINNT >= 0x0600)

WINBASEAPI
HRESULT
WINAPI
RegisterApplicationRecoveryCallback(
      APPLICATION_RECOVERY_CALLBACK pRecoveyCallback,
      PVOID pvParameter,
     DWORD dwPingInterval,
     DWORD dwFlags
    );

WINBASEAPI
HRESULT
WINAPI
UnregisterApplicationRecoveryCallback(void);

WINBASEAPI
HRESULT
WINAPI
RegisterApplicationRestart(
     PCWSTR pwzCommandline,
     DWORD dwFlags
    );

WINBASEAPI
HRESULT
WINAPI
UnregisterApplicationRestart(void);

#endif // _WIN32_WINNT >= 0x0600

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

#if (_WIN32_WINNT >= 0x0600)

WINBASEAPI
HRESULT
WINAPI
GetApplicationRecoveryCallback(
      HANDLE hProcess,
    _Out_ APPLICATION_RECOVERY_CALLBACK* pRecoveryCallback,
    _Outptr_opt_result_maybenull_ PVOID* ppvParameter,
    _Out_opt_ PDWORD pdwPingInterval,
    _Out_opt_ PDWORD pdwFlags
    );

WINBASEAPI
HRESULT
WINAPI
GetApplicationRestartSettings(
     HANDLE hProcess,
    _Out_writes_opt_(*pcchSize) PWSTR pwzCommandline,
    _Inout_ PDWORD pcchSize,
    _Out_opt_ PDWORD pdwFlags
    );

#endif // _WIN32_WINNT >= 0x0600

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if (_WIN32_WINNT >= 0x0600)

WINBASEAPI
HRESULT
WINAPI
ApplicationRecoveryInProgress(
    _Out_ PBOOL pbCancelled
    );

WINBASEAPI
VOID
WINAPI
ApplicationRecoveryFinished(
     BOOL bSuccess
    );

#endif // _WIN32_WINNT >= 0x0600

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#if (_WIN32_WINNT >= 0x0600)

#pragma region Application Family or OneCore Family
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
#else
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

WINBASEAPI
BOOL
WINAPI
GetFileInformationByHandleEx(
      HANDLE hFile,
      FILE_INFO_BY_HANDLE_CLASS FileInformationClass,
    _Out_writes_bytes_(dwBufferSize) LPVOID lpFileInformation,
      DWORD dwBufferSize
);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
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

WINBASEAPI
HANDLE
WINAPI
OpenFileById (
         HANDLE hVolumeHint,
         LPFILE_ID_DESCRIPTOR lpFileId,
         DWORD dwDesiredAccess,
         DWORD dwShareMode,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes,
         DWORD dwFlagsAndAttributes
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#endif

#pragma region Desktop Family or OneCore Family
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


WINBASEAPI
BOOLEAN
APIENTRY
CreateSymbolicLinkA (
     LPCSTR lpSymlinkFileName,
     LPCSTR lpTargetFileName,
     DWORD dwFlags
    );
WINBASEAPI
BOOLEAN
APIENTRY
CreateSymbolicLinkW (
     LPCWSTR lpSymlinkFileName,
     LPCWSTR lpTargetFileName,
     DWORD dwFlags
    );
#ifdef UNICODE
#define CreateSymbolicLink  CreateSymbolicLinkW
#else
#define CreateSymbolicLink  CreateSymbolicLinkA
#endif // !UNICODE

#endif // (_WIN32_WINNT >= 0x0600)

#if (_WIN32_WINNT >= 0x0600)

WINBASEAPI
BOOL
WINAPI
QueryActCtxSettingsW(
          DWORD dwFlags,
          HANDLE hActCtx,
          PCWSTR settingsNameSpace,
              PCWSTR settingName,
    _Out_writes_bytes_to_opt_(dwBuffer, *pdwWrittenOrRequired) PWSTR pvBuffer,
          SIZE_T dwBuffer,
    _Out_opt_ SIZE_T *pdwWrittenOrRequired
    );

#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if (_WIN32_WINNT >= 0x0600)

WINBASEAPI
BOOLEAN
APIENTRY
CreateSymbolicLinkTransactedA (
         LPCSTR lpSymlinkFileName,
         LPCSTR lpTargetFileName,
         DWORD dwFlags,
         HANDLE hTransaction
    );
WINBASEAPI
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
#else
#define CreateSymbolicLinkTransacted  CreateSymbolicLinkTransactedA
#endif // !UNICODE

#endif // (_WIN32_WINNT >= 0x0600)

#if (_WIN32_WINNT >= 0x0600)

WINBASEAPI
BOOL
WINAPI
ReplacePartitionUnit (
     PWSTR TargetPartition,
     PWSTR SparePartition,
     ULONG Flags
    );

#endif


#if (_WIN32_WINNT >= 0x0600)

WINBASEAPI
BOOL
WINAPI
AddSecureMemoryCacheCallback(
     __callback PSECURE_MEMORY_CACHE_CALLBACK pfnCallBack
    );

WINBASEAPI
BOOL
WINAPI
RemoveSecureMemoryCacheCallback(
     __callback PSECURE_MEMORY_CACHE_CALLBACK pfnCallBack
    );

#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#if (NTDDI_VERSION >= NTDDI_WIN7SP1)

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

_Must_inspect_result_
WINBASEAPI
BOOL
WINAPI
CopyContext(
    _Inout_ PCONTEXT Destination,
     DWORD ContextFlags,
     PCONTEXT Source
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

_Success_(return != FALSE)
WINBASEAPI
BOOL
WINAPI
InitializeContext(
    _Out_writes_bytes_opt_(*ContextLength) PVOID Buffer,
     DWORD ContextFlags,
    _Out_ PCONTEXT* Context,
    _Inout_ PDWORD ContextLength
    );
#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#if defined(_AMD64_) || defined(_X86_)

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
DWORD64
WINAPI
GetEnabledXStateFeatures(
    VOID
    );

_Must_inspect_result_
WINBASEAPI
BOOL
WINAPI
GetXStateFeaturesMask(
     PCONTEXT Context,
    _Out_ PDWORD64 FeatureMask
    );

_Success_(return != NULL)
WINBASEAPI
PVOID
WINAPI
LocateXStateFeature(
     PCONTEXT Context,
     DWORD FeatureId,
    _Out_opt_ PDWORD Length
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

_Must_inspect_result_
WINBASEAPI
BOOL
WINAPI
SetXStateFeaturesMask(
    _Inout_ PCONTEXT Context,
     DWORD64 FeatureMask
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#endif /* defined(_AMD64_) || defined(_X86_) */

#endif /* (NTDDI_VERSION >= NTDDI_WIN7SP1) */

#if (_WIN32_WINNT >= 0x0601)

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

WINBASEAPI
DWORD
APIENTRY
EnableThreadProfiling(
     HANDLE ThreadHandle,
     DWORD Flags,
     DWORD64 HardwareCounters,
    _Out_ HANDLE *PerformanceDataHandle
    );

WINBASEAPI
DWORD
APIENTRY
DisableThreadProfiling(
     HANDLE PerformanceDataHandle
    );

WINBASEAPI
DWORD
APIENTRY
QueryThreadProfiling(
     HANDLE ThreadHandle,
    _Out_ PBOOLEAN Enabled
    );

WINBASEAPI
DWORD
APIENTRY
ReadThreadProfilingData(
     HANDLE PerformanceDataHandle,
     DWORD Flags,
    _Out_ PPERFORMANCE_DATA PerformanceData
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* (_WIN32_WINNT >= 0x0601) */

#if (NTDDI_VERSION >= NTDDI_WIN10_RS4)

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

WINBASEAPI
DWORD
WINAPI
RaiseCustomSystemEventTrigger(
     PCUSTOM_SYSTEM_EVENT_TRIGGER_CONFIG CustomSystemEventTriggerConfig
    );

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#endif /* (NTDDI_VERSION >= NTDDI_WIN10_RS4) */



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
#else
#pragma warning(default:4001) /* nonstandard extension : single line comment */
#pragma warning(default:4201) /* nonstandard extension used : nameless struct/union */
#pragma warning(default:4214) /* nonstandard extension used : bit field types other then int */
#endif
#endif



#endif // _WINBASE_

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
    _Inout_ _Interlocked_operand_ unsigned volatile *Addend
    )
{
    return (unsigned) _InterlockedIncrement((volatile long*) Addend);
}

FORCEINLINE
unsigned long
InterlockedIncrement(
    _Inout_ _Interlocked_operand_ unsigned long volatile *Addend
    )
{
    return (unsigned long) _InterlockedIncrement((volatile long*) Addend);
}

// ARM64_WORKAROUND : should this work for managed code?
#if (defined(_WIN64) && !defined(_ARM64_)) || ((_WIN32_WINNT >= 0x0502) && defined(_WINBASE_) && !defined(_MANAGED))

FORCEINLINE
unsigned __int64
InterlockedIncrement(
    _Inout_ _Interlocked_operand_ unsigned __int64 volatile *Addend
    )
{
    return (unsigned __int64) (InterlockedIncrement64)((volatile __int64*) Addend);
}

#endif

FORCEINLINE
unsigned
InterlockedDecrement(
    _Inout_ _Interlocked_operand_ unsigned volatile *Addend
    )
{
    return (unsigned long) _InterlockedDecrement((volatile long*) Addend);
}

FORCEINLINE
unsigned long
InterlockedDecrement(
    _Inout_ _Interlocked_operand_ unsigned long volatile *Addend
    )
{
    return (unsigned long) _InterlockedDecrement((volatile long*) Addend);
}

// ARM64_WORKAROUND : should this work for managed code?
#if (defined(_WIN64) && !defined(_ARM64_)) || ((_WIN32_WINNT >= 0x0502) && defined(_WINBASE_) && !defined(_MANAGED))

FORCEINLINE
unsigned __int64
InterlockedDecrement(
    _Inout_ _Interlocked_operand_ unsigned __int64 volatile *Addend
    )
{
    return (unsigned __int64) (InterlockedDecrement64)((volatile __int64*) Addend);
}

#endif

#if !defined(_M_CEE_PURE)

FORCEINLINE
unsigned
InterlockedExchange(
    _Inout_ _Interlocked_operand_ unsigned volatile *Target,
     unsigned Value
    )
{
    return (unsigned) _InterlockedExchange((volatile long*) Target, (long) Value);
}

FORCEINLINE
unsigned long
InterlockedExchange(
    _Inout_ _Interlocked_operand_ unsigned long volatile *Target,
     unsigned long Value
    )
{
    return (unsigned long) _InterlockedExchange((volatile long*) Target, (long) Value);
}

#if defined(_WIN64) || ((_WIN32_WINNT >= 0x0502) && defined(_WINBASE_) && !defined(_MANAGED))

FORCEINLINE
unsigned __int64
InterlockedExchange(
    _Inout_ _Interlocked_operand_ unsigned __int64 volatile *Target,
     unsigned __int64 Value
    )
{
    return (unsigned __int64) InterlockedExchange64((volatile __int64*) Target, (__int64) Value);
}

#endif

FORCEINLINE
unsigned
InterlockedExchangeAdd(
    _Inout_ _Interlocked_operand_ unsigned volatile *Addend,
     unsigned Value
    )
{
    return (unsigned) _InterlockedExchangeAdd((volatile long*) Addend, (long) Value);
}

FORCEINLINE
unsigned
InterlockedExchangeSubtract(
    _Inout_ _Interlocked_operand_ unsigned volatile *Addend,
     unsigned Value
    )
{
    return (unsigned) _InterlockedExchangeAdd((volatile long*) Addend,  - (long) Value);
}

FORCEINLINE
unsigned long
InterlockedExchangeAdd(
    _Inout_ _Interlocked_operand_ unsigned long volatile *Addend,
     unsigned long Value
    )
{
    return (unsigned long) _InterlockedExchangeAdd((volatile long*) Addend, (long) Value);
}

FORCEINLINE
unsigned long
InterlockedExchangeSubtract(
    _Inout_ _Interlocked_operand_ unsigned long volatile *Addend,
     unsigned long Value
    )
{
    return (unsigned long) _InterlockedExchangeAdd((volatile long*) Addend,  - (long) Value);
}

#if defined(_WIN64) || ((_WIN32_WINNT >= 0x0502) && defined(_WINBASE_) && !defined(_MANAGED))

FORCEINLINE
unsigned __int64
InterlockedExchangeAdd(
    _Inout_ _Interlocked_operand_ unsigned __int64 volatile *Addend,
     unsigned __int64 Value
    )
{
    return (unsigned __int64) InterlockedExchangeAdd64((volatile __int64*) Addend,  (__int64) Value);
}

FORCEINLINE
unsigned __int64
InterlockedExchangeSubtract(
    _Inout_ _Interlocked_operand_ unsigned __int64 volatile *Addend,
     unsigned __int64 Value
    )
{
    return (unsigned __int64) InterlockedExchangeAdd64((volatile __int64*) Addend,  - (__int64) Value);
}

#endif

FORCEINLINE
unsigned
InterlockedCompareExchange(
    _Inout_ _Interlocked_operand_ unsigned volatile *Destination,
     unsigned Exchange,
     unsigned Comperand
    )
{
    return (unsigned) _InterlockedCompareExchange((volatile long*) Destination, (long) Exchange, (long) Comperand);
}

FORCEINLINE
unsigned long
InterlockedCompareExchange(
    _Inout_ _Interlocked_operand_ unsigned long volatile *Destination,
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
    _Inout_ _Interlocked_operand_ unsigned __int64 volatile *Destination,
     unsigned __int64 Exchange,
     unsigned __int64 Comperand
    )
{
    return (unsigned __int64) _InterlockedCompareExchange64((volatile __int64*) Destination, (__int64) Exchange, (__int64) Comperand);
}

FORCEINLINE
unsigned __int64
InterlockedAnd(
    _Inout_ _Interlocked_operand_ unsigned __int64 volatile *Destination,
     unsigned __int64 Value
    )
{
    return (unsigned __int64) InterlockedAnd64((volatile __int64*) Destination, (__int64) Value);
}

FORCEINLINE
unsigned __int64
InterlockedOr(
    _Inout_ _Interlocked_operand_ unsigned __int64 volatile *Destination,
     unsigned __int64 Value
    )
{
    return (unsigned __int64) InterlockedOr64((volatile __int64*) Destination, (__int64) Value);
}

FORCEINLINE
unsigned __int64
InterlockedXor(
    _Inout_ _Interlocked_operand_ unsigned __int64 volatile *Destination,
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