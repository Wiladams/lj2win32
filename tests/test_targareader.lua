package.path = "../?.lua;"..package.path;

require("win32.sdkddkver")

local targa = require("targa")

local ColorMapType = targa.ColorMapType;
local HorizontalOrientation = targa.HorizontalOrientation;
local VerticalOrientation = targa.VerticalOrientation;
local Interleave = targa.Interleave;
local ImageType = targa.ImageType;

--[[
    Utility Routines
]]
local function printDict(dict, label)
    if label then
        io.write('====')
        io.write(label)
        print("====")
    end

    if not dict then
        print("    NIL")
    end

    for k,v in pairs(dict) do
        print(string.format("%30s", k),v)
    end
end

local function printHeader(res)
    print("==== HEADER ====")

    print(string.format("%30s %d", "XOffset", res.XOffset))
    print(string.format("%30s %d", "YOffset", res.YOffset))
print()
    print(string.format("%30s %d", "Width", res.Width))
    print(string.format("%30s %d", "Height", res.Height))
    print(string.format("%30s %d", "Depth", res.PixelDepth))
    print(string.format("%30s %d", "BytesPerPixel", res.BytesPerPixel))
    print(string.format("%30s %s", "Type", ImageType[res.ImageType]))
print()
    print(string.format("%30s %s", "ColorMapType", ColorMapType[res.ColorMapType]))
    print(string.format("%30s %d", "CMapStart", res.CMapStart))
    print(string.format("%30s %d", "CMapLength", res.CMapLength))
    print(string.format("%30s %d", "CMapDepth", res.CMapDepth))
print()

    print(string.format("%30s %d", "AttrBits", res.AttrBits))
    print(string.format("%30s %s", "Horizontal", HorizontalOrientation[res.HorizontalOrientation]))
    print(string.format("%30s %s", "Vertical", VerticalOrientation[res.VerticalOrientation]))
    print(string.format("%30s %s", "Interleave", Interleave[res.AttrBits]))
end


--local pixbuff, header, footer = targa.readFromFile("images\\rgb_UL.tga")
--local pixbuff, header, footer = targa.readFromFile("images\\grayscale_UL.tga")
local pixbuff, header, footer = targa.readFromFile("images\\indexed_UL.tga")

if not pixbuff then
    print("readFromFile, ERROR: ", header.Error)
    return
end

--printDict(res.Footer, "FOOTER")
printHeader(header)
--print(res.PixelBuffer)