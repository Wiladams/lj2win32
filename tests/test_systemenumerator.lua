package.path = "../?.lua;"..package.path;

require("win32.sdkddkver")

local System = require("systemenumerator")

for id, name in System.processes() do
    print(id, name)
end