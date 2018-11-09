
-- minwindef.h -- Basic Windows Type Definitions for minwin partition        *
local ffi = require("ffi")

require("win32.intsafe")


_WIN32 = (ffi.os == "Windows") -- and ffi.abi("64bit");
WIN32 = _WIN32;



ffi.cdef[[
    typedef void *HANDLE;
    typedef HANDLE *PHANDLE;
]]

function DECLARE_HANDLE(name) 
    ffi.cdef(string.format("typedef HANDLE %s",name));
end


ffi.cdef[[
/*
 * BASETYPES is defined in ntdef.h if these types are already defined
 */


typedef ULONG *PULONG;
typedef USHORT *PUSHORT;
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
typedef BYTE			BOOLEAN;
typedef int                 BOOL;
typedef float               FLOAT;
]]

ffi.cdef[[
typedef FLOAT               *PFLOAT;
typedef BOOL                *PBOOL;
typedef BOOL                *LPBOOL;
typedef BYTE                *PBYTE;
typedef BYTE                *LPBYTE;
typedef int                 *PINT;
typedef int                 *LPINT;
typedef WORD                *PWORD;
typedef WORD                *LPWORD;
typedef long                *LPLONG;
typedef DWORD               *PDWORD;
typedef DWORD               *LPDWORD;
typedef void                *LPVOID;
typedef const void          *LPCVOID;

typedef unsigned int        *PUINT;
]]

ffi.cdef[[
typedef void            VOID;
typedef void *			PVOID;
]]


if not NT_INCLUDED then
require "win32.winnt"
end

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
typedef HANDLE           HGLOBAL;
typedef HANDLE           HLOCAL;
typedef HANDLE           GLOBALHANDLE;
typedef HANDLE           LOCALHANDLE;
]]

ffi.cdef[[

typedef INT_PTR (__stdcall *FARPROC)(void);
typedef INT_PTR (__stdcall *NEARPROC)(void);
typedef INT_PTR (__stdcall *PROC)(void);
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


if _MAC then
ffi.cdef[[
    typedef int HFILE;
]]
else
ffi.cdef[[
    typedef short HFILE;
]]
end

if not _FILETIME_ then
_FILETIME_ = true;

ffi.cdef[[
typedef struct _FILETIME {
    DWORD dwLowDateTime;
    DWORD dwHighDateTime;
} FILETIME, *PFILETIME, *LPFILETIME;
]]

end