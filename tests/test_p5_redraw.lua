package.path = "../?.lua;"..package.path;

require("p5")

local x = 0;

function setup()
   createCanvas(100, 100);
   noLoop();
end

function draw()
   background(204);
   line(x, 0, x, height);
end

function mousePressed()
    x = x + 1;
    redraw();
end


go()