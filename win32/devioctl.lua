local ffi = require("ffi")
local bit = require("bit")
local lshift, rshift = bit.lshift, bit.rshift;
local bor, band = bit.bor, bit.band;

require("win32.intsafe")

local exports = {}

--[[
// Define the various device type values.  Note that values used by Microsoft
// Corporation are in the range 0-32767, and 32768-65535 are reserved for use
// by customers.
--]]
ffi.cdef[[
typedef ULONG DEVICE_TYPE;
]]

ffi.cdef[[
static const int FILE_DEVICE_BEEP                = 0x00000001;
static const int FILE_DEVICE_CD_ROM              = 0x00000002;
static const int FILE_DEVICE_CD_ROM_FILE_SYSTEM  = 0x00000003;
static const int FILE_DEVICE_CONTROLLER          = 0x00000004;
static const int FILE_DEVICE_DATALINK            = 0x00000005;
static const int FILE_DEVICE_DFS                 = 0x00000006;
static const int FILE_DEVICE_DISK                = 0x00000007;
static const int FILE_DEVICE_DISK_FILE_SYSTEM    = 0x00000008;
static const int FILE_DEVICE_FILE_SYSTEM         = 0x00000009;
static const int FILE_DEVICE_INPORT_PORT         = 0x0000000a;
static const int FILE_DEVICE_KEYBOARD            = 0x0000000b;
static const int FILE_DEVICE_MAILSLOT            = 0x0000000c;
static const int FILE_DEVICE_MIDI_IN             = 0x0000000d;
static const int FILE_DEVICE_MIDI_OUT            = 0x0000000e;
static const int FILE_DEVICE_MOUSE               = 0x0000000f;
static const int FILE_DEVICE_MULTI_UNC_PROVIDER  = 0x00000010;
static const int FILE_DEVICE_NAMED_PIPE          = 0x00000011;
static const int FILE_DEVICE_NETWORK             = 0x00000012;
static const int FILE_DEVICE_NETWORK_BROWSER     = 0x00000013;
static const int FILE_DEVICE_NETWORK_FILE_SYSTEM = 0x00000014;
static const int FILE_DEVICE_NULL                = 0x00000015;
static const int FILE_DEVICE_PARALLEL_PORT       = 0x00000016;
static const int FILE_DEVICE_PHYSICAL_NETCARD    = 0x00000017;
static const int FILE_DEVICE_PRINTER             = 0x00000018;
static const int FILE_DEVICE_SCANNER             = 0x00000019;
static const int FILE_DEVICE_SERIAL_MOUSE_PORT   = 0x0000001a;
static const int FILE_DEVICE_SERIAL_PORT         = 0x0000001b;
static const int FILE_DEVICE_SCREEN              = 0x0000001c;
static const int FILE_DEVICE_SOUND               = 0x0000001d;
static const int FILE_DEVICE_STREAMS             = 0x0000001e;
static const int FILE_DEVICE_TAPE                = 0x0000001f;
static const int FILE_DEVICE_TAPE_FILE_SYSTEM    = 0x00000020;
static const int FILE_DEVICE_TRANSPORT           = 0x00000021;
static const int FILE_DEVICE_UNKNOWN             = 0x00000022;
static const int FILE_DEVICE_VIDEO               = 0x00000023;
static const int FILE_DEVICE_VIRTUAL_DISK        = 0x00000024;
static const int FILE_DEVICE_WAVE_IN             = 0x00000025;
static const int FILE_DEVICE_WAVE_OUT            = 0x00000026;
static const int FILE_DEVICE_8042_PORT           = 0x00000027;
static const int FILE_DEVICE_NETWORK_REDIRECTOR  = 0x00000028;
static const int FILE_DEVICE_BATTERY             = 0x00000029;
static const int FILE_DEVICE_BUS_EXTENDER        = 0x0000002a;
static const int FILE_DEVICE_MODEM               = 0x0000002b;
static const int FILE_DEVICE_VDM                 = 0x0000002c;
static const int FILE_DEVICE_MASS_STORAGE        = 0x0000002d;
static const int FILE_DEVICE_SMB                 = 0x0000002e;
static const int FILE_DEVICE_KS                  = 0x0000002f;
static const int FILE_DEVICE_CHANGER             = 0x00000030;
static const int FILE_DEVICE_SMARTCARD           = 0x00000031;
static const int FILE_DEVICE_ACPI                = 0x00000032;
static const int FILE_DEVICE_DVD                 = 0x00000033;
static const int FILE_DEVICE_FULLSCREEN_VIDEO    = 0x00000034;
static const int FILE_DEVICE_DFS_FILE_SYSTEM     = 0x00000035;
static const int FILE_DEVICE_DFS_VOLUME          = 0x00000036;
static const int FILE_DEVICE_SERENUM             = 0x00000037;
static const int FILE_DEVICE_TERMSRV             = 0x00000038;
static const int FILE_DEVICE_KSEC                = 0x00000039;
static const int FILE_DEVICE_FIPS                = 0x0000003A;
static const int FILE_DEVICE_INFINIBAND          = 0x0000003B;
static const int FILE_DEVICE_VMBUS               = 0x0000003E;
static const int FILE_DEVICE_CRYPT_PROVIDER      = 0x0000003F;
static const int FILE_DEVICE_WPD                 = 0x00000040;
static const int FILE_DEVICE_BLUETOOTH           = 0x00000041;
static const int FILE_DEVICE_MT_COMPOSITE        = 0x00000042;
static const int FILE_DEVICE_MT_TRANSPORT        = 0x00000043;
static const int FILE_DEVICE_BIOMETRIC           = 0x00000044;
static const int FILE_DEVICE_PMI                 = 0x00000045;
static const int FILE_DEVICE_EHSTOR              = 0x00000046;
static const int FILE_DEVICE_DEVAPI              = 0x00000047;
static const int FILE_DEVICE_GPIO                = 0x00000048;
static const int FILE_DEVICE_USBEX               = 0x00000049;
static const int FILE_DEVICE_CONSOLE             = 0x00000050;
static const int FILE_DEVICE_NFP                 = 0x00000051;
static const int FILE_DEVICE_SYSENV              = 0x00000052;
static const int FILE_DEVICE_VIRTUAL_BLOCK       = 0x00000053;
static const int FILE_DEVICE_POINT_OF_SERVICE    = 0x00000054;
static const int FILE_DEVICE_STORAGE_REPLICATION = 0x00000055;
static const int FILE_DEVICE_TRUST_ENV           = 0x00000056;
static const int FILE_DEVICE_UCM                 = 0x00000057;
static const int FILE_DEVICE_UCMTCPCI            = 0x00000058;
]]

--[[
//
// Macro definition for defining IOCTL and FSCTL function control codes.  Note
// that function codes 0-2047 are reserved for Microsoft Corporation, and
// 2048-4095 are reserved for customers.
//
--]]

function exports.CTL_CODE( DeviceType, Function, Method, Access ) 
    return bor(lshift(DeviceType, 16) , lshift(Access, 14) , lshift(Function, 2) , Method)
end 

-- Macro to extract device type out of the device io control code
function exports.DEVICE_TYPE_FROM_CTL_CODE(ctrlCode)     
    return rshift(band(ctrlCode, 0xffff0000), 16)
end

-- Macro to extract buffering method out of the device io control code
function exports.METHOD_FROM_CTL_CODE(ctrlCode)          
    return band(ctrlCode, 3)
end

ffi.cdef[[
//
// Define the method codes for how buffers are passed for I/O and FS controls
//
static const int METHOD_BUFFERED   =              0;
static const int METHOD_IN_DIRECT  =              1;
static const int METHOD_OUT_DIRECT =              2;
static const int METHOD_NEITHER    =              3;
]]

--[[
//
// Define some easier to comprehend aliases:
//   METHOD_DIRECT_TO_HARDWARE (writes, aka METHOD_IN_DIRECT)
//   METHOD_DIRECT_FROM_HARDWARE (reads, aka METHOD_OUT_DIRECT)
//
--]]
exports.METHOD_DIRECT_TO_HARDWARE =      exports.METHOD_IN_DIRECT;
exports.METHOD_DIRECT_FROM_HARDWARE = exports.METHOD_OUT_DIRECT;


--[[
//
// Define the access check value for any access
//
//
// The FILE_READ_ACCESS and FILE_WRITE_ACCESS constants are also defined in
// ntioapi.h as FILE_READ_DATA and FILE_WRITE_DATA. The values for these
// constants *MUST* always be in sync.
//
//
// FILE_SPECIAL_ACCESS is checked by the NT I/O system the same as FILE_ANY_ACCESS.
// The file systems, however, may add additional access checks for I/O and FS controls
// that use this value.
//
--]]

ffi.cdef[[
static const int FILE_ANY_ACCESS      =           0;
static const int FILE_SPECIAL_ACCESS  =  FILE_ANY_ACCESS;
static const int FILE_READ_ACCESS     =     0x0001;    // file & pipe
static const int FILE_WRITE_ACCESS    =     0x0002;    // file & pipe
]]

return exports
