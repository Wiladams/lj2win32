--[[
//------------------------------------------------------------------------------
// File: Errors.h
//
// Desc:  ActiveMovie error defines.
//
// Copyright (c) 1992 - 2001, Microsoft Corporation.  All rights reserved.
//------------------------------------------------------------------------------
--]]

local ffi = require("ffi")

if not __ERRORS__ then
__ERRORS__ = true

require("win32.winapifamily")


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


--[[
#ifndef _AMOVIE_
#define AMOVIEAPI   DECLSPEC_IMPORT
#else
#define AMOVIEAPI
#endif
--]]

ffi.cdef[[
// codes 0-01ff are reserved for OLE
static const int VFW_FIRST_CODE  = 0x200;
static const int MAX_ERROR_TEXT_LEN = 160;
]]

--#include <VFWMSGS.H>                    // includes all message definitions

ffi.cdef[[
typedef BOOL (__stdcall* AMGETERRORTEXTPROCA)(HRESULT, char *, DWORD);
typedef BOOL (__stdcall* AMGETERRORTEXTPROCW)(HRESULT, WCHAR *, DWORD);
]]

ffi.cdef[[
DWORD __stdcall AMGetErrorTextA( HRESULT hr ,  LPSTR pbuffer , DWORD MaxLen);
DWORD __stdcall AMGetErrorTextW( HRESULT hr ,  LPWSTR pbuffer , DWORD MaxLen);
]]

if UNICODE then
--#define AMGetErrorText  AMGetErrorTextW
ffi.cdef[[
typedef AMGETERRORTEXTPROCW AMGETERRORTEXTPROC;
]]
else
--#define AMGetErrorText  AMGetErrorTextA
ffi.cdef[[
typedef AMGETERRORTEXTPROCA AMGETERRORTEXTPROC;
]]
end


end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


end -- __ERRORS__
