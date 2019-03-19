local ffi = require("ffi")
local fourcc = require("fourcc")
local bitbang = require("bitbang")
local BVALUE = bitbang.BITSVALUE

local MAKEFOURCC = fourcc.MAKEFOURCC

local function BYTEVALUE(x, low, high)
    return tonumber(BVALUE(x, low, high))
end

local function test_fourcc(a,b,c,d)
    local val = MAKEFOURCC(a,b,c,d)

    print("fourc type: ", ffi.typeof(val))
    print(string.format("0x%x",tonumber(val)))
    
    local b0 = BYTEVALUE(val, 0, 7)
    local b1 = BYTEVALUE(val, 8, 15)
    local b2 = BYTEVALUE(val, 16, 23)
    local b3 = BYTEVALUE(val, 24, 31)


    print(string.format("BYTES: 0x%x  0x%x  0x%x  0x%x", b0, b1, b2, b3))
    print(string.format("CHARS: %c  %c  %c  %c", b0, b1, b2, b3))
end

local fourc = test_fourcc('R','I','F','F')
