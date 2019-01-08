package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C

require("win32.sdkddkver")

local NativeWindow = require("NativeWindow")

local dwinHandle = C.GetDesktopWindow()

local dwin = NativeWindow:init(dwinHandle)

print("Client Size: ", dwin:getClientSize())
print("Title: ", dwin:getTitle())