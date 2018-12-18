package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

NOGDI = true

require("win32.minwindef")
--require("win32.winnt")
require("win32.winerror")

--local qos = require("win32.qos")
local winsock = require("win32.winsock2")

print("_SS_MAXSIZE: ", ffi.C._SS_MAXSIZE)
print("_SS_ALIGNSIZE: ", ffi.C._SS_ALIGNSIZE)
