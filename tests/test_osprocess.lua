package.path = "../?.lua;"..package.path;

local OSProcess = require("OSProcess")
local OSModule = require("OSModule")

local function test_myproc()
    local myProc = OSProcess()

    print("ID: ", myProc.ProcessId)
    print("Image: ", myProc:getImageFileName())
end

local function test_createproc()
    local newProc, err = OSProcess({
        --ApplicationName = "c:\\tools\\lua\\luajit.exe",
        CommandLine = "luajit hello.lua",
    })

    print("newProc: ", newProc, err)

    if not newProc then
        print("FAILED: ", err)
        return
    end

    newProc:wait();
end

local function test_osmodule()
    local k32 = OSModule("kernel32")
    local proc, err = k32.GetProcessImageFileNameA
    print("k32.GetProcessImageFileNameA, proc,err: ", proc, err)

    local proc, err = k32.K32GetProcessImageFileNameA
    print("k32.K32GetProcessImageFileNameA, proc,err: ", proc, err)

    local psapi = OSModule("psapi")
    local proc, err = psapi.GetProcessImageFileNameA
    print("psapi.GetProcessImageFileNameA, proc,err: ", proc, err)

    local proc, err = psapi.K32GetProcessImageFileNameA
    print("psapi.K32GetProcessImageFileNameA, proc,err: ", proc, err)

end

--test_myproc()
--test_createproc()
test_osmodule()
