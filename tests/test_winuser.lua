package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local wingdi = require("win32.wingdi")
local winuser = require("win32.winuser")
local winerror = require("win32.winerror")



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


