package.path = "../?.lua;"..package.path;

local graphicApp = require("graphicapp")

local GDICommander = require("GDICommander")
local StopWatch = require("stopwatch")

local commander = GDICommander();
local swatch = StopWatch();

function setup()
    swatch:reset();
    commander:start();
    commander:send("START: ", ticker.seconds())
end

local counter = 0;

function loop()
    counter = counter + 1;
    if counter > 5001 then
        commander:send("QUIT")
    else
        commander:send(string.format("%3.4f", swatch:seconds()), "COMMAND"..tostring(counter))
    end
end

graphicApp.go({width=320, height=240, title="test_gdicommander"});
