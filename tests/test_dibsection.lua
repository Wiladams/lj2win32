package.path = "../?.lua;"..package.path;

local gApp = require("graphicapp")

local wingdi = require("win32.wingdi")


local function onMouseMove(event)
    print("MOUSE MOVE: ", event.x, event.y)
end




function setup()
    -- draw rectangle
    dc = surface.DC;
    yield();

    dc:UseDCPen(true);
    dc:UseDCBrush(true);

    dc:SetDCPenColor(RGB(0,0,255))
    dc:SetDCBrushColor(RGB(127,127,0))
    dc:Rectangle(100, 100, 400, 400);
    dc:flush();

    drawNow();
end


function loop()
    --print("LOOP")
    --drawNow();
end







gApp.go({width=1024, height=768, title="test_dibsection"});
