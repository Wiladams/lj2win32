local Rectangle = require("Rectangle")

local r1 = Rectangle(0,0,300,300)
local r2 = Rectangle(200,200,300,300)
local r3 = Rectangle(400,0, 100, 100)
local r4 = Rectangle(0,0, 100, 100)

print("r1: ", r1)
print("r2: ", r2)
print("union: ", r1:union(r2))
print("intersection: ", r1:intersection(r2))
print("outside: ", r1, r3, r1:intersection(r3))
print("outside left: ", r2, r4, r2:intersection(r4))
