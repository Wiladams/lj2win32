package.path = "../?.lua;"..package.path;

--[[
    Test the basic functions of a GDI Device Context
]]
local ffi = require("ffi")

local DC = require("DeviceContext")
local gdi = require("win32.wingdi")
local sched = require("scheduler")


local random = math.random

local width = 3240;
local height = 2160;

    -- Create a device context, default is the device context of the primary screen
local dc = DC();
dc:Rectangle(0, 0, width, height);

local function screenWrite()
    -- Do some simple drawing on it
    dc:Rectangle(0, 0, 319, 199);
    dc:Text("Hello, World!", 10, 10);
    dc:flush();
end

-- upper left quadrant
local function drawPixels(win)

    dc:Rectangle(win.left, win.top, win.left+win.width-1, win.top+win.height-1);
    
    while true do
        for i=1,10 do
            local x = random(win.left,win.left+win.width-1)
            local y = random(win.top,win.top+win.height-1)
            local color = gdi.RGB(random(0,255), random(0,255),random(0,255))

            dc:SetPixel(x,y,color);
        end
        --dc:flush();
        yield();
    end
end

local function drawLines(win)

    dc:Rectangle(win.left, win.top, win.left+win.width-1, win.top+win.height-1);

    while true do

        for i=1,5 do
            local x1 = random(win.left, win.left+win.width-1)
            local y1 = random(win.top, win.top+win.height-1)
            local x2 = random(win.left, win.left+win.width-1)
            local y2 = random(win.top, win.top+win.height-1)
            local color = gdi.RGB(random(0,255), random(0,255),random(0,255))

            dc:SetDCPenColor(color)
            dc:MoveTo(x1,y1);
            dc:LineTo(x2,y2);
        end
        --dc:flush();
        yield();
    end
end

local function drawRectangles(win)
    dc:SetDCPenColor(gdi.RGB(0,0,255))
    dc:Rectangle(win.left, win.top, win.left+win.width-1, win.top+win.height-1);

    local minwidth = 40;
    local minheight = 40;

    while true do
        for i=1,10 do
            local x = random(win.left, win.left+win.width-1-minwidth)
            local y = random(win.top, win.top+win.height-1-minheight)

            dc:RoundRect(x,y, x+minwidth, y+minheight, 3, 3);
        end
        yield();
    end
end

local function main()
    local win1 = {left=0, top=0, width = width/2, height = height/2}
    local win2 = {left=width/2+1, top=0, width = width/2, height = height/2}
    local win3 = {left=0, top = height/2+1, width = width/2, height = height/2}

    dc:UseDCPen();

    spawn(drawPixels, win1);
    spawn(drawLines, win2);
    spawn(drawRectangles, win3)
end

run(main)
