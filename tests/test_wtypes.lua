-- Test whether core Win32 types can be included properly
-- with duplication of embedded require statements
-- This might catch any upper/lower case problems
package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

require ("win32.basetsd")
require ("win32.arch");

require ("win32.wtypes");

print("sizeof(ULONG): ", ffi.sizeof("ULONG"))