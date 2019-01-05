--[[
	sockutils

	This file represents a nice easy consistent API for windows networking calls.
	There are covers for the typical Berkeley socket calls.  All functions return
	either false and an error code, or true or the value expected from the call.
	
	If you are going to do low level socket networking, you should be able
	to require this file, and not much else.
--]]
local ffi = require "ffi"
local C = ffi.C

local bit = require "bit"
local lshift = bit.lshift
local rshift = bit.rshift
local band = bit.band
local bor = bit.bor
local bnot = bit.bnot
local bswap = bit.bswap

require("win32.minwindef")
require("win32.winerror")
local wsock = require("win32.winsock2");
local mswsock = require("win32.mswsock")

--IN_CLASSA = wsock.IN4_CLASSA;
--IN_CLASSB = wsock.IN4_CLASSB
--[[
	Casual Macros
--]]

function IN4_CLASSA(i)
	return (band(i, 0x00000080) == 0)
end

function IN4_CLASSB(i)
	return (band(i, 0x000000c0) == 0x00000080)
end

function IN4_CLASSC(i)
	return (band(i, 0x000000e0) == 0x000000c0)
end

function IN4_CLASSD(i)
	return (band(i, 0x000000f0) == 0x000000e0)
end

IN4_MULTICAST = IN4_CLASSD



--[[
	BSD Style functions
--]]
local function accept(s, addr, addrlen)
	local socket = wsock.accept(s,addr,addrlen);
	if socket == C.INVALID_SOCKET then
		return false, wsock.WSAGetLastError();
	end
	
	return socket;
end

local function bind(s, name, namelen)
	if 0 == wsock.bind(s, ffi.cast("const struct sockaddr *",name), namelen) then
		return true;
	end
	
	return false, wsock.WSAGetLastError();
end

local function connect(s, name, namelen)
	if 0 == wsock.connect(s, ffi.cast("const struct sockaddr *", name), namelen) then
		return true
	end
	
	return false, wsock.WSAGetLastError();
end

local function closesocket(s)
	if 0 == wsock.closesocket(s) then
		return true
	end
	
	return false, wsock.WSAGetLastError();
end

local function ioctlsocket(s, cmd, argp)
	if 0 == wsock.ioctlsocket(s, cmd, argp) then
		return true
	end
	
	return false, wsock.WSAGetLastError();
end

local function listen(s, backlog)
	if 0 == wsock.listen(s, backlog) then
		return true
	end
	
	return false, wsock.WSAGetLastError();
end

local function recv(s, buf, len, flags)
	len = len or #buf;
	flags = flags or 0;
	
	local bytesreceived = wsock.recv(s, ffi.cast("char*", buf), len, flags);

	if bytesreceived == SOCKET_ERROR then
		return false, wsock.WSAGetLastError();
	end
	
	return bytesreceived;
end

local function send(s, buf, len, flags)
	len = len or #buf;
	flags = flags or 0;
	
	local bytessent = wsock.send(s, ffi.cast("const char*", buf), len, flags);

	if bytessent == SOCKET_ERROR then
		return false, wsock.WSAGetLastError();
	end
	
	return bytessent;
end

local function getsockopt(s, optlevel, optname, optval, optlen)
	if 0 == wsock.getsockopt(s, optlevel, optname, ffi.cast("char *",optval), optlen) then
		return true
	end
	
	return false, wsock.WSAGetLastError();
end

local function setsockopt(s, optlevel, optname, optval, optlen)
	if 0 == wsock.setsockopt(s, optlevel, optname, ffi.cast("const uint8_t *", optval), optlen) then
		return true
	end
	
	return false, wsock.WSAGetLastError();
end

local function shutdown(s, how)
	if 0 == wsock.shutdown(s, how) then
		return true
	end
	
	return false, wsock.WSAGetLastError();
end

local function socket(af, socktype, protocol)
	af = af or ffi.C.AF_INET
	socktype = socktype or ffi.C.SOCK_STREAM
	protocol = protocol or ffi.C.IPPROTO_TCP
	
	local sock = wsock.socket(af, socktype, protocol);
	if sock == ffi.C.INVALID_SOCKET then
		return false, wsock.WSAGetLastError();
	end
	
	return sock;
end

--[[
	Windows Specific Socket routines
--]]
local function WSAEnumProtocols()
	local lpiProtocols = nil;
	local dwBufferLen = 16384;
	local lpProtocolBuffer = ffi.cast("LPWSAPROTOCOL_INFOA", ffi.new("uint8_t[?]", dwBufferLen));	-- LPWSAPROTOCOL_INFO
	local lpdwBufferLength = ffi.new('int32_t[1]',dwBufferLen)
	local res = wsock.WSAEnumProtocolsA(lpiProtocols, lpProtocolBuffer, lpdwBufferLength);

	if res == ffi.C.SOCKET_ERROR then
		return false, wsock.WSAGetLastError();
	end

	local dwBufferLength = lpdwBufferLength[0];
	print("buffer length: ", dwBufferLength);

	return {infos = lpProtocolBuffer, count = res}
end


local function WSAIoctl(s,
    dwIoControlCode,
    lpvInBuffer,cbInBuffer,
    lpvOutBuffer, cbOutBuffer,
    lpcbBytesReturned,
    lpOverlapped, lpCompletionRoutine)

	local res = wsock.WSAIoctl(s, dwIoControlCode, 
		lpvInBuffer, cbInBuffer,
		lpvOutBuffer, cbOutBuffer,
		lpcbBytesReturned,
		lpOverlapped,
		lpCompletionRoutine);

	if res == 0 then 
		return true
	end

	return false, wsock.WSAGetLastError();
end

local function WSAPoll(fdArray, fds, timeout)
	local res = wsock.WSAPoll(fdArray, fds, timeout)
	
	if ffi.C.SOCKET_ERROR == res then
		return false, wsock.WSAGetLastError();
	end
	
	return res 
end

local function WSASocket(af, socktype, protocol, lpProtocolInfo, g, dwFlags)
	af = af or ffi.C.AF_INET;
	socktype = socktype or ffi.C.SOCK_STREAM;
	protocol = protocol or 0;
	lpProtocolInfo = lpProtocolInfo or nil;
	g = g or 0;
	dwFlags = dwFlags or ffi.C.WSA_FLAG_OVERLAPPED;

	local socket = wsock.WSASocketA(af, socktype, protocol, lpProtocolInfo, g, dwFlags);
	
	if socket == ffi.C.INVALID_SOCKET then
		return false, wsock.WSAGetLastError();
	end

	return socket;
end

--
-- MSWSock.h
--
WSAID_ACCEPTEX = GUID{0xb5367df1,0xcbac,0x11cf,{0x95,0xca,0x00,0x80,0x5f,0x48,0xa1,0x92}}
WSAID_CONNECTEX = GUID{0x25a207b9,0xddf3,0x4660,{0x8e,0xe9,0x76,0xe5,0x8c,0x74,0x06,0x3e}};
WSAID_DISCONNECTEX = GUID{0x7fda2e11,0x8630,0x436f,{0xa0, 0x31, 0xf5, 0x36, 0xa6, 0xee, 0xc1, 0x57}};


local function GetExtensionFunctionPointer(funcguid)
--print("GetExtensionFunctionPointer: ", funcguid)

	local sock = WSASocket();

	local outbuffsize = ffi.sizeof("intptr_t")
	local outbuff = ffi.new("intptr_t[1]");
	local pbytesreturned = ffi.new("int32_t[1]")

	local success, err = WSAIoctl(sock, ffi.C.SIO_GET_EXTENSION_FUNCTION_POINTER, 
		funcguid, ffi.sizeof(funcguid),
		outbuff, outbuffsize,
		pbytesreturned);

	closesocket(sock);

	if not success then
		return false, err
	end

	return ffi.cast("void *", outbuff[0])
end


--[[
	Real convenience functions
--]]

local SocketErrors = {
	[0]					= "SUCCESS",
	[C.WSAEFAULT]			= "WSAEFAULT",
	[C.WSAEINVAL]			= "WSAEINVAL",
	[C.WSAEWOULDBLOCK]	= "WSAEWOULDBLOCK",
	[C.WSAEINPROGRESS]		= "WSAEINPROGRESS",
	[C.WSAEALREADY]		= "WSAEALREADY",
	[C.WSAENOTSOCK]		= "WSAENOTSOCK",
	[C.WSAEAFNOSUPPORT]	= "WSAEAFNOSUPPORT",
	[C.WSAECONNABORTED]	= "WSAECONNABORTED",
	[C.WSAECONNRESET] 	= "WSAECONNRESET",
	[C.WSAENOBUFS] 		= "WSAENOBUFS",
	[C.WSAEISCONN]		= "WSAEISCONN",
	[C.WSAENOTCONN]		= "WSAENOTCONN",
	[C.WSAESHUTDOWN]		= "WSAESHUTDOWN",
	[C.WSAETOOMANYREFS]	= "WSAETOOMANYREFS",
	[C.WSAETIMEDOUT]		= "WSAETIMEDOUT",
	[C.WSAECONNREFUSED]	= "WSAECONNREFUSED",
	[C.WSAHOST_NOT_FOUND]	= "WSAHOST_NOT_FOUND",
}

function GetSocketErrorString(err)
	
	if not SocketErrors[err] then
		return SocketErrors[err];
	end
	
	return tostring(err)
end


local function GetLocalHostName()
	local name = ffi.new("char[255]")
	local err = wsock.gethostname(name, 255);

	return ffi.string(name)
end

--[[
	This startup routine must be called before any other functions
	within the library are utilized.
--]]
local function MAKEWORD(low,high)
	return bor(low , lshift(high , 8))
end

function WinsockStartup()
	local wVersionRequested = MAKEWORD( 2, 2 );

	local wsadata = ffi.new("WSADATA");
    local status = wsock.WSAStartup(wVersionRequested, wsadata);
    if status ~= 0 then
    	return false, wsock.WSAGetLastError();
    end

	return true;
end


-- Initialize the library
local successfulStart = WinsockStartup();

-- Do whatever is needed after library initialization

--
-- Query for direct function call interfaces
--
local CAcceptEx, err = ffi.cast("LPFN_ACCEPTEX", GetExtensionFunctionPointer(WSAID_ACCEPTEX));
local CConnectEx, err = ffi.cast("LPFN_CONNECTEX", GetExtensionFunctionPointer(WSAID_CONNECTEX));
local CDisconnectEx, err = ffi.cast("LPFN_DISCONNECTEX", GetExtensionFunctionPointer(WSAID_DISCONNECTEX));

local function AcceptEx(sock, 
	sListenSocket, 
	sAcceptSocket, 
	lpOutputBuffer, 
	dwReceiveDataLength,
	dwLocalAddressLength,
	dwRemoteAddressLength,
	lpOverlapped)


	dwReceiveDataLength = dwReceiveDataLength or 0;
	dwLocalAddressLength = dwLocalAddressLength or 0;
	dwRemoteAddressLength = dwRemoteAddressLength or 0;
	local lpdwBytesReceived = ffi.new("DWORD[1]");
	
	local status = CAppectEx(
	    sListenSocket,
	    sAcceptSocket,
	    lpOutputBuffer,
	    dwReceiveDataLength,
	    dwLocalAddressLength,
    	dwRemoteAddressLength,
    	lpdwBytesReceived,
    	lpOverlapped);

	if success == 1 then
		return true;
	end

	return false, wsock.WSAGetLastError();
end


local function DisconnectEx(sock, dwFlags, lpOverlapped)
	local success = CDisconnectEx(sock, nil,0,0);
	if success == 1 then
		return true;
	end

	return false, wsock.WSAGetLastError();
end


return {
	SuccessfulStartup = successfulStart,

	-- Data Structures
	IN_ADDR = IN_ADDR,
	sockaddr = sockaddr,
	sockaddr_in = sockaddr_in,
	sockaddr_in6 = sockaddr_in6,
	addrinfo = addrinfo,
	
	-- Library Functions
	accept = accept,
	bind = bind,
	connect = connect,
	closesocket = closesocket,
	ioctlsocket = ioctlsocket,
	listen = listen,
	recv = recv,
	send = send,
	setsockopt = setsockopt,
	getsockopt = getsockopt,
	shutdown = shutdown,
	socket = socket,
	
	-- Microsoft Extension Methods
	WSAIoctl = WSAIoctl,
	WSAPoll = WSAPoll,
	WSASocket = WSASocket,
	WSAEnumProtocols = WSAEnumProtocols,

	AcceptEx = AcceptEx;
	CConnectEx = CConnectEx;
	DisconnectEx = DisconnectEx;

	-- Helper functions
	GetLocalHostName = GetLocalHostName,
	GetSocketErrorString = GetSocketErrorString,

	-- Some constants
	families = families,
	socktypes = socktypes,
	protocols = protocols,
}
