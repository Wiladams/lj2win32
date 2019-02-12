local ffi = require("ffi")
local C = ffi.C 

require("win32.fileapi")
local unicode = require("unicode_util")
local strdelim = require("strdelim")
local Volume = require("volume")





local VolumeManager = {}

-- Iterate over the names of volumes
function VolumeManager.volumeNames(self)
    local function visitor()
        local buffLen = C.MAX_PATH
        local volumeName = ffi.new("wchar_t[?]", C.MAX_PATH)
        local queryhandle = C.FindFirstVolumeW(volumeName, buffLen);
        
        if queryhandle == C.INVALID_HANDLE_VALUE then
            return nil;
        end
        ffi.gc(queryhandle, C.FindVolumeClose)

        coroutine.yield(Volume(unicode.toAnsi(volumeName)))

        while true do
            local success = C.FindNextVolumeW(queryhandle, volumeName, buffLen) ~= 0;
            if not success then
                --C.FindVolumeClose(queryhandle)
                return nil;
            end

            coroutine.yield(Volume(unicode.toAnsi(volumeName)))
        end
    end

    return coroutine.wrap(visitor)
end

return VolumeManager