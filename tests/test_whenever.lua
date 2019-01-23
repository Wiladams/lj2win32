package.path = "../?.lua;"..package.path;

local sched = require("scheduler")

local function onBigSignal(params)
    print("onBigSignal: ", params)
end


onSignal("count", onBigSignal)

local function main()
    signalAll("count", 1);
    yield();
    signalAll("count", 2);
    yield();
    
    while true do
        yield();
    end        
end

run(main)