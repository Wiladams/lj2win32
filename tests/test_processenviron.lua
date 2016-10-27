package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local environ = require("win32.core.processenvironment")

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

print("     Command Line: ", getCommandLine());
print("Working Directory: ", getCurrentDirectory());