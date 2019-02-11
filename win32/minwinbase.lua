
local ffi = require("ffi")

--local exports = {}

--[[
//
// Constants
//
#define MoveMemory RtlMoveMemory
#define CopyMemory RtlCopyMemory
#define FillMemory RtlFillMemory
#define ZeroMemory RtlZeroMemory
--]]

if not _SECURITY_ATTRIBUTES_ then
_SECURITY_ATTRIBUTES_ = true
ffi.cdef[[
typedef struct _SECURITY_ATTRIBUTES {
    DWORD nLength;
    LPVOID lpSecurityDescriptor;
    BOOL bInheritHandle;
} SECURITY_ATTRIBUTES, *PSECURITY_ATTRIBUTES, *LPSECURITY_ATTRIBUTES;
]]
end

ffi.cdef[[
typedef struct _OVERLAPPED {
    ULONG_PTR Internal;
    ULONG_PTR InternalHigh;
    union {
        struct {
            DWORD Offset;
            DWORD OffsetHigh;
        } ;
        PVOID Pointer;
    } ;

    HANDLE  hEvent;
} OVERLAPPED, *LPOVERLAPPED;

typedef struct _OVERLAPPED_ENTRY {
    ULONG_PTR lpCompletionKey;
    LPOVERLAPPED lpOverlapped;
    ULONG_PTR Internal;
    DWORD dwNumberOfBytesTransferred;
} OVERLAPPED_ENTRY, *LPOVERLAPPED_ENTRY;
]]


if not _FILETIME_ then
_FILETIME_ = true

ffi.cdef[[
typedef struct _FILETIME {
    DWORD dwLowDateTime;
    DWORD dwHighDateTime;
} FILETIME, *PFILETIME, *LPFILETIME;
]]
end

if not _SYSTEMTIME_ then
_SYSTEMTIME_ = true;
ffi.cdef[[
typedef struct _SYSTEMTIME {
    WORD wYear;
    WORD wMonth;
    WORD wDayOfWeek;
    WORD wDay;
    WORD wHour;
    WORD wMinute;
    WORD wSecond;
    WORD wMilliseconds;
} SYSTEMTIME, *PSYSTEMTIME, *LPSYSTEMTIME;
]]
end


ffi.cdef[[
typedef struct _WIN32_FIND_DATAA {
    DWORD dwFileAttributes;
    FILETIME ftCreationTime;
    FILETIME ftLastAccessTime;
    FILETIME ftLastWriteTime;
    DWORD nFileSizeHigh;
    DWORD nFileSizeLow;
    DWORD dwReserved0;
    DWORD dwReserved1;
    CHAR   cFileName[ MAX_PATH ];
    CHAR   cAlternateFileName[ 14 ];
/*
#ifdef _MAC
    DWORD dwFileType;
    DWORD dwCreatorType;
    WORD  wFinderFlags;
#endif
*/
} WIN32_FIND_DATAA, *PWIN32_FIND_DATAA, *LPWIN32_FIND_DATAA;

typedef struct _WIN32_FIND_DATAW {
    DWORD dwFileAttributes;
    FILETIME ftCreationTime;
    FILETIME ftLastAccessTime;
    FILETIME ftLastWriteTime;
    DWORD nFileSizeHigh;
    DWORD nFileSizeLow;
    DWORD dwReserved0;
    DWORD dwReserved1;
    WCHAR  cFileName[ MAX_PATH ];
    WCHAR  cAlternateFileName[ 14 ];
/*
#ifdef _MAC
    DWORD dwFileType;
    DWORD dwCreatorType;
    WORD  wFinderFlags;
#endif
*/
} WIN32_FIND_DATAW, *PWIN32_FIND_DATAW, *LPWIN32_FIND_DATAW;
]]


if UNICODE then
ffi.cdef[[
typedef WIN32_FIND_DATAW WIN32_FIND_DATA;
typedef PWIN32_FIND_DATAW PWIN32_FIND_DATA;
typedef LPWIN32_FIND_DATAW LPWIN32_FIND_DATA;
]]
else
ffi.cdef[[
typedef WIN32_FIND_DATAA WIN32_FIND_DATA;
typedef PWIN32_FIND_DATAA PWIN32_FIND_DATA;
typedef LPWIN32_FIND_DATAA LPWIN32_FIND_DATA;
]]
end -- UNICODE


ffi.cdef[[
typedef enum _FINDEX_INFO_LEVELS {
    FindExInfoStandard,
    FindExInfoBasic,
    FindExInfoMaxInfoLevel
} FINDEX_INFO_LEVELS;

static const int FIND_FIRST_EX_CASE_SENSITIVE   = 0x00000001;
static const int FIND_FIRST_EX_LARGE_FETCH      = 0x00000002;

typedef enum _FINDEX_SEARCH_OPS {
    FindExSearchNameMatch,
    FindExSearchLimitToDirectories,
    FindExSearchLimitToDevices,
    FindExSearchMaxSearchOp
} FINDEX_SEARCH_OPS;

typedef enum _GET_FILEEX_INFO_LEVELS {
    GetFileExInfoStandard,
    GetFileExMaxInfoLevel
} GET_FILEEX_INFO_LEVELS;
]]


ffi.cdef[[
typedef enum _FILE_INFO_BY_HANDLE_CLASS {
    FileBasicInfo,
    FileStandardInfo,
    FileNameInfo,
    FileRenameInfo,
    FileDispositionInfo,
    FileAllocationInfo,
    FileEndOfFileInfo,
    FileStreamInfo,
    FileCompressionInfo,
    FileAttributeTagInfo,
    FileIdBothDirectoryInfo,
    FileIdBothDirectoryRestartInfo,
    FileIoPriorityHintInfo,
    FileRemoteProtocolInfo,
    FileFullDirectoryInfo,
    FileFullDirectoryRestartInfo,
    FileStorageInfo,
    FileAlignmentInfo,
    FileIdInfo,
    FileIdExtdDirectoryInfo,
    FileIdExtdDirectoryRestartInfo,
    FileDispositionInfoEx,
    FileRenameInfoEx,
    MaximumFileInfoByHandleClass
} FILE_INFO_BY_HANDLE_CLASS, *PFILE_INFO_BY_HANDLE_CLASS;
]]

ffi.cdef[[
typedef RTL_CRITICAL_SECTION CRITICAL_SECTION;
typedef PRTL_CRITICAL_SECTION PCRITICAL_SECTION;
typedef PRTL_CRITICAL_SECTION LPCRITICAL_SECTION;

typedef RTL_CRITICAL_SECTION_DEBUG CRITICAL_SECTION_DEBUG;
typedef PRTL_CRITICAL_SECTION_DEBUG PCRITICAL_SECTION_DEBUG;
typedef PRTL_CRITICAL_SECTION_DEBUG LPCRITICAL_SECTION_DEBUG;
]]


ffi.cdef[[
typedef void
(__stdcall *LPOVERLAPPED_COMPLETION_ROUTINE)(
        DWORD dwErrorCode,
        DWORD dwNumberOfBytesTransfered,
     LPOVERLAPPED lpOverlapped
    );
]]

ffi.cdef[[
static const int LOCKFILE_FAIL_IMMEDIATELY  = 0x00000001;
static const int LOCKFILE_EXCLUSIVE_LOCK    = 0x00000002;
]]

ffi.cdef[[
typedef struct _PROCESS_HEAP_ENTRY {
    PVOID lpData;
    DWORD cbData;
    BYTE cbOverhead;
    BYTE iRegionIndex;
    WORD wFlags;
    union {
        struct {
            HANDLE hMem;
            DWORD dwReserved[ 3 ];
        } Block;
        struct {
            DWORD dwCommittedSize;
            DWORD dwUnCommittedSize;
            LPVOID lpFirstBlock;
            LPVOID lpLastBlock;
        } Region;
    } ;
} PROCESS_HEAP_ENTRY, *LPPROCESS_HEAP_ENTRY, *PPROCESS_HEAP_ENTRY;
]]

ffi.cdef[[
static const int PROCESS_HEAP_REGION            = 0x0001;
static const int PROCESS_HEAP_UNCOMMITTED_RANGE = 0x0002;
static const int PROCESS_HEAP_ENTRY_BUSY        = 0x0004;
static const int PROCESS_HEAP_SEG_ALLOC         = 0x0008;
static const int PROCESS_HEAP_ENTRY_MOVEABLE    = 0x0010;
static const int PROCESS_HEAP_ENTRY_DDESHARE    = 0x0020;
]]

ffi.cdef[[
typedef struct _REASON_CONTEXT {
    ULONG Version;
    DWORD Flags;
    union {
        struct {
            HMODULE LocalizedReasonModule;
            ULONG LocalizedReasonId;
            ULONG ReasonStringCount;
            LPWSTR *ReasonStrings;

        } Detailed;

        LPWSTR SimpleReasonString;
    } Reason;
} REASON_CONTEXT, *PREASON_CONTEXT;
]]

--[[
//
// Debug APIs
//
#define EXCEPTION_DEBUG_EVENT       1
#define CREATE_THREAD_DEBUG_EVENT   2
#define CREATE_PROCESS_DEBUG_EVENT  3
#define EXIT_THREAD_DEBUG_EVENT     4
#define EXIT_PROCESS_DEBUG_EVENT    5
#define LOAD_DLL_DEBUG_EVENT        6
#define UNLOAD_DLL_DEBUG_EVENT      7
#define OUTPUT_DEBUG_STRING_EVENT   8
#define RIP_EVENT                   9
--]]

ffi.cdef[[
typedef DWORD (__stdcall *PTHREAD_START_ROUTINE)(
    LPVOID lpThreadParameter
    );
typedef PTHREAD_START_ROUTINE LPTHREAD_START_ROUTINE;
]]

ffi.cdef[[
typedef struct _EXCEPTION_DEBUG_INFO {
    EXCEPTION_RECORD ExceptionRecord;
    DWORD dwFirstChance;
} EXCEPTION_DEBUG_INFO, *LPEXCEPTION_DEBUG_INFO;

typedef struct _CREATE_THREAD_DEBUG_INFO {
    HANDLE hThread;
    LPVOID lpThreadLocalBase;
    LPTHREAD_START_ROUTINE lpStartAddress;
} CREATE_THREAD_DEBUG_INFO, *LPCREATE_THREAD_DEBUG_INFO;

typedef struct _CREATE_PROCESS_DEBUG_INFO {
    HANDLE hFile;
    HANDLE hProcess;
    HANDLE hThread;
    LPVOID lpBaseOfImage;
    DWORD dwDebugInfoFileOffset;
    DWORD nDebugInfoSize;
    LPVOID lpThreadLocalBase;
    LPTHREAD_START_ROUTINE lpStartAddress;
    LPVOID lpImageName;
    WORD fUnicode;
} CREATE_PROCESS_DEBUG_INFO, *LPCREATE_PROCESS_DEBUG_INFO;
]]

ffi.cdef[[
typedef struct _EXIT_THREAD_DEBUG_INFO {
    DWORD dwExitCode;
} EXIT_THREAD_DEBUG_INFO, *LPEXIT_THREAD_DEBUG_INFO;
]]

ffi.cdef[[
typedef struct _EXIT_PROCESS_DEBUG_INFO {
    DWORD dwExitCode;
} EXIT_PROCESS_DEBUG_INFO, *LPEXIT_PROCESS_DEBUG_INFO;
]]

ffi.cdef[[
typedef struct _LOAD_DLL_DEBUG_INFO {
    HANDLE hFile;
    LPVOID lpBaseOfDll;
    DWORD dwDebugInfoFileOffset;
    DWORD nDebugInfoSize;
    LPVOID lpImageName;
    WORD fUnicode;
} LOAD_DLL_DEBUG_INFO, *LPLOAD_DLL_DEBUG_INFO;
]]

ffi.cdef[[
typedef struct _UNLOAD_DLL_DEBUG_INFO {
    LPVOID lpBaseOfDll;
} UNLOAD_DLL_DEBUG_INFO, *LPUNLOAD_DLL_DEBUG_INFO;
]]

ffi.cdef[[
typedef struct _OUTPUT_DEBUG_STRING_INFO {
    LPSTR lpDebugStringData;
    WORD fUnicode;
    WORD nDebugStringLength;
} OUTPUT_DEBUG_STRING_INFO, *LPOUTPUT_DEBUG_STRING_INFO;
]]

ffi.cdef[[
typedef struct _RIP_INFO {
    DWORD dwError;
    DWORD dwType;
} RIP_INFO, *LPRIP_INFO;
]]

ffi.cdef[[
typedef struct _DEBUG_EVENT {
    DWORD dwDebugEventCode;
    DWORD dwProcessId;
    DWORD dwThreadId;
    union {
        EXCEPTION_DEBUG_INFO Exception;
        CREATE_THREAD_DEBUG_INFO CreateThread;
        CREATE_PROCESS_DEBUG_INFO CreateProcessInfo;
        EXIT_THREAD_DEBUG_INFO ExitThread;
        EXIT_PROCESS_DEBUG_INFO ExitProcess;
        LOAD_DLL_DEBUG_INFO LoadDll;
        UNLOAD_DLL_DEBUG_INFO UnloadDll;
        OUTPUT_DEBUG_STRING_INFO DebugString;
        RIP_INFO RipInfo;
    } u;
} DEBUG_EVENT, *LPDEBUG_EVENT;
]]

ffi.cdef[[
//
// Context definitions
//

typedef PCONTEXT LPCONTEXT;
]]

--[==[
ffi.cdef[[
/* compatibility macros */
static const int STILL_ACTIVE                      =  STATUS_PENDING;
static const int EXCEPTION_ACCESS_VIOLATION        =  STATUS_ACCESS_VIOLATION;
static const int EXCEPTION_DATATYPE_MISALIGNMENT   =  STATUS_DATATYPE_MISALIGNMENT;
static const int EXCEPTION_BREAKPOINT              =  STATUS_BREAKPOINT;
static const int EXCEPTION_SINGLE_STEP             =  STATUS_SINGLE_STEP;
static const int EXCEPTION_ARRAY_BOUNDS_EXCEEDED   =  STATUS_ARRAY_BOUNDS_EXCEEDED;
static const int EXCEPTION_FLT_DENORMAL_OPERAND    =  STATUS_FLOAT_DENORMAL_OPERAND;
static const int EXCEPTION_FLT_DIVIDE_BY_ZERO      =  STATUS_FLOAT_DIVIDE_BY_ZERO;
static const int EXCEPTION_FLT_INEXACT_RESULT      =  STATUS_FLOAT_INEXACT_RESULT;
static const int EXCEPTION_FLT_INVALID_OPERATION   =  STATUS_FLOAT_INVALID_OPERATION;
static const int EXCEPTION_FLT_OVERFLOW            =  STATUS_FLOAT_OVERFLOW;
static const int EXCEPTION_FLT_STACK_CHECK         =  STATUS_FLOAT_STACK_CHECK;
static const int EXCEPTION_FLT_UNDERFLOW           =  STATUS_FLOAT_UNDERFLOW;
static const int EXCEPTION_INT_DIVIDE_BY_ZERO      =  STATUS_INTEGER_DIVIDE_BY_ZERO;
static const int EXCEPTION_INT_OVERFLOW            =  STATUS_INTEGER_OVERFLOW;
static const int EXCEPTION_PRIV_INSTRUCTION        =  STATUS_PRIVILEGED_INSTRUCTION;
static const int EXCEPTION_IN_PAGE_ERROR           =  STATUS_IN_PAGE_ERROR;
static const int EXCEPTION_ILLEGAL_INSTRUCTION     =  STATUS_ILLEGAL_INSTRUCTION;
static const int EXCEPTION_NONCONTINUABLE_EXCEPTION=  STATUS_NONCONTINUABLE_EXCEPTION;
static const int EXCEPTION_STACK_OVERFLOW          =  STATUS_STACK_OVERFLOW;
static const int EXCEPTION_INVALID_DISPOSITION     =  STATUS_INVALID_DISPOSITION;
static const int EXCEPTION_GUARD_PAGE              =  STATUS_GUARD_PAGE_VIOLATION;
static const int EXCEPTION_INVALID_HANDLE          =  STATUS_INVALID_HANDLE;
static const int EXCEPTION_POSSIBLE_DEADLOCK       =  STATUS_POSSIBLE_DEADLOCK;
static const int CONTROL_C_EXIT                    =  STATUS_CONTROL_C_EXIT;
]]
--]==]


ffi.cdef[[
/* Local Memory Flags */
static const int LMEM_FIXED         = 0x0000;
static const int LMEM_MOVEABLE      = 0x0002;
static const int LMEM_NOCOMPACT     = 0x0010;
static const int LMEM_NODISCARD     = 0x0020;
static const int LMEM_ZEROINIT      = 0x0040;
static const int LMEM_MODIFY        = 0x0080;
static const int LMEM_DISCARDABLE   = 0x0F00;
static const int LMEM_VALID_FLAGS   = 0x0F72;
static const int LMEM_INVALID_HANDLE= 0x8000;

static const int LHND               = (LMEM_MOVEABLE | LMEM_ZEROINIT);
static const int LPTR               = (LMEM_FIXED | LMEM_ZEROINIT);

static const int NONZEROLHND        = (LMEM_MOVEABLE);
static const int NONZEROLPTR        = (LMEM_FIXED);
]]

--[[
function exports.LocalDiscard( h )   
    ffi.C.LocalReAlloc( (h), 0, ffi.C.LMEM_MOVEABLE )
end
--]]

ffi.cdef[[
/* Flags returned by LocalFlags (in addition to LMEM_DISCARDABLE) */
static const int LMEM_DISCARDED     = 0x4000;
static const int LMEM_LOCKCOUNT     = 0x00FF;
]]
