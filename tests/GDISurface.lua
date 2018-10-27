    --[[
        A GDI Surface is simply something that you can draw on.
        It is implemented as a DIBSection, with an associated in-memory Device Context 
    ]]
local ffi = require("ffi")
local wingdi = require("win32.wingdi")
local DeviceContext = require("DeviceContext")
local DIBSection = require("DIBSection")

local GDISurface = {}
setmetatable(GDISurface, {
    __call = function(self, ...)
        return self:new(...)
    end
})
local GDISurface_mt = {
    __index = GDISurface;
}


function GDISurface.init(self, params)
    local obj = params or {}

    obj.width = obj.width or 1
    obj.height = obj.height or 1

    -- Create a memory device context, either compatible
    -- with something, or just compatible with DISPLAY
    obj.DC = DeviceContext:CreateForMemory(obj.compatDC)

    obj.pixmap = DIBSection(obj);
    setmetatable(obj, GDISurface_mt)

    -- select the object into the context so we're ready to draw
    local selected = obj.DC:SelectObject(obj.pixmap.Handle)

    return obj;
end

function GDISurface.new(self, ...)
    return self:init(...)
end


return GDISurface
