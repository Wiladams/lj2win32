package.path = "../?.lua;"..package.path;
local ffi = require("ffi")
local C = ffi.C


require("win32.sdkddkver")
require("win32.minwindef")
require("win32.winsvc")

local SCMManager = require("SCMManager")

local serviceTypes = {
    [C.SERVICE_FILE_SYSTEM_DRIVER] = "SERVICE_FILE_SYSTEM_DRIVER";
    [C.SERVICE_KERNEL_DRIVER] = "SERVICE_KERNEL_DRIVER";
    [C.SERVICE_WIN32_OWN_PROCESS] = "SERVICE_WIN32_OWN_PROCESS";
    [C.SERVICE_WIN32_SHARE_PROCESS] = "SERVICE_WIN32_SHARE_PROCESS";
}


local function printServices(sch)
    print("== Services ==")
    for svc in sch:services() do
        print(string.format("{name = '%-30s',\tdisplay = '%s'};", 
            svc.name, svc.displayName))
        print("  ServiceType: ", serviceTypes[svc.serviceType])
    end
end

local sch = SCMManager:open();


if not sch then
    print("NO SCH")
    return ;
end

printServices(sch)

