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
local stopwatch = require("stopwatch")
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
local SWatch = stopwatch();


-- Global variables
-- Constants
HALF_PI = math.pi / 2
PI = math.pi
QUARTER_PI = math.pi/4
TWO_PI = math.pi * 2
TAU = TWO_PI

-- angleMode
DEGREES = 1;
RADIANS = 2;


-- Constants related to colors
-- colorMode
RGB = 1;
HSB = 2;

-- rectMode, ellipseMode
CORNER = 1;
CORNERS = 2;
RADIUS = 3;
CENTER = 4;

-- kind of close (for polygon)
STROKE = 0;
CLOSE = 1;

-- alignment
CENTER      = 0x00;
LEFT        = 0x01;
RIGHT       = 0x04;
TOP         = 0x10;
BOTTOM      = 0x40;
BASELINE    = 0x80;

MODEL = 1;
SCREEN = 2;
SHAPE = 3;

-- GEOMETRY
POINTS          = 0;
LINES           = 1;
LINE_STRIP      = 2;
LINE_LOOP       = 3;
POLYGON         = 4;
QUADS           = 5;
QUAD_STRIP      = 6;
TRIANGLES       = 7;
TRIANGLE_STRIP  = 8;
TRIANGLE_FAN    = 9;




-- environment
frameCount = false;
focused = false;
displayWidth = false;
displayHeight = false;
windowWidth = false;
windowHeight = false;
width = false;
height = false;

-- Mouse state changing live
mouseX = false;
mouseY = false;
pMouseX = false;
pMouseY = false;
winMouseX = false;
winMouseY = false;
pwinMouseX = false;
pwinMouseY = false;
mouseButton = false;
mouseIsPressed = false;
-- to be implemented by user code
-- mouseMoved()
-- mouseDragged()
-- mousePressed()
-- mouseReleased()
-- mouseClicked()
-- doubleClicked()
-- mouseWheel()

-- Keyboard state changing live
keyIsPressed = false;
key = false;
keyCode = false;
-- to be implemented by client code
-- keyPressed()
-- keyReleased()
-- keyTyped()
-- keyIsDown()

-- Touch events
touches = false;
-- touchStarted()
-- touchMoved()
-- touchEnded()

-- Initial State for modes
AngleMode = RADIANS;
ColorMode = RGB;
RectMode = CORNER;
EllipseMode = CORNER;

Running = false;
FrameRate = 20;

-- Typography
TextSize = 12;
TextAlignment = LEFT;
TextYAlignment = BASELINE;
TextLeading = 0;
TextMode = SCREEN;
TextSize = 12;




function angleMode(newMode)
    if newMode ~= DEGREES and newMode ~= RADIANS then 
        return false 
    end

    AngleMode = newMode;

    return true;
end

function color(...)
	local nargs = select('#', ...)
	local self = {}

	-- There can be 1, 2, 3, or 4, arguments
	--	print("Color.new - ", nargs)
	
	local r = 0
	local g = 0
	local b = 0
	local a = 0
	
	if (nargs == 1) then
			r = select(1,...)
			g = select(1,...)
			b = select(1,...)
			a = 255;
	elseif nargs == 2 then
			r = select(1,...)
			g = select(1,...)
			b = select(1,...)
			a = select(2,...)
	elseif nargs == 3 then
			r = select(1,...)
			g = select(2,...)
			b = select(3,...)
			a = 255
	elseif nargs == 4 then
		r = select(1,...)
		g = select(2,...)
		b = select(3,...)
		a = select(4,...)
	end
	
	self.cref = wingdi.RGB(r,g,b)
	
	self.R = r
	self.G = g
	self.B = b
	self.A = a

	return self;
end


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


function ellipseMode(newMode)
    EllipseMode = newMode;
end

function millis()
    -- get millis from p5 stopwatch
    SWatch:millis();
end

function rectMode(newMode)
    RectMode = newMode;
end

function redraw()
    appWindow:redraw(ffi.C.RDW_INVALIDATE)

    return true;
end


-- Very Windows specific

local function HIWORD(val)
    return band(rshift(val, 16), 0xffff)
end

local function LOWORD(val)
    return band(val, 0xffff)
end

-- encapsulate a mouse event
local function wm_mouse_event(hwnd, msg, wparam, lparam)
    -- assign previous mouse position
    if mouseX then pmouseX = mouseX end
    if mouseY then pmouseY = mouseY end

    -- assign new mouse position
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

    appWindow:show();
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

	BackgroundColor = color(225, 225, 225, 255);
	FillColor = color(255,255,255,255);
	StrokeColor = color(0,0,0,255);

    spawn(msgLoop);
    yield();

	createWindow(params);
    setupUIHandlers();
    yield();
	surface = GDISurface(params)

    surface.DC:SelectStockObject(ffi.C.NULL_PEN)
	surface.DC:SetDCBrushColor(BackgroundColor.cref)
    surface.DC:Rectangle(0, 0, params.width-1, params.height-1)

    surface.DC:UseDCPen(true);
    surface.DC:SetDCPenColor(StrokeColor.cref)
    surface.DC:SetDCBrushColor(FillColor.cref)

    if setup then
        setup();
    end
    redraw();
    yield();

    signalAll("gap-ready");
end


function go(params)
    params = params or {
        width = 320;
        height = 240;
        title = "p5"
    }
    params.width = params.width or 640;
    params.height = params.height or 480;
    params.title = params.title or "p5"

    run(main, params)
end

require("p5_gdi")