package.path = "../?.lua;"..package.path;

local os = require("os")
local ffi = require("ffi")


local User32 = require("win32.user32")
local WindowKind = require("WindowKind")
local wmmsgs = require("wmmsgs")
--local wmmsgs = require("wm_reserved")
local scheduler = require("scheduler")

local continueRunning = true;

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
    --print(string.format("WindowProc, msg: 0x%x", msg))
    if msg == ffi.C.WM_CLOSE then
        return User32.PostQuitMessage(0);
        --halt();
    end

    if msg == ffi.C.WM_QUIT then
        print("WM_QUIT")
    --    error("QUIT")
        halt();
    end

	return User32.DefWindowProcA(hwnd, msg, wparam, lparam);
end

-- You MUST register a window class before you can use it.
local winkind, err = WindowKind("NativeWindow", WindowProc);

if not winkind then
    print("Window kind not created, ERROR: ", err);
    return false, err;
end


local function mainLoop()
    -- Create an actual instance of a window
    local win1 = winkind:createWindow(320, 240, "Native Window");
    --print("win1: ", win1)
    -- get it to display on the screen
    win1:show();
    win1:update();


    --  create some a loop to process window messages
    local msg = ffi.new("MSG")
    local res = 0;
    while (continueRunning) do
        -- we use peekmessage, so we don't stall on a GetMessage
        while (User32.Lib.PeekMessageA(msg, nil, 0, 0, ffi.C.PM_REMOVE) ~= 0) do
            
            res = User32.Lib.TranslateMessage(msg)
            print(string.format("Loop Message: 0x%x", msg.message), wmmsgs[msg])

            res = User32.Lib.DispatchMessageA(msg)



			if msg.message == ffi.C.WM_QUIT then
                --continueRunning = false;
			end
        end
        
        yield();
    end
end

local function counter()
    local counter = 0;

    while true do
        counter = counter + 1;
        print("COUNTER")
        yield();
    end


end

local function main()
    spawn(mainLoop)
    spawn(counter)
end

run(main)