--[[
	This is a pure lua scheduler.  It is used
	to coordinate multiple lua coroutines.

	require("scheduler")

	It will automatically pollute your global
	namespace with new keywords:
	Kernel
	halt, run, coop, spawn, suspend, yield
	onSignal, signalAll, signalAllImmediate, signalOne, waitForSignal

	With this base of spawning, and signaling, fairly complex
	cooperative multi-tasking can be constructed.
]]

local ffi = require("ffi")
local profileapi = require("win32.profileapi")

local floor = math.floor;
local insert = table.insert;


--[[
squeue

The squeue is a simple data structure that represents a 
first in first out behavior.
--]]

local squeue = {}
setmetatable(squeue, {
	__call = function(self, ...)
		return self:create(...);
	end,
});

local Queue_mt = {
	__index = squeue;
}

function squeue.init(self, first, last, name)
	first = first or 1;
	last = last or 0;

	local obj = {
		first=first, 
		last=last, 
		name=name};

	setmetatable(obj, Queue_mt);

	return obj
end

function squeue.create(self, first, last, name)
	first = first or 1
	last = last or 0

	return self:init(first, last, name);
end

function squeue:pushFront(value)
	-- PushLeft
	local first = self.first - 1;
	self.first = first;
	self[first] = value;
end

function squeue:pinsert(value, fcomp)
	binsert(self, value, fcomp)
	self.last = self.last + 1;
end

function squeue:enqueue(value)
	--self.MyList:PushRight(value)
	local last = self.last + 1
	self.last = last
	self[last] = value

	return value
end

function squeue:dequeue()
	-- return self.MyList:PopLeft()
	local first = self.first

	if first > self.last then
		return nil, "list is empty"
	end
	
	local value = self[first]
	self[first] = nil        -- to allow garbage collection
	self.first = first + 1

	return value	
end

function squeue:length()
	return self.last - self.first+1
end

-- Returns an iterator over all the current 
-- values in the queue
function squeue:Entries(func, param)
	local starting = self.first-1;
	local len = self:length();

	local closure = function()
		starting = starting + 1;
		return self[starting];
	end

	return closure;
end



local function fcomp_default( a,b ) 
   return a < b 
end

local function getIndex(t, value, fcomp)
   local fcomp = fcomp or fcomp_default

   local iStart = 1;
   local iEnd = #t;
   local iMid = 1;
   local iState = 0;

   while iStart <= iEnd do
      -- calculate middle
      iMid = floor( (iStart+iEnd)/2 );
      
      -- compare
      if fcomp( value,t[iMid] ) then
            iEnd = iMid - 1;
            iState = 0;
      else
            iStart = iMid + 1;
            iState = 1;
      end
   end

   return (iMid+iState);
end

local function binsert(tbl, value, fcomp)
   local idx = getIndex(tbl, value, fcomp);
   insert( tbl, idx, value);
   
   return idx;
end

--[[
    A simple stopwatch.
    This stopwatch is independent of wall clock time.  It sets a relative
    start position whenever you call 'reset()'.
    
    The only function it serves is to tell you the number of seconds since
    the reset() method was called.
--]]



local function GetPerformanceFrequency(anum)
	anum = anum or ffi.new("int64_t[1]");
	local success = ffi.C.QueryPerformanceFrequency(anum)
	if success == 0 then
		return false;   --, ffi.C.GetLastError(); 
	end

	return tonumber(anum[0])
end

local function GetPerformanceCounter(pnum)
	pnum = pnum or ffi.new("int64_t[1]")
	local success = ffi.C.QueryPerformanceCounter(pnum)
	if success == 0 then 
		return false; --, ffi.C.GetLastError();
	end

	return tonumber(pnum[0])
end

local function GetCurrentTickTime()
	local pnum = ffi.new("int64_t[1]")

	local frequency = 1/GetPerformanceFrequency(pnum);
	local currentCount = GetPerformanceCounter(pnum);
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




--[[
	Task, contains stuff related to encapsulated code
--]]
local Task = {}

setmetatable(Task, {
	__call = function(self, ...)
		return self:create(...);
	end,
});

local Task_mt = {
	__index = Task,
}

function Task.init(self, aroutine, ...)

	local obj = {
		routine = coroutine.create(aroutine), 
	}
	setmetatable(obj, Task_mt);
	
	obj:setParams({...});

	return obj
end

function Task.create(self, aroutine, ...)
	-- The 'aroutine' should be something that is callable
	-- either a function, or a table with a meta '__call'
	-- implementation.  Checking with type == 'function'
	-- is not good enough as it will miss the meta __call cases

	return self:init(aroutine, ...)
end


function Task.getStatus(self)
	return coroutine.status(self.routine);
end

-- A function that can be used as a predicate
function Task.isFinished(self)
	return self:getStatus() == "dead"
end


function Task.setParams(self, params)
	self.params = params

	return self;
end

function Task.cancel(self)
end

function Task.resume(self)
--print("Task, RESUMING: ", unpack(self.params));
	return coroutine.resume(self.routine, unpack(self.params));
end



--[[
	Scheduler, the heart of the kernel
]]
local Scheduler = {}
setmetatable(Scheduler, {
	__call = function(self, ...)
		return self:create(...)
	end,
})
local Scheduler_mt = {
	__index = Scheduler,
}

function Scheduler.init(self, ...)
	local obj = {
		TasksReadyToRun = squeue();
	}
	setmetatable(obj, Scheduler_mt)
	
	return obj;
end

function Scheduler.create(self, ...)
	return self:init(...)
end

--[[
	tasksPending

	A simple method to let anyone know how many tasks are currently
	on the ready to run list.

	This might be useful when you're running some predicate logic based 
	on how many tasks there are.
--]]
function Scheduler.tasksPending(self)
	return self.TasksReadyToRun:length();
end

-- put a task on the ready list
-- the 'task' should be something that can be executed,
-- whether it's a function, functor, or something that has a '__call'
-- metamethod implemented.
-- The 'params' is a table of parameters which will be passed to the task
-- when it's ready to run.
function Scheduler.scheduleTask(self, task, params, priority)
	--print("Scheduler.scheduleTask: ", task, params)
	params = params or {}
	
	if not task then
		return false, "no task specified"
	end

	task:setParams(params);
	

	if priority == 0 then
		self.TasksReadyToRun:pushFront(task);	
	else
		self.TasksReadyToRun:enqueue(task);	
	end

	task.state = "readytorun"

	return task;
end

function Scheduler.removeTask(self, task)
	return true;
end

function Scheduler.getCurrentTask(self)
	return self.CurrentFiber;
end

function Scheduler.suspendCurrentTask(self, ...)
	self.CurrentFiber.state = "suspended"
end

function Scheduler.step(self)
	-- see if there's a task that's ready to run
	local task = self.TasksReadyToRun:dequeue()

	-- If no task is in the ready queue, just return
	if not task then
		return true
	end

	-- if the task is already dead, then just
	-- keep it out of the ready list, and return
	if task:getStatus() == "dead" then
		self:removeTask(task)
		return true;
	end

	-- If the task we pulled off the ready list is 
	-- not dead, then perhaps it is suspended.  If that's true
	-- then it needs to drop out of the ready list.
	-- We assume that some other part of the system is responsible for
	-- keeping track of the task, and rescheduling it when appropriate.
	if task.state == "suspended" then
		return true;
	end

	-- If we have gotten this far, then the task truly is ready to 
	-- run, and it should be set as the currentFiber, and its coroutine
	-- is resumed.
	self.CurrentFiber = task;
	local results = {task:resume()};

	-- once we get results back from the resume, one
	-- of the following things could have happened.
	-- 1) The routine exited normally
	-- 2) The routine yielded
	-- 3) The routine threw an error
	--
	-- In all cases, we parse out the results of the resume 
	-- into a success indicator and the rest of the values returned 
	-- from the routine
	local success = results[1];
	table.remove(results,1);

	-- no task is currently executing
	self.CurrentFiber = nil;

	if not success then
		print("RESUME ERROR")
		print(unpack(results));
	end

	-- Again, check to see if the task is dead after
	-- the most recent resume.  If it's dead, then don't
	-- bother putting it back into the readytorun queue
	-- just remove the task from the list of tasks
	if task:getStatus() == "dead" then
		self:removeTask(task)

		return true;
	end

	-- The only way the task will get back onto the readylist
	-- is if it's state is 'readytorun', otherwise, it will
	-- stay out of the readytorun list.
	if task.state == "readytorun" then
		self:scheduleTask(task, results);
	end
end

Kernel = {
	ContinueRunning = true;
	TaskID = 0;
	Scheduler = Scheduler();
	TasksSuspendedForSignal = {};
}
local Kernel = Kernel;


local function getNewTaskID()
	Kernel.TaskID = Kernel.TaskID + 1;
	return Kernel.TaskID;
end

local function getCurrentTask()
	return Kernel.Scheduler:getCurrentTask();
end

local function getCurrentTaskID()
	return getCurrentTask().TaskID;
end


local function inMainTask()
	return coroutine.running() == nil; 
end

local function coop(priority, func, ...)
	local task = Task(func, ...)
	task.TaskID = getNewTaskID();
	task.Priority = priority;
	return Kernel.Scheduler:scheduleTask(task, {...}, priority);
end

local function spawn(func, ...)
	return coop(100, func, ...);
end

local function yield(...)
	return coroutine.yield(...);
end

local function suspend(...)
	Kernel.Scheduler:suspendCurrentTask();
	return yield(...)
end


local function signalTasks(eventName, priority, allofthem, ...)
	local tasklist = Kernel.TasksSuspendedForSignal[eventName];

	if not  tasklist then
		return false, "event not registered", eventName
	end

	local nTasks = #tasklist
	if nTasks < 1 then
		return false, "no tasks waiting for event"
	end

	if allofthem then
		--local allparams = {...}
		--print("allparams: ", allparams, #allparams)
		for i=1,nTasks do
			Kernel.Scheduler:scheduleTask(tasklist[1],{...}, priority);
			table.remove(tasklist, 1);
		end
	else
		Kernel.Scheduler:scheduleTask(tasklist[1],{...}, priority);
		table.remove(tasklist, 1);
	end

	return true;
end

local function signalOne(eventName, ...)
	return signalTasks(eventName, 100, false, ...)
end

local function signalOneImmediate(eventName, ...)
	return signalTasks(eventName, 0, false, ...)
end

local function signalAll(eventName, ...)
	return signalTasks(eventName, 100, true, ...)
end

local function signalAllImmediate(eventName, ...)
	return signalTasks(eventName, 0, true, ...)
end

local function waitForSignal(eventName,...)
	local currentFiber = Kernel.Scheduler:getCurrentTask();

	if currentFiber == nil then
		return false, "not currently in a running task"
	end

	if not Kernel.TasksSuspendedForSignal[eventName] then
		Kernel.TasksSuspendedForSignal[eventName] = {}
	end

	table.insert(Kernel.TasksSuspendedForSignal[eventName], currentFiber);

	return suspend(...)
end


-- One shot signal activation
local function onSignal(sigName, func)
	local function watchit(sigName, func)
		func(waitForSignal(sigName));
	end

	local res = coop(0, watchit, sigName, func);
	yield();

	return res
end

-- continuous signal activation
local function on(sigName, func)
	if not func then
		return false;
	end

	local function watchit(sigName, func)
		while true do
			func(waitForSignal(sigName))
		end
	end

	local res = coop(0, watchit, sigName, func);
	yield();
	
	return res;
end

--[[
	predicates
	
	Predicates are a new form of cooperative flow control.
	The routines essentially wrap basic signaling with convenient words
	and spawning operations.

	The fundamental building block is the 'predicate', which is nothing more
	than a function which returns a boolean value.

	The typical usage will be to block a task with 'waitForPredicate', which will
	suspend the current task until the specified predicate returns a value of 'true'.
	It will then be resumed from that point.

	waitForPredicate
	signalOnPredicate
	when
	whenever
--]]


local function signalOnPredicate(pred, signalName)
	local function closure(lpred)
		local res = nil;
		repeat
			res = lpred();
			if res then 
				return signalAllImmediate(signalName, res) 
			end;

			yield();
		until res == nil
	end

	return spawn(closure, pred)
end

local function waitForPredicate(pred)
	local signalName = "predicate-"..tostring(getCurrentTaskID());
	signalOnPredicate(pred, signalName);
	return waitForSignal(signalName);
end

local function when(pred, func)
	local function closure(lpred, lfunc)
		lfunc(waitForPredicate(lpred))
	end

	return spawn(closure, pred, func)
end

local function whenever(pred, func)
	local function closure(lpred, lfunc)
		local signalName = "whenever-"..tostring(getCurrentTaskID());
		local res = true;
		repeat
			signalOnPredicate(lpred, signalName);
			res = waitForSignal(signalName);
			lfunc(res)
		until false
	end

	return spawn(closure, pred, func)
end

--[[
	Alarm Clock

	These routines implement time based flow control
]]

local	SignalsWaitingForTime = {};
local	SignalWatch = StopWatch();

local function runningTime()
	return SignalWatch:seconds();
end

local function compareDueTime(task1, task2)
	if task1.DueTime < task2.DueTime then
		return true
	end
	
	return false;
end


function waitUntilTime(atime)
	-- create a signal
	local taskID = getCurrentTaskID();
	local signalName = "sleep-"..tostring(taskID);
	local fiber = {DueTime = atime, SignalName = signalName};

	-- put time/signal into list so watchdog will pick it up
	binsert(SignalsWaitingForTime, fiber, compareDueTime)

	-- put the current task to wait on signal
	waitForSignal(signalName);
end

-- suspend the current task for the 
-- specified number of milliseconds
local function sleep(millis)
	-- figure out the time in the future
	local currentTime = SignalWatch:seconds();
	local futureTime = currentTime + (millis / 1000);
	
	return waitUntilTime(futureTime);
end

local function delay(millis, func)
	millis = millis or 1000

	local function closure()
		sleep(millis)
		func();
	end

	return spawn(closure)
end

local function periodic(millis, func)
	millis = millis or 1000

	local function closure()
		while true do
			sleep(millis)
			func();
		end
	end

	return spawn(closure)
end

-- The routine task which checks the list of waiting tasks to see
-- if any of them need to be signaled to wakeup
local function alarm_taskReadyToRun()
	local currentTime = SignalWatch:seconds();
	
	-- traverse through the fibers that are waiting
	-- on time
	local nAwaiting = #SignalsWaitingForTime;

	for i=1,nAwaiting do
		local task = SignalsWaitingForTime[1]; 
		if not task then
			return false;
		end

		if task.DueTime <= currentTime then
			return task
		else
			return false
		end
	end

	return false;
end

local function alarm_runTask(task)
	signalOneImmediate(task.SignalName);
	table.remove(SignalsWaitingForTime, 1);
end




--[[
	Main kernel control routines
]]

local function run(func, ...)

	if func ~= nil then
		spawn(func, ...)
	end

	while (Kernel.ContinueRunning) do
		Kernel.Scheduler:step();		
		-- This is a global variable because These routines
		-- MUST be a singleton within a lua state
		--Alarm = whenever(alarm_taskReadyToRun, alarm_runTask)
		local alarmTask = alarm_taskReadyToRun()
		if alarmTask then
			alarm_runTask(alarmTask)
		end
	end
end

local function halt(self)
	Kernel.ContinueRunning = false;
end

local function globalizeKernel(tbl)
	tbl = tbl or _G;

	rawset(tbl, "Kernel", Kernel);

	-- task management
	rawset(tbl,"halt", halt);
	rawset(tbl,"run", run);
	rawset(tbl,"coop", coop);
	rawset(tbl,"spawn", spawn);
	rawset(tbl,"suspend", suspend);
	rawset(tbl,"yield", yield);

	-- signaling
	rawset(tbl,"signalAll", signalAll);
	rawset(tbl,"signalAllImmediate", signalAllImmediate);
	rawset(tbl,"signalOne", signalOne);
	rawset(tbl,"waitForSignal", waitForSignal);
	rawset(tbl,"onSignal", onSignal);
	rawset(tbl,"on", on);

	-- predicates
	rawset(tbl,"signalOnPredicate", signalOnPredicate);
	rawset(tbl,"waitForPredicate", waitForPredicate);
	rawset(tbl,"when", when);
	rawset(tbl,"whenever", whenever);

	-- alarm clock
	rawset(tbl,"delay",delay);
	rawset(tbl,"periodic",periodic);
	rawset(tbl,"runningTime",runningTime);
	rawset(tbl,"sleep",sleep);

	-- extras
	rawset(tbl,"getCurrentTaskID", getCurrentTaskID);

	return tbl;
end

local global = globalizeKernel();

return Kernel