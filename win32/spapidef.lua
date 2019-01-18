
local ffi = require("ffi")

if not _INC_SPAPIDEF then
_INC_SPAPIDEF = true


require("win32.winapifamily")


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


if not SP_LOG_TOKEN then
ffi.cdef[[
typedef DWORDLONG SP_LOG_TOKEN;
typedef DWORDLONG *PSP_LOG_TOKEN;
]]
end

ffi.cdef[[
//
// Special txtlog token values
//

static const int LOGTOKEN_TYPE_MASK            =  3;

static const int LOGTOKEN_UNSPECIFIED          =  0;
static const int LOGTOKEN_NO_LOG               =  1;
static const int LOGTOKEN_SETUPAPI_APPLOG      =  2;
static const int LOGTOKEN_SETUPAPI_DEVLOG      =  3;


//
// Flags for SetupCreateTextLogSection
//

static const int TXTLOG_SETUPAPI_DEVLOG      = 0x00000001;            // 1 = setupdi.log, 0 = setupapi.log
static const int TXTLOG_SETUPAPI_CMDLINE     = 0x00000002;            // log the command line

static const int TXTLOG_SETUPAPI_BITS        = 0x00000003;
]]

ffi.cdef[[
//
// Flags for SetupWriteTextLog
//

//
// Event Levels (bits 0-3)
//

static const int TXTLOG_ERROR                    = 0x1;             // shows entries which indicate a real problem
static const int TXTLOG_WARNING                  = 0x2;             // shows entries which indicate a potential problem
static const int TXTLOG_SYSTEM_STATE_CHANGE      = 0x3;             // system changes only
static const int TXTLOG_SUMMARY                  = 0x4;             // show basic operation surrounding system changes
static const int TXTLOG_DETAILS                  = 0x5;             // detailed operation of the install process
static const int TXTLOG_VERBOSE                  = 0x6;             // log entries which potentially generate a lot of data
static const int TXTLOG_VERY_VERBOSE             = 0x7;             // highest level shows all log entries

//
// Bits reserved for internal use
//

static const int TXTLOG_RESERVED_FLAGS   = 0x0000FFF0;

//
// Basic flags (bits 4-31)
//

static const int TXTLOG_TIMESTAMP        = 0x00010000;
static const int TXTLOG_DEPTH_INCR       = 0x00020000;
static const int TXTLOG_DEPTH_DECR       = 0x00040000;
static const int TXTLOG_TAB_1            = 0x00080000;
static const int TXTLOG_FLUSH_FILE       = 0x00100000;
]]

local function TXTLOG_LEVEL(flags) 
    return (flags & = 0xf)
end

ffi.cdef[[
//
// Setupapi, Setupdi event categories
//

static const int TXTLOG_DEVINST          = 0x00000001;
static const int TXTLOG_INF              = 0x00000002;
static const int TXTLOG_FILEQ            = 0x00000004;
static const int TXTLOG_COPYFILES        = 0x00000008;

static const int TXTLOG_SIGVERIF         = 0x00000020;

static const int TXTLOG_BACKUP           = 0x00000080;
static const int TXTLOG_UI               = 0x00000100;
static const int TXTLOG_UTIL             = 0x00000200;
static const int TXTLOG_INFDB            = 0x00000400;

static const int TXTLOG_POLICY           = 0x00800000;
static const int TXTLOG_NEWDEV           = 0x01000000;
static const int TXTLOG_UMPNPMGR         = 0x02000000;
static const int TXTLOG_DRIVER_STORE     = 0x04000000;
static const int TXTLOG_SETUP            = 0x08000000;
static const int TXTLOG_CMI              = 0x10000000;
static const int TXTLOG_DEVMGR           = 0x20000000;

static const int TXTLOG_INSTALLER        = 0x40000000;
static const int TXTLOG_VENDOR           = 0x80000000;
]]


end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


end --// _INC_SPAPIDEF

