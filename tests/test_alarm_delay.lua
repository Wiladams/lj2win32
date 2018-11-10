package.path = "../?.lua;"..package.path

local scheduler = require("scheduler")


local function twoSeconds()
	print("TWO SECONDS: ", runningTime());
	halt();
end

local function main()
	print("delay(2000, twoSeconds)");
	delay(2000, twoSeconds);
	print("still going")
end

run(main)