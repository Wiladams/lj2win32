--[[
    A simple stopwatch.
    This stopwatch is independent of wall clock time.  It sets a relative
    start position whenever you call 'reset()'.
    
    The only function it serves is to tell you the number of seconds since
    the reset() method was called.
--]]

local timeticker = require("timeticker");



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
	local currentTime = timeticker.seconds();
	return currentTime - self.starttime;
end

function StopWatch.reset(self)
	self.starttime = timeticker.seconds();
end


return StopWatch
