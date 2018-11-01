package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

local winuser = require("win32.winuser")


--[[
UINT
__stdcall
GetRegisteredRawInputDevices(
    PRAWINPUTDEVICE pRawInputDevices,
     PUINT puiNumDevices,
     UINT cbSize);
--]]

local function GetInputDevices()
    local cbSize = 0;
    local puiNumDevices = ffi.new("UINT[1]")
    ffi.C.GetRegisteredRawInputDevices(nil, puiNumDevices, cbSize)

    local numDevices = puiNumDevices[0]
    print("Num Devices: ", numDevices)
end

--[[
-- message-only window
static const char* class_name = "DUMMY_CLASS";
WNDCLASSEX wx = {};
wx.cbSize = sizeof(WNDCLASSEX);
wx.lpfnWndProc = pWndProc;        // function which will handle messages
wx.hInstance = current_instance;
wx.lpszClassName = class_name;
if ( RegisterClassEx(&wx) ) {
  CreateWindowEx( 0, class_name, "dummy_name", 0, 0, 0, 0, 0, HWND_MESSAGE, NULL, NULL, NULL );
}
--]]

print("HWND_MESSAGE: ", ffi.C.HWND_MESSAGE)

--GetInputDevices();

