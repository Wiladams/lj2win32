-- test_OSModule.lua
--
--
--[[
	OSModule - This is a rough substitute for 
	using ffi.load, ffi.C and ffi.typeof

	Usage:
	local k32 = OSModule("kernel32")
	local GetConsoleMode = k32.GetConsoleMode;

	print("GetConsoleMode", GetConsoleMode);

	local lpMode = ffi.new("DWORD[1]");
	local status = GetConsoleMode(nil, lpMode);

	The advantage of this construct is that you get at all the 
	constants and types as well as functions through a single 
	interface.
--]]
local ffi = require("ffi");

require("win32.libloaderapi");
require("win32.errhandlingapi");



local OSModule = {}
setmetatable(OSModule,{
	__call = function(self, ...)
		return self:new(...);
	end,
})

local function getLibSymbol(lib, symbol)
	return pcall(function() return lib[symbol] end)
end

local function getCInfo(key)
    -- if it's a function or a constant
	local success, info = pcall(function() return ffi.C[key] end)
	if success then return info end

    -- if it's a type
	success, info = pcall(function() return ffi.typeof(key) end)

	if success then return info end

	return nil, "neither a function nor a type";
end

--[[
	Metatable for instances of the OSModule 
--]]
local OSModule_mt = {
	__index = function(self, key)
		--print("OSModule_mt.__index: ", key)
        -- see if the key is the name of a function
        local proc = ffi.C.GetProcAddress(self.Handle, key);
        
        --print("OSModule.__index, getProcAddress: ", proc)
        if proc ~= nil then
            -- We assume the function prototype already exists
            rawset(self, key, proc)
            return proc, "function";
        end

        return nil;

--[[
		-- get the type of the thing
		local success, ffitype = getCInfo(key);
        print("OSModule_mt.__index, ffitype: ", success, ffitype)
        
        if success then
            rawset(self, key, success)
            return success;
        end

		if not success then 
			return false, "declaration for type not found"
		end

		-- if it's a datatype, or constant, then 
		-- just return that

		-- turn the function information into a function pointer




		if proc ~= nil then
			ffitype = ffi.typeof("$ *", ffitype);
			local castval = ffi.cast(ffitype, proc);
			rawset(self, key, castval)

			return castval;
		end

		-- at this point we need to convert the type 
		-- into something interesting, and return that
        return ffitype;
--]]
	end,
}



function OSModule.init(self, handle)
	local obj = {
		Handle = handle;
	};

	setmetatable(obj, OSModule_mt);

	return obj;
end

function OSModule.new(self, name, flags)
	flags = flags or 0

	local handle = ffi.C.LoadLibraryExA(name, nil, flags);
	
	if handle == nil then
		return nil, ffi.C.GetLastError();
	end
	
	ffi.gc(handle, ffi.C.FreeLibrary);

	return self:init(handle);
end

function OSModule.getNativeHandle(self)
	return self.Handle
end

function OSModule.getProcAddress(self, procName)
	local addr = ffi.C.GetProcAddress(self:getNativeHandle(), procName);
	if not addr then
		return nil, ffi.C.GetLastError();
	end

	return addr;
end


return OSModule
