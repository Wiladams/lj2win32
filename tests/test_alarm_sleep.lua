package.path = package.path..";../?.lua"

require("scheduler")


local function main()
	local starttime = runningTime();
	print("sleep(3525)");

	sleep(3525);

    local stopTime = runningTime();
    local duration = stopTime - starttime;

	print("Duration: ", duration);

	halt();
end

run(main)