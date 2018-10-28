package.path = "../?.lua;"..package.path;

local graphicApp = require("graphicapp")
local dsignaler = require("drawsignaler")
local drawreactor = require("drawreactor")

local reactor =false;


function setup()
    reactor = drawreactor(dsignaler, surface);

    yield();
    dsignaler.clear();
    dsignaler.noFill();
    dsignaler.background(123)
end



graphicApp.go({title="test_drawreactor"});
