package.path = "../?.lua;"..package.path;

--[[
    Trying out process redirection
]]
local ffi = require("ffi")
local C = ffi.C 

local bit = require("bit")
local bor, band = bit.bor, bit.band

require("win32.sdkddkver")
require("win32.windef")
require("win32.winbase")
require("win32.fileapi")

local sa = ffi.new("SECURITY_ATTRIBUTES");
sa.nLength = ffi.sizeof(sa);
sa.lpSecurityDescriptor = nil;
sa.bInheritHandle = 1;   

local h = C.CreateFileA("out.log",C.FILE_APPEND_DATA,bor(C.FILE_SHARE_WRITE, C.FILE_SHARE_READ),sa,C.OPEN_ALWAYS,C.FILE_ATTRIBUTE_NORMAL,nil );


-- Create a new process
local lpApplicationName = "cmd.exe";
local lpCommandLine = "dir";
    --print("command line:", lpCommandLine, ffi.string(lpCommandLine))
local lpProcessAttributes = nil;
local lpThreadAttributes = nil;
local bInheritHandles = 1
--[[
if params.InheritHandles ~= nil then
        if not params.InhericHandles then
            bInheritHandles = 0
        end
    end
--]]
local dwCreationFlags = bor(C.NORMAL_PRIORITY_CLASS, C.CREATE_NO_WINDOW);
local lpEnvironment = nil;
local lpCurrentDirectory = nil;

local si = ffi.new("STARTUPINFOA")
si.cb = ffi.sizeof("STARTUPINFOA")
si.dwFlags = C.STARTF_USESTDHANDLES;
si.hStdInput = nil;
si.hStdError = h;
si.hStdOutput = h;
    
local lpProcessInformation = ffi.new("PROCESS_INFORMATION");

local success = C.CreateProcessA(lpApplicationName,
     ffi.cast("char *", lpCommandLine),
     lpProcessAttributes,
     lpThreadAttributes,
     bInheritHandles,
     dwCreationFlags,
     lpEnvironment,
     lpCurrentDirectory,
     lpStartupInfo,
     lpProcessInformation) ~= 0;

     local err = C.GetLastError();

print("SUCCESS: ", success, err)
