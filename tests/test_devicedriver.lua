package.path = "../?.lua;"..package.path;

local DeviceDriver = require("DeviceDriver")


for i, driver in DeviceDriver:drivers() do
    print(string.format("%4d %36s %s", i, driver:getName(), driver:getFilename()))
end

