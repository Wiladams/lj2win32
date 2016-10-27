package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local sysinfo = require("win32.core.sysinfo_l1_2_0")

local function getComputerName()
    local nameSize = 255;
    local nameBuffer = ffi.new("char[?]", nameSize+1)
    local pnameSize = ffi.new("DWORD[1]",nameSize)
    local success = sysinfo.GetComputerNameExA (ffi.C.ComputerNamePhysicalDnsFullyQualified, nameBuffer, pnameSize);
    
    if success == 1 then
        return ffi.string(nameBuffer, pnameSize[0])
    end

    return false;

end

print("Computer Name: ", getComputerName())