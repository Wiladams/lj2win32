package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local gdi = require("win32.wingdi")
local winerror = require("win32.winerror")


-- Create a device context and check capabilities
