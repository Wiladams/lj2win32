-- Test whether core Win32 types can be included properly
-- with duplication of embedded require statements
-- This might catch any upper/lower case problems
package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
--[[
require ("win32.basetsd")
require ("win32.arch");
--]]

--require("win32.minwindef")
--require("win32.winnt")
-- or just
require("win32.windef")

local wtypes = require ("win32.wtypes");


local function test_DECLARE_HANDLE()
    print("DECLARE_HANDLE: ", DECLARE_HANDLE)
    local moof = DECLARE_HANDLE("MOOF")
end

local function test_sizeof()
print("sizeof(ULONG): ", ffi.sizeof("ULONG"))
end

--test_DECLARE_HANDLE();


