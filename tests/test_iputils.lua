package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

require("win32.sdkddkver")

local ws2tcpip = require("win32.ws2tcpip")
local iputils = require("ip_utils")
local spairs = require("spairs")


--[[
    typedef struct WSAData {
        WORD                    wVersion;
        WORD                    wHighVersion;
        unsigned short          iMaxSockets;
        unsigned short          iMaxUdpDg;
        char  *              lpVendorInfo;
        char                    szDescription[WSADESCRIPTION_LEN+1];
        char                    szSystemStatus[WSASYS_STATUS_LEN+1];
} WSADATA,  * LPWSADATA;
--]]

function WinsockStartup()
	local wVersionRequested = MAKEWORD( 2, 2 );

	local wsadata = ffi.new("WSADATA");
    local status = ws2tcpip.WSAStartup(wVersionRequested, wsadata);
    if status ~= 0 then
    	return false, ws2tcpip.WSAGetLastError();
    end

    local res = {
        VersionMajor = tonumber(LOBYTE(wsadata.wVersion));
        VersionMinor = tonumber(HIBYTE(wsadata.wVersion));
        MaxMajor = tonumber(LOBYTE(wsadata.wHighVersion));
        MaxMinor = tonumber(HIBYTE(wsadata.wHighVersion));
        Description = ffi.string(wsadata.szDescription);
        SystemStatus = ffi.string(wsadata.szSystemStatus);
    }

	return res;
end

function setup()
    local success, err = WinsockStartup()

    print("WinsockStartup(): ", success, err)

    if not success then
        error("failed to startup winsock: "..tostring(err))
    end

    print("==== STARTUP ====")
    for k,v in spairs(success) do
        print(k, v)
    end
    print("===== ===== =====")
end

local function work()
    local s, err = iputils.CreateSocketAddress("www.google.com", 80)

    print("CreateSocketAddress: ", s, err)
end

setup()
work()


