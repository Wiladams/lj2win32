
local ffi = require("ffi");
local C = ffi.C 

local errorhandling = require("win32.errhandlingapi");
local core_process = require("win32.processthreadsapi");
local wingdi = require("win32.wingdi")
local winuser = require("win32.winuser")

ffi.cdef[[
typedef struct {
	HDESK	Handle;
	bool	OwnAllocation;
} DesktopHandle;
]]

local DesktopHandle = ffi.typeof("DesktopHandle");
local DesktopHandle_mt = {
	__gc = function(self)
		if self.OwnAllocation then
			desktop_ffi.CloseDesktop(self.Handle);
		end
	end,
	
	__index = {
	},
}

local Desktop = {}
setmetatable(Desktop, {
	__call = function(self, ...)
		return self:create(...);
	end,
})
local Desktop_mt = {
	__index = Desktop;
}

function Desktop.init(self, rawhandle, ownit)
	ownit = ownit or false;
	local obj = {
		Handle = DesktopHandle(rawhandle, ownit)
	}
	setmetatable(obj, Desktop_mt);

	return obj;
end

function Desktop.create(self, name, dwFlags, dwAccess, lpsa)
	dwFlags = dwFlags or 0
	dwAccess = dwAccess or 0
	lpsa = lpsa or nil;

	local rawhandle = ffi.C.CreateDesktopA(name, nil, nil, dwFlags, dwAccess, lpsa);
	if rawhandle == nil then
		return false, ffi.C.GetLastError();
	end

	return self:init(rawhandle, true);
end

function Desktop.open(self, name, dwFlags, fInherit, dwAccess)
	dwFlags = dwFlags or 0;
	fInherit = fInherit or false;
	dwAccess = dwAccess or 0;

	local rawhandle = ffi.C.OpenDesktopA(name, dwFlags, fInherit, dwAccess);

	if rawhandle == nil then
		return false, ffi.C.GetLastError();
	end

	return self:init(rawhandle, true);
end

function Desktop.openThreadDesktop(self, threadid)
	threadid = threadid or C.GetCurrentThreadId();

	local rawhandle = ffi.C.GetThreadDesktop(threadid);

	if rawhandle == nil then
		return false, ffi.C.GetLastError();
	end

	return self:init(rawhandle, false);
end

function Desktop.desktopNames(self, winsta)
	winsta = winsta or ffi.C.GetProcessWindowStation()

	local desktops = {}


	function enumdesktop(desktopname, lParam)
		local name = ffi.string(desktopname)
		--print("Desktop: ", name)
		table.insert(desktops, name)

		return true
	end
	
	local cb = ffi.cast("DESKTOPENUMPROCA", enumdesktop);

	local result = ffi.C.EnumDesktopsA(winsta, cb, 0)
	cb:free();
	
	return desktops
end


--[[
	Instance Methods
--]]
function Desktop.getNativeHandle(self)
	return self.Handle.Handle;
end

function Desktop.makeActive(self)
	local status = ffi.C.SwitchDesktop(self:getNativeHandle());
	if status == 0 then
		return false, ffi.C.GetLastError();
	end

	return true;
end

function Desktop.getWindowHandles(self)
	local wins = {};

	--jit.off(enumwindows);
	local function enumwindows(hwnd, param)
		local key = tostring(hwnd);
		--print(key);
		wins[key]  = hwnd;
		return true;
	end

	local cb = ffi.cast("WNDENUMPROC", enumwindows);
	local status = ffi.C.EnumDesktopWindows(self:getNativeHandle(), cb, 0);
	
	-- once done with the callback, free the resources
	cb:free();

	return wins;
end

return Desktop
