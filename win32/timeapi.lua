local ffi = require("ffi")

--[[
/********************************************************************************
*                                                                               *
* timerapi.h -- ApiSet Contract for api-ms-win-mm-time-l1-1-0                   *  
*                                                                               *
* Copyright (c) Microsoft Corporation. All rights reserved.                     *
*                                                                               *
********************************************************************************/
--]]



--#ifndef _TIMERAPI_H_
--#define _TIMERAPI_H_

--#include <apiset.h>
--#include <apisetcconv.h>


require("win32.mmsyscom")


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

if not MMNOTIMER then  
--  Timer support

ffi.cdef[[
/* timer error return values */
static const int  TIMERR_NOERROR     =   0;                    // no error 
static const int  TIMERR_NOCANDO     =   (TIMERR_BASE+1);      // request not completed 
static const int  TIMERR_STRUCT      =   (TIMERR_BASE+33);     // time struct size
]]

ffi.cdef[[
/* timer device capabilities data structure */
typedef struct timecaps_tag {
    UINT    wPeriodMin;     /* minimum period supported  */
    UINT    wPeriodMax;     /* maximum period supported  */
} TIMECAPS, *PTIMECAPS, *NPTIMECAPS, *LPTIMECAPS;
]]

ffi.cdef[[
/* timer function prototypes */

MMRESULT
__stdcall
timeGetSystemTime(
     LPMMTIME pmmt,
     UINT cbmmt
    );


DWORD
__stdcall
timeGetTime(
    void
    );


MMRESULT
__stdcall
timeGetDevCaps(
     LPTIMECAPS ptc,
     UINT cbtc
    );


MMRESULT
__stdcall
timeBeginPeriod(
     UINT uPeriod
    );


MMRESULT
__stdcall
timeEndPeriod(
     UINT uPeriod
    );
]]

end  -- ifndef MMNOTIMER

end -- WINAPI_FAMILY_PARTITION(WINAPIl_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


--end -- _TIMERAPI_H_

return ffi.load("api-ms-win-mm-time-l1-1-0")
