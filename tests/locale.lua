package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 


require("win32.winnls")
require("win32.errhandlingapi")
local unicode = require("unicode_util")

local exports = {}

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
    SystemLocaleName = "GetSystemDefaultLocaleName",
    UserLocaleName = "GetUserDefaultLocaleName",
    UserGeoName = "GetUserDefaultGeoName"
}


local function getLocaleNames()
    for i, funcname in ipairs(localefuncnames) do
        local name = getLocaleName(funcname)
        print(funcname, name)
    end
end

function exports.geoNames(self)
    local names = {}

    local function enumProc(Arg1, Argg2)
        table.insert(names, unicode.toAnsi(Arg1))
        return 1;   -- indicate we want more
    end
    jit.off(enumProc, true)    -- turn off jit for callbacks

    local function generator()
        local geoClass = C.GEOCLASS_ALL;
        local geoEnumProc = ffi.cast("GEO_ENUMNAMEPROC", enumProc)
        local data = ffi.cast("intptr_t",0);

        local status = C.EnumSystemGeoNames(geoClass, enumProc, data);
        geoEnumProc:free()

        -- send out the results one by one
        for i, name in ipairs(names) do
            coroutine.yield(name)
        end
    end

    local co = coroutine.create(generator);

    return function()
        local status, value = coroutine.resume(co)
        if not status then 
            return nil;
        else
            return value;
        end
    end
end



locale_mt = {
    __index = function(tbl, key)
        --print("__index: ", tbl, key)
        local funcname = localefuncnames[key];
        if funcname then
            return getLocaleName(funcname)
        end

        return nil;
    end
}
setmetatable(exports, locale_mt)

return exports