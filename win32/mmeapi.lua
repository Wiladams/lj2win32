local ffi = require("ffi")

--[[
/********************************************************************************
*                                                                               *
* mmeapi.h -- ApiSet Contract for api-ms-win-mm-mme-l1-1-0                      *  
*                                                                               *
* Copyright (c) Microsoft Corporation. All rights reserved.                     *
*                                                                               *
********************************************************************************/
--]]


--#ifndef _MMEAPI_H_
--#define _MMEAPI_H_

--#include <apiset.h>
--#include <apisetcconv.h>


require ("win32.mmsyscom") --// mm common definitions


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

if not MMNOWAVE then
--/****************************************************************************
--                        Waveform audio support
--****************************************************************************/

ffi.cdef[[
/* waveform audio error return values */
static const int WAVERR_BADFORMAT     = (WAVERR_BASE + 0);    /* unsupported wave format */
static const int WAVERR_STILLPLAYING  = (WAVERR_BASE + 1);    /* still something playing */
static const int WAVERR_UNPREPARED    = (WAVERR_BASE + 2);    /* header not prepared */
static const int WAVERR_SYNC          = (WAVERR_BASE + 3);    /* device is synchronous */
static const int WAVERR_LASTERROR     = (WAVERR_BASE + 3);    /* last error in range */
]]

-- waveform audio data types
DECLARE_HANDLE("HWAVE");
DECLARE_HANDLE("HWAVEIN");
DECLARE_HANDLE("HWAVEOUT");

ffi.cdef[[
typedef HWAVEIN  *LPHWAVEIN;
typedef HWAVEOUT  *LPHWAVEOUT;
typedef DRVCALLBACK WAVECALLBACK;
typedef WAVECALLBACK  *LPWAVECALLBACK;
]]

ffi.cdef[[
/* wave callback messages */
static const int WOM_OPEN      =  MM_WOM_OPEN;
static const int WOM_CLOSE     =  MM_WOM_CLOSE;
static const int WOM_DONE      =  MM_WOM_DONE;
static const int WIM_OPEN      =  MM_WIM_OPEN;
static const int WIM_CLOSE     =  MM_WIM_CLOSE;
static const int WIM_DATA      =  MM_WIM_DATA;
]]

ffi.cdef[[
/* device ID for wave device mapper */
static const int WAVE_MAPPER    =  -1;  // ((UINT)-1)
]]

ffi.cdef[[
/* flags for dwFlags parameter in waveOutOpen() and waveInOpen() */
static const int  WAVE_FORMAT_QUERY                      =    0x0001;
static const int  WAVE_ALLOWSYNC                         =    0x0002;
]]

if (WINVER >= 0x0400) then
ffi.cdef[[
static const int  WAVE_MAPPED                              =  0x0004;
static const int  WAVE_FORMAT_DIRECT                       =  0x0008;
static const int  WAVE_FORMAT_DIRECT_QUERY                 =  (WAVE_FORMAT_QUERY | WAVE_FORMAT_DIRECT);
static const int  WAVE_MAPPED_DEFAULT_COMMUNICATION_DEVICE =  0x0010;
]]
end --/* (WINVER >= 0x0400) */

ffi.cdef[[
/* wave data block header */
typedef struct wavehdr_tag {
    LPSTR       lpData;                 /* pointer to locked data buffer */
    DWORD       dwBufferLength;         /* length of data buffer */
    DWORD       dwBytesRecorded;        /* used for input only */
    DWORD_PTR   dwUser;                 /* for clients use */
    DWORD       dwFlags;                /* assorted flags (see defines) */
    DWORD       dwLoops;                /* loop control counter */
    struct wavehdr_tag  *lpNext;     /* reserved for driver */
    DWORD_PTR   reserved;               /* reserved for driver */
} WAVEHDR, *PWAVEHDR,  *NPWAVEHDR,  *LPWAVEHDR;
]]

ffi.cdef[[
/* flags for dwFlags field of WAVEHDR */
static const int WHDR_DONE      = 0x00000001;  /* done bit */
static const int WHDR_PREPARED  = 0x00000002;  /* set if this header has been prepared */
static const int WHDR_BEGINLOOP = 0x00000004;  /* loop start block */
static const int WHDR_ENDLOOP   = 0x00000008;  /* loop end block */
static const int WHDR_INQUEUE   = 0x00000010;  /* reserved for driver */
]]

--/* waveform output device capabilities structure */
if _WIN32 then
ffi.cdef[[
typedef struct tagWAVEOUTCAPSA {
    WORD    wMid;                  /* manufacturer ID */
    WORD    wPid;                  /* product ID */
    MMVERSION vDriverVersion;      /* version of the driver */
    CHAR    szPname[MAXPNAMELEN];  /* product name (NULL terminated string) */
    DWORD   dwFormats;             /* formats supported */
    WORD    wChannels;             /* number of sources supported */
    WORD    wReserved1;            /* packing */
    DWORD   dwSupport;             /* functionality supported by driver */
} WAVEOUTCAPSA, *PWAVEOUTCAPSA, *NPWAVEOUTCAPSA, *LPWAVEOUTCAPSA;

typedef struct tagWAVEOUTCAPSW {
    WORD    wMid;                  /* manufacturer ID */
    WORD    wPid;                  /* product ID */
    MMVERSION vDriverVersion;      /* version of the driver */
    WCHAR   szPname[MAXPNAMELEN];  /* product name (NULL terminated string) */
    DWORD   dwFormats;             /* formats supported */
    WORD    wChannels;             /* number of sources supported */
    WORD    wReserved1;            /* packing */
    DWORD   dwSupport;             /* functionality supported by driver */
} WAVEOUTCAPSW, *PWAVEOUTCAPSW, *NPWAVEOUTCAPSW, *LPWAVEOUTCAPSW;
]]


if UNICODE then
ffi.cdef[[
typedef WAVEOUTCAPSW WAVEOUTCAPS;
typedef PWAVEOUTCAPSW PWAVEOUTCAPS;
typedef NPWAVEOUTCAPSW NPWAVEOUTCAPS;
typedef LPWAVEOUTCAPSW LPWAVEOUTCAPS;
]]
else
ffi.cdef[[
typedef WAVEOUTCAPSA WAVEOUTCAPS;
typedef PWAVEOUTCAPSA PWAVEOUTCAPS;
typedef NPWAVEOUTCAPSA NPWAVEOUTCAPS;
typedef LPWAVEOUTCAPSA LPWAVEOUTCAPS;
]]
end --// UNICODE

ffi.cdef[[
typedef struct tagWAVEOUTCAPS2A {
    WORD    wMid;                  /* manufacturer ID */
    WORD    wPid;                  /* product ID */
    MMVERSION vDriverVersion;      /* version of the driver */
    CHAR    szPname[MAXPNAMELEN];  /* product name (NULL terminated string) */
    DWORD   dwFormats;             /* formats supported */
    WORD    wChannels;             /* number of sources supported */
    WORD    wReserved1;            /* packing */
    DWORD   dwSupport;             /* functionality supported by driver */
    GUID    ManufacturerGuid;      /* for extensible MID mapping */
    GUID    ProductGuid;           /* for extensible PID mapping */
    GUID    NameGuid;              /* for name lookup in registry */
} WAVEOUTCAPS2A, *PWAVEOUTCAPS2A, *NPWAVEOUTCAPS2A, *LPWAVEOUTCAPS2A;
]]

ffi.cdef[[
typedef struct tagWAVEOUTCAPS2W {
    WORD    wMid;                  /* manufacturer ID */
    WORD    wPid;                  /* product ID */
    MMVERSION vDriverVersion;      /* version of the driver */
    WCHAR   szPname[MAXPNAMELEN];  /* product name (NULL terminated string) */
    DWORD   dwFormats;             /* formats supported */
    WORD    wChannels;             /* number of sources supported */
    WORD    wReserved1;            /* packing */
    DWORD   dwSupport;             /* functionality supported by driver */
    GUID    ManufacturerGuid;      /* for extensible MID mapping */
    GUID    ProductGuid;           /* for extensible PID mapping */
    GUID    NameGuid;              /* for name lookup in registry */
} WAVEOUTCAPS2W, *PWAVEOUTCAPS2W, *NPWAVEOUTCAPS2W, *LPWAVEOUTCAPS2W;
]]

if UNICODE then
ffi.cdef[[
typedef WAVEOUTCAPS2W WAVEOUTCAPS2;
typedef PWAVEOUTCAPS2W PWAVEOUTCAPS2;
typedef NPWAVEOUTCAPS2W NPWAVEOUTCAPS2;
typedef LPWAVEOUTCAPS2W LPWAVEOUTCAPS2;
]]
else
ffi.cdef[[
typedef WAVEOUTCAPS2A WAVEOUTCAPS2;
typedef PWAVEOUTCAPS2A PWAVEOUTCAPS2;
typedef NPWAVEOUTCAPS2A NPWAVEOUTCAPS2;
typedef LPWAVEOUTCAPS2A LPWAVEOUTCAPS2;
]]
end --// UNICODE

else   -- _WIN32
ffi.cdef[[
typedef struct waveoutcaps_tag {
    WORD    wMid;                  /* manufacturer ID */
    WORD    wPid;                  /* product ID */
    VERSION vDriverVersion;        /* version of the driver */
    char    szPname[MAXPNAMELEN];  /* product name (NULL terminated string) */
    DWORD   dwFormats;             /* formats supported */
    WORD    wChannels;             /* number of sources supported */
    DWORD   dwSupport;             /* functionality supported by driver */
} WAVEOUTCAPS, *PWAVEOUTCAPS,  *NPWAVEOUTCAPS,  *LPWAVEOUTCAPS;
]]
end

ffi.cdef[[
/* flags for dwSupport field of WAVEOUTCAPS */
static const int WAVECAPS_PITCH         = 0x0001;   /* supports pitch control */
static const int WAVECAPS_PLAYBACKRATE  = 0x0002;   /* supports playback rate control */
static const int WAVECAPS_VOLUME        = 0x0004;   /* supports volume control */
static const int WAVECAPS_LRVOLUME      = 0x0008;   /* separate left-right volume control */
static const int WAVECAPS_SYNC          = 0x0010;
static const int WAVECAPS_SAMPLEACCURATE= 0x0020;
]]

-- waveform input device capabilities structure */
if _WIN32 then
ffi.cdef[[
typedef struct tagWAVEINCAPSA {
    WORD    wMid;                    /* manufacturer ID */
    WORD    wPid;                    /* product ID */
    MMVERSION vDriverVersion;        /* version of the driver */
    CHAR    szPname[MAXPNAMELEN];    /* product name (NULL terminated string) */
    DWORD   dwFormats;               /* formats supported */
    WORD    wChannels;               /* number of channels supported */
    WORD    wReserved1;              /* structure packing */
} WAVEINCAPSA, *PWAVEINCAPSA, *NPWAVEINCAPSA, *LPWAVEINCAPSA;
]]

ffi.cdef[[
typedef struct tagWAVEINCAPSW {
    WORD    wMid;                    /* manufacturer ID */
    WORD    wPid;                    /* product ID */
    MMVERSION vDriverVersion;        /* version of the driver */
    WCHAR   szPname[MAXPNAMELEN];    /* product name (NULL terminated string) */
    DWORD   dwFormats;               /* formats supported */
    WORD    wChannels;               /* number of channels supported */
    WORD    wReserved1;              /* structure packing */
} WAVEINCAPSW, *PWAVEINCAPSW, *NPWAVEINCAPSW, *LPWAVEINCAPSW;
]]

if UNICODE then
ffi.cdef[[
typedef WAVEINCAPSW WAVEINCAPS;
typedef PWAVEINCAPSW PWAVEINCAPS;
typedef NPWAVEINCAPSW NPWAVEINCAPS;
typedef LPWAVEINCAPSW LPWAVEINCAPS;
]]
else
ffi.cdef[[
typedef WAVEINCAPSA WAVEINCAPS;
typedef PWAVEINCAPSA PWAVEINCAPS;
typedef NPWAVEINCAPSA NPWAVEINCAPS;
typedef LPWAVEINCAPSA LPWAVEINCAPS;
]]
end --// UNICODE

ffi.cdef[[
typedef struct tagWAVEINCAPS2A {
    WORD    wMid;                    /* manufacturer ID */
    WORD    wPid;                    /* product ID */
    MMVERSION vDriverVersion;        /* version of the driver */
    CHAR    szPname[MAXPNAMELEN];    /* product name (NULL terminated string) */
    DWORD   dwFormats;               /* formats supported */
    WORD    wChannels;               /* number of channels supported */
    WORD    wReserved1;              /* structure packing */
    GUID    ManufacturerGuid;        /* for extensible MID mapping */
    GUID    ProductGuid;             /* for extensible PID mapping */
    GUID    NameGuid;                /* for name lookup in registry */
} WAVEINCAPS2A, *PWAVEINCAPS2A, *NPWAVEINCAPS2A, *LPWAVEINCAPS2A;
]]

ffi.cdef[[
typedef struct tagWAVEINCAPS2W {
    WORD    wMid;                    /* manufacturer ID */
    WORD    wPid;                    /* product ID */
    MMVERSION vDriverVersion;        /* version of the driver */
    WCHAR   szPname[MAXPNAMELEN];    /* product name (NULL terminated string) */
    DWORD   dwFormats;               /* formats supported */
    WORD    wChannels;               /* number of channels supported */
    WORD    wReserved1;              /* structure packing */
    GUID    ManufacturerGuid;        /* for extensible MID mapping */
    GUID    ProductGuid;             /* for extensible PID mapping */
    GUID    NameGuid;                /* for name lookup in registry */
} WAVEINCAPS2W, *PWAVEINCAPS2W, *NPWAVEINCAPS2W, *LPWAVEINCAPS2W;
]]

if UNICODE then
ffi.cdef[[
typedef WAVEINCAPS2W WAVEINCAPS2;
typedef PWAVEINCAPS2W PWAVEINCAPS2;
typedef NPWAVEINCAPS2W NPWAVEINCAPS2;
typedef LPWAVEINCAPS2W LPWAVEINCAPS2;
]]
else
ffi.cdef[[
typedef WAVEINCAPS2A WAVEINCAPS2;
typedef PWAVEINCAPS2A PWAVEINCAPS2;
typedef NPWAVEINCAPS2A NPWAVEINCAPS2;
typedef LPWAVEINCAPS2A LPWAVEINCAPS2;
]]
end -- UNICODE

else -- _WIN32
ffi.cdef[[
typedef struct waveincaps_tag {
    WORD    wMid;                    /* manufacturer ID */
    WORD    wPid;                    /* product ID */
    VERSION vDriverVersion;          /* version of the driver */
    char    szPname[MAXPNAMELEN];    /* product name (NULL terminated string) */
    DWORD   dwFormats;               /* formats supported */
    WORD    wChannels;               /* number of channels supported */
} WAVEINCAPS, *PWAVEINCAPS,  *NPWAVEINCAPS,  *LPWAVEINCAPS;
]]
end

ffi.cdef[[
/* defines for dwFormat field of WAVEINCAPS and WAVEOUTCAPS */
static const int WAVE_INVALIDFORMAT     = 0x00000000;       /* invalid format */
static const int WAVE_FORMAT_1M08       = 0x00000001;       /* 11.025 kHz, Mono,   8-bit  */
static const int WAVE_FORMAT_1S08       = 0x00000002;       /* 11.025 kHz, Stereo, 8-bit  */
static const int WAVE_FORMAT_1M16       = 0x00000004;       /* 11.025 kHz, Mono,   16-bit */
static const int WAVE_FORMAT_1S16       = 0x00000008;       /* 11.025 kHz, Stereo, 16-bit */
static const int WAVE_FORMAT_2M08       = 0x00000010;       /* 22.05  kHz, Mono,   8-bit  */
static const int WAVE_FORMAT_2S08       = 0x00000020;       /* 22.05  kHz, Stereo, 8-bit  */
static const int WAVE_FORMAT_2M16       = 0x00000040;       /* 22.05  kHz, Mono,   16-bit */
static const int WAVE_FORMAT_2S16       = 0x00000080;       /* 22.05  kHz, Stereo, 16-bit */
static const int WAVE_FORMAT_4M08       = 0x00000100;       /* 44.1   kHz, Mono,   8-bit  */
static const int WAVE_FORMAT_4S08       = 0x00000200;       /* 44.1   kHz, Stereo, 8-bit  */
static const int WAVE_FORMAT_4M16       = 0x00000400;       /* 44.1   kHz, Mono,   16-bit */
static const int WAVE_FORMAT_4S16       = 0x00000800;       /* 44.1   kHz, Stereo, 16-bit */

static const int WAVE_FORMAT_44M08      = 0x00000100;       /* 44.1   kHz, Mono,   8-bit  */
static const int WAVE_FORMAT_44S08      = 0x00000200;       /* 44.1   kHz, Stereo, 8-bit  */
static const int WAVE_FORMAT_44M16      = 0x00000400;       /* 44.1   kHz, Mono,   16-bit */
static const int WAVE_FORMAT_44S16      = 0x00000800;       /* 44.1   kHz, Stereo, 16-bit */
static const int WAVE_FORMAT_48M08      = 0x00001000;       /* 48     kHz, Mono,   8-bit  */
static const int WAVE_FORMAT_48S08      = 0x00002000;       /* 48     kHz, Stereo, 8-bit  */
static const int WAVE_FORMAT_48M16      = 0x00004000;       /* 48     kHz, Mono,   16-bit */
static const int WAVE_FORMAT_48S16      = 0x00008000;       /* 48     kHz, Stereo, 16-bit */
static const int WAVE_FORMAT_96M08      = 0x00010000;       /* 96     kHz, Mono,   8-bit  */
static const int WAVE_FORMAT_96S08      = 0x00020000;       /* 96     kHz, Stereo, 8-bit  */
static const int WAVE_FORMAT_96M16      = 0x00040000;       /* 96     kHz, Mono,   16-bit */
static const int WAVE_FORMAT_96S16      = 0x00080000;       /* 96     kHz, Stereo, 16-bit */
]]

if not  WAVE_FORMAT_PCM then
ffi.cdef[[
/* OLD general waveform format structure (information common to all formats) */
typedef struct waveformat_tag {
    WORD    wFormatTag;        /* format type */
    WORD    nChannels;         /* number of channels (i.e. mono, stereo, etc.) */
    DWORD   nSamplesPerSec;    /* sample rate */
    DWORD   nAvgBytesPerSec;   /* for buffer estimation */
    WORD    nBlockAlign;       /* block size of data */
} WAVEFORMAT, *PWAVEFORMAT,  *NPWAVEFORMAT,  *LPWAVEFORMAT;
]]

ffi.cdef[[
/* flags for wFormatTag field of WAVEFORMAT */
static const int WAVE_FORMAT_PCM   =  1;


/* specific waveform format structure for PCM data */
typedef struct pcmwaveformat_tag {
    WAVEFORMAT  wf;
    WORD        wBitsPerSample;
} PCMWAVEFORMAT, *PPCMWAVEFORMAT,  *NPPCMWAVEFORMAT,  *LPPCMWAVEFORMAT;
]]
end --/* WAVE_FORMAT_PCM */

if not _WAVEFORMATEX_ then
_WAVEFORMATEX_ = true 

ffi.cdef[[
/*
 *  extended waveform format structure used for all non-PCM formats. this
 *  structure is common to all non-PCM formats.
 */
typedef struct tWAVEFORMATEX
{
    WORD        wFormatTag;         /* format type */
    WORD        nChannels;          /* number of channels (i.e. mono, stereo...) */
    DWORD       nSamplesPerSec;     /* sample rate */
    DWORD       nAvgBytesPerSec;    /* for buffer estimation */
    WORD        nBlockAlign;        /* block size of data */
    WORD        wBitsPerSample;     /* number of bits per sample of mono data */
    WORD        cbSize;             /* the count in bytes of the size of */
                                    /* extra information (after cbSize) */
} WAVEFORMATEX, *PWAVEFORMATEX,  *NPWAVEFORMATEX,  *LPWAVEFORMATEX;
]]
end --/* _WAVEFORMATEX_ */

ffi.cdef[[
typedef const WAVEFORMATEX  *LPCWAVEFORMATEX;
]]

ffi.cdef[[
/* waveform audio function prototypes */

UINT
__stdcall
waveOutGetNumDevs(
    void
    );
]]

if _WIN32 then

ffi.cdef[[
MMRESULT
__stdcall
waveOutGetDevCapsA(
     UINT_PTR uDeviceID,
     LPWAVEOUTCAPSA pwoc,
     UINT cbwoc
    );


MMRESULT
__stdcall
waveOutGetDevCapsW(
     UINT_PTR uDeviceID,
     LPWAVEOUTCAPSW pwoc,
     UINT cbwoc
    );
]]

--[[
if UNICODE then
#define waveOutGetDevCaps  waveOutGetDevCapsW
else
#define waveOutGetDevCaps  waveOutGetDevCapsA
end // !UNICODE
--]]
else
ffi.cdef[[
 MMRESULT __stdcall waveOutGetDevCaps( UINT uDeviceID, LPWAVEOUTCAPS pwoc, UINT cbwoc);
]]
end     --  _WIN32

if (WINVER >= 0x0400) then
ffi.cdef[[
MMRESULT
__stdcall
waveOutGetVolume(
     HWAVEOUT hwo,
     LPDWORD pdwVolume
    );


MMRESULT
__stdcall
waveOutSetVolume(
     HWAVEOUT hwo,
     DWORD dwVolume
    );
]]
else
ffi.cdef[[
 MMRESULT __stdcall waveOutGetVolume(UINT uId, LPDWORD pdwVolume);
 MMRESULT __stdcall waveOutSetVolume(UINT uId, DWORD dwVolume);
]]
end

if _WIN32 then

ffi.cdef[[
MMRESULT
__stdcall
waveOutGetErrorTextA(
     MMRESULT mmrError,
     LPSTR pszText,
     UINT cchText
    );


MMRESULT
__stdcall
waveOutGetErrorTextW(
     MMRESULT mmrError,
     LPWSTR pszText,
     UINT cchText
    );
]]

--[[
if UNICODE then
#define waveOutGetErrorText  waveOutGetErrorTextW
else
#define waveOutGetErrorText  waveOutGetErrorTextA
end   -- UNICODE
--]]

else
ffi.cdef[[
MMRESULT __stdcall waveOutGetErrorText(MMRESULT mmrError, LPSTR pszText, UINT cchText);
]]
end

ffi.cdef[[
MMRESULT
__stdcall
waveOutOpen(
     LPHWAVEOUT phwo,
     UINT uDeviceID,
     LPCWAVEFORMATEX pwfx,
     DWORD_PTR dwCallback,
     DWORD_PTR dwInstance,
     DWORD fdwOpen
    );



MMRESULT
__stdcall
waveOutClose(
     HWAVEOUT hwo
    );


MMRESULT
__stdcall
waveOutPrepareHeader(
     HWAVEOUT hwo,
     LPWAVEHDR pwh,
     UINT cbwh
    );


MMRESULT
__stdcall
waveOutUnprepareHeader(
     HWAVEOUT hwo,
     LPWAVEHDR pwh,
     UINT cbwh
    );


MMRESULT
__stdcall
waveOutWrite(
     HWAVEOUT hwo,
     LPWAVEHDR pwh,
     UINT cbwh
    );


MMRESULT
__stdcall
waveOutPause(
     HWAVEOUT hwo
    );


MMRESULT
__stdcall
waveOutRestart(
     HWAVEOUT hwo
    );


MMRESULT
__stdcall
waveOutReset(
     HWAVEOUT hwo
    );


MMRESULT
__stdcall
waveOutBreakLoop(
     HWAVEOUT hwo
    );


MMRESULT
__stdcall
waveOutGetPosition(
     HWAVEOUT hwo,
     LPMMTIME pmmt,
     UINT cbmmt
    );


MMRESULT
__stdcall
waveOutGetPitch(
     HWAVEOUT hwo,
     LPDWORD pdwPitch
    );


MMRESULT
__stdcall
waveOutSetPitch(
     HWAVEOUT hwo,
     DWORD dwPitch
    );


MMRESULT
__stdcall
waveOutGetPlaybackRate(
     HWAVEOUT hwo,
     LPDWORD pdwRate
    );


MMRESULT
__stdcall
waveOutSetPlaybackRate(
     HWAVEOUT hwo,
     DWORD dwRate
    );


MMRESULT
__stdcall
waveOutGetID(
     HWAVEOUT hwo,
     LPUINT puDeviceID
    );
]]

if (WINVER >= 0x030a) then
if _WIN32 then
ffi.cdef[[
MMRESULT
__stdcall
waveOutMessage(
     HWAVEOUT hwo,
     UINT uMsg,
     DWORD_PTR dw1,
     DWORD_PTR dw2
    );
]]
else
ffi.cdef[[
DWORD __stdcall waveOutMessage(HWAVEOUT hwo, UINT uMsg, DWORD dw1, DWORD dw2);
]]
end
end --/* ifdef WINVER >= 0x030a */

ffi.cdef[[
UINT
__stdcall
waveInGetNumDevs(
    void
    );
]]

if _WIN32 then

ffi.cdef[[
MMRESULT
__stdcall
waveInGetDevCapsA(
     UINT_PTR uDeviceID,
     LPWAVEINCAPSA pwic,
     UINT cbwic
    );


MMRESULT
__stdcall
waveInGetDevCapsW(
     UINT_PTR uDeviceID,
     LPWAVEINCAPSW pwic,
     UINT cbwic
    );
]]

if UNICODE then
--#define waveInGetDevCaps  waveInGetDevCapsW
else
--#define waveInGetDevCaps  waveInGetDevCapsA
end   -- UNICODE

else
ffi.cdef[[
MMRESULT __stdcall waveInGetDevCaps(UINT uDeviceID, LPWAVEINCAPS pwic, UINT cbwic);
]]
end

if _WIN32 then

ffi.cdef[[
MMRESULT
__stdcall
waveInGetErrorTextA(
     MMRESULT mmrError,
     LPSTR pszText,
     UINT cchText
    );


MMRESULT
__stdcall
waveInGetErrorTextW(
     MMRESULT mmrError,
     LPWSTR pszText,
     UINT cchText
    );
]]

if UNICODE then
--#define waveInGetErrorText  waveInGetErrorTextW
else
--#define waveInGetErrorText  waveInGetErrorTextA
end   -- UNICODE

else
ffi.cdef[[
MMRESULT __stdcall waveInGetErrorText(MMRESULT mmrError, LPSTR pszText, UINT cchText);
]]
end

ffi.cdef[[
MMRESULT
__stdcall
waveInOpen(
     LPHWAVEIN phwi,
     UINT uDeviceID,
     LPCWAVEFORMATEX pwfx,
     DWORD_PTR dwCallback,
     DWORD_PTR dwInstance,
     DWORD fdwOpen
    );



MMRESULT
__stdcall
waveInClose(
     HWAVEIN hwi
    );


MMRESULT
__stdcall
waveInPrepareHeader(
     HWAVEIN hwi,
     LPWAVEHDR pwh,
     UINT cbwh
    );


MMRESULT
__stdcall
waveInUnprepareHeader(
     HWAVEIN hwi,
     LPWAVEHDR pwh,
     UINT cbwh
    );


MMRESULT
__stdcall
waveInAddBuffer(
     HWAVEIN hwi,
     LPWAVEHDR pwh,
     UINT cbwh
    );


MMRESULT
__stdcall
waveInStart(
     HWAVEIN hwi
    );


MMRESULT
__stdcall
waveInStop(
     HWAVEIN hwi
    );


MMRESULT
__stdcall
waveInReset(
     HWAVEIN hwi
    );


MMRESULT
__stdcall
waveInGetPosition(
     HWAVEIN hwi,
     LPMMTIME pmmt,
     UINT cbmmt
    );


MMRESULT
__stdcall
waveInGetID(
     HWAVEIN hwi,
     LPUINT puDeviceID
    );
]]

if (WINVER >= 0x030a) then
if _WIN32 then
ffi.cdef[[
MMRESULT
__stdcall
waveInMessage(
     HWAVEIN hwi,
     UINT uMsg,
     DWORD_PTR dw1,
     DWORD_PTR dw2
    );
]]
else
ffi.cdef[[
DWORD __stdcall waveInMessage(HWAVEIN hwi, UINT uMsg, DWORD dw1, DWORD dw2);
]]
end
end --/* ifdef WINVER >= 0x030a */

end  --/* ifndef MMNOWAVE */


if not MMNOMIDI then
--                            MIDI audio support

ffi.cdef[[
/* MIDI error return values */
static const int MIDIERR_UNPREPARED   = (MIDIERR_BASE + 0);   /* header not prepared */
static const int MIDIERR_STILLPLAYING = (MIDIERR_BASE + 1);   /* still something playing */
static const int MIDIERR_NOMAP        = (MIDIERR_BASE + 2);   /* no configured instruments */
static const int MIDIERR_NOTREADY     = (MIDIERR_BASE + 3);   /* hardware is still busy */
static const int MIDIERR_NODEVICE     = (MIDIERR_BASE + 4);   /* port no longer connected */
static const int MIDIERR_INVALIDSETUP = (MIDIERR_BASE + 5);   /* invalid MIF */
static const int MIDIERR_BADOPENMODE  = (MIDIERR_BASE + 6);   /* operation unsupported w/ open mode */
static const int MIDIERR_DONT_CONTINUE= (MIDIERR_BASE + 7);   /* thru device 'eating' a message */
static const int MIDIERR_LASTERROR    = (MIDIERR_BASE + 7);   /* last error in range */
]]

-- MIDI audio data types */
DECLARE_HANDLE("HMIDI");
DECLARE_HANDLE("HMIDIIN");
DECLARE_HANDLE("HMIDIOUT");
DECLARE_HANDLE("HMIDISTRM");

ffi.cdef[[
typedef HMIDI  *LPHMIDI;
typedef HMIDIIN  *LPHMIDIIN;
typedef HMIDIOUT  *LPHMIDIOUT;
typedef HMIDISTRM  *LPHMIDISTRM;
typedef DRVCALLBACK MIDICALLBACK;
typedef MIDICALLBACK  *LPMIDICALLBACK;

static const int MIDIPATCHSIZE   = 128;

typedef WORD PATCHARRAY[MIDIPATCHSIZE];
typedef WORD  *LPPATCHARRAY;
typedef WORD KEYARRAY[MIDIPATCHSIZE];
typedef WORD  *LPKEYARRAY;
]]

ffi.cdef[[
/* MIDI callback messages */
static const int MIM_OPEN      =  MM_MIM_OPEN;
static const int MIM_CLOSE     =  MM_MIM_CLOSE;
static const int MIM_DATA      =  MM_MIM_DATA;
static const int MIM_LONGDATA  =  MM_MIM_LONGDATA;
static const int MIM_ERROR     =  MM_MIM_ERROR;
static const int MIM_LONGERROR =  MM_MIM_LONGERROR;
static const int MOM_OPEN      =  MM_MOM_OPEN;
static const int MOM_CLOSE     =  MM_MOM_CLOSE;
static const int MOM_DONE      =  MM_MOM_DONE;
]]


if (WINVER >= 0x0400) then
ffi.cdef[[
static const int MIM_MOREDATA    =  MM_MIM_MOREDATA;
static const int MOM_POSITIONCB  =  MM_MOM_POSITIONCB;
]]
end --/* WINVER >= 0x0400 */

ffi.cdef[[
/* device ID for MIDI mapper */
static const int MIDIMAPPER    = ((UINT)-1);
static const int MIDI_MAPPER   = ((UINT)-1);
]]

if (WINVER >= 0x0400) then
ffi.cdef[[
/* flags for dwFlags parm of midiInOpen() */
static const int MIDI_IO_STATUS     = 0x00000020L;
]]
end --/* WINVER >= 0x0400 */

ffi.cdef[[
/* flags for wFlags parm of midiOutCachePatches(), midiOutCacheDrumPatches() */
static const int MIDI_CACHE_ALL     = 1;
static const int MIDI_CACHE_BESTFIT = 2;
static const int MIDI_CACHE_QUERY   = 3;
static const int MIDI_UNCACHE       = 4;
]]


--/* MIDI output device capabilities structure */
if _WIN32 then
ffi.cdef[[
typedef struct tagMIDIOUTCAPSA {
    WORD    wMid;                  /* manufacturer ID */
    WORD    wPid;                  /* product ID */
    MMVERSION vDriverVersion;      /* version of the driver */
    CHAR    szPname[MAXPNAMELEN];  /* product name (NULL terminated string) */
    WORD    wTechnology;           /* type of device */
    WORD    wVoices;               /* # of voices (internal synth only) */
    WORD    wNotes;                /* max # of notes (internal synth only) */
    WORD    wChannelMask;          /* channels used (internal synth only) */
    DWORD   dwSupport;             /* functionality supported by driver */
} MIDIOUTCAPSA, *PMIDIOUTCAPSA, *NPMIDIOUTCAPSA, *LPMIDIOUTCAPSA;
]]

ffi.cdef[[
typedef struct tagMIDIOUTCAPSW {
    WORD    wMid;                  /* manufacturer ID */
    WORD    wPid;                  /* product ID */
    MMVERSION vDriverVersion;      /* version of the driver */
    WCHAR   szPname[MAXPNAMELEN];  /* product name (NULL terminated string) */
    WORD    wTechnology;           /* type of device */
    WORD    wVoices;               /* # of voices (internal synth only) */
    WORD    wNotes;                /* max # of notes (internal synth only) */
    WORD    wChannelMask;          /* channels used (internal synth only) */
    DWORD   dwSupport;             /* functionality supported by driver */
} MIDIOUTCAPSW, *PMIDIOUTCAPSW, *NPMIDIOUTCAPSW, *LPMIDIOUTCAPSW;
]]

if UNICODE then
ffi.cdef[[
typedef MIDIOUTCAPSW MIDIOUTCAPS;
typedef PMIDIOUTCAPSW PMIDIOUTCAPS;
typedef NPMIDIOUTCAPSW NPMIDIOUTCAPS;
typedef LPMIDIOUTCAPSW LPMIDIOUTCAPS;
]]
else
ffi.cdef[[
typedef MIDIOUTCAPSA MIDIOUTCAPS;
typedef PMIDIOUTCAPSA PMIDIOUTCAPS;
typedef NPMIDIOUTCAPSA NPMIDIOUTCAPS;
typedef LPMIDIOUTCAPSA LPMIDIOUTCAPS;
]]
end   -- UNICODE

ffi.cdef[[
typedef struct tagMIDIOUTCAPS2A {
    WORD    wMid;                  /* manufacturer ID */
    WORD    wPid;                  /* product ID */
    MMVERSION vDriverVersion;      /* version of the driver */
    CHAR    szPname[MAXPNAMELEN];  /* product name (NULL terminated string) */
    WORD    wTechnology;           /* type of device */
    WORD    wVoices;               /* # of voices (internal synth only) */
    WORD    wNotes;                /* max # of notes (internal synth only) */
    WORD    wChannelMask;          /* channels used (internal synth only) */
    DWORD   dwSupport;             /* functionality supported by driver */
    GUID    ManufacturerGuid;      /* for extensible MID mapping */
    GUID    ProductGuid;           /* for extensible PID mapping */
    GUID    NameGuid;              /* for name lookup in registry */
} MIDIOUTCAPS2A, *PMIDIOUTCAPS2A, *NPMIDIOUTCAPS2A, *LPMIDIOUTCAPS2A;
]]

ffi.cdef[[
typedef struct tagMIDIOUTCAPS2W {
    WORD    wMid;                  /* manufacturer ID */
    WORD    wPid;                  /* product ID */
    MMVERSION vDriverVersion;      /* version of the driver */
    WCHAR   szPname[MAXPNAMELEN];  /* product name (NULL terminated string) */
    WORD    wTechnology;           /* type of device */
    WORD    wVoices;               /* # of voices (internal synth only) */
    WORD    wNotes;                /* max # of notes (internal synth only) */
    WORD    wChannelMask;          /* channels used (internal synth only) */
    DWORD   dwSupport;             /* functionality supported by driver */
    GUID    ManufacturerGuid;      /* for extensible MID mapping */
    GUID    ProductGuid;           /* for extensible PID mapping */
    GUID    NameGuid;              /* for name lookup in registry */
} MIDIOUTCAPS2W, *PMIDIOUTCAPS2W, *NPMIDIOUTCAPS2W, *LPMIDIOUTCAPS2W;
]]

if UNICODE then
ffi.cdef[[
typedef MIDIOUTCAPS2W MIDIOUTCAPS2;
typedef PMIDIOUTCAPS2W PMIDIOUTCAPS2;
typedef NPMIDIOUTCAPS2W NPMIDIOUTCAPS2;
typedef LPMIDIOUTCAPS2W LPMIDIOUTCAPS2;
]]
else
ffi.cdef[[
typedef MIDIOUTCAPS2A MIDIOUTCAPS2;
typedef PMIDIOUTCAPS2A PMIDIOUTCAPS2;
typedef NPMIDIOUTCAPS2A NPMIDIOUTCAPS2;
typedef LPMIDIOUTCAPS2A LPMIDIOUTCAPS2;
]]
end   -- UNICODE

else
ffi.cdef[[
typedef struct midioutcaps_tag {
    WORD    wMid;                  /* manufacturer ID */
    WORD    wPid;                  /* product ID */
    VERSION vDriverVersion;        /* version of the driver */
    char    szPname[MAXPNAMELEN];  /* product name (NULL terminated string) */
    WORD    wTechnology;           /* type of device */
    WORD    wVoices;               /* # of voices (internal synth only) */
    WORD    wNotes;                /* max # of notes (internal synth only) */
    WORD    wChannelMask;          /* channels used (internal synth only) */
    DWORD   dwSupport;             /* functionality supported by driver */
} MIDIOUTCAPS, *PMIDIOUTCAPS,  *NPMIDIOUTCAPS,  *LPMIDIOUTCAPS;
]]
end

ffi.cdef[[
/* flags for wTechnology field of MIDIOUTCAPS structure */
static const int MOD_MIDIPORT   = 1;  /* output port */
static const int MOD_SYNTH      = 2;  /* generic internal synth */
static const int MOD_SQSYNTH    = 3;  /* square wave internal synth */
static const int MOD_FMSYNTH    = 4;  /* FM internal synth */
static const int MOD_MAPPER     = 5;  /* MIDI mapper */
static const int MOD_WAVETABLE  = 6;  /* hardware wavetable synth */
static const int MOD_SWSYNTH    = 7;  /* software synth */

/* flags for dwSupport field of MIDIOUTCAPS structure */
static const int MIDICAPS_VOLUME    =      0x0001;  /* supports volume control */
static const int MIDICAPS_LRVOLUME  =      0x0002;  /* separate left-right volume control */
static const int MIDICAPS_CACHE     =      0x0004;
]]

if (WINVER >= 0x0400) then
ffi.cdef[[
static const int MIDICAPS_STREAM       =   0x0008;  /* driver supports midiStreamOut directly */
]]
end --/* WINVER >= 0x0400 */

--/* MIDI input device capabilities structure */
if _WIN32 then
ffi.cdef[[
typedef struct tagMIDIINCAPSA {
    WORD        wMid;                   /* manufacturer ID */
    WORD        wPid;                   /* product ID */
    MMVERSION   vDriverVersion;         /* version of the driver */
    CHAR        szPname[MAXPNAMELEN];   /* product name (NULL terminated string) */
//if (WINVER >= 0x0400)
    DWORD   dwSupport;             /* functionality supported by driver */
//end
} MIDIINCAPSA, *PMIDIINCAPSA, *NPMIDIINCAPSA, *LPMIDIINCAPSA;
]]

ffi.cdef[[
typedef struct tagMIDIINCAPSW {
    WORD        wMid;                   /* manufacturer ID */
    WORD        wPid;                   /* product ID */
    MMVERSION   vDriverVersion;         /* version of the driver */
    WCHAR       szPname[MAXPNAMELEN];   /* product name (NULL terminated string) */
//if (WINVER >= 0x0400)
    DWORD   dwSupport;             /* functionality supported by driver */
//end
} MIDIINCAPSW, *PMIDIINCAPSW, *NPMIDIINCAPSW, *LPMIDIINCAPSW;
]]

if UNICODE then
ffi.cdef[[
typedef MIDIINCAPSW MIDIINCAPS;
typedef PMIDIINCAPSW PMIDIINCAPS;
typedef NPMIDIINCAPSW NPMIDIINCAPS;
typedef LPMIDIINCAPSW LPMIDIINCAPS;
]]
else
ffi.cdef[[
typedef MIDIINCAPSA MIDIINCAPS;
typedef PMIDIINCAPSA PMIDIINCAPS;
typedef NPMIDIINCAPSA NPMIDIINCAPS;
typedef LPMIDIINCAPSA LPMIDIINCAPS;
]]
end   -- UNICODE

ffi.cdef[[
typedef struct tagMIDIINCAPS2A {
    WORD        wMid;                   /* manufacturer ID */
    WORD        wPid;                   /* product ID */
    MMVERSION   vDriverVersion;         /* version of the driver */
    CHAR        szPname[MAXPNAMELEN];   /* product name (NULL terminated string) */
//if (WINVER >= 0x0400)
    DWORD       dwSupport;              /* functionality supported by driver */
//end
    GUID        ManufacturerGuid;       /* for extensible MID mapping */
    GUID        ProductGuid;            /* for extensible PID mapping */
    GUID        NameGuid;               /* for name lookup in registry */
} MIDIINCAPS2A, *PMIDIINCAPS2A, *NPMIDIINCAPS2A, *LPMIDIINCAPS2A;
]]

ffi.cdef[[
typedef struct tagMIDIINCAPS2W {
    WORD        wMid;                   /* manufacturer ID */
    WORD        wPid;                   /* product ID */
    MMVERSION   vDriverVersion;         /* version of the driver */
    WCHAR       szPname[MAXPNAMELEN];   /* product name (NULL terminated string) */
//if (WINVER >= 0x0400)
    DWORD       dwSupport;              /* functionality supported by driver */
//end
    GUID        ManufacturerGuid;       /* for extensible MID mapping */
    GUID        ProductGuid;            /* for extensible PID mapping */
    GUID        NameGuid;               /* for name lookup in registry */
} MIDIINCAPS2W, *PMIDIINCAPS2W, *NPMIDIINCAPS2W, *LPMIDIINCAPS2W;
]]

if UNICODE then
ffi.cdef[[
typedef MIDIINCAPS2W MIDIINCAPS2;
typedef PMIDIINCAPS2W PMIDIINCAPS2;
typedef NPMIDIINCAPS2W NPMIDIINCAPS2;
typedef LPMIDIINCAPS2W LPMIDIINCAPS2;
]]
else
ffi.cdef[[
typedef MIDIINCAPS2A MIDIINCAPS2;
typedef PMIDIINCAPS2A PMIDIINCAPS2;
typedef NPMIDIINCAPS2A NPMIDIINCAPS2;
typedef LPMIDIINCAPS2A LPMIDIINCAPS2;
]]
end   -- UNICODE

else
ffi.cdef[[
typedef struct midiincaps_tag {
    WORD    wMid;                  /* manufacturer ID */
    WORD    wPid;                  /* product ID */
    VERSION vDriverVersion;        /* version of the driver */
    char    szPname[MAXPNAMELEN];  /* product name (NULL terminated string) */
//if (WINVER >= 0x0400)
    DWORD   dwSupport;             /* functionality supported by driver */
//end
} MIDIINCAPS, *PMIDIINCAPS,  *NPMIDIINCAPS,  *LPMIDIINCAPS;
]]
end

ffi.cdef[[
/* MIDI data block header */
typedef struct midihdr_tag {
    LPSTR       lpData;               /* pointer to locked data block */
    DWORD       dwBufferLength;       /* length of data in data block */
    DWORD       dwBytesRecorded;      /* used for input only */
    DWORD_PTR   dwUser;               /* for clients use */
    DWORD       dwFlags;              /* assorted flags (see defines) */
    struct midihdr_tag *lpNext;   /* reserved for driver */
    DWORD_PTR   reserved;             /* reserved for driver */
//if (WINVER >= 0x0400)
    DWORD       dwOffset;             /* Callback offset into buffer */
    DWORD_PTR   dwReserved[8];        /* Reserved for MMSYSTEM */
//end
} MIDIHDR, *PMIDIHDR,  *NPMIDIHDR,  *LPMIDIHDR;
]]

if (WINVER >= 0x0400) then
ffi.cdef[[
typedef struct midievent_tag
{
    DWORD       dwDeltaTime;          /* Ticks since last event */
    DWORD       dwStreamID;           /* Reserved; must be zero */
    DWORD       dwEvent;              /* Event type and parameters */
    DWORD       dwParms[1];           /* Parameters if this is a long event */
} MIDIEVENT;

typedef struct midistrmbuffver_tag
{
    DWORD       dwVersion;                  /* Stream buffer format version */
    DWORD       dwMid;                      /* Manufacturer ID as defined in MMREG.H */
    DWORD       dwOEMVersion;               /* Manufacturer version for custom ext */
} MIDISTRMBUFFVER;
]]
end --/* WINVER >= 0x0400 */

ffi.cdef[[
/* flags for dwFlags field of MIDIHDR structure */
static const int MHDR_DONE     =  0x00000001;       /* done bit */
static const int MHDR_PREPARED =  0x00000002;       /* set if header prepared */
static const int MHDR_INQUEUE  =  0x00000004;       /* reserved for driver */
static const int MHDR_ISSTRM   =  0x00000008;       /* Buffer is stream buffer */
]]

if (WINVER >= 0x0400) then
ffi.cdef[[
/* */
/* Type codes which go in the high byte of the event DWORD of a stream buffer */
/* */
/* Type codes 00-7F contain parameters within the low 24 bits */
/* Type codes 80-FF contain a length of their parameter in the low 24 */
/* bits, followed by their parameter data in the buffer. The event */
/* DWORD contains the exact byte length; the parm data itself must be */
/* padded to be an even multiple of 4 bytes long. */
/* */

static const int MEVT_F_SHORT      =  0x00000000L;
static const int MEVT_F_LONG       =  0x80000000L;
static const int MEVT_F_CALLBACK   =  0x40000000L;
]]

--local function MEVT_EVENTTYPE(x) return  ((BYTE)(((x)>>24)&0xFF)); end
--local function MEVT_EVENTPARM(x) return ((DWORD)((x)&0x00FFFFFFL)); end

ffi.cdef[[
static const int MEVT_SHORTMSG     =  ((BYTE)0x00);    /* parm = shortmsg for midiOutShortMsg */
static const int MEVT_TEMPO        =  ((BYTE)0x01);    /* parm = new tempo in microsec/qn     */
static const int MEVT_NOP          =  ((BYTE)0x02);    /* parm = unused; does nothing         */

/* 0x04-0x7F reserved */

static const int MEVT_LONGMSG      =  ((BYTE)0x80);    /* parm = bytes to send verbatim       */
static const int MEVT_COMMENT      =  ((BYTE)0x82);    /* parm = comment data                 */
static const int MEVT_VERSION      =  ((BYTE)0x84);    /* parm = MIDISTRMBUFFVER struct       */

/* 0x81-0xFF reserved */
]]

ffi.cdef[[
static const int MIDISTRM_ERROR     = (-2);

/* */
/* Structures and defines for midiStreamProperty */
/* */
static const int MIDIPROP_SET       = 0x80000000L;
static const int MIDIPROP_GET       = 0x40000000L;

/* These are intentionally both non-zero so the app cannot accidentally */
/* leave the operation off and happen to appear to work due to default */
/* action. */

static const int MIDIPROP_TIMEDIV  =  0x00000001;
static const int MIDIPROP_TEMPO    =  0x00000002;
]]

ffi.cdef[[
typedef struct midiproptimediv_tag
{
    DWORD       cbStruct;
    DWORD       dwTimeDiv;
} MIDIPROPTIMEDIV,  *LPMIDIPROPTIMEDIV;

typedef struct midiproptempo_tag
{
    DWORD       cbStruct;
    DWORD       dwTempo;
} MIDIPROPTEMPO,  *LPMIDIPROPTEMPO;
]]
end --/* WINVER >= 0x0400 */

ffi.cdef[[
/* MIDI function prototypes */

UINT
__stdcall
midiOutGetNumDevs(
    void
    );
]]

if (WINVER >= 0x0400) then
ffi.cdef[[
MMRESULT
__stdcall
midiStreamOpen(
     LPHMIDISTRM phms,
     LPUINT puDeviceID,
     DWORD cMidi,
     DWORD_PTR dwCallback,
     DWORD_PTR dwInstance,
     DWORD fdwOpen
    );


MMRESULT
__stdcall
midiStreamClose(
     HMIDISTRM hms
    );



MMRESULT
__stdcall
midiStreamProperty(
     HMIDISTRM hms,
     LPBYTE lppropdata,
     DWORD dwProperty
    );


MMRESULT
__stdcall
midiStreamPosition(
     HMIDISTRM hms,
     LPMMTIME lpmmt,
     UINT cbmmt
    );



MMRESULT
__stdcall
midiStreamOut(
     HMIDISTRM hms,
     LPMIDIHDR pmh,
     UINT cbmh
    );


MMRESULT
__stdcall
midiStreamPause(
     HMIDISTRM hms
    );


MMRESULT
__stdcall
midiStreamRestart(
     HMIDISTRM hms
    );


MMRESULT
__stdcall
midiStreamStop(
     HMIDISTRM hms
    );
]]

if _WIN32 then
ffi.cdef[[
MMRESULT
__stdcall
midiConnect(
     HMIDI hmi,
     HMIDIOUT hmo,
     LPVOID pReserved
    );


MMRESULT
__stdcall
midiDisconnect(
     HMIDI hmi,
     HMIDIOUT hmo,
     LPVOID pReserved
    );
]]
end
end --/* WINVER >= 0x0400 */

if _WIN32 then

ffi.cdef[[
MMRESULT
__stdcall
midiOutGetDevCapsA(
     UINT_PTR uDeviceID,
     LPMIDIOUTCAPSA pmoc,
     UINT cbmoc
    );


MMRESULT
__stdcall
midiOutGetDevCapsW(
     UINT_PTR uDeviceID,
     LPMIDIOUTCAPSW pmoc,
     UINT cbmoc
    );
]]

if UNICODE then
--#define midiOutGetDevCaps  midiOutGetDevCapsW
else
--#define midiOutGetDevCaps  midiOutGetDevCapsA
end   -- UNICODE

else
ffi.cdef[[]
MMRESULT __stdcall midiOutGetDevCaps(UINT uDeviceID, LPMIDIOUTCAPS pmoc, UINT cbmoc);
]]
end

if (WINVER >= 0x0400) then
ffi.cdef[[
MMRESULT
__stdcall
midiOutGetVolume(
     HMIDIOUT hmo,
     LPDWORD pdwVolume
    );


MMRESULT
__stdcall
midiOutSetVolume(
     HMIDIOUT hmo,
     DWORD dwVolume
    );
]]
else
ffi.cdef[[
 MMRESULT __stdcall midiOutGetVolume(UINT uId, LPDWORD pdwVolume);
 MMRESULT __stdcall midiOutSetVolume(UINT uId, DWORD dwVolume);
]]
end

if _WIN32 then

ffi.cdef[[
MMRESULT
__stdcall
midiOutGetErrorTextA(
     MMRESULT mmrError,
     LPSTR pszText,
     UINT cchText
    );


MMRESULT
__stdcall
midiOutGetErrorTextW(
     MMRESULT mmrError,
     LPWSTR pszText,
     UINT cchText
    );
]]

if UNICODE then
--#define midiOutGetErrorText  midiOutGetErrorTextW
else
--#define midiOutGetErrorText  midiOutGetErrorTextA
end   -- UNICODE

else
ffi.cdef[[
 MMRESULT __stdcall midiOutGetErrorText(MMRESULT mmrError, LPSTR pszText, UINT cchText);
]]
end

ffi.cdef[[
MMRESULT
__stdcall
midiOutOpen(
     LPHMIDIOUT phmo,
     UINT uDeviceID,
     DWORD_PTR dwCallback,
     DWORD_PTR dwInstance,
     DWORD fdwOpen
    );


MMRESULT
__stdcall
midiOutClose(
     HMIDIOUT hmo
    );


MMRESULT
__stdcall
midiOutPrepareHeader(
     HMIDIOUT hmo,
     LPMIDIHDR pmh,
     UINT cbmh
    );


MMRESULT
__stdcall
midiOutUnprepareHeader(
     HMIDIOUT hmo,
     LPMIDIHDR pmh,
     UINT cbmh
    );


MMRESULT
__stdcall
midiOutShortMsg(
     HMIDIOUT hmo,
     DWORD dwMsg
    );


MMRESULT
__stdcall
midiOutLongMsg(
     HMIDIOUT hmo,
     LPMIDIHDR pmh,
     UINT cbmh
    );


MMRESULT
__stdcall
midiOutReset(
     HMIDIOUT hmo
    );


MMRESULT
__stdcall
midiOutCachePatches(
     HMIDIOUT hmo,
     UINT uBank,
     LPWORD pwpa,
     UINT fuCache
    );


MMRESULT
__stdcall
midiOutCacheDrumPatches(
     HMIDIOUT hmo,
     UINT uPatch,
     LPWORD pwkya,
     UINT fuCache
    );


MMRESULT
__stdcall
midiOutGetID(
     HMIDIOUT hmo,
     LPUINT puDeviceID
    );
]]

if (WINVER >= 0x030a) then
if _WIN32 then
ffi.cdef[[
MMRESULT
__stdcall
midiOutMessage(
     HMIDIOUT hmo,
     UINT uMsg,
     DWORD_PTR dw1,
     DWORD_PTR dw2
    );
]]
else
ffi.cdef[[
DWORD __stdcall midiOutMessage(HMIDIOUT hmo, UINT uMsg, DWORD dw1, DWORD dw2);
]]
end
end --/* ifdef WINVER >= 0x030a */

ffi.cdef[[
UINT
__stdcall
midiInGetNumDevs(
    void
    );
]]

if _WIN32 then

ffi.cdef[[
MMRESULT
__stdcall
midiInGetDevCapsA(
     UINT_PTR uDeviceID,
     LPMIDIINCAPSA pmic,
     UINT cbmic
    );


MMRESULT
__stdcall
midiInGetDevCapsW(
     UINT_PTR uDeviceID,
     LPMIDIINCAPSW pmic,
     UINT cbmic
    );
]]

if UNICODE then
--#define midiInGetDevCaps  midiInGetDevCapsW
else
--#define midiInGetDevCaps  midiInGetDevCapsA
end   -- UNICODE

ffi.cdef[[
MMRESULT
__stdcall
midiInGetErrorTextA(
     MMRESULT mmrError,
     LPSTR pszText,
     UINT cchText
    );


MMRESULT
__stdcall
midiInGetErrorTextW(
     MMRESULT mmrError,
     LPWSTR pszText,
     UINT cchText
    );
]]

if UNICODE then
--#define midiInGetErrorText  midiInGetErrorTextW
else
--#define midiInGetErrorText  midiInGetErrorTextA
end   -- UNICODE

else
ffi.cdef[[
MMRESULT __stdcall midiInGetDevCaps(UINT uDeviceID, LPMIDIINCAPS pmic, UINT cbmic);
 MMRESULT __stdcall midiInGetErrorText(MMRESULT mmrError,  LPSTR pszText, UINT cchText);
]]
end

ffi.cdef[[
MMRESULT
__stdcall
midiInOpen(
     LPHMIDIIN phmi,
     UINT uDeviceID,
     DWORD_PTR dwCallback,
     DWORD_PTR dwInstance,
     DWORD fdwOpen
    );


MMRESULT
__stdcall
midiInClose(
     HMIDIIN hmi
    );


MMRESULT
__stdcall
midiInPrepareHeader(
     HMIDIIN hmi,
     LPMIDIHDR pmh,
     UINT cbmh
    );


MMRESULT
__stdcall
midiInUnprepareHeader(
     HMIDIIN hmi,
     LPMIDIHDR pmh,
     UINT cbmh
    );


MMRESULT
__stdcall
midiInAddBuffer(
     HMIDIIN hmi,
     LPMIDIHDR pmh,
     UINT cbmh
    );


MMRESULT
__stdcall
midiInStart(
     HMIDIIN hmi
    );


MMRESULT
__stdcall
midiInStop(
     HMIDIIN hmi
    );


MMRESULT
__stdcall
midiInReset(
     HMIDIIN hmi
    );


MMRESULT
__stdcall
midiInGetID(
     HMIDIIN hmi,
     LPUINT puDeviceID
    );
]]

if (WINVER >= 0x030a) then
if _WIN32 then
ffi.cdef[[
MMRESULT
__stdcall
midiInMessage(
     HMIDIIN hmi,
     UINT uMsg,
     DWORD_PTR dw1,
     DWORD_PTR dw2
    );
]]
else
ffi.cdef[[
DWORD __stdcall midiInMessage(HMIDIIN hmi, UINT uMsg, DWORD dw1, DWORD dw2);
]]
end
end --/* ifdef WINVER >= 0x030a */

end  --/* ifndef MMNOMIDI */



if not MMNOAUX then

--  Auxiliary audio support
ffi.cdef[[
/* device ID for aux device mapper */
static const int AUX_MAPPER   =  -1;
]]

--/* Auxiliary audio device capabilities structure */
if _WIN32 then
ffi.cdef[[
typedef struct tagAUXCAPSA {
    WORD        wMid;                /* manufacturer ID */
    WORD        wPid;                /* product ID */
    MMVERSION   vDriverVersion;      /* version of the driver */
    CHAR        szPname[MAXPNAMELEN];/* product name (NULL terminated string) */
    WORD        wTechnology;         /* type of device */
    WORD        wReserved1;          /* padding */
    DWORD       dwSupport;           /* functionality supported by driver */
} AUXCAPSA, *PAUXCAPSA, *NPAUXCAPSA, *LPAUXCAPSA;
]]

ffi.cdef[[
typedef struct tagAUXCAPSW {
    WORD        wMid;                /* manufacturer ID */
    WORD        wPid;                /* product ID */
    MMVERSION   vDriverVersion;      /* version of the driver */
    WCHAR       szPname[MAXPNAMELEN];/* product name (NULL terminated string) */
    WORD        wTechnology;         /* type of device */
    WORD        wReserved1;          /* padding */
    DWORD       dwSupport;           /* functionality supported by driver */
} AUXCAPSW, *PAUXCAPSW, *NPAUXCAPSW, *LPAUXCAPSW;
]]

if UNICODE then
ffi.cdef[[
typedef AUXCAPSW AUXCAPS;
typedef PAUXCAPSW PAUXCAPS;
typedef NPAUXCAPSW NPAUXCAPS;
typedef LPAUXCAPSW LPAUXCAPS;
]]
else
ffi.cdef[[
typedef AUXCAPSA AUXCAPS;
typedef PAUXCAPSA PAUXCAPS;
typedef NPAUXCAPSA NPAUXCAPS;
typedef LPAUXCAPSA LPAUXCAPS;
]]
end   -- UNICODE

ffi.cdef[[
typedef struct tagAUXCAPS2A {
    WORD        wMid;                /* manufacturer ID */
    WORD        wPid;                /* product ID */
    MMVERSION   vDriverVersion;      /* version of the driver */
    CHAR        szPname[MAXPNAMELEN];/* product name (NULL terminated string) */
    WORD        wTechnology;         /* type of device */
    WORD        wReserved1;          /* padding */
    DWORD       dwSupport;           /* functionality supported by driver */
    GUID        ManufacturerGuid;    /* for extensible MID mapping */
    GUID        ProductGuid;         /* for extensible PID mapping */
    GUID        NameGuid;            /* for name lookup in registry */
} AUXCAPS2A, *PAUXCAPS2A, *NPAUXCAPS2A, *LPAUXCAPS2A;
]]

ffi.cdef[[
typedef struct tagAUXCAPS2W {
    WORD        wMid;                /* manufacturer ID */
    WORD        wPid;                /* product ID */
    MMVERSION   vDriverVersion;      /* version of the driver */
    WCHAR       szPname[MAXPNAMELEN];/* product name (NULL terminated string) */
    WORD        wTechnology;         /* type of device */
    WORD        wReserved1;          /* padding */
    DWORD       dwSupport;           /* functionality supported by driver */
    GUID        ManufacturerGuid;    /* for extensible MID mapping */
    GUID        ProductGuid;         /* for extensible PID mapping */
    GUID        NameGuid;            /* for name lookup in registry */
} AUXCAPS2W, *PAUXCAPS2W, *NPAUXCAPS2W, *LPAUXCAPS2W;
]]

if UNICODE then
ffi.cdef[[
typedef AUXCAPS2W AUXCAPS2;
typedef PAUXCAPS2W PAUXCAPS2;
typedef NPAUXCAPS2W NPAUXCAPS2;
typedef LPAUXCAPS2W LPAUXCAPS2;
]]
else
ffi.cdef[[
typedef AUXCAPS2A AUXCAPS2;
typedef PAUXCAPS2A PAUXCAPS2;
typedef NPAUXCAPS2A NPAUXCAPS2;
typedef LPAUXCAPS2A LPAUXCAPS2;
]]
end   -- UNICODE

else
ffi.cdef[[
typedef struct auxcaps_tag {
    WORD    wMid;                  /* manufacturer ID */
    WORD    wPid;                  /* product ID */
    VERSION vDriverVersion;        /* version of the driver */
    char    szPname[MAXPNAMELEN];  /* product name (NULL terminated string) */
    WORD    wTechnology;           /* type of device */
    DWORD   dwSupport;             /* functionality supported by driver */
} AUXCAPS, *PAUXCAPS,  *NPAUXCAPS,  *LPAUXCAPS;
]]
end

ffi.cdef[[
/* flags for wTechnology field in AUXCAPS structure */
static const int AUXCAPS_CDAUDIO   = 1;       /* audio from internal CD-ROM drive */
static const int AUXCAPS_AUXIN     = 2;       /* audio from auxiliary input jacks */

/* flags for dwSupport field in AUXCAPS structure */
static const int AUXCAPS_VOLUME       =   0x0001;  /* supports volume control */
static const int AUXCAPS_LRVOLUME     =   0x0002;  /* separate left-right volume control */
]]

ffi.cdef[[
/* auxiliary audio function prototypes */

UINT
__stdcall
auxGetNumDevs(
    void
    );
]]

if _WIN32 then

ffi.cdef[[
MMRESULT
__stdcall
auxGetDevCapsA(
     UINT_PTR uDeviceID,
     LPAUXCAPSA pac,
     UINT cbac
    );


MMRESULT
__stdcall
auxGetDevCapsW(
     UINT_PTR uDeviceID,
     LPAUXCAPSW pac,
     UINT cbac
    );
]]

if UNICODE then
--#define auxGetDevCaps  auxGetDevCapsW
else
--#define auxGetDevCaps  auxGetDevCapsA
end   -- UNICODE

else
ffi.cdef[[
MMRESULT __stdcall auxGetDevCaps(UINT uDeviceID, LPAUXCAPS pac, UINT cbac);
]]
end

ffi.cdef[[
MMRESULT
__stdcall
auxSetVolume(
     UINT uDeviceID,
     DWORD dwVolume
    );


MMRESULT
__stdcall
auxGetVolume(
     UINT uDeviceID,
     LPDWORD pdwVolume
    );
]]

if (WINVER >= 0x030a) then
if _WIN32 then
ffi.cdef[[
MMRESULT
__stdcall
auxOutMessage(
     UINT uDeviceID,
     UINT uMsg,
     DWORD_PTR dw1,
     DWORD_PTR dw2
    );
]]
else
ffi.cdef[[
DWORD __stdcall auxOutMessage(UINT uDeviceID, UINT uMsg, DWORD dw1, DWORD dw2);
]]
end
end --/* ifdef WINVER >= 0x030a */

end  --/* ifndef MMNOAUX */



if not  MMNOMIXER then

--                            Mixer Support

DECLARE_HANDLE("HMIXEROBJ");
DECLARE_HANDLE("HMIXER");

ffi.cdef[[
typedef HMIXEROBJ  *LPHMIXEROBJ;
typedef HMIXER      *LPHMIXER;

static const int MIXER_SHORT_NAME_CHARS  = 16;
static const int MIXER_LONG_NAME_CHARS   = 64;

/* */
/*  MMRESULT error return values specific to the mixer API */

static const int MIXERR_INVALLINE           = (MIXERR_BASE + 0);
static const int MIXERR_INVALCONTROL        = (MIXERR_BASE + 1);
static const int MIXERR_INVALVALUE          = (MIXERR_BASE + 2);
static const int MIXERR_LASTERROR           = (MIXERR_BASE + 2);

static const int MIXER_OBJECTF_HANDLE   = 0x80000000L;
static const int MIXER_OBJECTF_MIXER    = 0x00000000L;
static const int MIXER_OBJECTF_HMIXER   = (MIXER_OBJECTF_HANDLE|MIXER_OBJECTF_MIXER);
static const int MIXER_OBJECTF_WAVEOUT  = 0x10000000L;
static const int MIXER_OBJECTF_HWAVEOUT = (MIXER_OBJECTF_HANDLE|MIXER_OBJECTF_WAVEOUT);
static const int MIXER_OBJECTF_WAVEIN   = 0x20000000L;
static const int MIXER_OBJECTF_HWAVEIN  = (MIXER_OBJECTF_HANDLE|MIXER_OBJECTF_WAVEIN);
static const int MIXER_OBJECTF_MIDIOUT  = 0x30000000L;
static const int MIXER_OBJECTF_HMIDIOUT = (MIXER_OBJECTF_HANDLE|MIXER_OBJECTF_MIDIOUT);
static const int MIXER_OBJECTF_MIDIIN   = 0x40000000L;
static const int MIXER_OBJECTF_HMIDIIN  = (MIXER_OBJECTF_HANDLE|MIXER_OBJECTF_MIDIIN);
static const int MIXER_OBJECTF_AUX      = 0x50000000L;
]]

ffi.cdef[[
UINT
__stdcall
mixerGetNumDevs(
    void
    );
]]

if _WIN32 then
ffi.cdef[[
typedef struct tagMIXERCAPSA {
    WORD            wMid;                   /* manufacturer id */
    WORD            wPid;                   /* product id */
    MMVERSION       vDriverVersion;         /* version of the driver */
    CHAR            szPname[MAXPNAMELEN];   /* product name */
    DWORD           fdwSupport;             /* misc. support bits */
    DWORD           cDestinations;          /* count of destinations */
} MIXERCAPSA, *PMIXERCAPSA, *LPMIXERCAPSA;
]]

ffi.cdef[[
typedef struct tagMIXERCAPSW {
    WORD            wMid;                   /* manufacturer id */
    WORD            wPid;                   /* product id */
    MMVERSION       vDriverVersion;         /* version of the driver */
    WCHAR           szPname[MAXPNAMELEN];   /* product name */
    DWORD           fdwSupport;             /* misc. support bits */
    DWORD           cDestinations;          /* count of destinations */
} MIXERCAPSW, *PMIXERCAPSW, *LPMIXERCAPSW;
]]


if UNICODE then
ffi.cdef[[
typedef MIXERCAPSW MIXERCAPS;
typedef PMIXERCAPSW PMIXERCAPS;
typedef LPMIXERCAPSW LPMIXERCAPS;
]]
else
ffi.cdef[[
typedef MIXERCAPSA MIXERCAPS;
typedef PMIXERCAPSA PMIXERCAPS;
typedef LPMIXERCAPSA LPMIXERCAPS;
]]
end   -- UNICODE

ffi.cdef[[
typedef struct tagMIXERCAPS2A {
    WORD            wMid;                   /* manufacturer id */
    WORD            wPid;                   /* product id */
    MMVERSION       vDriverVersion;         /* version of the driver */
    CHAR            szPname[MAXPNAMELEN];   /* product name */
    DWORD           fdwSupport;             /* misc. support bits */
    DWORD           cDestinations;          /* count of destinations */
    GUID            ManufacturerGuid;       /* for extensible MID mapping */
    GUID            ProductGuid;            /* for extensible PID mapping */
    GUID            NameGuid;               /* for name lookup in registry */
} MIXERCAPS2A, *PMIXERCAPS2A, *LPMIXERCAPS2A;
]]

ffi.cdef[[
typedef struct tagMIXERCAPS2W {
    WORD            wMid;                   /* manufacturer id */
    WORD            wPid;                   /* product id */
    MMVERSION       vDriverVersion;         /* version of the driver */
    WCHAR           szPname[MAXPNAMELEN];   /* product name */
    DWORD           fdwSupport;             /* misc. support bits */
    DWORD           cDestinations;          /* count of destinations */
    GUID            ManufacturerGuid;       /* for extensible MID mapping */
    GUID            ProductGuid;            /* for extensible PID mapping */
    GUID            NameGuid;               /* for name lookup in registry */
} MIXERCAPS2W, *PMIXERCAPS2W, *LPMIXERCAPS2W;
]]

if UNICODE then
ffi.cdef[[
typedef MIXERCAPS2W MIXERCAPS2;
typedef PMIXERCAPS2W PMIXERCAPS2;
typedef LPMIXERCAPS2W LPMIXERCAPS2;
]]
else
ffi.cdef[[
typedef MIXERCAPS2A MIXERCAPS2;
typedef PMIXERCAPS2A PMIXERCAPS2;
typedef LPMIXERCAPS2A LPMIXERCAPS2;
]]
end   -- UNICODE

else
ffi.cdef[[
typedef struct tMIXERCAPS {
    WORD            wMid;                   /* manufacturer id */
    WORD            wPid;                   /* product id */
    VERSION         vDriverVersion;         /* version of the driver */
    char            szPname[MAXPNAMELEN];   /* product name */
    DWORD           fdwSupport;             /* misc. support bits */
    DWORD           cDestinations;          /* count of destinations */
} MIXERCAPS, *PMIXERCAPS,  *LPMIXERCAPS;
]]
end

if _WIN32 then

ffi.cdef[[
MMRESULT
__stdcall
mixerGetDevCapsA(
     UINT_PTR uMxId,
     LPMIXERCAPSA pmxcaps,
     UINT cbmxcaps
    );


MMRESULT
__stdcall
mixerGetDevCapsW(
     UINT_PTR uMxId,
     LPMIXERCAPSW pmxcaps,
     UINT cbmxcaps
    );
]]

if UNICODE then
--#define mixerGetDevCaps  mixerGetDevCapsW
else
--#define mixerGetDevCaps  mixerGetDevCapsA
end   -- UNICODE

else
ffi.cdef[[
MMRESULT __stdcall mixerGetDevCaps(UINT uMxId, LPMIXERCAPS pmxcaps, UINT cbmxcaps);
]]
end

ffi.cdef[[
MMRESULT
__stdcall
mixerOpen(
     LPHMIXER phmx,
     UINT uMxId,
     DWORD_PTR dwCallback,
     DWORD_PTR dwInstance,
     DWORD fdwOpen
    );



MMRESULT
__stdcall
mixerClose(
     HMIXER hmx
    );



DWORD
__stdcall
mixerMessage(
     HMIXER hmx,
     UINT uMsg,
     DWORD_PTR dwParam1,
     DWORD_PTR dwParam2
    );
]]

if _WIN32 then
ffi.cdef[[
typedef struct tagMIXERLINEA {
    DWORD       cbStruct;               /* size of MIXERLINE structure */
    DWORD       dwDestination;          /* zero based destination index */
    DWORD       dwSource;               /* zero based source index (if source) */
    DWORD       dwLineID;               /* unique line id for mixer device */
    DWORD       fdwLine;                /* state/information about line */
    DWORD_PTR   dwUser;                 /* driver specific information */
    DWORD       dwComponentType;        /* component type line connects to */
    DWORD       cChannels;              /* number of channels line supports */
    DWORD       cConnections;           /* number of connections [possible] */
    DWORD       cControls;              /* number of controls at this line */
    CHAR        szShortName[MIXER_SHORT_NAME_CHARS];
    CHAR        szName[MIXER_LONG_NAME_CHARS];
    struct {
        DWORD       dwType;                 /* MIXERLINE_TARGETTYPE_xxxx */
        DWORD       dwDeviceID;             /* target device ID of device type */
        WORD        wMid;                   /* of target device */
        WORD        wPid;                   /*    "  " */
        MMVERSION   vDriverVersion;         /*    "  " */
        CHAR        szPname[MAXPNAMELEN];   /*    "  " */
    } Target;
} MIXERLINEA, *PMIXERLINEA, *LPMIXERLINEA;
]]

ffi.cdef[[
typedef struct tagMIXERLINEW {
    DWORD       cbStruct;               /* size of MIXERLINE structure */
    DWORD       dwDestination;          /* zero based destination index */
    DWORD       dwSource;               /* zero based source index (if source) */
    DWORD       dwLineID;               /* unique line id for mixer device */
    DWORD       fdwLine;                /* state/information about line */
    DWORD_PTR   dwUser;                 /* driver specific information */
    DWORD       dwComponentType;        /* component type line connects to */
    DWORD       cChannels;              /* number of channels line supports */
    DWORD       cConnections;           /* number of connections [possible] */
    DWORD       cControls;              /* number of controls at this line */
    WCHAR       szShortName[MIXER_SHORT_NAME_CHARS];
    WCHAR       szName[MIXER_LONG_NAME_CHARS];
    struct {
        DWORD       dwType;                 /* MIXERLINE_TARGETTYPE_xxxx */
        DWORD       dwDeviceID;             /* target device ID of device type */
        WORD        wMid;                   /* of target device */
        WORD        wPid;                   /*       */
        MMVERSION   vDriverVersion;         /*       */
        WCHAR       szPname[MAXPNAMELEN];   /*      */
    } Target;
} MIXERLINEW, *PMIXERLINEW, *LPMIXERLINEW;
]]

if UNICODE then
ffi.cdef[[
typedef MIXERLINEW MIXERLINE;
typedef PMIXERLINEW PMIXERLINE;
typedef LPMIXERLINEW LPMIXERLINE;
]]
else
ffi.cdef[[
typedef MIXERLINEA MIXERLINE;
typedef PMIXERLINEA PMIXERLINE;
typedef LPMIXERLINEA LPMIXERLINE;
]]
end   -- UNICODE

else
ffi.cdef[[
typedef struct tMIXERLINE {
    DWORD       cbStruct;               /* size of MIXERLINE structure */
    DWORD       dwDestination;          /* zero based destination index */
    DWORD       dwSource;               /* zero based source index (if source) */
    DWORD       dwLineID;               /* unique line id for mixer device */
    DWORD       fdwLine;                /* state/information about line */
    DWORD       dwUser;                 /* driver specific information */
    DWORD       dwComponentType;        /* component type line connects to */
    DWORD       cChannels;              /* number of channels line supports */
    DWORD       cConnections;           /* number of connections [possible] */
    DWORD       cControls;              /* number of controls at this line */
    char        szShortName[MIXER_SHORT_NAME_CHARS];
    char        szName[MIXER_LONG_NAME_CHARS];
    struct {
        DWORD   dwType;                 /* MIXERLINE_TARGETTYPE_xxxx */
        DWORD   dwDeviceID;             /* target device ID of device type */
        WORD    wMid;                   /* of target device */
        WORD    wPid;                   
        VERSION vDriverVersion;         
        char    szPname[MAXPNAMELEN];   
    } Target;
} MIXERLINE, *PMIXERLINE,  *LPMIXERLINE;
]]
end

ffi.cdef[[
/* */
/*  MIXERLINE.fdwLine */

static const int MIXERLINE_LINEF_ACTIVE            =  0x00000001L;
static const int MIXERLINE_LINEF_DISCONNECTED      =  0x00008000L;
static const int MIXERLINE_LINEF_SOURCE            =  0x80000000L;


/*  MIXERLINE.dwComponentType */
/* */
/*  component types for destinations and sources */

static const int MIXERLINE_COMPONENTTYPE_DST_FIRST     =  0x00000000L;
static const int MIXERLINE_COMPONENTTYPE_DST_UNDEFINED =  (MIXERLINE_COMPONENTTYPE_DST_FIRST + 0);
static const int MIXERLINE_COMPONENTTYPE_DST_DIGITAL   =  (MIXERLINE_COMPONENTTYPE_DST_FIRST + 1);
static const int MIXERLINE_COMPONENTTYPE_DST_LINE      =  (MIXERLINE_COMPONENTTYPE_DST_FIRST + 2);
static const int MIXERLINE_COMPONENTTYPE_DST_MONITOR   =  (MIXERLINE_COMPONENTTYPE_DST_FIRST + 3);
static const int MIXERLINE_COMPONENTTYPE_DST_SPEAKERS  =  (MIXERLINE_COMPONENTTYPE_DST_FIRST + 4);
static const int MIXERLINE_COMPONENTTYPE_DST_HEADPHONES=  (MIXERLINE_COMPONENTTYPE_DST_FIRST + 5);
static const int MIXERLINE_COMPONENTTYPE_DST_TELEPHONE =  (MIXERLINE_COMPONENTTYPE_DST_FIRST + 6);
static const int MIXERLINE_COMPONENTTYPE_DST_WAVEIN    =  (MIXERLINE_COMPONENTTYPE_DST_FIRST + 7);
static const int MIXERLINE_COMPONENTTYPE_DST_VOICEIN   =  (MIXERLINE_COMPONENTTYPE_DST_FIRST + 8);
static const int MIXERLINE_COMPONENTTYPE_DST_LAST      =  (MIXERLINE_COMPONENTTYPE_DST_FIRST + 8);

static const int MIXERLINE_COMPONENTTYPE_SRC_FIRST     =  0x00001000L;
static const int MIXERLINE_COMPONENTTYPE_SRC_UNDEFINED =  (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 0);
static const int MIXERLINE_COMPONENTTYPE_SRC_DIGITAL   =  (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 1);
static const int MIXERLINE_COMPONENTTYPE_SRC_LINE      =  (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 2);
static const int MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE=  (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 3);
static const int MIXERLINE_COMPONENTTYPE_SRC_SYNTHESIZER= (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 4);
static const int MIXERLINE_COMPONENTTYPE_SRC_COMPACTDISC= (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 5);
static const int MIXERLINE_COMPONENTTYPE_SRC_TELEPHONE  = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 6);
static const int MIXERLINE_COMPONENTTYPE_SRC_PCSPEAKER  = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 7);
static const int MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT    = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 8);
static const int MIXERLINE_COMPONENTTYPE_SRC_AUXILIARY  = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 9);
static const int MIXERLINE_COMPONENTTYPE_SRC_ANALOG     = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 10);
static const int MIXERLINE_COMPONENTTYPE_SRC_LAST       = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 10);

/* */
/*  MIXERLINE.Target.dwType */

static const int MIXERLINE_TARGETTYPE_UNDEFINED     = 0;
static const int MIXERLINE_TARGETTYPE_WAVEOUT       = 1;
static const int MIXERLINE_TARGETTYPE_WAVEIN        = 2;
static const int MIXERLINE_TARGETTYPE_MIDIOUT       = 3;
static const int MIXERLINE_TARGETTYPE_MIDIIN        = 4;
static const int MIXERLINE_TARGETTYPE_AUX           = 5;
]]

if _WIN32 then

ffi.cdef[[
MMRESULT
__stdcall
mixerGetLineInfoA(
     HMIXEROBJ hmxobj,
     LPMIXERLINEA pmxl,
     DWORD fdwInfo
    );


MMRESULT
__stdcall
mixerGetLineInfoW(
     HMIXEROBJ hmxobj,
     LPMIXERLINEW pmxl,
     DWORD fdwInfo
    );
]]

if UNICODE then
--#define mixerGetLineInfo  mixerGetLineInfoW
else
--#define mixerGetLineInfo  mixerGetLineInfoA
end   -- UNICODE

else
ffi.cdef[[
MMRESULT __stdcall mixerGetLineInfo(HMIXEROBJ hmxobj, LPMIXERLINE pmxl, DWORD fdwInfo);
]]
end

ffi.cdef[[
static const int MIXER_GETLINEINFOF_DESTINATION    =  0x00000000L;
static const int MIXER_GETLINEINFOF_SOURCE         =  0x00000001L;
static const int MIXER_GETLINEINFOF_LINEID         =  0x00000002L;
static const int MIXER_GETLINEINFOF_COMPONENTTYPE  =  0x00000003L;
static const int MIXER_GETLINEINFOF_TARGETTYPE     =  0x00000004L;

static const int MIXER_GETLINEINFOF_QUERYMASK      =  0x0000000FL;
]]

ffi.cdef[[
MMRESULT
__stdcall
mixerGetID(
     HMIXEROBJ hmxobj,
     UINT   * puMxId,
     DWORD fdwId
    );
]]

--[[
/* */
/*  MIXERCONTROL */
/* */
/* */
--]]

if _WIN32 then
ffi.cdef[[
typedef struct tagMIXERCONTROLA {
    DWORD           cbStruct;           /* size in bytes of MIXERCONTROL */
    DWORD           dwControlID;        /* unique control id for mixer device */
    DWORD           dwControlType;      /* MIXERCONTROL_CONTROLTYPE_xxx */
    DWORD           fdwControl;         /* MIXERCONTROL_CONTROLF_xxx */
    DWORD           cMultipleItems;     /* if MIXERCONTROL_CONTROLF_MULTIPLE set */
    CHAR            szShortName[MIXER_SHORT_NAME_CHARS];
    CHAR            szName[MIXER_LONG_NAME_CHARS];
    union {
        struct {
            LONG    lMinimum;           /* signed minimum for this control */
            LONG    lMaximum;           /* signed maximum for this control */
        } DUMMYSTRUCTNAME;
        struct {
            DWORD   dwMinimum;          /* unsigned minimum for this control */
            DWORD   dwMaximum;          /* unsigned maximum for this control */
        } DUMMYSTRUCTNAME2;
        DWORD       dwReserved[6];
    } Bounds;
    union {
        DWORD       cSteps;             /* # of steps between min & max */
        DWORD       cbCustomData;       /* size in bytes of custom data */
        DWORD       dwReserved[6];      /* !!! needed? we have cbStruct.... */
    } Metrics;
} MIXERCONTROLA, *PMIXERCONTROLA, *LPMIXERCONTROLA;
]]

ffi.cdef[[
typedef struct tagMIXERCONTROLW {
    DWORD           cbStruct;           /* size in bytes of MIXERCONTROL */
    DWORD           dwControlID;        /* unique control id for mixer device */
    DWORD           dwControlType;      /* MIXERCONTROL_CONTROLTYPE_xxx */
    DWORD           fdwControl;         /* MIXERCONTROL_CONTROLF_xxx */
    DWORD           cMultipleItems;     /* if MIXERCONTROL_CONTROLF_MULTIPLE set */
    WCHAR           szShortName[MIXER_SHORT_NAME_CHARS];
    WCHAR           szName[MIXER_LONG_NAME_CHARS];
    union {
        struct {
            LONG    lMinimum;           /* signed minimum for this control */
            LONG    lMaximum;           /* signed maximum for this control */
        } DUMMYSTRUCTNAME;
        struct {
            DWORD   dwMinimum;          /* unsigned minimum for this control */
            DWORD   dwMaximum;          /* unsigned maximum for this control */
        } DUMMYSTRUCTNAME2;
        DWORD       dwReserved[6];
    } Bounds;
    union {
        DWORD       cSteps;             /* # of steps between min & max */
        DWORD       cbCustomData;       /* size in bytes of custom data */
        DWORD       dwReserved[6];      /* !!! needed? we have cbStruct.... */
    } Metrics;
} MIXERCONTROLW, *PMIXERCONTROLW, *LPMIXERCONTROLW;
]]

if UNICODE then
ffi.cdef[[
typedef MIXERCONTROLW MIXERCONTROL;
typedef PMIXERCONTROLW PMIXERCONTROL;
typedef LPMIXERCONTROLW LPMIXERCONTROL;
]]
else
ffi.cdef[[
typedef MIXERCONTROLA MIXERCONTROL;
typedef PMIXERCONTROLA PMIXERCONTROL;
typedef LPMIXERCONTROLA LPMIXERCONTROL;
]]
end   -- UNICODE

else
ffi.cdef[[
typedef struct tMIXERCONTROL {
    DWORD           cbStruct;           /* size in bytes of MIXERCONTROL */
    DWORD           dwControlID;        /* unique control id for mixer device */
    DWORD           dwControlType;      /* MIXERCONTROL_CONTROLTYPE_xxx */
    DWORD           fdwControl;         /* MIXERCONTROL_CONTROLF_xxx */
    DWORD           cMultipleItems;     /* if MIXERCONTROL_CONTROLF_MULTIPLE set */
    char            szShortName[MIXER_SHORT_NAME_CHARS];
    char            szName[MIXER_LONG_NAME_CHARS];
    union {
        struct {
            LONG    lMinimum;           /* signed minimum for this control */
            LONG    lMaximum;           /* signed maximum for this control */
        } DUMMYSTRUCTNAME;
        struct {
            DWORD   dwMinimum;          /* unsigned minimum for this control */
            DWORD   dwMaximum;          /* unsigned maximum for this control */
        } DUMMYSTRUCTNAME2;
        DWORD       dwReserved[6];
    } Bounds;
    union {
        DWORD       cSteps;             /* # of steps between min & max */
        DWORD       cbCustomData;       /* size in bytes of custom data */
        DWORD       dwReserved[6];      /* !!! needed? we have cbStruct.... */
    } Metrics;
} MIXERCONTROL, *PMIXERCONTROL,  *LPMIXERCONTROL;
]]
end

ffi.cdef[[
/* */
/*  MIXERCONTROL.fdwControl */
/* */
/* */
static const int MIXERCONTROL_CONTROLF_UNIFORM  = 0x00000001L;
static const int MIXERCONTROL_CONTROLF_MULTIPLE = 0x00000002L;
static const int MIXERCONTROL_CONTROLF_DISABLED = 0x80000000L;

/* */
/*  MIXERCONTROL_CONTROLTYPE_xxx building block defines */
/* */
/* */
static const int MIXERCONTROL_CT_CLASS_MASK         = 0xF0000000L;
static const int MIXERCONTROL_CT_CLASS_CUSTOM       = 0x00000000L;
static const int MIXERCONTROL_CT_CLASS_METER        = 0x10000000L;
static const int MIXERCONTROL_CT_CLASS_SWITCH       = 0x20000000L;
static const int MIXERCONTROL_CT_CLASS_NUMBER       = 0x30000000L;
static const int MIXERCONTROL_CT_CLASS_SLIDER       = 0x40000000L;
static const int MIXERCONTROL_CT_CLASS_FADER        = 0x50000000L;
static const int MIXERCONTROL_CT_CLASS_TIME         = 0x60000000L;
static const int MIXERCONTROL_CT_CLASS_LIST         = 0x70000000L;

static const int MIXERCONTROL_CT_SUBCLASS_MASK      = 0x0F000000L;

static const int MIXERCONTROL_CT_SC_SWITCH_BOOLEAN  = 0x00000000L;
static const int MIXERCONTROL_CT_SC_SWITCH_BUTTON   = 0x01000000L;

static const int MIXERCONTROL_CT_SC_METER_POLLED    = 0x00000000L;

static const int MIXERCONTROL_CT_SC_TIME_MICROSECS  = 0x00000000L;
static const int MIXERCONTROL_CT_SC_TIME_MILLISECS  = 0x01000000L;

static const int MIXERCONTROL_CT_SC_LIST_SINGLE     = 0x00000000L;
static const int MIXERCONTROL_CT_SC_LIST_MULTIPLE   = 0x01000000L;

static const int MIXERCONTROL_CT_UNITS_MASK         = 0x00FF0000L;
static const int MIXERCONTROL_CT_UNITS_CUSTOM       = 0x00000000L;
static const int MIXERCONTROL_CT_UNITS_BOOLEAN      = 0x00010000L;
static const int MIXERCONTROL_CT_UNITS_SIGNED       = 0x00020000L;
static const int MIXERCONTROL_CT_UNITS_UNSIGNED     = 0x00030000L;
static const int MIXERCONTROL_CT_UNITS_DECIBELS     = 0x00040000L; /* in 10ths */
static const int MIXERCONTROL_CT_UNITS_PERCENT      = 0x00050000L; /* in 10ths */

/* */
/*  Commonly used control types for specifying MIXERCONTROL.dwControlType */
/* */

static const int MIXERCONTROL_CONTROLTYPE_CUSTOM        = (MIXERCONTROL_CT_CLASS_CUSTOM | MIXERCONTROL_CT_UNITS_CUSTOM);
static const int MIXERCONTROL_CONTROLTYPE_BOOLEANMETER  = (MIXERCONTROL_CT_CLASS_METER | MIXERCONTROL_CT_SC_METER_POLLED | MIXERCONTROL_CT_UNITS_BOOLEAN);
static const int MIXERCONTROL_CONTROLTYPE_SIGNEDMETER   = (MIXERCONTROL_CT_CLASS_METER | MIXERCONTROL_CT_SC_METER_POLLED | MIXERCONTROL_CT_UNITS_SIGNED);
static const int MIXERCONTROL_CONTROLTYPE_PEAKMETER     = (MIXERCONTROL_CONTROLTYPE_SIGNEDMETER + 1);
static const int MIXERCONTROL_CONTROLTYPE_UNSIGNEDMETER = (MIXERCONTROL_CT_CLASS_METER | MIXERCONTROL_CT_SC_METER_POLLED | MIXERCONTROL_CT_UNITS_UNSIGNED);
static const int MIXERCONTROL_CONTROLTYPE_BOOLEAN       = (MIXERCONTROL_CT_CLASS_SWITCH | MIXERCONTROL_CT_SC_SWITCH_BOOLEAN | MIXERCONTROL_CT_UNITS_BOOLEAN);
static const int MIXERCONTROL_CONTROLTYPE_ONOFF         = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 1);
static const int MIXERCONTROL_CONTROLTYPE_MUTE          = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 2);
static const int MIXERCONTROL_CONTROLTYPE_MONO          = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 3);
static const int MIXERCONTROL_CONTROLTYPE_LOUDNESS      = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 4);
static const int MIXERCONTROL_CONTROLTYPE_STEREOENH     = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 5);
static const int MIXERCONTROL_CONTROLTYPE_BASS_BOOST    = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 0x00002277);
static const int MIXERCONTROL_CONTROLTYPE_BUTTON        = (MIXERCONTROL_CT_CLASS_SWITCH | MIXERCONTROL_CT_SC_SWITCH_BUTTON | MIXERCONTROL_CT_UNITS_BOOLEAN);
static const int MIXERCONTROL_CONTROLTYPE_DECIBELS      = (MIXERCONTROL_CT_CLASS_NUMBER | MIXERCONTROL_CT_UNITS_DECIBELS);
static const int MIXERCONTROL_CONTROLTYPE_SIGNED        = (MIXERCONTROL_CT_CLASS_NUMBER | MIXERCONTROL_CT_UNITS_SIGNED);
static const int MIXERCONTROL_CONTROLTYPE_UNSIGNED      = (MIXERCONTROL_CT_CLASS_NUMBER | MIXERCONTROL_CT_UNITS_UNSIGNED);
static const int MIXERCONTROL_CONTROLTYPE_PERCENT       = (MIXERCONTROL_CT_CLASS_NUMBER | MIXERCONTROL_CT_UNITS_PERCENT);
static const int MIXERCONTROL_CONTROLTYPE_SLIDER        = (MIXERCONTROL_CT_CLASS_SLIDER | MIXERCONTROL_CT_UNITS_SIGNED);
static const int MIXERCONTROL_CONTROLTYPE_PAN           = (MIXERCONTROL_CONTROLTYPE_SLIDER + 1);
static const int MIXERCONTROL_CONTROLTYPE_QSOUNDPAN     = (MIXERCONTROL_CONTROLTYPE_SLIDER + 2);
static const int MIXERCONTROL_CONTROLTYPE_FADER         = (MIXERCONTROL_CT_CLASS_FADER | MIXERCONTROL_CT_UNITS_UNSIGNED);
static const int MIXERCONTROL_CONTROLTYPE_VOLUME        = (MIXERCONTROL_CONTROLTYPE_FADER + 1);
static const int MIXERCONTROL_CONTROLTYPE_BASS          = (MIXERCONTROL_CONTROLTYPE_FADER + 2);
static const int MIXERCONTROL_CONTROLTYPE_TREBLE        = (MIXERCONTROL_CONTROLTYPE_FADER + 3);
static const int MIXERCONTROL_CONTROLTYPE_EQUALIZER     = (MIXERCONTROL_CONTROLTYPE_FADER + 4);
static const int MIXERCONTROL_CONTROLTYPE_SINGLESELECT  = (MIXERCONTROL_CT_CLASS_LIST | MIXERCONTROL_CT_SC_LIST_SINGLE | MIXERCONTROL_CT_UNITS_BOOLEAN);
static const int MIXERCONTROL_CONTROLTYPE_MUX           = (MIXERCONTROL_CONTROLTYPE_SINGLESELECT + 1);
static const int MIXERCONTROL_CONTROLTYPE_MULTIPLESELECT= (MIXERCONTROL_CT_CLASS_LIST | MIXERCONTROL_CT_SC_LIST_MULTIPLE | MIXERCONTROL_CT_UNITS_BOOLEAN);
static const int MIXERCONTROL_CONTROLTYPE_MIXER         = (MIXERCONTROL_CONTROLTYPE_MULTIPLESELECT + 1);
static const int MIXERCONTROL_CONTROLTYPE_MICROTIME     = (MIXERCONTROL_CT_CLASS_TIME | MIXERCONTROL_CT_SC_TIME_MICROSECS | MIXERCONTROL_CT_UNITS_UNSIGNED);
static const int MIXERCONTROL_CONTROLTYPE_MILLITIME     = (MIXERCONTROL_CT_CLASS_TIME | MIXERCONTROL_CT_SC_TIME_MILLISECS | MIXERCONTROL_CT_UNITS_UNSIGNED);
]]

--[[
/* */
/*  MIXERLINECONTROLS */
/* */
--]]
if _WIN32 then
ffi.cdef[[
typedef struct tagMIXERLINECONTROLSA {
    DWORD           cbStruct;       /* size in bytes of MIXERLINECONTROLS */
    DWORD           dwLineID;       /* line id (from MIXERLINE.dwLineID) */
    union {
        DWORD       dwControlID;    /* MIXER_GETLINECONTROLSF_ONEBYID */
        DWORD       dwControlType;  /* MIXER_GETLINECONTROLSF_ONEBYTYPE */
    } DUMMYUNIONNAME;
    DWORD           cControls;      /* count of controls pmxctrl points to */
    DWORD           cbmxctrl;       /* size in bytes of _one_ MIXERCONTROL */
    LPMIXERCONTROLA pamxctrl;       /* pointer to first MIXERCONTROL array */
} MIXERLINECONTROLSA, *PMIXERLINECONTROLSA, *LPMIXERLINECONTROLSA;
]]

ffi.cdef[[
typedef struct tagMIXERLINECONTROLSW {
    DWORD           cbStruct;       /* size in bytes of MIXERLINECONTROLS */
    DWORD           dwLineID;       /* line id (from MIXERLINE.dwLineID) */
    union {
        DWORD       dwControlID;    /* MIXER_GETLINECONTROLSF_ONEBYID */
        DWORD       dwControlType;  /* MIXER_GETLINECONTROLSF_ONEBYTYPE */
    } DUMMYUNIONNAME;
    DWORD           cControls;      /* count of controls pmxctrl points to */
    DWORD           cbmxctrl;       /* size in bytes of _one_ MIXERCONTROL */
    LPMIXERCONTROLW pamxctrl;       /* pointer to first MIXERCONTROL array */
} MIXERLINECONTROLSW, *PMIXERLINECONTROLSW, *LPMIXERLINECONTROLSW;
]]

if UNICODE then
ffi.cdef[[
typedef MIXERLINECONTROLSW MIXERLINECONTROLS;
typedef PMIXERLINECONTROLSW PMIXERLINECONTROLS;
typedef LPMIXERLINECONTROLSW LPMIXERLINECONTROLS;
]]
else
ffi.cdef[[
typedef MIXERLINECONTROLSA MIXERLINECONTROLS;
typedef PMIXERLINECONTROLSA PMIXERLINECONTROLS;
typedef LPMIXERLINECONTROLSA LPMIXERLINECONTROLS;
]]
end   -- UNICODE

else
ffi.cdef[[
typedef struct tMIXERLINECONTROLS {
    DWORD           cbStruct;       /* size in bytes of MIXERLINECONTROLS */
    DWORD           dwLineID;       /* line id (from MIXERLINE.dwLineID) */
    union {
        DWORD       dwControlID;    /* MIXER_GETLINECONTROLSF_ONEBYID */
        DWORD       dwControlType;  /* MIXER_GETLINECONTROLSF_ONEBYTYPE */
    };
    DWORD           cControls;      /* count of controls pmxctrl points to */
    DWORD           cbmxctrl;       /* size in bytes of _one_ MIXERCONTROL */
    LPMIXERCONTROL  pamxctrl;       /* pointer to first MIXERCONTROL array */
} MIXERLINECONTROLS, *PMIXERLINECONTROLS,  *LPMIXERLINECONTROLS;
]]
end


if _WIN32 then

ffi.cdef[[
MMRESULT
__stdcall
mixerGetLineControlsA(
     HMIXEROBJ hmxobj,
     LPMIXERLINECONTROLSA pmxlc,
     DWORD fdwControls
    );


MMRESULT
__stdcall
mixerGetLineControlsW(
     HMIXEROBJ hmxobj,
     LPMIXERLINECONTROLSW pmxlc,
     DWORD fdwControls
    );
]]


if UNICODE then
--#define mixerGetLineControls  mixerGetLineControlsW
else
--#define mixerGetLineControls  mixerGetLineControlsA
end   -- UNICODE

else
ffi.cdef[[
MMRESULT __stdcall mixerGetLineControls(HMIXEROBJ hmxobj, LPMIXERLINECONTROLS pmxlc, DWORD fdwControls);
]]
end

ffi.cdef[[
static const int MIXER_GETLINECONTROLSF_ALL         = 0x00000000L;
static const int MIXER_GETLINECONTROLSF_ONEBYID     = 0x00000001L;
static const int MIXER_GETLINECONTROLSF_ONEBYTYPE   = 0x00000002L;

static const int MIXER_GETLINECONTROLSF_QUERYMASK   = 0x0000000FL;
]]

ffi.cdef[[
typedef struct tMIXERCONTROLDETAILS {
    DWORD           cbStruct;       /* size in bytes of MIXERCONTROLDETAILS */
    DWORD           dwControlID;    /* control id to get/set details on */
    DWORD           cChannels;      /* number of channels in paDetails array */
    union {
        HWND        hwndOwner;      /* for MIXER_SETCONTROLDETAILSF_CUSTOM */
        DWORD       cMultipleItems; /* if _MULTIPLE, the number of items per channel */
    } DUMMYUNIONNAME;
    DWORD           cbDetails;      /* size of _one_ details_XX struct */
    LPVOID          paDetails;      /* pointer to array of details_XX structs */
} MIXERCONTROLDETAILS, *PMIXERCONTROLDETAILS,  *LPMIXERCONTROLDETAILS;
]]


--  MIXER_GETCONTROLDETAILSF_LISTTEXT

if _WIN32 then
ffi.cdef[[
typedef struct tagMIXERCONTROLDETAILS_LISTTEXTA {
    DWORD           dwParam1;
    DWORD           dwParam2;
    CHAR            szName[MIXER_LONG_NAME_CHARS];
} MIXERCONTROLDETAILS_LISTTEXTA, *PMIXERCONTROLDETAILS_LISTTEXTA, *LPMIXERCONTROLDETAILS_LISTTEXTA;
typedef struct tagMIXERCONTROLDETAILS_LISTTEXTW {
    DWORD           dwParam1;
    DWORD           dwParam2;
    WCHAR           szName[MIXER_LONG_NAME_CHARS];
} MIXERCONTROLDETAILS_LISTTEXTW, *PMIXERCONTROLDETAILS_LISTTEXTW, *LPMIXERCONTROLDETAILS_LISTTEXTW;
]]

if UNICODE then
ffi.cdef[[
typedef MIXERCONTROLDETAILS_LISTTEXTW MIXERCONTROLDETAILS_LISTTEXT;
typedef PMIXERCONTROLDETAILS_LISTTEXTW PMIXERCONTROLDETAILS_LISTTEXT;
typedef LPMIXERCONTROLDETAILS_LISTTEXTW LPMIXERCONTROLDETAILS_LISTTEXT;
]]
else
ffi.cdef[[
typedef MIXERCONTROLDETAILS_LISTTEXTA MIXERCONTROLDETAILS_LISTTEXT;
typedef PMIXERCONTROLDETAILS_LISTTEXTA PMIXERCONTROLDETAILS_LISTTEXT;
typedef LPMIXERCONTROLDETAILS_LISTTEXTA LPMIXERCONTROLDETAILS_LISTTEXT;
]]
end   -- UNICODE

else
ffi.cdef[[
typedef struct tMIXERCONTROLDETAILS_LISTTEXT {
    DWORD           dwParam1;
    DWORD           dwParam2;
    char            szName[MIXER_LONG_NAME_CHARS];
} MIXERCONTROLDETAILS_LISTTEXT, *PMIXERCONTROLDETAILS_LISTTEXT,  *LPMIXERCONTROLDETAILS_LISTTEXT;
]]
end


--  MIXER_GETCONTROLDETAILSF_VALUE */
ffi.cdef[[
typedef struct tMIXERCONTROLDETAILS_BOOLEAN {
    LONG            fValue;
}       MIXERCONTROLDETAILS_BOOLEAN,
      *PMIXERCONTROLDETAILS_BOOLEAN,
  *LPMIXERCONTROLDETAILS_BOOLEAN;

typedef struct tMIXERCONTROLDETAILS_SIGNED {
    LONG            lValue;
}       MIXERCONTROLDETAILS_SIGNED,
      *PMIXERCONTROLDETAILS_SIGNED,
  *LPMIXERCONTROLDETAILS_SIGNED;

typedef struct tMIXERCONTROLDETAILS_UNSIGNED {
    DWORD           dwValue;
}       MIXERCONTROLDETAILS_UNSIGNED,
      *PMIXERCONTROLDETAILS_UNSIGNED,
  *LPMIXERCONTROLDETAILS_UNSIGNED;
]]

if _WIN32 then

ffi.cdef[[
MMRESULT
__stdcall
mixerGetControlDetailsA(
     HMIXEROBJ hmxobj,
     LPMIXERCONTROLDETAILS pmxcd,
     DWORD fdwDetails
    );


MMRESULT
__stdcall
mixerGetControlDetailsW(
     HMIXEROBJ hmxobj,
     LPMIXERCONTROLDETAILS pmxcd,
     DWORD fdwDetails
    );
]]

--[[
if UNICODE then
#define mixerGetControlDetails  mixerGetControlDetailsW
else
#define mixerGetControlDetails  mixerGetControlDetailsA
end   -- UNICODE
--]]

else
ffi.cdef[[
MMRESULT __stdcall mixerGetControlDetails(HMIXEROBJ hmxobj, LPMIXERCONTROLDETAILS pmxcd, DWORD fdwDetails);
]]
end

ffi.cdef[[
static const int MIXER_GETCONTROLDETAILSF_VALUE    =  0x00000000L;
static const int MIXER_GETCONTROLDETAILSF_LISTTEXT =  0x00000001L;

static const int MIXER_GETCONTROLDETAILSF_QUERYMASK=  0x0000000FL;
]]

ffi.cdef[[

MMRESULT
__stdcall
mixerSetControlDetails(
     HMIXEROBJ hmxobj,
     LPMIXERCONTROLDETAILS pmxcd,
     DWORD fdwDetails
    );
]]

ffi.cdef[[
static const int MIXER_SETCONTROLDETAILSF_VALUE     = 0x00000000L;
static const int MIXER_SETCONTROLDETAILSF_CUSTOM    = 0x00000001L;

static const int MIXER_SETCONTROLDETAILSF_QUERYMASK = 0x0000000FL;
]]
end --/* ifndef MMNOMIXER */
--]=]
end -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)




--end -- _MMEAPI_H_

return ffi.load("api-ms-win-mm-mme-l1-1-0")
