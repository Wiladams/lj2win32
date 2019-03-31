--[[
    This must be required by p5.lua, do not use it directly
	as it utilizes globals found in there.
	
	--transparency and GDI
	https://parnassus.co/transparent-graphics-with-pure-gdi-part-2-and-introducing-the-ttransparentcanvas-class/

]]

local ffi = require("ffi")
local wingdi = require("win32.wingdi")
local Rectangle = require("Rectangle")
local PixelBuffer = require("PixelBuffer")

local solidBrushes = {}
local solidPens = {}
local fontCache ={}			-- cache of fonts

--[==================================================[
		LANGUAGE COMMANDS
--]==================================================]
function push()
	surface.DC:save();
end

function pop()
	surface.DC:restore();
end

local function getFont(name, size)
	local namecache = fontCache[name];
	if namecache then
		local afont = namecache[size]
		if afont then
			return afont
		end
	else
		namecache = {}
		fontCache[name] = namecache
	end

	-- create a new font of the specified size
	--[[
	local afont = ffi.C.CreateFontA(  int cHeight,  int cWidth,  int cEscapement,  int cOrientation,  int cWeight,  DWORD bItalic,
	DWORD bUnderline,  DWORD bStrikeOut,  DWORD iCharSet,  DWORD iOutPrecision,  DWORD iClipPrecision,
	DWORD iQuality,  DWORD iPitchAndFamily,  LPCSTR pszFaceName);
--]]
	local cHeight = size;
	local cWidth = 0;
	local cEscapement = 0;
	local cOrientation = 0;
	local cWeight = ffi.C.FW_BOLD;
	local bItalic = 0;
	local bUnderline = 0;
	local bStrikeOut = 0;
	local iCharSet = 0;
	local iOutPrecision = 0;
	local iClipPrecision = 0;
	local iQuality = 2;
	local iPitchAndFamily = 0;
	local pszFaceName = name
	local afont = ffi.C.CreateFontA(cHeight, cWidth, cEscapement, cOrientation,  cWeight,  bItalic,
	bUnderline,  bStrikeOut,  iCharSet,  iOutPrecision,  iClipPrecision,
	iQuality,  iPitchAndFamily,  pszFaceName);
	
	-- add it to the name cache
	namecache[size] = afont;

	return afont;
end

local function solidBrush(c)
	local abrush = false;
	
	abrush = solidBrushes[tonumber(c.cref)]
	--print("solidBrush: ", c.cref, abrush)
	
	if abrush then
		return abrush, c;
	end

	abrush = ffi.C.CreateSolidBrush(c.cref);
	solidBrushes[tonumber(c.cref)] = abrush;

	return abrush, c;
end

local function solidPen(...)
	local c = select(1, ...)
	if type(c) ~= "cdata" then
		c = color(...)
	end
	
	local apen = solidPens[tonumber(c.cref)]

	if apen then
		return apen, c
	end


	apen = ffi.C.CreatePen(ffi.C.PS_SOLID, StrokeWidth, c.cref);
	if not apen then 
		return false, 'could not create solid pen'
	end

	solidPens[tonumber(c.cref)] = apen

	return apen, c
end


function colorMode(amode)
	-- if it's not valid input, just return
	if amode ~= RGB and amode ~= HSB then 
		return 
	end
	ColorMode = amode;

	return true;
end

function clear()
	local bbrush = solidBrush(BackgroundColor)

	if not bbrush then
		return false;
	end

	-- save old pen and brush
	local oldbrush = surface.DC:SelectObject(bbrush);
	local oldpen = surface.DC:SelectStockObject(ffi.C.NULL_PEN);

	surface.DC:Rectangle(0, 0, width-1, height-1)
	surface.DC:flush();

	-- restore the old stuff
	surface.DC:SelectObject(oldbrush);
	surface.DC:SelectObject(oldpen);
end

function background(...)
	local n = select('#', ...)
	local c = select(1,...)
	if type(c) ~= "cdata" then
		c = color(...)
	end

	local bbrush = solidBrush(c)
	BackgroundColor = c;

	if not bbrush then
		return false;
	end

	local oldbrush = surface.DC:SelectObject(bbrush);
	local oldpen = surface.DC:SelectStockObject(ffi.C.NULL_PEN);

	--surface.DC:SetBkColor(c.cref);
	--surface.DC:SetBkMode(ffi.C.TRANSPARENT);

	-- whenever background is called, fill the surface
	-- with the new color immediately
	surface.DC:Rectangle(0, 0, width-1, height-1)
	surface.DC:flush();

	-- restore the old stuff
	surface.DC:SelectObject(oldbrush);
	surface.DC:SelectObject(oldpen);
end



function fill(...)
	local c = select(1,...)

	if type(c) ~= "cdata" then
		c = color(...)
	end

	local abrush = solidBrush(c)
	FillColor = c;
	if not abrush then
		return false;
	end

	local oldbrush = surface.DC:SelectObject(abrush);
	
	-- set the text color as well
	surface.DC:SetTextColor(c.cref)

	return true;
end

function noFill()
	local oldbrush = surface.DC:SelectStockObject(ffi.C.NULL_BRUSH)

	return true;
end

function noStroke()
	surface.DC:SelectStockObject(ffi.C.NULL_PEN);

	return true;
end

function stroke(...)

	local pen, c = solidPen(...);
	StrokeColor = c;

	if pen == nil then
		print("NO SOLID PEN")
		return false;
	end

	local oldPen = surface.DC:SelectObject(pen)

	return true;
end



function point(x,y,z)
	--print("point(), x,y,z: ", x, y, z, StrokeColor.cref)
	surface.DC:SetPixel(x, y, StrokeColor.cref)
	
	return true;
end

function line(...)
	-- We either have 4, or 6 parameters
	local nargs = select('#',...)
	local x1, y1, z1, x2, y2, z2


	if nargs == 4 then
		x1 = select(1, ...)
		y1 = select(2, ...)
		x2 = select(3, ...)
		y2 = select(4, ...)
	elseif arg.n == 6 then
		x1 = select(1, ...)
		y1 = select(2, ...)
		z1 = select(3, ...)
		x2 = select(4, ...)
		y2 = select(5, ...)
		z2 = select(6, ...)
	end
	surface.DC:MoveTo(x1,y1);
	surface.DC:LineTo(x2, y2);

	return true;
end

function angleArc(x,y,r,startAt, endAt)
	surface.DC:AngleArc(x,y,r,startAt, endAt);
end

function triangle(x1, y1, x2, y2, x3, y3)
	local pts = ffi.new("POINT[3]", {{x1,y1},{x2,y2},{x3,y3}})
	surface.DC:Polygon(pts, 3)
end

function polygon(pts)
	local npts = #pts
	local apts = ffi.new("POINT[?]", npts,pts)
	local res = surface.DC:Polygon(apts, npts)
end

function polyline(pts)
	local npts = #pts
	local apts = ffi.new("POINT[?]", npts,pts)
	local res = surface.DC:Polyline(apts, npts)
end

function quad(x1, y1, x2, y2, x3, y3, x4, y4)
	local pts = ffi.new("POINT[4]", {{x1,y1},{x2,y2},{x3,y3},{x4,y4}})
	surface.DC:Polygon(pts, 4)
end

local function calcModeRect(mode, ...)
	local nargs = select('#',...)
	if nargs < 4 then return false end

	local a = select(1, ...)
	local b = select(2, ...)
	local c = select(3,...)
	local d = select(4,...)

	local x1 = 0;
	local y1 = 0;
	local rwidth = 0;
	local rheight = 0;

	if mode == CORNER then
		x1 = a;
		y1 = b;
		rwidth = c;
		rheight = d;

	elseif mode == CORNERS then
		x1 = a;
		y1 = b;
		rwidth = c - a + 1;
		rheight = d - b + 1;

	elseif mode == CENTER then
		x1 = a - c / 2;
		y1 = b - d / 2;
		rwidth = c;
		rheight = d;

	elseif mode == RADIUS then
		x1 = a - c;
		y1 = b - d;
		rwidth = c * 2;
		rheight = d * 2;
	end

	return x1, y1, rwidth, rheight;
end

function rect(...)
	local nargs = select('#',...)
	if nargs < 4 then return false end

	local x1, y1, rwidth, rheight = calcModeRect(RectMode, ...)


	if nargs == 4 then
		surface.DC:Rectangle(x1,y1,x1+rwidth-1,y1+rheight-1)
	elseif nargs == 5 then
		surface.DC:RoundRect(x1,y1,x1+rwidth-1, y1+rheight-1, select(5,...), select(5,...))
	end

	return true;
end

function ellipse(...)
	local nargs = select('#',...)

	local x1, y1, rwidth, rheight = calcModeRect(EllipseMode, ...)
	
	local xradius = rwidth / 2;
	local yradius = rheight / 2;

	surface.DC:Ellipse(x1,y1,x1+rwidth-1,y1+rheight-1)

	return true;
end

--[====================================[
--	Curves
--]====================================]

function bezier(x1, y1,  x2, y2,  x3, y3,  x4, y4)
--[[
	Processing.Renderer:DrawBezier(
		{x1, y1, 0},
		{x2, y2, 0},
		{x3, y3, 0},
		{x4, y4, 0})
--]]
end

function bezierDetail(...)
end

function bezierPoint(...)
end

-- Catmull - Rom curve
function curve(x1, y1,  x2, y2,  x3, y3,  x4, y4)
--[[
		Processing.Renderer:DrawCurve(
		{x1, y1, 0},
		{x2, y2, 0},
		{x3, y3, 0},
		{x4, y4, 0})
--]]
end

function curveDetail(...)
end

function curvePoint(...)
end

function curveTangent(...)

end

function curveTightness(...)
end

-- ATTRIBUTES
function smooth()
	--Processing.Renderer:SetAntiAlias(true)
end

function noSmooth()
	--Processing.Renderer:SetAntiAlias(false)
end

function pointSize(ptSize)
	PointSize = ptSize;
end

function strokeCap(cap)
	
end

function strokeJoin(join)
	
end

function strokeWeight(weight)
	StrokeWeight = weight;
	-- need to create a new pen with 
	-- this specified weight
end

--[[
function size(awidth, aheight, MODE)
	Processing.SetCanvasSize(awidth, aheight, MODE)
end
--]]

-- VERTEX
function beginShape(sMode)
	ShapeMode = sMode or POLYGON
	
	-- Start a new array of vertices
	ShapeVertices = {}

end

function endShape(endKind)
	endKind = endKind or STROKE 
	local npts = #ShapeVertices
	local apts = ffi.new("POINT[?]", npts,ShapeVertices)

	if ShapeMode == POLYGON then

		if endKind == CLOSE then
			surface.DC:BeginPath();
			local res = surface.DC:Polygon(apts, npts)
			surface.DC:EndPath();
			local success = surface.DC:StrokeAndFillPath();
		elseif endKind == STROKE then
			surface.DC:BeginPath();
			local res = surface.DC:Polyline(apts, npts)
			surface.DC:EndPath();
			local success = surface.DC:FillPath();

			surface.DC:BeginPath();
			local res = surface.DC:Polyline(apts, npts)
			surface.DC:EndPath();
			local success = surface.DC:StrokePath();
		end
	elseif ShapeMode == POINTS then
		for i, pt in ipairs(ShapeVertices) do
			point(pt[1], pt[2])
		end
	elseif ShapeMode == LINES then
		-- walk the array of points two at a time
		for i=0, npts-2, 2 do
			print("endshape: ", apts[i].x, apts[i].y, apts[i+1].x, apts[i+1].y)
			surface.DC:MoveTo(apts[i].x, apts[i].y)
			surface.DC:LineTo(apts[i+1].x, apts[i+1].y)
		end
	elseif ShapeMode == TRIANGLES then
		-- draw triangles
	end

	ShapeVertices = nil;
end

function vertex(...)
	local nargs = select('#',...)

	if not ShapeVertices or nargs < 2 then
		return false;
	end
	
	table.insert(ShapeVertices, {select(1,...),select(2,...)})

	return true;

--[[
	local x = nil
	local y = nil
	local z = nil
	local u = nil
	local v = nil

	if (nargs == 2) then
		x = select(1,...)
		y = select(2,...)
		z = 0
	elseif (nargs == 3) then
		x = select(1,...)
		y = select(2,...)
		z = select(3,...)
	elseif arg.n == 4 then
		x = arg[1]
		y = arg[2]
		u = arg[3]
		v = arg[4]
	elseif arg.n == 5 then
		x = arg[1]
		y = arg[2]
		z = arg[3]
		u = arg[4]
		v = arg[5]
	end


	if u and v then
		-- texture coordinate
	end

	if x and y and z then
		gl.vertex(x,y,z)
	end
--]]

end


function bezierVertex()
end

function curveVertex()
end



function texture()
end

function textureMode()
end



--[==============================[
	TRANSFORM
--]==============================]

-- Matrix Stack
function popMatrix()
	
end

function pushMatrix()
	
end

function applyMatrix()
end

function resetMatrix()
end

function printMatrix()
end


-- Simple transforms
function translate(x, y, z)
	-- SetWorldTransform
end

function rotate(rads)
	
end

function rotateX(rad)
end

function rotateY(rad)
end

function rotateZ(rad)
end

function scale(sx, sy, sz)
	
end

function shearX()
end

function shearY()
end



--[==============================[
	TYPOGRAPHY
--]==============================]

function createFont()
end

function loadFont()
end

function text(txt, x, y)
	surface.DC:Text(txt, x, y);
	--surface.DC:ExtTextOutA(  HDC hdc,  int x,  int y,  UINT options,  const RECT * lprect,  LPCSTR lpString,  UINT c,  const INT * lpDx)
end

-- Attributes

function textAlign(halign, valign)
	TextHAlignment = halign or LEFT
	TextVAlignment = valign or TOP

end

function textLeading(leading)
	TextLeading = leading
end

function textMode(mode)
	TextMode = mode
end

function textSize(asize)
	TextSize = asize
	FontName = "SYSTEM_FIXED_FONT"
	local afont = getFont(FontName, asize)
	if not afont then
		return false, 'could not find font'
	end

	surface.DC:SelectObject(afont);
end

function textWidth(txt)
	twidth, theight = Processing.Renderer:MeasureString(txt)
	return Processing.GetTextWidth(astring)
end

function textFont(fontname)
	return Processing.Renderer:SetFont(fontname);
	--return Processing.SetFontName(fontname)
end

-- Metrics

function textAscent()
    return false;
end

function textDescent()
    return false;
end


--[==============================[
	ENVIRONMENT
--]==============================]

function cursor()
end

function noCursor()
end

function frameRate(rate)
	FrameRate = rate
end




--[==============================[
	IMAGE
--]==============================]
function createImage(awidth, aheight)
	local pm = PixelBuffer(awidth, aheight)

	return pm
end

-- Loading and Displaying

--[[
    copy one pixel buffer to another
    without any blending operation

    need to do clipping
]]
function image(img, dstX, dstY, awidth, aheight)
	if not img then
		return false, 'no image specified'
	end

	--print("image(), img.width, img.height: ", img.Width, img.Height)
	--print("  width, height: ", width, height)
--	surface.DC:StretchBlt(img, dstX, dstY,awidth,aheight)
---[=[
	-- need to do some clipping
	dstX = dstX or 0
	dstY = dstY or 0

	-- find intersection of two rectangles
	local r1 = Rectangle(dstX, dstY, img.Width, img.Height)
	local r2 = Rectangle(0,0, width, height)
	local visible = r2:intersection(r1)
	
	--print("image: ", src.Width, src.Height)
	local pixelPtr = ffi.cast("struct Pixel32 *", surface.pixelData.data)
    for y= 0, img.Height-1 do
		for x=0, img.Width-1 do
			if visible:contains(x,y) then
				local c = img:get(x,y)
            	--set(dstX+x, dstY+y, c)
				pixelPtr[y*width+x].cref = c.cref
			end
        end
	end

--]=]
end

function imageMode()
end


function requestImage()
end

function tint()
end

function noTint()
end

-- Pixels


function blend()
end

function copy()
end

function filter()
end

function get(x, y)
	local cref = surface.DC:GetPixel(x,y)
	local r = wingdi.GetRValue(cref)
	local g = wingdi.GetGValue(cref)
	local b = wingdi.GetBValue(cref)
	return color(r,g,b)
end

function set(x,y,c)
	surface.DC:SetPixel(x, y, c.cref)
end

function loadPixels()
end

function pixels()
end

function updatePixels()
end
