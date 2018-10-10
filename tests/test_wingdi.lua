package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local gdi = require("win32.wingdi")
local winuser = require("win32.winuser")
local winerror = require("win32.winerror")

local function test_DisplayConfig()
    --local flags = ffi.C.QDC_ALL_PATHS;
    local flags = ffi.C.QDC_ONLY_ACTIVE_PATHS;

    local pnumPathArrayElements = ffi.new("UINT32[1]")
    local pnumModeInfoArrayElements = ffi.new("UINT32[1]")
    local res = ffi.C.GetDisplayConfigBufferSizes(flags,pnumPathArrayElements,pnumModeInfoArrayElements);

    numPathArrayElements = tonumber(pnumPathArrayElements[0])
    numInfoArrayElements = tonumber(pnumModeInfoArrayElements[0])
    
    print ("Buffer: ",winerror[tonumber(res)], numPathArrayElements, numInfoArrayElements)

    local pathArray = ffi.new("DISPLAYCONFIG_PATH_INFO[?]",numPathArrayElements)
    local modeInfoArray = ffi.new("DISPLAYCONFIG_MODE_INFO[?]", numInfoArrayElements)
    --local currentTopologyId = ffi.new("DISPLAYCONFIG_TOPOLOGY_ID[1]")
    local currentTopologyId = nil;

    res = ffi.C.QueryDisplayConfig(
        flags, 
        pnumPathArrayElements, 
        pathArray, 
        pnumModeInfoArrayElements, 
        modeInfoArray, 
        currentTopologyId);


    print(" Query: ", winerror[tonumber(res)], pnumPathArrayElements[0], pnumModeInfoArrayElements[0])
end

test_DisplayConfig()
