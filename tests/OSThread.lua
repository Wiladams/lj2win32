--[[
-- From processthreadapi
-- Create the OSThread object
-- threadid
-- create
-- exit
-- suspend
-- result

-- GetThreadTimes
-- ThreadLocalStorage

-- GetThreadContext
GetThreadIdealProcessorEx
GetThreadInformation
SetThreadIdealProcessor
GetThreadDescription
--]]

local ffi = require("ffi")
local C = ffi.C 
local bit = require("bit")
local lshift, rshift = bit.lshift, bit.rshift
local band, bor = bit.band, bit.bor


require("win32.tlhelp")
require("win32.processthreadsapi")
require("win32.errhandlingapi")



local OSThread = {}
setmetatable(OSThread, {
    __call = function(self, ...)
        return self:new(...)
    end
})
local OSThread_mt = {
    __index = OSThread
}

local function OSThread.init(self, rawhandle)
    local obj = {
        ThreadHandle = rawhandle;
    }
    setmetatable(obj, OSThread_mt)

    return obj
end

local function OSThread.new(self, ...)
    return self:init(...)
end

--[[
    Current thread convenience
]]

--[[
    Thread instance methods
]]
function OSThread.suspend(self)
    local result = C.SuspendThread(self.Handle);
    return result
end

function OSThread.terminate(self, exitCode)
    exitCode = exitCode or 0
    local success = C.TerminateThread(self.Handle, exitCode) ~= 0

    return success
end

function OSThread.getExitCode(self)
    local lpExitCode = ffi.new("DWORD[1]")
    local success = C.GetExitCodeThread(self.Handle, lpExitCode) ~= 0

    if not success then 
        return false, C.GetLastError()
    end
    
    return lpExitCode[0]
end

function OSThread.setToken(self, token)
    local success = C.SetThreadToken(self.Handle, token) ~= 0
    return success
end


return OSThread
