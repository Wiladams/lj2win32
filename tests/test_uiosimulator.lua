package.path = "../?.lua;"..package.path;

local ffi = require('ffi')


local uisim = require("uiosimulator")

--print("RECTL: ", ffi.typeof("RECTL"))

print("Size: ", uisim.ScreenWidth, uisim.ScreenHeight)