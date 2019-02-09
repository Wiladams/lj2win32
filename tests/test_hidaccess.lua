package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

require("win32.sdkddkver")


local HIDInterface = require("hidinterface")
local HIDDevice = require("HIDDevice")

local hider = HIDInterface();


local function printDict(dict, name)
    name = name or "Dictionary"
    print("==", name, "==")
    for k,v in pairs(dict) do
        print(string.format("%15s: %s", k,tostring(v)))
    end
    print("---------------------")
end

for path in hider:devicePaths() do
    --print("path: ", path)
    -- create a HIDDevice for each path
    local dev, err = HIDDevice(path)
    if dev then
        --print("Vendor: ", dev.VendorID)
        printDict(dev)
        --print(string.format("Vendor: 0x%x  Product: 0x%x  Version: %d", 
        --    dev.VendorID, dev.ProductID, dev.VersionNumber))
    else
        print("ERROR: ", err, path)
    end
end

