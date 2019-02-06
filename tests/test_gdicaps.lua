package.path = "../?.lua;"..package.path;

--[[
    Test the basic functions of a GDI Device Context
]]
local ffi = require("ffi")
local C = ffi.C 

local DC = require("DeviceContext")
local screenDC = DC();



local deviceTechnologies = {
    [1] = "DT_PLOTTER",
    "DT_RASDISPLAY",
    "DT_RASPRINTER",
    "DT_RASCAMERA",
    "DT_CHARSTREAM",
    "DT_METAFILE",
    "DT_DISPFILE"
}

local caps = {
    "DRIVERVERSION",
    "TECHNOLOGY",
    "HORZSIZE",
    "VERTSIZE",
    "HORZRES",
    "VERTRES",
    "BITSPIXEL",
    "PLANES",
    "NUMBRUSHES",
    "NUMPENS",
    "NUMMARKERS",
    "NUMFONTS",
    "NUMCOLORS",
    "PDEVICESIZE",
    "CURVECAPS",
    "LINECAPS",
    "POLYGONALCAPS",
    "TEXTCAPS",
    "CLIPCAPS",
    "RASTERCAPS",
    "ASPECTX",
    "ASPECTY",
    "ASPECTXY",
    "LOGPIXELSX",
    "LOGPIXELSY",
    "SIZEPALETTE",
    "NUMRESERVED",
    "COLORRES",
    "PHYSICALWIDTH",
    "PHYSICALHEIGHT",
    "PHYSICALOFFSETX",
    "PHYSICALOFFSETY",
    "SCALINGFACTORX",
    "SCALINGFACTORY",
    "VREFRESH",
    "DESKTOPVERTRES",
    "DESKTOPHORZRES",
    "BLTALIGNMENT",
    "SHADEBLENDCAPS",
    "COLORMGMTCAPS",
}

local function test_caps()
for _, cap in ipairs(caps) do
    local value = screenDC:capability(C[cap])
    print(string.format("%s: %d (0x%x)", cap, value, value))
end
end

local function test_technology()
    local value = screenDC:capability(C["TECHNOLOGY"])
    print("Technology: ", value, deviceTechnologies[value])
end


test_caps()
--test_technology()

