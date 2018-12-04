local ffi = require("ffi")



if not COM_NO_WINDOWS_H then
require("win32.windows")
end --// #ifndef COM_NO_WINDOWS_H

if not __dxgitype_h__ then
require("win32.dxgitype")
end --// #ifndef __dxgitype_h__

if not DCOMMON_H_INCLUDED
require("win32.dcommon")
end --// #ifndef DCOMMON_H_INCLUDED

ffi.cdef[[
typedef D3DCOLORVALUE D2D_COLOR_F;
]]
