package.path = "../?.lua;"..package.path;

local stopwatch = require "stopwatch"

local st = stopwatch();

for i=1,1000 do
    print(i)
end

print("seconds: ", st:seconds())