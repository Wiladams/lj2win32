package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local bit = require("bit")
local bor, band = bit.bor, bit.band

local graphicApp = require("graphicapp")
local winuser = require("win32.winuser")
local menu = require("menu")
local menubar, menu, separator, command = menu.menubar, menu.menu, menu.separator, menu.command
local example_menus = require("example_menus")


function setup()
    --appWindow:menuBar(example_menus.vscode)
    appWindow:menuBar(example_menus.openscad)
end


graphicApp.go({width=1024, height=768, title="test_menu"});