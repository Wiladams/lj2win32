--[[
	mmap is the rough equivalent of the mmap() function on Linux
	This basically allows you to memory map a file, which means you 
	can access a pointer to the file's contents without having to 
	go through IO routines.

	Usage:
	local m = mmap(filename)
	local ptr = m:getMap()

	print(ffi.string(ptr, #m))
--]]

local ffi = require "ffi"
local C = ffi.C
local bit = require "bit"

require("win32.winbase")

ffi.cdef[[
struct mmap_t {
	short existed;
	void* filehandle;
	void* maphandle;
	void* map;
	int size;
	char filename[?];
};
]]

local mmap = {}
setmetatable(mmap, {
	__call = function(self, ...)
		return self:new(...)
	end
})
local mmap_mt = {
	__index = mmap
}




mmap.__index = mmap
local new_map


function mmap.new(self, filename, newsize)
	newsize = newsize or 0
	local obj = {}

	-- Open file
	obj.filehandle = C.CreateFileA(filename, 
		bit.bor(C.GENERIC_READ, C.GENERIC_WRITE), 
		0, nil,
		C.OPEN_ALWAYS, 
		bit.bor(C.FILE_ATTRIBUTE_ARCHIVE, C.FILE_FLAG_RANDOM_ACCESS), 
		nil)
	
    if obj.filehandle == nil then
		error("Could not create/open file for mmap: "..tostring(C.GetLastError()))
	end
	
	-- properly close handle if it goes out of scope
	ffi.gc(obj.filehandle, C.CloseHandle)

	-- Set file size if new
	local exists = C.GetLastError() == ffi.C.ERROR_ALREADY_EXISTS

	if exists then
		local fsize = C.GetFileSize(obj.filehandle, nil)
		if fsize == 0 then
			-- Windows will error if mapping a 0-length file, fake a new one
			exists = false
			obj.size = newsize
		else
			obj.size = fsize
		end
	else
		obj.size = newsize
	end
	obj.existed = exists
	
	-- Open mapping
	obj.maphandle = C.CreateFileMappingW(obj.filehandle, nil, C.PAGE_READWRITE, 0, obj.size, nil)
	if obj.maphandle == nil then
		error("Could not create file map: "..tostring(C.GetLastError()))
	end
	ffi.gc(obj.maphandle, C.CloseHandle)

	-- Open view
	obj.map = ffi.cast("uint8_t *", C.MapViewOfFile(obj.maphandle, C.FILE_MAP_ALL_ACCESS, 0, 0, 0))
	if obj.map == nil then
		error("Could not map: "..tostring(errorhandling.GetLastError()))
	end
	ffi.gc(obj.map, C.UnmapViewOfFile)

	setmetatable(obj, mmap_mt)

	return obj
end

function mmap.length(self)
	return self.size
end

function mmap.getPointer(self)
	return self.map
end



function mmap.close(self, no_ungc)
	if self.map ~= nil then
		C.UnmapViewOfFile(self.map)
		self.map = nil
	end
	if self.maphandle ~= nil then
		C.CloseHandle(self.maphandle)
		self.maphandle = nil
	end
	if self.filehandle ~= nil then
		C.CloseHandle(self.filehandle)
		self.filehandle = nil
	end
end


return mmap
