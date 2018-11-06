local menu = require("menu")
local menubar, menu, separator, command = menu.menubar, menu.menu, menu.separator, menu.command

local exports = {}

exports.openscad = {
    menu {"File";
        command {caption="New", accel='Ctrl+N'};
        command {caption="Open...", accel='Ctrl+O'};
        menu {"Recent Files";
        };
        menu {"Examples";
            menu {"Basics";};
            menu {"Functions";};
            menu {"Advanced";};
            menu {"Old";};
        };
        command {caption="Reload", accel='Ctrl+R'};
        command {caption="Close", accel='Ctrl+W'};
        command {caption="Save", accel='Ctrl+S'};
        command {caption="Save As...", accel='Ctrl+Shift+S'};
        menu {"Export";
            command {caption = "Export as STL..."};
            command {caption = "Export as OFF..."};
            command {caption = "Export as AMF..."};
            command {caption = "Export as DXF..."};
            command {caption = "Export as SVG..."};
            command {caption = "Export as CSG..."};
            separator;
            command {caption = "Export as Image..."};
        };
        command {caption="Show Library Folder", accel=''};
        command {caption="Quit", accel=''};
    };
    menu {"Edit";
        command {caption = "Undo", accel='Ctrl+Z', id=200};
        command {caption = "Redo", accel='Ctrl+Shift+Z', id=201};
        separator;
        command {caption = "Cut", accel='Ctrl+X', id=202};
        command {caption = "Copy", accel='Ctrl+C', id=203};
        command {caption = "Paste", accel='Ctrl+V', id=204};
        separator;
        command {caption = "Indent", accel='Ctrl+I', id=205};
        command {caption = "Unindent", accel='Ctrl+Shift+I', id=206};
        command {caption = "Comment", accel='Ctrl+D', id=207};
        command {caption = "Uncomment", accel='Ctrl+Shift+D', id=208};
        command {caption = "Convert Tabs to Spaces", id=209};
        separator;
        command {caption = "Paste viewport translation", accel='Ctrl+T', id=210};
        command {caption = "Paste viewport rotation", accel='', id=211};
        separator;
        command {caption = "Find...", accel='Ctrl+F', id=212};
        command {caption = "Find and Replace...", accel='Ctrl+Alt+F', id=213};
        command {caption = "Find Next", accel='Ctrl+G', id=214};
        command {caption = "Find Previous", accel='Ctrl+Shift+G', id=215};
        command {caption = "Use Selection for Find", accel='Ctrl+E', id=216};
        separator;
        command {caption = "Increase Font Size", accel='Ctrl++', id=217};
        command {caption = "Decrease Font Size", accel='Ctrl--', id=218};
        command {caption = "Preferences", accel='', id=219};

    };
    menu {"Design";
        command {caption = "Automatic Reload and Preview", accel=''};
        command {caption = "Reload and Preview", accel='F4'};
        command {caption = "Preview", accel='F5'};
        command {caption = "Render", accel='F6'};
        separator;
        command {caption = "Check Validity", accel=''};
        command {caption = "Display AST...", accel=''};
        command {caption = "Display CSG Tree...", accel=''};
        command {caption = "Display CSG Products...", accel=''};
        separator;
        command {caption = "Flush Caches", accel=''};
    };
    menu {"View";
        command {caption = "Preview", accel='F9'};
        command {caption = "Surfaces", accel='F10'};
        command {caption = "Wireframe", accel='F11'};
        command {caption = "Thrown Together", accel='F12'};
        separator;
        command {caption = "Show Edges", accel='Ctrl+1'};
        command {caption = "Show Axes", accel='Ctrl+2'};
        command {caption = "Show Scale Markers", accel=''};
        command {caption = "Show Crosshairs", accel='Ctrl+3'};
        command {caption = "Animate", accel=''};
        separator;
        command {caption = "Top", accel='Ctrl+4'};
        command {caption = "Bottom", accel='Ctrl+5'};
        command {caption = "Left", accel='Ctrl+6'};
        command {caption = "Right", accel='Ctrl+7'};
        command {caption = "Front", accel='Ctrl+8'};
        command {caption = "Back", accel='Ctrl+9'};
        command {caption = "Diagonal", accel='Ctrl+0'};
        command {caption = "Center", accel=''};
        command {caption = "View All", accel=''};
        command {caption = "Reset View", accel=''};
        separator;
        command {caption = "Zoom In", accel='Ctrl+]'};
        command {caption = "Zoom Out", accel='Ctrl+['};
        separator;
        command {caption = "Perspective", accel=''};
        command {caption = "Orthogonal", accel=''};
        separator;
        command {caption = "Hide toolbars", accel=''};
        command {caption = "Hide editor", accel=''};
        command {caption = "Hide console", accel=''};
    };
    
    menu {"Help";
        command {caption = "About", accel=""};
        command {caption = "OpenSCAD Homepage"};
        command {caption = "Documentation"};
        command {caption = "Cheat Sheet"};
        command {caption = "Library Info"};
        command {caption = "Font List"};
    };

}


exports.vscode = {
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
        separator;
        command {caption = "Exit"};
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

return exports