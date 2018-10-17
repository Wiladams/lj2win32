local ffi = require("ffi")

local winuser = require("win32.winuser")
local wmmsgs = require("wmmsgs")

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

return msgLoop
