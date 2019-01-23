package.path = "../?.lua;"..package.path;

require("scheduler")

local function main(msg)
    print(msg)
    halt();
end

run(main, "Hello, World!")
