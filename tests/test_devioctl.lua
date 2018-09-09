package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local devioctl = require("win32.devioctl")
local ntddkbd = require("win32.ntddkbd")

local FILE_DEVICE_KEYBOARD = ffi.C.FILE_DEVICE_KEYBOARD;
local CTL_CODE = devioctl.CTL_CODE;
local METHOD_BUFFERED = ffi.C.METHOD_BUFFERED;
local FILE_ANY_ACCESS = ffi.C.FILE_ANY_ACCESS;

local queryKbdAttrs      = devioctl.CTL_CODE(FILE_DEVICE_KEYBOARD, 0x0000, METHOD_BUFFERED, FILE_ANY_ACCESS)

local deviceCode = devioctl.DEVICE_TYPE_FROM_CTL_CODE(queryKbdAttrs)
local methodCode = devioctl.METHOD_FROM_CTL_CODE(queryKbdAttrs)

print(string.format("Device: 0x%x", deviceCode))
print(string.format("Method: 0x%x", methodCode))