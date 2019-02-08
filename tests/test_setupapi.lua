package.path = "../?.lua;"..package.path;

require("win32.sdkddkver")


require("win32.windef")
require("win32.winreg")
require("win32.wingdi")
require("win32.winuser")
local setupapi = require("win32.setupapi")