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

-- an iterator over a delimited string.
-- returns one value at a time
-- use a coroutine based iterator
function exports.delimvalues(data, len, delim)
    len = len or #data
    delim = delim or string.byte(',')

    local function visit(data, len, delim)
        local startoffset = 0;
        local strptr = ffi.cast("const char *", data)

        while startoffset < len do
            local charoffset = startoffset;
            while charoffset < len and 
                strptr[charoffset] ~= delim do
                    charoffset = charoffset + 1;
            end
            
            local len = charoffset - startoffset
            coroutine.yield(ffi.string(strptr +startoffset, len))

            startoffset = charoffset + 1;
        end

        return nil;
    end

    local co = coroutine.create(visit);

    return function()
        local status, value = coroutine.resume(co, data, len, delim)
        if status then
            return value
        else
            return nil
        end
    end
end

--[[

    local function closure(state, startoffset)
        local strptr = ffi.cast("const char *", state.data)

        if startoffset >= state.length then
            return nil;
        end
        
        local charoffset = startoffset 

        while charoffset < state.length and 
            strptr[charoffset] ~= state.delim do
            charoffset = charoffset + 1;
        end
        local len = charoffset - startoffset

        return charoffset+1, ffi.string(strptr+startoffset, len)
    end

    return closure, {data = data, length=len, delim = delim}, 0
end
--]]

--[[
    multi string iterator
    In this case, a set of parameters are passed in.
    The type of the elements of the data array are specified as part of 
    the parameters, or 'char' is assumed.

    If the length of the string is 0, then a nil is returned.  This is not
        correct, as the length should determine when to terminate.
]]
function exports.mstriter(params)
    params = params or {}
 
    params.separator = params.separator or 0
    params.datalength = params.datalength or #params.data
    params.basetype = params.basetype or ffi.typeof("char")
    params.basetypeptr = ffi.typeof("const $ *", params.basetype)
    params.maxlen = params.maxlen or params.datalength-1;
 
    local function closure(param, idx)
        if not params.data then
            return nil;
        end
 
        local len = 0;
         
        while ffi.cast(param.basetypeptr, param.data)[idx + len] ~= param.separator and (len < param.maxlen) do
            len = len +1;
        end
 
        -- BUGBUG, len alone should not determine termination
        -- empty strings should be valid
        if len == 0 then
            return nil;
        end
 
        return (idx + len+1), ffi.string(ffi.cast(param.basetypeptr, param.data)+idx, len*ffi.sizeof(param.basetype));
    end
 
    return closure, params, 0;
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