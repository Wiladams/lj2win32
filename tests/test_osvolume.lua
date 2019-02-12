package.path = "../?.lua;"..package.path;

require("win32.sdkddkver")
require("win32.winbase")

local VolumeManager = require("volumemanager")
local Volume = require("volume")

local function test_volumemanager()
for v in VolumeManager:volumeNames() do
    print(v)
    v:paths()
    --for _, path in Volume.paths(v) do
    --    print("PATH: ", path)
    --end
end
end

local function test_volume()
    local v = Volume("\\\\?\\Volume{315f9811-40a7-4f08-87f0-ac1a3756314d}\\")
    print("Volume: ", v)
    print(".paths: ", v.paths)
    v:paths()
end

--test_volume()
test_volumemanager()