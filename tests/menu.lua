package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local bit = require("bit")
local bor, band = bit.bor, bit.band

local winuser = require("win32.winuser")


local exports = {}

-- turn a set of parameters into a MENUITEMINFO struct
local function menuItem(params)
    local mItem = ffi.new("MENUITEMINFOA")
    mItem.cbSize = ffi.sizeof("MENUITEMINFOA")
        
    return mItem;
end

local function makeseparator(params)
    params = params or {}
    local mItem = menuItem();
    mItem.fMask = ffi.C.MIIM_FTYPE;
    mItem.fType = ffi.C.MFT_SEPARATOR;

    return mItem;
end

exports.separator = makeseparator();

function exports.command(params)
    --print("command: ", params.caption)
    if not params.caption then return nil end

    local mItem = menuItem();
    
    local caption = params.caption;
    if params.accel then
        caption = caption..'\t'..params.accel;
    end
    mItem.fMask = bor(ffi.C.MIIM_STRING, ffi.C.MIIM_ID);
    mItem.cch = #caption;
    mItem.dwTypeData = ffi.cast("char *", caption)
    mItem.wID = params.id or 0;

    return mItem;
end

function exports.menu(params)
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

function exports.menubar(params)
    local hMenuBar = ffi.C.CreateMenu();
--print("menubar, params: ", #params, params)

    local position=1;
    for i, item in ipairs(params) do
        ffi.C.InsertMenuItemA(hMenuBar, position, 1, item)
        position = position + 1;
    end

    return hMenuBar;
end

return exports