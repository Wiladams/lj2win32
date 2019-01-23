--test_predicate_when.lua
package.path = package.path..";../?.lua"


local scheduler = require("scheduler")

local idx = 0;
local maxidx = 20;


local function counter(name, nCount)
	for num=1, nCount do
		idx = num
		local eventName = name..tostring(idx);
		print(eventName, idx)

		yield();
	end
end


local function countingFinished()
	return idx >= maxidx;
end

local function main()
	local t1 = spawn(counter, "counter", 100)

	when(countingFinished, halt)
end

run(main)