package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local sysmetrics = require("systemmetrics");


local function testAll()
for _, entry in ipairs(sysmetrics.names) do
    local value, err = sysmetrics.getSystemMetrics(entry.value)
    if value then
        if entry.converter then
            value = entry.converter(value);
        end
        print(string.format("{name = '%s', value = %s};", entry.name, tostring(value)))
    else
        print(entry.name, err)
    end
end
end

local function testSome()
    print(sysmetrics.SM_MAXIMUMTOUCHES)
    print(sysmetrics.getSystemMetrics(ffi.C.SM_MAXIMUMTOUCHES))
end

testAll();
testSome();
