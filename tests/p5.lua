--[[
    This single file represents the guts of a processing/p5 skin
    The code will be very familiar to anyone who's used to doing processing,
    but done with a Lua flavor.
    

    Typical usage:

    -- This first line MUST come before any user code
    local graphicApp = require("graphicapp")

    function onMouseMove(event)
        print("MOVE: ", event.x, event.y)
    end

    -- This MUST be the last line of the user code
    graphicApp.run();
]]
local ffi = require("ffi")
local bit = require("bit")
local band, bor = bit.band, bit.bor
local rshift, lshift = bit.rshift, bit.lshift;

local sched = require("scheduler")
local wingdi = require("win32.wingdi")
local winuser = require("win32.winuser")
local WindowKind = require("WindowKind")
local NativeWindow = require("nativewindow")
local wmmsgs = require("wm_reserved")
local DeviceContext = require("DeviceContext")
local GDISurface = require("GDISurface")



local exports = {}
local lonMessage = false;

-- internal constants
MemoryDC = nil;
ClientDC = nil;
GDIRGB = wingdi.RGB;


-- Global variables
-- Constants
HALF_PI = math.pi / 2
PI = math.pi
QUARTER_PI = math.pi/4
TWO_PI = math.pi * 2



-- Constants related to colors
RGB = 1;
HSB = 2;

CLOSE = 1;

LEFT        = 1;
CENTER      = 2;
RIGHT       = 4;

TOP         = 0x08;
BOTTOM      = 0x10;
BASELINE    = 0x20;

MODEL = 1;
SCREEN = 2;
SHAPE = 3;




-- Set once, then never changed
width = 1024;
height = 768;

-- Mouse state changing live
mouseX = false;
mouseY = false;
mouseButton = false;
isMousePressed = false;

-- mouse position from previous frame
pMouseX = false;
pMouseY = false;

key = false;
keyCode = false;

-- Initial State
ColorMode = RGB,

BackgroundColor = Color(127, 127, 127, 255),
FillColor = Color(255,255,255,255),
StrokeColor = Color(0,0,0,255),

Running = false,
FrameRate = 20,

-- Typography
TextSize = 12,
TextAlignment = LEFT,
TextYAlignment = BASELINE,
TextLeading = 0,
TextMode = SCREEN,
TextSize = 12,


--[==================================================[
		LANGUAGE COMMANDS
--]==================================================]

function blue(c)
	return c.B
end

function green(c)
	return c.G
end

function red(c)
	return c.R
end

function alpha(c)
	return c.A
end


function color(...)
	return Color(unpack(arg))
end

function background(...)
	if arg.n == 1 and type(arg[1]) == "table" then
		return Processing.SetBackgroundColor(arg[1])
	end

	local acolor = Color(unpack(arg))
--print("background: ", acolor[1], acolor[2], acolor[3], acolor[4])
	return Processing.SetBackgroundColor(acolor)
end

function colorMode(amode)
	-- if it's not valid input, just return
	if amode ~= RGB and amode ~= HSB then return end

	--return Processing.SetColorMode(amode)
end

function fill(...)
	-- See if we're being passed a 'Color'
	-- type
	if arg.n == 1 and type(arg[1]) == "table" then
		return Processing.Renderer:SetFillColor(arg[1])
		--return Processing.SetFillColor(arg[1])
	end

	local acolor = Color(unpack(arg))

	return Processing.Renderer:SetFillColor(acolor)
end

function noFill()
	local acolor = Color(0,0)

	return Processing.Renderer:SetFillColor(acolor)
end

function noStroke(...)
	local acolor = Color(0,0)

	return Processing.Renderer:SetStrokeColor(acolor)

	--return Processing.SetStrokeColor(acolor)
end

function stroke(...)
	if arg.n == 1 and type(arg[1]) == "table" then
		-- We already have a color structure
		-- so just set it
		return Processing.Renderer:SetStrokeColor(arg[1])
	end

	-- Otherwise, construct a new color object
	-- and set it
	local acolor = color(unpack(arg))

	return Processing.Renderer:SetStrokeColor(acolor)
end


function point(x,y,z)
	--y = Processing.Renderer.height - y

	Processing.Renderer:DrawPoint(x,y)
end

function line(...)
	-- We either have 4, or 6 parameters
	local x1, y1, z1, x2, y2, z2

	if arg.n == 4 then
		x1 = arg[1]
		y1 = arg[2]
		x2 = arg[3]
		y2 = arg[4]
	elseif arg.n == 6 then
		x1 = arg[1]
		y1 = arg[2]
		z1 = arg[3]
		x2 = arg[4]
		y2 = arg[5]
		z2 = arg[6]
	end

	Processing.Renderer:DrawLine(x1, y1, x2, y2)
end

function rect(x, y, w, h)
	Processing.Renderer:DrawRect(x, y, w, h)
end

function triangle(x1, y1, x2, y2, x3, y3)
	Processing.Renderer:DrawTriangle(x1, y1, x2, y2, x3, y3)
end

function polygon(pts)
	Processing.Renderer:DrawPolygon(pts)
end

function quad(x1, y1, x2, y2, x3, y3, x4, y4)
	local pts = {
		Point3D(x1, y1, 0),
		Point3D(x2, y2, 0),
		Point3D(x3, y3, 0),
		Point3D(x4, y4, 0),
	}

	polygon(pts)
end

function ellipse(centerx, centery, awidth, aheight)
	local steps = 30
	local pts = {}

	for i = 0, steps do
		local u = i/steps
		local angle = u * 2*PI
		local x = awidth/2 * cos(angle)
		local y = aheight/2 * sin(angle)
		local pt = Point3D(x+centerx, y+centery, 0)
		table.insert(pts, pt)
	end

	polygon(pts)
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
	Processing.Renderer:SetPointSize(ptSize)
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
	Processing.TextLeading = leading
end

function textMode(mode)
	Processing.TextMode = mode
end

function textSize(asize)
	Processing.TextSize = asize
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
--[[
function textAscent()
end

function textDescent()
end
--]]

--[==============================[
	ENVIRONMENT
--]==============================]

function cursor()
end

function noCursor()
end

function frameRate(rate)
	Processing.FrameRate = rate
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







local function HIWORD(val)
    return band(rshift(val, 16), 0xffff)
end

local function LOWORD(val)
    return band(val, 0xffff)
end

-- encapsulate a mouse event
local function wm_mouse_event(hwnd, msg, wparam, lparam)
    mouseX = tonumber(band(lparam,0x0000ffff));
    mouseY = tonumber(rshift(band(lparam, 0xffff0000),16));

    local event = {
        x = mouseX;
        y = mouseY;
        control = band(wparam, ffi.C.MK_CONTROL) ~= 0;
        shift = band(wparam, ffi.C.MK_SHIFT) ~= 0;
        lbutton = band(wparam, ffi.C.MK_LBUTTON) ~= 0;
        rbutton = band(wparam, ffi.C.MK_RBUTTON) ~= 0;
        mbutton = band(wparam, ffi.C.MK_MBUTTON) ~= 0;
        xbutton1 = band(wparam, ffi.C.MK_XBUTTON1) ~= 0;
        xbutton2 = band(wparam, ffi.C.MK_XBUTTON2) ~= 0;
    }

    mousePressed = event.lbutton or event.rbutton or event.mbutton;

    return event;
end

function MouseActivity(hwnd, msg, wparam, lparam)
    local res = 1;

    local event = wm_mouse_event(hwnd, msg, wparam, lparam)


    if msg == ffi.C.WM_MOUSEMOVE  then
        event.activity = 'mousemove' 
        signalAll('gap-mousemove', event)
    elseif msg == ffi.C.WM_LBUTTONDOWN or 
        msg == ffi.C.WM_RBUTTONDOWN or
        msg == ffi.C.WM_MBUTTONDOWN or
        msg == ffi.C.WM_XBUTTONDOWN then
        event.activity = 'mousedown';
        signalAll('gap-mousedown', event)
    elseif msg == ffi.C.WM_LBUTTONUP or
        msg == ffi.C.WM_RBUTTONUP or
        msg == ffi.C.WM_MBUTTONUP or
        msg == ffi.C.WM_XBUTTONUP then
        event.activity = 'mouseup'
        signalAll('gap-mouseup', event)
    elseif msg == ffi.C.WM_MOUSEWHEEL then
        event.activity = 'mousewheel';
        signalAll('gap-mousewheel', event)
    else
        res = ffi.C.DefWindowProcA(hwnd, msg, wparam, lparam);
    end

    return res;
end

function KeyboardActivity(hwnd, msg, wparam, lparam)
    --print("onKeyboardActivity")
    local res = 1;

    res = ffi.C.DefWindowProcA(hwnd, msg, wparam, lparam);

    return res;
end

function CommandActivity(hwnd, msg, wparam, lparam)
    if onCommand then
        onCommand({source = tonumber(HIWORD(wparam)), id=tonumber(LOWORD(wparam))})
    end
end


function WindowProc(hwnd, msg, wparam, lparam)
    --print(string.format("WindowProc: msg: 0x%x, %s", msg, wmmsgs[msg]), wparam, lparam)

    local res = 1;

    -- If the window has been destroyed, then post a quit message
    if msg == ffi.C.WM_COMMAND then
        CommandActivity(hwnd, msg, wparam, lparam)
    elseif msg == ffi.C.WM_DESTROY then
        ffi.C.PostQuitMessage(0);
        signalAllImmediate('gap-quitting');
        return 0;
    elseif msg == ffi.C.WM_PAINT then
        local ps = ffi.new("PAINTSTRUCT");
		local hdc = ffi.C.BeginPaint(hwnd, ps);
--print("PAINT: ", ps.rcPaint.left, ps.rcPaint.top,ps.rcPaint.right, ps.rcPaint.bottom)
		-- bitblt backing store to client area

        if (nil ~= surface) then
			ret = ffi.C.BitBlt(hdc,
				ps.rcPaint.left, ps.rcPaint.top,
				ps.rcPaint.right - ps.rcPaint.left, ps.rcPaint.bottom - ps.rcPaint.top,
				surface.DC.Handle,
				ps.rcPaint.left, ps.rcPaint.top,
                ffi.C.SRCCOPY);
        else
            --print("NO SURFACE YET")
        end

		ffi.C.EndPaint(hwnd, ps);
    elseif msg >= ffi.C.WM_MOUSEFIRST and msg <= ffi.C.WM_MOUSELAST then
        res = MouseActivity(hwnd, msg, wparam, lparam)
    elseif msg >= ffi.C.WM_KEYFIRST and msg <= ffi.C.WM_KEYLAST then
        res = KeyboardActivity(hwnd, msg, wparam, lparam)  
    else
        res = ffi.C.DefWindowProcA(hwnd, msg, wparam, lparam);
    end

	return res
end
jit.off(WindowProc)




local function msgLoop()
    --  create some a loop to process window messages
    --print("msgLoop - BEGIN")
    local msg = ffi.new("MSG")
    local res = 0;

    while (true) do
        --print("LOOP")
        -- we use peekmessage, so we don't stall on a GetMessage
        while (ffi.C.PeekMessageA(msg, nil, 0, 0, ffi.C.PM_REMOVE) ~= 0) do
            --print(string.format("Loop Message: 0x%x", msg.message), wmmsgs[msg.message])            
            if lonMessage then
                lonMessage(msg);
            end
            
            -- If we see a quit message, it's time to stop the program
            -- ideally we'd call an 'onQuit' and wait for that to return
            -- before actually halting.  That will give the app a chance
            -- to do some cleanup
            if msg.message == ffi.C.WM_QUIT then
                --print("msgLoop - QUIT")
                halt();
            end

            res = ffi.C.TranslateMessage(msg)
            res = ffi.C.DispatchMessageA(msg)
        end
        signalAll("gap-idle")
        yield();
    end

    print("msgLoop - END")        
end


local function createWindow(params)
    params = params or {width=1024, height=768, title="GraphicApplication"}
    params.width = params.width or 1024;
    params.height = params.height or 768;
    params.title = params.title or "Graphic App";

    -- set global variables
    width = params.width;
    height = params.height;

    -- You MUST register a window class before you can use it.
    local winkind, err = WindowKind("GraphicWindow", WindowProc);

    if not winkind then
        print("Window kind not created, ERROR: ", err);
        return false, err;
    end

    -- create an instance of a window
    appWindow = NativeWindow:create(winkind.ClassName, params.width, params.height,  params.title);
    --MemoryDC = DeviceContext:CreateForMemory(appWindow.ClientDC);
    ClientDC = DeviceContext:init(appWindow.ClientDC);

    appWindow:show();
end

function drawNow()
    appWindow:redraw(ffi.C.RDW_INVALIDATE)

    return true;
end

-- Register UI event handler global functions
-- These are the functions that the user should implement
-- in their code
local function setupUIHandlers()
    local handlers = {
        {activity = 'gap-mousedown', response = "onMouseActivity"};
        {activity = 'gap-mouseup', response = "onMouseActivity"};
        {activity = 'gap-mousemove', response = "onMouseActivity"};
        {activity = 'gap-mousewheel', response = "onMouseActivity"};

        {activity = 'gap-mousemove', response = "onMouseMove"};
        {activity = 'gap-mouseup', response = "onMouseUp"};
        {activity = 'gap-mousedown', response = "onMouseDown"};
        {activity = 'gap-mousewheel', response = "onMouseWheel"};

        {activity = 'gap-keydown', response = "onKeyboardActivity"};
        {activity = 'gap-keyup', response = "onKeyboardActivity"};
        {activity = 'gap-syskeydown', response = "onKeyboardActivity"};
        {activity = 'gap-syskeyup', response = "onKeyboardActivity"};

        {activity = 'gap-idle', response = "loop"};
        {activity = 'gap-idle', response = "onIdle"};
    }

    for i, handler in ipairs(handlers) do
        --print("response: ", handler.response, _G[handler.response])
        if _G[handler.response] ~= nil then
            on(handler.activity, _G[handler.response])
        end
    end

end



local function main(params)
    -- make a local for 'onMessage' global function
    if onMessage then
        lonMessage = onMessage;
    end

    spawn(msgLoop);
    yield();
    spawn(createWindow, params);
    yield();
    setupUIHandlers();
    yield();
    surface = GDISurface(params)

    if setup then
        --on('gap-ready', setup);
        setup();
    end
    drawNow();
    yield();

    signalAll("gap-ready");
end


function go(params)
    params = params or {
        width = 640;
        height = 480;
    }
    params.width = params.width or 640;
    params.height = params.height or 480;

    run(main, params)
end

