package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local sutils = require("sockutils")

print("Local Host Name: ", sutils.GetLocalHostName())
