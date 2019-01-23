-- Test whether the basic files can be required together
-- test whether the relative path construct is correct
package.path = "../?.lua;"..package.path;


require("win32.sdkddkver")
require("win32.winbase")
require("win32.winnt")