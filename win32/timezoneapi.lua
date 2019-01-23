
if not _TIMEZONEAPI_H_ then
_TIMEZONEAPI_H_ = true

--#include <apiset.h>
--#include <apisetcconv.h>
require ("win32.minwindef")
require ("win32.minwinbase")


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
static const int TIME_ZONE_ID_INVALID = ((DWORD)0xFFFFFFFF);
]]

ffi.cdef[[
typedef struct _TIME_ZONE_INFORMATION {
    LONG Bias;
    WCHAR StandardName[ 32 ];
    SYSTEMTIME StandardDate;
    LONG StandardBias;
    WCHAR DaylightName[ 32 ];
    SYSTEMTIME DaylightDate;
    LONG DaylightBias;
} TIME_ZONE_INFORMATION, *PTIME_ZONE_INFORMATION, *LPTIME_ZONE_INFORMATION;

typedef struct _TIME_DYNAMIC_ZONE_INFORMATION {
    LONG Bias;
    WCHAR StandardName[ 32 ];
    SYSTEMTIME StandardDate;
    LONG StandardBias;
    WCHAR DaylightName[ 32 ];
    SYSTEMTIME DaylightDate;
    LONG DaylightBias;
    WCHAR TimeZoneKeyName[ 128 ];
    BOOLEAN DynamicDaylightTimeDisabled;
} DYNAMIC_TIME_ZONE_INFORMATION, *PDYNAMIC_TIME_ZONE_INFORMATION;
]]

ffi.cdef[[
BOOL
__stdcall
SystemTimeToTzSpecificLocalTime(
     const TIME_ZONE_INFORMATION* lpTimeZoneInformation,
     const SYSTEMTIME* lpUniversalTime,
     LPSYSTEMTIME lpLocalTime
    );

BOOL
__stdcall
TzSpecificLocalTimeToSystemTime(
     const TIME_ZONE_INFORMATION* lpTimeZoneInformation,
     const SYSTEMTIME* lpLocalTime,
     LPSYSTEMTIME lpUniversalTime
    );

BOOL
__stdcall
FileTimeToSystemTime(
     const FILETIME* lpFileTime,
     LPSYSTEMTIME lpSystemTime
    );

BOOL
__stdcall
SystemTimeToFileTime(
     const SYSTEMTIME* lpSystemTime,
     LPFILETIME lpFileTime
    );

DWORD
__stdcall
GetTimeZoneInformation(
     LPTIME_ZONE_INFORMATION lpTimeZoneInformation
    );
]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
SetTimeZoneInformation(
     const TIME_ZONE_INFORMATION* lpTimeZoneInformation
    );
]]

if (_WIN32_WINNT >= 0x0600) then

ffi.cdef[[
BOOL
__stdcall
SetDynamicTimeZoneInformation(
     const DYNAMIC_TIME_ZONE_INFORMATION* lpTimeZoneInformation
    );
]]

end --// _WIN32_WINNT >= 0x0600

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

if (_WIN32_WINNT >= 0x0600) then

ffi.cdef[[
DWORD
__stdcall
GetDynamicTimeZoneInformation(
     PDYNAMIC_TIME_ZONE_INFORMATION pTimeZoneInformation
    );
]]

end --// _WIN32_WINNT >= 0x0600

if (_WIN32_WINNT >= 0x0601) then

ffi.cdef[[
BOOL
__stdcall
GetTimeZoneInformationForYear(
     USHORT wYear,
     PDYNAMIC_TIME_ZONE_INFORMATION pdtzi,
     LPTIME_ZONE_INFORMATION ptzi
    );
]]

end --// _WIN32_WINNT >= 0x0601


if (_WIN32_WINNT >= _WIN32_WINNT_WIN8) then

ffi.cdef[[
DWORD
__stdcall
EnumDynamicTimeZoneInformation(
     const DWORD dwIndex,
     PDYNAMIC_TIME_ZONE_INFORMATION lpTimeZoneInformation
    );

DWORD
__stdcall
GetDynamicTimeZoneInformationEffectiveYears(
     const PDYNAMIC_TIME_ZONE_INFORMATION lpTimeZoneInformation,
     LPDWORD FirstYear,
     LPDWORD LastYear
    );

BOOL
__stdcall
SystemTimeToTzSpecificLocalTimeEx(
     const DYNAMIC_TIME_ZONE_INFORMATION* lpTimeZoneInformation,
     const SYSTEMTIME* lpUniversalTime,
     LPSYSTEMTIME lpLocalTime
    );

BOOL
__stdcall
TzSpecificLocalTimeToSystemTimeEx(
     const DYNAMIC_TIME_ZONE_INFORMATION* lpTimeZoneInformation,
     const SYSTEMTIME* lpLocalTime,
     LPSYSTEMTIME lpUniversalTime
    );
]]

end --/* (_WIN32_WINNT >= _WIN32_WINNT_WIN8) */

if (NTDDI_VERSION >= NTDDI_WIN10_RS5) then


ffi.cdef[[
BOOL
__stdcall
LocalFileTimeToLocalSystemTime(
     const TIME_ZONE_INFORMATION* timeZoneInformation,
     const FILETIME* localFileTime,
     SYSTEMTIME* localSystemTime
    );




BOOL
__stdcall
LocalSystemTimeToLocalFileTime(
     const TIME_ZONE_INFORMATION* timeZoneInformation,
     const SYSTEMTIME* localSystemTime,
     FILETIME* localFileTime
    );
]]

#endif /* (NTDDI_VERSION >= NTDDI_WIN10_RS5) */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */

]]

end --// _TIMEZONEAPI_H_

