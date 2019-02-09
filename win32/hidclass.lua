
local ffi = require("ffi")
local C = ffi.C 

--#include <basetyps.h>
require("win32.winapifamily")
local utils = require("win32.utils")
local makeStatic = utils.makeStatic
local devioctl = require("win32.devioctl")
local CTL_CODE = devioctl.CTL_CODE

local exports = {}

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


DEFINE_GUID( "GUID_DEVINTERFACE_HID", 0x4D1E55B2, 0xF16F, 0x11CF, 0x88, 0xCB, 0x00, 0x11, 0x11, 0x00, 0x00, 0x30);
GUID_CLASS_INPUT = GUID_DEVINTERFACE_HID

-- 2c4e2e88-25e6-4c33-882f-3d82e6073681
DEFINE_GUID( "GUID_HID_INTERFACE_NOTIFY", 0x2c4e2e88, 0x25e6, 0x4c33, 0x88, 0x2f, 0x3d, 0x82, 0xe6, 0x07, 0x36, 0x81 );

-- {F5C315A5-69AC-4bc2-9279-D0B64576F44B}
DEFINE_GUID( "GUID_HID_INTERFACE_HIDPARSE", 0xf5c315a5, 0x69ac, 0x4bc2, 0x92, 0x79, 0xd0, 0xb6, 0x45, 0x76, 0xf4, 0x4b );


if DEFINE_DEVPROPKEY then

DEFINE_DEVPROPKEY(DEVPKEY_DeviceInterface_HID_UsagePage, 0xcbf38310, 0x4a17, 0x4310, 0xa1, 0xeb, 0x24, 0x7f, 0xb, 0x67, 0x59, 0x3b, 2);

DEFINE_DEVPROPKEY(DEVPKEY_DeviceInterface_HID_UsageId, 0xcbf38310, 0x4a17, 0x4310, 0xa1, 0xeb, 0x24, 0x7f, 0xb, 0x67, 0x59, 0x3b, 3);

DEFINE_DEVPROPKEY(DEVPKEY_DeviceInterface_HID_IsReadOnly, 0xcbf38310, 0x4a17, 0x4310, 0xa1, 0xeb, 0x24, 0x7f, 0xb, 0x67, 0x59, 0x3b, 4);

DEFINE_DEVPROPKEY(DEVPKEY_DeviceInterface_HID_VendorId, 0xcbf38310, 0x4a17, 0x4310, 0xa1, 0xeb, 0x24, 0x7f, 0xb, 0x67, 0x59, 0x3b, 5);

DEFINE_DEVPROPKEY(DEVPKEY_DeviceInterface_HID_ProductId, 0xcbf38310, 0x4a17, 0x4310, 0xa1, 0xeb, 0x24, 0x7f, 0xb, 0x67, 0x59, 0x3b, 6);

DEFINE_DEVPROPKEY(DEVPKEY_DeviceInterface_HID_VersionNumber, 0xcbf38310, 0x4a17, 0x4310, 0xa1, 0xeb, 0x24, 0x7f, 0xb, 0x67, 0x59, 0x3b, 7);

DEFINE_DEVPROPKEY(DEVPKEY_DeviceInterface_HID_BackgroundAccess, 0xcbf38310, 0x4a17, 0x4310, 0xa1, 0xeb, 0x24, 0x7f, 0xb, 0x67, 0x59, 0x3b, 8);

end

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
static const int HID_REVISION   = 0x00000001;
]]

function exports.HID_CTL_CODE(id)        return    CTL_CODE(C.FILE_DEVICE_KEYBOARD, id, C.METHOD_NEITHER, C.FILE_ANY_ACCESS) end
function exports.HID_BUFFER_CTL_CODE(id) return    CTL_CODE(C.FILE_DEVICE_KEYBOARD, id, C.METHOD_BUFFERED, C.FILE_ANY_ACCESS) end
function exports.HID_IN_CTL_CODE(id)     return    CTL_CODE(C.FILE_DEVICE_KEYBOARD, id, C.METHOD_IN_DIRECT, C.FILE_ANY_ACCESS) end
function exports.HID_OUT_CTL_CODE(id)    return    CTL_CODE(C.FILE_DEVICE_KEYBOARD, id, C.METHOD_OUT_DIRECT, C.FILE_ANY_ACCESS) end

local HID_BUFFER_CTL_CODE = exports.HID_BUFFER_CTL_CODE
local HID_CTL_CODE = exports.HID_CTL_CODE
local HID_IN_CTL_CODE = exports.HID_IN_CTL_CODE
local HID_IN_CTL_CODE = exports.HID_IN_CTL_CODE
local HID_OUT_CTL_CODE = exports.HID_OUT_CTL_CODE


makeStatic("IOCTL_HID_GET_DRIVER_CONFIG",             HID_BUFFER_CTL_CODE(100))
makeStatic("IOCTL_HID_SET_DRIVER_CONFIG",             HID_BUFFER_CTL_CODE(101))
makeStatic("IOCTL_HID_GET_POLL_FREQUENCY_MSEC",       HID_BUFFER_CTL_CODE(102))
makeStatic("IOCTL_HID_SET_POLL_FREQUENCY_MSEC",       HID_BUFFER_CTL_CODE(103))
makeStatic("IOCTL_GET_NUM_DEVICE_INPUT_BUFFERS",      HID_BUFFER_CTL_CODE(104))
makeStatic("IOCTL_SET_NUM_DEVICE_INPUT_BUFFERS",      HID_BUFFER_CTL_CODE(105))
makeStatic("IOCTL_HID_GET_COLLECTION_INFORMATION",    HID_BUFFER_CTL_CODE(106))
makeStatic("IOCTL_HID_ENABLE_WAKE_ON_SX",             HID_BUFFER_CTL_CODE(107))
makeStatic("IOCTL_HID_SET_S0_IDLE_TIMEOUT",           HID_BUFFER_CTL_CODE(108))


makeStatic("IOCTL_HID_GET_COLLECTION_DESCRIPTOR",     HID_CTL_CODE(100))
makeStatic("IOCTL_HID_FLUSH_QUEUE",                   HID_CTL_CODE(101))

makeStatic("IOCTL_HID_SET_FEATURE",                   HID_IN_CTL_CODE(100))
makeStatic("IOCTL_HID_SET_OUTPUT_REPORT",             HID_IN_CTL_CODE(101))

makeStatic("IOCTL_HID_GET_FEATURE",                   HID_OUT_CTL_CODE(100))
makeStatic("IOCTL_GET_PHYSICAL_DESCRIPTOR",           HID_OUT_CTL_CODE(102))
makeStatic("IOCTL_HID_GET_HARDWARE_ID",               HID_OUT_CTL_CODE(103))
makeStatic("IOCTL_HID_GET_INPUT_REPORT",              HID_OUT_CTL_CODE(104))
makeStatic("IOCTL_HID_GET_OUTPUT_REPORT",             HID_OUT_CTL_CODE(105))

makeStatic("IOCTL_HID_GET_MANUFACTURER_STRING",       HID_OUT_CTL_CODE(110))
makeStatic("IOCTL_HID_GET_PRODUCT_STRING",            HID_OUT_CTL_CODE(111))
makeStatic("IOCTL_HID_GET_SERIALNUMBER_STRING",       HID_OUT_CTL_CODE(112))

makeStatic("IOCTL_HID_GET_INDEXED_STRING",            HID_OUT_CTL_CODE(120))
makeStatic("IOCTL_HID_GET_MS_GENRE_DESCRIPTOR",       HID_OUT_CTL_CODE(121))

makeStatic("IOCTL_HID_ENABLE_SECURE_READ",            HID_CTL_CODE(130))
makeStatic("IOCTL_HID_DISABLE_SECURE_READ",           HID_CTL_CODE(131))

makeStatic("IOCTL_HID_DEVICERESET_NOTIFICATION",      HID_CTL_CODE(140))

ffi.cdef[[
//
// This is used to pass write-report and feature-report information
// from HIDCLASS to a minidriver.
//
typedef struct _HID_XFER_PACKET {
    PUCHAR  reportBuffer;
    ULONG   reportBufferLen;
    UCHAR   reportId;
} HID_XFER_PACKET, *PHID_XFER_PACKET;
]]

if NT_INCLUDED then
ffi.cdef[[
enum DeviceObjectState {
    DeviceObjectStarted,
    DeviceObjectStopped,
    DeviceObjectRemoved
};

typedef VOID (*PHID_STATUS_CHANGE)( PVOID Context,  enum DeviceObjectState State);
]]

--[[
typedef struct _HID_INTERFACE_NOTIFY_PNP
{
    INTERFACE ;
    PHID_STATUS_CHANGE StatusChangeFn;
    PVOID CallbackContext;
} HID_INTERFACE_NOTIFY_PNP, *PHID_INTERFACE_NOTIFY_PNP;
--]]

if __HIDPI_H__ then

ffi.cdef[[
typedef 
NTSTATUS 
(__stdcall *PHIDP_GETCAPS) (
      PHIDP_PREPARSED_DATA PreparsedData, 
     PHIDP_CAPS Capabilities
    );
]]

--[[
typedef struct _HID_INTERFACE_HIDPARSE
{
    INTERFACE;
    PHIDP_GETCAPS HidpGetCaps;
} HID_INTERFACE_HIDPARSE, *PHID_INTERFACE_HIDPARSE;
--]]
end --// __HIDPI_H__

end -- NT_INCLUDED

ffi.cdef[[
//
// Structure passed by IOCTL_HID_GET_COLLECTION_INFORMATION
//

typedef struct _HID_COLLECTION_INFORMATION {

    //
    // DescriptorSize is the size of the input buffer required to accept
    // the collection descriptor returned by
    // IOCTL_HID_GET_COLLECTION_DESCRIPTOR.
    //

    ULONG   DescriptorSize;

    //
    // Polled is TRUE if this collection is a polled collection.
    //

    BOOLEAN Polled;

    //
    // Reserved1 must be set to zero.
    //

    UCHAR   Reserved1[ 1 ];

    //
    // Vendor ids of this hid device
    //
    USHORT  VendorID;
    USHORT  ProductID;
    USHORT  VersionNumber;

    //
    // Additional fields, if any, will be added at the end of this structure.
    //

} HID_COLLECTION_INFORMATION, *PHID_COLLECTION_INFORMATION;
]]

ffi.cdef[[
//
// Structure passed by IOCTL_HID_GET_DRIVER_CONFIG and
// IOCTL_HID_SET_DRIVER_CONFIG
//

typedef struct _HID_DRIVER_CONFIG {

    //
    // Size must be set to the size of this structure.
    //

    ULONG   Size;

    //
    // Size of the input report queue (in reports).  This value can be set.
    //

    ULONG   RingBufferSize;

} HID_DRIVER_CONFIG, *PHID_DRIVER_CONFIG;
]]


end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


return exports