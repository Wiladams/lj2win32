-- user32_ffi.lua

local ffi = require "ffi"
local bit = require("bit")
local bor = bit.bor;
local band = bit.band;

require "win32.gdi32"
require "win32.wtypes"
local errorhandling = require("win32.core.errorhandling_l1_1_1");
local core_library = require("win32.core.libraryloader_l1_1_1");



-- Input handling
ffi.cdef[[
static const int MOUSEEVENTF_ABSOLUTE = 0x8000;
static const int MOUSEEVENTF_HWHEEL = 0x01000;
static const int MOUSEEVENTF_MOVE = 0x0001;
static const int MOUSEEVENTF_MOVE_NOCOALESCE = 0x2000;
static const int MOUSEEVENTF_LEFTDOWN = 0x0002;
static const int MOUSEEVENTF_LEFTUP = 0x0004;
static const int MOUSEEVENTF_RIGHTDOWN = 0x0008;
static const int MOUSEEVENTF_RIGHTUP = 0x0010;
static const int MOUSEEVENTF_MIDDLEDOWN = 0x0020;
static const int MOUSEEVENTF_MIDDLEUP = 0x0040;
static const int MOUSEEVENTF_VIRTUALDESK = 0x4000;
static const int MOUSEEVENTF_WHEEL = 0x0800;
static const int MOUSEEVENTF_XDOWN = 0x0080;
static const int MOUSEEVENTF_XUP = 0x0100;

typedef struct tagMOUSEINPUT {
  LONG      dx;
  LONG      dy;
  DWORD     mouseData;
  DWORD     dwFlags;
  DWORD     time;
  ULONG_PTR dwExtraInfo;
} MOUSEINPUT, *PMOUSEINPUT;

static const int KEYEVENTF_EXTENDEDKEY = 0x0001;
static const int KEYEVENTF_KEYUP = 0x0002;
static const int KEYEVENTF_SCANCODE = 0x0008;
static const int KEYEVENTF_UNICODE = 0x0004;

typedef struct tagKEYBDINPUT {
  WORD      wVk;
  WORD      wScan;
  DWORD     dwFlags;
  DWORD     time;
  ULONG_PTR dwExtraInfo;
} KEYBDINPUT, *PKEYBDINPUT;

typedef struct tagHARDWAREINPUT {
  DWORD uMsg;
  WORD  wParamL;
  WORD  wParamH;
} HARDWAREINPUT, *PHARDWAREINPUT;


static const int INPUT_MOUSE = 0;
static const int INPUT_KEYBOARD = 1;
static const int INPUT_HARDWARE = 2;

typedef struct tagINPUT {
  DWORD type;
  union {
    MOUSEINPUT    mi;
    KEYBDINPUT    ki;
    HARDWAREINPUT hi;
  };
} INPUT, *PINPUT;

UINT SendInput(
    UINT nInputs,
    PINPUT pInputs,
    int cbSize
);
]]


-- WINDOW CONSTRUCTION
ffi.cdef[[
typedef LRESULT (__stdcall *WNDPROC) (HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam);
typedef LRESULT (__stdcall *MsgProc) (HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

typedef struct {
    HWND hwnd;
    UINT message;
    WPARAM wParam;
    LPARAM lParam;
    DWORD time;
    POINT pt;
} MSG, *PMSG;

typedef struct {
    UINT style;
    WNDPROC lpfnWndProc;
    int cbClsExtra;
    int cbWndExtra;
    HINSTANCE hInstance;
    HICON hIcon;
    HCURSOR hCursor;
    HBRUSH hbrBackground;
    LPCSTR lpszMenuName;
    LPCSTR lpszClassName;
} WNDCLASSA, *PWNDCLASSA;

typedef struct {
    UINT cbSize;
    UINT style;
    WNDPROC lpfnWndProc;
    int cbClsExtra;
    int cbWndExtra;
    HINSTANCE hInstance;
    HICON hIcon;
    HCURSOR hCursor;
    HBRUSH hbrBackground;
    LPCSTR lpszMenuName;
    LPCSTR lpszClassName;
    HICON hIconSm;
} WNDCLASSEXA, *PWNDCLASSEXA;



typedef struct tagCREATESTRUCT {
    LPVOID lpCreateParams;
    HINSTANCE hInstance;
    HMENU hMenu;
    HWND hwndParent;
    int cy;
    int cx;
    int y;
    int x;
    LONG style;
    LPCSTR lpszName;
    LPCSTR lpszClass;
    DWORD dwExStyle;
} CREATESTRUCTA, *LPCREATESTRUCTA;

typedef struct {
    POINT ptReserved;
    POINT ptMaxSize;
    POINT ptMaxPosition;
    POINT ptMinTrackSize;
    POINT ptMaxTrackSize;
} MINMAXINFO, *PMINMAXINFO;

]]




-- Windows functions
ffi.cdef[[

DWORD MsgWaitForMultipleObjects(
	DWORD nCount,
	const HANDLE* pHandles,
	BOOL bWaitAll,
	DWORD dwMilliseconds);

DWORD MsgWaitForMultipleObjectsEx(
	DWORD nCount,
	const HANDLE* pHandles,
	DWORD dwMilliseconds,
	DWORD dwWakeMask,
	DWORD dwFlags
);

// PostMessage
BOOL PostMessage(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);

// PostQuitMessage
void PostQuitMessage(int nExitCode);

// PostThreadMessage
BOOL PostThreadMessageA(DWORD idThread, UINT Msg, WPARAM wParam, LPARAM lParam);

// SendMessage
int SendMessageA(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam);

// TranslateMessage
BOOL TranslateMessage(const MSG *lpMsg);

// DispatchMessage
LRESULT DispatchMessageA(const MSG *lpmsg);

// GetMessage
BOOL GetMessageA(PMSG lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax);

// GetMessageExtraInfo
LPARAM GetMessageExtraInfo(void);

// PeekMessage
BOOL PeekMessageA(PMSG lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax, UINT wRemoveMsg);

// WaitMessage
BOOL WaitMessage(void);
]]

ffi.cdef[[
BOOL
AdjustWindowRect(
    LPRECT lpRect,
    DWORD dwStyle,
    BOOL bMenu);

BOOL
AdjustWindowRectEx(
    LPRECT lpRect,
    DWORD dwStyle,
    BOOL bMenu,
    DWORD dwExStyle);

LRESULT CallWindowProc(WNDPROC lpPrevWndFunc, HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);

LRESULT DefWindowProcA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);


ATOM RegisterClassExA(const WNDCLASSEXA *lpwcx);
ATOM RegisterClassA(const WNDCLASSA *lpWndClass);

HWND CreateWindow(
		LPCSTR lpClassName,
		LPCSTR lpWindowName,
		DWORD dwStyle,
		int x,
		int y,
		int nWidth,
		int nHeight,
		HWND hWndParent,
		HMENU hMenu,
		HINSTANCE hInstance,
		LPVOID lpParam);

HWND CreateWindowExA(
	DWORD dwExStyle,
	const LPCSTR lpClassName,
	const LPCSTR lpWindowName,
	DWORD dwStyle,
	int x,
	int y,
	int nWidth,
	int nHeight,
	HWND hWndParent,
	HMENU hMenu,
	HINSTANCE hInstance,
	LPVOID lpParam
	);

BOOL DestroyWindow(HWND hWnd);

HWND GetDesktopWindow(void);


BOOL RedrawWindow(
  HWND hWnd,
  const RECT *lprcUpdate,
  HRGN hrgnUpdate,
  UINT flags
);

BOOL ShowWindow(HWND hWnd, int nCmdShow);

BOOL UpdateWindow(HWND hWnd);

BOOL MoveWindow(HWND hWnd,
  int X,
  int Y,
  int nWidth,
  int nHeight,
  BOOL bRepaint
);

HICON LoadIconA(HINSTANCE hInstance, LPCSTR lpIconName);

HCURSOR LoadCursorA(HINSTANCE hInstance, LPCSTR lpCursorName);

int GetClientRect(HWND hWnd, RECT *rect);


]]

-- System related calls
ffi.cdef[[
int GetSystemMetrics(int nIndex);
]]

ffi.cdef[[
BOOL SystemParametersInfoA(
  UINT  uiAction,
  UINT  uiParam,
  PVOID pvParam,
  UINT  fWinIni
);
]]

-- WINDOW DRAWING
ffi.cdef[[
HDC GetDC(HWND hWnd);

HDC GetWindowDC(HWND hWnd);
BOOL InvalidateRect(HWND hWnd, const RECT* lpRect, BOOL bErase);
]]

-- Window utilities
ffi.cdef[[

typedef BOOL (__stdcall *WNDENUMPROC)(HWND hwnd, LPARAM l);

int EnumWindows(WNDENUMPROC func, LPARAM l);

HWND GetForegroundWindow(void);

BOOL MessageBeep(UINT type);

int MessageBoxA(HWND hWnd,
		LPCTSTR lpText,
		LPCTSTR lpCaption,
		UINT uType
	);
]]

-- Window Station
ffi.cdef[[
BOOL  CloseWindowStation(HWINSTA hWinSta);

HWINSTA  CreateWindowStation(
	LPCTSTR lpwinsta,
	DWORD dwFlags,
	ACCESS_MASK dwDesiredAccess,
	LPSECURITY_ATTRIBUTES lpsa
);


// Callback function for EnumWindowStations
typedef BOOL (__stdcall *WINSTAENUMPROCW) (LPTSTR lpszWindowStation, LPARAM lParam);
typedef BOOL (__stdcall *WINSTAENUMPROCA) (LPCSTR lpszWindowStation, LPARAM lParam);

BOOL  EnumWindowStationsA(WINSTAENUMPROCA lpEnumFunc, LPARAM lParam);

HWINSTA  GetProcessWindowStation(void);

HWINSTA  OpenWindowStationA(LPCSTR lpszWinSta, BOOL fInherit, ACCESS_MASK dwDesiredAccess);
HWINSTA  OpenWindowStationW(LPTSTR lpszWinSta, BOOL fInherit, ACCESS_MASK dwDesiredAccess);

BOOL  SetProcessWindowStation(HWINSTA hWinSta);
HWINSTA GetProcessWindowStation();

BOOL  GetUserObjectInformation(HANDLE hObj,
    int nIndex,
	PVOID pvInfo,
    DWORD nLength,
	LPDWORD lpnLengthNeeded
);

BOOL LockWorkStation(void);

/*
BOOL  GetUserObjectSecurity(HANDLE hObj,
	PSECURITY_INFORMATION pSIRequested,
	PSECURITY_DESCRIPTOR pSD,
	DWORD nLength,
	LPDWORD lpnLengthNeeded
);


BOOL  SetUserObjectInformation(HANDLE hObj,
  int nIndex,
  PVOID pvInfo,
  DWORD nLength
);

BOOL  SetUserObjectSecurity(HANDLE hObj,
  PSECURITY_INFORMATION pSIRequested,
  PSECURITY_DESCRIPTOR pSID
);
*/
]]

-- Window Station Access attributes
ffi.cdef[[
static const int WINSTA_ENUMDESKTOPS        = 0x0001;
static const int WINSTA_READATTRIBUTES      = 0x0002;
static const int WINSTA_ACCESSCLIPBOARD     = 0x0004;
static const int WINSTA_CREATEDESKTOP       = 0x0008;
static const int WINSTA_WRITEATTRIBUTES     = 0x0010;
static const int WINSTA_ACCESSGLOBALATOMS   = 0x0020;
static const int WINSTA_EXITWINDOWS         = 0x0040;
static const int WINSTA_ENUMERATE           = 0x0100;
static const int WINSTA_READSCREEN          = 0x0200;

static const int WINSTA_ALL_ACCESS          = (WINSTA_ENUMDESKTOPS  | WINSTA_READATTRIBUTES  | WINSTA_ACCESSCLIPBOARD | \
                                     WINSTA_CREATEDESKTOP | WINSTA_WRITEATTRIBUTES | WINSTA_ACCESSGLOBALATOMS | \
                                     WINSTA_EXITWINDOWS   | WINSTA_ENUMERATE       | WINSTA_READSCREEN);

]]


-- Desktop management
ffi.cdef[[
typedef BOOL (__stdcall *DESKTOPENUMPROCA)(LPTSTR lpszDesktop, LPARAM lParam);
typedef BOOL (__stdcall *WINSTAENUMPROCA)(LPTSTR stationname, LPARAM lParam);

// CloseDesktop
BOOL CloseDesktop(HDESK hDesktop);

// CreateDesktop
HDESK CreateDesktopA(LPCTSTR lpszDesktop, 
    LPCTSTR lpszDevice,
    PDEVMODE pDevmode,
    DWORD dwFlags,
    ACCESS_MASK dwDesiredAccess, 
    LPSECURITY_ATTRIBUTES lpsa);


// EnumDesktops
BOOL EnumDesktopsA(HWINSTA hwinsta, DESKTOPENUMPROCA lpEnumFunc, LPARAM lParam);

// EnumDesktopWindows
BOOL EnumDesktopWindows(HDESK hDesktop, WNDENUMPROC lpfn, LPARAM lParam);


// GetThreadDesktop
HDESK GetThreadDesktop(DWORD dwThreadId);

// OpenDesktop
HDESK
OpenDesktopA(
    LPCSTR lpszDesktop,
    DWORD dwFlags,
    BOOL fInherit,
    ACCESS_MASK dwDesiredAccess);


// OpenInputDesktop
HDESK OpenInputDesktop(DWORD dwFlags, BOOL fInherit, ACCESS_MASK dwDesiredAccess);

// SetThreadDesktop
BOOL SetThreadDesktop(HDESK hDesktop);

// SwitchDesktop
BOOL SwitchDesktop(HDESK hDesktop);

// PaintDesktop
BOOL PaintDesktop(HDC hdc);
]]

ffi.cdef[[
/*
 * RedrawWindow() flags
 */
static const int RDW_INVALIDATE        =  0x0001;
static const int RDW_INTERNALPAINT     =  0x0002;
static const int RDW_ERASE             =  0x0004;

static const int RDW_VALIDATE          =  0x0008;
static const int RDW_NOINTERNALPAINT   =  0x0010;
static const int RDW_NOERASE           =  0x0020;

static const int RDW_NOCHILDREN        =  0x0040;
static const int RDW_ALLCHILDREN       =  0x0080;

static const int RDW_UPDATENOW         =  0x0100;
static const int RDW_ERASENOW          =  0x0200;

static const int RDW_FRAME             =  0x0400;
static const int RDW_NOFRAME           =  0x0800;

]]


ffi.cdef[[
static const int	CW_USEDEFAULT = 0x80000000;

static const int	CS_VREDRAW			= 0x0001;
static const int	CS_HREDRAW			= 0x0002;
static const int	CS_DBLCLKS			= 0x0008;
static const int	CS_OWNDC			= 0x0020;
static const int	CS_CLASSDC			= 0x0040;
static const int	CS_NOCLOSE			= 0x0200;
static const int	CS_SAVEBITS			= 0x0800;
static const int	CS_BYTEALIGNCLIENT	= 0x1000;
static const int	CS_BYTEALIGNWINDOW	= 0x2000;
static const int	CS_GLOBALCLASS		= 0x4000;
static const int	CS_DROPSHADOW		= 0x00020000;
]]

ffi.cdef[[
static const int	WS_POPUP			= 0x80000000;
static const int	WS_MAXIMIZEBOX 		= 0x00010000;
static const int	WS_SIZEBOX 			= 0x00040000;
static const int	WS_SYSMENU 			= 0x00080000;
static const int	WS_HSCROLL 			= 0x00100000;
static const int	WS_VSCROLL 			= 0x00200000;
static const int	WS_OVERLAPPEDWINDOW = 0x00CF0000;
static const int	WS_MAXIMIZE 		= 0x01000000;
static const int	WS_VISIBLE 			= 0x10000000;
static const int	WS_MINIMIZE 		= 0x20000000;

static const int	WS_EX_WINDOWEDGE	= 0x00000100;
static const int	WS_EX_APPWINDOW		= 0x00040000;
]]

ffi.cdef[[
	// Standard User32 Messages
static const int	WM_CREATE 			= 0x0001;
static const int	WM_DESTROY 			= 0x0002;
static const int	WM_SIZE 			= 0x0005;
static const int	WM_ACTIVATE 		= 0x0006;
static const int	WM_SETFOCUS			= 0x0007;
static const int	WM_KILLFOCUS		= 0x0008;
static const int	WM_ENABLE			= 0x000A;
static const int	WM_SETTEXT 			= 0x000C;
static const int	WM_GETTEXT 			= 0x000D;
static const int	WM_PAINT			= 0x000F;
static const int	WM_CLOSE 			= 0x0010;
static const int	WM_QUIT 			= 0x0012;
static const int	WM_ACTIVATEAPP 		= 0x001C;

static const int	WM_SETCURSOR 		= 0x0020;
static const int	WM_GETMINMAXINFO 	= 0x0024;
static const int	WM_WINDOWPOSCHANGING = 0x0046;
static const int	WM_WINDOWPOSCHANGED = 0x0047;
static const int	WM_NCCREATE 		= 0x0081;
static const int	WM_NCDESTROY 		= 0x0082;
static const int	WM_NCCALCSIZE 		= 0x0083;
static const int	WM_NCHITTEST 		= 0x0084;
static const int	WM_NCPAINT 			= 0x0085;
static const int	WM_NCACTIVATE 		= 0x0086;

	// Non Client (NC) mouse activity
static const int	WM_NCMOUSEMOVE 		= 0x00A0;
static const int	WM_NCLBUTTONDOWN 	= 0x00A1;
static const int	WM_NCLBUTTONUP 		= 0x00A2;
static const int	WM_NCLBUTTONDBLCLK 	= 0x00A3;
static const int	WM_NCRBUTTONDOWN 	= 0x00A4;
static const int	WM_NCRBUTTONUP 		= 0x00A5;
static const int	WM_NCRBUTTONDBLCLK 	= 0x00A6;
static const int	WM_NCMBUTTONDOWN 	= 0x00A7;
static const int	WM_NCMBUTTONUP 		= 0x00A8;
static const int	WM_NCMBUTTONDBLCLK 	= 0x00A9;

static const int	WM_INPUT_DEVICE_CHANGE = 0x00FE;
static const int	WM_INPUT			= 0x00FF;

	// Keyboard Activity
static const int	WM_KEYDOWN			= 0x0100;
static const int	WM_KEYUP			= 0x0101;
static const int	WM_CHAR				= 0x0102;
static const int	WM_DEADCHAR			= 0x0103;
static const int	WM_SYSKEYDOWN		= 0x0104;
static const int	WM_SYSKEYUP			= 0x0105;
static const int	WM_SYSCHAR			= 0x0106;
static const int	WM_SYSDEADCHAR		= 0x0107;
static const int	WM_COMMAND			= 0x0111;
static const int	WM_SYSCOMMAND		= 0x0112;


static const int	WM_TIMER = 0x0113;

	// client area mouse activity
static const int	WM_MOUSEFIRST		= 0x0200;
static const int	WM_MOUSEMOVE		= 0x0200;
static const int	WM_LBUTTONDOWN		= 0x0201;
static const int	WM_LBUTTONUP		= 0x0202;
static const int	WM_LBUTTONDBLCLK	= 0x0203;
static const int	WM_RBUTTONDOWN		= 0x0204;
static const int	WM_RBUTTONUP		= 0x0205;
static const int	WM_RBUTTONDBLCLK	= 0x0206;
static const int	WM_MBUTTONDOWN		= 0x0207;
static const int	WM_MBUTTONUP		= 0x0208;
static const int	WM_MBUTTONDBLCLK	= 0x0209;
static const int	WM_MOUSEWHEEL		= 0x020A;
static const int	WM_XBUTTONDOWN		= 0x020B;
static const int	WM_XBUTTONUP		= 0x020C;
static const int	WM_XBUTTONDBLCLK	= 0x020D;
static const int	WM_MOUSELAST		= 0x020D;

static const int	WM_SIZING 			= 0x0214;
static const int	WM_CAPTURECHANGED 	= 0x0215;
static const int	WM_MOVING 			= 0x0216;
static const int	WM_DEVICECHANGE 	= 0x0219;

static const int	WM_ENTERSIZEMOVE 	= 0x0231;
static const int	WM_EXITSIZEMOVE 	= 0x0232;
static const int	WM_DROPFILES 		= 0x0233;

static const int	WM_IME_SETCONTEXT 	= 0x0281;
static const int	WM_IME_NOTIFY 		= 0x0282;

static const int	WM_NCMOUSEHOVER		= 0x02A0;
static const int	WM_MOUSEHOVER 		= 0x02A1;
static const int	WM_NCMOUSELEAVE		= 0x02A2;
static const int	WM_MOUSELEAVE		= 0x02A3;

static const int	WM_PRINT            = 0x0317;

static const int	WM_DWMCOMPOSITIONCHANGED  =      0x031E;
static const int	WM_DWMNCRENDERINGCHANGED  =      0x031F;
static const int	WM_DWMCOLORIZATIONCOLORCHANGED = 0x0320;
static const int	WM_DWMWINDOWMAXIMIZEDCHANGE    = 0x0321;
]]

ffi.cdef[[
static const int	SW_HIDE = 0;
static const int	SW_SHOWNORMAL = 1;
static const int	SW_SHOWMINIMIZED = 2;
static const int	SW_SHOWMAXIMIZED = 3;
static const int	SW_MAXIMIZE = 3;
static const int	SW_SHOWNOACTIVATE = 4;
static const int	SW_SHOW = 5;
static const int	SW_MINIMIZE = 6;
static const int	SW_SHOWMINNOACTIVE = 7;
static const int	SW_SHOWNA = 8;
static const int	SW_RESTORE = 9;
static const int	SW_SHOWDEFAULT = 10;
static const int	SW_FORCEMINIMIZE = 11;

static const int	PM_NOREMOVE			= 0x0000;
static const int	PM_REMOVE 			= 0x0001;
static const int	PM_NOYIELD 			= 0x0002;

	// dwWakeMask of MsgWaitForMultipleObjectsEx()
static const int	QS_KEY				= 0x0001;
static const int	QS_MOUSEMOVE		= 0x0002;
static const int	QS_MOUSEBUTTON		= 0x0004;
static const int	QS_MOUSE			= 0x0006;
static const int	QS_POSTMESSAGE		= 0x0008;
static const int	QS_TIMER			= 0x0010;
static const int	QS_PAINT			= 0x0020;
static const int	QS_SENDMESSAGE		= 0x0040;
static const int	QS_HOTKEY			= 0x0080;
static const int	QS_ALLPOSTMESSAGE	= 0x0100;
static const int	QS_RAWINPUT			= 0x0400;
static const int	QS_INPUT			= 0x0407;
static const int	QS_ALLEVENTS		= 0x04BF;
static const int	QS_ALLINPUT			= 0x04FF;

	// dwFlags of MsgWaitForMultipleObjectsEx()
static const int	MWMO_WAITALL		= 0x0001;
static const int	MWMO_ALERTABLE		= 0x0002;
static const int	MWMO_INPUTAVAILABLE	= 0x0004;

static const int      WAIT_OBJECT_0 	= 0x00000000;

static const int	HWND_DESKTOP    	= 0x0000;
static const int	HWND_BROADCAST  	= 0xffff;
static const int	HWND_TOP        	= (0);
static const int	HWND_BOTTOM     	= (1);
static const int	HWND_TOPMOST    	= (-1);
static const int	HWND_NOTOPMOST  	= (-2);
static const int	HWND_MESSAGE 		= (-3);
]]

-- Used for GetSystemMetrics
ffi.cdef[[
static const int	SM_CXSCREEN = 0;
static const int	SM_CYSCREEN = 1;
static const int	SM_CXVSCROLL = 2;
static const int	SM_CYHSCROLL = 3;
static const int	SM_CYCAPTION = 4;
static const int	SM_CXBORDER = 5;
static const int	SM_CYBORDER = 6;
static const int	SM_CXDLGFRAME = 7;
static const int	SM_CXFIXEDFRAME = 7;
static const int	SM_CYDLGFRAME = 8;
static const int	SM_CYFIXEDFRAME = 8;
static const int	SM_CYVTHUMB = 9;
static const int	SM_CXHTHUMB = 10;
static const int	SM_CXICON = 11;
static const int	SM_CYICON = 12;
static const int	SM_CXCURSOR = 13;
static const int	SM_CYCURSOR = 14;
static const int	SM_CYMENU = 15;
static const int	SM_CXFULLSCREEN = 16;
static const int	SM_CYFULLSCREEN = 17;
static const int	SM_CYKANJIWINDOW = 18;
static const int	SM_MOUSEPRESENT = 19;
static const int	SM_CYVSCROLL = 20;
static const int	SM_CXHSCROLL = 21;
static const int	SM_DEBUG = 22;
static const int	SM_SWAPBUTTON = 23;
static const int	SM_RESERVED1 = 24;
static const int	SM_RESERVED2 = 25;
static const int	SM_RESERVED3 = 26;
static const int	SM_RESERVED4 = 27;
static const int	SM_CXMIN = 28;
static const int	SM_CYMIN = 29;
static const int	SM_CXSIZE = 30;
static const int	SM_CYSIZE = 31;
static const int	SM_CXSIZEFRAME = 32;
static const int	SM_CXFRAME = 32;
static const int	SM_CYFRAME = 33;
static const int	SM_CYSIZEFRAME = 33;
static const int	SM_CXMINTRACK = 34;
static const int	SM_CYMINTRACK = 35;
static const int	SM_CXDOUBLECLK = 36;
static const int	SM_CYDOUBLECLK = 37;
static const int	SM_CXICONSPACING = 38;
static const int	SM_CYICONSPACING = 39;
static const int	SM_MENUDROPALIGNMENT = 40;
static const int	SM_PENWINDOWS = 41;
static const int	SM_DBCSENABLED = 42;
static const int	SM_CMOUSEBUTTONS = 43;
static const int	SM_SECURE = 44;
static const int	SM_CXEDGE = 45;
static const int	SM_CYEDGE = 46;
static const int	SM_CXMINSPACING = 47;
static const int	SM_CYMINSPACING = 48;
static const int	SM_CXSMICON = 49;
static const int	SM_CYSMICON = 50;
static const int	SM_CYSMCAPTION = 51;
static const int	SM_CXSMSIZE = 52;
static const int	SM_CYSMSIZE = 53;
static const int	SM_CXMENUSIZE = 54;
static const int	SM_CYMENUSIZE = 55;
static const int	SM_ARRANGE = 56;
static const int	SM_CXMINIMIZED = 57;
static const int	SM_CYMINIMIZED = 58;
static const int	SM_CXMAXTRACK = 59;
static const int	SM_CYMAXTRACK = 60;
static const int	SM_CXMAXIMIZED = 61;
static const int	SM_CYMAXIMIZED = 62;
static const int	SM_NETWORK = 63;
static const int	SM_CLEANBOOT = 67;
static const int	SM_CXDRAG = 68;
static const int	SM_CYDRAG = 69;
static const int	SM_SHOWSOUNDS = 70;
static const int	SM_CXMENUCHECK = 71;
static const int	SM_CYMENUCHECK = 72;
static const int	SM_SLOWMACHINE = 73;
static const int	SM_MIDEASTENABLED = 74;
static const int	SM_MOUSEWHEELPRESENT = 75;
static const int	SM_XVIRTUALSCREEN = 76;
static const int	SM_YVIRTUALSCREEN = 77;
static const int	SM_CXVIRTUALSCREEN = 78;
static const int	SM_CYVIRTUALSCREEN = 79;
static const int	SM_CMONITORS = 80;
static const int	SM_SAMEDISPLAYFORMAT = 81;
static const int    SM_IMMENABLED = 82;
static const int    SM_TABLETPC = 86;
static const int    SM_MEDIACENTER = 87;
static const int    SM_STARTER = 88;
static const int    SM_SERVERR2 = 89;
static const int    SM_MOUSEHORIZONTALWHEELPRESENT = 91;
static const int    SM_DIGITIZER = 94;
static const int    SM_MAXIMUMTOUCHES = 95;

static const int    SM_REMOTESESSION = 0x1000;
static const int    SM_SHUTTINGDOWN = 0x2000;
static const int    SM_REMOTECONTROL = 0x2001;
static const int    SM_CONVERTIBLESLATEMODE = 0x2003;
static const int    SM_SYSTEMDOCKED = 0x2004;

]]



local Lib = ffi.load("user32");

local exports = {
	Lib = Lib,

    -- WindowStation
    CloseWindowStation = Lib.CloseWindowStation,
    EnumWindowStationsA = Lib.EnumWindowStationsA,
    OpenWindowStationA = Lib.OpenWindowStationA,

	CreateWindowExA = Lib.CreateWindowExA,
	DefWindowProcA = Lib.DefWindowProcA,
    DispatchMessageA = Lib.DispatchMessageA,
	GetClientRect = Lib.GetClientRect,
	GetDC = Lib.GetDC,
	GetDesktopWindow = Lib.GetDesktopWindow,
	GetMessageA = Lib.GetMessageA,
    GetSystemMetrics = Lib.GetSystemMetrics,
    SystemParametersInfo = Lib.SystemParametersInfoA,
	LoadCursor = Lib.LoadCursorA,
	PeekMessageA = Lib.PeekMessageA,
	RegisterClassExA = Lib.RegisterClassExA,
	SendInput = Lib.SendInput,
	SendMessageA = Lib.SendMessageA,
	ShowWindow = Lib.ShowWindow,
	TranslateMessage = Lib.TranslateMessage,
	UpdateWindow = Lib.UpdateWindow,
	MsgWaitForMultipleObjectsEx = Lib.MsgWaitForMultipleObjectsEx,
}


return exports
