
local ffi = require("ffi");
local bit = require("bit");
local bor = bit.bor;

local errorhandling = require("win32.core.errorhandling_l1_1_1");
local core_library = require("win32.core.libraryloader_l1_1_1");

local User32 = require("win32.winuser");



ffi.cdef[[
typedef struct {
	HWND	Handle;
} WindowHandle, *PWindowHandle;
]]


local WindowHandle_mt = {}
ffi.metatype("WindowHandle", WindowHandle_mt);
local WindowHandle = ffi.typeof("WindowHandle");

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
		ClientDC = ffi.C.GetDC(rawhandle);
	}
	setmetatable(obj, NativeWindow_mt);

	return obj;
end

--[[
	CreateWindowExA(
     DWORD dwExStyle,
     LPCSTR lpClassName,
     LPCSTR lpWindowName,
     DWORD dwStyle,
     int X,
     int Y,
     int nWidth,
     int nHeight,
     HWND hWndParent,
     HMENU hMenu,
     HINSTANCE hInstance,
     LPVOID lpParam);
]]
function NativeWindow.create(self, className, width, height, title)
	className = className or "NativeWindowClass";
	title = title or "Native Window Title";

	print("NativeWindow.create, name, title: ", className, title)

	local dwExStyle = bor(ffi.C.WS_EX_OVERLAPPEDWINDOW, ffi.C.WS_EX_APPWINDOW);
	local dwStyle = bor(ffi.C.WS_SYSMENU, ffi.C.WS_VISIBLE, ffi.C.WS_POPUP);

	--print("  Style: ", string.format("0x%x",dwExStyle), string.format("0x%x",dwStyle))

	local appInstance = core_library.GetModuleHandleA(nil);

	local hwnd = ffi.C.CreateWindowExA(
		dwExStyle,
		className,
		title,
		ffi.C.WS_OVERLAPPEDWINDOW,
		ffi.C.CW_USEDEFAULT,
		0,	-- ffi.C.CW_USEDEFAULT,
		width, 
		height,
		nil,
		nil,
		appInstance,
		nil);

	if hwnd == nil then
		return false, errorhandling.GetLastError();
	end

	return self:init(hwnd);
end



--[[
	Instance Methods
--]]

-- Attributes
function NativeWindow.getNativeHandle(self)
	return self.Handle.Handle;
end

function NativeWindow.getDeviceContext(self)
	if not self.ClientContext then
		self.ClientContext = DeviceContext(ffi.C.GetDC(self:getNativeHandle()))
	end

	return self.ClientContext;
end

-- Functions
function NativeWindow.hide(self, kind)
	kind = kind or ffi.C.SW_HIDE;
	self:Show(kind);
end
		
function NativeWindow.maximize(self)
	--print("NativeWinow:MAXIMIZE: ", ffi.C.SW_MAXIMIZE);
	return self:Show(ffi.C.SW_MAXIMIZE);
end

function NativeWindow.redraw(self, flags)
	local lprcUpdate = nil;	-- const RECT *
	local hrgnUpdate = nil; -- HRGN
	flags = flags or ffi.C.RDW_UPDATENOW;

	local res = ffi.C.RedrawWindow(
  		self:getNativeHandle(),
  		lprcUpdate,
   		hrgnUpdate,
  		flags);

	return true;
end

function NativeWindow.show(self, kind)
	kind = kind or ffi.C.SW_SHOWNORMAL;

	return ffi.C.ShowWindow(self:getNativeHandle(), kind);
end

function NativeWindow.update(self)
	ffi.C.UpdateWindow(self:getNativeHandle())
end

function NativeWindow.getClientSize(self)
	local csize = ffi.new( "RECT[1]" )
	User32.GetClientRect(self:getNativeHandle(), csize);
	csize = csize[0]
	local width = csize.right-csize.left
	local height = csize.bottom-csize.top

	return width, height
end

function NativeWindow.getTitle(self)
	local buf = ffi.new("char[?]", 256)
	local lbuf = ffi.cast("intptr_t", buf)
	if User32.SendMessageA(self:getNativeHandle(), ffi.C.WM_GETTEXT, 255, lbuf) ~= 0 then
		return ffi.string(buf)
	end

	return nil;
end


return NativeWindow;
