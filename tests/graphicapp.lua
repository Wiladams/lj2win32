--[[
    Create a graphic application.  That means there will be a window,
    a default event loop, and when the window closes, the app will close.

    A set of GDI based graphics calls will be available by default.
    Access to the device context of the window, and the window handle itself
]]
local ffi = require("ffi")
local bit = require("bit")
local band, bor = bit.band, bit.bor
local rshift, lshift = bit.rshift, bit.lshift;

local sched = require("scheduler")
local winuser = require("win32.winuser")
local WindowKind = require("WindowKind")
local NativeWindow = require("nativewindow")
local wmmsgs = require("wm_reserved")


local exports = {}


local function wm_mouse_event(hwnd, msg, wparam, lparam)
    local event = {
        x = band(lparam,0x0000ffff);
        y = rshift(band(lparam, 0xffff0000),16);
        control = band(wparam, ffi.C.MK_CONTROL) ~= 0;
        shift = band(wparam, ffi.C.MK_SHIFT) ~= 0;
        lbutton = band(wparam, ffi.C.MK_LBUTTON) ~= 0;
        rbutton = band(wparam, ffi.C.MK_RBUTTON) ~= 0;
        mbutton = band(wparam, ffi.C.MK_MBUTTON) ~= 0;
        xbutton1 = band(wparam, ffi.C.MK_XBUTTON1) ~= 0;
        xbutton2 = band(wparam, ffi.C.MK_XBUTTON2) ~= 0;
    }

    return event;
end

function onMouseActivity(hwnd, msg, wparam, lparam)
    local res = 1;

    local event = wm_mouse_event(hwnd, msg, wparam, lparam)
    if msg == ffi.C.WM_MOUSEMOVE  then
        event.activity = 'mousemove' 
        signalAll('mousemove', event)
    elseif msg == ffi.C.WM_LBUTTONDOWN or 
        msg == ffi.C.WM_RBUTTONDOWN or
        msg == ffi.C.WM_MBUTTONDOWN or
        msg == ffi.C.WM_XBUTTONDOWN then
        event.activity = 'mousedown';
        signalAll('mousedown', event)
    elseif msg == ffi.C.WM_LBUTTONUP or
        msg == ffi.C.WM_RBUTTONUP or
        msg == ffi.C.WM_MBUTTONUP or
        msg == ffi.C.WM_XBUTTONUP then
        event.activity = 'mouseup'
        signalAll('mouseup', event)
    elseif msg == ffi.C.WM_MOUSEWHEEL then
        event.activity = 'mousewheel';
        signalAll('mousewheel', event)
    else
        res = ffi.C.DefWindowProcA(hwnd, msg, wparam, lparam);
    end

    return res;
end

function onKeyboardActivity(hwnd, msg, wparam, lparam)
    print("onKeyboardActivity")
    local res = 1;

    res = ffi.C.DefWindowProcA(hwnd, msg, wparam, lparam);

    return res;
end


function WindowProc(hwnd, msg, wparam, lparam)
    --print(string.format("WindowProc: msg: 0x%x, %s", msg, wmmsgs[msg]), wparam, lparam)

    local res = 1;

    -- If the window has been destroyed, then post a quit message
    if msg == ffi.C.WM_DESTROY then
        ffi.C.PostQuitMessage(0);
        return res;
    end

    if msg >= ffi.C.WM_MOUSEFIRST and msg <= ffi.C.WM_MOUSELAST then
        res = onMouseActivity(hwnd, msg, wparam, lparam)
    elseif msg >= ffi.C.WM_KEYFIRST and msg <= ffi.C.WM_KEYLAST then
        res = onKeyboardActivity(hwnd, msg, wparam, lparam)  
    else
        res = ffi.C.DefWindowProcA(hwnd, msg, wparam, lparam);
    end

	return res
end
jit.off(WindowProc)




local function msgLoop()
    --  create some a loop to process window messages
    --print("msgLoop - BEGIN")
    local msg = ffi.new("MSG")
    local res = 0;

    while (true) do
        --print("LOOP")
        -- we use peekmessage, so we don't stall on a GetMessage
        while (ffi.C.PeekMessageA(msg, nil, 0, 0, ffi.C.PM_REMOVE) ~= 0) do
            --print(string.format("Loop Message: 0x%x", msg.message), wmmsgs[msg.message])            

            -- If we see a quit message, it's time to stop the program
            -- ideally we'd call an 'onQuit' and wait for that to return
            -- before actually halting.  That will give the app a chance
            -- to do some cleanup
            if msg.message == ffi.C.WM_QUIT then
                --print("msgLoop - QUIT")
                halt();
            end

            res = ffi.C.TranslateMessage(msg)
            res = ffi.C.DispatchMessageA(msg)
        end

        yield();
    end

    print("msgLoop - END")        
end


local function createWindow(params)
    params = params or {width=1026, height=768, title="GraphicApplication"}
    params.width = params.width or 1024;
    params.height = params.height or 768;
    params.title = params.title or "Graphic Application";

    -- You MUST register a window class before you can use it.
    local winkind, err = WindowKind("GraphicWindow", WindowProc);

    if not winkind then
        print("Window kind not created, ERROR: ", err);
        return false, err;
    end

    -- create an instance of a window
    appWindow = NativeWindow:create(winkind.ClassName, params.width, params.height,  params.title);
    appWindow:show();
end

local function main()
    spawn(msgLoop)
    spawn(createWindow)
end

function exports.run()
    run(main)
end

return exports
