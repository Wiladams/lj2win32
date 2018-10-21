-- Test whether the basic files can be required together
-- test whether the relative path construct is correct
package.path = "../?.lua;"..package.path;



local glu = require("win32.gl.glu")

print("GLU: ", glu)