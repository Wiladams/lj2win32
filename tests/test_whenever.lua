local sched = require("scheduler")

local function onBigSignal(params)
    print("onBigSignal: ", params)
end


whenever("count", onBigSignal)

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