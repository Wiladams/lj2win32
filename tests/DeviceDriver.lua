local ffi = require("ffi")

local psapi = require("win32.psapi")
require("win32.processthreadsapi")
require("win32.handleapi")

local DeviceDriver = {}
setmetatable(DeviceDriver, {
    __call = function(self, ...)
        return self:new(...)
    end
})
local DeviceDriver_mt = {
    __index = DeviceDriver;
}

function DeviceDriver.init(self, imageBase)
    local obj = {
        base = imageBase;
    }
    setmetatable(obj, DeviceDriver_mt)

    return obj;
end

function DeviceDriver.new(self, ...)
    return self:init(...)
end

-- return an iterator over device drivers
function DeviceDriver.drivers(self)

    -- find out how much space we need
    local lpImageBase = nil;
    local cb = 0;
    local pcbNeeded = ffi.new("DWORD[1]")
    local success = ffi.C.K32EnumDeviceDrivers (lpImageBase, cb, pcbNeeded) ~= 0


    if not success then
        return false, "error enumerating device drivers"
    end

    local cbNeeded = pcbNeeded[0]
    lpImageBase = ffi.new("void *[?]", cbNeeded/ffi.sizeof("void *"))
    -- make the call again with the right sized array
    local success = ffi.C.K32EnumDeviceDrivers (lpImageBase, cbNeeded, pcbNeeded) ~= 0

    if not success then
        return false, "error with second call to K32EnumDeviceDrivers"
    end

    -- Now that we have an array of device driver handles, we 
    -- can return a closure that can iterate over them, returning
    -- DeviceDriver objects along the way
    local numDrivers = pcbNeeded[0] / ffi.sizeof("LPVOID")
    local offset = 0;

    local function closure()
        if offset >= numDrivers then 
            return nil;
        end

        local newDriver = DeviceDriver(lpImageBase[offset])
        offset = offset + 1;
        
        return offset, newDriver;
    end

    return closure
end

function DeviceDriver.getName(self)
    local lpFilename = ffi.new("char[?]", ffi.C.MAX_PATH)
    local size = ffi.C.K32GetDeviceDriverBaseNameA (self.base,lpFilename, ffi.C.MAX_PATH);
    local success = size ~= 0;

    if not success then
        return false, "K32GetDeviceDriverBaseNameA failed"
    end

    return ffi.string(lpFilename, size)
end

function DeviceDriver.getFilename(self)
    local lpFilename = ffi.new("char[?]", ffi.C.MAX_PATH)

    local size = ffi.C.K32GetDeviceDriverFileNameA (self.base,lpFilename, ffi.C.MAX_PATH);
    local success = size ~= 0;
    
    if not success then
            return false, "K32GetDeviceDriverFileNameA failed"
    end
    
    return ffi.string(lpFilename, size)
end

return DeviceDriver
