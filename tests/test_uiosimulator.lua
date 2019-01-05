package.path = "../?.lua;"..package.path;

local ffi = require('ffi')


local uisim = require("uiosimulator")

--print("RECTL: ", ffi.typeof("RECTL"))

print("Size: ", uisim.ScreenWidth, uisim.ScreenHeight)

-- Move the mouse to the middle of the screen
uisim.MouseMove(uisim.ScreenWidth/2, uisim.ScreenHeight/2)


