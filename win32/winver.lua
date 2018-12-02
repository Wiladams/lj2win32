require("win32.winapifamily")

--[[
/*****************************************************************************\
*                                                                             *
* winver.h -    Version management functions, types, and definitions          *
*                                                                             *
*               Include file for VER.DLL.  This library is                    *
*               designed to allow version stamping of Windows executable files*
*               and of special .VER files for DOS executable files.           *
*                                                                             *
*               Copyright (c) Microsoft Corporation. All rights reserved.     *
*                                                                             *
\*****************************************************************************/
--]]

--#include <SpecStrings.h>
require("win32.verrsrc")





if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

if not RC_INVOKED              --/* RC doesn't need to see the rest of this */

ffi.cdef[[
/* ----- Function prototypes ----- */

DWORD
__stdcall
VerFindFileA(
                                 DWORD uFlags,
                                 LPCSTR szFileName,
                             LPCSTR szWinDir,
                                 LPCSTR szAppDir,
           LPSTR szCurDir,
                              PUINT puCurDirLen,
          LPSTR szDestDir,
                              PUINT puDestDirLen
        );
DWORD
__stdcall
VerFindFileW(
                                 DWORD uFlags,
                                 LPCWSTR szFileName,
                             LPCWSTR szWinDir,
                                 LPCWSTR szAppDir,
           LPWSTR szCurDir,
                              PUINT puCurDirLen,
          LPWSTR szDestDir,
                              PUINT puDestDirLen
        );
]]

--[[
#ifdef UNICODE
#define VerFindFile  VerFindFileW
#else
#define VerFindFile  VerFindFileA
#endif // !UNICODE
--]]

end --// RC_INVOKED

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

if not RC_INVOKED then
ffi.cdef[[
DWORD
__stdcall
VerInstallFileA(
                                 DWORD uFlags,
                                 LPCSTR szSrcFileName,
                                 LPCSTR szDestFileName,
                                 LPCSTR szSrcDir,
                                 LPCSTR szDestDir,
                                 LPCSTR szCurDir,
          LPSTR szTmpFile,
                              PUINT puTmpFileLen
        );
DWORD
__stdcall
VerInstallFileW(
                                 DWORD uFlags,
                                 LPCWSTR szSrcFileName,
                                 LPCWSTR szDestFileName,
                                 LPCWSTR szSrcDir,
                                 LPCWSTR szDestDir,
                                 LPCWSTR szCurDir,
          LPWSTR szTmpFile,
                              PUINT puTmpFileLen
        );
]]

--[[
#ifdef UNICODE
#define VerInstallFile  VerInstallFileW
#else
#define VerInstallFile  VerInstallFileA
#endif // !UNICODE
--]]

end // RC_INVOKED

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

if not RC_INVOKED then
ffi.cdef[[
/* Returns size of version info in bytes */
DWORD
__stdcall
GetFileVersionInfoSizeA(
                LPCSTR lptstrFilename, /* Filename of version stamped file */
         LPDWORD lpdwHandle       /* Information for use by GetFileVersionInfo */
        );
/* Returns size of version info in bytes */
DWORD
__stdcall
GetFileVersionInfoSizeW(
                LPCWSTR lptstrFilename, /* Filename of version stamped file */
         LPDWORD lpdwHandle       /* Information for use by GetFileVersionInfo */
        );
]]

--[[
#ifdef UNICODE
#define GetFileVersionInfoSize  GetFileVersionInfoSizeW
#else
#define GetFileVersionInfoSize  GetFileVersionInfoSizeA
#endif // !UNICODE
--]]

ffi.cdef[[
/* Read version info into buffer */
BOOL
__stdcall
GetFileVersionInfoA(
                        LPCSTR lptstrFilename, /* Filename of version stamped file */
                  DWORD dwHandle,          /* Information from GetFileVersionSize */
                        DWORD dwLen,             /* Length of buffer for info */
         LPVOID lpData            /* Buffer to place the data structure */
        );
/* Read version info into buffer */
BOOL
__stdcall
GetFileVersionInfoW(
                        LPCWSTR lptstrFilename, /* Filename of version stamped file */
                  DWORD dwHandle,          /* Information from GetFileVersionSize */
                        DWORD dwLen,             /* Length of buffer for info */
         LPVOID lpData            /* Buffer to place the data structure */
        );
]]

--[[
#ifdef UNICODE
#define GetFileVersionInfo  GetFileVersionInfoW
#else
#define GetFileVersionInfo  GetFileVersionInfoA
#endif // !UNICODE
--]]

end --// RC_INVOKED

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then 

if not RC_INVOKED then
ffi.cdef[[
DWORD __stdcall GetFileVersionInfoSizeExA( DWORD dwFlags,  LPCSTR lpwstrFilename,  LPDWORD lpdwHandle);
DWORD __stdcall GetFileVersionInfoSizeExW( DWORD dwFlags,  LPCWSTR lpwstrFilename,  LPDWORD lpdwHandle);
]]

--[[
#ifdef UNICODE
#define GetFileVersionInfoSizeEx  GetFileVersionInfoSizeExW
#else
#define GetFileVersionInfoSizeEx  GetFileVersionInfoSizeExA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL __stdcall GetFileVersionInfoExA( DWORD dwFlags,
                                     LPCSTR lpwstrFilename,
                                     DWORD dwHandle,
                                     DWORD dwLen,
                                     LPVOID lpData);
BOOL __stdcall GetFileVersionInfoExW( DWORD dwFlags,
                                     LPCWSTR lpwstrFilename,
                                     DWORD dwHandle,
                                     DWORD dwLen,
                                     LPVOID lpData);
]]

--[[
#ifdef UNICODE
#define GetFileVersionInfoEx  GetFileVersionInfoExW
#else
#define GetFileVersionInfoEx  GetFileVersionInfoExA
#endif // !UNICODE
--]]

end --// RC_INVOKED

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */




if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

if not RC_INVOKED then

ffi.cdef[[
DWORD
__stdcall
VerLanguageNameA(
                          DWORD wLang,
         LPSTR szLang,
                          DWORD cchLang
        );
DWORD
__stdcall
VerLanguageNameW(
                          DWORD wLang,
         LPWSTR szLang,
                          DWORD cchLang
        );
]]

--[[
#ifdef UNICODE
#define VerLanguageName  VerLanguageNameW
#else
#define VerLanguageName  VerLanguageNameA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
VerQueryValueA(
         LPCVOID pBlock,
         LPCSTR lpSubBlock,
         LPVOID * lplpBuffer,
         PUINT puLen
        );
BOOL
__stdcall
VerQueryValueW(
         LPCVOID pBlock,
         LPCWSTR lpSubBlock,
         LPVOID * lplpBuffer,
         PUINT puLen
        );
]]

--[[
#ifdef UNICODE
#define VerQueryValue  VerQueryValueW
#else
#define VerQueryValue  VerQueryValueA
#endif // !UNICODE
--]]

end  --/* !RC_INVOKED */

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */

return ffi.load("Api-ms-win-core-version-l1-1-0")