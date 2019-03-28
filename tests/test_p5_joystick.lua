package.path = "../?.lua;"..package.path;

require("win32.sdkddkver")
require("p5")

local spairs = require("spairs")


local Joystick = require("Joystick")



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



function setup()
    if not joy then
        print("NO JOY")
        halt();
    end

    -- capture joystick
    -- if you want rudimentary joystick control
    --joy:capture(appWindow.Handle)

    -- print joystick capabilities
    printDict(joy.caps)
    --halt();

    rectMode(CENTER)
end

function draw()
    clear();

    local pos, res = joy:getPosition()
    
    if not pos then
        print("POS: ERROR: ", res)
        return false;
    end
    
    local x = map(pos.x, -1,1, 0,width)
    local y = map(pos.y, -1,1, 0,height)
    local c = floor(map(pos.z, 0,1, 0,255))

    fill(c)
    rect(x, y, 20,20)
    --print(string.format("POS: %1.2f  %1.2f  %1.2f  %1.2f", pos.x, pos.y, pos.z, pos.r), string.format("0x%x", pos.buttons))
    if pos.POV then
        print("POV: ", pos.POV)
    end

    if pos.numberOfButtons > 0 then
        print("Buttons: ", string.format("0x%x", pos.buttons))
    end
end

function joyMoved(event)
    print("joyMoved: ", event.x, event.y)
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

go()
