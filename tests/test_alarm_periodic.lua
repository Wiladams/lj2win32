
package.path = package.path..";../?.lua"

local scheduler = require("scheduler")


local function haltAfterTime(msecs)
	local function closure()
		print("READY TO HALT: ", msecs, runningTime());
		halt();
	end

	delay(msecs, closure);	-- halt after specified seconds
end

local function everyPeriod()
	print("PERIODIC: ", runningTime());
end

local function main()
	periodic(250, everyPeriod)
	haltAfterTime(5000);
end

run(main)
