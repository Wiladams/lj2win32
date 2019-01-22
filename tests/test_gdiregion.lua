package.path = "../?.lua;"..package.path;

local GdiRegion = require("GdiRegion")

local rgn1 = GdiRegion:CreateRectRgn(10, 10, 100, 100)
local rgn2 = GdiRegion:CreateRectRgn(20, 20, 100, 100)
local rgn3 = GdiRegion:CreateRectRgn(10, 10, 100, 100)

print("rgn1 == rgn2 (false): ", rgn1 == rgn2)
print("rgn1 == rgn3 (true): ", rgn1 == rgn3)
