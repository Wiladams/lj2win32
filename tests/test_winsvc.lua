package.path = "../?.lua;"..package.path;
local ffi = require("ffi")
local C = ffi.C
local bit = require("bit")
local band = bit.band, bit.bor


require("win32.sdkddkver")
require("win32.minwindef")
require("win32.winsvc")

local SCMManager = require("SCMManager")
--require("funkit")()
require("fun")()


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

local function printServiceName(svc)
    print(string.format("{name = '%s', display = '%s'};", svc.name, svc.displayName))
end

local function printService(svc)
    print(string.format("{name = '%s', display = '%s', kind = '%s', state='%s'};", 
            svc.name, svc.displayName,
            serviceTypes[tonumber(svc.serviceType)] or string.format("0x%0x",svc.serviceType),
            serviceStates[svc.currentState] or string.format("0x%0x", svc.currentState)))
end

local function isFSDriver(svc)
    return band(svc.serviceType, C.SERVICE_FILE_SYSTEM_DRIVER) ~= 0
end

local function isKernelDriver(svc)
    return band(svc.serviceType == C.SERVICE_KERNEL_DRIVER) ~= 0
end

local function isRunning(svc)
    return svc.currentState == C.SERVICE_RUNNING
end

local sch = SCMManager:open();


if not sch then
    print("NO SCH")
    return ;
end

--each(printService, (filter(filter(sch:services(), isRunning), isKernelDriver)))

--each(printService, (filter(filter(sch:services(), isRunning), isFSDriver)))

each(printServiceName, sch:services())

--each(printServiceName, filter(isRunning, filter(isFSDriver, sch:services())))
