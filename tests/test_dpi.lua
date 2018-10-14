package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local wingdi = require("win32.wingdi")
local winuser = require("win32.winuser")


local dpi = ffi.C.GetDpiForSystem();

print("System DPI: ", dpi)