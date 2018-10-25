package.path = "../?.lua;"..package.path;

local os = require("os")
local ffi = require("ffi")


local User32 = require("win32.winuser")
local WindowKind = require("WindowKind")
local NativeWindow = require("nativewindow")
--local wmmsgs = require("wmmsgs")
local wmmsgs = require("wm_reserved")
local sched = require("scheduler")


local function createWindow(params)
    return NativeWindow:create(params.kind.ClassName, params.width, params.height,  params.title);
end


function WindowProc(hwnd, msg, wparam, lparam)
    print(string.format("WindowProc: msg: 0x%x, %s", msg, wmmsgs[msg]), wparam, lparam)

    if msg == ffi.C.WM_DESTROY then
        ffi.C.PostQuitMessage(0);
    end

    local res = ffi.C.DefWindowProcA(hwnd, msg, wparam, lparam);

    print("WindowProc, return: ", res)

	return res
end
jit.off(WindowProc)

local function msgLoop()
    --  create some a loop to process window messages
    print("msgLoop - BEGIN")
    local msg = ffi.new("MSG")
    local res = 0;

    while (true) do
        --print("LOOP")
        -- we use GetMessage, so we're sure to block here
        -- until a message is receive
        local res = ffi.C.GetMessageA(msg, nil,0,0)
        print(string.format("Loop Message: 0x%x", msg.message), wmmsgs[msg.message])            

        if res == 0 then 
            print("msgLoop - QUIT")
                        -- message is to quit
            yield();
            break;
        end

        res = ffi.C.TranslateMessage(msg)
        res = ffi.C.DispatchMessageA(msg)
        yield();
    end

    print("msgLoop - END")
    halt();
end

-- You MUST register a window class before you can use it.
local winkind, err = WindowKind("NativeWindow", WindowProc);

if not winkind then
	print("Window kind not created, ERROR: ", err);
	return false, err;
end


print("Created Window Kind")

local function main()
    local win = createWindow({kind = winkind, title="No Title", x=200, y=200, width = 640, height=480})

    --spawn a message loop, so we can terminate reasonably
    spawn(msgLoop)
    win:show();

end

run(main)
