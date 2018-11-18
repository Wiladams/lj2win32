package.path = "../?.lua;"..package.path;

local ffi = require("ffi");


require("win32.libloaderapi");
require("win32.errhandlingapi");
require("win32.consoleapi");

local OSModule = require("OSModule");

--[[
	Test cases
--]]
print("test_OSModule.lua - Test");


local function getCInfo(key)
	-- This first case covers values, this includes:
	-- constants, enums, and functions from within a library
	local success, info = pcall(function() return ffi.C[key] end)
	if success then 
		print(string.format("getCInfo(ffi.C.%s) : ", key, info))
		return info 
	end

	-- this second case covers when we want to return 
	-- a type declaration
	success, info = pcall(function() return ffi.typeof(key) end)
	if success then 
		print(string.format("getCInfo(ffi.typeof(%s)) : ", key, info))
		return info 
	end

	return nil, "not a constant nor a type";
end


local function test_loadmodule()
	local k32, err = OSModule("kernel32");

	print("OSModule: ", k32, err);

	local GetConsoleMode = k32.GetConsoleMode;

	print("GetConsoleMode", GetConsoleMode);

	local lpMode = ffi.new("DWORD[1]");
	local status = GetConsoleMode(nil, lpMode);

	print("Status: ", status);

	print(k32.SYSTEMTIME);
end

local function test_Signature()
ffi.cdef[[
typedef BOOL (* PFNGetConsoleMode)(HANDLE hConsoleHandle, LPDWORD lpMode);
]]

	local ffitype = ffi.typeof("PFNGetConsoleMode");
	--local ffitype = ffi.typeof("GetConsoleMode");
	local kernel32, err = OSModule("kernel32");

	print("ffitype: ", ffitype);
	local func = ffi.cast(ffitype, kernel32.GetConsoleMode);
	print("func: ", func);

	local lpMode = ffi.new("DWORD[1]");
	local status = func(nil, lpMode);
	print("Status: ", status);
	print("  Mode: ", lpMode[0]);
end

function test_loadlibrary()
	flags = 0;
	local handle = ffi.C.LoadLibraryExA("kernel32", nil, flags);

	print("test_loadlibrary, LoadLibraryExA: ", handle);

	if handle == nil then
		local err = ffi.C.GetLastError();
		print("Error loading library: ", err);
		
		return false, err;
	end

	local procName = "GetConsoleMode"
	local proc = ffi.C.GetProcAddress(handle, procName);

	print("GetProcAddress: ", proc)

	print("FFI Type: ", ffi.C[procName])
	local ffitype = ffi.typeof("$ *",  ffi.C[procName]);
	local castval = ffi.cast(ffitype, proc);

	print("Cast Proc Value: ", castval)
end

test_Signature();
--test_loadmodule();
--test_loadlibrary();

ffi.cdef[[
static const int someInt = 23;
]]

--print("GetConsoleMode : ", getCInfo("GetConsoleMode"))
--print("SYSTEMTIME : ", getCInfo("SYSTEMTIME"))
--print("someInt : ", getCInfo("someInt"))