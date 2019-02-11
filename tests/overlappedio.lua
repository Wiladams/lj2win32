--[[
    Do some file IO using OVERLAPPED

    This is still synchronous

    If you pass in a file handle, we'll just
    use that.

    If a path is passed in, the file is opened
    for read and write.
    https://docs.microsoft.com/en-us/windows/desktop/FileIO/testing-for-the-end-of-a-file

]]

local ffi = require("ffi")
local C = ffi.C 
local bit = require("bit")
local band, bor = bit.band, bit.bor
local lshift, rshift = bit.lshift, bit.rshift



local EventHandle = require("eventhandle")
local FileHandle = require("filehandle")
require("win32.winbase")

local BUF_SIZE = 4096

local OverlappedIO = {}
setmetatable(OverlappedIO, {
    __call = function(self, ...)
        return self:new(...)
    end
})
local OverlappedIO_mt = {
    __index = OverlappedIO;
}

function OverlappedIO.init(self, rawhandle)
    if not rawhandle or rawhandle == C.INVALID_HANDLE_VALUE then
        return nil, "invalid handle specified"
    end

    --local fileSize = C.GetFileSize(rawhandle, nil);
    --print("File Size: ", fileSize)

    local obj = {
        File = FileHandle(rawhandle);
    }
    
    -- Setup Writing OVERLAP Structure
    obj.WritingEvent = EventHandle();
    obj.WritingOL = ffi.new("OVERLAPPED")
    obj.WritingOL.hEvent = obj.WritingEvent.Handle

    -- Setup Reading OVERLAPPED structure
    obj.ReadingEvent = EventHandle();
    obj.ReadingOL = ffi.new("OVERLAPPED")
    obj.ReadingOL.hEvent = obj.ReadingEvent.Handle

    setmetatable(obj, OverlappedIO_mt)

    return obj
end



function OverlappedIO.new(self, params)
    params = params or {}

    if not params.RawFileHandle then
        if not params.Path then
            return nil, "No File Path Specified"
        end

        -- Need to open up a file because a raw handle
        -- was not supplied
        local desiredAccess = bor(C.GENERIC_WRITE , C.GENERIC_READ)
        local shareMode = bor(C.FILE_SHARE_READ, C.FILE_SHARE_WRITE)

        params.RawFileHandle = C.CreateFileA(params.Path, desiredAccess, shareMode,
            nil, C.OPEN_EXISTING, C.FILE_FLAG_OVERLAPPED, nil)
    
        if params.RawFileHandle == C.INVALID_HANDLE_VALUE then
            return false, "failed to open file"
        end
    end

    return self:init(params.RawFileHandle)
end


--[[
    Read from the file handle.  This is 
    synchronous, so it waits for the 
    event to signal, before returning.
]]
function OverlappedIO.read(self, buff, len, async)
    local dwBytesRead = ffi.new("DWORD[1]");
    local bytesRead = 0

    -- Attempt an asynchronous read operation.
    local success = C.ReadFile(self.File.Handle,
            buff,
            len,
            dwBytesRead,
            self.ReadingOL) ~= 0;
    
    local err = C.GetLastError()

    --print("READ result: ", success, err)
    --[[
        Errors can occur a few ways.  At this ReadFile()
        we expect to either see no error, bResult ~= 0
        or, bResult and there's an error

        The error will typically be ERROR_IO_PENDING
        if it's not, then we should drop out and 
        return the error.

        If it is ERROR_IO_PENDING, then we need to do
        the GetOverlappedResult(), which itself has
        error conditions.

        That can either return no error (bResult ~= 0),
        or continue pending
    ]]
    if not success then
        if err == C.ERROR_IO_PENDING then
            -- Check the result of the asynchronous read
            success = C.GetOverlappedResult(self.File.Handle,
                self.ReadingOL,
                dwBytesRead,
                1) ~= 0;
            
            err = C.GetLastError()
            
            --print("AFTER RESULT: ", success, dwBytesRead[0])
            -- reset the event as it is manual
            self.ReadingEvent:reset()

            if not success then
                if err == C.ERROR_HANDLE_EOF then
                    return false, "EOF"
                end
                -- some error occured while waiting
                return false, "GetOverlappedResult(): "..tostring(err)
            end

            -- the offset in the overlapped structure must be advanced
            -- or the next time we read, we'll be in the same position
            self.ReadingOL.Offset = self.ReadingOL.Offset + dwBytesRead[0]
        elseif err == C.ERROR_HANDLE_EOF then
            return false, "EOF"
        end
    else
        -- no pending, so we're done

    end
    
    bytesRead = dwBytesRead[0]

    return bytesRead
end

function OverlappedIO.write(self, buff, len, asyn)
    local res = C.WriteFile(self.Handle.Handle, buf, len, nil, ol)

end

return OverlappedIO
