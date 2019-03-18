package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

require("win32.sdkddkver")

--require("win32.minwindef")
--require("win32.minwinbase")
--require("win32.windef") -- to pickup HWND


local Joystick = require("Joystick")

local function getFirstJoystick()
    for joy in Joystick:sticks() do
        return joy;
    end
end

local function printPosition(pos, res)
    if not pos then
        print("POS: ERROR: ", res)
        return false;
    end
    
    print("POS: ", pos.x, pos.y, pos.z, string.format("0x%x", pos.buttons))
end


local joy = getFirstJoystick()

if not joy then
    print("NO JOY")
    return nil;
end

local pos, res = joy:getPosition()
printPosition(pos, res)