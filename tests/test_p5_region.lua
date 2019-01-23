package.path = "../?.lua;"..package.path;

require("p5")

local ffi = require("ffi")

local GdiRegion = require("GdiRegion")

local rgn1 = GdiRegion:CreateRectRgn(10, 10, 100, 100)
local rgn2 = GdiRegion:CreateRectRgn(20, 20, 110, 110)
local rgn3 = GdiRegion:CreateRectRgn(10, 10, 100, 100)

local verts = {
{200; 320};
{80; 160};
{80; 40};
{340; 40};
{520; 40};
{520; 160};
{400; 320};
}

local npts = #verts
local apts = ffi.new("POINT[?]", npts,verts)
local polyrgn = GdiRegion:CreatePolygonRgn(apts, npts)


function drawRegionRects(rgn)
    noFill();
    local cnt = 0;
    for arect in rgn:rects() do 
        if cnt % 4 == 0 then
        rect(arect.left, arect.top, arect.right, arect.bottom)
        end
        cnt = cnt + 1;
        --print(cnt)
    end
end

function setup()
    rectMode(CORNERS)
    background(222, 217, 177)
    stroke(0,0,0)
    noFill();
    --fill(131, 209, 119)

    drawRegionRects(polyrgn)
    --surface.DC:PaintRgn(polyrgn.Handle)
    --surface.DC:FrameRgn(polyrgn.Handle, brush, 1, 1)
end


go({width =600, height=400})