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

--[[
In order to iterate over the Power Devices, you can simply
call the DevicePowerEnumDevices() function repeatedly until
it indicates error.

This will work fine, but internally, the function checks to 
see if the device list has been opened already or not.  If it
has not been opened (for querying), the individual enum calls
are bracketed with DevicePowerOpen()/DevicePowerClose() calls.

This will be very slow.  The more optimal way is to call 
DevicePowerOpen() once, before multiple calls to DevicePowerEnumDevices(),
and then call DevicePowerClose() at the end.

The DevicePowerQuery structure essentially wraps up all this logic.
It is a cdata type which allows us to attach __gc finalizer, so when it
goes out of scope, the DevicePowerClose() function will be called,
saving us from havnig to worry about its closure in the case
where the iterator is abandoned.
--]]

ffi.cdef[[
typedef struct {
    int Handle;
} DevicePowerQuery;
]]
local DevicePowerQuery = ffi.typeof("DevicePowerQuery")
local DevicePowerQuery_mt = {
    __gc = function(self)
        -- when this object goes out of scope, close
        -- the query
        powrprof.DevicePowerClose();
    end;

    __new = function(ct,...)
        -- we need to open up the query to start
        -- if the fails, don't bother creating an object
        -- and return nil
        if powrprof.DevicePowerOpen(0) == 0 then
            return nil;
        end

        -- Create an instance of the type so we
        -- have something to garbage collect
        local obj = ffi.new(ct, ...)
        return obj;
    end;

    __index = {
        devices = function(self, qparams)
            return coroutine.wrap(function()
                local QueryInterpretationFlags = C.DEVICEPOWER_FILTER_DEVICES_PRESENT
                local QueryFlags = 0
                local pBufferSize = ffi.new("ULONG[1]", C.MAX_PATH * ffi.sizeof("WCHAR"))  -- 
                local pReturnBuffer = ffi.new("uint8_t[?]", pBufferSize[0])
                local QueryIndex = 0;

                while powrprof.DevicePowerEnumDevices(QueryIndex,QueryInterpretationFlags,QueryFlags,
                    pReturnBuffer, pBufferSize) ~= 0 do
    
                    coroutine.yield(ffi.string(toAnsi(pReturnBuffer)))
                    QueryIndex = QueryIndex+1;
                    pBufferSize[0] = C.MAX_PATH * ffi.sizeof("WCHAR")
                end
            end)
        end;

    }
}
ffi.metatype("DevicePowerQuery", DevicePowerQuery_mt)


local function iterateDevices()
    local query = DevicePowerQuery();

    for dev in query:devices() do
        print(string.format("{'%s'},",dev))
    end
end

local function getDeviceTable()
    local query = DevicePowerQuery();

    local devices = {}

    for dev in query:devices() do
        table.insert(devices, dev)
    end

    return devices
end

local function getPowerSchemeTable()
    local results = {}

    local RootPowerKey = nil;
    local SchemeGuid = nil;
    local SubGroupOfPowerSettingsGuid = nil;
    local AccessFlags = C.ACCESS_SCHEME
    local Index = 0
    local BufferSize = ffi.new("DWORD[1]", 1024)
    local Buffer = ffi.new("uint8_t[?]", BufferSize[0])

    while true do
        local status = powrprof.PowerEnumerate(RootPowerKey, SchemeGuid, SubGroupOfPowerSettingsGuid,
            AccessFlags, Index, Buffer, BufferSize)
        
        print("status: ", status)

        if status == C.ERROR_NO_MORE_ITEMS then
            break;
        end

        local str = ffi.string(unicode.toAnsi(Buffer))
        --local str = ffi.string(Buffer)
        print(str)
        Index = Index + 1;
        BufferSize[0] = 1024
    end
end

local function test_deviceTable()
    local tbl = getDeviceTable();

    for i, dev in ipairs(tbl) do
        print(dev)
    end
end



--iterateDevices()
test_deviceTable()
--getPowerSchemeTable()
