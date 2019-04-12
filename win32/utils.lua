local ffi = require("ffi")

local function makeStatic(name, value)
    ffi.cdef(string.format("static const int %s = %d;", name, tonumber(value)))
 end

 return {
     makeStatic = makeStatic
 }