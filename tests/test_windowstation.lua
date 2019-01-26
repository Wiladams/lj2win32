package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

local user32 = require("win32.sdkddkver")
local user32 = require("win32.wingdi")
local user32 = require("win32.winuser")

--[[
typedef BOOL (__stdcall *WINSTAENUMPROC) (LPTSTR lpszWindowStation,LPARAM lParam);

BOOL  EnumWindowStations(WINSTAENUMPROC lpEnumFunc, LPARAM lParam);
]]

local function OneStation(WindowStation, lParam)
    print(ffi.string(WindowStation), lParam)

    return true;
end 

local function windowStations()
    return function(params, state)
        return nil
    end
end

local function test_EnumWindowStations()
    print("==== test_EnumWindowStations ====")
    C.EnumWindowStationsA(OneStation, 0)
end

local function test_enumerator()
end

test_EnumWindowStations()
