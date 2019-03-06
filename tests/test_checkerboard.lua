package.path = "../?.lua;"..package.path;

require("p5")

local Checkerboard = require("Checkerboard")

local ck1 = Checkerboard({
    color1 = color(0,0,0xff),
    color2 = color(0,0xff, 0)})

function setup()
    ck1:draw()
    noLoop()
end

go()