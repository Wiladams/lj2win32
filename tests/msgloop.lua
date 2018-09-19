local ffi = require("ffi")

local User32 = require("win32.user32")
local wmmsgs = require("wmmsgs")

local function msgLoop()
    --  create some a loop to process window messages
    print("msgLoop - BEGIN")
    local msg = ffi.new("MSG")
    local res = 0;

    while (true) do
        --print("LOOP")
        -- we use peekmessage, so we don't stall on a GetMessage
        while (User32.Lib.PeekMessageA(msg, nil, 0, 0, ffi.C.PM_REMOVE) ~= 0) do
            print(string.format("Loop Message: 0x%x", msg.message), wmmsgs[msg.message])            
            res = User32.Lib.TranslateMessage(msg)
            res = User32.Lib.DispatchMessageA(msg)
        end
        
        if msg.message == ffi.C.WM_QUIT then
            print("msgLoop - QUIT")
            --continueRunning = false;
        end

        yield();
    end

    print("msgLoop - END")
end

return msgLoop
