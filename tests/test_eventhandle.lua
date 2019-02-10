package.path = "../?.lua;"..package.path;

require("win32.sdkddkver")

local EventHandle = require("eventhandle")

local eh, err = EventHandle()

print("Event Handle: ", eh, err)
