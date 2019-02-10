local ffi = require("ffi")
local C = ffi.C 
local fileapi = require("win32.fileapi")

ffi.cdef[[
typedef struct {
	HANDLE  Handle;
} FsHandle;
]]

local FsHandle = ffi.typeof("FsHandle");
local FsHandle_mt = {
    __gc = function(self)
        C.CloseHandle(self.Handle);
    end,

    __index = {
        isValid = function(self)
            return self.Handle ~= C.INVALID_HANDLE_VALUE;
        end,

        close = function(self)
            C.CancelIo(self.Handle)
            C.CloseHandle(self.Handle)
        end,
    },
};
ffi.metatype(FsHandle, FsHandle_mt);

return FsHandle
