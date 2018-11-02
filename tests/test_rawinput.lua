package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local winuser = require("win32.winuser")
local msgpump = require("msgpump")
local wmmsgs = require("wmmsgs")
local scheduler = require("scheduler")




local function RegisterDevices(hwnd)
    local pRawInputDevices = ffi.new("RAWINPUTDEVICE[1]")
    local uiNumDevices = 1;
    local cbSize = ffi.sizeof("RAWINPUTDEVICE")

    -- mouse
    pRawInputDevices[0].usUsagePage = 1;
    pRawInputDevices[0].usUsage = 0x02;
    pRawInputDevices[0].dwFlags = ffi.C.RIDEV_INPUTSINK;    -- must do this or no input
    pRawInputDevices[0].hwndTarget = hwnd;                  -- must associate with window for input

    local res = ffi.C.RegisterRawInputDevices(pRawInputDevices, uiNumDevices,cbSize);

    print("RegisterDevices: ", res)
end

local function GetInputDevices()
    local cbSize = ffi.sizeof("RAWINPUTDEVICE");
    local puiNumDevices = ffi.new("UINT[1]")
    ffi.C.GetRegisteredRawInputDevices(nil, puiNumDevices, cbSize)

    local numDevices = puiNumDevices[0]
    print("Num Devices: ", numDevices)
end



function msgproc(hwnd, msg, wparam, lparam)
    print(string.format("msgproc: msg: 0x%x, %s", msg, wmmsgs[msg]))

    local res = 1;

    -- If the window has been destroyed, then post a quit message
    if msg == ffi.C.WM_DESTROY then
        ffi.C.PostQuitMessage(0);
        signalAllImmediate('gap-quitting');
        return 0;
    else
        res = ffi.C.DefWindowProcA(hwnd, msg, wparam, lparam);
    end

	return res
end
jit.off(msgproc)

local function msgLoop(wndproc)
    -- create an instance of a msgpump
    local pump = msgpump(wndproc)

    --  create some a loop to process window messages
    --print("msgLoop - BEGIN")
    local msg = ffi.new("MSG")
    local res = 0;

    while (true) do
        --print("LOOP")
        -- we use peekmessage, so we don't stall on a GetMessage
        while (ffi.C.PeekMessageA(msg, nil, 0, 0, ffi.C.PM_REMOVE) ~= 0) do
            --print(string.format("Loop Message: 0x%x", msg.message), wmmsgs[msg.message])            
            res = ffi.C.TranslateMessage(msg)
            res = ffi.C.DispatchMessageA(msg)
        end
        
        if msg.message == ffi.C.WM_QUIT then
            print("msgLoop - QUIT")
            --continueRunning = false;
        end

        yield();
    end

    print("msgLoop - END")
end

local pumper = msgpump(msgproc)

local function main()
    spawn(msgLoop, msgproc)
    yield()

    RegisterDevices(pumper.hwnd);
    GetInputDevices();
end

run(main)


