package.path = "../?.lua;"..package.path;

local graphicApp = require("graphicapp")
local gdi = require("win32.wingdi")
local random = math.random;


--[[
function onMouseActivity(event)
    print("MOUSE: ", event.activity, event.x, event.y, event.lbutton, event.mbutton, event.rbutton, event.xbutton1, event.xbutton2)
end
--]]

--[[
local function onMouseMove(event)
    print("MOUSE MOVE: ", event.x, event.y)
end

local function onMouseUp(event)
    print("MOUSE UP: ", event.x, event.y, event.lbutton, event.mbutton, event.rbutton)
end
--]]

function onMouseDown(event)
    --print("MOUSE DOWN: ", event.x, event.y, event.lbutton, event.mbutton, event.rbutton)

    local dc = ClientDC;

    local color = gdi.RGB(random(0,255), random(0,255),random(0,255))
    dc:UseDCPen(true);
    dc:SetDCPenColor(color);
    dc:RoundRect(event.x-5, event.y-5, event.x+5, event.y+5, 3, 3);
    dc:flush();
end



local function drawEllipse(win)
    local dc = ClientDC;
    dc:UseDCPen(true);
    dc:SetDCPenColor(gdi.RGB(0,0,255))
    dc:Rectangle(win.left, win.top, win.left+win.width-1, win.top+win.height-1);

    local minwidth = 40;
    local minheight = 40;

    while true do
        for i=1,1 do
            local x = random(win.left, win.left+win.width-1-minwidth)
            local y = random(win.top, win.top+win.height-1-minheight)

            dc:Ellipse(x,y, x+minwidth, y+minheight);
        end
        yield();
    end
end


local function drawLines(win)
    print("drawLines")
    local dc = ClientDC;
    dc:UseDCPen(true);
    dc:Rectangle(win.left, win.top, win.left+win.width-1, win.top+win.height-1);

    while true do

        for i=1,1 do
            local x1 = random(win.left, win.left+win.width-1)
            local y1 = random(win.top, win.top+win.height-1)
            local x2 = random(win.left, win.left+win.width-1)
            local y2 = random(win.top, win.top+win.height-1)
            local color = gdi.RGB(random(0,255), random(0,255),random(0,255))

            dc:SetDCPenColor(color)
            dc:MoveTo(x1,y1);
            dc:LineTo(x2,y2);
        end

        yield();
    end
end

local function drawPixels(win)

    local dc = ClientDC;

    dc:Rectangle(win.left, win.top, win.left+win.width-1, win.top+win.height-1);
    
    while true do
        --dc:Rectangle(win.left, win.top, win.left+win.width-1, win.top+win.height-1);
        for i=1,10 do
            local x = random(win.left,win.left+win.width-1)
            local y = random(win.top,win.top+win.height-1)
            local gray = random(0,255);
            local color = gdi.RGB(gray, gray, gray);
            --local color = gdi.RGB(random(0,255), random(0,255),random(0,255))

            dc:SetPixel(x,y,color);
        end

        yield();
    end
end
local function drawRectangles(win)
    local dc = ClientDC;
    dc:UseDCPen(true);
    dc:SetDCPenColor(gdi.RGB(0,0,255))
    dc:Rectangle(win.left, win.top, win.left+win.width-1, win.top+win.height-1);

    local minwidth = 40;
    local minheight = 40;

    while true do
        for i=1,1 do
            local x = random(win.left, win.left+win.width-1-minwidth)
            local y = random(win.top, win.top+win.height-1-minheight)

            dc:RoundRect(x,y, x+minwidth, y+minheight, 3, 3);
        end
        yield();
    end
end



function setup()
    --print("SETUP")
    local win1 = {left=0, top=0, width = width/2, height = height/2}
    local win2 = {left=width/2+1, top=0, width = width/2, height = height/2}
    local win3 = {left=0, top = height/2+1, width = width/2, height = height/2}
    local win4 = {left=width/2+1, top=height/2+1, width=width/2, height=height/2}

    spawn(drawPixels, win1);
    spawn(drawLines, win2);
    spawn(drawRectangles, win3)
    spawn(drawEllipse, win4)
end


graphicApp.run();