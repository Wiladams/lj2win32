local strdelim = require("strdelim")

local astring="value1\0value2\0value3\0value4\0\0"
for i, str in strdelim.multinullstrings(astring) do
    print(i,str)
end
