package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

require("win32.sdkddkver")

local wingdi = require("win32.wingdi")
local winuser = require("win32.winuser")
local errorhandling = require("win32.errhandlingapi");
local core_string = require("experimental.apiset.string_l1_1_0");

local POINTER_DEVICE_TYPE = {
    [1] = "POINTER_DEVICE_TYPE_INTEGRATED_PEN",
    [2] = "POINTER_DEVICE_TYPE_EXTERNAL_PEN",
    [3] = "POINTER_DEVICE_TYPE_TOUCH",
    [4] = "POINTER_DEVICE_TYPE_TOUCH_PAD",
    [0xFFFFFFFF] = "POINTER_DEVICE_TYPE_MAX"
};

local function printPointerDevice(device)
    io.write(string.format("{ Name = '%s';", core_string.toAnsi(device.productString)))
    io.write(string.format("  DeviceType = '%s';", POINTER_DEVICE_TYPE[tonumber(device.pointerDeviceType)]))
    io.write(string.format("  DisplayOrientation = '%s';", device.displayOrientation));
    io.write(string.format("  CursorID = %d;", device.startingCursorId));
    print(string.format("  MaxActiveContacts = %d;", device.maxActiveContacts));
end


local function test_pointerlist()
    local pdeviceCount = ffi.new("UINT32[1]")
    local pointerDevices = nil;

    local success = winuser.GetPointerDevices(pdeviceCount, pointerDevices)

    if success == 0 then
        print("GetPointerDevices failed, first time: ");
        return false;
    end
    local deviceCount = pdeviceCount[0];

    print("Number of Devices: ", deviceCount)

    if deviceCount < 1 then
        print("No pointer devices")
        return false;
    end

    local pointerDevices = ffi.new("POINTER_DEVICE_INFO[?]", deviceCount);
    success = winuser.GetPointerDevices(pdeviceCount, pointerDevices);

    if success == 0 then
        print("GetPointerDevices failed, second time")
        return false;
    end

    for idx = 0, deviceCount -1 do 
        printPointerDevice(pointerDevices[idx])
    end


end

test_pointerlist();
