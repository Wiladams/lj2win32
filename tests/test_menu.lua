package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local bit = require("bit")
local bor, band = bit.bor, bit.band

local graphicApp = require("graphicapp")
local winuser = require("win32.winuser")
local menu = require("menu")
local menubar, menu, separator, command = menu.menubar, menu.menu, menu.separator, menu.command



function setup()
    appWindow:menuBar {
        menu {"File";
            command {caption ="New File"};
            command {caption = "New Window"};
            separator;
            command {caption = "Open File"};
            command {caption = "Open Folder"};
            command {caption = "Open Workspace"};
            menu {
                "Open Recent";
                command {caption="Reopen Closed Editor"};
                separator;
                separator;
                separator;
                command {caption="More"};
                separator;
                command {caption="Close Recently Opened", accel="\tCtrl+R"};
            };
            separator;
            command {caption="Add Folder to Workspace"};
            command {caption="Save Workspace as..."};
            separator;
            command {caption="Save", id = 104};
            command {caption="Save As", id =105};
            command {caption="Save All", id = 106};
            separator;
            command {caption="Auto Save"};
        };
        
        menu {"Edit";
            command{caption="Undo", accel= "Ctrl+Z", ID=2};
            command{caption="Redo", accel = "Ctrl+Y", ID=3};
            separator;
            command {caption="Cut", accel="Ctrl+X", ID=3};
            command {caption="Copy", accel="Ctrl+C", ID=4};
            command {caption="Paste", accel="Ctrl+V", ID=5};
            separator;
            command {caption="Find", ID=6};
            command {caption="Replace", ID=7};
            separator;
            command {caption="Find in Files", ID=8};
            command {caption="Replace in Files", ID=9};
        }
    }

end


graphicApp.go({width=1024, height=768, title="test_menu"});