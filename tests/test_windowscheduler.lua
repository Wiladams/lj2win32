package.path = "../?.lua;"..package.path;

local os = require("os")
local ffi = require("ffi")
local C = ffi.C 

require("win32.sdkddkver")
require("win32.wingdi")
require("win32.winuser")

local WindowKind = require("WindowKind")
local wmmsgs = require("wmmsgs")
--local wmmsgs = require("wm_reserved")
local scheduler = require("scheduler")
local msgloop = require("msgloop")

local exports = {}

--[[
    A simple Windows message handler.
    The only interesting thing done here is to quit
    the application when the window is closed.

    There are more elegant solutions, such as doing
    a PostQuitMessage(), but for this simple test, we 
    just want the app to exit when we close the window.
]]
jit.off(WindowProc)
function WindowProc(hwnd, msg, wparam, lparam)
    print(string.format("WindowProc: msg: 0x%x, %s", msg, wmmsgs[msg]))

    if msg == C.WM_DESTROY then
        C.PostQuitMessage(0);
        --halt();
    end

    if msg == C.WM_QUIT then
        print("WM_QUIT")
        --halt();
    end

	return C.DefWindowProcA(hwnd, msg, wparam, lparam);
end

-- You MUST register a window class before you can use it.
local winkind, err = WindowKind("NativeWindow", WindowProc);

if not winkind then
    print("Window kind not created, ERROR: ", err);
    return false, err;
end

exports.winkind = winkind;


local function counter()
    local counter = 0;

    while true do
        counter = counter + 1;
        print("COUNTER")
        yield();
    end
end


local function main()
    -- Create an actual instance of a window
    exports.win1 = winkind:createWindow(320, 240, "Native Window");
    --print("win1: ", win1)
    
    -- get it to display on the screen
    exports.win1:show();
    exports.win1:update();
    
    spawn(msgloop)
    --spawn(counter)
end

run(main)

return exports
