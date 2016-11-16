package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local sysmetrics = require("systemmetrics");


local function testAll()
    for key, entry in pairs(sysmetrics.names) do
        local value, err = sysmetrics[key]
        if value ~= nil then
            print(string.format("{name = '%s', value = %s};", key, value))
        else
            print(key, err)
        end
    end
end

local function testSome()
    print(sysmetrics.SM_MAXIMUMTOUCHES)
end

local function testLookup()
    if not arg[1] then
        return false;
    end

    print (arg[1], string.format("0x%x", sysmetrics[arg[1] ]))
end

local function testCdefgen()
    sysmetrics.genCdefs();
    print("CDEF, SM_MAXIMUMTOUCHES: ", ffi.C.SM_MAXIMUMTOUCHES)
end

--testAll();
--testSome();
--testCdefgen();
testLookup();
