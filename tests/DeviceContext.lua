local ffi = require "ffi"
local bit = require("bit")
local band = bit.band
local bnot = bit.bnot
local lshift = bit.lshift
local rshift = bit.rshift

local gdi_ffi = require("win32.gdi32")

--[[
	DeviceContext

	The Drawing Context for good ol' GDI drawing
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
		return string.format("DeviceContext(0x%s)", tostring(self.Handle))
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
	
	local rawhandle = gdi_ffi.CreateDCA(lpszDriver, lpszDevice, lpszOutput, lpInitData);
	
	if rawhandle == nil then
		return nil, "could not create Device Context as specified"
	end

	-- default to advanced graphics mode instead of GM_COMPATIBLE
	gdi_ffi.SetGraphicsMode(rawhandle, "GM_ADVANCED")

	return self:init(rawhandle)
end

function DeviceContext.CreateForMemory(self, hDC)
	hDC = hDC or gdi_ffi.CreateDCA("DISPLAY", nil, nil, nil)
	local rawhandle = gdi_ffi.CreateCompatibleDC(hDC) 
	
	return self:init(rawhandle)
end


function DeviceContext.clone(self)
	local hDC = gdi_ffi.CreateCompatibleDC(self.Handle);
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
DeviceContext.setGraphicsMode = function(self, mode)
	gdi_ffi.SetGraphicsMode(self.Handle, mode)

	return true;
end

DeviceContext.setMapMode = function(self, mode)
	gdi_ffi.SetMapMode(self.Handle, mode)

	return true;
end

-- Device Context State
DeviceContext.flush = function(self)
	return gdi_ffi.GdiFlush()
end

DeviceContext.restore = function(self, nSavedDC)
	nSavedDC = nSavedDC or -1;
	
	return gdi_ffi.RestoreDC(self.Handle, nSavedDC);
end

DeviceContext.save = function(self)
	local stateIndex = gdi_ffi.SaveDC(self.Handle);
	if stateIndex == 0 then
		return false, "failed to save GDI state"
	end

	return stateIndex; 
end

-- Object Management
DeviceContext.SelectObject = function(self, gdiobj)
	gdi_ffi.SelectObject(self.Handle, gdiobj.Handle)
end

DeviceContext.SelectStockObject = function(self, objectIndex)
    -- First get a handle on the object
    local objHandle = gdi_ffi.GetStockObject(objectIndex);

    --  Then select it into the device context
	return gdi_ffi.SelectObject(self.Handle, objHandle);
end


-- Drawing Attributes
DeviceContext.UseDCBrush = function(self)
	self:SelectStockObject(ffi.C.DC_BRUSH)
end

DeviceContext.UseDCPen = function(self)
	self:SelectStockObject(ffi.C.DC_PEN)
end

DeviceContext.SetDCBrushColor = function(self, color)
	return gdi_ffi.SetDCBrushColor(self.Handle, color)
end

DeviceContext.SetDCPenColor = function(self, color)
	return gdi_ffi.SetDCPenColor(self.Handle, color)
end


-- Drawing routines
DeviceContext.MoveTo = function(self, x, y)
	local result = gdi_ffi.MoveToEx(self.Handle, x, y, nil);
	return result
end

DeviceContext.MoveToEx = function(self, x, y, lpPoint)
	return gdi_ffi.MoveToEx(self.Handle, X, Y, lpPoint);
end

DeviceContext.SetPixel = function(self, x, y, color)
	return gdi_ffi.SetPixel(self.Handle, x, y, color);
end

DeviceContext.SetPixelV = function(self, x, y, crColor)
	return gdi_ffi.SetPixelV(self.Handle, X, Y, crColor);
end

DeviceContext.LineTo = function(self, xend, yend)
	local result = gdi_ffi.LineTo(self.Handle, xend, yend);
	return result
end

DeviceContext.Ellipse = function(self, nLeftRect, nTopRect, nRightRect, nBottomRect)
	return gdi_ffi.Ellipse(self.Handle,nLeftRect,nTopRect,nRightRect,nBottomRect);
end

DeviceContext.Polygon = function(self, lpPoints, nCount)
	local res = gdi_ffi.Polygon(self.Handle,lpPoints, nCount);

	return true;
end

function DeviceContext.Rectangle(self, left, top, right, bottom)
	return gdi_ffi.Rectangle(self.Handle, left, top, right, bottom);
end

function DeviceContext.RoundRect(self, left, top, right, bottom, width, height)
	return gdi_ffi.RoundRect(self.Handle, left, top, right, bottom, width, height);
end

-- Text Drawing
function DeviceContext.Text(self, txt, x, y)
	x = x or 0
	y = y or 0
	
	return gdi_ffi.TextOutA(self.Handle, x, y, txt, string.len(txt));
end

-- Bitmap drawing
function DeviceContext.BitBlt(self, nXDest, nYDest, nWidth, nHeight, hdcSrc, nXSrc, nYSrc, dwRop)
	nXSrc = nXSrc or 0
	nYSrc = nYSrc or 0
	dwRop = dwRop or gdi_ffi.SRCCOPY
	
	return gdi_ffi.BitBlt(self.Handle,nXDest,nYDest,nWidth,nHeight,hdcSrc,nXSrc,nYSrc,dwRop);
end

function DeviceContext.StretchDIBits(self, XDest, YDest, nDestWidth, nDestHeight, XSrc, YSrc, nSrcWidth, nSrcHeight, lpBits, lpBitsInfo, iUsage, dwRop)
			XDest = XDest or 0
			YDest = YDest or 0
			iUsage = iUsage or 0
			dwRop = dwRop or gdi_ffi.SRCCOPY;

			return gdi_ffi.StretchDIBits(hdc,XDest,YDest,nDestWidth,nDestHeight,XSrc,YSrc,nSrcWidth,nSrcHeight,lpBits,lpBitsInfo,iUsage,dwRop);
end

function DeviceContext.GetDIBits(self, hbmp, uStartScan, cScanLines, lpvBits, lpbi, uUsage)
			return gdi_ffi.GetDIBits(self.Handle,hbmp,uStartScan,cScanLines,lpvBits,lpbi,uUsage);
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

			self:StretchDIBits(XDest,YDest,DestWidth,DestHeight,
				0,0,img.Width, img.Height,
				img.Data,
				bmInfo);
end



return DeviceContext;
