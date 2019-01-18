local strdelim = require("strdelim")

local function testMultiNull()
local astring="value1\0value2\0value3\0value4\0\0"
for i, str in strdelim.multinullstrings(astring) do
    print(i,str)
end
end

local function testRegPath()
    local astring = "HKEY_LOCAL_MACHINE\\HARDWARE\\DESCRIPTION\\System"
    print("testRegPath: ", astring)
    for str in strdelim.delimvalues(astring, #astring, string.byte('\\')) do
        print(str)
    end
end

function array_iterator2(array)
    local function visit(arr)
        for i=1, #arr do
            coroutine.yield(arr[i])
        end
    end

    local co = coroutine.create(visit)

    return function()
        local status, value = coroutine.resume(co, array)
        if status then
            return value
        else
            return nil
        end
    end
end

local function testCoroutine()
    for achar in array_iterator2({'a','b','c','d','e','f'}) do
        print (achar)
    end
end

--testMultiNull();
testRegPath()
--testCoroutine();