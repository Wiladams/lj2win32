
local ffi = require("ffi");
local bit = require("bit");
local bor, band = bit.bor, bit.band;

local errorhandling = require("win32.errhandlingapi");

local wingdi = require("win32.wingdi")
local winuser = require("win32.winuser");
local menu = require("menu")


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
		Handle = rawhandle;
		ClientDC = ffi.C.GetDC(rawhandle);
	}
	setmetatable(obj, NativeWindow_mt);

	return obj;
end


function NativeWindow.create(self, className, width, height, title)
	className = className or "NativeWindowClass";
	title = title or "Native Window Title";

	--print("NativeWindow.create, name, title: ", className, title)

	local dwExStyle = bor(ffi.C.WS_EX_OVERLAPPEDWINDOW, ffi.C.WS_EX_APPWINDOW);
	local dwStyle = bor(ffi.C.WS_SYSMENU, ffi.C.WS_VISIBLE, ffi.C.WS_POPUP);

	--print("  Style: ", string.format("0x%x",dwExStyle), string.format("0x%x",dwStyle))

	local appInstance = ffi.C.GetModuleHandleA(nil);

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
function NativeWindow.getWindowDeviceContext(self)
	if not self.WindowContext then
		self.WindowContext = DeviceContext(ffi.C.GetWindowDC(self.Handle))
	end

	return self.WindowContext;
end

function NativeWindow.getDeviceContext(self)
	if not self.ClientContext then
		self.ClientContext = DeviceContext(ffi.C.GetDC(self.Handle))
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

function NativeWindow.invalidate(self, lpRect, bErase)
	bErase = bErase or 0;

	local res = ffi.C.InvalidateRect(self.Handle, r, bErase)
end

function NativeWindow.redraw(self, flags)
	self:invalidate();
	self:update();
	--[[
	local lprcUpdate = nil;	-- const RECT *
	local hrgnUpdate = nil; -- HRGN
	flags = flags or bor(ffi.C.RDW_UPDATENOW, ffi.C.RDW_INTERNALPAINT);

	local res = ffi.C.RedrawWindow(
  		self.Handle,
  		lprcUpdate,
   		hrgnUpdate,
  		flags);
--]]
	return true;
end

function NativeWindow.menuBar(self, params)
	local hMenuBar = menu.menubar(params)
	ffi.C.SetMenu(self.Handle, hMenuBar);
end

function NativeWindow.show(self, kind)
	kind = kind or ffi.C.SW_SHOWNORMAL;

	return ffi.C.ShowWindow(self.Handle, kind);
end

function NativeWindow.update(self)
	ffi.C.UpdateWindow(self.Handle)
end

function NativeWindow.getClientSize(self)
	local csize = ffi.new( "RECT[1]" )
	ffi.C.GetClientRect(self.Handle, csize);
	csize = csize[0]
	local width = csize.right-csize.left
	local height = csize.bottom-csize.top

	return width, height
end

function NativeWindow.getTitle(self)
	local buf = ffi.new("char[?]", 256)
	local lbuf = ffi.cast("intptr_t", buf)
	if ffi.C.SendMessageA(self.Handle, ffi.C.WM_GETTEXT, 255, lbuf) ~= 0 then
		return ffi.string(buf)
	end

	return nil;
end


return NativeWindow;
