
local ffi = require("ffi");

local errorhandling = require("win32.core.errorhandling_l1_1_1");
local desktop_ffi = require("win32.desktop");
local core_process = require("win32.core.processthreads_l1_1_1");

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

	local rawhandle = desktop_ffi.CreateDesktopA(name, nil, nil, dwFlags, dwAccess, lpsa);
	if rawhandle == nil then
		return false, errorhandling.GetLastError();
	end

	return self:init(rawhandle, true);
end

function Desktop.open(self, name, dwFlags, fInherit, dwAccess)
	dwFlags = dwFlags or 0;
	fInherit = fInherit or false;
	dwAccess = dwAccess or 0;

	local rawhandle = desktop_ffi.OpenDesktop(name, dwFlags, fInherit, dwAccess);

	if rawhandle == nil then
		return false, errorhandling.GetLastError();
	end

	return self:init(rawhandle, true);
end

function Desktop.openThreadDesktop(self, threadid)
	threadid = threadid or core_process.GetCurrentThreadId();

	local rawhandle = desktop_ffi.GetThreadDesktop(threadid);

	if rawhandle == nil then
		return false, errorhandling.GetLastError();
	end

	return self:init(rawhandle, false);
end

function Desktop.desktopNames(self, winsta)
	winsta = winsta or desktop_ffi.GetProcessWindowStation()

	local desktops = {}


	function enumdesktop(desktopname, lParam)
		local name = ffi.string(desktopname)
		--print("Desktop: ", name)
		table.insert(desktops, name)

		return true
	end
	
	local cb = ffi.cast("DESKTOPENUMPROCA", enumdesktop);

	local result = desktop_ffi.EnumDesktopsA(winsta, cb, 0)
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
	local status = desktop_ffi.SwitchDesktop(self:getNativeHandle());
	if status == 0 then
		return false, errorhandling.GetLastError();
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
	local status = desktop_ffi.EnumDesktopWindows(self:getNativeHandle(), cb, 0);
	
	-- once done with the callback, free the resources
	cb:free();

	return wins;
end

return Desktop
