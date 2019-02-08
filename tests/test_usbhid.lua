package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 
local bit = require("bit")
local band, bor = bit.band, bit.bor
local lshift, rshift = bit.lshift, bit.rshift

require("win32.sdkddkver")

require("win32.winreg")
require("win32.wingdi")
require("win32.winuser")
local setupapi = require("win32.setupapi")
local hidsdi = require("win32.hidsdi")
require("win32.errhandlingapi")
require("win32.winerror")


-- We want to get a list of HID Devices
-- You could just do this by querying the registry
-- but, the following is how you do it using the win32 API

-- 1. obtain the device interface GUID for the HID class
-- GUID_DEVINTERFACE_HID, from hidclass.lua
local HIDGuid = ffi.new("GUID")
hidsdi.HidD_GetHidGuid(HIDGuid)

print("HID GUID: ", HIDGuid)

-- 2. Request a pointer to a device information set 
local Enumerator = nil
local hwndParent = nil
local Flags = bor(C.DIGCF_PRESENT, C.DIGCF_DEVICEINTERFACE);

local deviceInfoSet = setupapi.SetupDiGetClassDevsA(HIDGuid, Enumerator, hwndParent, Flags);
print("hdevinfo: ", deviceInfoSet)

assert(deviceInfoSet)

-- 4. Request a structure containing a device interface's device path name
local function getDevicePath(deviceInfoSet, DeviceInterfaceData)
    --print("getDevicePath: ", deviceInfoSet, DeviceInterfaceData)

    local DeviceInterfaceDetailData = nil   --      PSP_DEVICE_INTERFACE_DETAIL_DATA_A 
    local DeviceInterfaceDetailDataSize = 0
    local pRequiredSize = ffi.new("DWORD[1]")
    local DeviceInfoData = nil              -- PSP_DEVINFO_DATA

    -- call once to get size requirement
    local status = setupapi.SetupDiGetDeviceInterfaceDetailA(deviceInfoSet,
        DeviceInterfaceData,
        DeviceInterfaceDetailData, 
        DeviceInterfaceDetailDataSize,
        pRequiredSize,
        DeviceInfoData)
    
    --print("REQUIRED: ", pRequiredSize[0])
    -- status should be 0, and GetLastError() should be 122
    if status == 0 then
        local err = C.GetLastError()
        if err ~= C.ERROR_INSUFFICIENT_BUFFER then
            return nil, err
        end
    end


    -- now we know how much of a buffer to allocate
    -- so allocate the space and call again
    DeviceInterfaceDetailDataSize = pRequiredSize[0]
    local detailBuffer = ffi.new("uint8_t[?]", pRequiredSize[0])
    DeviceInterfaceDetailData = ffi.cast("PSP_DEVICE_INTERFACE_DETAIL_DATA_A", detailBuffer)
    if ffi.sizeof("intptr_t") == 4 then
        DeviceInterfaceDetailData.cbSize = 4+1;
    elseif ffi.sizeof("intptr_t") == 8 then
        DeviceInterfaceDetailData.cbSize = 8;
    end

    --print("struct sizes: ", pRequiredSize[0], ffi.sizeof("SP_DEVICE_INTERFACE_DETAIL_DATA_A"))

    status = setupapi.SetupDiGetDeviceInterfaceDetailA(deviceInfoSet,
        DeviceInterfaceData,
        DeviceInterfaceDetailData, 
        DeviceInterfaceDetailDataSize,
        nil,
        nil)

    --print("second status: ", status)
    if status == 0 then
        return nil, status, C.GetLastError()
    end

    
    -- 5. Extract the device path name from the structure
    return ffi.string(DeviceInterfaceDetailData.DevicePath)
end


-- 3. Request a pointer to a structure that contains info about a device interface
local DeviceInfoData = nil;
local InterfaceClassGuid = HIDGuid;
local DeviceInterfaceData = ffi.new("SP_DEVICE_INTERFACE_DATA")
DeviceInterfaceData.cbSize = ffi.sizeof("SP_DEVICE_INTERFACE_DATA")

local function devices()
    local MemberIndex = 0;
    while setupapi.SetupDiEnumDeviceInterfaces(deviceInfoSet,
        DeviceInfoData,
        InterfaceClassGuid,
        MemberIndex,
        DeviceInterfaceData) ~= 0 do

        --print("Flags: ", DeviceInterfaceData.Flags)
        print(getDevicePath(deviceInfoSet, DeviceInterfaceData))
        -- advance to the next member
        MemberIndex = MemberIndex + 1;
    end
end
devices();

-- 6. Close communications
local success = setupapi.SetupDiDestroyDeviceInfoList(deviceInfoSet) ~= 0
print("shutdown: ", success)
