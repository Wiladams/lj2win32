local ffi = require("ffi")

--[[
local function Array2D(columns, rows)
    local arrtype = ffi.typeof("int[$][$]", rows, columns)
    return arrtype()    -- initialized with all 0
end
--]]

local Array2D = ffi.typeof("uint32_t[$][$]")

local PixelBuffer = {}
local PixelBuffer_mt = {

}

function PixelBuffer.init(self, pixels)
    local arrtype = ffi.typeof("uint32_t[$][$]", rows, columns)
    local obj = {
        pixels = 
    }
local p1 = Array2D(480, 640)
