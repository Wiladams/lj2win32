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
    print(sysmetrics.SM_MOUSEHORIZONTALWHEELPRESENT)
    print(sysmetrics.SM_TABLETPC);
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

local function testScreen()
    print(string.format("Monitors: %d", sysmetrics.SM_CMONITORS))
    print(string.format("Virtual Display"));
    print(string.format("    Size: %dx%d", sysmetrics.SM_CXVIRTUALSCREEN, sysmetrics.SM_CYVIRTUALSCREEN))
    print(string.format("  Origin: %dx%d", sysmetrics.SM_XVIRTUALSCREEN, sysmetrics.SM_YVIRTUALSCREEN))
    print(string.format("Primary Display"));
    print(string.format("    Size: %dx%d", sysmetrics.SM_CXSCREEN, sysmetrics.SM_CYSCREEN))

    -- Mouse
    if sysmetrics.SM_MOUSEPRESENT then
        print();

        print("   Mouse: ", sysmetrics.SM_MOUSEPRESENT)
        print(string.format(" Buttons: %d", sysmetrics.SM_CMOUSEBUTTONS))
    end
end

--testAll();
--testSome();
--testCdefgen();
--testLookup();
testScreen();

