package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

require("win32.sdkddkver")


local HIDInterface = require("hidinterface")


local hider = HIDInterface();

for path in hider:devicePaths() do
    print("path: ", path)
end

