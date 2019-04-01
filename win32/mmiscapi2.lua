--[[
/********************************************************************************
*                                                                               *
* mmiscapi2.h -- ApiSet Contract for api-ms-win-mm-misc-l2-1-0                  *  
*                                                                               *
* Copyright (c) Microsoft Corporation. All rights reserved.                     *
*                                                                               *
********************************************************************************/
--]]

local ffi = require("ffi")

if not _MMISCAPI2_H_ then
_MMISCAPI2_H_ = true

--#include <apiset.h>
--#include <apisetcconv.h>


require("win32.mmsyscom") --// mm common definitions




if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then
ffi.cdef[[
typedef void (__stdcall TIMECALLBACK)(UINT uTimerID, UINT uMsg, DWORD_PTR dwUser, DWORD_PTR dw1, DWORD_PTR dw2);
typedef TIMECALLBACK *LPTIMECALLBACK;
]]

ffi.cdef[[
/* flags for fuEvent parameter of timeSetEvent() function */
static const int TIME_ONESHOT  =  0x0000;   /* program timer for single event */
static const int TIME_PERIODIC =  0x0001;   /* program for continuous periodic event */
]]

if _WIN32 then
ffi.cdef[[
static const int TIME_CALLBACK_FUNCTION     = 0x0000;  /* callback is function */
static const int TIME_CALLBACK_EVENT_SET    = 0x0010;  /* callback is event - use SetEvent */
static const int TIME_CALLBACK_EVENT_PULSE  = 0x0020;  /* callback is event - use PulseEvent */
]]
end

if WINVER >= 0x0501 then
ffi.cdef[[
static const int TIME_KILL_SYNCHRONOUS  = 0x0100;  /* This flag prevents the event from occurring */
                                        /* after the user calls timeKillEvent() to */
                                        /* destroy it. */
]]
end --// WINVER >= 0x0501

ffi.cdef[[

MMRESULT
__stdcall
timeSetEvent(
     UINT uDelay,
     UINT uResolution,
     LPTIMECALLBACK fptc,
     DWORD_PTR dwUser,
     UINT fuEvent
    );


MMRESULT
__stdcall
timeKillEvent(
     UINT uTimerID
    );
]]

end --// WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)




end --// _MMISCAPI2_H_


