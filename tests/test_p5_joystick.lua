package.path = "../?.lua;"..package.path;

require("win32.sdkddkver")
require("p5")

local spairs = require("spairs")
local Joystick = require("Joystick")
local Rectangle = require("Rectangle")
local enum = require("enum")

local function printDict(dict)
    for k,v in spairs(dict) do
        print(string.format("%20s", k), v)
    end
end

local function getFirstJoystick()
    for joy in Joystick:sticks() do
        return joy;
    end
end



local joy = getFirstJoystick()

local canvasWidth = 940
local canvasHeight = 656
local canvasX = 64
local canvasY = 48

local canvasFrame = Rectangle(canvasX, canvasY, canvasWidth, canvasHeight)

local tools = enum {
    [1] = "selector",
    [2] = "pen",
}

local currentTool = tools['selector'];
local joyX = 0;
local joyY = 0;


function setup()
    if not joy then
        print("NO JOY")
        halt();
    end

    -- capture joystick
    -- if you want rudimentary joystick control
    joy:capture(appWindow.Handle)

    -- print joystick capabilities
    --printDict(joy.caps)
    joyX = width/2;
    joyY = height/2;
end

function draw()
    clear();

    local pos, res = joy:getPosition()
    
    if not pos then
        print("POS: ERROR: ", res)
        return false;
    end
    
    -- draw canvas drawing area
    fill(255)
    rectMode(CORNER)
    rect(canvasFrame:x(), canvasFrame:y(), canvasFrame:width(), canvasFrame:height())

    local x = map(pos.x, -1,1, 0,width)
    local y = map(pos.y, -1,1, 0,height)
    local c = floor(map(pos.z, 0,1, 0,255))

    fill(c)
    rectMode(CENTER)
    if currentTool == tools['selector'] then
        rect(x, y, 20,20)
    else
        ellipse(x,y,10,10)
    end

    --print(string.format("POS: %1.2f  %1.2f  %1.2f  %1.2f", pos.x, pos.y, pos.z, pos.r), string.format("0x%x", pos.buttons))
    if pos.POV then
        print("POV: ", pos.POV)
    end

    if pos.numberOfButtons > 0 then
        print("Buttons: ", string.format("0x%x", pos.buttons))
    end
end

function joyMoved(event)
    --print("joyMoved: ", event.x, event.y)
    local pos, res = joy:getPosition()

    local x = floor(map(pos.x, -1,1, 0,width))
    local y = floor(map(pos.y, -1,1, 0,height))
    --print("joyMoved: ", x, y)

    if canvasFrame:contains(x,y) then
        currentTool = tools['pen']
    else
        currentTool = tools['selector']
    end
end

function joyZMoved(event)
    print("joyZMoved: ", event.z)

end

function joyPressed(event)
    print("joyPressed: ", event.Buttons)
end

function joyReleased(event)
    print("joyReleased: ", event.Buttons)
end

go({width=1024, height=768})
