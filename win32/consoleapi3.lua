--* consoleapi3.h -- ApiSet Contract for api-ms-win-core-console-l3                                *
local ffi = require("ffi")





--#include <apiset.h>
--#include <apisetcconv.h>
require("win32.minwindef")
require("win32.minwinbase")

require("win32.wincontypes")
require("win32.windef")

if not NOGDI then
require("win32.wingdi")
end



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
GetNumberOfConsoleMouseButtons(
     LPDWORD lpNumberOfMouseButtons
    );
]]

if (_WIN32_WINNT >= 0x0500) then

ffi.cdef[[
COORD
__stdcall
GetConsoleFontSize(
     HANDLE hConsoleOutput,
     DWORD nFont
    );



BOOL
__stdcall
GetCurrentConsoleFont(
     HANDLE hConsoleOutput,
     BOOL bMaximumWindow,
     PCONSOLE_FONT_INFO lpConsoleCurrentFont
    );
]]

if not NOGDI then
ffi.cdef[[
typedef struct _CONSOLE_FONT_INFOEX {
    ULONG cbSize;
    DWORD nFont;
    COORD dwFontSize;
    UINT FontFamily;
    UINT FontWeight;
    WCHAR FaceName[LF_FACESIZE];
} CONSOLE_FONT_INFOEX, *PCONSOLE_FONT_INFOEX;
]]

ffi.cdef[[
BOOL
__stdcall
GetCurrentConsoleFontEx(
     HANDLE hConsoleOutput,
     BOOL bMaximumWindow,
     PCONSOLE_FONT_INFOEX lpConsoleCurrentFontEx
    );



BOOL
__stdcall
SetCurrentConsoleFontEx(
     HANDLE hConsoleOutput,
     BOOL bMaximumWindow,
     PCONSOLE_FONT_INFOEX lpConsoleCurrentFontEx
    );
]]

end


ffi.cdef[[
static const int CONSOLE_NO_SELECTION          =  0x0000;
static const int CONSOLE_SELECTION_IN_PROGRESS =  0x0001;   // selection has begun
static const int CONSOLE_SELECTION_NOT_EMPTY   =  0x0002;   // non-null select rectangle
static const int CONSOLE_MOUSE_SELECTION       =  0x0004;   // selecting with mouse
static const int CONSOLE_MOUSE_DOWN            =  0x0008;   // mouse is down

typedef struct _CONSOLE_SELECTION_INFO {
    DWORD dwFlags;
    COORD dwSelectionAnchor;
    SMALL_RECT srSelection;
} CONSOLE_SELECTION_INFO, *PCONSOLE_SELECTION_INFO;
]]

ffi.cdef[[
BOOL
__stdcall
GetConsoleSelectionInfo(
     PCONSOLE_SELECTION_INFO lpConsoleSelectionInfo
    );
]]


ffi.cdef[[
static const int HISTORY_NO_DUP_FLAG = 0x1;

typedef struct _CONSOLE_HISTORY_INFO {
    UINT cbSize;
    UINT HistoryBufferSize;
    UINT NumberOfHistoryBuffers;
    DWORD dwFlags;
} CONSOLE_HISTORY_INFO, *PCONSOLE_HISTORY_INFO;


BOOL
__stdcall
GetConsoleHistoryInfo(
     PCONSOLE_HISTORY_INFO lpConsoleHistoryInfo
    );



BOOL
__stdcall
SetConsoleHistoryInfo(
     PCONSOLE_HISTORY_INFO lpConsoleHistoryInfo
    );


static const int CONSOLE_FULLSCREEN = 1;            // fullscreen console
static const int CONSOLE_FULLSCREEN_HARDWARE = 2;   // console owns the hardware


BOOL
__stdcall
GetConsoleDisplayMode(
     LPDWORD lpModeFlags
    );


static const int CONSOLE_FULLSCREEN_MODE = 1;
static const int CONSOLE_WINDOWED_MODE = 2;


BOOL
__stdcall
SetConsoleDisplayMode(
     HANDLE hConsoleOutput,
     DWORD dwFlags,
     PCOORD lpNewScreenBufferDimensions
    );

    

HWND
__stdcall
GetConsoleWindow(
    VOID
    );
]]

end --/* _WIN32_WINNT >= 0x0500 */

if (_WIN32_WINNT >= 0x0501) then

ffi.cdef[[
BOOL
__stdcall
AddConsoleAliasA(
     LPSTR Source,
     LPSTR Target,
     LPSTR ExeName
    );


BOOL
__stdcall
AddConsoleAliasW(
     LPWSTR Source,
     LPWSTR Target,
     LPWSTR ExeName
    );
]]

--[[
#ifdef UNICODE
#define AddConsoleAlias  AddConsoleAliasW
#else
#define AddConsoleAlias  AddConsoleAliasA
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD
__stdcall
GetConsoleAliasA(
     LPSTR Source,
     LPSTR TargetBuffer,
     DWORD TargetBufferLength,
     LPSTR ExeName
    );


DWORD
__stdcall
GetConsoleAliasW(
     LPWSTR Source,
     LPWSTR TargetBuffer,
     DWORD TargetBufferLength,
     LPWSTR ExeName
    );
]]

--[[
#ifdef UNICODE
#define GetConsoleAlias  GetConsoleAliasW
#else
#define GetConsoleAlias  GetConsoleAliasA
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD
__stdcall
GetConsoleAliasesLengthA(
     LPSTR ExeName
    );


DWORD
__stdcall
GetConsoleAliasesLengthW(
     LPWSTR ExeName
    );
]]

--[[
#ifdef UNICODE
#define GetConsoleAliasesLength  GetConsoleAliasesLengthW
#else
#define GetConsoleAliasesLength  GetConsoleAliasesLengthA
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD
__stdcall
GetConsoleAliasExesLengthA(
    VOID
    );


DWORD
__stdcall
GetConsoleAliasExesLengthW(
    VOID
    );
]]

--[[
#ifdef UNICODE
#define GetConsoleAliasExesLength  GetConsoleAliasExesLengthW
#else
#define GetConsoleAliasExesLength  GetConsoleAliasExesLengthA
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD
__stdcall
GetConsoleAliasesA(
     LPSTR AliasBuffer,
     DWORD AliasBufferLength,
     LPSTR ExeName
    );


DWORD
__stdcall
GetConsoleAliasesW(
     LPWSTR AliasBuffer,
     DWORD AliasBufferLength,
     LPWSTR ExeName
    );
]]

--[[
#ifdef UNICODE
#define GetConsoleAliases  GetConsoleAliasesW
#else
#define GetConsoleAliases  GetConsoleAliasesA
#endif // !UNICODE
--]]


ffi.cdef[[
DWORD
__stdcall
GetConsoleAliasExesA(
     LPSTR ExeNameBuffer,
     DWORD ExeNameBufferLength
    );


DWORD
__stdcall
GetConsoleAliasExesW(
     LPWSTR ExeNameBuffer,
     DWORD ExeNameBufferLength
    );
]]

--[[
#ifdef UNICODE
#define GetConsoleAliasExes  GetConsoleAliasExesW
#else
#define GetConsoleAliasExes  GetConsoleAliasExesA
#endif // !UNICODE
--]]
end --/* _WIN32_WINNT >= 0x0501 */

ffi.cdef[[
VOID
__stdcall
ExpungeConsoleCommandHistoryA(
     LPSTR ExeName
    );


VOID
__stdcall
ExpungeConsoleCommandHistoryW(
     LPWSTR ExeName
    );
]]

--[[
#ifdef UNICODE
#define ExpungeConsoleCommandHistory  ExpungeConsoleCommandHistoryW
#else
#define ExpungeConsoleCommandHistory  ExpungeConsoleCommandHistoryA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
SetConsoleNumberOfCommandsA(
     DWORD Number,
     LPSTR ExeName
    );


BOOL
__stdcall
SetConsoleNumberOfCommandsW(
     DWORD Number,
     LPWSTR ExeName
    );
]]

--[[
#ifdef UNICODE
#define SetConsoleNumberOfCommands  SetConsoleNumberOfCommandsW
#else
#define SetConsoleNumberOfCommands  SetConsoleNumberOfCommandsA
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD
__stdcall
GetConsoleCommandHistoryLengthA(
     LPSTR ExeName
    );


DWORD
__stdcall
GetConsoleCommandHistoryLengthW(
     LPWSTR ExeName
    );
]]

--[[
#ifdef UNICODE
#define GetConsoleCommandHistoryLength  GetConsoleCommandHistoryLengthW
#else
#define GetConsoleCommandHistoryLength  GetConsoleCommandHistoryLengthA
#endif // !UNICODE
--]]

ffi.cdef[[
DWORD
__stdcall
GetConsoleCommandHistoryA(
    LPSTR Commands,
     DWORD CommandBufferLength,
     LPSTR ExeName
    );


DWORD
__stdcall
GetConsoleCommandHistoryW(
    LPWSTR Commands,
     DWORD CommandBufferLength,
     LPWSTR ExeName
    );
]]

--[[
#ifdef UNICODE
#define GetConsoleCommandHistory  GetConsoleCommandHistoryW
#else
#define GetConsoleCommandHistory  GetConsoleCommandHistoryA
#endif // !UNICODE
--]]

if (_WIN32_WINNT >= 0x0501) then

ffi.cdef[[
DWORD
__stdcall
GetConsoleProcessList(
     LPDWORD lpdwProcessList,
     DWORD dwProcessCount
    );
]]

end --/* _WIN32_WINNT >= 0x0501 */


end --// WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

