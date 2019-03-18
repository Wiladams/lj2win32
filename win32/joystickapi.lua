--[[
/********************************************************************************
*                                                                               *
* joystickapi.h -- ApiSet Contract for api-ms-win-mm-joystick-l1-1-0            *  
*                                                                               *
* Copyright (c) Microsoft Corporation. All rights reserved.                     *
*                                                                               *
********************************************************************************/
--]]

local ffi = require("ffi")

--#include <apiset.h>
--#include <apisetcconv.h>


require("win32.mmsyscom") -- mm common definitions




if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


if not MMNOJOY then

ffi.cdef[[
/* joystick error return values */
static const int JOYERR_NOERROR       = (0);                  /* no error */
static const int JOYERR_PARMS         = (JOYERR_BASE+5);      /* bad parameters */
static const int JOYERR_NOCANDO       = (JOYERR_BASE+6);      /* request not completed */
static const int JOYERR_UNPLUGGED     = (JOYERR_BASE+7);      /* joystick is unplugged */
]]

ffi.cdef[[
/* constants used with JOYINFO and JOYINFOEX structures and MM_JOY* messages */
static const int JOY_BUTTON1        = 0x0001;
static const int JOY_BUTTON2        = 0x0002;
static const int JOY_BUTTON3        = 0x0004;
static const int JOY_BUTTON4        = 0x0008;
static const int JOY_BUTTON1CHG     = 0x0100;
static const int JOY_BUTTON2CHG     = 0x0200;
static const int JOY_BUTTON3CHG     = 0x0400;
static const int JOY_BUTTON4CHG     = 0x0800;
]]

ffi.cdef[[
/* constants used with JOYINFOEX */
static const int JOY_BUTTON5         = 0x00000010;
static const int JOY_BUTTON6         = 0x00000020;
static const int JOY_BUTTON7         = 0x00000040;
static const int JOY_BUTTON8         = 0x00000080;
static const int JOY_BUTTON9         = 0x00000100;
static const int JOY_BUTTON10        = 0x00000200;
static const int JOY_BUTTON11        = 0x00000400;
static const int JOY_BUTTON12        = 0x00000800;
static const int JOY_BUTTON13        = 0x00001000;
static const int JOY_BUTTON14        = 0x00002000;
static const int JOY_BUTTON15        = 0x00004000;
static const int JOY_BUTTON16        = 0x00008000;
static const int JOY_BUTTON17        = 0x00010000;
static const int JOY_BUTTON18        = 0x00020000;
static const int JOY_BUTTON19        = 0x00040000;
static const int JOY_BUTTON20        = 0x00080000;
static const int JOY_BUTTON21        = 0x00100000;
static const int JOY_BUTTON22        = 0x00200000;
static const int JOY_BUTTON23        = 0x00400000;
static const int JOY_BUTTON24        = 0x00800000;
static const int JOY_BUTTON25        = 0x01000000;
static const int JOY_BUTTON26        = 0x02000000;
static const int JOY_BUTTON27        = 0x04000000;
static const int JOY_BUTTON28        = 0x08000000;
static const int JOY_BUTTON29        = 0x10000000;
static const int JOY_BUTTON30        = 0x20000000;
static const int JOY_BUTTON31        = 0x40000000;
static const int JOY_BUTTON32        = 0x80000000;
]]

ffi.cdef[[
/* constants used with JOYINFOEX structure */
static const int JOY_POVCENTERED       =  (WORD) -1;
static const int JOY_POVFORWARD        =  0;
static const int JOY_POVRIGHT          =  9000;
static const int JOY_POVBACKWARD       =  18000;
static const int JOY_POVLEFT           =  27000;
]]

ffi.cdef[[
static const int JOY_RETURNX             = 0x00000001;
static const int JOY_RETURNY             = 0x00000002;
static const int JOY_RETURNZ             = 0x00000004;
static const int JOY_RETURNR             = 0x00000008;
static const int JOY_RETURNU             = 0x00000010;     /* axis 5 */
static const int JOY_RETURNV             = 0x00000020;     /* axis 6 */
static const int JOY_RETURNPOV           = 0x00000040;
static const int JOY_RETURNBUTTONS       = 0x00000080;
static const int JOY_RETURNRAWDATA       = 0x00000100;
static const int JOY_RETURNPOVCTS        = 0x00000200;
static const int JOY_RETURNCENTERED      = 0x00000400;
static const int JOY_USEDEADZONE         = 0x00000800;
static const int JOY_RETURNALL           = (JOY_RETURNX | JOY_RETURNY | JOY_RETURNZ | \
                                 JOY_RETURNR | JOY_RETURNU | JOY_RETURNV | \
                                 JOY_RETURNPOV | JOY_RETURNBUTTONS);
]]

ffi.cdef[[
static const int JOY_CAL_READALWAYS      = 0x00010000;
static const int JOY_CAL_READXYONLY      = 0x00020000;
static const int JOY_CAL_READ3           = 0x00040000;
static const int JOY_CAL_READ4           = 0x00080000;
static const int JOY_CAL_READXONLY       = 0x00100000;
static const int JOY_CAL_READYONLY       = 0x00200000;
static const int JOY_CAL_READ5           = 0x00400000;
static const int JOY_CAL_READ6           = 0x00800000;
static const int JOY_CAL_READZONLY       = 0x01000000;
static const int JOY_CAL_READRONLY       = 0x02000000;
static const int JOY_CAL_READUONLY       = 0x04000000;
static const int JOY_CAL_READVONLY       = 0x08000000;
]]

ffi.cdef[[
/* joystick ID constants */
static const int JOYSTICKID1        = 0;
static const int JOYSTICKID2        = 1;
]]

ffi.cdef[[
/* joystick driver capabilites */
static const int JOYCAPS_HASZ            = 0x0001;
static const int JOYCAPS_HASR            = 0x0002;
static const int JOYCAPS_HASU            = 0x0004;
static const int JOYCAPS_HASV            = 0x0008;
static const int JOYCAPS_HASPOV          = 0x0010;
static const int JOYCAPS_POV4DIR         = 0x0020;
static const int JOYCAPS_POVCTS          = 0x0040;
]]


--/* joystick device capabilities data structure */
if _WIN32 then
ffi.cdef[[
typedef struct tagJOYCAPSA {
    WORD    wMid;                /* manufacturer ID */
    WORD    wPid;                /* product ID */
    CHAR    szPname[MAXPNAMELEN];/* product name (NULL terminated string) */
    UINT    wXmin;               /* minimum x position value */
    UINT    wXmax;               /* maximum x position value */
    UINT    wYmin;               /* minimum y position value */
    UINT    wYmax;               /* maximum y position value */
    UINT    wZmin;               /* minimum z position value */
    UINT    wZmax;               /* maximum z position value */
    UINT    wNumButtons;         /* number of buttons */
    UINT    wPeriodMin;          /* minimum message period when captured */
    UINT    wPeriodMax;          /* maximum message period when captured */
//#if (WINVER >= 0x0400)
    UINT    wRmin;               /* minimum r position value */
    UINT    wRmax;               /* maximum r position value */
    UINT    wUmin;               /* minimum u (5th axis) position value */
    UINT    wUmax;               /* maximum u (5th axis) position value */
    UINT    wVmin;               /* minimum v (6th axis) position value */
    UINT    wVmax;               /* maximum v (6th axis) position value */
    UINT    wCaps;               /* joystick capabilites */
    UINT    wMaxAxes;            /* maximum number of axes supported */
    UINT    wNumAxes;            /* number of axes in use */
    UINT    wMaxButtons;         /* maximum number of buttons supported */
    CHAR    szRegKey[MAXPNAMELEN];/* registry key */
    CHAR    szOEMVxD[MAX_JOYSTICKOEMVXDNAME]; /* OEM VxD in use */
//#endif
} JOYCAPSA, *PJOYCAPSA, *NPJOYCAPSA, *LPJOYCAPSA;
]]

ffi.cdef[[
typedef struct tagJOYCAPSW {
    WORD    wMid;                /* manufacturer ID */
    WORD    wPid;                /* product ID */
    WCHAR   szPname[MAXPNAMELEN];/* product name (NULL terminated string) */
    UINT    wXmin;               /* minimum x position value */
    UINT    wXmax;               /* maximum x position value */
    UINT    wYmin;               /* minimum y position value */
    UINT    wYmax;               /* maximum y position value */
    UINT    wZmin;               /* minimum z position value */
    UINT    wZmax;               /* maximum z position value */
    UINT    wNumButtons;         /* number of buttons */
    UINT    wPeriodMin;          /* minimum message period when captured */
    UINT    wPeriodMax;          /* maximum message period when captured */
//#if (WINVER >= 0x0400)
    UINT    wRmin;               /* minimum r position value */
    UINT    wRmax;               /* maximum r position value */
    UINT    wUmin;               /* minimum u (5th axis) position value */
    UINT    wUmax;               /* maximum u (5th axis) position value */
    UINT    wVmin;               /* minimum v (6th axis) position value */
    UINT    wVmax;               /* maximum v (6th axis) position value */
    UINT    wCaps;               /* joystick capabilites */
    UINT    wMaxAxes;            /* maximum number of axes supported */
    UINT    wNumAxes;            /* number of axes in use */
    UINT    wMaxButtons;         /* maximum number of buttons supported */
    WCHAR   szRegKey[MAXPNAMELEN];/* registry key */
    WCHAR   szOEMVxD[MAX_JOYSTICKOEMVXDNAME]; /* OEM VxD in use */
//#endif
} JOYCAPSW, *PJOYCAPSW, *NPJOYCAPSW, *LPJOYCAPSW;
]]


if UNICODE then
ffi.cdef[[
typedef JOYCAPSW JOYCAPS;
typedef PJOYCAPSW PJOYCAPS;
typedef NPJOYCAPSW NPJOYCAPS;
typedef LPJOYCAPSW LPJOYCAPS;
]]
else
ffi.cdef[[
typedef JOYCAPSA JOYCAPS;
typedef PJOYCAPSA PJOYCAPS;
typedef NPJOYCAPSA NPJOYCAPS;
typedef LPJOYCAPSA LPJOYCAPS;
]]
end --// UNICODE

ffi.cdef[[
typedef struct tagJOYCAPS2A {
    WORD    wMid;                /* manufacturer ID */
    WORD    wPid;                /* product ID */
    CHAR    szPname[MAXPNAMELEN];/* product name (NULL terminated string) */
    UINT    wXmin;               /* minimum x position value */
    UINT    wXmax;               /* maximum x position value */
    UINT    wYmin;               /* minimum y position value */
    UINT    wYmax;               /* maximum y position value */
    UINT    wZmin;               /* minimum z position value */
    UINT    wZmax;               /* maximum z position value */
    UINT    wNumButtons;         /* number of buttons */
    UINT    wPeriodMin;          /* minimum message period when captured */
    UINT    wPeriodMax;          /* maximum message period when captured */
    UINT    wRmin;               /* minimum r position value */
    UINT    wRmax;               /* maximum r position value */
    UINT    wUmin;               /* minimum u (5th axis) position value */
    UINT    wUmax;               /* maximum u (5th axis) position value */
    UINT    wVmin;               /* minimum v (6th axis) position value */
    UINT    wVmax;               /* maximum v (6th axis) position value */
    UINT    wCaps;               /* joystick capabilites */
    UINT    wMaxAxes;            /* maximum number of axes supported */
    UINT    wNumAxes;            /* number of axes in use */
    UINT    wMaxButtons;         /* maximum number of buttons supported */
    CHAR    szRegKey[MAXPNAMELEN];/* registry key */
    CHAR    szOEMVxD[MAX_JOYSTICKOEMVXDNAME]; /* OEM VxD in use */
    GUID    ManufacturerGuid;    /* for extensible MID mapping */
    GUID    ProductGuid;         /* for extensible PID mapping */
    GUID    NameGuid;            /* for name lookup in registry */
} JOYCAPS2A, *PJOYCAPS2A, *NPJOYCAPS2A, *LPJOYCAPS2A;
]]

ffi.cdef[[
typedef struct tagJOYCAPS2W {
    WORD    wMid;                /* manufacturer ID */
    WORD    wPid;                /* product ID */
    WCHAR   szPname[MAXPNAMELEN];/* product name (NULL terminated string) */
    UINT    wXmin;               /* minimum x position value */
    UINT    wXmax;               /* maximum x position value */
    UINT    wYmin;               /* minimum y position value */
    UINT    wYmax;               /* maximum y position value */
    UINT    wZmin;               /* minimum z position value */
    UINT    wZmax;               /* maximum z position value */
    UINT    wNumButtons;         /* number of buttons */
    UINT    wPeriodMin;          /* minimum message period when captured */
    UINT    wPeriodMax;          /* maximum message period when captured */
    UINT    wRmin;               /* minimum r position value */
    UINT    wRmax;               /* maximum r position value */
    UINT    wUmin;               /* minimum u (5th axis) position value */
    UINT    wUmax;               /* maximum u (5th axis) position value */
    UINT    wVmin;               /* minimum v (6th axis) position value */
    UINT    wVmax;               /* maximum v (6th axis) position value */
    UINT    wCaps;               /* joystick capabilites */
    UINT    wMaxAxes;            /* maximum number of axes supported */
    UINT    wNumAxes;            /* number of axes in use */
    UINT    wMaxButtons;         /* maximum number of buttons supported */
    WCHAR   szRegKey[MAXPNAMELEN];/* registry key */
    WCHAR   szOEMVxD[MAX_JOYSTICKOEMVXDNAME]; /* OEM VxD in use */
    GUID    ManufacturerGuid;    /* for extensible MID mapping */
    GUID    ProductGuid;         /* for extensible PID mapping */
    GUID    NameGuid;            /* for name lookup in registry */
} JOYCAPS2W, *PJOYCAPS2W, *NPJOYCAPS2W, *LPJOYCAPS2W;
]]

if UNICODE then
ffi.cdef[[
typedef JOYCAPS2W JOYCAPS2;
typedef PJOYCAPS2W PJOYCAPS2;
typedef NPJOYCAPS2W NPJOYCAPS2;
typedef LPJOYCAPS2W LPJOYCAPS2;
]]
else
ffi.cdef[[
typedef JOYCAPS2A JOYCAPS2;
typedef PJOYCAPS2A PJOYCAPS2;
typedef NPJOYCAPS2A NPJOYCAPS2;
typedef LPJOYCAPS2A LPJOYCAPS2;
]]
end --// UNICODE

else  -- _WIN32
ffi.cdef[[
typedef struct joycaps_tag {
    WORD wMid;                  /* manufacturer ID */
    WORD wPid;                  /* product ID */
    char szPname[MAXPNAMELEN];  /* product name (NULL terminated string) */
    UINT wXmin;                 /* minimum x position value */
    UINT wXmax;                 /* maximum x position value */
    UINT wYmin;                 /* minimum y position value */
    UINT wYmax;                 /* maximum y position value */
    UINT wZmin;                 /* minimum z position value */
    UINT wZmax;                 /* maximum z position value */
    UINT wNumButtons;           /* number of buttons */
    UINT wPeriodMin;            /* minimum message period when captured */
    UINT wPeriodMax;            /* maximum message period when captured */
//#if (WINVER >= 0x0400)
    UINT wRmin;                 /* minimum r position value */
    UINT wRmax;                 /* maximum r position value */
    UINT wUmin;                 /* minimum u (5th axis) position value */
    UINT wUmax;                 /* maximum u (5th axis) position value */
    UINT wVmin;                 /* minimum v (6th axis) position value */
    UINT wVmax;                 /* maximum v (6th axis) position value */
    UINT wCaps;                 /* joystick capabilites */
    UINT wMaxAxes;              /* maximum number of axes supported */
    UINT wNumAxes;              /* number of axes in use */
    UINT wMaxButtons;           /* maximum number of buttons supported */
    char szRegKey[MAXPNAMELEN]; /* registry key */
    char szOEMVxD[MAX_JOYSTICKOEMVXDNAME]; /* OEM VxD in use */
//#endif
} JOYCAPS, *PJOYCAPS,  *NPJOYCAPS,  *LPJOYCAPS;
]]
end

ffi.cdef[[
/* joystick information data structure */
typedef struct joyinfo_tag {
    UINT wXpos;                 /* x position */
    UINT wYpos;                 /* y position */
    UINT wZpos;                 /* z position */
    UINT wButtons;              /* button states */
} JOYINFO, *PJOYINFO,  *NPJOYINFO,  *LPJOYINFO;
]]

if (WINVER >= 0x0400) then
ffi.cdef[[
typedef struct joyinfoex_tag {
    DWORD dwSize;                /* size of structure */
    DWORD dwFlags;               /* flags to indicate what to return */
    DWORD dwXpos;                /* x position */
    DWORD dwYpos;                /* y position */
    DWORD dwZpos;                /* z position */
    DWORD dwRpos;                /* rudder/4th axis position */
    DWORD dwUpos;                /* 5th axis position */
    DWORD dwVpos;                /* 6th axis position */
    DWORD dwButtons;             /* button states */
    DWORD dwButtonNumber;        /* current button number pressed */
    DWORD dwPOV;                 /* point of view state */
    DWORD dwReserved1;           /* reserved for communication between winmm & driver */
    DWORD dwReserved2;           /* reserved for future expansion */
} JOYINFOEX, *PJOYINFOEX,  *NPJOYINFOEX,  *LPJOYINFOEX;
]]
end



if (WINVER >= 0x0400) then
ffi.cdef[[
MMRESULT
__stdcall
joyGetPosEx(
     UINT uJoyID,
     LPJOYINFOEX pji
    );
]]
end --/* WINVER >= 0x0400 */

ffi.cdef[[
UINT
__stdcall
joyGetNumDevs(
    void
    );
]]

if _WIN32 then
ffi.cdef[[

MMRESULT
__stdcall
joyGetDevCapsA(
     UINT_PTR uJoyID,
     LPJOYCAPSA pjc,
     UINT cbjc
    );


MMRESULT
__stdcall
joyGetDevCapsW(
     UINT_PTR uJoyID,
     LPJOYCAPSW pjc,
     UINT cbjc
    );
]]

--[[
if UNICODE then
#define joyGetDevCaps  joyGetDevCapsW
else
#define joyGetDevCaps  joyGetDevCapsA
end --// !UNICODE
--]]
else
ffi.cdef[[
MMRESULT __stdcall joyGetDevCaps(UINT uJoyID, LPJOYCAPS pjc, UINT cbjc);
]]
end

ffi.cdef[[
MMRESULT
__stdcall
joyGetPos(
     UINT uJoyID,
     LPJOYINFO pji
    );



MMRESULT
__stdcall
joyGetThreshold(
     UINT uJoyID,
     LPUINT puThreshold
    );



MMRESULT
__stdcall
joyReleaseCapture(
     UINT uJoyID
    );



MMRESULT
__stdcall
joySetCapture(
     HWND hwnd,
     UINT uJoyID,
     UINT uPeriod,
     BOOL fChanged
    );



MMRESULT
__stdcall
joySetThreshold(
     UINT uJoyID,
     UINT uThreshold
    );
]]

if (WINVER >= 0x0400) then
ffi.cdef[[
MMRESULT
__stdcall
joyConfigChanged(
     DWORD dwFlags
    );
]]
end

end  -- ifndef MMNOJOY

end -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


return ffi.load("api-ms-win-mm-joystick-l1-1-0")


