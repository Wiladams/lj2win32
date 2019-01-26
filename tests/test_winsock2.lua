package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

NOGDI = true

require("win32.minwindef")
require("win32.winerror")


local winsock = require("win32.winsock2")


print("_SS_MAXSIZE: ", C._SS_MAXSIZE)
print("_SS_ALIGNSIZE: ", C._SS_ALIGNSIZE)

print("FIONREAD: ", string.format("0x%x", C.FIONREAD))

local function test_timeval()
    local tv = ffi.new("struct timeval")
    print("default, tv.isset(): ", tv:isSet(), tv)

    tv.tv_sec = 3;
    print("after, tv.isSet(): ", tv:isSet(), tv)

    tv:clear()
    print("clear: ", tv)

    local tv1 = ffi.new("struct timeval", {7,500})
    local tv2 = ffi.new("struct timeval", {7,500})
    local tv3 = ffi.new("struct timeval", {7,600})
    local tv4 = ffi.new("struct timeval", {8,400})
    local tv5 = ffi.new("struct timeval", {7,400})

    print("equal: ", tv1 == tv2, tv1, tv2)
    print("less: ", tv1, tv2, tv1<tv2)
    print("less: ", tv1, tv4, tv1<tv4)
    print("__le: ", tv1, tv2, tv1<=tv2)
    print("__le: ", tv1, tv5, tv1<=tv5)
    print("__le: ", tv5, tv1, tv5<=tv1)
end

test_timeval()

