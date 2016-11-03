package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local sysmetrics = require("systemmetrics");


local function testAll()
    for key, entry in pairs(sysmetrics.names) do
        local value, err = sysmetrics.getSystemMetrics(key)
        if value ~= nil then
            print(string.format("{name = '%s', value = %s};", key, value))
        else
            print(key, err)
        end
    end
end

local function testSome()
    print(sysmetrics.SM_MAXIMUMTOUCHES)
    print(sysmetrics.getSystemMetrics(ffi.C.SM_MAXIMUMTOUCHES))
end

local function testCdefgen()
    sysmetrics.genCdefs();
end

--testAll();
--testSome();
testCdefgen();
