local ffi = require("ffi")
local C = ffi.C

require("win32.sdkddkver")
require("win32.wingdi")

local GdiRegion = {}

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

    __add = function(lhs, ...)
        local nargs = select('#',...)
        if type(select(1,...)) == 'cdata' then
            -- create new region
            local dstRegion = C.CreateRectRgn(0,0,0,0)

            local res = C.CombineRgn(dstRegion, lhs.Handle, rhs.Handle, C.RGN_OR)
            return RegionHandle(dstRegion)
        end

        -- offset current region by numeric values
        if type(select(1,...)) == 'table' then
            local tbl = select(1,...)
            local res = C.OffsetRgn(lhs.Handle, tbl[1], tbl[2])

        end
        
        return self;
    end;

    __sub = function(lhs, rhs)
        -- create new region
        local dstRegion = C.CreateRectRgn(0,0,0,0)

        local res = C.CombineRgn(dstRegion, lhs.Handle, rhs.Handle, C.RGN_DIFF)
        return RegionHandle(dstRegion)
    end;
}
ffi.metatype("RegionHandle", RegionHandle_mt)



--[[
    Factory functions
]]
function GdiRegion.CreatePolygonRgn(self, pptl, cPoint, iMode)
    iMode = iMode or C.WINDING
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

-- bounding box can be returned, or set
-- when no parameters are specified, the current bounding box is returned
function GdiRegion.bounds(self,...)
    if select('#',...) == 0 then
        local lprc = ffi.new("RECT")
        local res = C.GetRgnBox(self.Handle, lprc)

        return lprc, res
    end

    return false
end

--[[
    iterate over the rectangles that makeup the region
]]
function GdiRegion.rects(self)
    
    function visitor()
        local nBytes = 0;
        local lpRgnData = nil;


        local nBytes = C.GetRegionData(self.Handle, nBytes, lpRgnData)
        if nBytes == 0 then 
            return false;
        end

        lpRgnData = ffi.new("uint8_t[?]", nBytes)
        local rgnData = ffi.cast("RGNDATA *", lpRgnData)
        local res = C.GetRegionData(self.Handle, nBytes, rgnData)

        if res == 0 then 
            return false;
        end

    --print("  dwSize: ", rgnData.rdh.dwSize)
    --print("   iType: ", rgnData.rdh.iType) -- == RDH_RECTANGLES
    --print("  nCount: ", rgnData.rdh.nCount)
    --print("nRgnSize: ", rgnData.rdh.nRgnSize)
    --print(" rcBound: ", rgnData.rdh.rcBound.left, rgnData.rdh.rcBound.top, rgnData.rdh.rcBound.right, rgnData.rdh.rcBound.bottom)

        local rectArray = ffi.cast("RECT *", rgnData.Buffer)

        for i=0,rgnData.rdh.nCount-1 do 
            coroutine.yield({left = rectArray[i].left, top = rectArray[i].top, right = rectArray[i].right, bottom = rectArray[i].bottom})
        end

    end

    local co = coroutine.create(visitor)

    return function ()
        local status, value = coroutine.resume(co)
        --print(status, value)
        if not status then
            return nil;
        end

        return value;
    end

end


return GdiRegion
