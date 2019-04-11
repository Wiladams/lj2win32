
local ffi = require "ffi"
local C = ffi.C 

local bit = require "bit"
local band = bit.band

require("win32.winsock2");
local ws2tcpip = require("win32.ws2tcpip")


local families = {
    [tonumber(C.AF_INET)] = "AF_INET",
    [tonumber(C.AF_INET6)] = "AF_INET6",
    [tonumber(C.AF_BTH)] = "AF_BTH",
}

local socktypes = {
    [tonumber(C.SOCK_STREAM)] = "SOCK_STREAM",
    [tonumber(C.SOCK_DGRAM)] = "SOCK_DGRAM",
}

local protocols = {
    [tonumber(ffi.C.IPPROTO_IP)]    = "IPPROTO_IP",
    [tonumber(ffi.C.IPPROTO_ICMP)]  = "IPPROTO_ICMP",
    [tonumber(ffi.C.IPPROTO_IGMP)]  = "IPPROTO_IGMP",
    [tonumber(ffi.C.IPPROTO_GGP)]   = "IPPROTO_GGP",
    [tonumber(ffi.C.IPPROTO_TCP)]   = "IPPROTO_TCP",
    [tonumber(ffi.C.IPPROTO_PUP)]   = "IPPROTO_PUP",
    [tonumber(ffi.C.IPPROTO_UDP)]   = "IPPROTO_UDP",
    [tonumber(ffi.C.IPPROTO_IDP)]   = "IPPROTO_IDP",
    [tonumber(ffi.C.IPPROTO_RDP)]   = "IPPROTO_RDP",
    [tonumber(ffi.C.IPPROTO_IPV6)]  = "IPPROTO_IPV6",
    [tonumber(ffi.C.IPPROTO_ROUTING)]   = "IPPROTO_ROUTING",
    [tonumber(ffi.C.IPPROTO_FRAGMENT)]  = "IPPROTO_FRAGMENT",
    [tonumber(ffi.C.IPPROTO_ESP)]       = "IPPROTO_ESP",
    [tonumber(ffi.C.IPPROTO_AH)]        = "IPPROTO_AH",
    [tonumber(ffi.C.IPPROTO_ICMPV6)]    = "IPPROTO_ICMPV6",
    [tonumber(ffi.C.IPPROTO_NONE)]      = "IPPROTO_NONE",
    [tonumber(ffi.C.IPPROTO_DSTOPTS)]   = "IPPROTO_DSTOPTS",
    [tonumber(ffi.C.IPPROTO_ND)]        = "IPPROTO_ND",
    [tonumber(ffi.C.IPPROTO_ICLFXBM)]   = "IPPROTO_ICLFXBM",
    [tonumber(ffi.C.IPPROTO_PIM)]       = "IPPROTO_PIM",
    [tonumber(ffi.C.IPPROTO_PGM)]       = "IPPROTO_PGM",
    [tonumber(ffi.C.IPPROTO_L2TP)]      = "IPPROTO_L2TP",
    [tonumber(ffi.C.IPPROTO_SCTP)]      = "IPPROTO_SCTP",
}

--[[
    Definition of some structures
--]]

IN_ADDR = ffi.typeof("struct in_addr");
IN_ADDR_mt = {
    __tostring = function(self)
        local res = ws2tcpip.inet_ntoa(self)
        if res then
            return ffi.string(res)
        end

        return nil
    end,

    __index = {
        Assign = function(self, rhs)
            self.S_addr = rhs.S_addr
            return self
        end,

        Clone = function(self)
            local obj = IN_ADDR(self.S_addr)
            return obj
        end,

    },
}
ffi.metatype(IN_ADDR, IN_ADDR_mt)




sockaddr_in = ffi.typeof("struct sockaddr_in")
sockaddr_in_mt = {

    __new = function(ct, port, family)
        port = tonumber(port) or 80
        family = family or AF_INET;
        
        local obj = ffi.new(ct)
        obj.sin_family = family;
        obj.sin_addr.S_addr = ws2tcpip.htonl(INADDR_ANY);
        obj.sin_port = ws2tcpip.htons(port);
        
        return obj
    end,
  
    __tostring = function(self)
        return string.format("Family: %s  Port: %d Address: %s",
            families[self.sin_family], ws2tcpip.ntohs(self.sin_port), tostring(self.sin_addr));
    end,

    __index = {
        SetPort = function(self, port)
            local portnum = tonumber(port);
            if not portnum then 
                return nil, "not a number"
            end
            
            self.sin_port = ws2tcpip.htons(tonumber(port));
        end,
    },
}
ffi.metatype(sockaddr_in, sockaddr_in_mt);



sockaddr_in6 = ffi.typeof("struct sockaddr_in6")
sockaddr_in6_mt = {

    __tostring = function(self)
        return string.format("Family: %s  Port: %d Address: %s",
            families[self.sin6_family], self.sin6_port, tostring(self.sin6_addr));
    end,

    __index = {
        SetPort = function(self, port)
            local portnum = tonumber(port);
            self.sin6_port = ws2tcpip.htons(portnum);
        end,
    },
}
ffi.metatype(sockaddr_in6, sockaddr_in6_mt);


sockaddr = ffi.typeof("struct sockaddr")
sockaddr_mt = {
    __index = {
    }
}
ffi.metatype(sockaddr, sockaddr_mt);


-- pass in a sockaddr
-- get out a more specific sockaddr_in or sockaddr_in6
local function newSocketAddress(name, namelen)
print("newSocketAddress: ", name, namelen)
	local sockaddrptr = ffi.cast("struct sockaddr *", name)
	local newone

print("  newSocketAddress, family: ", sockaddrptr.sa_family)

	if sockaddrptr.sa_family == C.AF_INET then
		newone = ffi.new("struct sockaddr_in")
	elseif sockaddrptr.sa_family == C.AF_INET6 then
		newone = ffi.new("struct sockaddr_in6")
	end
	ffi.copy(newone, sockaddrptr, namelen)

	return newone
end


local function host_addresses(hostname, family, socktype, isnumericstring)
    print("== host_addresses: ", hostname, servicename, family, socktype, isnumericstring)

	hostname = hostname or "..localmachine"
	family = family or C.AF_UNSPEC;
	socktype = socktype or C.SOCK_STREAM;

	local err;
	local hints = ffi.new("struct addrinfo");
	local res = ffi.new("PADDRINFOA[1]")

	--hints.ai_flags = AI_CANONNAME;	-- return canonical name
	hints.ai_family = family;
	hints.ai_socktype = socktype;
	if isnumericstring then
		hints.ai_flags = C.AI_NUMERICHOST
	end

	err = ws2tcpip.getaddrinfo(hostname, servicename, hints, res)
print("  host_addresses.getaddrinfo, err: ", err);
	if err ~= 0 then
		-- error condition
		return nil, err
	end

--[[
typedef struct addrinfo
{
    int                 ai_flags;       // AI_PASSIVE, AI_CANONNAME, AI_NUMERICHOST
    int                 ai_family;      // PF_xxx
    int                 ai_socktype;    // SOCK_xxx
    int                 ai_protocol;    // 0 or IPPROTO_xxx for IPv4 and IPv6
    size_t              ai_addrlen;     // Length of ai_addr
    char *              ai_canonname;   // Canonical name for nodename
     struct sockaddr *   ai_addr;        // Binary address
    struct addrinfo *   ai_next;        // Next structure in linked list
}
ADDRINFOA, *PADDRINFOA;
    ]]

    local current = res[0]
    local entries = {}
    repeat
        table.insert(entries, {
            Flags = current.ai_flags;
            Family = current.ai_family;
            SockType = current.ai_socktype;
            Protocol = current.ai_protocol;
            AddressLength = current.ai_addrlen; -- probably need to copy physical memory
            Address = current.ai_addr;
        })
        current = current.ai_next;
    until current.ai_next == nil

	return entries
end

local function host_serv(hostname, servicename, family, socktype, isnumericstring)
    local hostaddrs = host_addresses(hostname, family, socktype, isnumericstring)

    return hostaddrs[1]
end


local CreateIPV4WildcardAddress= function(family, port)
	local inetaddr = sockaddr_in()
	inetaddr.sin_family = family;
	inetaddr.sin_addr.S_addr = ws2tcpip.htonl(C.INADDR_ANY);
	inetaddr.sin_port = ws2tcpip.htons(port);

	return inetaddr
end

local function CreateSocketAddress(hostname, port, family, socktype)
	family = family or C.AF_INET;
	socktype = socktype or C.SOCK_STREAM;

print("CreateSocketAddress(): ", hostname, port, family, socktype);

    local hostportoffset = hostname:find(':')
print("  CreateSocketAddress, hostportoffset: ", hostportoffset)

	if hostportoffset then
		port = tonumber(hostname:sub(hostportoffset+1))
		hostname = hostname:sub(1,hostportoffset-1)
		print("CreateSocketAddress() - Modified: ", hostname, port)
	end

	local addressinfo, err = host_serv(hostname, nil, family, socktype)

print("  CreateSocketAddress, after host_serv: ", addressinfo, err)

	if not addressinfo then
		return nil, err
	end


    -- clone one of the addresses
	local oneaddress = newSocketAddress(addressinfo.ai_addr, addressinfo.ai_addrlen)

print("  CreateSocketAddress, newSocketAddress: ", oneaddress)

    oneaddress:SetPort(port)

print("  CreateSocketAddress, setPort: ")

	-- free the addrinfos structure
	err = ws2tcpip.freeaddrinfo(addressinfo)

	return oneaddress;
end



return {
	host_serv = host_serv,
    host_addresses = host_addresses,
    
	CreateIPV4WildcardAddress = CreateIPV4WildcardAddress,
	CreateSocketAddress = CreateSocketAddress,

	--CreateTcpServerSocket = CreateTcpServerSocket,
    --CreateTcpClientSocket = CreateTcpClientSocket,
    
    families = families;
    socktypes = socktypes;
    protocols = protocols;
}
