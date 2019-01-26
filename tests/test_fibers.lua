package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

require("win32.sdkddkver")
require("win32.fibersapi")