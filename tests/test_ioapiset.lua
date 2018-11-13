package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

--require("win32.ioapiset")
local iocompletionset = require("iocompletionset")