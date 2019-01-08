local ffi = require("ffi")

local function makeStatic(name, value)
    ffi.cdef(string.format("static const int %s = %d;", name, value))
 end

 return {
     makeStatic = makeStatic
 }