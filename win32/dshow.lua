--[[
//------------------------------------------------------------------------------
// File: DShow.h
//
// Desc: DirectShow top-level include file
//
// Copyright (c) 2000-2001, Microsoft Corporation.  All rights reserved.
//------------------------------------------------------------------------------
--]]

local ffi = require("ffi")

if not __DSHOW_INCLUDED__ then
__DSHOW_INCLUDED__ = true

require("win32.winapifamily")


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

--[[
#if _MSC_VER>=1100
#define AM_NOVTABLE __declspec(novtable)
#else
#define AM_NOVTABLE
#endif
#endif  // MSC_VER
--]]


--#include <windows.h>
--#include <windowsx.h>
--#include <olectl.h>
--#include <ddraw.h>
require("win32.mmsystem")


if not NO_DSHOW_STRSAFE then
NO_SHLWAPI_STRFCNS = true
-- require("win32.strsafe")  
end

if not NUMELMS then
function NUMELMS(aa) return (ffi.sizeof(aa)/ffi.sizeof((aa)[0])) end
end

--require("win32.strmif")     -- Generated IDL header file for streams interfaces
--require("win32.amvideo")    -- ActiveMovie video interfaces and definitions

if DSHOW_USE_AMAUDIO then
require("win32.amaudio")    -- ActiveMovie audio interfaces and definitions
end


--#include <control.h>    // generated from control.odl
--#include <evcode.h>     // event code definitions
require("win32.uuids")     -- declaration of type GUIDs and well-known clsids
require("win32.errors")    -- HRESULT status and error definitions
--#include <edevdefs.h>   // External device control interface defines
--#include <audevcod.h>   // audio filter device error event codes
--#include <dvdevcod.h>   // DVD error event codes

--[[
///////////////////////////////////////////////////////////////////////////
// Define OLE Automation constants
///////////////////////////////////////////////////////////////////////////
#ifndef OATRUE
#define OATRUE (-1)
#endif // OATRUE
#ifndef OAFALSE
#define OAFALSE (0)
#endif // OAFALSE
--]]

--[[
///////////////////////////////////////////////////////////////////////////
// Define Win64 interfaces if not already defined
///////////////////////////////////////////////////////////////////////////
--]]

--[[
// InterlockedExchangePointer
#ifndef InterlockedExchangePointer
#define InterlockedExchangePointer(Target, Value) \
   (PVOID)InterlockedExchange((PLONG)(Target), (LONG)(Value))
#endif 
--]]

end -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


end -- __DSHOW_INCLUDED__
