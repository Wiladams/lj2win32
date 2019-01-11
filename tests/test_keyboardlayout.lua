package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

require("win32.sdkddkver")
local wingdi = require("win32.wingdi")
local winuser = require("win32.winuser")

local function getLayoutList()
    -- first call to find out how many elements are needed
    local nBuff = 0;
    local lpList = nil;

    local numElems = ffi.C.GetKeyboardLayoutList(nBuff,lpList);

    if numElems < 1 then return false end

    lpList = ffi.new("HKL[?]", numElems);

    -- Now call again with the proper sized array
    numElems = ffi.C.GetKeyboardLayoutList(numElems, ipList)
    print("Num Elems(2): ", numElems)

    return lpList;
end

local function getLayoutName()
    local buff = ffi.new("char[?]", ffi.C.KL_NAMELENGTH);
    local success = ffi.C.GetKeyboardLayoutNameA(buff)

    if success ~= 1 then
        print("failure: ", success)
        return false;
    end

    local name = ffi.string(buff)
    return name
end

getLayoutList();

print("Layout Name: ", getLayoutName())
