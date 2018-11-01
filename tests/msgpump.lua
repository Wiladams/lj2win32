--[[
    msgpump

    This is the implementation of a window-less message loop

    This must run in the context of a scheduler
]]
local ffi = require("ffi")

local wingdi = require("win32.wingdi")
local winuser = require("win32.winuser")
local wmmsgs = require("wmmsgs")
local libraryloader = require("experimental.apiset.libraryloader_l1_1_1");




local msgpump = {}
setmetatable(msgpump, {
    __call = function(self, ...)
        return self:new(...);
    end
})
local msgpump_mt ={
    __index = msgpump;
}
function msgpump.new(self, wndproc)
    local class_name = "msgpump";
    local wx = ffi.new("WNDCLASSEXA")

    local appInstance = libraryloader.GetModuleHandleA(nil);

    wx.cbSize = ffi.sizeof("WNDCLASSEXA");
    wx.lpfnWndProc = wndproc;        -- function which will handle messages
    wx.hInstance = nil;
    wx.lpszClassName = class_name;
    
    local reg = ffi.C.RegisterClassExA(wx) 
    if reg < 1 then 
        return nil;
    end

    local hwnd = ffi.C.CreateWindowExA( 0, class_name, "msgpump", 0, 0, 0, 0, 0, ffi.cast("HWND",ffi.C.HWND_MESSAGE), nil, nil, nil );


    local obj = {
        atom = reg;
        hwnd = hwnd;
    }
    setmetatable(msgpump, msgpump_mt)
end

local function msgLoop(wndproc)
    -- create an instance of a msgpump
    local pump = msgpump(wndproc)

    --  create some a loop to process window messages
    print("msgLoop - BEGIN")
    local msg = ffi.new("MSG")
    local res = 0;

    while (true) do
        --print("LOOP")
        -- we use peekmessage, so we don't stall on a GetMessage
        while (ffi.C.PeekMessageA(msg, nil, 0, 0, ffi.C.PM_REMOVE) ~= 0) do
            print(string.format("Loop Message: 0x%x", msg.message), wmmsgs[msg.message])            
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

return msgLoop
