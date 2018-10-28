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
    end
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

-- Put a bunch of drawing calls here
--[[
    // Setting colors
DPROC_API void colorMode(const COLORMODE mode, const float max1 = -1, const float max2 = -1, const float max3 = -1, const float maxA = -1);
DPROC_API DPPIXELVAL color(const float v1, const float v2 = -1, const float v3 = -1, const float alpha = -1);

DPROC_API void backgroundValues(const float v1, const float v2 = -1, const float v3 = -1, const float alpha = -1);
DPROC_API void background(const DPPIXELVAL value);
DPROC_API void backgroundImage(pb_rgba *bg);
//void clear();

//void colorMode();
DPROC_API void noFill();
DPROC_API void fillValues(const float v1, const float v2 = -1, const float v3 = -1, const float alpha = -1);
DPROC_API void fill(const DPPIXELVAL value);

DPROC_API void noStroke();
DPROC_API void stroke(const DPPIXELVAL value);
DPROC_API void strokeValues(const float v1, const float v2 = -1, const float v3 = -1, const float alpha = -1);

// attributes
DPROC_API void ellipseMode(const RECTMODE mode);
DPROC_API void noSmooth();
DPROC_API void rectMode(const RECTMODE mode);
DPROC_API void smooth();
//DPROC_API void strokeCap();
//DPROC_API void strokeJoin();
DPROC_API void strokeWeight(const float weight);


// 2D primitives
DPROC_API void bezier(const int x1, const int y1, const int x2, const int y2, const int x3, const int y3, const int segments = 60);
DPROC_API void ellipse(const float a, const float b, const float c, const float d);
DPROC_API void line(const int x1, const int y1, const int x2, const int y2);
DPROC_API void lineloop(const size_t nPtr, const int *pts);
DPROC_API void point(const int x, const int y);
DPROC_API void rect(const int a, const int b, const int c, const int d);
DPROC_API void quad(const int x1, const int y1, const int x2, const int y2, const int x3, const int y3, const int x4, const int y4);
DPROC_API void triangle(const int x1, const int y1, const int x2, const int y2, const int x3, const int y3);
DPROC_API void polygon(int nverts, int *a);

// Text

// createFont
// DPROC_API loadFont()
DPROC_API void setFont(const uint8_t *fontdata);
DPROC_API void text(const char *str, const int x, const int y);
//DPROC_API void textFont(font_t *font);
DPROC_API void textAlign(const int alignX = TX_LEFT, const int alignY = TX_BOTTOM);
// DPROC_API textLeading()
// DPROC_API textMode()
DPROC_API void textSize(const int size);
// DPROC_API textWidth()
// DPROC_API textAscent()
// DPROC_API textDescent()

// Shape
DPROC_API void beginShape(const int shapeKind = GR_POLYGON);
DPROC_API void vertex(const int x, const int y);
DPROC_API void bezierVertex(const int x1, const int y1, const int x2, const int y2, const int x3, const int y3);
DPROC_API void endShape(const int kindOfClose = STROKE);

// Images
DPROC_API void image(PSD img, const float a, const float b, const float c = -1, const float d = -1);
DPROC_API PSD loadImage(const char *filename, const char *extension = nullptr);

// Math
DPROC_API double dist(int x1, int y1, int x2, int y2);
DPROC_API double randomRange(const float low, const float high);
DPROC_API double random(const float high);
DPROC_API inline double sq(const double value) { return value*value; }

// Coordinate transformation
DPROC_API void applyMatrix();
DPROC_API void popMatrix();
DPROC_API void printMatrix();
DPROC_API void pushMatrix();
DPROC_API void resetMatrix();
DPROC_API void rotate(const float angle, const coord x, const coord y, const coord z);
DPROC_API void rotateX(const float anglex);
DPROC_API void rotateY(const float angley);
DPROC_API void rotateZ(const float anglez);
DPROC_API void scale(const float a, const float b, const float c);
DPROC_API void shearX();
DPROC_API void shearY();
DPROC_API void shearZ();
DPROC_API void translate(const coord x, const coord y, const coord z = 0);

]]


return GDISurface
