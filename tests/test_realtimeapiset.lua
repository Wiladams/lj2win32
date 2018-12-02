package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

require("win32.realtimeapiset")

local pCycleTime = ffi.new("uint64_t[1]")
local success = ffi.C.QueryThreadCycleTime(ThreadHandle,pCycleTime) ~= 0;

