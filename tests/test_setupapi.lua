package.path = "../?.lua;"..package.path;

require("win32.sdkddkver")

require("win32.minwindef")
local setupapi = require("win32.setupapi")