package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 


require("win32.winnls")
require("win32.errhandlingapi")
local unicode = require("unicode_util")

local function getLocaleName(funcname)
    local sysfunc = C[funcname]
    if not sysfunc then return nil end

    local cchName = 256;

    -- do this in a loop, expanding storage, until it succeeds or fails
    while true do
        local lpName = ffi.new("WCHAR[?]", cchName);

        local status = sysfunc(lpName, cchName);
        local err = 0;
        --print("status: ", status, err)

        if status == 0 then
            err = C.GetLastError();
            if err ~= C.ERROR_INSUFFICIENT_BUFFER then
                return nil, err
            end
        else
            return unicode.toAnsi(lpName)
        end

        if cchName > 64*1025 then
            return nil, "buffer > 64k";
        end

        -- do it again with the buffer twice as big
        cchName = cchName * 2;
    end
end

local localefuncnames = {
    "GetSystemDefaultLocaleName",
    "GetUserDefaultLocaleName",
    "GetUserDefaultGeoName"
}


local function getLocaleNames()
    for i, funcname in ipairs(localefuncnames) do
        local name = getLocaleName(funcname)
        print(funcname, name)
    end
end

getLocaleNames()
