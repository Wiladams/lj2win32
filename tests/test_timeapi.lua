package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

require("win32.sdkddkver")


require("win32.minwindef")
require("win32.minwinbase")

local timeapi = require("win32.timeapi")

local ptc = ffi.new("TIMECAPS")
local cbtc = ffi.sizeof("TIMECAPS")

local result = timeapi.timeGetDevCaps(ptc, cbtc);

print("result: ", result)
print("min, max: ", ptc.wPeriodMin, ptc.wPeriodMax)
