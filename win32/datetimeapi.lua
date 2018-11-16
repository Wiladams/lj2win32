-- core_datetime_l1_1_1.lua
-- api-ms-win-core-datetime-l1-1-1.dll	

local ffi = require("ffi");

require("win32.minwindef")
require("win32.minwinbase")


ffi.cdef[[
// For Windows Vista and above GetTimeFormatEx is preferred
int
GetTimeFormatA(
    LCID             Locale,
    DWORD            dwFlags,
    const SYSTEMTIME *lpTime,
    LPCSTR          lpFormat,
    LPSTR          lpTimeStr,
    int              cchTime);
// For Windows Vista and above GetTimeFormatEx is preferred
int
GetTimeFormatW(
    LCID             Locale,
    DWORD            dwFlags,
    const SYSTEMTIME *lpTime,
    LPCWSTR          lpFormat,
    LPWSTR          lpTimeStr,
    int              cchTime);

int
GetTimeFormatEx(
    LPCWSTR lpLocaleName,
    DWORD dwFlags,
    const SYSTEMTIME *lpTime,
    LPCWSTR lpFormat,
    LPWSTR lpTimeStr,
    int cchTime
);


// For Windows Vista and above GetDateFormatEx is preferred
int
GetDateFormatA(
    LCID             Locale,
    DWORD            dwFlags,
    const SYSTEMTIME *lpDate,
    LPCSTR          lpFormat,
    LPSTR          lpDateStr,
    int              cchDate);
// For Windows Vista and above GetDateFormatEx is preferred
int
GetDateFormatW(
    LCID             Locale,
    DWORD            dwFlags,
    const SYSTEMTIME *lpDate,
    LPCWSTR          lpFormat,
    LPWSTR          lpDateStr,
    int              cchDate);

int
GetDateFormatEx(
    LPCWSTR lpLocaleName,
    DWORD dwFlags,
    const SYSTEMTIME *lpDate,
    LPCWSTR lpFormat,
    LPWSTR lpDateStr,
    int cchDate,
    LPCWSTR lpCalendar
);
]]

ffi.cdef[[
int
__stdcall
GetDurationFormatEx(
     LPCWSTR lpLocaleName,
     DWORD dwFlags,
     const SYSTEMTIME* lpDuration,
     ULONGLONG ullDuration,
     LPCWSTR lpFormat,
    LPWSTR lpDurationStr,
     int cchDuration
    );
]]

