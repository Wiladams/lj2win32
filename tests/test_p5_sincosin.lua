package.path = "../?.lua;"..package.path;

require("p5")

local Checkerboard = require("checkerboard")


function setup()

    local cb1 = Checkerboard({
        width=width, 
        height=height,
        columns = 32,
        rows = 24,
        color1 = color(230),
        color2 = color(255)
    })

    --print("color: ", string.format("0x%08x", c.cref))
    local x = 0;
    local y = 0;

    cb1:draw();

    -- draw horizontal line
    stroke(0,255,255)
    strokeWeight(4)

    line(0,height/2, width,height/2)

    noStroke()

    -- Draw the actual function values
    for i=0, 2*PI, 0.01 do
        local svalue = sin(i)
        local cvalue = cos(i)
        local x = floor(map(i, 0, 2*PI, 10, width-10))
        local sy = floor(map(svalue, -1,1, 10,height-10))
        local cy = floor(map(cvalue, -1,1, 10,height-10))
        --print(x,y,value)

        fill(0xff, 0, 0)
        ellipse(x, sy, 4,4)

        fill(0, 0xff,0)
        ellipse(x, cy, 4,4)
    end

    noLoop()
end

go()
