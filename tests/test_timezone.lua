package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C


require("win32.sdkddkver")

print("NTDDI_VERSION: ", NTDDI_VERSION)
print("NTDDI_WIN10_RS5: ", NTDDI_WIN10_RS5)

require("win32.timezoneapi")
local unicode = require("unicode_util")


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
    local res = C.GetTimeZoneInformation(tzoneinfo);

    if res == ffi.C.TIME_ZONE_ID_INVALID then
        return false -- getLastError
    end

    local tbl = {
        Bias = tzoneinfo.Bias;
        StandardBias = tzoneinfo.StandardBias;
        DaylightBias = tzoneinfo.DaylightBias;
    }

    tbl.StandardName = unicode.toAnsi(tzoneinfo.StandardName);

    if res == ffi.C.TIME_ZONE_ID_DAYLIGHT then
        tbl.Name = unicode.toAnsi(tzoneinfo.DaylightName);
    elseif res == ffi.C.TIME_ZONE_ID_STANDARD then
        tbl.Name = unicode.toAnsi(tzoneinfo.StandardName);
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

