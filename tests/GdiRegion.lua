local ffi = require("ffi")
local C = ffi.C

require("win32.sdkddkver")
require("win32.wingdi")


ffi.cdef[[
typedef struct RegionHandle_t {
    HRGN Handle;
} RegionHandle
]]
local RegionHandle = ffi.typeof("RegionHandle")

local RegionHandle_mt = {
    __index = GdiRegion;

    __new = function(ct, ...)
        local obj = ffi.new(ct, ...)
        return obj;
    end;

    __eq = function(lhs, rhs)
        local res = C.EqualRgn(lhs.Handle, rhs.Handle);
        return res ~= 0
    end;

    __add = function(lhs, rsh)
        -- create new region
        local dstRegion = C.CreateRectRgn(0,0,0,0)

        local res = C.CombineRgn(dstRegion, lhs.Handle, rhs.Handle, C.RGN_OR)
        return RegionHandle(dstRegion)
    end;

    __sub = function(lhs, rsh)
        -- create new region
        local dstRegion = C.CreateRectRgn(0,0,0,0)

        local res = C.CombineRgn(dstRegion, lhs.Handle, rhs.Handle, C.RGN_DIFF)
        return RegionHandle(dstRegion)
    end;
}
ffi.metatype("RegionHandle", RegionHandle_mt)

--[[
setmetatable(GdiRegion, {
    __call = function(self, ...)
        return self:new(...)
    end
})
local GdiRegion_mt = {
    __index = GdiRegion;
}

function GdiRegion.init(self, rawhandle)
    local obj = {
        Handle = ffi.new("RegionHandle")
    }
    setmetatable(obj, GdiRegion_mt)

    return obj
end

function GdiRegion.new(self, rawhandle)
    return self:init(rawhandle)
end
--]]

local GdiRegion = {}

function GdiRegion.CreatePolygonRgn(self, pptl, cPoint, iMode)
    local rgn = C.CreatePolygonRgn(pptl, cPoint, iMode)
    if rgn == nil then
        return nil;
    end

    return RegionHandle(rgn)
end

function GdiRegion.CreateRectRgn(self, x1, y1, x2, y2)
    local rgn = C.CreateRectRgn(x1,y1,x2,y2)
    if rgn == nil then
        return nil;
    end

    return RegionHandle(rgn)
end

function GdiRegion.CreateRectRgnIndirect(self, lprect)
    local rgn = C.CreateRectRgnIndirect(lprect)
    if rgn == nil then
        return nil;
    end

    return RegionHandle(rgn)
end

function GdiRegion.CreateRoundRectRgnIndirect(self, x1, y1, x2, y2, w, h)
    local rgn = C.CreateRoundRectRgnIndirect(x1, y1, x2, y2, w, h)
    if rgn == nil then
        return nil;
    end

    return RegionHandle(rgn)
end

function GdiRegion.CreateRoundRectRgn(self, x1, y1, x2, y2, w, h)
    local rgn = C.CreateRoundRectRgn(x1, y1, x2, y2, w, h);
    if rgn == nil then 
        return nil;
    end

    return RegionHandle(rgn)
end

function GdiRegion.ExtCreateRegion(self, lpx, nCount, lpData)
    local rgn = C.ExtCreateRegion(lpx, nCount, lpData)
    if rgn == nil then 
        return nil;
    end

    return RegionHandle(rgn)
end


return GdiRegion
