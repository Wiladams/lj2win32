--    https://docs.microsoft.com/en-us/sysinternals/downloads/clockres


package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
require("win32.sysinfoapi")

--[[
BOOL
GetSystemTimeAdjustment(
    PDWORD lpTimeAdjustment,
    PDWORD lpTimeIncrement,
    PBOOL  lpTimeAdjustmentDisabled
    );
--]]

local lpTimeAdjustment = ffi.new("DWORD[1]")
local lpTimeIncrement = ffi.new("DWORD[1]")
local lpTimeAdjustmentDisabled = ffi.new("BOOL[1]")

local result = ffi.C.GetSystemTimeAdjustment(lpTimeAdjustment, lpTimeIncrement, lpTimeAdjustmentDisabled);

print("GetSystemTimeAdjustment: ", result == 1)
print("    Adjustment Disabled: ", lpTimeAdjustmentDisabled[0] == 1);
print("        Time Adjustment: ", lpTimeAdjustment[0]);
print("         Time Increment: ", lpTimeIncrement[0]);
