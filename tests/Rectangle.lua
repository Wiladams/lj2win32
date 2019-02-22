local ffi = require("ffi")
local bit = require("bit")
local lshift, rshift = bit.lshift, bit.rshift
local band, bor = bit.band, bit.bor

ffi.cdef[[
typedef struct Rectangle_t {
    int32_t Left;
    int32_t Top;
    int32_t Right;
    int32_t Bottom;
} Rectangle;
]]

local Rect = {}
setmetatable(Rect, {
    __call = function(self,...)
        return self:new(...)
    end
})
local Rectangle_mt = {
    __index = Rect,

    __eq = function(self, rhs)
        return self.Left == rhs.Left and
            self.Top == rhs.Top and
            self.Right == rhs.Right and
            self.Bottom == rhs.Bottom
    end,

    __tostring = function(self)
        return string.format("Rect(%d,%d,%d,%d)", self.Left, self.Top, self.Right-self.Left, self.Bottom-self.Top)
    end,
}
ffi.metatype(ffi.typeof("struct Rectangle_t"), Rectangle_mt)


function Rect.new(self, x, y, width, height)
    return ffi.new("struct Rectangle_t",x,y,x+width,y+height)
end

function Rect.origin(self)
    return {self.Left, self.Top}
end

function Rect.x(self)
    return self.Left;
end

function Rect.y(self)
    return self.Top
end

function Rect.width(self)
    return self.Right - self.Left;
end

function Rect.height(self)
    return self.Bottom - self.Top
end

function Rect.contains(self, x, y)
    return not (x < self.Left or x > self.Right or
        y < self.Top or y > self.Bottom)
end

function Rect.union(self, rhs)
    local x1 = math.min(self.Left, rhs.Left)
    local x2 = math.max(self.Right, rhs.Right)
    local y1 = math.min(self)
end


local r1 = Rect(10,10,100,100)
print("r1: ", r1)