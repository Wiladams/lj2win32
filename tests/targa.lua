--[[
    References
    
    http://www.fileformat.info/format/tga/egff.htm#TGA-DMYID.2
    http://www.dca.fee.unicamp.br/~martino/disciplinas/ea978/tgaffs.pdf
    
-- library of congress
    https://www.loc.gov/preservation/digital/formats/fdd/fdd000180.shtml

-- other implementations
    https://unix4lyfe.org/targa/
    https://github.com/ftrvxmtrx/tga

    Honors the following properties
    vertical orientation
    horizontal orientation
    truecolor (16, 24, 32)
    indexed (16, 24, 32)
    monochrome (8)
    compressed - RLE, (not RAW)
--]]

local ffi = require("ffi")
local bit = require("bit")
local band, bor = bit.band, bit.bor
local lshift, rshift = bit.lshift, bit.rshift

local binstream = require("binstream")
local enum = require("enum")
local mmap = require("mmap")
local PixelBuffer = require("PixelBuffer")
local bitbang = require("bitbang")

local BITSVALUE = bitbang.BITSVALUE
local isset = bitbang.isset


--[[
    Convenience structures
]]
local ColorMapType = enum {
    [0] = "NoPalette",
    [1] = "Palette"
}

local HorizontalOrientation = enum {
    [0] = "LeftToRight",
    [1] = "RightToLeft"
}

local VerticalOrientation = enum {
    [0] = "BottomToTop",
    [1] = "TopToBottom",
}

--[[
    Header.ImageDescriptor
//  Bits 7-6 - Data storage interleaving flag.                |
//             00 = non-interleaved.                          |
//             01 = two-way (even/odd) interleaving.          |
//             10 = four way interleaving.                    |
//             11 = reserved.         
--]]
local Interleave = enum {
    [0] = "non-interleaved",
    [1] = "two-way (even/odd)",
    [2] = "four-way",
    [3] = "reserved"
}

local ImageType = enum {
    NoImageData = 0,
    ColorMapped = 1,
    TrueColor = 2,
    Monochrome = 3,
    ColorMappedCompressed = 9,
    TrueColorCompressed = 10,
    MonochromeCompressed = 11,
}


local footerSize = 26
local targaXFileID = "TRUEVISION-XFILE";


local function readColorMap(bs, header)
    local bytespe = header.CMapDepth / 8;
    local pixtype = ffi.typeof("uint8_t[$]", bytespe)
    local databuff = pixtype()

    local cMap = ffi.new("struct Pixel32[?]", header.CMapLength)

    for i=header.CMapStart,header.CMapLength-1 do
        local nRead = bs:readByteBuffer(bytespe, databuff)
        
        if bytespe == 2 then
            local src16 = bor(lshift(databuff[1],8), databuff[0])
            cMap[i].Red = lshift(BITSVALUE(src16,0,4),3)
            cMap[i].Green = lshift(BITSVALUE(src16,5,9),3)
            cMap[i].Blue = lshift(BITSVALUE(src16,10,14),3)
            cMap[i].Alpha = 0
            if BITSVALUE(src16,15,15) >= 1 then
                cMap[i].Alpha = 0;  -- 255
            end 
        elseif bytespe == 3 then
            cMap[i].Red = databuff[0]
            cMap[i].Green = databuff[1]
            cMap[i].Blue = databuff[2]
            cMap[i].Alpha = 0

        elseif bytespe == 4 then
            cMap[i].Red = databuff[0]
            cMap[i].Green = databuff[1]
            cMap[i].Blue = databuff[2]
            --pix.Alpha = databuff[3]   -- We should pre-multiply the alpha?
        end

    end

    return cMap
end

local function isCompressed(header)
    return header.ImageType == ImageType.ColorMappedCompressed or
        header.ImageType == ImageType.TrueColorCompressed or
        header.ImageType == ImageType.MonochromeCompressed
end

local function readHeader(bs, res)
    res = res or {}

    res.IDLength = bs:readOctet()           -- 00h  Size of Image ID field
    res.ColorMapType = bs:readOctet()       -- 01h  Color map type 
    res.ImageType = bs:readOctet()          -- 02h  Image type code
    res.CMapStart = bs:readUInt16()         -- 03h  Color map origin
    res.CMapLength = bs:readUInt16()        -- 05h  Color map length
    res.CMapDepth = bs:readOctet()          -- 07h  Depth of color map entries
    res.Compressed = isCompressed(res)

    -- Image Description
    res.XOffset = bs:readUInt16()           -- 08h  X origin of image
    res.YOffset = bs:readUInt16()           -- 0Ah  Y origin of image
    res.Width = bs:readUInt16()             -- 0Ch  Width of image - Maximum 512
    res.Height = bs:readUInt16()            -- 0Eh  Height of image - Maximum 482
    res.PixelDepth = bs:readOctet()         -- 10h  Number of bits per pixel
    res.BytesPerPixel = res.PixelDepth / 8
    res.ImageDescriptor = bs:readOctet()    -- 11h  Image descriptor byte


    --[[
                  Image Descriptor Byte.                        |
      Bits 3-0 - number of attribute bits associated with each  |
                   pixel.  For the Targa 16, this would be 0 or |
                   1.  For the Targa 24, it should be 0.  For   |
                   Targa 32, it should be 8.                    |
      Bit 4    - controls left/right transfer of pixels to 
                 the screen.
                 0 = left to right
                 1 = right to left
      Bit 5    - controls top/bottom transfer of pixels to 
                 the screen.
                 0 = bottom to top
                 1 = top to bottom
                 
                 In Combination bits 5/4, they would have these values
                 00 = bottom left
                 01 = bottom right
                 10 = top left
                 11 = top right
                 
      Bits 7-6 - Data storage interleaving flag.                |
                 00 = non-interleaved.                          |
                 01 = two-way (even/odd) interleaving.          |
                 10 = four way interleaving.                    |
                 11 = reserved.         
--]]
    res.AttrBits = band(res.ImageDescriptor , 0x0F);
    res.HorizontalOrientation = rshift(band(res.ImageDescriptor, 0x10),4)
    res.VerticalOrientation = rshift(band(res.ImageDescriptor, 0x20), 5)
    res.Interleave = rshift(band(res.ImageDescriptor, 0xC0), 6)


-- If there's an identification section, read that next
--print("ImageIdentification: ", res.IDLength, string.format("0x%x",bs:tell()))
    if res.IDLength > 0 then
        res.ImageIdentification = bs:readBytes(res.IDLength)
    end


    -- If there's a color map, read that next
    if res.ColorMapType == ColorMapType.Palette then
        res.ColorMap = readColorMap(bs, res)
    end

    return res
end




--[[
     Targa images come in many different formats, and there are 
     a couple of different versions of the specification.
 
First thing to do is determine if the file is adhereing to version 
2.0 of the spcification.  We do that by reading a 'footer', which 
is the last 26 bytes of the file.

Return a PixelBuffer if we can read the file successfully
]]


local function readFooter(bs, rs)
    rs = rs or {}
    --print("targa.readFooter, BEGIN")
    rs.ExtensionAreaOffset = bs:readUInt32()
    rs.DeveloperDirectoryOffset = bs:readUInt32()
    rs.Signature = bs:readBytes(16)
    rs.Signature = ffi.string(rs.Signature, 16)
    rs.Period = string.char(bs:readOctet())
    rs.Zero = bs:readOctet()

    rs.isExtended = rs.Signature == targaXFileID

    if not rs.isExtended then
        return false;
    end
    --print("targa.readFooter, END")
    
    return rs
end

local TrueColor = ImageType.TrueColor
local Monochrome = ImageType.Monochrome
local ColorMapped = ImageType.ColorMapped
local TrueColorCompressed = ImageType.TrueColorCompressed
local ColorMappedCompressed = ImageType.ColorMappedCompressed
local MonochromeCompressed = ImageType.MonochromeCompressed

local function decodeSinglePixel(pix, databuff, pixelDepth, imtype, colorMap)
    --print(pix, databuff, bpp, imtype)
    if imtype == TrueColor or imtype == TrueColorCompressed then
        if pixelDepth == 24 then
            pix.Red = databuff[0]
            pix.Green = databuff[1]
            pix.Blue = databuff[2]
            pix.Alpha = 0
            return true
        elseif pixelDepth == 32 then
            pix.Red = databuff[0]
            pix.Green = databuff[1]
            pix.Blue = databuff[2]
            --pix.Alpha = databuff[3]   -- We should pre-multiply the alpha?
            return true
        elseif pixelDepth == 16 then
            local src16 = bor(lshift(databuff[1],8), databuff[0])
            pix.Red = lshift(BITSVALUE(src16,0,4),3)
            pix.Green = lshift(BITSVALUE(src16,5,9),3)
            pix.Blue = lshift(BITSVALUE(src16,10,14),3)
            pix.Alpha = 0
            if BITSVALUE(src16,15,15) >= 1 then
                pix.Alpha = 0;  -- 255
            end 
        end
        return true;
    elseif imtype == Monochrome or imtype == MonochromeCompressed then
        pix.Red = databuff[0]
        pix.Green = databuff[0]
        pix.Blue = databuff[0]
        pix.Alpha = 0
        return true
    elseif imtype == ColorMapped or imtype == ColorMappedCompressed then
        -- lookup the color using databuff[0] as index
        local cpix = colorMap[databuff[0]]
        pix.Red = cpix.Red;
        pix.Green = cpix.Green;
        pix.Blue = cpix.Blue;
        return true;
    end

    return false
end

-- We want to figure out the mapping between positions as we
-- read them and their locations in our pixel buffer in one place
-- This iterator figures that out, return x,y pairs for the positions
-- according to the horizontal and vertical orientation.  Ideally this
-- would do interleaving as well, but we don't have an image to test
-- with
local function locations(header)
    local function iterator()
        --  Start with left to right orientation
        local dx = 1;
        local xStart = 0
        local xEnd = header.Width-1
        
        -- switch to right to left of horizontal orientation indicates
        if header.HorizontalOrientation == HorizontalOrientation.RightToLeft then
            dx = -1
            xStart = header.Width-1
            xEnd = 0
        end
    
        -- start top to bottom vertical orientation
        local dy = 1
        local yStart = 0
        local yEnd = header.Height-1
        if header.VerticalOrientation == VerticalOrientation.BottomToTop then
            dy = -1
            yStart = header.Height-1
            yEnd = 0
        end
    
        -- Now do the actual iteration job
        for y = yStart, yEnd, dy do 
            for x=xStart,xEnd, dx do
                coroutine.yield(x,y,pix)
            end
        end
    end

    return coroutine.wrap(iterator)
end

-- An iterator which will return the uncompressed
-- pixels in row order
local function uncompressedPixels(bs, header)
    local function iterator()
        local bytesPerPixel = header.BytesPerPixel
        local pixtype = ffi.typeof("uint8_t[$]", bytesPerPixel)
        local pix = ffi.new("struct Pixel32")
        local databuff = pixtype()

        for x,y in locations(header) do
            local nRead = bs:readByteBuffer(bytesPerPixel, databuff)
            decodeSinglePixel(pix, databuff, header.PixelDepth, header.ImageType, header.ColorMap)
            coroutine.yield(x,y,pix)
        end
    end

    return coroutine.wrap(iterator)
end

local function compressedPixels(bs, header)
    local function iterator()
        local bytesPerPixel = header.BytesPerPixel
        local pixtype = ffi.typeof("uint8_t[$]", bytesPerPixel)
        local pix = ffi.new("struct Pixel32")
        local databuff = pixtype()
        
        local pixelCount = 0
        local repCount = 0

        for x,y in locations(header) do
            if pixelCount == 0 then
                -- read repeatCount byte to see if it's RLE or RAW
                -- and the number of repetitions                
                repCount = bs:readOctet()
                local isRLE = isset(repCount, 7)
                --print("RLE: ", isRLE)
                pixelCount = BITSVALUE(repCount,0,6) + 1
                local nRead = bs:readByteBuffer(bytesPerPixel, databuff)
                decodeSinglePixel(pix, databuff, header.PixelDepth, header.ImageType, header.ColorMap)
                --print("pixelCount: ", pixelCount, pix)
            end

            coroutine.yield(x,y,pix)
            pixelCount = pixelCount - 1
        end
    end

    return coroutine.wrap(iterator)
end

local function readBody(bs, header)
    --print("targa.readBody, BEGIN")

    local pb = PixelBuffer(header.Width, header.Height)
 
    if not header.Compressed then
        for x,y,pixel in uncompressedPixels(bs, header) do
            pb:set(x,y,pixel)
        end
    else
        for x,y,pixel in compressedPixels(bs, header) do
            pb:set(x,y,pixel)
        end
    end

    return pb
end

-- read a targa image from a stream
-- This assumes other forms, like reading from a fill
-- will create a stream to read from
local function readFromStream(bs, res)
    res = res or {}

    -- position 26 bytes from the end and try 
    -- to read the footer
    bs:seek(bs.size-footerSize)
    local footer, err = readFooter(bs)
    res.Footer = footer

    -- if footer == false, then it's not an extended
    -- format file.  Otherwise, the footer is returned
    -- In either case, time to read the header
    bs:seek(0)
    local header, err = readHeader(bs)
    res.Header = header

    if not header then
        res.Error = "error reading targa headder: "..tostring(err)
        return false, res
    end

    -- We have the header, so we should be able
    -- to read the body
    pixbuff, err = readBody(bs, header)

    res.PixelBuffer = pixbuff
    res.Error = err

    return pixbuff, header, footer
end

local function readFromFile(filename)
    local filemap, err = mmap(filename)
    if not filemap then
        return false, "file not mapped ()"..tostring(err)
    end

    local bs, err = binstream(filemap:getPointer(), filemap:length(), 0, true )

    if not bs then
        return false, err
    end

    return readFromStream(bs)
end


return {
    ColorMapType = ColorMapType;
    HorizontalOrientation = HorizontalOrientation;
    VerticalOrientation = VerticalOrientation;
    Interleave = Interleave;
    ImageType = ImageType;

    readHeader = readHeader;
    readFooter = readFooter;
    readBody = readBody;

    readFromFile = readFromFile;
    readFromStream = readFromStream;
}