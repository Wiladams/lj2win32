package.path = "../?.lua;"..package.path;
local bit = require("bit")
local bnot = bit.bnot

local ffi = require("ffi")
local ws2 = require("win32.winsock2")

print(INVALID_SOCKET)
sock = ffi.new("SOCKET", -1)
print(sock)
sock = ffi.new("SOCKET", bnot(0))
print(sock)
sock = ffi.new("uint64_t", -1)
print(sock)