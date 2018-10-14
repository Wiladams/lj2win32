local ffi = require("ffi")

local wingdi = require("win32.wingdi")
local winuser = require("win32.winuser")
local wmmsgs = require("wmmsgs")

local function msgLoop()
    --  create some a loop to process window messages
    print("msgLoop - BEGIN")
    local msg = ffi.new("MSG")
    local res = 0;

    while (true) do
        print("LOOP")
        -- we use peekmessage, so we don't stall on a GetMessage
        --while (ffi.C.PeekMessageA(msg, nil, 0, 0, ffi.C.PM_REMOVE) ~= 0) do
        while (ffi.C.GetMessageA(msg, nil,0,0) ~= 0) do
            print(string.format("Loop Message: 0x%x", msg.message), wmmsgs[msg.message])            
            res = ffi.C..TranslateMessage(msg)
            res = ffi.C..DispatchMessageA(msg)
            yield();
        end
        
        if msg.message == ffi.C.WM_QUIT then
            print("msgLoop - QUIT")
            --continueRunning = false;
            break;
        end
    end

    print("msgLoop - END")
end

return msgLoop
