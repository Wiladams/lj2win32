local ffi = require("ffi")
local bit = require("bit")
local bnot = bit.bnot
local lshift, rshift = bit.lshift, bit.rshift
local band, bor = bit.band, bit.bor

local gdi = require("win32.wingdi")
local DeviceContext = require("DeviceContext")


local function GetAlignedByteCount(width, bitsperpixel, alignment)
	local bytesperpixel = bitsperpixel / 8;
	return band((width * bytesperpixel + (alignment - 1)), bnot(alignment - 1));
end


local function GDIDIBSection(obj)
    obj = obj or {
        width = 1;
        height = 1;
        bitsPerPixel = 32;
    }
    obj.width = obj.width or 1;
    obj.height = obj.height or 1;
    obj.bitsPerPixel = obj.bitsPerPixel or 32;
    obj.alignment = obj.alignment or 2;

	obj.bytesPerRow = GetAlignedByteCount(obj.width, obj.bitsPerPixel, obj.alignment)


	-- Need to construct a BITMAPINFO structure
	-- to describe the image we'll be creating
    local info = ffi.new("BITMAPINFO")
    -- need to initialize the info header
    info.bmiHeader.biSize = ffi.sizeof("BITMAPINFOHEADER")
	info.bmiHeader.biWidth = obj.width
	info.bmiHeader.biHeight = obj.height
	info.bmiHeader.biPlanes = 1
	info.bmiHeader.biBitCount = obj.bitsPerPixel
	info.bmiHeader.biSizeImage = obj.bytesPerRow * obj.height
	info.bmiHeader.biClrImportant = 0
	info.bmiHeader.biClrUsed = 0
	info.bmiHeader.biCompression = 0	-- GDI32.BI_RGB
    
    obj.info = info;

	-- Create the DIBSection, using the screen as
    -- the source DC
    
    -- Create a memory device context, either compatible
    -- with something, or just compatible with DISPLAY
    obj.deviceContext = obj.deviceContext or DeviceContext:CreateForMemory(obj.compatDC)

	local pixelP = ffi.new("void *[1]")
	obj.Handle = ffi.C.CreateDIBSection(obj.deviceContext.Handle,
        info,
		ffi.C.DIB_RGB_COLORS,
		pixelP,
		nil,
        0);
        
--print("GDIDIBSection Handle: ", obj.Handle)
    obj.pixelData = {
        data = pixelP[0];
        size = info.bmiHeader.biSizeImage;
    }

	return obj
end




return GDIDIBSection
