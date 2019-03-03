local ffi = require("ffi")
local bit = require("bit")
local lshift, rshift = bit.lshift, bit.rshift
local band, bor = bit.band, bit.bor

-- Store the matrix kinds so we don't create a new
-- type declaration for every pixel buffer
local matrix_kinds = {}
--[[
    Some words on fast pixel blending
http://stereopsis.com/doubleblend.html
--]]
if ffi.abi("le") then
-- assuming typical x86, which
-- can deal with byte aligned access efficiently
ffi.cdef[[
typedef struct Pixel32 {
    union {
        struct {
            uint8_t Red;
           uint8_t Green;
           uint8_t Blue;            
           uint8_t Alpha;
        };
        uint32_t cref;
    };
} Pixel32;
]]
--[=[
ffi.cdef[[
typedef struct Pixel32 {
    union {
        struct {
            uint8_t Blue;            
            uint8_t Green;
            uint8_t Red;
            uint8_t Alpha;
        };
        uint32_t cref;
    };
} Pixel32;
]]
--]=]
else
    -- assuming bigendian systems do better 
    -- with 32-bit, and bit-fields
ffi.cdef[[
    struct Pixel32 {
        union {
            struct {
                uint32_t Alpha: 8;
                uint32_t Red: 8;
                uint32_t Green: 8;
                uint32_t Blue: 8;
            };
            uint32_t cref;
        };
    } ;
]]
end


local PixelBuffer = {}
setmetatable(PixelBuffer, {
    __call = function (self, ...)
        return self:new(...)
    end
})
local PixelBuffer_mt = {
    __index = PixelBuffer
}

function PixelBuffer.init(self, params)

    local obj = params or {}
    params.Data = ffi.cast("uint8_t *", params.Pixels)
    setmetatable(obj, PixelBuffer_mt)

    return obj;
end

function PixelBuffer.new(self, width, height)
    -- lookup the type of we've already created it
    local typemoniker = string.format("Pixel32:[%d,%d]", height, width);
    local matrixType = matrix_kinds[typemoniker]
    if not matrixType then
        matrixType = ffi.typeof("struct Pixel32[$][$]", height, width)
        matrix_kinds[typemoniker] = matrixType
    end

    local pixels = matrixType()

    return self:init({
        Pixels = pixels, 
        Width=width, 
        Height=height, 
        BitsPerElement = 32,
        Kind="struct Pixel32"})
end

function PixelBuffer.RGB(self, r,g,b)
    return ffi.new("struct Pixel32", {r,g,b,0})
end

function PixelBuffer.RGBA(self, r,g,b,a)
    return  ffi.new("struct Pixel32",{r,g,b,a})
end


function PixelBuffer.set(self, x, y, pix)
    self.Pixels[y][x] = pix
    return self
end

function PixelBuffer.get(self, x, y)
    return self.Pixels[y][x]
end

local black = PixelBuffer:RGB(0,0,0,0)

--[[
    set the entire pixel buffer to the specified
    pixel value.

    This is a quick way to clear a buffer without 
    doing any sort of blending operations.
]]
function PixelBuffer.clear(self, pix)
    pix = pix or black
    local pixels = self.Pixels

    for y=0,self.Height-1 do
        for x=0,self.Width-1 do
            pixels[y][x] = pix
        end
    end
end

--[[
    copy one pixel buffer to another
    without any blending operation

    need to do clipping
]]
function PixelBuffer.srcOver(self, src, dstX, dstY)
    for y=0,src.Height-1 do
        for x=0,src.Width-1 do
            self.Pixels[dstY+y][dstX+x] = src.Pixels[y][x]
        end
    end
end

return PixelBuffer
