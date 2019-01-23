package.path = "../?.lua;"..package.path;

require("p5")

local r = 255
local g = 120
local b = 50

local function onMessage(msg)
print("onMessage")
end

function setup()
    --noLoop();
    --loop();
end

function draw()
    noStroke()
    background(r, g, b)

    stroke(0,0,0)
    ellipse(25,25,50,50)
end

function mouseReleased()
    --print("mouseReleased")
    r = random(0,255)
    g = random(0,255)
    b = random(0,255)
end


go();