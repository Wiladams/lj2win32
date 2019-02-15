package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

require("win32.sdkddkver")
local system = require("ntdll_system")

for key, value in pairs(system.SYSTEM_INFORMATION_CLASS) do
    --print(key, system.getSystemInformation(value))
    local value, err = system.getSystemInformation(value)
    if value then
        print(key, value)
    end
end

--print("sizeof(SYSTEM_PROCESS_INFORMATION): ", string.format("0x%x", ffi.sizeof("SYSTEM_PROCESS_INFORMATION")))