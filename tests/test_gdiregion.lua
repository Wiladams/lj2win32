package.path = "../?.lua;"..package.path;

local GdiRegion = require("GdiRegion")

local rgn1 = GdiRegion:CreateRectRgn(10, 10, 100, 100)
local rgn2 = GdiRegion:CreateRectRgn(20, 20, 110, 110)
local rgn3 = GdiRegion:CreateRectRgn(10, 10, 100, 100)

local function printRegion(r)
    for rect in r:rects() do
        print(rect.left, rect.top, rect.right, rect.bottom)
    end
end

local function testEqual()
    print("== testEqual ==")
    print("rgn1 == rgn2 (false): ", rgn1 == rgn2)
    print("rgn1 == rgn3 (true): ", rgn1 == rgn3)
end

local function testAdd()
    print("== testAdd ==")
    local c = rgn1 + rgn2;
    printRegion(c)
end

local function testBounds()
    print("== testBounds ==")
    local b = rgn1:bounds()
    print("10,10,100,100", b.left, b.top, b.right, b.bottom)
end

local function testEnum()
    print("== testEnum ==")
    local c = rgn1 - rgn2;
    printRegion(c)
end

testAdd();
--testEqual();
--testBounds();
--testEnum();
