
--[[
/*==========================================================================
 *
 *  mmsyscom.h -- Commonm Include file for Multimedia API's
 *
 *  Version 4.00
 *
 *  Copyright (C) 1992-1998 Microsoft Corporation.  All Rights Reserved.
 *
 *==========================================================================
 */
--]]

local ffi = require("ffi")
local bit = require("bit")
local band, bor = bit.band, bit.bor
local lshift, rshift = bit.lshift, bit.rshift

 require ("win32.winapifamily")

--#ifndef _INC_MMSYSCOM
--#define _INC_MMSYSCOM   /* #defined if mmsystem.h has been included */

--[[
#ifdef _WIN32
#include <pshpack1.h>
#else
#ifndef RC_INVOKED
#pragma pack(1)
#endif
#endif
--]]



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


ffi.cdef[[
/* general constants */
static const int MAXPNAMELEN     = 32;     /* max product name length (including NULL) */
static const int MAXERRORLENGTH  = 256;    /* max error text length (including NULL) */
static const int MAX_JOYSTICKOEMVXDNAME = 260; /* max oem vxd name length (including NULL) */
]]

--[=[
/*
 *  Microsoft Manufacturer and Product ID's (these have been moved to
 *  MMREG.H for Windows 4.00 and above).
 */
#if (WINVER <= 0x0400)
#ifndef MM_MICROSOFT
#define MM_MICROSOFT            1   /* Microsoft Corporation */
#endif

#ifndef MM_MIDI_MAPPER
#define MM_MIDI_MAPPER          1   /* MIDI Mapper */
#define MM_WAVE_MAPPER          2   /* Wave Mapper */
#define MM_SNDBLST_MIDIOUT      3   /* Sound Blaster MIDI output port */
#define MM_SNDBLST_MIDIIN       4   /* Sound Blaster MIDI input port */
#define MM_SNDBLST_SYNTH        5   /* Sound Blaster internal synthesizer */
#define MM_SNDBLST_WAVEOUT      6   /* Sound Blaster waveform output */
#define MM_SNDBLST_WAVEIN       7   /* Sound Blaster waveform input */
#define MM_ADLIB                9   /* Ad Lib-compatible synthesizer */
#define MM_MPU401_MIDIOUT      10   /* MPU401-compatible MIDI output port */
#define MM_MPU401_MIDIIN       11   /* MPU401-compatible MIDI input port */
#define MM_PC_JOYSTICK         12   /* Joystick adapter */
#endif
#endif
--]=]


if _WIN32 then
ffi.cdef[[
typedef UINT        MMVERSION;  /* major (high byte), minor (low byte) */
]]
else
ffi.cdef[[
typedef UINT        VERSION;    /* major (high byte), minor (low byte) */
]]
end

ffi.cdef[[
typedef  UINT     MMRESULT;   /* error return code, 0 means no error */
                            /* call as if(err=xxxx(...)) Error(err); else */
typedef  UINT    *LPUINT;
]]
_MMRESULT_ = true


ffi.cdef[[
/* MMTIME data structure */
typedef struct mmtime_tag
{
    UINT            wType;      /* indicates the contents of the union */
    union
    {
        DWORD       ms;         /* milliseconds */
        DWORD       sample;     /* samples */
        DWORD       cb;         /* byte count */
        DWORD       ticks;      /* ticks in MIDI stream */

        /* SMPTE */
        struct
        {
            BYTE    hour;       /* hours */
            BYTE    min;        /* minutes */
            BYTE    sec;        /* seconds */
            BYTE    frame;      /* frames  */
            BYTE    fps;        /* frames per second */
            BYTE    dummy;      /* pad */
//#ifdef _WIN32
            BYTE    pad[2];
//#endif
        } smpte;

        /* MIDI */
        struct
        {
            DWORD songptrpos;   /* song pointer position */
        } midi;
    } u;
} MMTIME, *PMMTIME, *NPMMTIME, *LPMMTIME;
]]

ffi.cdef[[
/* types for wType field in MMTIME struct */
static const int TIME_MS       =  0x0001;  /* time in milliseconds */
static const int TIME_SAMPLES  =  0x0002;  /* number of wave samples */
static const int TIME_BYTES    =  0x0004;  /* current byte offset */
static const int TIME_SMPTE    =  0x0008;  /* SMPTE time */
static const int TIME_MIDI     =  0x0010;  /* MIDI time */
static const int TIME_TICKS    =  0x0020;  /* Ticks within MIDI stream */
]]

local DWORD = ffi.typeof("uint32_t")

--[[
function MAKEFOURCC(ch0, ch1, ch2, ch3)                              
    return            bor(DWORD(ffi.cast("BYTE",ch0)) , lshift(DWORD(ffi.cast("BYTE",ch1) , 8)) ,   
                lshift(DWORD(ffi.cast("BYTE",ch2) , 16)) , lshiftDWORD(ffi.cast("BYTE",ch3) , 24 )))
end
--]]

function MAKEFOURCC(ch0, ch1, ch2, ch3)                              
    return            DWORD(bor(ffi.cast("BYTE",ch0) , lshift(ffi.cast("BYTE",ch1) , 8) ,   
                lshift(ffi.cast("BYTE",ch2) , 16) , lshift(ffi.cast("BYTE",ch3) , 24 )))
end
-- Multimedia Extensions Window Messages
ffi.cdef[[
static const int MM_JOY1MOVE         = 0x3A0;           /* joystick */
static const int MM_JOY2MOVE         = 0x3A1;
static const int MM_JOY1ZMOVE        = 0x3A2;
static const int MM_JOY2ZMOVE        = 0x3A3;
static const int MM_JOY1BUTTONDOWN   = 0x3B5;
static const int MM_JOY2BUTTONDOWN   = 0x3B6;
static const int MM_JOY1BUTTONUP     = 0x3B7;
static const int MM_JOY2BUTTONUP     = 0x3B8;

static const int MM_MCINOTIFY        = 0x3B9;           /* MCI */

static const int MM_WOM_OPEN         = 0x3BB;           /* waveform output */
static const int MM_WOM_CLOSE        = 0x3BC;
static const int MM_WOM_DONE         = 0x3BD;

static const int MM_WIM_OPEN         = 0x3BE;           /* waveform input */
static const int MM_WIM_CLOSE        = 0x3BF;
static const int MM_WIM_DATA         = 0x3C0;

static const int MM_MIM_OPEN         = 0x3C1;           /* MIDI input */
static const int MM_MIM_CLOSE        = 0x3C2;
static const int MM_MIM_DATA         = 0x3C3;
static const int MM_MIM_LONGDATA     = 0x3C4;
static const int MM_MIM_ERROR        = 0x3C5;
static const int MM_MIM_LONGERROR    = 0x3C6;

static const int MM_MOM_OPEN         = 0x3C7;           /* MIDI output */
static const int MM_MOM_CLOSE        = 0x3C8;
static const int MM_MOM_DONE         = 0x3C9;
]]

--[=[
/* these are also in msvideo.h */
#ifndef MM_DRVM_OPEN
 #define MM_DRVM_OPEN       0x3D0           /* installable drivers */
 #define MM_DRVM_CLOSE      0x3D1
 #define MM_DRVM_DATA       0x3D2
 #define MM_DRVM_ERROR      0x3D3
#endif

/* these are used by msacm.h */
#define MM_STREAM_OPEN      0x3D4
#define MM_STREAM_CLOSE     0x3D5
#define MM_STREAM_DONE      0x3D6
#define MM_STREAM_ERROR     0x3D7

#if(WINVER >= 0x0400)
#define MM_MOM_POSITIONCB   0x3CA           /* Callback for MEVT_POSITIONCB */

#ifndef MM_MCISIGNAL
 #define MM_MCISIGNAL        0x3CB
#endif

#define MM_MIM_MOREDATA      0x3CC          /* MIM_DONE w/ pending events */

#endif /* WINVER >= 0x0400 */

#define MM_MIXM_LINE_CHANGE     0x3D0       /* mixer line change notify */
#define MM_MIXM_CONTROL_CHANGE  0x3D1       /* mixer control change notify */
--]=]

ffi.cdef[[
static const int MMSYSERR_BASE        =  0;
static const int WAVERR_BASE          =  32;
static const int MIDIERR_BASE         =  64;
static const int TIMERR_BASE          =  96;
static const int JOYERR_BASE          =  160;
static const int MCIERR_BASE          =  256;
static const int MIXERR_BASE          =  1024;
]]

--[=[
static const int MCI_STRING_OFFSET    =  512;
static const int MCI_VD_OFFSET        =  1024;
static const int MCI_CD_OFFSET        =  1088;
static const int MCI_WAVE_OFFSET      =  1152;
static const int MCI_SEQ_OFFSET       =  1216;

/****************************************************************************

                        General error return values

****************************************************************************/

/* general error return values */
#define MMSYSERR_NOERROR      0                    /* no error */
#define MMSYSERR_ERROR        (MMSYSERR_BASE + 1)  /* unspecified error */
#define MMSYSERR_BADDEVICEID  (MMSYSERR_BASE + 2)  /* device ID out of range */
#define MMSYSERR_NOTENABLED   (MMSYSERR_BASE + 3)  /* driver failed enable */
#define MMSYSERR_ALLOCATED    (MMSYSERR_BASE + 4)  /* device already allocated */
#define MMSYSERR_INVALHANDLE  (MMSYSERR_BASE + 5)  /* device handle is invalid */
#define MMSYSERR_NODRIVER     (MMSYSERR_BASE + 6)  /* no device driver present */
#define MMSYSERR_NOMEM        (MMSYSERR_BASE + 7)  /* memory allocation error */
#define MMSYSERR_NOTSUPPORTED (MMSYSERR_BASE + 8)  /* function isn't supported */
#define MMSYSERR_BADERRNUM    (MMSYSERR_BASE + 9)  /* error value out of range */
#define MMSYSERR_INVALFLAG    (MMSYSERR_BASE + 10) /* invalid flag passed */
#define MMSYSERR_INVALPARAM   (MMSYSERR_BASE + 11) /* invalid parameter passed */
#define MMSYSERR_HANDLEBUSY   (MMSYSERR_BASE + 12) /* handle being used */
                                                   /* simultaneously on another */
                                                   /* thread (eg callback) */
#define MMSYSERR_INVALIDALIAS (MMSYSERR_BASE + 13) /* specified alias not found */
#define MMSYSERR_BADDB        (MMSYSERR_BASE + 14) /* bad registry database */
#define MMSYSERR_KEYNOTFOUND  (MMSYSERR_BASE + 15) /* registry key not found */
#define MMSYSERR_READERROR    (MMSYSERR_BASE + 16) /* registry read error */
#define MMSYSERR_WRITEERROR   (MMSYSERR_BASE + 17) /* registry write error */
#define MMSYSERR_DELETEERROR  (MMSYSERR_BASE + 18) /* registry delete error */
#define MMSYSERR_VALNOTFOUND  (MMSYSERR_BASE + 19) /* registry value not found */
#define MMSYSERR_NODRIVERCB   (MMSYSERR_BASE + 20) /* driver does not call DriverCallback */
#define MMSYSERR_MOREDATA     (MMSYSERR_BASE + 21) /* more data to be returned */
#define MMSYSERR_LASTERROR    (MMSYSERR_BASE + 21) /* last error in range */

#if (WINVER < 0x030a) || defined(_WIN32)
DECLARE_HANDLE(HDRVR);
#endif /* ifdef WINVER < 0x030a */


/****************************************************************************

                          Driver callback support

****************************************************************************/

/* flags used with waveOutOpen(), waveInOpen(), midiInOpen(), and */
/* midiOutOpen() to specify the type of the dwCallback parameter. */

#define CALLBACK_TYPEMASK   0x00070000l    /* callback type mask */
#define CALLBACK_NULL       0x00000000l    /* no callback */
#define CALLBACK_WINDOW     0x00010000l    /* dwCallback is a HWND */
#define CALLBACK_TASK       0x00020000l    /* dwCallback is a HTASK */
#define CALLBACK_FUNCTION   0x00030000l    /* dwCallback is a FARPROC */
#ifdef _WIN32
#define CALLBACK_THREAD     (CALLBACK_TASK)/* thread ID replaces 16 bit task */
#define CALLBACK_EVENT      0x00050000l    /* dwCallback is an EVENT Handle */
#endif
typedef void (CALLBACK DRVCALLBACK)(HDRVR hdrvr, UINT uMsg, DWORD_PTR dwUser, DWORD_PTR dw1, DWORD_PTR dw2);

typedef DRVCALLBACK FAR *LPDRVCALLBACK;
#ifdef _WIN32
typedef DRVCALLBACK     *PDRVCALLBACK;
#endif
--]=]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */	


--[[
#ifdef _WIN32
#include <poppack.h>
#else
#ifndef RC_INVOKED
#pragma pack()
#endif
#endif
--]]

--end  --/* _INC_MMSYSCOM */
