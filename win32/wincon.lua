local ffi = require("ffi")

require("win32.winapifamily")

require("win32.wincontypes")


if not NOGDI then
require("win32.wingdi")
end

if not NOAPISET then
require("win32.consoleapi")
require("win32.consoleapi2")
require("win32.consoleapi3")
end

local CONSOLE_REAL_OUTPUT_HANDLE = ffi.cast("HANDLE", ffi.cast("LONG_PTR", -2)); -- (LongToHandle(-2))
local CONSOLE_REAL_INPUT_HANDLE    = ffi.cast("HANDLE", ffi.cast("LONG_PTR", -3)); -- (LongToHandle(-3))

--[[
#define CONSOLE_REAL_OUTPUT_HANDLE (LongToHandle(-2))
#define CONSOLE_REAL_INPUT_HANDLE (LongToHandle(-3))

#define CONSOLE_TEXTMODE_BUFFER  = 1;
--]]

