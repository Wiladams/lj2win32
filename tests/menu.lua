package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local bit = require("bit")

local winuser = require("win32.winuser")

local exports = {}


function exports.menu(params)
    params = params or {}
    local menu = ffi.C.CreateMenu();
    for idx, item in ipairs(params) do
    
    end

    print("Menu: ", menu)
end

function exports.submenu(params)
    
end

return exports
