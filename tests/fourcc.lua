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
local bitbang = require("bitbang")
local BVALUE = bitbang.BITSVALUE


local BYTE = ffi.typeof("uint8_t")
local DWORD = ffi.typeof("uint32_t")
local B = string.byte 

function MAKEFOURCC(ch0, ch1, ch2, ch3)
    if type(ch0) == "string" then
        ch0=B(ch0)
        ch1=B(ch1)
        ch2=B(ch2)
        ch3=B(ch3)
    end

    return  DWORD(bor(BYTE(ch0) , lshift(BYTE(ch1) , 8) , lshift(BYTE(ch2) , 16) , lshift(BYTE(ch3) , 24 )))
end

return {
    MAKEFOURCC = MAKEFOURCC;
}