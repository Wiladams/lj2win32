package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local bit = require("bit")
local bor, band, lshift, rshift = bit.bor, bit.band, bit.lshift, bit.rshift

local graphicApp = require("graphicapp")
local winuser = require("win32.winuser")
local wmmsgs = require("wm_reserved")
local menu = require("menu")
local menubar, menu, separator, command = menu.menubar, menu.menu, menu.separator, menu.command
local example_menus = require("example_menus")

local function HIWORD(val)
    return band(rshift(val, 16), 0xffff)
end

local function LOWORD(val)
    return band(val, 0xffff)
end

function onMessage(msg)
    --print(string.format("onMessage: 0x%x", msg.message), wmmsgs[msg.message])            
    if msg.message == ffi.C.WM_COMMAND then
        local msgSource = HIWORD(msg.wParam)
        local id = LOWORD(msg.wParam)
        print("Menu: ",msgSource, id);
    end

    -- report we're not processing this message
    return false;
end

function setup()
    --appWindow:menuBar(example_menus.vscode)
    appWindow:menuBar(example_menus.openscad)
end


graphicApp.go({width=1024, height=768, title="test_menu"});