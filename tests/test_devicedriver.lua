package.path = "../?.lua;"..package.path;

local DeviceDriver = require("DeviceDriver")


for i, driver in DeviceDriver:drivers() do
    print(string.format("{name='%s', filename='%s'};", driver:getName(), driver:getFilename()))
end

