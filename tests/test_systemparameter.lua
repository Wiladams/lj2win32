-- test_systemparameter.lua
package.path = "../?.lua;"..package.path;

local ffi = require("ffi")


local sysparam = require("systemparametersinfo")

local function printValue(title, value)
    if type(value) == "table" then
        for k,v in pairs(value) do
            print(k,v)
        end
    else
        print(value)
    end
end

printValue("SPI_GETNONCLIENTMETRICS", sysparam.SPI_GETNONCLIENTMETRICS)
printValue("SPI_GETCLEARTYPE", sysparam.SPI_GETCLEARTYPE)