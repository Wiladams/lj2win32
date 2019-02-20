--[[
    References
    
    http://www.fileformat.info/format/tga/egff.htm#TGA-DMYID.2
    http://www.dca.fee.unicamp.br/~martino/disciplinas/ea978/tgaffs.pdf
--]]

local ffi = require("ffi")
local bit = require("bit")
local band, bor = bit.band, bit.bor
local lshift, rshift = bit.lshift, bit.rshift

local binstream = require("binstream")
local enum = require("enum")
local mmap = require("mmap")
local PixelBuffer = require("PixelBuffer")






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

local function readHeader(bs, res)
    res = res or {}

    res.IDLength = bs:readOctet()           -- 00h  Size of Image ID field
    res.ColorMapType = bs:readOctet()       -- 01h  Color map type 
    res.ImageType = bs:readOctet()          -- 02h  Image type code
    res.CMapStart = bs:readUInt16()         -- 03h  Color map origin
    res.CMapLength = bs:readUInt16()        -- 05h  Color map length
    res.CMapDepth = bs:readOctet()          -- 07h  Depth of color map entries

    -- Image Description
    res.XOffset = bs:readUInt16()           -- 08h  X origin of image
    res.YOffset = bs:readUInt16()           -- 0Ah  Y origin of image
    res.Width = bs:readUInt16()             -- 0Ch  Width of image - Maximum 512
    res.Height = bs:readUInt16()            -- 0Eh  Height of image - Maximum 482
    res.PixelDepth = bs:readOctet()         -- 10h  Number of bits per pixel
    res.ImageDescriptor = bs:readOctet()    -- 11h  Image descriptor byte

    res.BytesPerPixel = res.PixelDepth / 8

    -- If there's an identification section, read that next
    if res.IDLength > 0 then
        header.ImageIdentification = bs:readBytes(header.IDLength)
    end

    -- If there's a color map, read that next

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

local function readBody(bs, header)
    --print("targa.readBody, BEGIN")
    -- create a pixelbuffer of the right size
    --print("targa.readBody, 1.0", header.Width, header.Height, header.BytesPerPixel)
    local bpp = header.BytesPerPixel
    local pb = PixelBuffer(header.Width, header.Height)
 
    -- create a type to represent the pixel data
    local pixtype = ffi.typeof("uint8_t[$]", header.BytesPerPixel)
    local pixtype_ptr = ffi.typeof("$ *", pixtype)
    --print("targa.readBody, 2.0", pixtype, pixtype_ptr)

    -- create an instance of a single pixel we'll use to stuff the 
    -- PixelBuffer
    local pix = ffi.new("struct Pixel32")

    -- get a pointer on the current position within the binstream
    -- and cast it to our pixtype_ptr
    --local data = ffi.cast(pixtype_ptr, bs:getPositionPointer())
    --local dataOffset = 0
    local databuff = pixtype()

    --print("targa.readBody, 3.0: ", data, bs:remaining())

    --  Start with left to right orientation
    local dx = 1;
    local xStart = 0
    local xEnd = header.Width-1
    -- switch thing up for right to left
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

    for y=yStart,yEnd, dy do 
        for x=xStart,xEnd, dx do
            local nRead = bs:readByteBuffer(bpp, databuff)

            if header.ImageType == ImageType.TrueColor then
                pix.Red = databuff[0]
                pix.Green = databuff[1]
                pix.Blue = databuff[2]
            elseif header.ImageType == ImageType.Monochrome then
                pix.Red = databuff[0]
                pix.Green = databuff[0]
                pix.Blue = databuff[0]
            end

            pb:set(x,y, pix)
        end
    end
    
    --print("targa.readBody, END")

    return pb
end


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


    local trueColor = tonumber(ImageType.TrueColor)
    --print("ImageType.TrueColor:", header.ImageType, trueColor)

--[[
    --print("header.ImageType == ImageType.TrueColor ", header.ImageType == ImageType.TrueColor)
    if header.ImageType ~= trueColor then
        res.Error = "can only read uncompressed TrueType"
        return false, res
    end
--]]
    -- Read the body
    pixbuff, err = readBody(bs, header)

    res.PixelBuffer = pixbuff
    res.Error = err

    if not pixbuff then
        return false, res
    end

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