package.path = "../?.lua;"..package.path;

require("p5")

local x = 0;

function setup()
    noLoop();
end

function draw()
    --print("Frame Count: ", frameCount)
    background(204);
    x = x + 1.0;
    if (x > width) then
        x = 0;
    end
    line(x, 0, x, height);
end

function mousePressed()
    loop();
end

function mouseReleased()
    noLoop();
end



go({frameRate=30, title="test_p5_loop_1"});