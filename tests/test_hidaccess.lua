package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

require("win32.sdkddkver")


local HIDInterface = require("hidinterface")
local HIDDevice = require("HIDDevice")

local hider = HIDInterface();

for path in hider:devicePaths() do
    print("path: ", path)
    -- create a HIDDevice for each path
    local dev, err = HIDDevice(path)
    if dev then
        --print("Vendor: ", dev.VendorID)
        print(string.format("Vendor: 0x%x  Product: 0x%x  Version: %d", 
            dev.VendorID, dev.ProductID, dev.VersionNumber))
    else
        print(err)
    end
end

