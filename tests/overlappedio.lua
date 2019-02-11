--[[
    Do some file IO using OVERLAPPED

    This is still synchronous

    If you pass in a file handle, we'll just
    use that.

    If a path is passed in, the file is opened
    for read and write.
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
    --    local dwFileSize        = C.GetFileSize(rawhandle, nil);
    --print("File Size: ", dwFileSize)

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
    local dwBytesRead       = ffi.new("DWORD[1]");
    local bytesRead = 0

    -- Attempt an asynchronous read operation.
    local bResult = C.ReadFile(self.File.Handle,
            buff,
            len,
            dwBytesRead,
            self.ReadingOL);
    
    local err = C.GetLastError()

    --print("READ result: ", bResult, err)

    if bResult == 0 then
        if err == C.ERROR_IO_PENDING then
            -- Check the result of the asynchronous read
            bResult = C.GetOverlappedResult(self.File.Handle,
                self.ReadingOL,
                dwBytesRead,
                1);
            
            --print("AFTER RESULT: ", bResult, dwBytesRead[0])
            -- reset the event as it is manual
            self.ReadingEvent:reset()
            

            if bResult == 0 then
                -- some error occured while waiting
                return false, "waiting for Overlapped Result"
            end

            -- update the offset in the overlapped structure
            -- to advance
            self.ReadingOL.Offset = self.ReadingOL.Offset + dwBytesRead[0]
        elseif err == ERROR_HANDLE_EOF then
            return 0, "EOF"
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
