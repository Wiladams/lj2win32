package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

require("win32.sdkddkver")

local wingdi = require("win32.wingdi")
local winuser = require("win32.winuser")
local winerror = require("win32.winerror")


local function getDeviceName(self)
    --print("==== getDeviceInfo ====")
    -- First get the name of the device
    --print("Type: ", device.dwType)
    local uiCommand = ffi.C.RIDI_DEVICENAME;

    local pcbSize = ffi.new("UINT[1]",0);
    local res = winuser.GetRawInputDeviceInfoA(self.deviceHandle, uiCommand, nil, pcbSize);

    --print("Res: ", string.format("0x%x",res), pcbSize[0])
    -- now get the real data
    local pData = ffi.new("uint8_t[?]", pcbSize[0])
    res = winuser.GetRawInputDeviceInfoA(self.deviceHandle, uiCommand, pData, pcbSize);

    --print("Res 2: ", res, pData, pcbSize[0])
    if res > 0 then
        return ffi.string(pData, res);
    end

    return nil;
end

local function getDeviceInfo(self)
    --print("==== getDeviceInfo ====")
    local uiCommand = ffi.C.RIDI_DEVICEINFO;
    local pData = ffi.new("RID_DEVICE_INFO");
    pData.cbSize = ffi.sizeof("RID_DEVICE_INFO");
    local pcbSize = ffi.new("UINT[1]",pData.cbSize);

    local res = winuser.GetRawInputDeviceInfoA(self.deviceHandle, uiCommand, pData, pcbSize);

    if res < 0 then
        return false;
    end
    --print("res: ", res, pData.dwType)
    if pData.dwType == ffi.C.RIM_TYPEMOUSE    then
        self.kind = "mouse";
        self.ID = pData.mouse.dwId;
        self.NumberOfButtons = pData.mouse.dwNumberOfButtons;
        self.SampleRate = pData.mouse.dwSampleRate;
        self.HasHorizontalWheel = pData.mouse.fHasHorizontalWheel;
    elseif pData.dwType == ffi.C.RIM_TYPEKEYBOARD then
        self.Kind = "keyboard";
        self.SubType = pData.keyboard.dwSubType;
        self.KeyboardMode = pData.keyboard.dwKeyboardMode;
        self.NumberOfFunctionKeys = pData.keyboard.dwNumberOfFunctionKeys;
        self.NumberOfIndicators = pData.keyboard.dwNumberOfIndicators;
        self.NumberOfKeysTotal = pData.keyboard.dwNumberOfKeysTotal;
    elseif pData.dwType == ffi.C.RIM_TYPEHID      then
        self.Kind = "hid";
        self.VendorId = pData.hid.dwVendorId;
        self.ProductId = pData.hid.dwProductId;
        self.VersionNumber = pData.hid.dwVersionNumber;
        self.UsagePage = pData.hid.usUsagePage;
        self.Usage = pData.hid.usUsage;
    else
        return false;
    end

    return self;
end

local function RawInputDevice(deviceHandle, deviceType)
    local obj = {
        deviceHandle = deviceHandle;
        deviceType = deviceType;
    }
    obj.Name = getDeviceName(obj);
    getDeviceInfo(obj);

    return obj;
end

local function getListOfInputDevices()
    local puiNumDevices = ffi.new("UINT[1]")
    local cbSize = ffi.sizeof(ffi.typeof("RAWINPUTDEVICELIST"))

    -- First figure out how many there are
    local res = winuser.GetRawInputDeviceList(nil, puiNumDevices, cbSize)

    -- Allocate enough space to contain the actual data
    local pRawInputDeviceList = ffi.new("RAWINPUTDEVICELIST[?]", puiNumDevices[0])
    -- now get them for real
    res = winuser.GetRawInputDeviceList(pRawInputDeviceList, puiNumDevices, cbSize);

    -- Assuming we got them all, return in a table
    local devices = {}
    for i=0,puiNumDevices[0]-1 do
        table.insert(devices, 
            RawInputDevice(pRawInputDeviceList[i].hDevice, pRawInputDeviceList[i].dwType))
    end

    return devices, puiNumDevices[0];
end

local function test_deviceinfo()
local function printDeviceInfo(dinfo)
    print("==== Device Info ====")
    for k,v in pairs(dinfo) do
        print(k,v)
    end
end


local devices, count = getListOfInputDevices()

for idx, dinfo in ipairs(devices) do
    printDeviceInfo(dinfo)
end
end

test_deviceinfo();
