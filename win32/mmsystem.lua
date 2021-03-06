local ffi = require("ffi")

require ("win32.winapifamily")

--[[
/*==========================================================================
 *
 *  mmsystem.h -- Include file for Multimedia API's
 *
 *  Version 4.00
 *
 *  Copyright (C) 1992-1998 Microsoft Corporation.  All Rights Reserved.
 *
 *--------------------------------------------------------------------------
 *
 *  Define:         Prevent inclusion of:
 *  --------------  --------------------------------------------------------
 *  MMNODRV         Installable driver support
 *  MMNOSOUND       Sound support
 *  MMNOWAVE        Waveform support
 *  MMNOMIDI        MIDI support
 *  MMNOAUX         Auxiliary audio support
 *  MMNOMIXER       Mixer support
 *  MMNOTIMER       Timer support
 *  MMNOJOY         Joystick support
 *  MMNOMCI         MCI support
 *  MMNOMMIO        Multimedia file I/O support
 *  MMNOMMSYSTEM    General MMSYSTEM functions
 *
 *==========================================================================
 */
--]]

if not _INC_MMSYSTEM then
_INC_MMSYSTEM = true   --/* #defined if mmsystem.h has been included */


require ("win32.mmsyscom")

--[[
#ifdef _WIN32
#include <pshpack1.h>
#else
#ifndef RC_INVOKED
#pragma pack(1)
#endif
#endif
--]]


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

--                    Multimedia Extensions Window Messages

if not MMNOMCI then
-- MMNOMCI         MCI support
-- NYI require("win32.mciapi")
end -- #ifndef MMNOMCI

-- MMNODRV - Installable driver support
require("win32.mmiscapi")
require("win32.mmiscapi2")


-- MMNOSOUND  Sound support */
require("win32.playsoundapi")

require("win32.mmeapi")

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

if not MMNOTIMER then
--                            Timer support
require ("win32.timeapi")

end  --/* ifndef MMNOTIMER */

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

require("win32.joystickapi")


if not NEWTRANSPARENT then
ffi.cdef[[
static const int NEWTRANSPARENT  = 3;           /* use with SetBkMode() */
static const int QUERYROPSUPPORT = 40;          /* use to determine ROP support */
]]
end  --/* ifndef NEWTRANSPARENT */


--                        DIB Driver extensions
ffi.cdef[[
static const int SELECTDIB      = 41;                      /* DIB.DRV select dib escape */
]]
function DIBINDEX(n)     return MAKELONG(n,0x10FF) end


if not SC_SCREENSAVE then
ffi.cdef[[
static const int SC_SCREENSAVE  = 0xF140;
]]
end  --/* ifndef SC_SCREENSAVE */


end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



--[[
#ifdef _WIN32
#include <poppack.h>
#else
#ifndef RC_INVOKED
#pragma pack()
#endif
#endif
--]]
end  -- _INC_MMSYSTEM


return ffi.load("winmm")

