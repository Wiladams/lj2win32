
local ffi = require("ffi");
local bit = require("bit");
local bor = bit.bor;

local errorhandling = require("win32.core.errorhandling_l1_1_1");
local core_library = require("win32.core.libraryloader_l1_1_1");

local User32 = require("win32.user32");


print(" core_library: ", core_library)
print("errorhandling: ", errorhandling)


ffi.cdef[[
typedef struct {
	HWND	Handle;
} WindowHandle, *PWindowHandle;
]]

local WindowHandle = ffi.typeof("WindowHandle");
local WindowHandle_mt = {}
ffi.metatype(WindowHandle, WindowHandle_mt);


local NativeWindow = {}
setmetatable(NativeWindow, {
	__call = function(self, ...)
		return self:create(...);
	end,
});
local NativeWindow_mt = {
	__index = NativeWindow,
}

function NativeWindow.init(self, rawhandle)
	local obj = {
		Handle = WindowHandle(rawhandle);
	}
	setmetatable(obj, NativeWindow_mt);

	return obj;
end

function NativeWindow.create(self, className, width, height, title)
	className = className or "NativeWindowClass";
	title = title or "Native Window Title";

	local dwExStyle = bor(ffi.C.WS_EX_APPWINDOW, ffi.C.WS_EX_WINDOWEDGE);
	local dwStyle = bor(ffi.C.WS_SYSMENU, ffi.C.WS_VISIBLE, ffi.C.WS_POPUP);

--print("GameWindow:CreateWindow - 1.0")
	local appInstance = core_library.GetModuleHandleA(nil);

	local hwnd = User32.CreateWindowExA(
		0,
		className,
		title,
		ffi.C.WS_OVERLAPPEDWINDOW,
		ffi.C.CW_USEDEFAULT,
		ffi.C.CW_USEDEFAULT,
		width, height,
		nil,
		nil,
		appInstance,
		nil);

local err = errorhandling.GetLastError();

print("hwnd: ", hwnd, err)

	if hwnd == nil then
		return false, errorhandling.GetLastError();
	end

	return self:init(hwnd);
end

--[[
	Instance Methods
--]]

-- Attributes
NativeWindow.getNativeHandle = function(self)
	return self.Handle.Handle;
end

NativeWindow.getDeviceContext = function(self)
	if not self.ClientContext then
		self.ClientContext = DeviceContext(User32.GetDC(self:getNativeHandle()))
	end

	return self.ClientContext;
end

-- Functions
NativeWindow.Hide = function(self, kind)
	kind = kind or User32.SW_HIDE;
	self:Show(kind);
end
		
NativeWindow.Maximize = function(self)
	--print("NativeWinow:MAXIMIZE: ", ffi.C.SW_MAXIMIZE);
	return self:Show(ffi.C.SW_MAXIMIZE);
end

NativeWindow.redraw = function(self, flags)
	local lprcUpdate = nil;	-- const RECT *
	local hrgnUpdate = nil; -- HRGN
	flags = flags or ffi.C.RDW_UPDATENOW;

	local res = User32.RedrawWindow(
  		self:getNativeHandle(),
  		lprcUpdate,
   		hrgnUpdate,
  		flags);

	return true;
end

function NativeWindow.Show(self, kind)
	kind = kind or ffi.C.SW_SHOWNORMAL;

	return User32.ShowWindow(self:getNativeHandle(), kind);
end

function NativeWindow.Update(self)
	User32.UpdateWindow(self:getNativeHandle())
end

function NativeWindow.GetClientSize(self)
	local csize = ffi.new( "RECT[1]" )
	User32.GetClientRect(self:getNativeHandle(), csize);
	csize = csize[0]
	local width = csize.right-csize.left
	local height = csize.bottom-csize.top

	return width, height
end

function NativeWindow.GetTitle(self)
	local buf = ffi.new("char[?]", 256)
	local lbuf = ffi.cast("intptr_t", buf)
	if User32.SendMessageA(self:getNativeHandle(), User32.WM_GETTEXT, 255, lbuf) ~= 0 then
		return ffi.string(buf)
	end
end


return NativeWindow;
