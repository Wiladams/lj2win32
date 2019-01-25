package.path = "../?.lua;"..package.path;

require("p5")

local function drawBlend(v1, v2, xLeft, wid, yTop, hgt, useCosine)
    local xRight = xLeft + wid;
    local oldx = xLeft;
    local oldy = yTop + (hgt+v1);
    for  x=xLeft, xRight-1 do
        local a = map(x, xLeft, xRight-1, 0, 1)
        if useCosine then
            a = map(cos(a*radians(180)), 1, -1, 0, 1)
        end
        local y = yTop + (hgt*lerp(v1,v2, a));
        line(oldx, oldy, x, y);
        oldx = x;
        oldy = y;
    end
end


local function drawSet(v1, v2, v3, useCosine, xLeft, yTop)
    drawBlend(v1, v1, xLeft,     100, yTop, 100, useCosine)
    drawBlend(v1, v2, xLeft+100, 100, yTop, 100, useCosine)
    drawBlend(v2, v2, xLeft+200, 100, yTop, 100, useCosine)
    drawBlend(v2, v3, xLeft+300, 100, yTop, 100, useCosine)
    drawBlend(v3, v3, xLeft+400, 100, yTop, 100, useCosine)
end

function setup()
    background(210)
    noFill();
    stroke(0);
    strokeWeight(2)
    smooth()
    local v1 = 0;
    local v2 = 0.5;
    local v3 = 1;
    drawSet(v1, v2, v3, false, 50, 50)
    drawSet(v1, v2, v3, true, 50, 250)
end



go({width=600, height = 400});