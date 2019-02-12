package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

require("win32.sdkddkver")
local FileHandle = require("filehandle")

local f1, err = FileHandle({Path="textfile.txt",
    DesiredAccess = C.GENERIC_READ,
    ShareMode = C.FILE_SHARE_READ,
    --CreationDisposition = C.OPEN_EXISTING,
    --FlagsAndAttributes = 0,                   -- FILE_FLAG_OVERLAPPED
})

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
    local buffLen = 1024
    local buff = ffi.new("uint8_t[?]", buffLen)

    while true do
        local bytesRead, err = f1:read(buff, buffLen)
        --print(bytesRead, err)
        if bytesRead then
            io.write(ffi.string(buff, bytesRead))
        else
            print("ERROR: ", err)
            break;
        end
    end
end

test_basic()
--test_readfile()