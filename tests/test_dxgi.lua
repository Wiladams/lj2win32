package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

--COM_NO_WINDOWS_H = true
require("win32.sdkddkver")
require("win32.windef")

local dxgi = require("win32.dxgi")


local ppFactory = ffi.new("IDXGIFactory1*[1]")
local hr = dxgi.CreateDXGIFactory1(C.IID_IDXGIFactory1,  ppFactory)

print(hr, ppFactory[0])
