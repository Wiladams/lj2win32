local ffi = require("ffi")

-- windef.h -- Basic Windows Type Definitions                                *
--if _WINDEF_ then
--    return;
--end
print("==== WINDEF ====")
_WINDEF_ = true;



require("win32.minwindef")
require("win32.winnt")

local DECLARE_HANDLE = DECLARE_HANDLE




DECLARE_HANDLE("HWND");
DECLARE_HANDLE("HHOOK");
DECLARE_HANDLE("HEVENT");
DECLARE_HANDLE("HGDIOBJ");
DECLARE_HANDLE("HACCEL");
DECLARE_HANDLE("HBITMAP");
DECLARE_HANDLE("HBRUSH");
DECLARE_HANDLE("HCOLORSPACE");
DECLARE_HANDLE("HDC");
DECLARE_HANDLE("HGLRC");          -- OpenGL
DECLARE_HANDLE("HDESK");
DECLARE_HANDLE("HENHMETAFILE");
DECLARE_HANDLE("HFONT");
DECLARE_HANDLE("HICON");
DECLARE_HANDLE("HMENU");
DECLARE_HANDLE("HPALETTE");
DECLARE_HANDLE("HPEN");
DECLARE_HANDLE("HWINEVENTHOOK");
DECLARE_HANDLE("HMONITOR");
DECLARE_HANDLE("HUMPD");
DECLARE_HANDLE("HCURSOR");    -- HICONs & HCURSORs are not polymorphic


ffi.cdef[[
typedef DWORD   COLORREF;
typedef DWORD   *LPCOLORREF;

//static const int HFILE_ERROR = HFILE-1;

typedef struct tagRECT
{
    LONG    left;
    LONG    top;
    LONG    right;
    LONG    bottom;
} RECT, *PRECT, *NPRECT, *LPRECT;

typedef const RECT * LPCRECT;

typedef struct _RECTL       /* rcl */
{
    LONG    left;
    LONG    top;
    LONG    right;
    LONG    bottom;
} RECTL, *PRECTL, *LPRECTL;

typedef const RECTL * LPCRECTL;

typedef struct tagPOINT
{
    LONG  x;
    LONG  y;
} POINT, *PPOINT, *NPPOINT, *LPPOINT;

typedef struct _POINTL      /* ptl  */
{
    LONG  x;
    LONG  y;
} POINTL, *PPOINTL;

typedef struct tagSIZE
{
    LONG        cx;
    LONG        cy;
} SIZE, *PSIZE, *LPSIZE;

typedef SIZE               SIZEL;
typedef SIZE               *PSIZEL, *LPSIZEL;
]]


if not _MAC then
ffi.cdef[[
typedef struct tagPOINTS
{
    SHORT   x;
    SHORT   y;
} POINTS, *PPOINTS, *LPPOINTS;
]]
else
ffi.cdef[[
typedef struct tagPOINTS
{
    SHORT   y;
    SHORT   x;
} POINTS, *PPOINTS, *LPPOINTS;
]]
end

ffi.cdef[[
/* mode selections for the device mode function */
static const int DM_UPDATE          = 1;
static const int DM_COPY            = 2;
static const int DM_PROMPT          = 4;
static const int DM_MODIFY          = 8;

static const int DM_IN_BUFFER       = DM_MODIFY;
static const int DM_IN_PROMPT       = DM_PROMPT;
static const int DM_OUT_BUFFER      = DM_COPY;
static const int DM_OUT_DEFAULT     = DM_UPDATE;

/* device capabilities indices */
static const int DC_FIELDS          = 1;
static const int DC_PAPERS          = 2;
static const int DC_PAPERSIZE       = 3;
static const int DC_MINEXTENT       = 4;
static const int DC_MAXEXTENT       = 5;
static const int DC_BINS            = 6;
static const int DC_DUPLEX          = 7;
static const int DC_SIZE            = 8;
static const int DC_EXTRA           = 9;
static const int DC_VERSION         = 10;
static const int DC_DRIVER          = 11;
static const int DC_BINNAMES        = 12;
static const int DC_ENUMRESOLUTIONS = 13;
static const int DC_FILEDEPENDENCIES =14;
static const int DC_TRUETYPE         =15;
static const int DC_PAPERNAMES       =16;
static const int DC_ORIENTATION      =17;
static const int DC_COPIES           =18;
]]



_DPI_AWARENESS_CONTEXTS_ = true;

DECLARE_HANDLE("DPI_AWARENESS_CONTEXT");

ffi.cdef[[
typedef enum DPI_AWARENESS {
    DPI_AWARENESS_INVALID           = -1,
    DPI_AWARENESS_UNAWARE           = 0,
    DPI_AWARENESS_SYSTEM_AWARE      = 1,
    DPI_AWARENESS_PER_MONITOR_AWARE = 2
} DPI_AWARENESS;
]]

--[[
    -- BUGBUG
-- Problem I'm having is handles are pointers, and they differ
-- between 32-bit and 64-bit, so making them static const int doesn't
-- quite work I think.
ffi.cdef[[
DPI_AWARENESS_CONTEXT_UNAWARE              = ((DPI_AWARENESS_CONTEXT)-1);
DPI_AWARENESS_CONTEXT_SYSTEM_AWARE         = ((DPI_AWARENESS_CONTEXT)-2);
DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE    = ((DPI_AWARENESS_CONTEXT)-3);
DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2 = ((DPI_AWARENESS_CONTEXT)-4);
DPI_AWARENESS_CONTEXT_UNAWARE_GDISCALED    = ((DPI_AWARENESS_CONTEXT)-5);
]]
--]]

ffi.cdef[[
typedef enum DPI_HOSTING_BEHAVIOR {
    DPI_HOSTING_BEHAVIOR_INVALID     = -1,
    DPI_HOSTING_BEHAVIOR_DEFAULT     = 0,
    DPI_HOSTING_BEHAVIOR_MIXED       = 1
} DPI_HOSTING_BEHAVIOR;
]]

return exports
