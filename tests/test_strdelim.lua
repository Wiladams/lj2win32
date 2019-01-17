local strdelim = require("strdelim")

local function testMultiNull()
local astring="value1\0value2\0value3\0value4\0\0"
for i, str in strdelim.multinullstrings(astring) do
    print(i,str)
end
end

local function testRegPath()
    local astring = "HKEY_LOCAL_MACHINE\\HARDWARE\\DESCRIPTION\\System"
    for i,str in strdelim.delimvalues(astring, #astring, string.byte('\\')) do
        print(i,str)
    end
end

--testMultiNull();
testRegPath()
