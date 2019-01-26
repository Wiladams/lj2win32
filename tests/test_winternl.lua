package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

require("win32.sdkddkver")
local nt = require("win32.winternl")



-- base is
-- (b)2, (o)8, 10, (x)16
local function atoi(str, base)
    base = base or 10
    local pvalue = ffi.new("ULONG[1]")
    local success = nt.RtlCharToInteger(str, base, pvalue) == 0

    if not success then
        return nil
    end

    return pvalue[0]
end

local function testTS()
print("INTERNAL_TS_ACTIVE_CONSOLE_ID: ", INTERNAL_TS_ACTIVE_CONSOLE_ID)
end

local function testRandom()
local Seed = ffi.new("ULONG[1]",248)
local rnd = nt.RtlUniform (Seed);
print("RtlUniform: ", string.format("0x%x",rnd))
end


local function testConversions()

    print("0b1100 (12)", atoi("1100b", 2))
    print("106o    (70)", atoi("106o", 8))
    print("123", atoi("123", 10))
    print("32x   (50)", atoi("32x", 16))

end

testConversions()

