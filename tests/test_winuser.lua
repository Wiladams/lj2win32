package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

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


--[[
    typedef struct DISPLAYCONFIG_MODE_INFO
{
    DISPLAYCONFIG_MODE_INFO_TYPE    infoType;
    UINT32                          id;
    LUID                            adapterId;
    union
    {
        DISPLAYCONFIG_TARGET_MODE   targetMode;
        DISPLAYCONFIG_SOURCE_MODE   sourceMode;
        DISPLAYCONFIG_DESKTOP_IMAGE_INFO    desktopImageInfo;
    } ;
} DISPLAYCONFIG_MODE_INFO;

typedef struct DISPLAYCONFIG_TARGET_MODE
{
    DISPLAYCONFIG_VIDEO_SIGNAL_INFO   targetVideoSignalInfo;
} DISPLAYCONFIG_TARGET_MODE;
typedef struct DISPLAYCONFIG_VIDEO_SIGNAL_INFO
{
    UINT64                          pixelRate;
    DISPLAYCONFIG_RATIONAL          hSyncFreq;
    DISPLAYCONFIG_RATIONAL          vSyncFreq;
    DISPLAYCONFIG_2DREGION          activeSize;
    DISPLAYCONFIG_2DREGION          totalSize;

    union
    {
        struct
        {
            UINT32 videoStandard : 16;

            // Vertical refresh frequency divider
            UINT32 vSyncFreqDivider : 6;

            UINT32 reserved : 10;
        } AdditionalSignalInfo;

        UINT32 videoStandard;
    } ;

    // Scan line ordering (e.g. progressive, interlaced).
    DISPLAYCONFIG_SCANLINE_ORDERING scanLineOrdering;
} DISPLAYCONFIG_VIDEO_SIGNAL_INFO;
]]

local DISPLAYCONFIG_PIXELFORMAT = 
{
    [1] = "DISPLAYCONFIG_PIXELFORMAT_8BPP";
    [2] = "DISPLAYCONFIG_PIXELFORMAT_16BPP",
    [3] = "DISPLAYCONFIG_PIXELFORMAT_24BPP",
    [4] = "DISPLAYCONFIG_PIXELFORMAT_32BPP",
    [5] = "DISPLAYCONFIG_PIXELFORMAT_NONGDI",
    [0xffffffff] = "DISPLAYCONFIG_PIXELFORMAT_FORCE_UINT32" 
} ;

local DISPLAYCONFIG_MODE_INFO_TYPE =
{
    [1] = "DISPLAYCONFIG_MODE_INFO_TYPE_SOURCE",
    [2] = "DISPLAYCONFIG_MODE_INFO_TYPE_TARGET",
    [3] = "DISPLAYCONFIG_MODE_INFO_TYPE_DESKTOP_IMAGE",
    [0xFFFFFFFF] = "DISPLAYCONFIG_MODE_INFO_TYPE_FORCE_UINT32" 
};

local function printModeInfo(mode)
    print("==== Mode Info ====")
    print("       ID: ", mode.id)
    if mode.infoType == ffi.C.DISPLAYCONFIG_MODE_INFO_TYPE_SOURCE then
        print("SOURCE")
        print("  width: ", mode.sourceMode.width);
        print("  height: ", mode.sourceMode.height);
        print("  format: ", DISPLAYCONFIG_PIXELFORMAT[tonumber(mode.sourceMode.pixelFormat)])
        print("  locate: ", mode.sourceMode.position.x, mode.sourceMode.position.y)
    elseif mode.infoType == ffi.C.DISPLAYCONFIG_MODE_INFO_TYPE_TARGET then
        local targetInfo = mode.targetMode.targetVideoSignalInfo;

        print("TARGET")
        print("  pixel rate: ", mode.targetMode.targetVideoSignalInfo.pixelRate)
        print("       hsync: ", mode.targetMode.targetVideoSignalInfo.hSyncFreq.Numerator, mode.targetMode.targetVideoSignalInfo.hSyncFreq.Denominator)
        print("       vsync: ", mode.targetMode.targetVideoSignalInfo.vSyncFreq.Numerator, mode.targetMode.targetVideoSignalInfo.vSyncFreq.Denominator, mode.targetMode.targetVideoSignalInfo.vSyncFreq.Numerator/ mode.targetMode.targetVideoSignalInfo.vSyncFreq.Denominator)
        print(" active size: ", targetInfo.activeSize.cx, targetInfo.activeSize.cy)
        print("  total size: ", targetInfo.totalSize.cx, targetInfo.totalSize.cy)
        print("    ordering: ", tonumber(mode.targetMode.targetVideoSignalInfo.scanLineOrdering))
        print("    standard: ", mode.targetMode.targetVideoSignalInfo.AdditionalSignalInfo.videoStandard)
        print("     divisor: ", mode.targetMode.targetVideoSignalInfo.AdditionalSignalInfo.vSyncFreqDivider)
    elseif mode.infoType == ffi.C.DISPLAYCONFIG_MODE_INFO_TYPE_DESKTOP_IMAGE then
        print("IMAGE")
    else
        print("Info Type: ", DISPLAYCONFIG_MODE_INFO_TYPE[tonumber(mode.infoType)])
    end
end

local function test_DisplayConfig()
    local flags = ffi.C.QDC_ALL_PATHS;
    --local flags = ffi.C.QDC_ONLY_ACTIVE_PATHS;
    --local flags = ffi.C.QDC_DATABASE_CURRENT;

    local pnumPathArrayElements = ffi.new("UINT32[1]")
    local pnumModeInfoArrayElements = ffi.new("UINT32[1]")
    local res = ffi.C.GetDisplayConfigBufferSizes(flags,pnumPathArrayElements,pnumModeInfoArrayElements);

    numPathArrayElements = tonumber(pnumPathArrayElements[0])
    numInfoArrayElements = tonumber(pnumModeInfoArrayElements[0])
    
    --print ("Buffer: ",winerror[tonumber(res)], numPathArrayElements, numInfoArrayElements)

    local pathArray = ffi.new("DISPLAYCONFIG_PATH_INFO[?]",numPathArrayElements)
    local modeInfoArray = ffi.new("DISPLAYCONFIG_MODE_INFO[?]", numInfoArrayElements)
    local currentTopologyId = nil;
    if flags == ffi.C.QDC_DATABASE_CURRENT then
        currentTopologyId = ffi.new("DISPLAYCONFIG_TOPOLOGY_ID[1]")
    end

    res = ffi.C.QueryDisplayConfig(
        flags, 
        pnumPathArrayElements, 
        pathArray, 
        pnumModeInfoArrayElements, 
        modeInfoArray, 
        currentTopologyId);


    print(" Query: ", winerror[tonumber(res)], pnumPathArrayElements[0], pnumModeInfoArrayElements[0])

    -- print modeInfo
    for idx=0, pnumModeInfoArrayElements[0]-1 do
        printModeInfo(modeInfoArray[idx])
    end

end

test_DisplayConfig()
--test_deviceinfo();


