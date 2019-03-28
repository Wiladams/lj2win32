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
_INC_MMSYSTEM = true   /* #defined if mmsystem.h has been included */


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
require("win32.mciapi")
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
require ("win32.timeapi").h>

end  --/* ifndef MMNOTIMER */

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


//
// Joystickapi API Set contract
//
#include <joystickapi.h>



/****************************************************************************

                        DISPLAY Driver extensions

****************************************************************************/

#ifndef NEWTRANSPARENT
    #define NEWTRANSPARENT  3           /* use with SetBkMode() */

    #define QUERYROPSUPPORT 40          /* use to determine ROP support */
#endif  /* ifndef NEWTRANSPARENT */

/****************************************************************************

                        DIB Driver extensions

****************************************************************************/

#define SELECTDIB       41                      /* DIB.DRV select dib escape */
#define DIBINDEX(n)     MAKELONG((n),0x10FF)


/****************************************************************************

                        ScreenSaver support

    The current application will receive a syscommand of SC_SCREENSAVE just
    before the screen saver is invoked.  If the app wishes to prevent a
    screen save, return non-zero value, otherwise call DefWindowProc().

****************************************************************************/

#ifndef SC_SCREENSAVE

    #define SC_SCREENSAVE   0xF140

#endif  /* ifndef SC_SCREENSAVE */


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion



#ifdef _WIN32
#include <poppack.h>
#else
#ifndef RC_INVOKED
#pragma pack()
#endif
#endif

#endif  /* _INC_MMSYSTEM */




