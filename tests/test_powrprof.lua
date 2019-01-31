package.path = "../?.lua;"..package.path;

require("win32.sdkddkver")
require("win32.minwindef")
require("win32.winreg")

local powrprof = require("win32.powrprof")
