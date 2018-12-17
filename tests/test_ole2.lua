package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local win32 = require("win32.minwindef")
local combaseapi = require("win32.combaseapi")
--local ole2 = require("win32.ole2")