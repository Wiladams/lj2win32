package.path = "../?.lua;"..package.path;

require("p5")

local ax = 200; ay = 320;
local bx = 80; by = 160;
local cx = 220; cy = 200;
local dx = 300; dy = 40;
local ex = 380; ey = 200;
local fx = 520; fy = 160;
local gx = 400; gy = 320;

function drawLeaf()
    beginShape(POLYGON);
--    beginShape(LINES);
    vertex(ax, ay);
    vertex(bx, by);
    vertex(cx, cy);
    vertex(dx, dy);
    vertex(ex, ey);
    vertex(fx, fy);
    vertex(gx, gy);
    --endShape(CLOSE);
    endShape(STROKE);
end

function setup()
    background(222, 217, 177)
    fill(131, 209, 119)
    strokeWeight(3)
    strokeJoin(ROUND)
    smooth();
    drawLeaf();
end



go({width =600, height=400})