--[[
* sysinfoapi.h -- ApiSet Contract for api-ms-win-core-sysinfo-l1    

    Deprecated interfaces are not included*
--]]

local ffi = require("ffi")

require("win32.minwindef")
require("win32.minwinbase")


--[[
#if defined(FKG_FORCED_USAGE) || defined(WINPHONE) || defined(BUILD_WINDOWS)
# define NOT_BUILD_WINDOWS_DEPRECATE
#else
# define NOT_BUILD_WINDOWS_DEPRECATE __declspec(deprecated)
#endif
--]]



ffi.cdef[[
typedef struct _SYSTEM_INFO {
    union {
        DWORD dwOemId;          // Obsolete field...do not use
        struct {
            WORD wProcessorArchitecture;
            WORD wReserved;
        }; // DUMMYSTRUCTNAME;
    }; // DUMMYUNIONNAME;
    DWORD dwPageSize;
    LPVOID lpMinimumApplicationAddress;
    LPVOID lpMaximumApplicationAddress;
    DWORD_PTR dwActiveProcessorMask;
    DWORD dwNumberOfProcessors;
    DWORD dwProcessorType;
    DWORD dwAllocationGranularity;
    WORD wProcessorLevel;
    WORD wProcessorRevision;
} SYSTEM_INFO, *LPSYSTEM_INFO;
]]


ffi.cdef[[
typedef struct _MEMORYSTATUSEX {
    DWORD dwLength;
    DWORD dwMemoryLoad;
    DWORDLONG ullTotalPhys;
    DWORDLONG ullAvailPhys;
    DWORDLONG ullTotalPageFile;
    DWORDLONG ullAvailPageFile;
    DWORDLONG ullTotalVirtual;
    DWORDLONG ullAvailVirtual;
    DWORDLONG ullAvailExtendedVirtual;
} MEMORYSTATUSEX, *LPMEMORYSTATUSEX;
]]

ffi.cdef[[

BOOL
__stdcall
GlobalMemoryStatusEx(
     LPMEMORYSTATUSEX lpBuffer
    );



VOID
__stdcall
GetSystemInfo(
     LPSYSTEM_INFO lpSystemInfo
    );



VOID
__stdcall
GetSystemTime(
     LPSYSTEMTIME lpSystemTime
    );



VOID
__stdcall
GetSystemTimeAsFileTime(
     LPFILETIME lpSystemTimeAsFileTime
    );



VOID
__stdcall
GetLocalTime(
     LPSYSTEMTIME lpSystemTime
    );
]]


--[[
NOT_BUILD_WINDOWS_DEPRECATE

__drv_preferredFunction("IsWindows*", "Deprecated. Use VerifyVersionInfo* or IsWindows* macros from VersionHelpers.")
DWORD
__stdcall
GetVersion(
    VOID
    );
--]]

ffi.cdef[[
BOOL
__stdcall
SetLocalTime(
    const SYSTEMTIME* lpSystemTime
    );
]]



--[[
__drv_preferredFunction("GetTickCount64", "GetTickCount overflows roughly every 49 days.  Code that does not take that into account can loop indefinitely.  GetTickCount64 operates on 64 bit values and does not have that problem")

DWORD
__stdcall
GetTickCount(
    VOID
    );
--]]



ffi.cdef[[
ULONGLONG
__stdcall
GetTickCount64(
    VOID
    );
]]





ffi.cdef[[
BOOL
__stdcall
GetSystemTimeAdjustment(
     PDWORD lpTimeAdjustment,
     PDWORD lpTimeIncrement,
     PBOOL lpTimeAdjustmentDisabled
    );




BOOL
__stdcall
GetSystemTimeAdjustmentPrecise(
     PDWORD64 lpTimeAdjustment,
     PDWORD64 lpTimeIncrement,
     PBOOL lpTimeAdjustmentDisabled
    );
]]


ffi.cdef[[
UINT
__stdcall
GetSystemDirectoryA(
    LPSTR lpBuffer,
    UINT uSize
    );



UINT
__stdcall
GetSystemDirectoryW(
    LPWSTR lpBuffer,
    UINT uSize
    );
]]

--[[
#ifdef UNICODE
#define GetSystemDirectory  GetSystemDirectoryW
#else
#define GetSystemDirectory  GetSystemDirectoryA
#endif // !UNICODE
--]]





ffi.cdef[[
UINT
__stdcall
GetWindowsDirectoryA(
    LPSTR lpBuffer,
    UINT uSize
    );

UINT
__stdcall
GetWindowsDirectoryW(
    LPWSTR lpBuffer,
    UINT uSize
    );
]]

--[[
#ifdef UNICODE
#define GetWindowsDirectory  GetWindowsDirectoryW
#else
#define GetWindowsDirectory  GetWindowsDirectoryA
#endif // !UNICODE
--]]

ffi.cdef[[
UINT
__stdcall
GetSystemWindowsDirectoryA(
    LPSTR lpBuffer,
    UINT uSize
    );



UINT
__stdcall
GetSystemWindowsDirectoryW(
    LPWSTR lpBuffer,
    UINT uSize
    );
]]

--[[
#ifdef UNICODE
#define GetSystemWindowsDirectory  GetSystemWindowsDirectoryW
#else
#define GetSystemWindowsDirectory  GetSystemWindowsDirectoryA
#endif // !UNICODE
--]]


ffi.cdef[[
typedef enum _COMPUTER_NAME_FORMAT {
    ComputerNameNetBIOS,
    ComputerNameDnsHostname,
    ComputerNameDnsDomain,
    ComputerNameDnsFullyQualified,
    ComputerNamePhysicalNetBIOS,
    ComputerNamePhysicalDnsHostname,
    ComputerNamePhysicalDnsDomain,
    ComputerNamePhysicalDnsFullyQualified,
    ComputerNameMax
} COMPUTER_NAME_FORMAT ;
]]




ffi.cdef[[
BOOL
__stdcall
GetComputerNameExA(
    COMPUTER_NAME_FORMAT NameType,
    LPSTR lpBuffer,
     LPDWORD nSize
    );

BOOL
__stdcall
GetComputerNameExW(
    COMPUTER_NAME_FORMAT NameType,
    LPWSTR lpBuffer,
     LPDWORD nSize
    );
]]

--[[
#ifdef UNICODE
#define GetComputerNameEx  GetComputerNameExW
#else
#define GetComputerNameEx  GetComputerNameExA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
SetComputerNameExW(
    COMPUTER_NAME_FORMAT NameType,
    LPCWSTR lpBuffer
    );
]]

--[[
#ifdef UNICODE
#define SetComputerNameEx SetComputerNameExW
#endif
--]]

ffi.cdef[[
BOOL
__stdcall
SetSystemTime(
    const SYSTEMTIME* lpSystemTime
    );
]]


--[[
NOT_BUILD_WINDOWS_DEPRECATE

__drv_preferredFunction("IsWindows*", "Deprecated. Use VerifyVersionInfo* or IsWindows* macros from VersionHelpers.")
BOOL
__stdcall
GetVersionExA(
     LPOSVERSIONINFOA lpVersionInformation
    );

NOT_BUILD_WINDOWS_DEPRECATE

__drv_preferredFunction("IsWindows*", "Deprecated. Use VerifyVersionInfo* or IsWindows* macros from VersionHelpers.")
BOOL
__stdcall
GetVersionExW(
     LPOSVERSIONINFOW lpVersionInformation
    );

#ifdef UNICODE
#define GetVersionEx  GetVersionExW
#else
#define GetVersionEx  GetVersionExA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
GetLogicalProcessorInformation(
     PSYSTEM_LOGICAL_PROCESSOR_INFORMATION Buffer,
     PDWORD ReturnedLength
    );
]]


ffi.cdef[[
BOOL
__stdcall
GetLogicalProcessorInformationEx(
    LOGICAL_PROCESSOR_RELATIONSHIP RelationshipType,
     PSYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX Buffer,
     PDWORD ReturnedLength
    );
]]




ffi.cdef[[
VOID
__stdcall
GetNativeSystemInfo(
     LPSYSTEM_INFO lpSystemInfo
    );
]]


ffi.cdef[[
VOID
__stdcall
GetSystemTimePreciseAsFileTime(
     LPFILETIME lpSystemTimeAsFileTime
    );
]]

ffi.cdef[[
BOOL
__stdcall
GetProductInfo(
    DWORD dwOSMajorVersion,
    DWORD dwOSMinorVersion,
    DWORD dwSpMajorVersion,
    DWORD dwSpMinorVersion,
     PDWORD pdwReturnedProductType
    );
]]


ffi.cdef[[

ULONGLONG
VerSetConditionMask(
    ULONGLONG ConditionMask,
    ULONG TypeMask,
    UCHAR Condition
    );
]]

ffi.cdef[[
BOOL
__stdcall
GetOsSafeBootMode(
     PDWORD Flags
    );
]]


ffi.cdef[[
UINT
__stdcall
EnumSystemFirmwareTables(
    DWORD FirmwareTableProviderSignature,
    PVOID pFirmwareTableEnumBuffer,
    DWORD BufferSize
    );



UINT
__stdcall
GetSystemFirmwareTable(
    DWORD FirmwareTableProviderSignature,
    DWORD FirmwareTableID,
    PVOID pFirmwareTableBuffer,
    DWORD BufferSize
    );
]]




ffi.cdef[[
BOOL
__stdcall
DnsHostnameToComputerNameExW(
    LPCWSTR Hostname,
    LPWSTR ComputerName,
     LPDWORD nSize
    );

BOOL
__stdcall
GetPhysicallyInstalledSystemMemory(
     PULONGLONG TotalMemoryInKilobytes
    );
]]


ffi.cdef[[
static const int SCEX2_ALT_NETBIOS_NAME = 0x00000001;


BOOL
__stdcall
SetComputerNameEx2W(
    COMPUTER_NAME_FORMAT NameType,
    DWORD Flags,
    LPCWSTR lpBuffer
    );
]]

--[[
#ifdef UNICODE
#define SetComputerNameEx2 SetComputerNameEx2W
#endif
--]]

ffi.cdef[[
BOOL
__stdcall
SetSystemTimeAdjustment(
    DWORD dwTimeAdjustment,
    BOOL bTimeAdjustmentDisabled
    );

BOOL
__stdcall
SetSystemTimeAdjustmentPrecise(
    DWORD64 dwTimeAdjustment,
    BOOL bTimeAdjustmentDisabled
    );



BOOL
__stdcall
InstallELAMCertificateInfo(
    HANDLE ELAMFile
    );
]]



ffi.cdef[[
BOOL
__stdcall
GetProcessorSystemCycleTime(
    USHORT Group,
     PSYSTEM_PROCESSOR_CYCLE_TIME_INFORMATION Buffer,
     PDWORD ReturnedLength
    );
]]



ffi.cdef[[
BOOL
__stdcall
GetOsManufacturingMode(
     PBOOL pbEnabled
    );
]]


ffi.cdef[[
HRESULT
__stdcall
GetIntegratedDisplaySize(
     double* sizeInInches
    );
]]



ffi.cdef[[
BOOL
__stdcall
SetComputerNameA(
    LPCSTR lpComputerName
    );


BOOL
__stdcall
SetComputerNameW(
    LPCWSTR lpComputerName
    );
]]

--[[
#ifdef UNICODE
#define SetComputerName  SetComputerNameW
#else
#define SetComputerName  SetComputerNameA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
SetComputerNameExA(
    COMPUTER_NAME_FORMAT NameType,
    LPCSTR lpBuffer
    );
]]

--[[
#ifndef UNICODE
#define SetComputerNameEx SetComputerNameExA
#endif
--]]

