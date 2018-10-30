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

--local winnt = require("win32.winnt")
local memoryapi = require("win32.memoryapi")
--local memory = require("win32.core.memory_l1_1_1")
local file = require("win32.core.file_l1_2_0")
local errorhandling = require("win32.core.errorhandling_l1_1_1");
local handle = require("win32.core.handle_l1_1_0")



--local PAGE_READWRITE = 0x4
--local FILE_MAP_ALL_ACCESS = 0xf001f


local mmap = {}
mmap.__index = mmap
local new_map


function mmap:__new(filename, newsize)
	newsize = newsize or 0
	local m = ffi.new(self, #filename+1)
	
	-- Open file
	m.filehandle = file.CreateFileA(filename, bit.bor(C.GENERIC_READ, C.GENERIC_WRITE), 0, nil,
		C.OPEN_ALWAYS, bit.bor(C.FILE_ATTRIBUTE_ARCHIVE, C.FILE_FLAG_RANDOM_ACCESS), nil)
	
    if m.filehandle == nil then
		error("Could not create/open file for mmap: "..tostring(errorhandling.GetLastError()))
	end
	
	-- Set file size if new
	local exists = errorhandling.GetLastError() == ffi.C.ERROR_ALREADY_EXISTS

	if exists then
		local fsize = file.GetFileSize(m.filehandle, nil)
		if fsize == 0 then
			-- Windows will error if mapping a 0-length file, fake a new one
			exists = false
			m.size = newsize
		else
			m.size = fsize
		end
	else
		m.size = newsize
	end
	m.existed = exists
	
	-- Open mapping
	m.maphandle = memory.CreateFileMappingW(m.filehandle, nil, ffi.C.PAGE_READWRITE, 0, m.size, nil)
	if m.maphandle == nil then
		error("Could not create file map: "..tostring(errorhandling.GetLastError()))
	end
	
	-- Open view
	m.map = memory.MapViewOfFile(m.maphandle, ffi.C.FILE_MAP_ALL_ACCESS, 0, 0, 0)
	if m.map == nil then
		error("Could not map: "..tostring(errorhandling.GetLastError()))
	end
	
	-- Copy filename (for delete)
	ffi.copy(m.filename, filename)
	
	return m
end

function mmap:getPointer()
	return self.map
end

function mmap:__len()
	return self.size
end

function mmap:close(no_ungc)
	if self.map ~= nil then
		memory.UnmapViewOfFile(self.map)
		self.map = nil
	end
	if self.maphandle ~= nil then
		handle.CloseHandle(self.maphandle)
		self.maphandle = nil
	end
	if self.filehandle ~= nil then
		handle.CloseHandle(self.filehandle)
		self.filehandle = nil
	end
	
	if not no_ungc then ffi.gc(self, nil) end
end

function mmap:__gc()
	self:close(true)
end

function mmap:delete()
	self:close()
	file.DeleteFileA(self.filename)
end

local new_map = ffi.metatype([[struct {
	short existed;
	void* filehandle;
	void* maphandle;
	void* map;
	int size;
	char filename[?];
}]], mmap)

return new_map

