package.path = "../?.lua;"..package.path;

require("win32.sdkddkver")
require("win32.windef")

_NO_COM = true

local ddraw = require("win32.ddraw")

local function doit(oneparam)
    print(oneparam)
end

doit "this"