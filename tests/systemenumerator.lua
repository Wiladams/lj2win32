
local ffi = require("ffi")
local C = ffi.C
local bit = require("bit")

require("win32.tlhelp32")
require("win32.errhandlingapi")
require("win32.handleapi")

local exports = {}

function exports.processes()
    local function visitor()
        local dwFlags = C.TH32CS_SNAPPROCESS
        local th32ProcessID = 0
        local tlHandle = C.CreateToolhelp32Snapshot(dwFlags, th32ProcessID);

        if tlHandle == nil then 
            return nil, C.GetLastError()
        end

        -- make sure the handle is closed if we 
        -- go out of scope
        ffi.gc(tlHandle, C.CloseHandle)

        local lppe = ffi.new("PROCESSENTRY32")
        lppe.dwSize = ffi.sizeof("PROCESSENTRY32")
        local success = C.Process32First(tlHandle, lppe) ~= 0

        if not success then
            print("Process32First, FAILED: ", C.GetLastError())
            return nil
        end


        repeat
            local exename = ffi.string(lppe.szExeFile)
            coroutine.yield(lppe.th32ProcessID, exename)
        until C.Process32Next(tlHandle,lppe) == 0
    end

    return coroutine.wrap(visitor)
end



return exports
