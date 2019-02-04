package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

require("win32.sdkddkver")
mmap = require("mmap")

local filemap = mmap("textfile.txt")


print("FILE")
print(ffi.string(filemap:getPointer(), #filemap))