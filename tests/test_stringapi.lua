package.path = "../?.lua;"..package.path;

require("win32.stringapiset")


local function toUnicode(in_Src, nsrcBytes)
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

	local charswritten = ffi.C.MultiByteToWideChar(ffi.C.CP_ACP, 0, in_Src, nsrcBytes, buff, charsneeded)
	buff[charswritten] = 0


	return buff, charswritten;
end

local function toAnsi(in_Src, nsrcBytes)
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

