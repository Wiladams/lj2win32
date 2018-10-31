-- core_string_l1_1_0.lua	
-- api-ms-win-core-string-l1-1-0.dll

local ffi = require("ffi");

local WTypes = require("win32.wtypes");

local k32Lib = ffi.load("kernel32")

ffi.cdef[[
static const int CP_ACP 		= 0;	// default to ANSI code page
static const int CP_OEMCP		= 1;	// default to OEM code page
static const int CP_MACCP		= 2;	// default to MAC code page
static const int CP_THREAD_ACP	= 3;	// current thread's ANSI code page
static const int CP_SYMBOL		= 42;	// SYMBOL translations
]]

ffi.cdef[[
int MultiByteToWideChar(UINT CodePage,
    DWORD    dwFlags,
    LPCSTR   lpMultiByteStr, int cbMultiByte,
    LPWSTR  lpWideCharStr, int cchWideChar);


int WideCharToMultiByte(UINT CodePage,
    DWORD    dwFlags,
	LPCWSTR  lpWideCharStr, int cchWideChar,
    LPSTR   lpMultiByteStr, int cbMultiByte,
    LPCSTR   lpDefaultChar,
    LPBOOL  lpUsedDefaultChar);
]]




local function toUnicode(in_Src, nsrcBytes)
	if in_Src == nil then
		return nil;
	end
	
	nsrcBytes = nsrcBytes or #in_Src

	-- find out how many characters needed
	local charsneeded = k32Lib.MultiByteToWideChar(ffi.C.CP_ACP, 0, ffi.cast("const char *",in_Src), nsrcBytes, nil, 0);

	if charsneeded < 0 then
		return nil;
	end


	local buff = ffi.new("uint16_t[?]", charsneeded+1)

	local charswritten = k32Lib.MultiByteToWideChar(ffi.C.CP_ACP, 0, in_Src, nsrcBytes, buff, charsneeded)
	buff[charswritten] = 0


	return buff, charswritten;
end

local function toAnsi(in_Src, nsrcBytes)
	if in_Src == nil then 
		return nil;
	end
	
	local cchWideChar = nsrcBytes or -1;

	-- find out how many characters needed
	local bytesneeded = k32Lib.WideCharToMultiByte(
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
	local byteswritten = k32Lib.WideCharToMultiByte(
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

local function TEXT(quote)
	if UNICODE then
		return toUnicode(quote);
	else
		return quote;
	end
end


return {
	Lib = k32Lib,
	
	toUnicode = toUnicode,
	toAnsi = toAnsi,
	TEXT = TEXT,
	
	--CompareStringEx = k32Lib.CompareStringEx,
	--CompareStringOrdinal = k32Lib.CompareStringOrdinal,
	--CompareStringW = k32Lib.CompareStringW,
	--FoldStringW = k32Lib.FoldStringW,
	--GetStringTypeExW = k32Lib.GetStringTypeExW,
	--GetStringTypeW = k32Lib.GetStringTypeW,
	MultiByteToWideChar = k32Lib.MultiByteToWideChar,
	WideCharToMultiByte = k32Lib.WideCharToMultiByte,
}