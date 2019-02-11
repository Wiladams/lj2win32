local ffi = require("ffi")
local C = ffi.C 
local fileapi = require("win32.fileapi")

ffi.cdef[[
typedef struct {
	HANDLE  Handle;
} FsHandle;
]]

local FileHandle = {};
setmetatable(FileHandle, {
    __call = function(self, ...)
        return self:new(...)
    end
})
local FsHandle_mt = {
    __gc = function(self)
        C.CloseHandle(self.Handle);
    end,

    __index = FileHandle,
};
ffi.metatype("FsHandle", FsHandle_mt);

function FileHandle.init(self, params)
    if not params.RawFileHandle then
        return nil;
    end

    local handle = ffi.new("FsHandle", params.RawFileHandle)
    return handle
end

function FileHandle.new(self, params)
    params = params or {}
    
    if not params.RawFileHandle then
        if not params.Path then
            return nil, "No File Path Specified"
        end

        -- Need to open up a file because a raw handle
        -- was not supplied
        local desiredAccess = params.DesiredAccess or bor(C.GENERIC_WRITE , C.GENERIC_READ)
        local shareMode = params.ShareMode or bor(C.FILE_SHARE_READ, C.FILE_SHARE_WRITE)
        local creationDisposition = params.CreationDisposition or C.OPEN_EXISTING
        local flagsAndAttributes = params.FlagsAndAttributes or C.FILE_FLAG_OVERLAPPED

        params.RawFileHandle = C.CreateFileA(params.Path, 
            desiredAccess, 
            shareMode,
            nil, 
            creationDisposition,    -- CreationDisposition
            flagsAndAttributes,     -- FlagsAndAttributes
            nil)

        if params.RawFileHandle == C.INVALID_HANDLE_VALUE then
            return false, "failed to open file"
        end
    end

    return self:init(params)
end

function FileHandle.isValid(self)
    return self.Handle ~= C.INVALID_HANDLE_VALUE;
end

function FileHandle.close(self)
    C.CancelIo(self.Handle)
    C.CloseHandle(self.Handle)
end

function FileHandle.size(self)
    local fileSize = C.GetFileSize(self.Handle, nil);
    return fileSize
end


return ffi.typeof("FsHandle")
