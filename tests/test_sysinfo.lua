package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

require("sdkddkver")
local sysinfo = require("win32.sysinfoapi")

local function getComputerName()
    local nameSize = 255;
    local nameBuffer = ffi.new("char[?]", nameSize+1)
    local pnameSize = ffi.new("DWORD[1]",nameSize)
    local success = ffi.C.GetComputerNameExA (ffi.C.ComputerNamePhysicalDnsFullyQualified, nameBuffer, pnameSize);
    
    if success == 1 then
        return ffi.string(nameBuffer, pnameSize[0])
    end

    return false;

end

local function test_computername()
    print("Computer Name: ", getComputerName())
end

--[[
    typedef struct _SYSTEMTIME {
    WORD wYear;
    WORD wMonth;
    WORD wDayOfWeek;
    WORD wDay;
    WORD wHour;
    WORD wMinute;
    WORD wSecond;
    WORD wMilliseconds;
} SYSTEMTIME, *PSYSTEMTIME, *LPSYSTEMTIME;
]]
local weekdays = {
    [0] = "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat"
}
local function test_systime()
    ffi.metatype("SYSTEMTIME",{
        __tostring = function(self)
            return string.format("%d/%d/%d %d:%d:%d.%3d (%s)", 
                self.wDay, self.wMonth, self.wYear,
                self.wHour, self.wMinute, self.wSecond, self.wMilliseconds,
                weekdays[self.wDayOfWeek])
        end
    })

    -- get system time
    local aTime = ffi.new("SYSTEMTIME")
    ffi.C.GetSystemTime(aTime)

    -- print it out
    print("GMT: ", aTime)

    ffi.C.GetLocalTime(aTime)
    print("LOCAL: ", aTime)
end

local function test_systemDirectory()
    local uSize = ffi.C.MAX_PATH;
    local lpBuffer = ffi.new("char[?]", uSize)
    local res = ffi.C.GetSystemDirectoryA(lpBuffer,uSize);

    print(ffi.string(lpBuffer, res))
end

local function test_windowsDirectory()
    local uSize = ffi.C.MAX_PATH
    local lpBuffer = ffi.new("char[?]", uSize)
    local res = ffi.C.GetWindowsDirectoryA(
        lpBuffer,
        uSize);

    print("Windows: ", ffi.string(lpBuffer, res))
end


--test_computername();
test_systime();
test_systemDirectory()
test_windowsDirectory()