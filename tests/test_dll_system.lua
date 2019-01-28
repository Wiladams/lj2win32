package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

require("win32.sdkddkver")
local system = require("ntdll_system")

print(system.getSystemInformation("SystemBasicInformation"))

print("sizeof(SYSTEM_PROCESS_INFORMATION): ", string.format("0x%x", ffi.sizeof("SYSTEM_PROCESS_INFORMATION")))