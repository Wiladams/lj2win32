

local ffi = require("ffi")
local bit = require("bit")
local band, bor = bit.band, bit.bor
local lshift, rshift = bit.lshift, bit.rshift

--#include <specstrings.h>
require("win32.winapifamily")


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP, WINAPI_PARTITION_SYSTEM) then

if not NO_STRICT then
if not STRICT then
STRICT  = 1
end
end -- NO_STRICT */

-- Win32 defines _WIN32 automatically,
-- but Macintosh doesn't, so if we are using
-- Win32 Functions, we must do it here


if not WIN32 then
_WIN32 = true
WIN32 = true
end

_WIN64 = (ffi.os == "Windows") and ffi.abi("64bit");

--[[
/*
 * BASETYPES is defined in ntdef.h if these types are already defined
 */
--]]

if not BASETYPES then
BASETYPES = true

ffi.cdef[[
typedef unsigned long ULONG;
typedef ULONG *PULONG;
typedef unsigned short USHORT;
typedef USHORT *PUSHORT;
typedef unsigned char UCHAR;
typedef UCHAR *PUCHAR;
typedef char *PSZ;      // null terminated
]]
end  --/* !BASETYPES */

ffi.cdef[[
static const int MAX_PATH  =  260;
]]

-- not really
-- ffi.cdef[[
-- typedef (void *) NULL;
-- ]]

--[[
#ifndef FALSE
#define FALSE               0
#endif

#ifndef TRUE
#define TRUE                1
#endif
--]]

--[[
#ifndef IN
#define IN
#endif

#ifndef OUT
#define OUT
#endif

#ifndef OPTIONAL
#define OPTIONAL
#endif
--]]

--[[]
#undef far
#undef near
#undef pascal

#define far
#define near

#if (!defined(_MAC)) && ((_MSC_VER >= 800) || defined(_STDCALL_SUPPORTED))
#define pascal __stdcall
#else
#define pascal
#endif

#if defined(DOSWIN32) || defined(_MAC)
#define cdecl _cdecl
#ifndef CDECL
#define CDECL _cdecl
#endif
#else
#define cdecl
#ifndef CDECL
#define CDECL
#endif
#endif

#ifdef _MAC
#define CALLBACK    PASCAL
#define WINAPI      CDECL
#define WINAPIV     CDECL
#define APIENTRY    WINAPI
#define APIPRIVATE  CDECL
#ifdef _68K_
#define PASCAL      __pascal
#else
#define PASCAL
#endif
#elif (_MSC_VER >= 800) || defined(_STDCALL_SUPPORTED)
#define CALLBACK    __stdcall
#define WINAPI      __stdcall
#define WINAPIV     __cdecl
#define APIENTRY    WINAPI
#define APIPRIVATE  __stdcall
#define PASCAL      __stdcall
#else
#define CALLBACK
#define WINAPI
#define WINAPIV
#define APIENTRY    WINAPI
#define APIPRIVATE
#define PASCAL      pascal
#endif

#ifndef _M_CEE_PURE
#ifndef WINAPI_INLINE
#define WINAPI_INLINE  WINAPI
#endif
#endif

#undef FAR
#undef  NEAR
#define FAR                 far
#define NEAR                near
#ifndef CONST
#define CONST               const
#endif
--]]

ffi.cdef[[
typedef unsigned long       DWORD;
typedef int                 BOOL;
typedef unsigned char       BYTE;
typedef unsigned short      WORD;
typedef float               FLOAT;
typedef FLOAT               *PFLOAT;
typedef BOOL            *PBOOL;
typedef BOOL             *LPBOOL;
typedef BYTE            *PBYTE;
typedef BYTE             *LPBYTE;
typedef int             *PINT;
typedef int              *LPINT;
typedef WORD            *PWORD;
typedef WORD             *LPWORD;
typedef long             *LPLONG;
typedef DWORD           *PDWORD;
typedef DWORD            *LPDWORD;
typedef void             *LPVOID;
typedef const void       *LPCVOID;

typedef int                 INT;
typedef unsigned int        UINT;
typedef unsigned int        *PUINT;
]]

if not NT_INCLUDED then
require("win32.winnt")
end -- /* NT_INCLUDED */

ffi.cdef[[
/* Types use for passing & returning polymorphic values */
typedef UINT_PTR            WPARAM;
typedef LONG_PTR            LPARAM;
typedef LONG_PTR            LRESULT;
]]

--[[
#ifndef NOMINMAX

#ifndef max
#define max(a,b)            (((a) > (b)) ? (a) : (b))
#endif

#ifndef min
#define min(a,b)            (((a) < (b)) ? (a) : (b))
#endif

#endif  /* NOMINMAX */
--]]

if not MAKEWORD then
function MAKEWORD(low,high)
    return   ffi.cast("WORD", bor(band(low,0xff) , lshift(high, 8)))
end
end

local BYTE = ffi.typeof("BYTE")
local WORD = ffi.typeof("WORD")
local DWORD = ffi.typeof("DWORD")
local LONG = ffi.typeof("LONG")
local DWORD_PTR = ffi.typeof("DWORD_PTR")

function MAKEWORD(a, b)    return  WORD(bor(BYTE(band(DWORD_PTR(a) , 0xff)) , WORD(lshift(BYTE(band(DWORD_PTR(b) , 0xff)) , 8)))) end
function MAKELONG(a, b)    return  LONG(bor(WORD(band(DWORD_PTR(a) , 0xffff)) , lshift(DWORD(WORD(band(DWORD_PTR(b) , 0xffff))) , 16))) end
function LOWORD(l)         return  WORD(band(DWORD_PTR(l) , 0xffff)) end
function HIWORD(l)         return  WORD(band(rshift(DWORD_PTR(l) , 16) , 0xffff)) end
function LOBYTE(w)         return BYTE(band(DWORD_PTR(w) , 0xff)) end
function HIBYTE(w)         return  BYTE(band(rshift(DWORD_PTR(w), 8) , 0xff)) end


ffi.cdef[[
typedef HANDLE          *SPHANDLE;
typedef HANDLE           *LPHANDLE;
typedef HANDLE              HGLOBAL;
typedef HANDLE              HLOCAL;
typedef HANDLE              GLOBALHANDLE;
typedef HANDLE              LOCALHANDLE;
]]


if not _MANAGED then

if _WIN64 then
ffi.cdef[[
typedef INT_PTR ( __stdcall *FARPROC)();
typedef INT_PTR ( __stdcall *NEARPROC)();
typedef INT_PTR (__stdcall *PROC)();
]]
else
ffi.cdef[[
typedef int ( __stdcall *FARPROC)();
typedef int ( __stdcall *NEARPROC)();
typedef int ( __stdcall *PROC)();
]]
end  -- _WIN64



else
ffi.cdef[[
typedef INT_PTR ( *FARPROC)(void);
typedef INT_PTR ( *NEARPROC)(void);
typedef INT_PTR ( *PROC)(void);
]]
end


ffi.cdef[[
typedef WORD                ATOM;   //BUGBUG - might want to remove this from minwin
]]

DECLARE_HANDLE("HKEY");
ffi.cdef[[
typedef HKEY *PHKEY;
]]
DECLARE_HANDLE("HMETAFILE");
DECLARE_HANDLE("HINSTANCE");
ffi.cdef[[
typedef HINSTANCE HMODULE;      /* HMODULEs can be used in place of HINSTANCEs */
]]
DECLARE_HANDLE("HRGN");
DECLARE_HANDLE("HRSRC");
DECLARE_HANDLE("HSPRITE");
DECLARE_HANDLE("HLSURF");
DECLARE_HANDLE("HSTR");
DECLARE_HANDLE("HTASK");
DECLARE_HANDLE("HWINSTA");
DECLARE_HANDLE("HKL");

if not _MAC then
ffi.cdef[[
typedef int HFILE;
]]
else
ffi.cdef[[
typedef short HFILE;
]]
end


ffi.cdef[[
typedef struct _FILETIME {
    DWORD dwLowDateTime;
    DWORD dwHighDateTime;
} FILETIME, *PFILETIME, *LPFILETIME;
]]
_FILETIME_ = true;



end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


