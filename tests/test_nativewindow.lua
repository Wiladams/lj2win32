package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local WindowKind = require("WindowKind")
local User32 = require("win32.user32")
local os = require("os")

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
    print(string.format("WindowProc, msg: 0x%x", msg))
    if msg == ffi.C.WM_CLOSE then
        --User32.PostQuitMessage(0);
        print("WM_CLOSE")
        os.exit();
    end

    if msg == ffi.C.WM_QUIT then
        print("WM_QUIT")
    --    error("QUIT")
    end

	return User32.DefWindowProcA(hwnd, msg, wparam, lparam);
end

-- You MUST register a window class before you can use it.
local winkind, err = WindowKind("NativeWindow", WindowProc);

if not winkind then
	print("Window kind not created, ERROR: ", err);
	return false, err;
end

-- Create an actual instance of a window
local win1 = winkind:createWindow(320, 240, "Native Window");
print("win1: ", win1)
win1:show();
win1:update();


--  create some sort of loop to keep window open
-- until we want to quit
local msg = ffi.new("MSG")

-- Run a basic windows message pump
local res = 0;
while (continueRunning) do

	res = User32.GetMessageA(msg, nil, 0,0)
	res = User32.TranslateMessage(msg)
			
	User32.DispatchMessageA(msg)

	if msg.message == ffi.C.WM_QUIT then
			print("APP QUIT == TRUE")
			continueRunning = false;
	end
end
