print("OSProcess - BEGIN")


local ffi = require("ffi")
local C = ffi.C 


--require("win32.winbase")
require("win32.psapi")
--print("PSAPI INCLUDED")
print(ffi.C.K32EnumProcessModulesEx)

require("win32.processthreadsapi")      -- Already in winbase
require("win32.handleapi")


--[[
    A couple of utilities
]]
local function stringdup(str)
    if not str or type(str) ~= "string" then
        return nil 
    end

	local newstr = ffi.new("char [?]", #str+1, str)
    return newstr
end

local function handleNumber(handle)
    return tonumber(ffi.cast("intptr_t", handle))
end




local OSProcess = {}
setmetatable(OSProcess, {
    __call = function(self, ...)
        return self:new(...)
    end;
})
local OSProcess_mt = {
    __index = OSProcess;
}

function OSProcess.init(self, obj)
    obj = obj or {
        ProcessId = C.GetCurrentProcessId(), 
        ProcessHandle = C.GetCurrentProcess()
    }

    setmetatable(obj, OSProcess_mt)

    return obj
end

function OSProcess.new(self, ...)
    local nargs = select('#', ...)

    if nargs == 0 then
        -- current process
        return self:init()
    end

    local params = select(1,...)
    if type(params) ~= "table" then
        return false, "no parameters specified"
    end

    -- Create a new process
    local lpApplicationName = params.ApplicationName;
    local lpCommandLine = stringdup(params.CommandLine);
    --print("command line:", lpCommandLine, ffi.string(lpCommandLine))
    local lpProcessAttributes = params.ProcessAttributes;
    local lpThreadAttributes = params.ThreadAttributes;
    local bInheritHandles = 1
    if params.InheritHandles ~= nil then
        if not params.InhericHandles then
            bInheritHandles = 0
        end
    end

    local dwCreationFlags = params.CreationFlags or C.NORMAL_PRIORITY_CLASS;
    local lpEnvironment = params.Environment;
    local lpCurrentDirectory = params.CurrentDirectory;
    local lpStartupInfo = params.StartupInfo;
    if not lpStartupInfo then
        lpStartupInfo = ffi.new("STARTUPINFOA")
        lpStartupInfo.cb = ffi.sizeof("STARTUPINFOA")
    end
    local lpProcessInformation = ffi.new("PROCESS_INFORMATION");

    local success = C.CreateProcessA(lpApplicationName,
     lpCommandLine,
     lpProcessAttributes,
     lpThreadAttributes,
     bInheritHandles,
     dwCreationFlags,
     lpEnvironment,
     lpCurrentDirectory,
     lpStartupInfo,
     lpProcessInformation) ~= 0;
    local err = C.GetLastError();

--print("SUCCESS: ", success, err)

    if not success then
        return false, C.GetLastError()
    end


    return self:init({
        ProcessHandle = lpProcessInformation.hProcess;
        ProcessId = lpProcessInformation.dwProcessId;
        ThreadHandle = lpProcessInformation.hThread;
        ThreadId = lpProcessInformation.dwThreadId;
    })
end



function OSProcess.terminate(self, exitCode)
    exitCode = exitCode or 0

    local success = C.TerminateProcess(self.ProcessHandle, exitCode) ~= 0;

    if not success then
        return false, C.GetLastError()
    end

    return true;
end

-- block the current thread waiting
-- for the process to complete
function OSProcess.wait(self, timeout)
    --print("OSProcess.wait(), BEGIN")
    timeout = timeout or C.INFINITE

    -- Wait for the process
    C.WaitForSingleObject(self.ProcessHandle, timeout);
    --print("OSProcess.wait(), END")
end

-- Reducing the working set to the bare
-- minimum needed
function OSProcess.emptyWorkingSet(self)
    local success = C.K32EmptyWorkingSet() ~= 0
    local err = C.GetLastError()

    return success, err
end

ffi.cdef[[
    DWORD
__stdcall
GetProcessImageFileNameA (
     HANDLE hProcess,
     LPSTR lpImageFileName,
     DWORD nSize
    );
]]

function OSProcess.getImageFileName(self)
    local nSize = C.MAX_PATH
    local lpImageFileName = ffi.new("char[?]", C.MAX_PATH)
    local result = C.K32GetProcessImageFileNameA (self.ProcessHandle, lpImageFileName, nSize);
    --local result = psapi.GetProcessImageFileNameA (self.ProcessHandle, lpImageFileName, nSize);
    local err = C.GetLastError()
    if result == 0  then
        return false, err;
    end

    return ffi.string(lpImageFileName, result)
end

function OSProcess.moduleNames(self)
    local function visitor()
        -- Get a list of all the modules in this process.
        local  hMods = ffi.new("HMODULE[1024]");
        local cbNeeded = ffi.new("DWORD[1]")
        local szModName = ffi.new("char[?]", ffi.C.MAX_PATH);

        if( ffi.C.K32EnumProcessModules(self.ProcessHandle, hMods, ffi.sizeof(hMods), cbNeeded) ~= 0) then
        --if( psapi.K32EnumProcessModules(self.ProcessHandle, hMods, ffi.sizeof(hMods), cbNeeded) ~= 0) then
            local nmodules = cbNeeded[0] / ffi.sizeof("HMODULE")
            for i = 0, nmodules-1 do
                -- Get the full path to the module's file.
                local success = ffi.C.K32GetModuleFileNameExA( self.ProcessHandle, hMods[i], szModName, ffi.sizeof(szModName) / ffi.sizeof("char")) ~= 0
                if success then
                    local str = ffi.string(szModName);
                    coroutine.yield(str)
                    --print(string.format("\t0x%8x\t%s", handleNumber(hMods[i]), ffi.string(szModName)))
                end
            end
        end
    end

    return coroutine.wrap(visitor)
end


return OSProcess