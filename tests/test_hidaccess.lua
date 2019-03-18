package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

require("win32.sdkddkver")


local HIDInterface = require("hidinterface")
local HIDDevice = require("HIDDevice")
local spairs = require("spairs")
local usbvendorlist = require("usbvendorlist")
local hidusagedb = require("hidusagedb")

local HIDinter = HIDInterface();


local function printDict(dict, name)
    name = name or "Dictionary"
    print("==", name, "==")
    for k,v in spairs(dict) do
        if k == "VendorID" then 
            k = "VENDOR" 
            v = usbvendorlist[v] or string.format("0x%x", v)
        elseif k == "Usage" then
            k = "USAGE"
            v = hidusagedb:lookupUsage(dict.UsagePage, v)
        elseif k == "UsagePage" then
            k = "USAGEPAGE"
            local page = hidusagedb[v]
            if page then
                v = page.name
            else
                v = string.format("0x%x",v)
            end
        end 

        print(string.format("%15s: %s", k,tostring(v)))
    end
    print("---------------------")
end

local function test_devicepaths()
for path in HIDinter:devicePaths() do
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
end

local function test_hiddb()
    -- generic
    local page = hidusagedb[0x01]

    local usage = page.usage[0x80]

    print(page.name, usage)
end

test_devicepaths()
--test_hiddb()

