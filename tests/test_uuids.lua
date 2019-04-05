package.path = "../?.lua;"..package.path;

require("win32.sdkddkver")
require("win32.minwindef")
require("win32.minwinbase")

require("win32.uuids")

print("test_uuids - END")