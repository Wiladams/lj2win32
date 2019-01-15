local ffi = require("ffi")
local exports = {}


-- given a pointer to a string, an offset and length
-- split along the delimeter, returning two strings
function exports.splitdelim(str, delim, offset, len)
    local strptr = ffi.cast("const char *", str)
    local delimoffset = offset;

    while strptr[delimoffset] ~= delim and delimoffset < offset + len-1 do
        delimoffset = delimoffset + 1;
    end
    local key = ffi.string(str+offset, delimoffset-offset)
    local value = ffi.string(str+delimoffset+1, offset+len-delimoffset-1)

    return key, value;
end

-- given a string that has embedded nulls
-- split it into a table of individual key value pairs
-- The end of the input string would be indicated
-- with two '\0' values. 
-- this=value1\0is=value2\0an=value3\0example=value4\0\0
--
function exports.multinullpairs(multinull)
    local res = {}
    local strptr = ffi.cast("const char *", multinull)
    local startoffset = 0;

    while strptr[startoffset] ~= 0 do
        local charoffset = startoffset;

        while strptr[charoffset] ~= 0 do 
            charoffset = charoffset + 1;
        end
        local len = charoffset - startoffset

        local key, value = exports.splitdelim(strptr, string.byte('='), startoffset, len)
        rawset(res, key, value)

        startoffset = charoffset + 1;     -- skip over string null terminator
    end

    return res
end

-- an iterator over the multi null string.
-- returns one string at a time
function exports.multinullstrings(multinull)
    local function closure(state, startoffset)
        local strptr = ffi.cast("const char *", state)

        if strptr[startoffset] == 0 then
            return nil;
        end
        
        local charoffset = startoffset 

        while strptr[charoffset] ~= 0 do
            charoffset = charoffset + 1;
        end
        local len = charoffset - startoffset

        return charoffset+1, ffi.string(strptr+startoffset, len)
    end

    return closure, multinull, 0
end


return exports