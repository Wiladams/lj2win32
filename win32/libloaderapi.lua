-- libloaderapi.lua -- ApiSet Contract for api-ms-win-core-libraryloader-l1        *



local ffi = require("ffi")

if not _APISETLIBLOADER_ then
_APISETLIBLOADER_ = true;


require("win32.minwindef")
require("win32.minwinbase")

ffi.cdef[[
static const int  FIND_RESOURCE_DIRECTORY_TYPES      = 0x0100;
static const int  FIND_RESOURCE_DIRECTORY_NAMES      = 0x0200;
static const int  FIND_RESOURCE_DIRECTORY_LANGUAGES  = 0x0400;

static const int  RESOURCE_ENUM_LN              = 0x0001;
static const int  RESOURCE_ENUM_MUI             = 0x0002;
static const int  RESOURCE_ENUM_MUI_SYSTEM      = 0x0004;
static const int  RESOURCE_ENUM_VALIDATE        = 0x0008;
static const int  RESOURCE_ENUM_MODULE_EXACT    = 0x0010;

static const int SUPPORT_LANG_NUMBER = 32;

typedef struct tagENUMUILANG {
    ULONG  NumOfEnumUILang;    // Acutall number of enumerated languages
    ULONG  SizeOfEnumUIBuffer; // Buffer size of pMUIEnumUILanguages
    LANGID *pEnumUIBuffer;
} ENUMUILANG, *PENUMUILANG;
]]


ffi.cdef[[
typedef BOOL (__stdcall * ENUMRESLANGPROCA)(
    HMODULE hModule,
    LPCSTR lpType,
    LPCSTR lpName,
    WORD wLanguage,
    LONG_PTR lParam);

typedef BOOL (__stdcall * ENUMRESLANGPROCW)(
    HMODULE hModule,
    LPCWSTR lpType,
    LPCWSTR lpName,
    WORD wLanguage,
    LONG_PTR lParam);
]]

--[[
#ifdef UNICODE
#define ENUMRESLANGPROC  ENUMRESLANGPROCW
#else
#define ENUMRESLANGPROC  ENUMRESLANGPROCA
#endif // !UNICODE
--]]

ffi.cdef[[
typedef BOOL (__stdcall * ENUMRESNAMEPROCA)(
    HMODULE hModule,
    LPCSTR lpType,
    LPSTR lpName,
    LONG_PTR lParam);
typedef BOOL (__stdcall * ENUMRESNAMEPROCW)(
    HMODULE hModule,
    LPCWSTR lpType,
    LPWSTR lpName,
    LONG_PTR lParam);
]]

--[[
#ifdef UNICODE
#define ENUMRESNAMEPROC  ENUMRESNAMEPROCW
#else
#define ENUMRESNAMEPROC  ENUMRESNAMEPROCA
#endif // !UNICODE
--]]

ffi.cdef[[
typedef BOOL (__stdcall * ENUMRESTYPEPROCA)(
    HMODULE hModule,
    LPSTR lpType,
    LONG_PTR lParam
    );
typedef BOOL (__stdcall * ENUMRESTYPEPROCW)(
    HMODULE hModule,
    LPWSTR lpType,
    LONG_PTR lParam
    );
]]

--[[
#ifdef UNICODE
#define ENUMRESTYPEPROC  ENUMRESTYPEPROCW
#else
#define ENUMRESTYPEPROC  ENUMRESTYPEPROCA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
DisableThreadLibraryCalls(
    HMODULE hLibModule
    );
]]


ffi.cdef[[
HRSRC
__stdcall
FindResourceExW(
    HMODULE hModule,
    LPCWSTR lpType,
    LPCWSTR lpName,
    WORD wLanguage
    );
]]


--[[
#ifdef UNICODE
#define FindResourceEx  FindResourceExW
#endif
--]]

ffi.cdef[[
int
__stdcall
FindStringOrdinal(
    DWORD dwFindStringOrdinalFlags,
    LPCWSTR lpStringSource,
    int cchSource,
    LPCWSTR lpStringValue,
    int cchValue,
    BOOL bIgnoreCase
    );



BOOL
__stdcall
FreeLibrary(
    HMODULE hLibModule
    );




void
__stdcall
FreeLibraryAndExitThread(
    HMODULE hLibModule,
    DWORD dwExitCode
    );

    

BOOL
__stdcall
FreeResource(
    HGLOBAL hResData
    );




DWORD
__stdcall
GetModuleFileNameA(
    HMODULE hModule,
    LPSTR lpFilename,
    DWORD nSize
    );


DWORD
__stdcall
GetModuleFileNameW(
    HMODULE hModule,
    LPWSTR lpFilename,
    DWORD nSize
    );
]]

--[[
#ifdef UNICODE
#define GetModuleFileName  GetModuleFileNameW
#else
#define GetModuleFileName  GetModuleFileNameA
#endif // !UNICODE
--]]

ffi.cdef[[
HMODULE
__stdcall
GetModuleHandleA(
    LPCSTR lpModuleName
    );


HMODULE
__stdcall
GetModuleHandleW(
    LPCWSTR lpModuleName
    );
]]

--[[
#ifdef UNICODE
#define GetModuleHandle  GetModuleHandleW
#else
#define GetModuleHandle  GetModuleHandleA
#endif // !UNICODE
--]]

if not RC_INVOKED then
ffi.cdef[[
static const int GET_MODULE_HANDLE_EX_FLAG_PIN                = (0x00000001);
static const int GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT = (0x00000002);
static const int GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS       = (0x00000004);

typedef BOOL (__stdcall* PGET_MODULE_HANDLE_EXA)(DWORD dwFlags, LPCSTR     lpModuleName, HMODULE*    phModule);

typedef
BOOL
(__stdcall*
PGET_MODULE_HANDLE_EXW)(
           DWORD        dwFlags,
       LPCWSTR     lpModuleName,
     HMODULE*    phModule
    );
]]

--[[
#ifdef UNICODE
#define PGET_MODULE_HANDLE_EX  PGET_MODULE_HANDLE_EXW
#else
#define PGET_MODULE_HANDLE_EX  PGET_MODULE_HANDLE_EXA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
GetModuleHandleExA(
    DWORD dwFlags,
    LPCSTR lpModuleName,
     HMODULE* phModule
    );


BOOL
__stdcall
GetModuleHandleExW(
    DWORD dwFlags,
    LPCWSTR lpModuleName,
     HMODULE* phModule
    );
]]

--[[
#ifdef UNICODE
#define GetModuleHandleEx  GetModuleHandleExW
#else
#define GetModuleHandleEx  GetModuleHandleExA
#endif // !UNICODE
--]]
end



ffi.cdef[[
FARPROC __stdcall GetProcAddress(HMODULE hModule, LPCSTR lpProcName);
]]



ffi.cdef[[
HMODULE
__stdcall
LoadLibraryExA(
    LPCSTR lpLibFileName,
     HANDLE hFile,
    DWORD dwFlags
    );


HMODULE
__stdcall
LoadLibraryExW(
    LPCWSTR lpLibFileName,
     HANDLE hFile,
    DWORD dwFlags
    );
]]

--[[
#ifdef UNICODE
#define LoadLibraryEx  LoadLibraryExW
#else
#define LoadLibraryEx  LoadLibraryExA
#endif // !UNICODE
--]]

ffi.cdef[[
static const int DONT_RESOLVE_DLL_REFERENCES       =  0x00000001;
static const int LOAD_LIBRARY_AS_DATAFILE          =  0x00000002;
// reserved for internal LOAD_PACKAGED_LIBRARY: 0x00000004;
static const int LOAD_WITH_ALTERED_SEARCH_PATH     =  0x00000008;
static const int LOAD_IGNORE_CODE_AUTHZ_LEVEL      =  0x00000010;
static const int LOAD_LIBRARY_AS_IMAGE_RESOURCE    =  0x00000020;
static const int LOAD_LIBRARY_AS_DATAFILE_EXCLUSIVE=  0x00000040;
static const int LOAD_LIBRARY_REQUIRE_SIGNED_TARGET=  0x00000080;
static const int LOAD_LIBRARY_SEARCH_DLL_LOAD_DIR  =  0x00000100;
static const int LOAD_LIBRARY_SEARCH_APPLICATION_DIR= 0x00000200;
static const int LOAD_LIBRARY_SEARCH_USER_DIRS     =  0x00000400;
static const int LOAD_LIBRARY_SEARCH_SYSTEM32      =  0x00000800;
static const int LOAD_LIBRARY_SEARCH_DEFAULT_DIRS  =  0x00001000;
]]

--[[
#if (NTDDI_VERSION >= NTDDI_WIN10_RS1)

#define LOAD_LIBRARY_SAFE_CURRENT_DIRS      0x00002000

#define LOAD_LIBRARY_SEARCH_SYSTEM32_NO_FORWARDER   0x00004000

#else

//
// For anything building for downlevel, set the flag to be the same as LOAD_LIBRARY_SEARCH_SYSTEM32
// such that they're treated the same when running on older version of OS.
//

#define LOAD_LIBRARY_SEARCH_SYSTEM32_NO_FORWARDER   LOAD_LIBRARY_SEARCH_SYSTEM32

#endif // (_APISET_LIBLOADER_VER >= 0x0202)
--]]

ffi.cdef[[
static const int LOAD_LIBRARY_OS_INTEGRITY_CONTINUITY  = 0x00008000;
]]

ffi.cdef[[
HGLOBAL
__stdcall
LoadResource(
    HMODULE hModule,
    HRSRC hResInfo
    );

int
__stdcall
LoadStringA(
    HINSTANCE hInstance,
    UINT uID,
    LPSTR lpBuffer,
    int cchBufferMax
    );

int
__stdcall
LoadStringW(
    HINSTANCE hInstance,
    UINT uID,
    LPWSTR lpBuffer,
    int cchBufferMax
    );
]]

--[[
#ifdef UNICODE
#define LoadString  LoadStringW
#else
#define LoadString  LoadStringA
#endif // !UNICODE
--]]


ffi.cdef[[
LPVOID __stdcall LockResource(HGLOBAL hResData);



DWORD
__stdcall
SizeofResource(
    HMODULE hModule,
    HRSRC hResInfo
    );
]]


ffi.cdef[[
typedef PVOID DLL_DIRECTORY_COOKIE, *PDLL_DIRECTORY_COOKIE;

DLL_DIRECTORY_COOKIE
__stdcall
AddDllDirectory(
    PCWSTR NewDirectory
    );

BOOL
__stdcall
RemoveDllDirectory(
    DLL_DIRECTORY_COOKIE Cookie
    );

BOOL
__stdcall
SetDefaultDllDirectories(
    DWORD DirectoryFlags
    );
]]



ffi.cdef[[
BOOL
__stdcall
EnumResourceLanguagesExA(
    HMODULE hModule,
    LPCSTR lpType,
    LPCSTR lpName,
    ENUMRESLANGPROCA lpEnumFunc,
    LONG_PTR lParam,
    DWORD dwFlags,
    LANGID LangId
    );


BOOL
__stdcall
EnumResourceLanguagesExW(
    HMODULE hModule,
    LPCWSTR lpType,
    LPCWSTR lpName,
    ENUMRESLANGPROCW lpEnumFunc,
    LONG_PTR lParam,
    DWORD dwFlags,
    LANGID LangId
    );
]]

--[[
#ifdef UNICODE
#define EnumResourceLanguagesEx  EnumResourceLanguagesExW
#else
#define EnumResourceLanguagesEx  EnumResourceLanguagesExA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
EnumResourceNamesExA(
    HMODULE hModule,
    LPCSTR lpType,
    ENUMRESNAMEPROCA lpEnumFunc,
    LONG_PTR lParam,
    DWORD dwFlags,
    LANGID LangId
    );


BOOL
__stdcall
EnumResourceNamesExW(
    HMODULE hModule,
    LPCWSTR lpType,
    ENUMRESNAMEPROCW lpEnumFunc,
    LONG_PTR lParam,
    DWORD dwFlags,
    LANGID LangId
    );
]]

--[[
#ifdef UNICODE
#define EnumResourceNamesEx  EnumResourceNamesExW
#else
#define EnumResourceNamesEx  EnumResourceNamesExA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
EnumResourceTypesExA(
    HMODULE hModule,
    ENUMRESTYPEPROCA lpEnumFunc,
    LONG_PTR lParam,
    DWORD dwFlags,
    LANGID LangId
    );


BOOL
__stdcall
EnumResourceTypesExW(
    HMODULE hModule,
    ENUMRESTYPEPROCW lpEnumFunc,
    LONG_PTR lParam,
    DWORD dwFlags,
    LANGID LangId
    );
]]

--[[
#ifdef UNICODE
#define EnumResourceTypesEx  EnumResourceTypesExW
#else
#define EnumResourceTypesEx  EnumResourceTypesExA
#endif // !UNICODE
--]]



ffi.cdef[[

HRSRC
__stdcall
FindResourceW(
    HMODULE hModule,
    LPCWSTR lpName,
    LPCWSTR lpType
    );
]]

--[[
#ifdef UNICODE
#define FindResource  FindResourceW
#endif
--]]

ffi.cdef[[
HMODULE
__stdcall
LoadLibraryA(
    LPCSTR lpLibFileName
    );



HMODULE
__stdcall
LoadLibraryW(
    LPCWSTR lpLibFileName
    );
]]

--[[
#ifdef UNICODE
#define LoadLibrary  LoadLibraryW
#else
#define LoadLibrary  LoadLibraryA
#endif // !UNICODE
--]]


ffi.cdef[[
BOOL
__stdcall
EnumResourceNamesW(
    HMODULE hModule,
    LPCWSTR lpType,
    ENUMRESNAMEPROCW lpEnumFunc,
    LONG_PTR lParam
    );
]]

--[[
if UNICODE then
EnumResourceNames  = EnumResourceNamesW
end
--]]
end -- _APISETLIBLOADER_
