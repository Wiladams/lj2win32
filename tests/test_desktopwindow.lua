package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C

local NativeWindow = require("NativeWindow")

local dwinHandle = C.GetDesktopWindow()