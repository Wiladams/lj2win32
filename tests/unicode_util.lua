--[[
    A couple of routines to convert between Windows widechar, and multi-byte representations
    of strings.

    This is typically useful when from Lua you want to interact with one of the Windows UNICODE interfaces
    and you're starting from a typical Lua string literal, which are not UNICODE necessarily.

    To match typical Windows 'C' symantics, you can do something like:

        local uniutil = require("unicode_util")
        local L = uniutil.toUnicode;

        someFunctionW(L'ThisString')
]]

local ffi = require("ffi")
local C = ffi.C 

require("win32.stringapiset")



local exports = {}

function exports.toUnicode(in_Src, nsrcBytes)
	if in_Src == nil then
		return nil;
	end
	
	nsrcBytes = nsrcBytes or #in_Src

	-- find out how many characters needed
	local charsneeded = ffi.C.MultiByteToWideChar(ffi.C.CP_ACP, 0, ffi.cast("const char *",in_Src), nsrcBytes, nil, 0);

	if charsneeded < 0 then
		return nil;
	end

	local buff = ffi.new("uint16_t[?]", charsneeded+1)

	local charswritten = C.MultiByteToWideChar(ffi.C.CP_ACP, 0, in_Src, nsrcBytes, buff, charsneeded)
	buff[charswritten] = 0


	return buff, charswritten;
end

function exports.toAnsi(in_Src, nsrcBytes)
	if in_Src == nil then 
		return nil;
	end
	
	local cchWideChar = nsrcBytes or -1;

	-- find out how many characters needed
	local bytesneeded = ffi.C.WideCharToMultiByte(
		ffi.C.CP_ACP, 
		0, 
		ffi.cast("const uint16_t *", in_Src), 
		cchWideChar, 
		nil, 
		0, 
		nil, 
		nil);

--print("BN: ", bytesneeded);

	if bytesneeded <= 0 then
		return nil;
	end

	-- create a buffer to stuff the converted string into
	local buff = ffi.new("uint8_t[?]", bytesneeded)

	-- do the actual string conversion
	local byteswritten = ffi.C.WideCharToMultiByte(
		ffi.C.CP_ACP, 
		0, 
		ffi.cast("const uint16_t *", in_Src), 
		cchWideChar, 
		buff, 
		bytesneeded, 
		nil, 
		nil);

	if cchWideChar == -1 then
		return ffi.string(buff, byteswritten-1);
	end

	return ffi.string(buff, byteswritten)
end

return exports
