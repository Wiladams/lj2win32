package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 
--local k32 = ffi.load("kernel32")
--local lib = ffi.load("api-ms-win-core-sysinfo-l1")

require("win32.sdkddkver")
require("win32.sysinfoapi")

local pInches = ffi.new("double[1]")
local res = C.GetIntegratedDisplaySize(pInches);
print("Diagonal: ", pInches[0])