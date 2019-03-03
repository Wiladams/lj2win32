package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
require("p5")
require("PixelBuffer")

--[[
obj.pixelData = {
    data = pixelP[0];
    size = info.bmiHeader.biSizeImage;
}
--]]

local function setPixel(x,y,pix)
    local pixelPtr = ffi.cast("struct Pixel32 *", surface.pixelData.data)
    pixelPtr[y*width+x] = pix
end

function setup()
    local pix = ffi.new("struct Pixel32")
    pix.Red = 0xff
    for i=1,100 do
        setPixel(i,i,pix)
    end

    noLoop()
end


go()