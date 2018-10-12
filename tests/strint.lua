-- turn a int string literal into a hex value
local ffi = require("ffi")


--[=[
ffi.cdef[[
// Values for bV5CSType
static const int PROFILE_LINKED     =     'LINK';
static const int PROFILE_EMBEDDED   =     'MBED';
]]
--]=]

local function convert(str)
    local arr = ffi.cast("const char *", str)
    io.write(str,"  ")
    for i=#str,1,-1 do
        io.write(string.format("%02X",arr[i-1]))
    end
    print();
end

convert('PSOC')
convert('sRGB')
convert('Win ')
convert('LINK')
convert('MBED')