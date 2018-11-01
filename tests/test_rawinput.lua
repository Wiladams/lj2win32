package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local winuser = require("win32.winuser")
local msgpump = require("msgpump")
local wmmsgs = require("wmmsgs")
local scheduler = require("scheduler")

--[[
UINT
__stdcall
GetRegisteredRawInputDevices(
    PRAWINPUTDEVICE pRawInputDevices,
     PUINT puiNumDevices,
     UINT cbSize);
--]]

local function GetInputDevices()
    local cbSize = ffi.sizeof("RAWINPUTDEVICE");
    local puiNumDevices = ffi.new("UINT[1]")
    ffi.C.GetRegisteredRawInputDevices(nil, puiNumDevices, cbSize)

    local numDevices = puiNumDevices[0]
    print("Num Devices: ", numDevices)
end

local function RegisterDevices()
    local pRawInputDevices = ffi.new("RAWINPUTDEVICE[1]")
    local uiNumDevices = 1;
    local cbSize = ffi.sizeof("RAWINPUTDEVICE")

    pRawInputDevices[0].usUsagePage = 1;
    pRawInputDevices[0].usUsage = 0x02;
    local res = ffi.C.RegisterRawInputDevices(pRawInputDevices, uiNumDevices,cbSize);

    print("RegisterDevices: ", res)
end


function msgproc(hwnd, msg, wparam, lparam)
    print(string.format("msgproc: msg: 0x%x, %s", msg, wmmsgs[msg]), wparam, lparam)

    local res = 1;

    -- If the window has been destroyed, then post a quit message
    if msg == ffi.C.WM_DESTROY then
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


local function main()
    RegisterDevices();
    GetInputDevices();
    spawn(msgpump, msgproc)
end

run(main)


