-- test_console.lua
package.path = "../?.lua;"..package.path;

local ffi = require("ffi");
local bit = require("bit");
local band = bit.band;
local bor = bit.bor;
local bxor = bit.bxor;

local core_string = require("experimental.apiset.string_l1_1_0");
require("win32.synchapi");

--local console = require("console");
local ConsoleWindow = require("ConsoleWindow");
--require("scheduler")


--[[
	Test Cases
--]]

local con, err = ConsoleWindow:CreateNew();
print("con: ", con, err)

--[[
con:setTitle("test_consolewindow");
con:setMode(0);
con:enableLineInput();
con:enableEchoInput();
con:enableProcessedInput();



local bufflen = 256;
local buff = ffi.new("char[?]", bufflen);

function main()
	while true do
		ffi.C.SleepEx(3000, true);
	
		local bytesread, err = con:ReadBytes(buff, bufflen);

		if bytesread then
			print("\b")
			--print(ffi.string(buff, bytesread));
		else
			print("Error: ", err);
		end
		--yield();
	end
end

main()
--run(main)
--]]