package.path = "../?.lua;"..package.path;

local graphicApp = require("graphicapp")

local GDICommander = require("GDICommander")

local commander = GDICommander();

function setup()
    commander:start();
    commander:send("START")
end

local counter = 0;

function loop()
    counter = counter + 1;
    if counter == 101 then
        commander:send("QUIT")
    else
        commander:send("COMMAND"..tostring(counter))
    end
end

graphicApp.go({width=320, height=240, title="test_gdicommander"});
