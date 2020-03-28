package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

require("win32.sdkddkver")
--require("win32.minwindef")
require("win32.wingdi")

--print("typeof: ABC => ", ffi.typeof("ABC"));

local usp = require("win32.usp10")

print("SGCM_RTL: ", ffi.C.SGCM_RTL);
