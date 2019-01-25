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

local serviceStates = {
    [C.SERVICE_CONTINUE_PENDING] = "SERVICE_CONTINUE_PENDING";
    [C.SERVICE_PAUSE_PENDING] = "SERVICE_PAUSE_PENDING";
    [C.SERVICE_PAUSED] = "SERVICE_PAUSED";
    [C.SERVICE_RUNNING] = "SERVICE_RUNNING";
    [C.SERVICE_START_PENDING] = "SERVICE_START_PENDING";
    [C.SERVICE_STOP_PENDING] = "SERVICE_STOP_PENDING";
    [C.SERVICE_STOPPED] = "SERVICE_STOPPED";

}

local function printServices(sch)
    print("== Services ==")
    for svc in sch:services() do
        print(string.format("{name = '%s', display = '%s', kind = '%s', state='%s'};", 
            svc.name, svc.displayName,
            serviceTypes[tonumber(svc.serviceType)] or string.format("0x%0x",svc.serviceType),
            serviceStates[svc.currentState] or string.format("0x%0x", svc.currentState)
        ))
        --print("  ServiceType: ", serviceTypes[tonumber(svc.serviceType)] or string.format("0x%0x",svc.serviceType))
        --print(" ServiceState: ", serviceStates[svc.currentState] or string.format("0x%0x", svc.currentState))
    end
end

local sch = SCMManager:open();


if not sch then
    print("NO SCH")
    return ;
end

printServices(sch)

