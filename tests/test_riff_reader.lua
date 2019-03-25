package.path = "../?.lua;"..package.path;

local riff = require("riff")
local binstream = require("binstream")
local mmap = require("mmap")
local bitbang = require("bitbang")
local BVALUE = bitbang.BITSVALUE
local spairs = require("spairs")
local fourcc = require("fourcc")
local fourccToString = fourcc.fourccToString

local function BYTEVALUE(x, low, high)
    return tonumber(BVALUE(x, low, high))
end



local function printDict(dict)
    print("==== Chunk ====")
    for k,v in spairs(dict) do
        if k == "Id" or k == "Kind" or k == "fcc" then
            v = fourccToString(v)
        elseif k == "FormatTag" then
            v = string.format("0x%x", v)
        end

        print(string.format("%-10s: ", k),v)
    end
end



local function printFileHeader(header)
    print("==== File Header ====")
    print("ID: ", fourccToString(header.Id))
    print("Size: ", header.Size)
    print("Kind: ", fourccToString(header.Kind))
end

local function printChunk(chunk)
    print("==== CHUNK ====")
    print("ID: ", fourccToString(chunk.Id))
    print("Size: ", string.format("0x%x",chunk.Size))
    print("Data: ", chunk.Data)
end


local function readFromFile(filename)
    print("++++======= FILE: ", filename)
    local filemap, err = mmap(filename)
    if not filemap then
        return false, "file not mapped ()"..tostring(err)
    end

    local bs, err = binstream(filemap:getPointer(), filemap:length(), 0, true )

    if not bs then
        return false, err
    end

    local header = riff.readFileHeader(bs)

    printFileHeader(header)

    -- create subrange for those cases where the file is bigger
    -- than the RIFF chunk
    local ls, err = bs:range(header.Size-4)
    if not ls then
        print("bs:range(), failure: ", err)
        return false;
    end

    for chunk in riff.readChunks(ls, header) do
        --printChunk(chunk)
        printDict(chunk)
    end
end

-- some from here
-- http://www-mmsp.ece.mcgill.ca/Documents/AudioFormats/WAVE/Samples.html
-- http://www.cs.bath.ac.uk/~rwd/cardattrit.html

local files = {

    "canimate.avi",
--[[
    "chimes.wav",
    "sample.avi",
    "sample.rmi",
    "sample.pal",
    "Spirogra.avi",
    "M_busy.ani",
    "M1F1-Alaw-AFsp.wav",
    
    -- Sample files from GoldWave
    "addf8-Alaw-GW.wav",
    "addf8-mulaw-GW.wav",
    "addf8-GSM-GW.wav",
    
    -- Multi-Channel examples
    "6_Channel_ID.wav",
    "8_Channel_ID.wav",

    -- Perverse files
    "Pmiscck.wav",      -- WAVE file (9 samples) with an odd length intermediate chunk (type XxXx)
    "Ptjunk.wav",       -- WAVE file with trailing junk after the RIFF chunk
    "GLASS.wav",        -- WAVE file with a RIFF chunk length larger than the file size (originally from www.sipro.com)
    "Utopia Critical Stop.wav", -- WAVE file, PCM data, with a fact chunk following the data. The fact chunk contains the four characters FILT and not the number of samples. (From the system directory C:\WINNT\Media on a Windows 2000 system)

    -- These files are from CCRMA at Stanford:  ftp://ftp-ccrma.stanford.edu/pub/Lisp/sf.tar.gz
    "truspech.wav",     -- WAVE file (format code 0x0022)
    "voxware.wav",      -- WAVE file (format code 0x181C)
--]]
}

for _, filename in ipairs(files) do
    readFromFile(string.format("media\\riff\\%s", filename))
end

