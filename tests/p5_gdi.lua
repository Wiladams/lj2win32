--[[
    This must be required by p5.lua, do not use it directly
    as it utilizes globals found in there.
]]

local ffi = require("ffi")
local wingdi = require("win32.wingdi")

local solidBrushes = {}
local solidPens = {}

--[==================================================[
		LANGUAGE COMMANDS
--]==================================================]
local function solidBrush(...)
	local c = color(...)
	local abrush = false;
	
	abrush = solidBrushes[tonumber(c.cref)]
	--print("solidBrush: ", c.cref, abrush)
	
	if abrush then
		return abrush;
	end

	abrush = ffi.C.CreateSolidBrush(c.cref);
	solidBrushes[tonumber(c.cref)] = abrush;

	return abrush, c;
end

local function solidPen(...)
	local c = color(...)

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




function background(...)
	local bbrush, c = solidBrush(...)

	if not bbrush then
		return false;
	end

	local oldbrush = surface.DC:SelectObject(bbrush);
	local oldpen = surface.DC:SelectStockObject(ffi.C.NULL_PEN);


	-- whenever background is called, fill the surface
	-- with the new color immediately
	surface.DC:Rectangle(0, 0, width-1, height-1)
	surface.DC:flush();

	-- restore the old stuff
	surface.DC:SelectObject(oldbrush);
	surface.DC:SelectObject(oldpen);
end



function fill(...)
	local abrush, c = solidBrush(...)

	if not abrush then
		return false;
	end

	local oldbrush = surface.DC:SelectObject(abrush);
	
	return true;
end

function noFill()
--[[
	local plbrush = ffi.new("LOGBRUSH", {ffi.C.BS_NULL, 0, nil})
	FillBrush = ffi.C.CreateBrushIndicect(plbrush);
	FillColor = false;

	local oldbrush = surface.DC:SelectObject(FillBrush);

	if oldbrush then
		ffi.C.DeleteObject(oldbrush)
	end
--]]
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



function triangle(x1, y1, x2, y2, x3, y3)
	local pts = ffi.new("POINT[3]", {{x1,y1},{x2,y2},{x3,y3}})
	surface.DC:Polygon(pts, 3)
end

function polygon(pts)
	local npts = #pts
	local apts = ffi.new("POINT[?]", npts)
	surface.DC:Polygon(apts, npts)
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
	Processing.Renderer:DrawBezier(
		{x1, y1, 0},
		{x2, y2, 0},
		{x3, y3, 0},
		{x4, y4, 0})
end

function bezierDetail(...)
end

function bezierPoint(...)
end

-- Catmull - Rom curve
function curve(x1, y1,  x2, y2,  x3, y3,  x4, y4)
	Processing.Renderer:DrawCurve(
		{x1, y1, 0},
		{x2, y2, 0},
		{x3, y3, 0},
		{x4, y4, 0})
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
	Processing.Renderer:SetAntiAlias(true)
end

function noSmooth()
	Processing.Renderer:SetAntiAlias(false)
end

function pointSize(ptSize)
	PointSize = ptSize;
end

function strokeCap(cap)
	Processing.Renderer:SetLineCap(cap);
end

function strokeJoin(join)
	Processing.Renderer:SetLineJoin(join)
end

function strokeWeight(weight)
	Processing.Renderer:SetLineWidth(weight)
end

function size(awidth, aheight, MODE)
	Processing.SetCanvasSize(awidth, aheight, MODE)
end

-- VERTEX
function beginShape(...)
	local sMode = POLYGON
	if arg.n == 0 then
		Processing.VertexMode = gl.POLYGON
	elseif arg[1] == POINTS then
		Processing.ShapeMode = gl.POINTS
	elseif arg[1] == LINES then
		Processing.ShapeMode = gl.LINES
	end
end

function bezierVertex()
end

function curveVertex()
end

function endShape()
end

function texture()
end

function textureMode()
end

function vertex(...)
	local x = nil
	local y = nil
	local z = nil
	local u = nil
	local v = nil

	if (arg.n == 2) then
		x = arg[1]
		y = arg[2]
		z = 0
	elseif arg.n == 3 then
		x = arg[1]
		y = arg[2]
		z = arg[3]
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

end






--[==============================[
	TRANSFORM
--]==============================]

-- Matrix Stack
function popMatrix()
	Processing.Renderer:PopMatrix();
end


function pushMatrix()
	Processing.Renderer:PushMatrix();
end

function applyMatrix()
end

function resetMatrix()
end

function printMatrix()
end


-- Simple transforms
function translate(x, y, z)
	Processing.Renderer:Translate(x, y, z)
end

function rotate(rads)
	Processing.Renderer:Rotate(rads)
end

function rotateX(rad)
end

function rotateY(rad)
end

function rotateZ(rad)
end

function scale(sx, sy, sz)
	Processing.Renderer:Scale(sx, sy, sz)
end

function shearX()
end

function shearY()
end



--[[
	Scene
--]]
function addactor(actor)
	if not actor then return end

	if actor.Update then
		table.insert(Processing.Actors, actor)
	end

	if actor.Render then
		addgraphic(actor)
	end

	addinteractor(actor)
end

function addgraphic(agraphic)
	if not agraphic then return end

	table.insert(Processing.Graphics, agraphic)
end

function addinteractor(interactor)
	if not interactor then return end

	if interactor.MouseActivity then
		table.insert(Processing.MouseInteractors, interactor)
	end

	if interactor.KeyboardActivity then
		table.insert(Processing.KeyboardInteractors, interactor)
	end
end


--[==============================[
	TYPOGRAPHY
--]==============================]

function createFont()
end

function loadFont()
end

function text(x, y, txt)
	--Processing.Renderer:Scale(1, -1)
	Processing.Renderer:DrawText(x, y, txt)
	--Processing.Renderer:Scale(1, -1)
end

-- Attributes

function textAlign(align, yalign)
	yalign = yalign or Processing.TextYAlignment

	Processing.TextAlignment = align
	Processing.TextYAlignment = yalign
	--Processing.SetTextAlignment(align, yalign)

	Processing.Renderer:SetTextAlignment(align)
end

function textLeading(leading)
	TextLeading = leading
end

function textMode(mode)
	TextMode = mode
end

function textSize(asize)
	TextSize = asize
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
function createImage(awidth, aheight, dtype)
	local pm = PImage(awidth, aheight, dtype)
	return pm
end

-- Loading and Displaying
--(img, offsetx, offsety, awidth, aheight)
function image(img, x, y, awidth, aheight)
	if img == nil then return end
	awidth = awidth or 0
	aheight = aheight or 0

	Processing.Renderer:DrawImage(img, x, y, awidth, aheight)
end

function imageMode()
end

function loadImage(filename)
	local pm = PImage({Filename = filename})

	return pm
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
	return Processing.Renderer:get(x,y)
end

function set(x, y, acolor)
	Processing.Renderer:set(x, y, acolor)
end

function loadPixels()
	Processing.Renderer:loadPixels()
end

function pixels()
end

function updatePixels()
	Processing.Renderer:updatePixels();
end
