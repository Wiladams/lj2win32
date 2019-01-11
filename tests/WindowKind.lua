-- WindowKind.lua
--[[
    A WindowKind is a class of Window.  This is a convenience
    for getting a particular kind of window registered.
    The primary working interface is the constructor, which 
    looks like this:
        function WindowKind.create(self, classname, msgproc, style)

    Parameters:
            classname - The name of the window class
            msgproc - A 'WindowProc', which will receive all the messages
            style - a style for the window class
    
    The real benefit is that once you construct a Window class, you 
    can use this as a class factory, to generate instances of 
    that kind of Window.
]]
local ffi = require("ffi");
local bit = require("bit");
local bor = bit.bor;

local errorhandling = require("win32.errhandlingapi");

require("win32.wingdi")
local winuser = require("win32.winuser");



local WindowKind = {}
setmetatable(WindowKind, {
    __call = function(self, ...)
        return self:create(...);
    end,
});

local WindowKind_mt = {
    __index = WindowKind,    
}

function WindowKind.init(self, classname, atom)
    local obj = {
        ClassAtom = atom,
        ClassName = classname,
    }
    setmetatable(obj, WindowKind_mt);

    return obj;
end

function WindowKind.create(self, classname, msgproc, style)
	msgproc = msgproc or ffi.C.DefWindowProcA;
	--style = style or bor(ffi.C.CS_HREDRAW,ffi.C.CS_VREDRAW, ffi.C.CS_OWNDC);
	style = style or bor(ffi.C.CS_HREDRAW,ffi.C.CS_VREDRAW);

	local appInstance = ffi.C.GetModuleHandleA(nil);

	local wcex = ffi.new("WNDCLASSEXA");
    wcex.cbSize = ffi.sizeof(wcex);
    wcex.style          = style;
    wcex.lpfnWndProc    = msgproc;
    wcex.cbClsExtra     = 0;
    wcex.cbWndExtra     = 0;
    wcex.hInstance      = appInstance;
    wcex.hIcon          = ffi.C.LoadIconA(appInstance, winuser.MAKEINTRESOURCE(ffi.C.IDI_APPLICATION));
    wcex.hCursor        = winuser.LoadCursor(nil, winuser.IDC_ARROW);
    wcex.hbrBackground  = ffi.cast("HBRUSH", ffi.C.COLOR_WINDOW+1);
    wcex.lpszMenuName   = nil;		-- NULL;
    wcex.lpszClassName  = classname;
    wcex.hIconSm        = ffi.C.LoadIconA(appInstance, winuser.MAKEINTRESOURCE(ffi.C.IDI_APPLICATION));

	local classAtom = ffi.C.RegisterClassExA(wcex);

	if classAtom == 0 then
    	return nil, errorhandling.GetLastError();
    end

    return self:init(classname, classAtom);
end



return WindowKind;
