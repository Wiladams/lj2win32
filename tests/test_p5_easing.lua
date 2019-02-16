package.path = "../?.lua;"..package.path;

require("p5")

local x = 1;
local y = 1;
local easing = 0.05;

function setup()
  --createCanvas(720, 400);
  fill(255)
  noStroke();
end

function draw()
if not mouseX then
    return
end
    background(237,34,93);
    local targetX = mouseX;
    local dx = targetX - x;
    x = x+dx * easing;

    local targetY = mouseY;
    local dy = targetY - y;
    y = y+dy * easing;

    ellipse(x,y,66,66);

end

go {width = 720, height=400}