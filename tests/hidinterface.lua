package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 
local bit = require("bit")
local band, bor = bit.band, bit.bor
local lshift, rshift = bit.lshift, bit.rshift


require("win32.winreg")
require("win32.wingdi")
require("win32.winuser")
require("win32.errhandlingapi")
require("win32.winerror")

local setupapi = require("win32.setupapi")
local hidsdi = require("win32.hidsdi")
local hidclass = require("win32.hidclass")

local HID_OUT_CTL_CODE = hidclass.HID_OUT_CTL_CODE
local IOCTL_HID_GET_FEATURE = C.IOCTL_HID_GET_FEATURE

local HIDInterface = {}
setmetatable(HIDInterface, {
    __call = function(self, ...)
        return self:new(...)
    end
})
local HIDInterface_mt = {
    __index = HIDInterface;

    -- this should actually wrap a 'safehandle'
    __gc = function(self)
--        local success = setupapi.SetupDiDestroyDeviceInfoList(deviceInfoSet) ~= 0
    end;
}

function HIDInterface.init(self, classguid, deviceInfoSet)
    local obj = {
        guid = classguid;
        deviceInfoSet = deviceInfoSet;
    }
    setmetatable(obj, HIDInterface_mt)

    return obj
end

function HIDInterface.new(self,...)
    -- GUID_DEVINTERFACE_HID, from hidclass.lua
    local HIDGuid = ffi.new("GUID")
    hidsdi.HidD_GetHidGuid(HIDGuid)
    -- if HIDGuid:isEmpty() then return nil end

    -- 2. Request a pointer to a device information set 
    local Enumerator = nil
    local hwndParent = nil
    local Flags = bor(C.DIGCF_PRESENT, C.DIGCF_DEVICEINTERFACE);

    local deviceInfoSet = setupapi.SetupDiGetClassDevsA(HIDGuid, Enumerator, hwndParent, Flags);
    --print("hdevinfo: ", deviceInfoSet)

    if not deviceInfoSet then
        return nil, "could not get class devs"
    end


    return self:init(HIDGuid, deviceInfoSet)
end


-- 4. Request a structure containing a device interface's device path name
local function getDevicePath(deviceInfoSet, DeviceInterfaceData)
    --print("getDevicePath: ", deviceInfoSet, DeviceInterfaceData)

    local DeviceInterfaceDetailData = nil   --      PSP_DEVICE_INTERFACE_DETAIL_DATA_A 
    local DeviceInterfaceDetailDataSize = 0
    local pRequiredSize = ffi.new("DWORD[1]")
    local DeviceInfoData = ffi.new("SP_DEVINFO_DATA")              -- PSP_DEVINFO_DATA
    DeviceInfoData.cbSize = ffi.sizeof("SP_DEVINFO_DATA")

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

function HIDInterface.devicePaths(self)

    
    local function iterator()
        local MemberIndex = 0;
        local DeviceInterfaceData = ffi.new("SP_DEVICE_INTERFACE_DATA")
        DeviceInterfaceData.cbSize = ffi.sizeof("SP_DEVICE_INTERFACE_DATA")
        local DeviceInfoData = nil;
        local InterfaceClassGuid = self.guid;

        while setupapi.SetupDiEnumDeviceInterfaces(self.deviceInfoSet,
            DeviceInfoData,
            self.guid,
            MemberIndex,
            DeviceInterfaceData) ~= 0 do

            --print("Flags: ", DeviceInterfaceData.Flags)
            local devPath = getDevicePath(self.deviceInfoSet, DeviceInterfaceData)
            coroutine.yield(devPath)

            MemberIndex = MemberIndex + 1;
        end
    end

    return coroutine.wrap(iterator)
end


return HIDInterface

