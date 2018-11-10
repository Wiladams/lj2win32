--test_scheduler.lua
package.path = package.path..";../?.lua"


local sched = require("scheduler")

local idx = 0;
local maxidx = 20;


local function counter(name, nCount)
	for num=1, nCount do
		idx = num
		local eventName = name..tostring(idx);
		print(eventName, idx)
		signalOne(eventName);

		yield();
	end

	signalAll(name..'-finished')
end

local function every5()
	local lastidx = 0;
	
	while idx <= maxidx do
		waitForPredicate(function() return (idx % 5) == 0 end)
		if idx > lastidx then
			print("!! matched 5 !!")
			lastidx = idx;
			--yield();
		end
	end
end

local function test_whenever(modulus)
	local lastidx = 0;

	local function modulustest()
		--print("modulustest: ", idx, lastidx, maxidx)
		if idx > maxidx then
			return false;
		end

		if idx > lastidx then
			lastidx = idx;
			return (idx % modulus) == 0
		end
	end

	local t1 = whenever(modulustest, function() print("== EVERY: ", modulus) end)

	return t1;
end

local function main()
	local t1 = spawn(counter, "counter", maxidx)

	test_whenever(2);
	test_whenever(5);


	-- setup to call halt when counting is finished
	onSignal("counter-finished", halt)
end

run(main)
