--[[
    This is the include file that defines all constants and types for
    accessing the keyboard device.
--]]
local ffi = require("ffi")

local devioctl = require("win32.devioctl")
local core_string = require("win32.core.string_l1_1_0");
local L = core_string.toUnicode;

--[[
//
// Device Name - this string is the name of the device.  It is the name
// that should be passed to NtOpenFile when accessing the device.
//
// Note:  For devices that support multiple units, it should be suffixed
//        with the Ascii representation of the unit number.
//
--]]

local DD_KEYBOARD_DEVICE_NAME   = "\\Device\\KeyboardClass";
local DD_KEYBOARD_DEVICE_NAME_U = L"\\Device\\KeyboardClass";

--[[
//
// NtDeviceIoControlFile IoControlCode values for this device.
//
// Warning:  Remember that the low two bits of the code specify how the
//           buffers are passed to the driver!
//
--]]
local FILE_DEVICE_KEYBOARD = ffi.C.FILE_DEVICE_KEYBOARD;
local CTL_CODE = devioctl.CTL_CODE;
local METHOD_BUFFERED = ffi.C.METHOD_BUFFERED;
local FILE_ANY_ACCESS = ffi.C.FILE_ANY_ACCESS;

local exports = {}

exports.IOCTL_KEYBOARD_QUERY_ATTRIBUTES      = CTL_CODE(FILE_DEVICE_KEYBOARD, 0x0000, METHOD_BUFFERED, FILE_ANY_ACCESS)
exports.IOCTL_KEYBOARD_SET_TYPEMATIC         = CTL_CODE(FILE_DEVICE_KEYBOARD, 0x0001, METHOD_BUFFERED, FILE_ANY_ACCESS)
exports.IOCTL_KEYBOARD_SET_INDICATORS        = CTL_CODE(FILE_DEVICE_KEYBOARD, 0x0002, METHOD_BUFFERED, FILE_ANY_ACCESS)
exports.IOCTL_KEYBOARD_QUERY_TYPEMATIC       = CTL_CODE(FILE_DEVICE_KEYBOARD, 0x0008, METHOD_BUFFERED, FILE_ANY_ACCESS)
exports.IOCTL_KEYBOARD_QUERY_INDICATORS      = CTL_CODE(FILE_DEVICE_KEYBOARD, 0x0010, METHOD_BUFFERED, FILE_ANY_ACCESS)
exports.IOCTL_KEYBOARD_QUERY_INDICATOR_TRANSLATION  = CTL_CODE(FILE_DEVICE_KEYBOARD, 0x0020, METHOD_BUFFERED, FILE_ANY_ACCESS)
exports.IOCTL_KEYBOARD_INSERT_DATA           = CTL_CODE(FILE_DEVICE_KEYBOARD, 0x0040, METHOD_BUFFERED, FILE_ANY_ACCESS)
exports.IOCTL_KEYBOARD_QUERY_EXTENDED_ATTRIBUTES    = CTL_CODE(FILE_DEVICE_KEYBOARD, 0x0080, METHOD_BUFFERED, FILE_ANY_ACCESS)


-- These Device IO control query/set IME status to keyboard hardware.

exports.IOCTL_KEYBOARD_QUERY_IME_STATUS      = CTL_CODE(FILE_DEVICE_KEYBOARD, 0x0400, METHOD_BUFFERED, FILE_ANY_ACCESS)
exports.IOCTL_KEYBOARD_SET_IME_STATUS        = CTL_CODE(FILE_DEVICE_KEYBOARD, 0x0401, METHOD_BUFFERED, FILE_ANY_ACCESS)

-- Declare the GUID that represents the device interface for keyboards.
--[[
DEFINE_GUID( GUID_DEVINTERFACE_KEYBOARD, 0x884b96c3, 0x56ef, 0x11d1, \
             0xbc, 0x8c, 0x00, 0xa0, 0xc9, 0x14, 0x05, 0xdd);
--]]

--[[
//
// Obsolete device interface class GUID name.
// (use of above GUID_DEVINTERFACE_* name is recommended).
//

#define GUID_CLASS_KEYBOARD  GUID_DEVINTERFACE_KEYBOARD
--]]

ffi.cdef[[
//
// NtReadFile Output Buffer record structures for this device.
//

typedef struct _KEYBOARD_INPUT_DATA {

    //
    // Unit number.  E.g., for \Device\KeyboardPort0 the unit is '0',
    // for \Device\KeyboardPort1 the unit is '1', and so on.
    //

    USHORT UnitId;

    //
    // The "make" scan code (key depression).
    //

    USHORT MakeCode;

    //
    // The flags field indicates a "break" (key release) and other
    // miscellaneous scan code information defined below.
    //

    USHORT Flags;

    USHORT Reserved;

    //
    // Device-specific additional information for the event.
    //

    ULONG ExtraInformation;

} KEYBOARD_INPUT_DATA, *PKEYBOARD_INPUT_DATA;
]]

ffi.cdef[[
//
// Define the keyboard overrun MakeCode.
//

static const int KEYBOARD_OVERRUN_MAKE_CODE  =  0xFF;

//
// Define the keyboard input data Flags.
//

static const int KEY_MAKE  = 0;
static const int KEY_BREAK = 1;
static const int KEY_E0    = 2;
static const int KEY_E1    = 4;
static const int KEY_TERMSRV_SET_LED = 8;
static const int KEY_TERMSRV_SHADOW  = 0x10;
static const int KEY_TERMSRV_VKPACKET = 0x20;
static const int KEY_RIM_VKEY = 0x40;
]]

ffi.cdef[[
//
// NtDeviceIoControlFile Input/Output Buffer record structures for
// IOCTL_KEYBOARD_QUERY_TYPEMATIC/IOCTL_KEYBOARD_SET_TYPEMATIC.
//

typedef struct _KEYBOARD_TYPEMATIC_PARAMETERS {

    //
    // Unit identifier.  Specifies the device unit for which this
    // request is intended.
    //

    USHORT UnitId;

    //
    // Typematic rate, in repeats per second.
    //

    USHORT  Rate;

    //
    // Typematic delay, in milliseconds.
    //

    USHORT  Delay;

} KEYBOARD_TYPEMATIC_PARAMETERS, *PKEYBOARD_TYPEMATIC_PARAMETERS;
]]

ffi.cdef[[
//
// NtDeviceIoControlFile OutputBuffer record structures for
// IOCTL_KEYBOARD_QUERY_ATTRIBUTES.
//

typedef struct _KEYBOARD_ID {
    UCHAR Type;       // Keyboard type
    UCHAR Subtype;    // Keyboard subtype (OEM-dependent value)
} KEYBOARD_ID, *PKEYBOARD_ID;

typedef struct _KEYBOARD_ATTRIBUTES {

    //
    // Keyboard ID value.  Used to distinguish between keyboard types.
    //

    KEYBOARD_ID KeyboardIdentifier;

    //
    // Scan code mode.
    //

    USHORT KeyboardMode;

    //
    // Number of function keys located on the keyboard.
    //

    USHORT NumberOfFunctionKeys;

    //
    // Number of LEDs located on the keyboard.
    //

    USHORT NumberOfIndicators;

    //
    // Total number of keys located on the keyboard.
    //

    USHORT NumberOfKeysTotal;

    //
    // Length of the typeahead buffer, in bytes.
    //

    ULONG  InputDataQueueLength;

    //
    // Minimum allowable values of keyboard typematic rate and delay.
    //

    KEYBOARD_TYPEMATIC_PARAMETERS KeyRepeatMinimum;

    //
    // Maximum allowable values of keyboard typematic rate and delay.
    //

    KEYBOARD_TYPEMATIC_PARAMETERS KeyRepeatMaximum;

} KEYBOARD_ATTRIBUTES, *PKEYBOARD_ATTRIBUTES;
]]

ffi.cdef[[
//
// The structure used by IOCTL_KEYBOARD_QUERY_EXTENDED_ATTRIBUTES
//

static const int KEYBOARD_EXTENDED_ATTRIBUTES_STRUCT_VERSION_1  = 1;

typedef struct _KEYBOARD_EXTENDED_ATTRIBUTES {
    //
    // The version of this structure.
    // Only accept KEYBOARD_EXTENDED_ATTRIBUTES_STRUCT_VERSION_1 now.
    //
    UCHAR Version; 

    //
    // Keyboard Form Factor (Usage ID: 0x2C1)
    //
    UCHAR FormFactor;

    //
    // Keyboard Key Type (Usage ID: 0x2C2)
    //
    UCHAR KeyType;

    //
    // Keyboard Physical Layout (Usage ID: 0x2C3)
    //
    UCHAR PhysicalLayout;

    //
    // Vendor-Specific Keyboard Layout (Usage ID: 0x2C4)
    //
    UCHAR VendorSpecificPhysicalLayout;

    //
    // Keyboard IETF Language Tag Index (Usage ID: 0x2C5)
    //
    UCHAR IETFLanguageTagIndex;

    //
    // Implemented Keyboard Input Assist Controls (Usage ID: 0x2C6)
    //
    UCHAR ImplementedInputAssistControls;

} KEYBOARD_EXTENDED_ATTRIBUTES, *PKEYBOARD_EXTENDED_ATTRIBUTES;
]]

--[[
//
// ENHANCED_KEYBOARD() is TRUE if the value for keyboard type indicates an
// Enhanced (101- or 102-key) or compatible keyboard.  The result is FALSE
// if the keyboard is an old-style AT keyboard (83- or 84- or 86-key keyboard).
//
--]]
function exports.ENHANCED_KEYBOARD(Id) 
    return Id.Type == 2 or Id.Type == 4 or exports.FAREAST_KEYBOARD(Id)
end

--[[
 Japanese keyboard(7) and Korean keyboard(8) are also Enhanced (101-)
 or compatible keyboard.
--]]

function exports.FAREAST_KEYBOARD(Id)  
    return Id.Type == 7 or Id.Type == 8
end

ffi.cdef[[
//
// NtDeviceIoControlFile Input/Output Buffer record structures for
// IOCTL_KEYBOARD_QUERY_INDICATORS/IOCTL_KEYBOARD_SET_INDICATORS.
//

typedef struct _KEYBOARD_INDICATOR_PARAMETERS {

    //
    // Unit identifier.  Specifies the device unit for which this
    // request is intended.
    //

    USHORT UnitId;

    //
    // LED indicator state.
    //

    USHORT    LedFlags;

} KEYBOARD_INDICATOR_PARAMETERS, *PKEYBOARD_INDICATOR_PARAMETERS;
]]

ffi.cdef[[
//
// NtDeviceIoControlFile Output Buffer record structures for
// IOCTL_KEYBOARD_QUERY_INDICATOR_TRANSLATION.
//

typedef struct _INDICATOR_LIST {

    //
    // The "make" scan code (key depression).
    //

    USHORT MakeCode;

    //
    // The associated LED indicators.
    //

    USHORT IndicatorFlags;

} INDICATOR_LIST, *PINDICATOR_LIST;

typedef struct _KEYBOARD_INDICATOR_TRANSLATION {

    //
    // Number of entries in IndicatorList.
    //

    USHORT NumberOfIndicatorKeys;

    //
    // List of the scancode-to-indicator mappings.
    //

    INDICATOR_LIST IndicatorList[1];

} KEYBOARD_INDICATOR_TRANSLATION, *PKEYBOARD_INDICATOR_TRANSLATION;
]]

ffi.cdef[[
//
// Define the keyboard indicators.
//
static const int KEYBOARD_LED_INJECTED     = 0x8000; //Used by Terminal Server
static const int KEYBOARD_SHADOW           = 0x4000; //Used by Terminal Server
static const int KEYBOARD_KANA_LOCK_ON     = 8; // Japanese keyboard
static const int KEYBOARD_CAPS_LOCK_ON     = 4;
static const int KEYBOARD_NUM_LOCK_ON      = 2;
static const int KEYBOARD_SCROLL_LOCK_ON   = 1;
]]

ffi.cdef[[
//
// Generic NtDeviceIoControlFile Input Buffer record structure for
// various keyboard IOCTLs.
//

typedef struct _KEYBOARD_UNIT_ID_PARAMETER {

    //
    // Unit identifier.  Specifies the device unit for which this
    // request is intended.
    //

    USHORT UnitId;

} KEYBOARD_UNIT_ID_PARAMETER, *PKEYBOARD_UNIT_ID_PARAMETER;
]]

--[[
//
// Define the base values for the keyboard error log packet's
// UniqueErrorValue field.
//

#define KEYBOARD_ERROR_VALUE_BASE        10000
--]]


ffi.cdef[[
//
// NtDeviceIoControlFile Input/Output Buffer record structures for
// IOCTL_KEYBOARD_QUERY_IME_STATUS/IOCTL_KEYBOARD_SET_IME_STATUS.
//

typedef struct _KEYBOARD_IME_STATUS {

    //
    // Unit identifier.  Specifies the device unit for which this
    // request is intended.
    //

    USHORT UnitId;

    //
    // Ime open or close status.
    //
    ULONG ImeOpen;

    //
    // Ime conversion status.
    //
    ULONG ImeConvMode;

} KEYBOARD_IME_STATUS, *PKEYBOARD_IME_STATUS;
]]





