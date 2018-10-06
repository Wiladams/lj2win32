package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local winuser = require("winuser")
--local errorhandling = require("win32.core.errorhandling_l1_1_1");

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


end

test_pointerlist();
