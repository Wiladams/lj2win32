--[[
    This file encapsulates some fourcc routines
    and well known constants.  In windows, the mmsyscom file
    contains these routines, but perhaps they're useful on their
    own without having to drag in the entirety of what's needed
    to support that.
]]
local ffi = require("ffi")
local bit = require("bit")
local lshift, rshift = bit.lshift, bit.rshift
local bor, band = bit.bor, bit.band
local bswap = bit.bswap

local bitbang = require("bitbang")
local BVALUE = bitbang.BITSVALUE


local BYTE = ffi.typeof("uint8_t")
local WORD = ffi.typeof("uint16_t")
local DWORD = ffi.typeof("uint32_t")
local B = string.byte 

local function BYTEVALUE(x, low, high)
    return tonumber(BVALUE(x, low, high))
end


local function MAKEFOURCC(ch0, ch1, ch2, ch3)
    if type(ch0) == "string" then
        ch0=B(ch0)
        ch1=B(ch1)
        ch2=B(ch2)
        ch3=B(ch3)
    end

    return  DWORD(bor(BYTE(ch0) , lshift(BYTE(ch1) , 8) , lshift(BYTE(ch2) , 16) , lshift(BYTE(ch3) , 24 )))
end

local function MAKETWOCC(ch0, ch1) 
    if type(ch0) == "string" then
        ch0=B(ch0)
        ch1=B(ch1)
    end

    return WORD(bor(BYTE(ch0) , lshift(BYTE(ch1) , 8)))
end

local function fourccToString(val)
    -- BUGBUG

    local arr = ffi.new("uint8_t[4]",
        BYTEVALUE(val, 0, 7), 
        BYTEVALUE(val, 8, 15),
        BYTEVALUE(val, 16, 23),
        BYTEVALUE(val, 24, 31)
    )
    return ffi.string(arr,4)

--[[
    -- clunky method
    local b0 = string.char(BYTEVALUE(val, 0, 7))
    local b1 = string.char(BYTEVALUE(val, 8, 15))
    local b2 = string.char(BYTEVALUE(val, 16, 23))
    local b3 = string.char(BYTEVALUE(val, 24, 31))

    local strTbl = {}
    table.insert(strTbl, b0)
    table.insert(strTbl, b1)
    table.insert(strTbl, b2)
    table.insert(strTbl, b3)

    return table.concat(strTbl)
--]]
end

local function stringToFourcc(str)
    if #str ~= 4 then return false, 'string length must be 4' end

    local arr = ffi.cast("const char *", str)
    return MAKEFOURCC(arr[0], arr[1], arr[2], arr[3])
end


return {
    MAKEFOURCC = MAKEFOURCC;
    MAKETWOCC = MAKETWOCC;

    fourccToString = fourccToString;
    stringToFourcc = stringToFourcc;
}