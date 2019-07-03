package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

require("win32.sdkddkver")
local wingdi = require("win32.wingdi")
local winuser = require("win32.winuser")

-- use the following to set DPI awareness in the beginning
-- so we can get true DPI values
-- SetThreadDpiAwarenessContext
local DPI_AWARENESS_CONTEXT_SYSTEM_AWARE         = ffi.cast("DPI_AWARENESS_CONTEXT",-2);

local oldContext = ffi.C.SetThreadDpiAwarenessContext(DPI_AWARENESS_CONTEXT_SYSTEM_AWARE);
print("old context: ", oldContext)

local dpi = ffi.C.GetDpiForSystem();

print("System DPI: ", dpi)