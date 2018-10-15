package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local bit = require("bit")
local bor, band = bit.bor, bit.band

local scheduler = require("scheduler")
local winuser = require("win32.winuser")
local wmmsgs = require("wmmsgs")


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
    print("eventDelegate: ", event, hwnd, idObject, idChild)
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
        bor(ffi.C.WINEVENT_OUTOFCONTEXT, ffi.C.WINEVENT_SKIPOWNPROCESS));

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
end

local function main()
    spawn(setEvent)
    spawn(msgLoop)
end

run(main)
