package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

require("win32.sdkddkver")
require("win32.windef")
require("win32.wingdi")
require("win32.winuser")

local commctrl = require("win32.commctrl")
require("win32.errhandlingapi")

-- Need to figure out how to include 6.0 version of common controls
-- normally requires a manifest and the linker does magic
local flags = C.ICC_WIN95_CLASSES;   
local initStruct = ffi.new("INITCOMMONCONTROLSEX")
initStruct.dwSize = ffi.sizeof("INITCOMMONCONTROLSEX")
initStruct.dwICC = flags

local success = commctrl.InitCommonControlsEx(initStruct) == 1

local err = C.GetLastError();

print("InitCommonControlsEx: ", success, err)
