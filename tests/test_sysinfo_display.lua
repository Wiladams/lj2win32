package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local k32 = ffi.load("kernel32")

require("win32.sysinfoapi")

local pInches = ffi.new("double[1]")
local res = k32.GetIntegratedDisplaySize(pInches);
print("Diagonal: ", pInches[0])