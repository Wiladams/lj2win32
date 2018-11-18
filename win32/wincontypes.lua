local ffi = require("ffi")

require("win32.minwindef")


ffi.cdef[[
typedef struct _COORD {
    SHORT X;
    SHORT Y;
} COORD, *PCOORD;

typedef struct _SMALL_RECT {
    SHORT Left;
    SHORT Top;
    SHORT Right;
    SHORT Bottom;
} SMALL_RECT, *PSMALL_RECT;

typedef struct _KEY_EVENT_RECORD {
    BOOL bKeyDown;
    WORD wRepeatCount;
    WORD wVirtualKeyCode;
    WORD wVirtualScanCode;
    union {
        WCHAR UnicodeChar;
        CHAR   AsciiChar;
    } uChar;
    DWORD dwControlKeyState;
} KEY_EVENT_RECORD, *PKEY_EVENT_RECORD;
]]

ffi.cdef[[
//
// ControlKeyState flags
//

static const int RIGHT_ALT_PRESSED     = 0x0001; // the right alt key is pressed.
static const int LEFT_ALT_PRESSED      = 0x0002; // the left alt key is pressed.
static const int RIGHT_CTRL_PRESSED    = 0x0004; // the right ctrl key is pressed.
static const int LEFT_CTRL_PRESSED     = 0x0008; // the left ctrl key is pressed.
static const int SHIFT_PRESSED         = 0x0010; // the shift key is pressed.
static const int NUMLOCK_ON            = 0x0020; // the numlock light is on.
static const int SCROLLLOCK_ON         = 0x0040; // the scrolllock light is on.
static const int CAPSLOCK_ON           = 0x0080; // the capslock light is on.
static const int ENHANCED_KEY          = 0x0100; // the key is enhanced.
static const int NLS_DBCSCHAR          = 0x00010000; // DBCS for JPN: SBCS/DBCS mode.
static const int NLS_ALPHANUMERIC      = 0x00000000; // DBCS for JPN: Alphanumeric mode.
static const int NLS_KATAKANA          = 0x00020000; // DBCS for JPN: Katakana mode.
static const int NLS_HIRAGANA          = 0x00040000; // DBCS for JPN: Hiragana mode.
static const int NLS_ROMAN             = 0x00400000; // DBCS for JPN: Roman/Noroman mode.
static const int NLS_IME_CONVERSION    = 0x00800000; // DBCS for JPN: IME conversion.
static const int NLS_IME_DISABLE       = 0x20000000; // DBCS for JPN: IME enable/disable.
]]

ffi.cdef[[
typedef struct _MOUSE_EVENT_RECORD {
    COORD dwMousePosition;
    DWORD dwButtonState;
    DWORD dwControlKeyState;
    DWORD dwEventFlags;
} MOUSE_EVENT_RECORD, *PMOUSE_EVENT_RECORD;
]]

ffi.cdef[[
//
// ButtonState flags
//
static const int FROM_LEFT_1ST_BUTTON_PRESSED    =0x0001;
static const int RIGHTMOST_BUTTON_PRESSED        =0x0002;
static const int FROM_LEFT_2ND_BUTTON_PRESSED    =0x0004;
static const int FROM_LEFT_3RD_BUTTON_PRESSED    =0x0008;
static const int FROM_LEFT_4TH_BUTTON_PRESSED    =0x0010;

//
// EventFlags
//
static const int MOUSE_MOVED   =0x0001;
static const int DOUBLE_CLICK  =0x0002;
static const int MOUSE_WHEELED =0x0004;
static const int MOUSE_HWHEELED =0x0008;
]]


ffi.cdef[[
typedef struct _WINDOW_BUFFER_SIZE_RECORD {
    COORD dwSize;
} WINDOW_BUFFER_SIZE_RECORD, *PWINDOW_BUFFER_SIZE_RECORD;

typedef struct _MENU_EVENT_RECORD {
    UINT dwCommandId;
} MENU_EVENT_RECORD, *PMENU_EVENT_RECORD;

typedef struct _FOCUS_EVENT_RECORD {
    BOOL bSetFocus;
} FOCUS_EVENT_RECORD, *PFOCUS_EVENT_RECORD;

typedef struct _INPUT_RECORD {
    WORD EventType;
    union {
        KEY_EVENT_RECORD KeyEvent;
        MOUSE_EVENT_RECORD MouseEvent;
        WINDOW_BUFFER_SIZE_RECORD WindowBufferSizeEvent;
        MENU_EVENT_RECORD MenuEvent;
        FOCUS_EVENT_RECORD FocusEvent;
    } Event;
} INPUT_RECORD, *PINPUT_RECORD;
]]

ffi.cdef[[
//
//  EventType flags:
//

static const int KEY_EVENT      = 0x0001; // Event contains key event record
static const int MOUSE_EVENT    = 0x0002; // Event contains mouse event record
static const int WINDOW_BUFFER_SIZE_EVENT =0x0004; // Event contains window change event record
static const int MENU_EVENT     = 0x0008; // Event contains menu event record
static const int FOCUS_EVENT    = 0x0010; // event contains focus change
]]

ffi.cdef[[
typedef struct _CHAR_INFO {
    union {
        WCHAR UnicodeChar;
        CHAR   AsciiChar;
    } Char;
    WORD Attributes;
} CHAR_INFO, *PCHAR_INFO;

typedef struct _CONSOLE_FONT_INFO {
    DWORD  nFont;
    COORD  dwFontSize;
} CONSOLE_FONT_INFO, *PCONSOLE_FONT_INFO;
]]

ffi.cdef[[
typedef VOID* HPCON;
]]


