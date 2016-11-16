-- test_systemparameter.lua
package.path = "../?.lua;"..package.path;

local ffi = require("ffi")


local sysparam = require("systemparametersinfo")

local function printValue(value)
    if type(value) == "table" then
        for k,v in pairs(value) do
            print(k,v)
        end
    else
        print(value)
    end
end

printValue(sysparam.SPI_GETNONCLIENTMETRICS)