package.path = "../?.lua;"..package.path;

local EMRCodec = require("EMRCodec")

for i=1,122 do
    print(i, EMRCodec.RecordType[i])
end
