-- user32_ffi.lua

local ffi = require "ffi"

require "win32.wtypes"



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


-- WINDOW DRAWING
ffi.cdef[[
HDC GetDC(HWND hWnd);

HDC GetWindowDC(HWND hWnd);
BOOL InvalidateRect(HWND hWnd, const RECT* lpRect, BOOL bErase);


// WINDOW UTILITIES


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
typedef BOOL (__stdcall *WINSTAENUMPROC) (LPTSTR lpszWindowStation,LPARAM lParam);

BOOL  EnumWindowStations(WINSTAENUMPROC lpEnumFunc, LPARAM lParam);

HWINSTA  GetProcessWindowStation(void);

HWINSTA  OpenWindowStationA(LPTSTR lpszWinSta, BOOL fInherit, ACCESS_MASK dwDesiredAccess);
HWINSTA  OpenWindowStationW(LPTSTR lpszWinSta, BOOL fInherit, ACCESS_MASK dwDesiredAccess);

BOOL  SetProcessWindowStation(HWINSTA hWinSta);

BOOL  GetUserObjectInformation(HANDLE hObj,
    int nIndex,
	PVOID pvInfo,
    DWORD nLength,
	LPDWORD lpnLengthNeeded
);

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

static const int	WM_PRINT = 0x0317;

static const int	WM_DWMCOMPOSITIONCHANGED  =      0x031E;
static const int	WM_DWMNCRENDERINGCHANGED  =      0x031F;
static const int	WM_DWMCOLORIZATIONCOLORCHANGED = 0x0320;
static const int	WM_DWMWINDOWMAXIMIZEDCHANGE    = 0x0321;


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

ffi.cdef[[
	// Used for GetSystemMetrics
static const int	CXSCREEN = 0;
static const int	CYSCREEN = 1;
static const int	CXVSCROLL = 2;
static const int	CYHSCROLL = 3;
static const int	CYCAPTION = 4;
static const int	CXBORDER = 5;
static const int	CYBORDER = 6;
static const int	CXDLGFRAME = 7;
static const int	CXFIXEDFRAME = 7;
static const int	CYDLGFRAME = 8;
static const int	CYFIXEDFRAME = 8;
static const int	CYVTHUMB = 9;
static const int	CXHTHUMB = 10;
static const int	CXICON = 11;
static const int	CYICON = 12;
static const int	CXCURSOR = 13;
static const int	CYCURSOR = 14;
static const int	CYMENU = 15;
static const int	CXFULLSCREEN = 16;
static const int	CYFULLSCREEN = 17;
static const int	CYKANJIWINDOW = 18;
static const int	MOUSEPRESENT = 19;
static const int	CYVSCROLL = 20;
static const int	CXHSCROLL = 21;
static const int	DEBUG = 22;
static const int	SWAPBUTTON = 23;
static const int	RESERVED1 = 24;
static const int	RESERVED2 = 25;
static const int	RESERVED3 = 26;
static const int	RESERVED4 = 27;
static const int	CXMIN = 28;
static const int	CYMIN = 29;
static const int	CXSIZE = 30;
static const int	CYSIZE = 31;
static const int	CXSIZEFRAME = 32;
static const int	CXFRAME = 32;
static const int	CYFRAME = 33;
static const int	CYSIZEFRAME = 33;
static const int	CXMINTRACK = 34;
static const int	CYMINTRACK = 35;
static const int	CXDOUBLECLK = 36;
static const int	CYDOUBLECLK = 37;
static const int	CXICONSPACING = 38;
static const int	CYICONSPACING = 39;
static const int	MENUDROPALIGNMENT = 40;
static const int	PENWINDOWS = 41;
static const int	DBCSENABLED = 42;
static const int	CMOUSEBUTTONS = 43;
static const int	SECURE = 44;
static const int	CXEDGE = 45;
static const int	CYEDGE = 46;
static const int	CXMINSPACING = 47;
static const int	CYMINSPACING = 48;
static const int	CXSMICON = 49;
static const int	CYSMICON = 50;
static const int	CYSMCAPTION = 51;
static const int	CXSMSIZE = 52;
static const int	CYSMSIZE = 53;
static const int	CXMENUSIZE = 54;
static const int	CYMENUSIZE = 55;
static const int	ARRANGE = 56;
static const int	CXMINIMIZED = 57;
static const int	CYMINIMIZED = 58;
static const int	CXMAXTRACK = 59;
static const int	CYMAXTRACK = 60;
static const int	CXMAXIMIZED = 61;
static const int	CYMAXIMIZED = 62;
static const int	NETWORK = 63;
static const int	CLEANBOOT = 67;
static const int	CXDRAG = 68;
static const int	CYDRAG = 69;
static const int	SHOWSOUNDS = 70;
static const int	CXMENUCHECK = 71;
static const int	CYMENUCHECK = 72;
static const int	SLOWMACHINE = 73;
static const int	MIDEASTENABLED = 74;
static const int	MOUSEWHEELPRESENT = 75;
static const int	XVIRTUALSCREEN = 76;
static const int	YVIRTUALSCREEN = 77;
static const int	CXVIRTUALSCREEN = 78;
static const int	CYVIRTUALSCREEN = 79;
static const int	CMONITORS = 80;
static const int	SAMEDISPLAYFORMAT = 81;
static const int	CMETRICS = 83;
]]

local Lib = ffi.load("user32");

local user32_ffi = {
	Lib = Lib,

	CloseWindowStation = Lib.CloseWindowStation,
	CreateWindowExA = Lib.CreateWindowExA,
	DefWindowProcA = Lib.DefWindowProcA,
	DispatchMessageA = Lib.DispatchMessageA,
	GetClientRect = Lib.GetClientRect,
	GetDC = Lib.GetDC,
	GetDesktopWindow = Lib.GetDesktopWindow,
	GetMessageA = Lib.GetMessageA,
	GetSystemMetrics = Lib.GetSystemMetrics,
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

return user32_ffi
