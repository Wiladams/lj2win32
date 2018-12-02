local ffi = require("ffi")
-- stringapi.h -- ApiSet Contract for api-ms-win-core-string-l1                  *



--#ifndef _APISETSTRING_
--#define _APISETSTRING_

--#include <apiset.h>
--#include <apisetcconv.h>
require("win32.minwindef")
require("win32.winnls")



--#if (WINVER >= 0x0600)


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP, WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
int
__stdcall
CompareStringEx(
     LPCWSTR lpLocaleName,
     DWORD dwCmpFlags,
     LPCWCH lpString1,
     int cchCount1,
     LPCWCH lpString2,
     int cchCount2,
     LPNLSVERSIONINFO lpVersionInformation,
     LPVOID lpReserved,
     LPARAM lParam
    );



int
__stdcall
CompareStringOrdinal(
     LPCWCH lpString1,
     int cchCount1,
     LPCWCH lpString2,
     int cchCount2,
     BOOL bIgnoreCase
    );
]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


--#endif //(WINVER >= 0x0600)


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
int
__stdcall
CompareStringW(
     LCID Locale,
     DWORD dwCmpFlags,
     PCNZWCH lpString1,
     int cchCount1,
     PCNZWCH lpString2,
     int cchCount2
    );
]]

--[[
#ifdef UNICODE
#define CompareString  CompareStringW
#endif
--]]

ffi.cdef[[
int
__stdcall
FoldStringW(
     DWORD dwMapFlags,
     LPCWCH lpSrcStr,
     int cchSrc,
     LPWSTR lpDestStr,
     int cchDest
    );
]]

--[[
#ifdef UNICODE
#define FoldString  FoldStringW
#endif
--]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
GetStringTypeExW(
     LCID Locale,
     DWORD dwInfoType,
     LPCWCH lpSrcStr,
     int cchSrc,
     LPWORD lpCharType
    );
]]

--[[
#ifdef UNICODE
#define GetStringTypeEx  GetStringTypeExW
#endif
--]]

ffi.cdef[[
BOOL
__stdcall
GetStringTypeW(
     DWORD dwInfoType,
     LPCWCH lpSrcStr,
     int cchSrc,
     LPWORD lpCharType
    );
]]



ffi.cdef[[
int
__stdcall
MultiByteToWideChar(
     UINT CodePage,
     DWORD dwFlags,
     LPCCH lpMultiByteStr,
     int cbMultiByte,
     LPWSTR lpWideCharStr,
     int cchWideChar
    );




int
__stdcall
WideCharToMultiByte(
     UINT CodePage,
     DWORD dwFlags,
     LPCWCH lpWideCharStr,
     int cchWideChar,
     LPSTR lpMultiByteStr,
     int cbMultiByte,
     LPCCH lpDefaultChar,
     LPBOOL lpUsedDefaultChar
    );
]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


--#endif // _APISETSTRING_
