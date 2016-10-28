package.path = "../?.lua;"..package.path;

--[[
    Test the basic functions of a GDI Device Context
]]
local ffi = require("ffi")

local DC = require("DeviceContext")

-- Create a device context, default is the device context of the whole screen
local screenDC = DC();


-- Do some simple drawing on it
screenDC:Rectangle(0, 0, 319, 199);
screenDC:Text("Hello, World!", 10, 10);
screenDC:flush();