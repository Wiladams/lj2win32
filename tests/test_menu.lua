package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
--local bit = require("bit")
--local bor, band, lshift, rshift = bit.bor, bit.band, bit.lshift, bit.rshift

local graphicApp = require("graphicapp")
local example_menus = require("example_menus")



function onCommand(cmd)
    print("onCommand: ", cmd.source, cmd.id)
end


function setup()
    --appWindow:menuBar(example_menus.vscode)
    appWindow:menuBar(example_menus.openscad)
end


graphicApp.go({width=1024, height=768, title="test_menu"});