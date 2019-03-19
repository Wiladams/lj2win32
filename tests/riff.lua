--[[
    http://netghost.narod.ru/gff/graphics/summary/micriff.htm
]]
local bitstream = require("bitstream")

--[[
    typedef struct _Chunk
{
    DWORD ChunkId;              /* Chunk ID marker */
    DWORD ChunkSize;            /* Size of the chunk data in bytes */
    BYTE ChunkData[ChunkSize];  /* The chunk data */
} CHUNK;
]]

local function readChunk(bs, res)
    res = res or {}

    res.ChunkId = bs:readDWORD();
    res.ChunkSize = bs:readDWORD();
    res.ChunkData = bs:readBytes(res.ChunkSize)
    return rs
end
