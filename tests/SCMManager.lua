local ffi = require("ffi")
local C = ffi.C 
local bit = require("bit")
local band, bor = bit.band, bit.bor

local winsvc = require("win32.winsvc")
require("win32.errhandlingapi")
require("win32.winerror")

local SCMManager = {}
ffi.cdef[[
typedef struct ServiceControlHandle_t
{
    SC_HANDLE   Handle;
} ServiceControlHandle;
]]
local ServiceControlHandle = ffi.typeof("ServiceControlHandle")


local ServiceControlHandle_mt = {
    __index = SCMManager;

    __new = function(ct, rawhandle)
        return ffi.new(ct, rawhandle)
    end;

    __gc = function(self)
        local success = winsvc.CloseServiceHandle(self.Handle);
        --print("ServiceControlHandle.__gc")
    end;
}
ffi.metatype("ServiceControlHandle", ServiceControlHandle_mt)


function SCMManager.open(self, machineName, databaseName, desiredAccess)
    desiredAccess = desiredAccess or bor(C.SC_MANAGER_CONNECT, C.SC_MANAGER_ENUMERATE_SERVICE)

    local rawhandle = winsvc.OpenSCManagerA(machineName, databaseName, desiredAccess)
    return ServiceControlHandle(rawhandle);
end

-- iterate over the services
function SCMManager.services(self)
    --print("SCMManager.services, 1.0: ", self.Handle)

    local function visitor()
        local serviceType = C.SERVICE_TYPE_ALL;
        local serviceState = C.SERVICE_STATE_ALL;
        local lpServices = nil;
        local cbBufSize = 0;
        local pcbBytesNeeded = ffi.new("DWORD[1]");
        local lpServicesReturned = ffi.new("DWORD[1]");
        local lpResumeHandle = ffi.new("DWORD[1]",0);
        local pszGroupName = nil;

        -- Call first time to figure out how much memory to
        -- allocate to receive data

        local success = winsvc.EnumServicesStatusExA(
            self.Handle,
            C.SC_ENUM_PROCESS_INFO,
            serviceType,
            serviceState,
            lpServices,
            cbBufSize,
            pcbBytesNeeded,
            lpServicesReturned,
            lpResumeHandle,
            pszGroupName) ~= 0;
        
        --print("SCMManager.services.visitor, 2.0: ", success)

        if not success then
            local err = C.GetLastError()
            --print("FAILED 1: ", err)
            if err ~= C.ERROR_MORE_DATA then
                --print("1 RETURNING")
                return nil;
            end
        end
        
        cbBufSize = pcbBytesNeeded[0]
        lpServices = ffi.new("uint8_t[?]", cbBufSize)
        lpResumeHandle[0] = 0
--print("cbBufSize: ", cbBufSize)

        local success = winsvc.EnumServicesStatusExA(
            self.Handle,
            C.SC_ENUM_PROCESS_INFO,
            serviceType,
            serviceState,
            lpServices,
            cbBufSize,
            pcbBytesNeeded,
            lpServicesReturned,
            lpResumeHandle,
            pszGroupName) ~= 0;
        
        if not success then
            local err = C.GetLastError()
            --print("FAILED 2: ", err)
            if err ~= C.ERROR_MORE_DATA then
                return nil;
            end
        end

        -- Now we have list of services, do a loop
        -- to return one for each iteration
        local nServices = lpServicesReturned[0]
        for i=0,nServices - 1 do
            local svc = ffi.cast("ENUM_SERVICE_STATUS_PROCESSA *", lpServices)[i]
            local value = {
                name = ffi.string(svc.lpServiceName),
                displayName = ffi.string(svc.lpDisplayName),
                serviceType = svc.ServiceStatusProcess.dwServiceType,
                currentState = svc.ServiceStatusProcess.dwCurrentState,
                controlsAccepted = svc.ServiceStatusProcess.dwControlsAccepted,
                win32ExitCode = svc.ServiceStatusProcess.dwWin32ExitCode,
                serviceExitCode = svc.ServiceStatusProcess.dwServiceSpecificExitCode,
                checkPoint = svc.ServiceStatusProcess.dwCheckPoint,
                waitHint = svc.ServiceStatusProcess.dwWaitHint,
                processId = svc.ServiceStatusProcess.dwProcessId,
                serviceFlags = svc.ServiceStatusProcess.dwServiceFlags
            }
            coroutine.yield(value)
        end
    end

    local co = coroutine.create(visitor)

    return function()
        local status, value = coroutine.resume(co)
        if not status then
            return nil;
        end

        return value;
    end

end

return SCMManager
