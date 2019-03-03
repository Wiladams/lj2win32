local ffi = require "ffi"
local C = ffi.C
local bit = require("bit")
local band = bit.band
local bnot = bit.bnot
local lshift = bit.lshift
local rshift = bit.rshift

local gdi_ffi = require("win32.wingdi")

--[[
	DeviceContext

	The Drawing Context for good ol' GDI drawing

	You can easily create a device context using a simple constructor mechanism
	
	local dc = DeviceContext(Driver, Device, Output, InitData)

	This is similar to the CreateDC() function call within Win32, but a Lua object
	is returned, or "nil, error" if it fails for some reason.

	If you don't specify any parameters, the device will be the default screen
--]]
local DeviceContext = {}
setmetatable(DeviceContext, {
	__call = function(self, ...)
		return self:create(...)
	end,
})

local DeviceContext_mt = {
	__index = DeviceContext,

	__tostring = function(self)
		return string.format("DeviceContext:init(0x%s)", tostring(self.Handle))
	end,
}

function DeviceContext.init(self, rawhandle)
	local obj = {
		Handle = rawhandle;
	}
	setmetatable(obj, DeviceContext_mt)

	return obj;
end

function DeviceContext.create(self, lpszDriver, lpszDevice, lpszOutput, lpInitData)
	lpszDriver = lpszDriver or "DISPLAY"
	
	local rawhandle = ffi.C.CreateDCA(lpszDriver, lpszDevice, lpszOutput, lpInitData);
	
	if rawhandle == nil then
		return nil, "could not create Device Context as specified"
	end

	-- do these initializations here so that the init() call
	-- doesn't have to change anything about the context
	-- Set some default state
	C.SetGraphicsMode(rawhandle, C.GM_ADVANCED)
	
	-- so text draws with a transparent background by default
	C.SetBkMode(rawhandle, C.TRANSPARENT);

	return self:init(rawhandle)
end

--[[
	DeviceContext:CreateForMemory()

	By default will create a DeviceContext tied to memory, compatible with the screen
]]
function DeviceContext.CreateForMemory(self, hDC)
	hDC = hDC or C.CreateDCA("DISPLAY", nil, nil, nil)
	local rawhandle = C.CreateCompatibleDC(hDC) 
	
	-- need to delete original DC
	-- ffi.C.DeleteDC(hDC)

	C.SetGraphicsMode(rawhandle, C.GM_ADVANCED)
	C.SetBkMode(rawhandle, C.TRANSPARENT);

	return self:init(rawhandle)
end


function DeviceContext.clone(self)
	local hDC = ffi.C.CreateCompatibleDC(self.Handle);
	local ctxt = DeviceContext:init(hDC)
	
	return ctxt;
end

--[[
DeviceContext.createCompatibleBitmap = function(self, width, height)
	local bm, err = GDIBitmap:createCompatible(width, height, self);

	return bm, err
end
--]]

--[[
Device Capabilities
--]]
function DeviceContext.capability(self, cap)
	local res = C.GetDeviceCaps(self.Handle, cap)
	return res
end

-- Coordinates and Transforms
function DeviceContext.setGraphicsMode(self, mode)
	C.SetGraphicsMode(self.Handle, mode)

	return true;
end

function DeviceContext.setMapMode(self, mode)
	C.SetMapMode(self.Handle, mode)

	return true;
end

-- Device Context State
function DeviceContext.flush(self)
	return C.GdiFlush()
end

function DeviceContext.restore(self, nSavedDC)
	nSavedDC = nSavedDC or -1;
	
	return C.RestoreDC(self.Handle, nSavedDC);
end

function DeviceContext.save(self)
	local stateIndex = C.SaveDC(self.Handle);
	if stateIndex == 0 then
		return false, "failed to save GDI state"
	end

	return stateIndex; 
end

-- Object Management
function DeviceContext.SelectObject(self, gdiobj)
	if not gdiobj then return false end
	
	local res = ffi.C.SelectObject(self.Handle, gdiobj)
	if res == nil then
		return false
	end

	return res;
end

function DeviceContext.SelectStockObject(self, objectIndex)
    -- First get a handle on the object
    local objHandle = ffi.C.GetStockObject(objectIndex);

    --  Then select it into the device context
	return ffi.C.SelectObject(self.Handle, objHandle);
end


-- Drawing Attributes
function DeviceContext.UseDCBrush(self)
	self:SelectStockObject(C.DC_BRUSH)
end

function DeviceContext.UseDCPen(self)
	self:SelectStockObject(C.DC_PEN)
end

function DeviceContext.SetDCBrushColor(self, color)
	return C.SetDCBrushColor(self.Handle, color)
end

function DeviceContext.SetDCPenColor(self, color)
	return C.SetDCPenColor(self.Handle, color)
end

--[[
	Moving cursor
]]
function DeviceContext.MoveTo(self, x, y)
	local result = C.MoveToEx(self.Handle, x, y, nil);

	return result
end

function DeviceContext.MoveToEx(self, x, y, lpPoint)
	return C.MoveToEx(self.Handle, X, Y, lpPoint);
end


-- Drawing routines
function DeviceContext.GetPixel(self, x, y)
	return C.GetPixel(self.Handle, x, y)
end

function DeviceContext.SetPixel(self, x, y, cref)
	return C.SetPixel(self.Handle, x, y, cref);
end

function DeviceContext.SetPixelV(self, x, y, cref)
	return C.SetPixelV(self.Handle, X, Y, cref);
end



function DeviceContext.LineTo(self, xend, yend)
	local success = C.LineTo(self.Handle, xend, yend)~= 0;
	
	return success
end

function DeviceContext.Arc(self, x1,y1,x2,y2,x3,y3,x4,y4)

	local success = C.Arc(self.Handle,
		x1,y1,
		x2,y2,
		x3,y3,
		x4,y4) ~= 0;

	return success
end

function DeviceContext.ArcTo(self, left, top, right, bottom, xr1, yr1, xr2, yr2)

	local success = C.Arc(self.Handle,
		left, top, right, bottom, 
		xr1, yr1, xr2, yr2) ~= 0;

	return success
end

function DeviceContext.AngleArc(  self,  x,  y,  r,  StartAngle,  SweepAngle)
	return C.AngleArc(self.Handle,  x,  y,  r,  StartAngle,  SweepAngle)
end

function DeviceContext.Chord(self, x1, y1, x2, y2, x3, y3, x4, y4)
	local success = C.Chord(self.Handle,
		x1,y1,
		x2,y2,
		x3,y3,
		x4,y4) ~= 0;

	return success
end

function DeviceContext.Pie(self, left, top, right, bottom, xr1, yr1, xr2, yr2)
	local success = C.Pie(self.Handle,
		left,top,right,bottom,
		xr1,yr1,xr2,yr2) ~= 0;

	return success
end

function DeviceContext.Ellipse(self, nLeftRect, nTopRect, nRightRect, nBottomRect)
	local success = C.Ellipse(self.Handle,nLeftRect,nTopRect,nRightRect,nBottomRect) ~= 0;
	
	return success;
end

-- Drawing Rectangles
function DeviceContext.Rectangle(self, left, top, right, bottom)
	local success = C.Rectangle(self.Handle, left, top, right, bottom) ~= 0;

	return success
end

function DeviceContext.RoundRect(self, left, top, right, bottom, width, height)
	local success = C.RoundRect(self.Handle, left, top, right, bottom, width, height) ~= 0;

	return success
end

-- Drawing Polys
function DeviceContext.Polyline(self, apt, cpt)
	-- if it's a table, create an array of POINTs
	-- if it's already points, pass it through
	local success = C.Polyline( self.Handle,  apt,  cpt) ~= 0;

	return success
end

function DeviceContext.PolylineTo(self, apt, cpt)
	local success = C.PolylineTo( self.Handle,  apt,  cpt) ~= 0;

	return success
end

function DeviceContext.PolyPolyline(self, apt, cpt)
	local success = C.PolyPolyline( self.Handle,  apt,  cpt) ~= 0;

	return success
end

function DeviceContext.PolyBezier(self, apt, cpt)
	local success = C.PolyBezier( self.Handle,  apt,  cpt) ~= 0;

	return success
end

function DeviceContext.PolyBezierTo(self, apt, cpt)
	local success = C.PolyBezierTo( self.Handle,  apt,  cpt) ~= 0;

	return success
end

function DeviceContext.Polygon(self, lpPoints, nCount)
	local success = C.Polygon(self.Handle,lpPoints, nCount) ~= 0;

	return success;
end

function DeviceContext.PolyPolygon(self, lpPoints, nCount, asz)
	local success = C.PolyPolygon(self.Handle,lpPoints, nCount, asz) ~= 0;

	return success;
end

function DeviceContext.PolyDraw(self, apt, aj, cpt)
	local success = C.PolyDraw(self.Handle, apt, aj, cpt) ~= 0;

	return success
end

-- Filling
function DeviceContext.FloodFill(self, x, y, cref, kind)
	local success = C.FloodFill(self.Handle, x, y, cref) ~= 0

	return success
end

function DeviceContext.ExtFloodFill(self, x, y, cref, kind)
	local success = C.ExtFloodFill(self.Handle, x, y, cref, kind) ~= 0

	return success
end

--[[
	Region specifics
]]
function DeviceContext.FillRgn(self, rgn, brush)
	local success = C.FillRgn(self.Handle, rgn, brush) ~= 0

	return success
end

function DeviceContext.FrameRgn(self, rgn, brush, w, h)
	local success = C.FrameRgn(self.Handle, rgn, brush, w, h) ~= 0

	return success
end

function DeviceContext.PaintRgn(self, rgn)
	local success = C.PaintRgn(self.Handle, rgn) ~= 0

	return success
end

-- Text Drawing
function DeviceContext.SetBkColor(self, cref)
	return C.SetBkColor(self.Handle, cref);
end

function DeviceContext.SetBkMode(self, mode)
	return C.SetBkMode(self.Handle, mode)
end

function DeviceContext.SetTextColor(self, cref)
	return C.SetTextColor(self.Handle, cref);
end

function DeviceContext.ExtTextOut(self, x, y, options, lprect, lpString, c, lpDx)
	local success = C.ExtTextOutA(self.Handle, x, y, options, lprect, lpString, c, lpDx);

	return success
end

function DeviceContext.Text(self, txt, x, y)
	x = x or 0
	y = y or 0
	
	return C.TextOutA(self.Handle, x, y, txt, #txt);
end

-- Bitmap drawing
function DeviceContext.BitBlt(self, nXDest, nYDest, nWidth, nHeight, hdcSrc, nXSrc, nYSrc, dwRop)
	nXSrc = nXSrc or 0
	nYSrc = nYSrc or 0
	dwRop = dwRop or ffi.C.SRCCOPY
	
	return C.BitBlt(self.Handle,nXDest,nYDest,nWidth,nHeight,hdcSrc,nXSrc,nYSrc,dwRop);
end

function DeviceContext.StretchDIBits(self, XDest, YDest, nDestWidth, nDestHeight, XSrc, YSrc, nSrcWidth, nSrcHeight, lpBits, lpBitsInfo, iUsage, dwRop)
	XDest = XDest or 0
	YDest = YDest or 0
	iUsage = iUsage or 0
	dwRop = dwRop or ffi.C.SRCCOPY;

	return C.StretchDIBits(hdc,XDest,YDest,nDestWidth,nDestHeight,XSrc,YSrc,nSrcWidth,nSrcHeight,lpBits,lpBitsInfo,iUsage,dwRop);
end

function DeviceContext.GetDIBits(self, hbmp, uStartScan, cScanLines, lpvBits, lpbi, uUsage)
	return C.GetDIBits(self.Handle,hbmp,uStartScan,cScanLines,lpvBits,lpbi,uUsage);
end

function DeviceContext.StretchBlt(self, img, XDest, YDest,DestWidth,DestHeight)
			XDest = XDest or 0
			YDest = YDest or 0
			DestWidth = DestWidth or img.Width
			DestHeight = DestHeight or img.Height
--print("stretchBlt: ", XDest, YDest, DestWidth, DestHeight)
--print(" Size: ", img.Width, img.Height, img.BitsPerElement)
--print(" Data: ", img.Data, img.Pixels)
			-- Draw a pixel buffer
			local bmInfo = ffi.new("BITMAPINFO")
			bmInfo.bmiHeader.biSize = ffi.sizeof("BITMAPINFOHEADER")
			bmInfo.bmiHeader.biWidth = img.Width;
			bmInfo.bmiHeader.biHeight = img.Height;
			bmInfo.bmiHeader.biPlanes = 1;
			bmInfo.bmiHeader.biBitCount = img.BitsPerElement;
			bmInfo.bmiHeader.biClrImportant = 0;
			bmInfo.bmiHeader.biClrUsed = 0;
			bmInfo.bmiHeader.biCompression = 0;

			return self:StretchDIBits(XDest,YDest,DestWidth,DestHeight,
				0,0,img.Width, img.Height,
				img.Data,
				bmInfo);
end

--[[
	Path handling
	Within a Begin/EndPath, you can use the following drawing commands

--AngleArc 
--Arc 
--ArcTo 
--Chord 
--CloseFigure 
--Ellipse 
--ExtTextOut 
--LineTo 
--MoveToEx 
--Pie 
--PolyBezier 
--PolyBezierTo 
--PolyDraw 
--Polygon 
--Polyline 
--PolylineTo 
--PolyPolygon 
--PolyPolyline 
--Rectangle 
--RoundRect 
--TextOut 
]]
function DeviceContext.BeginPath(self)
	local success = C.BeginPath(self.Handle)~=0;
	return success;
end

function DeviceContext.EndPath(self)
	local success = C.EndPath(self.Handle)~= 0;
	return success;
end

function DeviceContext.CloseFigure(self)
	local success = C.CloseFigure(self.Handle) ~= 0
	return success
end

function DeviceContext.FillPath(self)
	local success = C.FillPath(self.Handle) ~= 0;
	return success;
end

function DeviceContext.StrokePath(self)
	local success = C.StrokePath(self.Handle) ~= 0;
	return success;
end

function DeviceContext.StrokeAndFillPath(self)
	local success = C.StrokeAndFillPath(self.Handle);
	return success;
end


return DeviceContext;
