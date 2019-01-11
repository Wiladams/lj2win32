package.path = "../?.lua;"..package.path;

local os = require("os")
local ffi = require("ffi")
local C = ffi.C

require("win32.sdkddkver")

local wingdi = require("win32.wingdi")
local winuser = require("win32.winuser")
local WindowKind = require("WindowKind")
local NativeWindow = require("NativeWindow")
local wmmsgs = require("wmmsgs")
--local wmmsgs = require("wm_reserved")

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
        --C.PostQuitMessage(0);
        os.exit();
    end

    if msg == C.WM_QUIT then
        print("WM_QUIT")
    --    error("QUIT")
    end

	return C.DefWindowProcA(hwnd, msg, wparam, lparam);
end


-- You MUST register a window class before you can use it.
local winkind, err = WindowKind("NativeWindow", WindowProc);

if not winkind then
	print("Window kind not created, ERROR: ", err);
	return false, err;
end

-- Create an actual instance of a window
local win1 = NativeWindow(winkind.ClassName, 320, 240, "Native Window");
--print("win1: ", win1)
win1:show();
win1:update();


--  create some sort of loop to keep window open
-- until we want to quit
local msg = ffi.new("MSG")

-- Run a basic windows message pump
local res = 0;
while (continueRunning) do

	res = C.GetMessageA(msg, nil, 0,0)
	res = C.TranslateMessage(msg)
			
	C.DispatchMessageA(msg)

	if msg.message == ffi.C.WM_QUIT then
			print("APP QUIT == TRUE")
			continueRunning = false;
	end
end
