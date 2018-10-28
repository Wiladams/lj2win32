package.path = "../?.lua;"..package.path;

local graphicApp = require("graphicapp")
local dsignaler = require("drawsignaler")

local function grandHandler(event)
    print("HANDLER: ", event.command)
end

function setup()
    for k,v in pairs(dsignaler.marshalers) do
        print("signal: ", k)
        if type(v)=='function' then
            on('draw_'..k, grandHandler)
        end
    end
    yield();

    dsignaler.clear();
    dsignaler.noFill();
    dsignaler.background(123)
end



graphicApp.go({title="test_drawsignaler"});
