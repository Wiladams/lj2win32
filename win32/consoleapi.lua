--[[
* consoleapi.h -- ApiSet Contract for api-ms-win-core-console-l1                *
--]]





local ffi = require("ffi")
require("win32.minwindef")
require("win32.minwinbase")
require("win32.wincontypes")




ffi.cdef[[
BOOL
__stdcall
AllocConsole(
    VOID
    );



BOOL
__stdcall
FreeConsole(
    VOID
    );
]]


ffi.cdef[[
BOOL
__stdcall
AttachConsole(
    DWORD dwProcessId
    );


static const int ATTACH_PARENT_PROCESS = ((DWORD)-1);
]]

ffi.cdef[[
UINT
__stdcall
GetConsoleCP(
    VOID
    );



UINT
__stdcall
GetConsoleOutputCP(
    VOID
    );
]]

ffi.cdef[[
//
// Input Mode flags:
//

static const int ENABLE_PROCESSED_INPUT             = 0x0001;
static const int ENABLE_LINE_INPUT                  = 0x0002;
static const int ENABLE_ECHO_INPUT                  = 0x0004;
static const int ENABLE_WINDOW_INPUT                = 0x0008;
static const int ENABLE_MOUSE_INPUT                 = 0x0010;
static const int ENABLE_INSERT_MODE                 = 0x0020;
static const int ENABLE_QUICK_EDIT_MODE             = 0x0040;
static const int ENABLE_EXTENDED_FLAGS              = 0x0080;
static const int ENABLE_AUTO_POSITION               = 0x0100;
static const int ENABLE_VIRTUAL_TERMINAL_INPUT      = 0x0200;
]]

ffi.cdef[[
//
// Output Mode flags:
//

static const int ENABLE_PROCESSED_OUTPUT            = 0x0001;
static const int ENABLE_WRAP_AT_EOL_OUTPUT          = 0x0002;
static const int ENABLE_VIRTUAL_TERMINAL_PROCESSING = 0x0004;
static const int DISABLE_NEWLINE_AUTO_RETURN        = 0x0008;
static const int ENABLE_LVB_GRID_WORLDWIDE          = 0x0010;
]]

ffi.cdef[[
BOOL
__stdcall
GetConsoleMode(
    HANDLE hConsoleHandle,
    LPDWORD lpMode
    );

BOOL
__stdcall
SetConsoleMode(
    HANDLE hConsoleHandle,
    DWORD dwMode
    );

BOOL
__stdcall
GetNumberOfConsoleInputEvents(
    HANDLE hConsoleInput,
    LPDWORD lpNumberOfEvents
    );

BOOL
__stdcall
ReadConsoleInputA(
    HANDLE hConsoleInput,
     PINPUT_RECORD lpBuffer,
    DWORD nLength,
     LPDWORD lpNumberOfEventsRead
    );

BOOL
__stdcall
ReadConsoleInputW(
    HANDLE hConsoleInput,
     PINPUT_RECORD lpBuffer,
    DWORD nLength,
     LPDWORD lpNumberOfEventsRead
    );
]]

--[[
#ifdef UNICODE
#define ReadConsoleInput  ReadConsoleInputW
#else
#define ReadConsoleInput  ReadConsoleInputA
#endif // !UNICODE
--]]




--[[
#ifndef UNICODE
#define PeekConsoleInput  PeekConsoleInputA
#endif
--]]




ffi.cdef[[
BOOL
__stdcall
PeekConsoleInputA(
    HANDLE hConsoleInput,
     PINPUT_RECORD lpBuffer,
    DWORD nLength,
    LPDWORD lpNumberOfEventsRead
    );


BOOL
__stdcall
PeekConsoleInputW(
    HANDLE hConsoleInput,
     PINPUT_RECORD lpBuffer,
    DWORD nLength,
    LPDWORD lpNumberOfEventsRead
    );
]]

--[[
#ifdef UNICODE
#define PeekConsoleInput  PeekConsoleInputW
#else
#define PeekConsoleInput  PeekConsoleInputA
#endif // !UNICODE
--]]

ffi.cdef[[
typedef struct _CONSOLE_READCONSOLE_CONTROL {
    ULONG nLength;
    ULONG nInitialChars;
    ULONG dwCtrlWakeupMask;
    ULONG dwControlKeyState;
} CONSOLE_READCONSOLE_CONTROL, *PCONSOLE_READCONSOLE_CONTROL;
]]

ffi.cdef[[
BOOL
__stdcall
ReadConsoleA(
    HANDLE hConsoleInput,
     LPVOID lpBuffer,
    DWORD nNumberOfCharsToRead,
     LPDWORD lpNumberOfCharsRead,
     PCONSOLE_READCONSOLE_CONTROL pInputControl
    );



BOOL
__stdcall
ReadConsoleW(
    HANDLE hConsoleInput,
     LPVOID lpBuffer,
    DWORD nNumberOfCharsToRead,
     LPDWORD lpNumberOfCharsRead,
     PCONSOLE_READCONSOLE_CONTROL pInputControl
    );
]]

--[[
#ifdef UNICODE
#define ReadConsole  ReadConsoleW
#else
#define ReadConsole  ReadConsoleA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
WriteConsoleA(
    HANDLE hConsoleOutput,
     const VOID* lpBuffer,
    DWORD nNumberOfCharsToWrite,
     LPDWORD lpNumberOfCharsWritten,
     LPVOID lpReserved
    );


BOOL
__stdcall
WriteConsoleW(
    HANDLE hConsoleOutput,
     const VOID* lpBuffer,
    DWORD nNumberOfCharsToWrite,
     LPDWORD lpNumberOfCharsWritten,
     LPVOID lpReserved
    );
]]

--[[
#ifdef UNICODE
#define WriteConsole  WriteConsoleW
#else
#define WriteConsole  WriteConsoleA
#endif // !UNICODE
--]]

ffi.cdef[[
//
// Ctrl Event flags
//

static const int CTRL_C_EVENT        = 0;
static const int CTRL_BREAK_EVENT    = 1;
static const int CTRL_CLOSE_EVENT    = 2;
// 3 is reserved!
// 4 is reserved!
static const int CTRL_LOGOFF_EVENT   = 5;
static const int CTRL_SHUTDOWN_EVENT = 6;
]]

ffi.cdef[[
//
// typedef for ctrl-c handler routines
//

typedef
BOOL
(__stdcall *PHANDLER_ROUTINE)(
    DWORD CtrlType
    );


BOOL
__stdcall
SetConsoleCtrlHandler(
     PHANDLER_ROUTINE HandlerRoutine,
    BOOL Add
    );
]]





ffi.cdef[[
// CreatePseudoConsole Flags
static const int PSEUDOCONSOLE_INHERIT_CURSOR = (0x1);


HRESULT
__stdcall
CreatePseudoConsole(
    COORD size,
    HANDLE hInput,
    HANDLE hOutput,
    DWORD dwFlags,
    HPCON* phPC
    );



HRESULT
__stdcall
ResizePseudoConsole(
    HPCON hPC,
    COORD size
    );



VOID
__stdcall
ClosePseudoConsole(
    HPCON hPC
    );
]]


