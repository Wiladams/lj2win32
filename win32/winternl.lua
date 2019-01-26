--[[
/************************************************************************
*                                                                       *
*   winternl.h -- This module defines the internal NT APIs and data     *
*       structures that are intended for the use only by internal core  *
*       Windows components.  These APIs and data structures may change  *
*       at any time.                                                    *
*                                                                       *
*   These APIs and data structures are subject to changes from one      *
*       Windows release to another Windows release.  To maintain the    *
*       compatiblity of your application, avoid using these APIs and    *
*       data structures.                                                *
*                                                                       *
*   The appropriate mechanism for accessing the functions defined in    *
*       this header is to use LoadLibrary() for ntdll.dll and           *
*       GetProcAddress() for the particular function.  By using this    *
*       approach, your application will be more resilient to changes    *
*       for these functions between Windows releases.  If a function    *
*       prototype does change, then GetProcAddress() for that function  *
*       might detect the change and fail the function call, which your  *
*       application will be able to detect.  GetProcAddress() may not   *
*       be able to detect all signature changes, thus avoid using these *
*       internal functions.  Instead, your application should use the   *
*       appropriate Win32 function that provides equivalent or similiar *
*       functionality.                                                  *
*                                                                       *
*   Copyright (c) Microsoft Corp. All rights reserved.                  *
*                                                                       *
************************************************************************/
--]]

local ffi = require("ffi")
local C = ffi.C 

if not _WINTERNL_ then
_WINTERNL_ = true

require("win32.winapifamily")


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


if (_WIN32_WINNT >= 0x0500) then

require ("win32.windef")



ffi.cdef[[
//
// These data structures and type definitions are needed for compilation and
// use of the internal Windows APIs defined in this header.
//
typedef LONG NTSTATUS;

typedef const char *PCSZ;

typedef struct _STRING {
    USHORT Length;
    USHORT MaximumLength;
    PCHAR Buffer;
} STRING;
typedef STRING *PSTRING;

typedef STRING ANSI_STRING;
typedef PSTRING PANSI_STRING;
typedef PSTRING PCANSI_STRING;

typedef STRING OEM_STRING;
typedef PSTRING POEM_STRING;
typedef const STRING* PCOEM_STRING;

typedef struct _UNICODE_STRING {
    USHORT Length;
    USHORT MaximumLength;
    PWSTR  Buffer;
} UNICODE_STRING;
typedef UNICODE_STRING *PUNICODE_STRING;
typedef const UNICODE_STRING *PCUNICODE_STRING;

typedef LONG KPRIORITY;

typedef struct _CLIENT_ID {
    HANDLE UniqueProcess;
    HANDLE UniqueThread;
} CLIENT_ID;
]]

--[[
//
// The PEB_LDR_DATA, LDR_DATA_TABLE_ENTRY, RTL_USER_PROCESS_PARAMETERS, PEB
// and TEB structures are subject to changes between Windows releases; thus,
// the field offsets and reserved fields may change. The reserved fields are
// reserved for use only by the Windows operating systems. Do not assume a
// maximum size for these structures.
//
// Instead of using the InMemoryOrderModuleList field of the
//     LDR_DATA_TABLE_ENTRY structure, use the Win32 API EnumProcessModules
//
// Instead of using the IsBeingDebugged field of the PEB structure, use the
//     Win32 APIs IsDebuggerPresent or CheckRemoteDebuggerPresent
//
// Instead of using the SessionId field of the PEB structure, use the Win32
//     APIs GetCurrentProcessId and ProcessIdToSessionId
//
// Instead of using the Tls fields of the TEB structure, use the Win32 APIs
//     TlsAlloc, TlsGetValue, TlsSetValue and TlsFree
//
// Instead of using the ReservedForOle field, use the COM API
//     CoGetContextToken
//
// Sample x86 assembly code that gets the SessionId (subject to change
//     between Windows releases, use the Win32 APIs to make your application
//     resilient to changes)
//     mov     eax,fs:[00000018]
//     mov     eax,[eax+0x30]
//     mov     eax,[eax+0x1d4]
//

//
// N.B. Fields marked as reserved do not necessarily reflect the structure
//      of the real struct. They may simply guarantee that the offets of
//      the exposed fields are correct. When code matches this pattern,
//
//          TYPE1 ExposedField1;
//          BYTE ReservedBytes[b];
//          PVOID ReservedPtrs[p];
//          TYPE2 ExposedField2;
//
//      or that pattern with ReservedBytes and ReservedPtrs swapped, it is
//      likely that 'b' and 'p' are derived from the following system:
//
//          GapThirtyTwo = 4p + b
//          GapSixtyFour = 8p + b
//
//      where GapThirtyTwo is the number of bytes between the two exposed
//      fields in the 32-bit version of the real struct and GapSixtyFour
//      is the number of bytes between the two exposed fields in the 64-bit
//      version of the real struct.
//
//      Also note that such code must take into account the alignment of
//      the ReservedPtrs field.
//
--]]

ffi.cdef[[
typedef struct _PEB_LDR_DATA {
    BYTE Reserved1[8];
    PVOID Reserved2[3];
    LIST_ENTRY InMemoryOrderModuleList;
} PEB_LDR_DATA, *PPEB_LDR_DATA;

typedef struct _LDR_DATA_TABLE_ENTRY {
    PVOID Reserved1[2];
    LIST_ENTRY InMemoryOrderLinks;
    PVOID Reserved2[2];
    PVOID DllBase;
    PVOID Reserved3[2];
    UNICODE_STRING FullDllName;
    BYTE Reserved4[8];
    PVOID Reserved5[3];

    union {
        ULONG CheckSum;
        PVOID Reserved6;
    } ;

    ULONG TimeDateStamp;
} LDR_DATA_TABLE_ENTRY, *PLDR_DATA_TABLE_ENTRY;

typedef struct _RTL_USER_PROCESS_PARAMETERS {
    BYTE Reserved1[16];
    PVOID Reserved2[10];
    UNICODE_STRING ImagePathName;
    UNICODE_STRING CommandLine;
} RTL_USER_PROCESS_PARAMETERS, *PRTL_USER_PROCESS_PARAMETERS;
]]

ffi.cdef[[
typedef
void
(__stdcall *PPS_POST_PROCESS_INIT_ROUTINE) (
    void
    );
]]

ffi.cdef[[
typedef struct _PEB {
    BYTE Reserved1[2];
    BYTE BeingDebugged;
    BYTE Reserved2[1];
    PVOID Reserved3[2];
    PPEB_LDR_DATA Ldr;
    PRTL_USER_PROCESS_PARAMETERS ProcessParameters;
    PVOID Reserved4[3];
    PVOID AtlThunkSListPtr;
    PVOID Reserved5;
    ULONG Reserved6;
    PVOID Reserved7;
    ULONG Reserved8;
    ULONG AtlThunkSListPtr32;
    PVOID Reserved9[45];
    BYTE Reserved10[96];
    PPS_POST_PROCESS_INIT_ROUTINE PostProcessInitRoutine;
    BYTE Reserved11[128];
    PVOID Reserved12[1];
    ULONG SessionId;
} PEB, *PPEB;

typedef struct _TEB {
    PVOID Reserved1[12];
    PPEB ProcessEnvironmentBlock;
    PVOID Reserved2[399];
    BYTE Reserved3[1952];
    PVOID TlsSlots[64];
    BYTE Reserved4[8];
    PVOID Reserved5[26];
    PVOID ReservedForOle;  // Windows 2000 only
    PVOID Reserved6[4];
    PVOID TlsExpansionSlots;
} TEB, *PTEB;
]]

ffi.cdef[[
typedef struct _OBJECT_ATTRIBUTES {
    ULONG Length;
    HANDLE RootDirectory;
    PUNICODE_STRING ObjectName;
    ULONG Attributes;
    PVOID SecurityDescriptor;
    PVOID SecurityQualityOfService;
} OBJECT_ATTRIBUTES;
typedef OBJECT_ATTRIBUTES *POBJECT_ATTRIBUTES;
]]

ffi.cdef[[
typedef struct _IO_STATUS_BLOCK {
    union {
        NTSTATUS Status;
        PVOID Pointer;
    } ;


    ULONG_PTR Information;
} IO_STATUS_BLOCK, *PIO_STATUS_BLOCK;
]]

ffi.cdef[[
typedef
void
(__stdcall *PIO_APC_ROUTINE) (
     PVOID ApcContext,
     PIO_STATUS_BLOCK IoStatusBlock,
     ULONG Reserved
    );
]]

ffi.cdef[[
typedef struct _PROCESS_BASIC_INFORMATION {
    PVOID Reserved1;
    PPEB PebBaseAddress;
    PVOID Reserved2[2];
    ULONG_PTR UniqueProcessId;
    PVOID Reserved3;
} PROCESS_BASIC_INFORMATION;
typedef PROCESS_BASIC_INFORMATION *PPROCESS_BASIC_INFORMATION;

typedef struct _SYSTEM_PROCESSOR_PERFORMANCE_INFORMATION {
    LARGE_INTEGER IdleTime;
    LARGE_INTEGER KernelTime;
    LARGE_INTEGER UserTime;
    LARGE_INTEGER Reserved1[2];
    ULONG Reserved2;
} SYSTEM_PROCESSOR_PERFORMANCE_INFORMATION, *PSYSTEM_PROCESSOR_PERFORMANCE_INFORMATION;

typedef struct _SYSTEM_PROCESS_INFORMATION {
    ULONG NextEntryOffset;
    ULONG NumberOfThreads;
    BYTE Reserved1[48];
    UNICODE_STRING ImageName;
    KPRIORITY BasePriority;
    HANDLE UniqueProcessId;
    PVOID Reserved2;
    ULONG HandleCount;
    ULONG SessionId;
    PVOID Reserved3;
    SIZE_T PeakVirtualSize;
    SIZE_T VirtualSize;
    ULONG Reserved4;
    SIZE_T PeakWorkingSetSize;
    SIZE_T WorkingSetSize;
    PVOID Reserved5;
    SIZE_T QuotaPagedPoolUsage;
    PVOID Reserved6;
    SIZE_T QuotaNonPagedPoolUsage;
    SIZE_T PagefileUsage;
    SIZE_T PeakPagefileUsage;
    SIZE_T PrivatePageCount;
    LARGE_INTEGER Reserved7[6];
} SYSTEM_PROCESS_INFORMATION, *PSYSTEM_PROCESS_INFORMATION;

typedef struct _SYSTEM_THREAD_INFORMATION {
    LARGE_INTEGER Reserved1[3];
    ULONG Reserved2;
    PVOID StartAddress;
    CLIENT_ID ClientId;
    KPRIORITY Priority;
    LONG BasePriority;
    ULONG Reserved3;
    ULONG ThreadState;
    ULONG WaitReason;
} SYSTEM_THREAD_INFORMATION, *PSYSTEM_THREAD_INFORMATION;

typedef struct _SYSTEM_REGISTRY_QUOTA_INFORMATION {
    ULONG RegistryQuotaAllowed;
    ULONG RegistryQuotaUsed;
    PVOID Reserved1;
} SYSTEM_REGISTRY_QUOTA_INFORMATION, *PSYSTEM_REGISTRY_QUOTA_INFORMATION;

typedef struct _SYSTEM_BASIC_INFORMATION {
    BYTE Reserved1[24];
    PVOID Reserved2[4];
    CCHAR NumberOfProcessors;
} SYSTEM_BASIC_INFORMATION, *PSYSTEM_BASIC_INFORMATION;

typedef struct _SYSTEM_TIMEOFDAY_INFORMATION {
    BYTE Reserved1[48];
} SYSTEM_TIMEOFDAY_INFORMATION, *PSYSTEM_TIMEOFDAY_INFORMATION;

typedef struct _SYSTEM_PERFORMANCE_INFORMATION {
    BYTE Reserved1[312];
} SYSTEM_PERFORMANCE_INFORMATION, *PSYSTEM_PERFORMANCE_INFORMATION;

typedef struct _SYSTEM_EXCEPTION_INFORMATION {
    BYTE Reserved1[16];
} SYSTEM_EXCEPTION_INFORMATION, *PSYSTEM_EXCEPTION_INFORMATION;

typedef struct _SYSTEM_LOOKASIDE_INFORMATION {
    BYTE Reserved1[32];
} SYSTEM_LOOKASIDE_INFORMATION, *PSYSTEM_LOOKASIDE_INFORMATION;

typedef struct _SYSTEM_INTERRUPT_INFORMATION {
    BYTE Reserved1[24];
} SYSTEM_INTERRUPT_INFORMATION, *PSYSTEM_INTERRUPT_INFORMATION;

typedef struct _SYSTEM_POLICY_INFORMATION {
    PVOID Reserved1[2];
    ULONG Reserved2[3];
} SYSTEM_POLICY_INFORMATION, *PSYSTEM_POLICY_INFORMATION;
]]

ffi.cdef[[
typedef enum _FILE_INFORMATION_CLASS {
    FileDirectoryInformation = 1
} FILE_INFORMATION_CLASS;

typedef enum _PROCESSINFOCLASS {
    ProcessBasicInformation = 0,
    ProcessDebugPort = 7,
    ProcessWow64Information = 26,
    ProcessImageFileName = 27,
    ProcessBreakOnTermination = 29
} PROCESSINFOCLASS;

typedef enum _THREADINFOCLASS {
    ThreadIsIoPending = 16
} THREADINFOCLASS;

typedef enum _SYSTEM_INFORMATION_CLASS {
    SystemBasicInformation = 0,
    SystemPerformanceInformation = 2,
    SystemTimeOfDayInformation = 3,
    SystemProcessInformation = 5,
    SystemProcessorPerformanceInformation = 8,
    SystemInterruptInformation = 23,
    SystemExceptionInformation = 33,
    SystemRegistryQuotaInformation = 37,
    SystemLookasideInformation = 45,
    SystemPolicyInformation = 134,
} SYSTEM_INFORMATION_CLASS;
]]

ffi.cdef[[
//
// Object Information Classes
//

typedef enum _OBJECT_INFORMATION_CLASS {
    ObjectBasicInformation = 0,
    ObjectTypeInformation = 2
} OBJECT_INFORMATION_CLASS;
]]

ffi.cdef[[
//
//  Public Object Information definitions
//

typedef struct _PUBLIC_OBJECT_BASIC_INFORMATION {
    ULONG Attributes;
    ACCESS_MASK GrantedAccess;
    ULONG HandleCount;
    ULONG PointerCount;

    ULONG Reserved[10];    // reserved for internal use

} PUBLIC_OBJECT_BASIC_INFORMATION, *PPUBLIC_OBJECT_BASIC_INFORMATION;

typedef struct __PUBLIC_OBJECT_TYPE_INFORMATION {

    UNICODE_STRING TypeName;

    ULONG Reserved [22];    // reserved for internal use

} PUBLIC_OBJECT_TYPE_INFORMATION, *PPUBLIC_OBJECT_TYPE_INFORMATION;
]]

if (_WIN32_WINNT >= 0x0501) then
--[[
//
// use the WTS API instead
//     WTSGetActiveConsoleSessionId
// The active console id is cached as a volatile ULONG in a constant
// memory location.  This x86 memory location is subject to changes between
// Windows releases.  Use the WTS API to make your application resilient to
// changes.
//
--]]

INTERNAL_TS_ACTIVE_CONSOLE_ID  = ffi.cast("ULONG*", 0x7ffe02d8)[0]
end --// (_WIN32_WINNT >= 0x0501)

--[[
//
// These functions are intended for use by internal core Windows components
// since these functions may change between Windows releases.
//
--]]

--[[
#define RtlMoveMemory(Destination,Source,Length) memmove((Destination),(Source),(Length))
#define RtlFillMemory(Destination,Length,Fill) memset((Destination),(Fill),(Length))
#define RtlZeroMemory(Destination,Length) memset((Destination),0,(Length))
--]]

ffi.cdef[[
//
// use the Win32 API instead
//     CloseHandle
//
 NTSTATUS
__stdcall
NtClose (
     HANDLE Handle
    );

//
// use the Win32 API instead
//     CreateFile
//
 NTSTATUS
__stdcall
NtCreateFile (
     PHANDLE FileHandle,
     ACCESS_MASK DesiredAccess,
     POBJECT_ATTRIBUTES ObjectAttributes,
     PIO_STATUS_BLOCK IoStatusBlock,
     PLARGE_INTEGER AllocationSize ,
     ULONG FileAttributes,
     ULONG ShareAccess,
     ULONG CreateDisposition,
     ULONG CreateOptions,
     PVOID EaBuffer ,
     ULONG EaLength
    );

//
// use the Win32 API instead
//     CreateFile
//
 NTSTATUS
__stdcall
NtOpenFile (
     PHANDLE FileHandle,
     ACCESS_MASK DesiredAccess,
     POBJECT_ATTRIBUTES ObjectAttributes,
     PIO_STATUS_BLOCK IoStatusBlock,
     ULONG ShareAccess,
     ULONG OpenOptions
    );

//
// use the Win32 API instead
//     N/A
//
 NTSTATUS
__stdcall
NtRenameKey (
     HANDLE KeyHandle,
     PUNICODE_STRING NewName
    );

//
// use the Win32 API instead
//     RegNotifyChangeKeyValue
//

 NTSTATUS
__stdcall
NtNotifyChangeMultipleKeys (
     HANDLE MasterKeyHandle,
     ULONG Count,
     OBJECT_ATTRIBUTES SubordinateObjects[],
     HANDLE Event,
     PIO_APC_ROUTINE ApcRoutine,
     PVOID ApcContext,
     PIO_STATUS_BLOCK IoStatusBlock,
     ULONG CompletionFilter,
     BOOLEAN WatchTree,
     PVOID Buffer,
     ULONG BufferSize,
     BOOLEAN Asynchronous
    );

//
// use the Win32 API instead
//     RegQueryValueEx
//

typedef struct _KEY_VALUE_ENTRY {
    PUNICODE_STRING ValueName;
    ULONG           DataLength;
    ULONG           DataOffset;
    ULONG           Type;
} KEY_VALUE_ENTRY, *PKEY_VALUE_ENTRY;

 NTSTATUS
__stdcall
NtQueryMultipleValueKey (
     HANDLE KeyHandle,
     PKEY_VALUE_ENTRY ValueEntries,
     ULONG EntryCount,
     PVOID ValueBuffer,
     PULONG BufferLength,
     PULONG RequiredBufferLength
    );

//
// use the Win32 API instead
//     N/A
//

typedef enum _KEY_SET_INFORMATION_CLASS {
    KeyWriteTimeInformation,
    KeyWow64FlagsInformation,
    KeyControlFlagsInformation,
    KeySetVirtualizationInformation,
    KeySetDebugInformation,
    KeySetHandleTagsInformation,
    MaxKeySetInfoClass  // MaxKeySetInfoClass should always be the last enum
} KEY_SET_INFORMATION_CLASS;

 NTSTATUS
__stdcall
NtSetInformationKey (
     HANDLE KeyHandle,
     
        KEY_SET_INFORMATION_CLASS KeySetInformationClass,
     PVOID KeySetInformation,
     ULONG KeySetInformationLength
    );

//
// use the Win32 API instead
//     DeviceIoControl
//
 NTSTATUS
__stdcall
NtDeviceIoControlFile (
     HANDLE FileHandle,
     HANDLE Event ,
     PIO_APC_ROUTINE ApcRoutine ,
     PVOID ApcContext ,
     PIO_STATUS_BLOCK IoStatusBlock,
     ULONG IoControlCode,
     PVOID InputBuffer ,
     ULONG InputBufferLength,
     PVOID OutputBuffer ,
     ULONG OutputBufferLength
    );

//
// use the Win32 API instead
//     WaitForSingleObjectEx
//
NTSTATUS
__stdcall
NtWaitForSingleObject (
     HANDLE Handle,
     BOOLEAN Alertable,
     PLARGE_INTEGER Timeout 
    );

//
// use the Win32 API instead
//     CheckNameLegalDOS8Dot3
//
BOOLEAN
__stdcall
RtlIsNameLegalDOS8Dot3 (
     PUNICODE_STRING Name,
      POEM_STRING OemName ,
      PBOOLEAN NameContainsSpaces 
    );

//
// This function might be needed for some of the internal Windows functions,
// defined in this header file.
//

ULONG
__stdcall
RtlNtStatusToDosError (
   NTSTATUS Status
   );

//
// use the Win32 APIs instead
//     GetProcessHandleCount
//     GetProcessId
//
 NTSTATUS
__stdcall
NtQueryInformationProcess (
     HANDLE ProcessHandle,
     PROCESSINFOCLASS ProcessInformationClass,
     PVOID ProcessInformation,
     ULONG ProcessInformationLength,
     PULONG ReturnLength 
    );

//
// use the Win32 API instead
//     GetThreadIOPendingFlag
//
 NTSTATUS
__stdcall
NtQueryInformationThread (
     HANDLE ThreadHandle,
     THREADINFOCLASS ThreadInformationClass,
     PVOID ThreadInformation,
     ULONG ThreadInformationLength,
     PULONG ReturnLength 
    );

//
// use the Win32 APIs instead
//     GetFileInformationByHandle
//     GetFileInformationByHandleEx
//     GetProcessInformation
//     GetThreadInformation
//

NTSTATUS
__stdcall
NtQueryObject (
     HANDLE Handle,
     OBJECT_INFORMATION_CLASS ObjectInformationClass,
     PVOID ObjectInformation,
     ULONG ObjectInformationLength,
     PULONG ReturnLength
    );

//
// use the Win32 APIs instead
//     GetSystemRegistryQuota
//     GetSystemTimes
// use the CryptoAPIs instead for generating random data
//     CryptGenRandom
//
 NTSTATUS
__stdcall
NtQuerySystemInformation (
     SYSTEM_INFORMATION_CLASS SystemInformationClass,
     PVOID SystemInformation,
     ULONG SystemInformationLength,
     PULONG ReturnLength 
    );

//
// use the Win32 API instead
//     GetSystemTimeAsFileTime
//
 NTSTATUS
__stdcall
NtQuerySystemTime (
     PLARGE_INTEGER SystemTime
    );

//
// use the Win32 API instead
//     LocalFileTimeToFileTime
//
NTSTATUS
__stdcall
RtlLocalTimeToSystemTime (
     PLARGE_INTEGER LocalTime,
     PLARGE_INTEGER SystemTime
    );

//
// use the Win32 API instead
//     SystemTimeToFileTime to convert to FILETIME structures
//     copy the resulting FILETIME structures to ULARGE_INTEGER structures
//     perform the calculation
//
BOOLEAN
__stdcall
RtlTimeToSecondsSince1970 (
    PLARGE_INTEGER Time,
    PULONG ElapsedSeconds
    );

//
// These APIs might be need for some of the internal Windows functions,
// defined in this header file.
//
VOID
__stdcall
RtlFreeAnsiString (
    PANSI_STRING AnsiString
    );

VOID
__stdcall
RtlFreeUnicodeString (
    PUNICODE_STRING UnicodeString
    );

VOID
__stdcall
RtlFreeOemString(
    POEM_STRING OemString
    );

VOID
__stdcall
RtlInitString (
    PSTRING DestinationString,
    PCSZ SourceString
    );

NTSTATUS
__stdcall
RtlInitStringEx (
    PSTRING DestinationString,
    PCSZ SourceString
    );

VOID
__stdcall
RtlInitAnsiString (
    PANSI_STRING DestinationString,
    PCSZ SourceString
    );

NTSTATUS
__stdcall
RtlInitAnsiStringEx (
    PANSI_STRING DestinationString,
    PCSZ SourceString
    );

VOID
__stdcall
RtlInitUnicodeString (
    PUNICODE_STRING DestinationString,
    PCWSTR SourceString
    );

NTSTATUS
__stdcall
RtlAnsiStringToUnicodeString (
    PUNICODE_STRING DestinationString,
    PCANSI_STRING SourceString,
    BOOLEAN AllocateDestinationString
    );

NTSTATUS
__stdcall
RtlUnicodeStringToAnsiString (
    PANSI_STRING DestinationString,
    PCUNICODE_STRING SourceString,
    BOOLEAN AllocateDestinationString
    );

NTSTATUS
__stdcall
RtlUnicodeStringToOemString(
    POEM_STRING DestinationString,
    PCUNICODE_STRING SourceString,
    BOOLEAN AllocateDestinationString
    );

//
// Use the Win32 API instead
//     WideCharToMultiByte
//     set CodePage to CP_ACP
//     set cbMultiByte to 0
//
NTSTATUS
__stdcall
RtlUnicodeToMultiByteSize(
     PULONG BytesInMultiByteString,
     PWCH UnicodeString,
     ULONG BytesInUnicodeString
    );

//
// Use the C runtime function instead
//     strtol
//
NTSTATUS
__stdcall
RtlCharToInteger (
    PCSZ String,
    ULONG Base,
    PULONG Value
    );

//
// use the Win32 API instead
//     ConvertSidToStringSid
//
NTSTATUS
__stdcall
RtlConvertSidToUnicodeString (
    PUNICODE_STRING UnicodeString,
    PSID Sid,
    BOOLEAN AllocateDestinationString
    );

//
// use the CryptoAPIs instead
//     CryptGenRandom
//
ULONG
__stdcall
RtlUniform (
    PULONG Seed
    );
]]

--#define LOGONID_CURRENT     ((ULONG)-1)
--#define SERVERNAME_CURRENT  ((HANDLE)NULL)

ffi.cdef[[
typedef enum _WINSTATIONINFOCLASS {
    WinStationInformation = 8
} WINSTATIONINFOCLASS;


typedef struct _WINSTATIONINFORMATIONW {
    BYTE Reserved2[70];
    ULONG LogonId;
    BYTE Reserved3[1140];
} WINSTATIONINFORMATIONW, * PWINSTATIONINFORMATIONW;
]]

ffi.cdef[[
//
// this function is implemented in winsta.dll (you need to loadlibrary to call this function)
// this internal function retrives the LogonId (also called SessionId) for the current process
// You should avoid using this function as it can change. you can retrieve the same information
// Using public api WTSQuerySessionInformation. Pass WTSSessionId as the WTSInfoClass parameter
//
typedef BOOLEAN (__stdcall * PWINSTATIONQUERYINFORMATIONW)(
    HANDLE, ULONG, WINSTATIONINFOCLASS, PVOID, ULONG, PULONG );
]]

--[[
//
// Generic test for success on any status value (non-negative numbers
// indicate success).
//

#ifndef NT_SUCCESS
#define NT_SUCCESS(Status) (((NTSTATUS)(Status)) >= 0)
#endif
--]]

--[[
//
// Generic test for information on any status value.
//

#ifndef NT_INFORMATION
#define NT_INFORMATION(Status) ((((ULONG)(Status)) >> 30) == 1)
#endif
--]]

--[[
//
// Generic test for warning on any status value.
//

#ifndef NT_WARNING
#define NT_WARNING(Status) ((((ULONG)(Status)) >> 30) == 2)
#endif
--]]

--[[
//
// Generic test for error on any status value.
//

#ifndef NT_ERROR
#define NT_ERROR(Status) ((((ULONG)(Status)) >> 30) == 3)
#endif
--]]

--[[
//++
//
// VOID
// InitializeObjectAttributes(
//      POBJECT_ATTRIBUTES p,
//      PUNICODE_STRING n,
//      ULONG a,
//      HANDLE r,
//      PSECURITY_DESCRIPTOR s
//     )
//
//--

#ifndef InitializeObjectAttributes
#define InitializeObjectAttributes( p, n, a, r, s ) { \
    (p)->Length = sizeof( OBJECT_ATTRIBUTES );          \
    (p)->RootDirectory = r;                             \
    (p)->Attributes = a;                                \
    (p)->ObjectName = n;                                \
    (p)->SecurityDescriptor = s;                        \
    (p)->SecurityQualityOfService = NULL;               \
    }
#endif
--]]

ffi.cdef[[
//
// Valid values for the Attributes field
//

static const int OBJ_INHERIT                         = 0x00000002L;
static const int OBJ_PERMANENT                       = 0x00000010L;
static const int OBJ_EXCLUSIVE                       = 0x00000020L;
static const int OBJ_CASE_INSENSITIVE                = 0x00000040L;
static const int OBJ_OPENIF                          = 0x00000080L;
static const int OBJ_OPENLINK                        = 0x00000100L;
static const int OBJ_KERNEL_HANDLE                   = 0x00000200L;
static const int OBJ_FORCE_ACCESS_CHECK              = 0x00000400L;
static const int OBJ_IGNORE_IMPERSONATED_DEVICEMAP   = 0x00000800L;
static const int OBJ_DONT_REPARSE                    = 0x00001000L;
static const int OBJ_VALID_ATTRIBUTES                = 0x00001FF2L;
]]

ffi.cdef[[
//
// Define the create disposition values
//

static const int FILE_SUPERSEDE                  = 0x00000000;
static const int FILE_OPEN                       = 0x00000001;
static const int FILE_CREATE                     = 0x00000002;
static const int FILE_OPEN_IF                    = 0x00000003;
static const int FILE_OVERWRITE                  = 0x00000004;
static const int FILE_OVERWRITE_IF               = 0x00000005;
static const int FILE_MAXIMUM_DISPOSITION        = 0x00000005;

//
// Define the create/open option flags
//

static const int FILE_DIRECTORY_FILE                     = 0x00000001;
static const int FILE_WRITE_THROUGH                      = 0x00000002;
static const int FILE_SEQUENTIAL_ONLY                    = 0x00000004;
static const int FILE_NO_INTERMEDIATE_BUFFERING          = 0x00000008;

static const int FILE_SYNCHRONOUS_IO_ALERT               = 0x00000010;
static const int FILE_SYNCHRONOUS_IO_NONALERT            = 0x00000020;
static const int FILE_NON_DIRECTORY_FILE                 = 0x00000040;
static const int FILE_CREATE_TREE_CONNECTION             = 0x00000080;

static const int FILE_COMPLETE_IF_OPLOCKED               = 0x00000100;
static const int FILE_NO_EA_KNOWLEDGE                    = 0x00000200;
static const int FILE_OPEN_REMOTE_INSTANCE               = 0x00000400;
static const int FILE_RANDOM_ACCESS                      = 0x00000800;

static const int FILE_DELETE_ON_CLOSE                    = 0x00001000;
static const int FILE_OPEN_BY_FILE_ID                    = 0x00002000;
static const int FILE_OPEN_FOR_BACKUP_INTENT             = 0x00004000;
static const int FILE_NO_COMPRESSION                     = 0x00008000;
]]


if (_WIN32_WINNT >= _WIN32_WINNT_WIN7) then
ffi.cdef[[
static const int FILE_OPEN_REQUIRING_OPLOCK              = 0x00010000;
]]
end

ffi.cdef[[
static const int FILE_RESERVE_OPFILTER                   = 0x00100000;
static const int FILE_OPEN_REPARSE_POINT                 = 0x00200000;
static const int FILE_OPEN_NO_RECALL                     = 0x00400000;
static const int FILE_OPEN_FOR_FREE_SPACE_QUERY          = 0x00800000;

static const int FILE_VALID_OPTION_FLAGS                 = 0x00ffffff;
static const int FILE_VALID_PIPE_OPTION_FLAGS            = 0x00000032;
static const int FILE_VALID_MAILSLOT_OPTION_FLAGS        = 0x00000032;
static const int FILE_VALID_SET_FLAGS                    = 0x00000036;
]]

ffi.cdef[[
//
// Define the I/O status information return values for NtCreateFile/NtOpenFile
//

static const int FILE_SUPERSEDED                 = 0x00000000;
static const int FILE_OPENED                     = 0x00000001;
static const int FILE_CREATED                    = 0x00000002;
static const int FILE_OVERWRITTEN                = 0x00000003;
static const int FILE_EXISTS                     = 0x00000004;
static const int FILE_DOES_NOT_EXIST             = 0x00000005;
]]


end --// (_WIN32_WINNT >= 0x0500)


end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


end --// _WINTERNL_

local lib = ffi.load("ntdll")

return lib