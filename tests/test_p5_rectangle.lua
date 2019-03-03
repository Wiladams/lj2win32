package.path = "../?.lua;"..package.path;

require("p5")
local Rectangle = require("Rectangle")

local baseRect = Rectangle(200, 200, 800, 600)

local function drawRectangle(r)
    if not r then
        return 
    end

    rect(r:x(), r:y(), r:width(), r:height())
end


local overlaps = {
    -- each corner
    Rectangle(100,100, 300, 300),
    Rectangle(100,600, 300, 300),
    Rectangle(800,100,300,300),
    Rectangle(800,600,300,300),

    -- in the middle
    Rectangle(450,350, 300,300),

    -- outside
    Rectangle(450,10, 150,150),

}


local function drawIntersectors()
    for _, overlap in ipairs(overlaps) do 
        fill(0,0,255)
        drawRectangle(overlap)

        local inter = baseRect:intersection(overlap)
        fill(255, 0,0)
        drawRectangle(inter)
    end 
end

function setup()
    rectMode(CORNER)
    noStroke()

    fill(0,255,0)
    drawRectangle(baseRect)

    drawIntersectors()

    noLoop()
end

go({width = 1200, height=1000})