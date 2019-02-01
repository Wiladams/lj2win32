package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 
local bit = require("bit")
local band, bor = bit.band, bit.bor

require("win32.sdkddkver")
require("win32.minwindef")
require("win32.winreg")
require("win32.errhandlingapi")
require("win32.winerror")

local powrprof = require("win32.powrprof")
local unicode = require("unicode_util")
local toAnsi = unicode.toAnsi

-- convenience for iterator producers
local  function send (...)
    coroutine.yield(...)
end

-- an iterator for all producers
local function co_iterator(producer)
    return coroutine.wrap(producer)
end

-- The challenge with this implementation is that when you use
-- DevicePowerOpen(), you must pair it with a DevicePowerClose()
-- Since we're in an iterator which can be abandoned at any time
-- we won't necessary get to the end of the iteration.
-- in that case, the iterator itself should be an object with a finalizer
-- so that in the finalizer we can do the close if it hasn't already
-- happened by the time we get there.
-- Another way to do it is to pull all the results into a table
-- from the beginning, and just feed out of the table
local function device_prod()
    local QueryIndex = 0;
    local QueryInterpretationFlags = C.DEVICEPOWER_FILTER_DEVICES_PRESENT
    local QueryFlags = 0
    local pBufferSize = ffi.new("ULONG[1]", C.MAX_PATH * ffi.sizeof("WCHAR"))  -- 
    local pReturnBuffer = ffi.new("uint8_t[?]", pBufferSize[0])


    if powrprof.DevicePowerOpen(0) == 0 then
        return nil;
    end

    while powrprof.DevicePowerEnumDevices(QueryIndex,QueryInterpretationFlags,QueryFlags,
        pReturnBuffer, pBufferSize) ~= 0 do

        coroutine.yield(ffi.string(toAnsi(pReturnBuffer)))
        QueryIndex = QueryIndex+1;
        pBufferSize[0] = C.MAX_PATH * ffi.sizeof("WCHAR")
    end

    powrprof.DevicePowerClose();
end



local function getDevices()
    for dev in co_iterator(device_prod) do
        print(string.format("{'%s'},",dev))
    end
end


getDevices()