package.path = "../?.lua;"..package.path;

--[[
    Use the winuser 'EnumDisplayDevices' call to get some display
    information.
]]
local ffi = require("ffi")
local C = ffi.C 
local bit = require("bit")
local band, bor = bit.band, bit.bor

require("win32.sdkddkver")

local wingdi = require("win32.wingdi")
local winuser = require("win32.winuser")

local exports = {}

--[[
    Return list of display adapters in the system
]]
function exports.adapters()
    local iDevNum = 0;

    local function closure()
        local pDisplayDevice = ffi.new("DISPLAY_DEVICEA")
        pDisplayDevice.cb = ffi.sizeof("DISPLAY_DEVICEA")
        local dwFlags = 0;
        local res = C.EnumDisplayDevicesA(nil, iDevNum, pDisplayDevice, dwFlags)
        iDevNum = iDevNum + 1;
        if res ~= 0 then
            return {
                Name = ffi.string(pDisplayDevice.DeviceName);
                Description = ffi.string(pDisplayDevice.DeviceString);
                ID = ffi.string(pDisplayDevice.DeviceID);
                Key = ffi.string(pDisplayDevice.DeviceKey);
                Flags = tonumber(pDisplayDevice.StateFlags);
                isActive = band(pDisplayDevice.StateFlags, C.DISPLAY_DEVICE_ACTIVE) ~= 0;
                isPrimary = band(pDisplayDevice.StateFlags, C.DISPLAY_DEVICE_PRIMARY_DEVICE) ~= 0
            }

        end

        return nil;
    end

    return closure
end

function exports.monitorsForAdapter(adapterName)
    local iDevNum = 0;

    local function closure()
        local pDisplayDevice = ffi.new("DISPLAY_DEVICEA")
        pDisplayDevice.cb = ffi.sizeof("DISPLAY_DEVICEA")
        local dwFlags = 0;
        local res = C.EnumDisplayDevicesA(adapterName, iDevNum, pDisplayDevice, dwFlags)
        if res == 0 then
            return nil;
        end

        iDevNum = iDevNum + 1;

        return {
            Name = ffi.string(pDisplayDevice.DeviceName);
            Description = ffi.string(pDisplayDevice.DeviceString);
            ID = ffi.string(pDisplayDevice.DeviceID);
            Key = ffi.string(pDisplayDevice.DeviceKey);
            Flags = tonumber(pDisplayDevice.StateFlags);
        }
    end

    return closure
end


for adapter in exports.adapters() do
    print("== ADAPTER ==")
    print("           Name: ", adapter.Name)
    print("    Description: ", adapter.Description)
    print("             ID: ", adapter.ID)
    print("            Key: ", adapter.Key)
    print("          Flags: ", string.format("0x%x", adapter.Flags))
    print("         Active: ", adapter.isActive)
    print("        Primary: ", adapter.isPrimary)

    if adapter.isActive then
        for monitor in exports.monitorsForAdapter(adapter.Name) do
            print("        -- Monitor --")
            print("                  Name: ", monitor.Name)
            print("           Description: ", monitor.Description)
            print("                    ID: ", monitor.ID);
            print("                   Key: ", monitor.Key);
        end
    end
end


