package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

require("win32.sdkddkver")
require("win32.wingdi")
require("win32.winuser")

local DPI_AWARENESS_CONTEXT_SYSTEM_AWARE         = ffi.cast("DPI_AWARENESS_CONTEXT",-2);
local DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2 = ffi.cast("DPI_AWARENESS_CONTEXT",-4);

local function printDict(dict)
    for k,v in pairs(dict) do
        print(string.format("%20s  %s", tostring(k), tostring(v)))
    end
end

local function getCaps()
    local hdc = C.GetDC(nil);
    local caps = {
        HORZSIZE = C.GetDeviceCaps(hdc, C.HORZSIZE);
        VERTSIZE = C.GetDeviceCaps(hdc, C.VERTSIZE);

        LOGPIXELSX = C.GetDeviceCaps(hdc,  C.LOGPIXELSX);
        LOGPIXELSY = C.GetDeviceCaps(hdc,  C.LOGPIXELSY);
        HORZRES = C.GetDeviceCaps(hdc,C.HORZRES);
        VERTRES = C.GetDeviceCaps(hdc, C.VERTRES);
        PHYSICALWIDTH = C.GetDeviceCaps(hdc, C.PHYSICALWIDTH);
        PHYSICALHEIGHT = C.GetDeviceCaps(hdc, C.PHYSICALHEIGHT);
    }

    printDict(caps)
end

local function test_unaware()
    print("==== test_unaware ====")
    getCaps();
end

local function test_aware()
    print("==== test_aware ====")
    local oldContext = C.SetThreadDpiAwarenessContext(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2);
    print("old context: ", oldContext)

    getCaps();
end


test_unaware()
test_aware()