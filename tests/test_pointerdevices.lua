package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local winuser = require("win32.winuser")
local core_string = require("win32.core.string_l1_1_0");

--local errorhandling = require("win32.core.errorhandling_l1_1_1");

--[[
      DWORD displayOrientation;
    HANDLE device;
    POINTER_DEVICE_TYPE pointerDeviceType;
    HMONITOR monitor;
    ULONG startingCursorId;
    USHORT maxActiveContacts;
    WCHAR productString[POINTER_DEVICE_PRODUCT_STRING_MAX];  
--]]
local POINTER_DEVICE_TYPE = {
    [1] = "POINTER_DEVICE_TYPE_INTEGRATED_PEN",
    [2] = "POINTER_DEVICE_TYPE_EXTERNAL_PEN",
    [3] = "POINTER_DEVICE_TYPE_TOUCH",
    [4] = "POINTER_DEVICE_TYPE_TOUCH_PAD",
    [0xFFFFFFFF] = "POINTER_DEVICE_TYPE_MAX"
};

local function printPointerDevice(device)
    print("==== printPointerDevice ====")
    print("Name: ", core_string.toAnsi(device.productString))
    print("        Device Type: ", POINTER_DEVICE_TYPE[tonumber(device.pointerDeviceType)])
    print("Display Orientation: ", device.displayOrientation);
    print("          Cursor ID: ", device.startingCursorId);
    print("Max Active Contacts: ", device.maxActiveContacts);
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
