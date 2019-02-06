package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

local sysinfo = require("win32.sysinfoapi")


local function test_systeminfo()
    local pInfo = ffi.new("SYSTEM_INFO")
    C.GetSystemInfo(pInfo);

    --print("Processor Arch: ", string.format("0x%x", pInfo.wProcessorArchitecture))
    print("Page Size: ", string.format("0x%x", pInfo.dwPageSize))
    print("Alloc Granularity: ", string.format("0x%x (%d)", pInfo.dwAllocationGranularity, pInfo.dwAllocationGranularity))
    print("Num Procs: ", string.format("0x%x", pInfo.dwNumberOfProcessors))
    print("Proc Type: ", string.format("0x%x (%d)", pInfo.dwProcessorType, pInfo.dwProcessorType))
    print("Proc Level: ", string.format("0x%x", pInfo.wProcessorLevel))
    print("Proc Revis: ", string.format("0x%x", pInfo.wProcessorRevision))
    print("Alloc Granularity: ", string.format("0x%x", pInfo.dwAllocationGranularity))

end

--[[
    typedef struct _MEMORYSTATUSEX {
    DWORD dwLength;
    DWORD dwMemoryLoad;
    DWORDLONG ullTotalPhys;
    DWORDLONG ullAvailPhys;
    DWORDLONG ullTotalPageFile;
    DWORDLONG ullAvailPageFile;
    DWORDLONG ullTotalVirtual;
    DWORDLONG ullAvailVirtual;
    DWORDLONG ullAvailExtendedVirtual;
} MEMORYSTATUSEX, *LPMEMORYSTATUSEX;
]]
local function test_memorystatus()
    print("== test_memorystatus ==")
    local lpBuffer = ffi.new("MEMORYSTATUSEX")
    lpBuffer.dwLength = ffi.sizeof("MEMORYSTATUSEX")
    local success = C.GlobalMemoryStatusEx(lpBuffer) ~= 0;

    if not success then
        return 
    end

    print("{")
    print(string.format("   MemoryLoad = %d;", lpBuffer.dwMemoryLoad))
    print(string.format("    TotalPhys = 0x%x;", tonumber(lpBuffer.ullTotalPhys)))
    print(string.format("    AvailPhys = 0x%x;", tonumber(lpBuffer.ullAvailPhys)))
    print(string.format("TotalPageFile = 0x%x;", tonumber(lpBuffer.ullTotalPageFile)))
    print(string.format("AvailPageFile = 0x%x;", tonumber(lpBuffer.ullAvailPageFile)))
    print(string.format(" TotalVirtual = 0x%x;", tonumber(lpBuffer.ullTotalVirtual)))
    print(string.format(" AvailVirtual = 0x%x;", tonumber(lpBuffer.ullAvailVirtual)))
    print(string.format("AvailExtendedVirtual = 0x%x;", tonumber(lpBuffer.ullAvailExtendedVirtual)))
    print("};")
end

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

local function test_productinfo()
    print("== test_productinfo ==")

    local returnInfo = ffi.new("DWORD[1]")
    dwOSMajorVersion = 0
    dwOSMinorVersion = 0
    dwSpMajorVersion = 0
    dwSpMinorVersion = 0

    local success = C.GetProductInfo(dwOSMajorVersion,dwOSMinorVersion, dwSpMajorVersion, dwSpMinorVersion,returnInfo) ~= 0

    if not success then
        print("ERROR")
        return 
    end

    print("Product Info: ", string.format("0x%x", returnInfo[0]))
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


--test_systeminfo()
--test_computername();
--test_memorystatus();
test_productinfo()
--test_systime();
--test_systemDirectory()
--test_windowsDirectory()