local ffi = require("ffi")

require("win32.profileapi")

local function GetPerformanceFrequency(anum)
	anum = anum or ffi.new("int64_t[1]");
	local success = ffi.C.QueryPerformanceFrequency(anum)
	if success == 0 then
		return false;   --, errorhandling.GetLastError(); 
	end

	return tonumber(anum[0])
end

local function GetPerformanceCounter(anum)
	anum = anum or ffi.new("int64_t[1]")
	local success = ffi.C.QueryPerformanceCounter(anum)
	if success == 0 then 
		return false; --, errorhandling.GetLastError();
	end

	return tonumber(anum[0])
end

local function GetCurrentTickTime()
	local frequency = 1/GetPerformanceFrequency();
	local currentCount = GetPerformanceCounter();
	local seconds = currentCount * frequency;

	return seconds;
end


return {	
	getPerformanceCounter = GetPerformanceCounter,
	getPerformanceFrequency = GetPerformanceFrequency,
	getCurrentTickTime = GetCurrentTickTime,
	seconds = GetCurrentTickTime,
}

