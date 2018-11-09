--[[
    A simple stopwatch.
    This stopwatch is independent of wall clock time.  It sets a relative
    start position whenever you call 'reset()'.
    
    The only function it serves is to tell you the number of seconds since
    the reset() method was called.
--]]

local ffi = require("ffi")
local profileapi = require("win32.profileapi")

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


local StopWatch = {}
setmetatable(StopWatch, {
	__call = function(self, ...)
		return self:new(...);
	end;

})

local StopWatch_mt = {
	__index = StopWatch;
}

function StopWatch.init(self, obj)
    obj = obj or {
        starttime = 0;
    }

	setmetatable(obj, StopWatch_mt);
	obj:reset();

	return obj;
end

function StopWatch.new(self, ...)
	return self:init(...);
end

function StopWatch.seconds(self)
	local currentTime = GetCurrentTickTime();
	return currentTime - self.starttime;
end

function StopWatch.millis(self)
	return self:seconds()*1000;
end

function StopWatch.reset(self)
	self.starttime = GetCurrentTickTime();
end


return StopWatch
