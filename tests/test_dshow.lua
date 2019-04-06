package.path = "../?.lua;"..package.path;

NO_DSHOW_STRSAFE = true

require("win32.sdkddkver")
--require("win32.minwindef")
require("win32.windef")

local dshow = require("win32.dshow")