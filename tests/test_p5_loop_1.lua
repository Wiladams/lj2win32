package.path = "../?.lua;"..package.path;

require("p5")

local x = 0;

function setup()
    createCanvas(100, 100);
    noLoop();
end

function draw()
    --print("Frame Count: ", frameCount)
    background(204);
    x = x + 0.5;
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



go({title="test_p5_loop_1"});