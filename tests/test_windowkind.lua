package.path = "../?.lua;"..package.path;

local os = require("os")
local ffi = require("ffi")


local User32 = require("win32.winuser")
local WindowKind = require("WindowKind")
local NativeWindow = require("nativewindow")
local wmmsgs = require("wmmsgs")

local function createWindow(params)
    return NativeWindow:create(params.kind.ClassName, params.width, params.height,  params.title);
end

jit.off(WindowProc)
function WindowProc(hwnd, msg, wparam, lparam)
    print(string.format("WindowProc: msg: 0x%x, %s", msg, wmmsgs[msg]), wparam, lparam)

    local res = ffi.C.DefWindowProcA(hwnd, msg, wparam, lparam);

    print("WindowProc, return: ", res)

	return res
end


-- You MUST register a window class before you can use it.
local winkind, err = WindowKind("NativeWindow", WindowProc);

if not winkind then
	print("Window kind not created, ERROR: ", err);
	return false, err;
end


print("Created Window Kind")


local win = createWindow({kind = winkind, title="No Title", x=200, y=200, width = 640, height=480})