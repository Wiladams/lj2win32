local ffi = require("ffi")




if not _SETUPAPI_VER then
    if _WIN32_WINNT and not _WIN32_WINDOWS or (_WIN32_WINNT < _WIN32_WINDOWS) then
        _SETUPAPI_VER = _WIN32_WINNT  --// SetupAPI version follows Windows NT version
    elseif _WIN32_WINDOWS then
        if _WIN32_WINDOWS >= 0x0490 then
            _SETUPAPI_VER = _WIN32_WINNT_WIN2K        --// WinME uses same version of SetupAPI as Win2k
        elseif _WIN32_WINDOWS >= 0x0410 then
            _SETUPAPI_VER = 0x0410        --// Indicates version of SetupAPI shipped with Win98
        else
            _SETUPAPI_VER = _WIN32_WINNT_NT4        -- Earliest SetupAPI version
        end -- _WIN32_WINDOWS
    else -- _WIN32_WINNT/_WIN32_WINDOWS
        _SETUPAPI_VER = _WIN32_WINNT_WINXP;
    end --// _WIN32_WINNT/_WIN32_WINDOWS
end --// !_SETUPAPI_VER

if not __LPGUID_DEFINED__ then
__LPGUID_DEFINED__ = true
ffi.cdef[[
typedef GUID *LPGUID;
]]
end


require ("win32.spapidef")
require("win32.commctrl")
require("win32.devpropdef")


if _WIN64 then
print("_WIN64")
--#include <pshpack8.h>   // Assume 8-byte (64-bit) packing throughout
else
--#include <pshpack1.h>   // Assume byte packing throughout (32-bit processor)
end


ffi.cdef[[
//
// Define maximum string length constants
//
static const int LINE_LEN                 =   256; // Windows 9x-compatible maximum for
                                        // displayable strings coming from a
                                        // device INF.
static const int MAX_INF_STRING_LENGTH    =  4096; // Actual maximum size of an INF string
                                        // (including string substitutions).
static const int MAX_INF_SECTION_NAME_LENGTH = 255; // For Windows 9x compatibility, INF
                                        // section names should be constrained
                                        // to 32 characters.

static const int MAX_TITLE_LEN             =   60;
static const int MAX_INSTRUCTION_LEN       =  256;
static const int MAX_LABEL_LEN             =   30;
static const int MAX_SERVICE_NAME_LEN      =  256;
static const int MAX_SUBTITLE_LEN          =  256;
]]

ffi.cdef[[
//
// Define maximum length of a machine name in the format expected by ConfigMgr32
// CM_Connect_Machine (i.e., "\\\\MachineName\0").
//
static const int SP_MAX_MACHINENAME_LENGTH   = (MAX_PATH + 3);
]]

ffi.cdef[[
typedef PVOID HINF;

typedef struct _INFCONTEXT {
    PVOID Inf;
    PVOID CurrentInf;
    UINT Section;
    UINT Line;
} INFCONTEXT, *PINFCONTEXT;


typedef struct _SP_INF_INFORMATION {
    DWORD InfStyle;
    DWORD InfCount;
    BYTE VersionData[ANYSIZE_ARRAY];
} SP_INF_INFORMATION, *PSP_INF_INFORMATION;


typedef struct _SP_ALTPLATFORM_INFO_V3 {
    DWORD cbSize;
    DWORD Platform;
    DWORD MajorVersion;
    DWORD MinorVersion;
    WORD  ProcessorArchitecture;

    union {
        WORD  Reserved; // for compatibility with V1 structure
        WORD  Flags;    // indicates validity of non V1 fields
    } ;


    DWORD FirstValidatedMajorVersion;
    DWORD FirstValidatedMinorVersion;

    BYTE ProductType;
    WORD SuiteMask;

    DWORD BuildNumber;

} SP_ALTPLATFORM_INFO_V3, *PSP_ALTPLATFORM_INFO_V3;
]]

ffi.cdef[[
typedef struct _SP_ALTPLATFORM_INFO_V2 {
    DWORD cbSize;
    DWORD Platform;
    DWORD MajorVersion;
    DWORD MinorVersion;
    WORD  ProcessorArchitecture;
    union {
        WORD  Reserved;
        WORD  Flags;
    } ;
    DWORD FirstValidatedMajorVersion;
    DWORD FirstValidatedMinorVersion;
} SP_ALTPLATFORM_INFO_V2, *PSP_ALTPLATFORM_INFO_V2;

typedef struct _SP_ALTPLATFORM_INFO_V1 {
    DWORD cbSize;
    DWORD Platform;
    DWORD MajorVersion;
    DWORD MinorVersion;
    WORD  ProcessorArchitecture;
    WORD  Reserved; // must be zero.
} SP_ALTPLATFORM_INFO_V1, *PSP_ALTPLATFORM_INFO_V1;
]]


if USE_SP_ALTPLATFORM_INFO_V1 or (_SETUPAPI_VER < _WIN32_WINNT_WINXP) then
ffi.cdef[[
// use version 1 altplatform info data structure
typedef SP_ALTPLATFORM_INFO_V1 SP_ALTPLATFORM_INFO;
typedef PSP_ALTPLATFORM_INFO_V1 PSP_ALTPLATFORM_INFO;
]]
elseif USE_SP_ALTPLATFORM_INFO_V3 and (NTDDI_VERSION >= NTDDI_WIN10_RS1) then
ffi.cdef[[
// use version 3 altplatform info data structure
typedef SP_ALTPLATFORM_INFO_V3 SP_ALTPLATFORM_INFO;
typedef PSP_ALTPLATFORM_INFO_V3 PSP_ALTPLATFORM_INFO;
]]
else
ffi.cdef[[
// use version 2 altplatform info data structure
typedef SP_ALTPLATFORM_INFO_V2 SP_ALTPLATFORM_INFO;
typedef PSP_ALTPLATFORM_INFO_V2 PSP_ALTPLATFORM_INFO;
]]
end  --// use default version of altplatform info data structure



if _WIN32_WINNT >= _WIN32_WINNT_WINXP then
ffi.cdef[[
static const int SP_ALTPLATFORM_FLAGS_VERSION_RANGE = (0x0001);     // FirstValidatedMajor/MinorVersion
]]
end

if NTDDI_VERSION >= NTDDI_WIN10_RS1 then
ffi.cdef[[
static const int SP_ALTPLATFORM_FLAGS_SUITE_MASK   = (0x0002);     // SuiteMask
]]
end

ffi.cdef[[
//
// Define structure that is filled in by SetupQueryInfOriginalFileInformation
// to indicate the INFs original name and the original name of the (potentially
// platform-specific) catalog file specified by that INF.
//
typedef struct _SP_ORIGINAL_FILE_INFO_A {
    DWORD  cbSize;
    CHAR   OriginalInfName[MAX_PATH];
    CHAR   OriginalCatalogName[MAX_PATH];
} SP_ORIGINAL_FILE_INFO_A, *PSP_ORIGINAL_FILE_INFO_A;

typedef struct _SP_ORIGINAL_FILE_INFO_W {
    DWORD  cbSize;
    WCHAR  OriginalInfName[MAX_PATH];
    WCHAR  OriginalCatalogName[MAX_PATH];
} SP_ORIGINAL_FILE_INFO_W, *PSP_ORIGINAL_FILE_INFO_W;
]]

--[[
if UNICODE
typedef SP_ORIGINAL_FILE_INFO_W SP_ORIGINAL_FILE_INFO;
typedef PSP_ORIGINAL_FILE_INFO_W PSP_ORIGINAL_FILE_INFO;
else
typedef SP_ORIGINAL_FILE_INFO_A SP_ORIGINAL_FILE_INFO;
typedef PSP_ORIGINAL_FILE_INFO_A PSP_ORIGINAL_FILE_INFO;
end
--]]

ffi.cdef[[
static const int INF_STYLE_NONE         =  0x00000000;       // unrecognized or non-existent
static const int INF_STYLE_OLDNT        =  0x00000001;       // winnt 3.x
static const int INF_STYLE_WIN4         =  0x00000002;       // Win95
]]

ffi.cdef[[

static const int INF_STYLE_CACHE_ENABLE  = 0x00000010; // always cache INF, even outside of %windir%\Inf
static const int INF_STYLE_CACHE_DISABLE = 0x00000020; // delete cached INF information
]]

if _SETUPAPI_VER >= _WIN32_WINNT_WS03 then
ffi.cdef[[
static const int INF_STYLE_CACHE_IGNORE  = 0x00000040; // ignore any cached INF information
]]
end

ffi.cdef[[
//
// Target directory specs.
//
static const int DIRID_ABSOLUTE        =  -1;              // real 32-bit -1
static const int DIRID_ABSOLUTE_16BIT  =   0xffff;         // 16-bit -1 for compat w/setupx
static const int DIRID_NULL            =   0;
static const int DIRID_SRCPATH         =   1;
static const int DIRID_WINDOWS         =  10;
static const int DIRID_SYSTEM          =  11;             // system32
static const int DIRID_DRIVERS         =  12;
static const int DIRID_IOSUBSYS        =  DIRID_DRIVERS;
static const int DIRID_DRIVER_STORE    =  13;
static const int DIRID_INF             =  17;
static const int DIRID_HELP            =  18;
static const int DIRID_FONTS           =  20;
static const int DIRID_VIEWERS         =  21;
static const int DIRID_COLOR           =  23;
static const int DIRID_APPS            =  24;
static const int DIRID_SHARED          =  25;
static const int DIRID_BOOT            =  30;

static const int DIRID_SYSTEM16        =  50;
static const int DIRID_SPOOL           =  51;
static const int DIRID_SPOOLDRIVERS    =  52;
static const int DIRID_USERPROFILE     =  53;
static const int DIRID_LOADER          =  54;
static const int DIRID_PRINTPROCESSOR  =  55;

static const int DIRID_DEFAULT         =  DIRID_SYSTEM;
]]

ffi.cdef[[
static const int DIRID_COMMON_STARTMENU       = 16406;  // All Users\Start Menu
static const int DIRID_COMMON_PROGRAMS        = 16407;  // All Users\Start Menu\Programs
static const int DIRID_COMMON_STARTUP         = 16408;  // All Users\Start Menu\Programs\Startup
static const int DIRID_COMMON_DESKTOPDIRECTORY= 16409;  // All Users\Desktop
static const int DIRID_COMMON_FAVORITES       = 16415;  // All Users\Favorites
static const int DIRID_COMMON_APPDATA         = 16419;  // All Users\Application Data

static const int DIRID_PROGRAM_FILES          = 16422;  // Program Files
static const int DIRID_SYSTEM_X86             = 16425;  // system32 for WOW
static const int DIRID_PROGRAM_FILES_X86      = 16426;  // Program Files for WOW
static const int DIRID_PROGRAM_FILES_COMMON   = 16427;  // Program Files\Common
static const int DIRID_PROGRAM_FILES_COMMONX86= 16428;  // x86 Program Files\Common for WOW

static const int DIRID_COMMON_TEMPLATES       = 16429;  // All Users\Templates
static const int DIRID_COMMON_DOCUMENTS       = 16430;  // All Users\Documents


//
// First user-definable dirid. See SetupSetDirectoryId().
//
static const int DIRID_USER             = 0x8000;
]]

ffi.cdef[[
//
// Setup callback notification routine type
//
typedef UINT (__stdcall* PSP_FILE_CALLBACK_A)(
     PVOID Context,
     UINT Notification,
     UINT_PTR Param1,
     UINT_PTR Param2
    );

typedef UINT (__stdcall* PSP_FILE_CALLBACK_W)(
     PVOID Context,
     UINT Notification,
     UINT_PTR Param1,
     UINT_PTR Param2
    );
]]


if UNICODE then
ffi.cdef[[
typedef  PSP_FILE_CALLBACK_W PSP_FILE_CALLBACK;
]]
else
ffi.cdef[[
typedef  PSP_FILE_CALLBACK_A PSP_FILE_CALLBACK;
]]
end



ffi.cdef[[
//
// Operation/queue start/end notification. These are ordinal values.
//
static const int SPFILENOTIFY_STARTQUEUE         = 0x00000001;
static const int SPFILENOTIFY_ENDQUEUE           = 0x00000002;
static const int SPFILENOTIFY_STARTSUBQUEUE      = 0x00000003;
static const int SPFILENOTIFY_ENDSUBQUEUE        = 0x00000004;
static const int SPFILENOTIFY_STARTDELETE        = 0x00000005;
static const int SPFILENOTIFY_ENDDELETE          = 0x00000006;
static const int SPFILENOTIFY_DELETEERROR        = 0x00000007;
static const int SPFILENOTIFY_STARTRENAME        = 0x00000008;
static const int SPFILENOTIFY_ENDRENAME          = 0x00000009;
static const int SPFILENOTIFY_RENAMEERROR        = 0x0000000a;
static const int SPFILENOTIFY_STARTCOPY          = 0x0000000b;
static const int SPFILENOTIFY_ENDCOPY            = 0x0000000c;
static const int SPFILENOTIFY_COPYERROR          = 0x0000000d;
static const int SPFILENOTIFY_NEEDMEDIA          = 0x0000000e;
static const int SPFILENOTIFY_QUEUESCAN          = 0x0000000f;
//
// These are used with SetupIterateCabinet().
//
static const int SPFILENOTIFY_CABINETINFO        = 0x00000010;
static const int SPFILENOTIFY_FILEINCABINET      = 0x00000011;
static const int SPFILENOTIFY_NEEDNEWCABINET     = 0x00000012;
static const int SPFILENOTIFY_FILEEXTRACTED      = 0x00000013;
static const int SPFILENOTIFY_FILEOPDELAYED      = 0x00000014;
//
// These are used for backup operations
//
static const int SPFILENOTIFY_STARTBACKUP        = 0x00000015;
static const int SPFILENOTIFY_BACKUPERROR        = 0x00000016;
static const int SPFILENOTIFY_ENDBACKUP          = 0x00000017;
//
// Extended notification for SetupScanFileQueue(Flags=SPQ_SCAN_USE_CALLBACKEX)
//
static const int SPFILENOTIFY_QUEUESCAN_EX       = 0x00000018;

static const int SPFILENOTIFY_STARTREGISTRATION  = 0x00000019;
static const int SPFILENOTIFY_ENDREGISTRATION    = 0x00000020;
]]


if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then
ffi.cdef[[
static const int SPFILENOTIFY_QUEUESCAN_SIGNERINFO = 0x00000040;
]]
end

ffi.cdef[[
//
// Copy notification. These are bit flags that may be combined.
//
static const int SPFILENOTIFY_LANGMISMATCH      = 0x00010000;
static const int SPFILENOTIFY_TARGETEXISTS      = 0x00020000;
static const int SPFILENOTIFY_TARGETNEWER       = 0x00040000;

//
// File operation codes and callback outcomes.
//
static const int FILEOP_COPY                    = 0;
static const int FILEOP_RENAME                  = 1;
static const int FILEOP_DELETE                  = 2;
static const int FILEOP_BACKUP                  = 3;

static const int FILEOP_ABORT                   = 0;
static const int FILEOP_DOIT                    = 1;
static const int FILEOP_SKIP                    = 2;
static const int FILEOP_RETRY                   = FILEOP_DOIT;
static const int FILEOP_NEWPATH                 = 4;

//
// Flags in inf copy sections
//
static const int COPYFLG_WARN_IF_SKIP           = 0x00000001;  // warn if user tries to skip file
static const int COPYFLG_NOSKIP                 = 0x00000002;  // disallow skipping this file
static const int COPYFLG_NOVERSIONCHECK         = 0x00000004;  // ignore versions and overwrite target
static const int COPYFLG_FORCE_FILE_IN_USE      = 0x00000008;  // force file-in-use behavior
static const int COPYFLG_NO_OVERWRITE           = 0x00000010;  // do not copy if file exists on target
static const int COPYFLG_NO_VERSION_DIALOG      = 0x00000020;  // do not copy if target is newer
static const int COPYFLG_OVERWRITE_OLDER_ONLY   = 0x00000040;  // leave target alone if version same as source
static const int COPYFLG_PROTECTED_WINDOWS_DRIVER_FILE = 0x00000100;    // a Windows driver file to be 
                            // protected as other Windows system files

static const int COPYFLG_REPLACEONLY           =  0x00000400;  // copy only if file exists on target
static const int COPYFLG_NODECOMP              =  0x00000800;  // don't attempt to decompress file; copy as-is
static const int COPYFLG_REPLACE_BOOT_FILE     =  0x00001000;  // file must be present upon reboot (i.e., it's
                                                    // needed by the loader); this flag implies a reboot
static const int COPYFLG_NOPRUNE               =  0x00002000;  // never prune this file
static const int COPYFLG_IN_USE_TRY_RENAME     =  0x00004000;  // If file in use, try to rename the target first

//
// Flags in inf delete sections
// New flags go in high word
//
static const int DELFLG_IN_USE                  = 0x00000001;  // queue in-use file for delete
static const int DELFLG_IN_USE1                 = 0x00010000;  // high-word version of DELFLG_IN_USE
]]

ffi.cdef[[
//
// Source and file paths. Used when notifying queue callback
// of SPFILENOTIFY_STARTxxx, SPFILENOTIFY_ENDxxx, and SPFILENOTIFY_xxxERROR.
//
typedef struct _FILEPATHS_A {
    PCSTR  Target;
    PCSTR  Source;  // not used for delete operations
    UINT   Win32Error;
    DWORD  Flags;   // such as SP_COPY_NOSKIP for copy errors
} FILEPATHS_A, *PFILEPATHS_A;

typedef struct _FILEPATHS_W {
    PCWSTR Target;
    PCWSTR Source;  // not used for delete operations
    UINT   Win32Error;
    DWORD  Flags;   // such as SP_COPY_NOSKIP for copy errors
} FILEPATHS_W, *PFILEPATHS_W;
]]

--[[
if UNICODE
typedef FILEPATHS_W FILEPATHS;
typedef PFILEPATHS_W PFILEPATHS;
else
typedef FILEPATHS_A FILEPATHS;
typedef PFILEPATHS_A PFILEPATHS;
end
--]]


if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then
ffi.cdef[[
typedef struct _FILEPATHS_SIGNERINFO_A {
    PCSTR  Target;
    PCSTR  Source;  // not used for delete operations
    UINT   Win32Error;
    DWORD  Flags;   // such as SP_COPY_NOSKIP for copy errors
    PCSTR  DigitalSigner;
    PCSTR  Version;
    PCSTR  CatalogFile;
} FILEPATHS_SIGNERINFO_A, *PFILEPATHS_SIGNERINFO_A;

typedef struct _FILEPATHS_SIGNERINFO_W {
    PCWSTR Target;
    PCWSTR Source;  // not used for delete operations
    UINT   Win32Error;
    DWORD  Flags;   // such as SP_COPY_NOSKIP for copy errors
    PCWSTR DigitalSigner;
    PCWSTR Version;
    PCWSTR CatalogFile;
} FILEPATHS_SIGNERINFO_W, *PFILEPATHS_SIGNERINFO_W;
]]

--[[
if UNICODE
typedef FILEPATHS_SIGNERINFO_W FILEPATHS_SIGNERINFO;
typedef PFILEPATHS_SIGNERINFO_W PFILEPATHS_SIGNERINFO;
else
typedef FILEPATHS_SIGNERINFO_A FILEPATHS_SIGNERINFO;
typedef PFILEPATHS_SIGNERINFO_A PFILEPATHS_SIGNERINFO;
end
--]]
end --// _SETUPAPI_VER >= _WIN32_WINNT_WINXP

ffi.cdef[[
//
// Structure used with SPFILENOTIFY_NEEDMEDIA
//
typedef struct _SOURCE_MEDIA_A {
    PCSTR Reserved;
    PCSTR Tagfile;          // may be NULL
    PCSTR Description;
    //
    // Pathname part and filename part of source file
    // that caused us to need the media.
    //
    PCSTR SourcePath;
    PCSTR SourceFile;
    DWORD Flags;            // subset of SP_COPY_xxx
} SOURCE_MEDIA_A, *PSOURCE_MEDIA_A;

typedef struct _SOURCE_MEDIA_W {
    PCWSTR Reserved;
    PCWSTR Tagfile;         // may be NULL
    PCWSTR Description;
    //
    // Pathname part and filename part of source file
    // that caused us to need the media.
    //
    PCWSTR SourcePath;
    PCWSTR SourceFile;
    DWORD  Flags;           // subset of SP_COPY_xxx
} SOURCE_MEDIA_W, *PSOURCE_MEDIA_W;
]]

--[[
if UNICODE
typedef SOURCE_MEDIA_W SOURCE_MEDIA;
typedef PSOURCE_MEDIA_W PSOURCE_MEDIA;
else
typedef SOURCE_MEDIA_A SOURCE_MEDIA;
typedef PSOURCE_MEDIA_A PSOURCE_MEDIA;
end
--]]

ffi.cdef[[
//
// Structure used with SPFILENOTIFY_CABINETINFO and
// SPFILENOTIFY_NEEDNEWCABINET
//
typedef struct _CABINET_INFO_A {
    PCSTR CabinetPath;
    PCSTR CabinetFile;
    PCSTR DiskName;
    USHORT SetId;
    USHORT CabinetNumber;
} CABINET_INFO_A, *PCABINET_INFO_A;

typedef struct _CABINET_INFO_W {
    PCWSTR CabinetPath;
    PCWSTR CabinetFile;
    PCWSTR DiskName;
    USHORT SetId;
    USHORT CabinetNumber;
} CABINET_INFO_W, *PCABINET_INFO_W;
]]

--[[
if UNICODE
typedef CABINET_INFO_W CABINET_INFO;
typedef PCABINET_INFO_W PCABINET_INFO;
else
typedef CABINET_INFO_A CABINET_INFO;
typedef PCABINET_INFO_A PCABINET_INFO;
end
--]]

ffi.cdef[[
//
// Structure used with SPFILENOTIFY_FILEINCABINET
//
typedef struct _FILE_IN_CABINET_INFO_A {
    PCSTR NameInCabinet;
    DWORD FileSize;
    DWORD Win32Error;
    WORD  DosDate;
    WORD  DosTime;
    WORD  DosAttribs;
    CHAR  FullTargetName[MAX_PATH];
} FILE_IN_CABINET_INFO_A, *PFILE_IN_CABINET_INFO_A;

typedef struct _FILE_IN_CABINET_INFO_W {
    PCWSTR NameInCabinet;
    DWORD  FileSize;
    DWORD  Win32Error;
    WORD   DosDate;
    WORD   DosTime;
    WORD   DosAttribs;
    WCHAR  FullTargetName[MAX_PATH];
} FILE_IN_CABINET_INFO_W, *PFILE_IN_CABINET_INFO_W;
]]

--[[
if UNICODE
typedef FILE_IN_CABINET_INFO_W FILE_IN_CABINET_INFO;
typedef PFILE_IN_CABINET_INFO_W PFILE_IN_CABINET_INFO;
else
typedef FILE_IN_CABINET_INFO_A FILE_IN_CABINET_INFO;
typedef PFILE_IN_CABINET_INFO_A PFILE_IN_CABINET_INFO;
end
--]]

ffi.cdef[[
//
// Structure used for SPFILENOTIFY_***REGISTRATION
// callback
//

typedef struct _SP_REGISTER_CONTROL_STATUSA {
    DWORD    cbSize;
    PCSTR    FileName;
    DWORD    Win32Error;
    DWORD    FailureCode;
} SP_REGISTER_CONTROL_STATUSA, *PSP_REGISTER_CONTROL_STATUSA;

typedef struct _SP_REGISTER_CONTROL_STATUSW {
    DWORD    cbSize;
    PCWSTR   FileName;
    DWORD    Win32Error;
    DWORD    FailureCode;
} SP_REGISTER_CONTROL_STATUSW, *PSP_REGISTER_CONTROL_STATUSW;
]]

--[[
if UNICODE
typedef SP_REGISTER_CONTROL_STATUSW SP_REGISTER_CONTROL_STATUS;
typedef PSP_REGISTER_CONTROL_STATUSW PSP_REGISTER_CONTROL_STATUS;
else
typedef SP_REGISTER_CONTROL_STATUSA SP_REGISTER_CONTROL_STATUS;
typedef PSP_REGISTER_CONTROL_STATUSA PSP_REGISTER_CONTROL_STATUS;
end
--]]

ffi.cdef[[
static const int SPREG_SUCCESS  = 0x00000000;
static const int SPREG_LOADLIBRARY  = 0x00000001;
static const int SPREG_GETPROCADDR  = 0x00000002;
static const int SPREG_REGSVR       = 0x00000003;
static const int SPREG_DLLINSTALL   = 0x00000004;
static const int SPREG_TIMEOUT  = 0x00000005;
static const int SPREG_UNKNOWN  = 0xFFFFFFFF;
]]

ffi.cdef[[
//
// Define type for setup file queue
//
typedef PVOID HSPFILEQ;

//
// Structure used with SetupQueueCopyIndirect
//
typedef struct _SP_FILE_COPY_PARAMS_A {
    DWORD    cbSize;
    HSPFILEQ QueueHandle;
    PCSTR    SourceRootPath;     
    PCSTR    SourcePath;         
    PCSTR    SourceFilename;
    PCSTR    SourceDescription;  
    PCSTR    SourceTagfile;      
    PCSTR    TargetDirectory;
    PCSTR    TargetFilename;     
    DWORD    CopyStyle;
    HINF     LayoutInf;          
    PCSTR    SecurityDescriptor; 
} SP_FILE_COPY_PARAMS_A, *PSP_FILE_COPY_PARAMS_A;

typedef struct _SP_FILE_COPY_PARAMS_W {
    DWORD    cbSize;
    HSPFILEQ QueueHandle;
    PCWSTR   SourceRootPath;     
    PCWSTR   SourcePath;         
    PCWSTR   SourceFilename;
    PCWSTR   SourceDescription;  
    PCWSTR   SourceTagfile;      
    PCWSTR   TargetDirectory;
    PCWSTR   TargetFilename;     
    DWORD    CopyStyle;
    HINF     LayoutInf;          
    PCWSTR   SecurityDescriptor; 
} SP_FILE_COPY_PARAMS_W, *PSP_FILE_COPY_PARAMS_W;
]]

--[[
if UNICODE
typedef SP_FILE_COPY_PARAMS_W SP_FILE_COPY_PARAMS;
typedef PSP_FILE_COPY_PARAMS_W PSP_FILE_COPY_PARAMS;
else
typedef SP_FILE_COPY_PARAMS_A SP_FILE_COPY_PARAMS;
typedef PSP_FILE_COPY_PARAMS_A PSP_FILE_COPY_PARAMS;
end
--]]

ffi.cdef[[
//
// Define type for setup disk space list
//
typedef PVOID HDSKSPC;

//
// Define type for reference to device information set
//
typedef PVOID HDEVINFO;

//
// Device information structure (references a device instance
// that is a member of a device information set)
//
typedef struct _SP_DEVINFO_DATA {
    DWORD cbSize;
    GUID  ClassGuid;
    DWORD DevInst;    // DEVINST handle
    ULONG_PTR Reserved;
} SP_DEVINFO_DATA, *PSP_DEVINFO_DATA;

//
// Device interface information structure (references a device
// interface that is associated with the device information
// element that owns it).
//
typedef struct _SP_DEVICE_INTERFACE_DATA {
    DWORD cbSize;
    GUID  InterfaceClassGuid;
    DWORD Flags;
    ULONG_PTR Reserved;
} SP_DEVICE_INTERFACE_DATA, *PSP_DEVICE_INTERFACE_DATA;
]]


ffi.cdef[[
//
// Flags for SP_DEVICE_INTERFACE_DATA.Flags field.
//
static const int SPINT_ACTIVE  = 0x00000001;
static const int SPINT_DEFAULT = 0x00000002;
static const int SPINT_REMOVED = 0x00000004;
]]

--[[
//
// Backward compatibility--do not use.
//
typedef SP_DEVICE_INTERFACE_DATA  SP_INTERFACE_DEVICE_DATA;
typedef PSP_DEVICE_INTERFACE_DATA PSP_INTERFACE_DEVICE_DATA;
#define SPID_ACTIVE               SPINT_ACTIVE
#define SPID_DEFAULT              SPINT_DEFAULT
#define SPID_REMOVED              SPINT_REMOVED
--]]

ffi.cdef[[
typedef struct _SP_DEVICE_INTERFACE_DETAIL_DATA_A {
    DWORD  cbSize;
    CHAR   DevicePath[ANYSIZE_ARRAY];
} SP_DEVICE_INTERFACE_DETAIL_DATA_A, *PSP_DEVICE_INTERFACE_DETAIL_DATA_A;

typedef struct _SP_DEVICE_INTERFACE_DETAIL_DATA_W {
    DWORD  cbSize;
    WCHAR  DevicePath[ANYSIZE_ARRAY];
} SP_DEVICE_INTERFACE_DETAIL_DATA_W, *PSP_DEVICE_INTERFACE_DETAIL_DATA_W;
]]

--[[
if UNICODE
typedef SP_DEVICE_INTERFACE_DETAIL_DATA_W SP_DEVICE_INTERFACE_DETAIL_DATA;
typedef PSP_DEVICE_INTERFACE_DETAIL_DATA_W PSP_DEVICE_INTERFACE_DETAIL_DATA;
else
typedef SP_DEVICE_INTERFACE_DETAIL_DATA_A SP_DEVICE_INTERFACE_DETAIL_DATA;
typedef PSP_DEVICE_INTERFACE_DETAIL_DATA_A PSP_DEVICE_INTERFACE_DETAIL_DATA;
end
--]]

--[[
//
// Backward compatibility--do not use.
//
typedef SP_DEVICE_INTERFACE_DETAIL_DATA_W SP_INTERFACE_DEVICE_DETAIL_DATA_W;
typedef PSP_DEVICE_INTERFACE_DETAIL_DATA_W PSP_INTERFACE_DEVICE_DETAIL_DATA_W;
typedef SP_DEVICE_INTERFACE_DETAIL_DATA_A SP_INTERFACE_DEVICE_DETAIL_DATA_A;
typedef PSP_DEVICE_INTERFACE_DETAIL_DATA_A PSP_INTERFACE_DEVICE_DETAIL_DATA_A;
if UNICODE
typedef SP_INTERFACE_DEVICE_DETAIL_DATA_W SP_INTERFACE_DEVICE_DETAIL_DATA;
typedef PSP_INTERFACE_DEVICE_DETAIL_DATA_W PSP_INTERFACE_DEVICE_DETAIL_DATA;
else
typedef SP_INTERFACE_DEVICE_DETAIL_DATA_A SP_INTERFACE_DEVICE_DETAIL_DATA;
typedef PSP_INTERFACE_DEVICE_DETAIL_DATA_A PSP_INTERFACE_DEVICE_DETAIL_DATA;
end
--]]

ffi.cdef[[
//
// Structure for detailed information on a device information set (used for
// SetupDiGetDeviceInfoListDetail which supercedes the functionality of
// SetupDiGetDeviceInfoListClass).
//
typedef struct _SP_DEVINFO_LIST_DETAIL_DATA_A {
    DWORD  cbSize;
    GUID   ClassGuid;
    HANDLE RemoteMachineHandle;
    CHAR   RemoteMachineName[SP_MAX_MACHINENAME_LENGTH];
} SP_DEVINFO_LIST_DETAIL_DATA_A, *PSP_DEVINFO_LIST_DETAIL_DATA_A;

typedef struct _SP_DEVINFO_LIST_DETAIL_DATA_W {
    DWORD  cbSize;
    GUID   ClassGuid;
    HANDLE RemoteMachineHandle;
    WCHAR  RemoteMachineName[SP_MAX_MACHINENAME_LENGTH];
} SP_DEVINFO_LIST_DETAIL_DATA_W, *PSP_DEVINFO_LIST_DETAIL_DATA_W;
]]

--[[
if UNICODE
typedef SP_DEVINFO_LIST_DETAIL_DATA_W SP_DEVINFO_LIST_DETAIL_DATA;
typedef PSP_DEVINFO_LIST_DETAIL_DATA_W PSP_DEVINFO_LIST_DETAIL_DATA;
else
typedef SP_DEVINFO_LIST_DETAIL_DATA_A SP_DEVINFO_LIST_DETAIL_DATA;
typedef PSP_DEVINFO_LIST_DETAIL_DATA_A PSP_DEVINFO_LIST_DETAIL_DATA;
end
--]]

ffi.cdef[[
//
// Class installer function codes
//
static const int DIF_SELECTDEVICE                    = 0x00000001;
static const int DIF_INSTALLDEVICE                   = 0x00000002;
static const int DIF_ASSIGNRESOURCES                 = 0x00000003;
static const int DIF_PROPERTIES                      = 0x00000004;
static const int DIF_REMOVE                          = 0x00000005;
static const int DIF_FIRSTTIMESETUP                  = 0x00000006;
static const int DIF_FOUNDDEVICE                     = 0x00000007;
static const int DIF_SELECTCLASSDRIVERS              = 0x00000008;
static const int DIF_VALIDATECLASSDRIVERS            = 0x00000009;
static const int DIF_INSTALLCLASSDRIVERS             = 0x0000000A;
static const int DIF_CALCDISKSPACE                   = 0x0000000B;
static const int DIF_DESTROYPRIVATEDATA              = 0x0000000C;
static const int DIF_VALIDATEDRIVER                  = 0x0000000D;
static const int DIF_DETECT                          = 0x0000000F;
static const int DIF_INSTALLWIZARD                   = 0x00000010;
static const int DIF_DESTROYWIZARDDATA               = 0x00000011;
static const int DIF_PROPERTYCHANGE                  = 0x00000012;
static const int DIF_ENABLECLASS                     = 0x00000013;
static const int DIF_DETECTVERIFY                    = 0x00000014;
static const int DIF_INSTALLDEVICEFILES              = 0x00000015;
static const int DIF_UNREMOVE                        = 0x00000016;
static const int DIF_SELECTBESTCOMPATDRV             = 0x00000017;
static const int DIF_ALLOW_INSTALL                   = 0x00000018;
static const int DIF_REGISTERDEVICE                  = 0x00000019;
static const int DIF_NEWDEVICEWIZARD_PRESELECT       = 0x0000001A;
static const int DIF_NEWDEVICEWIZARD_SELECT          = 0x0000001B;
static const int DIF_NEWDEVICEWIZARD_PREANALYZE      = 0x0000001C;
static const int DIF_NEWDEVICEWIZARD_POSTANALYZE     = 0x0000001D;
static const int DIF_NEWDEVICEWIZARD_FINISHINSTALL   = 0x0000001E;
static const int DIF_UNUSED1                         = 0x0000001F;
static const int DIF_INSTALLINTERFACES               = 0x00000020;
static const int DIF_DETECTCANCEL                    = 0x00000021;
static const int DIF_REGISTER_COINSTALLERS           = 0x00000022;
static const int DIF_ADDPROPERTYPAGE_ADVANCED        = 0x00000023;
static const int DIF_ADDPROPERTYPAGE_BASIC           = 0x00000024;
static const int DIF_RESERVED1                       = 0x00000025;
static const int DIF_TROUBLESHOOTER                  = 0x00000026;
static const int DIF_POWERMESSAGEWAKE                = 0x00000027;
static const int DIF_ADDREMOTEPROPERTYPAGE_ADVANCED  = 0x00000028;
static const int DIF_UPDATEDRIVER_UI                 = 0x00000029;
static const int DIF_FINISHINSTALL_ACTION            = 0x0000002A;
static const int DIF_RESERVED2                       = 0x00000030;

//
// Obsoleted DIF codes (do not use)
//
static const int DIF_MOVEDEVICE                      = 0x0000000E;
]]

ffi.cdef[[
typedef UINT        DI_FUNCTION;    // Function type for device installer


//
// Device installation parameters structure (associated with a
// particular device information element, or globally with a device
// information set)
//
typedef struct _SP_DEVINSTALL_PARAMS_A {
    DWORD             cbSize;
    DWORD             Flags;
    DWORD             FlagsEx;
    HWND              hwndParent;
    PSP_FILE_CALLBACK_A InstallMsgHandler;
    PVOID             InstallMsgHandlerContext;
    HSPFILEQ          FileQueue;
    ULONG_PTR         ClassInstallReserved;
    DWORD             Reserved;
    CHAR              DriverPath[MAX_PATH];
} SP_DEVINSTALL_PARAMS_A, *PSP_DEVINSTALL_PARAMS_A;

typedef struct _SP_DEVINSTALL_PARAMS_W {
    DWORD             cbSize;
    DWORD             Flags;
    DWORD             FlagsEx;
    HWND              hwndParent;
    PSP_FILE_CALLBACK_W InstallMsgHandler;
    PVOID             InstallMsgHandlerContext;
    HSPFILEQ          FileQueue;
    ULONG_PTR         ClassInstallReserved;
    DWORD             Reserved;
    WCHAR             DriverPath[MAX_PATH];
} SP_DEVINSTALL_PARAMS_W, *PSP_DEVINSTALL_PARAMS_W;
]]

--[[
if UNICODE
typedef SP_DEVINSTALL_PARAMS_W SP_DEVINSTALL_PARAMS;
typedef PSP_DEVINSTALL_PARAMS_W PSP_DEVINSTALL_PARAMS;
else
typedef SP_DEVINSTALL_PARAMS_A SP_DEVINSTALL_PARAMS;
typedef PSP_DEVINSTALL_PARAMS_A PSP_DEVINSTALL_PARAMS;
end
--]]

ffi.cdef[[
//
// SP_DEVINSTALL_PARAMS.Flags values
//
// Flags for choosing a device
//
static const int DI_SHOWOEM                  = 0x00000001L;     // support Other... button
static const int DI_SHOWCOMPAT               = 0x00000002L;     // show compatibility list
static const int DI_SHOWCLASS                = 0x00000004L;     // show class list
static const int DI_SHOWALL                  = 0x00000007L;     // both class & compat list shown
static const int DI_NOVCP                    = 0x00000008L;     // dont create a new copy queue--use
                                                    // caller-supplied FileQueue
static const int DI_DIDCOMPAT                = 0x00000010L;     // Searched for compatible devices
static const int DI_DIDCLASS                 = 0x00000020L;     // Searched for class devices
static const int DI_AUTOASSIGNRES            = 0x00000040L;     // No UI for resources if possible

// flags returned by DiInstallDevice to indicate need to reboot/restart
static const int DI_NEEDRESTART              = 0x00000080L;     // Reboot required to take effect
static const int DI_NEEDREBOOT               = 0x00000100L;     // ""

// flags for device installation
static const int DI_NOBROWSE                 = 0x00000200L;     // no Browse... in InsertDisk

// Flags set by DiBuildDriverInfoList
static const int DI_MULTMFGS                 = 0x00000400L;     // Set if multiple manufacturers in
                                                    // class driver list

// Flag indicates that device is disabled
static const int DI_DISABLED                 = 0x00000800L;     // Set if device disabled

// Flags for Device/Class Properties
static const int DI_GENERALPAGE_ADDED        = 0x00001000L;
static const int DI_RESOURCEPAGE_ADDED       = 0x00002000L;

// Flag to indicate the setting properties for this Device (or class) caused a change
// so the Dev Mgr UI probably needs to be updatd.
static const int DI_PROPERTIES_CHANGE        = 0x00004000L;

// Flag to indicate that the sorting from the INF file should be used.
static const int DI_INF_IS_SORTED            = 0x00008000L;

// Flag to indicate that only the the INF specified by SP_DEVINSTALL_PARAMS.DriverPath
// should be searched.
static const int DI_ENUMSINGLEINF            = 0x00010000L;

// Flag that prevents ConfigMgr from removing/re-enumerating devices during device
// registration, installation, and deletion.
static const int DI_DONOTCALLCONFIGMG        = 0x00020000L;

// The following flag can be used to install a device disabled
static const int DI_INSTALLDISABLED          = 0x00040000L;

// Flag that causes SetupDiBuildDriverInfoList to build a device's compatible driver
// list from its existing class driver list, instead of the normal INF search.
static const int DI_COMPAT_FROM_CLASS        = 0x00080000L;

// This flag is set if the Class Install params should be used.
static const int DI_CLASSINSTALLPARAMS       = 0x00100000L;

// This flag is set if the caller of DiCallClassInstaller does NOT
// want the internal default action performed if the Class installer
// returns ERROR_DI_DO_DEFAULT.
static const int DI_NODI_DEFAULTACTION       = 0x00200000L;

// The setupx flag, DI_NOSYNCPROCESSING (= 0x00400000L) is not support in the Setup APIs.

// flags for device installation
static const int DI_QUIETINSTALL             = 0x00800000L;     // don't confuse the user with
                                                    // questions or excess info
static const int DI_NOFILECOPY               = 0x01000000L;     // No file Copy necessary
static const int DI_FORCECOPY                = 0x02000000L;     // Force files to be copied from install path
static const int DI_DRIVERPAGE_ADDED         = 0x04000000L;     // Prop provider added Driver page.
static const int DI_USECI_SELECTSTRINGS      = 0x08000000L;     // Use Class Installer Provided strings in the Select Device Dlg
static const int DI_OVERRIDE_INFFLAGS        = 0x10000000L;     // Override INF flags
static const int DI_PROPS_NOCHANGEUSAGE      = 0x20000000L;     // No Enable/Disable in General Props

static const int DI_NOSELECTICONS            = 0x40000000L;     // No small icons in select device dialogs

static const int DI_NOWRITE_IDS              = 0x80000000L;     // Don't write HW & Compat IDs on install
]]

ffi.cdef[[
//
// SP_DEVINSTALL_PARAMS.FlagsEx values
//

static const int DI_FLAGSEX_RESERVED2                = 0x00000001L;  // DI_FLAGSEX_USEOLDINFSEARCH is obsolete
static const int DI_FLAGSEX_RESERVED3                = 0x00000002L;  // DI_FLAGSEX_AUTOSELECTRANK0 is obsolete
static const int DI_FLAGSEX_CI_FAILED                = 0x00000004L;  // Failed to Load/Call class installer
]]

if _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN then
ffi.cdef[[
static const int DI_FLAGSEX_FINISHINSTALL_ACTION     = 0x00000008L;  // Class/co-installer wants to get a DIF_FINISH_INSTALL action in client context.
]]
end -- _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN

ffi.cdef[[
static const int DI_FLAGSEX_DIDINFOLIST              = 0x00000010L;  // Did the Class Info List
static const int DI_FLAGSEX_DIDCOMPATINFO            = 0x00000020L;  // Did the Compat Info List

static const int DI_FLAGSEX_FILTERCLASSES            = 0x00000040L;
static const int DI_FLAGSEX_SETFAILEDINSTALL         = 0x00000080L;
static const int DI_FLAGSEX_DEVICECHANGE             = 0x00000100L;
static const int DI_FLAGSEX_ALWAYSWRITEIDS           = 0x00000200L;
static const int DI_FLAGSEX_PROPCHANGE_PENDING       = 0x00000400L;  // One or more device property sheets have had changes made
                                                         // to them, and need to have a DIF_PROPERTYCHANGE occur.
static const int DI_FLAGSEX_ALLOWEXCLUDEDDRVS        = 0x00000800L;
static const int DI_FLAGSEX_NOUIONQUERYREMOVE        = 0x00001000L;
static const int DI_FLAGSEX_USECLASSFORCOMPAT        = 0x00002000L;  // Use the device's class when building compat drv list.
                                                         // (Ignored if DI_COMPAT_FROM_CLASS flag is specified.)

static const int DI_FLAGSEX_RESERVED4                = 0x00004000L;  // DI_FLAGSEX_OLDINF_IN_CLASSLIST is obsolete

static const int DI_FLAGSEX_NO_DRVREG_MODIFY         = 0x00008000L;  // Don't run AddReg and DelReg for device's software (driver) key.
static const int DI_FLAGSEX_IN_SYSTEM_SETUP          = 0x00010000L;  // Installation is occurring during initial system setup.
static const int DI_FLAGSEX_INET_DRIVER              = 0x00020000L;  // Driver came from Windows Update
static const int DI_FLAGSEX_APPENDDRIVERLIST         = 0x00040000L;  // Cause SetupDiBuildDriverInfoList to append
                                                         // a new driver list to an existing list.
static const int DI_FLAGSEX_PREINSTALLBACKUP         = 0x00080000L;  // not used
static const int DI_FLAGSEX_BACKUPONREPLACE          = 0x00100000L;  // not used
static const int DI_FLAGSEX_DRIVERLIST_FROM_URL      = 0x00200000L;  // build driver list from INF(s) retrieved from URL specified
                                                         // in SP_DEVINSTALL_PARAMS.DriverPath (empty string means
                                                         // Windows Update website)
static const int DI_FLAGSEX_RESERVED1                = 0x00400000L;
static const int DI_FLAGSEX_EXCLUDE_OLD_INET_DRIVERS = 0x00800000L;  // Don't include old Internet drivers when building
                                                         // a driver list.
                                                         // Ignored on Windows Vista and later.
static const int DI_FLAGSEX_POWERPAGE_ADDED          = 0x01000000L;  // class installer added their own power page
]]

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then
ffi.cdef[[
static const int DI_FLAGSEX_FILTERSIMILARDRIVERS     = 0x02000000L;  // only include similar drivers in class list
static const int DI_FLAGSEX_INSTALLEDDRIVER          = 0x04000000L;  // only add the installed driver to the class or compat
                                                         // driver list.  Used in calls to SetupDiBuildDriverInfoList
static const int DI_FLAGSEX_NO_CLASSLIST_NODE_MERGE  = 0x08000000L;  // Don't remove identical driver nodes from the class list
static const int DI_FLAGSEX_ALTPLATFORM_DRVSEARCH    = 0x10000000L;  // Build driver list based on alternate platform information
                                                         // specified in associated file queue
static const int DI_FLAGSEX_RESTART_DEVICE_ONLY      = 0x20000000L;  // only restart the device drivers are being installed on as
                                                         // opposed to restarting all devices using those drivers.
]]
end --// _SETUPAPI_VER >= _WIN32_WINNT_WINXP

if _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN then
ffi.cdef[[
static const int DI_FLAGSEX_RECURSIVESEARCH          = 0x40000000L;  // Tell SetupDiBuildDriverInfoList to do a recursive search
static const int DI_FLAGSEX_SEARCH_PUBLISHED_INFS    = 0x80000000L;  // Tell SetupDiBuildDriverInfoList to do a "published INF" search
]]
end -- _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN


ffi.cdef[[
//
// Class installation parameters header.  This must be the first field of any
// class install parameter structure.  The InstallFunction field must be set to
// the function code corresponding to the structure, and the cbSize field must
// be set to the size of the header structure.  E.g.,
//
// SP_ENABLECLASS_PARAMS EnableClassParams;
//
// EnableClassParams.ClassInstallHeader.cbSize = sizeof(SP_CLASSINSTALL_HEADER);
// EnableClassParams.ClassInstallHeader.InstallFunction = DIF_ENABLECLASS;
//
typedef struct _SP_CLASSINSTALL_HEADER {
    DWORD       cbSize;
    DI_FUNCTION InstallFunction;
} SP_CLASSINSTALL_HEADER, *PSP_CLASSINSTALL_HEADER;


//
// Structure corresponding to a DIF_ENABLECLASS install function.
//
typedef struct _SP_ENABLECLASS_PARAMS {
    SP_CLASSINSTALL_HEADER ClassInstallHeader;
    GUID                   ClassGuid;
    DWORD                  EnableMessage;
} SP_ENABLECLASS_PARAMS, *PSP_ENABLECLASS_PARAMS;

static const int ENABLECLASS_QUERY   =0;
static const int ENABLECLASS_SUCCESS =1;
static const int ENABLECLASS_FAILURE =2;


//
// Values indicating a change in a devices state
//
static const int DICS_ENABLE     = 0x00000001;
static const int DICS_DISABLE    = 0x00000002;
static const int DICS_PROPCHANGE = 0x00000003;
static const int DICS_START      = 0x00000004;
static const int DICS_STOP       = 0x00000005;
//
// Values specifying the scope of a device property change
//
static const int DICS_FLAG_GLOBAL        = 0x00000001;  // make change in all hardware profiles
static const int DICS_FLAG_CONFIGSPECIFIC= 0x00000002;  // make change in specified profile only
static const int DICS_FLAG_CONFIGGENERAL = 0x00000004;  // 1 or more hardware profile-specific
                                             // changes to follow.
//
// Structure corresponding to a DIF_PROPERTYCHANGE install function.
//
typedef struct _SP_PROPCHANGE_PARAMS {
    SP_CLASSINSTALL_HEADER ClassInstallHeader;
    DWORD                  StateChange;
    DWORD                  Scope;
    DWORD                  HwProfile;
} SP_PROPCHANGE_PARAMS, *PSP_PROPCHANGE_PARAMS;


//
// Structure corresponding to a DIF_REMOVE install function.
//
typedef struct _SP_REMOVEDEVICE_PARAMS {
    SP_CLASSINSTALL_HEADER ClassInstallHeader;
    DWORD Scope;
    DWORD HwProfile;
} SP_REMOVEDEVICE_PARAMS, *PSP_REMOVEDEVICE_PARAMS;

static const int DI_REMOVEDEVICE_GLOBAL                =  0x00000001;
static const int DI_REMOVEDEVICE_CONFIGSPECIFIC        =  0x00000002;


//
// Structure corresponding to a DIF_UNREMOVE install function.
//
typedef struct _SP_UNREMOVEDEVICE_PARAMS {
    SP_CLASSINSTALL_HEADER ClassInstallHeader;
    DWORD Scope;
    DWORD HwProfile;
} SP_UNREMOVEDEVICE_PARAMS, *PSP_UNREMOVEDEVICE_PARAMS;

static const int DI_UNREMOVEDEVICE_CONFIGSPECIFIC      =  0x00000002;


//
// Structure corresponding to a DIF_SELECTDEVICE install function.
//
typedef struct _SP_SELECTDEVICE_PARAMS_A {
    SP_CLASSINSTALL_HEADER ClassInstallHeader;
    CHAR                   Title[MAX_TITLE_LEN];
    CHAR                   Instructions[MAX_INSTRUCTION_LEN];
    CHAR                   ListLabel[MAX_LABEL_LEN];
    CHAR                   SubTitle[MAX_SUBTITLE_LEN];
    BYTE                   Reserved[2];                  // DWORD size alignment
} SP_SELECTDEVICE_PARAMS_A, *PSP_SELECTDEVICE_PARAMS_A;

typedef struct _SP_SELECTDEVICE_PARAMS_W {
    SP_CLASSINSTALL_HEADER ClassInstallHeader;
    WCHAR                  Title[MAX_TITLE_LEN];
    WCHAR                  Instructions[MAX_INSTRUCTION_LEN];
    WCHAR                  ListLabel[MAX_LABEL_LEN];
    WCHAR                  SubTitle[MAX_SUBTITLE_LEN];
} SP_SELECTDEVICE_PARAMS_W, *PSP_SELECTDEVICE_PARAMS_W;
]]

if UNICODE then
ffi.cdef[[
typedef SP_SELECTDEVICE_PARAMS_W SP_SELECTDEVICE_PARAMS;
typedef PSP_SELECTDEVICE_PARAMS_W PSP_SELECTDEVICE_PARAMS;
]]
else
ffi.cdef[[
typedef SP_SELECTDEVICE_PARAMS_A SP_SELECTDEVICE_PARAMS;
typedef PSP_SELECTDEVICE_PARAMS_A PSP_SELECTDEVICE_PARAMS;
]]
end

ffi.cdef[[
//
// Callback routine for giving progress notification during detection
//
typedef BOOL (__stdcall* PDETECT_PROGRESS_NOTIFY)(
      PVOID ProgressNotifyParam,
      DWORD DetectComplete
     );

// where:
//     ProgressNotifyParam - value supplied by caller requesting detection.
//     DetectComplete - Percent completion, to be incremented by class
//                      installer, as it steps thru its detection.
//
// Return Value - If TRUE, then detection is cancelled.  Allows caller
//                requesting detection to stop detection asap.
//

//
// Structure corresponding to a DIF_DETECT install function.
//
typedef struct _SP_DETECTDEVICE_PARAMS {
    SP_CLASSINSTALL_HEADER  ClassInstallHeader;
    PDETECT_PROGRESS_NOTIFY DetectProgressNotify;
    PVOID                   ProgressNotifyParam;
} SP_DETECTDEVICE_PARAMS, *PSP_DETECTDEVICE_PARAMS;
]]

ffi.cdef[[
//
// 'Add New Device' installation wizard structure (backward-compatibility
// only--respond to DIF_NEWDEVICEWIZARD_* requests instead).
//
// Structure corresponding to a DIF_INSTALLWIZARD install function.
// (NOTE: This structure is also applicable for DIF_DESTROYWIZARDDATA,
// but DIF_INSTALLWIZARD is the associated function code in the class
// installation parameter structure in both cases.)
//
// Define maximum number of dynamic wizard pages that can be added to
// hardware install wizard.
//
static const int MAX_INSTALLWIZARD_DYNAPAGES            = 20;

typedef struct _SP_INSTALLWIZARD_DATA {
    SP_CLASSINSTALL_HEADER ClassInstallHeader;
    DWORD                  Flags;
    HPROPSHEETPAGE         DynamicPages[MAX_INSTALLWIZARD_DYNAPAGES];
    DWORD                  NumDynamicPages;
    DWORD                  DynamicPageFlags;
    DWORD                  PrivateFlags;
    LPARAM                 PrivateData;
    HWND                   hwndWizardDlg;
} SP_INSTALLWIZARD_DATA, *PSP_INSTALLWIZARD_DATA;
]]

ffi.cdef[[
static const int NDW_INSTALLFLAG_DIDFACTDEFS        = 0x00000001;
static const int NDW_INSTALLFLAG_HARDWAREALLREADYIN = 0x00000002;
static const int NDW_INSTALLFLAG_NEEDRESTART        = DI_NEEDRESTART;
static const int NDW_INSTALLFLAG_NEEDREBOOT         = DI_NEEDREBOOT;
static const int NDW_INSTALLFLAG_NEEDSHUTDOWN       = 0x00000200;
static const int NDW_INSTALLFLAG_EXPRESSINTRO       = 0x00000400;
static const int NDW_INSTALLFLAG_SKIPISDEVINSTALLED = 0x00000800;
static const int NDW_INSTALLFLAG_NODETECTEDDEVS     = 0x00001000;
static const int NDW_INSTALLFLAG_INSTALLSPECIFIC    = 0x00002000;
static const int NDW_INSTALLFLAG_SKIPCLASSLIST      = 0x00004000;
static const int NDW_INSTALLFLAG_CI_PICKED_OEM      = 0x00008000;
static const int NDW_INSTALLFLAG_PCMCIAMODE         = 0x00010000;
static const int NDW_INSTALLFLAG_PCMCIADEVICE       = 0x00020000;
static const int NDW_INSTALLFLAG_USERCANCEL         = 0x00040000;
static const int NDW_INSTALLFLAG_KNOWNCLASS         = 0x00080000;

static const int DYNAWIZ_FLAG_PAGESADDED            = 0x00000001;

static const int DYNAWIZ_FLAG_ANALYZE_HANDLECONFLICT =0x00000008;

static const int DYNAWIZ_FLAG_INSTALLDET_NEXT      =  0x00000002;
static const int DYNAWIZ_FLAG_INSTALLDET_PREV      =  0x00000004;

static const int MIN_IDD_DYNAWIZ_RESOURCE_ID            = 10000;
static const int MAX_IDD_DYNAWIZ_RESOURCE_ID            = 11000;


static const int IDD_DYNAWIZ_FIRSTPAGE                  = 10000;
static const int IDD_DYNAWIZ_SELECT_PREVPAGE            = 10001;
static const int IDD_DYNAWIZ_SELECT_NEXTPAGE            = 10002;
static const int IDD_DYNAWIZ_ANALYZE_PREVPAGE           = 10003;
static const int IDD_DYNAWIZ_ANALYZE_NEXTPAGE           = 10004;
static const int IDD_DYNAWIZ_SELECTDEV_PAGE             = 10009;
static const int IDD_DYNAWIZ_ANALYZEDEV_PAGE            = 10010;
static const int IDD_DYNAWIZ_INSTALLDETECTEDDEVS_PAGE   = 10011;
static const int IDD_DYNAWIZ_SELECTCLASS_PAGE           = 10012;


static const int IDD_DYNAWIZ_INSTALLDETECTED_PREVPAGE   = 10006;
static const int IDD_DYNAWIZ_INSTALLDETECTED_NEXTPAGE   = 10007;
static const int IDD_DYNAWIZ_INSTALLDETECTED_NODEVS     = 10008;
]]

ffi.cdef[[
//
// Structure corresponding to the following DIF_NEWDEVICEWIZARD_* install
// functions:
//
//     DIF_NEWDEVICEWIZARD_PRESELECT
//     DIF_NEWDEVICEWIZARD_SELECT
//     DIF_NEWDEVICEWIZARD_PREANALYZE
//     DIF_NEWDEVICEWIZARD_POSTANALYZE
//     DIF_NEWDEVICEWIZARD_FINISHINSTALL
//
typedef struct _SP_NEWDEVICEWIZARD_DATA {
    SP_CLASSINSTALL_HEADER ClassInstallHeader;
    DWORD                  Flags;   // presently unused--must be zero.
    HPROPSHEETPAGE         DynamicPages[MAX_INSTALLWIZARD_DYNAPAGES];
    DWORD                  NumDynamicPages;
    HWND                   hwndWizardDlg;
} SP_NEWDEVICEWIZARD_DATA, *PSP_NEWDEVICEWIZARD_DATA;

//
// The same structure is also used for retrieval of property pages via the
// following install functions:
//
//     DIF_ADDPROPERTYPAGE_ADVANCED
//     DIF_ADDPROPERTYPAGE_BASIC
//     DIF_ADDREMOTEPROPERTYPAGE_ADVANCED
//
typedef SP_NEWDEVICEWIZARD_DATA SP_ADDPROPERTYPAGE_DATA;
typedef PSP_NEWDEVICEWIZARD_DATA PSP_ADDPROPERTYPAGE_DATA;


//
// Structure corresponding to the DIF_TROUBLESHOOTER install function
//
typedef struct _SP_TROUBLESHOOTER_PARAMS_A {
    SP_CLASSINSTALL_HEADER ClassInstallHeader;
    CHAR                   ChmFile[MAX_PATH];
    CHAR                   HtmlTroubleShooter[MAX_PATH];
} SP_TROUBLESHOOTER_PARAMS_A, *PSP_TROUBLESHOOTER_PARAMS_A;

typedef struct _SP_TROUBLESHOOTER_PARAMS_W {
    SP_CLASSINSTALL_HEADER ClassInstallHeader;
    WCHAR                  ChmFile[MAX_PATH];
    WCHAR                  HtmlTroubleShooter[MAX_PATH];
} SP_TROUBLESHOOTER_PARAMS_W, *PSP_TROUBLESHOOTER_PARAMS_W;
]]

if UNICODE then
ffi.cdef[[
typedef SP_TROUBLESHOOTER_PARAMS_W SP_TROUBLESHOOTER_PARAMS;
typedef PSP_TROUBLESHOOTER_PARAMS_W PSP_TROUBLESHOOTER_PARAMS;
]]
else
ffi.cdef[[
typedef SP_TROUBLESHOOTER_PARAMS_A SP_TROUBLESHOOTER_PARAMS;
typedef PSP_TROUBLESHOOTER_PARAMS_A PSP_TROUBLESHOOTER_PARAMS;
]]
end

ffi.cdef[[
//
// Structure corresponding to the DIF_POWERMESSAGEWAKE install function
//
typedef struct _SP_POWERMESSAGEWAKE_PARAMS_A {
    SP_CLASSINSTALL_HEADER ClassInstallHeader;
    CHAR                   PowerMessageWake[LINE_LEN*2];
} SP_POWERMESSAGEWAKE_PARAMS_A, *PSP_POWERMESSAGEWAKE_PARAMS_A;

typedef struct _SP_POWERMESSAGEWAKE_PARAMS_W {
    SP_CLASSINSTALL_HEADER ClassInstallHeader;
    WCHAR                  PowerMessageWake[LINE_LEN*2];
} SP_POWERMESSAGEWAKE_PARAMS_W, *PSP_POWERMESSAGEWAKE_PARAMS_W;
]]

if UNICODE then
ffi.cdef[[
typedef SP_POWERMESSAGEWAKE_PARAMS_W SP_POWERMESSAGEWAKE_PARAMS;
typedef PSP_POWERMESSAGEWAKE_PARAMS_W PSP_POWERMESSAGEWAKE_PARAMS;
]]
else
ffi.cdef[[
typedef SP_POWERMESSAGEWAKE_PARAMS_A SP_POWERMESSAGEWAKE_PARAMS;
typedef PSP_POWERMESSAGEWAKE_PARAMS_A PSP_POWERMESSAGEWAKE_PARAMS;
]]
end

ffi.cdef[[
//
// Driver information structure (member of a driver info list that may be associated
// with a particular device instance, or (globally) with a device information set)
//
typedef struct _SP_DRVINFO_DATA_V2_A {
    DWORD     cbSize;
    DWORD     DriverType;
    ULONG_PTR Reserved;
    CHAR      Description[LINE_LEN];
    CHAR      MfgName[LINE_LEN];
    CHAR      ProviderName[LINE_LEN];
    FILETIME  DriverDate;
    DWORDLONG DriverVersion;
} SP_DRVINFO_DATA_V2_A, *PSP_DRVINFO_DATA_V2_A;

typedef struct _SP_DRVINFO_DATA_V2_W {
    DWORD     cbSize;
    DWORD     DriverType;
    ULONG_PTR Reserved;
    WCHAR     Description[LINE_LEN];
    WCHAR     MfgName[LINE_LEN];
    WCHAR     ProviderName[LINE_LEN];
    FILETIME  DriverDate;
    DWORDLONG DriverVersion;
} SP_DRVINFO_DATA_V2_W, *PSP_DRVINFO_DATA_V2_W;

//
// Version 1 of the SP_DRVINFO_DATA structures, used only for compatibility
// with Windows NT 4.0/Windows 95/98 SETUPAPI.DLL
//
typedef struct _SP_DRVINFO_DATA_V1_A {
    DWORD     cbSize;
    DWORD     DriverType;
    ULONG_PTR Reserved;
    CHAR      Description[LINE_LEN];
    CHAR      MfgName[LINE_LEN];
    CHAR      ProviderName[LINE_LEN];
} SP_DRVINFO_DATA_V1_A, *PSP_DRVINFO_DATA_V1_A;

typedef struct _SP_DRVINFO_DATA_V1_W {
    DWORD     cbSize;
    DWORD     DriverType;
    ULONG_PTR Reserved;
    WCHAR     Description[LINE_LEN];
    WCHAR     MfgName[LINE_LEN];
    WCHAR     ProviderName[LINE_LEN];
} SP_DRVINFO_DATA_V1_W, *PSP_DRVINFO_DATA_V1_W;
]]

if UNICODE then
ffi.cdef[[
typedef SP_DRVINFO_DATA_V1_W SP_DRVINFO_DATA_V1;
typedef PSP_DRVINFO_DATA_V1_W PSP_DRVINFO_DATA_V1;
typedef SP_DRVINFO_DATA_V2_W SP_DRVINFO_DATA_V2;
typedef PSP_DRVINFO_DATA_V2_W PSP_DRVINFO_DATA_V2;
]]
else
ffi.cdef[[
typedef SP_DRVINFO_DATA_V1_A SP_DRVINFO_DATA_V1;
typedef PSP_DRVINFO_DATA_V1_A PSP_DRVINFO_DATA_V1;
typedef SP_DRVINFO_DATA_V2_A SP_DRVINFO_DATA_V2;
typedef PSP_DRVINFO_DATA_V2_A PSP_DRVINFO_DATA_V2;
]]
end

if USE_SP_DRVINFO_DATA_V1 or (_SETUPAPI_VER < _WIN32_WINNT_WIN2K)  then  --// use version 1 driver info data structure
ffi.cdef[[
typedef SP_DRVINFO_DATA_V1_A SP_DRVINFO_DATA_A;
typedef PSP_DRVINFO_DATA_V1_A PSP_DRVINFO_DATA_A;
typedef SP_DRVINFO_DATA_V1_W SP_DRVINFO_DATA_W;
typedef PSP_DRVINFO_DATA_V1_W PSP_DRVINFO_DATA_W;
typedef SP_DRVINFO_DATA_V1 SP_DRVINFO_DATA;
typedef PSP_DRVINFO_DATA_V1 PSP_DRVINFO_DATA;
]]
else                      -- // use version 2 driver info data structure
ffi.cdef[[
typedef SP_DRVINFO_DATA_V2_A SP_DRVINFO_DATA_A;
typedef PSP_DRVINFO_DATA_V2_A PSP_DRVINFO_DATA_A;
typedef SP_DRVINFO_DATA_V2_W SP_DRVINFO_DATA_W;
typedef PSP_DRVINFO_DATA_V2_W PSP_DRVINFO_DATA_W;
typedef SP_DRVINFO_DATA_V2 SP_DRVINFO_DATA;
typedef PSP_DRVINFO_DATA_V2 PSP_DRVINFO_DATA;
]]
end  --// use current version of driver info data structure

ffi.cdef[[
//
// Driver information details structure (provides detailed information about a
// particular driver information structure)
//
typedef struct _SP_DRVINFO_DETAIL_DATA_A {
    DWORD    cbSize;
    FILETIME InfDate;
    DWORD    CompatIDsOffset;
    DWORD    CompatIDsLength;
    ULONG_PTR Reserved;
    CHAR     SectionName[LINE_LEN];
    CHAR     InfFileName[MAX_PATH];
    CHAR     DrvDescription[LINE_LEN];
    CHAR     HardwareID[ANYSIZE_ARRAY];
} SP_DRVINFO_DETAIL_DATA_A, *PSP_DRVINFO_DETAIL_DATA_A;

typedef struct _SP_DRVINFO_DETAIL_DATA_W {
    DWORD    cbSize;
    FILETIME InfDate;
    DWORD    CompatIDsOffset;
    DWORD    CompatIDsLength;
    ULONG_PTR Reserved;
    WCHAR    SectionName[LINE_LEN];
    WCHAR    InfFileName[MAX_PATH];
    WCHAR    DrvDescription[LINE_LEN];
    WCHAR    HardwareID[ANYSIZE_ARRAY];
} SP_DRVINFO_DETAIL_DATA_W, *PSP_DRVINFO_DETAIL_DATA_W;
]]

if UNICODE then
ffi.cdef[[
typedef SP_DRVINFO_DETAIL_DATA_W SP_DRVINFO_DETAIL_DATA;
typedef PSP_DRVINFO_DETAIL_DATA_W PSP_DRVINFO_DETAIL_DATA;
]]
else
ffi.cdef[[
typedef SP_DRVINFO_DETAIL_DATA_A SP_DRVINFO_DETAIL_DATA;
typedef PSP_DRVINFO_DETAIL_DATA_A PSP_DRVINFO_DETAIL_DATA;
]]
end

ffi.cdef[[
//
// Driver installation parameters (associated with a particular driver
// information element)
//
typedef struct _SP_DRVINSTALL_PARAMS {
    DWORD cbSize;
    DWORD Rank;
    DWORD Flags;
    DWORD_PTR PrivateData;
    DWORD Reserved;
} SP_DRVINSTALL_PARAMS, *PSP_DRVINSTALL_PARAMS;
]]

--[=[
//
// SP_DRVINSTALL_PARAMS.Flags values
//

#define DNF_DUPDESC             0x00000001  // Multiple providers have same desc
#define DNF_OLDDRIVER           0x00000002  // Driver node specifies old/current driver
#define DNF_EXCLUDEFROMLIST     0x00000004  // If set, this driver node will not be
                                            // displayed in any driver select dialogs.
#define DNF_NODRIVER            0x00000008  // if we want to install no driver
                                            // (e.g no mouse drv)
#define DNF_LEGACYINF           0x00000010  // Driver node came from an old-style INF (obsolete)
#define DNF_CLASS_DRIVER        0x00000020  // Driver node represents a class driver
#define DNF_COMPATIBLE_DRIVER   0x00000040  // Driver node represents a compatible driver
#define DNF_INET_DRIVER         0x00000080  // Driver comes from an internet source
#define DNF_UNUSED1             0x00000100
#define DNF_UNUSED2             0x00000200
#define DNF_OLD_INET_DRIVER     0x00000400  // Driver came from the Internet, but we don't currently
                                            // have access to it's source files.  Never attempt to
                                            // install a driver with this flag!
                                            // Note used on Windows Vista and Later.
#define DNF_BAD_DRIVER          0x00000800  // Driver node should not be used at all
#define DNF_DUPPROVIDER         0x00001000  // Multiple drivers have the same provider and desc

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then
#define DNF_INF_IS_SIGNED         0x00002000  // If file is digitally signed
#define DNF_OEM_F6_INF            0x00004000  // INF specified from F6 during textmode setup.
#define DNF_DUPDRIVERVER          0x00008000  // Multipe drivers have the same desc, provider, and DriverVer values
#define DNF_BASIC_DRIVER          0x00010000  // Driver provides basic functionality, but should
                                              // not be chosen if other signed drivers exist.
end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP

#if _SETUPAPI_VER >= _WIN32_WINNT_WS03
#define DNF_AUTHENTICODE_SIGNED   0x00020000  // Inf file is signed by an Authenticode(tm) catalog.
end -- _SETUPAPI_VER >= _WIN32_WINNT_WS03

#if _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN
#define DNF_INSTALLEDDRIVER       0x00040000  // This driver node is currently installed on the device.
#define DNF_ALWAYSEXCLUDEFROMLIST 0x00080000  // If set, this driver is not even displayed in 
                                              // alternative platform either.
#define DNF_INBOX_DRIVER          0x00100000  // This driver node came from an INF that shipped with Windows.
end -- _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN

#if _SETUPAPI_VER >= _WIN32_WINNT_WIN7
#define DNF_REQUESTADDITIONALSOFTWARE   0x00200000  // This driver is only part of a software solution needed
                                                    // by this device
end -- _SETUPAPI_VER >= _WIN32_WINNT_WIN7

#define DNF_UNUSED_22            = 0x00400000;
#define DNF_UNUSED_23            = 0x00800000;
#define DNF_UNUSED_24            = 0x01000000;
#define DNF_UNUSED_25            = 0x02000000;
#define DNF_UNUSED_26            = 0x04000000;
#define DNF_UNUSED_27            = 0x08000000;
#define DNF_UNUSED_28            = 0x10000000;
#define DNF_UNUSED_29            = 0x20000000;
#define DNF_UNUSED_30            = 0x40000000;
#define DNF_UNUSED_31            = 0x80000000;
--]=]

--[=[
//
// Rank values (the lower the Rank number, the better the Rank)
//
#if _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN
#define DRIVER_HARDWAREID_RANK  0x00000FFF  // Any rank less than or equal to
                                            // this value is a gold
                                            // HardwareID match

#define DRIVER_HARDWAREID_MASK  0x80000FFF  // If you mask these bits off (AND)
                                            // from the Rank and the result is 0
                                            // then the Rank is a trusted HardwareID
                                            // match

#define DRIVER_UNTRUSTED_RANK   0x80000000  // Any rank with this bit set is an
                                            // "untrusted" rank, meaning that
                                            // the INF was unsigned.

#define DRIVER_W9X_SUSPECT_RANK 0xC0000000  // Any rank that is greater than
                                            // or equal to this value, and lesser
                                            // than or equal to 0xFFFF is suspected
                                            // to be a Win9x-only driver, because
                                            // (a) it isn't signed, and (b) there
                                            // is no NT-specific decoration to
                                            // explicitly indicate that the INF
                                            // supports Windows NT/2000/XP

else
#define DRIVER_HARDWAREID_RANK  0x00000FFF  // Any rank less than or equal to
                                            // this value is a trusted
                                            // HardwareID match

#define DRIVER_COMPATID_RANK    0x00003FFF  // Any rank less than or equal to
                                            // this (and greater than
                                            // DRIVER_HARDWAREID_RANK) is a
                                            // trusted CompatibleID match

#define DRIVER_UNTRUSTED_RANK   0x00008000  // Any rank with this bit set is an
                                            // "untrusted" rank, meaning that
                                            // the INF was unsigned.

#define DRIVER_UNTRUSTED_HARDWAREID_RANK  0x00008FFF  // Any rank less than or equal to
                                                      // this value (and greater than
                                                      // or equal to DRIVER_UNTRUSTED_RANK)
                                                      // is an untrusted HardwareID match

#define DRIVER_UNTRUSTED_COMPATID_RANK    0x0000BFFF  // Any rank less than or equal to
                                                      // this value (and greater than
                                                      // DRIVER_UNTRUSTED_HARDWAREID_RANK)
                                                      // is an untrusted CompatibleID match

#define DRIVER_W9X_SUSPECT_RANK            0x0000C000 // Any rank that is greater than
                                                      // or equal to this value, and lesser
                                                      // than or equal to 0xFFFF is suspected
                                                      // to be a Win9x-only driver, because
                                                      // (a) it isn't signed, and (b) there
                                                      // is no NT-specific decoration to
                                                      // explicitly indicate that the INF
                                                      // supports Windows NT/2000/XP

#define DRIVER_W9X_SUSPECT_HARDWAREID_RANK 0x0000CFFF // Any rank less than or equal to this
                                                      // (and greater than or equal to
                                                      // DRIVER_W9X_SUSPECT_RANK) is a
                                                      // hardware ID match suspected of being
                                                      // only for Windows 9x platforms.

#define DRIVER_W9X_SUSPECT_COMPATID_RANK   0x0000FFFF // Any rank less than or equal to
                                                      // this (and greater than
                                                      // DRIVER_W9X_SUSPECT_HARDWAREID_RANK)
                                                      // is a compatible ID match suspected
                                                      // of being only for Windows 9x
                                                      // platforms.
end -- _SETUPAPI_VER < _WIN32_WINNT_LONGHORN
--]=]

ffi.cdef[[
//
// Setup callback routine for comparing detection signatures
//
typedef DWORD (__stdcall* PSP_DETSIG_CMPPROC)(
     HDEVINFO         DeviceInfoSet,
     PSP_DEVINFO_DATA NewDeviceData,
     PSP_DEVINFO_DATA ExistingDeviceData,
     PVOID            CompareContext      
    );


//
// Define context structure handed to co-installers
//
typedef struct _COINSTALLER_CONTEXT_DATA {
    BOOL  PostProcessing;
    DWORD InstallResult;
    PVOID PrivateData;
} COINSTALLER_CONTEXT_DATA, *PCOINSTALLER_CONTEXT_DATA;


//
// Structure containing class image list information.
//
typedef struct _SP_CLASSIMAGELIST_DATA {
    DWORD      cbSize;
    HIMAGELIST ImageList;
    ULONG_PTR  Reserved;
} SP_CLASSIMAGELIST_DATA, *PSP_CLASSIMAGELIST_DATA;


//
// Structure to be passed as first parameter (LPVOID lpv) to ExtensionPropSheetPageProc
// entry point in setupapi.dll or to "EnumPropPages32" or "BasicProperties32" entry
// points provided by class/device property page providers.  Used to retrieve a handle
// (or, potentially, multiple handles) to property pages for a specified property page type.
//
typedef struct _SP_PROPSHEETPAGE_REQUEST {
    DWORD            cbSize;
    DWORD            PageRequested;
    HDEVINFO         DeviceInfoSet;
    PSP_DEVINFO_DATA DeviceInfoData;
} SP_PROPSHEETPAGE_REQUEST, *PSP_PROPSHEETPAGE_REQUEST;
]]

ffi.cdef[[
//
// Property sheet codes used in SP_PROPSHEETPAGE_REQUEST.PageRequested
//
static const int SPPSR_SELECT_DEVICE_RESOURCES      = 1;    // supplied by setupapi.dll
static const int SPPSR_ENUM_BASIC_DEVICE_PROPERTIES = 2;    // supplied by device's BasicProperties32 provider
static const int SPPSR_ENUM_ADV_DEVICE_PROPERTIES   = 3;    // supplied by class and/or device's EnumPropPages32 provider


//
// Structure used with SetupGetBackupInformation/SetupSetBackupInformation
//
typedef struct _SP_BACKUP_QUEUE_PARAMS_V2_A {
    DWORD    cbSize;                            // size of structure
    CHAR     FullInfPath[MAX_PATH];             // buffer to hold ANSI pathname of INF file
    INT      FilenameOffset;                    // offset in CHARs of filename part (after "\"")
    CHAR     ReinstallInstance[MAX_PATH];       // Instance ID (if present)
} SP_BACKUP_QUEUE_PARAMS_V2_A, *PSP_BACKUP_QUEUE_PARAMS_V2_A;

typedef struct _SP_BACKUP_QUEUE_PARAMS_V2_W {
    DWORD    cbSize;                            // size of structure
    WCHAR    FullInfPath[MAX_PATH];             // buffer to hold UNICODE pathname of INF file
    INT      FilenameOffset;                    // offset in WCHARs of filename part (after "\"")
    WCHAR    ReinstallInstance[MAX_PATH];       // Instance ID (if present)
} SP_BACKUP_QUEUE_PARAMS_V2_W, *PSP_BACKUP_QUEUE_PARAMS_V2_W;

//
// Version 1 of the SP_BACKUP_QUEUE_PARAMS structures, used only for compatibility
// with Windows 2000/Windows 95/98/ME SETUPAPI.DLL
//
typedef struct _SP_BACKUP_QUEUE_PARAMS_V1_A {
    DWORD    cbSize;                            // size of structure
    CHAR     FullInfPath[MAX_PATH];             // buffer to hold ANSI pathname of INF file
    INT      FilenameOffset;                    // offset in CHARs of filename part (after "\"")
} SP_BACKUP_QUEUE_PARAMS_V1_A, *PSP_BACKUP_QUEUE_PARAMS_V1_A;

typedef struct _SP_BACKUP_QUEUE_PARAMS_V1_W {
    DWORD    cbSize;                            // size of structure
    WCHAR    FullInfPath[MAX_PATH];             // buffer to hold UNICODE pathname of INF file
    INT      FilenameOffset;                    // offset in WCHARs of filename part (after "\"")
} SP_BACKUP_QUEUE_PARAMS_V1_W, *PSP_BACKUP_QUEUE_PARAMS_V1_W;
]]

if UNICODE then
ffi.cdef[[
typedef SP_BACKUP_QUEUE_PARAMS_V1_W SP_BACKUP_QUEUE_PARAMS_V1;
typedef PSP_BACKUP_QUEUE_PARAMS_V1_W PSP_BACKUP_QUEUE_PARAMS_V1;
typedef SP_BACKUP_QUEUE_PARAMS_V2_W SP_BACKUP_QUEUE_PARAMS_V2;
typedef PSP_BACKUP_QUEUE_PARAMS_V2_W PSP_BACKUP_QUEUE_PARAMS_V2;
]]
else
ffi.cdef[[
typedef SP_BACKUP_QUEUE_PARAMS_V1_A SP_BACKUP_QUEUE_PARAMS_V1;
typedef PSP_BACKUP_QUEUE_PARAMS_V1_A PSP_BACKUP_QUEUE_PARAMS_V1;
typedef SP_BACKUP_QUEUE_PARAMS_V2_A SP_BACKUP_QUEUE_PARAMS_V2;
typedef PSP_BACKUP_QUEUE_PARAMS_V2_A PSP_BACKUP_QUEUE_PARAMS_V2;
]]
end

--[=[
#if USE_SP_BACKUP_QUEUE_PARAMS_V1 || (_SETUPAPI_VER < _WIN32_WINNT_WINXP)  // use version 1 driver info data structure

typedef SP_BACKUP_QUEUE_PARAMS_V1_A SP_BACKUP_QUEUE_PARAMS_A;
typedef PSP_BACKUP_QUEUE_PARAMS_V1_A PSP_BACKUP_QUEUE_PARAMS_A;
typedef SP_BACKUP_QUEUE_PARAMS_V1_W SP_BACKUP_QUEUE_PARAMS_W;
typedef PSP_BACKUP_QUEUE_PARAMS_V1_W PSP_BACKUP_QUEUE_PARAMS_W;
typedef SP_BACKUP_QUEUE_PARAMS_V1 SP_BACKUP_QUEUE_PARAMS;
typedef PSP_BACKUP_QUEUE_PARAMS_V1 PSP_BACKUP_QUEUE_PARAMS;

else                       // use version 2 driver info data structure

typedef SP_BACKUP_QUEUE_PARAMS_V2_A SP_BACKUP_QUEUE_PARAMS_A;
typedef PSP_BACKUP_QUEUE_PARAMS_V2_A PSP_BACKUP_QUEUE_PARAMS_A;
typedef SP_BACKUP_QUEUE_PARAMS_V2_W SP_BACKUP_QUEUE_PARAMS_W;
typedef PSP_BACKUP_QUEUE_PARAMS_V2_W PSP_BACKUP_QUEUE_PARAMS_W;
typedef SP_BACKUP_QUEUE_PARAMS_V2 SP_BACKUP_QUEUE_PARAMS;
typedef PSP_BACKUP_QUEUE_PARAMS_V2 PSP_BACKUP_QUEUE_PARAMS;

end  // use current version of driver info data structure
--]=]




--[=[
#ifndef _SPAPI_ERRORS
#define _SPAPI_ERRORS

//
// Setupapi-specific error codes
//
// Inf parse outcomes
//
#define ERROR_EXPECTED_SECTION_NAME  (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0)
#define ERROR_BAD_SECTION_NAME_LINE  (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|1)
#define ERROR_SECTION_NAME_TOO_LONG  (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|2)
#define ERROR_GENERAL_SYNTAX         (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|3)
//
// Inf runtime errors
//
#define ERROR_WRONG_INF_STYLE        (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x100)
#define ERROR_SECTION_NOT_FOUND      (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x101)
#define ERROR_LINE_NOT_FOUND         (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x102)
#define ERROR_NO_BACKUP              (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x103)
//
// Device Installer/other errors
//
#define ERROR_NO_ASSOCIATED_CLASS                (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x200)
#define ERROR_CLASS_MISMATCH                     (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x201)
#define ERROR_DUPLICATE_FOUND                    (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x202)
#define ERROR_NO_DRIVER_SELECTED                 (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x203)
#define ERROR_KEY_DOES_NOT_EXIST                 (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x204)
#define ERROR_INVALID_DEVINST_NAME               (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x205)
#define ERROR_INVALID_CLASS                      (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x206)
#define ERROR_DEVINST_ALREADY_EXISTS             (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x207)
#define ERROR_DEVINFO_NOT_REGISTERED             (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x208)
#define ERROR_INVALID_REG_PROPERTY               (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x209)
#define ERROR_NO_INF                             (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x20A)
#define ERROR_NO_SUCH_DEVINST                    (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x20B)
#define ERROR_CANT_LOAD_CLASS_ICON               (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x20C)
#define ERROR_INVALID_CLASS_INSTALLER            (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x20D)
#define ERROR_DI_DO_DEFAULT                      (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x20E)
#define ERROR_DI_NOFILECOPY                      (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x20F)
#define ERROR_INVALID_HWPROFILE                  (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x210)
#define ERROR_NO_DEVICE_SELECTED                 (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x211)
#define ERROR_DEVINFO_LIST_LOCKED                (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x212)
#define ERROR_DEVINFO_DATA_LOCKED                (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x213)
#define ERROR_DI_BAD_PATH                        (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x214)
#define ERROR_NO_CLASSINSTALL_PARAMS             (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x215)
#define ERROR_FILEQUEUE_LOCKED                   (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x216)
#define ERROR_BAD_SERVICE_INSTALLSECT            (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x217)
#define ERROR_NO_CLASS_DRIVER_LIST               (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x218)
#define ERROR_NO_ASSOCIATED_SERVICE              (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x219)
#define ERROR_NO_DEFAULT_DEVICE_INTERFACE        (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x21A)
#define ERROR_DEVICE_INTERFACE_ACTIVE            (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x21B)
#define ERROR_DEVICE_INTERFACE_REMOVED           (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x21C)
#define ERROR_BAD_INTERFACE_INSTALLSECT          (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x21D)
#define ERROR_NO_SUCH_INTERFACE_CLASS            (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x21E)
#define ERROR_INVALID_REFERENCE_STRING           (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x21F)
#define ERROR_INVALID_MACHINENAME                (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x220)
#define ERROR_REMOTE_COMM_FAILURE                (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x221)
#define ERROR_MACHINE_UNAVAILABLE                (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x222)
#define ERROR_NO_CONFIGMGR_SERVICES              (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x223)
#define ERROR_INVALID_PROPPAGE_PROVIDER          (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x224)
#define ERROR_NO_SUCH_DEVICE_INTERFACE           (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x225)
#define ERROR_DI_POSTPROCESSING_REQUIRED         (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x226)
#define ERROR_INVALID_COINSTALLER                (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x227)
#define ERROR_NO_COMPAT_DRIVERS                  (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x228)
#define ERROR_NO_DEVICE_ICON                     (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x229)
#define ERROR_INVALID_INF_LOGCONFIG              (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x22A)
#define ERROR_DI_DONT_INSTALL                    (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x22B)
#define ERROR_INVALID_FILTER_DRIVER              (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x22C)
#define ERROR_NON_WINDOWS_NT_DRIVER              (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x22D)
#define ERROR_NON_WINDOWS_DRIVER                 (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x22E)
#define ERROR_NO_CATALOG_FOR_OEM_INF             (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x22F)
#define ERROR_DEVINSTALL_QUEUE_NONNATIVE         (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x230)
#define ERROR_NOT_DISABLEABLE                    (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x231)
#define ERROR_CANT_REMOVE_DEVINST                (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x232)
#define ERROR_INVALID_TARGET                     (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x233)
#define ERROR_DRIVER_NONNATIVE                   (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x234)
#define ERROR_IN_WOW64                           (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x235)
#define ERROR_SET_SYSTEM_RESTORE_POINT           (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x236)

#define ERROR_SCE_DISABLED                       (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x238)
#define ERROR_UNKNOWN_EXCEPTION                  (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x239)
#define ERROR_PNP_REGISTRY_ERROR                 (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x23A)
#define ERROR_REMOTE_REQUEST_UNSUPPORTED         (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x23B)
#define ERROR_NOT_AN_INSTALLED_OEM_INF           (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x23C)
#define ERROR_INF_IN_USE_BY_DEVICES              (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x23D)
#define ERROR_DI_FUNCTION_OBSOLETE               (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x23E)
#define ERROR_NO_AUTHENTICODE_CATALOG            (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x23F)
#define ERROR_AUTHENTICODE_DISALLOWED            (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x240)
#define ERROR_AUTHENTICODE_TRUSTED_PUBLISHER     (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x241)
#define ERROR_AUTHENTICODE_TRUST_NOT_ESTABLISHED (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x242)
#define ERROR_AUTHENTICODE_PUBLISHER_NOT_TRUSTED (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x243)
#define ERROR_SIGNATURE_OSATTRIBUTE_MISMATCH     (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x244)
#define ERROR_ONLY_VALIDATE_VIA_AUTHENTICODE     (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x245)
#define ERROR_DEVICE_INSTALLER_NOT_READY         (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x246)
#define ERROR_DRIVER_STORE_ADD_FAILED            (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x247)
#define ERROR_DEVICE_INSTALL_BLOCKED             (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x248)
#define ERROR_DRIVER_INSTALL_BLOCKED             (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x249)
#define ERROR_WRONG_INF_TYPE                     (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x24A)
#define ERROR_FILE_HASH_NOT_IN_CATALOG           (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x24B)
#define ERROR_DRIVER_STORE_DELETE_FAILED         (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x24C)

//
// Setupapi exception codes
//
#define ERROR_UNRECOVERABLE_STACK_OVERFLOW (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x300)
#define EXCEPTION_SPAPI_UNRECOVERABLE_STACK_OVERFLOW ERROR_UNRECOVERABLE_STACK_OVERFLOW

//
// Backward compatibility--do not use.
//
#define ERROR_NO_DEFAULT_INTERFACE_DEVICE ERROR_NO_DEFAULT_DEVICE_INTERFACE
#define ERROR_INTERFACE_DEVICE_ACTIVE     ERROR_DEVICE_INTERFACE_ACTIVE
#define ERROR_INTERFACE_DEVICE_REMOVED    ERROR_DEVICE_INTERFACE_REMOVED
#define ERROR_NO_SUCH_INTERFACE_DEVICE    ERROR_NO_SUCH_DEVICE_INTERFACE


//
// Win9x migration DLL error code
//
#define ERROR_NOT_INSTALLED (APPLICATION_ERROR_MASK|ERROR_SEVERITY_ERROR|0x1000)

end -- _SPAPI_ERRORS
--]=]

ffi.cdef[[
BOOL
__stdcall
SetupGetInfInformationA(
     LPCVOID InfSpec,
     DWORD SearchControl,
     PSP_INF_INFORMATION ReturnBuffer, 
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );



BOOL
__stdcall
SetupGetInfInformationW(
     LPCVOID InfSpec,
     DWORD SearchControl,
     PSP_INF_INFORMATION ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );
]]

ffi.cdef[[
//
// SearchControl flags for SetupGetInfInformation
//
static const int INFINFO_INF_SPEC_IS_HINF       = 1;
static const int INFINFO_INF_NAME_IS_ABSOLUTE   = 2;
static const int INFINFO_DEFAULT_SEARCH         = 3;
static const int INFINFO_REVERSE_DEFAULT_SEARCH = 4;
static const int INFINFO_INF_PATH_LIST_SEARCH   = 5;





BOOL
__stdcall
SetupQueryInfFileInformationA(
     PSP_INF_INFORMATION InfInformation,
     UINT InfIndex,
     PSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize 
    );


BOOL
__stdcall
SetupQueryInfFileInformationW(
     PSP_INF_INFORMATION InfInformation,
     UINT InfIndex,
     PWSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );





BOOL
__stdcall
SetupQueryInfOriginalFileInformationA(
     PSP_INF_INFORMATION InfInformation,
     UINT InfIndex,
     PSP_ALTPLATFORM_INFO AlternatePlatformInfo,
     PSP_ORIGINAL_FILE_INFO_A OriginalFileInfo
    );


BOOL
__stdcall
SetupQueryInfOriginalFileInformationW(
     PSP_INF_INFORMATION InfInformation,
     UINT InfIndex,
     PSP_ALTPLATFORM_INFO AlternatePlatformInfo,
     PSP_ORIGINAL_FILE_INFO_W OriginalFileInfo
    );





BOOL
__stdcall
SetupQueryInfVersionInformationA(
     PSP_INF_INFORMATION InfInformation,
     UINT InfIndex,
     PCSTR Key,
     PSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );


BOOL
__stdcall
SetupQueryInfVersionInformationW(
     PSP_INF_INFORMATION InfInformation,
     UINT InfIndex,
     PCWSTR Key,
     PWSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );
]]



if _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN then

ffi.cdef[[
BOOL
__stdcall
SetupGetInfDriverStoreLocationA(
     PCSTR FileName,
     PSP_ALTPLATFORM_INFO AlternatePlatformInfo,
     PCSTR LocaleName,
     PSTR ReturnBuffer, 
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );


BOOL
__stdcall
SetupGetInfDriverStoreLocationW(
     PCWSTR FileName,
     PSP_ALTPLATFORM_INFO AlternatePlatformInfo,    
     PCWSTR LocaleName,
     PWSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );




BOOL
__stdcall
SetupGetInfPublishedNameA(
     PCSTR DriverStoreLocation,
     PSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );


BOOL
__stdcall
SetupGetInfPublishedNameW(
     PCWSTR DriverStoreLocation,
     PWSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );
]]


end -- _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN


ffi.cdef[[
BOOL
__stdcall
SetupGetInfFileListA(
     PCSTR DirectoryPath,
     DWORD InfStyle,
     PSTR ReturnBuffer, 
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );


BOOL
__stdcall
SetupGetInfFileListW(
     PCWSTR DirectoryPath,
     DWORD InfStyle,
     PWSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );




HINF
__stdcall
SetupOpenInfFileW(
     PCWSTR FileName,
     PCWSTR InfClass,
     DWORD InfStyle,
     PUINT ErrorLine
    );


HINF
__stdcall
SetupOpenInfFileA(
     PCSTR FileName,
     PCSTR InfClass,
     DWORD InfStyle,
     PUINT ErrorLine
    );





HINF
__stdcall
SetupOpenMasterInf(
    VOID
    );



BOOL
__stdcall
SetupOpenAppendInfFileW(
     PCWSTR FileName,
     HINF InfHandle,
     PUINT ErrorLine
    );


BOOL
__stdcall
SetupOpenAppendInfFileA(
     PCSTR FileName,
     HINF InfHandle,
     PUINT ErrorLine
    );





VOID
__stdcall
SetupCloseInfFile(
     HINF InfHandle
    );



BOOL
__stdcall
SetupFindFirstLineA(
     HINF InfHandle,
     PCSTR Section,
     PCSTR Key,
     PINFCONTEXT Context
    );


BOOL
__stdcall
SetupFindFirstLineW(
     HINF InfHandle,
     PCWSTR Section,
     PCWSTR Key,
     PINFCONTEXT Context
    );





BOOL
__stdcall
SetupFindNextLine(
     PINFCONTEXT ContextIn,
     PINFCONTEXT ContextOut
    );



BOOL
__stdcall
SetupFindNextMatchLineA(
     PINFCONTEXT ContextIn,
     PCSTR Key,
     PINFCONTEXT ContextOut
    );


BOOL
__stdcall
SetupFindNextMatchLineW(
     PINFCONTEXT ContextIn,
     PCWSTR Key,
     PINFCONTEXT ContextOut
    );





BOOL
__stdcall
SetupGetLineByIndexA(
     HINF InfHandle,
     PCSTR Section,
     DWORD Index,
     PINFCONTEXT Context
    );


BOOL
__stdcall
SetupGetLineByIndexW(
     HINF InfHandle,
     PCWSTR Section,
     DWORD Index,
     PINFCONTEXT Context
    );





LONG
__stdcall
SetupGetLineCountA(
     HINF InfHandle,
     PCSTR Section
    );


LONG
__stdcall
SetupGetLineCountW(
     HINF InfHandle,
     PCWSTR Section
    );





BOOL
__stdcall
SetupGetLineTextA(
     PINFCONTEXT Context,
     HINF InfHandle,
     PCSTR Section,
     PCSTR Key,
     PSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );


BOOL
__stdcall
SetupGetLineTextW(
     PINFCONTEXT Context,
     HINF InfHandle,
     PCWSTR Section,
     PCWSTR Key,
     PWSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );





DWORD
__stdcall
SetupGetFieldCount(
     PINFCONTEXT Context
    );



BOOL
__stdcall
SetupGetStringFieldA(
     PINFCONTEXT Context,
     DWORD FieldIndex,
     PSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );


BOOL
__stdcall
SetupGetStringFieldW(
     PINFCONTEXT Context,
     DWORD FieldIndex,
     PWSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );





BOOL
__stdcall
SetupGetIntField(
     PINFCONTEXT Context,
     DWORD FieldIndex,
     PINT IntegerValue
    );



BOOL
__stdcall
SetupGetMultiSzFieldA(
     PINFCONTEXT Context,
     DWORD FieldIndex,
     PSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     LPDWORD RequiredSize 
    );


BOOL
__stdcall
SetupGetMultiSzFieldW(
     PINFCONTEXT Context,
     DWORD FieldIndex,
     PWSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     LPDWORD RequiredSize 
    );





BOOL
__stdcall
SetupGetBinaryField(
     PINFCONTEXT Context,
     DWORD FieldIndex,
     PBYTE ReturnBuffer,
     DWORD ReturnBufferSize,
     LPDWORD RequiredSize 
    );
]]

--[[
//
// SetupGetFileCompressionInfo is depreciated
// use SetupGetFileCompressionInfoEx instead
//
// ActualSourceFileName returned by SetupGetFileCompressionInfo
// must be freed by the export setupapi!MyFree (NT4+ Win95+)
// or LocalFree (Win2k+)
//

DWORD
__stdcall
SetupGetFileCompressionInfoA(
     PCSTR SourceFileName,
     PSTR *ActualSourceFileName,
     PDWORD SourceFileSize,
     PDWORD TargetFileSize,
     PUINT CompressionType
    );


DWORD
__stdcall
SetupGetFileCompressionInfoW(
     PCWSTR SourceFileName,
     PWSTR *ActualSourceFileName,
     PDWORD SourceFileSize,
     PDWORD TargetFileSize,
     PUINT CompressionType
    );
--]]


if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then
ffi.cdef[[
//
// SetupGetFileCompressionInfoEx is the preferred API over
// SetupGetFileCompressionInfo. It follows the normal
// conventions of returning BOOL and writing to user-supplied
// buffer.
//


BOOL
__stdcall
SetupGetFileCompressionInfoExA(
     PCSTR SourceFileName,
     PSTR ActualSourceFileNameBuffer,
     DWORD ActualSourceFileNameBufferLen,
     PDWORD RequiredBufferLen, 
     PDWORD SourceFileSize,
     PDWORD TargetFileSize,
     PUINT CompressionType
    );


BOOL
__stdcall
SetupGetFileCompressionInfoExW(
     PCWSTR SourceFileName,
     PWSTR ActualSourceFileNameBuffer,
     DWORD ActualSourceFileNameBufferLen,
     PDWORD RequiredBufferLen,
     PDWORD SourceFileSize,
     PDWORD TargetFileSize,
     PUINT CompressionType
    );
]]

end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP

--[=[
//
// Compression types
//
#define FILE_COMPRESSION_NONE       0
#define FILE_COMPRESSION_WINLZA     1
#define FILE_COMPRESSION_MSZIP      2
#define FILE_COMPRESSION_NTCAB      3



DWORD
__stdcall
SetupDecompressOrCopyFileA(
     PCSTR SourceFileName,
     PCSTR TargetFileName,
     PUINT CompressionType
    );


DWORD
__stdcall
SetupDecompressOrCopyFileW(
     PCWSTR SourceFileName,
     PCWSTR TargetFileName,
     PUINT CompressionType
    );

if UNICODE
#define SetupDecompressOrCopyFile SetupDecompressOrCopyFileW
else
#define SetupDecompressOrCopyFile SetupDecompressOrCopyFileA
end



BOOL
__stdcall
SetupGetSourceFileLocationA(
     HINF InfHandle,
     PINFCONTEXT InfContext,
     PCSTR FileName,
     PUINT SourceId,
     PSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );


BOOL
__stdcall
SetupGetSourceFileLocationW(
     HINF InfHandle,
     PINFCONTEXT InfContext,
     PCWSTR FileName,
     PUINT SourceId,
     PWSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );

if UNICODE
#define SetupGetSourceFileLocation SetupGetSourceFileLocationW
else
#define SetupGetSourceFileLocation SetupGetSourceFileLocationA
end



BOOL
__stdcall
SetupGetSourceFileSizeA(
     HINF InfHandle,
     PINFCONTEXT InfContext,
     PCSTR FileName,
     PCSTR Section,
     PDWORD FileSize,
     UINT RoundingFactor
    );


BOOL
__stdcall
SetupGetSourceFileSizeW(
     HINF InfHandle,
     PINFCONTEXT InfContext,
     PCWSTR FileName,
     PCWSTR Section,
     PDWORD FileSize,
     UINT RoundingFactor
    );

if UNICODE
#define SetupGetSourceFileSize SetupGetSourceFileSizeW
else
#define SetupGetSourceFileSize SetupGetSourceFileSizeA
end



BOOL
__stdcall
SetupGetTargetPathA(
     HINF InfHandle,
     PINFCONTEXT InfContext,
     PCSTR Section,
     PSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );


BOOL
__stdcall
SetupGetTargetPathW(
     HINF InfHandle,
     PINFCONTEXT InfContext,
     PCWSTR Section,
     PWSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );

if UNICODE
#define SetupGetTargetPath SetupGetTargetPathW
else
#define SetupGetTargetPath SetupGetTargetPathA
end


//
// Define flags for SourceList APIs.
//
#define SRCLIST_TEMPORARY       0x00000001
#define SRCLIST_NOBROWSE        0x00000002
#define SRCLIST_SYSTEM          0x00000010
#define SRCLIST_USER            0x00000020
#define SRCLIST_SYSIFADMIN      0x00000040
#define SRCLIST_SUBDIRS         0x00000100
#define SRCLIST_APPEND          0x00000200
#define SRCLIST_NOSTRIPPLATFORM 0x00000400



BOOL
__stdcall
SetupSetSourceListA(
     DWORD Flags,
    _In_reads_(SourceCount) PCSTR *SourceList,
     UINT SourceCount
    );


BOOL
__stdcall
SetupSetSourceListW(
     DWORD Flags,
    _In_reads_(SourceCount) PCWSTR *SourceList,
     UINT SourceCount
    );

if UNICODE
#define SetupSetSourceList SetupSetSourceListW
else
#define SetupSetSourceList SetupSetSourceListA
end



BOOL
__stdcall
SetupCancelTemporarySourceList(
    VOID
    );



BOOL
__stdcall
SetupAddToSourceListA(
     DWORD Flags,
     PCSTR Source
    );


BOOL
__stdcall
SetupAddToSourceListW(
     DWORD Flags,
     PCWSTR Source
    );

if UNICODE
#define SetupAddToSourceList SetupAddToSourceListW
else
#define SetupAddToSourceList SetupAddToSourceListA
end



BOOL
__stdcall
SetupRemoveFromSourceListA(
     DWORD Flags,
     PCSTR Source
    );


BOOL
__stdcall
SetupRemoveFromSourceListW(
     DWORD Flags,
     PCWSTR Source
    );

if UNICODE
#define SetupRemoveFromSourceList SetupRemoveFromSourceListW
else
#define SetupRemoveFromSourceList SetupRemoveFromSourceListA
end



BOOL
__stdcall
SetupQuerySourceListA(
     DWORD Flags,
    _Outptr_result_buffer_(*Count) PCSTR **List,
     PUINT Count
    );


BOOL
__stdcall
SetupQuerySourceListW(
     DWORD Flags,
    _Outptr_result_buffer_(*Count) PCWSTR **List,
     PUINT Count
    );

if UNICODE
#define SetupQuerySourceList SetupQuerySourceListW
else
#define SetupQuerySourceList SetupQuerySourceListA
end



BOOL
__stdcall
SetupFreeSourceListA(
     _At_(*List, _Pre_readable_size_(Count) _Post_null_) PCSTR **List,
     UINT Count
    );


BOOL
__stdcall
SetupFreeSourceListW(
     _At_(*List, _Pre_readable_size_(Count) _Post_null_) PCWSTR **List,
     UINT Count
    );

if UNICODE
#define SetupFreeSourceList SetupFreeSourceListW
else
#define SetupFreeSourceList SetupFreeSourceListA
end



UINT
__stdcall
SetupPromptForDiskA(
     HWND hwndParent,
     PCSTR DialogTitle,
     PCSTR DiskName,
     PCSTR PathToSource,
     PCSTR FileSought,
     PCSTR TagFile,
     DWORD DiskPromptStyle,
    _Out_writes_opt_(PathBufferSize) PSTR PathBuffer,
     DWORD PathBufferSize,
     PDWORD PathRequiredSize
    );


UINT
__stdcall
SetupPromptForDiskW(
     HWND hwndParent,
     PCWSTR DialogTitle,
     PCWSTR DiskName,
     PCWSTR PathToSource,
     PCWSTR FileSought,
     PCWSTR TagFile,
     DWORD DiskPromptStyle,
    _Out_writes_opt_(PathBufferSize) PWSTR PathBuffer,
     DWORD PathBufferSize,
     PDWORD PathRequiredSize
    );

if UNICODE
#define SetupPromptForDisk SetupPromptForDiskW
else
#define SetupPromptForDisk SetupPromptForDiskA
end



UINT
__stdcall
SetupCopyErrorA(
     HWND hwndParent,
     PCSTR DialogTitle,
     PCSTR DiskName,
     PCSTR PathToSource,
     PCSTR SourceFile,
     PCSTR TargetPathFile,
     UINT Win32ErrorCode,
     DWORD Style,
    _Out_writes_opt_(PathBufferSize) PSTR PathBuffer,
     DWORD PathBufferSize,
     PDWORD PathRequiredSize
    );


UINT
__stdcall
SetupCopyErrorW(
     HWND hwndParent,
     PCWSTR DialogTitle,
     PCWSTR DiskName,
     PCWSTR PathToSource,
     PCWSTR SourceFile,
     PCWSTR TargetPathFile,
     UINT Win32ErrorCode,
     DWORD Style,
    _Out_writes_opt_(PathBufferSize) PWSTR PathBuffer,
     DWORD PathBufferSize,
     PDWORD PathRequiredSize
    );

if UNICODE
#define SetupCopyError SetupCopyErrorW
else
#define SetupCopyError SetupCopyErrorA
end



UINT
__stdcall
SetupRenameErrorA(
     HWND hwndParent,
     PCSTR DialogTitle,
     PCSTR SourceFile,
     PCSTR TargetFile,
     UINT Win32ErrorCode,
     DWORD Style
    );


UINT
__stdcall
SetupRenameErrorW(
     HWND hwndParent,
     PCWSTR DialogTitle,
     PCWSTR SourceFile,
     PCWSTR TargetFile,
     UINT Win32ErrorCode,
     DWORD Style
    );

if UNICODE
#define SetupRenameError SetupRenameErrorW
else
#define SetupRenameError SetupRenameErrorA
end



UINT
__stdcall
SetupDeleteErrorA(
     HWND hwndParent,
     PCSTR DialogTitle,
     PCSTR File,
     UINT Win32ErrorCode,
     DWORD Style
    );


UINT
__stdcall
SetupDeleteErrorW(
     HWND hwndParent,
     PCWSTR DialogTitle,
     PCWSTR File,
     UINT Win32ErrorCode,
     DWORD Style
    );

if UNICODE
#define SetupDeleteError SetupDeleteErrorW
else
#define SetupDeleteError SetupDeleteErrorA
end


UINT
__stdcall
SetupBackupErrorA(
     HWND hwndParent,
     PCSTR DialogTitle,
     PCSTR SourceFile,
     PCSTR TargetFile,
     UINT Win32ErrorCode,
     DWORD Style
    );


UINT
__stdcall
SetupBackupErrorW(
     HWND hwndParent,
     PCWSTR DialogTitle,
     PCWSTR SourceFile,
     PCWSTR TargetFile,
     UINT Win32ErrorCode,
     DWORD Style
    );

if UNICODE
#define SetupBackupError SetupBackupErrorW
else
#define SetupBackupError SetupBackupErrorA
end


//
// Styles for SetupPromptForDisk, SetupCopyError,
// SetupRenameError, SetupDeleteError
//
#define IDF_NOBROWSE                    0x00000001
#define IDF_NOSKIP                      0x00000002
#define IDF_NODETAILS                   0x00000004
#define IDF_NOCOMPRESSED                0x00000008
#define IDF_CHECKFIRST                  0x00000100
#define IDF_NOBEEP                      0x00000200
#define IDF_NOFOREGROUND                0x00000400
#define IDF_WARNIFSKIP                  0x00000800

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then

#define IDF_NOREMOVABLEMEDIAPROMPT      0x00001000
#define IDF_USEDISKNAMEASPROMPT         0x00002000
#define IDF_OEMDISK                     0x80000000

end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP

//
// Return values for SetupPromptForDisk, SetupCopyError,
// SetupRenameError, SetupDeleteError, SetupBackupError
//
#define DPROMPT_SUCCESS         0
#define DPROMPT_CANCEL          1
#define DPROMPT_SKIPFILE        2
#define DPROMPT_BUFFERTOOSMALL  3
#define DPROMPT_OUTOFMEMORY     4



BOOL
__stdcall
SetupSetDirectoryIdA(
     HINF InfHandle,
     DWORD Id, 
     PCSTR Directory 
    );


BOOL
__stdcall
SetupSetDirectoryIdW(
     HINF InfHandle,
     DWORD Id, 
     PCWSTR Directory 
    );

if UNICODE
#define SetupSetDirectoryId SetupSetDirectoryIdW
else
#define SetupSetDirectoryId SetupSetDirectoryIdA
end



BOOL
__stdcall
SetupSetDirectoryIdExA(
     HINF InfHandle,
     DWORD Id, 
     PCSTR Directory, 
     DWORD Flags,
     DWORD Reserved1,
     PVOID Reserved2
    );


BOOL
__stdcall
SetupSetDirectoryIdExW(
     HINF InfHandle,
     DWORD Id, 
     PCWSTR Directory,
     DWORD Flags,
     DWORD Reserved1,
     PVOID Reserved2
    );

if UNICODE
#define SetupSetDirectoryIdEx SetupSetDirectoryIdExW
else
#define SetupSetDirectoryIdEx SetupSetDirectoryIdExA
end

//
// Flags for SetupSetDirectoryIdEx
//
#define SETDIRID_NOT_FULL_PATH      0x00000001



BOOL
__stdcall
SetupGetSourceInfoA(
     HINF InfHandle,
     UINT SourceId,
     UINT InfoDesired,
     PSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );


BOOL
__stdcall
SetupGetSourceInfoW(
     HINF InfHandle,
     UINT SourceId,
     UINT InfoDesired,
     PWSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );

if UNICODE
#define SetupGetSourceInfo SetupGetSourceInfoW
else
#define SetupGetSourceInfo SetupGetSourceInfoA
end

//
// InfoDesired values for SetupGetSourceInfo
//

#define SRCINFO_PATH            1
#define SRCINFO_TAGFILE         2
#define SRCINFO_DESCRIPTION     3
#define SRCINFO_FLAGS           4

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then
//
// SRC_FLAGS allow special treatment of source
// lower 4 bits are reserved for OS use
// the flags may determine what other parameters exist
//
#define SRCINFO_TAGFILE2        5  // alternate tagfile, when SRCINFO_TAGFILE is a cabfile

#define SRC_FLAGS_CABFILE       (0x0010) // if set, treat SRCINFO_TAGFILE as a cabfile and specify alternate tagfile

end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP


BOOL
__stdcall
SetupInstallFileA(
     HINF InfHandle,
     PINFCONTEXT InfContext,
     PCSTR SourceFile,
     PCSTR SourcePathRoot,
     PCSTR DestinationName,
     DWORD CopyStyle,
     PSP_FILE_CALLBACK_A CopyMsgHandler,
     PVOID Context
    );


BOOL
__stdcall
SetupInstallFileW(
     HINF InfHandle,
     PINFCONTEXT InfContext,
     PCWSTR SourceFile,
     PCWSTR SourcePathRoot,
     PCWSTR DestinationName,
     DWORD CopyStyle,
     PSP_FILE_CALLBACK_W CopyMsgHandler,
     PVOID Context
    );

if UNICODE
#define SetupInstallFile SetupInstallFileW
else
#define SetupInstallFile SetupInstallFileA
end


BOOL
__stdcall
SetupInstallFileExA(
     HINF InfHandle,
     PINFCONTEXT InfContext,
     PCSTR SourceFile,
     PCSTR SourcePathRoot,
     PCSTR DestinationName,
     DWORD CopyStyle,
     PSP_FILE_CALLBACK_A CopyMsgHandler,
     PVOID Context,
     PBOOL FileWasInUse
    );


BOOL
__stdcall
SetupInstallFileExW(
     HINF InfHandle,
     PINFCONTEXT InfContext,
     PCWSTR SourceFile,
     PCWSTR SourcePathRoot,
     PCWSTR DestinationName,
     DWORD CopyStyle,
     PSP_FILE_CALLBACK_W CopyMsgHandler,
     PVOID Context,
     PBOOL FileWasInUse
    );

if UNICODE
#define SetupInstallFileEx SetupInstallFileExW
else
#define SetupInstallFileEx SetupInstallFileExA
end

//
// CopyStyle values for copy and queue-related APIs
//
#define SP_COPY_DELETESOURCE        0x0000001   // delete source file on successful copy
#define SP_COPY_REPLACEONLY         0x0000002   // copy only if target file already present
#define SP_COPY_NEWER               0x0000004   // copy only if source newer than or same as target
#define SP_COPY_NEWER_OR_SAME       SP_COPY_NEWER
#define SP_COPY_NOOVERWRITE         0x0000008   // copy only if target doesn't exist
#define SP_COPY_NODECOMP            0x0000010   // don't decompress source file while copying
#define SP_COPY_LANGUAGEAWARE       0x0000020   // don't overwrite file of different language
#define SP_COPY_SOURCE_ABSOLUTE     0x0000040   // SourceFile is a full source path
#define SP_COPY_SOURCEPATH_ABSOLUTE 0x0000080   // SourcePathRoot is the full path
#define SP_COPY_IN_USE_NEEDS_REBOOT 0x0000100   // System needs reboot if file in use
#define SP_COPY_FORCE_IN_USE        0x0000200   // Force target-in-use behavior
#define SP_COPY_NOSKIP              0x0000400   // Skip is disallowed for this file or section
#define SP_FLAG_CABINETCONTINUATION 0x0000800   // Used with need media notification
#define SP_COPY_FORCE_NOOVERWRITE   0x0001000   // like NOOVERWRITE but no callback nofitication
#define SP_COPY_FORCE_NEWER         0x0002000   // like NEWER but no callback nofitication
#define SP_COPY_WARNIFSKIP          0x0004000   // system critical file: warn if user tries to skip
#define SP_COPY_NOBROWSE            0x0008000   // Browsing is disallowed for this file or section
#define SP_COPY_NEWER_ONLY          0x0010000   // copy only if source file newer than target
#define SP_COPY_RESERVED            0x0020000   // was: SP_COPY_SOURCE_SIS_MASTER (deprecated)
#define SP_COPY_OEMINF_CATALOG_ONLY 0x0040000   // (SetupCopyOEMInf only) don't copy INF--just catalog
#define SP_COPY_REPLACE_BOOT_FILE   0x0080000   // file must be present upon reboot (i.e., it's
                                                // needed by the loader); this flag implies a reboot
#define SP_COPY_NOPRUNE             0x0100000   // never prune this file

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then

#define SP_COPY_OEM_F6_INF          0x0200000   // Used when calling SetupCopyOemInf

end --_SETUPAPI_VER >= _WIN32_WINNT_WINXP

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then

#define SP_COPY_ALREADYDECOMP       0x0400000   // similar to SP_COPY_NODECOMP

end --_SETUPAPI_VER >= _WIN32_WINNT_WINXP

#if _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN

#define SP_COPY_WINDOWS_SIGNED      0x1000000   // BuildLab or WinSE signed
#define SP_COPY_PNPLOCKED           0x2000000   // Used with the signature flag
#define SP_COPY_IN_USE_TRY_RENAME   0x4000000   // If file in use, try to rename the target first
#define SP_COPY_INBOX_INF           0x8000000   // Referred by CopyFiles of inbox inf

end --_SETUPAPI_VER >= _WIN32_WINNT_LONGHORN

#if _SETUPAPI_VER >= _WIN32_WINNT_WIN7

#define SP_COPY_HARDLINK            0x10000000  // Copy using hardlink, if possible

end

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then

//
// Flags passed to Backup notification
//
#define SP_BACKUP_BACKUPPASS        0x00000001  // file backed up during backup pass
#define SP_BACKUP_DEMANDPASS        0x00000002  // file backed up on demand
#define SP_BACKUP_SPECIAL           0x00000004  // if set, special type of backup
#define SP_BACKUP_BOOTFILE          0x00000008  // file marked with COPYFLG_REPLACE_BOOT_FILE


end --_SETUPAPI_VER >= _WIN32_WINNT_WINXP



HSPFILEQ
__stdcall
SetupOpenFileQueue(
    VOID
    );


BOOL
__stdcall
SetupCloseFileQueue(
     HSPFILEQ QueueHandle
    );


BOOL
__stdcall
SetupSetFileQueueAlternatePlatformA(
     HSPFILEQ QueueHandle,
     PSP_ALTPLATFORM_INFO AlternatePlatformInfo,
     PCSTR AlternateDefaultCatalogFile
    );


BOOL
__stdcall
SetupSetFileQueueAlternatePlatformW(
     HSPFILEQ QueueHandle,
     PSP_ALTPLATFORM_INFO AlternatePlatformInfo,
     PCWSTR AlternateDefaultCatalogFile
    );

if UNICODE
#define SetupSetFileQueueAlternatePlatform SetupSetFileQueueAlternatePlatformW
else
#define SetupSetFileQueueAlternatePlatform SetupSetFileQueueAlternatePlatformA
end



BOOL
__stdcall
SetupSetPlatformPathOverrideA(
     PCSTR Override
    );


BOOL
__stdcall
SetupSetPlatformPathOverrideW(
     PCWSTR Override
    );

if UNICODE
#define SetupSetPlatformPathOverride SetupSetPlatformPathOverrideW
else
#define SetupSetPlatformPathOverride SetupSetPlatformPathOverrideA
end



BOOL
__stdcall
SetupQueueCopyA(
     HSPFILEQ QueueHandle,
     PCSTR SourceRootPath, 
     PCSTR SourcePath, 
     PCSTR SourceFilename,
     PCSTR SourceDescription, 
     PCSTR SourceTagfile, 
     PCSTR TargetDirectory,
     PCSTR TargetFilename, 
     DWORD CopyStyle
    );


BOOL
__stdcall
SetupQueueCopyW(
     HSPFILEQ QueueHandle,
     PCWSTR SourceRootPath, 
     PCWSTR SourcePath, 
     PCWSTR SourceFilename,
     PCWSTR SourceDescription, 
     PCWSTR SourceTagfile, 
     PCWSTR TargetDirectory,
     PCWSTR TargetFilename, 
     DWORD CopyStyle
    );

if UNICODE
#define SetupQueueCopy SetupQueueCopyW
else
#define SetupQueueCopy SetupQueueCopyA
end



BOOL
__stdcall
SetupQueueCopyIndirectA(
     PSP_FILE_COPY_PARAMS_A CopyParams
    );


BOOL
__stdcall
SetupQueueCopyIndirectW(
     PSP_FILE_COPY_PARAMS_W CopyParams
    );

if UNICODE
#define SetupQueueCopyIndirect SetupQueueCopyIndirectW
else
#define SetupQueueCopyIndirect SetupQueueCopyIndirectA
end



BOOL
__stdcall
SetupQueueDefaultCopyA(
     HSPFILEQ QueueHandle,
     HINF InfHandle,
     PCSTR SourceRootPath,
     PCSTR SourceFilename,
     PCSTR TargetFilename,
     DWORD CopyStyle
    );


BOOL
__stdcall
SetupQueueDefaultCopyW(
     HSPFILEQ QueueHandle,
     HINF InfHandle,
     PCWSTR SourceRootPath,
     PCWSTR SourceFilename,
     PCWSTR TargetFilename,
     DWORD CopyStyle
    );

if UNICODE
#define SetupQueueDefaultCopy SetupQueueDefaultCopyW
else
#define SetupQueueDefaultCopy SetupQueueDefaultCopyA
end



BOOL
__stdcall
SetupQueueCopySectionA(
     HSPFILEQ QueueHandle,
     PCSTR SourceRootPath,
     HINF InfHandle,
     HINF ListInfHandle,
     PCSTR Section,
     DWORD CopyStyle
    );


BOOL
__stdcall
SetupQueueCopySectionW(
     HSPFILEQ QueueHandle,
     PCWSTR SourceRootPath,
     HINF InfHandle,
     HINF ListInfHandle,
     PCWSTR Section,
     DWORD CopyStyle
    );

if UNICODE
#define SetupQueueCopySection SetupQueueCopySectionW
else
#define SetupQueueCopySection SetupQueueCopySectionA
end



BOOL
__stdcall
SetupQueueDeleteA(
     HSPFILEQ QueueHandle,
     PCSTR PathPart1,
     PCSTR PathPart2
    );


BOOL
__stdcall
SetupQueueDeleteW(
     HSPFILEQ QueueHandle,
     PCWSTR PathPart1,
     PCWSTR PathPart2
    );

if UNICODE
#define SetupQueueDelete SetupQueueDeleteW
else
#define SetupQueueDelete SetupQueueDeleteA
end



BOOL
__stdcall
SetupQueueDeleteSectionA(
     HSPFILEQ QueueHandle,
     HINF InfHandle,
     HINF ListInfHandle,
     PCSTR Section
    );


BOOL
__stdcall
SetupQueueDeleteSectionW(
     HSPFILEQ QueueHandle,
     HINF InfHandle,
     HINF ListInfHandle,
     PCWSTR Section
    );

if UNICODE
#define SetupQueueDeleteSection SetupQueueDeleteSectionW
else
#define SetupQueueDeleteSection SetupQueueDeleteSectionA
end



BOOL
__stdcall
SetupQueueRenameA(
     HSPFILEQ QueueHandle,
     PCSTR SourcePath,
     PCSTR SourceFilename,
     PCSTR TargetPath,
     PCSTR TargetFilename
    );


BOOL
__stdcall
SetupQueueRenameW(
     HSPFILEQ QueueHandle,
     PCWSTR SourcePath,
     PCWSTR SourceFilename, 
     PCWSTR TargetPath,
     PCWSTR TargetFilename
    );

if UNICODE
#define SetupQueueRename SetupQueueRenameW
else
#define SetupQueueRename SetupQueueRenameA
end



BOOL
__stdcall
SetupQueueRenameSectionA(
     HSPFILEQ QueueHandle,
     HINF InfHandle,
     HINF ListInfHandle,
     PCSTR Section
    );


BOOL
__stdcall
SetupQueueRenameSectionW(
     HSPFILEQ QueueHandle,
     HINF InfHandle,
     HINF ListInfHandle,
     PCWSTR Section
    );

if UNICODE
#define SetupQueueRenameSection SetupQueueRenameSectionW
else
#define SetupQueueRenameSection SetupQueueRenameSectionA
end



BOOL
__stdcall
SetupCommitFileQueueA(
     HWND Owner,
     HSPFILEQ QueueHandle,
     PSP_FILE_CALLBACK_A MsgHandler,
     PVOID Context
    );


BOOL
__stdcall
SetupCommitFileQueueW(
     HWND Owner,
     HSPFILEQ QueueHandle,
     PSP_FILE_CALLBACK_W MsgHandler,
     PVOID Context
    );

if UNICODE
#define SetupCommitFileQueue SetupCommitFileQueueW
else
#define SetupCommitFileQueue SetupCommitFileQueueA
end



BOOL
__stdcall
SetupScanFileQueueA(
     HSPFILEQ FileQueue,
     DWORD Flags,
     HWND Window,
     PSP_FILE_CALLBACK_A CallbackRoutine,
     PVOID CallbackContext,
     PDWORD Result
    );


BOOL
__stdcall
SetupScanFileQueueW(
     HSPFILEQ FileQueue,
     DWORD Flags,
     HWND Window,
     PSP_FILE_CALLBACK_W CallbackRoutine,
     PVOID CallbackContext,
     PDWORD Result
    );

if UNICODE
#define SetupScanFileQueue SetupScanFileQueueW
else
#define SetupScanFileQueue SetupScanFileQueueA
end

//
// Define flags for SetupScanFileQueue.
//
#define SPQ_SCAN_FILE_PRESENCE                  0x00000001
#define SPQ_SCAN_FILE_VALIDITY                  0x00000002
#define SPQ_SCAN_USE_CALLBACK                   0x00000004
#define SPQ_SCAN_USE_CALLBACKEX                 0x00000008
#define SPQ_SCAN_INFORM_USER                    0x00000010
#define SPQ_SCAN_PRUNE_COPY_QUEUE               0x00000020

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then

#define SPQ_SCAN_USE_CALLBACK_SIGNERINFO        0x00000040
#define SPQ_SCAN_PRUNE_DELREN                   0x00000080 // remote Delete/Rename queue

end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP


#if _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN

#define SPQ_SCAN_FILE_PRESENCE_WITHOUT_SOURCE   0x00000100
#define SPQ_SCAN_FILE_COMPARISON                0x00000200
#define SPQ_SCAN_ACTIVATE_DRP                   0x00000400

end -- _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN


//
// Define flags used with Param2 for SPFILENOTIFY_QUEUESCAN
//
#define SPQ_DELAYED_COPY                        0x00000001  // file was in use; registered for delayed copy

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then


BOOL
__stdcall
SetupGetFileQueueCount(
     HSPFILEQ FileQueue,
     UINT SubQueueFileOp,
     PUINT NumOperations
    );


BOOL
__stdcall
SetupGetFileQueueFlags(
     HSPFILEQ FileQueue,
     PDWORD Flags
    );


BOOL
__stdcall
SetupSetFileQueueFlags(
     HSPFILEQ FileQueue,
     DWORD FlagMask,
     DWORD Flags
    );

//
// Flags/FlagMask for use with SetupSetFileQueueFlags and returned by SetupGetFileQueueFlags
//
#define SPQ_FLAG_BACKUP_AWARE      0x00000001  // If set, SetupCommitFileQueue will
                                               // issue backup notifications.

#define SPQ_FLAG_ABORT_IF_UNSIGNED 0x00000002  // If set, SetupCommitFileQueue will
                                               // fail with ERROR_SET_SYSTEM_RESTORE_POINT
                                               // if the user elects to proceed with an
                                               // unsigned queue committal.  This allows
                                               // the caller to set a system restore point,
                                               // then re-commit the file queue.

#define SPQ_FLAG_FILES_MODIFIED    0x00000004  // If set, at least one file was
                                               // replaced by a different version

#define SPQ_FLAG_DO_SHUFFLEMOVE    0x00000008  // If set then always do a shuffle move. A shuffle 
                                               // move will first try to copy the source over the
                                               // destination file, but if the destination file is
                                               // in use it will rename the destination file to a 
                                               // temp name and queue the temp name for deletion.
                                               // It will then be free to copy the source to the 
                                               // destination name.  It is considered an error if
                                               // the destination file can't be renamed for some
                                               // reason.

#define SPQ_FLAG_VALID             0x0000000F  // mask of valid flags (can be passed as FlagMask)

end  // _SETUPAPI_VER >= _WIN32_WINNT_WINXP

//
// Define OEM Source Type values for use in SetupCopyOEMInf.
//
#define SPOST_NONE  0
#define SPOST_PATH  1
#define SPOST_URL   2
#define SPOST_MAX   3


BOOL
__stdcall
SetupCopyOEMInfA(
     PCSTR SourceInfFileName,
     PCSTR OEMSourceMediaLocation,
     DWORD OEMSourceMediaType,
     DWORD CopyStyle,
    _Out_writes_opt_(DestinationInfFileNameSize) PSTR DestinationInfFileName,
     DWORD DestinationInfFileNameSize,
     PDWORD RequiredSize,
     PSTR *DestinationInfFileNameComponent
    );


BOOL
__stdcall
SetupCopyOEMInfW(
     PCWSTR SourceInfFileName,
     PCWSTR OEMSourceMediaLocation,
     DWORD OEMSourceMediaType,
     DWORD CopyStyle,
    _Out_writes_opt_(DestinationInfFileNameSize) PWSTR DestinationInfFileName,
     DWORD DestinationInfFileNameSize,
     PDWORD RequiredSize,
     PWSTR  *DestinationInfFileNameComponent
    );

if UNICODE
#define SetupCopyOEMInf SetupCopyOEMInfW
else
#define SetupCopyOEMInf SetupCopyOEMInfA
end

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then

//
// Flags used by SetupUninstallOEMInf
//
#define SUOI_FORCEDELETE   0x00000001

end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP

#if _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN

#define SUOI_INTERNAL1     0x00000002

end -- _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN


if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then

BOOL
__stdcall
SetupUninstallOEMInfA(
     PCSTR InfFileName,
     DWORD Flags,
     PVOID Reserved
    );


BOOL
__stdcall
SetupUninstallOEMInfW(
     PCWSTR InfFileName,
     DWORD Flags,
     PVOID Reserved
    );

if UNICODE
#define SetupUninstallOEMInf SetupUninstallOEMInfW
else
#define SetupUninstallOEMInf SetupUninstallOEMInfA
end



BOOL
__stdcall
SetupUninstallNewlyCopiedInfs(
     HSPFILEQ FileQueue,
     DWORD Flags,
     PVOID Reserved
    );

end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP


//
// Disk space list APIs
//

HDSKSPC
__stdcall
SetupCreateDiskSpaceListA(
     PVOID Reserved1,
     DWORD Reserved2,
     UINT Flags
    );


HDSKSPC
__stdcall
SetupCreateDiskSpaceListW(
     PVOID Reserved1,
     DWORD Reserved2,
     UINT Flags
    );

if UNICODE
#define SetupCreateDiskSpaceList SetupCreateDiskSpaceListW
else
#define SetupCreateDiskSpaceList SetupCreateDiskSpaceListA
end

//
// Flags for SetupCreateDiskSpaceList
//
#define SPDSL_IGNORE_DISK              0x00000001  // ignore deletes and on-disk files in copies
#define SPDSL_DISALLOW_NEGATIVE_ADJUST 0x00000002



HDSKSPC
__stdcall
SetupDuplicateDiskSpaceListA(
     HDSKSPC DiskSpace,
     PVOID Reserved1,
     DWORD Reserved2,
     UINT Flags
    );


HDSKSPC
__stdcall
SetupDuplicateDiskSpaceListW(
     HDSKSPC DiskSpace,
     PVOID Reserved1,
     DWORD Reserved2,
     UINT Flags
    );

if UNICODE
#define SetupDuplicateDiskSpaceList SetupDuplicateDiskSpaceListW
else
#define SetupDuplicateDiskSpaceList SetupDuplicateDiskSpaceListA
end



BOOL
__stdcall
SetupDestroyDiskSpaceList(
     HDSKSPC DiskSpace
    );



BOOL
__stdcall
SetupQueryDrivesInDiskSpaceListA(
     HDSKSPC DiskSpace,
     PSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );


BOOL
__stdcall
SetupQueryDrivesInDiskSpaceListW(
     HDSKSPC DiskSpace,
     PWSTR ReturnBuffer,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );

if UNICODE
#define SetupQueryDrivesInDiskSpaceList SetupQueryDrivesInDiskSpaceListW
else
#define SetupQueryDrivesInDiskSpaceList SetupQueryDrivesInDiskSpaceListA
end



BOOL
__stdcall
SetupQuerySpaceRequiredOnDriveA(
     HDSKSPC DiskSpace,
     PCSTR DriveSpec,
     LONGLONG *SpaceRequired,
     PVOID Reserved1,
     UINT Reserved2
    );


BOOL
__stdcall
SetupQuerySpaceRequiredOnDriveW(
     HDSKSPC DiskSpace,
     PCWSTR DriveSpec,
     LONGLONG *SpaceRequired,
     PVOID Reserved1,
     UINT Reserved2
    );

if UNICODE
#define SetupQuerySpaceRequiredOnDrive SetupQuerySpaceRequiredOnDriveW
else
#define SetupQuerySpaceRequiredOnDrive SetupQuerySpaceRequiredOnDriveA
end



BOOL
__stdcall
SetupAdjustDiskSpaceListA(
     HDSKSPC DiskSpace,
     LPCSTR DriveRoot,
     LONGLONG Amount,
     PVOID Reserved1,
     UINT Reserved2
    );


BOOL
__stdcall
SetupAdjustDiskSpaceListW(
     HDSKSPC DiskSpace,
     LPCWSTR DriveRoot,
     LONGLONG Amount,
     PVOID Reserved1,
     UINT Reserved2
    );

if UNICODE
#define SetupAdjustDiskSpaceList SetupAdjustDiskSpaceListW
else
#define SetupAdjustDiskSpaceList SetupAdjustDiskSpaceListA
end



BOOL
__stdcall
SetupAddToDiskSpaceListA(
     HDSKSPC DiskSpace,
     PCSTR TargetFilespec,
     LONGLONG FileSize,
     UINT Operation,
     PVOID Reserved1,
     UINT Reserved2
    );


BOOL
__stdcall
SetupAddToDiskSpaceListW(
     HDSKSPC DiskSpace,
     PCWSTR TargetFilespec,
     LONGLONG FileSize,
     UINT Operation,
     PVOID Reserved1,
     UINT Reserved2
    );

if UNICODE
#define SetupAddToDiskSpaceList SetupAddToDiskSpaceListW
else
#define SetupAddToDiskSpaceList SetupAddToDiskSpaceListA
end



BOOL
__stdcall
SetupAddSectionToDiskSpaceListA(
     HDSKSPC DiskSpace,
     HINF InfHandle,
     HINF ListInfHandle,
     PCSTR SectionName,
     UINT Operation,
     PVOID Reserved1,
     UINT Reserved2
    );


BOOL
__stdcall
SetupAddSectionToDiskSpaceListW(
     HDSKSPC DiskSpace,
     HINF InfHandle,
     HINF ListInfHandle,
     PCWSTR SectionName,
     UINT Operation,
     PVOID Reserved1,
     UINT Reserved2
    );

if UNICODE
#define SetupAddSectionToDiskSpaceList SetupAddSectionToDiskSpaceListW
else
#define SetupAddSectionToDiskSpaceList SetupAddSectionToDiskSpaceListA
end



BOOL
__stdcall
SetupAddInstallSectionToDiskSpaceListA(
     HDSKSPC DiskSpace,
     HINF InfHandle,
     HINF LayoutInfHandle,
     PCSTR SectionName,
     PVOID Reserved1,
     UINT Reserved2
    );


BOOL
__stdcall
SetupAddInstallSectionToDiskSpaceListW(
     HDSKSPC DiskSpace,
     HINF InfHandle,
     HINF LayoutInfHandle,
     PCWSTR SectionName,
     PVOID Reserved1,
     UINT Reserved2
    );

if UNICODE
#define SetupAddInstallSectionToDiskSpaceList SetupAddInstallSectionToDiskSpaceListW
else
#define SetupAddInstallSectionToDiskSpaceList SetupAddInstallSectionToDiskSpaceListA
end



BOOL
__stdcall
SetupRemoveFromDiskSpaceListA(
     HDSKSPC DiskSpace,
     PCSTR TargetFilespec,
     UINT Operation,
     PVOID Reserved1,
     UINT Reserved2
    );


BOOL
__stdcall
SetupRemoveFromDiskSpaceListW(
     HDSKSPC DiskSpace,
     PCWSTR TargetFilespec,
     UINT Operation,
     PVOID Reserved1,
     UINT Reserved2
    );

if UNICODE
#define SetupRemoveFromDiskSpaceList SetupRemoveFromDiskSpaceListW
else
#define SetupRemoveFromDiskSpaceList SetupRemoveFromDiskSpaceListA
end



BOOL
__stdcall
SetupRemoveSectionFromDiskSpaceListA(
     HDSKSPC DiskSpace,
     HINF InfHandle,
     HINF ListInfHandle,
     PCSTR SectionName,
     UINT Operation,
     PVOID Reserved1,
     UINT Reserved2
    );


BOOL
__stdcall
SetupRemoveSectionFromDiskSpaceListW(
     HDSKSPC DiskSpace,
     HINF InfHandle,
     HINF ListInfHandle,
     PCWSTR SectionName,
     UINT Operation,
     PVOID Reserved1,
     UINT Reserved2
    );

if UNICODE
#define SetupRemoveSectionFromDiskSpaceList SetupRemoveSectionFromDiskSpaceListW
else
#define SetupRemoveSectionFromDiskSpaceList SetupRemoveSectionFromDiskSpaceListA
end



BOOL
__stdcall
SetupRemoveInstallSectionFromDiskSpaceListA(
     HDSKSPC DiskSpace,
     HINF InfHandle,
     HINF LayoutInfHandle,
     PCSTR SectionName,
     PVOID Reserved1,
     UINT Reserved2
    );


BOOL
__stdcall
SetupRemoveInstallSectionFromDiskSpaceListW(
     HDSKSPC DiskSpace,
     HINF InfHandle,
     HINF LayoutInfHandle,
     PCWSTR SectionName,
     PVOID Reserved1,
     UINT Reserved2
    );

if UNICODE
#define SetupRemoveInstallSectionFromDiskSpaceList SetupRemoveInstallSectionFromDiskSpaceListW
else
#define SetupRemoveInstallSectionFromDiskSpaceList SetupRemoveInstallSectionFromDiskSpaceListA
end


//
// Cabinet APIs
//


BOOL
__stdcall
SetupIterateCabinetA(
     PCSTR CabinetFile,
     DWORD Reserved,
     PSP_FILE_CALLBACK_A MsgHandler,
     PVOID Context
    );


BOOL
__stdcall
SetupIterateCabinetW(
     PCWSTR CabinetFile,
     DWORD Reserved,
     PSP_FILE_CALLBACK_W MsgHandler,
     PVOID Context
    );

if UNICODE
#define SetupIterateCabinet SetupIterateCabinetW
else
#define SetupIterateCabinet SetupIterateCabinetA
end



INT
__stdcall
SetupPromptReboot(
     HSPFILEQ FileQueue,
     HWND Owner,
     BOOL ScanOnly
    );

//
// Define flags that are returned by SetupPromptReboot
//
#define SPFILEQ_FILE_IN_USE         0x00000001
#define SPFILEQ_REBOOT_RECOMMENDED  0x00000002
#define SPFILEQ_REBOOT_IN_PROGRESS  0x00000004



PVOID
__stdcall
SetupInitDefaultQueueCallback(
     HWND OwnerWindow
    );


PVOID
__stdcall
SetupInitDefaultQueueCallbackEx(
     HWND OwnerWindow,
     HWND AlternateProgressWindow,
     UINT ProgressMessage,
     DWORD Reserved1,
     PVOID Reserved2
    );


VOID
__stdcall
SetupTermDefaultQueueCallback(
     PVOID Context
    );


UINT
__stdcall
SetupDefaultQueueCallbackA(
     PVOID Context,
     UINT Notification,
     UINT_PTR Param1,
     UINT_PTR Param2
    );


UINT
__stdcall
SetupDefaultQueueCallbackW(
     PVOID Context,
     UINT Notification,
     UINT_PTR Param1,
     UINT_PTR Param2
    );

if UNICODE
#define SetupDefaultQueueCallback SetupDefaultQueueCallbackW
else
#define SetupDefaultQueueCallback SetupDefaultQueueCallbackA
end


//
// Flags for AddReg section lines in INF.  The corresponding value
// is <ValueType> in the AddReg line format given below:
//
// <RegRootString>,<SubKey>,<ValueName>,<ValueType>,<Value>...
//
// The low word contains basic flags concerning the general data type
// and AddReg action. The high word contains values that more specifically
// identify the data type of the registry value.  The high word is ignored
// by the 16-bit Windows 95 SETUPX APIs.
//
// If <ValueType> has FLG_ADDREG_DELREG_BIT set, it will be ignored by AddReg
// (not supported by SetupX).
//

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then

#define FLG_ADDREG_DELREG_BIT       ( 0x00008000 ) // if set, interpret as DELREG, see below

end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP

#define FLG_ADDREG_BINVALUETYPE     ( 0x00000001 )
#define FLG_ADDREG_NOCLOBBER        ( 0x00000002 )
#define FLG_ADDREG_DELVAL           ( 0x00000004 )
#define FLG_ADDREG_APPEND           ( 0x00000008 ) // Currently supported only
                                                   // for REG_MULTI_SZ values.
#define FLG_ADDREG_KEYONLY          ( 0x00000010 ) // Just create the key, ignore value
#define FLG_ADDREG_OVERWRITEONLY    ( 0x00000020 ) // Set only if value already exists

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then

#define FLG_ADDREG_64BITKEY         ( 0x00001000 ) // make this change in the 64 bit registry.
#define FLG_ADDREG_KEYONLY_COMMON   ( 0x00002000 ) // same as FLG_ADDREG_KEYONLY but also works for DELREG
#define FLG_ADDREG_32BITKEY         ( 0x00004000 ) // make this change in the 32 bit registry.

end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP

//
// The INF may supply any arbitrary data type ordinal in the highword except
// for the following: REG_NONE, REG_SZ, REG_EXPAND_SZ, REG_MULTI_SZ.  If this
// technique is used, then the data is given in binary format, one byte per
// field.
//
#define FLG_ADDREG_TYPE_MASK        ( 0xFFFF0000 | FLG_ADDREG_BINVALUETYPE )
#define FLG_ADDREG_TYPE_SZ          ( 0x00000000                           )
#define FLG_ADDREG_TYPE_MULTI_SZ    ( 0x00010000                           )
#define FLG_ADDREG_TYPE_EXPAND_SZ   ( 0x00020000                           )
#define FLG_ADDREG_TYPE_BINARY      ( 0x00000000 | FLG_ADDREG_BINVALUETYPE )
#define FLG_ADDREG_TYPE_DWORD       ( 0x00010000 | FLG_ADDREG_BINVALUETYPE )
#define FLG_ADDREG_TYPE_NONE        ( 0x00020000 | FLG_ADDREG_BINVALUETYPE )

#if _SETUPAPI_VER >= _WIN32_WINNT_WIN10

#define FLG_ADDREG_TYPE_QWORD       ( 0x000B0000 | FLG_ADDREG_BINVALUETYPE )

end -- _SETUPAPI_VER >= _WIN32_WINNT_WIN10

//
// Flags for DelReg section lines in INF.  The corresponding value
// is <Operation> in the extended DelReg line format given below:
//
// <RegRootString>,<SubKey>,<ValueName>,<Operation>[,...]
//
// In SetupX and some versions of SetupAPI, <Operation> will be ignored and <ValueName> will
// be deleted. Use with care.
//
// The bits determined by mask FLG_DELREG_TYPE_MASK indicates type of data expected.
// <Operation> must have FLG_ADDREG_DELREG_BIT set, otherwise it is ignored and specified
// value will be deleted (allowing an AddReg section to also be used as a DelReg section)
// if <Operation> is not specified, <ValueName> will be deleted (if specified) otherwise
// <SubKey> will be deleted.
//
// the compatability flag
//
#define FLG_DELREG_VALUE            (0x00000000)

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then

#define FLG_DELREG_TYPE_MASK        FLG_ADDREG_TYPE_MASK        // 0xFFFF0001
#define FLG_DELREG_TYPE_SZ          FLG_ADDREG_TYPE_SZ          // 0x00000000
#define FLG_DELREG_TYPE_MULTI_SZ    FLG_ADDREG_TYPE_MULTI_SZ    // 0x00010000
#define FLG_DELREG_TYPE_EXPAND_SZ   FLG_ADDREG_TYPE_EXPAND_SZ   // 0x00020000
#define FLG_DELREG_TYPE_BINARY      FLG_ADDREG_TYPE_BINARY      // 0x00000001
#define FLG_DELREG_TYPE_DWORD       FLG_ADDREG_TYPE_DWORD       // 0x00010001
#define FLG_DELREG_TYPE_NONE        FLG_ADDREG_TYPE_NONE        // 0x00020001
#define FLG_DELREG_64BITKEY         FLG_ADDREG_64BITKEY         // 0x00001000
#define FLG_DELREG_KEYONLY_COMMON   FLG_ADDREG_KEYONLY_COMMON   // 0x00002000
#define FLG_DELREG_32BITKEY         FLG_ADDREG_32BITKEY         // 0x00004000

//
// <Operation> = FLG_DELREG_MULTI_SZ_DELSTRING
//               <RegRootString>,<SubKey>,<ValueName>,0x00018002,<String>
//               removes all entries matching <String> (case ignored) from multi-sz registry value
//

#define FLG_DELREG_OPERATION_MASK   (0x000000FE)
#define FLG_DELREG_MULTI_SZ_DELSTRING ( FLG_DELREG_TYPE_MULTI_SZ | FLG_ADDREG_DELREG_BIT | 0x00000002 ) // 0x00018002

end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP

#if _SETUPAPI_VER >= _WIN32_WINNT_WIN10

#define FLG_DELREG_TYPE_QWORD       FLG_ADDREG_TYPE_QWORD       // 0x000B0001

end -- _SETUPAPI_VER >= _WIN32_WINNT_WIN10

//
// Flags for BitReg section lines in INF.
//
#define FLG_BITREG_CLEARBITS        ( 0x00000000 )
#define FLG_BITREG_SETBITS          ( 0x00000001 )

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then

#define FLG_BITREG_64BITKEY         ( 0x00001000 )
#define FLG_BITREG_32BITKEY         ( 0x00004000 )

end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP

//
// Flags for Ini2Reg section lines in INF.
//
if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then

#define FLG_INI2REG_64BITKEY        ( 0x00001000 )
#define FLG_INI2REG_32BITKEY        ( 0x00004000 )

end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP

//
// Flags for RegSvr section lines in INF
//
#define FLG_REGSVR_DLLREGISTER      ( 0x00000001 )
#define FLG_REGSVR_DLLINSTALL       ( 0x00000002 )

// Flags for RegSvr section lines in INF
//

#define FLG_PROFITEM_CURRENTUSER    ( 0x00000001 )
#define FLG_PROFITEM_DELETE         ( 0x00000002 )
#define FLG_PROFITEM_GROUP          ( 0x00000004 )
#define FLG_PROFITEM_CSIDL          ( 0x00000008 )

//
// Flags for AddProperty section lines in the INF
//

#define FLG_ADDPROPERTY_NOCLOBBER       ( 0x00000001 )
#define FLG_ADDPROPERTY_OVERWRITEONLY   ( 0x00000002 )
#define FLG_ADDPROPERTY_APPEND          ( 0x00000004 )
#define FLG_ADDPROPERTY_OR              ( 0x00000008 )
#define FLG_ADDPROPERTY_AND             ( 0x00000010 )

//
// Flags for DelProperty section lines in the INF
//

#define FLG_DELPROPERTY_MULTI_SZ_DELSTRING  ( 0x00000001 )



BOOL
__stdcall
SetupInstallFromInfSectionA(
     HWND Owner,
     HINF InfHandle,
     PCSTR SectionName,
     UINT Flags,
     HKEY RelativeKeyRoot,
     PCSTR SourceRootPath,
     UINT CopyFlags,
     PSP_FILE_CALLBACK_A MsgHandler,
     PVOID Context,
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData
    );


BOOL
__stdcall
SetupInstallFromInfSectionW(
     HWND Owner,
     HINF InfHandle,
     PCWSTR SectionName,
     UINT Flags,
     HKEY RelativeKeyRoot,
     PCWSTR SourceRootPath,
     UINT CopyFlags,
     PSP_FILE_CALLBACK_W MsgHandler,
     PVOID Context,
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData
    );

if UNICODE
#define SetupInstallFromInfSection SetupInstallFromInfSectionW
else
#define SetupInstallFromInfSection SetupInstallFromInfSectionA
end

//
// Flags for SetupInstallFromInfSection
//
#define SPINST_LOGCONFIG                0x00000001
#define SPINST_INIFILES                 0x00000002
#define SPINST_REGISTRY                 0x00000004
#define SPINST_INI2REG                  0x00000008
#define SPINST_FILES                    0x00000010
#define SPINST_BITREG                   0x00000020
#define SPINST_REGSVR                   0x00000040
#define SPINST_UNREGSVR                 0x00000080
#define SPINST_PROFILEITEMS             0x00000100

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then

#define SPINST_COPYINF                  0x00000200

#if _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN

#define SPINST_PROPERTIES               0x00000400
#define SPINST_ALL                      0x000007ff

else

#define SPINST_ALL                      0x000003ff

end -- _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN

else

#define SPINST_ALL                      0x000001ff

end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP

#define SPINST_SINGLESECTION            0x00010000
#define SPINST_LOGCONFIG_IS_FORCED      0x00020000
#define SPINST_LOGCONFIGS_ARE_OVERRIDES 0x00040000

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then

#define SPINST_REGISTERCALLBACKAWARE    0x00080000

end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP

#if _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN

#define SPINST_DEVICEINSTALL            0x00100000

end -- _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN


BOOL
__stdcall
SetupInstallFilesFromInfSectionA(
     HINF InfHandle,
     HINF LayoutInfHandle,
     HSPFILEQ FileQueue,
     PCSTR SectionName,
     PCSTR SourceRootPath,
     UINT CopyFlags
    );


BOOL
__stdcall
SetupInstallFilesFromInfSectionW(
     HINF InfHandle,
     HINF LayoutInfHandle,
     HSPFILEQ FileQueue,
     PCWSTR SectionName,
     PCWSTR SourceRootPath,
     UINT CopyFlags
    );

if UNICODE
#define SetupInstallFilesFromInfSection SetupInstallFilesFromInfSectionW
else
#define SetupInstallFilesFromInfSection SetupInstallFilesFromInfSectionA
end


//
// Flags for SetupInstallServicesFromInfSection(Ex).  These flags are also used
// in the flags field of AddService or DelService lines in a device INF.  Some
// of these flags are not permitted in the non-Ex API.  These flags are marked
// as such below.
//

//
// (AddService) move service's tag to front of its group order list
//
#define SPSVCINST_TAGTOFRONT                   (0x00000001)

//
// (AddService) **Ex API only** mark this service as the function driver for the
// device being installed
//
#define SPSVCINST_ASSOCSERVICE                 (0x00000002)

//
// (DelService) delete the associated event log entry for a service specified in
// a DelService entry
//
#define SPSVCINST_DELETEEVENTLOGENTRY          (0x00000004)

//
// (AddService) don't overwrite display name if it already exists
//
#define SPSVCINST_NOCLOBBER_DISPLAYNAME        (0x00000008)

//
// (AddService) don't overwrite start type value if service already exists
//
#define SPSVCINST_NOCLOBBER_STARTTYPE          (0x00000010)

//
// (AddService) don't overwrite error control value if service already exists
//
#define SPSVCINST_NOCLOBBER_ERRORCONTROL       (0x00000020)

//
// (AddService) don't overwrite load order group if it already exists
//
#define SPSVCINST_NOCLOBBER_LOADORDERGROUP     (0x00000040)

//
// (AddService) don't overwrite dependencies list if it already exists
//
#define SPSVCINST_NOCLOBBER_DEPENDENCIES       (0x00000080)

//
// (AddService) don't overwrite description if it already exists
//
#define SPSVCINST_NOCLOBBER_DESCRIPTION        (0x00000100)
//
// (DelService) stop the associated service specified in
// a DelService entry before deleting the service
//
#define SPSVCINST_STOPSERVICE                  (0x00000200)

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then
//
// (AddService) force overwrite of security settings
//
#define SPSVCINST_CLOBBER_SECURITY             (0x00000400)

end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP

#if _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN
//
// (Start Service) start a service manually after install
//
#define SPSVCINST_STARTSERVICE                 (0x00000800)

end -- _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN

#if _SETUPAPI_VER >= _WIN32_WINNT_WIN7
//
// (AddService) don't overwrite required privileges list if it already exists
//
#define SPSVCINST_NOCLOBBER_REQUIREDPRIVILEGES (0x00001000)

end -- _SETUPAPI_VER >= _WIN32_WINNT_WIN7

#if _SETUPAPI_VER >= _WIN32_WINNT_WIN10
//
// (AddService) don't overwrite triggers if they already exist
//
#define SPSVCINST_NOCLOBBER_TRIGGERS (0x00002000)

end -- _SETUPAPI_VER >= _WIN32_WINNT_WIN10


BOOL
__stdcall
SetupInstallServicesFromInfSectionA(
     HINF InfHandle,
     PCSTR SectionName,
     DWORD Flags
    );


BOOL
__stdcall
SetupInstallServicesFromInfSectionW(
     HINF InfHandle,
     PCWSTR SectionName,
     DWORD Flags
    );

if UNICODE
#define SetupInstallServicesFromInfSection SetupInstallServicesFromInfSectionW
else
#define SetupInstallServicesFromInfSection SetupInstallServicesFromInfSectionA
end
--]]


BOOL
__stdcall
SetupInstallServicesFromInfSectionExA(
     HINF InfHandle,
     PCSTR SectionName,
     DWORD Flags,
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     PVOID Reserved1,
     PVOID Reserved2
    );


BOOL
__stdcall
SetupInstallServicesFromInfSectionExW(
     HINF InfHandle,
     PCWSTR SectionName,
     DWORD Flags,
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     PVOID Reserved1,
     PVOID Reserved2
    );

if UNICODE
#define SetupInstallServicesFromInfSectionEx SetupInstallServicesFromInfSectionExW
else
#define SetupInstallServicesFromInfSectionEx SetupInstallServicesFromInfSectionExA
end
--]]


//
// High level routine, usually used via rundll32.dll
// to perform right-click install action on INFs
// May be called directly:
//
// wsprintf(CmdLineBuffer,TEXT("DefaultInstall 132 %s"),InfPath);
// InstallHinfSection(NULL,NULL,CmdLineBuffer,0);
//
VOID
__stdcall
InstallHinfSectionA(
     HWND Window,
     HINSTANCE ModuleHandle,
     PCSTR CommandLine,
     INT ShowCommand
    );

VOID
__stdcall
InstallHinfSectionW(
     HWND Window,
     HINSTANCE ModuleHandle,
     PCWSTR CommandLine,
     INT ShowCommand
    );

if UNICODE
#define InstallHinfSection InstallHinfSectionW
else
#define InstallHinfSection InstallHinfSectionA
end
--]]




//
// Define handle type for Setup file log.
//
typedef PVOID HSPFILELOG;


HSPFILELOG
__stdcall
SetupInitializeFileLogA(
     PCSTR LogFileName,
     DWORD Flags
    );


HSPFILELOG
__stdcall
SetupInitializeFileLogW(
     PCWSTR LogFileName,
     DWORD Flags
    );

if UNICODE
#define SetupInitializeFileLog SetupInitializeFileLogW
else
#define SetupInitializeFileLog SetupInitializeFileLogA
end
--]]

//
// Flags for SetupInitializeFileLog
//
#define SPFILELOG_SYSTEMLOG     0x00000001  // use system log -- must be Administrator
#define SPFILELOG_FORCENEW      0x00000002  // not valid with SPFILELOG_SYSTEMLOG
#define SPFILELOG_QUERYONLY     0x00000004  // allows non-administrators to read system log



BOOL
__stdcall
SetupTerminateFileLog(
     HSPFILELOG FileLogHandle
    );



BOOL
__stdcall
SetupLogFileA(
     HSPFILELOG FileLogHandle,
     PCSTR LogSectionName,
     PCSTR SourceFilename,
     PCSTR TargetFilename,
     DWORD Checksum,
     PCSTR DiskTagfile,
     PCSTR DiskDescription,
     PCSTR OtherInfo,
     DWORD Flags
    );


BOOL
__stdcall
SetupLogFileW(
     HSPFILELOG FileLogHandle,
     PCWSTR LogSectionName,
     PCWSTR SourceFilename,
     PCWSTR TargetFilename,
     DWORD Checksum,
     PCWSTR DiskTagfile,
     PCWSTR DiskDescription,
     PCWSTR OtherInfo,
     DWORD Flags
    );

if UNICODE
#define SetupLogFile SetupLogFileW
else
#define SetupLogFile SetupLogFileA
end
--]]
//
// Flags for SetupLogFile
//
#define SPFILELOG_OEMFILE   0x00000001



BOOL
__stdcall
SetupRemoveFileLogEntryA(
     HSPFILELOG FileLogHandle,
     PCSTR LogSectionName,
     PCSTR TargetFilename
    );


BOOL
__stdcall
SetupRemoveFileLogEntryW(
     HSPFILELOG FileLogHandle,
     PCWSTR LogSectionName,
     PCWSTR TargetFilename
    );

if UNICODE
#define SetupRemoveFileLogEntry SetupRemoveFileLogEntryW
else
#define SetupRemoveFileLogEntry SetupRemoveFileLogEntryA
end
--]]

//
// Items retrievable from SetupQueryFileLog()
//
typedef enum {
    SetupFileLogSourceFilename,
    SetupFileLogChecksum,
    SetupFileLogDiskTagfile,
    SetupFileLogDiskDescription,
    SetupFileLogOtherInfo,
    SetupFileLogMax
} SetupFileLogInfo;


BOOL
__stdcall
SetupQueryFileLogA(
     HSPFILELOG FileLogHandle,
     PCSTR LogSectionName,
     PCSTR TargetFilename,
     SetupFileLogInfo DesiredInfo,
     PSTR DataOut,
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );


BOOL
__stdcall
SetupQueryFileLogW(
     HSPFILELOG FileLogHandle,
     PCWSTR LogSectionName, 
     PCWSTR TargetFilename,
     SetupFileLogInfo DesiredInfo,
     PWSTR DataOut, 
     DWORD ReturnBufferSize,
     PDWORD RequiredSize
    );

if UNICODE
#define SetupQueryFileLog SetupQueryFileLogW
else
#define SetupQueryFileLog SetupQueryFileLogA
end
--]]

//
// Text logging APIs
//
#define LogSeverity                 DWORD
#define LogSevInformation           0x00000000
#define LogSevWarning               0x00000001
#define LogSevError                 0x00000002
#define LogSevFatalError            0x00000003
#define LogSevMaximum               0x00000004


BOOL
__stdcall
SetupOpenLog (
     BOOL Erase
    );


BOOL
__stdcall
SetupLogErrorA (
     LPCSTR MessageString,
     LogSeverity Severity
    );


BOOL
__stdcall
SetupLogErrorW (
     LPCWSTR MessageString,
     LogSeverity Severity
    );

if UNICODE
#define SetupLogError SetupLogErrorW
else
#define SetupLogError SetupLogErrorA
end
--]]

VOID
__stdcall
SetupCloseLog (
    VOID
    );

//
// Text log for INF debugging
//

#if _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN



SP_LOG_TOKEN
__stdcall
SetupGetThreadLogToken(
    VOID
    );


VOID
__stdcall
SetupSetThreadLogToken(
     SP_LOG_TOKEN LogToken
    );


VOID
__stdcall
SetupWriteTextLog(
     SP_LOG_TOKEN LogToken,
     DWORD Category,
     DWORD Flags,
     PCSTR MessageStr,
    ...
    );
    

VOID
__stdcall
SetupWriteTextLogError(
     SP_LOG_TOKEN LogToken,
     DWORD Category,
     DWORD LogFlags,
     DWORD Error,
     PCSTR MessageStr,
    ...
    );
    

VOID
__stdcall
SetupWriteTextLogInfLine(
     SP_LOG_TOKEN LogToken,
     DWORD Flags,
     HINF InfHandle,
     PINFCONTEXT Context
    );

end -- _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN


//
// Backup Information APIs
//


BOOL
__stdcall
SetupGetBackupInformationA(
     HSPFILEQ QueueHandle,
     PSP_BACKUP_QUEUE_PARAMS_A BackupParams
    );


BOOL
__stdcall
SetupGetBackupInformationW(
     HSPFILEQ QueueHandle,
     PSP_BACKUP_QUEUE_PARAMS_W BackupParams
    );

if UNICODE
#define SetupGetBackupInformation SetupGetBackupInformationW
else
#define SetupGetBackupInformation SetupGetBackupInformationA
end
--]]
if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then


BOOL
__stdcall
SetupPrepareQueueForRestoreA(
     HSPFILEQ QueueHandle,
     PCSTR BackupPath,
     DWORD RestoreFlags
    );


BOOL
__stdcall
SetupPrepareQueueForRestoreW(
     HSPFILEQ QueueHandle,
     PCWSTR BackupPath,
     DWORD RestoreFlags
    );

if UNICODE
#define SetupPrepareQueueForRestore SetupPrepareQueueForRestoreW
else
#define SetupPrepareQueueForRestore SetupPrepareQueueForRestoreA
end
--]]
end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then

//
// Control forcing of Non-Interactive Mode
// Overriden if SetupAPI is run in non-interactive window session
//


BOOL
__stdcall
SetupSetNonInteractiveMode(
     BOOL NonInteractiveFlag
    );


BOOL
__stdcall
SetupGetNonInteractiveMode(
    VOID
    );

end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP

//
// Device Installer APIs
//



HDEVINFO
__stdcall
SetupDiCreateDeviceInfoList(
     const GUID *ClassGuid,
     HWND hwndParent
    );




HDEVINFO
__stdcall
SetupDiCreateDeviceInfoListExA(
     const GUID *ClassGuid,
     HWND hwndParent,
     PCSTR MachineName,
     PVOID Reserved
    );



HDEVINFO
__stdcall
SetupDiCreateDeviceInfoListExW(
     const GUID *ClassGuid,
     HWND hwndParent, 
     PCWSTR MachineName, 
     PVOID Reserved
    );

if UNICODE
#define SetupDiCreateDeviceInfoListEx SetupDiCreateDeviceInfoListExW
else
#define SetupDiCreateDeviceInfoListEx SetupDiCreateDeviceInfoListExA
end
--]]


BOOL
__stdcall
SetupDiGetDeviceInfoListClass(
     HDEVINFO DeviceInfoSet,
     LPGUID ClassGuid
    );


BOOL
__stdcall
SetupDiGetDeviceInfoListDetailA(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_LIST_DETAIL_DATA_A DeviceInfoSetDetailData
    );


BOOL
__stdcall
SetupDiGetDeviceInfoListDetailW(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_LIST_DETAIL_DATA_W DeviceInfoSetDetailData
    );

if UNICODE
#define SetupDiGetDeviceInfoListDetail SetupDiGetDeviceInfoListDetailW
else
#define SetupDiGetDeviceInfoListDetail SetupDiGetDeviceInfoListDetailA
end
--]]

//
// Flags for SetupDiCreateDeviceInfo
//
#define DICD_GENERATE_ID        0x00000001
#define DICD_INHERIT_CLASSDRVS  0x00000002


BOOL
__stdcall
SetupDiCreateDeviceInfoA(
     HDEVINFO DeviceInfoSet,
     PCSTR DeviceName,
     const GUID *ClassGuid,
     PCSTR DeviceDescription,
     HWND hwndParent,
     DWORD CreationFlags,
     PSP_DEVINFO_DATA DeviceInfoData
    );


BOOL
__stdcall
SetupDiCreateDeviceInfoW(
     HDEVINFO DeviceInfoSet,
     PCWSTR DeviceName,
     const GUID *ClassGuid,
     PCWSTR DeviceDescription,
     HWND hwndParent,
     DWORD CreationFlags,
     PSP_DEVINFO_DATA DeviceInfoData
    );

if UNICODE
#define SetupDiCreateDeviceInfo SetupDiCreateDeviceInfoW
else
#define SetupDiCreateDeviceInfo SetupDiCreateDeviceInfoA
end
--]]

//
// Flags for SetupDiOpenDeviceInfo
//
#define DIOD_INHERIT_CLASSDRVS  0x00000002
#define DIOD_CANCEL_REMOVE      0x00000004


BOOL
__stdcall
SetupDiOpenDeviceInfoA(
     HDEVINFO DeviceInfoSet,
     PCSTR DeviceInstanceId,
     HWND hwndParent,
     DWORD OpenFlags,
     PSP_DEVINFO_DATA DeviceInfoData
    );


BOOL
__stdcall
SetupDiOpenDeviceInfoW(
     HDEVINFO DeviceInfoSet,
     PCWSTR DeviceInstanceId,
     HWND hwndParent,
     DWORD OpenFlags,
     PSP_DEVINFO_DATA DeviceInfoData
    );

if UNICODE
#define SetupDiOpenDeviceInfo SetupDiOpenDeviceInfoW
else
#define SetupDiOpenDeviceInfo SetupDiOpenDeviceInfoA
end
--]]


BOOL
__stdcall
SetupDiGetDeviceInstanceIdA(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
    _Out_writes_opt_(DeviceInstanceIdSize) PSTR DeviceInstanceId,
     DWORD DeviceInstanceIdSize,
     PDWORD RequiredSize
    );


BOOL
__stdcall
SetupDiGetDeviceInstanceIdW(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
    _Out_writes_opt_(DeviceInstanceIdSize) PWSTR DeviceInstanceId,
     DWORD DeviceInstanceIdSize,
     PDWORD RequiredSize
    );
]]

--[[
if UNICODE
#define SetupDiGetDeviceInstanceId SetupDiGetDeviceInstanceIdW
else
#define SetupDiGetDeviceInstanceId SetupDiGetDeviceInstanceIdA
end
--]]
--]=]

ffi.cdef[[
BOOL
__stdcall
SetupDiDeleteDeviceInfo(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData
    );



BOOL
__stdcall
SetupDiEnumDeviceInfo(
     HDEVINFO DeviceInfoSet,
     DWORD MemberIndex,
     PSP_DEVINFO_DATA DeviceInfoData
    );



BOOL
__stdcall
SetupDiDestroyDeviceInfoList(
     HDEVINFO DeviceInfoSet
    );



BOOL
__stdcall
SetupDiEnumDeviceInterfaces(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     const GUID *InterfaceClassGuid,
     DWORD MemberIndex,
     PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData
    );
]]



ffi.cdef[[
BOOL
__stdcall
SetupDiCreateDeviceInterfaceA(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     const GUID *InterfaceClassGuid,
     PCSTR ReferenceString,
     DWORD CreationFlags,
     PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData
    );


BOOL
__stdcall
SetupDiCreateDeviceInterfaceW(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     const GUID *InterfaceClassGuid,
     PCWSTR ReferenceString,
     DWORD CreationFlags,
     PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData 
    );
]]



--[[

#define SetupDiEnumInterfaceDevice SetupDiEnumDeviceInterfaces

//
// Backward compatibility--do not use.
//
#define SetupDiCreateInterfaceDeviceW SetupDiCreateDeviceInterfaceW
#define SetupDiCreateInterfaceDeviceA SetupDiCreateDeviceInterfaceA
if UNICODE
#define SetupDiCreateInterfaceDevice SetupDiCreateDeviceInterfaceW
else
#define SetupDiCreateInterfaceDevice SetupDiCreateDeviceInterfaceA
end
--]]

ffi.cdef[[
//
// Flags for SetupDiOpenDeviceInterface
//
static const int DIODI_NO_ADD   = 0x00000001;
]]

ffi.cdef[[
BOOL
__stdcall
SetupDiOpenDeviceInterfaceA(
     HDEVINFO DeviceInfoSet,
     PCSTR DevicePath,
     DWORD OpenFlags,
     PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData
    );

BOOL
__stdcall
SetupDiOpenDeviceInterfaceW(
     HDEVINFO DeviceInfoSet,
     PCWSTR DevicePath,
     DWORD OpenFlags,
     PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData
    );

BOOL
__stdcall
SetupDiGetDeviceInterfaceAlias(
     HDEVINFO DeviceInfoSet,
     PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData,
     const GUID *AliasInterfaceClassGuid,
     PSP_DEVICE_INTERFACE_DATA AliasDeviceInterfaceData
    );

BOOL
__stdcall
SetupDiDeleteDeviceInterfaceData(
     HDEVINFO DeviceInfoSet,
     PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData
    );

BOOL
__stdcall
SetupDiRemoveDeviceInterface(
     HDEVINFO DeviceInfoSet,
     PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData
    );

BOOL
__stdcall
SetupDiGetDeviceInterfaceDetailA(
     HDEVINFO DeviceInfoSet,
     PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData,
     PSP_DEVICE_INTERFACE_DETAIL_DATA_A DeviceInterfaceDetailData, 
     DWORD DeviceInterfaceDetailDataSize,
      PDWORD RequiredSize,
     PSP_DEVINFO_DATA DeviceInfoData
    );

BOOL
__stdcall
SetupDiGetDeviceInterfaceDetailW(
     HDEVINFO DeviceInfoSet,
     PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData,
     PSP_DEVICE_INTERFACE_DETAIL_DATA_W DeviceInterfaceDetailData,
     DWORD DeviceInterfaceDetailDataSize,
      PDWORD RequiredSize,
     PSP_DEVINFO_DATA DeviceInfoData
    );
]]

ffi.cdef[[
BOOL
__stdcall
SetupDiInstallDeviceInterfaces(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData
    );
]]


if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then

ffi.cdef[[
BOOL
__stdcall
SetupDiSetDeviceInterfaceDefault(
     HDEVINFO DeviceInfoSet,
     PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData,
     DWORD Flags,
     PVOID Reserved
    );
]]
end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP


ffi.cdef[[
static const int SPRDI_FIND_DUPS      =  0x00000001;


BOOL
__stdcall
SetupDiRegisterDeviceInfo(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     DWORD Flags,
     PSP_DETSIG_CMPPROC CompareProc,
     PVOID CompareContext,
     PSP_DEVINFO_DATA DupDeviceInfoData
    );
]]

--[[
//
// Backward compatibility--do not use.
//
#define SetupDiOpenInterfaceDeviceW SetupDiOpenDeviceInterfaceW
#define SetupDiOpenInterfaceDeviceA SetupDiOpenDeviceInterfaceA

#define SetupDiGetInterfaceDeviceAlias SetupDiGetDeviceInterfaceAlias

#define SetupDiDeleteInterfaceDeviceData SetupDiDeleteDeviceInterfaceData
#define SetupDiRemoveInterfaceDevice SetupDiRemoveDeviceInterface


#define SetupDiGetInterfaceDeviceDetailW SetupDiGetDeviceInterfaceDetailW
#define SetupDiGetInterfaceDeviceDetailA SetupDiGetDeviceInterfaceDetailA

#define SetupDiInstallInterfaceDevices SetupDiInstallDeviceInterfaces

--]]

ffi.cdef[[
//
// Ordinal values distinguishing between class drivers and
// device drivers.
// (Passed in 'DriverType' parameter of driver information list APIs)
//
static const int SPDIT_NODRIVER         =  0x00000000;
static const int SPDIT_CLASSDRIVER      =  0x00000001;
static const int SPDIT_COMPATDRIVER     =  0x00000002;
]]

ffi.cdef[[
BOOL
__stdcall
SetupDiBuildDriverInfoList(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     DWORD DriverType
    );



BOOL
__stdcall
SetupDiCancelDriverInfoSearch(
     HDEVINFO DeviceInfoSet
    );



BOOL
__stdcall
SetupDiEnumDriverInfoA(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     DWORD DriverType,
     DWORD MemberIndex,
     PSP_DRVINFO_DATA_A DriverInfoData
    );


BOOL
__stdcall
SetupDiEnumDriverInfoW(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     DWORD DriverType,
     DWORD MemberIndex,
     PSP_DRVINFO_DATA_W DriverInfoData
    );
]]



ffi.cdef[[
BOOL
__stdcall
SetupDiGetSelectedDriverA(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     PSP_DRVINFO_DATA_A DriverInfoData
    );


BOOL
__stdcall
SetupDiGetSelectedDriverW(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     PSP_DRVINFO_DATA_W DriverInfoData
    );
]]



ffi.cdef[[
BOOL
__stdcall
SetupDiSetSelectedDriverA(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     PSP_DRVINFO_DATA_A DriverInfoData
    );


BOOL
__stdcall
SetupDiSetSelectedDriverW(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     PSP_DRVINFO_DATA_W DriverInfoData
    );
]]



ffi.cdef[[
BOOL
__stdcall
SetupDiGetDriverInfoDetailA(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     PSP_DRVINFO_DATA_A DriverInfoData,
     PSP_DRVINFO_DETAIL_DATA_A DriverInfoDetailData, 
     DWORD DriverInfoDetailDataSize,
     PDWORD RequiredSize
    );


BOOL
__stdcall
SetupDiGetDriverInfoDetailW(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     PSP_DRVINFO_DATA_W DriverInfoData,
     PSP_DRVINFO_DETAIL_DATA_W DriverInfoDetailData,
     DWORD DriverInfoDetailDataSize,
     PDWORD RequiredSize
    );
]]



ffi.cdef[[
BOOL
__stdcall
SetupDiDestroyDriverInfoList(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     DWORD DriverType
    );
]]

ffi.cdef[[
//
// Flags controlling what is included in the device information set built
// by SetupDiGetClassDevs
//
static const int DIGCF_DEFAULT         =  0x00000001;  // only valid with DIGCF_DEVICEINTERFACE
static const int DIGCF_PRESENT         =  0x00000002;
static const int DIGCF_ALLCLASSES      =  0x00000004;
static const int DIGCF_PROFILE         =  0x00000008;
static const int DIGCF_DEVICEINTERFACE =  0x00000010;

//
// Backward compatibility--do not use.
//
static const int DIGCF_INTERFACEDEVICE = DIGCF_DEVICEINTERFACE;
]]


ffi.cdef[[
HDEVINFO
__stdcall
SetupDiGetClassDevsA(
     const GUID *ClassGuid,
     PCSTR Enumerator,
     HWND hwndParent,
     DWORD Flags
    );



HDEVINFO
__stdcall
SetupDiGetClassDevsW(
     const GUID *ClassGuid,
     PCWSTR Enumerator,
     HWND hwndParent,
     DWORD Flags
    );
]]

--[[
if UNICODE
#define SetupDiGetClassDevs SetupDiGetClassDevsW
else
#define SetupDiGetClassDevs SetupDiGetClassDevsA
end
--]]

ffi.cdef[[
HDEVINFO
__stdcall
SetupDiGetClassDevsExA(
     const GUID *ClassGuid,
     PCSTR Enumerator,
     HWND hwndParent,
     DWORD Flags,
     HDEVINFO DeviceInfoSet,
     PCSTR MachineName,
     PVOID Reserved
    );



HDEVINFO
__stdcall
SetupDiGetClassDevsExW(
     const GUID *ClassGuid,
     PCWSTR Enumerator,
     HWND hwndParent,
     DWORD Flags,
     HDEVINFO DeviceInfoSet,
     PCWSTR MachineName,
     PVOID Reserved
    );
]]

--[[
if UNICODE
#define SetupDiGetClassDevsEx SetupDiGetClassDevsExW
else
#define SetupDiGetClassDevsEx SetupDiGetClassDevsExA
end
--]]

ffi.cdef[[
BOOL
__stdcall
SetupDiGetINFClassA(
     PCSTR InfName,
     LPGUID ClassGuid,
     PSTR ClassName,
     DWORD ClassNameSize,
     PDWORD RequiredSize
    );


BOOL
__stdcall
SetupDiGetINFClassW(
     PCWSTR InfName,
     LPGUID ClassGuid,
     PWSTR ClassName,
     DWORD ClassNameSize,
     PDWORD RequiredSize
    );
]]


ffi.cdef[[
//
// Flags controlling exclusion from the class information list built
// by SetupDiBuildClassInfoList(Ex)
//
static const int DIBCI_NOINSTALLCLASS  = 0x00000001;
static const int DIBCI_NODISPLAYCLASS  = 0x00000002;



BOOL
__stdcall
SetupDiBuildClassInfoList(
     DWORD Flags,
     LPGUID ClassGuidList,
     DWORD ClassGuidListSize,
     PDWORD RequiredSize
    );



BOOL
__stdcall
SetupDiBuildClassInfoListExA(
     DWORD Flags,
     LPGUID ClassGuidList,
     DWORD ClassGuidListSize,
     PDWORD RequiredSize,
     PCSTR MachineName,
     PVOID Reserved
    );



BOOL
__stdcall
SetupDiBuildClassInfoListExW(
     DWORD Flags,
     LPGUID ClassGuidList,
     DWORD ClassGuidListSize,
     PDWORD RequiredSize,
     PCWSTR MachineName,
     PVOID Reserved
    );



BOOL
__stdcall
SetupDiGetClassDescriptionA(
     const GUID *ClassGuid,
     PSTR ClassDescription,
     DWORD ClassDescriptionSize,
     PDWORD RequiredSize
    );


BOOL
__stdcall
SetupDiGetClassDescriptionW(
     const GUID *ClassGuid,
     PWSTR ClassDescription,
     DWORD ClassDescriptionSize,
     PDWORD RequiredSize
    );



BOOL
__stdcall
SetupDiGetClassDescriptionExA(
     const GUID *ClassGuid,
     PSTR ClassDescription,
     DWORD ClassDescriptionSize,
     PDWORD RequiredSize,
     PCSTR MachineName,
     PVOID Reserved
    );


BOOL
__stdcall
SetupDiGetClassDescriptionExW(
     const GUID *ClassGuid,
     PWSTR ClassDescription,
     DWORD ClassDescriptionSize,
     PDWORD RequiredSize,
     PCWSTR MachineName,
     PVOID Reserved
    );





BOOL
__stdcall
SetupDiCallClassInstaller(
     DI_FUNCTION InstallFunction,
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData
    );
]]


ffi.cdef[[
BOOL
__stdcall
SetupDiSelectDevice(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData
    );


BOOL
__stdcall
SetupDiSelectBestCompatDrv(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData
    );


BOOL
__stdcall
SetupDiInstallDevice(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData
    );

BOOL
__stdcall
SetupDiInstallDriverFiles(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData
    );


BOOL
__stdcall
SetupDiRegisterCoDeviceInstallers(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData
    );

BOOL
__stdcall
SetupDiRemoveDevice(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData
    );




BOOL
__stdcall
SetupDiUnremoveDevice(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData
    );
]]


if _SETUPAPI_VER >= _WIN32_WINNT_WS03 then

ffi.cdef[[
BOOL
__stdcall
SetupDiRestartDevices(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData
    );
]]
end -- _SETUPAPI_VER >= _WIN32_WINNT_WS03

ffi.cdef[[

BOOL
__stdcall
SetupDiChangeState(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData
    );



BOOL
__stdcall
SetupDiInstallClassA(
     HWND hwndParent,
     PCSTR InfFileName,
     DWORD Flags,
     HSPFILEQ FileQueue
    );


BOOL
__stdcall
SetupDiInstallClassW(
     HWND hwndParent,
     PCWSTR InfFileName,
     DWORD Flags,
     HSPFILEQ FileQueue
    );





BOOL
__stdcall
SetupDiInstallClassExA(
     HWND hwndParent,
     PCSTR InfFileName,
     DWORD Flags,
     HSPFILEQ FileQueue,
     const GUID *InterfaceClassGuid,
     PVOID Reserved1,
     PVOID Reserved2
    );


BOOL
__stdcall
SetupDiInstallClassExW(
     HWND hwndParent,
     PCWSTR InfFileName,
     DWORD Flags,
     HSPFILEQ FileQueue,
     const GUID *InterfaceClassGuid,
     PVOID Reserved1,
     PVOID Reserved2
    );




HKEY
__stdcall
SetupDiOpenClassRegKey(
     const GUID *ClassGuid,
     REGSAM samDesired
    );
]]

ffi.cdef[[
//
// Flags for SetupDiOpenClassRegKeyEx
//
static const int DIOCR_INSTALLER  = 0x00000001;    // class installer registry branch
static const int DIOCR_INTERFACE  = 0x00000002;    // interface class registry branch



HKEY
__stdcall
SetupDiOpenClassRegKeyExA(
     const GUID *ClassGuid,
     REGSAM samDesired,
     DWORD Flags,
     PCSTR MachineName,
     PVOID Reserved
    );



HKEY
__stdcall
SetupDiOpenClassRegKeyExW(
     const GUID *ClassGuid,
     REGSAM samDesired,
     DWORD Flags,
     PCWSTR MachineName,
     PVOID Reserved
    );

HKEY
__stdcall
SetupDiCreateDeviceInterfaceRegKeyA(
     HDEVINFO DeviceInfoSet,
     PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData,
     DWORD Reserved,
     REGSAM samDesired,
     HINF InfHandle,
     PCSTR InfSectionName
    );



HKEY
__stdcall
SetupDiCreateDeviceInterfaceRegKeyW(
     HDEVINFO DeviceInfoSet,
     PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData,
     DWORD Reserved,
     REGSAM samDesired,
     HINF InfHandle,
     PCWSTR InfSectionName
    );

HKEY
__stdcall
SetupDiOpenDeviceInterfaceRegKey(
     HDEVINFO DeviceInfoSet,
     PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData,
     DWORD Reserved,
     REGSAM samDesired
    );

BOOL
__stdcall
SetupDiDeleteDeviceInterfaceRegKey(
     HDEVINFO DeviceInfoSet,
     PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData,
     DWORD Reserved
    );
]]

--[[
//
// Backward compatibility--do not use.
//
#define SetupDiCreateInterfaceDeviceRegKeyW SetupDiCreateDeviceInterfaceRegKeyW
#define SetupDiCreateInterfaceDeviceRegKeyA SetupDiCreateDeviceInterfaceRegKeyA
if UNICODE
#define SetupDiCreateInterfaceDeviceRegKey SetupDiCreateDeviceInterfaceRegKeyW
else
#define SetupDiCreateInterfaceDeviceRegKey SetupDiCreateDeviceInterfaceRegKeyA
end
#define SetupDiOpenInterfaceDeviceRegKey SetupDiOpenDeviceInterfaceRegKey

#define SetupDiDeleteInterfaceDeviceRegKey SetupDiDeleteDeviceInterfaceRegKey
--]]

ffi.cdef[[
//
// KeyType values for SetupDiCreateDevRegKey, SetupDiOpenDevRegKey, and
// SetupDiDeleteDevRegKey.
//
static const int DIREG_DEV     =  0x00000001;          // Open/Create/Delete device key
static const int DIREG_DRV     =  0x00000002;          // Open/Create/Delete driver key
static const int DIREG_BOTH    =  0x00000004;          // Delete both driver and Device key



HKEY
__stdcall
SetupDiCreateDevRegKeyA(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     DWORD Scope,
     DWORD HwProfile,
     DWORD KeyType,
     HINF InfHandle,
     PCSTR InfSectionName
    );



HKEY
__stdcall
SetupDiCreateDevRegKeyW(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     DWORD Scope,
     DWORD HwProfile,
     DWORD KeyType,
     HINF InfHandle,
     PCWSTR InfSectionName
    );





HKEY
__stdcall
SetupDiOpenDevRegKey(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     DWORD Scope,
     DWORD HwProfile,
     DWORD KeyType,
     REGSAM samDesired
    );



BOOL
__stdcall
SetupDiDeleteDevRegKey(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     DWORD Scope,
     DWORD HwProfile,
     DWORD KeyType
    );



BOOL
__stdcall
SetupDiGetHwProfileList(
     PDWORD HwProfileList,
     DWORD HwProfileListSize,
     PDWORD RequiredSize,
     PDWORD CurrentlyActiveIndex
    );



BOOL
__stdcall
SetupDiGetHwProfileListExA(
     PDWORD HwProfileList,
     DWORD HwProfileListSize,
     PDWORD RequiredSize,
     PDWORD CurrentlyActiveIndex,
     PCSTR MachineName,
     PVOID Reserved
    );



BOOL
__stdcall
SetupDiGetHwProfileListExW(
     PDWORD HwProfileList,
     DWORD HwProfileListSize,
     PDWORD RequiredSize,
     PDWORD CurrentlyActiveIndex,
     PCWSTR MachineName,
     PVOID Reserved
    );

]]

if _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN then

ffi.cdef[[
BOOL
__stdcall
SetupDiGetDevicePropertyKeys(
             HDEVINFO         DeviceInfoSet,
             PSP_DEVINFO_DATA DeviceInfoData,
     DEVPROPKEY *PropertyKeyArray,
             DWORD            PropertyKeyCount,
        PDWORD           RequiredPropertyKeyCount,
             DWORD            Flags
    );



BOOL
__stdcall
SetupDiGetDevicePropertyW(
             HDEVINFO         DeviceInfoSet,
             PSP_DEVINFO_DATA DeviceInfoData,
       const DEVPROPKEY      *PropertyKey,
            DEVPROPTYPE     *PropertyType,
     PBYTE PropertyBuffer,
             DWORD            PropertyBufferSize,
        PDWORD           RequiredSize,
             DWORD            Flags
    );




BOOL
__stdcall
SetupDiSetDevicePropertyW(
             HDEVINFO         DeviceInfoSet,
             PSP_DEVINFO_DATA DeviceInfoData,
       const DEVPROPKEY      *PropertyKey,
             DEVPROPTYPE      PropertyType,
     const PBYTE PropertyBuffer,
             DWORD            PropertyBufferSize,
             DWORD            Flags
    );




BOOL
__stdcall
SetupDiGetDeviceInterfacePropertyKeys(
             HDEVINFO         DeviceInfoSet,
             PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData,
     DEVPROPKEY *PropertyKeyArray,
             DWORD            PropertyKeyCount,
        PDWORD           RequiredPropertyKeyCount,
             DWORD            Flags
    );



BOOL
__stdcall
SetupDiGetDeviceInterfacePropertyW(
             HDEVINFO         DeviceInfoSet,
             PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData,
       const DEVPROPKEY      *PropertyKey,
            DEVPROPTYPE     *PropertyType,
     PBYTE PropertyBuffer,
             DWORD            PropertyBufferSize,
        PDWORD           RequiredSize,
             DWORD            Flags
    );




BOOL
__stdcall
SetupDiSetDeviceInterfacePropertyW(
             HDEVINFO         DeviceInfoSet,
             PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData,
       const DEVPROPKEY      *PropertyKey,
             DEVPROPTYPE      PropertyType,
     const PBYTE PropertyBuffer,
             DWORD            PropertyBufferSize,
             DWORD            Flags
    );
]]


ffi.cdef[[
//
// Flags for SetupDiGetClassPropertyKeys, SetupDiGetClassProperty, and
// SetupDiSetClassProperty.
//
static const int DICLASSPROP_INSTALLER  = 0x00000001;    // device setup class property
static const int DICLASSPROP_INTERFACE  = 0x00000002;    // device interface class property


BOOL
__stdcall
SetupDiGetClassPropertyKeys(
       const GUID            *ClassGuid,
     DEVPROPKEY *PropertyKeyArray,
             DWORD            PropertyKeyCount,
        PDWORD           RequiredPropertyKeyCount,
             DWORD            Flags
    );


BOOL
__stdcall
SetupDiGetClassPropertyKeysExW(
       const GUID            *ClassGuid,
     DEVPROPKEY *PropertyKeyArray,
             DWORD            PropertyKeyCount,
        PDWORD           RequiredPropertyKeyCount,
             DWORD            Flags,
         PCWSTR           MachineName,
       PVOID            Reserved
    );




BOOL
__stdcall
SetupDiGetClassPropertyW(
       const GUID            *ClassGuid,
       const DEVPROPKEY      *PropertyKey,
            DEVPROPTYPE     *PropertyType,
     PBYTE PropertyBuffer,
             DWORD            PropertyBufferSize,
        PDWORD           RequiredSize,
             DWORD            Flags
    );





BOOL
__stdcall
SetupDiGetClassPropertyExW(
       const GUID            *ClassGuid,
       const DEVPROPKEY      *PropertyKey,
            DEVPROPTYPE     *PropertyType,
     PBYTE PropertyBuffer,
             DWORD            PropertyBufferSize,
        PDWORD           RequiredSize,
             DWORD            Flags,
         PCWSTR           MachineName,
       PVOID            Reserved
    );




BOOL
__stdcall
SetupDiSetClassPropertyW(
       const GUID            *ClassGuid,
       const DEVPROPKEY      *PropertyKey,
             DEVPROPTYPE      PropertyType,
     const PBYTE PropertyBuffer,
             DWORD            PropertyBufferSize,
             DWORD            Flags
    );




BOOL
__stdcall
SetupDiSetClassPropertyExW(
       const GUID            *ClassGuid,
       const DEVPROPKEY      *PropertyKey,
             DEVPROPTYPE      PropertyType,
     const PBYTE PropertyBuffer,
             DWORD            PropertyBufferSize,
             DWORD            Flags,
         PCWSTR           MachineName,
       PVOID            Reserved
    );
]]

end -- _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN


ffi.cdef[[
//
// Device registry property codes
// (Codes marked as read-only (R) may only be used for
// SetupDiGetDeviceRegistryProperty)
//
// These values should cover the same set of registry properties
// as defined by the CM_DRP codes in cfgmgr32.h.
//
// Note that SPDRP codes are zero based while CM_DRP codes are one based!
//
static const int SPDRP_DEVICEDESC                  = (0x00000000);  // DeviceDesc (R/W)
static const int SPDRP_HARDWAREID                  = (0x00000001);  // HardwareID (R/W)
static const int SPDRP_COMPATIBLEIDS               = (0x00000002);  // CompatibleIDs (R/W)
static const int SPDRP_UNUSED0                     = (0x00000003);  // unused
static const int SPDRP_SERVICE                     = (0x00000004);  // Service (R/W)
static const int SPDRP_UNUSED1                     = (0x00000005);  // unused
static const int SPDRP_UNUSED2                     = (0x00000006);  // unused
static const int SPDRP_CLASS                       = (0x00000007);  // Class (R--tied to ClassGUID)
static const int SPDRP_CLASSGUID                   = (0x00000008);  // ClassGUID (R/W)
static const int SPDRP_DRIVER                      = (0x00000009);  // Driver (R/W)
static const int SPDRP_CONFIGFLAGS                 = (0x0000000A);  // ConfigFlags (R/W)
static const int SPDRP_MFG                         = (0x0000000B);  // Mfg (R/W)
static const int SPDRP_FRIENDLYNAME                = (0x0000000C);  // FriendlyName (R/W)
static const int SPDRP_LOCATION_INFORMATION        = (0x0000000D);  // LocationInformation (R/W)
static const int SPDRP_PHYSICAL_DEVICE_OBJECT_NAME = (0x0000000E);  // PhysicalDeviceObjectName (R)
static const int SPDRP_CAPABILITIES                = (0x0000000F);  // Capabilities (R)
static const int SPDRP_UI_NUMBER                   = (0x00000010);  // UiNumber (R)
static const int SPDRP_UPPERFILTERS                = (0x00000011);  // UpperFilters (R/W)
static const int SPDRP_LOWERFILTERS                = (0x00000012);  // LowerFilters (R/W)
static const int SPDRP_BUSTYPEGUID                 = (0x00000013);  // BusTypeGUID (R)
static const int SPDRP_LEGACYBUSTYPE               = (0x00000014);  // LegacyBusType (R)
static const int SPDRP_BUSNUMBER                   = (0x00000015);  // BusNumber (R)
static const int SPDRP_ENUMERATOR_NAME             = (0x00000016);  // Enumerator Name (R)
static const int SPDRP_SECURITY                    = (0x00000017);  // Security (R/W, binary form)
static const int SPDRP_SECURITY_SDS                = (0x00000018);  // Security (W, SDS form)
static const int SPDRP_DEVTYPE                     = (0x00000019);  // Device Type (R/W)
static const int SPDRP_EXCLUSIVE                   = (0x0000001A);  // Device is exclusive-access (R/W)
static const int SPDRP_CHARACTERISTICS             = (0x0000001B);  // Device Characteristics (R/W)
static const int SPDRP_ADDRESS                     = (0x0000001C);  // Device Address (R)
static const int SPDRP_UI_NUMBER_DESC_FORMAT       = (0X0000001D);  // UiNumberDescFormat (R/W)
static const int SPDRP_DEVICE_POWER_DATA           = (0x0000001E);  // Device Power Data (R)
static const int SPDRP_REMOVAL_POLICY              = (0x0000001F);  // Removal Policy (R)
static const int SPDRP_REMOVAL_POLICY_HW_DEFAULT   = (0x00000020);  // Hardware Removal Policy (R)
static const int SPDRP_REMOVAL_POLICY_OVERRIDE     = (0x00000021);  // Removal Policy Override (RW)
static const int SPDRP_INSTALL_STATE               = (0x00000022);  // Device Install State (R)
static const int SPDRP_LOCATION_PATHS              = (0x00000023);  // Device Location Paths (R)
static const int SPDRP_BASE_CONTAINERID            = (0x00000024);  // Base ContainerID (R)

static const int SPDRP_MAXIMUM_PROPERTY            = (0x00000025);  // Upper bound on ordinals
]]

ffi.cdef[[
//
// Class registry property codes
// (Codes marked as read-only (R) may only be used for
// SetupDiGetClassRegistryProperty)
//
// These values should cover the same set of registry properties
// as defined by the CM_CRP codes in cfgmgr32.h.
// they should also have a 1:1 correspondence with Device registers, where applicable
// but no overlap otherwise
//
static const int SPCRP_UPPERFILTERS                = (0x00000011);  // UpperFilters (R/W)
static const int SPCRP_LOWERFILTERS                = (0x00000012);  // LowerFilters (R/W)
static const int SPCRP_SECURITY                    = (0x00000017);  // Security (R/W, binary form)
static const int SPCRP_SECURITY_SDS                = (0x00000018);  // Security (W, SDS form)
static const int SPCRP_DEVTYPE                     = (0x00000019);  // Device Type (R/W)
static const int SPCRP_EXCLUSIVE                   = (0x0000001A);  // Device is exclusive-access (R/W)
static const int SPCRP_CHARACTERISTICS             = (0x0000001B);  // Device Characteristics (R/W)
static const int SPCRP_MAXIMUM_PROPERTY            = (0x0000001C);  // Upper bound on ordinals
]]

--[=[

BOOL
__stdcall
SetupDiGetDeviceRegistryPropertyA(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     DWORD Property,
     PDWORD PropertyRegDataType, 
     PBYTE PropertyBuffer,
     DWORD PropertyBufferSize,
     PDWORD RequiredSize 
    );


BOOL
__stdcall
SetupDiGetDeviceRegistryPropertyW(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     DWORD Property,
     PDWORD PropertyRegDataType,
     PBYTE PropertyBuffer,
     DWORD PropertyBufferSize,
     PDWORD RequiredSize
    );

--[[
if UNICODE
#define SetupDiGetDeviceRegistryProperty SetupDiGetDeviceRegistryPropertyW
else
#define SetupDiGetDeviceRegistryProperty SetupDiGetDeviceRegistryPropertyA
end
--]]

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then



BOOL
__stdcall
SetupDiGetClassRegistryPropertyA(
     const GUID *ClassGuid,
     DWORD Property,
     PDWORD PropertyRegDataType,
     PBYTE PropertyBuffer,
     DWORD PropertyBufferSize,
     PDWORD RequiredSize,
     PCSTR MachineName,
     PVOID Reserved
    );



BOOL
__stdcall
SetupDiGetClassRegistryPropertyW(
     const GUID *ClassGuid,
     DWORD Property,
     PDWORD PropertyRegDataType,
     PBYTE PropertyBuffer,
     DWORD PropertyBufferSize,
     PDWORD RequiredSize,
     PCWSTR MachineName, 
     PVOID Reserved
    );

--[[
if UNICODE
#define SetupDiGetClassRegistryProperty SetupDiGetClassRegistryPropertyW
else
#define SetupDiGetClassRegistryProperty SetupDiGetClassRegistryPropertyA
end
--]]

end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP


BOOL
__stdcall
SetupDiSetDeviceRegistryPropertyA(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     DWORD Property,
     const BYTE *PropertyBuffer,
     DWORD PropertyBufferSize
    );


BOOL
__stdcall
SetupDiSetDeviceRegistryPropertyW(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     DWORD Property,
     const BYTE *PropertyBuffer,
     DWORD PropertyBufferSize
    );

--[[
if UNICODE
#define SetupDiSetDeviceRegistryProperty SetupDiSetDeviceRegistryPropertyW
else
#define SetupDiSetDeviceRegistryProperty SetupDiSetDeviceRegistryPropertyA
end
--]]

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then


BOOL
__stdcall
SetupDiSetClassRegistryPropertyA(
     const GUID *ClassGuid,
     DWORD Property,
     const BYTE *PropertyBuffer, 
     DWORD PropertyBufferSize,
     PCSTR MachineName,
     PVOID Reserved
    );


BOOL
__stdcall
SetupDiSetClassRegistryPropertyW(
     const GUID *ClassGuid,
     DWORD Property,
     const BYTE *PropertyBuffer,
     DWORD PropertyBufferSize,
     PCWSTR MachineName,
     PVOID Reserved
    );

--[[
if UNICODE
#define SetupDiSetClassRegistryProperty SetupDiSetClassRegistryPropertyW
else
#define SetupDiSetClassRegistryProperty SetupDiSetClassRegistryPropertyA
end
--]]
end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP

ffi.cdef[[
BOOL
__stdcall
SetupDiGetDeviceInstallParamsA(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     PSP_DEVINSTALL_PARAMS_A DeviceInstallParams
    );


BOOL
__stdcall
SetupDiGetDeviceInstallParamsW(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     PSP_DEVINSTALL_PARAMS_W DeviceInstallParams
    );
]]

--[[
if UNICODE
#define SetupDiGetDeviceInstallParams SetupDiGetDeviceInstallParamsW
else
#define SetupDiGetDeviceInstallParams SetupDiGetDeviceInstallParamsA
end
--]]


BOOL
__stdcall
SetupDiGetClassInstallParamsA(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData, 
    _Out_writes_bytes_to_opt_(ClassInstallParamsSize, *RequiredSize) PSP_CLASSINSTALL_HEADER ClassInstallParams,
     DWORD ClassInstallParamsSize,
     PDWORD RequiredSize
    );



BOOL
__stdcall
SetupDiGetClassInstallParamsW(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
    _Out_writes_bytes_to_opt_(ClassInstallParamsSize, *RequiredSize) PSP_CLASSINSTALL_HEADER ClassInstallParams,
     DWORD ClassInstallParamsSize,
     PDWORD RequiredSize
    );

if UNICODE
#define SetupDiGetClassInstallParams SetupDiGetClassInstallParamsW
else
#define SetupDiGetClassInstallParams SetupDiGetClassInstallParamsA
end



BOOL
__stdcall
SetupDiSetDeviceInstallParamsA(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     PSP_DEVINSTALL_PARAMS_A DeviceInstallParams
    );


BOOL
__stdcall
SetupDiSetDeviceInstallParamsW(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     PSP_DEVINSTALL_PARAMS_W DeviceInstallParams
    );

if UNICODE
#define SetupDiSetDeviceInstallParams SetupDiSetDeviceInstallParamsW
else
#define SetupDiSetDeviceInstallParams SetupDiSetDeviceInstallParamsA
end



BOOL
__stdcall
SetupDiSetClassInstallParamsA(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
    _In_reads_bytes_opt_(ClassInstallParamsSize) PSP_CLASSINSTALL_HEADER ClassInstallParams,
     DWORD ClassInstallParamsSize
    );


BOOL
__stdcall
SetupDiSetClassInstallParamsW(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
    _In_reads_bytes_opt_(ClassInstallParamsSize) PSP_CLASSINSTALL_HEADER ClassInstallParams,
     DWORD ClassInstallParamsSize
    );

if UNICODE
#define SetupDiSetClassInstallParams SetupDiSetClassInstallParamsW
else
#define SetupDiSetClassInstallParams SetupDiSetClassInstallParamsA
end



BOOL
__stdcall
SetupDiGetDriverInstallParamsA(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     PSP_DRVINFO_DATA_A DriverInfoData,
     PSP_DRVINSTALL_PARAMS DriverInstallParams
    );


BOOL
__stdcall
SetupDiGetDriverInstallParamsW(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     PSP_DRVINFO_DATA_W DriverInfoData,
     PSP_DRVINSTALL_PARAMS DriverInstallParams
    );

--[[
if UNICODE
#define SetupDiGetDriverInstallParams SetupDiGetDriverInstallParamsW
else
#define SetupDiGetDriverInstallParams SetupDiGetDriverInstallParamsA
end
--]]

ffi.cdef[[
BOOL
__stdcall
SetupDiSetDriverInstallParamsA(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     PSP_DRVINFO_DATA_A DriverInfoData,
     PSP_DRVINSTALL_PARAMS DriverInstallParams
    );


BOOL
__stdcall
SetupDiSetDriverInstallParamsW(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     PSP_DRVINFO_DATA_W DriverInfoData,
     PSP_DRVINSTALL_PARAMS DriverInstallParams
    );
]]

--[[
if UNICODE
#define SetupDiSetDriverInstallParams SetupDiSetDriverInstallParamsW
else
#define SetupDiSetDriverInstallParams SetupDiSetDriverInstallParamsA
end
--]]

ffi.cdef[[
BOOL
__stdcall
SetupDiLoadClassIcon(
     const GUID *ClassGuid,
     HICON *LargeIcon,
     PINT MiniIconIndex 
    );
]]

#if _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN

ffi.cdef[[
BOOL
__stdcall
SetupDiLoadDeviceIcon(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     UINT cxIcon,
     UINT cyIcon,
     DWORD Flags,
     HICON *hIcon
    );
]]

end -- _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN
--]=]

ffi.cdef[[
//
// Flags controlling the drawing of mini-icons
//
static const int DMI_MASK     = 0x00000001;
static const int DMI_BKCOLOR  = 0x00000002;
static const int DMI_USERECT  = 0x00000004;
]]

ffi.cdef[[
INT
__stdcall
SetupDiDrawMiniIcon(
     HDC hdc,
     RECT rc,
     INT MiniIconIndex,
     DWORD Flags
    );



BOOL
__stdcall
SetupDiGetClassBitmapIndex(
     const GUID *ClassGuid,
     PINT MiniIconIndex
    );



BOOL
__stdcall
SetupDiGetClassImageList(
     PSP_CLASSIMAGELIST_DATA ClassImageListData
    );



BOOL
__stdcall
SetupDiGetClassImageListExA(
     PSP_CLASSIMAGELIST_DATA ClassImageListData,
     PCSTR MachineName,
     PVOID Reserved
    );


BOOL
__stdcall
SetupDiGetClassImageListExW(
     PSP_CLASSIMAGELIST_DATA ClassImageListData,
     PCWSTR MachineName,
     PVOID Reserved
    );
]]

--[[
if UNICODE
#define SetupDiGetClassImageListEx SetupDiGetClassImageListExW
else
#define SetupDiGetClassImageListEx SetupDiGetClassImageListExA
end
--]]

ffi.cdef[[
BOOL
__stdcall
SetupDiGetClassImageIndex(
     PSP_CLASSIMAGELIST_DATA ClassImageListData,
     const GUID *ClassGuid,
     PINT ImageIndex
    );



BOOL
__stdcall
SetupDiDestroyClassImageList(
     PSP_CLASSIMAGELIST_DATA ClassImageListData
    );
]]

ffi.cdef[[
//
// PropertySheetType values for the SetupDiGetClassDevPropertySheets API
//
static const int DIGCDP_FLAG_BASIC         =  0x00000001;
static const int DIGCDP_FLAG_ADVANCED      =  0x00000002;
]]


if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then
ffi.cdef[[
static const int DIGCDP_FLAG_REMOTE_BASIC    = 0x00000003;  // not presently implemented
static const int DIGCDP_FLAG_REMOTE_ADVANCED = 0x00000004;
]]
end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP

ffi.cdef[[
BOOL
__stdcall
SetupDiGetClassDevPropertySheetsA(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     LPPROPSHEETHEADERA PropertySheetHeader,
     DWORD PropertySheetHeaderPageListSize,
     PDWORD RequiredSize,
     DWORD PropertySheetType
    );


BOOL
__stdcall
SetupDiGetClassDevPropertySheetsW(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     LPPROPSHEETHEADERW PropertySheetHeader,
     DWORD PropertySheetHeaderPageListSize,
     PDWORD RequiredSize,
     DWORD PropertySheetType
    );
]]

--[[
if UNICODE
#define SetupDiGetClassDevPropertySheets SetupDiGetClassDevPropertySheetsW
else
#define SetupDiGetClassDevPropertySheets SetupDiGetClassDevPropertySheetsA
end
--]]

ffi.cdef[[
//
// Define ICON IDs publicly exposed from setupapi.
//
static const int IDI_RESOURCEFIRST          = 159;
static const int IDI_RESOURCE               = 159;
static const int IDI_RESOURCELAST           = 161;
static const int IDI_RESOURCEOVERLAYFIRST   = 161;
static const int IDI_RESOURCEOVERLAYLAST    = 161;
static const int IDI_CONFLICT               = 161;

static const int IDI_CLASSICON_OVERLAYFIRST = 500;
static const int IDI_CLASSICON_OVERLAYLAST  = 502;
static const int IDI_PROBLEM_OVL            = 500;
static const int IDI_DISABLED_OVL           = 501;
static const int IDI_FORCED_OVL             = 502;
]]

ffi.cdef[[
BOOL
__stdcall
SetupDiAskForOEMDisk(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData
    );



BOOL
__stdcall
SetupDiSelectOEMDrv(
     HWND hwndParent,
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData
    );



BOOL
__stdcall
SetupDiClassNameFromGuidA(
     const GUID *ClassGuid,
     PSTR ClassName,
     DWORD ClassNameSize,
     PDWORD RequiredSize
    );


BOOL
__stdcall
SetupDiClassNameFromGuidW(
     const GUID *ClassGuid,
     PWSTR ClassName,
     DWORD ClassNameSize,
     PDWORD RequiredSize
    );
]]

--[[
if UNICODE
#define SetupDiClassNameFromGuid SetupDiClassNameFromGuidW
else
#define SetupDiClassNameFromGuid SetupDiClassNameFromGuidA
end
--]]

ffi.cdef[[
BOOL
__stdcall
SetupDiClassNameFromGuidExA(
     const GUID *ClassGuid,
     PSTR ClassName,
     DWORD ClassNameSize,
     PDWORD RequiredSize,
     PCSTR MachineName,
     PVOID Reserved
    );


BOOL
__stdcall
SetupDiClassNameFromGuidExW(
     const GUID *ClassGuid,
     PWSTR ClassName,
     DWORD ClassNameSize,
     PDWORD RequiredSize,
     PCWSTR MachineName,
     PVOID Reserved
    );
]]

--[[
if UNICODE
#define SetupDiClassNameFromGuidEx SetupDiClassNameFromGuidExW
else
#define SetupDiClassNameFromGuidEx SetupDiClassNameFromGuidExA
end
--]]

ffi.cdef[[
BOOL
__stdcall
SetupDiClassGuidsFromNameA(
     PCSTR ClassName,
     LPGUID ClassGuidList,
     DWORD ClassGuidListSize,
     PDWORD RequiredSize
    );



BOOL
__stdcall
SetupDiClassGuidsFromNameW(
     PCWSTR ClassName,
     LPGUID ClassGuidList,
     DWORD ClassGuidListSize,
     PDWORD RequiredSize
    );
]]

--[[
if UNICODE
#define SetupDiClassGuidsFromName SetupDiClassGuidsFromNameW
else
#define SetupDiClassGuidsFromName SetupDiClassGuidsFromNameA
end
--]]


ffi.cdef[[
BOOL
__stdcall
SetupDiClassGuidsFromNameExA(
     PCSTR ClassName,
     LPGUID ClassGuidList,
     DWORD ClassGuidListSize,
     PDWORD RequiredSize,
     PCSTR MachineName,
     PVOID Reserved
    );



BOOL
__stdcall
SetupDiClassGuidsFromNameExW(
     PCWSTR ClassName,
     LPGUID ClassGuidList,
     DWORD ClassGuidListSize,
     PDWORD RequiredSize,
     PCWSTR MachineName,
     PVOID Reserved
    );
]]

--[[
if UNICODE
#define SetupDiClassGuidsFromNameEx SetupDiClassGuidsFromNameExW
else
#define SetupDiClassGuidsFromNameEx SetupDiClassGuidsFromNameExA
end
--]]

ffi.cdef[[
BOOL
__stdcall
SetupDiGetHwProfileFriendlyNameA(
     DWORD HwProfile,
     PSTR FriendlyName,
     DWORD FriendlyNameSize,
     PDWORD RequiredSize
    );


BOOL
__stdcall
SetupDiGetHwProfileFriendlyNameW(
     DWORD HwProfile,
     PWSTR FriendlyName,
     DWORD FriendlyNameSize,
     PDWORD RequiredSize
    );
]]

--[[
if UNICODE
#define SetupDiGetHwProfileFriendlyName SetupDiGetHwProfileFriendlyNameW
else
#define SetupDiGetHwProfileFriendlyName SetupDiGetHwProfileFriendlyNameA
end
--]]

ffi.cdef[[
BOOL
__stdcall
SetupDiGetHwProfileFriendlyNameExA(
     DWORD HwProfile,
     PSTR FriendlyName,
     DWORD FriendlyNameSize,
     PDWORD RequiredSize,
     PCSTR MachineName,
     PVOID Reserved
    );


BOOL
__stdcall
SetupDiGetHwProfileFriendlyNameExW(
     DWORD HwProfile,
     PWSTR FriendlyName,
     DWORD FriendlyNameSize,
     PDWORD RequiredSize,
     PCWSTR MachineName,
     PVOID Reserved
    );
]]

--[[
if UNICODE
#define SetupDiGetHwProfileFriendlyNameEx SetupDiGetHwProfileFriendlyNameExW
else
#define SetupDiGetHwProfileFriendlyNameEx SetupDiGetHwProfileFriendlyNameExA
end
--]]

ffi.cdef[[
//
// PageType values for SetupDiGetWizardPage API
//
static const int SPWPT_SELECTDEVICE    =  0x00000001;

//
// Flags for SetupDiGetWizardPage API
//
static const int SPWP_USE_DEVINFO_DATA =  0x00000001;
]]

ffi.cdef[[
HPROPSHEETPAGE
__stdcall
SetupDiGetWizardPage(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     PSP_INSTALLWIZARD_DATA InstallWizardData,
     DWORD PageType,
     DWORD Flags
    );



BOOL
__stdcall
SetupDiGetSelectedDevice(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData
    );



BOOL
__stdcall
SetupDiSetSelectedDevice(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData
    );
]]

if _SETUPAPI_VER >= _WIN32_WINNT_WS03 then

ffi.cdef[[
BOOL
__stdcall
SetupDiGetActualModelsSectionA(
     PINFCONTEXT Context,
     PSP_ALTPLATFORM_INFO AlternatePlatformInfo,
     PSTR InfSectionWithExt,
     DWORD InfSectionWithExtSize,
     PDWORD RequiredSize,
     PVOID Reserved
    );


BOOL
__stdcall
SetupDiGetActualModelsSectionW(
     PINFCONTEXT Context,
     PSP_ALTPLATFORM_INFO AlternatePlatformInfo,
     PWSTR InfSectionWithExt,
     DWORD InfSectionWithExtSize,
     PDWORD RequiredSize,
     PVOID Reserved
    );
]]

--[[
if UNICODE
#define SetupDiGetActualModelsSection SetupDiGetActualModelsSectionW
else
#define SetupDiGetActualModelsSection SetupDiGetActualModelsSectionA
end
--]]

end -- _SETUPAPI_VER >= _WIN32_WINNT_WS03


ffi.cdef[[
BOOL
__stdcall
SetupDiGetActualSectionToInstallA(
     HINF InfHandle,
     PCSTR InfSectionName,
     PSTR InfSectionWithExt,
     DWORD InfSectionWithExtSize,
     PDWORD RequiredSize,
     PSTR *Extension
    );


BOOL
__stdcall
SetupDiGetActualSectionToInstallW(
     HINF InfHandle,
     PCWSTR InfSectionName,
     PWSTR InfSectionWithExt,
     DWORD InfSectionWithExtSize,
     PDWORD RequiredSize,
     PWSTR *Extension
    );
]]

--[[
if UNICODE
#define SetupDiGetActualSectionToInstall SetupDiGetActualSectionToInstallW
else
#define SetupDiGetActualSectionToInstall SetupDiGetActualSectionToInstallA
end
--]]

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then

ffi.cdef[[
BOOL
__stdcall
SetupDiGetActualSectionToInstallExA(
     HINF InfHandle,
     PCSTR InfSectionName,
     PSP_ALTPLATFORM_INFO AlternatePlatformInfo,
     PSTR InfSectionWithExt,
     DWORD InfSectionWithExtSize,
     PDWORD RequiredSize,
     PSTR *Extension,
     PVOID Reserved
    );


BOOL
__stdcall
SetupDiGetActualSectionToInstallExW(
     HINF InfHandle,
     PCWSTR InfSectionName,
     PSP_ALTPLATFORM_INFO AlternatePlatformInfo,
     PWSTR InfSectionWithExt,
     DWORD InfSectionWithExtSize,
     PDWORD RequiredSize,
     PWSTR *Extension,
     PVOID Reserved
    );
]]

--[[
if UNICODE
#define SetupDiGetActualSectionToInstallEx SetupDiGetActualSectionToInstallExW
else
#define SetupDiGetActualSectionToInstallEx SetupDiGetActualSectionToInstallExA
end
--]]
end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP


if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then

ffi.cdef[[
//
// SetupEnumInfSections is for low-level parsing of an INF
//

BOOL
__stdcall
SetupEnumInfSectionsA (
     HINF InfHandle,
     UINT Index,
     PSTR Buffer, 
     UINT Size,
     UINT *SizeNeeded
    );


BOOL
__stdcall
SetupEnumInfSectionsW (
     HINF InfHandle,
     UINT Index,
     PWSTR Buffer, 
     UINT Size,
     UINT *SizeNeeded
    );
]]

--[[
if UNICODE
#define SetupEnumInfSections SetupEnumInfSectionsW
else
#define SetupEnumInfSections SetupEnumInfSectionsA
end
--]]
end -- _SETUPAPI_VER >= _WIN32_WINNT_WINXP

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then
ffi.cdef[[
typedef struct _SP_INF_SIGNER_INFO_V1_A {
    DWORD  cbSize;
    CHAR   CatalogFile[MAX_PATH];
    CHAR   DigitalSigner[MAX_PATH];
    CHAR   DigitalSignerVersion[MAX_PATH];
} SP_INF_SIGNER_INFO_V1_A, *PSP_INF_SIGNER_INFO_V1_A;

typedef struct _SP_INF_SIGNER_INFO_V1_W {
    DWORD  cbSize;
    WCHAR  CatalogFile[MAX_PATH];
    WCHAR  DigitalSigner[MAX_PATH];
    WCHAR  DigitalSignerVersion[MAX_PATH];
} SP_INF_SIGNER_INFO_V1_W, *PSP_INF_SIGNER_INFO_V1_W;
]]

--[[
if UNICODE
typedef SP_INF_SIGNER_INFO_V1_W SP_INF_SIGNER_INFO_V1;
typedef PSP_INF_SIGNER_INFO_V1_W PSP_INF_SIGNER_INFO_V1;
else
typedef SP_INF_SIGNER_INFO_V1_A SP_INF_SIGNER_INFO_V1;
typedef PSP_INF_SIGNER_INFO_V1_A PSP_INF_SIGNER_INFO_V1;
end
--]]

if _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN then
ffi.cdef[[
typedef struct _SP_INF_SIGNER_INFO_V2_A {
    DWORD  cbSize;
    CHAR   CatalogFile[MAX_PATH];
    CHAR   DigitalSigner[MAX_PATH];
    CHAR   DigitalSignerVersion[MAX_PATH];
    DWORD  SignerScore;
} SP_INF_SIGNER_INFO_V2_A, *PSP_INF_SIGNER_INFO_V2_A;

typedef struct _SP_INF_SIGNER_INFO_V2_W {
    DWORD  cbSize;
    WCHAR  CatalogFile[MAX_PATH];
    WCHAR  DigitalSigner[MAX_PATH];
    WCHAR  DigitalSignerVersion[MAX_PATH];
    DWORD  SignerScore;
} SP_INF_SIGNER_INFO_V2_W, *PSP_INF_SIGNER_INFO_V2_W;
]]

--[[
if UNICODE
typedef SP_INF_SIGNER_INFO_V2_W SP_INF_SIGNER_INFO_V2;
typedef PSP_INF_SIGNER_INFO_V2_W PSP_INF_SIGNER_INFO_V2;
else
typedef SP_INF_SIGNER_INFO_V2_A SP_INF_SIGNER_INFO_V2;
typedef PSP_INF_SIGNER_INFO_V2_A PSP_INF_SIGNER_INFO_V2;
end
--]]

ffi.cdef[[
//
// Driver signer scores (high order bit of the signing byte means unsigned)
//
static const int SIGNERSCORE_UNKNOWN       =  0xFF000000;  
static const int SIGNERSCORE_W9X_SUSPECT   =  0xC0000000;  
static const int SIGNERSCORE_UNSIGNED      =  0x80000000;  
static const int SIGNERSCORE_AUTHENTICODE  =  0x0F000000;  
static const int SIGNERSCORE_WHQL          =  0x0D000005;  // base WHQL.
static const int SIGNERSCORE_UNCLASSIFIED  =  0x0D000004;  // UNCLASSIFIED == INBOX == STANDARD == PREMIUM when the SIGNERSCORE_MASK 
static const int SIGNERSCORE_INBOX         =  0x0D000003;  // filter is applied.
static const int SIGNERSCORE_LOGO_STANDARD =  0x0D000002;  
static const int SIGNERSCORE_LOGO_PREMIUM  =  0x0D000001;  

static const int SIGNERSCORE_MASK          =  0xFF000000;  // Mask out all but the upper BYTE which contains the ranking signer information
static const int SIGNERSCORE_SIGNED_MASK   =  0xF0000000;  // Mask out only the upper nibble, which tells us if the package is signed or not.
]]
end --// _SETUPAPI_VER >= _WIN32_WINNT_LONGHORN

if USE_SP_INF_SIGNER_INFO_V1 or (_SETUPAPI_VER < _WIN32_WINNT_LONGHORN)  then --// use version 1 signer info structure
ffi.cdef[[
typedef SP_INF_SIGNER_INFO_V1_A SP_INF_SIGNER_INFO_A;
typedef PSP_INF_SIGNER_INFO_V1_A PSP_INF_SIGNER_INFO_A;
typedef SP_INF_SIGNER_INFO_V1_W SP_INF_SIGNER_INFO_W;
typedef PSP_INF_SIGNER_INFO_V1_W PSP_INF_SIGNER_INFO_W;
typedef SP_INF_SIGNER_INFO_V1 SP_INF_SIGNER_INFO;
typedef PSP_INF_SIGNER_INFO_V1 PSP_INF_SIGNER_INFO;
]]
else                       --// use version 2 signer info structure
ffi.cdef[[
typedef SP_INF_SIGNER_INFO_V2_A SP_INF_SIGNER_INFO_A;
typedef PSP_INF_SIGNER_INFO_V2_A PSP_INF_SIGNER_INFO_A;
typedef SP_INF_SIGNER_INFO_V2_W SP_INF_SIGNER_INFO_W;
typedef PSP_INF_SIGNER_INFO_V2_W PSP_INF_SIGNER_INFO_W;
typedef SP_INF_SIGNER_INFO_V2 SP_INF_SIGNER_INFO;
typedef PSP_INF_SIGNER_INFO_V2 PSP_INF_SIGNER_INFO;
]]
end  --// use current version of signer info structure


ffi.cdef[[
BOOL
__stdcall
SetupVerifyInfFileA(
     PCSTR InfName,
     PSP_ALTPLATFORM_INFO AltPlatformInfo,
     PSP_INF_SIGNER_INFO_A InfSignerInfo
    );


BOOL
__stdcall
SetupVerifyInfFileW(
     PCWSTR InfName,
     PSP_ALTPLATFORM_INFO AltPlatformInfo,
     PSP_INF_SIGNER_INFO_W InfSignerInfo
    );
]]

--[[
if UNICODE
#define SetupVerifyInfFile SetupVerifyInfFileW
else
#define SetupVerifyInfFile SetupVerifyInfFileA
end
--]]

end --// _SETUPAPI_VER >= _WIN32_WINNT_WINXP

if _SETUPAPI_VER >= _WIN32_WINNT_WINXP then
ffi.cdef[[
//
// Flags for use by SetupDiGetCustomDeviceProperty
//
static const int DICUSTOMDEVPROP_MERGE_MULTISZ   = 0x00000001;



BOOL
__stdcall
SetupDiGetCustomDevicePropertyA(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     PCSTR CustomPropertyName,
     DWORD Flags,
     PDWORD PropertyRegDataType,
     PBYTE PropertyBuffer,
     DWORD PropertyBufferSize,
     PDWORD RequiredSize
    );



BOOL
__stdcall
SetupDiGetCustomDevicePropertyW(
     HDEVINFO DeviceInfoSet,
     PSP_DEVINFO_DATA DeviceInfoData,
     PCWSTR CustomPropertyName,
     DWORD Flags,
     PDWORD PropertyRegDataType,
     PBYTE PropertyBuffer,
     DWORD PropertyBufferSize,
     PDWORD RequiredSize
    );
]]

--[[
if UNICODE
#define SetupDiGetCustomDeviceProperty SetupDiGetCustomDevicePropertyW
else
#define SetupDiGetCustomDeviceProperty SetupDiGetCustomDevicePropertyA
end
--]]
end --// _SETUPAPI_VER >= _WIN32_WINNT_WINXP


if _SETUPAPI_VER >= _WIN32_WINNT_WS03 then
ffi.cdef[[
static const int SCWMI_CLOBBER_SECURITY  = 0x00000001;


BOOL
__stdcall
SetupConfigureWmiFromInfSectionA(
     HINF InfHandle,
     PCSTR SectionName,
     DWORD Flags
    );


BOOL
__stdcall
SetupConfigureWmiFromInfSectionW(
     HINF InfHandle,
     PCWSTR SectionName,
     DWORD Flags
    );
]]

--[[
if UNICODE
#define SetupConfigureWmiFromInfSection SetupConfigureWmiFromInfSectionW
else
#define SetupConfigureWmiFromInfSection SetupConfigureWmiFromInfSectionA
end
--]]

end --// _SETUPAPI_VER >= _WIN32_WINNT_WS03


--#include <poppack.h>




--end /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


return ffi.load("setupapi")