package.path = "../?.lua;"..package.path;


local ffi = require "ffi"
local bit = require "bit"
local lshift = bit.lshift
local rshift = bit.rshift
local band = bit.band
local bor = bit.bor
local bnot = bit.bnot
local bswap = bit.bswap

require("win32.winerror")
local wsock = require("win32.winsock2")

local exports = {}



function WinsockStartup()
	local wVersionRequested = wsock.MAKEWORD( 2, 2 );

	local wsadata = ffi.new("WSADATA");
    local status = wsock.WSAStartup(wVersionRequested, wsadata);
    if status ~= 0 then
    	return false, wsock.WSAGetLastError();
    end

	return true;
end

local success, err = WinsockStartup();

print("success: ", success, err)