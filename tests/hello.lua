-- Simple program used to test process creation
local ffi = require("ffi")
local function arrLength(arr,ct)
    print("arrLength: ", ffi.sizeof(arr), ffi.sizeof(ct))
    local elems = ffi.sizeof(arr) / ffi.sizeof(ct)
    print ("elems: ", elems)
    return elems
end

local p2D = ffi.new("int[24]", { 0, 0, 1, -1, 0, 0, -1, 1, 0, 2, 1, 1, 1, 2, 2, 0, 1, 2, 0, 2, 1, 0, 0, 0 });


for i = 0, arrLength(p2D,"int")-1, 4  do
    print(p2D[i])
end
--[[
for i =1, 1000 do
    print(i,"Hello, Lua!")
end
--]]