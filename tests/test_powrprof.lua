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

local function getDevices()
    local QueryIndex = 0;
    local QueryInterpretationFlags = C.DEVICEPOWER_FILTER_DEVICES_PRESENT
    local QueryFlags = 0
    local pBufferSize = ffi.new("ULONG[1]", C.MAX_PATH * ffi.sizeof("WCHAR"))  -- 
    local pReturnBuffer = ffi.new("uint8_t[?]", pBufferSize[0])

    -- should open device list
    -- query bunch of times
    -- otherwise, device list is opened/closed for every 
    -- call, which is not very performant
    while true do
        --local pBufferSize = ffi.new("ULONG[1]", 1024*64)  -- C.MAX_PATH * ffi.sizeof("WCHAR")
        --local pReturnBuffer = nil

        local status = powrprof.DevicePowerEnumDevices(
            QueryIndex,
            QueryInterpretationFlags,
            QueryFlags,
            pReturnBuffer,
            pBufferSize);

        --print ("getDevices(), 1: ", status)
        if status == 0 then
            local err = C.GetLastError()

            if err == C.ERROR_NO_MORE_ITEMS then
                break;
            end
--[[
            if err ~= C.ERROR_INSUFFICIENT_BUFFER then
                print("ERROR: ", err)
                break;
                --return false, err
            end
--]]
        end

--[[
        -- do it again with known size this time
        pReturnBuffer = ffi.new("uint8_t[?]", pBufferSize[0])
        status = powrprof.DevicePowerEnumDevices(QueryIndex, QueryInterpretationFlags, QueryFlags,
            pReturnBuffer,
            pBufferSize);

        print ("getDevices(), 2: ", status)
        if status == 0 then
            local err = C.GetLastError()

            --if err ~= C.ERROR_INSUFFICIENT_BUFFER then
                print("ERROR: ", err)
                return false, err
            --end
        end
--]]
        print(QueryIndex, ffi.string(toAnsi(pReturnBuffer)))
        QueryIndex = QueryIndex+1;
        pBufferSize[0] = C.MAX_PATH * ffi.sizeof("WCHAR")
    end
end


getDevices()