package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

require("win32.sdkddkver")

local ws2tcpip = require("win32.ws2tcpip")
local iputils = require("ip_utils")
local spairs = require("spairs")

local function printDict(dict)
    for k,v in spairs(dict) do
        print(k,v)
    end
end

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


--[[
                Flags = current.ai_flags;
            Family = current.ai_family;
            SockType = current.ai_socktype;
            Protocol = current.ai_protocol;
            AddressLength = current.ai_addrlen; -- probably need to copy physical memory
            Address = current.ai_addr;
]]
local function printHostAddress(addr)
--[[]]
    local function addrToString()
        local family = families[self.ai_family]
        local socktype = socktypes[self.ai_socktype]
        local protocol = protocols[self.ai_protocol]

        --local family = self.ai_family
        local socktype = self.ai_socktype
        local protocol = self.ai_protocol


        local str = string.format("Socket Type: %s, Protocol: %s, %s", socktype, protocol, tostring(self.ai_addr));
    end
--]]

    print("     Family: ", iputils.families[addr.Family])
    print("Socket Type: ", iputils.socktypes[addr.SockType])
    print("Protocol: ", iputils.protocols[addr.Protocol]);
    print("Address: ", tostring(addr.Address));
end

local function test_host_addresses()
    print("==== test_host_addresses ====")
    --local addrs = iputils.host_addresses()
    local addrs = iputils.host_addresses("bing.com")
    if not addrs then 
        return false, "No addresses found"
    end

    for _, addr in ipairs(addrs) do
        print("== NET ADDRESS ==")
        printHostAddress(addr)
    end
end

setup()
--work()
test_host_addresses()


