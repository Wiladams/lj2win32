package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local NativeWindow = require("NativeWindow")

local win1 = NativeWindow("NativeWindow", 320, 240, "Native Window");