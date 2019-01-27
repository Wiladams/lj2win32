-- test_console.lua
local ffi = require("ffi");
local C = ffi.C 

local bit = require("bit");
local band = bit.band;
local bor = bit.bor;
local bxor = bit.bxor;


--local console = require("console");
--local core_string = require("experimental.apiset.string_l1_1_0");

require("win32.synchapi");
require("win32.consoleapi")
require("win32.consoleapi2")
require("win32.errhandlingapi")
require("win32.processenv")


local ConsoleWindow = {}
setmetatable(ConsoleWindow, {
	__call = function(self,...)
		return self:create(...);
	end,

})

-- Metatable for ConsoleWindow instances
local ConsoleWindow_mt = {
	__index = ConsoleWindow,
}

function ConsoleWindow.init(self, ...)
	local obj = {}
	setmetatable(obj, ConsoleWindow_mt);

	return obj;
end

function ConsoleWindow.create(self, ...)
	return self:init(...);
end

function ConsoleWindow.CreateNew(self, ...)
	-- Detach from current console if attached
	ffi.C.FreeConsole();


	-- Allocate new console
	local res = C.AllocConsole();

	if res == 0 then
		return false, C.GetLastError();
	end

	return ConsoleWindow();
end



--[[
	Input Mode attributes
--]]
ConsoleWindow.setMode = function(self, mode, handle)
	handle = handle or self:getStdIn();
	local status = core_console1.SetConsoleMode(handle, mode);

	if status == 0 then
		return false, error_handling.GetLastError();
	end

	return true;
end

ConsoleWindow.getMode = function(self, handle)
	handle = handle or self:getStdIn();
	local lpMode = ffi.new("DWORD[1]");
	local status = core_console1.GetConsoleMode(handle, lpMode);

	if status == 0 then
		return false, error_handling.GetLastError();
	end

	return lpMode[0];
end

ConsoleWindow.disableMode = function(self, mode, handle)
	handle = handle or self:getStdIn();

	-- get current input mode
	local currentmode = self:getMode();

	-- subtract out the desired mode
	mode = band(currentmode, bxor(mode));

	-- set the mode again
	return self:setMode(mode);
end

ConsoleWindow.enableMode = function(self, mode, handle)
	handle = handle or self:getStdIn();

	-- get current input mode
	local currentmode = self:getMode();

	-- add the desired mode
	mode = bor(currentmode, mode);

	-- set the mode again
	return self:setMode(mode);
end


ConsoleWindow.enableEchoInput = function(self)
	return self:enableMode(ffi.C.ENABLE_ECHO_INPUT);
end

ConsoleWindow.enableInsertMode = function(self)
	return self:enableMode(ffi.C.ENABLE_INSERT_MODE);
end

ConsoleWindow.enableLineInput = function(self)
	return self:enableMode(ffi.C.ENABLE_LINE_INPUT);
end

ConsoleWindow.enableLineWrap = function(self)
	return self:enableMode(ffi.C.ENABLE_WRAP_AT_EOL_OUTPUT, self:getStdOut());
end

ConsoleWindow.enableMouseInput = function(self)
	return self:enableMode(C.ENABLE_MOUSE_INPUT);
end

ConsoleWindow.enableProcessedInput = function(self)
	return self:enableMode(C.ENABLE_PROCESSED_INPUT);
end

ConsoleWindow.enableProcessedOutput = function(self)
	return self:enableMode(C.ENABLE_PROCESSED_OUTPUT, self:getStdOut());
end

ConsoleWindow.enableQuickEditMode = function(self)
	return self:enableMode(ffi.C.ENABLE_QUICK_EDIT_MODE);
end

ConsoleWindow.enableWindowEvents = function(self)
	return self:enableMode(ffi.C.ENABLE_WINDOW_INPUT);
end


--[[
	Get Standard I/O handles
--]]
ConsoleWindow.getStdOut = function(self)
	return processenviron.GetStdHandle(ffi.C.STD_OUTPUT_HANDLE);
end

ConsoleWindow.getStdIn = function(self)
	return processenviron.GetStdHandle(ffi.C.STD_INPUT_HANDLE);
end

ConsoleWindow.getStdErr = function(self)
	return processenviron.GetStdHandle(ffi.C.STD_ERROR_HANDLE);
end


ConsoleWindow.setTitle = function(self, title)
	--local lpConsoleTitle = core_string.toUnicode(title);

	local status = ffi.C.SetConsoleTitleA(title);
end

ConsoleWindow.ReadBytes = function(self, lpBuffer, nNumberOfCharsToRead, offset)
	local lpNumberOfCharsRead = ffi.new("DWORD[1]");

	local status = core_console1.ReadConsoleA(self:getStdIn(),
		lpBuffer, nNumberOfCharsToRead,
		lpNumberOfCharsRead, nil);

	if status == 0 then
		return error_handling.GetLastError();
	end

	return lpNumberOfCharsRead[0];
end

return ConsoleWindow
