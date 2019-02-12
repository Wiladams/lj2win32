package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 
local bit = require("bit")
local band, bor = bit.band, bit.bor

require("win32.sdkddkver")
require("win32.winbase")

local VolumeManager = require("volumemanager")
local Volume = require("volume")

local function test_volumemanager()
for v in VolumeManager:volumeNames() do
    print("VOLUME: ", v)
    print("PATHS: ")
    v:paths()
    --for _, path in Volume.paths(v) do
    --    print("PATH: ", path)
    --end
    print("MOUNTS:")
    for mp in v:mountPoints() do
        print(mp)
    end
end
end

-- enumerate the drive letters currently
-- used within the system
local function usedDrives()
    local function enumerator()
        local T_A = string.byte('A')
        local mask = C.GetLogicalDrives();
        for i=0,25 do
            if band(math.pow(2,i), mask) ~= 0 then
                coroutine.yield(string.char(T_A+i))
            end
        end
    end 

    return coroutine.wrap(enumerator)
end

-- enumerate the drive letters currently
-- unused by the system
local function availableDrives()
    local function enumerator()
        local T_A = string.byte('A')
        local mask = C.GetLogicalDrives();
        for i=0,25 do
            if band(math.pow(2,i), mask) == 0 then
                coroutine.yield(string.char(T_A+i))
            end
        end
    end 

    return coroutine.wrap(enumerator)
end

local function test_availableDrives()
    print("USED DRIVES")
    for drive in usedDrives() do
        print(string.format("%s:", drive))
    end

    print("AVAILABLE DRIVES")
    for drive in availableDrives() do
        print(string.format("%s:", drive))
    end
end

test_availableDrives()
--test_volumemanager()

