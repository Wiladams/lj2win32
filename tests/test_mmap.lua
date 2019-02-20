package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

require("win32.sdkddkver")
local mmap = require("mmap")
local binstream = require("binstream")


local filemap = mmap("textfile.txt")

local function test_fileprint()
print("FILE")
print(ffi.string(filemap:getPointer(), filemap:length()))
end

local function test_binstream()
    local bs = binstream(filemap:getPointer(), filemap:length())
    local buff = ffi.new("char[3]")
    for i=1, filemap:length()/3 do
        bs:readByteBuffer(3,buff)
        io.write(ffi.string(buff,3))
    end
end

--test_fileprint()
test_binstream()