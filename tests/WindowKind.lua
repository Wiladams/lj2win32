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

local errorhandling = require("win32.core.errorhandling_l1_1_1");
local libraryloader = require("win32.core.libraryloader_l1_1_1");

local User32 = require("win32.user32");
local NativeWindow = require("NativeWindow");


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
	msgproc = msgproc or User32.DefWindowProcA;
	style = style or bor(ffi.C.CS_HREDRAW,ffi.C.CS_VREDRAW, ffi.C.CS_OWNDC);

	local appInstance = libraryloader.GetModuleHandleA(nil);

	local wcex = ffi.new("WNDCLASSEXA");
    wcex.cbSize = ffi.sizeof(wcex);
    wcex.style          = style;
    wcex.lpfnWndProc    = msgproc;
    wcex.cbClsExtra     = 0;
    wcex.cbWndExtra     = 0;
    wcex.hInstance      = appInstance;
    wcex.hIcon          = nil;		-- LoadIcon(hInst, MAKEINTRESOURCE(IDI_APPLICATION));
    wcex.hCursor        = User32.LoadCursor(nil, IDC_ARROW);
    wcex.hbrBackground  = nil;		-- (HBRUSH)(COLOR_WINDOW+1);
    wcex.lpszMenuName   = nil;		-- NULL;
    wcex.lpszClassName  = classname;
    wcex.hIconSm        = nil;		-- LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_APPLICATION));

	local classAtom = User32.RegisterClassExA(wcex);

	if classAtom == 0 then
    	return nil, errorhandling.GetLastError();
    end

    return self:init(classname, classAtom);
end


function WindowKind.createWindow(self, width, height, title)
    return NativeWindow:create(self.ClassName, width, height,  title);
end

return WindowKind;
