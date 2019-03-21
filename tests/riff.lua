--[[
    http://netghost.narod.ru/gff/graphics/summary/micriff.htm
    https://sno.phy.queensu.ca/~phil/exiftool/TagNames/RIFF.html
    http://www.mcternan.me.uk/MCS/Downloads/wave.pdf
    https://docs.microsoft.com/en-us/windows/desktop/xaudio2/resource-interchange-file-format--riff-

    XAudio2 for audio playback
    ]]
local ffi = require("ffi")
local bitstream = require("binstream")
local fourcc = require("fourcc")
local binstream = require("binstream")
local bitbang = require("bitbang")
local BVALUE = bitbang.BITSVALUE

local MAKEFOURCC = fourcc.MAKEFOURCC
local fourccToString = fourcc.fourccToString
local str24cc = fourcc.stringToFourcc

local RIFF = str24cc('RIFF')
local LIST = str24cc('LIST')
local fmt = str24cc('fmt ')
local INFO = str24cc('INFO')
local data = str24cc('data')

-- some values from mmreg.lua
local  WAVE_FORMAT_EXTENSIBLE   = 0xFFFE; -- Microsoft
local  WAVE_FORMAT_MPEG         = 0x0050; -- Microsoft Corporation
local  WAVE_FORMAT_MPEGLAYER3   = 0x0055; -- ISO/MPEG Layer3 Format Tag


local function BYTEVALUE(x, low, high)
    return tonumber(BVALUE(x, low, high))
end



local function readChunkHeader(bs, res)
    res = res or {}

    res.Id = bs:readDWORD();
    res.Size = bs:readDWORD();

    return res
end

local function read_chunk_LIST(bs, res)
    if not res then return false end

    res.Kind = bs:readDWORD()
    res.Data = bs:readBytes(res.Size-4)

    if res.Kind == INFO then
        -- each of the chunks in here are strings of
        -- information.  So, read the chunks
        -- create a stream on the data
        local ls, err = binstream(res.Data, res.Size, 0, true )

        while not ls:EOF() do
            local chunk = readChunkHeader(ls)
            local data = ls:readBytes(chunk.Size)
            if data then
            res[fourccToString(chunk.Id)] = ffi.string(data)
            end
            ls:skipToEven()
        end
    end

    return res
end

--
-- https://msdn.microsoft.com/en-us/library/windows/desktop/dd390970(v=vs.85).aspx
--
local function read_chunk_fmt(bs, res)
    if not res then return false end

    res.Data = bs:readBytes(res.Size)
    -- create a stream on the data
    local ls, err = binstream(res.Data, res.Size, 0, true )

    -- Read the base structure
    res.FormatTag = ls:readWORD();
    res.NumChannels = ls:readWORD();
    res.SamplesPerSec = ls:readDWORD();
    res.AvgBytesPerSec = ls:readDWORD();
    res.BlockAlign = ls:readWORD();
    res.BitsPerSample = ls:readWORD();
    res.cbSize = ls:readWORD();

    -- Based on the FormatTag, there may be extensible structure
    -- to be read.  Check ls:remaining to see if it corresponds
    -- to res.cbSize, for a sanity check

    if res.FormatTag == WAVE_FORMAT_EXTENSIBLE then
        res.Samples = ls:readWORD()
        res.ChannelMask = ls:readDWORD()
        res.SubFormat = ls:readBytes(16)    -- GUID
    elseif res.FormatTag == WAVE_FORMAT_MPEG then
        res.HeadLayer = ls:readWORD();
        res.HeadBitrate = ls:readDWORD();
        res.HeadMode = ls:readWORD();
        res.HeadModeExt = ls:readWORD();
        res.HeadEmphasis = ls:readWORD();
        res.HeadFlags = ls:readWORD();
        res.PTSLow = ls:readDWORD();
        res.PTSHigh = ls:readDWORD();
    elseif res.FormatTag == WAVE_FORMAT_MPEGLAYER3 then
    end

    return res
end

local function readChunk(bs, res)
    res = res or {}

    readChunkHeader(bs, res)

    if res.Id == RIFF then
        res.Kind = bs:readDWORD()
    elseif res.Id == LIST then
        read_chunk_LIST(bs, res)
    elseif res.Id == fmt then
        read_chunk_fmt(bs, res)
    else
        res.Data = bs:readBytes(res.Size)
    end

    return res
end

local function readLISTHeader(bs, res)
    res = res or {}

    readChunkHeader(bs, res)

    return res
end

local function readFileHeader(bs, res)
    res = res or {}

    readChunkHeader(bs, res)
    
    res.Kind = bs:readDWORD()

    return res
end

local function readChunks(bs, header)
    local function enumerator()
        while not bs:EOF() do 
            coroutine.yield(readChunk(bs))
            bs:skipToEven()
        end
    end

    return coroutine.wrap(enumerator)
end


return {
    readChunk = readChunk;
    readFileHeader = readFileHeader;
    readLISTHeader = readLISTHeader;
    readChunks = readChunks;
}