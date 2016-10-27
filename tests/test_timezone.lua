package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local tzone = require("win32.core.timezone_l1_1_0")
local strings = require("win32.core.string_l1_1_0")

--[[
    typedef struct _TIME_ZONE_INFORMATION {
    LONG Bias;
    WCHAR StandardName[ 32 ];
    SYSTEMTIME StandardDate;
    LONG StandardBias;
    WCHAR DaylightName[ 32 ];
    SYSTEMTIME DaylightDate;
    LONG DaylightBias;
} TIME_ZONE_INFORMATION, *PTIME_ZONE_INFORMATION, *LPTIME_ZONE_INFORMATION;

]]
local function getTimeZone()
    local tzoneinfo = ffi.new ("TIME_ZONE_INFORMATION")
    local res = tzone.GetTimeZoneInformation(tzoneinfo);

    if res == ffi.C.TIME_ZONE_ID_INVALID then
        return false -- getLastError
    end

    local tbl = {
        Bias = tzoneinfo.Bias;
        StandardBias = tzoneinfo.StandardBias;
        DaylightBias = tzoneinfo.DaylightBias;
    }

    tbl.StandardName = strings.toAnsi(tzoneinfo.StandardName);

    if res == ffi.C.TIME_ZONE_ID_DAYLIGHT then
        tbl.Name = strings.toAnsi(tzoneinfo.DaylightName);
    elseif res == ffi.C.TIME_ZONE_ID_STANDARD then
        tbl.Name = strings.toAnsi(tzoneinfo.StandardName);
    end

    return tbl
end

local tzinfo =  getTimeZone();
if not tzinfo then
    print("No TZ info")
    return ;
end

print("Standard Name: ", tzinfo.StandardName);
print("         Name: ", tzinfo.Name)

