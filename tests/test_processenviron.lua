package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local environ = require("win32.processenv")
local strdelim = require("strdelim")




local function getEnvironment()
    local environs = ffi.C.GetEnvironmentStrings()
    print("environs: ", environs)
    if environs == nil then
        return false, "failed"
    end

    local res =  strdelim.multinullpairs(environs)
    ffi.C.FreeEnvironmentStringsA(environs)

    return res;
end

local function getCommandLine()
    local res = environ.GetCommandLineA();
    if res == nil then
        return false;
    end

    return ffi.string(res);
end

local function getCurrentDirectory()
    -- call once with zero length to get size
    local bufferLength = environ.GetCurrentDirectoryA(0,nil);

    -- call again with specified buffer length
    local lpBuffer = ffi.new('char[?]', bufferLength)
    local res = environ.GetCurrentDirectoryA(bufferLength,lpBuffer);

    if res > 0 then 
        return ffi.string(lpBuffer, res)
    end

    return false;
end


--print("     Command Line: ", getCommandLine());
--print("Working Directory: ", getCurrentDirectory());

--print(coroutine.running())

local function test_envvars()
    local vars = getEnvironment()
    for k,v in pairs(vars) do
        print(string.format("%32s  %s", k,v))
    end
end

test_envvars()

