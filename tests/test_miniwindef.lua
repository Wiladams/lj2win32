-- Test whether core Win32 types can be included properly
-- with duplication of embedded require statements
-- This might catch any upper/lower case problems
package.path = "../?.lua;"..package.path;

local ffi = require("ffi")



local function test_miniwindef()
require ("win32.minwindef")

local DWORD_PTR = ffi.typeof("DWORD_PTR")
local WORD = ffi.typeof("WORD")
local DWORD = ffi.typeof("DWORD")
local LONG = ffi.typeof("LONG")


    print("MAKELONG(0x1100, 0x3322): ", MAKELONG(0x1100, 0x3322), string.format("0x%x", tonumber(MAKELONG(0x1100, 0x3322))))
    print("    MAKEWORD(0x00, 0x11): ", MAKEWORD(0x00, 0x11), string.format("0x%x", tonumber(MAKEWORD(0x00, 0x11))))

    print("    DWORD_PTR(0xaaaa): ", DWORD_PTR(0xaaaa), string.format("0x%x",tonumber(DWORD_PTR(0xaaaa))))
    print("     LONG(0x22221111): ", LONG(0x22221111), string.format("0x%x",tonumber(LONG(0x22221111))))
    print("        DWORD(0xaaaa): ", DWORD(0xaaaa), string.format("0x%x",tonumber(DWORD(0xaaaa))))
    print("         WORD(0xaaaa): ", WORD(0xaaaa), string.format("0x%x",tonumber(WORD(0xaaaa))))
    print("   LOWORD(0xbbbbaaaa): ", LOWORD(0xbbbbaaaa), string.format("0x%x",tonumber(LOWORD(0xbbbbaaaa))))
    print("   HIWORD(0xbbbbaaaa): ", HIWORD(0xbbbbaaaa), string.format("0x%x",tonumber(HIWORD(0xbbbbaaaa))))
    print("       LOBYTE(0xbbaa): ", LOBYTE(0xbbaa), string.format("0x%x",tonumber(LOBYTE(0xbbaa))))
    print("       HIBYTE(0xbbaa): ", HIBYTE(0xbbaa), string.format("0x%x",tonumber(HIBYTE(0xbbaa))))

end

local function test_windef()
    require("win32.windef")
end

test_miniwindef();
test_windef();
