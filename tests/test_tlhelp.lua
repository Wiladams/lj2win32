package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C

require("win32.sdkddkver")

require("win32.tlhelp32")
require("win32.errhandlingapi")
require("win32.handleapi")

local dwFlags = C.TH32CS_SNAPPROCESS
local th32ProcessID = 0
local tlHandle = C.CreateToolhelp32Snapshot(dwFlags, th32ProcessID);

print("tlHandle: ", tlHandle)

if tlHandle == nil then 
    error(C.GetLastError())
end

ffi.gc(tlHandle, C.CloseHandle)

local function processes(tlHandle)
    local function visitor()
        local lppe = ffi.new("PROCESSENTRY32")
        lppe.dwSize = ffi.sizeof("PROCESSENTRY32")
        local success = C.Process32First(tlHandle, lppe) ~= 0

        if not success then
            print("Process32First, FAILED: ", C.GetLastError())
            return nil
        end

        local exename = ffi.string(lppe.szExeFile)
        coroutine.yield(lppe.th32ProcessID, exename)

        while C.Process32Next(tlHandle,lppe) ~= 0 do
            local exename = ffi.string(lppe.szExeFile)
            coroutine.yield(lppe.th32ProcessID, exename)    
        end
    end

    return coroutine.wrap(visitor)
end

for id, exename in processes(tlHandle) do
    print(id, exename)
end


C.CloseHandle(tlHandle)