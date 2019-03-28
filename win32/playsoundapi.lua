local ffi = require("ffi")
--[[
/********************************************************************************
*                                                                               *
* playsoundapi.h -- ApiSet Contract for api-ms-win-mm-playsound-l1-1-0          *  
*                                                                               *
* Copyright (c) Microsoft Corporation. All rights reserved.                     *
*                                                                               *
********************************************************************************/
--]]


--#ifndef _PLAYSOUNDAPI_H_
--#define _PLAYSOUNDAPI_H_

--#include <apiset.h>
--#include <apisetcconv.h>


require ("win32.mmsyscom") --// mm common definitions




if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

if not MMNOSOUND then 
-- Sound support

--if _WIN32 then

ffi.cdef[[
BOOL
__stdcall
sndPlaySoundA(
     LPCSTR pszSound,
     UINT fuSound
    );


BOOL
__stdcall
sndPlaySoundW(
     LPCWSTR pszSound,
     UINT fuSound
    );
]]

--[[
#ifdef UNICODE
#define sndPlaySound  sndPlaySoundW
#else
#define sndPlaySound  sndPlaySoundA
#endif // !UNICODE
--]]

--[[
#else
DLOAD_RET(FALSE)
BOOL __stdcall sndPlaySound(LPCSTR pszSound, UINT fuSound);
#endif
--]]

ffi.cdef[[
/*
 *  flag values for fuSound and fdwSound arguments on [snd]PlaySound
 */
static const int SND_SYNC          =  0x0000;  /* play synchronously (default) */
static const int SND_ASYNC         =  0x0001;  /* play asynchronously */
static const int SND_NODEFAULT     =  0x0002;  /* silence (!default) if sound not found */
static const int SND_MEMORY        =  0x0004;  /* pszSound points to a memory file */
static const int SND_LOOP          =  0x0008;  /* loop the sound until next sndPlaySound */
static const int SND_NOSTOP        =  0x0010;  /* don't stop any currently playing sound */

static const int SND_NOWAIT     = 0x00002000L; /* don't wait if the driver is busy */
static const int SND_ALIAS      = 0x00010000L; /* name is a registry alias */
static const int SND_ALIAS_ID   = 0x00110000L; /* alias is a predefined ID */
static const int SND_FILENAME   = 0x00020000L; /* name is file name */
static const int SND_RESOURCE   = 0x00040004L; /* name is resource name or atom */
]]

--[[
#if (WINVER >= 0x0400)
#define SND_PURGE           0x0040  /* purge non-static events for task */
#define SND_APPLICATION     0x0080  /* look for application specific association */
#endif /* WINVER >= 0x0400 */
#define SND_SENTRY      0x00080000L /* Generate a SoundSentry event with this sound */
#define SND_RING        0x00100000L /* Treat this as a "ring" from a communications app - don't duck me */
#define SND_SYSTEM      0x00200000L /* Treat this as a system sound */

#define SND_ALIAS_START 0           /* alias base */
--]]

if _WIN32 then
--[[
#define sndAlias(ch0, ch1)      (SND_ALIAS_START + (DWORD)(BYTE)(ch0) | ((DWORD)(BYTE)(ch1) << 8))

#define SND_ALIAS_SYSTEMASTERISK        sndAlias('S', '*')
#define SND_ALIAS_SYSTEMQUESTION        sndAlias('S', '?')
#define SND_ALIAS_SYSTEMHAND            sndAlias('S', 'H')
#define SND_ALIAS_SYSTEMEXIT            sndAlias('S', 'E')
#define SND_ALIAS_SYSTEMSTART           sndAlias('S', 'S')
#define SND_ALIAS_SYSTEMWELCOME         sndAlias('S', 'W')
#define SND_ALIAS_SYSTEMEXCLAMATION     sndAlias('S', '!')
#define SND_ALIAS_SYSTEMDEFAULT         sndAlias('S', 'D')
--]]

ffi.cdef[[

BOOL
__stdcall
PlaySoundA(
     LPCSTR pszSound,
     HMODULE hmod,
     DWORD fdwSound
    );


BOOL
__stdcall
PlaySoundW(
     LPCWSTR pszSound,
     HMODULE hmod,
     DWORD fdwSound
    );
]]

--[[
#ifdef UNICODE
#define PlaySound  PlaySoundW
#else
#define PlaySound  PlaySoundA
#endif // !UNICODE
--]]
--[[
#else
DLOAD_RET(FALSE)
BOOL __stdcall PlaySound(LPCSTR pszSound, HMODULE hmod, DWORD fdwSound);
--]]
end

end  -- ifndef MMNOSOUND */ 

end --// WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)




--#endif // _PLAYSOUNDAPI_H_

return ffi.load("api-ms-win-mm-playsound-l1-1-0")
