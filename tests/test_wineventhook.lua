package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local wingdi = require("win32.wingdi")
local winuser = require("win32.winuser")

local wmmsgs = require("wmmsgs")

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

    if msg == ffi.C.WM_DESTROY then
        User32.PostQuitMessage(0);
        --halt();
    end

    if msg == ffi.C.WM_QUIT then
        print("WM_QUIT")
        --halt();
    end

	return User32.DefWindowProcA(hwnd, msg, wparam, lparam);
end

--[[
    typedef VOID (__stdcall* WINEVENTPROC)(
    HWINEVENTHOOK hWinEventHook,
    DWORD         event,
    HWND          hwnd,
    LONG          idObject,
    LONG          idChild,
    DWORD         idEventThread,
    DWORD         dwmsEventTime);
]]
jit.off(eventDelegate)
local function eventDelegate(hWinEventHook, event, hwnd, idObject, idChild, idEventThread, dwmsEventTime)
    print("eventDelegate: ", event)
end

jit.off(moveDelegate)
local function moveDelegate(hWinEventHook, event, hwnd, idObject, idChild, idEventThread, dwmsEventTime)
    print("moveDelegate: ", event)
end

local function setEvent()
    local moveHook = ffi.C.SetWinEventHook(
        ffi.C.EVENT_SYSTEM_MOVESIZESTART, 
        ffi.C.EVENT_SYSTEM_MOVESIZEEND,
        nil,
        moveDelegate, 
        0,
        0,
        ffi.C.WINEVENT_OUTOFCONTEXT);

--[[
    local hook = ffi.C.SetWinEventHook(
        ffi.C.EVENT_SYSTEM_FOREGROUND, 
        ffi.C.EVENT_SYSTEM_FOREGROUND,
        nil,
        eventDelegate, 
        0,
        0,
        ffi.C.WINEVENT_OUTOFCONTEXT);
--]]
    print("Hook: ", hook)
end


local function main()
    spawn(setEvent)
    spawn(msgloop)
end

run(main)
