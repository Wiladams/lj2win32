package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local user32 = require("win32.user32")
local NativeWindow = require("nativewindow")


-- You MUST register a window class before you can use it.
local classname = "NativeWindow"
local winclass = NativeWindow:RegisterWindowClass(classname)


local win1 = NativeWindow:create("NativeWindow", 320, 240, "Native Window");
print("win1: ", win1)
win1:Show();
--  create some sort of loop to keep window open

console.