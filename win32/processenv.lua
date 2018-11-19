--[[
* ProcessEnv.h -- ApiSet Contract for api-ms-win-core-processenvironment-l1     *
--]]


local ffi = require("ffi")
require("win32.minwindef")


ffi.cdef[[
BOOL
__stdcall
SetEnvironmentStringsW(
      LPWCH NewEnvironment
    );
]]

--[[
#ifdef UNICODE
#define SetEnvironmentStrings  SetEnvironmentStringsW
#endif
--]]

ffi.cdef[[
HANDLE
__stdcall
GetStdHandle(
    DWORD nStdHandle
    );



BOOL
__stdcall
SetStdHandle(
    DWORD nStdHandle,
    HANDLE hHandle
    );
]]

ffi.cdef[[
BOOL
__stdcall
SetStdHandleEx(
    DWORD nStdHandle,
    HANDLE hHandle,
     PHANDLE phPrevValue
    );
]]



ffi.cdef[[
LPSTR
__stdcall
GetCommandLineA(
    VOID
    );


LPWSTR
__stdcall
GetCommandLineW(
    VOID
    );
]]

--[[
#ifdef UNICODE
#define GetCommandLine  GetCommandLineW
#else
#define GetCommandLine  GetCommandLineA
#endif // !UNICODE
--]]

ffi.cdef[[
LPCH
__stdcall
GetEnvironmentStrings(
    VOID
    );




LPWCH
__stdcall
GetEnvironmentStringsW(
    VOID
    );
]]

--[[
#ifdef UNICODE
#define GetEnvironmentStrings  GetEnvironmentStringsW
#else
#define GetEnvironmentStringsA  GetEnvironmentStrings
#endif // !UNICODE
--]]


ffi.cdef[[
BOOL
__stdcall
FreeEnvironmentStringsA(
      LPCH penv
    );


BOOL
__stdcall
FreeEnvironmentStringsW(
      LPWCH penv
    );
]]

--[[
#ifdef UNICODE
#define FreeEnvironmentStrings  FreeEnvironmentStringsW
#else
#define FreeEnvironmentStrings  FreeEnvironmentStringsA
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD
__stdcall
GetEnvironmentVariableA(
     LPCSTR lpName,
     LPSTR lpBuffer,
    DWORD nSize
    );



DWORD
__stdcall
GetEnvironmentVariableW(
     LPCWSTR lpName,
     LPWSTR lpBuffer,
    DWORD nSize
    );
]]

--[[
#ifdef UNICODE
#define GetEnvironmentVariable  GetEnvironmentVariableW
#else
#define GetEnvironmentVariable  GetEnvironmentVariableA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
SetEnvironmentVariableA(
    LPCSTR lpName,
     LPCSTR lpValue
    );


BOOL
__stdcall
SetEnvironmentVariableW(
    LPCWSTR lpName,
     LPCWSTR lpValue
    );
]]

--[[
#ifdef UNICODE
#define SetEnvironmentVariable  SetEnvironmentVariableW
#else
#define SetEnvironmentVariable  SetEnvironmentVariableA
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD
__stdcall
ExpandEnvironmentStringsA(
    LPCSTR lpSrc,
     LPSTR lpDst,
    DWORD nSize
    );

DWORD
__stdcall
ExpandEnvironmentStringsW(
    LPCWSTR lpSrc,
     LPWSTR lpDst,
    DWORD nSize
    );
]]

--[[
#ifdef UNICODE
#define ExpandEnvironmentStrings  ExpandEnvironmentStringsW
#else
#define ExpandEnvironmentStrings  ExpandEnvironmentStringsA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
SetCurrentDirectoryA(
    LPCSTR lpPathName
    );


BOOL
__stdcall
SetCurrentDirectoryW(
    LPCWSTR lpPathName
    );
]]

--[[
#ifdef UNICODE
#define SetCurrentDirectory  SetCurrentDirectoryW
#else
#define SetCurrentDirectory  SetCurrentDirectoryA
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD
__stdcall
GetCurrentDirectoryA(
    DWORD nBufferLength,
     LPSTR lpBuffer
    );



DWORD
__stdcall
GetCurrentDirectoryW(
    DWORD nBufferLength,
     LPWSTR lpBuffer
    );
]]

--[[
#ifdef UNICODE
#define GetCurrentDirectory  GetCurrentDirectoryW
#else
#define GetCurrentDirectory  GetCurrentDirectoryA
#endif // !UNICODE
--]]



ffi.cdef[[
DWORD
__stdcall
SearchPathW(
     LPCWSTR lpPath,
    LPCWSTR lpFileName,
     LPCWSTR lpExtension,
    DWORD nBufferLength,
     LPWSTR lpBuffer,
     LPWSTR* lpFilePart
    );
]]

--[[
#ifdef UNICODE
#define SearchPath  SearchPathW
#else
#define SearchPath  SearchPathA
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD
SearchPathA(
     LPCSTR lpPath,
    LPCSTR lpFileName,
     LPCSTR lpExtension,
    DWORD nBufferLength,
     LPSTR lpBuffer,
     LPSTR* lpFilePart
    );
]]


ffi.cdef[[
BOOL
__stdcall
NeedCurrentDirectoryForExePathA(
    LPCSTR ExeName
    );


BOOL
__stdcall
NeedCurrentDirectoryForExePathW(
    LPCWSTR ExeName
    );
]]

--[[
#ifdef UNICODE
#define NeedCurrentDirectoryForExePath  NeedCurrentDirectoryForExePathW
#else
#define NeedCurrentDirectoryForExePath  NeedCurrentDirectoryForExePathA
#endif // !UNICODE
--]]
