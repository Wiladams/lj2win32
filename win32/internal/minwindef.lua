
-- minwindef.h -- Basic Windows Type Definitions for minwin partition        *
local ffi = require("ffi")

require("win32.intsafe")

DECLARE_HANDLE = wtypes.DECLARE_HANDLE;


_WIN32 = (ffi.os == "Windows") -- and ffi.abi("64bit");
WIN32 = _WIN32;


ffi.cdef[[
/*
 * BASETYPES is defined in ntdef.h if these types are already defined
 */

typedef unsigned long ULONG;
typedef ULONG *PULONG;
typedef unsigned short USHORT;
typedef USHORT *PUSHORT;
typedef unsigned char UCHAR;
typedef UCHAR *PUCHAR;
typedef char *PSZ;


static const int MAX_PATH = 260;
]]


--[[
#define CALLBACK    __stdcall
#define WINAPI      __stdcall
#define WINAPIV     __cdecl
#define APIENTRY    WINAPI
#define APIPRIVATE  __stdcall
#define PASCAL      __stdcall
--]]


ffi.cdef[[
typedef unsigned long       DWORD;
typedef int                 BOOL;
typedef unsigned char       BYTE;
typedef unsigned short      WORD;
typedef float               FLOAT;
typedef FLOAT               *PFLOAT;
typedef BOOL near           *PBOOL;
typedef BOOL far            *LPBOOL;
typedef BYTE near           *PBYTE;
typedef BYTE far            *LPBYTE;
typedef int near            *PINT;
typedef int far             *LPINT;
typedef WORD near           *PWORD;
typedef WORD far            *LPWORD;
typedef long far            *LPLONG;
typedef DWORD near          *PDWORD;
typedef DWORD far           *LPDWORD;
typedef void far            *LPVOID;
typedef CONST void far      *LPCVOID;

typedef int                 INT;
typedef unsigned int        UINT;
typedef unsigned int        *PUINT;
]]

--#ifndef NT_INCLUDED
--#include <winnt.h>
--#endif /* NT_INCLUDED */

ffi.cdef[[
/* Types use for passing & returning polymorphic values */
typedef UINT_PTR            WPARAM;
typedef LONG_PTR            LPARAM;
typedef LONG_PTR            LRESULT;
]]


--[[
exports.MAKEWORD = function(a, b)      ((WORD)(((BYTE)(((DWORD_PTR)(a)) & 0xff)) | ((WORD)((BYTE)(((DWORD_PTR)(b)) & 0xff))) << 8)) end
exports.MAKELONG = function(a, b)      ((LONG)(((WORD)(((DWORD_PTR)(a)) & 0xffff)) | ((DWORD)((WORD)(((DWORD_PTR)(b)) & 0xffff))) << 16)) end
exports.LOWORD = function(l)           ((WORD)(((DWORD_PTR)(l)) & 0xffff)) end
exports.HIWORD = function(l)           ((WORD)((((DWORD_PTR)(l)) >> 16) & 0xffff)) end
exports.LOBYTE = function(w)           ((BYTE)(((DWORD_PTR)(w)) & 0xff)) end
exports.HIBYTE = function(w)           ((BYTE)((((DWORD_PTR)(w)) >> 8) & 0xff)) end
--]]

ffi.cdef[[
typedef HANDLE         *SPHANDLE;
typedef HANDLE          *LPHANDLE;
typedef HANDLE              HGLOBAL;
typedef HANDLE              HLOCAL;
typedef HANDLE              GLOBALHANDLE;
typedef HANDLE              LOCALHANDLE;
]]

ffi.cdef[[

typedef INT_PTR (WINAPI *FARPROC)(void);
typedef INT_PTR (WINAPI *NEARPROC)(void);
typedef INT_PTR (WINAPI *PROC)(void);
]]

ffi.cdef[[
typedef WORD                ATOM;   //BUGBUG - might want to remove this from minwin
]]

DECLARE_HANDLE("HKEY");
DECLARE_HANDLE("HMETAFILE");
DECLARE_HANDLE("HINSTANCE");
DECLARE_HANDLE("HRGN");
DECLARE_HANDLE("HRSRC");
DECLARE_HANDLE("HSPRITE");
DECLARE_HANDLE("HLSURF");
DECLARE_HANDLE("HSTR");
DECLARE_HANDLE("HTASK");
DECLARE_HANDLE("HWINSTA");
DECLARE_HANDLE("HKL");

ffi.cdef[[
typedef HKEY *PHKEY;
typedef HINSTANCE HMODULE;      /* HMODULEs can be used in place of HINSTANCEs */
]]


#ifndef _MAC
typedef int HFILE;
#else
typedef short HFILE;
#endif

ffi.cdef[[
//
//  File System time stamps are represented with the following structure:
//
typedef struct _FILETIME {
    DWORD dwLowDateTime;
    DWORD dwHighDateTime;
} FILETIME, *PFILETIME, *LPFILETIME;

]]

