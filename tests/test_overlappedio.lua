package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

require("win32.sdkddkver")
local OverLappedIO = require("overlappedio")

local f1, err = OverLappedIO({Path="textfile.txt"})

local function test_basic()
print("f1:", f1, err)

local buffLen = 80
local buff = ffi.new("uint8_t[?]", buffLen)
local bResult, err = f1:read(buff, buffLen)

if bResult then
io.write(ffi.string(buff, bResult))
else
    print("ERROR: ", bResult, err)
end
end

local function test_readfile()
    local buffLen = 80
    local buff = ffi.new("uint8_t[?]", buffLen)

    while true do
        local bytesRead, err = f1:read(buff, buffLen)
        if bytesRead then
            io.write(ffi.string(buff, bytesRead))
        else
            print("ERROR: ", err)
            break;
        end
    end
end

--test_basic()
test_readfile()