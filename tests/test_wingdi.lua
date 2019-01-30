package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local gdi = require("win32.wingdi")
local winerror = require("win32.winerror")


-- Create a device context and check capabilities
local BITMAPINFOHEADER = nil
local BITMAPINFOHEADER_mt = {
    __new = function(ct,...)
        local obj = ffi.new(ct,...);
        obj.biSize = ffi.sizeof("BITMAPINFOHEADER")
        return obj;
    end;
    
    __index = {
        Init = function(self)
            self.biSize = ffi.sizeof("BITMAPINFOHEADER")
        end;
    }
}
ffi.metatype("BITMAPINFOHEADER", BITMAPINFOHEADER_mt)


local BITMAPINFO = ffi.typeof("BITMAPINFO")
local BITMAPINFO_mt = {
  __new = function(ct)
  --print("BITMAPINFO_ct")
    local obj = ffi.new(ct);
    obj:Init();
    obj.bmiHeader:Init();
    return obj;
  end;

  __index = {
    Init = function(self)
      self.bmiHeader:Init();
    end;
  };
}
ffi.metatype("BITMAPINFO", BITMAPINFO_mt)
