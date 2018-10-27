package.path = "../?.lua;"..package.path;

local graphicApp = require("graphicapp")

local wingdi = require("win32.wingdi")




function onMouseMove(event)
    print("MOVE: ", event.x, event.y)
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
end










graphicApp.run();