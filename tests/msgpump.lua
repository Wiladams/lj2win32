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
    -- Post a single message to ensure that the
    -- message queue is setup.
    ffi.C.PostMessageA(hwnd, ffi.C.WM_NULL, 0, 0);


    local obj = {
        atom = reg;
        hwnd = hwnd;
    }
    setmetatable(obj, msgpump_mt)

    return obj
end


return msgpump
