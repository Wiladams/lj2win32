-- Test whether core Win32 types can be included properly
-- with duplication of embedded require statements
-- This might catch any upper/lower case problems
package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local function test_miniwindef()
require ("win32.internal.minwindef")
end

local function test_windef()
    require("win32.internal.windef")
end

test_miniwindef();
test_windef();
