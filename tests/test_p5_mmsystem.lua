package.path = "../?.lua;"..package.path;

--[[
    references
    https://fourcc.org/
]]
local ffi = require("ffi")

require("p5")

require("win32.mmsyscom")
local bitbang = require("bitbang")
local BVALUE = bitbang.BITSVALUE
local B = string.byte

local function BYTEVAL(x, low, high)
    return tonumber(BVALUE(x, low, high))
end

local function CHAR(x, low, high)
    return tonumber(BVALUE(x, low, high))
end

function setup()
local fourc = MAKEFOURCC(B'R',B'I',B'F',B'F')

    print("fourc type: ", ffi.typeof(fourc))
    print(string.format("0x%x",tonumber(fourc)))
    local b0 = BYTEVAL(fourc, 0, 7)
    local b1 = BYTEVAL(fourc, 8, 15)
    local b2 = BYTEVAL(fourc, 16, 23)
    local b3 = BYTEVAL(fourc, 24, 31)

    local c0 = CHAR(fourc, 0, 7)
    local c1 = CHAR(fourc, 8, 15)
    local c2 = CHAR(fourc, 16, 23)
    local c3 = CHAR(fourc, 24, 31)

    print(string.format("BYTES: 0x%x  0x%x  0x%x  0x%x", b0, b1, b2, b3))
    print(string.format("CHARS: %c  %c  %c  %c", c0, c1, c2, c3))

    halt();
end

go()
