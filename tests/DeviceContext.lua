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



-- Drawing routines
function DeviceContext.MoveTo(self, x, y)
	local result = C.MoveToEx(self.Handle, x, y, nil);
	return result
end

function DeviceContext.MoveToEx(self, x, y, lpPoint)
	return C.MoveToEx(self.Handle, X, Y, lpPoint);
end

function DeviceContext.SetPixel(self, x, y, cref)
	return C.SetPixel(self.Handle, x, y, cref);
end

function DeviceContext.SetPixelV(self, x, y, cref)
	return C.SetPixelV(self.Handle, X, Y, cref);
end

function DeviceContext.LineTo(self, xend, yend)
	local result = C.LineTo(self.Handle, xend, yend);
	return result
end

function DeviceContext.Ellipse(self, nLeftRect, nTopRect, nRightRect, nBottomRect)
	return C.Ellipse(self.Handle,nLeftRect,nTopRect,nRightRect,nBottomRect);
end

function DeviceContext.Polygon(self, lpPoints, nCount)
	local res = C.Polygon(self.Handle,lpPoints, nCount);

	return true;
end

function DeviceContext.Rectangle(self, left, top, right, bottom)
	return C.Rectangle(self.Handle, left, top, right, bottom);
end

function DeviceContext.RoundRect(self, left, top, right, bottom, width, height)
	return C.RoundRect(self.Handle, left, top, right, bottom, width, height);
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

			-- Draw a pixel buffer
			local bmInfo = BITMAPINFO();
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

AngleArc 
Arc 
ArcTo 
Chord 
CloseFigure 
--Ellipse 
ExtTextOut 
--LineTo 
--MoveToEx 
Pie 
PolyBezier 
PolyBezierTo 
PolyDraw 
--Polygon 
Polyline 
PolylineTo 
PolyPolygon 
PolyPolyline 
--Rectangle 
--RoundRect 
--TextOut 
]]
function DeviceContext.BeginPath(self)
	return C.BeginPath(self.Handle);
end

function DeviceContext.EndPath(self)
	return C.EndPath(self.Handle)
end



return DeviceContext;
