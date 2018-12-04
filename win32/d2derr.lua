local ffi = require("ffi")

require("win32.winapifamily")


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

ffi.cdef[[
static const int FACILITY_D2D = 0x899;
]]

function MAKE_D2DHR( sev, code ) return MAKE_HRESULT( sev, FACILITY_D2D, (code) )

function MAKE_D2DHR_ERR( code ) return MAKE_D2DHR( 1, code )



ffi.cdef[[
static const int D2DERR_UNSUPPORTED_PIXEL_FORMAT   =  WINCODEC_ERR_UNSUPPORTEDPIXELFORMAT
]]



D2DERR_INSUFFICIENT_BUFFER        =  HRESULT_FROM_WIN32(ERROR_INSUFFICIENT_BUFFER)
D2DERR_FILE_NOT_FOUND             =  HRESULT_FROM_WIN32(ERROR_FILE_NOT_FOUND)


-- D2D specific codes now live in winerror.h



end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
