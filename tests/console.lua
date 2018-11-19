--[[
	Provide some convenience to the various console api calls
]]

local ffi = require("ffi");
require("win32.consoleapi")
require("win32.consoleapi2")
require("win32.errhandlingapi")
require("win32.processenv")



local function AllocConsole()
	local res = ffi.C.AllocConsole();

	if res == 0 then
		return false, ffi.C.GetLastError();
	end

	return true;
end

local function GetConsoleCP()
	local res = ffi.C.GetConsoleCP();

	return res
end

local GetConsoleMode = function(hConsoleHandle)
	local lpMode = ffi.new("DWORD[1]");
	local res = ffi.C.GetConsoleMode(hConsoleHandle, lpMode);
	
	if res == 0 then
		return false, ffi.C.GetLastError();
	end

	return lpMode[0];
end

local GetConsoleOutputCP = function()
	local res = ffi.C.GetConsoleOutputCP();

	return res;
end

local GetNumberOfConsoleInputEvents = function(hConsoleInput)
	local lpNumberOfEvents = ffi.new("DWORD[1]");
	local res = ffi.C.GetNumberOfConsoleInputEvents(hConsoleInput,lpNumberOfEvents);

	if res == 0 then
		return false, ffi.C.GetLastError();
	end

	return lpNumberOfEvents[0];
end

local function PeekConsoleInputA(hConsoleInput, lpBuffer, nLength)
	local lpNumberOfEventsRead = ffi.new("DWORD[1]");
	local res = ffi.C.PeekConsoleInputA(
    	hConsoleInput,
    	lpBuffer,
    	nLength,
    	lpNumberOfEventsRead);

    if res == 0 then
    	return false, ffi.C.GetLastError();
    end

    return lpNumberOfEventsRead[0];
end

local function ReadConsole(hConsoleInput, lpBuffer, nNumberOfCharsToRead)
	local lpNumberOfCharsRead = ffi.new("DWORD[1]");

	local res = ffi.C.ReadConsoleA(
    	hConsoleInput,
    	lpBuffer,
    	nNumberOfCharsToRead,
    	lpNumberOfCharsRead,
    	pInputControl);

	if res == 0 then
		return false, ffi.C.GetLastError();
	end

	return lpNumberOfCharsRead[0];
end

local ReadConsoleInput = function(hConsoleInput, lpBuffer, nLength)

	local lpNumberOfEventsRead = ffi.new("DWORD[1]");

	local res = ffi.C.ReadConsoleInputA(hConsoleInput,
    	lpBuffer,
    	nLength,
    	lpNumberOfEventsRead);

    if res == 0 then
    	return false, ffi.C.GetLastError();
    end

    return lpNumberOfEventsRead[0];
end

local function SetConsoleCtrlHandler(HandlerRoutine, Add)
	local addin = 0;
	if Add then addin = 1; end

	Add = Add or false;
	local res = ffi.C.SetConsoleCtrlHandler(HandlerRoutine, addin);
	if res == 0 then
		return false, ffi.C.GetLastError();
	end

	return true;
end

local function SetConsoleMode(hConsoleHandle, dwMode)
	dwMode = dwMode or 0;
	local res = ffi.C.SetConsoleMode(hConsoleHandle, dwMode);
	if res == 0 then
		return false, ffi.C.GetLastError();
	end

	return true;
end

local WriteConsole = function(hConsoleOutput, lpBuffer, nNumberOfCharsToWrite)
	nNumberOfCharsToWrite = nNumberOfCharsToWrite or #lpBuffer;

	local lpNumberOfCharsWritten = ffi.new("DWORD[1]");
	local res =  ffi.C.WriteConsoleA(hConsoleOutput,
    	lpBuffer,
    	nNumberOfCharsToWrite,
     	lpNumberOfCharsWritten,
     	lpReserved);

     if res == 0 then
     	return false, ffi.C.GetLastError();
     end

     return lpNumberOfCharsWritten[0];
end

local function hwrite(handle, ...)
	handle = handle or ffi.C.GetStdHandle (ffi.C.STD_OUTPUT_HANDLE);

	local nargs = select('#',...);
	if nargs > 0 then
		for i=1,nargs do 
			WriteConsole (handle, tostring(select(i,...)));
		end 
	end
end

local function output(...)
	hwrite(nil, ...);
end




return {
	hwrite = hwrite,
	output = output,

	AllocConsole = AllocConsole,
	GetConsoleCP = GetConsoleCP,
	GetConsoleMode = GetConsoleMode,
	GetConsoleOutputCP = GetConsoleOutputCP,
	GetNumberOfConsoleInputEvents = GetNumberOfConsoleInputEvents,
	PeekConsoleInput = PeekConsoleInputA,
	ReadConsole = ReadConsoleA,
	ReadConsoleInput = ReadConsoleInputA,
	SetConsoleCtrlHandler = SetConsoleCtrlHandler,
	SetConsoleMode = SetConsoleMode,
	WriteConsole = WriteConsole,
}
