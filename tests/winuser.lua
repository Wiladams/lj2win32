local ffi = require("ffi")
local bit = require("bit")
local lshift, rshift = bit.lshift, bit.rshift

local exports = {}
exports.Lib = ffi.load("user32");

--#include <stdarg.h>
--[[
#ifndef NOAPISET
#include <libloaderapi.h> // LoadString%
#endif
--]]
require("win32.wtypes")


ffi.cdef[[
typedef HANDLE HDWP;
typedef VOID MENUTEMPLATEA;
typedef VOID MENUTEMPLATEW;
]]
if UNICODE then
ffi.cdef[[
    typedef MENUTEMPLATEW MENUTEMPLATE;
]]
else
ffi.cdef[[
    typedef MENUTEMPLATEA MENUTEMPLATE;
]]
end

ffi.cdef[[
typedef PVOID LPMENUTEMPLATEA;
typedef PVOID LPMENUTEMPLATEW;
]]
if UNICODE then
ffi.cdef[[
typedef LPMENUTEMPLATEW LPMENUTEMPLATE;
]]
else
ffi.cdef[[
typedef LPMENUTEMPLATEA LPMENUTEMPLATE;
]]
end -- UNICODE

ffi.cdef[[
typedef LRESULT (__stdcall* WNDPROC)(HWND, UINT, WPARAM, LPARAM);
]]


ffi.cdef[[
typedef INT_PTR (__stdcall* DLGPROC)(HWND, UINT, WPARAM, LPARAM);
typedef VOID (__stdcall* TIMERPROC)(HWND, UINT, UINT_PTR, DWORD);
typedef BOOL (__stdcall* GRAYSTRINGPROC)(HDC, LPARAM, int);
typedef BOOL (__stdcall* WNDENUMPROC)(HWND, LPARAM);
typedef LRESULT (__stdcall* HOOKPROC)(int code, WPARAM wParam, LPARAM lParam);
typedef VOID (__stdcall* SENDASYNCPROC)(HWND, UINT, ULONG_PTR, LRESULT);

typedef BOOL (__stdcall* PROPENUMPROCA)(HWND, LPCSTR, HANDLE);
typedef BOOL (__stdcall* PROPENUMPROCW)(HWND, LPCWSTR, HANDLE);

typedef BOOL (__stdcall* PROPENUMPROCEXA)(HWND, LPSTR, HANDLE, ULONG_PTR);
typedef BOOL (__stdcall* PROPENUMPROCEXW)(HWND, LPWSTR, HANDLE, ULONG_PTR);

typedef int (__stdcall* EDITWORDBREAKPROCA)(LPSTR lpch, int ichCurrent, int cch, int code);
typedef int (__stdcall* EDITWORDBREAKPROCW)(LPWSTR lpch, int ichCurrent, int cch, int code);

typedef BOOL (__stdcall* DRAWSTATEPROC)(HDC hdc, LPARAM lData, WPARAM wData, int cx, int cy);
]]


if UNICODE then
ffi.cdef[[
typedef PROPENUMPROCW        PROPENUMPROC;
typedef PROPENUMPROCEXW      PROPENUMPROCEX;
typedef EDITWORDBREAKPROCW   EDITWORDBREAKPROC;
]]
else  -- !UNICODE
ffi.cdef[[
typedef PROPENUMPROCA        PROPENUMPROC;
typedef PROPENUMPROCEXA      PROPENUMPROCEX;
typedef EDITWORDBREAKPROCA   EDITWORDBREAKPROC;
]]
end -- UNICODE 


ffi.cdef[[
typedef BOOL (__stdcall* NAMEENUMPROCA)(LPSTR, LPARAM);
typedef BOOL (__stdcall* NAMEENUMPROCW)(LPWSTR, LPARAM);

typedef NAMEENUMPROCA   WINSTAENUMPROCA;
typedef NAMEENUMPROCA   DESKTOPENUMPROCA;
typedef NAMEENUMPROCW   WINSTAENUMPROCW;
typedef NAMEENUMPROCW   DESKTOPENUMPROCW;
]]

if UNICODE then
ffi.cdef[[
typedef WINSTAENUMPROCW     WINSTAENUMPROC;
typedef DESKTOPENUMPROCW    DESKTOPENUMPROC;
]]
else  -- !UNICODE
ffi.cdef[[
typedef WINSTAENUMPROCA     WINSTAENUMPROC;
typedef DESKTOPENUMPROCA    DESKTOPENUMPROC;
]]
end -- UNICODE 



local function IS_INTRESOURCE(_r) 
    return (rshift(ffi.cast("ULONG_PTR",_r), 16) == 0) 
end

local function MAKEINTRESOURCEA(i) 
    return ffi.cast("LPSTR",ffi.cast("ULONG_PTR",ffi.cast("WORD",i)))
end

local function MAKEINTRESOURCEW(i) 
    return ffi.cast("LPWSTR",ffi.cast("ULONG_PTR",ffi.cast("WORD",i)))
end

local MAKEINTRESOURCE  = MAKEINTRESOURCEA

if UNICODE then
MAKEINTRESOURCE  = MAKEINTRESOURCEW
end

--[=[
#ifndef NORESOURCE

/*
 * Predefined Resource Types
 */
#define RT_CURSOR           MAKEINTRESOURCE(1)
#define RT_BITMAP           MAKEINTRESOURCE(2)
#define RT_ICON             MAKEINTRESOURCE(3)
#define RT_MENU             MAKEINTRESOURCE(4)
#define RT_DIALOG           MAKEINTRESOURCE(5)
#define RT_STRING           MAKEINTRESOURCE(6)
#define RT_FONTDIR          MAKEINTRESOURCE(7)
#define RT_FONT             MAKEINTRESOURCE(8)
#define RT_ACCELERATOR      MAKEINTRESOURCE(9)
#define RT_RCDATA           MAKEINTRESOURCE(10)
#define RT_MESSAGETABLE     MAKEINTRESOURCE(11)

#define DIFFERENCE     11
#define RT_GROUP_CURSOR MAKEINTRESOURCE((ULONG_PTR)(RT_CURSOR) + DIFFERENCE)
#define RT_GROUP_ICON   MAKEINTRESOURCE((ULONG_PTR)(RT_ICON) + DIFFERENCE)
#define RT_VERSION      MAKEINTRESOURCE(16)
#define RT_DLGINCLUDE   MAKEINTRESOURCE(17)
#if(WINVER >= 0x0400)
#define RT_PLUGPLAY     MAKEINTRESOURCE(19)
#define RT_VXD          MAKEINTRESOURCE(20)
#define RT_ANICURSOR    MAKEINTRESOURCE(21)
#define RT_ANIICON      MAKEINTRESOURCE(22)
#endif /* WINVER >= 0x0400 */
#define RT_HTML         MAKEINTRESOURCE(23)
#ifdef RC_INVOKED
#define RT_MANIFEST                        24
#define CREATEPROCESS_MANIFEST_RESOURCE_ID  1
#define ISOLATIONAWARE_MANIFEST_RESOURCE_ID 2
#define ISOLATIONAWARE_NOSTATICIMPORT_MANIFEST_RESOURCE_ID 3
#define MINIMUM_RESERVED_MANIFEST_RESOURCE_ID 1   /* inclusive */
#define MAXIMUM_RESERVED_MANIFEST_RESOURCE_ID 16  /* inclusive */
#else  /* RC_INVOKED */
#define RT_MANIFEST                        MAKEINTRESOURCE(24)
#define CREATEPROCESS_MANIFEST_RESOURCE_ID MAKEINTRESOURCE( 1)
#define ISOLATIONAWARE_MANIFEST_RESOURCE_ID MAKEINTRESOURCE(2)
#define ISOLATIONAWARE_NOSTATICIMPORT_MANIFEST_RESOURCE_ID MAKEINTRESOURCE(3)
#define MINIMUM_RESERVED_MANIFEST_RESOURCE_ID MAKEINTRESOURCE( 1 /*inclusive*/)
#define MAXIMUM_RESERVED_MANIFEST_RESOURCE_ID MAKEINTRESOURCE(16 /*inclusive*/)
#endif /* RC_INVOKED */
--]=]


ffi.cdef[[

int
__stdcall
wvsprintfA(
     LPSTR,
      LPCSTR,
     va_list arglist);

int
__stdcall
wvsprintfW(
     LPWSTR,
      LPCWSTR,
     va_list arglist);
]]

exports.wvsprintf   = ffi.C.wvsprintfA;
if UNICODE then
exports.wvsprintf  = ffi.C.wvsprintfW;
end -- !UNICODE


ffi.cdef[[
int
__cdecl
wsprintfA(
     LPSTR,
      LPCSTR,
    ...);

int
__cdecl
wsprintfW(
     LPWSTR,
      LPCWSTR,
    ...);
]]

if UNICODE then
exports.wsprintf  = ffi.C.wsprintfW;
else
exports.wsprintf  = ffi.C.wsprintfA;
end


ffi.cdef[[
/*
 * SPI_SETDESKWALLPAPER defined constants
 */
static const int SETWALLPAPER_DEFAULT    = ((LPWSTR)-1);
]]

ffi.cdef[[
/*
 * Scroll Bar Constants
 */
static const int SB_HORZ           =  0;
static const int SB_VERT           =  1;
static const int SB_CTL            =  2;
static const int SB_BOTH           =  3;

/*
 * Scroll Bar Commands
 */
static const int SB_LINEUP          = 0;
static const int SB_LINELEFT        = 0;
static const int SB_LINEDOWN        = 1;
static const int SB_LINERIGHT       = 1;
static const int SB_PAGEUP          = 2;
static const int SB_PAGELEFT        = 2;
static const int SB_PAGEDOWN        = 3;
static const int SB_PAGERIGHT       = 3;
static const int SB_THUMBPOSITION   = 4;
static const int SB_THUMBTRACK      = 5;
static const int SB_TOP             = 6;
static const int SB_LEFT            = 6;
static const int SB_BOTTOM          = 7;
static const int SB_RIGHT           = 7;
static const int SB_ENDSCROLL       = 8;
]]


ffi.cdef[[
/*
 * ShowWindow() Commands
 */
static const int SW_HIDE            = 0;
static const int SW_SHOWNORMAL      = 1;
static const int SW_NORMAL          = 1;
static const int SW_SHOWMINIMIZED   = 2;
static const int SW_SHOWMAXIMIZED   = 3;
static const int SW_MAXIMIZE        = 3;
static const int SW_SHOWNOACTIVATE  = 4;
static const int SW_SHOW            = 5;
static const int SW_MINIMIZE        = 6;
static const int SW_SHOWMINNOACTIVE = 7;
static const int SW_SHOWNA          = 8;
static const int SW_RESTORE         = 9;
static const int SW_SHOWDEFAULT     = 10;
static const int SW_FORCEMINIMIZE   = 11;
static const int SW_MAX             = 11;
]]

ffi.cdef[[
/*
 * Old ShowWindow() Commands
 */
static const int HIDE_WINDOW         =0;
static const int SHOW_OPENWINDOW     =1;
static const int SHOW_ICONWINDOW     =2;
static const int SHOW_FULLSCREEN     =3;
static const int SHOW_OPENNOACTIVATE =4;

/*
 * Identifiers for the WM_SHOWWINDOW message
 */
static const int SW_PARENTCLOSING    =1;
static const int SW_OTHERZOOM        =2;
static const int SW_PARENTOPENING    =3;
static const int SW_OTHERUNZOOM      =4;
]]


ffi.cdef[[
/*
 * AnimateWindow() Commands
 */
static const int AW_HOR_POSITIVE            = 0x00000001;
static const int AW_HOR_NEGATIVE            = 0x00000002;
static const int AW_VER_POSITIVE            = 0x00000004;
static const int AW_VER_NEGATIVE            = 0x00000008;
static const int AW_CENTER                  = 0x00000010;
static const int AW_HIDE                    = 0x00010000;
static const int AW_ACTIVATE                = 0x00020000;
static const int AW_SLIDE                   = 0x00040000;
static const int AW_BLEND                   = 0x00080000;
]]

ffi.cdef[[
/*
 * WM_KEYUP/DOWN/CHAR HIWORD(lParam) flags
 */
static const int KF_EXTENDED      = 0x0100;
static const int KF_DLGMODE       = 0x0800;
static const int KF_MENUMODE      = 0x1000;
static const int KF_ALTDOWN       = 0x2000;
static const int KF_REPEAT        = 0x4000;
static const int KF_UP            = 0x8000;
]]

if not NOVIRTUALKEYCODES then
ffi.cdef[[
/*
 * Virtual Keys, Standard Set
 */
static const int VK_LBUTTON        = 0x01;
static const int VK_RBUTTON        = 0x02;
static const int VK_CANCEL         = 0x03;
static const int VK_MBUTTON        = 0x04;    /* NOT contiguous with L & RBUTTON */
static const int VK_XBUTTON1       = 0x05;    /* NOT contiguous with L & RBUTTON */
static const int VK_XBUTTON2       = 0x06;    /* NOT contiguous with L & RBUTTON */

// 0x07 : reserved

static const int VK_BACK           = 0x08;
static const int VK_TAB            = 0x09;

/*
 * = 0x0A - = 0x0B : reserved
 */

static const int VK_CLEAR          = 0x0C;
static const int VK_RETURN         = 0x0D;

/*
 * = 0x0E - = 0x0F : unassigned
 */

static const int VK_SHIFT          = 0x10;
static const int VK_CONTROL        = 0x11;
static const int VK_MENU           = 0x12;
static const int VK_PAUSE          = 0x13;
static const int VK_CAPITAL        = 0x14;

static const int VK_KANA           = 0x15;
//static const int VK_HANGEUL        = 0x15;  /* old name - should be here for compatibility */
static const int VK_HANGUL         = 0x15;

/*
 * = 0x16 : unassigned
 */

static const int VK_JUNJA          = 0x17;
static const int VK_FINAL          = 0x18;
static const int VK_HANJA          = 0x19;
static const int VK_KANJI          = 0x19;

/*
 * = 0x1A : unassigned
 */

static const int VK_ESCAPE         = 0x1B;

static const int VK_CONVERT        = 0x1C;
static const int VK_NONCONVERT     = 0x1D;
static const int VK_ACCEPT         = 0x1E;
static const int VK_MODECHANGE     = 0x1F;

static const int VK_SPACE          = 0x20;
static const int VK_PRIOR          = 0x21;
static const int VK_NEXT           = 0x22;
static const int VK_END            = 0x23;
static const int VK_HOME           = 0x24;
static const int VK_LEFT           = 0x25;
static const int VK_UP             = 0x26;
static const int VK_RIGHT          = 0x27;
static const int VK_DOWN           = 0x28;
static const int VK_SELECT         = 0x29;
static const int VK_PRINT          = 0x2A;
static const int VK_EXECUTE        = 0x2B;
static const int VK_SNAPSHOT       = 0x2C;
static const int VK_INSERT         = 0x2D;
static const int VK_DELETE         = 0x2E;
static const int VK_HELP           = 0x2F;

/*
 * VK_0 - VK_9 are the same as ASCII '0' - '9' (0x30 - 0x39)
 * 0x3A - 0x40 : unassigned
 * VK_A - VK_Z are the same as ASCII 'A' - 'Z' (0x41 - 0x5A)
 */

static const int VK_LWIN           = 0x5B;
static const int VK_RWIN           = 0x5C;
static const int VK_APPS           = 0x5D;

/*
 * = 0x5E : reserved
 */

static const int VK_SLEEP          = 0x5F;

static const int VK_NUMPAD0        = 0x60;
static const int VK_NUMPAD1        = 0x61;
static const int VK_NUMPAD2        = 0x62;
static const int VK_NUMPAD3        = 0x63;
static const int VK_NUMPAD4        = 0x64;
static const int VK_NUMPAD5        = 0x65;
static const int VK_NUMPAD6        = 0x66;
static const int VK_NUMPAD7        = 0x67;
static const int VK_NUMPAD8        = 0x68;
static const int VK_NUMPAD9        = 0x69;
static const int VK_MULTIPLY       = 0x6A;
static const int VK_ADD            = 0x6B;
static const int VK_SEPARATOR      = 0x6C;
static const int VK_SUBTRACT       = 0x6D;
static const int VK_DECIMAL        = 0x6E;
static const int VK_DIVIDE         = 0x6F;
static const int VK_F1             = 0x70;
static const int VK_F2             = 0x71;
static const int VK_F3             = 0x72;
static const int VK_F4             = 0x73;
static const int VK_F5             = 0x74;
static const int VK_F6             = 0x75;
static const int VK_F7             = 0x76;
static const int VK_F8             = 0x77;
static const int VK_F9             = 0x78;
static const int VK_F10            = 0x79;
static const int VK_F11            = 0x7A;
static const int VK_F12            = 0x7B;
static const int VK_F13            = 0x7C;
static const int VK_F14            = 0x7D;
static const int VK_F15            = 0x7E;
static const int VK_F16            = 0x7F;
static const int VK_F17            = 0x80;
static const int VK_F18            = 0x81;
static const int VK_F19            = 0x82;
static const int VK_F20            = 0x83;
static const int VK_F21            = 0x84;
static const int VK_F22            = 0x85;
static const int VK_F23            = 0x86;
static const int VK_F24            = 0x87;

/*
 * 0x88 - 0x8F : UI navigation
 */

static const int VK_NAVIGATION_VIEW     = 0x88; // reserved
static const int VK_NAVIGATION_MENU     = 0x89; // reserved
static const int VK_NAVIGATION_UP       = 0x8A; // reserved
static const int VK_NAVIGATION_DOWN     = 0x8B; // reserved
static const int VK_NAVIGATION_LEFT     = 0x8C; // reserved
static const int VK_NAVIGATION_RIGHT    = 0x8D; // reserved
static const int VK_NAVIGATION_ACCEPT   = 0x8E; // reserved
static const int VK_NAVIGATION_CANCEL   = 0x8F; // reserved


static const int VK_NUMLOCK        = 0x90;
static const int VK_SCROLL         = 0x91;

/*
 * NEC PC-9800 kbd definitions
 */
static const int VK_OEM_NEC_EQUAL  = 0x92;   // '=' key on numpad

/*
 * Fujitsu/OASYS kbd definitions
 */
static const int VK_OEM_FJ_JISHO   = 0x92;   // 'Dictionary' key
static const int VK_OEM_FJ_MASSHOU = 0x93;   // 'Unregister word' key
static const int VK_OEM_FJ_TOUROKU = 0x94;   // 'Register word' key
static const int VK_OEM_FJ_LOYA    = 0x95;   // 'Left OYAYUBI' key
static const int VK_OEM_FJ_ROYA    = 0x96;   // 'Right OYAYUBI' key

/*
 * 0x97 - 0x9F : unassigned
 */

/*
 * VK_L* & VK_R* - left and right Alt, Ctrl and Shift virtual keys.
 * Used only as parameters to GetAsyncKeyState() and GetKeyState().
 * No other API or message will distinguish left and right keys in this way.
 */
static const int VK_LSHIFT         = 0xA0;
static const int VK_RSHIFT         = 0xA1;
static const int VK_LCONTROL       = 0xA2;
static const int VK_RCONTROL       = 0xA3;
static const int VK_LMENU          = 0xA4;
static const int VK_RMENU          = 0xA5;


static const int VK_BROWSER_BACK        = 0xA6;
static const int VK_BROWSER_FORWARD     = 0xA7;
static const int VK_BROWSER_REFRESH     = 0xA8;
static const int VK_BROWSER_STOP        = 0xA9;
static const int VK_BROWSER_SEARCH      = 0xAA;
static const int VK_BROWSER_FAVORITES   = 0xAB;
static const int VK_BROWSER_HOME        = 0xAC;

static const int VK_VOLUME_MUTE         = 0xAD;
static const int VK_VOLUME_DOWN         = 0xAE;
static const int VK_VOLUME_UP           = 0xAF;
static const int VK_MEDIA_NEXT_TRACK    = 0xB0;
static const int VK_MEDIA_PREV_TRACK    = 0xB1;
static const int VK_MEDIA_STOP          = 0xB2;
static const int VK_MEDIA_PLAY_PAUSE    = 0xB3;
static const int VK_LAUNCH_MAIL         = 0xB4;
static const int VK_LAUNCH_MEDIA_SELECT = 0xB5;
static const int VK_LAUNCH_APP1         = 0xB6;
static const int VK_LAUNCH_APP2         = 0xB7;



/*
 * 0xB8 - 0xB9 : reserved
 */

static const int VK_OEM_1          = 0xBA;   // ';:' for US
static const int VK_OEM_PLUS       = 0xBB;   // '+' any country
static const int VK_OEM_COMMA      = 0xBC;   // ',' any country
static const int VK_OEM_MINUS      = 0xBD;   // '-' any country
static const int VK_OEM_PERIOD     = 0xBE;   // '.' any country
static const int VK_OEM_2          = 0xBF;   // '/?' for US
static const int VK_OEM_3          = 0xC0;   // '`~' for US

//  0xC1 - 0xC2 : reserved



/*
 * 0xC3 - 0xDA : Gamepad input
 */

static const int VK_GAMEPAD_A                         = 0xC3; // reserved
static const int VK_GAMEPAD_B                         = 0xC4; // reserved
static const int VK_GAMEPAD_X                         = 0xC5; // reserved
static const int VK_GAMEPAD_Y                         = 0xC6; // reserved
static const int VK_GAMEPAD_RIGHT_SHOULDER            = 0xC7; // reserved
static const int VK_GAMEPAD_LEFT_SHOULDER             = 0xC8; // reserved
static const int VK_GAMEPAD_LEFT_TRIGGER              = 0xC9; // reserved
static const int VK_GAMEPAD_RIGHT_TRIGGER             = 0xCA; // reserved
static const int VK_GAMEPAD_DPAD_UP                   = 0xCB; // reserved
static const int VK_GAMEPAD_DPAD_DOWN                 = 0xCC; // reserved
static const int VK_GAMEPAD_DPAD_LEFT                 = 0xCD; // reserved
static const int VK_GAMEPAD_DPAD_RIGHT                = 0xCE; // reserved
static const int VK_GAMEPAD_MENU                      = 0xCF; // reserved
static const int VK_GAMEPAD_VIEW                      = 0xD0; // reserved
static const int VK_GAMEPAD_LEFT_THUMBSTICK_BUTTON    = 0xD1; // reserved
static const int VK_GAMEPAD_RIGHT_THUMBSTICK_BUTTON   = 0xD2; // reserved
static const int VK_GAMEPAD_LEFT_THUMBSTICK_UP        = 0xD3; // reserved
static const int VK_GAMEPAD_LEFT_THUMBSTICK_DOWN      = 0xD4; // reserved
static const int VK_GAMEPAD_LEFT_THUMBSTICK_RIGHT     = 0xD5; // reserved
static const int VK_GAMEPAD_LEFT_THUMBSTICK_LEFT      = 0xD6; // reserved
static const int VK_GAMEPAD_RIGHT_THUMBSTICK_UP       = 0xD7; // reserved
static const int VK_GAMEPAD_RIGHT_THUMBSTICK_DOWN     = 0xD8; // reserved
static const int VK_GAMEPAD_RIGHT_THUMBSTICK_RIGHT    = 0xD9; // reserved
static const int VK_GAMEPAD_RIGHT_THUMBSTICK_LEFT     = 0xDA; // reserved

static const int VK_OEM_4          = 0xDB;  //  '[{' for US
static const int VK_OEM_5          = 0xDC;  //  '\|' for US
static const int VK_OEM_6          = 0xDD;  //  ']}' for US
static const int VK_OEM_7          = 0xDE;  //  ''"' for US
static const int VK_OEM_8          = 0xDF;

/*
 * 0xE0 : reserved
 */

/*
 * Various extended or enhanced keyboards
 */
static const int VK_OEM_AX         = 0xE1;  //  'AX' key on Japanese AX kbd
static const int VK_OEM_102        = 0xE2;  //  "<>" or "\|" on RT 102-key kbd.
static const int VK_ICO_HELP       = 0xE3;  //  Help key on ICO
static const int VK_ICO_00         = 0xE4;  //  00 key on ICO


static const int VK_PROCESSKEY     = 0xE5;

static const int VK_ICO_CLEAR      = 0xE6;

static const int VK_PACKET         = 0xE7;


/*
 * 0xE8 : unassigned
 */

/*
 * Nokia/Ericsson definitions
 */
static const int VK_OEM_RESET      = 0xE9;
static const int VK_OEM_JUMP       = 0xEA;
static const int VK_OEM_PA1        = 0xEB;
static const int VK_OEM_PA2        = 0xEC;
static const int VK_OEM_PA3        = 0xED;
static const int VK_OEM_WSCTRL     = 0xEE;
static const int VK_OEM_CUSEL      = 0xEF;
static const int VK_OEM_ATTN       = 0xF0;
static const int VK_OEM_FINISH     = 0xF1;
static const int VK_OEM_COPY       = 0xF2;
static const int VK_OEM_AUTO       = 0xF3;
static const int VK_OEM_ENLW       = 0xF4;
static const int VK_OEM_BACKTAB    = 0xF5;

static const int VK_ATTN           = 0xF6;
static const int VK_CRSEL          = 0xF7;
static const int VK_EXSEL          = 0xF8;
static const int VK_EREOF          = 0xF9;
static const int VK_PLAY           = 0xFA;
static const int VK_ZOOM           = 0xFB;
static const int VK_NONAME         = 0xFC;
static const int VK_PA1            = 0xFD;
static const int VK_OEM_CLEAR      = 0xFE;

 // 0xFF : reserved
]]

end -- !NOVIRTUALKEYCODES


ffi.cdef[[
/*
 * SetWindowsHook() codes
 */
static const int WH_MIN              =(-1);
static const int WH_MSGFILTER        =(-1);
static const int WH_JOURNALRECORD    =0;
static const int WH_JOURNALPLAYBACK  =1;
static const int WH_KEYBOARD         =2;
static const int WH_GETMESSAGE       =3;
static const int WH_CALLWNDPROC      =4;
static const int WH_CBT              =5;
static const int WH_SYSMSGFILTER     =6;
static const int WH_MOUSE            =7;

static const int WH_HARDWARE         =8;

static const int WH_DEBUG            =9;
static const int WH_SHELL           =10;
static const int WH_FOREGROUNDIDLE  =11;

static const int WH_CALLWNDPROCRET  =12;



static const int WH_KEYBOARD_LL     =13;
static const int WH_MOUSE_LL        =14;




static const int WH_MAX             =14;


static const int WH_MINHOOK         = WH_MIN;
static const int WH_MAXHOOK         = WH_MAX;
]]

ffi.cdef[[
/*
 * Hook Codes
 */
static const int HC_ACTION          = 0;
static const int HC_GETNEXT         = 1;
static const int HC_SKIP            = 2;
static const int HC_NOREMOVE        = 3;
static const int HC_NOREM           = HC_NOREMOVE;
static const int HC_SYSMODALON      = 4;
static const int HC_SYSMODALOFF     = 5;

/*
 * CBT Hook Codes
 */
static const int HCBT_MOVESIZE      = 0;
static const int HCBT_MINMAX        = 1;
static const int HCBT_QS            = 2;
static const int HCBT_CREATEWND     = 3;
static const int HCBT_DESTROYWND    = 4;
static const int HCBT_ACTIVATE      = 5;
static const int HCBT_CLICKSKIPPED  = 6;
static const int HCBT_KEYSKIPPED    = 7;
static const int HCBT_SYSCOMMAND    = 8;
static const int HCBT_SETFOCUS      = 9;
]]

ffi.cdef[[
/*
 * HCBT_CREATEWND parameters pointed to by lParam
 */
typedef struct tagCBT_CREATEWNDA
{
    struct tagCREATESTRUCTA *lpcs;
    HWND           hwndInsertAfter;
} CBT_CREATEWNDA, *LPCBT_CREATEWNDA;
/*
 * HCBT_CREATEWND parameters pointed to by lParam
 */
typedef struct tagCBT_CREATEWNDW
{
    struct tagCREATESTRUCTW *lpcs;
    HWND           hwndInsertAfter;
} CBT_CREATEWNDW, *LPCBT_CREATEWNDW;
]]

if UNICODE then
ffi.cdef[[
typedef CBT_CREATEWNDW CBT_CREATEWND;
typedef LPCBT_CREATEWNDW LPCBT_CREATEWND;
]]
else
ffi.cdef[[
typedef CBT_CREATEWNDA CBT_CREATEWND;
typedef LPCBT_CREATEWNDA LPCBT_CREATEWND;
]]
end

ffi.cdef[[
/*
 * HCBT_ACTIVATE structure pointed to by lParam
 */
typedef struct tagCBTACTIVATESTRUCT
{
    BOOL    fMouse;
    HWND    hWndActive;
} CBTACTIVATESTRUCT, *LPCBTACTIVATESTRUCT;


/*
 * WTSSESSION_NOTIFICATION struct pointed by lParam, for WM_WTSSESSION_CHANGE
 */
typedef struct tagWTSSESSION_NOTIFICATION
{
    DWORD cbSize;
    DWORD dwSessionId;

} WTSSESSION_NOTIFICATION, *PWTSSESSION_NOTIFICATION;
]]

--[=[
/*
 * codes passed in WPARAM for WM_WTSSESSION_CHANGE
 */

#define WTS_CONSOLE_CONNECT                0x1
#define WTS_CONSOLE_DISCONNECT             0x2
#define WTS_REMOTE_CONNECT                 0x3
#define WTS_REMOTE_DISCONNECT              0x4
#define WTS_SESSION_LOGON                  0x5
#define WTS_SESSION_LOGOFF                 0x6
#define WTS_SESSION_LOCK                   0x7
#define WTS_SESSION_UNLOCK                 0x8
#define WTS_SESSION_REMOTE_CONTROL         0x9
#define WTS_SESSION_CREATE                 0xa
#define WTS_SESSION_TERMINATE              0xb


/*
 * WH_MSGFILTER Filter Proc Codes
 */
#define MSGF_DIALOGBOX      0
#define MSGF_MESSAGEBOX     1
#define MSGF_MENU           2
#define MSGF_SCROLLBAR      5
#define MSGF_NEXTWINDOW     6
#define MSGF_MAX            8                       // unused
#define MSGF_USER           4096

/*
 * Shell support
 */
#define HSHELL_WINDOWCREATED        1
#define HSHELL_WINDOWDESTROYED      2
#define HSHELL_ACTIVATESHELLWINDOW  3


#define HSHELL_WINDOWACTIVATED      4
#define HSHELL_GETMINRECT           5
#define HSHELL_REDRAW               6
#define HSHELL_TASKMAN              7
#define HSHELL_LANGUAGE             8
#define HSHELL_SYSMENU              9
#define HSHELL_ENDTASK              10


#define HSHELL_ACCESSIBILITYSTATE   11
#define HSHELL_APPCOMMAND           12



#define HSHELL_WINDOWREPLACED       13
#define HSHELL_WINDOWREPLACING      14




#define HSHELL_MONITORCHANGED            16



#define HSHELL_HIGHBIT            0x8000
#define HSHELL_FLASH              (HSHELL_REDRAW|HSHELL_HIGHBIT)
#define HSHELL_RUDEAPPACTIVATED   (HSHELL_WINDOWACTIVATED|HSHELL_HIGHBIT)


/* cmd for HSHELL_APPCOMMAND and WM_APPCOMMAND */
#define APPCOMMAND_BROWSER_BACKWARD       1
#define APPCOMMAND_BROWSER_FORWARD        2
#define APPCOMMAND_BROWSER_REFRESH        3
#define APPCOMMAND_BROWSER_STOP           4
#define APPCOMMAND_BROWSER_SEARCH         5
#define APPCOMMAND_BROWSER_FAVORITES      6
#define APPCOMMAND_BROWSER_HOME           7
#define APPCOMMAND_VOLUME_MUTE            8
#define APPCOMMAND_VOLUME_DOWN            9
#define APPCOMMAND_VOLUME_UP              10
#define APPCOMMAND_MEDIA_NEXTTRACK        11
#define APPCOMMAND_MEDIA_PREVIOUSTRACK    12
#define APPCOMMAND_MEDIA_STOP             13
#define APPCOMMAND_MEDIA_PLAY_PAUSE       14
#define APPCOMMAND_LAUNCH_MAIL            15
#define APPCOMMAND_LAUNCH_MEDIA_SELECT    16
#define APPCOMMAND_LAUNCH_APP1            17
#define APPCOMMAND_LAUNCH_APP2            18
#define APPCOMMAND_BASS_DOWN              19
#define APPCOMMAND_BASS_BOOST             20
#define APPCOMMAND_BASS_UP                21
#define APPCOMMAND_TREBLE_DOWN            22
#define APPCOMMAND_TREBLE_UP              23

#define APPCOMMAND_MICROPHONE_VOLUME_MUTE 24
#define APPCOMMAND_MICROPHONE_VOLUME_DOWN 25
#define APPCOMMAND_MICROPHONE_VOLUME_UP   26
#define APPCOMMAND_HELP                   27
#define APPCOMMAND_FIND                   28
#define APPCOMMAND_NEW                    29
#define APPCOMMAND_OPEN                   30
#define APPCOMMAND_CLOSE                  31
#define APPCOMMAND_SAVE                   32
#define APPCOMMAND_PRINT                  33
#define APPCOMMAND_UNDO                   34
#define APPCOMMAND_REDO                   35
#define APPCOMMAND_COPY                   36
#define APPCOMMAND_CUT                    37
#define APPCOMMAND_PASTE                  38
#define APPCOMMAND_REPLY_TO_MAIL          39
#define APPCOMMAND_FORWARD_MAIL           40
#define APPCOMMAND_SEND_MAIL              41
#define APPCOMMAND_SPELL_CHECK            42
#define APPCOMMAND_DICTATE_OR_COMMAND_CONTROL_TOGGLE    43
#define APPCOMMAND_MIC_ON_OFF_TOGGLE      44
#define APPCOMMAND_CORRECTION_LIST        45
#define APPCOMMAND_MEDIA_PLAY             46
#define APPCOMMAND_MEDIA_PAUSE            47
#define APPCOMMAND_MEDIA_RECORD           48
#define APPCOMMAND_MEDIA_FAST_FORWARD     49
#define APPCOMMAND_MEDIA_REWIND           50
#define APPCOMMAND_MEDIA_CHANNEL_UP       51
#define APPCOMMAND_MEDIA_CHANNEL_DOWN     52


#define APPCOMMAND_DELETE                 53
#define APPCOMMAND_DWM_FLIP3D             54


#define FAPPCOMMAND_MOUSE 0x8000
#define FAPPCOMMAND_KEY   0
#define FAPPCOMMAND_OEM   0x1000
#define FAPPCOMMAND_MASK  0xF000

#define GET_APPCOMMAND_LPARAM(lParam) ((short)(HIWORD(lParam) & ~FAPPCOMMAND_MASK))
#define GET_DEVICE_LPARAM(lParam)     ((WORD)(HIWORD(lParam) & FAPPCOMMAND_MASK))
#define GET_MOUSEORKEY_LPARAM         GET_DEVICE_LPARAM
#define GET_FLAGS_LPARAM(lParam)      (LOWORD(lParam))
#define GET_KEYSTATE_LPARAM(lParam)   GET_FLAGS_LPARAM(lParam)
--]=]

ffi.cdef[[
typedef struct
{
    HWND    hwnd;
    RECT    rc;
} SHELLHOOKINFO, *LPSHELLHOOKINFO;

/*
 * Message Structure used in Journaling
 */
typedef struct tagEVENTMSG {
    UINT    message;
    UINT    paramL;
    UINT    paramH;
    DWORD    time;
    HWND     hwnd;
} EVENTMSG, *PEVENTMSGMSG, *NPEVENTMSGMSG, *LPEVENTMSGMSG;

typedef struct tagEVENTMSG *PEVENTMSG, *NPEVENTMSG, *LPEVENTMSG;
]]

ffi.cdef[[
/*
 * Message structure used by WH_CALLWNDPROC
 */
typedef struct tagCWPSTRUCT {
    LPARAM  lParam;
    WPARAM  wParam;
    UINT    message;
    HWND    hwnd;
} CWPSTRUCT, *PCWPSTRUCT, *NPCWPSTRUCT, *LPCWPSTRUCT;
]]


ffi.cdef[[
/*
 * Message structure used by WH_CALLWNDPROCRET
 */
typedef struct tagCWPRETSTRUCT {
    LRESULT lResult;
    LPARAM  lParam;
    WPARAM  wParam;
    UINT    message;
    HWND    hwnd;
} CWPRETSTRUCT, *PCWPRETSTRUCT, *NPCWPRETSTRUCT, *LPCWPRETSTRUCT;
]]




--[[
/*
 * Low level hook flags
 */

#define LLKHF_EXTENDED       (KF_EXTENDED >> 8) /* 0x00000001 */
#define LLKHF_INJECTED       0x00000010
#define LLKHF_ALTDOWN        (KF_ALTDOWN >> 8) /* 0x00000020 */
#define LLKHF_UP             (KF_UP >> 8)      /* 0x00000080 */
#define LLKHF_LOWER_IL_INJECTED        0x00000002

#define LLMHF_INJECTED       0x00000001
#define LLMHF_LOWER_IL_INJECTED        0x00000002
--]]

ffi.cdef[[
/*
 * Structure used by WH_KEYBOARD_LL
 */
typedef struct tagKBDLLHOOKSTRUCT {
    DWORD   vkCode;
    DWORD   scanCode;
    DWORD   flags;
    DWORD   time;
    ULONG_PTR dwExtraInfo;
} KBDLLHOOKSTRUCT, *LPKBDLLHOOKSTRUCT, *PKBDLLHOOKSTRUCT;
]]

ffi.cdef[[
/*
 * Structure used by WH_MOUSE_LL
 */
typedef struct tagMSLLHOOKSTRUCT {
    POINT   pt;
    DWORD   mouseData;
    DWORD   flags;
    DWORD   time;
    ULONG_PTR dwExtraInfo;
} MSLLHOOKSTRUCT, *LPMSLLHOOKSTRUCT, *PMSLLHOOKSTRUCT;
]]

ffi.cdef[[
/*
 * Structure used by WH_DEBUG
 */
typedef struct tagDEBUGHOOKINFO
{
    DWORD   idThread;
    DWORD   idThreadInstaller;
    LPARAM  lParam;
    WPARAM  wParam;
    int     code;
} DEBUGHOOKINFO, *PDEBUGHOOKINFO, *NPDEBUGHOOKINFO, * LPDEBUGHOOKINFO;
]]

ffi.cdef[[
/*
 * Structure used by WH_MOUSE
 */
typedef struct tagMOUSEHOOKSTRUCT {
    POINT   pt;
    HWND    hwnd;
    UINT    wHitTestCode;
    ULONG_PTR dwExtraInfo;
} MOUSEHOOKSTRUCT, *LPMOUSEHOOKSTRUCT, *PMOUSEHOOKSTRUCT;
]]


ffi.cdef[[
typedef struct tagMOUSEHOOKSTRUCTEX
{
    MOUSEHOOKSTRUCT DUMMYSTRUCTNAME;
    DWORD   mouseData;
} MOUSEHOOKSTRUCTEX, *LPMOUSEHOOKSTRUCTEX, *PMOUSEHOOKSTRUCTEX;
]]


ffi.cdef[[
/*
 * Structure used by WH_HARDWARE
 */
typedef struct tagHARDWAREHOOKSTRUCT {
    HWND    hwnd;
    UINT    message;
    WPARAM  wParam;
    LPARAM  lParam;
} HARDWAREHOOKSTRUCT, *LPHARDWAREHOOKSTRUCT, *PHARDWAREHOOKSTRUCT;
]]

--[=[
/*
 * Keyboard Layout API
 */
#define HKL_PREV            0
#define HKL_NEXT            1


#define KLF_ACTIVATE        0x00000001
#define KLF_SUBSTITUTE_OK   0x00000002
#define KLF_REORDER         0x00000008
#if(WINVER >= 0x0400)
#define KLF_REPLACELANG     0x00000010
#define KLF_NOTELLSHELL     0x00000080
#endif /* WINVER >= 0x0400 */
#define KLF_SETFORPROCESS   0x00000100
#if(_WIN32_WINNT >= 0x0500)
#define KLF_SHIFTLOCK       0x00010000
#define KLF_RESET           0x40000000
#endif /* _WIN32_WINNT >= 0x0500 */


#if(WINVER >= 0x0500)
/*
 * Bits in wParam of WM_INPUTLANGCHANGEREQUEST message
 */
#define INPUTLANGCHANGE_SYSCHARSET 0x0001
#define INPUTLANGCHANGE_FORWARD    0x0002
#define INPUTLANGCHANGE_BACKWARD   0x0004
#endif /* WINVER >= 0x0500 */
--]=]

ffi.cdef[[
/*
 * Size of KeyboardLayoutName (number of characters), including nul terminator
 */
static const int KL_NAMELENGTH = 9;


HKL
__stdcall
LoadKeyboardLayoutA(
     LPCSTR pwszKLID,
     UINT Flags);

HKL
__stdcall
LoadKeyboardLayoutW(
     LPCWSTR pwszKLID,
     UINT Flags);
]]

if UNICODE then
exports.LoadKeyboardLayout  = ffi.C.LoadKeyboardLayoutW;
else
exports.LoadKeyboardLayout  = ffi.C.LoadKeyboardLayoutA;
end



ffi.cdef[[
HKL
__stdcall
ActivateKeyboardLayout(
     HKL hkl,
     UINT Flags);

int
__stdcall
ToUnicodeEx(
     UINT wVirtKey,
     UINT wScanCode,
    const BYTE *lpKeyState,
    LPWSTR pwszBuff,
     int cchBuff,
     UINT wFlags,
     HKL dwhkl);



BOOL
__stdcall
UnloadKeyboardLayout(
     HKL hkl);


BOOL
__stdcall
GetKeyboardLayoutNameA(
    LPSTR pwszKLID);

BOOL
__stdcall
GetKeyboardLayoutNameW(
    LPWSTR pwszKLID);
]]

--[=[
#ifdef UNICODE
#define GetKeyboardLayoutName  GetKeyboardLayoutNameW
#else
#define GetKeyboardLayoutName  GetKeyboardLayoutNameA
#endif // !UNICODE

#if(WINVER >= 0x0400)

int
__stdcall
GetKeyboardLayoutList(
     int nBuff,
    HKL *lpList);


HKL
__stdcall
GetKeyboardLayout(
     DWORD idThread);



typedef struct tagMOUSEMOVEPOINT {
    int   x;
    int   y;
    DWORD time;
    ULONG_PTR dwExtraInfo;
} MOUSEMOVEPOINT, *PMOUSEMOVEPOINT, FAR* LPMOUSEMOVEPOINT;


/*
 * Values for resolution parameter of GetMouseMovePointsEx
 */
#define GMMP_USE_DISPLAY_POINTS          1
#define GMMP_USE_HIGH_RESOLUTION_POINTS  2


int
__stdcall
GetMouseMovePointsEx(
     UINT cbSize,
     LPMOUSEMOVEPOINT lppt,
    LPMOUSEMOVEPOINT lpptBuf,
     int nBufPoints,
     DWORD resolution);


#ifndef NODESKTOP
/*
 * Desktop-specific access flags
 */
#define DESKTOP_READOBJECTS         0x0001L
#define DESKTOP_CREATEWINDOW        0x0002L
#define DESKTOP_CREATEMENU          0x0004L
#define DESKTOP_HOOKCONTROL         0x0008L
#define DESKTOP_JOURNALRECORD       0x0010L
#define DESKTOP_JOURNALPLAYBACK     0x0020L
#define DESKTOP_ENUMERATE           0x0040L
#define DESKTOP_WRITEOBJECTS        0x0080L
#define DESKTOP_SWITCHDESKTOP       0x0100L

/*
 * Desktop-specific control flags
 */
#define DF_ALLOWOTHERACCOUNTHOOK    0x0001L

#ifdef _WINGDI_
#ifndef NOGDI


HDESK
__stdcall
CreateDesktopA(
     LPCSTR lpszDesktop,
    LPCSTR lpszDevice,
    DEVMODEA* pDevmode,
     DWORD dwFlags,
     ACCESS_MASK dwDesiredAccess,
     LPSECURITY_ATTRIBUTES lpsa);

HDESK
__stdcall
CreateDesktopW(
     LPCWSTR lpszDesktop,
    LPCWSTR lpszDevice,
    DEVMODEW* pDevmode,
     DWORD dwFlags,
     ACCESS_MASK dwDesiredAccess,
     LPSECURITY_ATTRIBUTES lpsa);
#ifdef UNICODE
#define CreateDesktop  CreateDesktopW
#else
#define CreateDesktop  CreateDesktopA
#endif // !UNICODE


HDESK
__stdcall
CreateDesktopExA(
     LPCSTR lpszDesktop,
    LPCSTR lpszDevice,
    DEVMODEA* pDevmode,
     DWORD dwFlags,
     ACCESS_MASK dwDesiredAccess,
     LPSECURITY_ATTRIBUTES lpsa,
     ULONG ulHeapSize,
    PVOID pvoid);

HDESK
__stdcall
CreateDesktopExW(
     LPCWSTR lpszDesktop,
    LPCWSTR lpszDevice,
    DEVMODEW* pDevmode,
     DWORD dwFlags,
     ACCESS_MASK dwDesiredAccess,
     LPSECURITY_ATTRIBUTES lpsa,
     ULONG ulHeapSize,
    PVOID pvoid);
#ifdef UNICODE
#define CreateDesktopEx  CreateDesktopExW
#else
#define CreateDesktopEx  CreateDesktopExA
#endif // !UNICODE


#endif /* NOGDI */
#endif /* _WINGDI_ */


HDESK
__stdcall
OpenDesktopA(
     LPCSTR lpszDesktop,
     DWORD dwFlags,
     BOOL fInherit,
     ACCESS_MASK dwDesiredAccess);

HDESK
__stdcall
OpenDesktopW(
     LPCWSTR lpszDesktop,
     DWORD dwFlags,
     BOOL fInherit,
     ACCESS_MASK dwDesiredAccess);
#ifdef UNICODE
#define OpenDesktop  OpenDesktopW
#else
#define OpenDesktop  OpenDesktopA
#endif // !UNICODE


HDESK
__stdcall
OpenInputDesktop(
     DWORD dwFlags,
     BOOL fInherit,
     ACCESS_MASK dwDesiredAccess);



BOOL
__stdcall
EnumDesktopsA(
     HWINSTA hwinsta,
     DESKTOPENUMPROCA lpEnumFunc,
     LPARAM lParam);

BOOL
__stdcall
EnumDesktopsW(
     HWINSTA hwinsta,
     DESKTOPENUMPROCW lpEnumFunc,
     LPARAM lParam);
#ifdef UNICODE
#define EnumDesktops  EnumDesktopsW
#else
#define EnumDesktops  EnumDesktopsA
#endif // !UNICODE


BOOL
__stdcall
EnumDesktopWindows(
     HDESK hDesktop,
     WNDENUMPROC lpfn,
     LPARAM lParam);



BOOL
__stdcall
SwitchDesktop(
     HDESK hDesktop);



BOOL
__stdcall
SetThreadDesktop(
      HDESK hDesktop);


BOOL
__stdcall
CloseDesktop(
     HDESK hDesktop);


HDESK
__stdcall
GetThreadDesktop(
     DWORD dwThreadId);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif  /* !NODESKTOP */

#ifndef NOWINDOWSTATION
/*
 * Windowstation-specific access flags
 */
#define WINSTA_ENUMDESKTOPS         0x0001L
#define WINSTA_READATTRIBUTES       0x0002L
#define WINSTA_ACCESSCLIPBOARD      0x0004L
#define WINSTA_CREATEDESKTOP        0x0008L
#define WINSTA_WRITEATTRIBUTES      0x0010L
#define WINSTA_ACCESSGLOBALATOMS    0x0020L
#define WINSTA_EXITWINDOWS          0x0040L
#define WINSTA_ENUMERATE            0x0100L
#define WINSTA_READSCREEN           0x0200L

#define WINSTA_ALL_ACCESS           (WINSTA_ENUMDESKTOPS  | WINSTA_READATTRIBUTES  | WINSTA_ACCESSCLIPBOARD | \
                                     WINSTA_CREATEDESKTOP | WINSTA_WRITEATTRIBUTES | WINSTA_ACCESSGLOBALATOMS | \
                                     WINSTA_EXITWINDOWS   | WINSTA_ENUMERATE       | WINSTA_READSCREEN)

/*
 * Windowstation creation flags.
 */
#define CWF_CREATE_ONLY          0x00000001

/*
 * Windowstation-specific attribute flags
 */
#define WSF_VISIBLE                 0x0001L

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


HWINSTA
__stdcall
CreateWindowStationA(
     LPCSTR lpwinsta,
     DWORD dwFlags,
     ACCESS_MASK dwDesiredAccess,
     LPSECURITY_ATTRIBUTES lpsa);

HWINSTA
__stdcall
CreateWindowStationW(
     LPCWSTR lpwinsta,
     DWORD dwFlags,
     ACCESS_MASK dwDesiredAccess,
     LPSECURITY_ATTRIBUTES lpsa);
#ifdef UNICODE
#define CreateWindowStation  CreateWindowStationW
#else
#define CreateWindowStation  CreateWindowStationA
#endif // !UNICODE


HWINSTA
__stdcall
OpenWindowStationA(
     LPCSTR lpszWinSta,
     BOOL fInherit,
     ACCESS_MASK dwDesiredAccess);

HWINSTA
__stdcall
OpenWindowStationW(
     LPCWSTR lpszWinSta,
     BOOL fInherit,
     ACCESS_MASK dwDesiredAccess);
#ifdef UNICODE
#define OpenWindowStation  OpenWindowStationW
#else
#define OpenWindowStation  OpenWindowStationA
#endif // !UNICODE


BOOL
__stdcall
EnumWindowStationsA(
     WINSTAENUMPROCA lpEnumFunc,
     LPARAM lParam);

BOOL
__stdcall
EnumWindowStationsW(
     WINSTAENUMPROCW lpEnumFunc,
     LPARAM lParam);
#ifdef UNICODE
#define EnumWindowStations  EnumWindowStationsW
#else
#define EnumWindowStations  EnumWindowStationsA
#endif // !UNICODE


BOOL
__stdcall
CloseWindowStation(
     HWINSTA hWinSta);


BOOL
__stdcall
SetProcessWindowStation(
     HWINSTA hWinSta);


HWINSTA
__stdcall
GetProcessWindowStation(
    VOID);



BOOL
__stdcall
SetUserObjectSecurity(
     HANDLE hObj,
     PSECURITY_INFORMATION pSIRequested,
     PSECURITY_DESCRIPTOR pSID);


BOOL
__stdcall
GetUserObjectSecurity(
     HANDLE hObj,
     PSECURITY_INFORMATION pSIRequested,
    _Out_writes_bytes_opt_(nLength) PSECURITY_DESCRIPTOR pSID,
     DWORD nLength,
     LPDWORD lpnLengthNeeded);



#define UOI_FLAGS       1
#define UOI_NAME        2
#define UOI_TYPE        3
#define UOI_USER_SID    4
#if(WINVER >= 0x0600)
#define UOI_HEAPSIZE    5
#define UOI_IO          6
#endif /* WINVER >= 0x0600 */
#define UOI_TIMERPROC_EXCEPTION_SUPPRESSION       7


typedef struct tagUSEROBJECTFLAGS {
    BOOL fInherit;
    BOOL fReserved;
    DWORD dwFlags;
} USEROBJECTFLAGS, *PUSEROBJECTFLAGS;


BOOL
__stdcall
GetUserObjectInformationA(
     HANDLE hObj,
     int nIndex,
    _Out_writes_bytes_opt_(nLength) PVOID pvInfo,
     DWORD nLength,
    _Out_opt_ LPDWORD lpnLengthNeeded);

BOOL
__stdcall
GetUserObjectInformationW(
     HANDLE hObj,
     int nIndex,
    _Out_writes_bytes_opt_(nLength) PVOID pvInfo,
     DWORD nLength,
    _Out_opt_ LPDWORD lpnLengthNeeded);
#ifdef UNICODE
#define GetUserObjectInformation  GetUserObjectInformationW
#else
#define GetUserObjectInformation  GetUserObjectInformationA
#endif // !UNICODE


BOOL
__stdcall
SetUserObjectInformationA(
     HANDLE hObj,
     int nIndex,
    _In_reads_bytes_(nLength) PVOID pvInfo,
     DWORD nLength);

BOOL
__stdcall
SetUserObjectInformationW(
     HANDLE hObj,
     int nIndex,
    _In_reads_bytes_(nLength) PVOID pvInfo,
     DWORD nLength);
#ifdef UNICODE
#define SetUserObjectInformation  SetUserObjectInformationW
#else
#define SetUserObjectInformation  SetUserObjectInformationA
#endif // !UNICODE
--]=]

ffi.cdef[[
typedef struct tagWNDCLASSEXA {
    UINT        cbSize;
    /* Win 3.x */
    UINT        style;
    WNDPROC     lpfnWndProc;
    int         cbClsExtra;
    int         cbWndExtra;
    HINSTANCE   hInstance;
    HICON       hIcon;
    HCURSOR     hCursor;
    HBRUSH      hbrBackground;
    LPCSTR      lpszMenuName;
    LPCSTR      lpszClassName;
    /* Win 4.0 */
    HICON       hIconSm;
} WNDCLASSEXA, *PWNDCLASSEXA, *NPWNDCLASSEXA, *LPWNDCLASSEXA;

typedef struct tagWNDCLASSEXW {
    UINT        cbSize;
    /* Win 3.x */
    UINT        style;
    WNDPROC     lpfnWndProc;
    int         cbClsExtra;
    int         cbWndExtra;
    HINSTANCE   hInstance;
    HICON       hIcon;
    HCURSOR     hCursor;
    HBRUSH      hbrBackground;
    LPCWSTR     lpszMenuName;
    LPCWSTR     lpszClassName;
    /* Win 4.0 */
    HICON       hIconSm;
} WNDCLASSEXW, *PWNDCLASSEXW, *NPWNDCLASSEXW, *LPWNDCLASSEXW;
]]

if UNICODE then
ffi.cdef[[
typedef WNDCLASSEXW WNDCLASSEX;
typedef PWNDCLASSEXW PWNDCLASSEX;
typedef NPWNDCLASSEXW NPWNDCLASSEX;
typedef LPWNDCLASSEXW LPWNDCLASSEX;
]]
else
ffi.cdef[[
typedef WNDCLASSEXA WNDCLASSEX;
typedef PWNDCLASSEXA PWNDCLASSEX;
typedef NPWNDCLASSEXA NPWNDCLASSEX;
typedef LPWNDCLASSEXA LPWNDCLASSEX;
]]
end -- UNICODE

ffi.cdef[[
typedef struct tagWNDCLASSA {
    UINT        style;
    WNDPROC     lpfnWndProc;
    int         cbClsExtra;
    int         cbWndExtra;
    HINSTANCE   hInstance;
    HICON       hIcon;
    HCURSOR     hCursor;
    HBRUSH      hbrBackground;
    LPCSTR      lpszMenuName;
    LPCSTR      lpszClassName;
} WNDCLASSA, *PWNDCLASSA, *NPWNDCLASSA, *LPWNDCLASSA;

typedef struct tagWNDCLASSW {
    UINT        style;
    WNDPROC     lpfnWndProc;
    int         cbClsExtra;
    int         cbWndExtra;
    HINSTANCE   hInstance;
    HICON       hIcon;
    HCURSOR     hCursor;
    HBRUSH      hbrBackground;
    LPCWSTR     lpszMenuName;
    LPCWSTR     lpszClassName;
} WNDCLASSW, *PWNDCLASSW, *NPWNDCLASSW, *LPWNDCLASSW;
]]


if UNICODE then
ffi.cdef[[
typedef WNDCLASSW WNDCLASS;
typedef PWNDCLASSW PWNDCLASS;
typedef NPWNDCLASSW NPWNDCLASS;
typedef LPWNDCLASSW LPWNDCLASS;
]]
else
ffi.cdef[[
typedef WNDCLASSA WNDCLASS;
typedef PWNDCLASSA PWNDCLASS;
typedef NPWNDCLASSA NPWNDCLASS;
typedef LPWNDCLASSA LPWNDCLASS;
]]
end -- UNICODE

ffi.cdef[[
BOOL __stdcall IsHungAppWindow(HWND hwnd);

void __stdcall DisableProcessWindowsGhosting();
]]

ffi.cdef[[
/*
 * Message structure
 */
typedef struct tagMSG {
    HWND        hwnd;
    UINT        message;
    WPARAM      wParam;
    LPARAM      lParam;
    DWORD       time;
    POINT       pt;
//#ifdef _MAC
//    DWORD       lPrivate;
//#endif
} MSG, *PMSG, *NPMSG, *LPMSG;
]]

--[[
#define POINTSTOPOINT(pt, pts)                          \
        { (pt).x = (LONG)(SHORT)LOWORD(*(LONG*)&pts);   \
          (pt).y = (LONG)(SHORT)HIWORD(*(LONG*)&pts); }

#define POINTTOPOINTS(pt)      (MAKELONG((short)((pt).x), (short)((pt).y)))
#define MAKEWPARAM(l, h)      ((WPARAM)(DWORD)MAKELONG(l, h))
#define MAKELPARAM(l, h)      ((LPARAM)(DWORD)MAKELONG(l, h))
#define MAKELRESULT(l, h)     ((LRESULT)(DWORD)MAKELONG(l, h))
--]]

--[[
/*
 * Window field offsets for GetWindowLong()
 */
#define GWL_WNDPROC         (-4)
#define GWL_HINSTANCE       (-6)
#define GWL_HWNDPARENT      (-8)
#define GWL_STYLE           (-16)
#define GWL_EXSTYLE         (-20)
#define GWL_USERDATA        (-21)
#define GWL_ID              (-12)

#ifdef _WIN64

#undef GWL_WNDPROC
#undef GWL_HINSTANCE
#undef GWL_HWNDPARENT
#undef GWL_USERDATA

#endif /* _WIN64 */



#define GWLP_WNDPROC        (-4)
#define GWLP_HINSTANCE      (-6)
#define GWLP_HWNDPARENT     (-8)
#define GWLP_USERDATA       (-21)
#define GWLP_ID             (-12)
--]]

--[=[
/*
 * Class field offsets for GetClassLong()
 */
#define GCL_MENUNAME        (-8)
#define GCL_HBRBACKGROUND   (-10)
#define GCL_HCURSOR         (-12)
#define GCL_HICON           (-14)
#define GCL_HMODULE         (-16)
#define GCL_CBWNDEXTRA      (-18)
#define GCL_CBCLSEXTRA      (-20)
#define GCL_WNDPROC         (-24)
#define GCL_STYLE           (-26)
#define GCW_ATOM            (-32)


#define GCL_HICONSM         (-34)


#ifdef _WIN64

#undef GCL_MENUNAME
#undef GCL_HBRBACKGROUND
#undef GCL_HCURSOR
#undef GCL_HICON
#undef GCL_HMODULE
#undef GCL_WNDPROC
#undef GCL_HICONSM

#endif /* _WIN64 */

#define GCLP_MENUNAME       (-8)
#define GCLP_HBRBACKGROUND  (-10)
#define GCLP_HCURSOR        (-12)
#define GCLP_HICON          (-14)
#define GCLP_HMODULE        (-16)
#define GCLP_WNDPROC        (-24)
#define GCLP_HICONSM        (-34)
--]=]

ffi.cdef[[
/*
 * Window Messages
 */

static const int WM_NULL                        = 0x0000;
static const int WM_CREATE                      = 0x0001;
static const int WM_DESTROY                     = 0x0002;
static const int WM_MOVE                        = 0x0003;
static const int WM_SIZE                        = 0x0005;

static const int WM_ACTIVATE                    = 0x0006;
/*
 * WM_ACTIVATE state values
 */
static const int    WA_INACTIVE    = 0;
static const int    WA_ACTIVE      = 1;
static const int    WA_CLICKACTIVE = 2;

static const int WM_SETFOCUS                   =  0x0007;
static const int WM_KILLFOCUS                  =  0x0008;
static const int WM_ENABLE                     =  0x000A;
static const int WM_SETREDRAW                  =  0x000B;
static const int WM_SETTEXT                    =  0x000C;
static const int WM_GETTEXT                    =  0x000D;
static const int WM_GETTEXTLENGTH              =  0x000E;
static const int WM_PAINT                      =  0x000F;
static const int WM_CLOSE                      =  0x0010;

static const int WM_QUERYENDSESSION            =  0x0011;
static const int WM_QUERYOPEN                  =  0x0013;
static const int WM_ENDSESSION                 =  0x0016;

static const int WM_QUIT                       =  0x0012;
static const int WM_ERASEBKGND                 =  0x0014;
static const int WM_SYSCOLORCHANGE             =  0x0015;
static const int WM_SHOWWINDOW                 =  0x0018;
static const int WM_WININICHANGE               =  0x001A;

static const int WM_SETTINGCHANGE              =  WM_WININICHANGE;



static const int WM_DEVMODECHANGE              =  0x001B;
static const int WM_ACTIVATEAPP                =  0x001C;
static const int WM_FONTCHANGE                 =  0x001D;
static const int WM_TIMECHANGE                 =  0x001E;
static const int WM_CANCELMODE                 =  0x001F;
static const int WM_SETCURSOR                  =  0x0020;
static const int WM_MOUSEACTIVATE              =  0x0021;
static const int WM_CHILDACTIVATE              =  0x0022;
static const int WM_QUEUESYNC                  =  0x0023;

static const int WM_GETMINMAXINFO              =  0x0024;
]]

ffi.cdef[[
/*
 * Struct pointed to by WM_GETMINMAXINFO lParam
 */
typedef struct tagMINMAXINFO {
    POINT ptReserved;
    POINT ptMaxSize;
    POINT ptMaxPosition;
    POINT ptMinTrackSize;
    POINT ptMaxTrackSize;
} MINMAXINFO, *PMINMAXINFO, *LPMINMAXINFO;
]]

ffi.cdef[[
static const int WM_PAINTICON                   = 0x0026;
static const int WM_ICONERASEBKGND              = 0x0027;
static const int WM_NEXTDLGCTL                  = 0x0028;
static const int WM_SPOOLERSTATUS               = 0x002A;
static const int WM_DRAWITEM                    = 0x002B;
static const int WM_MEASUREITEM                 = 0x002C;
static const int WM_DELETEITEM                  = 0x002D;
static const int WM_VKEYTOITEM                  = 0x002E;
static const int WM_CHARTOITEM                  = 0x002F;
static const int WM_SETFONT                     = 0x0030;
static const int WM_GETFONT                     = 0x0031;
static const int WM_SETHOTKEY                   = 0x0032;
static const int WM_GETHOTKEY                   = 0x0033;
static const int WM_QUERYDRAGICON               = 0x0037;
static const int WM_COMPAREITEM                 = 0x0039;

static const int WM_GETOBJECT                   = 0x003D;

static const int WM_COMPACTING                  = 0x0041;
static const int WM_COMMNOTIFY                  = 0x0044;  /* no longer suported */
static const int WM_WINDOWPOSCHANGING           = 0x0046;
static const int WM_WINDOWPOSCHANGED            = 0x0047;

static const int WM_POWER                       = 0x0048;
]]

ffi.cdef[[
/*
 * wParam for WM_POWER window message and DRV_POWER driver notification
 */
static const int PWR_OK             = 1;
static const int PWR_FAIL           = (-1);
static const int PWR_SUSPENDREQUEST = 1;
static const int PWR_SUSPENDRESUME  = 2;
static const int PWR_CRITICALRESUME = 3;

static const int WM_COPYDATA                     = 0x004A;
static const int WM_CANCELJOURNAL                = 0x004B;


/*
 * lParam of WM_COPYDATA message points to...
 */
typedef struct tagCOPYDATASTRUCT {
    ULONG_PTR dwData;
    DWORD cbData;
    PVOID lpData;
} COPYDATASTRUCT, *PCOPYDATASTRUCT;


typedef struct tagMDINEXTMENU
{
    HMENU   hmenuIn;
    HMENU   hmenuNext;
    HWND    hwndNext;
} MDINEXTMENU, * PMDINEXTMENU, * LPMDINEXTMENU;


static const int WM_NOTIFY                       = 0x004E;
static const int WM_INPUTLANGCHANGEREQUEST       = 0x0050;
static const int WM_INPUTLANGCHANGE              = 0x0051;
static const int WM_TCARD                        = 0x0052;
static const int WM_HELP                         = 0x0053;
static const int WM_USERCHANGED                  = 0x0054;
static const int WM_NOTIFYFORMAT                 = 0x0055;

static const int NFR_ANSI                        =     1;
static const int NFR_UNICODE                     =     2;
static const int NF_QUERY                        =     3;
static const int NF_REQUERY                      =     4;

static const int WM_CONTEXTMENU                  = 0x007B;
static const int WM_STYLECHANGING                = 0x007C;
static const int WM_STYLECHANGED                 = 0x007D;
static const int WM_DISPLAYCHANGE                = 0x007E;
static const int WM_GETICON                      = 0x007F;
static const int WM_SETICON                      = 0x0080;


static const int WM_NCCREATE                     = 0x0081;
static const int WM_NCDESTROY                    = 0x0082;
static const int WM_NCCALCSIZE                   = 0x0083;
static const int WM_NCHITTEST                    = 0x0084;
static const int WM_NCPAINT                      = 0x0085;
static const int WM_NCACTIVATE                   = 0x0086;
static const int WM_GETDLGCODE                   = 0x0087;

static const int WM_SYNCPAINT                    = 0x0088;

static const int WM_NCMOUSEMOVE                  = 0x00A0;
static const int WM_NCLBUTTONDOWN                = 0x00A1;
static const int WM_NCLBUTTONUP                  = 0x00A2;
static const int WM_NCLBUTTONDBLCLK              = 0x00A3;
static const int WM_NCRBUTTONDOWN                = 0x00A4;
static const int WM_NCRBUTTONUP                  = 0x00A5;
static const int WM_NCRBUTTONDBLCLK              = 0x00A6;
static const int WM_NCMBUTTONDOWN                = 0x00A7;
static const int WM_NCMBUTTONUP                  = 0x00A8;
static const int WM_NCMBUTTONDBLCLK              = 0x00A9;

static const int WM_NCXBUTTONDOWN                = 0x00AB;
static const int WM_NCXBUTTONUP                  = 0x00AC;
static const int WM_NCXBUTTONDBLCLK              = 0x00AD;




static const int WM_INPUT_DEVICE_CHANGE          = 0x00FE;



static const int WM_INPUT                        = 0x00FF;


static const int WM_KEYFIRST                     = 0x0100;
static const int WM_KEYDOWN                      = 0x0100;
static const int WM_KEYUP                        = 0x0101;
static const int WM_CHAR                         = 0x0102;
static const int WM_DEADCHAR                     = 0x0103;
static const int WM_SYSKEYDOWN                   = 0x0104;
static const int WM_SYSKEYUP                     = 0x0105;
static const int WM_SYSCHAR                      = 0x0106;
static const int WM_SYSDEADCHAR                  = 0x0107;

static const int WM_UNICHAR                      = 0x0109;
static const int WM_KEYLAST                      = 0x0109;
static const int UNICODE_NOCHAR                  = 0xFFFF;

//static const int WM_KEYLAST                      = 0x0108;



static const int WM_IME_STARTCOMPOSITION         = 0x010D;
static const int WM_IME_ENDCOMPOSITION           = 0x010E;
static const int WM_IME_COMPOSITION              = 0x010F;
static const int WM_IME_KEYLAST                  = 0x010F;


static const int WM_INITDIALOG                   = 0x0110;
static const int WM_COMMAND                      = 0x0111;
static const int WM_SYSCOMMAND                   = 0x0112;
static const int WM_TIMER                        = 0x0113;
static const int WM_HSCROLL                      = 0x0114;
static const int WM_VSCROLL                      = 0x0115;
static const int WM_INITMENU                     = 0x0116;
static const int WM_INITMENUPOPUP                = 0x0117;

static const int WM_GESTURE                      = 0x0119;
static const int WM_GESTURENOTIFY                = 0x011A;

static const int WM_MENUSELECT                   = 0x011F;
static const int WM_MENUCHAR                     = 0x0120;
static const int WM_ENTERIDLE                    = 0x0121;

static const int WM_MENURBUTTONUP                = 0x0122;
static const int WM_MENUDRAG                     = 0x0123;
static const int WM_MENUGETOBJECT                = 0x0124;
static const int WM_UNINITMENUPOPUP              = 0x0125;
static const int WM_MENUCOMMAND                  = 0x0126;


static const int WM_CHANGEUISTATE                = 0x0127;
static const int WM_UPDATEUISTATE                = 0x0128;
static const int WM_QUERYUISTATE                 = 0x0129;



/*
 * LOWORD(wParam) values in WM_*UISTATE*
 */
static const int UIS_SET                        = 1;
static const int UIS_CLEAR                      = 2;
static const int UIS_INITIALIZE                 = 3;

/*
 * HIWORD(wParam) values in WM_*UISTATE*
 */
 static const int UISF_HIDEFOCUS                 = 0x1;
 static const int UISF_HIDEACCEL                 = 0x2;

 static const int UISF_ACTIVE                    = 0x4;
]]

--[=[
#define WM_CTLCOLORMSGBOX               0x0132
#define WM_CTLCOLOREDIT                 0x0133
#define WM_CTLCOLORLISTBOX              0x0134
#define WM_CTLCOLORBTN                  0x0135
#define WM_CTLCOLORDLG                  0x0136
#define WM_CTLCOLORSCROLLBAR            0x0137
#define WM_CTLCOLORSTATIC               0x0138
#define MN_GETHMENU                     0x01E1

#define WM_MOUSEFIRST                   0x0200
#define WM_MOUSEMOVE                    0x0200
#define WM_LBUTTONDOWN                  0x0201
#define WM_LBUTTONUP                    0x0202
#define WM_LBUTTONDBLCLK                0x0203
#define WM_RBUTTONDOWN                  0x0204
#define WM_RBUTTONUP                    0x0205
#define WM_RBUTTONDBLCLK                0x0206
#define WM_MBUTTONDOWN                  0x0207
#define WM_MBUTTONUP                    0x0208
#define WM_MBUTTONDBLCLK                0x0209
#if (_WIN32_WINNT >= 0x0400) || (_WIN32_WINDOWS > 0x0400)
#define WM_MOUSEWHEEL                   0x020A
#endif
#if (_WIN32_WINNT >= 0x0500)
#define WM_XBUTTONDOWN                  0x020B
#define WM_XBUTTONUP                    0x020C
#define WM_XBUTTONDBLCLK                0x020D
#endif
#if (_WIN32_WINNT >= 0x0600)
#define WM_MOUSEHWHEEL                  0x020E
#endif

#if (_WIN32_WINNT >= 0x0600)
#define WM_MOUSELAST                    0x020E
#elif (_WIN32_WINNT >= 0x0500)
#define WM_MOUSELAST                    0x020D
#elif (_WIN32_WINNT >= 0x0400) || (_WIN32_WINDOWS > 0x0400)
#define WM_MOUSELAST                    0x020A
#else
#define WM_MOUSELAST                    0x0209
#endif /* (_WIN32_WINNT >= 0x0600) */


#if(_WIN32_WINNT >= 0x0400)
/* Value for rolling one detent */
#define WHEEL_DELTA                     120
#define GET_WHEEL_DELTA_WPARAM(wParam)  ((short)HIWORD(wParam))

/* Setting to scroll one page for SPI_GET/SETWHEELSCROLLLINES */
#define WHEEL_PAGESCROLL                (UINT_MAX)
#endif /* _WIN32_WINNT >= 0x0400 */

#if(_WIN32_WINNT >= 0x0500)
#define GET_KEYSTATE_WPARAM(wParam)     (LOWORD(wParam))
#define GET_NCHITTEST_WPARAM(wParam)    ((short)LOWORD(wParam))
#define GET_XBUTTON_WPARAM(wParam)      (HIWORD(wParam))

/* XButton values are WORD flags */
#define XBUTTON1      0x0001
#define XBUTTON2      0x0002
/* Were there to be an XBUTTON3, its value would be 0x0004 */
#endif /* _WIN32_WINNT >= 0x0500 */

#define WM_PARENTNOTIFY                 0x0210
#define WM_ENTERMENULOOP                0x0211
#define WM_EXITMENULOOP                 0x0212

#if(WINVER >= 0x0400)
#define WM_NEXTMENU                     0x0213
#define WM_SIZING                       0x0214
#define WM_CAPTURECHANGED               0x0215
#define WM_MOVING                       0x0216
#endif /* WINVER >= 0x0400 */

#if(WINVER >= 0x0400)


#define WM_POWERBROADCAST               0x0218

#ifndef _WIN32_WCE
#define PBT_APMQUERYSUSPEND             0x0000
#define PBT_APMQUERYSTANDBY             0x0001

#define PBT_APMQUERYSUSPENDFAILED       0x0002
#define PBT_APMQUERYSTANDBYFAILED       0x0003

#define PBT_APMSUSPEND                  0x0004
#define PBT_APMSTANDBY                  0x0005

#define PBT_APMRESUMECRITICAL           0x0006
#define PBT_APMRESUMESUSPEND            0x0007
#define PBT_APMRESUMESTANDBY            0x0008

#define PBTF_APMRESUMEFROMFAILURE       0x00000001

#define PBT_APMBATTERYLOW               0x0009
#define PBT_APMPOWERSTATUSCHANGE        0x000A

#define PBT_APMOEMEVENT                 0x000B


#define PBT_APMRESUMEAUTOMATIC          0x0012
#if (_WIN32_WINNT >= 0x0502)
#ifndef PBT_POWERSETTINGCHANGE
#define PBT_POWERSETTINGCHANGE          0x8013

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

typedef struct {
    GUID PowerSetting;
    DWORD DataLength;
    UCHAR Data[1];
} POWERBROADCAST_SETTING, *PPOWERBROADCAST_SETTING;


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif // PBT_POWERSETTINGCHANGE

#endif // (_WIN32_WINNT >= 0x0502)
#endif

#endif /* WINVER >= 0x0400 */

#if(WINVER >= 0x0400)
#define WM_DEVICECHANGE                 0x0219
#endif /* WINVER >= 0x0400 */

#define WM_MDICREATE                    0x0220
#define WM_MDIDESTROY                   0x0221
#define WM_MDIACTIVATE                  0x0222
#define WM_MDIRESTORE                   0x0223
#define WM_MDINEXT                      0x0224
#define WM_MDIMAXIMIZE                  0x0225
#define WM_MDITILE                      0x0226
#define WM_MDICASCADE                   0x0227
#define WM_MDIICONARRANGE               0x0228
#define WM_MDIGETACTIVE                 0x0229


#define WM_MDISETMENU                   0x0230
#define WM_ENTERSIZEMOVE                0x0231
#define WM_EXITSIZEMOVE                 0x0232
#define WM_DROPFILES                    0x0233
#define WM_MDIREFRESHMENU               0x0234

#if(WINVER >= 0x0602)
#define WM_POINTERDEVICECHANGE          0x238
#define WM_POINTERDEVICEINRANGE         0x239
#define WM_POINTERDEVICEOUTOFRANGE      0x23A
#endif /* WINVER >= 0x0602 */


#if(WINVER >= 0x0601)
#define WM_TOUCH                        0x0240
#endif /* WINVER >= 0x0601 */

#if(WINVER >= 0x0602)
#define WM_NCPOINTERUPDATE              0x0241
#define WM_NCPOINTERDOWN                0x0242
#define WM_NCPOINTERUP                  0x0243
#define WM_POINTERUPDATE                0x0245
#define WM_POINTERDOWN                  0x0246
#define WM_POINTERUP                    0x0247
#define WM_POINTERENTER                 0x0249
#define WM_POINTERLEAVE                 0x024A
#define WM_POINTERACTIVATE              0x024B
#define WM_POINTERCAPTURECHANGED        0x024C
#define WM_TOUCHHITTESTING              0x024D
#define WM_POINTERWHEEL                 0x024E
#define WM_POINTERHWHEEL                0x024F
#define DM_POINTERHITTEST               0x0250
#define WM_POINTERROUTEDTO              0x0251
#define WM_POINTERROUTEDAWAY            0x0252
#define WM_POINTERROUTEDRELEASED        0x0253
#endif /* WINVER >= 0x0602 */


#if(WINVER >= 0x0400)
#define WM_IME_SETCONTEXT               0x0281
#define WM_IME_NOTIFY                   0x0282
#define WM_IME_CONTROL                  0x0283
#define WM_IME_COMPOSITIONFULL          0x0284
#define WM_IME_SELECT                   0x0285
#define WM_IME_CHAR                     0x0286
#endif /* WINVER >= 0x0400 */
#if(WINVER >= 0x0500)
#define WM_IME_REQUEST                  0x0288
#endif /* WINVER >= 0x0500 */
#if(WINVER >= 0x0400)
#define WM_IME_KEYDOWN                  0x0290
#define WM_IME_KEYUP                    0x0291
#endif /* WINVER >= 0x0400 */

#if((_WIN32_WINNT >= 0x0400) || (WINVER >= 0x0500))
#define WM_MOUSEHOVER                   0x02A1
#define WM_MOUSELEAVE                   0x02A3
#endif
#if(WINVER >= 0x0500)
#define WM_NCMOUSEHOVER                 0x02A0
#define WM_NCMOUSELEAVE                 0x02A2
#endif /* WINVER >= 0x0500 */

#if(_WIN32_WINNT >= 0x0501)
#define WM_WTSSESSION_CHANGE            0x02B1

#define WM_TABLET_FIRST                 0x02c0
#define WM_TABLET_LAST                  0x02df
#endif /* _WIN32_WINNT >= 0x0501 */

#if(WINVER >= 0x0601)
#define WM_DPICHANGED                   0x02E0
#endif /* WINVER >= 0x0601 */

#define WM_CUT                          0x0300
#define WM_COPY                         0x0301
#define WM_PASTE                        0x0302
#define WM_CLEAR                        0x0303
#define WM_UNDO                         0x0304
#define WM_RENDERFORMAT                 0x0305
#define WM_RENDERALLFORMATS             0x0306
#define WM_DESTROYCLIPBOARD             0x0307
#define WM_DRAWCLIPBOARD                0x0308
#define WM_PAINTCLIPBOARD               0x0309
#define WM_VSCROLLCLIPBOARD             0x030A
#define WM_SIZECLIPBOARD                0x030B
#define WM_ASKCBFORMATNAME              0x030C
#define WM_CHANGECBCHAIN                0x030D
#define WM_HSCROLLCLIPBOARD             0x030E
#define WM_QUERYNEWPALETTE              0x030F
#define WM_PALETTEISCHANGING            0x0310
#define WM_PALETTECHANGED               0x0311
#define WM_HOTKEY                       0x0312

#if(WINVER >= 0x0400)
#define WM_PRINT                        0x0317
#define WM_PRINTCLIENT                  0x0318
#endif /* WINVER >= 0x0400 */

#if(_WIN32_WINNT >= 0x0500)
#define WM_APPCOMMAND                   0x0319
#endif /* _WIN32_WINNT >= 0x0500 */

#if(_WIN32_WINNT >= 0x0501)
#define WM_THEMECHANGED                 0x031A
#endif /* _WIN32_WINNT >= 0x0501 */


#if(_WIN32_WINNT >= 0x0501)
#define WM_CLIPBOARDUPDATE              0x031D
#endif /* _WIN32_WINNT >= 0x0501 */

#if(_WIN32_WINNT >= 0x0600)
#define WM_DWMCOMPOSITIONCHANGED        0x031E
#define WM_DWMNCRENDERINGCHANGED        0x031F
#define WM_DWMCOLORIZATIONCOLORCHANGED  0x0320
#define WM_DWMWINDOWMAXIMIZEDCHANGE     0x0321
#endif /* _WIN32_WINNT >= 0x0600 */

#if(_WIN32_WINNT >= 0x0601)
#define WM_DWMSENDICONICTHUMBNAIL           0x0323
#define WM_DWMSENDICONICLIVEPREVIEWBITMAP   0x0326
#endif /* _WIN32_WINNT >= 0x0601 */


#if(WINVER >= 0x0600)
#define WM_GETTITLEBARINFOEX            0x033F
#endif /* WINVER >= 0x0600 */

#if(WINVER >= 0x0400)
#endif /* WINVER >= 0x0400 */


#if(WINVER >= 0x0400)
#define WM_HANDHELDFIRST                0x0358
#define WM_HANDHELDLAST                 0x035F

#define WM_AFXFIRST                     0x0360
#define WM_AFXLAST                      0x037F
#endif /* WINVER >= 0x0400 */

#define WM_PENWINFIRST                  0x0380
#define WM_PENWINLAST                   0x038F


#if(WINVER >= 0x0400)
#define WM_APP                          0x8000
#endif /* WINVER >= 0x0400 */


/*
 * NOTE: All Message Numbers below 0x0400 are RESERVED.
 *
 * Private Window Messages Start Here:
 */
#define WM_USER                         0x0400

#if(WINVER >= 0x0400)

/*  wParam for WM_SIZING message  */
#define WMSZ_LEFT           1
#define WMSZ_RIGHT          2
#define WMSZ_TOP            3
#define WMSZ_TOPLEFT        4
#define WMSZ_TOPRIGHT       5
#define WMSZ_BOTTOM         6
#define WMSZ_BOTTOMLEFT     7
#define WMSZ_BOTTOMRIGHT    8
#endif /* WINVER >= 0x0400 */

#ifndef NONCMESSAGES

/*
 * WM_NCHITTEST and MOUSEHOOKSTRUCT Mouse Position Codes
 */
#define HTERROR             (-2)
#define HTTRANSPARENT       (-1)
#define HTNOWHERE           0
#define HTCLIENT            1
#define HTCAPTION           2
#define HTSYSMENU           3
#define HTGROWBOX           4
#define HTSIZE              HTGROWBOX
#define HTMENU              5
#define HTHSCROLL           6
#define HTVSCROLL           7
#define HTMINBUTTON         8
#define HTMAXBUTTON         9
#define HTLEFT              10
#define HTRIGHT             11
#define HTTOP               12
#define HTTOPLEFT           13
#define HTTOPRIGHT          14
#define HTBOTTOM            15
#define HTBOTTOMLEFT        16
#define HTBOTTOMRIGHT       17
#define HTBORDER            18
#define HTREDUCE            HTMINBUTTON
#define HTZOOM              HTMAXBUTTON
#define HTSIZEFIRST         HTLEFT
#define HTSIZELAST          HTBOTTOMRIGHT
#if(WINVER >= 0x0400)
#define HTOBJECT            19
#define HTCLOSE             20
#define HTHELP              21
#endif /* WINVER >= 0x0400 */


/*
 * SendMessageTimeout values
 */
#define SMTO_NORMAL         0x0000
#define SMTO_BLOCK          0x0001
#define SMTO_ABORTIFHUNG    0x0002
#if(WINVER >= 0x0500)
#define SMTO_NOTIMEOUTIFNOTHUNG 0x0008
#endif /* WINVER >= 0x0500 */
#if(WINVER >= 0x0600)
#define SMTO_ERRORONEXIT    0x0020
#endif /* WINVER >= 0x0600 */
#if(WINVER >= 0x0602)
#endif /* WINVER >= 0x0602 */

#endif /* !NONCMESSAGES */

/*
 * WM_MOUSEACTIVATE Return Codes
 */
#define MA_ACTIVATE         1
#define MA_ACTIVATEANDEAT   2
#define MA_NOACTIVATE       3
#define MA_NOACTIVATEANDEAT 4

/*
 * WM_SETICON / WM_GETICON Type Codes
 */
#define ICON_SMALL          0
#define ICON_BIG            1
#if(_WIN32_WINNT >= 0x0501)
#define ICON_SMALL2         2
#endif /* _WIN32_WINNT >= 0x0501 */


#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


UINT
__stdcall
RegisterWindowMessageA(
     LPCSTR lpString);

UINT
__stdcall
RegisterWindowMessageW(
     LPCWSTR lpString);
#ifdef UNICODE
#define RegisterWindowMessage  RegisterWindowMessageW
#else
#define RegisterWindowMessage  RegisterWindowMessageA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion


/*
 * WM_SIZE message wParam values
 */
#define SIZE_RESTORED       0
#define SIZE_MINIMIZED      1
#define SIZE_MAXIMIZED      2
#define SIZE_MAXSHOW        3
#define SIZE_MAXHIDE        4

/*
 * Obsolete constant names
 */
#define SIZENORMAL          SIZE_RESTORED
#define SIZEICONIC          SIZE_MINIMIZED
#define SIZEFULLSCREEN      SIZE_MAXIMIZED
#define SIZEZOOMSHOW        SIZE_MAXSHOW
#define SIZEZOOMHIDE        SIZE_MAXHIDE


#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

/*
 * WM_WINDOWPOSCHANGING/CHANGED struct pointed to by lParam
 */
typedef struct tagWINDOWPOS {
    HWND    hwnd;
    HWND    hwndInsertAfter;
    int     x;
    int     y;
    int     cx;
    int     cy;
    UINT    flags;
} WINDOWPOS, *LPWINDOWPOS, *PWINDOWPOS;

/*
 * WM_NCCALCSIZE parameter structure
 */
typedef struct tagNCCALCSIZE_PARAMS {
    RECT       rgrc[3];
    PWINDOWPOS lppos;
} NCCALCSIZE_PARAMS, *LPNCCALCSIZE_PARAMS;

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/*
 * WM_NCCALCSIZE "window valid rect" return values
 */
#define WVR_ALIGNTOP        0x0010
#define WVR_ALIGNLEFT       0x0020
#define WVR_ALIGNBOTTOM     0x0040
#define WVR_ALIGNRIGHT      0x0080
#define WVR_HREDRAW         0x0100
#define WVR_VREDRAW         0x0200
#define WVR_REDRAW         (WVR_HREDRAW | \
                            WVR_VREDRAW)
#define WVR_VALIDRECTS      0x0400


#ifndef NOKEYSTATES

/*
 * Key State Masks for Mouse Messages
 */
#define MK_LBUTTON          0x0001
#define MK_RBUTTON          0x0002
#define MK_SHIFT            0x0004
#define MK_CONTROL          0x0008
#define MK_MBUTTON          0x0010
#if(_WIN32_WINNT >= 0x0500)
#define MK_XBUTTON1         0x0020
#define MK_XBUTTON2         0x0040
#endif /* _WIN32_WINNT >= 0x0500 */

#endif /* !NOKEYSTATES */


#if(_WIN32_WINNT >= 0x0400)
#ifndef NOTRACKMOUSEEVENT

#define TME_HOVER       0x00000001
#define TME_LEAVE       0x00000002
#if(WINVER >= 0x0500)
#define TME_NONCLIENT   0x00000010
#endif /* WINVER >= 0x0500 */
#define TME_QUERY       0x40000000
#define TME_CANCEL      0x80000000


#define HOVER_DEFAULT   0xFFFFFFFF
#endif /* _WIN32_WINNT >= 0x0400 */

#if(_WIN32_WINNT >= 0x0400)

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

typedef struct tagTRACKMOUSEEVENT {
    DWORD cbSize;
    DWORD dwFlags;
    HWND  hwndTrack;
    DWORD dwHoverTime;
} TRACKMOUSEEVENT, *LPTRACKMOUSEEVENT;


BOOL
__stdcall
TrackMouseEvent(
     LPTRACKMOUSEEVENT lpEventTrack);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* _WIN32_WINNT >= 0x0400 */

#if(_WIN32_WINNT >= 0x0400)

#endif /* !NOTRACKMOUSEEVENT */
#endif /* _WIN32_WINNT >= 0x0400 */


#endif /* !NOWINMESSAGES */

#ifndef NOWINSTYLES


/*
 * Window Styles
 */
#define WS_OVERLAPPED       0x00000000L
#define WS_POPUP            0x80000000L
#define WS_CHILD            0x40000000L
#define WS_MINIMIZE         0x20000000L
#define WS_VISIBLE          0x10000000L
#define WS_DISABLED         0x08000000L
#define WS_CLIPSIBLINGS     0x04000000L
#define WS_CLIPCHILDREN     0x02000000L
#define WS_MAXIMIZE         0x01000000L
#define WS_CAPTION          0x00C00000L     /* WS_BORDER | WS_DLGFRAME  */
#define WS_BORDER           0x00800000L
#define WS_DLGFRAME         0x00400000L
#define WS_VSCROLL          0x00200000L
#define WS_HSCROLL          0x00100000L
#define WS_SYSMENU          0x00080000L
#define WS_THICKFRAME       0x00040000L
#define WS_GROUP            0x00020000L
#define WS_TABSTOP          0x00010000L

#define WS_MINIMIZEBOX      0x00020000L
#define WS_MAXIMIZEBOX      0x00010000L


#define WS_TILED            WS_OVERLAPPED
#define WS_ICONIC           WS_MINIMIZE
#define WS_SIZEBOX          WS_THICKFRAME
#define WS_TILEDWINDOW      WS_OVERLAPPEDWINDOW

/*
 * Common Window Styles
 */
#define WS_OVERLAPPEDWINDOW (WS_OVERLAPPED     | \
                             WS_CAPTION        | \
                             WS_SYSMENU        | \
                             WS_THICKFRAME     | \
                             WS_MINIMIZEBOX    | \
                             WS_MAXIMIZEBOX)

#define WS_POPUPWINDOW      (WS_POPUP          | \
                             WS_BORDER         | \
                             WS_SYSMENU)

#define WS_CHILDWINDOW      (WS_CHILD)

/*
 * Extended Window Styles
 */
#define WS_EX_DLGMODALFRAME     0x00000001L
#define WS_EX_NOPARENTNOTIFY    0x00000004L
#define WS_EX_TOPMOST           0x00000008L
#define WS_EX_ACCEPTFILES       0x00000010L
#define WS_EX_TRANSPARENT       0x00000020L
#if(WINVER >= 0x0400)
#define WS_EX_MDICHILD          0x00000040L
#define WS_EX_TOOLWINDOW        0x00000080L
#define WS_EX_WINDOWEDGE        0x00000100L
#define WS_EX_CLIENTEDGE        0x00000200L
#define WS_EX_CONTEXTHELP       0x00000400L

#endif /* WINVER >= 0x0400 */
#if(WINVER >= 0x0400)

#define WS_EX_RIGHT             0x00001000L
#define WS_EX_LEFT              0x00000000L
#define WS_EX_RTLREADING        0x00002000L
#define WS_EX_LTRREADING        0x00000000L
#define WS_EX_LEFTSCROLLBAR     0x00004000L
#define WS_EX_RIGHTSCROLLBAR    0x00000000L

#define WS_EX_CONTROLPARENT     0x00010000L
#define WS_EX_STATICEDGE        0x00020000L
#define WS_EX_APPWINDOW         0x00040000L


#define WS_EX_OVERLAPPEDWINDOW  (WS_EX_WINDOWEDGE | WS_EX_CLIENTEDGE)
#define WS_EX_PALETTEWINDOW     (WS_EX_WINDOWEDGE | WS_EX_TOOLWINDOW | WS_EX_TOPMOST)

#endif /* WINVER >= 0x0400 */

#if(_WIN32_WINNT >= 0x0500)
#define WS_EX_LAYERED           0x00080000

#endif /* _WIN32_WINNT >= 0x0500 */


#if(WINVER >= 0x0500)
#define WS_EX_NOINHERITLAYOUT   0x00100000L // Disable inheritence of mirroring by children
#endif /* WINVER >= 0x0500 */

#if(WINVER >= 0x0602)
#define WS_EX_NOREDIRECTIONBITMAP 0x00200000L
#endif /* WINVER >= 0x0602 */

#if(WINVER >= 0x0500)
#define WS_EX_LAYOUTRTL         0x00400000L // Right to left mirroring
#endif /* WINVER >= 0x0500 */

#if(_WIN32_WINNT >= 0x0501)
#define WS_EX_COMPOSITED        0x02000000L
#endif /* _WIN32_WINNT >= 0x0501 */
#if(_WIN32_WINNT >= 0x0500)
#define WS_EX_NOACTIVATE        0x08000000L
#endif /* _WIN32_WINNT >= 0x0500 */


/*
 * Class styles
 */
#define CS_VREDRAW          0x0001
#define CS_HREDRAW          0x0002
#define CS_DBLCLKS          0x0008
#define CS_OWNDC            0x0020
#define CS_CLASSDC          0x0040
#define CS_PARENTDC         0x0080
#define CS_NOCLOSE          0x0200
#define CS_SAVEBITS         0x0800
#define CS_BYTEALIGNCLIENT  0x1000
#define CS_BYTEALIGNWINDOW  0x2000
#define CS_GLOBALCLASS      0x4000

#define CS_IME              0x00010000
#if(_WIN32_WINNT >= 0x0501)
#define CS_DROPSHADOW       0x00020000
#endif /* _WIN32_WINNT >= 0x0501 */



#endif /* !NOWINSTYLES */
#if(WINVER >= 0x0400)
/* WM_PRINT flags */
#define PRF_CHECKVISIBLE    0x00000001L
#define PRF_NONCLIENT       0x00000002L
#define PRF_CLIENT          0x00000004L
#define PRF_ERASEBKGND      0x00000008L
#define PRF_CHILDREN        0x00000010L
#define PRF_OWNED           0x00000020L

/* 3D border styles */
#define BDR_RAISEDOUTER 0x0001
#define BDR_SUNKENOUTER 0x0002
#define BDR_RAISEDINNER 0x0004
#define BDR_SUNKENINNER 0x0008

#define BDR_OUTER       (BDR_RAISEDOUTER | BDR_SUNKENOUTER)
#define BDR_INNER       (BDR_RAISEDINNER | BDR_SUNKENINNER)
#define BDR_RAISED      (BDR_RAISEDOUTER | BDR_RAISEDINNER)
#define BDR_SUNKEN      (BDR_SUNKENOUTER | BDR_SUNKENINNER)


#define EDGE_RAISED     (BDR_RAISEDOUTER | BDR_RAISEDINNER)
#define EDGE_SUNKEN     (BDR_SUNKENOUTER | BDR_SUNKENINNER)
#define EDGE_ETCHED     (BDR_SUNKENOUTER | BDR_RAISEDINNER)
#define EDGE_BUMP       (BDR_RAISEDOUTER | BDR_SUNKENINNER)

/* Border flags */
#define BF_LEFT         0x0001
#define BF_TOP          0x0002
#define BF_RIGHT        0x0004
#define BF_BOTTOM       0x0008

#define BF_TOPLEFT      (BF_TOP | BF_LEFT)
#define BF_TOPRIGHT     (BF_TOP | BF_RIGHT)
#define BF_BOTTOMLEFT   (BF_BOTTOM | BF_LEFT)
#define BF_BOTTOMRIGHT  (BF_BOTTOM | BF_RIGHT)
#define BF_RECT         (BF_LEFT | BF_TOP | BF_RIGHT | BF_BOTTOM)

#define BF_DIAGONAL     0x0010

// For diagonal lines, the BF_RECT flags specify the end point of the
// vector bounded by the rectangle parameter.
#define BF_DIAGONAL_ENDTOPRIGHT     (BF_DIAGONAL | BF_TOP | BF_RIGHT)
#define BF_DIAGONAL_ENDTOPLEFT      (BF_DIAGONAL | BF_TOP | BF_LEFT)
#define BF_DIAGONAL_ENDBOTTOMLEFT   (BF_DIAGONAL | BF_BOTTOM | BF_LEFT)
#define BF_DIAGONAL_ENDBOTTOMRIGHT  (BF_DIAGONAL | BF_BOTTOM | BF_RIGHT)


#define BF_MIDDLE       0x0800  /* Fill in the middle */
#define BF_SOFT         0x1000  /* For softer buttons */
#define BF_ADJUST       0x2000  /* Calculate the space left over */
#define BF_FLAT         0x4000  /* For flat rather than 3D borders */
#define BF_MONO         0x8000  /* For monochrome borders */


#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
DrawEdge(
     HDC hdc,
     LPRECT qrc,
     UINT edge,
     UINT grfFlags);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/* flags for DrawFrameControl */

#define DFC_CAPTION             1
#define DFC_MENU                2
#define DFC_SCROLL              3
#define DFC_BUTTON              4
#if(WINVER >= 0x0500)
#define DFC_POPUPMENU           5
#endif /* WINVER >= 0x0500 */

#define DFCS_CAPTIONCLOSE       0x0000
#define DFCS_CAPTIONMIN         0x0001
#define DFCS_CAPTIONMAX         0x0002
#define DFCS_CAPTIONRESTORE     0x0003
#define DFCS_CAPTIONHELP        0x0004

#define DFCS_MENUARROW          0x0000
#define DFCS_MENUCHECK          0x0001
#define DFCS_MENUBULLET         0x0002
#define DFCS_MENUARROWRIGHT     0x0004
#define DFCS_SCROLLUP           0x0000
#define DFCS_SCROLLDOWN         0x0001
#define DFCS_SCROLLLEFT         0x0002
#define DFCS_SCROLLRIGHT        0x0003
#define DFCS_SCROLLCOMBOBOX     0x0005
#define DFCS_SCROLLSIZEGRIP     0x0008
#define DFCS_SCROLLSIZEGRIPRIGHT 0x0010

#define DFCS_BUTTONCHECK        0x0000
#define DFCS_BUTTONRADIOIMAGE   0x0001
#define DFCS_BUTTONRADIOMASK    0x0002
#define DFCS_BUTTONRADIO        0x0004
#define DFCS_BUTTON3STATE       0x0008
#define DFCS_BUTTONPUSH         0x0010

#define DFCS_INACTIVE           0x0100
#define DFCS_PUSHED             0x0200
#define DFCS_CHECKED            0x0400

#if(WINVER >= 0x0500)
#define DFCS_TRANSPARENT        0x0800
#define DFCS_HOT                0x1000
#endif /* WINVER >= 0x0500 */

#define DFCS_ADJUSTRECT         0x2000
#define DFCS_FLAT               0x4000
#define DFCS_MONO               0x8000

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
DrawFrameControl(
     HDC,
     LPRECT,
     UINT,
     UINT);


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion


/* flags for DrawCaption */
#define DC_ACTIVE           0x0001
#define DC_SMALLCAP         0x0002
#define DC_ICON             0x0004
#define DC_TEXT             0x0008
#define DC_INBUTTON         0x0010
#if(WINVER >= 0x0500)
#define DC_GRADIENT         0x0020
#endif /* WINVER >= 0x0500 */
#if(_WIN32_WINNT >= 0x0501)
#define DC_BUTTONS          0x1000
#endif /* _WIN32_WINNT >= 0x0501 */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
DrawCaption(
     HWND hwnd,
     HDC hdc,
     CONST RECT * lprect,
     UINT flags);


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#define IDANI_OPEN          1
#define IDANI_CAPTION       3

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
DrawAnimatedRects(
     HWND hwnd,
     int idAni,
     CONST RECT *lprcFrom,
     CONST RECT *lprcTo);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* WINVER >= 0x0400 */

#ifndef NOCLIPBOARD


/*
 * Predefined Clipboard Formats
 */
#define CF_TEXT             1
#define CF_BITMAP           2
#define CF_METAFILEPICT     3
#define CF_SYLK             4
#define CF_DIF              5
#define CF_TIFF             6
#define CF_OEMTEXT          7
#define CF_DIB              8
#define CF_PALETTE          9
#define CF_PENDATA          10
#define CF_RIFF             11
#define CF_WAVE             12
#define CF_UNICODETEXT      13
#define CF_ENHMETAFILE      14
#if(WINVER >= 0x0400)
#define CF_HDROP            15
#define CF_LOCALE           16
#endif /* WINVER >= 0x0400 */
#if(WINVER >= 0x0500)
#define CF_DIBV5            17
#endif /* WINVER >= 0x0500 */

#if(WINVER >= 0x0500)
#define CF_MAX              18
#elif(WINVER >= 0x0400)
#define CF_MAX              17
#else
#define CF_MAX              15
#endif

#define CF_OWNERDISPLAY     0x0080
#define CF_DSPTEXT          0x0081
#define CF_DSPBITMAP        0x0082
#define CF_DSPMETAFILEPICT  0x0083
#define CF_DSPENHMETAFILE   0x008E

/*
 * "Private" formats don't get GlobalFree()'d
 */
#define CF_PRIVATEFIRST     0x0200
#define CF_PRIVATELAST      0x02FF

/*
 * "GDIOBJ" formats do get DeleteObject()'d
 */
#define CF_GDIOBJFIRST      0x0300
#define CF_GDIOBJLAST       0x03FF


#endif /* !NOCLIPBOARD */

/*
 * Defines for the fVirt field of the Accelerator table structure.
 */
#define FVIRTKEY  TRUE          /* Assumed to be == TRUE */
#define FNOINVERT 0x02
#define FSHIFT    0x04
#define FCONTROL  0x08
#define FALT      0x10

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

typedef struct tagACCEL {
#ifndef _MAC
    BYTE   fVirt;               /* Also called the flags field */
    WORD   key;
    WORD   cmd;
#else
    WORD   fVirt;               /* Also called the flags field */
    WORD   key;
    DWORD  cmd;
#endif
} ACCEL, *LPACCEL;

typedef struct tagPAINTSTRUCT {
    HDC         hdc;
    BOOL        fErase;
    RECT        rcPaint;
    BOOL        fRestore;
    BOOL        fIncUpdate;
    BYTE        rgbReserved[32];
} PAINTSTRUCT, *PPAINTSTRUCT, *NPPAINTSTRUCT, *LPPAINTSTRUCT;

typedef struct tagCREATESTRUCTA {
    LPVOID      lpCreateParams;
    HINSTANCE   hInstance;
    HMENU       hMenu;
    HWND        hwndParent;
    int         cy;
    int         cx;
    int         y;
    int         x;
    LONG        style;
    LPCSTR      lpszName;
    LPCSTR      lpszClass;
    DWORD       dwExStyle;
} CREATESTRUCTA, *LPCREATESTRUCTA;
typedef struct tagCREATESTRUCTW {
    LPVOID      lpCreateParams;
    HINSTANCE   hInstance;
    HMENU       hMenu;
    HWND        hwndParent;
    int         cy;
    int         cx;
    int         y;
    int         x;
    LONG        style;
    LPCWSTR     lpszName;
    LPCWSTR     lpszClass;
    DWORD       dwExStyle;
} CREATESTRUCTW, *LPCREATESTRUCTW;
#ifdef UNICODE
typedef CREATESTRUCTW CREATESTRUCT;
typedef LPCREATESTRUCTW LPCREATESTRUCT;
#else
typedef CREATESTRUCTA CREATESTRUCT;
typedef LPCREATESTRUCTA LPCREATESTRUCT;
#endif // UNICODE

typedef struct tagWINDOWPLACEMENT {
    UINT  length;
    UINT  flags;
    UINT  showCmd;
    POINT ptMinPosition;
    POINT ptMaxPosition;
    RECT  rcNormalPosition;
#ifdef _MAC
    RECT  rcDevice;
#endif
} WINDOWPLACEMENT;
typedef WINDOWPLACEMENT *PWINDOWPLACEMENT, *LPWINDOWPLACEMENT;

#define WPF_SETMINPOSITION          0x0001
#define WPF_RESTORETOMAXIMIZED      0x0002
#if(_WIN32_WINNT >= 0x0500)
#define WPF_ASYNCWINDOWPLACEMENT    0x0004
#endif /* _WIN32_WINNT >= 0x0500 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#if(WINVER >= 0x0400)

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

typedef struct tagNMHDR
{
    HWND      hwndFrom;
    UINT_PTR  idFrom;
    UINT      code;         // NM_ code
}   NMHDR;

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

typedef NMHDR * LPNMHDR;

typedef struct tagSTYLESTRUCT
{
    DWORD   styleOld;
    DWORD   styleNew;
} STYLESTRUCT, * LPSTYLESTRUCT;

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion
#endif /* WINVER >= 0x0400 */


/*
 * Owner draw control types
 */
#define ODT_MENU        1
#define ODT_LISTBOX     2
#define ODT_COMBOBOX    3
#define ODT_BUTTON      4
#if(WINVER >= 0x0400)
#define ODT_STATIC      5
#endif /* WINVER >= 0x0400 */

/*
 * Owner draw actions
 */
#define ODA_DRAWENTIRE  0x0001
#define ODA_SELECT      0x0002
#define ODA_FOCUS       0x0004

/*
 * Owner draw state
 */
#define ODS_SELECTED    0x0001
#define ODS_GRAYED      0x0002
#define ODS_DISABLED    0x0004
#define ODS_CHECKED     0x0008
#define ODS_FOCUS       0x0010
#if(WINVER >= 0x0400)
#define ODS_DEFAULT         0x0020
#define ODS_COMBOBOXEDIT    0x1000
#endif /* WINVER >= 0x0400 */
#if(WINVER >= 0x0500)
#define ODS_HOTLIGHT        0x0040
#define ODS_INACTIVE        0x0080
#if(_WIN32_WINNT >= 0x0500)
#define ODS_NOACCEL         0x0100
#define ODS_NOFOCUSRECT     0x0200
#endif /* _WIN32_WINNT >= 0x0500 */
#endif /* WINVER >= 0x0500 */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

/*
 * MEASUREITEMSTRUCT for ownerdraw
 */
typedef struct tagMEASUREITEMSTRUCT {
    UINT       CtlType;
    UINT       CtlID;
    UINT       itemID;
    UINT       itemWidth;
    UINT       itemHeight;
    ULONG_PTR  itemData;
} MEASUREITEMSTRUCT, *PMEASUREITEMSTRUCT, *LPMEASUREITEMSTRUCT;

/*
 * DRAWITEMSTRUCT for ownerdraw
 */
typedef struct tagDRAWITEMSTRUCT {
    UINT        CtlType;
    UINT        CtlID;
    UINT        itemID;
    UINT        itemAction;
    UINT        itemState;
    HWND        hwndItem;
    HDC         hDC;
    RECT        rcItem;
    ULONG_PTR   itemData;
} DRAWITEMSTRUCT, *PDRAWITEMSTRUCT, *LPDRAWITEMSTRUCT;

/*
 * DELETEITEMSTRUCT for ownerdraw
 */
typedef struct tagDELETEITEMSTRUCT {
    UINT       CtlType;
    UINT       CtlID;
    UINT       itemID;
    HWND       hwndItem;
    ULONG_PTR  itemData;
} DELETEITEMSTRUCT, *PDELETEITEMSTRUCT, *LPDELETEITEMSTRUCT;

/*
 * COMPAREITEMSTUCT for ownerdraw sorting
 */
typedef struct tagCOMPAREITEMSTRUCT {
    UINT        CtlType;
    UINT        CtlID;
    HWND        hwndItem;
    UINT        itemID1;
    ULONG_PTR   itemData1;
    UINT        itemID2;
    ULONG_PTR   itemData2;
    DWORD       dwLocaleId;
} COMPAREITEMSTRUCT, *PCOMPAREITEMSTRUCT, *LPCOMPAREITEMSTRUCT;

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#ifndef NOMSG

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

/*
 * Message Function Templates
 */


BOOL
__stdcall
GetMessageA(
     LPMSG lpMsg,
     HWND hWnd,
     UINT wMsgFilterMin,
     UINT wMsgFilterMax);

BOOL
__stdcall
GetMessageW(
     LPMSG lpMsg,
     HWND hWnd,
     UINT wMsgFilterMin,
     UINT wMsgFilterMax);
#ifdef UNICODE
#define GetMessage  GetMessageW
#else
#define GetMessage  GetMessageA
#endif // !UNICODE

#if defined(_M_CEE)
#undef GetMessage
__inline
BOOL
GetMessage(
    LPMSG lpMsg,
    HWND hWnd,
    UINT wMsgFilterMin,
    UINT wMsgFilterMax
    )
{
#ifdef UNICODE
    return GetMessageW(
#else
    return GetMessageA(
#endif
        lpMsg,
        hWnd,
        wMsgFilterMin,
        wMsgFilterMax
        );
}
#endif  /* _M_CEE */



BOOL
__stdcall
TranslateMessage(
     CONST MSG *lpMsg);


LRESULT
__stdcall
DispatchMessageA(
     CONST MSG *lpMsg);

LRESULT
__stdcall
DispatchMessageW(
     CONST MSG *lpMsg);
#ifdef UNICODE
#define DispatchMessage  DispatchMessageW
#else
#define DispatchMessage  DispatchMessageA
#endif // !UNICODE

#if defined(_M_CEE)
#undef DispatchMessage
__inline
LRESULT
DispatchMessage(
    CONST MSG *lpMsg
    )
{
#ifdef UNICODE
    return DispatchMessageW(
#else
    return DispatchMessageA(
#endif
        lpMsg
        );
}
#endif  /* _M_CEE */


BOOL
__stdcall
SetMessageQueue(
     int cMessagesMax);


BOOL
__stdcall
PeekMessageA(
     LPMSG lpMsg,
     HWND hWnd,
     UINT wMsgFilterMin,
     UINT wMsgFilterMax,
     UINT wRemoveMsg);

BOOL
__stdcall
PeekMessageW(
     LPMSG lpMsg,
     HWND hWnd,
     UINT wMsgFilterMin,
     UINT wMsgFilterMax,
     UINT wRemoveMsg);
#ifdef UNICODE
#define PeekMessage  PeekMessageW
#else
#define PeekMessage  PeekMessageA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/*
 * PeekMessage() Options
 */
#define PM_NOREMOVE         0x0000
#define PM_REMOVE           0x0001
#define PM_NOYIELD          0x0002
#if(WINVER >= 0x0500)
#define PM_QS_INPUT         (QS_INPUT << 16)
#define PM_QS_POSTMESSAGE   ((QS_POSTMESSAGE | QS_HOTKEY | QS_TIMER) << 16)
#define PM_QS_PAINT         (QS_PAINT << 16)
#define PM_QS_SENDMESSAGE   (QS_SENDMESSAGE << 16)
#endif /* WINVER >= 0x0500 */


#endif /* !NOMSG */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
RegisterHotKey(
     HWND hWnd,
     int id,
     UINT fsModifiers,
     UINT vk);


BOOL
__stdcall
UnregisterHotKey(
     HWND hWnd,
     int id);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#define MOD_ALT             0x0001
#define MOD_CONTROL         0x0002
#define MOD_SHIFT           0x0004
#define MOD_WIN             0x0008
#if(WINVER >= 0x0601)
#define MOD_NOREPEAT        0x4000
#endif /* WINVER >= 0x0601 */


#define IDHOT_SNAPWINDOW        (-1)    /* SHIFT-PRINTSCRN  */
#define IDHOT_SNAPDESKTOP       (-2)    /* PRINTSCRN        */

#ifdef WIN_INTERNAL
    #ifndef LSTRING
    #define NOLSTRING
    #endif /* LSTRING */
    #ifndef LFILEIO
    #define NOLFILEIO
    #endif /* LFILEIO */
#endif /* WIN_INTERNAL */

#if(WINVER >= 0x0400)
#endif /* WINVER >= 0x0400 */

#if(_WIN32_WINNT >= 0x0400)
#define ENDSESSION_CLOSEAPP         0x00000001
#endif /* _WIN32_WINNT >= 0x0400 */
#if(_WIN32_WINNT >= 0x0400)
#define ENDSESSION_CRITICAL         0x40000000
#endif /* _WIN32_WINNT >= 0x0400 */
#if(_WIN32_WINNT >= 0x0400)
#define ENDSESSION_LOGOFF           0x80000000
#endif /* _WIN32_WINNT >= 0x0400 */

#define EWX_LOGOFF                  0x00000000
#define EWX_SHUTDOWN                0x00000001
#define EWX_REBOOT                  0x00000002
#define EWX_FORCE                   0x00000004
#define EWX_POWEROFF                0x00000008
#if(_WIN32_WINNT >= 0x0500)
#define EWX_FORCEIFHUNG             0x00000010
#endif /* _WIN32_WINNT >= 0x0500 */
#define EWX_QUICKRESOLVE            0x00000020
#if(_WIN32_WINNT >= 0x0600)
#define EWX_RESTARTAPPS             0x00000040
#endif /* _WIN32_WINNT >= 0x0600 */
#define EWX_HYBRID_SHUTDOWN         0x00400000
#define EWX_BOOTOPTIONS             0x01000000

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#define ExitWindows(dwReserved, Code) ExitWindowsEx(EWX_LOGOFF, 0xFFFFFFFF)

_When_((uFlags&(EWX_POWEROFF|EWX_SHUTDOWN|EWX_FORCE))!=0,
    __drv_preferredFunction("InitiateSystemShutdownEx",
        "Legacy API. Rearchitect to avoid Reboot"))

BOOL
__stdcall
ExitWindowsEx(
     UINT uFlags,
     DWORD dwReason);


BOOL
__stdcall
SwapMouseButton(
     BOOL fSwap);


DWORD
__stdcall
GetMessagePos(
    VOID);


LONG
__stdcall
GetMessageTime(
    VOID);


LPARAM
__stdcall
GetMessageExtraInfo(
    VOID);

#if(_WIN32_WINNT >= 0x0602)

DWORD
__stdcall
GetUnpredictedMessagePos(
    VOID);
#endif /* _WIN32_WINNT >= 0x0602 */

#if(_WIN32_WINNT >= 0x0501)

BOOL
__stdcall
IsWow64Message(
    VOID);
#endif /* _WIN32_WINNT >= 0x0501 */

#if(WINVER >= 0x0400)

LPARAM
__stdcall
SetMessageExtraInfo(
     LPARAM lParam);
#endif /* WINVER >= 0x0400 */


LRESULT
__stdcall
SendMessageA(
     HWND hWnd,
     UINT Msg,
      WPARAM wParam,
      LPARAM lParam);

LRESULT
__stdcall
SendMessageW(
     HWND hWnd,
     UINT Msg,
      WPARAM wParam,
      LPARAM lParam);
#ifdef UNICODE
#define SendMessage  SendMessageW
#else
#define SendMessage  SendMessageA
#endif // !UNICODE

#if defined(_M_CEE)
#undef SendMessage
__inline
LRESULT
SendMessage(
    HWND hWnd,
    UINT Msg,
    WPARAM wParam,
    LPARAM lParam
    )
{
#ifdef UNICODE
    return SendMessageW(
#else
    return SendMessageA(
#endif
        hWnd,
        Msg,
        wParam,
        lParam
        );
}
#endif  /* _M_CEE */




LRESULT
__stdcall
SendMessageTimeoutA(
     HWND hWnd,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam,
     UINT fuFlags,
     UINT uTimeout,
    _Out_opt_ PDWORD_PTR lpdwResult);

LRESULT
__stdcall
SendMessageTimeoutW(
     HWND hWnd,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam,
     UINT fuFlags,
     UINT uTimeout,
    _Out_opt_ PDWORD_PTR lpdwResult);
#ifdef UNICODE
#define SendMessageTimeout  SendMessageTimeoutW
#else
#define SendMessageTimeout  SendMessageTimeoutA
#endif // !UNICODE


BOOL
__stdcall
SendNotifyMessageA(
     HWND hWnd,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam);

BOOL
__stdcall
SendNotifyMessageW(
     HWND hWnd,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam);
#ifdef UNICODE
#define SendNotifyMessage  SendNotifyMessageW
#else
#define SendNotifyMessage  SendNotifyMessageA
#endif // !UNICODE


BOOL
__stdcall
SendMessage__stdcallA(
     HWND hWnd,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam,
     SENDASYNCPROC lpResult__stdcall,
     ULONG_PTR dwData);

BOOL
__stdcall
SendMessage__stdcallW(
     HWND hWnd,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam,
     SENDASYNCPROC lpResult__stdcall,
     ULONG_PTR dwData);
#ifdef UNICODE
#define SendMessage__stdcall  SendMessage__stdcallW
#else
#define SendMessage__stdcall  SendMessage__stdcallA
#endif // !UNICODE

#if(_WIN32_WINNT >= 0x0501)
typedef struct {
    UINT  cbSize;
    HDESK hdesk;
    HWND  hwnd;
    LUID  luid;
} BSMINFO, *PBSMINFO;


long
__stdcall
BroadcastSystemMessageExA(
     DWORD flags,
    _Inout_opt_ LPDWORD lpInfo,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam,
    _Out_opt_ PBSMINFO pbsmInfo);

long
__stdcall
BroadcastSystemMessageExW(
     DWORD flags,
    _Inout_opt_ LPDWORD lpInfo,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam,
    _Out_opt_ PBSMINFO pbsmInfo);
#ifdef UNICODE
#define BroadcastSystemMessageEx  BroadcastSystemMessageExW
#else
#define BroadcastSystemMessageEx  BroadcastSystemMessageExA
#endif // !UNICODE
#endif /* _WIN32_WINNT >= 0x0501 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#if(WINVER >= 0x0400)

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if defined(_WIN32_WINNT)

long
__stdcall
BroadcastSystemMessageA(
     DWORD flags,
    _Inout_opt_ LPDWORD lpInfo,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam);

long
__stdcall
BroadcastSystemMessageW(
     DWORD flags,
    _Inout_opt_ LPDWORD lpInfo,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam);
#ifdef UNICODE
#define BroadcastSystemMessage  BroadcastSystemMessageW
#else
#define BroadcastSystemMessage  BroadcastSystemMessageA
#endif // !UNICODE
#elif defined(_WIN32_WINDOWS)
// The Win95 version isn't A/W decorated

long
__stdcall
BroadcastSystemMessage(
     DWORD flags,
    _Inout_opt_ LPDWORD lpInfo,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam);

#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

//Broadcast Special Message Recipient list
#define BSM_ALLCOMPONENTS       0x00000000
#define BSM_VXDS                0x00000001
#define BSM_NETDRIVER           0x00000002
#define BSM_INSTALLABLEDRIVERS  0x00000004
#define BSM_APPLICATIONS        0x00000008
#define BSM_ALLDESKTOPS         0x00000010

//Broadcast Special Message Flags
#define BSF_QUERY               0x00000001
#define BSF_IGNORECURRENTTASK   0x00000002
#define BSF_FLUSHDISK           0x00000004
#define BSF_NOHANG              0x00000008
#define BSF_POSTMESSAGE         0x00000010
#define BSF_FORCEIFHUNG         0x00000020
#define BSF_NOTIMEOUTIFNOTHUNG  0x00000040
#if(_WIN32_WINNT >= 0x0500)
#define BSF_ALLOWSFW            0x00000080
#define BSF_SENDNOTIFYMESSAGE   0x00000100
#endif /* _WIN32_WINNT >= 0x0500 */
#if(_WIN32_WINNT >= 0x0501)
#define BSF_RETURNHDESK         0x00000200
#define BSF_LUID                0x00000400
#endif /* _WIN32_WINNT >= 0x0501 */

#define BROADCAST_QUERY_DENY         0x424D5144  // Return this value to deny a query.
#endif /* WINVER >= 0x0400 */

// RegisterDeviceNotification

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if(WINVER >= 0x0500)
typedef  PVOID           HDEVNOTIFY;
typedef  HDEVNOTIFY     *PHDEVNOTIFY;

#define DEVICE_NOTIFY_WINDOW_HANDLE          0x00000000
#define DEVICE_NOTIFY_SERVICE_HANDLE         0x00000001
#if(_WIN32_WINNT >= 0x0501)
#define DEVICE_NOTIFY_ALL_INTERFACE_CLASSES  0x00000004
#endif /* _WIN32_WINNT >= 0x0501 */


HDEVNOTIFY
__stdcall
RegisterDeviceNotificationA(
     HANDLE hRecipient,
     LPVOID NotificationFilter,
     DWORD Flags);

HDEVNOTIFY
__stdcall
RegisterDeviceNotificationW(
     HANDLE hRecipient,
     LPVOID NotificationFilter,
     DWORD Flags);
#ifdef UNICODE
#define RegisterDeviceNotification  RegisterDeviceNotificationW
#else
#define RegisterDeviceNotification  RegisterDeviceNotificationA
#endif // !UNICODE


BOOL
__stdcall
UnregisterDeviceNotification(
     HDEVNOTIFY Handle
    );

#if (_WIN32_WINNT >= 0x0502)

#if !defined(_HPOWERNOTIFY_DEF_)

#define _HPOWERNOTIFY_DEF_

typedef  PVOID           HPOWERNOTIFY;
typedef  HPOWERNOTIFY   *PHPOWERNOTIFY;

#endif


HPOWERNOTIFY
__stdcall
RegisterPowerSettingNotification(
    IN HANDLE hRecipient,
    IN LPCGUID PowerSettingGuid,
    IN DWORD Flags
    );


BOOL
__stdcall
UnregisterPowerSettingNotification(
    IN HPOWERNOTIFY Handle
    );


HPOWERNOTIFY
__stdcall
RegisterSuspendResumeNotification (
    IN HANDLE hRecipient,
    IN DWORD Flags
    );


BOOL
__stdcall
UnregisterSuspendResumeNotification (
    IN HPOWERNOTIFY Handle
    );


#endif // (_WIN32_WINNT >= 0x0502)
#endif /* WINVER >= 0x0500 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
PostMessageA(
     HWND hWnd,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam);

BOOL
__stdcall
PostMessageW(
     HWND hWnd,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam);
#ifdef UNICODE
#define PostMessage  PostMessageW
#else
#define PostMessage  PostMessageA
#endif // !UNICODE


BOOL
__stdcall
PostThreadMessageA(
     DWORD idThread,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam);

BOOL
__stdcall
PostThreadMessageW(
     DWORD idThread,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam);
#ifdef UNICODE
#define PostThreadMessage  PostThreadMessageW
#else
#define PostThreadMessage  PostThreadMessageA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#define PostAppMessageA(idThread, wMsg, wParam, lParam)\
        PostThreadMessageA((DWORD)idThread, wMsg, wParam, lParam)
#define PostAppMessageW(idThread, wMsg, wParam, lParam)\
        PostThreadMessageW((DWORD)idThread, wMsg, wParam, lParam)
#ifdef UNICODE
#define PostAppMessage  PostAppMessageW
#else
#define PostAppMessage  PostAppMessageA
#endif // !UNICODE

/*
 * Special HWND value for use with PostMessage() and SendMessage()
 */
#define HWND_BROADCAST  ((HWND)0xffff)

#if(WINVER >= 0x0500)
#define HWND_MESSAGE     ((HWND)-3)
#endif /* WINVER >= 0x0500 */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
AttachThreadInput(
     DWORD idAttach,
     DWORD idAttachTo,
     BOOL fAttach);



BOOL
__stdcall
ReplyMessage(
     LRESULT lResult);


BOOL
__stdcall
WaitMessage(
    VOID);

#if (_WIN32_WINNT >= 0x602)
#endif



DWORD
__stdcall
WaitForInputIdle(
     HANDLE hProcess,
     DWORD dwMilliseconds);


#ifndef _MAC
LRESULT
__stdcall
#else
LRESULT
__stdcall
#endif
DefWindowProcA(
     HWND hWnd,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam);

#ifndef _MAC
LRESULT
__stdcall
#else
LRESULT
__stdcall
#endif
DefWindowProcW(
     HWND hWnd,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam);
#ifdef UNICODE
#define DefWindowProc  DefWindowProcW
#else
#define DefWindowProc  DefWindowProcA
#endif // !UNICODE


VOID
__stdcall
PostQuitMessage(
     int nExitCode);

#ifdef STRICT


LRESULT
__stdcall
CallWindowProcA(
     WNDPROC lpPrevWndFunc,
     HWND hWnd,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam);

LRESULT
__stdcall
CallWindowProcW(
     WNDPROC lpPrevWndFunc,
     HWND hWnd,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam);
#ifdef UNICODE
#define CallWindowProc  CallWindowProcW
#else
#define CallWindowProc  CallWindowProcA
#endif // !UNICODE

#else /* !STRICT */


LRESULT
__stdcall
CallWindowProcA(
     FARPROC lpPrevWndFunc,
     HWND hWnd,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam);

LRESULT
__stdcall
CallWindowProcW(
     FARPROC lpPrevWndFunc,
     HWND hWnd,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam);
#ifdef UNICODE
#define CallWindowProc  CallWindowProcW
#else
#define CallWindowProc  CallWindowProcA
#endif // !UNICODE

#endif /* !STRICT */


BOOL
__stdcall
InSendMessage(
    VOID);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#if(WINVER >= 0x0500)

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


DWORD
__stdcall
InSendMessageEx(
    LPVOID lpReserved);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/*
 * InSendMessageEx return value
 */
#define ISMEX_NOSEND      0x00000000
#define ISMEX_SEND        0x00000001
#define ISMEX_NOTIFY      0x00000002
#define ISMEX___stdcall    0x00000004
#define ISMEX_REPLIED     0x00000008
#endif /* WINVER >= 0x0500 */


#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


UINT
__stdcall
GetDoubleClickTime(
    VOID);


BOOL
__stdcall
SetDoubleClickTime(
     UINT);


ATOM
__stdcall
RegisterClassA(
     CONST WNDCLASSA *lpWndClass);

ATOM
__stdcall
RegisterClassW(
     CONST WNDCLASSW *lpWndClass);
#ifdef UNICODE
#define RegisterClass  RegisterClassW
#else
#define RegisterClass  RegisterClassA
#endif // !UNICODE


BOOL
__stdcall
UnregisterClassA(
     LPCSTR lpClassName,
     HINSTANCE hInstance);

BOOL
__stdcall
UnregisterClassW(
     LPCWSTR lpClassName,
     HINSTANCE hInstance);
#ifdef UNICODE
#define UnregisterClass  UnregisterClassW
#else
#define UnregisterClass  UnregisterClassA
#endif // !UNICODE

_Success_(return)

BOOL
__stdcall
GetClassInfoA(
     HINSTANCE hInstance,
     LPCSTR lpClassName,
     LPWNDCLASSA lpWndClass);
_Success_(return)

BOOL
__stdcall
GetClassInfoW(
     HINSTANCE hInstance,
     LPCWSTR lpClassName,
     LPWNDCLASSW lpWndClass);
#ifdef UNICODE
#define GetClassInfo  GetClassInfoW
#else
#define GetClassInfo  GetClassInfoA
#endif // !UNICODE

#if(WINVER >= 0x0400)

ATOM
__stdcall
RegisterClassExA(
     CONST WNDCLASSEXA *);

ATOM
__stdcall
RegisterClassExW(
     CONST WNDCLASSEXW *);
#ifdef UNICODE
#define RegisterClassEx  RegisterClassExW
#else
#define RegisterClassEx  RegisterClassExA
#endif // !UNICODE

_Success_(return)

BOOL
__stdcall
GetClassInfoExA(
     HINSTANCE hInstance,
     LPCSTR lpszClass,
     LPWNDCLASSEXA lpwcx);
_Success_(return)

BOOL
__stdcall
GetClassInfoExW(
     HINSTANCE hInstance,
     LPCWSTR lpszClass,
     LPWNDCLASSEXW lpwcx);
#ifdef UNICODE
#define GetClassInfoEx  GetClassInfoExW
#else
#define GetClassInfoEx  GetClassInfoExA
#endif // !UNICODE

#endif /* WINVER >= 0x0400 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#define CW_USEDEFAULT       ((int)0x80000000)

/*
 * Special value for CreateWindow, et al.
 */
#define HWND_DESKTOP        ((HWND)0)

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if(_WIN32_WINNT >= 0x0501)
typedef BOOLEAN (__stdcall * PREGISTERCLASSNAMEW)(LPCWSTR);
#endif /* _WIN32_WINNT >= 0x0501 */


HWND
__stdcall
CreateWindowExA(
     DWORD dwExStyle,
     LPCSTR lpClassName,
     LPCSTR lpWindowName,
     DWORD dwStyle,
     int X,
     int Y,
     int nWidth,
     int nHeight,
     HWND hWndParent,
     HMENU hMenu,
     HINSTANCE hInstance,
     LPVOID lpParam);

HWND
__stdcall
CreateWindowExW(
     DWORD dwExStyle,
     LPCWSTR lpClassName,
     LPCWSTR lpWindowName,
     DWORD dwStyle,
     int X,
     int Y,
     int nWidth,
     int nHeight,
     HWND hWndParent,
     HMENU hMenu,
     HINSTANCE hInstance,
     LPVOID lpParam);
#ifdef UNICODE
#define CreateWindowEx  CreateWindowExW
#else
#define CreateWindowEx  CreateWindowExA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#define CreateWindowA(lpClassName, lpWindowName, dwStyle, x, y,\
nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam)\
CreateWindowExA(0L, lpClassName, lpWindowName, dwStyle, x, y,\
nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam)
#define CreateWindowW(lpClassName, lpWindowName, dwStyle, x, y,\
nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam)\
CreateWindowExW(0L, lpClassName, lpWindowName, dwStyle, x, y,\
nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam)
#ifdef UNICODE
#define CreateWindow  CreateWindowW
#else
#define CreateWindow  CreateWindowA
#endif // !UNICODE

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)



BOOL
__stdcall
IsWindow(
     HWND hWnd);



BOOL
__stdcall
IsMenu(
     HMENU hMenu);


BOOL
__stdcall
IsChild(
     HWND hWndParent,
     HWND hWnd);


BOOL
__stdcall
DestroyWindow(
     HWND hWnd);


BOOL
__stdcall
ShowWindow(
     HWND hWnd,
     int nCmdShow);

#if(WINVER >= 0x0500)

BOOL
__stdcall
AnimateWindow(
     HWND hWnd,
     DWORD dwTime,
     DWORD dwFlags);
#endif /* WINVER >= 0x0500 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#if(_WIN32_WINNT >= 0x0500)
#if defined(_WINGDI_) && !defined(NOGDI)

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
UpdateLayeredWindow(
     HWND hWnd,
     HDC hdcDst,
     POINT* pptDst,
     SIZE* psize,
     HDC hdcSrc,
     POINT* pptSrc,
     COLORREF crKey,
     BLENDFUNCTION* pblend,
     DWORD dwFlags);

/*
 * Layered Window Update information
 */
typedef struct tagUPDATELAYEREDWINDOWINFO
{
    DWORD cbSize;
    HDC hdcDst;
    const POINT* pptDst;
    const SIZE* psize;
    HDC hdcSrc;
    const POINT* pptSrc;
    COLORREF crKey;
    const BLENDFUNCTION* pblend;
    DWORD dwFlags;
    const RECT* prcDirty;
} UPDATELAYEREDWINDOWINFO, *PUPDATELAYEREDWINDOWINFO;


#if (_WIN32_WINNT < 0x0502)
typedef
#endif /* _WIN32_WINNT < 0x0502 */

BOOL
__stdcall
UpdateLayeredWindowIndirect(
     HWND hWnd,
     const UPDATELAYEREDWINDOWINFO* pULWInfo);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif

#if(_WIN32_WINNT >= 0x0501)

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
GetLayeredWindowAttributes(
     HWND hwnd,
    _Out_opt_ COLORREF* pcrKey,
    _Out_opt_ BYTE* pbAlpha,
    _Out_opt_ DWORD* pdwFlags);

#define PW_CLIENTONLY           0x00000001

#if(_WIN32_WINNT >= 0x0603)
#define PW_RENDERFULLCONTENT    0x00000002
#endif /* _WIN32_WINNT >= 0x0603 */



BOOL
__stdcall
PrintWindow(
     HWND hwnd,
     HDC hdcBlt,
     UINT nFlags);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* _WIN32_WINNT >= 0x0501 */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
SetLayeredWindowAttributes(
     HWND hwnd,
     COLORREF crKey,
     BYTE bAlpha,
     DWORD dwFlags);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#define LWA_COLORKEY            0x00000001
#define LWA_ALPHA               0x00000002


#define ULW_COLORKEY            0x00000001
#define ULW_ALPHA               0x00000002
#define ULW_OPAQUE              0x00000004

#define ULW_EX_NORESIZE         0x00000008

#endif /* _WIN32_WINNT >= 0x0500 */


#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


#if(WINVER >= 0x0400)

BOOL
__stdcall
ShowWindowAsync(
      HWND hWnd,
      int nCmdShow);
#endif /* WINVER >= 0x0400 */


BOOL
__stdcall
FlashWindow(
      HWND hWnd,
      BOOL bInvert);

#if(WINVER >= 0x0500)
typedef struct {
    UINT  cbSize;
    HWND  hwnd;
    DWORD dwFlags;
    UINT  uCount;
    DWORD dwTimeout;
} FLASHWINFO, *PFLASHWINFO;


BOOL
__stdcall
FlashWindowEx(
     PFLASHWINFO pfwi);

#define FLASHW_STOP         0
#define FLASHW_CAPTION      0x00000001
#define FLASHW_TRAY         0x00000002
#define FLASHW_ALL          (FLASHW_CAPTION | FLASHW_TRAY)
#define FLASHW_TIMER        0x00000004
#define FLASHW_TIMERNOFG    0x0000000C

#endif /* WINVER >= 0x0500 */


BOOL
__stdcall
ShowOwnedPopups(
      HWND hWnd,
      BOOL fShow);


BOOL
__stdcall
OpenIcon(
      HWND hWnd);


BOOL
__stdcall
CloseWindow(
      HWND hWnd);


BOOL
__stdcall
MoveWindow(
     HWND hWnd,
     int X,
     int Y,
     int nWidth,
     int nHeight,
     BOOL bRepaint);


BOOL
__stdcall
SetWindowPos(
     HWND hWnd,
     HWND hWndInsertAfter,
     int X,
     int Y,
     int cx,
     int cy,
     UINT uFlags);


BOOL
__stdcall
GetWindowPlacement(
     HWND hWnd,
     WINDOWPLACEMENT *lpwndpl);


BOOL
__stdcall
SetWindowPlacement(
     HWND hWnd,
     CONST WINDOWPLACEMENT *lpwndpl);

#if(_WIN32_WINNT >= 0x0601)
#define WDA_NONE        0x00000000
#define WDA_MONITOR     0x00000001



BOOL
__stdcall
GetWindowDisplayAffinity(
     HWND hWnd,
     DWORD* pdwAffinity);


BOOL
__stdcall
SetWindowDisplayAffinity(
     HWND hWnd,
     DWORD dwAffinity);

#endif /* _WIN32_WINNT >= 0x0601 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#ifndef NODEFERWINDOWPOS

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


HDWP
__stdcall
BeginDeferWindowPos(
     int nNumWindows);


HDWP
__stdcall
DeferWindowPos(
     HDWP hWinPosInfo,
     HWND hWnd,
     HWND hWndInsertAfter,
     int x,
     int y,
     int cx,
     int cy,
     UINT uFlags);



BOOL
__stdcall
EndDeferWindowPos(
     HDWP hWinPosInfo);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* !NODEFERWINDOWPOS */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
IsWindowVisible(
     HWND hWnd);


BOOL
__stdcall
IsIconic(
     HWND hWnd);


BOOL
__stdcall
AnyPopup(
    VOID);


BOOL
__stdcall
BringWindowToTop(
     HWND hWnd);


BOOL
__stdcall
IsZoomed(
     HWND hWnd);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/*
 * SetWindowPos Flags
 */
#define SWP_NOSIZE          0x0001
#define SWP_NOMOVE          0x0002
#define SWP_NOZORDER        0x0004
#define SWP_NOREDRAW        0x0008
#define SWP_NOACTIVATE      0x0010
#define SWP_FRAMECHANGED    0x0020  /* The frame changed: send WM_NCCALCSIZE */
#define SWP_SHOWWINDOW      0x0040
#define SWP_HIDEWINDOW      0x0080
#define SWP_NOCOPYBITS      0x0100
#define SWP_NOOWNERZORDER   0x0200  /* Don't do owner Z ordering */
#define SWP_NOSENDCHANGING  0x0400  /* Don't send WM_WINDOWPOSCHANGING */

#define SWP_DRAWFRAME       SWP_FRAMECHANGED
#define SWP_NOREPOSITION    SWP_NOOWNERZORDER

#if(WINVER >= 0x0400)
#define SWP_DEFERERASE      0x2000
#define SWP_ASYNCWINDOWPOS  0x4000
#endif /* WINVER >= 0x0400 */


#define HWND_TOP        ((HWND)0)
#define HWND_BOTTOM     ((HWND)1)
#define HWND_TOPMOST    ((HWND)-1)
#define HWND_NOTOPMOST  ((HWND)-2)

#ifndef NOCTLMGR

/*
 * WARNING:
 * The following structures must NOT be DWORD padded because they are
 * followed by strings, etc that do not have to be DWORD aligned.
 */
#include <pshpack2.h>

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

/*
 * original NT 32 bit dialog template:
 */
typedef struct {
    DWORD style;
    DWORD dwExtendedStyle;
    WORD cdit;
    short x;
    short y;
    short cx;
    short cy;
} DLGTEMPLATE;

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

typedef DLGTEMPLATE *LPDLGTEMPLATEA;
typedef DLGTEMPLATE *LPDLGTEMPLATEW;
#ifdef UNICODE
typedef LPDLGTEMPLATEW LPDLGTEMPLATE;
#else
typedef LPDLGTEMPLATEA LPDLGTEMPLATE;
#endif // UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

typedef CONST DLGTEMPLATE *LPCDLGTEMPLATEA;
typedef CONST DLGTEMPLATE *LPCDLGTEMPLATEW;
#ifdef UNICODE
typedef LPCDLGTEMPLATEW LPCDLGTEMPLATE;
#else
typedef LPCDLGTEMPLATEA LPCDLGTEMPLATE;
#endif // UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion


#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

/*
 * 32 bit Dialog item template.
 */
typedef struct {
    DWORD style;
    DWORD dwExtendedStyle;
    short x;
    short y;
    short cx;
    short cy;
    WORD id;
} DLGITEMTEMPLATE;
typedef DLGITEMTEMPLATE *PDLGITEMTEMPLATEA;
typedef DLGITEMTEMPLATE *PDLGITEMTEMPLATEW;
#ifdef UNICODE
typedef PDLGITEMTEMPLATEW PDLGITEMTEMPLATE;
#else
typedef PDLGITEMTEMPLATEA PDLGITEMTEMPLATE;
#endif // UNICODE
typedef DLGITEMTEMPLATE *LPDLGITEMTEMPLATEA;
typedef DLGITEMTEMPLATE *LPDLGITEMTEMPLATEW;
#ifdef UNICODE
typedef LPDLGITEMTEMPLATEW LPDLGITEMTEMPLATE;
#else
typedef LPDLGITEMTEMPLATEA LPDLGITEMTEMPLATE;
#endif // UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion


#include <poppack.h> /* Resume normal packing */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


HWND
__stdcall
CreateDialogParamA(
     HINSTANCE hInstance,
     LPCSTR lpTemplateName,
     HWND hWndParent,
     DLGPROC lpDialogFunc,
     LPARAM dwInitParam);

HWND
__stdcall
CreateDialogParamW(
     HINSTANCE hInstance,
     LPCWSTR lpTemplateName,
     HWND hWndParent,
     DLGPROC lpDialogFunc,
     LPARAM dwInitParam);
#ifdef UNICODE
#define CreateDialogParam  CreateDialogParamW
#else
#define CreateDialogParam  CreateDialogParamA
#endif // !UNICODE


HWND
__stdcall
CreateDialogIndirectParamA(
     HINSTANCE hInstance,
     LPCDLGTEMPLATEA lpTemplate,
     HWND hWndParent,
     DLGPROC lpDialogFunc,
     LPARAM dwInitParam);

HWND
__stdcall
CreateDialogIndirectParamW(
     HINSTANCE hInstance,
     LPCDLGTEMPLATEW lpTemplate,
     HWND hWndParent,
     DLGPROC lpDialogFunc,
     LPARAM dwInitParam);
#ifdef UNICODE
#define CreateDialogIndirectParam  CreateDialogIndirectParamW
#else
#define CreateDialogIndirectParam  CreateDialogIndirectParamA
#endif // !UNICODE

#define CreateDialogA(hInstance, lpName, hWndParent, lpDialogFunc) \
CreateDialogParamA(hInstance, lpName, hWndParent, lpDialogFunc, 0L)
#define CreateDialogW(hInstance, lpName, hWndParent, lpDialogFunc) \
CreateDialogParamW(hInstance, lpName, hWndParent, lpDialogFunc, 0L)
#ifdef UNICODE
#define CreateDialog  CreateDialogW
#else
#define CreateDialog  CreateDialogA
#endif // !UNICODE

#define CreateDialogIndirectA(hInstance, lpTemplate, hWndParent, lpDialogFunc) \
CreateDialogIndirectParamA(hInstance, lpTemplate, hWndParent, lpDialogFunc, 0L)
#define CreateDialogIndirectW(hInstance, lpTemplate, hWndParent, lpDialogFunc) \
CreateDialogIndirectParamW(hInstance, lpTemplate, hWndParent, lpDialogFunc, 0L)
#ifdef UNICODE
#define CreateDialogIndirect  CreateDialogIndirectW
#else
#define CreateDialogIndirect  CreateDialogIndirectA
#endif // !UNICODE


INT_PTR
__stdcall
DialogBoxParamA(
     HINSTANCE hInstance,
     LPCSTR lpTemplateName,
     HWND hWndParent,
     DLGPROC lpDialogFunc,
     LPARAM dwInitParam);

INT_PTR
__stdcall
DialogBoxParamW(
     HINSTANCE hInstance,
     LPCWSTR lpTemplateName,
     HWND hWndParent,
     DLGPROC lpDialogFunc,
     LPARAM dwInitParam);
#ifdef UNICODE
#define DialogBoxParam  DialogBoxParamW
#else
#define DialogBoxParam  DialogBoxParamA
#endif // !UNICODE


INT_PTR
__stdcall
DialogBoxIndirectParamA(
     HINSTANCE hInstance,
     LPCDLGTEMPLATEA hDialogTemplate,
     HWND hWndParent,
     DLGPROC lpDialogFunc,
     LPARAM dwInitParam);

INT_PTR
__stdcall
DialogBoxIndirectParamW(
     HINSTANCE hInstance,
     LPCDLGTEMPLATEW hDialogTemplate,
     HWND hWndParent,
     DLGPROC lpDialogFunc,
     LPARAM dwInitParam);
#ifdef UNICODE
#define DialogBoxIndirectParam  DialogBoxIndirectParamW
#else
#define DialogBoxIndirectParam  DialogBoxIndirectParamA
#endif // !UNICODE

#define DialogBoxA(hInstance, lpTemplate, hWndParent, lpDialogFunc) \
DialogBoxParamA(hInstance, lpTemplate, hWndParent, lpDialogFunc, 0L)
#define DialogBoxW(hInstance, lpTemplate, hWndParent, lpDialogFunc) \
DialogBoxParamW(hInstance, lpTemplate, hWndParent, lpDialogFunc, 0L)
#ifdef UNICODE
#define DialogBox  DialogBoxW
#else
#define DialogBox  DialogBoxA
#endif // !UNICODE

#define DialogBoxIndirectA(hInstance, lpTemplate, hWndParent, lpDialogFunc) \
DialogBoxIndirectParamA(hInstance, lpTemplate, hWndParent, lpDialogFunc, 0L)
#define DialogBoxIndirectW(hInstance, lpTemplate, hWndParent, lpDialogFunc) \
DialogBoxIndirectParamW(hInstance, lpTemplate, hWndParent, lpDialogFunc, 0L)
#ifdef UNICODE
#define DialogBoxIndirect  DialogBoxIndirectW
#else
#define DialogBoxIndirect  DialogBoxIndirectA
#endif // !UNICODE


BOOL
__stdcall
EndDialog(
     HWND hDlg,
     INT_PTR nResult);


HWND
__stdcall
GetDlgItem(
     HWND hDlg,
     int nIDDlgItem);


BOOL
__stdcall
SetDlgItemInt(
     HWND hDlg,
     int nIDDlgItem,
     UINT uValue,
     BOOL bSigned);


UINT
__stdcall
GetDlgItemInt(
     HWND hDlg,
     int nIDDlgItem,
    _Out_opt_ BOOL *lpTranslated,
     BOOL bSigned);


BOOL
__stdcall
SetDlgItemTextA(
     HWND hDlg,
     int nIDDlgItem,
     LPCSTR lpString);

BOOL
__stdcall
SetDlgItemTextW(
     HWND hDlg,
     int nIDDlgItem,
     LPCWSTR lpString);
#ifdef UNICODE
#define SetDlgItemText  SetDlgItemTextW
#else
#define SetDlgItemText  SetDlgItemTextA
#endif // !UNICODE

_Ret_range_(0, cchMax)

UINT
__stdcall
GetDlgItemTextA(
     HWND hDlg,
     int nIDDlgItem,
    _Out_writes_(cchMax) LPSTR lpString,
     int cchMax);
_Ret_range_(0, cchMax)

UINT
__stdcall
GetDlgItemTextW(
     HWND hDlg,
     int nIDDlgItem,
    _Out_writes_(cchMax) LPWSTR lpString,
     int cchMax);
#ifdef UNICODE
#define GetDlgItemText  GetDlgItemTextW
#else
#define GetDlgItemText  GetDlgItemTextA
#endif // !UNICODE


BOOL
__stdcall
CheckDlgButton(
     HWND hDlg,
     int nIDButton,
     UINT uCheck);


BOOL
__stdcall
CheckRadioButton(
     HWND hDlg,
     int nIDFirstButton,
     int nIDLastButton,
     int nIDCheckButton);


UINT
__stdcall
IsDlgButtonChecked(
     HWND hDlg,
     int nIDButton);


LRESULT
__stdcall
SendDlgItemMessageA(
     HWND hDlg,
     int nIDDlgItem,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam);

LRESULT
__stdcall
SendDlgItemMessageW(
     HWND hDlg,
     int nIDDlgItem,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam);
#ifdef UNICODE
#define SendDlgItemMessage  SendDlgItemMessageW
#else
#define SendDlgItemMessage  SendDlgItemMessageA
#endif // !UNICODE


HWND
__stdcall
GetNextDlgGroupItem(
     HWND hDlg,
     HWND hCtl,
     BOOL bPrevious);


HWND
__stdcall
GetNextDlgTabItem(
     HWND hDlg,
     HWND hCtl,
     BOOL bPrevious);


int
__stdcall
GetDlgCtrlID(
     HWND hWnd);


long
__stdcall
GetDialogBaseUnits(VOID);



#ifndef _MAC
LRESULT
__stdcall
#else
LRESULT
__stdcall
#endif
DefDlgProcA(
     HWND hDlg,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam);

#ifndef _MAC
LRESULT
__stdcall
#else
LRESULT
__stdcall
#endif
DefDlgProcW(
     HWND hDlg,
     UINT Msg,
     WPARAM wParam,
     LPARAM lParam);
#ifdef UNICODE
#define DefDlgProc  DefDlgProcW
#else
#define DefDlgProc  DefDlgProcA
#endif // !UNICODE


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/*
 * Window extra byted needed for private dialog classes.
 */
#ifndef _MAC
#define DLGWINDOWEXTRA 30
#else
#define DLGWINDOWEXTRA 48
#endif

#endif /* !NOCTLMGR */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#ifndef NOMSG


BOOL
__stdcall
CallMsgFilterA(
     LPMSG lpMsg,
     int nCode);

BOOL
__stdcall
CallMsgFilterW(
     LPMSG lpMsg,
     int nCode);
#ifdef UNICODE
#define CallMsgFilter  CallMsgFilterW
#else
#define CallMsgFilter  CallMsgFilterA
#endif // !UNICODE

#endif /* !NOMSG */

#ifndef NOCLIPBOARD

/*
 * Clipboard Manager Functions
 */


BOOL
__stdcall
OpenClipboard(
     HWND hWndNewOwner);


BOOL
__stdcall
CloseClipboard(
    VOID);


#if(WINVER >= 0x0500)


DWORD
__stdcall
GetClipboardSequenceNumber(
    VOID);

#endif /* WINVER >= 0x0500 */


HWND
__stdcall
GetClipboardOwner(
    VOID);


HWND
__stdcall
SetClipboardViewer(
     HWND hWndNewViewer);


HWND
__stdcall
GetClipboardViewer(
    VOID);


BOOL
__stdcall
ChangeClipboardChain(
     HWND hWndRemove,
     HWND hWndNewNext);


HANDLE
__stdcall
SetClipboardData(
     UINT uFormat,
     HANDLE hMem);


HANDLE
__stdcall
GetClipboardData(
     UINT uFormat);


UINT
__stdcall
RegisterClipboardFormatA(
     LPCSTR lpszFormat);

UINT
__stdcall
RegisterClipboardFormatW(
     LPCWSTR lpszFormat);
#ifdef UNICODE
#define RegisterClipboardFormat  RegisterClipboardFormatW
#else
#define RegisterClipboardFormat  RegisterClipboardFormatA
#endif // !UNICODE


int
__stdcall
CountClipboardFormats(
    VOID);


UINT
__stdcall
EnumClipboardFormats(
     UINT format);


int
__stdcall
GetClipboardFormatNameA(
     UINT format,
    _Out_writes_(cchMaxCount) LPSTR lpszFormatName,
     int cchMaxCount);

int
__stdcall
GetClipboardFormatNameW(
     UINT format,
    _Out_writes_(cchMaxCount) LPWSTR lpszFormatName,
     int cchMaxCount);
#ifdef UNICODE
#define GetClipboardFormatName  GetClipboardFormatNameW
#else
#define GetClipboardFormatName  GetClipboardFormatNameA
#endif // !UNICODE


BOOL
__stdcall
EmptyClipboard(
    VOID);


BOOL
__stdcall
IsClipboardFormatAvailable(
     UINT format);


int
__stdcall
GetPriorityClipboardFormat(
    _In_reads_(cFormats) UINT *paFormatPriorityList,
     int cFormats);


HWND
__stdcall
GetOpenClipboardWindow(
    VOID);

#if(WINVER >= 0x0600)

BOOL
__stdcall
AddClipboardFormatListener(
     HWND hwnd);


BOOL
__stdcall
RemoveClipboardFormatListener(
     HWND hwnd);


BOOL
__stdcall
GetUpdatedClipboardFormats(
    _Out_writes_(cFormats) PUINT lpuiFormats,
     UINT cFormats,
     PUINT pcFormatsOut);
#endif /* WINVER >= 0x0600 */

#endif /* !NOCLIPBOARD */

/*
 * Character Translation Routines
 */


BOOL
__stdcall
CharToOemA(
     LPCSTR pSrc,
    _Out_writes_(_Inexpressible_(strlen(pSrc) + 1)) LPSTR pDst);

BOOL
__stdcall
CharToOemW(
     LPCWSTR pSrc,
    _Out_writes_(_Inexpressible_(strlen(pSrc) + 1)) LPSTR pDst);
#ifdef UNICODE
#define CharToOem  CharToOemW
#else
#define CharToOem  CharToOemA
#endif // !UNICODE

__drv_preferredFunction("OemToCharBuff","Does not validate buffer size")

BOOL
__stdcall
OemToCharA(
     LPCSTR pSrc,
    _Out_writes_(_Inexpressible_(strlen(pSrc) + 1)) LPSTR pDst);
__drv_preferredFunction("OemToCharBuff","Does not validate buffer size")

BOOL
__stdcall
OemToCharW(
     LPCSTR pSrc,
    _Out_writes_(_Inexpressible_(strlen(pSrc) + 1)) LPWSTR pDst);
#ifdef UNICODE
#define OemToChar  OemToCharW
#else
#define OemToChar  OemToCharA
#endif // !UNICODE


BOOL
__stdcall
CharToOemBuffA(
     LPCSTR lpszSrc,
    _Out_writes_(cchDstLength) LPSTR lpszDst,
     DWORD cchDstLength);

BOOL
__stdcall
CharToOemBuffW(
     LPCWSTR lpszSrc,
    _Out_writes_(cchDstLength) LPSTR lpszDst,
     DWORD cchDstLength);
#ifdef UNICODE
#define CharToOemBuff  CharToOemBuffW
#else
#define CharToOemBuff  CharToOemBuffA
#endif // !UNICODE


BOOL
__stdcall
OemToCharBuffA(
     LPCSTR lpszSrc,
    _Out_writes_(cchDstLength) LPSTR lpszDst,
     DWORD cchDstLength);

BOOL
__stdcall
OemToCharBuffW(
     LPCSTR lpszSrc,
    _Out_writes_(cchDstLength) LPWSTR lpszDst,
     DWORD cchDstLength);
#ifdef UNICODE
#define OemToCharBuff  OemToCharBuffW
#else
#define OemToCharBuff  OemToCharBuffA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


LPSTR
__stdcall
CharUpperA(
     LPSTR lpsz);

LPWSTR
__stdcall
CharUpperW(
     LPWSTR lpsz);
#ifdef UNICODE
#define CharUpper  CharUpperW
#else
#define CharUpper  CharUpperA
#endif // !UNICODE


DWORD
__stdcall
CharUpperBuffA(
    _Inout_updates_(cchLength) LPSTR lpsz,
     DWORD cchLength);

DWORD
__stdcall
CharUpperBuffW(
    _Inout_updates_(cchLength) LPWSTR lpsz,
     DWORD cchLength);
#ifdef UNICODE
#define CharUpperBuff  CharUpperBuffW
#else
#define CharUpperBuff  CharUpperBuffA
#endif // !UNICODE


LPSTR
__stdcall
CharLowerA(
     LPSTR lpsz);

LPWSTR
__stdcall
CharLowerW(
     LPWSTR lpsz);
#ifdef UNICODE
#define CharLower  CharLowerW
#else
#define CharLower  CharLowerA
#endif // !UNICODE


DWORD
__stdcall
CharLowerBuffA(
    _Inout_updates_(cchLength) LPSTR lpsz,
     DWORD cchLength);

DWORD
__stdcall
CharLowerBuffW(
    _Inout_updates_(cchLength) LPWSTR lpsz,
     DWORD cchLength);
#ifdef UNICODE
#define CharLowerBuff  CharLowerBuffW
#else
#define CharLowerBuff  CharLowerBuffA
#endif // !UNICODE


LPSTR
__stdcall
CharNextA(
     LPCSTR lpsz);

LPWSTR
__stdcall
CharNextW(
     LPCWSTR lpsz);
#ifdef UNICODE
#define CharNext  CharNextW
#else
#define CharNext  CharNextA
#endif // !UNICODE


LPSTR
__stdcall
CharPrevA(
     LPCSTR lpszStart,
     LPCSTR lpszCurrent);

LPWSTR
__stdcall
CharPrevW(
     LPCWSTR lpszStart,
     LPCWSTR lpszCurrent);
#ifdef UNICODE
#define CharPrev  CharPrevW
#else
#define CharPrev  CharPrevA
#endif // !UNICODE

#if(WINVER >= 0x0400)

LPSTR
__stdcall
CharNextExA(
      WORD CodePage,
      LPCSTR lpCurrentChar,
      DWORD dwFlags);


LPSTR
__stdcall
CharPrevExA(
      WORD CodePage,
      LPCSTR lpStart,
      LPCSTR lpCurrentChar,
      DWORD dwFlags);
#endif /* WINVER >= 0x0400 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

/*
 * Compatibility defines for character translation routines
 */
#define AnsiToOem CharToOemA
#define OemToAnsi OemToCharA
#define AnsiToOemBuff CharToOemBuffA
#define OemToAnsiBuff OemToCharBuffA
#define AnsiUpper CharUpperA
#define AnsiUpperBuff CharUpperBuffA
#define AnsiLower CharLowerA
#define AnsiLowerBuff CharLowerBuffA
#define AnsiNext CharNextA
#define AnsiPrev CharPrevA

#pragma region Desktop or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

#ifndef  NOLANGUAGE
/*
 * Language dependent Routines
 */


BOOL
__stdcall
IsCharAlphaA(
     CHAR ch);

BOOL
__stdcall
IsCharAlphaW(
     WCHAR ch);
#ifdef UNICODE
#define IsCharAlpha  IsCharAlphaW
#else
#define IsCharAlpha  IsCharAlphaA
#endif // !UNICODE


BOOL
__stdcall
IsCharAlphaNumericA(
     CHAR ch);

BOOL
__stdcall
IsCharAlphaNumericW(
     WCHAR ch);
#ifdef UNICODE
#define IsCharAlphaNumeric  IsCharAlphaNumericW
#else
#define IsCharAlphaNumeric  IsCharAlphaNumericA
#endif // !UNICODE


BOOL
__stdcall
IsCharUpperA(
     CHAR ch);

BOOL
__stdcall
IsCharUpperW(
     WCHAR ch);
#ifdef UNICODE
#define IsCharUpper  IsCharUpperW
#else
#define IsCharUpper  IsCharUpperA
#endif // !UNICODE


BOOL
__stdcall
IsCharLowerA(
     CHAR ch);

BOOL
__stdcall
IsCharLowerW(
     WCHAR ch);
#ifdef UNICODE
#define IsCharLower  IsCharLowerW
#else
#define IsCharLower  IsCharLowerA
#endif // !UNICODE

#endif  /* !NOLANGUAGE */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)
--]=]

ffi.cdef[[
HWND
__stdcall
SetFocus(
     HWND hWnd);


HWND
__stdcall
GetActiveWindow(void);


HWND
__stdcall
GetFocus(
    void);


UINT
__stdcall
GetKBCodePage(
    void);


SHORT
__stdcall
GetKeyState(
     int nVirtKey);


SHORT
__stdcall
GetAsyncKeyState(
     int vKey);



BOOL
__stdcall
GetKeyboardState(PBYTE lpKeyState);


BOOL
__stdcall
SetKeyboardState(LPBYTE lpKeyState);
]]
	
ffi.cdef[[
int
__stdcall
GetKeyNameTextA(
     LONG lParam,
    LPSTR lpString,
     int cchSize);

int
__stdcall
GetKeyNameTextW(
     LONG lParam,
    LPWSTR lpString,
     int cchSize);
]]

--[[
#ifdef UNICODE
#define GetKeyNameText  GetKeyNameTextW
#else
#define GetKeyNameText  GetKeyNameTextA
#endif // !UNICODE
--]]

ffi.cdef[[
int
__stdcall
GetKeyboardType(
     int nTypeFlag);


int
__stdcall
ToAscii(
     UINT uVirtKey,
     UINT uScanCode,
    const BYTE *lpKeyState,
     LPWORD lpChar,
     UINT uFlags);

int
__stdcall
ToAsciiEx(
     UINT uVirtKey,
     UINT uScanCode,
    const BYTE *lpKeyState,
     LPWORD lpChar,
     UINT uFlags,
     HKL dwhkl);
]]

ffi.cdef[[
int
__stdcall
ToUnicode(
     UINT wVirtKey,
     UINT wScanCode,
    const BYTE *lpKeyState,
    LPWSTR pwszBuff,
     int cchBuff,
     UINT wFlags);


DWORD
__stdcall
OemKeyScan(
     WORD wOemChar);


SHORT
__stdcall
VkKeyScanA(
     CHAR ch);

SHORT
__stdcall
VkKeyScanW(
     WCHAR ch);
]]

--[[
#ifdef UNICODE
#define VkKeyScan  VkKeyScanW
#else
#define VkKeyScan  VkKeyScanA
#endif // !UNICODE
--]]

ffi.cdef[[
SHORT
__stdcall
VkKeyScanExA(
     CHAR ch,
     HKL dwhkl);

SHORT
__stdcall
VkKeyScanExW(
     WCHAR ch,
     HKL dwhkl);
]]

--[[
#ifdef UNICODE
#define VkKeyScanEx  VkKeyScanExW
#else
#define VkKeyScanEx  VkKeyScanExA
#endif // !UNICODE
--]]

ffi.cdef[[
static const int KEYEVENTF_EXTENDEDKEY =0x0001;
static const int KEYEVENTF_KEYUP       =0x0002;
static const int KEYEVENTF_UNICODE     =0x0004;
static const int KEYEVENTF_SCANCODE    =0x0008;
]]

ffi.cdef[[
void
__stdcall
keybd_event(
     BYTE bVk,
     BYTE bScan,
     DWORD dwFlags,
     ULONG_PTR dwExtraInfo);
]]


--[=[
static const int MOUSEEVENTF_MOVE      =  0x0001; /* mouse move */
#define MOUSEEVENTF_LEFTDOWN    0x0002 /* left button down */
#define MOUSEEVENTF_LEFTUP      0x0004 /* left button up */
#define MOUSEEVENTF_RIGHTDOWN   0x0008 /* right button down */
#define MOUSEEVENTF_RIGHTUP     0x0010 /* right button up */
#define MOUSEEVENTF_MIDDLEDOWN  0x0020 /* middle button down */
#define MOUSEEVENTF_MIDDLEUP    0x0040 /* middle button up */
#define MOUSEEVENTF_XDOWN       0x0080 /* x button down */
#define MOUSEEVENTF_XUP         0x0100 /* x button down */
#define MOUSEEVENTF_WHEEL                0x0800 /* wheel button rolled */

#define MOUSEEVENTF_HWHEEL              0x01000 /* hwheel button rolled */


#define MOUSEEVENTF_MOVE_NOCOALESCE      0x2000 /* do not coalesce mouse moves */

#define MOUSEEVENTF_VIRTUALDESK          0x4000 /* map to entire virtual desktop */
#define MOUSEEVENTF_ABSOLUTE             0x8000 /* absolute move */




VOID
__stdcall
mouse_event(
     DWORD dwFlags,
     DWORD dx,
     DWORD dy,
     DWORD dwData,
     ULONG_PTR dwExtraInfo);


typedef struct tagMOUSEINPUT {
    LONG    dx;
    LONG    dy;
    DWORD   mouseData;
    DWORD   dwFlags;
    DWORD   time;
    ULONG_PTR dwExtraInfo;
} MOUSEINPUT, *PMOUSEINPUT, FAR* LPMOUSEINPUT;

typedef struct tagKEYBDINPUT {
    WORD    wVk;
    WORD    wScan;
    DWORD   dwFlags;
    DWORD   time;
    ULONG_PTR dwExtraInfo;
} KEYBDINPUT, *PKEYBDINPUT, FAR* LPKEYBDINPUT;


typedef struct tagHARDWAREINPUT {
    DWORD   uMsg;
    WORD    wParamL;
    WORD    wParamH;
} HARDWAREINPUT, *PHARDWAREINPUT, FAR* LPHARDWAREINPUT;

#define INPUT_MOUSE     0
#define INPUT_KEYBOARD  1
#define INPUT_HARDWARE  2

typedef struct tagINPUT {
    DWORD   type;

    union
    {
        MOUSEINPUT      mi;
        KEYBDINPUT      ki;
        HARDWAREINPUT   hi;
    } DUMMYUNIONNAME;
} INPUT, *PINPUT, FAR* LPINPUT;


UINT
__stdcall
SendInput(
     UINT cInputs,                     // number of input in the array
    _In_reads_(cInputs) LPINPUT pInputs,  // array of inputs
     int cbSize);                      // sizeof(INPUT)


/*
 * Touch Input defines and functions
 */

/*
 * Touch input handle
 */
DECLARE_HANDLE(HTOUCHINPUT);

typedef struct tagTOUCHINPUT {
    LONG x;
    LONG y;
    HANDLE hSource;
    DWORD dwID;
    DWORD dwFlags;
    DWORD dwMask;
    DWORD dwTime;
    ULONG_PTR dwExtraInfo;
    DWORD cxContact;
    DWORD cyContact;
} TOUCHINPUT, *PTOUCHINPUT;
typedef TOUCHINPUT const * PCTOUCHINPUT;


/*
 * Conversion of touch input coordinates to pixels
 */
#define TOUCH_COORD_TO_PIXEL(l)         ((l) / 100)

/*
 * Touch input flag values (TOUCHINPUT.dwFlags)
 */
#define TOUCHEVENTF_MOVE            0x0001
#define TOUCHEVENTF_DOWN            0x0002
#define TOUCHEVENTF_UP              0x0004
#define TOUCHEVENTF_INRANGE         0x0008
#define TOUCHEVENTF_PRIMARY         0x0010
#define TOUCHEVENTF_NOCOALESCE      0x0020
#define TOUCHEVENTF_PEN             0x0040
#define TOUCHEVENTF_PALM            0x0080

/*
 * Touch input mask values (TOUCHINPUT.dwMask)
 */
#define TOUCHINPUTMASKF_TIMEFROMSYSTEM  0x0001  // the dwTime field contains a system generated value
#define TOUCHINPUTMASKF_EXTRAINFO       0x0002  // the dwExtraInfo field is valid
#define TOUCHINPUTMASKF_CONTACTAREA     0x0004  // the cxContact and cyContact fields are valid

BOOL
__stdcall
GetTouchInputInfo(
     HTOUCHINPUT hTouchInput,               // input event handle; from touch message lParam
     UINT cInputs,                          // number of elements in the array
    PTOUCHINPUT pInputs,  // array of touch inputs
     int cbSize);                           // sizeof(TOUCHINPUT)


BOOL
__stdcall
CloseTouchInputHandle(
     HTOUCHINPUT hTouchInput);                   // input event handle; from touch message lParam



/*
 * RegisterTouchWindow flag values
 */
#define TWF_FINETOUCH       (0x00000001)
#define TWF_WANTPALM        (0x00000002)

BOOL
__stdcall
RegisterTouchWindow(
     HWND hwnd,
     ULONG ulFlags);


BOOL
__stdcall
UnregisterTouchWindow(
     HWND hwnd);


BOOL
__stdcall
IsTouchWindow(
     HWND hwnd,
    _Out_opt_ PULONG pulFlags);


#define POINTER_STRUCTURES

enum tagPOINTER_INPUT_TYPE {
    PT_POINTER  = 0x00000001,   // Generic pointer
    PT_TOUCH    = 0x00000002,   // Touch
    PT_PEN      = 0x00000003,   // Pen
    PT_MOUSE    = 0x00000004,   // Mouse

    PT_TOUCHPAD = 0x00000005,   // Touchpad

};


typedef DWORD POINTER_INPUT_TYPE;

typedef UINT32 POINTER_FLAGS;


#define POINTER_FLAG_NONE               0x00000000 // Default
#define POINTER_FLAG_NEW                0x00000001 // New pointer
#define POINTER_FLAG_INRANGE            0x00000002 // Pointer has not departed
#define POINTER_FLAG_INCONTACT          0x00000004 // Pointer is in contact
#define POINTER_FLAG_FIRSTBUTTON        0x00000010 // Primary action
#define POINTER_FLAG_SECONDBUTTON       0x00000020 // Secondary action
#define POINTER_FLAG_THIRDBUTTON        0x00000040 // Third button
#define POINTER_FLAG_FOURTHBUTTON       0x00000080 // Fourth button
#define POINTER_FLAG_FIFTHBUTTON        0x00000100 // Fifth button
#define POINTER_FLAG_PRIMARY            0x00002000 // Pointer is primary
#define POINTER_FLAG_CONFIDENCE         0x00004000 // Pointer is considered unlikely to be accidental
#define POINTER_FLAG_CANCELED           0x00008000 // Pointer is departing in an abnormal manner
#define POINTER_FLAG_DOWN               0x00010000 // Pointer transitioned to down state (made contact)
#define POINTER_FLAG_UPDATE             0x00020000 // Pointer update
#define POINTER_FLAG_UP                 0x00040000 // Pointer transitioned from down state (broke contact)
#define POINTER_FLAG_WHEEL              0x00080000 // Vertical wheel
#define POINTER_FLAG_HWHEEL             0x00100000 // Horizontal wheel
#define POINTER_FLAG_CAPTURECHANGED     0x00200000 // Lost capture
#define POINTER_FLAG_HASTRANSFORM       0x00400000 // Input has a transform associated with it


/*
 * Pointer info key states defintions.
 */
#define POINTER_MOD_SHIFT   (0x0004)    // Shift key is held down.
#define POINTER_MOD_CTRL    (0x0008)    // Ctrl key is held down.

typedef enum tagPOINTER_BUTTON_CHANGE_TYPE {
    POINTER_CHANGE_NONE,
    POINTER_CHANGE_FIRSTBUTTON_DOWN,
    POINTER_CHANGE_FIRSTBUTTON_UP,
    POINTER_CHANGE_SECONDBUTTON_DOWN,
    POINTER_CHANGE_SECONDBUTTON_UP,
    POINTER_CHANGE_THIRDBUTTON_DOWN,
    POINTER_CHANGE_THIRDBUTTON_UP,
    POINTER_CHANGE_FOURTHBUTTON_DOWN,
    POINTER_CHANGE_FOURTHBUTTON_UP,
    POINTER_CHANGE_FIFTHBUTTON_DOWN,
    POINTER_CHANGE_FIFTHBUTTON_UP,
} POINTER_BUTTON_CHANGE_TYPE;

typedef struct tagPOINTER_INFO {
    POINTER_INPUT_TYPE    pointerType;
    UINT32          pointerId;
    UINT32          frameId;
    POINTER_FLAGS   pointerFlags;
    HANDLE          sourceDevice;
    HWND            hwndTarget;
    POINT           ptPixelLocation;
    POINT           ptHimetricLocation;
    POINT           ptPixelLocationRaw;
    POINT           ptHimetricLocationRaw;
    DWORD           dwTime;
    UINT32          historyCount;
    INT32           InputData;
    DWORD           dwKeyStates;
    UINT64          PerformanceCount;
    POINTER_BUTTON_CHANGE_TYPE ButtonChangeType;
} POINTER_INFO;


typedef UINT32 TOUCH_FLAGS;
#define TOUCH_FLAG_NONE                 0x00000000 // Default

typedef UINT32 TOUCH_MASK;
#define TOUCH_MASK_NONE                 0x00000000 // Default - none of the optional fields are valid
#define TOUCH_MASK_CONTACTAREA          0x00000001 // The rcContact field is valid
#define TOUCH_MASK_ORIENTATION          0x00000002 // The orientation field is valid
#define TOUCH_MASK_PRESSURE             0x00000004 // The pressure field is valid

typedef struct tagPOINTER_TOUCH_INFO {
    POINTER_INFO    pointerInfo;
    TOUCH_FLAGS     touchFlags;
    TOUCH_MASK      touchMask;
    RECT            rcContact;
    RECT            rcContactRaw;
    UINT32          orientation;
    UINT32          pressure;
} POINTER_TOUCH_INFO;

typedef UINT32 PEN_FLAGS;
#define PEN_FLAG_NONE                   0x00000000 // Default
#define PEN_FLAG_BARREL                 0x00000001 // The barrel button is pressed
#define PEN_FLAG_INVERTED               0x00000002 // The pen is inverted
#define PEN_FLAG_ERASER                 0x00000004 // The eraser button is pressed

typedef UINT32 PEN_MASK;
#define PEN_MASK_NONE                   0x00000000 // Default - none of the optional fields are valid
#define PEN_MASK_PRESSURE               0x00000001 // The pressure field is valid
#define PEN_MASK_ROTATION               0x00000002 // The rotation field is valid
#define PEN_MASK_TILT_X                 0x00000004 // The tiltX field is valid
#define PEN_MASK_TILT_Y                 0x00000008 // The tiltY field is valid

typedef struct tagPOINTER_PEN_INFO {
    POINTER_INFO    pointerInfo;
    PEN_FLAGS       penFlags;
    PEN_MASK        penMask;
    UINT32          pressure;
    UINT32          rotation;
    INT32           tiltX;
    INT32           tiltY;
} POINTER_PEN_INFO;

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/*
 * Flags that appear in pointer input message parameters
 */
#define POINTER_MESSAGE_FLAG_NEW                0x00000001 // New pointer
#define POINTER_MESSAGE_FLAG_INRANGE            0x00000002 // Pointer has not departed
#define POINTER_MESSAGE_FLAG_INCONTACT          0x00000004 // Pointer is in contact
#define POINTER_MESSAGE_FLAG_FIRSTBUTTON        0x00000010 // Primary action
#define POINTER_MESSAGE_FLAG_SECONDBUTTON       0x00000020 // Secondary action
#define POINTER_MESSAGE_FLAG_THIRDBUTTON        0x00000040 // Third button
#define POINTER_MESSAGE_FLAG_FOURTHBUTTON       0x00000080 // Fourth button
#define POINTER_MESSAGE_FLAG_FIFTHBUTTON        0x00000100 // Fifth button
#define POINTER_MESSAGE_FLAG_PRIMARY            0x00002000 // Pointer is primary
#define POINTER_MESSAGE_FLAG_CONFIDENCE         0x00004000 // Pointer is considered unlikely to be accidental
#define POINTER_MESSAGE_FLAG_CANCELED           0x00008000 // Pointer is departing in an abnormal manner

/*
 * Macros to retrieve information from pointer input message parameters
 */
#define GET_POINTERID_WPARAM(wParam)                (LOWORD(wParam))
#define IS_POINTER_FLAG_SET_WPARAM(wParam, flag)    (((DWORD)HIWORD(wParam) & (flag)) == (flag))
#define IS_POINTER_NEW_WPARAM(wParam)               IS_POINTER_FLAG_SET_WPARAM(wParam, POINTER_MESSAGE_FLAG_NEW)
#define IS_POINTER_INRANGE_WPARAM(wParam)           IS_POINTER_FLAG_SET_WPARAM(wParam, POINTER_MESSAGE_FLAG_INRANGE)
#define IS_POINTER_INCONTACT_WPARAM(wParam)         IS_POINTER_FLAG_SET_WPARAM(wParam, POINTER_MESSAGE_FLAG_INCONTACT)
#define IS_POINTER_FIRSTBUTTON_WPARAM(wParam)       IS_POINTER_FLAG_SET_WPARAM(wParam, POINTER_MESSAGE_FLAG_FIRSTBUTTON)
#define IS_POINTER_SECONDBUTTON_WPARAM(wParam)      IS_POINTER_FLAG_SET_WPARAM(wParam, POINTER_MESSAGE_FLAG_SECONDBUTTON)
#define IS_POINTER_THIRDBUTTON_WPARAM(wParam)       IS_POINTER_FLAG_SET_WPARAM(wParam, POINTER_MESSAGE_FLAG_THIRDBUTTON)
#define IS_POINTER_FOURTHBUTTON_WPARAM(wParam)      IS_POINTER_FLAG_SET_WPARAM(wParam, POINTER_MESSAGE_FLAG_FOURTHBUTTON)
#define IS_POINTER_FIFTHBUTTON_WPARAM(wParam)       IS_POINTER_FLAG_SET_WPARAM(wParam, POINTER_MESSAGE_FLAG_FIFTHBUTTON)
#define IS_POINTER_PRIMARY_WPARAM(wParam)           IS_POINTER_FLAG_SET_WPARAM(wParam, POINTER_MESSAGE_FLAG_PRIMARY)
#define HAS_POINTER_CONFIDENCE_WPARAM(wParam)       IS_POINTER_FLAG_SET_WPARAM(wParam, POINTER_MESSAGE_FLAG_CONFIDENCE)
#define IS_POINTER_CANCELED_WPARAM(wParam)          IS_POINTER_FLAG_SET_WPARAM(wParam, POINTER_MESSAGE_FLAG_CANCELED)

/*
 * WM_POINTERACTIVATE return codes
 */
#define PA_ACTIVATE                     MA_ACTIVATE
#define PA_NOACTIVATE                   MA_NOACTIVATE


#define MAX_TOUCH_COUNT 256

#define TOUCH_FEEDBACK_DEFAULT 0x1
#define TOUCH_FEEDBACK_INDIRECT 0x2
#define TOUCH_FEEDBACK_NONE 0x3

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
InitializeTouchInjection(
     UINT32 maxCount,
     DWORD dwMode);


BOOL
__stdcall
InjectTouchInput(
     UINT32 count,
    _In_reads_(count) CONST POINTER_TOUCH_INFO *contacts);

typedef struct tagUSAGE_PROPERTIES {
    USHORT level;
    USHORT page;
    USHORT usage;
    INT32 logicalMinimum;
    INT32 logicalMaximum;
    USHORT unit;
    USHORT exponent;
    BYTE   count;
    INT32 physicalMinimum;
    INT32 physicalMaximum;
}USAGE_PROPERTIES, *PUSAGE_PROPERTIES;

typedef struct tagPOINTER_TYPE_INFO {
    POINTER_INPUT_TYPE  type;
    union{
        POINTER_TOUCH_INFO touchInfo;
        POINTER_PEN_INFO   penInfo;
    } DUMMYUNIONNAME;
}POINTER_TYPE_INFO, *PPOINTER_TYPE_INFO;

typedef struct tagINPUT_INJECTION_VALUE {
    USHORT page;
    USHORT usage;
    INT32  value;
    USHORT index;
}INPUT_INJECTION_VALUE, *PINPUT_INJECTION_VALUE;


BOOL
__stdcall
GetPointerType(
     UINT32 pointerId,
     POINTER_INPUT_TYPE *pointerType);


BOOL
__stdcall
GetPointerCursorId(
     UINT32 pointerId,
     UINT32 *cursorId);


BOOL
__stdcall
GetPointerInfo(
     UINT32 pointerId,
    _Out_writes_(1) POINTER_INFO *pointerInfo);


BOOL
__stdcall
GetPointerInfoHistory(
     UINT32 pointerId,
     UINT32 *entriesCount,
    _Out_writes_opt_(*entriesCount) POINTER_INFO *pointerInfo);


BOOL
__stdcall
GetPointerFrameInfo(
     UINT32 pointerId,
     UINT32 *pointerCount,
    _Out_writes_opt_(*pointerCount) POINTER_INFO *pointerInfo);


BOOL
__stdcall
GetPointerFrameInfoHistory(
     UINT32 pointerId,
     UINT32 *entriesCount,
     UINT32 *pointerCount,
    _Out_writes_opt_(*entriesCount * *pointerCount) POINTER_INFO *pointerInfo);


BOOL
__stdcall
GetPointerTouchInfo(
     UINT32 pointerId,
    _Out_writes_(1) POINTER_TOUCH_INFO *touchInfo);


BOOL
__stdcall
GetPointerTouchInfoHistory(
     UINT32 pointerId,
     UINT32 *entriesCount,
    _Out_writes_opt_(*entriesCount) POINTER_TOUCH_INFO *touchInfo);


BOOL
__stdcall
GetPointerFrameTouchInfo(
     UINT32 pointerId,
     UINT32 *pointerCount,
    _Out_writes_opt_(*pointerCount) POINTER_TOUCH_INFO *touchInfo);


BOOL
__stdcall
GetPointerFrameTouchInfoHistory(
     UINT32 pointerId,
     UINT32 *entriesCount,
     UINT32 *pointerCount,
    _Out_writes_opt_(*entriesCount * *pointerCount) POINTER_TOUCH_INFO *touchInfo);


BOOL
__stdcall
GetPointerPenInfo(
     UINT32 pointerId,
    _Out_writes_(1) POINTER_PEN_INFO *penInfo);


BOOL
__stdcall
GetPointerPenInfoHistory(
     UINT32 pointerId,
     UINT32 *entriesCount,
    _Out_writes_opt_(*entriesCount) POINTER_PEN_INFO *penInfo);


BOOL
__stdcall
GetPointerFramePenInfo(
     UINT32 pointerId,
     UINT32 *pointerCount,
    _Out_writes_opt_(*pointerCount) POINTER_PEN_INFO *penInfo);


BOOL
__stdcall
GetPointerFramePenInfoHistory(
     UINT32 pointerId,
     UINT32 *entriesCount,
     UINT32 *pointerCount,
    _Out_writes_opt_(*entriesCount * *pointerCount) POINTER_PEN_INFO *penInfo);


BOOL
__stdcall
SkipPointerFrameMessages(
     UINT32 pointerId);


BOOL
__stdcall
RegisterPointerInputTarget(
     HWND hwnd,
     POINTER_INPUT_TYPE pointerType);


BOOL
__stdcall
UnregisterPointerInputTarget(
     HWND hwnd,
     POINTER_INPUT_TYPE pointerType);


BOOL
__stdcall
RegisterPointerInputTargetEx(
     HWND hwnd,
     POINTER_INPUT_TYPE pointerType,
     BOOL fObserve);


BOOL
__stdcall
UnregisterPointerInputTargetEx(
     HWND hwnd,
     POINTER_INPUT_TYPE pointerType);



BOOL
__stdcall
EnableMouseInPointer(
     BOOL fEnable);


BOOL
__stdcall
IsMouseInPointerEnabled(
    VOID);


#define TOUCH_HIT_TESTING_DEFAULT 0x0
#define TOUCH_HIT_TESTING_CLIENT  0x1
#define TOUCH_HIT_TESTING_NONE    0x2


BOOL
__stdcall
RegisterTouchHitTestingWindow(
     HWND hwnd,
     ULONG value);

typedef struct tagTOUCH_HIT_TESTING_PROXIMITY_EVALUATION
{
    UINT16 score;
    POINT adjustedPoint;
} TOUCH_HIT_TESTING_PROXIMITY_EVALUATION, *PTOUCH_HIT_TESTING_PROXIMITY_EVALUATION;

/*
 * WM_TOUCHHITTESTING structure
*/

typedef struct tagTOUCH_HIT_TESTING_INPUT
{
    UINT32 pointerId;
    POINT point;
    RECT boundingBox;
    RECT nonOccludedBoundingBox;
    UINT32 orientation;
} TOUCH_HIT_TESTING_INPUT, *PTOUCH_HIT_TESTING_INPUT;


#define TOUCH_HIT_TESTING_PROXIMITY_CLOSEST  0x0
#define TOUCH_HIT_TESTING_PROXIMITY_FARTHEST  0xFFF


BOOL
__stdcall
EvaluateProximityToRect(
     const RECT *controlBoundingBox,
     const TOUCH_HIT_TESTING_INPUT *pHitTestingInput,
     TOUCH_HIT_TESTING_PROXIMITY_EVALUATION *pProximityEval);


BOOL
__stdcall
EvaluateProximityToPolygon(
    UINT32 numVertices,
    _In_reads_(numVertices) const POINT *controlPolygon,
     const TOUCH_HIT_TESTING_INPUT *pHitTestingInput,
     TOUCH_HIT_TESTING_PROXIMITY_EVALUATION *pProximityEval);


LRESULT
__stdcall
PackTouchHitTestingProximityEvaluation(
     const TOUCH_HIT_TESTING_INPUT *pHitTestingInput,
     const TOUCH_HIT_TESTING_PROXIMITY_EVALUATION *pProximityEval);


typedef enum tagFEEDBACK_TYPE {
    FEEDBACK_TOUCH_CONTACTVISUALIZATION = 1,
    FEEDBACK_PEN_BARRELVISUALIZATION    = 2,
    FEEDBACK_PEN_TAP                    = 3,
    FEEDBACK_PEN_DOUBLETAP              = 4,
    FEEDBACK_PEN_PRESSANDHOLD           = 5,
    FEEDBACK_PEN_RIGHTTAP               = 6,
    FEEDBACK_TOUCH_TAP                  = 7,
    FEEDBACK_TOUCH_DOUBLETAP            = 8,
    FEEDBACK_TOUCH_PRESSANDHOLD         = 9,
    FEEDBACK_TOUCH_RIGHTTAP             = 10,
    FEEDBACK_GESTURE_PRESSANDTAP        = 11,
    FEEDBACK_MAX                        = 0xFFFFFFFF
} FEEDBACK_TYPE;


#define GWFS_INCLUDE_ANCESTORS           0x00000001



BOOL
__stdcall
GetWindowFeedbackSetting(
     HWND hwnd,
     FEEDBACK_TYPE feedback,
     DWORD dwFlags,
     UINT32* pSize,
    _Out_writes_bytes_opt_(*pSize) VOID* config);


BOOL
__stdcall
SetWindowFeedbackSetting(
     HWND hwnd,
     FEEDBACK_TYPE feedback,
     DWORD dwFlags,
     UINT32 size,
    _In_reads_bytes_opt_(size) CONST VOID* configuration);


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* WINVER >= 0x0602 */

#if(WINVER >= 0x0603)

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

//Disable warning C4201:nameless struct/union
#if _MSC_VER >= 1200
#pragma warning(push)
#endif
#pragma warning(disable : 4201)

typedef struct tagINPUT_TRANSFORM {
    union {
        struct {
            float        _11, _12, _13, _14;
            float        _21, _22, _23, _24;
            float        _31, _32, _33, _34;
            float        _41, _42, _43, _44;
        } DUMMYSTRUCTNAME;
        float m[4][4];
    } DUMMYUNIONNAME;
} INPUT_TRANSFORM;

#if _MSC_VER >= 1200
#pragma warning(pop)
#endif



BOOL
__stdcall
GetPointerInputTransform(
     UINT32 pointerId,
     UINT32 historyCount,
    _Out_writes_(historyCount) INPUT_TRANSFORM *inputTransform);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* WINVER >= 0x0603 */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if(_WIN32_WINNT >= 0x0500)
typedef struct tagLASTINPUTINFO {
    UINT cbSize;
    DWORD dwTime;
} LASTINPUTINFO, * PLASTINPUTINFO;


BOOL
__stdcall
GetLastInputInfo(
     PLASTINPUTINFO plii);
#endif /* _WIN32_WINNT >= 0x0500 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#pragma region Desktop or PC Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_PC_APP)


UINT
__stdcall
MapVirtualKeyA(
     UINT uCode,
     UINT uMapType);

UINT
__stdcall
MapVirtualKeyW(
     UINT uCode,
     UINT uMapType);
#ifdef UNICODE
#define MapVirtualKey  MapVirtualKeyW
#else
#define MapVirtualKey  MapVirtualKeyA
#endif // !UNICODE

#if(WINVER >= 0x0400)

UINT
__stdcall
MapVirtualKeyExA(
     UINT uCode,
     UINT uMapType,
     HKL dwhkl);

UINT
__stdcall
MapVirtualKeyExW(
     UINT uCode,
     UINT uMapType,
     HKL dwhkl);
#ifdef UNICODE
#define MapVirtualKeyEx  MapVirtualKeyExW
#else
#define MapVirtualKeyEx  MapVirtualKeyExA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_PC_APP) */
#pragma endregion

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#define MAPVK_VK_TO_VSC     (0)
#define MAPVK_VSC_TO_VK     (1)
#define MAPVK_VK_TO_CHAR    (2)
#define MAPVK_VSC_TO_VK_EX  (3)
#endif /* WINVER >= 0x0400 */
#if(WINVER >= 0x0600)
#define MAPVK_VK_TO_VSC_EX  (4)
#endif /* WINVER >= 0x0600 */


BOOL
__stdcall
GetInputState(
    VOID);


DWORD
__stdcall
GetQueueStatus(
     UINT flags);



HWND
__stdcall
GetCapture(
    VOID);


HWND
__stdcall
SetCapture(
     HWND hWnd);


BOOL
__stdcall
ReleaseCapture(
    VOID);


DWORD
__stdcall
MsgWaitForMultipleObjects(
     DWORD nCount,
    _In_reads_opt_(nCount) CONST HANDLE *pHandles,
     BOOL fWaitAll,
     DWORD dwMilliseconds,
     DWORD dwWakeMask);


DWORD
__stdcall
MsgWaitForMultipleObjectsEx(
     DWORD nCount,
    _In_reads_opt_(nCount) CONST HANDLE *pHandles,
     DWORD dwMilliseconds,
     DWORD dwWakeMask,
     DWORD dwFlags);


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#define MWMO_WAITALL        0x0001
#define MWMO_ALERTABLE      0x0002
#define MWMO_INPUTAVAILABLE 0x0004

/*
 * Queue status flags for GetQueueStatus() and MsgWaitForMultipleObjects()
 */
#define QS_KEY              0x0001
#define QS_MOUSEMOVE        0x0002
#define QS_MOUSEBUTTON      0x0004
#define QS_POSTMESSAGE      0x0008
#define QS_TIMER            0x0010
#define QS_PAINT            0x0020
#define QS_SENDMESSAGE      0x0040
#define QS_HOTKEY           0x0080
#define QS_ALLPOSTMESSAGE   0x0100

#if(_WIN32_WINNT >= 0x0501)
#define QS_RAWINPUT         0x0400
#endif /* _WIN32_WINNT >= 0x0501 */

#if(_WIN32_WINNT >= 0x0602)
#define QS_TOUCH            0x0800
#define QS_POINTER          0x1000

#endif /* _WIN32_WINNT >= 0x0602 */


#define QS_MOUSE           (QS_MOUSEMOVE     | \
                            QS_MOUSEBUTTON)

#if (_WIN32_WINNT >= 0x602)
#define QS_INPUT           (QS_MOUSE         | \
                            QS_KEY           | \
                            QS_RAWINPUT      | \
                            QS_TOUCH         | \
                            QS_POINTER)

#else
#if (_WIN32_WINNT >= 0x0501)
#define QS_INPUT           (QS_MOUSE         | \
                            QS_KEY           | \
                            QS_RAWINPUT)
#else
#define QS_INPUT           (QS_MOUSE         | \
                            QS_KEY)
#endif // (_WIN32_WINNT >= 0x0501)
#endif

#define QS_ALLEVENTS       (QS_INPUT         | \
                            QS_POSTMESSAGE   | \
                            QS_TIMER         | \
                            QS_PAINT         | \
                            QS_HOTKEY)

#define QS_ALLINPUT        (QS_INPUT         | \
                            QS_POSTMESSAGE   | \
                            QS_TIMER         | \
                            QS_PAINT         | \
                            QS_HOTKEY        | \
                            QS_SENDMESSAGE)


#define USER_TIMER_MAXIMUM  0x7FFFFFFF
#define USER_TIMER_MINIMUM  0x0000000A

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

/*
 * Windows Functions
 */


UINT_PTR
__stdcall
SetTimer(
     HWND hWnd,
     UINT_PTR nIDEvent,
     UINT uElapse,
     TIMERPROC lpTimerFunc);

#if(WINVER >= 0x0601)

#define TIMERV_DEFAULT_COALESCING   (0)
#define TIMERV_NO_COALESCING        (0xFFFFFFFF)

#define TIMERV_COALESCING_MIN       (1)
#define TIMERV_COALESCING_MAX       (0x7FFFFFF5)


UINT_PTR
__stdcall
SetCoalescableTimer(
     HWND hWnd,
     UINT_PTR nIDEvent,
     UINT uElapse,
     TIMERPROC lpTimerFunc,
     ULONG uToleranceDelay);

#endif /* WINVER >= 0x0601 */


BOOL
__stdcall
KillTimer(
     HWND hWnd,
     UINT_PTR uIDEvent);


BOOL
__stdcall
IsWindowUnicode(
     HWND hWnd);


BOOL
__stdcall
EnableWindow(
     HWND hWnd,
     BOOL bEnable);


BOOL
__stdcall
IsWindowEnabled(
     HWND hWnd);


HACCEL
__stdcall
LoadAcceleratorsA(
     HINSTANCE hInstance,
     LPCSTR lpTableName);

HACCEL
__stdcall
LoadAcceleratorsW(
     HINSTANCE hInstance,
     LPCWSTR lpTableName);
#ifdef UNICODE
#define LoadAccelerators  LoadAcceleratorsW
#else
#define LoadAccelerators  LoadAcceleratorsA
#endif // !UNICODE


HACCEL
__stdcall
CreateAcceleratorTableA(
    _In_reads_(cAccel) LPACCEL paccel,
     int cAccel);

HACCEL
__stdcall
CreateAcceleratorTableW(
    _In_reads_(cAccel) LPACCEL paccel,
     int cAccel);
#ifdef UNICODE
#define CreateAcceleratorTable  CreateAcceleratorTableW
#else
#define CreateAcceleratorTable  CreateAcceleratorTableA
#endif // !UNICODE


BOOL
__stdcall
DestroyAcceleratorTable(
     HACCEL hAccel);


int
__stdcall
CopyAcceleratorTableA(
     HACCEL hAccelSrc,
    _Out_writes_to_opt_(cAccelEntries, return) LPACCEL lpAccelDst,
     int cAccelEntries);

int
__stdcall
CopyAcceleratorTableW(
     HACCEL hAccelSrc,
    _Out_writes_to_opt_(cAccelEntries, return) LPACCEL lpAccelDst,
     int cAccelEntries);
#ifdef UNICODE
#define CopyAcceleratorTable  CopyAcceleratorTableW
#else
#define CopyAcceleratorTable  CopyAcceleratorTableA
#endif // !UNICODE

#ifndef NOMSG


int
__stdcall
TranslateAcceleratorA(
     HWND hWnd,
     HACCEL hAccTable,
     LPMSG lpMsg);

int
__stdcall
TranslateAcceleratorW(
     HWND hWnd,
     HACCEL hAccTable,
     LPMSG lpMsg);
#ifdef UNICODE
#define TranslateAccelerator  TranslateAcceleratorW
#else
#define TranslateAccelerator  TranslateAcceleratorA
#endif // !UNICODE

#endif /* !NOMSG */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#ifndef NOSYSMETRICS


/*
 * GetSystemMetrics() codes
 */

#define SM_CXSCREEN             0
#define SM_CYSCREEN             1
#define SM_CXVSCROLL            2
#define SM_CYHSCROLL            3
#define SM_CYCAPTION            4
#define SM_CXBORDER             5
#define SM_CYBORDER             6
#define SM_CXDLGFRAME           7
#define SM_CYDLGFRAME           8
#define SM_CYVTHUMB             9
#define SM_CXHTHUMB             10
#define SM_CXICON               11
#define SM_CYICON               12
#define SM_CXCURSOR             13
#define SM_CYCURSOR             14
#define SM_CYMENU               15
#define SM_CXFULLSCREEN         16
#define SM_CYFULLSCREEN         17
#define SM_CYKANJIWINDOW        18
#define SM_MOUSEPRESENT         19
#define SM_CYVSCROLL            20
#define SM_CXHSCROLL            21
#define SM_DEBUG                22
#define SM_SWAPBUTTON           23
#define SM_RESERVED1            24
#define SM_RESERVED2            25
#define SM_RESERVED3            26
#define SM_RESERVED4            27
#define SM_CXMIN                28
#define SM_CYMIN                29
#define SM_CXSIZE               30
#define SM_CYSIZE               31
#define SM_CXFRAME              32
#define SM_CYFRAME              33
#define SM_CXMINTRACK           34
#define SM_CYMINTRACK           35
#define SM_CXDOUBLECLK          36
#define SM_CYDOUBLECLK          37
#define SM_CXICONSPACING        38
#define SM_CYICONSPACING        39
#define SM_MENUDROPALIGNMENT    40
#define SM_PENWINDOWS           41
#define SM_DBCSENABLED          42
#define SM_CMOUSEBUTTONS        43

#if(WINVER >= 0x0400)
#define SM_CXFIXEDFRAME           SM_CXDLGFRAME  /* ;win40 name change */
#define SM_CYFIXEDFRAME           SM_CYDLGFRAME  /* ;win40 name change */
#define SM_CXSIZEFRAME            SM_CXFRAME     /* ;win40 name change */
#define SM_CYSIZEFRAME            SM_CYFRAME     /* ;win40 name change */

#define SM_SECURE               44
#define SM_CXEDGE               45
#define SM_CYEDGE               46
#define SM_CXMINSPACING         47
#define SM_CYMINSPACING         48
#define SM_CXSMICON             49
#define SM_CYSMICON             50
#define SM_CYSMCAPTION          51
#define SM_CXSMSIZE             52
#define SM_CYSMSIZE             53
#define SM_CXMENUSIZE           54
#define SM_CYMENUSIZE           55
#define SM_ARRANGE              56
#define SM_CXMINIMIZED          57
#define SM_CYMINIMIZED          58
#define SM_CXMAXTRACK           59
#define SM_CYMAXTRACK           60
#define SM_CXMAXIMIZED          61
#define SM_CYMAXIMIZED          62
#define SM_NETWORK              63
#define SM_CLEANBOOT            67
#define SM_CXDRAG               68
#define SM_CYDRAG               69
#endif /* WINVER >= 0x0400 */
#define SM_SHOWSOUNDS           70
#if(WINVER >= 0x0400)
#define SM_CXMENUCHECK          71   /* Use instead of GetMenuCheckMarkDimensions()! */
#define SM_CYMENUCHECK          72
#define SM_SLOWMACHINE          73
#define SM_MIDEASTENABLED       74
#endif /* WINVER >= 0x0400 */

#if (WINVER >= 0x0500) || (_WIN32_WINNT >= 0x0400)
#define SM_MOUSEWHEELPRESENT    75
#endif
#if(WINVER >= 0x0500)
#define SM_XVIRTUALSCREEN       76
#define SM_YVIRTUALSCREEN       77
#define SM_CXVIRTUALSCREEN      78
#define SM_CYVIRTUALSCREEN      79
#define SM_CMONITORS            80
#define SM_SAMEDISPLAYFORMAT    81
#endif /* WINVER >= 0x0500 */
#if(_WIN32_WINNT >= 0x0500)
#define SM_IMMENABLED           82
#endif /* _WIN32_WINNT >= 0x0500 */
#if(_WIN32_WINNT >= 0x0501)
#define SM_CXFOCUSBORDER        83
#define SM_CYFOCUSBORDER        84
#endif /* _WIN32_WINNT >= 0x0501 */

#if(_WIN32_WINNT >= 0x0501)
#define SM_TABLETPC             86
#define SM_MEDIACENTER          87
#define SM_STARTER              88
#define SM_SERVERR2             89
#endif /* _WIN32_WINNT >= 0x0501 */

#if(_WIN32_WINNT >= 0x0600)
#define SM_MOUSEHORIZONTALWHEELPRESENT    91
#define SM_CXPADDEDBORDER       92
#endif /* _WIN32_WINNT >= 0x0600 */

#if(WINVER >= 0x0601)

#define SM_DIGITIZER            94
#define SM_MAXIMUMTOUCHES       95
#endif /* WINVER >= 0x0601 */

#if (WINVER < 0x0500) && (!defined(_WIN32_WINNT) || (_WIN32_WINNT < 0x0400))
#define SM_CMETRICS             76
#elif WINVER == 0x500
#define SM_CMETRICS             83
#elif WINVER == 0x501
#define SM_CMETRICS             91
#elif WINVER == 0x600
#define SM_CMETRICS             93
#else
#define SM_CMETRICS             97
#endif

#if(WINVER >= 0x0500)
#define SM_REMOTESESSION        0x1000


#if(_WIN32_WINNT >= 0x0501)
#define SM_SHUTTINGDOWN           0x2000
#endif /* _WIN32_WINNT >= 0x0501 */

#if(WINVER >= 0x0501)
#define SM_REMOTECONTROL          0x2001
#endif /* WINVER >= 0x0501 */

#if(WINVER >= 0x0501)
#define SM_CARETBLINKINGENABLED   0x2002
#endif /* WINVER >= 0x0501 */

#if(WINVER >= 0x0602)
#define SM_CONVERTIBLESLATEMODE   0x2003
#define SM_SYSTEMDOCKED           0x2004
#endif /* WINVER >= 0x0602 */

#endif /* WINVER >= 0x0500 */


#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


int
__stdcall
GetSystemMetrics(
     int nIndex);


#if(WINVER >= 0x0605)

int
__stdcall
GetSystemMetricsForDpi(
     int nIndex,
     UINT dpi);

#endif /* WINVER >= 0x0605 */


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* !NOSYSMETRICS */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#ifndef NOMENUS


HMENU
__stdcall
LoadMenuA(
     HINSTANCE hInstance,
     LPCSTR lpMenuName);

HMENU
__stdcall
LoadMenuW(
     HINSTANCE hInstance,
     LPCWSTR lpMenuName);
#ifdef UNICODE
#define LoadMenu  LoadMenuW
#else
#define LoadMenu  LoadMenuA
#endif // !UNICODE


HMENU
__stdcall
LoadMenuIndirectA(
     CONST MENUTEMPLATEA *lpMenuTemplate);

HMENU
__stdcall
LoadMenuIndirectW(
     CONST MENUTEMPLATEW *lpMenuTemplate);
#ifdef UNICODE
#define LoadMenuIndirect  LoadMenuIndirectW
#else
#define LoadMenuIndirect  LoadMenuIndirectA
#endif // !UNICODE


HMENU
__stdcall
GetMenu(
     HWND hWnd);


BOOL
__stdcall
SetMenu(
     HWND hWnd,
     HMENU hMenu);


BOOL
__stdcall
ChangeMenuA(
     HMENU hMenu,
     UINT cmd,
     LPCSTR lpszNewItem,
     UINT cmdInsert,
     UINT flags);

BOOL
__stdcall
ChangeMenuW(
     HMENU hMenu,
     UINT cmd,
     LPCWSTR lpszNewItem,
     UINT cmdInsert,
     UINT flags);
#ifdef UNICODE
#define ChangeMenu  ChangeMenuW
#else
#define ChangeMenu  ChangeMenuA
#endif // !UNICODE


BOOL
__stdcall
HiliteMenuItem(
     HWND hWnd,
     HMENU hMenu,
     UINT uIDHiliteItem,
     UINT uHilite);


int
__stdcall
GetMenuStringA(
     HMENU hMenu,
     UINT uIDItem,
    _Out_writes_opt_(cchMax) LPSTR lpString,
     int cchMax,
     UINT flags);

int
__stdcall
GetMenuStringW(
     HMENU hMenu,
     UINT uIDItem,
    _Out_writes_opt_(cchMax) LPWSTR lpString,
     int cchMax,
     UINT flags);
#ifdef UNICODE
#define GetMenuString  GetMenuStringW
#else
#define GetMenuString  GetMenuStringA
#endif // !UNICODE


UINT
__stdcall
GetMenuState(
     HMENU hMenu,
     UINT uId,
     UINT uFlags);


BOOL
__stdcall
DrawMenuBar(
     HWND hWnd);

#if(_WIN32_WINNT >= 0x0501)
#define PMB_ACTIVE      0x00000001

#endif /* _WIN32_WINNT >= 0x0501 */



HMENU
__stdcall
GetSystemMenu(
     HWND hWnd,
     BOOL bRevert);



HMENU
__stdcall
CreateMenu(
    VOID);


HMENU
__stdcall
CreatePopupMenu(
    VOID);


BOOL
__stdcall
DestroyMenu(
     HMENU hMenu);


DWORD
__stdcall
CheckMenuItem(
     HMENU hMenu,
     UINT uIDCheckItem,
     UINT uCheck);


BOOL
__stdcall
EnableMenuItem(
     HMENU hMenu,
     UINT uIDEnableItem,
     UINT uEnable);


HMENU
__stdcall
GetSubMenu(
     HMENU hMenu,
     int nPos);


UINT
__stdcall
GetMenuItemID(
     HMENU hMenu,
     int nPos);


int
__stdcall
GetMenuItemCount(
     HMENU hMenu);


BOOL
__stdcall
InsertMenuA(
     HMENU hMenu,
     UINT uPosition,
     UINT uFlags,
     UINT_PTR uIDNewItem,
     LPCSTR lpNewItem);

BOOL
__stdcall
InsertMenuW(
     HMENU hMenu,
     UINT uPosition,
     UINT uFlags,
     UINT_PTR uIDNewItem,
     LPCWSTR lpNewItem);
#ifdef UNICODE
#define InsertMenu  InsertMenuW
#else
#define InsertMenu  InsertMenuA
#endif // !UNICODE


BOOL
__stdcall
AppendMenuA(
     HMENU hMenu,
     UINT uFlags,
     UINT_PTR uIDNewItem,
     LPCSTR lpNewItem);

BOOL
__stdcall
AppendMenuW(
     HMENU hMenu,
     UINT uFlags,
     UINT_PTR uIDNewItem,
     LPCWSTR lpNewItem);
#ifdef UNICODE
#define AppendMenu  AppendMenuW
#else
#define AppendMenu  AppendMenuA
#endif // !UNICODE


BOOL
__stdcall
ModifyMenuA(
     HMENU hMnu,
     UINT uPosition,
     UINT uFlags,
     UINT_PTR uIDNewItem,
     LPCSTR lpNewItem);

BOOL
__stdcall
ModifyMenuW(
     HMENU hMnu,
     UINT uPosition,
     UINT uFlags,
     UINT_PTR uIDNewItem,
     LPCWSTR lpNewItem);
#ifdef UNICODE
#define ModifyMenu  ModifyMenuW
#else
#define ModifyMenu  ModifyMenuA
#endif // !UNICODE


BOOL
__stdcall RemoveMenu(
     HMENU hMenu,
     UINT uPosition,
     UINT uFlags);


BOOL
__stdcall
DeleteMenu(
     HMENU hMenu,
     UINT uPosition,
     UINT uFlags);


BOOL
__stdcall
SetMenuItemBitmaps(
     HMENU hMenu,
     UINT uPosition,
     UINT uFlags,
     HBITMAP hBitmapUnchecked,
     HBITMAP hBitmapChecked);


LONG
__stdcall
GetMenuCheckMarkDimensions(
    VOID);


BOOL
__stdcall
TrackPopupMenu(
     HMENU hMenu,
     UINT uFlags,
     int x,
     int y,
    int nReserved,
     HWND hWnd,
    CONST RECT *prcRect);

#if(WINVER >= 0x0400)
/* return codes for WM_MENUCHAR */
#define MNC_IGNORE  0
#define MNC_CLOSE   1
#define MNC_EXECUTE 2
#define MNC_SELECT  3

typedef struct tagTPMPARAMS
{
    UINT    cbSize;     /* Size of structure */
    RECT    rcExclude;  /* Screen coordinates of rectangle to exclude when positioning */
}   TPMPARAMS;
typedef TPMPARAMS *LPTPMPARAMS;


BOOL
__stdcall
TrackPopupMenuEx(
     HMENU hMenu,
     UINT uFlags,
     int x,
     int y,
     HWND hwnd,
     LPTPMPARAMS lptpm);
#endif /* WINVER >= 0x0400 */

#if(_WIN32_WINNT >= 0x0601)

BOOL
__stdcall
CalculatePopupWindowPosition(
     const POINT *anchorPoint,
     const SIZE *windowSize,
     UINT /* TPM_XXX values */ flags,
     RECT *excludeRect,
     RECT *popupWindowPosition);

#endif /* _WIN32_WINNT >= 0x0601 */

#if(WINVER >= 0x0500)

#define MNS_NOCHECK         0x80000000
#define MNS_MODELESS        0x40000000
#define MNS_DRAGDROP        0x20000000
#define MNS_AUTODISMISS     0x10000000
#define MNS_NOTIFYBYPOS     0x08000000
#define MNS_CHECKORBMP      0x04000000

#define MIM_MAXHEIGHT               0x00000001
#define MIM_BACKGROUND              0x00000002
#define MIM_HELPID                  0x00000004
#define MIM_MENUDATA                0x00000008
#define MIM_STYLE                   0x00000010
#define MIM_APPLYTOSUBMENUS         0x80000000

typedef struct tagMENUINFO
{
    DWORD   cbSize;
    DWORD   fMask;
    DWORD   dwStyle;
    UINT    cyMax;
    HBRUSH  hbrBack;
    DWORD   dwContextHelpID;
    ULONG_PTR dwMenuData;
}   MENUINFO, *LPMENUINFO;
typedef MENUINFO CONST *LPCMENUINFO;


BOOL
__stdcall
GetMenuInfo(
     HMENU,
     LPMENUINFO);


BOOL
__stdcall
SetMenuInfo(
     HMENU,
     LPCMENUINFO);


BOOL
__stdcall
EndMenu(
        VOID);

/*
 * WM_MENUDRAG return values.
 */
#define MND_CONTINUE       0
#define MND_ENDMENU        1

typedef struct tagMENUGETOBJECTINFO
{
    DWORD dwFlags;
    UINT uPos;
    HMENU hmenu;
    PVOID riid;
    PVOID pvObj;
} MENUGETOBJECTINFO, * PMENUGETOBJECTINFO;

/*
 * MENUGETOBJECTINFO dwFlags values
 */
#define MNGOF_TOPGAP         0x00000001
#define MNGOF_BOTTOMGAP      0x00000002

/*
 * WM_MENUGETOBJECT return values
 */
#define MNGO_NOINTERFACE     0x00000000
#define MNGO_NOERROR         0x00000001
#endif /* WINVER >= 0x0500 */

#if(WINVER >= 0x0400)
#define MIIM_STATE       0x00000001
#define MIIM_ID          0x00000002
#define MIIM_SUBMENU     0x00000004
#define MIIM_CHECKMARKS  0x00000008
#define MIIM_TYPE        0x00000010
#define MIIM_DATA        0x00000020
#endif /* WINVER >= 0x0400 */

#if(WINVER >= 0x0500)
#define MIIM_STRING      0x00000040
#define MIIM_BITMAP      0x00000080
#define MIIM_FTYPE       0x00000100

#define HBMMENU___stdcall            ((HBITMAP) -1)
#define HBMMENU_SYSTEM              ((HBITMAP)  1)
#define HBMMENU_MBAR_RESTORE        ((HBITMAP)  2)
#define HBMMENU_MBAR_MINIMIZE       ((HBITMAP)  3)
#define HBMMENU_MBAR_CLOSE          ((HBITMAP)  5)
#define HBMMENU_MBAR_CLOSE_D        ((HBITMAP)  6)
#define HBMMENU_MBAR_MINIMIZE_D     ((HBITMAP)  7)
#define HBMMENU_POPUP_CLOSE         ((HBITMAP)  8)
#define HBMMENU_POPUP_RESTORE       ((HBITMAP)  9)
#define HBMMENU_POPUP_MAXIMIZE      ((HBITMAP) 10)
#define HBMMENU_POPUP_MINIMIZE      ((HBITMAP) 11)
#endif /* WINVER >= 0x0500 */

#if(WINVER >= 0x0400)
typedef struct tagMENUITEMINFOA
{
    UINT     cbSize;
    UINT     fMask;
    UINT     fType;         // used if MIIM_TYPE (4.0) or MIIM_FTYPE (>4.0)
    UINT     fState;        // used if MIIM_STATE
    UINT     wID;           // used if MIIM_ID
    HMENU    hSubMenu;      // used if MIIM_SUBMENU
    HBITMAP  hbmpChecked;   // used if MIIM_CHECKMARKS
    HBITMAP  hbmpUnchecked; // used if MIIM_CHECKMARKS
    ULONG_PTR dwItemData;   // used if MIIM_DATA
    LPSTR    dwTypeData;    // used if MIIM_TYPE (4.0) or MIIM_STRING (>4.0)
    UINT     cch;           // used if MIIM_TYPE (4.0) or MIIM_STRING (>4.0)
#if(WINVER >= 0x0500)
    HBITMAP  hbmpItem;      // used if MIIM_BITMAP
#endif /* WINVER >= 0x0500 */
}   MENUITEMINFOA, *LPMENUITEMINFOA;
typedef struct tagMENUITEMINFOW
{
    UINT     cbSize;
    UINT     fMask;
    UINT     fType;         // used if MIIM_TYPE (4.0) or MIIM_FTYPE (>4.0)
    UINT     fState;        // used if MIIM_STATE
    UINT     wID;           // used if MIIM_ID
    HMENU    hSubMenu;      // used if MIIM_SUBMENU
    HBITMAP  hbmpChecked;   // used if MIIM_CHECKMARKS
    HBITMAP  hbmpUnchecked; // used if MIIM_CHECKMARKS
    ULONG_PTR dwItemData;   // used if MIIM_DATA
    LPWSTR   dwTypeData;    // used if MIIM_TYPE (4.0) or MIIM_STRING (>4.0)
    UINT     cch;           // used if MIIM_TYPE (4.0) or MIIM_STRING (>4.0)
#if(WINVER >= 0x0500)
    HBITMAP  hbmpItem;      // used if MIIM_BITMAP
#endif /* WINVER >= 0x0500 */
}   MENUITEMINFOW, *LPMENUITEMINFOW;
#ifdef UNICODE
typedef MENUITEMINFOW MENUITEMINFO;
typedef LPMENUITEMINFOW LPMENUITEMINFO;
#else
typedef MENUITEMINFOA MENUITEMINFO;
typedef LPMENUITEMINFOA LPMENUITEMINFO;
#endif // UNICODE
typedef MENUITEMINFOA CONST *LPCMENUITEMINFOA;
typedef MENUITEMINFOW CONST *LPCMENUITEMINFOW;
#ifdef UNICODE
typedef LPCMENUITEMINFOW LPCMENUITEMINFO;
#else
typedef LPCMENUITEMINFOA LPCMENUITEMINFO;
#endif // UNICODE



BOOL
__stdcall
InsertMenuItemA(
     HMENU hmenu,
     UINT item,
     BOOL fByPosition,
     LPCMENUITEMINFOA lpmi);

BOOL
__stdcall
InsertMenuItemW(
     HMENU hmenu,
     UINT item,
     BOOL fByPosition,
     LPCMENUITEMINFOW lpmi);
#ifdef UNICODE
#define InsertMenuItem  InsertMenuItemW
#else
#define InsertMenuItem  InsertMenuItemA
#endif // !UNICODE


BOOL
__stdcall
GetMenuItemInfoA(
     HMENU hmenu,
     UINT item,
     BOOL fByPosition,
     LPMENUITEMINFOA lpmii);

BOOL
__stdcall
GetMenuItemInfoW(
     HMENU hmenu,
     UINT item,
     BOOL fByPosition,
     LPMENUITEMINFOW lpmii);
#ifdef UNICODE
#define GetMenuItemInfo  GetMenuItemInfoW
#else
#define GetMenuItemInfo  GetMenuItemInfoA
#endif // !UNICODE


BOOL
__stdcall
SetMenuItemInfoA(
     HMENU hmenu,
     UINT item,
     BOOL fByPositon,
     LPCMENUITEMINFOA lpmii);

BOOL
__stdcall
SetMenuItemInfoW(
     HMENU hmenu,
     UINT item,
     BOOL fByPositon,
     LPCMENUITEMINFOW lpmii);
#ifdef UNICODE
#define SetMenuItemInfo  SetMenuItemInfoW
#else
#define SetMenuItemInfo  SetMenuItemInfoA
#endif // !UNICODE


#define GMDI_USEDISABLED    0x0001L
#define GMDI_GOINTOPOPUPS   0x0002L


UINT
__stdcall
GetMenuDefaultItem(
     HMENU hMenu,
     UINT fByPos,
     UINT gmdiFlags);


BOOL
__stdcall
SetMenuDefaultItem(
     HMENU hMenu,
     UINT uItem,
     UINT fByPos);


BOOL
__stdcall
GetMenuItemRect(
     HWND hWnd,
     HMENU hMenu,
     UINT uItem,
     LPRECT lprcItem);


int
__stdcall
MenuItemFromPoint(
     HWND hWnd,
     HMENU hMenu,
     POINT ptScreen);
#endif /* WINVER >= 0x0400 */

/*
 * Flags for TrackPopupMenu
 */
#define TPM_LEFTBUTTON  0x0000L
#define TPM_RIGHTBUTTON 0x0002L
#define TPM_LEFTALIGN   0x0000L
#define TPM_CENTERALIGN 0x0004L
#define TPM_RIGHTALIGN  0x0008L
#if(WINVER >= 0x0400)
#define TPM_TOPALIGN        0x0000L
#define TPM_VCENTERALIGN    0x0010L
#define TPM_BOTTOMALIGN     0x0020L

#define TPM_HORIZONTAL      0x0000L     /* Horz alignment matters more */
#define TPM_VERTICAL        0x0040L     /* Vert alignment matters more */
#define TPM_NONOTIFY        0x0080L     /* Don't send any notification msgs */
#define TPM_RETURNCMD       0x0100L
#endif /* WINVER >= 0x0400 */
#if(WINVER >= 0x0500)
#define TPM_RECURSE         0x0001L
#define TPM_HORPOSANIMATION 0x0400L
#define TPM_HORNEGANIMATION 0x0800L
#define TPM_VERPOSANIMATION 0x1000L
#define TPM_VERNEGANIMATION 0x2000L
#if(_WIN32_WINNT >= 0x0500)
#define TPM_NOANIMATION     0x4000L
#endif /* _WIN32_WINNT >= 0x0500 */
#if(_WIN32_WINNT >= 0x0501)
#define TPM_LAYOUTRTL       0x8000L
#endif /* _WIN32_WINNT >= 0x0501 */
#endif /* WINVER >= 0x0500 */
#if(_WIN32_WINNT >= 0x0601)
#define TPM_WORKAREA        0x10000L
#endif /* _WIN32_WINNT >= 0x0601 */


#endif /* !NOMENUS */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion


#if(WINVER >= 0x0400)

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

//
// Drag-and-drop support
// Obsolete - use OLE instead
//
typedef struct tagDROPSTRUCT
{
    HWND    hwndSource;
    HWND    hwndSink;
    DWORD   wFmt;
    ULONG_PTR dwData;
    POINT   ptDrop;
    DWORD   dwControlData;
} DROPSTRUCT, *PDROPSTRUCT, *LPDROPSTRUCT;

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#define DOF_EXECUTABLE      0x8001      // wFmt flags
#define DOF_DOCUMENT        0x8002
#define DOF_DIRECTORY       0x8003
#define DOF_MULTIPLE        0x8004
#define DOF_PROGMAN         0x0001
#define DOF_SHELLDATA       0x0002

#define DO_DROPFILE         0x454C4946L
#define DO_PRINTFILE        0x544E5250L

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


DWORD
__stdcall
DragObject(
     HWND hwndParent,
     HWND hwndFrom,
     UINT fmt,
     ULONG_PTR data,
     HCURSOR hcur);


BOOL
__stdcall
DragDetect(
     HWND hwnd,
     POINT pt);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* WINVER >= 0x0400 */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
DrawIcon(
     HDC hDC,
     int X,
     int Y,
     HICON hIcon);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#ifndef NODRAWTEXT

/*
 * DrawText() Format Flags
 */
#define DT_TOP                      0x00000000
#define DT_LEFT                     0x00000000
#define DT_CENTER                   0x00000001
#define DT_RIGHT                    0x00000002
#define DT_VCENTER                  0x00000004
#define DT_BOTTOM                   0x00000008
#define DT_WORDBREAK                0x00000010
#define DT_SINGLELINE               0x00000020
#define DT_EXPANDTABS               0x00000040
#define DT_TABSTOP                  0x00000080
#define DT_NOCLIP                   0x00000100
#define DT_EXTERNALLEADING          0x00000200
#define DT_CALCRECT                 0x00000400
#define DT_NOPREFIX                 0x00000800
#define DT_INTERNAL                 0x00001000

#if(WINVER >= 0x0400)
#define DT_EDITCONTROL              0x00002000
#define DT_PATH_ELLIPSIS            0x00004000
#define DT_END_ELLIPSIS             0x00008000
#define DT_MODIFYSTRING             0x00010000
#define DT_RTLREADING               0x00020000
#define DT_WORD_ELLIPSIS            0x00040000
#if(WINVER >= 0x0500)
#define DT_NOFULLWIDTHCHARBREAK     0x00080000
#if(_WIN32_WINNT >= 0x0500)
#define DT_HIDEPREFIX               0x00100000
#define DT_PREFIXONLY               0x00200000
#endif /* _WIN32_WINNT >= 0x0500 */
#endif /* WINVER >= 0x0500 */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

typedef struct tagDRAWTEXTPARAMS
{
    UINT    cbSize;
    int     iTabLength;
    int     iLeftMargin;
    int     iRightMargin;
    UINT    uiLengthDrawn;
} DRAWTEXTPARAMS, *LPDRAWTEXTPARAMS;

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* WINVER >= 0x0400 */


#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#define _In_bypassable_reads_or_z_(size) \
    _When_(((size) == -1) || (_String_length_(_Curr_) <  (size)), _In_z_) \
    _When_(((size) != -1) && (_String_length_(_Curr_) >= (size)), _In_reads_(size))

#define _Inout_grows_updates_bypassable_or_z_(size, grows) \
    _When_(((size) == -1) || (_String_length_(_Curr_) <  (size)), _Pre_z_ _Pre_valid_ _Out_writes_z_(_String_length_(_Curr_) + (grows))) \
    _When_(((size) != -1) && (_String_length_(_Curr_) >= (size)), _Pre_count_(size) _Pre_valid_ _Out_writes_z_((size) + (grows)))


_Success_(return)
int
__stdcall
DrawTextA(
     HDC hdc,
    _When_((format & DT_MODIFYSTRING), _At_((LPSTR)lpchText, _Inout_grows_updates_bypassable_or_z_(cchText, 4)))
    _When_((!(format & DT_MODIFYSTRING)), _In_bypassable_reads_or_z_(cchText))
    LPCSTR lpchText,
     int cchText,
     LPRECT lprc,
     UINT format);

_Success_(return)
int
__stdcall
DrawTextW(
     HDC hdc,
    _When_((format & DT_MODIFYSTRING), _At_((LPWSTR)lpchText, _Inout_grows_updates_bypassable_or_z_(cchText, 4)))
    _When_((!(format & DT_MODIFYSTRING)), _In_bypassable_reads_or_z_(cchText))
    LPCWSTR lpchText,
     int cchText,
     LPRECT lprc,
     UINT format);
#ifdef UNICODE
#define DrawText  DrawTextW
#else
#define DrawText  DrawTextA
#endif // !UNICODE

#if defined(_M_CEE)
#undef DrawText
__inline
int
DrawText(
    HDC hdc,
    LPCTSTR lpchText,
    int cchText,
    LPRECT lprc,
    UINT format
    )
{
#ifdef UNICODE
    return DrawTextW(
#else
    return DrawTextA(
#endif
        hdc,
    lpchText,
    cchText,
    lprc,
    format
        );
}
#endif  /* _M_CEE */


#if(WINVER >= 0x0400)

_Success_(return)
int
__stdcall
DrawTextExA(
     HDC hdc,
    _When_((cchText) < -1, _Unreferenced_parameter_)
    _When_((format & DT_MODIFYSTRING), _Inout_grows_updates_bypassable_or_z_(cchText, 4))
    _When_((!(format & DT_MODIFYSTRING)), _At_((LPCSTR)lpchText, _In_bypassable_reads_or_z_(cchText)))
    LPSTR lpchText,
     int cchText,
     LPRECT lprc,
     UINT format,
     LPDRAWTEXTPARAMS lpdtp);

_Success_(return)
int
__stdcall
DrawTextExW(
     HDC hdc,
    _When_((cchText) < -1, _Unreferenced_parameter_)
    _When_((format & DT_MODIFYSTRING), _Inout_grows_updates_bypassable_or_z_(cchText, 4))
    _When_((!(format & DT_MODIFYSTRING)), _At_((LPCWSTR)lpchText, _In_bypassable_reads_or_z_(cchText)))
    LPWSTR lpchText,
     int cchText,
     LPRECT lprc,
     UINT format,
     LPDRAWTEXTPARAMS lpdtp);
#ifdef UNICODE
#define DrawTextEx  DrawTextExW
#else
#define DrawTextEx  DrawTextExA
#endif // !UNICODE
#endif /* WINVER >= 0x0400 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* !NODRAWTEXT */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
GrayStringA(
     HDC hDC,
     HBRUSH hBrush,
     GRAYSTRINGPROC lpOutputFunc,
     LPARAM lpData,
     int nCount,
     int X,
     int Y,
     int nWidth,
     int nHeight);

BOOL
__stdcall
GrayStringW(
     HDC hDC,
     HBRUSH hBrush,
     GRAYSTRINGPROC lpOutputFunc,
     LPARAM lpData,
     int nCount,
     int X,
     int Y,
     int nWidth,
     int nHeight);
#ifdef UNICODE
#define GrayString  GrayStringW
#else
#define GrayString  GrayStringA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#if(WINVER >= 0x0400)
/* Monolithic state-drawing routine */
/* Image type */
#define DST_COMPLEX     0x0000
#define DST_TEXT        0x0001
#define DST_PREFIXTEXT  0x0002
#define DST_ICON        0x0003
#define DST_BITMAP      0x0004

/* State type */
#define DSS_NORMAL      0x0000
#define DSS_UNION       0x0010  /* Gray string appearance */
#define DSS_DISABLED    0x0020
#define DSS_MONO        0x0080
#if(_WIN32_WINNT >= 0x0500)
#define DSS_HIDEPREFIX  0x0200
#define DSS_PREFIXONLY  0x0400
#endif /* _WIN32_WINNT >= 0x0500 */
#define DSS_RIGHT       0x8000

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
DrawStateA(
     HDC hdc,
     HBRUSH hbrFore,
     DRAWSTATEPROC qfn__stdcall,
     LPARAM lData,
     WPARAM wData,
     int x,
     int y,
     int cx,
     int cy,
     UINT uFlags);

BOOL
__stdcall
DrawStateW(
     HDC hdc,
     HBRUSH hbrFore,
     DRAWSTATEPROC qfn__stdcall,
     LPARAM lData,
     WPARAM wData,
     int x,
     int y,
     int cx,
     int cy,
     UINT uFlags);
#ifdef UNICODE
#define DrawState  DrawStateW
#else
#define DrawState  DrawStateA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* WINVER >= 0x0400 */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


LONG
__stdcall
TabbedTextOutA(
     HDC hdc,
     int x,
     int y,
    _In_reads_(chCount) LPCSTR lpString,
     int chCount,
     int nTabPositions,
    _In_reads_opt_(nTabPositions) CONST INT *lpnTabStopPositions,
     int nTabOrigin);

LONG
__stdcall
TabbedTextOutW(
     HDC hdc,
     int x,
     int y,
    _In_reads_(chCount) LPCWSTR lpString,
     int chCount,
     int nTabPositions,
    _In_reads_opt_(nTabPositions) CONST INT *lpnTabStopPositions,
     int nTabOrigin);
#ifdef UNICODE
#define TabbedTextOut  TabbedTextOutW
#else
#define TabbedTextOut  TabbedTextOutA
#endif // !UNICODE


DWORD
__stdcall
GetTabbedTextExtentA(
     HDC hdc,
    _In_reads_(chCount) LPCSTR lpString,
     int chCount,
     int nTabPositions,
    _In_reads_opt_(nTabPositions) CONST INT *lpnTabStopPositions);

DWORD
__stdcall
GetTabbedTextExtentW(
     HDC hdc,
    _In_reads_(chCount) LPCWSTR lpString,
     int chCount,
     int nTabPositions,
    _In_reads_opt_(nTabPositions) CONST INT *lpnTabStopPositions);
#ifdef UNICODE
#define GetTabbedTextExtent  GetTabbedTextExtentW
#else
#define GetTabbedTextExtent  GetTabbedTextExtentA
#endif // !UNICODE


BOOL
__stdcall
UpdateWindow(
     HWND hWnd);


HWND
__stdcall
SetActiveWindow(
     HWND hWnd);



HWND
__stdcall
GetForegroundWindow(
    VOID);

#if(WINVER >= 0x0400)

BOOL
__stdcall
PaintDesktop(
     HDC hdc);


VOID
__stdcall
SwitchToThisWindow(
     HWND hwnd,
     BOOL fUnknown);
#endif /* WINVER >= 0x0400 */



BOOL
__stdcall
SetForegroundWindow(
     HWND hWnd);

#if(_WIN32_WINNT >= 0x0500)

BOOL
__stdcall
AllowSetForegroundWindow(
     DWORD dwProcessId);

#define ASFW_ANY    ((DWORD)-1)


BOOL
__stdcall
LockSetForegroundWindow(
     UINT uLockCode);

#define LSFW_LOCK       1
#define LSFW_UNLOCK     2

#endif /* _WIN32_WINNT >= 0x0500 */


HWND
__stdcall
WindowFromDC(
     HDC hDC);


HDC
__stdcall
GetDC(
     HWND hWnd);


HDC
__stdcall
GetDCEx(
     HWND hWnd,
     HRGN hrgnClip,
     DWORD flags);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/*
 * GetDCEx() flags
 */
#define DCX_WINDOW           0x00000001L
#define DCX_CACHE            0x00000002L
#define DCX_NORESETATTRS     0x00000004L
#define DCX_CLIPCHILDREN     0x00000008L
#define DCX_CLIPSIBLINGS     0x00000010L
#define DCX_PARENTCLIP       0x00000020L
#define DCX_EXCLUDERGN       0x00000040L
#define DCX_INTERSECTRGN     0x00000080L
#define DCX_EXCLUDEUPDATE    0x00000100L
#define DCX_INTERSECTUPDATE  0x00000200L
#define DCX_LOCKWINDOWUPDATE 0x00000400L

#define DCX_VALIDATE         0x00200000L

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


HDC
__stdcall
GetWindowDC(
     HWND hWnd);


int
__stdcall
ReleaseDC(
     HWND hWnd,
     HDC hDC);


HDC
__stdcall
BeginPaint(
     HWND hWnd,
     LPPAINTSTRUCT lpPaint);


BOOL
__stdcall
EndPaint(
     HWND hWnd,
     CONST PAINTSTRUCT *lpPaint);


BOOL
__stdcall
GetUpdateRect(
     HWND hWnd,
    _Out_opt_ LPRECT lpRect,
     BOOL bErase);


int
__stdcall
GetUpdateRgn(
     HWND hWnd,
     HRGN hRgn,
     BOOL bErase);


int
__stdcall
SetWindowRgn(
     HWND hWnd,
     HRGN hRgn,
     BOOL bRedraw);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion


#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


int
__stdcall
GetWindowRgn(
     HWND hWnd,
     HRGN hRgn);

#if(_WIN32_WINNT >= 0x0501)


int
__stdcall
GetWindowRgnBox(
     HWND hWnd,
     LPRECT lprc);

#endif /* _WIN32_WINNT >= 0x0501 */


int
__stdcall
ExcludeUpdateRgn(
     HDC hDC,
     HWND hWnd);


BOOL
__stdcall
InvalidateRect(
     HWND hWnd,
     CONST RECT *lpRect,
     BOOL bErase);


BOOL
__stdcall
ValidateRect(
     HWND hWnd,
     CONST RECT *lpRect);


BOOL
__stdcall
InvalidateRgn(
     HWND hWnd,
     HRGN hRgn,
     BOOL bErase);


BOOL
__stdcall
ValidateRgn(
     HWND hWnd,
     HRGN hRgn);



BOOL
__stdcall
RedrawWindow(
     HWND hWnd,
     CONST RECT *lprcUpdate,
     HRGN hrgnUpdate,
     UINT flags);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/*
 * RedrawWindow() flags
 */
#define RDW_INVALIDATE          0x0001
#define RDW_INTERNALPAINT       0x0002
#define RDW_ERASE               0x0004

#define RDW_VALIDATE            0x0008
#define RDW_NOINTERNALPAINT     0x0010
#define RDW_NOERASE             0x0020

#define RDW_NOCHILDREN          0x0040
#define RDW_ALLCHILDREN         0x0080

#define RDW_UPDATENOW           0x0100
#define RDW_ERASENOW            0x0200

#define RDW_FRAME               0x0400
#define RDW_NOFRAME             0x0800


#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

/*
 * LockWindowUpdate API
 */


BOOL
__stdcall
LockWindowUpdate(
     HWND hWndLock);


BOOL
__stdcall
ScrollWindow(
     HWND hWnd,
     int XAmount,
     int YAmount,
     CONST RECT *lpRect,
     CONST RECT *lpClipRect);


BOOL
__stdcall
ScrollDC(
     HDC hDC,
     int dx,
     int dy,
     CONST RECT *lprcScroll,
     CONST RECT *lprcClip,
     HRGN hrgnUpdate,
    _Out_opt_ LPRECT lprcUpdate);


int
__stdcall
ScrollWindowEx(
     HWND hWnd,
     int dx,
     int dy,
     CONST RECT *prcScroll,
     CONST RECT *prcClip,
     HRGN hrgnUpdate,
    _Out_opt_ LPRECT prcUpdate,
     UINT flags);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#define SW_SCROLLCHILDREN   0x0001  /* Scroll children within *lprcScroll. */
#define SW_INVALIDATE       0x0002  /* Invalidate after scrolling */
#define SW_ERASE            0x0004  /* If SW_INVALIDATE, don't send WM_ERASEBACKGROUND */
#if(WINVER >= 0x0500)
#define SW_SMOOTHSCROLL     0x0010  /* Use smooth scrolling */
#endif /* WINVER >= 0x0500 */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#ifndef NOSCROLL


int
__stdcall
SetScrollPos(
     HWND hWnd,
     int nBar,
     int nPos,
     BOOL bRedraw);


int
__stdcall
GetScrollPos(
     HWND hWnd,
     int nBar);


BOOL
__stdcall
SetScrollRange(
     HWND hWnd,
     int nBar,
     int nMinPos,
     int nMaxPos,
     BOOL bRedraw);


BOOL
__stdcall
GetScrollRange(
     HWND hWnd,
     int nBar,
     LPINT lpMinPos,
     LPINT lpMaxPos);


BOOL
__stdcall
ShowScrollBar(
     HWND hWnd,
     int wBar,
     BOOL bShow);


BOOL
__stdcall
EnableScrollBar(
     HWND hWnd,
     UINT wSBflags,
     UINT wArrows);


/*
 * EnableScrollBar() flags
 */
#define ESB_ENABLE_BOTH     0x0000
#define ESB_DISABLE_BOTH    0x0003

#define ESB_DISABLE_LEFT    0x0001
#define ESB_DISABLE_RIGHT   0x0002

#define ESB_DISABLE_UP      0x0001
#define ESB_DISABLE_DOWN    0x0002

#define ESB_DISABLE_LTUP    ESB_DISABLE_LEFT
#define ESB_DISABLE_RTDN    ESB_DISABLE_RIGHT


#endif  /* !NOSCROLL */


BOOL
__stdcall
SetPropA(
     HWND hWnd,
     LPCSTR lpString,
     HANDLE hData);

BOOL
__stdcall
SetPropW(
     HWND hWnd,
     LPCWSTR lpString,
     HANDLE hData);
#ifdef UNICODE
#define SetProp  SetPropW
#else
#define SetProp  SetPropA
#endif // !UNICODE


HANDLE
__stdcall
GetPropA(
     HWND hWnd,
     LPCSTR lpString);

HANDLE
__stdcall
GetPropW(
     HWND hWnd,
     LPCWSTR lpString);
#ifdef UNICODE
#define GetProp  GetPropW
#else
#define GetProp  GetPropA
#endif // !UNICODE


HANDLE
__stdcall
RemovePropA(
     HWND hWnd,
     LPCSTR lpString);

HANDLE
__stdcall
RemovePropW(
     HWND hWnd,
     LPCWSTR lpString);
#ifdef UNICODE
#define RemoveProp  RemovePropW
#else
#define RemoveProp  RemovePropA
#endif // !UNICODE


int
__stdcall
EnumPropsExA(
     HWND hWnd,
     PROPENUMPROCEXA lpEnumFunc,
     LPARAM lParam);

int
__stdcall
EnumPropsExW(
     HWND hWnd,
     PROPENUMPROCEXW lpEnumFunc,
     LPARAM lParam);
#ifdef UNICODE
#define EnumPropsEx  EnumPropsExW
#else
#define EnumPropsEx  EnumPropsExA
#endif // !UNICODE


int
__stdcall
EnumPropsA(
     HWND hWnd,
     PROPENUMPROCA lpEnumFunc);

int
__stdcall
EnumPropsW(
     HWND hWnd,
     PROPENUMPROCW lpEnumFunc);
#ifdef UNICODE
#define EnumProps  EnumPropsW
#else
#define EnumProps  EnumPropsA
#endif // !UNICODE


BOOL
__stdcall
SetWindowTextA(
     HWND hWnd,
     LPCSTR lpString);

BOOL
__stdcall
SetWindowTextW(
     HWND hWnd,
     LPCWSTR lpString);
#ifdef UNICODE
#define SetWindowText  SetWindowTextW
#else
#define SetWindowText  SetWindowTextA
#endif // !UNICODE

_Ret_range_(0, nMaxCount)

int
__stdcall
GetWindowTextA(
     HWND hWnd,
    _Out_writes_(nMaxCount) LPSTR lpString,
     int nMaxCount);
_Ret_range_(0, nMaxCount)

int
__stdcall
GetWindowTextW(
     HWND hWnd,
    _Out_writes_(nMaxCount) LPWSTR lpString,
     int nMaxCount);
#ifdef UNICODE
#define GetWindowText  GetWindowTextW
#else
#define GetWindowText  GetWindowTextA
#endif // !UNICODE


int
__stdcall
GetWindowTextLengthA(
     HWND hWnd);

int
__stdcall
GetWindowTextLengthW(
     HWND hWnd);
#ifdef UNICODE
#define GetWindowTextLength  GetWindowTextLengthW
#else
#define GetWindowTextLength  GetWindowTextLengthA
#endif // !UNICODE


BOOL
__stdcall
GetClientRect(
     HWND hWnd,
     LPRECT lpRect);


BOOL
__stdcall
GetWindowRect(
     HWND hWnd,
     LPRECT lpRect);


BOOL
__stdcall
AdjustWindowRect(
     LPRECT lpRect,
     DWORD dwStyle,
     BOOL bMenu);


BOOL
__stdcall
AdjustWindowRectEx(
     LPRECT lpRect,
     DWORD dwStyle,
     BOOL bMenu,
     DWORD dwExStyle);

#if(WINVER >= 0x0605)

BOOL
__stdcall
AdjustWindowRectExForDpi(
     LPRECT lpRect,
     DWORD dwStyle,
     BOOL bMenu,
     DWORD dwExStyle,
     UINT dpi);
#endif /* WINVER >= 0x0605 */


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#if(WINVER >= 0x0400)
#define HELPINFO_WINDOW    0x0001
#define HELPINFO_MENUITEM  0x0002

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

typedef struct tagHELPINFO      /* Structure pointed to by lParam of WM_HELP */
{
    UINT    cbSize;             /* Size in bytes of this struct  */
    int     iContextType;       /* Either HELPINFO_WINDOW or HELPINFO_MENUITEM */
    int     iCtrlId;            /* Control Id or a Menu item Id. */
    HANDLE  hItemHandle;        /* hWnd of control or hMenu.     */
    DWORD_PTR dwContextId;      /* Context Id associated with this item */
    POINT   MousePos;           /* Mouse Position in screen co-ordinates */
}  HELPINFO, *LPHELPINFO;


BOOL
__stdcall
SetWindowContextHelpId(
     HWND,
     DWORD);


DWORD
__stdcall
GetWindowContextHelpId(
     HWND);


BOOL
__stdcall
SetMenuContextHelpId(
     HMENU,
     DWORD);


DWORD
__stdcall
GetMenuContextHelpId(
     HMENU);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* WINVER >= 0x0400 */


#ifndef NOMB

/*
 * MessageBox() Flags
 */
#define MB_OK                       0x00000000L
#define MB_OKCANCEL                 0x00000001L
#define MB_ABORTRETRYIGNORE         0x00000002L
#define MB_YESNOCANCEL              0x00000003L
#define MB_YESNO                    0x00000004L
#define MB_RETRYCANCEL              0x00000005L
#if(WINVER >= 0x0500)
#define MB_CANCELTRYCONTINUE        0x00000006L
#endif /* WINVER >= 0x0500 */


#define MB_ICONHAND                 0x00000010L
#define MB_ICONQUESTION             0x00000020L
#define MB_ICONEXCLAMATION          0x00000030L
#define MB_ICONASTERISK             0x00000040L

#if(WINVER >= 0x0400)
#define MB_USERICON                 0x00000080L
#define MB_ICONWARNING              MB_ICONEXCLAMATION
#define MB_ICONERROR                MB_ICONHAND
#endif /* WINVER >= 0x0400 */

#define MB_ICONINFORMATION          MB_ICONASTERISK
#define MB_ICONSTOP                 MB_ICONHAND

#define MB_DEFBUTTON1               0x00000000L
#define MB_DEFBUTTON2               0x00000100L
#define MB_DEFBUTTON3               0x00000200L
#if(WINVER >= 0x0400)
#define MB_DEFBUTTON4               0x00000300L
#endif /* WINVER >= 0x0400 */

#define MB_APPLMODAL                0x00000000L
#define MB_SYSTEMMODAL              0x00001000L
#define MB_TASKMODAL                0x00002000L
#if(WINVER >= 0x0400)
#define MB_HELP                     0x00004000L // Help Button
#endif /* WINVER >= 0x0400 */

#define MB_NOFOCUS                  0x00008000L
#define MB_SETFOREGROUND            0x00010000L
#define MB_DEFAULT_DESKTOP_ONLY     0x00020000L

#if(WINVER >= 0x0400)
#define MB_TOPMOST                  0x00040000L
#define MB_RIGHT                    0x00080000L
#define MB_RTLREADING               0x00100000L

#endif /* WINVER >= 0x0400 */

#ifdef _WIN32_WINNT
#if (_WIN32_WINNT >= 0x0400)
#define MB_SERVICE_NOTIFICATION          0x00200000L
#else
#define MB_SERVICE_NOTIFICATION          0x00040000L
#endif
#define MB_SERVICE_NOTIFICATION_NT3X     0x00040000L
#endif

#define MB_TYPEMASK                 0x0000000FL
#define MB_ICONMASK                 0x000000F0L
#define MB_DEFMASK                  0x00000F00L
#define MB_MODEMASK                 0x00003000L
#define MB_MISCMASK                 0x0000C000L

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


int
__stdcall
MessageBoxA(
     HWND hWnd,
     LPCSTR lpText,
     LPCSTR lpCaption,
     UINT uType);

int
__stdcall
MessageBoxW(
     HWND hWnd,
     LPCWSTR lpText,
     LPCWSTR lpCaption,
     UINT uType);
#ifdef UNICODE
#define MessageBox  MessageBoxW
#else
#define MessageBox  MessageBoxA
#endif // !UNICODE

#if defined(_M_CEE)
#undef MessageBox
__inline
int
MessageBox(
    HWND hWnd,
    LPCTSTR lpText,
    LPCTSTR lpCaption,
    UINT uType
    )
{
#ifdef UNICODE
    return MessageBoxW(
#else
    return MessageBoxA(
#endif
        hWnd,
    lpText,
    lpCaption,
    uType
        );
}
#endif  /* _M_CEE */


int
__stdcall
MessageBoxExA(
     HWND hWnd,
     LPCSTR lpText,
     LPCSTR lpCaption,
     UINT uType,
     WORD wLanguageId);

int
__stdcall
MessageBoxExW(
     HWND hWnd,
     LPCWSTR lpText,
     LPCWSTR lpCaption,
     UINT uType,
     WORD wLanguageId);
#ifdef UNICODE
#define MessageBoxEx  MessageBoxExW
#else
#define MessageBoxEx  MessageBoxExA
#endif // !UNICODE

#if(WINVER >= 0x0400)

typedef VOID (__stdcall *MSGBOX__stdcall)(LPHELPINFO lpHelpInfo);

typedef struct tagMSGBOXPARAMSA
{
    UINT        cbSize;
    HWND        hwndOwner;
    HINSTANCE   hInstance;
    LPCSTR      lpszText;
    LPCSTR      lpszCaption;
    DWORD       dwStyle;
    LPCSTR      lpszIcon;
    DWORD_PTR   dwContextHelpId;
    MSGBOX__stdcall      lpfnMsgBox__stdcall;
    DWORD       dwLanguageId;
} MSGBOXPARAMSA, *PMSGBOXPARAMSA, *LPMSGBOXPARAMSA;
typedef struct tagMSGBOXPARAMSW
{
    UINT        cbSize;
    HWND        hwndOwner;
    HINSTANCE   hInstance;
    LPCWSTR     lpszText;
    LPCWSTR     lpszCaption;
    DWORD       dwStyle;
    LPCWSTR     lpszIcon;
    DWORD_PTR   dwContextHelpId;
    MSGBOX__stdcall      lpfnMsgBox__stdcall;
    DWORD       dwLanguageId;
} MSGBOXPARAMSW, *PMSGBOXPARAMSW, *LPMSGBOXPARAMSW;
#ifdef UNICODE
typedef MSGBOXPARAMSW MSGBOXPARAMS;
typedef PMSGBOXPARAMSW PMSGBOXPARAMS;
typedef LPMSGBOXPARAMSW LPMSGBOXPARAMS;
#else
typedef MSGBOXPARAMSA MSGBOXPARAMS;
typedef PMSGBOXPARAMSA PMSGBOXPARAMS;
typedef LPMSGBOXPARAMSA LPMSGBOXPARAMS;
#endif // UNICODE


int
__stdcall
MessageBoxIndirectA(
     CONST MSGBOXPARAMSA * lpmbp);

int
__stdcall
MessageBoxIndirectW(
     CONST MSGBOXPARAMSW * lpmbp);
#ifdef UNICODE
#define MessageBoxIndirect  MessageBoxIndirectW
#else
#define MessageBoxIndirect  MessageBoxIndirectA
#endif // !UNICODE
#endif /* WINVER >= 0x0400 */


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion


#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
MessageBeep(
     UINT uType);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* !NOMB */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)



int
__stdcall
ShowCursor(
     BOOL bShow);


BOOL
__stdcall
SetCursorPos(
     int X,
     int Y);

#if(WINVER >= 0x0600)

BOOL
__stdcall
SetPhysicalCursorPos(
     int X,
     int Y);
#endif /* WINVER >= 0x0600 */


HCURSOR
__stdcall
SetCursor(
     HCURSOR hCursor);


BOOL
__stdcall
GetCursorPos(
     LPPOINT lpPoint);

#if(WINVER >= 0x0600)

BOOL
__stdcall
GetPhysicalCursorPos(
     LPPOINT lpPoint);
#endif /* WINVER >= 0x0600 */


BOOL
__stdcall
ClipCursor(
     CONST RECT *lpRect);



BOOL
__stdcall
GetClipCursor(
     LPRECT lpRect);


HCURSOR
__stdcall
GetCursor(
    VOID);


BOOL
__stdcall
CreateCaret(
     HWND hWnd,
     HBITMAP hBitmap,
     int nWidth,
     int nHeight);


UINT
__stdcall
GetCaretBlinkTime(
    VOID);


BOOL
__stdcall
SetCaretBlinkTime(
     UINT uMSeconds);


BOOL
__stdcall
DestroyCaret(
    VOID);


BOOL
__stdcall
HideCaret(
     HWND hWnd);


BOOL
__stdcall
ShowCaret(
     HWND hWnd);


BOOL
__stdcall
SetCaretPos(
     int X,
     int Y);


BOOL
__stdcall
GetCaretPos(
     LPPOINT lpPoint);


BOOL
__stdcall
ClientToScreen(
     HWND hWnd,
     LPPOINT lpPoint);


BOOL
__stdcall
ScreenToClient(
     HWND hWnd,
     LPPOINT lpPoint);

#if(WINVER >= 0x0600)

BOOL
__stdcall
LogicalToPhysicalPoint(
     HWND hWnd,
     LPPOINT lpPoint);


BOOL
__stdcall
PhysicalToLogicalPoint(
     HWND hWnd,
     LPPOINT lpPoint);

#endif /* WINVER >= 0x0600 */

#if(WINVER >= 0x0603)

BOOL
__stdcall
LogicalToPhysicalPointForPerMonitorDPI(
     HWND hWnd,
     LPPOINT lpPoint);


BOOL
__stdcall
PhysicalToLogicalPointForPerMonitorDPI(
     HWND hWnd,
     LPPOINT lpPoint);

#endif /* WINVER >= 0x0603 */


int
__stdcall
MapWindowPoints(
     HWND hWndFrom,
     HWND hWndTo,
    _Inout_updates_(cPoints) LPPOINT lpPoints,
     UINT cPoints);


HWND
__stdcall
WindowFromPoint(
     POINT Point);

#if(WINVER >= 0x0600)

HWND
__stdcall
WindowFromPhysicalPoint(
     POINT Point);
#endif /* WINVER >= 0x0600 */


HWND
__stdcall
ChildWindowFromPoint(
     HWND hWndParent,
     POINT Point);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#if(WINVER >= 0x0400)
#define CWP_ALL             0x0000
#define CWP_SKIPINVISIBLE   0x0001
#define CWP_SKIPDISABLED    0x0002
#define CWP_SKIPTRANSPARENT 0x0004

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


HWND
__stdcall
ChildWindowFromPointEx(
     HWND hwnd,
     POINT pt,
     UINT flags);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* WINVER >= 0x0400 */

#ifndef NOCOLOR

/*
 * Color Types
 */
#define CTLCOLOR_MSGBOX         0
#define CTLCOLOR_EDIT           1
#define CTLCOLOR_LISTBOX        2
#define CTLCOLOR_BTN            3
#define CTLCOLOR_DLG            4
#define CTLCOLOR_SCROLLBAR      5
#define CTLCOLOR_STATIC         6
#define CTLCOLOR_MAX            7

#define COLOR_SCROLLBAR         0
#define COLOR_BACKGROUND        1
#define COLOR_ACTIVECAPTION     2
#define COLOR_INACTIVECAPTION   3
#define COLOR_MENU              4
#define COLOR_WINDOW            5
#define COLOR_WINDOWFRAME       6
#define COLOR_MENUTEXT          7
#define COLOR_WINDOWTEXT        8
#define COLOR_CAPTIONTEXT       9
#define COLOR_ACTIVEBORDER      10
#define COLOR_INACTIVEBORDER    11
#define COLOR_APPWORKSPACE      12
#define COLOR_HIGHLIGHT         13
#define COLOR_HIGHLIGHTTEXT     14
#define COLOR_BTNFACE           15
#define COLOR_BTNSHADOW         16
#define COLOR_GRAYTEXT          17
#define COLOR_BTNTEXT           18
#define COLOR_INACTIVECAPTIONTEXT 19
#define COLOR_BTNHIGHLIGHT      20

#if(WINVER >= 0x0400)
#define COLOR_3DDKSHADOW        21
#define COLOR_3DLIGHT           22
#define COLOR_INFOTEXT          23
#define COLOR_INFOBK            24
#endif /* WINVER >= 0x0400 */

#if(WINVER >= 0x0500)
#define COLOR_HOTLIGHT          26
#define COLOR_GRADIENTACTIVECAPTION 27
#define COLOR_GRADIENTINACTIVECAPTION 28
#if(WINVER >= 0x0501)
#define COLOR_MENUHILIGHT       29
#define COLOR_MENUBAR           30
#endif /* WINVER >= 0x0501 */
#endif /* WINVER >= 0x0500 */

#if(WINVER >= 0x0400)
#define COLOR_DESKTOP           COLOR_BACKGROUND
#define COLOR_3DFACE            COLOR_BTNFACE
#define COLOR_3DSHADOW          COLOR_BTNSHADOW
#define COLOR_3DHIGHLIGHT       COLOR_BTNHIGHLIGHT
#define COLOR_3DHILIGHT         COLOR_BTNHIGHLIGHT
#define COLOR_BTNHILIGHT        COLOR_BTNHIGHLIGHT
#endif /* WINVER >= 0x0400 */


#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


DWORD
__stdcall
GetSysColor(
     int nIndex);

#if(WINVER >= 0x0400)

HBRUSH
__stdcall
GetSysColorBrush(
     int nIndex);


#endif /* WINVER >= 0x0400 */


BOOL
__stdcall
SetSysColors(
     int cElements,
    _In_reads_(cElements) CONST INT * lpaElements,
    _In_reads_(cElements) CONST COLORREF * lpaRgbValues);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* !NOCOLOR */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
DrawFocusRect(
     HDC hDC,
     CONST RECT * lprc);


int
__stdcall
FillRect(
     HDC hDC,
     CONST RECT *lprc,
     HBRUSH hbr);


int
__stdcall
FrameRect(
     HDC hDC,
     CONST RECT *lprc,
     HBRUSH hbr);


BOOL
__stdcall
InvertRect(
     HDC hDC,
     CONST RECT *lprc);


BOOL
__stdcall
SetRect(
     LPRECT lprc,
     int xLeft,
     int yTop,
     int xRight,
     int yBottom);


BOOL
__stdcall
SetRectEmpty(
     LPRECT lprc);


BOOL
__stdcall
CopyRect(
     LPRECT lprcDst,
     CONST RECT *lprcSrc);


BOOL
__stdcall
InflateRect(
     LPRECT lprc,
     int dx,
     int dy);


BOOL
__stdcall
IntersectRect(
     LPRECT lprcDst,
     CONST RECT *lprcSrc1,
     CONST RECT *lprcSrc2);


BOOL
__stdcall
UnionRect(
     LPRECT lprcDst,
     CONST RECT *lprcSrc1,
     CONST RECT *lprcSrc2);


BOOL
__stdcall
SubtractRect(
     LPRECT lprcDst,
     CONST RECT *lprcSrc1,
     CONST RECT *lprcSrc2);


BOOL
__stdcall
OffsetRect(
     LPRECT lprc,
     int dx,
     int dy);


BOOL
__stdcall
IsRectEmpty(
     CONST RECT *lprc);


BOOL
__stdcall
EqualRect(
     CONST RECT *lprc1,
     CONST RECT *lprc2);


BOOL
__stdcall
PtInRect(
     CONST RECT *lprc,
     POINT pt);

#ifndef NOWINOFFSETS


WORD
__stdcall
GetWindowWord(
     HWND hWnd,
     int nIndex);


WORD
__stdcall
SetWindowWord(
     HWND hWnd,
     int nIndex,
     WORD wNewWord);


LONG
__stdcall
GetWindowLongA(
     HWND hWnd,
     int nIndex);

LONG
__stdcall
GetWindowLongW(
     HWND hWnd,
     int nIndex);
#ifdef UNICODE
#define GetWindowLong  GetWindowLongW
#else
#define GetWindowLong  GetWindowLongA
#endif // !UNICODE


LONG
__stdcall
SetWindowLongA(
     HWND hWnd,
     int nIndex,
     LONG dwNewLong);

LONG
__stdcall
SetWindowLongW(
     HWND hWnd,
     int nIndex,
     LONG dwNewLong);
#ifdef UNICODE
#define SetWindowLong  SetWindowLongW
#else
#define SetWindowLong  SetWindowLongA
#endif // !UNICODE

#ifdef _WIN64


LONG_PTR
__stdcall
GetWindowLongPtrA(
     HWND hWnd,
     int nIndex);

LONG_PTR
__stdcall
GetWindowLongPtrW(
     HWND hWnd,
     int nIndex);
#ifdef UNICODE
#define GetWindowLongPtr  GetWindowLongPtrW
#else
#define GetWindowLongPtr  GetWindowLongPtrA
#endif // !UNICODE


LONG_PTR
__stdcall
SetWindowLongPtrA(
     HWND hWnd,
     int nIndex,
     LONG_PTR dwNewLong);

LONG_PTR
__stdcall
SetWindowLongPtrW(
     HWND hWnd,
     int nIndex,
     LONG_PTR dwNewLong);
#ifdef UNICODE
#define SetWindowLongPtr  SetWindowLongPtrW
#else
#define SetWindowLongPtr  SetWindowLongPtrA
#endif // !UNICODE

#else  /* _WIN64 */

#define GetWindowLongPtrA   GetWindowLongA
#define GetWindowLongPtrW   GetWindowLongW
#ifdef UNICODE
#define GetWindowLongPtr  GetWindowLongPtrW
#else
#define GetWindowLongPtr  GetWindowLongPtrA
#endif // !UNICODE

#define SetWindowLongPtrA   SetWindowLongA
#define SetWindowLongPtrW   SetWindowLongW
#ifdef UNICODE
#define SetWindowLongPtr  SetWindowLongPtrW
#else
#define SetWindowLongPtr  SetWindowLongPtrA
#endif // !UNICODE

#endif /* _WIN64 */


WORD
__stdcall
GetClassWord(
     HWND hWnd,
     int nIndex);


WORD
__stdcall
SetClassWord(
     HWND hWnd,
     int nIndex,
     WORD wNewWord);


DWORD
__stdcall
GetClassLongA(
     HWND hWnd,
     int nIndex);

DWORD
__stdcall
GetClassLongW(
     HWND hWnd,
     int nIndex);
#ifdef UNICODE
#define GetClassLong  GetClassLongW
#else
#define GetClassLong  GetClassLongA
#endif // !UNICODE


DWORD
__stdcall
SetClassLongA(
     HWND hWnd,
     int nIndex,
     LONG dwNewLong);

DWORD
__stdcall
SetClassLongW(
     HWND hWnd,
     int nIndex,
     LONG dwNewLong);
#ifdef UNICODE
#define SetClassLong  SetClassLongW
#else
#define SetClassLong  SetClassLongA
#endif // !UNICODE

#ifdef _WIN64


ULONG_PTR
__stdcall
GetClassLongPtrA(
     HWND hWnd,
     int nIndex);

ULONG_PTR
__stdcall
GetClassLongPtrW(
     HWND hWnd,
     int nIndex);
#ifdef UNICODE
#define GetClassLongPtr  GetClassLongPtrW
#else
#define GetClassLongPtr  GetClassLongPtrA
#endif // !UNICODE


ULONG_PTR
__stdcall
SetClassLongPtrA(
     HWND hWnd,
     int nIndex,
     LONG_PTR dwNewLong);

ULONG_PTR
__stdcall
SetClassLongPtrW(
     HWND hWnd,
     int nIndex,
     LONG_PTR dwNewLong);
#ifdef UNICODE
#define SetClassLongPtr  SetClassLongPtrW
#else
#define SetClassLongPtr  SetClassLongPtrA
#endif // !UNICODE

#else  /* _WIN64 */

#define GetClassLongPtrA    GetClassLongA
#define GetClassLongPtrW    GetClassLongW
#ifdef UNICODE
#define GetClassLongPtr  GetClassLongPtrW
#else
#define GetClassLongPtr  GetClassLongPtrA
#endif // !UNICODE

#define SetClassLongPtrA    SetClassLongA
#define SetClassLongPtrW    SetClassLongW
#ifdef UNICODE
#define SetClassLongPtr  SetClassLongPtrW
#else
#define SetClassLongPtr  SetClassLongPtrA
#endif // !UNICODE

#endif /* _WIN64 */

#endif /* !NOWINOFFSETS */

#if(WINVER >= 0x0500)

BOOL
__stdcall
GetProcessDefaultLayout(
     DWORD *pdwDefaultLayout);


BOOL
__stdcall
SetProcessDefaultLayout(
     DWORD dwDefaultLayout);
#endif /* WINVER >= 0x0500 */


HWND
__stdcall
GetDesktopWindow(
    VOID);



HWND
__stdcall
GetParent(
     HWND hWnd);


HWND
__stdcall
SetParent(
     HWND hWndChild,
     HWND hWndNewParent);


BOOL
__stdcall
EnumChildWindows(
     HWND hWndParent,
     WNDENUMPROC lpEnumFunc,
     LPARAM lParam);



HWND
__stdcall
FindWindowA(
     LPCSTR lpClassName,
     LPCSTR lpWindowName);

HWND
__stdcall
FindWindowW(
     LPCWSTR lpClassName,
     LPCWSTR lpWindowName);
#ifdef UNICODE
#define FindWindow  FindWindowW
#else
#define FindWindow  FindWindowA
#endif // !UNICODE

#if(WINVER >= 0x0400)

HWND
__stdcall
FindWindowExA(
     HWND hWndParent,
     HWND hWndChildAfter,
     LPCSTR lpszClass,
     LPCSTR lpszWindow);

HWND
__stdcall
FindWindowExW(
     HWND hWndParent,
     HWND hWndChildAfter,
     LPCWSTR lpszClass,
     LPCWSTR lpszWindow);
#ifdef UNICODE
#define FindWindowEx  FindWindowExW
#else
#define FindWindowEx  FindWindowExA
#endif // !UNICODE


HWND
__stdcall
GetShellWindow(
    VOID);

#endif /* WINVER >= 0x0400 */



BOOL
__stdcall
RegisterShellHookWindow(
     HWND hwnd);


BOOL
__stdcall
DeregisterShellHookWindow(
     HWND hwnd);


BOOL
__stdcall
EnumWindows(
     WNDENUMPROC lpEnumFunc,
     LPARAM lParam);


BOOL
__stdcall
EnumThreadWindows(
     DWORD dwThreadId,
     WNDENUMPROC lpfn,
     LPARAM lParam);


#define EnumTaskWindows(hTask, lpfn, lParam) EnumThreadWindows(HandleToUlong(hTask), lpfn, lParam)


int
__stdcall
GetClassNameA(
     HWND hWnd,
    _Out_writes_to_(nMaxCount, return) LPSTR lpClassName,
     int nMaxCount
    );

int
__stdcall
GetClassNameW(
     HWND hWnd,
    _Out_writes_to_(nMaxCount, return) LPWSTR lpClassName,
     int nMaxCount
    );
#ifdef UNICODE
#define GetClassName  GetClassNameW
#else
#define GetClassName  GetClassNameA
#endif // !UNICODE

#if defined(_M_CEE)
#undef GetClassName
__inline
int
GetClassName(
    HWND hWnd,
    LPTSTR lpClassName,
    int nMaxCount
    )
{
#ifdef UNICODE
    return GetClassNameW(
#else
    return GetClassNameA(
#endif
        hWnd,
    lpClassName,
    nMaxCount
        );
}
#endif  /* _M_CEE */




HWND
__stdcall
GetTopWindow(
     HWND hWnd);

#define GetNextWindow(hWnd, wCmd) GetWindow(hWnd, wCmd)
#define GetSysModalWindow() (NULL)
#define SetSysModalWindow(hWnd) (NULL)


DWORD
__stdcall
GetWindowThreadProcessId(
     HWND hWnd,
    _Out_opt_ LPDWORD lpdwProcessId);

#if(_WIN32_WINNT >= 0x0501)

BOOL
__stdcall
IsGUIThread(
     BOOL bConvert);

#endif /* _WIN32_WINNT >= 0x0501 */


#define GetWindowTask(hWnd) \
        ((HANDLE)(DWORD_PTR)GetWindowThreadProcessId(hWnd, NULL))


HWND
__stdcall
GetLastActivePopup(
     HWND hWnd);

/*
 * GetWindow() Constants
 */
#define GW_HWNDFIRST        0
#define GW_HWNDLAST         1
#define GW_HWNDNEXT         2
#define GW_HWNDPREV         3
#define GW_OWNER            4
#define GW_CHILD            5
#if(WINVER <= 0x0400)
#define GW_MAX              5
#else
#define GW_ENABLEDPOPUP     6
#define GW_MAX              6
#endif


HWND
__stdcall
GetWindow(
     HWND hWnd,
     UINT uCmd);


#ifndef NOWH

#ifdef STRICT


HHOOK
__stdcall
SetWindowsHookA(
     int nFilterType,
     HOOKPROC pfnFilterProc);

HHOOK
__stdcall
SetWindowsHookW(
     int nFilterType,
     HOOKPROC pfnFilterProc);
#ifdef UNICODE
#define SetWindowsHook  SetWindowsHookW
#else
#define SetWindowsHook  SetWindowsHookA
#endif // !UNICODE

#else /* !STRICT */


HOOKPROC
__stdcall
SetWindowsHookA(
     int nFilterType,
     HOOKPROC pfnFilterProc);

HOOKPROC
__stdcall
SetWindowsHookW(
     int nFilterType,
     HOOKPROC pfnFilterProc);
#ifdef UNICODE
#define SetWindowsHook  SetWindowsHookW
#else
#define SetWindowsHook  SetWindowsHookA
#endif // !UNICODE

#endif /* !STRICT */


BOOL
__stdcall
UnhookWindowsHook(
     int nCode,
     HOOKPROC pfnFilterProc);


HHOOK
__stdcall
SetWindowsHookExA(
     int idHook,
     HOOKPROC lpfn,
     HINSTANCE hmod,
     DWORD dwThreadId);

HHOOK
__stdcall
SetWindowsHookExW(
     int idHook,
     HOOKPROC lpfn,
     HINSTANCE hmod,
     DWORD dwThreadId);
#ifdef UNICODE
#define SetWindowsHookEx  SetWindowsHookExW
#else
#define SetWindowsHookEx  SetWindowsHookExA
#endif // !UNICODE


BOOL
__stdcall
UnhookWindowsHookEx(
     HHOOK hhk);


LRESULT
__stdcall
CallNextHookEx(
     HHOOK hhk,
     int nCode,
     WPARAM wParam,
     LPARAM lParam);

/*
 * Macros for source-level compatibility with old functions.
 */
#ifdef STRICT
#define DefHookProc(nCode, wParam, lParam, phhk)\
        CallNextHookEx(*phhk, nCode, wParam, lParam)
#else
#define DefHookProc(nCode, wParam, lParam, phhk)\
        CallNextHookEx((HHOOK)*phhk, nCode, wParam, lParam)
#endif /* STRICT */
#endif /* !NOWH */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#ifndef NOMENUS


/* ;win40  -- A lot of MF_* flags have been renamed as MFT_* and MFS_* flags */
/*
 * Menu flags for Add/Check/EnableMenuItem()
 */
#define MF_INSERT           0x00000000L
#define MF_CHANGE           0x00000080L
#define MF_APPEND           0x00000100L
#define MF_DELETE           0x00000200L
#define MF_REMOVE           0x00001000L

#define MF_BYCOMMAND        0x00000000L
#define MF_BYPOSITION       0x00000400L

#define MF_SEPARATOR        0x00000800L

#define MF_ENABLED          0x00000000L
#define MF_GRAYED           0x00000001L
#define MF_DISABLED         0x00000002L

#define MF_UNCHECKED        0x00000000L
#define MF_CHECKED          0x00000008L
#define MF_USECHECKBITMAPS  0x00000200L

#define MF_STRING           0x00000000L
#define MF_BITMAP           0x00000004L
#define MF_OWNERDRAW        0x00000100L

#define MF_POPUP            0x00000010L
#define MF_MENUBARBREAK     0x00000020L
#define MF_MENUBREAK        0x00000040L

#define MF_UNHILITE         0x00000000L
#define MF_HILITE           0x00000080L

#if(WINVER >= 0x0400)
#define MF_DEFAULT          0x00001000L
#endif /* WINVER >= 0x0400 */
#define MF_SYSMENU          0x00002000L
#define MF_HELP             0x00004000L
#if(WINVER >= 0x0400)
#define MF_RIGHTJUSTIFY     0x00004000L
#endif /* WINVER >= 0x0400 */

#define MF_MOUSESELECT      0x00008000L
#if(WINVER >= 0x0400)
#define MF_END              0x00000080L  /* Obsolete -- only used by old RES files */
#endif /* WINVER >= 0x0400 */


#if(WINVER >= 0x0400)
#define MFT_STRING          MF_STRING
#define MFT_BITMAP          MF_BITMAP
#define MFT_MENUBARBREAK    MF_MENUBARBREAK
#define MFT_MENUBREAK       MF_MENUBREAK
#define MFT_OWNERDRAW       MF_OWNERDRAW
#define MFT_RADIOCHECK      0x00000200L
#define MFT_SEPARATOR       MF_SEPARATOR
#define MFT_RIGHTORDER      0x00002000L
#define MFT_RIGHTJUSTIFY    MF_RIGHTJUSTIFY

/* Menu flags for Add/Check/EnableMenuItem() */
#define MFS_GRAYED          0x00000003L
#define MFS_DISABLED        MFS_GRAYED
#define MFS_CHECKED         MF_CHECKED
#define MFS_HILITE          MF_HILITE
#define MFS_ENABLED         MF_ENABLED
#define MFS_UNCHECKED       MF_UNCHECKED
#define MFS_UNHILITE        MF_UNHILITE
#define MFS_DEFAULT         MF_DEFAULT
#endif /* WINVER >= 0x0400 */


#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if(WINVER >= 0x0400)


BOOL
__stdcall
CheckMenuRadioItem(
     HMENU hmenu,
     UINT first,
     UINT last,
     UINT check,
     UINT flags);
#endif /* WINVER >= 0x0400 */

/*
 * Menu item resource format
 */
typedef struct {
    WORD versionNumber;
    WORD offset;
} MENUITEMTEMPLATEHEADER, *PMENUITEMTEMPLATEHEADER;

typedef struct {        // version 0
    WORD mtOption;
    WORD mtID;
    WCHAR mtString[1];
} MENUITEMTEMPLATE, *PMENUITEMTEMPLATE;
#define MF_END             0x00000080L

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* !NOMENUS */

#ifndef NOSYSCOMMANDS

/*
 * System Menu Command Values
 */
#define SC_SIZE         0xF000
#define SC_MOVE         0xF010
#define SC_MINIMIZE     0xF020
#define SC_MAXIMIZE     0xF030
#define SC_NEXTWINDOW   0xF040
#define SC_PREVWINDOW   0xF050
#define SC_CLOSE        0xF060
#define SC_VSCROLL      0xF070
#define SC_HSCROLL      0xF080
#define SC_MOUSEMENU    0xF090
#define SC_KEYMENU      0xF100
#define SC_ARRANGE      0xF110
#define SC_RESTORE      0xF120
#define SC_TASKLIST     0xF130
#define SC_SCREENSAVE   0xF140
#define SC_HOTKEY       0xF150
#if(WINVER >= 0x0400)
#define SC_DEFAULT      0xF160
#define SC_MONITORPOWER 0xF170
#define SC_CONTEXTHELP  0xF180
#define SC_SEPARATOR    0xF00F
#endif /* WINVER >= 0x0400 */

#if(WINVER >= 0x0600)
#define SCF_ISSECURE    0x00000001
#endif /* WINVER >= 0x0600 */

#define GET_SC_WPARAM(wParam) ((int)wParam & 0xFFF0)

/*
 * Obsolete names
 */
#define SC_ICON         SC_MINIMIZE
#define SC_ZOOM         SC_MAXIMIZE

#endif /* !NOSYSCOMMANDS */

/*
 * Resource Loading Routines
 */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


HBITMAP
__stdcall
LoadBitmapA(
     HINSTANCE hInstance,
     LPCSTR lpBitmapName);

HBITMAP
__stdcall
LoadBitmapW(
     HINSTANCE hInstance,
     LPCWSTR lpBitmapName);
#ifdef UNICODE
#define LoadBitmap  LoadBitmapW
#else
#define LoadBitmap  LoadBitmapA
#endif // !UNICODE


HCURSOR
__stdcall
LoadCursorA(
     HINSTANCE hInstance,
     LPCSTR lpCursorName);

HCURSOR
__stdcall
LoadCursorW(
     HINSTANCE hInstance,
     LPCWSTR lpCursorName);
#ifdef UNICODE
#define LoadCursor  LoadCursorW
#else
#define LoadCursor  LoadCursorA
#endif // !UNICODE


HCURSOR
__stdcall
LoadCursorFromFileA(
     LPCSTR lpFileName);

HCURSOR
__stdcall
LoadCursorFromFileW(
     LPCWSTR lpFileName);
#ifdef UNICODE
#define LoadCursorFromFile  LoadCursorFromFileW
#else
#define LoadCursorFromFile  LoadCursorFromFileA
#endif // !UNICODE


HCURSOR
__stdcall
CreateCursor(
     HINSTANCE hInst,
     int xHotSpot,
     int yHotSpot,
     int nWidth,
     int nHeight,
     CONST VOID *pvANDPlane,
     CONST VOID *pvXORPlane);


BOOL
__stdcall
DestroyCursor(
     HCURSOR hCursor);

#ifndef _MAC
#define CopyCursor(pcur) ((HCURSOR)CopyIcon((HICON)(pcur)))
#else

HCURSOR
__stdcall
CopyCursor(
     HCURSOR hCursor);
#endif

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/*
 * Standard Cursor IDs
 */
#define IDC_ARROW           MAKEINTRESOURCE(32512)
#define IDC_IBEAM           MAKEINTRESOURCE(32513)
#define IDC_WAIT            MAKEINTRESOURCE(32514)
#define IDC_CROSS           MAKEINTRESOURCE(32515)
#define IDC_UPARROW         MAKEINTRESOURCE(32516)
#define IDC_SIZE            MAKEINTRESOURCE(32640)  /* OBSOLETE: use IDC_SIZEALL */
#define IDC_ICON            MAKEINTRESOURCE(32641)  /* OBSOLETE: use IDC_ARROW */
#define IDC_SIZENWSE        MAKEINTRESOURCE(32642)
#define IDC_SIZENESW        MAKEINTRESOURCE(32643)
#define IDC_SIZEWE          MAKEINTRESOURCE(32644)
#define IDC_SIZENS          MAKEINTRESOURCE(32645)
#define IDC_SIZEALL         MAKEINTRESOURCE(32646)
#define IDC_NO              MAKEINTRESOURCE(32648) /*not in win3.1 */
#if(WINVER >= 0x0500)
#define IDC_HAND            MAKEINTRESOURCE(32649)
#endif /* WINVER >= 0x0500 */
#define IDC_APPSTARTING     MAKEINTRESOURCE(32650) /*not in win3.1 */
#if(WINVER >= 0x0400)
#define IDC_HELP            MAKEINTRESOURCE(32651)
#endif /* WINVER >= 0x0400 */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
SetSystemCursor(
     HCURSOR hcur,
     DWORD id);

typedef struct _ICONINFO {
    BOOL    fIcon;
    DWORD   xHotspot;
    DWORD   yHotspot;
    HBITMAP hbmMask;
    HBITMAP hbmColor;
} ICONINFO;
typedef ICONINFO *PICONINFO;


HICON
__stdcall
LoadIconA(
     HINSTANCE hInstance,
     LPCSTR lpIconName);

HICON
__stdcall
LoadIconW(
     HINSTANCE hInstance,
     LPCWSTR lpIconName);
#ifdef UNICODE
#define LoadIcon  LoadIconW
#else
#define LoadIcon  LoadIconA
#endif // !UNICODE



UINT
__stdcall
PrivateExtractIconsA(
    _In_reads_(MAX_PATH) LPCSTR szFileName,
     int nIconIndex,
     int cxIcon,
     int cyIcon,
    _Out_writes_opt_(nIcons) HICON *phicon,
    _Out_writes_opt_(nIcons) UINT *piconid,
     UINT nIcons,
     UINT flags);

UINT
__stdcall
PrivateExtractIconsW(
    _In_reads_(MAX_PATH) LPCWSTR szFileName,
     int nIconIndex,
     int cxIcon,
     int cyIcon,
    _Out_writes_opt_(nIcons) HICON *phicon,
    _Out_writes_opt_(nIcons) UINT *piconid,
     UINT nIcons,
     UINT flags);
#ifdef UNICODE
#define PrivateExtractIcons  PrivateExtractIconsW
#else
#define PrivateExtractIcons  PrivateExtractIconsA
#endif // !UNICODE


HICON
__stdcall
CreateIcon(
     HINSTANCE hInstance,
     int nWidth,
     int nHeight,
     BYTE cPlanes,
     BYTE cBitsPixel,
     CONST BYTE *lpbANDbits,
     CONST BYTE *lpbXORbits);


BOOL
__stdcall
DestroyIcon(
     HICON hIcon);


int
__stdcall
LookupIconIdFromDirectory(
    _In_reads_bytes_(sizeof(WORD) * 3) PBYTE presbits,
     BOOL fIcon);

#if(WINVER >= 0x0400)

int
__stdcall
LookupIconIdFromDirectoryEx(
    _In_reads_bytes_(sizeof(WORD) * 3) PBYTE presbits,
     BOOL fIcon,
     int cxDesired,
     int cyDesired,
     UINT Flags);
#endif /* WINVER >= 0x0400 */


HICON
__stdcall
CreateIconFromResource(
    _In_reads_bytes_(dwResSize) PBYTE presbits,
     DWORD dwResSize,
     BOOL fIcon,
     DWORD dwVer);

#if(WINVER >= 0x0400)

HICON
__stdcall
CreateIconFromResourceEx(
    _In_reads_bytes_(dwResSize) PBYTE presbits,
     DWORD dwResSize,
     BOOL fIcon,
     DWORD dwVer,
     int cxDesired,
     int cyDesired,
     UINT Flags);

/* Icon/Cursor header */
typedef struct tagCURSORSHAPE
{
    int     xHotSpot;
    int     yHotSpot;
    int     cx;
    int     cy;
    int     cbWidth;
    BYTE    Planes;
    BYTE    BitsPixel;
} CURSORSHAPE, *LPCURSORSHAPE;
#endif /* WINVER >= 0x0400 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#define IMAGE_BITMAP        0
#define IMAGE_ICON          1
#define IMAGE_CURSOR        2
#if(WINVER >= 0x0400)
#define IMAGE_ENHMETAFILE   3

#define LR_DEFAULTCOLOR     0x00000000
#define LR_MONOCHROME       0x00000001
#define LR_COLOR            0x00000002
#define LR_COPYRETURNORG    0x00000004
#define LR_COPYDELETEORG    0x00000008
#define LR_LOADFROMFILE     0x00000010
#define LR_LOADTRANSPARENT  0x00000020
#define LR_DEFAULTSIZE      0x00000040
#define LR_VGACOLOR         0x00000080
#define LR_LOADMAP3DCOLORS  0x00001000
#define LR_CREATEDIBSECTION 0x00002000
#define LR_COPYFROMRESOURCE 0x00004000
#define LR_SHARED           0x00008000

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


HANDLE
__stdcall
LoadImageA(
     HINSTANCE hInst,
     LPCSTR name,
     UINT type,
     int cx,
     int cy,
     UINT fuLoad);

HANDLE
__stdcall
LoadImageW(
     HINSTANCE hInst,
     LPCWSTR name,
     UINT type,
     int cx,
     int cy,
     UINT fuLoad);
#ifdef UNICODE
#define LoadImage  LoadImageW
#else
#define LoadImage  LoadImageA
#endif // !UNICODE


HANDLE
__stdcall
CopyImage(
     HANDLE h,
     UINT type,
     int cx,
     int cy,
     UINT flags);

#define DI_MASK         0x0001
#define DI_IMAGE        0x0002
#define DI_NORMAL       0x0003
#define DI_COMPAT       0x0004
#define DI_DEFAULTSIZE  0x0008
#if(_WIN32_WINNT >= 0x0501)
#define DI_NOMIRROR     0x0010
#endif /* _WIN32_WINNT >= 0x0501 */

 BOOL __stdcall DrawIconEx(
     HDC hdc,
     int xLeft,
     int yTop,
     HICON hIcon,
     int cxWidth,
     int cyWidth,
     UINT istepIfAniCur,
     HBRUSH hbrFlickerFreeDraw,
     UINT diFlags);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* WINVER >= 0x0400 */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


HICON
__stdcall
CreateIconIndirect(
     PICONINFO piconinfo);


HICON
__stdcall
CopyIcon(
     HICON hIcon);


BOOL
__stdcall
GetIconInfo(
     HICON hIcon,
     PICONINFO piconinfo);

#if(_WIN32_WINNT >= 0x0600)
typedef struct _ICONINFOEXA {
    DWORD   cbSize;
    BOOL    fIcon;
    DWORD   xHotspot;
    DWORD   yHotspot;
    HBITMAP hbmMask;
    HBITMAP hbmColor;
    WORD    wResID;
    CHAR    szModName[MAX_PATH];
    CHAR    szResName[MAX_PATH];
} ICONINFOEXA, *PICONINFOEXA;
typedef struct _ICONINFOEXW {
    DWORD   cbSize;
    BOOL    fIcon;
    DWORD   xHotspot;
    DWORD   yHotspot;
    HBITMAP hbmMask;
    HBITMAP hbmColor;
    WORD    wResID;
    WCHAR   szModName[MAX_PATH];
    WCHAR   szResName[MAX_PATH];
} ICONINFOEXW, *PICONINFOEXW;
#ifdef UNICODE
typedef ICONINFOEXW ICONINFOEX;
typedef PICONINFOEXW PICONINFOEX;
#else
typedef ICONINFOEXA ICONINFOEX;
typedef PICONINFOEXA PICONINFOEX;
#endif // UNICODE


BOOL
__stdcall
GetIconInfoExA(
     HICON hicon,
     PICONINFOEXA piconinfo);

BOOL
__stdcall
GetIconInfoExW(
     HICON hicon,
     PICONINFOEXW piconinfo);
#ifdef UNICODE
#define GetIconInfoEx  GetIconInfoExW
#else
#define GetIconInfoEx  GetIconInfoExA
#endif // !UNICODE
#endif /* _WIN32_WINNT >= 0x0600 */

#if(WINVER >= 0x0400)
#define RES_ICON    1
#define RES_CURSOR  2
#endif /* WINVER >= 0x0400 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#ifdef OEMRESOURCE


/*
 * OEM Resource Ordinal Numbers
 */
#define OBM_CLOSE           32754
#define OBM_UPARROW         32753
#define OBM_DNARROW         32752
#define OBM_RGARROW         32751
#define OBM_LFARROW         32750
#define OBM_REDUCE          32749
#define OBM_ZOOM            32748
#define OBM_RESTORE         32747
#define OBM_REDUCED         32746
#define OBM_ZOOMD           32745
#define OBM_RESTORED        32744
#define OBM_UPARROWD        32743
#define OBM_DNARROWD        32742
#define OBM_RGARROWD        32741
#define OBM_LFARROWD        32740
#define OBM_MNARROW         32739
#define OBM_COMBO           32738
#define OBM_UPARROWI        32737
#define OBM_DNARROWI        32736
#define OBM_RGARROWI        32735
#define OBM_LFARROWI        32734

#define OBM_OLD_CLOSE       32767
#define OBM_SIZE            32766
#define OBM_OLD_UPARROW     32765
#define OBM_OLD_DNARROW     32764
#define OBM_OLD_RGARROW     32763
#define OBM_OLD_LFARROW     32762
#define OBM_BTSIZE          32761
#define OBM_CHECK           32760
#define OBM_CHECKBOXES      32759
#define OBM_BTNCORNERS      32758
#define OBM_OLD_REDUCE      32757
#define OBM_OLD_ZOOM        32756
#define OBM_OLD_RESTORE     32755


#define OCR_NORMAL          32512
#define OCR_IBEAM           32513
#define OCR_WAIT            32514
#define OCR_CROSS           32515
#define OCR_UP              32516
#define OCR_SIZE            32640   /* OBSOLETE: use OCR_SIZEALL */
#define OCR_ICON            32641   /* OBSOLETE: use OCR_NORMAL */
#define OCR_SIZENWSE        32642
#define OCR_SIZENESW        32643
#define OCR_SIZEWE          32644
#define OCR_SIZENS          32645
#define OCR_SIZEALL         32646
#define OCR_ICOCUR          32647   /* OBSOLETE: use OIC_WINLOGO */
#define OCR_NO              32648
#if(WINVER >= 0x0500)
#define OCR_HAND            32649
#endif /* WINVER >= 0x0500 */
#if(WINVER >= 0x0400)
#define OCR_APPSTARTING     32650
#endif /* WINVER >= 0x0400 */


#define OIC_SAMPLE          32512
#define OIC_HAND            32513
#define OIC_QUES            32514
#define OIC_BANG            32515
#define OIC_NOTE            32516
#if(WINVER >= 0x0400)
#define OIC_WINLOGO         32517
#define OIC_WARNING         OIC_BANG
#define OIC_ERROR           OIC_HAND
#define OIC_INFORMATION     OIC_NOTE
#endif /* WINVER >= 0x0400 */
#if(WINVER >= 0x0600)
#define OIC_SHIELD          32518
#endif /* WINVER >= 0x0600 */



#endif /* OEMRESOURCE */

#define ORD_LANGDRIVER    1     /* The ordinal number for the entry point of
                                ** language drivers.
                                */

#ifndef NOICONS

/*
 * Standard Icon IDs
 */
#ifdef RC_INVOKED
#define IDI_APPLICATION     32512
#define IDI_HAND            32513
#define IDI_QUESTION        32514
#define IDI_EXCLAMATION     32515
#define IDI_ASTERISK        32516
#if(WINVER >= 0x0400)
#define IDI_WINLOGO         32517
#endif /* WINVER >= 0x0400 */
#if(WINVER >= 0x0600)
#define IDI_SHIELD          32518
#endif /* WINVER >= 0x0600 */
#else
#define IDI_APPLICATION     MAKEINTRESOURCE(32512)
#define IDI_HAND            MAKEINTRESOURCE(32513)
#define IDI_QUESTION        MAKEINTRESOURCE(32514)
#define IDI_EXCLAMATION     MAKEINTRESOURCE(32515)
#define IDI_ASTERISK        MAKEINTRESOURCE(32516)
#if(WINVER >= 0x0400)
#define IDI_WINLOGO         MAKEINTRESOURCE(32517)
#endif /* WINVER >= 0x0400 */
#if(WINVER >= 0x0600)
#define IDI_SHIELD          MAKEINTRESOURCE(32518)
#endif /* WINVER >= 0x0600 */
#endif /* RC_INVOKED */

#if(WINVER >= 0x0400)
#define IDI_WARNING     IDI_EXCLAMATION
#define IDI_ERROR       IDI_HAND
#define IDI_INFORMATION IDI_ASTERISK
#endif /* WINVER >= 0x0400 */


#endif /* !NOICONS */


#ifdef NOAPISET

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


int
__stdcall
LoadStringA(
     HINSTANCE hInstance,
     UINT uID,
    _Out_writes_to_(cchBufferMax, return + 1) LPSTR lpBuffer,
     int cchBufferMax);

int
__stdcall
LoadStringW(
     HINSTANCE hInstance,
     UINT uID,
    _Out_writes_to_(cchBufferMax, return + 1) LPWSTR lpBuffer,
     int cchBufferMax);
#ifdef UNICODE
#define LoadString  LoadStringW
#else
#define LoadString  LoadStringA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif


/*
 * Dialog Box Command IDs
 */
#define IDOK                1
#define IDCANCEL            2
#define IDABORT             3
#define IDRETRY             4
#define IDIGNORE            5
#define IDYES               6
#define IDNO                7
#if(WINVER >= 0x0400)
#define IDCLOSE         8
#define IDHELP          9
#endif /* WINVER >= 0x0400 */

#if(WINVER >= 0x0500)
#define IDTRYAGAIN      10
#define IDCONTINUE      11
#endif /* WINVER >= 0x0500 */

#if(WINVER >= 0x0501)
#ifndef IDTIMEOUT
#define IDTIMEOUT 32000
#endif
#endif /* WINVER >= 0x0501 */


#ifndef NOCTLMGR

/*
 * Control Manager Structures and Definitions
 */

#ifndef NOWINSTYLES


/*
 * Edit Control Styles
 */
#define ES_LEFT             0x0000L
#define ES_CENTER           0x0001L
#define ES_RIGHT            0x0002L
#define ES_MULTILINE        0x0004L
#define ES_UPPERCASE        0x0008L
#define ES_LOWERCASE        0x0010L
#define ES_PASSWORD         0x0020L
#define ES_AUTOVSCROLL      0x0040L
#define ES_AUTOHSCROLL      0x0080L
#define ES_NOHIDESEL        0x0100L
#define ES_OEMCONVERT       0x0400L
#define ES_READONLY         0x0800L
#define ES_WANTRETURN       0x1000L
#if(WINVER >= 0x0400)
#define ES_NUMBER           0x2000L
#endif /* WINVER >= 0x0400 */


#endif /* !NOWINSTYLES */

/*
 * Edit Control Notification Codes
 */
#define EN_SETFOCUS         0x0100
#define EN_KILLFOCUS        0x0200
#define EN_CHANGE           0x0300
#define EN_UPDATE           0x0400
#define EN_ERRSPACE         0x0500
#define EN_MAXTEXT          0x0501
#define EN_HSCROLL          0x0601
#define EN_VSCROLL          0x0602

#if(_WIN32_WINNT >= 0x0500)
#define EN_ALIGN_LTR_EC     0x0700
#define EN_ALIGN_RTL_EC     0x0701
#endif /* _WIN32_WINNT >= 0x0500 */

#if(WINVER >= 0x0604)
#define EN_BEFORE_PASTE     0x0800
#define EN_AFTER_PASTE      0x0801
#endif /* WINVER >= 0x0604 */

#if(WINVER >= 0x0400)
/* Edit control EM_SETMARGIN parameters */
#define EC_LEFTMARGIN       0x0001
#define EC_RIGHTMARGIN      0x0002
#define EC_USEFONTINFO      0xffff
#endif /* WINVER >= 0x0400 */

#if(WINVER >= 0x0500)
/* wParam of EM_GET/SETIMESTATUS  */
#define EMSIS_COMPOSITIONSTRING        0x0001

/* lParam for EMSIS_COMPOSITIONSTRING  */
#define EIMES_GETCOMPSTRATONCE         0x0001
#define EIMES_CANCELCOMPSTRINFOCUS     0x0002
#define EIMES_COMPLETECOMPSTRKILLFOCUS 0x0004
#endif /* WINVER >= 0x0500 */

#ifndef NOWINMESSAGES


/*
 * Edit Control Messages
 */
#define EM_GETSEL               0x00B0
#define EM_SETSEL               0x00B1
#define EM_GETRECT              0x00B2
#define EM_SETRECT              0x00B3
#define EM_SETRECTNP            0x00B4
#define EM_SCROLL               0x00B5
#define EM_LINESCROLL           0x00B6
#define EM_SCROLLCARET          0x00B7
#define EM_GETMODIFY            0x00B8
#define EM_SETMODIFY            0x00B9
#define EM_GETLINECOUNT         0x00BA
#define EM_LINEINDEX            0x00BB
#define EM_SETHANDLE            0x00BC
#define EM_GETHANDLE            0x00BD
#define EM_GETTHUMB             0x00BE
#define EM_LINELENGTH           0x00C1
#define EM_REPLACESEL           0x00C2
#define EM_GETLINE              0x00C4
#define EM_LIMITTEXT            0x00C5
#define EM_CANUNDO              0x00C6
#define EM_UNDO                 0x00C7
#define EM_FMTLINES             0x00C8
#define EM_LINEFROMCHAR         0x00C9
#define EM_SETTABSTOPS          0x00CB
#define EM_SETPASSWORDCHAR      0x00CC
#define EM_EMPTYUNDOBUFFER      0x00CD
#define EM_GETFIRSTVISIBLELINE  0x00CE
#define EM_SETREADONLY          0x00CF
#define EM_SETWORDBREAKPROC     0x00D0
#define EM_GETWORDBREAKPROC     0x00D1
#define EM_GETPASSWORDCHAR      0x00D2
#if(WINVER >= 0x0400)
#define EM_SETMARGINS           0x00D3
#define EM_GETMARGINS           0x00D4
#define EM_SETLIMITTEXT         EM_LIMITTEXT   /* ;win40 Name change */
#define EM_GETLIMITTEXT         0x00D5
#define EM_POSFROMCHAR          0x00D6
#define EM_CHARFROMPOS          0x00D7
#endif /* WINVER >= 0x0400 */

#if(WINVER >= 0x0500)
#define EM_SETIMESTATUS         0x00D8
#define EM_GETIMESTATUS         0x00D9
#endif /* WINVER >= 0x0500 */

#if(WINVER >= 0x0604)
#define EM_ENABLEFEATURE        0x00DA
#endif /* WINVER >= 0x0604 */


#endif /* !NOWINMESSAGES */

#if(WINVER >= 0x0604)
/*
 * EM_ENABLEFEATURE options
 */
typedef enum {
    EDIT_CONTROL_FEATURE_ENTERPRISE_DATA_PROTECTION_PASTE_SUPPORT  = 0,
    EDIT_CONTROL_FEATURE_PASTE_NOTIFICATIONS                       = 1,
} EDIT_CONTROL_FEATURE;
#endif /* WINVER >= 0x0604 */

/*
 * EDITWORDBREAKPROC code values
 */
#define WB_LEFT            0
#define WB_RIGHT           1
#define WB_ISDELIMITER     2


/*
 * Button Control Styles
 */
#define BS_PUSHBUTTON       0x00000000L
#define BS_DEFPUSHBUTTON    0x00000001L
#define BS_CHECKBOX         0x00000002L
#define BS_AUTOCHECKBOX     0x00000003L
#define BS_RADIOBUTTON      0x00000004L
#define BS_3STATE           0x00000005L
#define BS_AUTO3STATE       0x00000006L
#define BS_GROUPBOX         0x00000007L
#define BS_USERBUTTON       0x00000008L
#define BS_AUTORADIOBUTTON  0x00000009L
#define BS_PUSHBOX          0x0000000AL
#define BS_OWNERDRAW        0x0000000BL
#define BS_TYPEMASK         0x0000000FL
#define BS_LEFTTEXT         0x00000020L
#if(WINVER >= 0x0400)
#define BS_TEXT             0x00000000L
#define BS_ICON             0x00000040L
#define BS_BITMAP           0x00000080L
#define BS_LEFT             0x00000100L
#define BS_RIGHT            0x00000200L
#define BS_CENTER           0x00000300L
#define BS_TOP              0x00000400L
#define BS_BOTTOM           0x00000800L
#define BS_VCENTER          0x00000C00L
#define BS_PUSHLIKE         0x00001000L
#define BS_MULTILINE        0x00002000L
#define BS_NOTIFY           0x00004000L
#define BS_FLAT             0x00008000L
#define BS_RIGHTBUTTON      BS_LEFTTEXT
#endif /* WINVER >= 0x0400 */

/*
 * User Button Notification Codes
 */
#define BN_CLICKED          0
#define BN_PAINT            1
#define BN_HILITE           2
#define BN_UNHILITE         3
#define BN_DISABLE          4
#define BN_DOUBLECLICKED    5
#if(WINVER >= 0x0400)
#define BN_PUSHED           BN_HILITE
#define BN_UNPUSHED         BN_UNHILITE
#define BN_DBLCLK           BN_DOUBLECLICKED
#define BN_SETFOCUS         6
#define BN_KILLFOCUS        7
#endif /* WINVER >= 0x0400 */

/*
 * Button Control Messages
 */
#define BM_GETCHECK        0x00F0
#define BM_SETCHECK        0x00F1
#define BM_GETSTATE        0x00F2
#define BM_SETSTATE        0x00F3
#define BM_SETSTYLE        0x00F4
#if(WINVER >= 0x0400)
#define BM_CLICK           0x00F5
#define BM_GETIMAGE        0x00F6
#define BM_SETIMAGE        0x00F7
#endif /* WINVER >= 0x0400 */
#if(WINVER >= 0x0600)
#define BM_SETDONTCLICK    0x00F8
#endif /* WINVER >= 0x0600 */

#if(WINVER >= 0x0400)
#define BST_UNCHECKED      0x0000
#define BST_CHECKED        0x0001
#define BST_INDETERMINATE  0x0002
#define BST_PUSHED         0x0004
#define BST_FOCUS          0x0008
#endif /* WINVER >= 0x0400 */

/*
 * Static Control Constants
 */
#define SS_LEFT             0x00000000L
#define SS_CENTER           0x00000001L
#define SS_RIGHT            0x00000002L
#define SS_ICON             0x00000003L
#define SS_BLACKRECT        0x00000004L
#define SS_GRAYRECT         0x00000005L
#define SS_WHITERECT        0x00000006L
#define SS_BLACKFRAME       0x00000007L
#define SS_GRAYFRAME        0x00000008L
#define SS_WHITEFRAME       0x00000009L
#define SS_USERITEM         0x0000000AL
#define SS_SIMPLE           0x0000000BL
#define SS_LEFTNOWORDWRAP   0x0000000CL
#if(WINVER >= 0x0400)
#define SS_OWNERDRAW        0x0000000DL
#define SS_BITMAP           0x0000000EL
#define SS_ENHMETAFILE      0x0000000FL
#define SS_ETCHEDHORZ       0x00000010L
#define SS_ETCHEDVERT       0x00000011L
#define SS_ETCHEDFRAME      0x00000012L
#define SS_TYPEMASK         0x0000001FL
#endif /* WINVER >= 0x0400 */
#if(WINVER >= 0x0501)
#define SS_REALSIZECONTROL  0x00000040L
#endif /* WINVER >= 0x0501 */
#define SS_NOPREFIX         0x00000080L /* Don't do "&" character translation */
#if(WINVER >= 0x0400)
#define SS_NOTIFY           0x00000100L
#define SS_CENTERIMAGE      0x00000200L
#define SS_RIGHTJUST        0x00000400L
#define SS_REALSIZEIMAGE    0x00000800L
#define SS_SUNKEN           0x00001000L
#define SS_EDITCONTROL      0x00002000L
#define SS_ENDELLIPSIS      0x00004000L
#define SS_PATHELLIPSIS     0x00008000L
#define SS_WORDELLIPSIS     0x0000C000L
#define SS_ELLIPSISMASK     0x0000C000L
#endif /* WINVER >= 0x0400 */



#ifndef NOWINMESSAGES
/*
 * Static Control Mesages
 */
#define STM_SETICON         0x0170
#define STM_GETICON         0x0171
#if(WINVER >= 0x0400)
#define STM_SETIMAGE        0x0172
#define STM_GETIMAGE        0x0173
#define STN_CLICKED         0
#define STN_DBLCLK          1
#define STN_ENABLE          2
#define STN_DISABLE         3
#endif /* WINVER >= 0x0400 */
#define STM_MSGMAX          0x0174
#endif /* !NOWINMESSAGES */

/*
 * Dialog window class
 */
#define WC_DIALOG       (MAKEINTATOM(0x8002))

/*
 * Get/SetWindowWord/Long offsets for use with WC_DIALOG windows
 */
#define DWL_MSGRESULT   0
#define DWL_DLGPROC     4
#define DWL_USER        8

#ifdef _WIN64

#undef DWL_MSGRESULT
#undef DWL_DLGPROC
#undef DWL_USER

#endif /* _WIN64 */

#define DWLP_MSGRESULT  0
#define DWLP_DLGPROC    DWLP_MSGRESULT + sizeof(LRESULT)
#define DWLP_USER       DWLP_DLGPROC + sizeof(DLGPROC)

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

/*
 * Dialog Manager Routines
 */

#ifndef NOMSG


BOOL
__stdcall
IsDialogMessageA(
     HWND hDlg,
     LPMSG lpMsg);

BOOL
__stdcall
IsDialogMessageW(
     HWND hDlg,
     LPMSG lpMsg);
#ifdef UNICODE
#define IsDialogMessage  IsDialogMessageW
#else
#define IsDialogMessage  IsDialogMessageA
#endif // !UNICODE

#endif /* !NOMSG */


BOOL
__stdcall
MapDialogRect(
     HWND hDlg,
     LPRECT lpRect);


int
__stdcall
DlgDirListA(
     HWND hDlg,
     LPSTR lpPathSpec,
     int nIDListBox,
     int nIDStaticPath,
     UINT uFileType);

int
__stdcall
DlgDirListW(
     HWND hDlg,
     LPWSTR lpPathSpec,
     int nIDListBox,
     int nIDStaticPath,
     UINT uFileType);
#ifdef UNICODE
#define DlgDirList  DlgDirListW
#else
#define DlgDirList  DlgDirListA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/*
 * DlgDirList, DlgDirListComboBox flags values
 */
#define DDL_READWRITE       0x0000
#define DDL_READONLY        0x0001
#define DDL_HIDDEN          0x0002
#define DDL_SYSTEM          0x0004
#define DDL_DIRECTORY       0x0010
#define DDL_ARCHIVE         0x0020

#define DDL_POSTMSGS        0x2000
#define DDL_DRIVES          0x4000
#define DDL_EXCLUSIVE       0x8000

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
DlgDirSelectExA(
     HWND hwndDlg,
    _Out_writes_(chCount) LPSTR lpString,
     int chCount,
     int idListBox);

BOOL
__stdcall
DlgDirSelectExW(
     HWND hwndDlg,
    _Out_writes_(chCount) LPWSTR lpString,
     int chCount,
     int idListBox);
#ifdef UNICODE
#define DlgDirSelectEx  DlgDirSelectExW
#else
#define DlgDirSelectEx  DlgDirSelectExA
#endif // !UNICODE


int
__stdcall
DlgDirListComboBoxA(
     HWND hDlg,
     LPSTR lpPathSpec,
     int nIDComboBox,
     int nIDStaticPath,
     UINT uFiletype);

int
__stdcall
DlgDirListComboBoxW(
     HWND hDlg,
     LPWSTR lpPathSpec,
     int nIDComboBox,
     int nIDStaticPath,
     UINT uFiletype);
#ifdef UNICODE
#define DlgDirListComboBox  DlgDirListComboBoxW
#else
#define DlgDirListComboBox  DlgDirListComboBoxA
#endif // !UNICODE


BOOL
__stdcall
DlgDirSelectComboBoxExA(
     HWND hwndDlg,
    _Out_writes_(cchOut) LPSTR lpString,
     int cchOut,
     int idComboBox);

BOOL
__stdcall
DlgDirSelectComboBoxExW(
     HWND hwndDlg,
    _Out_writes_(cchOut) LPWSTR lpString,
     int cchOut,
     int idComboBox);
#ifdef UNICODE
#define DlgDirSelectComboBoxEx  DlgDirSelectComboBoxExW
#else
#define DlgDirSelectComboBoxEx  DlgDirSelectComboBoxExA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion



/*
 * Dialog Styles
 */
#define DS_ABSALIGN         0x01L
#define DS_SYSMODAL         0x02L
#define DS_LOCALEDIT        0x20L   /* Edit items get Local storage. */
#define DS_SETFONT          0x40L   /* User specified font for Dlg controls */
#define DS_MODALFRAME       0x80L   /* Can be combined with WS_CAPTION  */
#define DS_NOIDLEMSG        0x100L  /* WM_ENTERIDLE message will not be sent */
#define DS_SETFOREGROUND    0x200L  /* not in win3.1 */


#if(WINVER >= 0x0400)
#define DS_3DLOOK           0x0004L
#define DS_FIXEDSYS         0x0008L
#define DS_NOFAILCREATE     0x0010L
#define DS_CONTROL          0x0400L
#define DS_CENTER           0x0800L
#define DS_CENTERMOUSE      0x1000L
#define DS_CONTEXTHELP      0x2000L

#define DS_SHELLFONT        (DS_SETFONT | DS_FIXEDSYS)
#endif /* WINVER >= 0x0400 */

#if defined(_WIN32_WCE) && (_WIN32_WCE >= 0x0500)
#define DS_USEPIXELS        0x8000L
#endif


#define DM_GETDEFID         (WM_USER+0)
#define DM_SETDEFID         (WM_USER+1)

#if(WINVER >= 0x0400)
#define DM_REPOSITION       (WM_USER+2)
#endif /* WINVER >= 0x0400 */
/*
 * Returned in HIWORD() of DM_GETDEFID result if msg is supported
 */
#define DC_HASDEFID         0x534B

/*
 * Dialog Codes
 */
#define DLGC_WANTARROWS     0x0001      /* Control wants arrow keys         */
#define DLGC_WANTTAB        0x0002      /* Control wants tab keys           */
#define DLGC_WANTALLKEYS    0x0004      /* Control wants all keys           */
#define DLGC_WANTMESSAGE    0x0004      /* Pass message to control          */
#define DLGC_HASSETSEL      0x0008      /* Understands EM_SETSEL message    */
#define DLGC_DEFPUSHBUTTON  0x0010      /* Default pushbutton               */
#define DLGC_UNDEFPUSHBUTTON 0x0020     /* Non-default pushbutton           */
#define DLGC_RADIOBUTTON    0x0040      /* Radio button                     */
#define DLGC_WANTCHARS      0x0080      /* Want WM_CHAR messages            */
#define DLGC_STATIC         0x0100      /* Static item: don't include       */
#define DLGC_BUTTON         0x2000      /* Button item: can be checked      */

#define LB_CTLCODE          0L

/*
 * Listbox Return Values
 */
#define LB_OKAY             0
#define LB_ERR              (-1)
#define LB_ERRSPACE         (-2)

/*
**  The idStaticPath parameter to DlgDirList can have the following values
**  ORed if the list box should show other details of the files along with
**  the name of the files;
*/
                                  /* all other details also will be returned */


/*
 * Listbox Notification Codes
 */
#define LBN_ERRSPACE        (-2)
#define LBN_SELCHANGE       1
#define LBN_DBLCLK          2
#define LBN_SELCANCEL       3
#define LBN_SETFOCUS        4
#define LBN_KILLFOCUS       5



#ifndef NOWINMESSAGES

/*
 * Listbox messages
 */
#define LB_ADDSTRING            0x0180
#define LB_INSERTSTRING         0x0181
#define LB_DELETESTRING         0x0182
#define LB_SELITEMRANGEEX       0x0183
#define LB_RESETCONTENT         0x0184
#define LB_SETSEL               0x0185
#define LB_SETCURSEL            0x0186
#define LB_GETSEL               0x0187
#define LB_GETCURSEL            0x0188
#define LB_GETTEXT              0x0189
#define LB_GETTEXTLEN           0x018A
#define LB_GETCOUNT             0x018B
#define LB_SELECTSTRING         0x018C
#define LB_DIR                  0x018D
#define LB_GETTOPINDEX          0x018E
#define LB_FINDSTRING           0x018F
#define LB_GETSELCOUNT          0x0190
#define LB_GETSELITEMS          0x0191
#define LB_SETTABSTOPS          0x0192
#define LB_GETHORIZONTALEXTENT  0x0193
#define LB_SETHORIZONTALEXTENT  0x0194
#define LB_SETCOLUMNWIDTH       0x0195
#define LB_ADDFILE              0x0196
#define LB_SETTOPINDEX          0x0197
#define LB_GETITEMRECT          0x0198
#define LB_GETITEMDATA          0x0199
#define LB_SETITEMDATA          0x019A
#define LB_SELITEMRANGE         0x019B
#define LB_SETANCHORINDEX       0x019C
#define LB_GETANCHORINDEX       0x019D
#define LB_SETCARETINDEX        0x019E
#define LB_GETCARETINDEX        0x019F
#define LB_SETITEMHEIGHT        0x01A0
#define LB_GETITEMHEIGHT        0x01A1
#define LB_FINDSTRINGEXACT      0x01A2
#define LB_SETLOCALE            0x01A5
#define LB_GETLOCALE            0x01A6
#define LB_SETCOUNT             0x01A7
#if(WINVER >= 0x0400)
#define LB_INITSTORAGE          0x01A8
#define LB_ITEMFROMPOINT        0x01A9
#endif /* WINVER >= 0x0400 */
#if defined(_WIN32_WCE) && (_WIN32_WCE >= 0x0400)
#define LB_MULTIPLEADDSTRING    0x01B1
#endif


#if(_WIN32_WINNT >= 0x0501)
#define LB_GETLISTBOXINFO       0x01B2
#endif /* _WIN32_WINNT >= 0x0501 */

#if(_WIN32_WINNT >= 0x0501)
#define LB_MSGMAX               0x01B3
#elif defined(_WIN32_WCE) && (_WIN32_WCE >= 0x0400)
#define LB_MSGMAX               0x01B1
#elif(WINVER >= 0x0400)
#define LB_MSGMAX               0x01B0
#else
#define LB_MSGMAX               0x01A8
#endif

#endif /* !NOWINMESSAGES */

#ifndef NOWINSTYLES


/*
 * Listbox Styles
 */
#define LBS_NOTIFY            0x0001L
#define LBS_SORT              0x0002L
#define LBS_NOREDRAW          0x0004L
#define LBS_MULTIPLESEL       0x0008L
#define LBS_OWNERDRAWFIXED    0x0010L
#define LBS_OWNERDRAWVARIABLE 0x0020L
#define LBS_HASSTRINGS        0x0040L
#define LBS_USETABSTOPS       0x0080L
#define LBS_NOINTEGRALHEIGHT  0x0100L
#define LBS_MULTICOLUMN       0x0200L
#define LBS_WANTKEYBOARDINPUT 0x0400L
#define LBS_EXTENDEDSEL       0x0800L
#define LBS_DISABLENOSCROLL   0x1000L
#define LBS_NODATA            0x2000L
#if(WINVER >= 0x0400)
#define LBS_NOSEL             0x4000L
#endif /* WINVER >= 0x0400 */
#define LBS_COMBOBOX          0x8000L

#define LBS_STANDARD          (LBS_NOTIFY | LBS_SORT | WS_VSCROLL | WS_BORDER)


#endif /* !NOWINSTYLES */


/*
 * Combo Box return Values
 */
#define CB_OKAY             0
#define CB_ERR              (-1)
#define CB_ERRSPACE         (-2)


/*
 * Combo Box Notification Codes
 */
#define CBN_ERRSPACE        (-1)
#define CBN_SELCHANGE       1
#define CBN_DBLCLK          2
#define CBN_SETFOCUS        3
#define CBN_KILLFOCUS       4
#define CBN_EDITCHANGE      5
#define CBN_EDITUPDATE      6
#define CBN_DROPDOWN        7
#define CBN_CLOSEUP         8
#define CBN_SELENDOK        9
#define CBN_SELENDCANCEL    10

#ifndef NOWINSTYLES

/*
 * Combo Box styles
 */
#define CBS_SIMPLE            0x0001L
#define CBS_DROPDOWN          0x0002L
#define CBS_DROPDOWNLIST      0x0003L
#define CBS_OWNERDRAWFIXED    0x0010L
#define CBS_OWNERDRAWVARIABLE 0x0020L
#define CBS_AUTOHSCROLL       0x0040L
#define CBS_OEMCONVERT        0x0080L
#define CBS_SORT              0x0100L
#define CBS_HASSTRINGS        0x0200L
#define CBS_NOINTEGRALHEIGHT  0x0400L
#define CBS_DISABLENOSCROLL   0x0800L
#if(WINVER >= 0x0400)
#define CBS_UPPERCASE         0x2000L
#define CBS_LOWERCASE         0x4000L
#endif /* WINVER >= 0x0400 */

#endif  /* !NOWINSTYLES */


/*
 * Combo Box messages
 */
#ifndef NOWINMESSAGES
#define CB_GETEDITSEL               0x0140
#define CB_LIMITTEXT                0x0141
#define CB_SETEDITSEL               0x0142
#define CB_ADDSTRING                0x0143
#define CB_DELETESTRING             0x0144
#define CB_DIR                      0x0145
#define CB_GETCOUNT                 0x0146
#define CB_GETCURSEL                0x0147
#define CB_GETLBTEXT                0x0148
#define CB_GETLBTEXTLEN             0x0149
#define CB_INSERTSTRING             0x014A
#define CB_RESETCONTENT             0x014B
#define CB_FINDSTRING               0x014C
#define CB_SELECTSTRING             0x014D
#define CB_SETCURSEL                0x014E
#define CB_SHOWDROPDOWN             0x014F
#define CB_GETITEMDATA              0x0150
#define CB_SETITEMDATA              0x0151
#define CB_GETDROPPEDCONTROLRECT    0x0152
#define CB_SETITEMHEIGHT            0x0153
#define CB_GETITEMHEIGHT            0x0154
#define CB_SETEXTENDEDUI            0x0155
#define CB_GETEXTENDEDUI            0x0156
#define CB_GETDROPPEDSTATE          0x0157
#define CB_FINDSTRINGEXACT          0x0158
#define CB_SETLOCALE                0x0159
#define CB_GETLOCALE                0x015A
#if(WINVER >= 0x0400)
#define CB_GETTOPINDEX              0x015b
#define CB_SETTOPINDEX              0x015c
#define CB_GETHORIZONTALEXTENT      0x015d
#define CB_SETHORIZONTALEXTENT      0x015e
#define CB_GETDROPPEDWIDTH          0x015f
#define CB_SETDROPPEDWIDTH          0x0160
#define CB_INITSTORAGE              0x0161
#if defined(_WIN32_WCE) &&(_WIN32_WCE >= 0x0400)
#define CB_MULTIPLEADDSTRING        0x0163
#endif
#endif /* WINVER >= 0x0400 */

#if(_WIN32_WINNT >= 0x0501)
#define CB_GETCOMBOBOXINFO          0x0164
#endif /* _WIN32_WINNT >= 0x0501 */

#if(_WIN32_WINNT >= 0x0501)
#define CB_MSGMAX                   0x0165
#elif defined(_WIN32_WCE) && (_WIN32_WCE >= 0x0400)
#define CB_MSGMAX                   0x0163
#elif(WINVER >= 0x0400)
#define CB_MSGMAX                   0x0162
#else
#define CB_MSGMAX                   0x015B
#endif
#endif  /* !NOWINMESSAGES */



#ifndef NOWINSTYLES


/*
 * Scroll Bar Styles
 */
#define SBS_HORZ                    0x0000L
#define SBS_VERT                    0x0001L
#define SBS_TOPALIGN                0x0002L
#define SBS_LEFTALIGN               0x0002L
#define SBS_BOTTOMALIGN             0x0004L
#define SBS_RIGHTALIGN              0x0004L
#define SBS_SIZEBOXTOPLEFTALIGN     0x0002L
#define SBS_SIZEBOXBOTTOMRIGHTALIGN 0x0004L
#define SBS_SIZEBOX                 0x0008L
#if(WINVER >= 0x0400)
#define SBS_SIZEGRIP                0x0010L
#endif /* WINVER >= 0x0400 */


#endif /* !NOWINSTYLES */

/*
 * Scroll bar messages
 */
#ifndef NOWINMESSAGES
#define SBM_SETPOS                  0x00E0 /*not in win3.1 */
#define SBM_GETPOS                  0x00E1 /*not in win3.1 */
#define SBM_SETRANGE                0x00E2 /*not in win3.1 */
#define SBM_SETRANGEREDRAW          0x00E6 /*not in win3.1 */
#define SBM_GETRANGE                0x00E3 /*not in win3.1 */
#define SBM_ENABLE_ARROWS           0x00E4 /*not in win3.1 */
#if(WINVER >= 0x0400)
#define SBM_SETSCROLLINFO           0x00E9
#define SBM_GETSCROLLINFO           0x00EA
#endif /* WINVER >= 0x0400 */

#if(_WIN32_WINNT >= 0x0501)
#define SBM_GETSCROLLBARINFO        0x00EB
#endif /* _WIN32_WINNT >= 0x0501 */

#if(WINVER >= 0x0400)
#define SIF_RANGE           0x0001
#define SIF_PAGE            0x0002
#define SIF_POS             0x0004
#define SIF_DISABLENOSCROLL 0x0008
#define SIF_TRACKPOS        0x0010
#define SIF_ALL             (SIF_RANGE | SIF_PAGE | SIF_POS | SIF_TRACKPOS)

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

typedef struct tagSCROLLINFO
{
    UINT    cbSize;
    UINT    fMask;
    int     nMin;
    int     nMax;
    UINT    nPage;
    int     nPos;
    int     nTrackPos;
}   SCROLLINFO, *LPSCROLLINFO;
typedef SCROLLINFO CONST *LPCSCROLLINFO;


int
__stdcall
SetScrollInfo(
     HWND hwnd,
     int nBar,
     LPCSCROLLINFO lpsi,
     BOOL redraw);


BOOL
__stdcall
GetScrollInfo(
     HWND hwnd,
     int nBar,
     LPSCROLLINFO lpsi);


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion
#endif /* WINVER >= 0x0400 */

#endif /* !NOWINMESSAGES */
#endif /* !NOCTLMGR */

#ifndef NOMDI

/*
 * MDI client style bits
 */
#define MDIS_ALLCHILDSTYLES    0x0001

/*
 * wParam Flags for WM_MDITILE and WM_MDICASCADE messages.
 */
#define MDITILE_VERTICAL       0x0000 /*not in win3.1 */
#define MDITILE_HORIZONTAL     0x0001 /*not in win3.1 */
#define MDITILE_SKIPDISABLED   0x0002 /*not in win3.1 */
#if(_WIN32_WINNT >= 0x0500)
#define MDITILE_ZORDER         0x0004
#endif /* _WIN32_WINNT >= 0x0500 */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

typedef struct tagMDICREATESTRUCTA {
    LPCSTR   szClass;
    LPCSTR   szTitle;
    HANDLE hOwner;
    int x;
    int y;
    int cx;
    int cy;
    DWORD style;
    LPARAM lParam;        /* app-defined stuff */
} MDICREATESTRUCTA, *LPMDICREATESTRUCTA;
typedef struct tagMDICREATESTRUCTW {
    LPCWSTR  szClass;
    LPCWSTR  szTitle;
    HANDLE hOwner;
    int x;
    int y;
    int cx;
    int cy;
    DWORD style;
    LPARAM lParam;        /* app-defined stuff */
} MDICREATESTRUCTW, *LPMDICREATESTRUCTW;
#ifdef UNICODE
typedef MDICREATESTRUCTW MDICREATESTRUCT;
typedef LPMDICREATESTRUCTW LPMDICREATESTRUCT;
#else
typedef MDICREATESTRUCTA MDICREATESTRUCT;
typedef LPMDICREATESTRUCTA LPMDICREATESTRUCT;
#endif // UNICODE

typedef struct tagCLIENTCREATESTRUCT {
    HANDLE hWindowMenu;
    UINT idFirstChild;
} CLIENTCREATESTRUCT, *LPCLIENTCREATESTRUCT;


LRESULT
__stdcall
DefFrameProcA(
     HWND hWnd,
     HWND hWndMDIClient,
     UINT uMsg,
     WPARAM wParam,
     LPARAM lParam);

LRESULT
__stdcall
DefFrameProcW(
     HWND hWnd,
     HWND hWndMDIClient,
     UINT uMsg,
     WPARAM wParam,
     LPARAM lParam);
#ifdef UNICODE
#define DefFrameProc  DefFrameProcW
#else
#define DefFrameProc  DefFrameProcA
#endif // !UNICODE


#ifndef _MAC
LRESULT
__stdcall
#else
LRESULT
__stdcall
#endif
DefMDIChildProcA(
     HWND hWnd,
     UINT uMsg,
     WPARAM wParam,
     LPARAM lParam);

#ifndef _MAC
LRESULT
__stdcall
#else
LRESULT
__stdcall
#endif
DefMDIChildProcW(
     HWND hWnd,
     UINT uMsg,
     WPARAM wParam,
     LPARAM lParam);
#ifdef UNICODE
#define DefMDIChildProc  DefMDIChildProcW
#else
#define DefMDIChildProc  DefMDIChildProcA
#endif // !UNICODE

#ifndef NOMSG


BOOL
__stdcall
TranslateMDISysAccel(
     HWND hWndClient,
     LPMSG lpMsg);

#endif /* !NOMSG */


UINT
__stdcall
ArrangeIconicWindows(
     HWND hWnd);


HWND
__stdcall
CreateMDIWindowA(
     LPCSTR lpClassName,
     LPCSTR lpWindowName,
     DWORD dwStyle,
     int X,
     int Y,
     int nWidth,
     int nHeight,
     HWND hWndParent,
     HINSTANCE hInstance,
     LPARAM lParam);

HWND
__stdcall
CreateMDIWindowW(
     LPCWSTR lpClassName,
     LPCWSTR lpWindowName,
     DWORD dwStyle,
     int X,
     int Y,
     int nWidth,
     int nHeight,
     HWND hWndParent,
     HINSTANCE hInstance,
     LPARAM lParam);
#ifdef UNICODE
#define CreateMDIWindow  CreateMDIWindowW
#else
#define CreateMDIWindow  CreateMDIWindowA
#endif // !UNICODE

#if(WINVER >= 0x0400)

WORD
__stdcall
TileWindows(
     HWND hwndParent,
     UINT wHow,
     CONST RECT * lpRect,
     UINT cKids,
    _In_reads_opt_(cKids) const HWND * lpKids);


WORD
__stdcall CascadeWindows(
     HWND hwndParent,
     UINT wHow,
     CONST RECT * lpRect,
     UINT cKids,
    _In_reads_opt_(cKids) const HWND * lpKids);

#endif /* WINVER >= 0x0400 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* !NOMDI */

#endif /* !NOUSER */

/****** Help support ********************************************************/

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#ifndef NOHELP

typedef DWORD HELPPOLY;
typedef struct tagMULTIKEYHELPA {
#ifndef _MAC
    DWORD  mkSize;
#else
    WORD   mkSize;
#endif
    CHAR   mkKeylist;
    CHAR   szKeyphrase[1];
} MULTIKEYHELPA, *PMULTIKEYHELPA, *LPMULTIKEYHELPA;
typedef struct tagMULTIKEYHELPW {
#ifndef _MAC
    DWORD  mkSize;
#else
    WORD   mkSize;
#endif
    WCHAR  mkKeylist;
    WCHAR  szKeyphrase[1];
} MULTIKEYHELPW, *PMULTIKEYHELPW, *LPMULTIKEYHELPW;
#ifdef UNICODE
typedef MULTIKEYHELPW MULTIKEYHELP;
typedef PMULTIKEYHELPW PMULTIKEYHELP;
typedef LPMULTIKEYHELPW LPMULTIKEYHELP;
#else
typedef MULTIKEYHELPA MULTIKEYHELP;
typedef PMULTIKEYHELPA PMULTIKEYHELP;
typedef LPMULTIKEYHELPA LPMULTIKEYHELP;
#endif // UNICODE

typedef struct tagHELPWININFOA {
    int  wStructSize;
    int  x;
    int  y;
    int  dx;
    int  dy;
    int  wMax;
    CHAR   rgchMember[2];
} HELPWININFOA, *PHELPWININFOA, *LPHELPWININFOA;
typedef struct tagHELPWININFOW {
    int  wStructSize;
    int  x;
    int  y;
    int  dx;
    int  dy;
    int  wMax;
    WCHAR  rgchMember[2];
} HELPWININFOW, *PHELPWININFOW, *LPHELPWININFOW;
#ifdef UNICODE
typedef HELPWININFOW HELPWININFO;
typedef PHELPWININFOW PHELPWININFO;
typedef LPHELPWININFOW LPHELPWININFO;
#else
typedef HELPWININFOA HELPWININFO;
typedef PHELPWININFOA PHELPWININFO;
typedef LPHELPWININFOA LPHELPWININFO;
#endif // UNICODE


/*
 * Commands to pass to WinHelp()
 */
#define HELP_CONTEXT      0x0001L  /* Display topic in ulTopic */
#define HELP_QUIT         0x0002L  /* Terminate help */
#define HELP_INDEX        0x0003L  /* Display index */
#define HELP_CONTENTS     0x0003L
#define HELP_HELPONHELP   0x0004L  /* Display help on using help */
#define HELP_SETINDEX     0x0005L  /* Set current Index for multi index help */
#define HELP_SETCONTENTS  0x0005L
#define HELP_CONTEXTPOPUP 0x0008L
#define HELP_FORCEFILE    0x0009L
#define HELP_KEY          0x0101L  /* Display topic for keyword in offabData */
#define HELP_COMMAND      0x0102L
#define HELP_PARTIALKEY   0x0105L
#define HELP_MULTIKEY     0x0201L
#define HELP_SETWINPOS    0x0203L
#if(WINVER >= 0x0400)
#define HELP_CONTEXTMENU  0x000a
#define HELP_FINDER       0x000b
#define HELP_WM_HELP      0x000c
#define HELP_SETPOPUP_POS 0x000d

#define HELP_TCARD              0x8000
#define HELP_TCARD_DATA         0x0010
#define HELP_TCARD_OTHER_CALLER 0x0011

// These are in winhelp.h in Win95.
#define IDH_NO_HELP                     28440
#define IDH_MISSING_CONTEXT             28441 // Control doesn't have matching help context
#define IDH_GENERIC_HELP_BUTTON         28442 // Property sheet help button
#define IDH_OK                          28443
#define IDH_CANCEL                      28444
#define IDH_HELP                        28445

#endif /* WINVER >= 0x0400 */




BOOL
__stdcall
WinHelpA(
     HWND hWndMain,
     LPCSTR lpszHelp,
     UINT uCommand,
     ULONG_PTR dwData);

BOOL
__stdcall
WinHelpW(
     HWND hWndMain,
     LPCWSTR lpszHelp,
     UINT uCommand,
     ULONG_PTR dwData);
#ifdef UNICODE
#define WinHelp  WinHelpW
#else
#define WinHelp  WinHelpA
#endif // !UNICODE

#endif /* !NOHELP */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#if(WINVER >= 0x0500)

#define GR_GDIOBJECTS       0       /* Count of GDI objects */
#define GR_USEROBJECTS      1       /* Count of USER objects */
#endif /* WINVER >= 0x0500 */
#if(WINVER >= 0x0601)
#define GR_GDIOBJECTS_PEAK  2       /* Peak count of GDI objects */
#define GR_USEROBJECTS_PEAK 4       /* Peak count of USER objects */
#endif /* WINVER >= 0x0601 */

#if(WINVER >= 0x0601)
#define GR_GLOBAL           ((HANDLE)-2)
#endif /* WINVER >= 0x0601 */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#if(WINVER >= 0x0500)

DWORD
__stdcall
GetGuiResources(
     HANDLE hProcess,
     DWORD uiFlags);
#endif /* WINVER >= 0x0500 */


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion


#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#ifndef NOSYSPARAMSINFO

/*
 * Parameter for SystemParametersInfo.
 */

#define SPI_GETBEEP                 0x0001
#define SPI_SETBEEP                 0x0002
#define SPI_GETMOUSE                0x0003
#define SPI_SETMOUSE                0x0004
#define SPI_GETBORDER               0x0005
#define SPI_SETBORDER               0x0006
#define SPI_GETKEYBOARDSPEED        0x000A
#define SPI_SETKEYBOARDSPEED        0x000B
#define SPI_LANGDRIVER              0x000C
#define SPI_ICONHORIZONTALSPACING   0x000D
#define SPI_GETSCREENSAVETIMEOUT    0x000E
#define SPI_SETSCREENSAVETIMEOUT    0x000F
#define SPI_GETSCREENSAVEACTIVE     0x0010
#define SPI_SETSCREENSAVEACTIVE     0x0011
#define SPI_GETGRIDGRANULARITY      0x0012
#define SPI_SETGRIDGRANULARITY      0x0013
#define SPI_SETDESKWALLPAPER        0x0014
#define SPI_SETDESKPATTERN          0x0015
#define SPI_GETKEYBOARDDELAY        0x0016
#define SPI_SETKEYBOARDDELAY        0x0017
#define SPI_ICONVERTICALSPACING     0x0018
#define SPI_GETICONTITLEWRAP        0x0019
#define SPI_SETICONTITLEWRAP        0x001A
#define SPI_GETMENUDROPALIGNMENT    0x001B
#define SPI_SETMENUDROPALIGNMENT    0x001C
#define SPI_SETDOUBLECLKWIDTH       0x001D
#define SPI_SETDOUBLECLKHEIGHT      0x001E
#define SPI_GETICONTITLELOGFONT     0x001F
#define SPI_SETDOUBLECLICKTIME      0x0020
#define SPI_SETMOUSEBUTTONSWAP      0x0021
#define SPI_SETICONTITLELOGFONT     0x0022
#define SPI_GETFASTTASKSWITCH       0x0023
#define SPI_SETFASTTASKSWITCH       0x0024
#if(WINVER >= 0x0400)
#define SPI_SETDRAGFULLWINDOWS      0x0025
#define SPI_GETDRAGFULLWINDOWS      0x0026
#define SPI_GETNONCLIENTMETRICS     0x0029
#define SPI_SETNONCLIENTMETRICS     0x002A
#define SPI_GETMINIMIZEDMETRICS     0x002B
#define SPI_SETMINIMIZEDMETRICS     0x002C
#define SPI_GETICONMETRICS          0x002D
#define SPI_SETICONMETRICS          0x002E
#define SPI_SETWORKAREA             0x002F
#define SPI_GETWORKAREA             0x0030
#define SPI_SETPENWINDOWS           0x0031

#define SPI_GETHIGHCONTRAST         0x0042
#define SPI_SETHIGHCONTRAST         0x0043
#define SPI_GETKEYBOARDPREF         0x0044
#define SPI_SETKEYBOARDPREF         0x0045
#define SPI_GETSCREENREADER         0x0046
#define SPI_SETSCREENREADER         0x0047
#define SPI_GETANIMATION            0x0048
#define SPI_SETANIMATION            0x0049
#define SPI_GETFONTSMOOTHING        0x004A
#define SPI_SETFONTSMOOTHING        0x004B
#define SPI_SETDRAGWIDTH            0x004C
#define SPI_SETDRAGHEIGHT           0x004D
#define SPI_SETHANDHELD             0x004E
#define SPI_GETLOWPOWERTIMEOUT      0x004F
#define SPI_GETPOWEROFFTIMEOUT      0x0050
#define SPI_SETLOWPOWERTIMEOUT      0x0051
#define SPI_SETPOWEROFFTIMEOUT      0x0052
#define SPI_GETLOWPOWERACTIVE       0x0053
#define SPI_GETPOWEROFFACTIVE       0x0054
#define SPI_SETLOWPOWERACTIVE       0x0055
#define SPI_SETPOWEROFFACTIVE       0x0056
#define SPI_SETCURSORS              0x0057
#define SPI_SETICONS                0x0058
#define SPI_GETDEFAULTINPUTLANG     0x0059
#define SPI_SETDEFAULTINPUTLANG     0x005A
#define SPI_SETLANGTOGGLE           0x005B
#define SPI_GETWINDOWSEXTENSION     0x005C
#define SPI_SETMOUSETRAILS          0x005D
#define SPI_GETMOUSETRAILS          0x005E
#define SPI_SETSCREENSAVERRUNNING   0x0061
#define SPI_SCREENSAVERRUNNING     SPI_SETSCREENSAVERRUNNING
#endif /* WINVER >= 0x0400 */
#define SPI_GETFILTERKEYS          0x0032
#define SPI_SETFILTERKEYS          0x0033
#define SPI_GETTOGGLEKEYS          0x0034
#define SPI_SETTOGGLEKEYS          0x0035
#define SPI_GETMOUSEKEYS           0x0036
#define SPI_SETMOUSEKEYS           0x0037
#define SPI_GETSHOWSOUNDS          0x0038
#define SPI_SETSHOWSOUNDS          0x0039
#define SPI_GETSTICKYKEYS          0x003A
#define SPI_SETSTICKYKEYS          0x003B
#define SPI_GETACCESSTIMEOUT       0x003C
#define SPI_SETACCESSTIMEOUT       0x003D
#if(WINVER >= 0x0400)
#define SPI_GETSERIALKEYS          0x003E
#define SPI_SETSERIALKEYS          0x003F
#endif /* WINVER >= 0x0400 */
#define SPI_GETSOUNDSENTRY         0x0040
#define SPI_SETSOUNDSENTRY         0x0041
#if(_WIN32_WINNT >= 0x0400)
#define SPI_GETSNAPTODEFBUTTON     0x005F
#define SPI_SETSNAPTODEFBUTTON     0x0060
#endif /* _WIN32_WINNT >= 0x0400 */
#if (_WIN32_WINNT >= 0x0400) || (_WIN32_WINDOWS > 0x0400)
#define SPI_GETMOUSEHOVERWIDTH     0x0062
#define SPI_SETMOUSEHOVERWIDTH     0x0063
#define SPI_GETMOUSEHOVERHEIGHT    0x0064
#define SPI_SETMOUSEHOVERHEIGHT    0x0065
#define SPI_GETMOUSEHOVERTIME      0x0066
#define SPI_SETMOUSEHOVERTIME      0x0067
#define SPI_GETWHEELSCROLLLINES    0x0068
#define SPI_SETWHEELSCROLLLINES    0x0069
#define SPI_GETMENUSHOWDELAY       0x006A
#define SPI_SETMENUSHOWDELAY       0x006B

#if (_WIN32_WINNT >= 0x0600)
#define SPI_GETWHEELSCROLLCHARS   0x006C
#define SPI_SETWHEELSCROLLCHARS   0x006D
#endif

#define SPI_GETSHOWIMEUI          0x006E
#define SPI_SETSHOWIMEUI          0x006F
#endif


#if(WINVER >= 0x0500)
#define SPI_GETMOUSESPEED         0x0070
#define SPI_SETMOUSESPEED         0x0071
#define SPI_GETSCREENSAVERRUNNING 0x0072
#define SPI_GETDESKWALLPAPER      0x0073
#endif /* WINVER >= 0x0500 */

#if(WINVER >= 0x0600)
#define SPI_GETAUDIODESCRIPTION   0x0074
#define SPI_SETAUDIODESCRIPTION   0x0075

#define SPI_GETSCREENSAVESECURE   0x0076
#define SPI_SETSCREENSAVESECURE   0x0077
#endif /* WINVER >= 0x0600 */

#if(_WIN32_WINNT >= 0x0601)
#define SPI_GETHUNGAPPTIMEOUT           0x0078
#define SPI_SETHUNGAPPTIMEOUT           0x0079
#define SPI_GETWAITTOKILLTIMEOUT        0x007A
#define SPI_SETWAITTOKILLTIMEOUT        0x007B
#define SPI_GETWAITTOKILLSERVICETIMEOUT 0x007C
#define SPI_SETWAITTOKILLSERVICETIMEOUT 0x007D
#define SPI_GETMOUSEDOCKTHRESHOLD       0x007E
#define SPI_SETMOUSEDOCKTHRESHOLD       0x007F
#define SPI_GETPENDOCKTHRESHOLD         0x0080
#define SPI_SETPENDOCKTHRESHOLD         0x0081
#define SPI_GETWINARRANGING             0x0082
#define SPI_SETWINARRANGING             0x0083
#define SPI_GETMOUSEDRAGOUTTHRESHOLD    0x0084
#define SPI_SETMOUSEDRAGOUTTHRESHOLD    0x0085
#define SPI_GETPENDRAGOUTTHRESHOLD      0x0086
#define SPI_SETPENDRAGOUTTHRESHOLD      0x0087
#define SPI_GETMOUSESIDEMOVETHRESHOLD   0x0088
#define SPI_SETMOUSESIDEMOVETHRESHOLD   0x0089
#define SPI_GETPENSIDEMOVETHRESHOLD     0x008A
#define SPI_SETPENSIDEMOVETHRESHOLD     0x008B
#define SPI_GETDRAGFROMMAXIMIZE         0x008C
#define SPI_SETDRAGFROMMAXIMIZE         0x008D
#define SPI_GETSNAPSIZING               0x008E
#define SPI_SETSNAPSIZING               0x008F
#define SPI_GETDOCKMOVING               0x0090
#define SPI_SETDOCKMOVING               0x0091
#endif /* _WIN32_WINNT >= 0x0601 */

#if(WINVER >= 0x0602)
#define MAX_TOUCH_PREDICTION_FILTER_TAPS 3

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

typedef struct tagTouchPredictionParameters
{
    UINT cbSize;
    UINT dwLatency;       // Latency in millisecs
    UINT dwSampleTime;    // Sample time in millisecs (used to deduce velocity)
    UINT bUseHWTimeStamp; // Use H/W TimeStamps
} TOUCHPREDICTIONPARAMETERS, *PTOUCHPREDICTIONPARAMETERS;

#define TOUCHPREDICTIONPARAMETERS_DEFAULT_LATENCY 8
#define TOUCHPREDICTIONPARAMETERS_DEFAULT_SAMPLETIME 8
#define TOUCHPREDICTIONPARAMETERS_DEFAULT_USE_HW_TIMESTAMP 1
#define TOUCHPREDICTIONPARAMETERS_DEFAULT_RLS_DELTA 0.001f
#define TOUCHPREDICTIONPARAMETERS_DEFAULT_RLS_LAMBDA_MIN 0.9f
#define TOUCHPREDICTIONPARAMETERS_DEFAULT_RLS_LAMBDA_MAX 0.999f
#define TOUCHPREDICTIONPARAMETERS_DEFAULT_RLS_LAMBDA_LEARNING_RATE 0.001f
#define TOUCHPREDICTIONPARAMETERS_DEFAULT_RLS_EXPO_SMOOTH_ALPHA 0.99f

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#define SPI_GETTOUCHPREDICTIONPARAMETERS 0x009C
#define SPI_SETTOUCHPREDICTIONPARAMETERS 0x009D

#define MAX_LOGICALDPIOVERRIDE  2
#define MIN_LOGICALDPIOVERRIDE  -2

#define SPI_GETLOGICALDPIOVERRIDE       0x009E
#define SPI_SETLOGICALDPIOVERRIDE       0x009F


#define SPI_GETMENURECT   0x00A2
#define SPI_SETMENURECT   0x00A3

#endif /* WINVER >= 0x0602 */


#if(WINVER >= 0x0500)
#define SPI_GETACTIVEWINDOWTRACKING         0x1000
#define SPI_SETACTIVEWINDOWTRACKING         0x1001
#define SPI_GETMENUANIMATION                0x1002
#define SPI_SETMENUANIMATION                0x1003
#define SPI_GETCOMBOBOXANIMATION            0x1004
#define SPI_SETCOMBOBOXANIMATION            0x1005
#define SPI_GETLISTBOXSMOOTHSCROLLING       0x1006
#define SPI_SETLISTBOXSMOOTHSCROLLING       0x1007
#define SPI_GETGRADIENTCAPTIONS             0x1008
#define SPI_SETGRADIENTCAPTIONS             0x1009
#define SPI_GETKEYBOARDCUES                 0x100A
#define SPI_SETKEYBOARDCUES                 0x100B
#define SPI_GETMENUUNDERLINES               SPI_GETKEYBOARDCUES
#define SPI_SETMENUUNDERLINES               SPI_SETKEYBOARDCUES
#define SPI_GETACTIVEWNDTRKZORDER           0x100C
#define SPI_SETACTIVEWNDTRKZORDER           0x100D
#define SPI_GETHOTTRACKING                  0x100E
#define SPI_SETHOTTRACKING                  0x100F
#define SPI_GETMENUFADE                     0x1012
#define SPI_SETMENUFADE                     0x1013
#define SPI_GETSELECTIONFADE                0x1014
#define SPI_SETSELECTIONFADE                0x1015
#define SPI_GETTOOLTIPANIMATION             0x1016
#define SPI_SETTOOLTIPANIMATION             0x1017
#define SPI_GETTOOLTIPFADE                  0x1018
#define SPI_SETTOOLTIPFADE                  0x1019
#define SPI_GETCURSORSHADOW                 0x101A
#define SPI_SETCURSORSHADOW                 0x101B
#if(_WIN32_WINNT >= 0x0501)
#define SPI_GETMOUSESONAR                   0x101C
#define SPI_SETMOUSESONAR                   0x101D
#define SPI_GETMOUSECLICKLOCK               0x101E
#define SPI_SETMOUSECLICKLOCK               0x101F
#define SPI_GETMOUSEVANISH                  0x1020
#define SPI_SETMOUSEVANISH                  0x1021
#define SPI_GETFLATMENU                     0x1022
#define SPI_SETFLATMENU                     0x1023
#define SPI_GETDROPSHADOW                   0x1024
#define SPI_SETDROPSHADOW                   0x1025
#define SPI_GETBLOCKSENDINPUTRESETS         0x1026
#define SPI_SETBLOCKSENDINPUTRESETS         0x1027
#endif /* _WIN32_WINNT >= 0x0501 */

#define SPI_GETUIEFFECTS                    0x103E
#define SPI_SETUIEFFECTS                    0x103F

#if(_WIN32_WINNT >= 0x0600)
#define SPI_GETDISABLEOVERLAPPEDCONTENT     0x1040
#define SPI_SETDISABLEOVERLAPPEDCONTENT     0x1041
#define SPI_GETCLIENTAREAANIMATION          0x1042
#define SPI_SETCLIENTAREAANIMATION          0x1043
#define SPI_GETCLEARTYPE                    0x1048
#define SPI_SETCLEARTYPE                    0x1049
#define SPI_GETSPEECHRECOGNITION            0x104A
#define SPI_SETSPEECHRECOGNITION            0x104B
#endif /* _WIN32_WINNT >= 0x0600 */

#if(WINVER >= 0x0601)
#define SPI_GETCARETBROWSING                0x104C
#define SPI_SETCARETBROWSING                0x104D
#define SPI_GETTHREADLOCALINPUTSETTINGS     0x104E
#define SPI_SETTHREADLOCALINPUTSETTINGS     0x104F
#define SPI_GETSYSTEMLANGUAGEBAR            0x1050
#define SPI_SETSYSTEMLANGUAGEBAR            0x1051
#endif /* WINVER >= 0x0601 */

#define SPI_GETFOREGROUNDLOCKTIMEOUT        0x2000
#define SPI_SETFOREGROUNDLOCKTIMEOUT        0x2001
#define SPI_GETACTIVEWNDTRKTIMEOUT          0x2002
#define SPI_SETACTIVEWNDTRKTIMEOUT          0x2003
#define SPI_GETFOREGROUNDFLASHCOUNT         0x2004
#define SPI_SETFOREGROUNDFLASHCOUNT         0x2005
#define SPI_GETCARETWIDTH                   0x2006
#define SPI_SETCARETWIDTH                   0x2007

#if(_WIN32_WINNT >= 0x0501)
#define SPI_GETMOUSECLICKLOCKTIME           0x2008
#define SPI_SETMOUSECLICKLOCKTIME           0x2009
#define SPI_GETFONTSMOOTHINGTYPE            0x200A
#define SPI_SETFONTSMOOTHINGTYPE            0x200B

/* constants for SPI_GETFONTSMOOTHINGTYPE and SPI_SETFONTSMOOTHINGTYPE: */
#define FE_FONTSMOOTHINGSTANDARD            0x0001
#define FE_FONTSMOOTHINGCLEARTYPE           0x0002

#define SPI_GETFONTSMOOTHINGCONTRAST           0x200C
#define SPI_SETFONTSMOOTHINGCONTRAST           0x200D

#define SPI_GETFOCUSBORDERWIDTH             0x200E
#define SPI_SETFOCUSBORDERWIDTH             0x200F
#define SPI_GETFOCUSBORDERHEIGHT            0x2010
#define SPI_SETFOCUSBORDERHEIGHT            0x2011

#define SPI_GETFONTSMOOTHINGORIENTATION           0x2012
#define SPI_SETFONTSMOOTHINGORIENTATION           0x2013

/* constants for SPI_GETFONTSMOOTHINGORIENTATION and SPI_SETFONTSMOOTHINGORIENTATION: */
#define FE_FONTSMOOTHINGORIENTATIONBGR   0x0000
#define FE_FONTSMOOTHINGORIENTATIONRGB   0x0001
#endif /* _WIN32_WINNT >= 0x0501 */

#if(_WIN32_WINNT >= 0x0600)
#define SPI_GETMINIMUMHITRADIUS             0x2014
#define SPI_SETMINIMUMHITRADIUS             0x2015
#define SPI_GETMESSAGEDURATION              0x2016
#define SPI_SETMESSAGEDURATION              0x2017
#endif /* _WIN32_WINNT >= 0x0600 */

#if(WINVER >= 0x0602)
#define SPI_GETCONTACTVISUALIZATION         0x2018
#define SPI_SETCONTACTVISUALIZATION         0x2019
/* constants for SPI_GETCONTACTVISUALIZATION and SPI_SETCONTACTVISUALIZATION */
#define CONTACTVISUALIZATION_OFF                 0x0000
#define CONTACTVISUALIZATION_ON                  0x0001
#define CONTACTVISUALIZATION_PRESENTATIONMODE    0x0002

#define SPI_GETGESTUREVISUALIZATION         0x201A
#define SPI_SETGESTUREVISUALIZATION         0x201B
/* constants for SPI_GETGESTUREVISUALIZATION and SPI_SETGESTUREVISUALIZATION */
#define GESTUREVISUALIZATION_OFF                 0x0000
#define GESTUREVISUALIZATION_ON                  0x001F
#define GESTUREVISUALIZATION_TAP                 0x0001
#define GESTUREVISUALIZATION_DOUBLETAP           0x0002
#define GESTUREVISUALIZATION_PRESSANDTAP         0x0004
#define GESTUREVISUALIZATION_PRESSANDHOLD        0x0008
#define GESTUREVISUALIZATION_RIGHTTAP            0x0010
#endif /* WINVER >= 0x0602 */

#if(WINVER >= 0x0602)
#define SPI_GETMOUSEWHEELROUTING            0x201C
#define SPI_SETMOUSEWHEELROUTING            0x201D

    #define MOUSEWHEEL_ROUTING_FOCUS                  0
    #define MOUSEWHEEL_ROUTING_HYBRID                 1
#if(WINVER >= 0x0603)
    #define MOUSEWHEEL_ROUTING_MOUSE_POS              2
#endif /* WINVER >= 0x0603 */
#endif /* WINVER >= 0x0602 */

#if(WINVER >= 0x0604)
#define SPI_GETPENVISUALIZATION                  0x201E
#define SPI_SETPENVISUALIZATION                  0x201F
/* constants for SPI_{GET|SET}PENVISUALIZATION */
#define PENVISUALIZATION_ON                      0x0023
#define PENVISUALIZATION_OFF                     0x0000
#define PENVISUALIZATION_TAP                     0x0001
#define PENVISUALIZATION_DOUBLETAP               0x0002
#define PENVISUALIZATION_CURSOR                  0x0020

#define SPI_GETPENARBITRATIONTYPE                0x2020
#define SPI_SETPENARBITRATIONTYPE                0x2021
/* constants for SPI_{GET|SET}PENARBITRATIONTYPE */
#define PENARBITRATIONTYPE_NONE                  0x0000
#define PENARBITRATIONTYPE_WIN8                  0x0001
#define PENARBITRATIONTYPE_FIS                   0x0002
#define PENARBITRATIONTYPE_SPT                   0x0003
#define PENARBITRATIONTYPE_MAX                   0x0004
#endif /* WINVER >= 0x0604 */

#endif /* WINVER >= 0x0500 */

/*
 * Flags
 */
#define SPIF_UPDATEINIFILE    0x0001
#define SPIF_SENDWININICHANGE 0x0002
#define SPIF_SENDCHANGE       SPIF_SENDWININICHANGE


#define METRICS_USEDEFAULT -1
#ifdef _WINGDI_
#ifndef NOGDI

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

typedef struct tagNONCLIENTMETRICSA
{
    UINT    cbSize;
    int     iBorderWidth;
    int     iScrollWidth;
    int     iScrollHeight;
    int     iCaptionWidth;
    int     iCaptionHeight;
    LOGFONTA lfCaptionFont;
    int     iSmCaptionWidth;
    int     iSmCaptionHeight;
    LOGFONTA lfSmCaptionFont;
    int     iMenuWidth;
    int     iMenuHeight;
    LOGFONTA lfMenuFont;
    LOGFONTA lfStatusFont;
    LOGFONTA lfMessageFont;
#if(WINVER >= 0x0600)
    int     iPaddedBorderWidth;
#endif /* WINVER >= 0x0600 */
}   NONCLIENTMETRICSA, *PNONCLIENTMETRICSA, FAR* LPNONCLIENTMETRICSA;
typedef struct tagNONCLIENTMETRICSW
{
    UINT    cbSize;
    int     iBorderWidth;
    int     iScrollWidth;
    int     iScrollHeight;
    int     iCaptionWidth;
    int     iCaptionHeight;
    LOGFONTW lfCaptionFont;
    int     iSmCaptionWidth;
    int     iSmCaptionHeight;
    LOGFONTW lfSmCaptionFont;
    int     iMenuWidth;
    int     iMenuHeight;
    LOGFONTW lfMenuFont;
    LOGFONTW lfStatusFont;
    LOGFONTW lfMessageFont;
#if(WINVER >= 0x0600)
    int     iPaddedBorderWidth;
#endif /* WINVER >= 0x0600 */
}   NONCLIENTMETRICSW, *PNONCLIENTMETRICSW, FAR* LPNONCLIENTMETRICSW;
#ifdef UNICODE
typedef NONCLIENTMETRICSW NONCLIENTMETRICS;
typedef PNONCLIENTMETRICSW PNONCLIENTMETRICS;
typedef LPNONCLIENTMETRICSW LPNONCLIENTMETRICS;
#else
typedef NONCLIENTMETRICSA NONCLIENTMETRICS;
typedef PNONCLIENTMETRICSA PNONCLIENTMETRICS;
typedef LPNONCLIENTMETRICSA LPNONCLIENTMETRICS;
#endif // UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#endif /* NOGDI */
#endif /* _WINGDI_ */

#define ARW_BOTTOMLEFT              0x0000L
#define ARW_BOTTOMRIGHT             0x0001L
#define ARW_TOPLEFT                 0x0002L
#define ARW_TOPRIGHT                0x0003L
#define ARW_STARTMASK               0x0003L
#define ARW_STARTRIGHT              0x0001L
#define ARW_STARTTOP                0x0002L

#define ARW_LEFT                    0x0000L
#define ARW_RIGHT                   0x0000L
#define ARW_UP                      0x0004L
#define ARW_DOWN                    0x0004L
#define ARW_HIDE                    0x0008L

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

typedef struct tagMINIMIZEDMETRICS
{
    UINT    cbSize;
    int     iWidth;
    int     iHorzGap;
    int     iVertGap;
    int     iArrange;
}   MINIMIZEDMETRICS, *PMINIMIZEDMETRICS, *LPMINIMIZEDMETRICS;

#ifdef _WINGDI_
#ifndef NOGDI
typedef struct tagICONMETRICSA
{
    UINT    cbSize;
    int     iHorzSpacing;
    int     iVertSpacing;
    int     iTitleWrap;
    LOGFONTA lfFont;
}   ICONMETRICSA, *PICONMETRICSA, *LPICONMETRICSA;
typedef struct tagICONMETRICSW
{
    UINT    cbSize;
    int     iHorzSpacing;
    int     iVertSpacing;
    int     iTitleWrap;
    LOGFONTW lfFont;
}   ICONMETRICSW, *PICONMETRICSW, *LPICONMETRICSW;
#ifdef UNICODE
typedef ICONMETRICSW ICONMETRICS;
typedef PICONMETRICSW PICONMETRICS;
typedef LPICONMETRICSW LPICONMETRICS;
#else
typedef ICONMETRICSA ICONMETRICS;
typedef PICONMETRICSA PICONMETRICS;
typedef LPICONMETRICSA LPICONMETRICS;
#endif // UNICODE
#endif /* NOGDI */
#endif /* _WINGDI_ */

typedef struct tagANIMATIONINFO
{
    UINT    cbSize;
    int     iMinAnimate;
}   ANIMATIONINFO, *LPANIMATIONINFO;

typedef struct tagSERIALKEYSA
{
    UINT    cbSize;
    DWORD   dwFlags;
    LPSTR     lpszActivePort;
    LPSTR     lpszPort;
    UINT    iBaudRate;
    UINT    iPortState;
    UINT    iActive;
}   SERIALKEYSA, *LPSERIALKEYSA;
typedef struct tagSERIALKEYSW
{
    UINT    cbSize;
    DWORD   dwFlags;
    LPWSTR    lpszActivePort;
    LPWSTR    lpszPort;
    UINT    iBaudRate;
    UINT    iPortState;
    UINT    iActive;
}   SERIALKEYSW, *LPSERIALKEYSW;
#ifdef UNICODE
typedef SERIALKEYSW SERIALKEYS;
typedef LPSERIALKEYSW LPSERIALKEYS;
#else
typedef SERIALKEYSA SERIALKEYS;
typedef LPSERIALKEYSA LPSERIALKEYS;
#endif // UNICODE

/* flags for SERIALKEYS dwFlags field */
#define SERKF_SERIALKEYSON  0x00000001
#define SERKF_AVAILABLE     0x00000002
#define SERKF_INDICATOR     0x00000004


typedef struct tagHIGHCONTRASTA
{
    UINT    cbSize;
    DWORD   dwFlags;
    LPSTR   lpszDefaultScheme;
}   HIGHCONTRASTA, *LPHIGHCONTRASTA;
typedef struct tagHIGHCONTRASTW
{
    UINT    cbSize;
    DWORD   dwFlags;
    LPWSTR  lpszDefaultScheme;
}   HIGHCONTRASTW, *LPHIGHCONTRASTW;
#ifdef UNICODE
typedef HIGHCONTRASTW HIGHCONTRAST;
typedef LPHIGHCONTRASTW LPHIGHCONTRAST;
#else
typedef HIGHCONTRASTA HIGHCONTRAST;
typedef LPHIGHCONTRASTA LPHIGHCONTRAST;
#endif // UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/* flags for HIGHCONTRAST dwFlags field */
#define HCF_HIGHCONTRASTON  0x00000001
#define HCF_AVAILABLE       0x00000002
#define HCF_HOTKEYACTIVE    0x00000004
#define HCF_CONFIRMHOTKEY   0x00000008
#define HCF_HOTKEYSOUND     0x00000010
#define HCF_INDICATOR       0x00000020
#define HCF_HOTKEYAVAILABLE 0x00000040
#define HCF_LOGONDESKTOP    0x00000100
#define HCF_DEFAULTDESKTOP  0x00000200

/* Flags for ChangeDisplaySettings */
#define CDS_UPDATEREGISTRY           0x00000001
#define CDS_TEST                     0x00000002
#define CDS_FULLSCREEN               0x00000004
#define CDS_GLOBAL                   0x00000008
#define CDS_SET_PRIMARY              0x00000010
#define CDS_VIDEOPARAMETERS          0x00000020
#if(WINVER >= 0x0600)
#define CDS_ENABLE_UNSAFE_MODES      0x00000100
#define CDS_DISABLE_UNSAFE_MODES     0x00000200
#endif /* WINVER >= 0x0600 */
#define CDS_RESET                    0x40000000
#define CDS_RESET_EX                 0x20000000
#define CDS_NORESET                  0x10000000

#include <tvout.h>

/* Return values for ChangeDisplaySettings */
#define DISP_CHANGE_SUCCESSFUL       0
#define DISP_CHANGE_RESTART          1
#define DISP_CHANGE_FAILED          -1
#define DISP_CHANGE_BADMODE         -2
#define DISP_CHANGE_NOTUPDATED      -3
#define DISP_CHANGE_BADFLAGS        -4
#define DISP_CHANGE_BADPARAM        -5
#if(_WIN32_WINNT >= 0x0501)
#define DISP_CHANGE_BADDUALVIEW     -6
#endif /* _WIN32_WINNT >= 0x0501 */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#ifdef _WINGDI_
#ifndef NOGDI


LONG
__stdcall
ChangeDisplaySettingsA(
     DEVMODEA* lpDevMode,
     DWORD dwFlags);

LONG
__stdcall
ChangeDisplaySettingsW(
     DEVMODEW* lpDevMode,
     DWORD dwFlags);
#ifdef UNICODE
#define ChangeDisplaySettings  ChangeDisplaySettingsW
#else
#define ChangeDisplaySettings  ChangeDisplaySettingsA
#endif // !UNICODE


LONG
__stdcall
ChangeDisplaySettingsExA(
     LPCSTR lpszDeviceName,
     DEVMODEA* lpDevMode,
    HWND hwnd,
     DWORD dwflags,
     LPVOID lParam);

LONG
__stdcall
ChangeDisplaySettingsExW(
     LPCWSTR lpszDeviceName,
     DEVMODEW* lpDevMode,
    HWND hwnd,
     DWORD dwflags,
     LPVOID lParam);
#ifdef UNICODE
#define ChangeDisplaySettingsEx  ChangeDisplaySettingsExW
#else
#define ChangeDisplaySettingsEx  ChangeDisplaySettingsExA
#endif // !UNICODE


#define ENUM_CURRENT_SETTINGS       ((DWORD)-1)
#define ENUM_REGISTRY_SETTINGS      ((DWORD)-2)


BOOL
__stdcall
EnumDisplaySettingsA(
     LPCSTR lpszDeviceName,
     DWORD iModeNum,
     DEVMODEA* lpDevMode);

BOOL
__stdcall
EnumDisplaySettingsW(
     LPCWSTR lpszDeviceName,
     DWORD iModeNum,
     DEVMODEW* lpDevMode);
#ifdef UNICODE
#define EnumDisplaySettings  EnumDisplaySettingsW
#else
#define EnumDisplaySettings  EnumDisplaySettingsA
#endif // !UNICODE

#if(WINVER >= 0x0500)


BOOL
__stdcall
EnumDisplaySettingsExA(
     LPCSTR lpszDeviceName,
     DWORD iModeNum,
     DEVMODEA* lpDevMode,
     DWORD dwFlags);

BOOL
__stdcall
EnumDisplaySettingsExW(
     LPCWSTR lpszDeviceName,
     DWORD iModeNum,
     DEVMODEW* lpDevMode,
     DWORD dwFlags);
#ifdef UNICODE
#define EnumDisplaySettingsEx  EnumDisplaySettingsExW
#else
#define EnumDisplaySettingsEx  EnumDisplaySettingsExA
#endif // !UNICODE

/* Flags for EnumDisplaySettingsEx */
#define EDS_RAWMODE                   0x00000002
#define EDS_ROTATEDMODE               0x00000004


BOOL
__stdcall
EnumDisplayDevicesA(
     LPCSTR lpDevice,
     DWORD iDevNum,
     PDISPLAY_DEVICEA lpDisplayDevice,
     DWORD dwFlags);

BOOL
__stdcall
EnumDisplayDevicesW(
     LPCWSTR lpDevice,
     DWORD iDevNum,
     PDISPLAY_DEVICEW lpDisplayDevice,
     DWORD dwFlags);
#ifdef UNICODE
#define EnumDisplayDevices  EnumDisplayDevicesW
#else
#define EnumDisplayDevices  EnumDisplayDevicesA
#endif // !UNICODE

/* Flags for EnumDisplayDevices */
#define EDD_GET_DEVICE_INTERFACE_NAME 0x00000001



LONG
__stdcall
GetDisplayConfigBufferSizes(
     UINT32 flags,
     UINT32* numPathArrayElements,
     UINT32* numModeInfoArrayElements);


LONG
__stdcall
SetDisplayConfig(
     UINT32 numPathArrayElements,
    DISPLAYCONFIG_PATH_INFO* pathArray,
     UINT32 numModeInfoArrayElements,
    DISPLAYCONFIG_MODE_INFO* modeInfoArray,
     UINT32 flags);


LONG
__stdcall
QueryDisplayConfig(
     UINT32 flags,
     UINT32* numPathArrayElements,
    DISPLAYCONFIG_PATH_INFO* pathArray,
     UINT32* numModeInfoArrayElements,
    DISPLAYCONFIG_MODE_INFO* modeInfoArray,
    DISPLAYCONFIG_TOPOLOGY_ID* currentTopologyId);


LONG
__stdcall
DisplayConfigGetDeviceInfo(
     DISPLAYCONFIG_DEVICE_INFO_HEADER* requestPacket);


LONG
__stdcall
DisplayConfigSetDeviceInfo(
     DISPLAYCONFIG_DEVICE_INFO_HEADER* setPacket);
--]=]



ffi.cdef[[
BOOL
__stdcall
SystemParametersInfoA(
     UINT uiAction,
     UINT uiParam,
      PVOID pvParam,
     UINT fWinIni);


BOOL
__stdcall
SystemParametersInfoW(
     UINT uiAction,
     UINT uiParam,
      PVOID pvParam,
     UINT fWinIni);
]]

exports.SystemParametersInfo   = ffi.C.SystemParametersInfoA;

if UNICODE then
exports.SystemParametersInfo  = ffi.C.SystemParametersInfoW;
end

ffi.cdef[[
BOOL
__stdcall
SystemParametersInfoForDpi(
     UINT uiAction,
     UINT uiParam,
    PVOID pvParam,
     UINT fWinIni,
     UINT dpi);
]]


--[=[
/*
 * Accessibility support
 */
typedef struct tagFILTERKEYS
{
    UINT  cbSize;
    DWORD dwFlags;
    DWORD iWaitMSec;            // Acceptance Delay
    DWORD iDelayMSec;           // Delay Until Repeat
    DWORD iRepeatMSec;          // Repeat Rate
    DWORD iBounceMSec;          // Debounce Time
} FILTERKEYS, *LPFILTERKEYS;

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/*
 * FILTERKEYS dwFlags field
 */
#define FKF_FILTERKEYSON    0x00000001
#define FKF_AVAILABLE       0x00000002
#define FKF_HOTKEYACTIVE    0x00000004
#define FKF_CONFIRMHOTKEY   0x00000008
#define FKF_HOTKEYSOUND     0x00000010
#define FKF_INDICATOR       0x00000020
#define FKF_CLICKON         0x00000040

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

typedef struct tagSTICKYKEYS
{
    UINT  cbSize;
    DWORD dwFlags;
} STICKYKEYS, *LPSTICKYKEYS;

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/*
 * STICKYKEYS dwFlags field
 */
#define SKF_STICKYKEYSON    0x00000001
#define SKF_AVAILABLE       0x00000002
#define SKF_HOTKEYACTIVE    0x00000004
#define SKF_CONFIRMHOTKEY   0x00000008
#define SKF_HOTKEYSOUND     0x00000010
#define SKF_INDICATOR       0x00000020
#define SKF_AUDIBLEFEEDBACK 0x00000040
#define SKF_TRISTATE        0x00000080
#define SKF_TWOKEYSOFF      0x00000100
#if(_WIN32_WINNT >= 0x0500)
#define SKF_LALTLATCHED       0x10000000
#define SKF_LCTLLATCHED       0x04000000
#define SKF_LSHIFTLATCHED     0x01000000
#define SKF_RALTLATCHED       0x20000000
#define SKF_RCTLLATCHED       0x08000000
#define SKF_RSHIFTLATCHED     0x02000000
#define SKF_LWINLATCHED       0x40000000
#define SKF_RWINLATCHED       0x80000000
#define SKF_LALTLOCKED        0x00100000
#define SKF_LCTLLOCKED        0x00040000
#define SKF_LSHIFTLOCKED      0x00010000
#define SKF_RALTLOCKED        0x00200000
#define SKF_RCTLLOCKED        0x00080000
#define SKF_RSHIFTLOCKED      0x00020000
#define SKF_LWINLOCKED        0x00400000
#define SKF_RWINLOCKED        0x00800000
#endif /* _WIN32_WINNT >= 0x0500 */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

typedef struct tagMOUSEKEYS
{
    UINT cbSize;
    DWORD dwFlags;
    DWORD iMaxSpeed;
    DWORD iTimeToMaxSpeed;
    DWORD iCtrlSpeed;
    DWORD dwReserved1;
    DWORD dwReserved2;
} MOUSEKEYS, *LPMOUSEKEYS;

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/*
 * MOUSEKEYS dwFlags field
 */
#define MKF_MOUSEKEYSON     0x00000001
#define MKF_AVAILABLE       0x00000002
#define MKF_HOTKEYACTIVE    0x00000004
#define MKF_CONFIRMHOTKEY   0x00000008
#define MKF_HOTKEYSOUND     0x00000010
#define MKF_INDICATOR       0x00000020
#define MKF_MODIFIERS       0x00000040
#define MKF_REPLACENUMBERS  0x00000080
#if(_WIN32_WINNT >= 0x0500)
#define MKF_LEFTBUTTONSEL   0x10000000
#define MKF_RIGHTBUTTONSEL  0x20000000
#define MKF_LEFTBUTTONDOWN  0x01000000
#define MKF_RIGHTBUTTONDOWN 0x02000000
#define MKF_MOUSEMODE       0x80000000
#endif /* _WIN32_WINNT >= 0x0500 */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

typedef struct tagACCESSTIMEOUT
{
    UINT  cbSize;
    DWORD dwFlags;
    DWORD iTimeOutMSec;
} ACCESSTIMEOUT, *LPACCESSTIMEOUT;

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/*
 * ACCESSTIMEOUT dwFlags field
 */
#define ATF_TIMEOUTON       0x00000001
#define ATF_ONOFFFEEDBACK   0x00000002

/* values for SOUNDSENTRY iFSGrafEffect field */
#define SSGF_NONE       0
#define SSGF_DISPLAY    3

/* values for SOUNDSENTRY iFSTextEffect field */
#define SSTF_NONE       0
#define SSTF_CHARS      1
#define SSTF_BORDER     2
#define SSTF_DISPLAY    3

/* values for SOUNDSENTRY iWindowsEffect field */
#define SSWF_NONE     0
#define SSWF_TITLE    1
#define SSWF_WINDOW   2
#define SSWF_DISPLAY  3
#define SSWF_CUSTOM   4

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

typedef struct tagSOUNDSENTRYA
{
    UINT cbSize;
    DWORD dwFlags;
    DWORD iFSTextEffect;
    DWORD iFSTextEffectMSec;
    DWORD iFSTextEffectColorBits;
    DWORD iFSGrafEffect;
    DWORD iFSGrafEffectMSec;
    DWORD iFSGrafEffectColor;
    DWORD iWindowsEffect;
    DWORD iWindowsEffectMSec;
    LPSTR   lpszWindowsEffectDLL;
    DWORD iWindowsEffectOrdinal;
} SOUNDSENTRYA, *LPSOUNDSENTRYA;
typedef struct tagSOUNDSENTRYW
{
    UINT cbSize;
    DWORD dwFlags;
    DWORD iFSTextEffect;
    DWORD iFSTextEffectMSec;
    DWORD iFSTextEffectColorBits;
    DWORD iFSGrafEffect;
    DWORD iFSGrafEffectMSec;
    DWORD iFSGrafEffectColor;
    DWORD iWindowsEffect;
    DWORD iWindowsEffectMSec;
    LPWSTR  lpszWindowsEffectDLL;
    DWORD iWindowsEffectOrdinal;
} SOUNDSENTRYW, *LPSOUNDSENTRYW;
#ifdef UNICODE
typedef SOUNDSENTRYW SOUNDSENTRY;
typedef LPSOUNDSENTRYW LPSOUNDSENTRY;
#else
typedef SOUNDSENTRYA SOUNDSENTRY;
typedef LPSOUNDSENTRYA LPSOUNDSENTRY;
#endif // UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/*
 * SOUNDSENTRY dwFlags field
 */
#define SSF_SOUNDSENTRYON   0x00000001
#define SSF_AVAILABLE       0x00000002
#define SSF_INDICATOR       0x00000004

#pragma region Desktop or PC Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_PC_APP)
#if(_WIN32_WINNT >= 0x0600)

BOOL
__stdcall
SoundSentry(VOID);


typedef struct tagTOGGLEKEYS
{
    UINT cbSize;
    DWORD dwFlags;
} TOGGLEKEYS, *LPTOGGLEKEYS;


/*
 * TOGGLEKEYS dwFlags field
 */
#define TKF_TOGGLEKEYSON    0x00000001
#define TKF_AVAILABLE       0x00000002
#define TKF_HOTKEYACTIVE    0x00000004
#define TKF_CONFIRMHOTKEY   0x00000008
#define TKF_HOTKEYSOUND     0x00000010
#define TKF_INDICATOR       0x00000020



typedef struct tagAUDIODESCRIPTION {
    UINT cbSize;   // sizeof(AudioDescriptionType)
    BOOL Enabled;  // On/Off
    LCID Locale;   // locale ID for language
} AUDIODESCRIPTION, *LPAUDIODESCRIPTION;



/*
 * Set debug level
 */


VOID
__stdcall
SetDebugErrorLevel(
     DWORD dwLevel);



/*
 * SetLastErrorEx() types.
 */

#define SLE_ERROR       0x00000001
#define SLE_MINORERROR  0x00000002
#define SLE_WARNING     0x00000003


VOID
__stdcall
SetLastErrorEx(
     DWORD dwErrCode,
     DWORD dwType);


int
__stdcall
InternalGetWindowText(
     HWND hWnd,
    LPWSTR pString,
     int cchMaxCount);


#if defined(WINNT)

BOOL
__stdcall
EndTask(
     HWND hWnd,
     BOOL fShutDown,
     BOOL fForce);
#endif


BOOL
__stdcall
CancelShutdown(
    VOID);



/*
 * Multimonitor API.
 */

#define MONITOR_DEFAULTTONULL       0x00000000
#define MONITOR_DEFAULTTOPRIMARY    0x00000001
#define MONITOR_DEFAULTTONEAREST    0x00000002


HMONITOR
__stdcall
MonitorFromPoint(
     POINT pt,
     DWORD dwFlags);


HMONITOR
__stdcall
MonitorFromRect(
     LPCRECT lprc,
     DWORD dwFlags);


HMONITOR
__stdcall
MonitorFromWindow(
     HWND hwnd,
     DWORD dwFlags);


#define MONITORINFOF_PRIMARY        0x00000001

#ifndef CCHDEVICENAME
#define CCHDEVICENAME 32
#endif

typedef struct tagMONITORINFO
{
    DWORD   cbSize;
    RECT    rcMonitor;
    RECT    rcWork;
    DWORD   dwFlags;
} MONITORINFO, *LPMONITORINFO;

#ifdef __cplusplus
typedef struct tagMONITORINFOEXA : public tagMONITORINFO
{
    CHAR        szDevice[CCHDEVICENAME];
} MONITORINFOEXA, *LPMONITORINFOEXA;
typedef struct tagMONITORINFOEXW : public tagMONITORINFO
{
    WCHAR       szDevice[CCHDEVICENAME];
} MONITORINFOEXW, *LPMONITORINFOEXW;
#ifdef UNICODE
typedef MONITORINFOEXW MONITORINFOEX;
typedef LPMONITORINFOEXW LPMONITORINFOEX;
#else
typedef MONITORINFOEXA MONITORINFOEX;
typedef LPMONITORINFOEXA LPMONITORINFOEX;
#endif // UNICODE
#else // ndef __cplusplus
typedef struct tagMONITORINFOEXA
{
    MONITORINFO DUMMYSTRUCTNAME;
    CHAR        szDevice[CCHDEVICENAME];
} MONITORINFOEXA, *LPMONITORINFOEXA;
typedef struct tagMONITORINFOEXW
{
    MONITORINFO DUMMYSTRUCTNAME;
    WCHAR       szDevice[CCHDEVICENAME];
} MONITORINFOEXW, *LPMONITORINFOEXW;
#ifdef UNICODE
typedef MONITORINFOEXW MONITORINFOEX;
typedef LPMONITORINFOEXW LPMONITORINFOEX;
#else
typedef MONITORINFOEXA MONITORINFOEX;
typedef LPMONITORINFOEXA LPMONITORINFOEX;
#endif // UNICODE
#endif


BOOL
__stdcall
GetMonitorInfoA(
     HMONITOR hMonitor,
     LPMONITORINFO lpmi);

BOOL
__stdcall
GetMonitorInfoW(
     HMONITOR hMonitor,
     LPMONITORINFO lpmi);
#ifdef UNICODE
#define GetMonitorInfo  GetMonitorInfoW
#else
#define GetMonitorInfo  GetMonitorInfoA
#endif // !UNICODE

typedef BOOL (__stdcall* MONITORENUMPROC)(HMONITOR, HDC, LPRECT, LPARAM);


BOOL
__stdcall
EnumDisplayMonitors(
     HDC hdc,
     LPCRECT lprcClip,
     MONITORENUMPROC lpfnEnum,
     LPARAM dwData);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion


#ifndef NOWINABLE

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

/*
 * WinEvents - Active Accessibility hooks
 */


VOID
__stdcall
NotifyWinEvent(
     DWORD event,
     HWND  hwnd,
     LONG  idObject,
     LONG  idChild);

typedef VOID (__stdcall* WINEVENTPROC)(
    HWINEVENTHOOK hWinEventHook,
    DWORD         event,
    HWND          hwnd,
    LONG          idObject,
    LONG          idChild,
    DWORD         idEventThread,
    DWORD         dwmsEventTime);


HWINEVENTHOOK
__stdcall
SetWinEventHook(
     DWORD eventMin,
     DWORD eventMax,
     HMODULE hmodWinEventProc,
     WINEVENTPROC pfnWinEventProc,
     DWORD idProcess,
     DWORD idThread,
     DWORD dwFlags);

#if(_WIN32_WINNT >= 0x0501)

BOOL
__stdcall
IsWinEventHookInstalled(
     DWORD event);
#endif /* _WIN32_WINNT >= 0x0501 */

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/*
 * dwFlags for SetWinEventHook
 */
#define WINEVENT_OUTOFCONTEXT   0x0000  // Events are ASYNC
#define WINEVENT_SKIPOWNTHREAD  0x0001  // Don't call back for events on installer's thread
#define WINEVENT_SKIPOWNPROCESS 0x0002  // Don't call back for events on installer's process
#define WINEVENT_INCONTEXT      0x0004  // Events are SYNC, this causes your dll to be injected into every process

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
UnhookWinEvent(
     HWINEVENTHOOK hWinEventHook);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/*
 * idObject values for WinEventProc and NotifyWinEvent
 */

/*
 * hwnd + idObject can be used with OLEACC.DLL's OleGetObjectFromWindow()
 * to get an interface pointer to the container.  indexChild is the item
 * within the container in question.  Setup a VARIANT with vt VT_I4 and
 * lVal the indexChild and pass that in to all methods.  Then you
 * are raring to go.
 */


/*
 * Common object IDs (cookies, only for sending WM_GETOBJECT to get at the
 * thing in question).  Positive IDs are reserved for apps (app specific),
 * negative IDs are system things and are global, 0 means "just little old
 * me".
 */
#define     CHILDID_SELF        0
#define     INDEXID_OBJECT      0
#define     INDEXID_CONTAINER   0

/*
 * Reserved IDs for system objects
 */
#define     OBJID_WINDOW        ((LONG)0x00000000)
#define     OBJID_SYSMENU       ((LONG)0xFFFFFFFF)
#define     OBJID_TITLEBAR      ((LONG)0xFFFFFFFE)
#define     OBJID_MENU          ((LONG)0xFFFFFFFD)
#define     OBJID_CLIENT        ((LONG)0xFFFFFFFC)
#define     OBJID_VSCROLL       ((LONG)0xFFFFFFFB)
#define     OBJID_HSCROLL       ((LONG)0xFFFFFFFA)
#define     OBJID_SIZEGRIP      ((LONG)0xFFFFFFF9)
#define     OBJID_CARET         ((LONG)0xFFFFFFF8)
#define     OBJID_CURSOR        ((LONG)0xFFFFFFF7)
#define     OBJID_ALERT         ((LONG)0xFFFFFFF6)
#define     OBJID_SOUND         ((LONG)0xFFFFFFF5)
#define     OBJID_QUERYCLASSNAMEIDX ((LONG)0xFFFFFFF4)
#define     OBJID_NATIVEOM      ((LONG)0xFFFFFFF0)

/*
 * EVENT DEFINITION
 */
#define EVENT_MIN           0x00000001
#define EVENT_MAX           0x7FFFFFFF

/*
 *  EVENT_SYSTEM_SOUND
 *  Sent when a sound is played.  Currently nothing is generating this, we
 *  this event when a system sound (for menus, etc) is played.  Apps
 *  generate this, if accessible, when a private sound is played.  For
 *  example, if Mail plays a "New Mail" sound.
 *
 *  System Sounds:
 *  (Generated by PlaySoundEvent in USER itself)
 *      hwnd            is NULL
 *      idObject        is OBJID_SOUND
 *      idChild         is sound child ID if one
 *  App Sounds:
 *  (PlaySoundEvent won't generate notification; up to app)
 *      hwnd + idObject gets interface pointer to Sound object
 *      idChild identifies the sound in question
 *  are going to be cleaning up the SOUNDSENTRY feature in the control panel
 *  and will use this at that time.  Applications implementing WinEvents
 *  are perfectly welcome to use it.  Clients of IAccessible* will simply
 *  turn around and get back a non-visual object that describes the sound.
 */
#define EVENT_SYSTEM_SOUND              0x0001

/*
 * EVENT_SYSTEM_ALERT
 * System Alerts:
 * (Generated by MessageBox() calls for example)
 *      hwnd            is hwndMessageBox
 *      idObject        is OBJID_ALERT
 * App Alerts:
 * (Generated whenever)
 *      hwnd+idObject gets interface pointer to Alert
 */
#define EVENT_SYSTEM_ALERT              0x0002

/*
 * EVENT_SYSTEM_FOREGROUND
 * Sent when the foreground (active) window changes, even if it is changing
 * to another window in the same thread as the previous one.
 *      hwnd            is hwndNewForeground
 *      idObject        is OBJID_WINDOW
 *      idChild    is INDEXID_OBJECT
 */
#define EVENT_SYSTEM_FOREGROUND         0x0003

/*
 * Menu
 *      hwnd            is window (top level window or popup menu window)
 *      idObject        is ID of control (OBJID_MENU, OBJID_SYSMENU, OBJID_SELF for popup)
 *      idChild         is CHILDID_SELF
 *
 * EVENT_SYSTEM_MENUSTART
 * EVENT_SYSTEM_MENUEND
 * For MENUSTART, hwnd+idObject+idChild refers to the control with the menu bar,
 *  or the control bringing up the context menu.
 *
 * Sent when entering into and leaving from menu mode (system, app bar, and
 * track popups).
 */
#define EVENT_SYSTEM_MENUSTART          0x0004
#define EVENT_SYSTEM_MENUEND            0x0005

/*
 * EVENT_SYSTEM_MENUPOPUPSTART
 * EVENT_SYSTEM_MENUPOPUPEND
 * Sent when a menu popup comes up and just before it is taken down.  Note
 * that for a call to TrackPopupMenu(), a client will see EVENT_SYSTEM_MENUSTART
 * followed almost immediately by EVENT_SYSTEM_MENUPOPUPSTART for the popup
 * being shown.
 *
 * For MENUPOPUP, hwnd+idObject+idChild refers to the NEW popup coming up, not the
 * parent item which is hierarchical.  You can get the parent menu/popup by
 * asking for the accParent object.
 */
#define EVENT_SYSTEM_MENUPOPUPSTART     0x0006
#define EVENT_SYSTEM_MENUPOPUPEND       0x0007


/*
 * EVENT_SYSTEM_CAPTURESTART
 * EVENT_SYSTEM_CAPTUREEND
 * Sent when a window takes the capture and releases the capture.
 */
#define EVENT_SYSTEM_CAPTURESTART       0x0008
#define EVENT_SYSTEM_CAPTUREEND         0x0009

/*
 * Move Size
 * EVENT_SYSTEM_MOVESIZESTART
 * EVENT_SYSTEM_MOVESIZEEND
 * Sent when a window enters and leaves move-size dragging mode.
 */
#define EVENT_SYSTEM_MOVESIZESTART      0x000A
#define EVENT_SYSTEM_MOVESIZEEND        0x000B

/*
 * Context Help
 * EVENT_SYSTEM_CONTEXTHELPSTART
 * EVENT_SYSTEM_CONTEXTHELPEND
 * Sent when a window enters and leaves context sensitive help mode.
 */
#define EVENT_SYSTEM_CONTEXTHELPSTART   0x000C
#define EVENT_SYSTEM_CONTEXTHELPEND     0x000D

/*
 * Drag & Drop
 * EVENT_SYSTEM_DRAGDROPSTART
 * EVENT_SYSTEM_DRAGDROPEND
 * Send the START notification just before going into drag&drop loop.  Send
 * the END notification just after canceling out.
 * Note that it is up to apps and OLE to generate this, since the system
 * doesn't know.  Like EVENT_SYSTEM_SOUND, it will be a while before this
 * is prevalent.
 */
#define EVENT_SYSTEM_DRAGDROPSTART      0x000E
#define EVENT_SYSTEM_DRAGDROPEND        0x000F

/*
 * Dialog
 * Send the START notification right after the dialog is completely
 *  initialized and visible.  Send the END right before the dialog
 *  is hidden and goes away.
 * EVENT_SYSTEM_DIALOGSTART
 * EVENT_SYSTEM_DIALOGEND
 */
#define EVENT_SYSTEM_DIALOGSTART        0x0010
#define EVENT_SYSTEM_DIALOGEND          0x0011

/*
 * EVENT_SYSTEM_SCROLLING
 * EVENT_SYSTEM_SCROLLINGSTART
 * EVENT_SYSTEM_SCROLLINGEND
 * Sent when beginning and ending the tracking of a scrollbar in a window,
 * and also for scrollbar controls.
 */
#define EVENT_SYSTEM_SCROLLINGSTART     0x0012
#define EVENT_SYSTEM_SCROLLINGEND       0x0013

/*
 * Alt-Tab Window
 * Send the START notification right after the switch window is initialized
 * and visible.  Send the END right before it is hidden and goes away.
 * EVENT_SYSTEM_SWITCHSTART
 * EVENT_SYSTEM_SWITCHEND
 */
#define EVENT_SYSTEM_SWITCHSTART        0x0014
#define EVENT_SYSTEM_SWITCHEND          0x0015

/*
 * EVENT_SYSTEM_MINIMIZESTART
 * EVENT_SYSTEM_MINIMIZEEND
 * Sent when a window minimizes and just before it restores.
 */
#define EVENT_SYSTEM_MINIMIZESTART      0x0016
#define EVENT_SYSTEM_MINIMIZEEND        0x0017


#if(_WIN32_WINNT >= 0x0600)
#define EVENT_SYSTEM_DESKTOPSWITCH      0x0020
#endif /* _WIN32_WINNT >= 0x0600 */


#if(_WIN32_WINNT >= 0x0602)
// AppGrabbed: HWND = hwnd of app thumbnail, objectID = 0, childID = 0
#define EVENT_SYSTEM_SWITCHER_APPGRABBED    0x0024
// OverTarget: HWND = hwnd of app thumbnail, objectID =
//            1 for center
//            2 for near snapped
//            3 for far snapped
//            4 for prune
//            childID = 0
#define EVENT_SYSTEM_SWITCHER_APPOVERTARGET 0x0025
// Dropped: HWND = hwnd of app thumbnail, objectID = <same as above>, childID = 0
#define EVENT_SYSTEM_SWITCHER_APPDROPPED    0x0026
// Cancelled: HWND = hwnd of app thumbnail, objectID = 0, childID = 0
#define EVENT_SYSTEM_SWITCHER_CANCELLED     0x0027
#endif /* _WIN32_WINNT >= 0x0602 */


#if(_WIN32_WINNT >= 0x0602)

/*
 * Sent when an IME's soft key is pressed and should be echoed,
 * but is not passed through the keyboard hook.
 * Must not be sent when a key is sent through the keyboard hook.
 *     HWND             is the hwnd of the UI containing the soft key
 *     idChild          is the Unicode value of the character entered
 *     idObject         is a bitfield
 *         0x00000001: set if a 32-bit Unicode surrogate pair is used
 */
#define EVENT_SYSTEM_IME_KEY_NOTIFICATION  0x0029

#endif /* _WIN32_WINNT >= 0x0602 */


#if(_WIN32_WINNT >= 0x0601)
#define EVENT_SYSTEM_END        0x00FF

#define EVENT_OEM_DEFINED_START     0x0101
#define EVENT_OEM_DEFINED_END       0x01FF

#define EVENT_UIA_EVENTID_START         0x4E00
#define EVENT_UIA_EVENTID_END           0x4EFF

#define EVENT_UIA_PROPID_START          0x7500
#define EVENT_UIA_PROPID_END            0x75FF
#endif /* _WIN32_WINNT >= 0x0601 */

#if(_WIN32_WINNT >= 0x0501)
#define EVENT_CONSOLE_CARET             0x4001
#define EVENT_CONSOLE_UPDATE_REGION     0x4002
#define EVENT_CONSOLE_UPDATE_SIMPLE     0x4003
#define EVENT_CONSOLE_UPDATE_SCROLL     0x4004
#define EVENT_CONSOLE_LAYOUT            0x4005
#define EVENT_CONSOLE_START_APPLICATION 0x4006
#define EVENT_CONSOLE_END_APPLICATION   0x4007

/*
 * Flags for EVENT_CONSOLE_START/END_APPLICATION.
 */
#if defined(_WIN64)
#define CONSOLE_APPLICATION_16BIT       0x0000
#else
#define CONSOLE_APPLICATION_16BIT       0x0001
#endif

/*
 * Flags for EVENT_CONSOLE_CARET
 */
#define CONSOLE_CARET_SELECTION         0x0001
#define CONSOLE_CARET_VISIBLE           0x0002
#endif /* _WIN32_WINNT >= 0x0501 */

#if(_WIN32_WINNT >= 0x0601)
#define EVENT_CONSOLE_END       0x40FF
#endif /* _WIN32_WINNT >= 0x0601 */

/*
 * Object events
 *
 * The system AND apps generate these.  The system generates these for
 * real windows.  Apps generate these for objects within their window which
 * act like a separate control, e.g. an item in a list view.
 *
 * When the system generate them, dwParam2 is always WMOBJID_SELF.  When
 * apps generate them, apps put the has-meaning-to-the-app-only ID value
 * in dwParam2.
 * For all events, if you want detailed accessibility information, callers
 * should
 *      * Call AccessibleObjectFromWindow() with the hwnd, idObject parameters
 *          of the event, and IID_IAccessible as the REFIID, to get back an
 *          IAccessible* to talk to
 *      * Initialize and fill in a VARIANT as VT_I4 with lVal the idChild
 *          parameter of the event.
 *      * If idChild isn't zero, call get_accChild() in the container to see
 *          if the child is an object in its own right.  If so, you will get
 *          back an IDispatch* object for the child.  You should release the
 *          parent, and call QueryInterface() on the child object to get its
 *          IAccessible*.  Then you talk directly to the child.  Otherwise,
 *          if get_accChild() returns you nothing, you should continue to
 *          use the child VARIANT.  You will ask the container for the properties
 *          of the child identified by the VARIANT.  In other words, the
 *          child in this case is accessible but not a full-blown object.
 *          Like a button on a titlebar which is 'small' and has no children.
 */

/*
 * For all EVENT_OBJECT events,
 *      hwnd is the dude to Send the WM_GETOBJECT message to (unless NULL,
 *          see above for system things)
 *      idObject is the ID of the object that can resolve any queries a
 *          client might have.  It's a way to deal with windowless controls,
 *          controls that are just drawn on the screen in some larger parent
 *          window (like SDM), or standard frame elements of a window.
 *      idChild is the piece inside of the object that is affected.  This
 *          allows clients to access things that are too small to have full
 *          blown objects in their own right.  Like the thumb of a scrollbar.
 *          The hwnd/idObject pair gets you to the container, the dude you
 *          probably want to talk to most of the time anyway.  The idChild
 *          can then be passed into the acc properties to get the name/value
 *          of it as needed.
 *
 * Example #1:
 *      System propagating a listbox selection change
 *      EVENT_OBJECT_SELECTION
 *          hwnd == listbox hwnd
 *          idObject == OBJID_WINDOW
 *          idChild == new selected item, or CHILDID_SELF if
 *              nothing now selected within container.
 *      Word '97 propagating a listbox selection change
 *          hwnd == SDM window
 *          idObject == SDM ID to get at listbox 'control'
 *          idChild == new selected item, or CHILDID_SELF if
 *              nothing
 *
 * Example #2:
 *      System propagating a menu item selection on the menu bar
 *      EVENT_OBJECT_SELECTION
 *          hwnd == top level window
 *          idObject == OBJID_MENU
 *          idChild == ID of child menu bar item selected
 *
 * Example #3:
 *      System propagating a dropdown coming off of said menu bar item
 *      EVENT_OBJECT_CREATE
 *          hwnd == popup item
 *          idObject == OBJID_WINDOW
 *          idChild == CHILDID_SELF
 *
 * Example #4:
 *
 * For EVENT_OBJECT_REORDER, the object referred to by hwnd/idObject is the
 * PARENT container in which the zorder is occurring.  This is because if
 * one child is zordering, all of them are changing their relative zorder.
 */
#define EVENT_OBJECT_CREATE                 0x8000  // hwnd + ID + idChild is created item
#define EVENT_OBJECT_DESTROY                0x8001  // hwnd + ID + idChild is destroyed item
#define EVENT_OBJECT_SHOW                   0x8002  // hwnd + ID + idChild is shown item
#define EVENT_OBJECT_HIDE                   0x8003  // hwnd + ID + idChild is hidden item
#define EVENT_OBJECT_REORDER                0x8004  // hwnd + ID + idChild is parent of zordering children
/*
 * NOTE:
 * Minimize the number of notifications!
 *
 * When you are hiding a parent object, obviously all child objects are no
 * longer visible on screen.  They still have the same "visible" status,
 * but are not truly visible.  Hence do not send HIDE notifications for the
 * children also.  One implies all.  The same goes for SHOW.
 */


#define EVENT_OBJECT_FOCUS                  0x8005  // hwnd + ID + idChild is focused item
#define EVENT_OBJECT_SELECTION              0x8006  // hwnd + ID + idChild is selected item (if only one), or idChild is OBJID_WINDOW if complex
#define EVENT_OBJECT_SELECTIONADD           0x8007  // hwnd + ID + idChild is item added
#define EVENT_OBJECT_SELECTIONREMOVE        0x8008  // hwnd + ID + idChild is item removed
#define EVENT_OBJECT_SELECTIONWITHIN        0x8009  // hwnd + ID + idChild is parent of changed selected items

/*
 * NOTES:
 * There is only one "focused" child item in a parent.  This is the place
 * keystrokes are going at a given moment.  Hence only send a notification
 * about where the NEW focus is going.  A NEW item getting the focus already
 * implies that the OLD item is losing it.
 *
 * SELECTION however can be multiple.  Hence the different SELECTION
 * notifications.  Here's when to use each:
 *
 * (1) Send a SELECTION notification in the simple single selection
 *     case (like the focus) when the item with the selection is
 *     merely moving to a different item within a container.  hwnd + ID
 *     is the container control, idChildItem is the new child with the
 *     selection.
 *
 * (2) Send a SELECTIONADD notification when a new item has simply been added
 *     to the selection within a container.  This is appropriate when the
 *     number of newly selected items is very small.  hwnd + ID is the
 *     container control, idChildItem is the new child added to the selection.
 *
 * (3) Send a SELECTIONREMOVE notification when a new item has simply been
 *     removed from the selection within a container.  This is appropriate
 *     when the number of newly selected items is very small, just like
 *     SELECTIONADD.  hwnd + ID is the container control, idChildItem is the
 *     new child removed from the selection.
 *
 * (4) Send a SELECTIONWITHIN notification when the selected items within a
 *     control have changed substantially.  Rather than propagate a large
 *     number of changes to reflect removal for some items, addition of
 *     others, just tell somebody who cares that a lot happened.  It will
 *     be faster an easier for somebody watching to just turn around and
 *     query the container control what the new bunch of selected items
 *     are.
 */

#define EVENT_OBJECT_STATECHANGE            0x800A  // hwnd + ID + idChild is item w/ state change
/*
 * Examples of when to send an EVENT_OBJECT_STATECHANGE include
 *      * It is being enabled/disabled (USER does for windows)
 *      * It is being pressed/released (USER does for buttons)
 *      * It is being checked/unchecked (USER does for radio/check buttons)
 */
#define EVENT_OBJECT_LOCATIONCHANGE         0x800B  // hwnd + ID + idChild is moved/sized item

/*
 * Note:
 * A LOCATIONCHANGE is not sent for every child object when the parent
 * changes shape/moves.  Send one notification for the topmost object
 * that is changing.  For example, if the user resizes a top level window,
 * USER will generate a LOCATIONCHANGE for it, but not for the menu bar,
 * title bar, scrollbars, etc.  that are also changing shape/moving.
 *
 * In other words, it only generates LOCATIONCHANGE notifications for
 * real windows that are moving/sizing.  It will not generate a LOCATIONCHANGE
 * for every non-floating child window when the parent moves (the children are
 * logically moving also on screen, but not relative to the parent).
 *
 * Now, if the app itself resizes child windows as a result of being
 * sized, USER will generate LOCATIONCHANGEs for those dudes also because
 * it doesn't know better.
 *
 * Note also that USER will generate LOCATIONCHANGE notifications for two
 * non-window sys objects:
 *      (1) System caret
 *      (2) Cursor
 */

#define EVENT_OBJECT_NAMECHANGE             0x800C  // hwnd + ID + idChild is item w/ name change
#define EVENT_OBJECT_DESCRIPTIONCHANGE      0x800D  // hwnd + ID + idChild is item w/ desc change
#define EVENT_OBJECT_VALUECHANGE            0x800E  // hwnd + ID + idChild is item w/ value change
#define EVENT_OBJECT_PARENTCHANGE           0x800F  // hwnd + ID + idChild is item w/ new parent
#define EVENT_OBJECT_HELPCHANGE             0x8010  // hwnd + ID + idChild is item w/ help change
#define EVENT_OBJECT_DEFACTIONCHANGE        0x8011  // hwnd + ID + idChild is item w/ def action change
#define EVENT_OBJECT_ACCELERATORCHANGE      0x8012  // hwnd + ID + idChild is item w/ keybd accel change

#if(_WIN32_WINNT >= 0x0600)
#define EVENT_OBJECT_INVOKED                0x8013  // hwnd + ID + idChild is item invoked
#define EVENT_OBJECT_TEXTSELECTIONCHANGED   0x8014  // hwnd + ID + idChild is item w? test selection change

/*
 * EVENT_OBJECT_CONTENTSCROLLED
 * Sent when ending the scrolling of a window object.
 *
 * Unlike the similar event (EVENT_SYSTEM_SCROLLEND), this event will be
 * associated with the scrolling window itself. There is no difference
 * between horizontal or vertical scrolling.
 *
 * This event should be posted whenever scroll action is completed, including
 * when it is scrolled by scroll bars, mouse wheel, or keyboard navigations.
 *
 *   example:
 *          hwnd == window that is scrolling
 *          idObject == OBJID_CLIENT
 *          idChild == CHILDID_SELF
 */
#define EVENT_OBJECT_CONTENTSCROLLED        0x8015
#endif /* _WIN32_WINNT >= 0x0600 */

#if(_WIN32_WINNT >= 0x0601)
#define EVENT_SYSTEM_ARRANGMENTPREVIEW      0x8016
#endif /* _WIN32_WINNT >= 0x0601 */

#if(_WIN32_WINNT >= 0x0602)

/*
 * EVENT_OBJECT_CLOAKED / UNCLOAKED
 * Sent when a window is cloaked or uncloaked.
 * A cloaked window still exists, but is invisible to
 * the user.
 */
#define EVENT_OBJECT_CLOAKED                0x8017
#define EVENT_OBJECT_UNCLOAKED              0x8018

/*
 * EVENT_OBJECT_LIVEREGIONCHANGED
 * Sent when an object that is part of a live region
 * changes.  A live region is an area of an application
 * that changes frequently and/or asynchronously, so
 * that an assistive technology tool might want to pay
 * special attention to it.
 */
#define EVENT_OBJECT_LIVEREGIONCHANGED      0x8019

/*
 * EVENT_OBJECT_HOSTEDOBJECTSINVALIDATED
 * Sent when a window that is hosting other Accessible
 * objects changes the hosted objects.  A client may
 * wish to requery to see what the new hosted objects are,
 * especially if it has been monitoring events from this
 * window.  A hosted object is one with a different Accessibility
 * framework (MSAA or UI Automation) from its host.
 *
 * Changes in hosted objects with the *same* framework
 * as the parent should be handed with the usual structural
 * change events, such as EVENT_OBJECT_CREATED for MSAA.
 * see above.
 */
#define EVENT_OBJECT_HOSTEDOBJECTSINVALIDATED 0x8020

/*
 * Drag / Drop Events
 * These events are used in conjunction with the
 * UI Automation Drag/Drop patterns.
 *
 * For DRAGSTART, DRAGCANCEL, and DRAGCOMPLETE,
 * HWND+objectID+childID refers to the object being dragged.
 *
 * For DRAGENTER, DRAGLEAVE, and DRAGDROPPED,
 * HWND+objectID+childID refers to the target of the drop
 * that is being hovered over.
 */

#define EVENT_OBJECT_DRAGSTART              0x8021
#define EVENT_OBJECT_DRAGCANCEL             0x8022
#define EVENT_OBJECT_DRAGCOMPLETE           0x8023

#define EVENT_OBJECT_DRAGENTER              0x8024
#define EVENT_OBJECT_DRAGLEAVE              0x8025
#define EVENT_OBJECT_DRAGDROPPED            0x8026

/*
 * EVENT_OBJECT_IME_SHOW/HIDE
 * Sent by an IME window when it has become visible or invisible.
 */
#define EVENT_OBJECT_IME_SHOW               0x8027
#define EVENT_OBJECT_IME_HIDE               0x8028

/*
 * EVENT_OBJECT_IME_CHANGE
 * Sent by an IME window whenever it changes size or position.
 */
#define EVENT_OBJECT_IME_CHANGE             0x8029

#define EVENT_OBJECT_TEXTEDIT_CONVERSIONTARGETCHANGED 0x8030

#endif /* _WIN32_WINNT >= 0x0602 */

#if(_WIN32_WINNT >= 0x0601)
#define EVENT_OBJECT_END                    0x80FF

#define EVENT_AIA_START                     0xA000
#define EVENT_AIA_END                       0xAFFF
#endif /* _WIN32_WINNT >= 0x0601 */


/*
 * Child IDs
 */


/*
 * System Sounds (idChild of system SOUND notification)
 */
#define SOUND_SYSTEM_STARTUP            1
#define SOUND_SYSTEM_SHUTDOWN           2
#define SOUND_SYSTEM_BEEP               3
#define SOUND_SYSTEM_ERROR              4
#define SOUND_SYSTEM_QUESTION           5
#define SOUND_SYSTEM_WARNING            6
#define SOUND_SYSTEM_INFORMATION        7
#define SOUND_SYSTEM_MAXIMIZE           8
#define SOUND_SYSTEM_MINIMIZE           9
#define SOUND_SYSTEM_RESTOREUP          10
#define SOUND_SYSTEM_RESTOREDOWN        11
#define SOUND_SYSTEM_APPSTART           12
#define SOUND_SYSTEM_FAULT              13
#define SOUND_SYSTEM_APPEND             14
#define SOUND_SYSTEM_MENUCOMMAND        15
#define SOUND_SYSTEM_MENUPOPUP          16
#define CSOUND_SYSTEM                   16

/*
 * System Alerts (indexChild of system ALERT notification)
 */
#define ALERT_SYSTEM_INFORMATIONAL      1       // MB_INFORMATION
#define ALERT_SYSTEM_WARNING            2       // MB_WARNING
#define ALERT_SYSTEM_ERROR              3       // MB_ERROR
#define ALERT_SYSTEM_QUERY              4       // MB_QUESTION
#define ALERT_SYSTEM_CRITICAL           5       // HardSysErrBox
#define CALERT_SYSTEM                   6

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

typedef struct tagGUITHREADINFO
{
    DWORD   cbSize;
    DWORD   flags;
    HWND    hwndActive;
    HWND    hwndFocus;
    HWND    hwndCapture;
    HWND    hwndMenuOwner;
    HWND    hwndMoveSize;
    HWND    hwndCaret;
    RECT    rcCaret;
} GUITHREADINFO, *PGUITHREADINFO, * LPGUITHREADINFO;

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#define GUI_CARETBLINKING   0x00000001
#define GUI_INMOVESIZE      0x00000002
#define GUI_INMENUMODE      0x00000004
#define GUI_SYSTEMMENUMODE  0x00000008
#define GUI_POPUPMENUMODE   0x00000010
#if(_WIN32_WINNT >= 0x0501)
#if defined(_WIN64)
#define GUI_16BITTASK       0x00000000
#else
#define GUI_16BITTASK       0x00000020
#endif
#endif /* _WIN32_WINNT >= 0x0501 */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


BOOL
__stdcall
GetGUIThreadInfo(
     DWORD idThread,
     PGUITHREADINFO pgui);


BOOL
__stdcall
BlockInput(
    BOOL fBlockIt);

#if(_WIN32_WINNT >= 0x0600)

#define USER_DEFAULT_SCREEN_DPI 96


BOOL
__stdcall
SetProcessDPIAware(
    VOID);


BOOL
__stdcall
IsProcessDPIAware(
    VOID);

#endif /* _WIN32_WINNT >= 0x0600 */

#if(WINVER >= 0x0605)

DPI_AWARENESS_CONTEXT
__stdcall
SetThreadDpiAwarenessContext(
     DPI_AWARENESS_CONTEXT dpiContext);


DPI_AWARENESS_CONTEXT
__stdcall
GetThreadDpiAwarenessContext();


DPI_AWARENESS_CONTEXT
__stdcall
GetWindowDpiAwarenessContext(
     HWND hwnd);


DPI_AWARENESS
__stdcall
GetAwarenessFromDpiAwarenessContext(
     DPI_AWARENESS_CONTEXT value);


BOOL
__stdcall
AreDpiAwarenessContextsEqual(
     DPI_AWARENESS_CONTEXT dpiContextA,
     DPI_AWARENESS_CONTEXT dpiContextB);


BOOL
__stdcall
IsValidDpiAwarenessContext(
     DPI_AWARENESS_CONTEXT value);


UINT
__stdcall
GetDpiForWindow(
     HWND hwnd);


UINT
__stdcall
GetDpiForSystem();


BOOL
__stdcall
EnableNonClientDpiScaling(
     HWND hwnd);


BOOL
__stdcall
InheritWindowMonitor(
     HWND hwnd,
     HWND hwndInherit);

#endif /* WINVER >= 0x0605 */



UINT
__stdcall
GetWindowModuleFileNameA(
     HWND hwnd,
    _Out_writes_to_(cchFileNameMax, return) LPSTR pszFileName,
     UINT cchFileNameMax);

UINT
__stdcall
GetWindowModuleFileNameW(
     HWND hwnd,
    _Out_writes_to_(cchFileNameMax, return) LPWSTR pszFileName,
     UINT cchFileNameMax);
#ifdef UNICODE
#define GetWindowModuleFileName  GetWindowModuleFileNameW
#else
#define GetWindowModuleFileName  GetWindowModuleFileNameA
#endif // !UNICODE

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

#ifndef NO_STATE_FLAGS
#define STATE_SYSTEM_UNAVAILABLE        0x00000001  // Disabled
#define STATE_SYSTEM_SELECTED           0x00000002
#define STATE_SYSTEM_FOCUSED            0x00000004
#define STATE_SYSTEM_PRESSED            0x00000008
#define STATE_SYSTEM_CHECKED            0x00000010
#define STATE_SYSTEM_MIXED              0x00000020  // 3-state checkbox or toolbar button
#define STATE_SYSTEM_INDETERMINATE      STATE_SYSTEM_MIXED
#define STATE_SYSTEM_READONLY           0x00000040
#define STATE_SYSTEM_HOTTRACKED         0x00000080
#define STATE_SYSTEM_DEFAULT            0x00000100
#define STATE_SYSTEM_EXPANDED           0x00000200
#define STATE_SYSTEM_COLLAPSED          0x00000400
#define STATE_SYSTEM_BUSY               0x00000800
#define STATE_SYSTEM_FLOATING           0x00001000  // Children "owned" not "contained" by parent
#define STATE_SYSTEM_MARQUEED           0x00002000
#define STATE_SYSTEM_ANIMATED           0x00004000
#define STATE_SYSTEM_INVISIBLE          0x00008000
#define STATE_SYSTEM_OFFSCREEN          0x00010000
#define STATE_SYSTEM_SIZEABLE           0x00020000
#define STATE_SYSTEM_MOVEABLE           0x00040000
#define STATE_SYSTEM_SELFVOICING        0x00080000
#define STATE_SYSTEM_FOCUSABLE          0x00100000
#define STATE_SYSTEM_SELECTABLE         0x00200000
#define STATE_SYSTEM_LINKED             0x00400000
#define STATE_SYSTEM_TRAVERSED          0x00800000
#define STATE_SYSTEM_MULTISELECTABLE    0x01000000  // Supports multiple selection
#define STATE_SYSTEM_EXTSELECTABLE      0x02000000  // Supports extended selection
#define STATE_SYSTEM_ALERT_LOW          0x04000000  // This information is of low priority
#define STATE_SYSTEM_ALERT_MEDIUM       0x08000000  // This information is of medium priority
#define STATE_SYSTEM_ALERT_HIGH         0x10000000  // This information is of high priority
#define STATE_SYSTEM_PROTECTED          0x20000000  // access to this is restricted
#define STATE_SYSTEM_VALID              0x3FFFFFFF
#endif

#define CCHILDREN_TITLEBAR              5
#define CCHILDREN_SCROLLBAR             5

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

/*
 * Information about the global cursor.
 */
typedef struct tagCURSORINFO
{
    DWORD   cbSize;
    DWORD   flags;
    HCURSOR hCursor;
    POINT   ptScreenPos;
} CURSORINFO, *PCURSORINFO, *LPCURSORINFO;

#define CURSOR_SHOWING     0x00000001
#if(WINVER >= 0x0602)
#define CURSOR_SUPPRESSED  0x00000002
#endif /* WINVER >= 0x0602 */


BOOL
__stdcall
GetCursorInfo(
     PCURSORINFO pci);

/*
 * Window information snapshot
 */
typedef struct tagWINDOWINFO
{
    DWORD cbSize;
    RECT rcWindow;
    RECT rcClient;
    DWORD dwStyle;
    DWORD dwExStyle;
    DWORD dwWindowStatus;
    UINT cxWindowBorders;
    UINT cyWindowBorders;
    ATOM atomWindowType;
    WORD wCreatorVersion;
} WINDOWINFO, *PWINDOWINFO, *LPWINDOWINFO;

#define WS_ACTIVECAPTION    0x0001


BOOL
__stdcall
GetWindowInfo(
     HWND hwnd,
     PWINDOWINFO pwi);

/*
 * Titlebar information.
 */
typedef struct tagTITLEBARINFO
{
    DWORD cbSize;
    RECT rcTitleBar;
    DWORD rgstate[CCHILDREN_TITLEBAR + 1];
} TITLEBARINFO, *PTITLEBARINFO, *LPTITLEBARINFO;


BOOL
__stdcall
GetTitleBarInfo(
     HWND hwnd,
     PTITLEBARINFO pti);

#if(WINVER >= 0x0600)
typedef struct tagTITLEBARINFOEX
{
    DWORD cbSize;
    RECT rcTitleBar;
    DWORD rgstate[CCHILDREN_TITLEBAR + 1];
    RECT rgrect[CCHILDREN_TITLEBAR + 1];
} TITLEBARINFOEX, *PTITLEBARINFOEX, *LPTITLEBARINFOEX;
#endif /* WINVER >= 0x0600 */

/*
 * Menubar information
 */
typedef struct tagMENUBARINFO
{
    DWORD cbSize;
    RECT rcBar;          // rect of bar, popup, item
    HMENU hMenu;         // real menu handle of bar, popup
    HWND hwndMenu;       // hwnd of item submenu if one
    BOOL fBarFocused:1;  // bar, popup has the focus
    BOOL fFocused:1;     // item has the focus
} MENUBARINFO, *PMENUBARINFO, *LPMENUBARINFO;


BOOL
__stdcall
GetMenuBarInfo(
     HWND hwnd,
     LONG idObject,
     LONG idItem,
     PMENUBARINFO pmbi);

/*
 * Scrollbar information
 */
typedef struct tagSCROLLBARINFO
{
    DWORD cbSize;
    RECT rcScrollBar;
    int dxyLineButton;
    int xyThumbTop;
    int xyThumbBottom;
    int reserved;
    DWORD rgstate[CCHILDREN_SCROLLBAR + 1];
} SCROLLBARINFO, *PSCROLLBARINFO, *LPSCROLLBARINFO;


BOOL
__stdcall
GetScrollBarInfo(
     HWND hwnd,
     LONG idObject,
     PSCROLLBARINFO psbi);

/*
 * Combobox information
 */
typedef struct tagCOMBOBOXINFO
{
    DWORD cbSize;
    RECT rcItem;
    RECT rcButton;
    DWORD stateButton;
    HWND hwndCombo;
    HWND hwndItem;
    HWND hwndList;
} COMBOBOXINFO, *PCOMBOBOXINFO, *LPCOMBOBOXINFO;


BOOL
__stdcall
GetComboBoxInfo(
     HWND hwndCombo,
     PCOMBOBOXINFO pcbi);

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/*
 * The "real" ancestor window
 */
#define     GA_PARENT       1
#define     GA_ROOT         2
#define     GA_ROOTOWNER    3

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)


HWND
__stdcall
GetAncestor(
     HWND hwnd,
     UINT gaFlags);


/*
 * This gets the REAL child window at the point.  If it is in the dead
 * space of a group box, it will try a sibling behind it.  But static
 * fields will get returned.  In other words, it is kind of a cross between
 * ChildWindowFromPointEx and WindowFromPoint.
 */

HWND
__stdcall
RealChildWindowFromPoint(
     HWND hwndParent,
     POINT ptParentClientCoords);


/*
 * This gets the name of the window TYPE, not class.  This allows us to
 * recognize ThunderButton32 et al.
 */

UINT
__stdcall
RealGetWindowClassA(
     HWND hwnd,
    _Out_writes_to_(cchClassNameMax, return) LPSTR ptszClassName,
     UINT cchClassNameMax);
/*
 * This gets the name of the window TYPE, not class.  This allows us to
 * recognize ThunderButton32 et al.
 */

UINT
__stdcall
RealGetWindowClassW(
     HWND hwnd,
    _Out_writes_to_(cchClassNameMax, return) LPWSTR ptszClassName,
     UINT cchClassNameMax);
#ifdef UNICODE
#define RealGetWindowClass  RealGetWindowClassW
#else
#define RealGetWindowClass  RealGetWindowClassA
#endif // !UNICODE

/*
 * Alt-Tab Switch window information.
 */
typedef struct tagALTTABINFO
{
    DWORD cbSize;
    int cItems;
    int cColumns;
    int cRows;
    int iColFocus;
    int iRowFocus;
    int cxItem;
    int cyItem;
    POINT ptStart;
} ALTTABINFO, *PALTTABINFO, *LPALTTABINFO;


BOOL
__stdcall
GetAltTabInfoA(
     HWND hwnd,
     int iItem,
     PALTTABINFO pati,
    _Out_writes_opt_(cchItemText) LPSTR pszItemText,
     UINT cchItemText);

BOOL
__stdcall
GetAltTabInfoW(
     HWND hwnd,
     int iItem,
     PALTTABINFO pati,
    _Out_writes_opt_(cchItemText) LPWSTR pszItemText,
     UINT cchItemText);
#ifdef UNICODE
#define GetAltTabInfo  GetAltTabInfoW
#else
#define GetAltTabInfo  GetAltTabInfoA
#endif // !UNICODE

/*
 * Listbox information.
 * Returns the number of items per row.
 */

DWORD
__stdcall
GetListBoxInfo(
     HWND hwnd);

BOOL
__stdcall
LockWorkStation(
    VOID);



BOOL
__stdcall
UserHandleGrantAccess(
     HANDLE hUserHandle,
     HANDLE hJob,
     BOOL   bGrant);
--]=]



-- Raw Input Messages.
DECLARE_HANDLE("HRAWINPUT");

--[[
/*
 * WM_INPUT wParam
 */


 * Use this macro to get the input code from wParam.
--]]
function exports.GET_RAWINPUT_CODE_WPARAM(wParam)    return band(wParam, 0xff) end

ffi.cdef[[
static const int RIM_INPUT      = 0;
static const int  RIM_INPUTSINK  = 1;

/*
 * Raw Input data header
 */
typedef struct tagRAWINPUTHEADER {
    DWORD dwType;
    DWORD dwSize;
    HANDLE hDevice;
    WPARAM wParam;
} RAWINPUTHEADER, *PRAWINPUTHEADER, *LPRAWINPUTHEADER;


/*
 * Type of the raw input
 */
static const int  RIM_TYPEMOUSE       =0;
static const int  RIM_TYPEKEYBOARD    =1;
static const int  RIM_TYPEHID         =2;
static const int  RIM_TYPEMAX         =2;



/*
 * Raw format of the mouse input
 */
typedef struct tagRAWMOUSE {
    /*
     * Indicator flags.
     */
    USHORT usFlags;

    /*
     * The transition state of the mouse buttons.
     */
    union {
        ULONG ulButtons;
        struct  {
            USHORT  usButtonFlags;
            USHORT  usButtonData;
        } ;
    } ;


    /*
     * The raw state of the mouse buttons.
     */
    ULONG ulRawButtons;

    /*
     * The signed relative or absolute motion in the X direction.
     */
    LONG lLastX;

    /*
     * The signed relative or absolute motion in the Y direction.
     */
    LONG lLastY;

    /*
     * Device-specific additional information for the event.
     */
    ULONG ulExtraInformation;

} RAWMOUSE, *PRAWMOUSE, *LPRAWMOUSE;
]]

--[=[
/*
 * Define the mouse button state indicators.
 */

#define RI_MOUSE_LEFT_BUTTON_DOWN   0x0001  // Left Button changed to down.
#define RI_MOUSE_LEFT_BUTTON_UP     0x0002  // Left Button changed to up.
#define RI_MOUSE_RIGHT_BUTTON_DOWN  0x0004  // Right Button changed to down.
#define RI_MOUSE_RIGHT_BUTTON_UP    0x0008  // Right Button changed to up.
#define RI_MOUSE_MIDDLE_BUTTON_DOWN 0x0010  // Middle Button changed to down.
#define RI_MOUSE_MIDDLE_BUTTON_UP   0x0020  // Middle Button changed to up.

#define RI_MOUSE_BUTTON_1_DOWN      RI_MOUSE_LEFT_BUTTON_DOWN
#define RI_MOUSE_BUTTON_1_UP        RI_MOUSE_LEFT_BUTTON_UP
#define RI_MOUSE_BUTTON_2_DOWN      RI_MOUSE_RIGHT_BUTTON_DOWN
#define RI_MOUSE_BUTTON_2_UP        RI_MOUSE_RIGHT_BUTTON_UP
#define RI_MOUSE_BUTTON_3_DOWN      RI_MOUSE_MIDDLE_BUTTON_DOWN
#define RI_MOUSE_BUTTON_3_UP        RI_MOUSE_MIDDLE_BUTTON_UP

#define RI_MOUSE_BUTTON_4_DOWN      0x0040
#define RI_MOUSE_BUTTON_4_UP        0x0080
#define RI_MOUSE_BUTTON_5_DOWN      0x0100
#define RI_MOUSE_BUTTON_5_UP        0x0200

/*
 * If usButtonFlags has RI_MOUSE_WHEEL, the wheel delta is stored in usButtonData.
 * Take it as a signed value.
 */
#define RI_MOUSE_WHEEL              0x0400
#define RI_MOUSE_HWHEEL             0x0800


/*
 * Define the mouse indicator flags.
 */
#define MOUSE_MOVE_RELATIVE         0
#define MOUSE_MOVE_ABSOLUTE         1
#define MOUSE_VIRTUAL_DESKTOP    0x02  // the coordinates are mapped to the virtual desktop
#define MOUSE_ATTRIBUTES_CHANGED 0x04  // requery for mouse attributes
#define MOUSE_MOVE_NOCOALESCE    0x08  // do not coalesce mouse moves
--]=]

ffi.cdef[[
/*
 * Raw format of the keyboard input
 */
typedef struct tagRAWKEYBOARD {
    USHORT MakeCode;
    USHORT Flags;

    USHORT Reserved;

    USHORT VKey;
    UINT   Message;

    ULONG ExtraInformation;
} RAWKEYBOARD, *PRAWKEYBOARD, *LPRAWKEYBOARD;
]]

ffi.cdef[[
/*
 * Define the keyboard overrun MakeCode.
 */

static const int KEYBOARD_OVERRUN_MAKE_CODE   = 0xFF;

/*
 * Define the keyboard input data Flags.
 */
static const int RI_KEY_MAKE            = 0;
static const int RI_KEY_BREAK           = 1;
static const int RI_KEY_E0              = 2;
static const int RI_KEY_E1              = 4;
static const int RI_KEY_TERMSRV_SET_LED = 8;
static const int RI_KEY_TERMSRV_SHADOW  = 0x10;
]]

ffi.cdef[[
/*
 * Raw format of the input from Human Input Devices
 */
typedef struct tagRAWHID {
    DWORD dwSizeHid;    // byte size of each report
    DWORD dwCount;      // number of input packed
    BYTE bRawData[1];
} RAWHID, *PRAWHID, *LPRAWHID;


/*
 * RAWINPUT data structure.
 */
typedef struct tagRAWINPUT {
    RAWINPUTHEADER header;
    union {
        RAWMOUSE    mouse;
        RAWKEYBOARD keyboard;
        RAWHID      hid;
    } data;
} RAWINPUT, *PRAWINPUT, *LPRAWINPUT;
]]

--[=[
#ifdef _WIN64
#define RAWINPUT_ALIGN(x)   (((x) + sizeof(QWORD) - 1) & ~(sizeof(QWORD) - 1))
#else   // _WIN64
#define RAWINPUT_ALIGN(x)   (((x) + sizeof(DWORD) - 1) & ~(sizeof(DWORD) - 1))
#endif  // _WIN64

#define NEXTRAWINPUTBLOCK(ptr) ((PRAWINPUT)RAWINPUT_ALIGN((ULONG_PTR)((PBYTE)(ptr) + (ptr)->header.dwSize)))
--]=]

ffi.cdef[[
/*
 * Flags for GetRawInputData
 */

static const int RID_INPUT             =  0x10000003;
static const int RID_HEADER            =  0x10000005;

UINT
__stdcall
GetRawInputData(
     HRAWINPUT hRawInput,
     UINT uiCommand,
    LPVOID pData,
     PUINT pcbSize,
     UINT cbSizeHeader);
]]

ffi.cdef[[
/*
 * Raw Input Device Information
 */
static const int RIDI_PREPARSEDDATA      =0x20000005;
static const int RIDI_DEVICENAME         =0x20000007;  // the return valus is the character length, not the byte size
static const int RIDI_DEVICEINFO         =0x2000000b;

typedef struct tagRID_DEVICE_INFO_MOUSE {
    DWORD dwId;
    DWORD dwNumberOfButtons;
    DWORD dwSampleRate;
    BOOL  fHasHorizontalWheel;
} RID_DEVICE_INFO_MOUSE, *PRID_DEVICE_INFO_MOUSE;

typedef struct tagRID_DEVICE_INFO_KEYBOARD {
    DWORD dwType;
    DWORD dwSubType;
    DWORD dwKeyboardMode;
    DWORD dwNumberOfFunctionKeys;
    DWORD dwNumberOfIndicators;
    DWORD dwNumberOfKeysTotal;
} RID_DEVICE_INFO_KEYBOARD, *PRID_DEVICE_INFO_KEYBOARD;

typedef struct tagRID_DEVICE_INFO_HID {
    DWORD dwVendorId;
    DWORD dwProductId;
    DWORD dwVersionNumber;

    /*
     * Top level collection UsagePage and Usage
     */
    USHORT usUsagePage;
    USHORT usUsage;
} RID_DEVICE_INFO_HID, *PRID_DEVICE_INFO_HID;

typedef struct tagRID_DEVICE_INFO {
    DWORD cbSize;
    DWORD dwType;
    union {
        RID_DEVICE_INFO_MOUSE mouse;
        RID_DEVICE_INFO_KEYBOARD keyboard;
        RID_DEVICE_INFO_HID hid;
    };
} RID_DEVICE_INFO, *PRID_DEVICE_INFO, *LPRID_DEVICE_INFO;


UINT
__stdcall
GetRawInputDeviceInfoA(
     HANDLE hDevice,
     UINT uiCommand,
    LPVOID pData,
     PUINT pcbSize);

UINT
__stdcall
GetRawInputDeviceInfoW(
     HANDLE hDevice,
     UINT uiCommand,
    LPVOID pData,
     PUINT pcbSize);
]]

exports.GetRawInputDeviceInfoA = exports.Lib.GetRawInputDeviceInfoA
exports.GetRawInputDeviceInfo  = exports.GetRawInputDeviceInfoA;

if UNICODE then
exports.GetRawInputDeviceInfo  = exports.Lib.GetRawInputDeviceInfoW;
end


ffi.cdef[[
/*
 * Raw Input Bulk Read: GetRawInputBuffer
 */

UINT
__stdcall
GetRawInputBuffer(
    PRAWINPUT pData,
     PUINT pcbSize,
     UINT cbSizeHeader);

/*
 * Raw Input request APIs
 */
typedef struct tagRAWINPUTDEVICE {
    USHORT usUsagePage; // Toplevel collection UsagePage
    USHORT usUsage;     // Toplevel collection Usage
    DWORD dwFlags;
    HWND hwndTarget;    // Target hwnd. NULL = follows keyboard focus
} RAWINPUTDEVICE, *PRAWINPUTDEVICE, *LPRAWINPUTDEVICE;

typedef const RAWINPUTDEVICE* PCRAWINPUTDEVICE;
]]

--[=[
#define RIDEV_REMOVE            0x00000001
#define RIDEV_EXCLUDE           0x00000010
#define RIDEV_PAGEONLY          0x00000020
#define RIDEV_NOLEGACY          0x00000030
#define RIDEV_INPUTSINK         0x00000100
#define RIDEV_CAPTUREMOUSE      0x00000200  // effective when mouse nolegacy is specified, otherwise it would be an error
#define RIDEV_NOHOTKEYS         0x00000200  // effective for keyboard.
#define RIDEV_APPKEYS           0x00000400  // effective for keyboard.

#define RIDEV_EXINPUTSINK       0x00001000
#define RIDEV_DEVNOTIFY         0x00002000

#define RIDEV_EXMODEMASK        0x000000F0

#define RIDEV_EXMODE(mode)  ((mode) & RIDEV_EXMODEMASK)


#define GIDC_ARRIVAL             1
#define GIDC_REMOVAL             2



#define GET_DEVICE_CHANGE_WPARAM(wParam)  (LOWORD(wParam))

#define GET_DEVICE_CHANGE_LPARAM(lParam)  (LOWORD(lParam))
--]=]


ffi.cdef[[
BOOL
__stdcall
RegisterRawInputDevices(
    PCRAWINPUTDEVICE pRawInputDevices,
     UINT uiNumDevices,
     UINT cbSize);


UINT
__stdcall
GetRegisteredRawInputDevices(
    PRAWINPUTDEVICE pRawInputDevices,
     PUINT puiNumDevices,
     UINT cbSize);
]]

ffi.cdef[[
typedef struct tagRAWINPUTDEVICELIST {
    HANDLE hDevice;
    DWORD dwType;
} RAWINPUTDEVICELIST, *PRAWINPUTDEVICELIST;


UINT
__stdcall
GetRawInputDeviceList(
    PRAWINPUTDEVICELIST pRawInputDeviceList,
     PUINT puiNumDevices,
     UINT cbSize);


LRESULT
__stdcall
DefRawInputProc(
    PRAWINPUT* paRawInput,
     INT nInput,
     UINT cbSizeHeader);
]]



ffi.cdef[[
static const int POINTER_DEVICE_PRODUCT_STRING_MAX = 520;
/*
 * wParam values for WM_POINTERDEVICECHANGE
 */
static const int PDC_ARRIVAL                   = 0x001;
static const int PDC_REMOVAL                   = 0x002;
static const int PDC_ORIENTATION_0             = 0x004;
static const int PDC_ORIENTATION_90            = 0x008;
static const int PDC_ORIENTATION_180           = 0x010;
static const int PDC_ORIENTATION_270           = 0x020;
static const int PDC_MODE_DEFAULT              = 0x040;
static const int PDC_MODE_CENTERED             = 0x080;
static const int PDC_MAPPING_CHANGE            = 0x100;
static const int PDC_RESOLUTION                = 0x200;
static const int PDC_ORIGIN                    = 0x400;
static const int PDC_MODE_ASPECTRATIOPRESERVED = 0x800;
]]

ffi.cdef[[
typedef enum tagPOINTER_DEVICE_TYPE {
    POINTER_DEVICE_TYPE_INTEGRATED_PEN = 0x00000001,
    POINTER_DEVICE_TYPE_EXTERNAL_PEN   = 0x00000002,
    POINTER_DEVICE_TYPE_TOUCH          = 0x00000003,
    POINTER_DEVICE_TYPE_TOUCH_PAD      = 0x00000004,
    POINTER_DEVICE_TYPE_MAX            = 0xFFFFFFFF
} POINTER_DEVICE_TYPE;

typedef struct tagPOINTER_DEVICE_INFO {
    DWORD displayOrientation;
    HANDLE device;
    POINTER_DEVICE_TYPE pointerDeviceType;
    HMONITOR monitor;
    ULONG startingCursorId;
    USHORT maxActiveContacts;
    WCHAR productString[POINTER_DEVICE_PRODUCT_STRING_MAX];
} POINTER_DEVICE_INFO;

typedef struct tagPOINTER_DEVICE_PROPERTY {
    INT32 logicalMin;
    INT32 logicalMax;
    INT32 physicalMin;
    INT32 physicalMax;
    UINT32 unit;
    UINT32 unitExponent;
    USHORT usagePageId;
    USHORT usageId;
} POINTER_DEVICE_PROPERTY;

typedef enum tagPOINTER_DEVICE_CURSOR_TYPE {
    POINTER_DEVICE_CURSOR_TYPE_UNKNOWN   = 0x00000000,
    POINTER_DEVICE_CURSOR_TYPE_TIP       = 0x00000001,
    POINTER_DEVICE_CURSOR_TYPE_ERASER    = 0x00000002,
    POINTER_DEVICE_CURSOR_TYPE_MAX       = 0xFFFFFFFF
} POINTER_DEVICE_CURSOR_TYPE;

typedef struct tagPOINTER_DEVICE_CURSOR_INFO {
    UINT32 cursorId;
    POINTER_DEVICE_CURSOR_TYPE cursor;
} POINTER_DEVICE_CURSOR_INFO;
]]

ffi.cdef[[
BOOL
__stdcall
GetPointerDevices(
     UINT32* deviceCount,
    POINTER_DEVICE_INFO *pointerDevices);


BOOL
__stdcall
GetPointerDevice(
    HANDLE device,
    POINTER_DEVICE_INFO *pointerDevice);


BOOL
__stdcall
GetPointerDeviceProperties(
     HANDLE device,
     UINT32* propertyCount,
    POINTER_DEVICE_PROPERTY *pointerProperties);


BOOL
__stdcall
RegisterPointerDeviceNotifications(
     HWND window,
     BOOL notifyRange);


BOOL
__stdcall
GetPointerDeviceRects(
     HANDLE device,
    RECT* pointerDeviceRect,
    RECT* displayRect);


BOOL
__stdcall
GetPointerDeviceCursors(
     HANDLE device,
     UINT32* cursorCount,
    POINTER_DEVICE_CURSOR_INFO *deviceCursors);


BOOL
__stdcall
GetRawPointerDeviceData(
     UINT32 pointerId,
     UINT32 historyCount,
     UINT32 propertiesCount,
    POINTER_DEVICE_PROPERTY* pProperties,
    LONG* pValues);
]]

ffi.cdef[[
/*
 * Message Filter
 */

static const int MSGFLT_ADD = 1;
static const int MSGFLT_REMOVE = 2;


BOOL
__stdcall
ChangeWindowMessageFilter(
     UINT message,
     DWORD dwFlag);


/*
 * Message filter info values (CHANGEFILTERSTRUCT.ExtStatus)
 */
static const int MSGFLTINFO_NONE                        = 0;
static const int MSGFLTINFO_ALREADYALLOWED_FORWND       = 1;
static const int MSGFLTINFO_ALREADYDISALLOWED_FORWND    = 2;
static const int MSGFLTINFO_ALLOWED_HIGHER              = 3;
]]

ffi.cdef[[
typedef struct tagCHANGEFILTERSTRUCT {
    DWORD cbSize;
    DWORD ExtStatus;
} CHANGEFILTERSTRUCT, *PCHANGEFILTERSTRUCT;
]]

ffi.cdef[[
/*
 * Message filter action values (action parameter to ChangeWindowMessageFilterEx)
 */
static const int MSGFLT_RESET                           = 0;
static const int MSGFLT_ALLOW                           = 1;
static const int MSGFLT_DISALLOW                        = 2;
]]

ffi.cdef[[
BOOL
__stdcall
ChangeWindowMessageFilterEx(
     HWND hwnd,                                         // Window
     UINT message,                                      // WM_ message
     DWORD action,                                      // Message filter action value
    PCHANGEFILTERSTRUCT pChangeFilterStruct);   // Optional
]]

--[=[
/*
 * Gesture defines and functions
 */


/*
 * Gesture information handle
 */
DECLARE_HANDLE(HGESTUREINFO);



/*
 * Gesture flags - GESTUREINFO.dwFlags
 */
#define GF_BEGIN                        0x00000001
#define GF_INERTIA                      0x00000002
#define GF_END                          0x00000004

/*
 * Gesture IDs
 */
#define GID_BEGIN                       1
#define GID_END                         2
#define GID_ZOOM                        3
#define GID_PAN                         4
#define GID_ROTATE                      5
#define GID_TWOFINGERTAP                6
#define GID_PRESSANDTAP                 7
#define GID_ROLLOVER                    GID_PRESSANDTAP


/*
 * Gesture information structure
 *   - Pass the HGESTUREINFO received in the WM_GESTURE message lParam into the
 *     GetGestureInfo function to retrieve this information.
 *   - If cbExtraArgs is non-zero, pass the HGESTUREINFO received in the WM_GESTURE
 *     message lParam into the GetGestureExtraArgs function to retrieve extended
 *     argument information.
 */
typedef struct tagGESTUREINFO {
    UINT cbSize;                    // size, in bytes, of this structure (including variable length Args field)
    DWORD dwFlags;                  // see GF_* flags
    DWORD dwID;                     // gesture ID, see GID_* defines
    HWND hwndTarget;                // handle to window targeted by this gesture
    POINTS ptsLocation;             // current location of this gesture
    DWORD dwInstanceID;             // internally used
    DWORD dwSequenceID;             // internally used
    ULONGLONG ullArguments;         // arguments for gestures whose arguments fit in 8 BYTES
    UINT cbExtraArgs;               // size, in bytes, of extra arguments, if any, that accompany this gesture
} GESTUREINFO, *PGESTUREINFO;
typedef GESTUREINFO const * PCGESTUREINFO;


/*
 * Gesture notification structure
 *   - The WM_GESTURENOTIFY message lParam contains a pointer to this structure.
 *   - The WM_GESTURENOTIFY message notifies a window that gesture recognition is
 *     in progress and a gesture will be generated if one is recognized under the
 *     current gesture settings.
 */
typedef struct tagGESTURENOTIFYSTRUCT {
    UINT cbSize;                    // size, in bytes, of this structure
    DWORD dwFlags;                  // unused
    HWND hwndTarget;                // handle to window targeted by the gesture
    POINTS ptsLocation;             // starting location
    DWORD dwInstanceID;             // internally used
} GESTURENOTIFYSTRUCT, *PGESTURENOTIFYSTRUCT;

/*
 * Gesture argument helpers
 *   - Angle should be a double in the range of -2pi to +2pi
 *   - Argument should be an unsigned 16-bit value
 */
#define GID_ROTATE_ANGLE_TO_ARGUMENT(_arg_)     ((USHORT)((((_arg_) + 2.0 * 3.14159265) / (4.0 * 3.14159265)) * 65535.0))
#define GID_ROTATE_ANGLE_FROM_ARGUMENT(_arg_)   ((((double)(_arg_) / 65535.0) * 4.0 * 3.14159265) - 2.0 * 3.14159265)

/*
 * Gesture information retrieval
 *   - HGESTUREINFO is received by a window in the lParam of a WM_GESTURE message.
 */

BOOL
__stdcall
GetGestureInfo(
     HGESTUREINFO hGestureInfo,
     PGESTUREINFO pGestureInfo);

/*
 * Gesture extra arguments retrieval
 *   - HGESTUREINFO is received by a window in the lParam of a WM_GESTURE message.
 *   - Size, in bytes, of the extra argument data is available in the cbExtraArgs
 *     field of the GESTUREINFO structure retrieved using the GetGestureInfo function.
 */

BOOL
__stdcall
GetGestureExtraArgs(
     HGESTUREINFO hGestureInfo,
     UINT cbExtraArgs,
    _Out_writes_bytes_(cbExtraArgs) PBYTE pExtraArgs);

/*
 * Gesture information handle management
 *   - If an application processes the WM_GESTURE message, then once it is done
 *     with the associated HGESTUREINFO, the application is responsible for
 *     closing the handle using this function. Failure to do so may result in
 *     process memory leaks.
 *   - If the message is instead passed to DefWindowProc, or is forwarded using
 *     one of the PostMessage or SendMessage class of API functions, the handle
 *     is transfered with the message and need not be closed by the application.
 */

BOOL
__stdcall
CloseGestureInfoHandle(
     HGESTUREINFO hGestureInfo);


/*
 * Gesture configuration structure
 *   - Used in SetGestureConfig and GetGestureConfig
 *   - Note that any setting not included in either GESTURECONFIG.dwWant or
 *     GESTURECONFIG.dwBlock will use the parent window's preferences or
 *     system defaults.
 */
typedef struct tagGESTURECONFIG {
    DWORD dwID;                     // gesture ID
    DWORD dwWant;                   // settings related to gesture ID that are to be turned on
    DWORD dwBlock;                  // settings related to gesture ID that are to be turned off
} GESTURECONFIG, *PGESTURECONFIG;

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion

/*
 * Gesture configuration flags - GESTURECONFIG.dwWant or GESTURECONFIG.dwBlock
 */

/*
 * Common gesture configuration flags - set GESTURECONFIG.dwID to zero
 */
#define GC_ALLGESTURES                              0x00000001

/*
 * Zoom gesture configuration flags - set GESTURECONFIG.dwID to GID_ZOOM
 */
#define GC_ZOOM                                     0x00000001

/*
 * Pan gesture configuration flags - set GESTURECONFIG.dwID to GID_PAN
 */
#define GC_PAN                                      0x00000001
#define GC_PAN_WITH_SINGLE_FINGER_VERTICALLY        0x00000002
#define GC_PAN_WITH_SINGLE_FINGER_HORIZONTALLY      0x00000004
#define GC_PAN_WITH_GUTTER                          0x00000008
#define GC_PAN_WITH_INERTIA                         0x00000010

/*
 * Rotate gesture configuration flags - set GESTURECONFIG.dwID to GID_ROTATE
 */
#define GC_ROTATE                                   0x00000001

/*
 * Two finger tap gesture configuration flags - set GESTURECONFIG.dwID to GID_TWOFINGERTAP
 */
#define GC_TWOFINGERTAP                             0x00000001

/*
 * PressAndTap gesture configuration flags - set GESTURECONFIG.dwID to GID_PRESSANDTAP
 */
#define GC_PRESSANDTAP                              0x00000001
#define GC_ROLLOVER                                 GC_PRESSANDTAP

#define GESTURECONFIGMAXCOUNT           256             // Maximum number of gestures that can be included
                                                        // in a single call to SetGestureConfig / GetGestureConfig



BOOL
__stdcall
SetGestureConfig(
     HWND hwnd,                                     // window for which configuration is specified
     DWORD dwReserved,                              // reserved, must be 0
     UINT cIDs,                                     // count of GESTURECONFIG structures
    _In_reads_(cIDs) PGESTURECONFIG pGestureConfig,    // array of GESTURECONFIG structures, dwIDs will be processed in the
                                                        // order specified and repeated occurances will overwrite previous ones
     UINT cbSize);                                  // sizeof(GESTURECONFIG)


#define GCF_INCLUDE_ANCESTORS           0x00000001      // If specified, GetGestureConfig returns consolidated configuration
                                                        // for the specified window and it's parent window chain


BOOL
__stdcall
GetGestureConfig(
     HWND hwnd,                                     // window for which configuration is required
     DWORD dwReserved,                              // reserved, must be 0
     DWORD dwFlags,                                 // see GCF_* flags
     PUINT pcIDs,                                   // *pcIDs contains the size, in number of GESTURECONFIG structures,
                                                        // of the buffer pointed to by pGestureConfig
   PGESTURECONFIG pGestureConfig,
                                                        // pointer to buffer to receive the returned array of GESTURECONFIG structures
     UINT cbSize);                                  // sizeof(GESTURECONFIG)
--]=]


ffi.cdef[[
/*
 * GetSystemMetrics(SM_DIGITIZER) flag values
 */
static const int NID_INTEGRATED_TOUCH  = 0x00000001;
static const int NID_EXTERNAL_TOUCH    = 0x00000002;
static const int NID_INTEGRATED_PEN    = 0x00000004;
static const int NID_EXTERNAL_PEN      = 0x00000008;
static const int NID_MULTI_INPUT       = 0x00000040;
static const int NID_READY             = 0x00000080;

static const int  MAX_STR_BLOCKREASON = 256;
]]


ffi.cdef[[
BOOL
__stdcall
ShutdownBlockReasonCreate(
     HWND hWnd,
     LPCWSTR pwszReason);


BOOL
__stdcall
ShutdownBlockReasonQuery(
     HWND hWnd,
    LPWSTR pwszBuff,
     DWORD *pcchBuff);


BOOL
__stdcall
ShutdownBlockReasonDestroy(
     HWND hWnd);
]]


ffi.cdef[[
/*
 * Identifiers for message input source device type.
 */
typedef enum tagINPUT_MESSAGE_DEVICE_TYPE  {
    IMDT_UNAVAILABLE        = 0x00000000,       // not specified
    IMDT_KEYBOARD           = 0x00000001,       // from keyboard
    IMDT_MOUSE              = 0x00000002,       // from mouse
    IMDT_TOUCH              = 0x00000004,       // from touch
    IMDT_PEN                = 0x00000008,       // from pen
    IMDT_TOUCHPAD           = 0x00000010,       // from touchpad
 } INPUT_MESSAGE_DEVICE_TYPE;



typedef enum tagINPUT_MESSAGE_ORIGIN_ID {
     IMO_UNAVAILABLE = 0x00000000,  // not specified
     IMO_HARDWARE    = 0x00000001,  // from a hardware device or injected by a UIAccess app
     IMO_INJECTED    = 0x00000002,  // injected via SendInput() by a non-UIAccess app
     IMO_SYSTEM      = 0x00000004,  // injected by the system
} INPUT_MESSAGE_ORIGIN_ID;

/*
 * Input source structure.
 */
 typedef struct tagINPUT_MESSAGE_SOURCE {
     INPUT_MESSAGE_DEVICE_TYPE deviceType;
     INPUT_MESSAGE_ORIGIN_ID   originId;
 } INPUT_MESSAGE_SOURCE;
]]

ffi.cdef[[
/*
 * API to determine the input source of the current messsage.
 */

BOOL
__stdcall
GetCurrentInputMessageSource(
     INPUT_MESSAGE_SOURCE *inputMessageSource);


BOOL
__stdcall
GetCIMSSM(
     INPUT_MESSAGE_SOURCE *inputMessageSource);
]]

ffi.cdef[[
/*
 * AutoRotation state structure
 */
typedef enum tagAR_STATE {
    AR_ENABLED        = 0x0,
    AR_DISABLED       = 0x1,
    AR_SUPPRESSED     = 0x2,
    AR_REMOTESESSION  = 0x4,
    AR_MULTIMON       = 0x8,
    AR_NOSENSOR       = 0x10,
    AR_NOT_SUPPORTED  = 0x20,
    AR_DOCKED         = 0x40,
    AR_LAPTOP         = 0x80
} AR_STATE, *PAR_STATE;
]]
--[[
// Don't define this for MIDL compiler passes over winuser.h. Some of them
// don't include winnt.h (where DEFINE_ENUM_FLAG_OPERATORS is defined and
// get compile errors.
DEFINE_ENUM_FLAG_OPERATORS(AR_STATE)
--]]



ffi.cdef[[
/*
 * Orientation preference structure. This is used by applications to specify
 * their orientation preferences to windows.
 */
typedef enum ORIENTATION_PREFERENCE {
    ORIENTATION_PREFERENCE_NONE              = 0x0,
    ORIENTATION_PREFERENCE_LANDSCAPE         = 0x1,
    ORIENTATION_PREFERENCE_PORTRAIT          = 0x2,
    ORIENTATION_PREFERENCE_LANDSCAPE_FLIPPED = 0x4,
    ORIENTATION_PREFERENCE_PORTRAIT_FLIPPED  = 0x8
} ORIENTATION_PREFERENCE;
]]

--[[
#ifndef MIDL_PASS
// Don't define this for MIDL compiler passes over winuser.h. Some of them
// don't include winnt.h (where DEFINE_ENUM_FLAG_OPERATORS is defined and
// get compile errors.
DEFINE_ENUM_FLAG_OPERATORS(ORIENTATION_PREFERENCE)
#endif
--]]

ffi.cdef[[
BOOL
__stdcall
GetAutoRotationState(
     PAR_STATE pState);


BOOL
__stdcall
GetDisplayAutoRotationPreferences(
     ORIENTATION_PREFERENCE *pOrientation);


BOOL
__stdcall
GetDisplayAutoRotationPreferencesByProcessId(
     DWORD dwProcessId,
     ORIENTATION_PREFERENCE *pOrientation,
     BOOL *fRotateScreen);


BOOL
__stdcall
SetDisplayAutoRotationPreferences(
     ORIENTATION_PREFERENCE orientation);
]]



ffi.cdef[[
BOOL
__stdcall
IsImmersiveProcess(
     HANDLE hProcess);


BOOL
__stdcall
SetProcessRestrictionExemption(
     BOOL fEnableExemption);
]]



exports.GetRawInputDeviceList = exports.Lib.GetRawInputDeviceList;
exports.GetPointerDevices = exports.Lib.GetPointerDevices;

return exports
