package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local bit = require("bit")
local bor, band = bit.bor, bit.band

local graphicApp = require("graphicapp")
local winuser = require("win32.winuser")


-- turn a set of parameters into a MENUITEMINFO struct
local function menuItem(params)
    local mItem = ffi.new("MENUITEMINFOA")
    mItem.cbSize = ffi.sizeof("MENUITEMINFOA")
    
    
    return mItem;
end

local function separator(params)
    local mItem = menuItem();
    mItem.fMask = ffi.C.MIIM_FTYPE;
    mItem.fType = ffi.C.MFT_SEPARATOR;

    return mItem;
end

local function command(params)
    --print("command: ", params.caption)
    local mItem = menuItem();
    mItem.fMask = bor(ffi.C.MIIM_STRING, ffi.C.MIIM_ID);
    mItem.cch = #params.caption;
    mItem.dwTypeData = ffi.cast("char *", params.caption)
    mItem.wID = params.ID or 0;

    return mItem;
end

local function menu(params)
    local hMenu = ffi.C.CreatePopupMenu();
    local mItem = menuItem();
    mItem.fMask = bor(ffi.C.MIIM_SUBMENU, ffi.C.MIIM_STRING);
    mItem.hSubMenu = hMenu;

    local position = 1;
    for i, item in ipairs(params) do
        --print(type(item), item)
        if type(item) == 'string' then
            mItem.dwTypeData = ffi.cast("char *",item);
        else
            --print("insert: ", item)
            ffi.C.InsertMenuItemA(hMenu, position, 1, item)
        end

        position = position + 1;
    end

    return mItem;
end

local function menubar(params)
    local hMenuBar = ffi.C.CreateMenu();
--print("menubar, params: ", #params, params)

    local position=1;
    for i, item in ipairs(params) do
        ffi.C.InsertMenuItemA(hMenuBar, position, 1, item)
        position = position + 1;
    end

    return hMenuBar;
end

--[[
        local uFlags = MF_STRING;

    local hMenuBar = ffi.C.CreateMenu();
    local fileMenu = ffi.C.CreateMenu();
    
    local hOpenRecent = ffi.C.CreatePopupMenu();
    ffi.C.AppendMenuA(hOpenRecent, ffi.C.MF_STRING, 101, "Reopen Closed Editor")
    ffi.C.AppendMenuA(hOpenRecent, ffi.C.MF_SEPARATOR, 103, "")
    ffi.C.AppendMenuA(hOpenRecent, ffi.C.MF_SEPARATOR, 103, "")
    ffi.C.AppendMenuA(hOpenRecent, ffi.C.MF_SEPARATOR, 103, "")
    ffi.C.AppendMenuA(hOpenRecent, ffi.C.MF_STRING, 101, "More")
    ffi.C.AppendMenuA(hOpenRecent, ffi.C.MF_SEPARATOR, 103, "")
    ffi.C.AppendMenuA(hOpenRecent, ffi.C.MF_STRING, 101, "&Close Recently Opened\tCtrl+R")


    ffi.C.AppendMenuA(fileMenu, ffi.C.MF_STRING, 101, "&New File\tCtrl+N")
    ffi.C.AppendMenuA(fileMenu, ffi.C.MF_STRING, 102, "New Window")
    ffi.C.AppendMenuA(fileMenu, ffi.C.MF_SEPARATOR, 103, "")
    ffi.C.AppendMenuA(fileMenu, ffi.C.MF_STRING, 104, "Open File")
    ffi.C.AppendMenuA(fileMenu, ffi.C.MF_STRING, 104, "Open Folder")
    ffi.C.AppendMenuA(fileMenu, ffi.C.MF_STRING, 104, "Open Workspace")
    ffi.C.AppendMenuA(fileMenu, ffi.C.MF_POPUP, ffi.cast("UINT_PTR", hOpenRecent), "Open Recent")
    ffi.C.AppendMenuA(fileMenu, ffi.C.MF_SEPARATOR, 103, "")
    ffi.C.AppendMenuA(fileMenu, ffi.C.MF_STRING, 104, "Add Folder to Workspace")
    ffi.C.AppendMenuA(fileMenu, ffi.C.MF_STRING, 104, "Save Workspace As")
    ffi.C.AppendMenuA(fileMenu, ffi.C.MF_SEPARATOR, 103, "")
    ffi.C.AppendMenuA(fileMenu, ffi.C.MF_STRING, 104, "Save")
    ffi.C.AppendMenuA(fileMenu, ffi.C.MF_STRING, 104, "Save As")
    ffi.C.AppendMenuA(fileMenu, ffi.C.MF_STRING, 104, "Save All")
    ffi.C.AppendMenuA(fileMenu, ffi.C.MF_SEPARATOR, 103, "")
    ffi.C.AppendMenuA(fileMenu, ffi.C.MF_STRING, 104, "Auto Save")
    ffi.C.AppendMenuA(hMenuBar, ffi.C.MF_POPUP, ffi.cast("UINT_PTR", fileMenu), "File")

]]


function setup()
    hMenuBar = menubar {
        menu {
            "File";
            command {caption ="New File"};
            command {caption = "New Window"};
            separator {};
            command {caption = "Open File"};
            command {caption = "Open Folder"};
            command {caption = "Open Workspace"};
            menu {
                "Open Recent";
                command {caption="Reopen Closed Editor"};
                separator {};
                separator {};
                separator {};
                command {caption="More"};
                separator {};
                command {caption="Close Recently Opened\tCtrl+R"};
            };
            separator {};
            command {caption="Add Folder to Workspace"};
            command {caption="Save Workspace as..."};
        };
        menu {
            "Edit";
            command{caption="Undo\tCtrl+Z", ID=2};
            command{caption="Redo\tCtrl+Y", ID=3};
            separator{};
            command {caption="Cut\tCtrl+X", ID=3};
            command {caption="Copy\tCtrl+C", ID=4};
            command {caption="Paste\tCtrl+V", ID=5};
            separator{};
            command {caption="Find", ID=6};
            command {caption="Replace", ID=7};
            separator{};
            command {caption="Find in Files", ID=8};
            command {caption="Replace in Files", ID=9};
        }
    }

    ffi.C.SetMenu(appWindow.Handle.Handle, hMenuBar);
end


graphicApp.go({width=1024, height=768, title="test_menu"});