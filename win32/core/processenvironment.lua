--core-processenvironment-l1-2-0.lua	
--api-ms-win-core-processenvironment-l1-2-0.dll	

local ffi = require("ffi");

local WTypes = require("win32.wtypes");


ffi.cdef[[
static const int STD_INPUT_HANDLE    = ((DWORD)-10);
static const int STD_OUTPUT_HANDLE   = ((DWORD)-11);
static const int STD_ERROR_HANDLE    = ((DWORD)-12);
]]

--[[
ExpandEnvironmentStringsA
ExpandEnvironmentStringsW
FreeEnvironmentStringsA
FreeEnvironmentStringsW
--]]


ffi.cdef[[
LPSTR GetCommandLineA(void);

LPWSTR GetCommandLineW(void);
]]

ffi.cdef[[
DWORD
GetCurrentDirectoryA(DWORD nBufferLength,LPSTR lpBuffer);

DWORD
GetCurrentDirectoryW(DWORD nBufferLength, LPWSTR lpBuffer);
]]

--[[
GetEnvironmentStrings
GetEnvironmentStringsW
GetEnvironmentVariableA
GetEnvironmentVariableW
--]]


ffi.cdef[[
HANDLE GetStdHandle(DWORD nStdHandle);
]]

--local k32Lib = ffi.load("kernel32");
local Lib = ffi.load("api-ms-win-core-processenvironment-l1-2-0");

return {
	Lib = Lib,
	
	GetCommandLineA = Lib.GetCommandLineA,
	GetCommandLineW = Lib.GetCommandLineW,
	GetCurrentDirectoryA = Lib.GetCurrentDirectoryA,
	GetCurrentDirectoryW = Lib.GetCurrentDirectoryW,
	GetStdHandle = Lib.GetStdHandle,
}

--[[
NeedCurrentDirectoryForExePathA
NeedCurrentDirectoryForExePathW
SearchPathA
SearchPathW
SetCurrentDirectoryA
SetCurrentDirectoryW
SetEnvironmentStringsW
SetEnvironmentVariableA
SetEnvironmentVariableW
SetStdHandle
SetStdHandleEx
--]]