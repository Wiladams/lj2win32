--[[
* consoleapi2.h -- ApiSet Contract for api-ms-win-core-console-l2                *
--]]

local ffi = require("ffi")

require("win32.minwindef")
require("win32.minwinbase")

require("win32.wincontypes")
require("win32.windef")



ffi.cdef[[
//
// Attributes flags:
//

static const int FOREGROUND_BLUE      = 0x0001; // text color contains blue.
static const int FOREGROUND_GREEN     = 0x0002; // text color contains green.
static const int FOREGROUND_RED       = 0x0004; // text color contains red.
static const int FOREGROUND_INTENSITY = 0x0008; // text color is intensified.
static const int BACKGROUND_BLUE      = 0x0010; // background color contains blue.
static const int BACKGROUND_GREEN     = 0x0020; // background color contains green.
static const int BACKGROUND_RED       = 0x0040; // background color contains red.
static const int BACKGROUND_INTENSITY = 0x0080; // background color is intensified.
static const int COMMON_LVB_LEADING_BYTE    = 0x0100; // Leading Byte of DBCS
static const int COMMON_LVB_TRAILING_BYTE   = 0x0200; // Trailing Byte of DBCS
static const int COMMON_LVB_GRID_HORIZONTAL = 0x0400; // DBCS: Grid attribute: top horizontal.
static const int COMMON_LVB_GRID_LVERTICAL  = 0x0800; // DBCS: Grid attribute: left vertical.
static const int COMMON_LVB_GRID_RVERTICAL  = 0x1000; // DBCS: Grid attribute: right vertical.
static const int COMMON_LVB_REVERSE_VIDEO   = 0x4000; // DBCS: Reverse fore/back ground attribute.
static const int COMMON_LVB_UNDERSCORE      = 0x8000; // DBCS: Underscore.

static const int COMMON_LVB_SBCSDBCS        = 0x0300; // SBCS or DBCS flag.
]]

ffi.cdef[[
BOOL
__stdcall
FillConsoleOutputCharacterA(
     HANDLE hConsoleOutput,
     CHAR cCharacter,
     DWORD nLength,
     COORD dwWriteCoord,
     LPDWORD lpNumberOfCharsWritten
    );


BOOL
__stdcall
FillConsoleOutputCharacterW(
     HANDLE hConsoleOutput,
     WCHAR cCharacter,
     DWORD nLength,
     COORD dwWriteCoord,
     LPDWORD lpNumberOfCharsWritten
    );
]]

--[[
#ifdef UNICODE
#define FillConsoleOutputCharacter  FillConsoleOutputCharacterW
#else
#define FillConsoleOutputCharacter  FillConsoleOutputCharacterA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
FillConsoleOutputAttribute(
     HANDLE hConsoleOutput,
     WORD wAttribute,
     DWORD nLength,
     COORD dwWriteCoord,
     LPDWORD lpNumberOfAttrsWritten
    );



BOOL
__stdcall
GenerateConsoleCtrlEvent(
     DWORD dwCtrlEvent,
     DWORD dwProcessGroupId
    );



HANDLE
__stdcall
CreateConsoleScreenBuffer(
     DWORD dwDesiredAccess,
     DWORD dwShareMode,
     const SECURITY_ATTRIBUTES* lpSecurityAttributes,
     DWORD dwFlags,
     LPVOID lpScreenBufferData
    );



BOOL
__stdcall
SetConsoleActiveScreenBuffer(
     HANDLE hConsoleOutput
    );



BOOL
__stdcall
FlushConsoleInputBuffer(
     HANDLE hConsoleInput
    );



BOOL
__stdcall
SetConsoleCP(
     UINT wCodePageID
    );



BOOL
__stdcall
SetConsoleOutputCP(
     UINT wCodePageID
    );


typedef struct _CONSOLE_CURSOR_INFO {
    DWORD  dwSize;
    BOOL   bVisible;
} CONSOLE_CURSOR_INFO, *PCONSOLE_CURSOR_INFO;


BOOL
__stdcall
GetConsoleCursorInfo(
     HANDLE hConsoleOutput,
     PCONSOLE_CURSOR_INFO lpConsoleCursorInfo
    );



BOOL
__stdcall
SetConsoleCursorInfo(
     HANDLE hConsoleOutput,
     const CONSOLE_CURSOR_INFO* lpConsoleCursorInfo
    );


typedef struct _CONSOLE_SCREEN_BUFFER_INFO {
    COORD dwSize;
    COORD dwCursorPosition;
    WORD  wAttributes;
    SMALL_RECT srWindow;
    COORD dwMaximumWindowSize;
} CONSOLE_SCREEN_BUFFER_INFO, *PCONSOLE_SCREEN_BUFFER_INFO;


BOOL
__stdcall
GetConsoleScreenBufferInfo(
     HANDLE hConsoleOutput,
     PCONSOLE_SCREEN_BUFFER_INFO lpConsoleScreenBufferInfo
    );


typedef struct _CONSOLE_SCREEN_BUFFER_INFOEX {
    ULONG cbSize;
    COORD dwSize;
    COORD dwCursorPosition;
    WORD wAttributes;
    SMALL_RECT srWindow;
    COORD dwMaximumWindowSize;
    WORD wPopupAttributes;
    BOOL bFullscreenSupported;
    COLORREF ColorTable[16];
} CONSOLE_SCREEN_BUFFER_INFOEX, *PCONSOLE_SCREEN_BUFFER_INFOEX;


BOOL
__stdcall
GetConsoleScreenBufferInfoEx(
     HANDLE hConsoleOutput,
     PCONSOLE_SCREEN_BUFFER_INFOEX lpConsoleScreenBufferInfoEx
    );



BOOL
__stdcall
SetConsoleScreenBufferInfoEx(
     HANDLE hConsoleOutput,
     PCONSOLE_SCREEN_BUFFER_INFOEX lpConsoleScreenBufferInfoEx
    );



BOOL
__stdcall
SetConsoleScreenBufferSize(
     HANDLE hConsoleOutput,
     COORD dwSize
    );



BOOL
__stdcall
SetConsoleCursorPosition(
     HANDLE hConsoleOutput,
     COORD dwCursorPosition
    );



COORD
__stdcall
GetLargestConsoleWindowSize(
     HANDLE hConsoleOutput
    );



BOOL
__stdcall
SetConsoleTextAttribute(
     HANDLE hConsoleOutput,
     WORD wAttributes
    );



BOOL
__stdcall
SetConsoleWindowInfo(
     HANDLE hConsoleOutput,
     BOOL bAbsolute,
     const SMALL_RECT* lpConsoleWindow
    );



BOOL
__stdcall
WriteConsoleOutputCharacterA(
     HANDLE hConsoleOutput,
     LPCSTR lpCharacter,
     DWORD nLength,
     COORD dwWriteCoord,
     LPDWORD lpNumberOfCharsWritten
    );


BOOL
__stdcall
WriteConsoleOutputCharacterW(
     HANDLE hConsoleOutput,
     LPCWSTR lpCharacter,
     DWORD nLength,
     COORD dwWriteCoord,
     LPDWORD lpNumberOfCharsWritten
    );
]]

--[[
#ifdef UNICODE
#define WriteConsoleOutputCharacter  WriteConsoleOutputCharacterW
#else
#define WriteConsoleOutputCharacter  WriteConsoleOutputCharacterA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
WriteConsoleOutputAttribute(
     HANDLE hConsoleOutput,
     const WORD* lpAttribute,
     DWORD nLength,
     COORD dwWriteCoord,
     LPDWORD lpNumberOfAttrsWritten
    );



BOOL
__stdcall
ReadConsoleOutputCharacterA(
     HANDLE hConsoleOutput,
     LPSTR lpCharacter,
     DWORD nLength,
     COORD dwReadCoord,
     LPDWORD lpNumberOfCharsRead
    );


BOOL
__stdcall
ReadConsoleOutputCharacterW(
     HANDLE hConsoleOutput,
     LPWSTR lpCharacter,
     DWORD nLength,
     COORD dwReadCoord,
     LPDWORD lpNumberOfCharsRead
    );
]]

--[[
#ifdef UNICODE
#define ReadConsoleOutputCharacter  ReadConsoleOutputCharacterW
#else
#define ReadConsoleOutputCharacter  ReadConsoleOutputCharacterA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
ReadConsoleOutputAttribute(
     HANDLE hConsoleOutput,
     LPWORD lpAttribute,
     DWORD nLength,
     COORD dwReadCoord,
     LPDWORD lpNumberOfAttrsRead
    );



BOOL
__stdcall
WriteConsoleInputA(
     HANDLE hConsoleInput,
     const INPUT_RECORD* lpBuffer,
     DWORD nLength,
     LPDWORD lpNumberOfEventsWritten
    );


BOOL
__stdcall
WriteConsoleInputW(
     HANDLE hConsoleInput,
     const INPUT_RECORD* lpBuffer,
     DWORD nLength,
     LPDWORD lpNumberOfEventsWritten
    );
]]

--[[
#ifdef UNICODE
#define WriteConsoleInput  WriteConsoleInputW
#else
#define WriteConsoleInput  WriteConsoleInputA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
ScrollConsoleScreenBufferA(
     HANDLE hConsoleOutput,
     const SMALL_RECT* lpScrollRectangle,
     const SMALL_RECT* lpClipRectangle,
     COORD dwDestinationOrigin,
     const CHAR_INFO* lpFill
    );


BOOL
__stdcall
ScrollConsoleScreenBufferW(
     HANDLE hConsoleOutput,
     const SMALL_RECT* lpScrollRectangle,
     const SMALL_RECT* lpClipRectangle,
     COORD dwDestinationOrigin,
     const CHAR_INFO* lpFill
    );
]]

--[[
#ifdef UNICODE
#define ScrollConsoleScreenBuffer  ScrollConsoleScreenBufferW
#else
#define ScrollConsoleScreenBuffer  ScrollConsoleScreenBufferA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
WriteConsoleOutputA(
     HANDLE hConsoleOutput,
     const CHAR_INFO* lpBuffer,
     COORD dwBufferSize,
     COORD dwBufferCoord,
     PSMALL_RECT lpWriteRegion
    );


BOOL
__stdcall
WriteConsoleOutputW(
     HANDLE hConsoleOutput,
     const CHAR_INFO* lpBuffer,
     COORD dwBufferSize,
     COORD dwBufferCoord,
     PSMALL_RECT lpWriteRegion
    );
]]

--[[
#ifdef UNICODE
#define WriteConsoleOutput  WriteConsoleOutputW
#else
#define WriteConsoleOutput  WriteConsoleOutputA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
ReadConsoleOutputA(
     HANDLE hConsoleOutput,
     PCHAR_INFO lpBuffer,
     COORD dwBufferSize,
     COORD dwBufferCoord,
     PSMALL_RECT lpReadRegion
    );


BOOL
__stdcall
ReadConsoleOutputW(
     HANDLE hConsoleOutput,
     PCHAR_INFO lpBuffer,
     COORD dwBufferSize,
     COORD dwBufferCoord,
     PSMALL_RECT lpReadRegion
    );
]]

--[[
#ifdef UNICODE
#define ReadConsoleOutput  ReadConsoleOutputW
#else
#define ReadConsoleOutput  ReadConsoleOutputA
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD
__stdcall
GetConsoleTitleA(
     LPSTR lpConsoleTitle,
     DWORD nSize
    );


DWORD
__stdcall
GetConsoleTitleW(
     LPWSTR lpConsoleTitle,
     DWORD nSize
    );
]]

--[[
#ifdef UNICODE
#define GetConsoleTitle  GetConsoleTitleW
#else
#define GetConsoleTitle  GetConsoleTitleA
#endif // !UNICODE
--]]


ffi.cdef[[
DWORD
__stdcall
GetConsoleOriginalTitleA(
     LPSTR lpConsoleTitle,
     DWORD nSize
    );


DWORD
__stdcall
GetConsoleOriginalTitleW(
     LPWSTR lpConsoleTitle,
     DWORD nSize
    );
]]

--[[
#ifdef UNICODE
#define GetConsoleOriginalTitle  GetConsoleOriginalTitleW
#else
#define GetConsoleOriginalTitle  GetConsoleOriginalTitleA
#endif // !UNICODE
--]]    


ffi.cdef[[
BOOL
__stdcall
SetConsoleTitleA(
     LPCSTR lpConsoleTitle
    );


BOOL
__stdcall
SetConsoleTitleW(
     LPCWSTR lpConsoleTitle
    );
]]

--[[
#ifdef UNICODE
#define SetConsoleTitle  SetConsoleTitleW
#else
#define SetConsoleTitle  SetConsoleTitleA
#endif // !UNICODE
--]]
