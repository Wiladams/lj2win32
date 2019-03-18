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

    -- print joystick capabilities
    printDict(joy.caps)
    --halt();
end

function draw()
    local pos, res = joy:getPosition()
    
    if not pos then
        print("POS: ERROR: ", res)
        return false;
    end
    
    print("POS: ", pos.x, pos.y, pos.z, pos.r, pos.u, pos.v, string.format("0x%x", pos.buttons))
end

go()
