    --[[
        A GDI Surface is simply something that you can draw on.
        It is implemented as a DIBSection, with an associated in-memory Device Context 
    ]]
local ffi = require("ffi")
local bit = require("bit")
local bnot = bit.bnot;
local band, bor = bit.band, bit.bor
local lshift, rshift = bit.lshift, bit.rshift

local wingdi = require("win32.wingdi")
local DeviceContext = require("DeviceContext")


local function GetAlignedByteCount(width, bitsperpixel, alignment)
	local bytesperpixel = bitsperpixel / 8;
	return band((width * bytesperpixel + (alignment - 1)), bnot(alignment - 1));
end


local GDISurface = {}
setmetatable(GDISurface, {
    __call = function(self, ...)
        return self:new(...)
    end;

    __index = DeviceContext;
})
local GDISurface_mt = {
    __index = GDISurface;
}


function GDISurface.init(self, params)
    local obj = params or {}

    obj.width = obj.width or 1
    obj.height = obj.height or 1
    obj.bitsPerPixel = obj.bitsPerPixel or 32;
    obj.alignment = obj.alignment or 4;

    obj.bytesPerRow = GetAlignedByteCount(obj.width, obj.bitsPerPixel, obj.alignment)

    local info = ffi.new("BITMAPINFO")
    info.bmiHeader.biSize = ffi.sizeof("BITMAPINFOHEADER");
    info.bmiHeader.biWidth = obj.width;
	info.bmiHeader.biHeight = -obj.height;	-- top-down DIB Section
    info.bmiHeader.biPlanes = 1;
	info.bmiHeader.biBitCount = obj.bitsPerPixel;
    info.bmiHeader.biSizeImage = obj.bytesPerRow * obj.height;
    info.bmiHeader.biClrImportant = 0;
    info.bmiHeader.biClrUsed = 0;
    info.bmiHeader.biCompression = ffi.C.BI_RGB;

    obj.info = info;

    local pixelP = ffi.new("void *[1]")
	obj.DIBHandle = ffi.C.CreateDIBSection(nil,
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

    -- Create a memory device context, either compatible
    -- with something, or just compatible with DISPLAY
    obj.DC = DeviceContext:CreateForMemory(obj.compatDC)

    -- select the object into the context so we're ready to draw
    local selected = obj.DC:SelectObject(obj.DIBHandle)

    setmetatable(obj, GDISurface_mt)

    return obj;
end

function GDISurface.new(self, ...)
    return self:init(...)
end



return GDISurface
