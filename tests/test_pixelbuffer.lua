package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local PixelBuffer = require("PixelBuffer")
local targa = require("targa")


function lerp(low, high, x)
    return low + x*(high-low)
end

function map(x, olow, ohigh, rlow, rhigh)
    rlow = rlow or olow
    rhigh = rhigh or ohigh
    return rlow + (x-olow)*((rhigh-rlow)/(ohigh-olow))
end

--[[
    opacity table allows you to use lookups to determine
    an opacity value without doing multiplication.

    createOpacityTable() essentially pre-calculates the destination
    value given an opacity and value.

    The table is two dimensional (256x256)
    Each 'row' represents an opacity level (0-255)
    Each column' represents a source value (0 -255)
    The element represents the pre-multiplied value for the given
    opacity/value combination.

    Usage:
    local tab = createOpacityTable()

    -- perform alpha blending
    local alpha = 127
    function blend(pb, src, alpha)
        for y=0,src.Height-1 do
            for x=0,src.Width-1 do
                -- or something like it
                pb:set(x,y, tab[alpha][src:get(x,y).red])
            end
        end
    end
]]
local function createOpacityTable()
    local tab = ffi.new("uint8_t[256][256]")
    for opacity =0,255 do    
        for value=0,255 do
            local opvalue = map(value, 0,255, 0, opacity)
            tab[opacity][value] = opvalue
        end
    end
    return tab
end


local function printPixelBuffer(pb)
    for y =0, pb.Height-1 do
        for x = 0, pb.Width-1 do
            io.write(string.format('%8x ',pb.Pixels[y][x].cref))
        end
        print()
    end
end


local function hline(pb, x, y, len, pix)
    for i=0,len-1 do
        pb.Pixels[y][x+i] = pix
    end

    return true
end

local function vline(pb, x, y, len, pix)
    for i=0,len-1 do
        pb.Pixels[y+i][x] = pix
    end

    return true
end

local function fillRect(pb, x, y, width, height, pix)
    for i=0,height-1 do
        hline(pb, x, y+i, width, pix)
    end

    return true
end

local function frameRect(pb, x, y, width, height, pix)
    hline(pb, x,y,width,pix)
    hline(pb, x, y+height-1, width,pix)
    vline(pb, x, y, height,pix)
    vline(pb, x+width-1, y, height, pix)
end


local function test_srcover()
    local frameBuffer = PixelBuffer(20,10)
    local image = PixelBuffer(4,3)

    -- make framebuffer background white
    local bgPix = PixelBuffer:RGB(88,0,0)
    frameBuffer:clear(bgPix)

    -- give the image some pixels
    local c = PixelBuffer:RGB(2, 0,0)
    image:clear(c)

    -- copy image to framebuffer
    local black = PixelBuffer:RGB(0,0,0)
    frameBuffer:srcOver(image, 1,1)
    frameBuffer:srcOver(image, 3,3)
    frameBuffer:srcOver(image, 10,5)
    frameRect(frameBuffer, 9,4,5,4,black)

    printPixelBuffer(image)
    printPixelBuffer(frameBuffer)
end

local function test_Pixel32()
    local Pixel32 = ffi.typeof("Pixel32")
    local pix1 = Pixel32()
    print(string.format("cref: 0x%x", pix1.cref))

    pix1.Red = 0xff
    print(string.format("  Red: 0x%x", pix1.Red))

    pix1.Green = 0xCC
    print(string.format("Green: 0x%x", pix1.Green))
   
    pix1.Blue = 0xBB
    print(string.format(" Blue: 0x%x", pix1.Blue))

    print(string.format(" cref: 0x%08x", pix1.cref))

end

local function test_load()
    print("==== test_load ====")
    local img, err = targa.readFromFile("images\\rgb_UL.tga")
    print("loaded...", img, err)
    if not img then
        print(err.Error)
        return 
    end

    printPixelBuffer(img)
end


test_load()
--test_Pixel32()
--test_srcover()
--createOpacityTable()
