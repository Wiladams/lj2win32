package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

require("win32.sdkddkver")


local hidclass = require("hidaccess")


local hider = hidclass();

for path in hider:devicePaths() do
    print("path: ", path)
end

