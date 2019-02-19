-- http://www.fileformat.info/format/tga/egff.htm#TGA-DMYID.2

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

local ImageOrigin = enum {

    [0x00] = "BottomLeft",
    [0x10] = "BottomRight",
    [0x20] = "TopLeft",
    [0x30] = "TopRight"
}

local OriginMask = 0x30;

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

--[[
public struct TargaHeader
{
    public byte IDLength;              /* 00h  Size of Image ID field */
    public TargaColorMapType ColorMapType;          /* 01h  Color map type */
    public TargaImageType ImageType;   /* 02h  Image type code */
    public short CMapStart;            /* 03h  Color map origin */
    public short CMapLength;           /* 05h  Color map length */
    public byte CMapDepth;             /* 07h  Depth of color map entries */
    public short XOffset;              /* 08h  X origin of image */
    public short YOffset;              /* 0Ah  Y origin of image */
    public short Width;                // 0Ch  Width of image - Maximum 512
    public short Height;               // 0Eh  Height of image - Maximum 482
    public byte PixelDepth;            /* 10h  Image pixel size */
    public byte ImageDescriptor;       /* 11h  Image descriptor byte */
};
--]]
local function readHeader(bs, res)
    res = res or {}

    res.IDLength = bs:readOctet()
    res.ColorMapType = bs:readOctet()
    res.ImageType = bs:readOctet()
    res.CMapStart = bs:readUInt16()
    res.CMapLength = bs:readUInt16()
    res.CMapDepth = bs:readOctet()

    -- Image Description
    res.XOffset = bs:readUInt16()
    res.YOffset = bs:readUInt16()
    res.Width = bs:readUInt16()
    res.Height = bs:readUInt16()
    res.PixelDepth = bs:readOctet()
    res.ImageDescriptor = bs:readOctet()

    res.BytesPerPixel = res.PixelDepth / 8

    if res.IDLength > 0 then
        header.ImageIdentification = bs:readBytes(header.IDLength)
    end

--[[
    //              Image Descriptor Byte.                        |
    //  Bits 3-0 - number of attribute bits associated with each  |
    //               pixel.  For the Targa 16, this would be 0 or |
    //               1.  For the Targa 24, it should be 0.  For   |
    //               Targa 32, it should be 8.                    |
    //  Bit 4    - controls left/right transfer of pixels to 
    ///             the screen.
    ///             0 = left to right
    ///             1 = right to left
    //  Bit 5    - controls top/bottom transfer of pixels to 
    ///             the screen.
    ///             0 = bottom to top
    ///             1 = top to bottom
    ///             
    ///             In Combination bits 5/4, they would have these values
    ///             00 = bottom left
    ///             01 = bottom right
    ///             10 = top left
    ///             11 = top right
    ///             
    //  Bits 7-6 - Data storage interleaving flag.                |
    //             00 = non-interleaved.                          |
    //             01 = two-way (even/odd) interleaving.          |
    //             10 = four way interleaving.                    |
    //             11 = reserved.         
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
    
    return rs
end

local function readBody(bs, header)
    -- create a pixelbuffer of the right size
    local pb = PixelBuffer(header.Width, header.Height)

    -- create a type to represent the pixel data
    local pixtype = ffi.typeof("uint8_t[$]", header.BytesPerPixel)
    local pixtype_ptr = ffi.typeof("$*", pixtype)

    -- create an instance of a single pixel we'll use to stuff the 
    -- PixelBuffer
    local pix = ffi.new("Pixel32")

    -- get a pointer on the current position within the binstream
    -- and cast it to our pixtype_ptr
    local data = ffi.cast(pixtype_ptr, bs:getPositionPointer())
    local dataOffset = 0

    for y=0,header.Width-1 do 
        for x=0,header.Height-1 do
            pix.Red = data[dataOffset][0]
            pix.Green = data[dataOffset][1]
            pix.Blue = data[dataOffset][2]
            pb:set(x,y, pix)

            dataOffset = dataOffset + 1
        end
    end

    return pb
end


local function readFromStream(bs, res)
    res = res or {}

    -- position 26 bytes from the end and try 
    -- to read the footer
    bs:seek(bs.size-footerSize)
    local footer, err = readFooter(bs)
    if footer then
        res.Footer = footer
    end

    -- if footer == false, then it's not an extended
    -- format file.  Otherwise, the footer is returned
    -- In either case, time to read the header
    bs:seek(0)
    local header, err = readHeader(bs)

    if not header then
        return false, res
    end

    res.Header = header

    --print("ImageType.TrueColor:", type(header.ImageType), type(ImageType.TrueColor))
--[[
    if header.Imagetype ~= ImageType.TrueColor then
        res.Error = "can only read uncompressed TrueType"
        return false, res
    end
--]]
    -- Read the body
    buff, err = readBody(bs, header)

    res.PixelBuffer = buff
    res.Error = err

    if not buff then
        return false, res
    end

    return res
end

local function readFromFile(filename)
    local filemap, err = mmap(filename)
    if not filemap then
        return false, "file not mapped ()"..tostring(err)
    end

    local bs, err = binstream(filemap:getPointer(), #filemap, 0, true )

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

    readFromFile = readFromFile;
    readFromStream = readFromStream;
}