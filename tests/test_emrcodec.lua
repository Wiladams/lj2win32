package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local EMRCodec = require("EMRCodec")
local EMRRecordStream = require("emrrecordstream")

local function test_enum()
for i=1,122 do
    print(i, EMRCodec.RecordType[i])
end
end

local size = 256;
local data = ffi.new("uint8_t[?]", size)
rstream = EMRRecordStream(data, size)

print("rstream: ", rstream.data, rstream.size)


local setbkcolor = rstream:readEMRSETBKCOLOR();
print(setbkcolor.emr.iType, setbkcolor.emr.nSize)