
if not __wgl_wgl_h_ then
__wgl_wgl_h_ = 1

local ffi = require("ffi")
local C = ffi.C 

require("win32.gl.gl")
require("win32.minwindef")
require("win32.minwinbase")
require("win32.wingdi")

--[[
/*
** Copyright (c) 2013-2018 The Khronos Group Inc.
**
** Permission is hereby granted, free of charge, to any person obtaining a
** copy of this software and/or associated documentation files (the
** "Materials"), to deal in the Materials without restriction, including
** without limitation the rights to use, copy, modify, merge, publish,
** distribute, sublicense, and/or sell copies of the Materials, and to
** permit persons to whom the Materials are furnished to do so, subject to
** the following conditions:
**
** The above copyright notice and this permission notice shall be included
** in all copies or substantial portions of the Materials.
**
** THE MATERIALS ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
** EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
** MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
** IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
** CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
** TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
** MATERIALS OR THE USE OR OTHER DEALINGS IN THE MATERIALS.
*/
--]]

--[[
/*
** This header is generated from the Khronos OpenGL / OpenGL ES XML
** API Registry. The current version of the Registry, generator scripts
** used to make the header, and the header can be found at
**   https://github.com/KhronosGroup/OpenGL-Registry
*/
--]]

--[[
#if defined(_WIN32) && !defined(APIENTRY) && !defined(__CYGWIN__) && !defined(__SCITECH_SNAP__)
#define WIN32_LEAN_AND_MEAN 1
#include <windows.h>
end
--]]


--/* Generated on date 20190228 */

--[[
/* Generated C header for:
 * API: wgl
 * Versions considered: .*
 * Versions emitted: .*
 * Default extensions included: wgl
 * Additional extensions included: _nomatch_^
 * Extensions removed: _nomatch_^
 */
--]]

if not WGL_VERSION_1_0 then
WGL_VERSION_1_0 = 1

-- These are in wingdi.lua
--[=[
ffi.cdef[[
static const int WGL_FONT_LINES                    = 0;
static const int WGL_FONT_POLYGONS                 = 1;
]]
--]=]

-- These are in wingdi.lua
--[=[
ffi.cdef[[
static const int WGL_SWAP_MAIN_PLANE               = 0x00000001;
static const int WGL_SWAP_OVERLAY1                 = 0x00000002;
static const int WGL_SWAP_OVERLAY2                 = 0x00000004;
static const int WGL_SWAP_OVERLAY3                 = 0x00000008;
static const int WGL_SWAP_OVERLAY4                 = 0x00000010;
static const int WGL_SWAP_OVERLAY5                 = 0x00000020;
static const int WGL_SWAP_OVERLAY6                 = 0x00000040;
static const int WGL_SWAP_OVERLAY7                 = 0x00000080;
static const int WGL_SWAP_OVERLAY8                 = 0x00000100;
static const int WGL_SWAP_OVERLAY9                 = 0x00000200;
static const int WGL_SWAP_OVERLAY10                = 0x00000400;
static const int WGL_SWAP_OVERLAY11                = 0x00000800;
static const int WGL_SWAP_OVERLAY12                = 0x00001000;
static const int WGL_SWAP_OVERLAY13                = 0x00002000;
static const int WGL_SWAP_OVERLAY14                = 0x00004000;
static const int WGL_SWAP_OVERLAY15                = 0x00008000;
static const int WGL_SWAP_UNDERLAY1                = 0x00010000;
static const int WGL_SWAP_UNDERLAY2                = 0x00020000;
static const int WGL_SWAP_UNDERLAY3                = 0x00040000;
static const int WGL_SWAP_UNDERLAY4                = 0x00080000;
static const int WGL_SWAP_UNDERLAY5                = 0x00100000;
static const int WGL_SWAP_UNDERLAY6                = 0x00200000;
static const int WGL_SWAP_UNDERLAY7                = 0x00400000;
static const int WGL_SWAP_UNDERLAY8                = 0x00800000;
static const int WGL_SWAP_UNDERLAY9                = 0x01000000;
static const int WGL_SWAP_UNDERLAY10               = 0x02000000;
static const int WGL_SWAP_UNDERLAY11               = 0x04000000;
static const int WGL_SWAP_UNDERLAY12               = 0x08000000;
static const int WGL_SWAP_UNDERLAY13               = 0x10000000;
static const int WGL_SWAP_UNDERLAY14               = 0x20000000;
static const int WGL_SWAP_UNDERLAY15               = 0x40000000;
]]
--]=]


ffi.cdef[[
typedef int (__stdcall * PFNCHOOSEPIXELFORMATPROC) (HDC hDc, const PIXELFORMATDESCRIPTOR *pPfd);
typedef int (__stdcall * PFNDESCRIBEPIXELFORMATPROC) (HDC hdc, int ipfd, UINT cjpfd, const PIXELFORMATDESCRIPTOR *ppfd);
typedef UINT (__stdcall * PFNGETENHMETAFILEPIXELFORMATPROC) (HENHMETAFILE hemf, const PIXELFORMATDESCRIPTOR *ppfd);
typedef int (__stdcall * PFNGETPIXELFORMATPROC) (HDC hdc);
typedef BOOL (__stdcall * PFNSETPIXELFORMATPROC) (HDC hdc, int ipfd, const PIXELFORMATDESCRIPTOR *ppfd);
typedef BOOL (__stdcall * PFNSWAPBUFFERSPROC) (HDC hdc);
typedef BOOL (__stdcall * PFNWGLCOPYCONTEXTPROC) (HGLRC hglrcSrc, HGLRC hglrcDst, UINT mask);
typedef HGLRC (__stdcall * PFNWGLCREATECONTEXTPROC) (HDC hDc);
typedef HGLRC (__stdcall * PFNWGLCREATELAYERCONTEXTPROC) (HDC hDc, int level);
typedef BOOL (__stdcall * PFNWGLDELETECONTEXTPROC) (HGLRC oldContext);
typedef BOOL (__stdcall * PFNWGLDESCRIBELAYERPLANEPROC) (HDC hDc, int pixelFormat, int layerPlane, UINT nBytes, const LAYERPLANEDESCRIPTOR *plpd);
typedef HGLRC (__stdcall * PFNWGLGETCURRENTCONTEXTPROC) (void);
typedef HDC (__stdcall * PFNWGLGETCURRENTDCPROC) (void);
typedef int (__stdcall * PFNWGLGETLAYERPALETTEENTRIESPROC) (HDC hdc, int iLayerPlane, int iStart, int cEntries, const COLORREF *pcr);
typedef PROC (__stdcall * PFNWGLGETPROCADDRESSPROC) (LPCSTR lpszProc);
typedef BOOL (__stdcall * PFNWGLMAKECURRENTPROC) (HDC hDc, HGLRC newContext);
typedef BOOL (__stdcall * PFNWGLREALIZELAYERPALETTEPROC) (HDC hdc, int iLayerPlane, BOOL bRealize);
typedef int (__stdcall * PFNWGLSETLAYERPALETTEENTRIESPROC) (HDC hdc, int iLayerPlane, int iStart, int cEntries, const COLORREF *pcr);
typedef BOOL (__stdcall * PFNWGLSHARELISTSPROC) (HGLRC hrcSrvShare, HGLRC hrcSrvSource);
typedef BOOL (__stdcall * PFNWGLSWAPLAYERBUFFERSPROC) (HDC hdc, UINT fuFlags);
typedef BOOL (__stdcall * PFNWGLUSEFONTBITMAPSPROC) (HDC hDC, DWORD first, DWORD count, DWORD listBase);
typedef BOOL (__stdcall * PFNWGLUSEFONTBITMAPSAPROC) (HDC hDC, DWORD first, DWORD count, DWORD listBase);
typedef BOOL (__stdcall * PFNWGLUSEFONTBITMAPSWPROC) (HDC hDC, DWORD first, DWORD count, DWORD listBase);
typedef BOOL (__stdcall * PFNWGLUSEFONTOUTLINESPROC) (HDC hDC, DWORD first, DWORD count, DWORD listBase, FLOAT deviation, FLOAT extrusion, int format, LPGLYPHMETRICSFLOAT lpgmf);
typedef BOOL (__stdcall * PFNWGLUSEFONTOUTLINESAPROC) (HDC hDC, DWORD first, DWORD count, DWORD listBase, FLOAT deviation, FLOAT extrusion, int format, LPGLYPHMETRICSFLOAT lpgmf);
typedef BOOL (__stdcall * PFNWGLUSEFONTOUTLINESWPROC) (HDC hDC, DWORD first, DWORD count, DWORD listBase, FLOAT deviation, FLOAT extrusion, int format, LPGLYPHMETRICSFLOAT lpgmf);
]]

if WGL_WGLEXT_PROTOTYPES then
ffi.cdef[[
int __stdcall ChoosePixelFormat (HDC hDc, const PIXELFORMATDESCRIPTOR *pPfd);
int __stdcall DescribePixelFormat (HDC hdc, int ipfd, UINT cjpfd, const PIXELFORMATDESCRIPTOR *ppfd);
UINT __stdcall GetEnhMetaFilePixelFormat (HENHMETAFILE hemf, const PIXELFORMATDESCRIPTOR *ppfd);
int __stdcall GetPixelFormat (HDC hdc);
BOOL __stdcall SetPixelFormat (HDC hdc, int ipfd, const PIXELFORMATDESCRIPTOR *ppfd);
BOOL __stdcall SwapBuffers (HDC hdc);
BOOL __stdcall wglCopyContext (HGLRC hglrcSrc, HGLRC hglrcDst, UINT mask);
HGLRC __stdcall wglCreateContext (HDC hDc);
HGLRC __stdcall wglCreateLayerContext (HDC hDc, int level);
BOOL __stdcall wglDeleteContext (HGLRC oldContext);
BOOL __stdcall wglDescribeLayerPlane (HDC hDc, int pixelFormat, int layerPlane, UINT nBytes, const LAYERPLANEDESCRIPTOR *plpd);
HGLRC __stdcall wglGetCurrentContext (void);
HDC __stdcall wglGetCurrentDC (void);
int __stdcall wglGetLayerPaletteEntries (HDC hdc, int iLayerPlane, int iStart, int cEntries, const COLORREF *pcr);
PROC __stdcall wglGetProcAddress (LPCSTR lpszProc);
BOOL __stdcall wglMakeCurrent (HDC hDc, HGLRC newContext);
BOOL __stdcall wglRealizeLayerPalette (HDC hdc, int iLayerPlane, BOOL bRealize);
int __stdcall wglSetLayerPaletteEntries (HDC hdc, int iLayerPlane, int iStart, int cEntries, const COLORREF *pcr);
BOOL __stdcall wglShareLists (HGLRC hrcSrvShare, HGLRC hrcSrvSource);
BOOL __stdcall wglSwapLayerBuffers (HDC hdc, UINT fuFlags);
BOOL __stdcall wglUseFontBitmaps (HDC hDC, DWORD first, DWORD count, DWORD listBase);
BOOL __stdcall wglUseFontBitmapsA (HDC hDC, DWORD first, DWORD count, DWORD listBase);
BOOL __stdcall wglUseFontBitmapsW (HDC hDC, DWORD first, DWORD count, DWORD listBase);
BOOL __stdcall wglUseFontOutlines (HDC hDC, DWORD first, DWORD count, DWORD listBase, FLOAT deviation, FLOAT extrusion, int format, LPGLYPHMETRICSFLOAT lpgmf);
BOOL __stdcall wglUseFontOutlinesA (HDC hDC, DWORD first, DWORD count, DWORD listBase, FLOAT deviation, FLOAT extrusion, int format, LPGLYPHMETRICSFLOAT lpgmf);
BOOL __stdcall wglUseFontOutlinesW (HDC hDC, DWORD first, DWORD count, DWORD listBase, FLOAT deviation, FLOAT extrusion, int format, LPGLYPHMETRICSFLOAT lpgmf);
]]
end
end --/* WGL_VERSION_1_0 */

if not WGL_ARB_buffer_region then
WGL_ARB_buffer_region = 1
ffi.cdef[[
static const int WGL_FRONT_COLOR_BUFFER_BIT_ARB   = 0x00000001;
static const int WGL_BACK_COLOR_BUFFER_BIT_ARB    = 0x00000002;
static const int WGL_DEPTH_BUFFER_BIT_ARB         = 0x00000004;
static const int WGL_STENCIL_BUFFER_BIT_ARB       = 0x00000008;
]]

ffi.cdef[[
typedef HANDLE (__stdcall * PFNWGLCREATEBUFFERREGIONARBPROC) (HDC hDC, int iLayerPlane, UINT uType);
typedef VOID (__stdcall * PFNWGLDELETEBUFFERREGIONARBPROC) (HANDLE hRegion);
typedef BOOL (__stdcall * PFNWGLSAVEBUFFERREGIONARBPROC) (HANDLE hRegion, int x, int y, int width, int height);
typedef BOOL (__stdcall * PFNWGLRESTOREBUFFERREGIONARBPROC) (HANDLE hRegion, int x, int y, int width, int height, int xSrc, int ySrc);
]]

if WGL_WGLEXT_PROTOTYPES then
ffi.cdef[[
HANDLE __stdcall wglCreateBufferRegionARB (HDC hDC, int iLayerPlane, UINT uType);
VOID __stdcall wglDeleteBufferRegionARB (HANDLE hRegion);
BOOL __stdcall wglSaveBufferRegionARB (HANDLE hRegion, int x, int y, int width, int height);
BOOL __stdcall wglRestoreBufferRegionARB (HANDLE hRegion, int x, int y, int width, int height, int xSrc, int ySrc);
]]
end

end --/* WGL_ARB_buffer_region */

if not WGL_ARB_context_flush_control then
WGL_ARB_context_flush_control = 1
ffi.cdef[[
static const int WGL_CONTEXT_RELEASE_BEHAVIOR_ARB        = 0x2097;
static const int WGL_CONTEXT_RELEASE_BEHAVIOR_NONE_ARB   = 0;
static const int WGL_CONTEXT_RELEASE_BEHAVIOR_FLUSH_ARB  = 0x2098;
]]
end --/* WGL_ARB_context_flush_control */

if not WGL_ARB_create_context then
WGL_ARB_create_context = 1;
ffi.cdef[[
static const int WGL_CONTEXT_DEBUG_BIT_ARB        = 0x00000001;
static const int WGL_CONTEXT_FORWARD_COMPATIBLE_BIT_ARB = 0x00000002;
static const int WGL_CONTEXT_MAJOR_VERSION_ARB    = 0x2091;
static const int WGL_CONTEXT_MINOR_VERSION_ARB    = 0x2092;
static const int WGL_CONTEXT_LAYER_PLANE_ARB      = 0x2093;
static const int WGL_CONTEXT_FLAGS_ARB            = 0x2094;
static const int ERROR_INVALID_VERSION_ARB        = 0x2095;
]]

ffi.cdef[[
typedef HGLRC (__stdcall * PFNWGLCREATECONTEXTATTRIBSARBPROC) (HDC hDC, HGLRC hShareContext, const int *attribList);
]]

if WGL_WGLEXT_PROTOTYPES then
ffi.cdef[[
HGLRC __stdcall wglCreateContextAttribsARB (HDC hDC, HGLRC hShareContext, const int *attribList);
]]
end

end --/* WGL_ARB_create_context */

if not WGL_ARB_create_context_no_error then
WGL_ARB_create_context_no_error = 1;
ffi.cdef[[
static const int WGL_CONTEXT_OPENGL_NO_ERROR_ARB  = 0x31B3;
]]
end --/* WGL_ARB_create_context_no_error */

if not WGL_ARB_create_context_profile then
WGL_ARB_create_context_profile = 1;

ffi.cdef[[
static const int WGL_CONTEXT_PROFILE_MASK_ARB      = 0x9126;
static const int WGL_CONTEXT_CORE_PROFILE_BIT_ARB  = 0x00000001;
static const int WGL_CONTEXT_COMPATIBILITY_PROFILE_BIT_ARB = 0x00000002;
static const int ERROR_INVALID_PROFILE_ARB         = 0x2096;
]]
end --/* WGL_ARB_create_context_profile */

if not WGL_ARB_create_context_robustness then
WGL_ARB_create_context_robustness = 1
ffi.cdef[[
static const int WGL_CONTEXT_ROBUST_ACCESS_BIT_ARB = 0x00000004;
static const int WGL_LOSE_CONTEXT_ON_RESET_ARB     = 0x8252;
static const int WGL_CONTEXT_RESET_NOTIFICATION_STRATEGY_ARB = 0x8256;
static const int WGL_NO_RESET_NOTIFICATION_ARB     = 0x8261;
]]
end --/* WGL_ARB_create_context_robustness */

if not WGL_ARB_extensions_string then
WGL_ARB_extensions_string = 1

ffi.cdef[[
typedef const char *(__stdcall * PFNWGLGETEXTENSIONSSTRINGARBPROC) (HDC hdc);
]]

if WGL_WGLEXT_PROTOTYPES then
ffi.cdef[[
const char *__stdcall wglGetExtensionsStringARB (HDC hdc);
]]
end
end --/* WGL_ARB_extensions_string */

if not WGL_ARB_framebuffer_sRGB then
WGL_ARB_framebuffer_sRGB = 1
ffi.cdef[[
static const int WGL_FRAMEBUFFER_SRGB_CAPABLE_ARB = 0x20A9;
]]
end --/* WGL_ARB_framebuffer_sRGB */

if not WGL_ARB_make_current_read then
WGL_ARB_make_current_read = 1
ffi.cdef[[
static const int ERROR_INVALID_PIXEL_TYPE_ARB    =  0x2043;
static const int ERROR_INCOMPATIBLE_DEVICE_CONTEXTS_ARB = 0x2054;
]]

ffi.cdef[[
typedef BOOL (__stdcall * PFNWGLMAKECONTEXTCURRENTARBPROC) (HDC hDrawDC, HDC hReadDC, HGLRC hglrc);
typedef HDC (__stdcall * PFNWGLGETCURRENTREADDCARBPROC) (void);
]]

if WGL_WGLEXT_PROTOTYPES then
ffi.cdef[[
BOOL __stdcall wglMakeContextCurrentARB (HDC hDrawDC, HDC hReadDC, HGLRC hglrc);
HDC __stdcall wglGetCurrentReadDCARB (void);
]]
end
end --/* WGL_ARB_make_current_read */

if not WGL_ARB_multisample then
WGL_ARB_multisample = 1
ffi.cdef[[
static const int WGL_SAMPLE_BUFFERS_ARB         =   0x2041;
static const int WGL_SAMPLES_ARB                =   0x2042;
]]
end --/* WGL_ARB_multisample */

if not WGL_ARB_pbuffer then
WGL_ARB_pbuffer = 1
DECLARE_HANDLE("HPBUFFERARB");

ffi.cdef[[
static const int WGL_DRAW_TO_PBUFFER_ARB         =  0x202D;
static const int WGL_MAX_PBUFFER_PIXELS_ARB      =  0x202E;
static const int WGL_MAX_PBUFFER_WIDTH_ARB       =  0x202F;
static const int WGL_MAX_PBUFFER_HEIGHT_ARB      =  0x2030;
static const int WGL_PBUFFER_LARGEST_ARB         =  0x2033;
static const int WGL_PBUFFER_WIDTH_ARB           =  0x2034;
static const int WGL_PBUFFER_HEIGHT_ARB          =  0x2035;
static const int WGL_PBUFFER_LOST_ARB            =  0x2036;
]]

ffi.cdef[[
typedef HPBUFFERARB (__stdcall * PFNWGLCREATEPBUFFERARBPROC) (HDC hDC, int iPixelFormat, int iWidth, int iHeight, const int *piAttribList);
typedef HDC (__stdcall * PFNWGLGETPBUFFERDCARBPROC) (HPBUFFERARB hPbuffer);
typedef int (__stdcall * PFNWGLRELEASEPBUFFERDCARBPROC) (HPBUFFERARB hPbuffer, HDC hDC);
typedef BOOL (__stdcall * PFNWGLDESTROYPBUFFERARBPROC) (HPBUFFERARB hPbuffer);
typedef BOOL (__stdcall * PFNWGLQUERYPBUFFERARBPROC) (HPBUFFERARB hPbuffer, int iAttribute, int *piValue);
]]

if WGL_WGLEXT_PROTOTYPES then
ffi.cdef[[
HPBUFFERARB __stdcall wglCreatePbufferARB (HDC hDC, int iPixelFormat, int iWidth, int iHeight, const int *piAttribList);
HDC __stdcall wglGetPbufferDCARB (HPBUFFERARB hPbuffer);
int __stdcall wglReleasePbufferDCARB (HPBUFFERARB hPbuffer, HDC hDC);
BOOL __stdcall wglDestroyPbufferARB (HPBUFFERARB hPbuffer);
BOOL __stdcall wglQueryPbufferARB (HPBUFFERARB hPbuffer, int iAttribute, int *piValue);
]]
end
end --/* WGL_ARB_pbuffer */

if not WGL_ARB_pixel_format then
WGL_ARB_pixel_format = 1

ffi.cdef[[
static const int WGL_NUMBER_PIXEL_FORMATS_ARB      = 0x2000;
static const int WGL_DRAW_TO_WINDOW_ARB            = 0x2001;
static const int WGL_DRAW_TO_BITMAP_ARB            = 0x2002;
static const int WGL_ACCELERATION_ARB              = 0x2003;
static const int WGL_NEED_PALETTE_ARB              = 0x2004;
static const int WGL_NEED_SYSTEM_PALETTE_ARB       = 0x2005;
static const int WGL_SWAP_LAYER_BUFFERS_ARB        = 0x2006;
static const int WGL_SWAP_METHOD_ARB               = 0x2007;
static const int WGL_NUMBER_OVERLAYS_ARB           = 0x2008;
static const int WGL_NUMBER_UNDERLAYS_ARB          = 0x2009;
static const int WGL_TRANSPARENT_ARB               = 0x200A;
static const int WGL_TRANSPARENT_RED_VALUE_ARB     = 0x2037;
static const int WGL_TRANSPARENT_GREEN_VALUE_ARB   = 0x2038;
static const int WGL_TRANSPARENT_BLUE_VALUE_ARB    = 0x2039;
static const int WGL_TRANSPARENT_ALPHA_VALUE_ARB   = 0x203A;
static const int WGL_TRANSPARENT_INDEX_VALUE_ARB   = 0x203B;
static const int WGL_SHARE_DEPTH_ARB               = 0x200C;
static const int WGL_SHARE_STENCIL_ARB             = 0x200D;
static const int WGL_SHARE_ACCUM_ARB               = 0x200E;
static const int WGL_SUPPORT_GDI_ARB               = 0x200F;
static const int WGL_SUPPORT_OPENGL_ARB            = 0x2010;
static const int WGL_DOUBLE_BUFFER_ARB             = 0x2011;
static const int WGL_STEREO_ARB                    = 0x2012;
static const int WGL_PIXEL_TYPE_ARB                = 0x2013;
static const int WGL_COLOR_BITS_ARB                = 0x2014;
static const int WGL_RED_BITS_ARB                  = 0x2015;
static const int WGL_RED_SHIFT_ARB                 = 0x2016;
static const int WGL_GREEN_BITS_ARB                = 0x2017;
static const int WGL_GREEN_SHIFT_ARB               = 0x2018;
static const int WGL_BLUE_BITS_ARB                 = 0x2019;
static const int WGL_BLUE_SHIFT_ARB                = 0x201A;
static const int WGL_ALPHA_BITS_ARB                = 0x201B;
static const int WGL_ALPHA_SHIFT_ARB               = 0x201C;
static const int WGL_ACCUM_BITS_ARB                = 0x201D;
static const int WGL_ACCUM_RED_BITS_ARB            = 0x201E;
static const int WGL_ACCUM_GREEN_BITS_ARB          = 0x201F;
static const int WGL_ACCUM_BLUE_BITS_ARB           = 0x2020;
static const int WGL_ACCUM_ALPHA_BITS_ARB          = 0x2021;
static const int WGL_DEPTH_BITS_ARB                = 0x2022;
static const int WGL_STENCIL_BITS_ARB              = 0x2023;
static const int WGL_AUX_BUFFERS_ARB               = 0x2024;
static const int WGL_NO_ACCELERATION_ARB           = 0x2025;
static const int WGL_GENERIC_ACCELERATION_ARB      = 0x2026;
static const int WGL_FULL_ACCELERATION_ARB         = 0x2027;
static const int WGL_SWAP_EXCHANGE_ARB             = 0x2028;
static const int WGL_SWAP_COPY_ARB                 = 0x2029;
static const int WGL_SWAP_UNDEFINED_ARB            = 0x202A;
static const int WGL_TYPE_RGBA_ARB                 = 0x202B;
static const int WGL_TYPE_COLORINDEX_ARB           = 0x202C;
]]

ffi.cdef[[
typedef BOOL (__stdcall * PFNWGLGETPIXELFORMATATTRIBIVARBPROC) (HDC hdc, int iPixelFormat, int iLayerPlane, UINT nAttributes, const int *piAttributes, int *piValues);
typedef BOOL (__stdcall * PFNWGLGETPIXELFORMATATTRIBFVARBPROC) (HDC hdc, int iPixelFormat, int iLayerPlane, UINT nAttributes, const int *piAttributes, FLOAT *pfValues);
typedef BOOL (__stdcall * PFNWGLCHOOSEPIXELFORMATARBPROC) (HDC hdc, const int *piAttribIList, const FLOAT *pfAttribFList, UINT nMaxFormats, int *piFormats, UINT *nNumFormats);
]]

if WGL_WGLEXT_PROTOTYPES then
ffi.cdef[[
BOOL __stdcall wglGetPixelFormatAttribivARB (HDC hdc, int iPixelFormat, int iLayerPlane, UINT nAttributes, const int *piAttributes, int *piValues);
BOOL __stdcall wglGetPixelFormatAttribfvARB (HDC hdc, int iPixelFormat, int iLayerPlane, UINT nAttributes, const int *piAttributes, FLOAT *pfValues);
BOOL __stdcall wglChoosePixelFormatARB (HDC hdc, const int *piAttribIList, const FLOAT *pfAttribFList, UINT nMaxFormats, int *piFormats, UINT *nNumFormats);
]]
end
end --/* WGL_ARB_pixel_format */

if not WGL_ARB_pixel_format_float then
WGL_ARB_pixel_format_float = 1;
ffi.cdef[[
static const int WGL_TYPE_RGBA_FLOAT_ARB        =   0x21A0;
]]
end --/* WGL_ARB_pixel_format_float */

if not WGL_ARB_render_texture then
WGL_ARB_render_texture = 1

ffi.cdef[[
static const int WGL_BIND_TO_TEXTURE_RGB_ARB       = 0x2070;
static const int WGL_BIND_TO_TEXTURE_RGBA_ARB      = 0x2071;
static const int WGL_TEXTURE_FORMAT_ARB            = 0x2072;
static const int WGL_TEXTURE_TARGET_ARB            = 0x2073;
static const int WGL_MIPMAP_TEXTURE_ARB            = 0x2074;
static const int WGL_TEXTURE_RGB_ARB               = 0x2075;
static const int WGL_TEXTURE_RGBA_ARB              = 0x2076;
static const int WGL_NO_TEXTURE_ARB                = 0x2077;
static const int WGL_TEXTURE_CUBE_MAP_ARB          = 0x2078;
static const int WGL_TEXTURE_1D_ARB                = 0x2079;
static const int WGL_TEXTURE_2D_ARB                = 0x207A;
static const int WGL_MIPMAP_LEVEL_ARB              = 0x207B;
static const int WGL_CUBE_MAP_FACE_ARB             = 0x207C;
static const int WGL_TEXTURE_CUBE_MAP_POSITIVE_X_ARB = 0x207D;
static const int WGL_TEXTURE_CUBE_MAP_NEGATIVE_X_ARB = 0x207E;
static const int WGL_TEXTURE_CUBE_MAP_POSITIVE_Y_ARB = 0x207F;
static const int WGL_TEXTURE_CUBE_MAP_NEGATIVE_Y_ARB = 0x2080;
static const int WGL_TEXTURE_CUBE_MAP_POSITIVE_Z_ARB = 0x2081;
static const int WGL_TEXTURE_CUBE_MAP_NEGATIVE_Z_ARB = 0x2082;
static const int WGL_FRONT_LEFT_ARB                = 0x2083;
static const int WGL_FRONT_RIGHT_ARB               = 0x2084;
static const int WGL_BACK_LEFT_ARB                 = 0x2085;
static const int WGL_BACK_RIGHT_ARB                = 0x2086;
static const int WGL_AUX0_ARB                      = 0x2087;
static const int WGL_AUX1_ARB                      = 0x2088;
static const int WGL_AUX2_ARB                      = 0x2089;
static const int WGL_AUX3_ARB                      = 0x208A;
static const int WGL_AUX4_ARB                      = 0x208B;
static const int WGL_AUX5_ARB                      = 0x208C;
static const int WGL_AUX6_ARB                      = 0x208D;
static const int WGL_AUX7_ARB                      = 0x208E;
static const int WGL_AUX8_ARB                      = 0x208F;
static const int WGL_AUX9_ARB                      = 0x2090;
]]

ffi.cdef[[
typedef BOOL (__stdcall * PFNWGLBINDTEXIMAGEARBPROC) (HPBUFFERARB hPbuffer, int iBuffer);
typedef BOOL (__stdcall * PFNWGLRELEASETEXIMAGEARBPROC) (HPBUFFERARB hPbuffer, int iBuffer);
typedef BOOL (__stdcall * PFNWGLSETPBUFFERATTRIBARBPROC) (HPBUFFERARB hPbuffer, const int *piAttribList);
]]

if WGL_WGLEXT_PROTOTYPES then
ffi.cdef[[
BOOL __stdcall wglBindTexImageARB (HPBUFFERARB hPbuffer, int iBuffer);
BOOL __stdcall wglReleaseTexImageARB (HPBUFFERARB hPbuffer, int iBuffer);
BOOL __stdcall wglSetPbufferAttribARB (HPBUFFERARB hPbuffer, const int *piAttribList);
]]
end
end --/* WGL_ARB_render_texture */


if not WGL_ARB_robustness_application_isolation then
WGL_ARB_robustness_application_isolation =1

ffi.cdef[[
static const int WGL_CONTEXT_RESET_ISOLATION_BIT_ARB = 0x00000008;
]]
end  -- WGL_ARB_robustness_application_isolation */

if not WGL_ARB_robustness_share_group_isolation then
WGL_ARB_robustness_share_group_isolation =1
end  -- WGL_ARB_robustness_share_group_isolation */


if not WGL_3DFX_multisample then
WGL_3DFX_multisample =1

ffi.cdef[[
static const int WGL_SAMPLE_BUFFERS_3DFX         =  0x2060;
static const int WGL_SAMPLES_3DFX                =  0x2061;
]]
end  -- WGL_3DFX_multisample */

if not WGL_3DL_stereo_control then
WGL_3DL_stereo_control =1

ffi.cdef[[
static const int WGL_STEREO_EMITTER_ENABLE_3DL    = 0x2055;
static const int WGL_STEREO_EMITTER_DISABLE_3DL   = 0x2056;
static const int WGL_STEREO_POLARITY_NORMAL_3DL   = 0x2057;
static const int WGL_STEREO_POLARITY_INVERT_3DL   = 0x2058;
]]

ffi.cdef[[
typedef BOOL (__stdcall * PFNWGLSETSTEREOEMITTERSTATE3DLPROC) (HDC hDC, UINT uState);
]]

if WGL_WGLEXT_PROTOTYPES then
ffi.cdef[[
BOOL __stdcall wglSetStereoEmitterState3DL (HDC hDC, UINT uState);
]]
end
end  -- WGL_3DL_stereo_control */


if not WGL_AMD_gpu_association then
WGL_AMD_gpu_association = 1

ffi.cdef[[
static const int WGL_GPU_VENDOR_AMD                = 0x1F00;
static const int WGL_GPU_RENDERER_STRING_AMD       = 0x1F01;
static const int WGL_GPU_OPENGL_VERSION_STRING_AMD = 0x1F02;
static const int WGL_GPU_FASTEST_TARGET_GPUS_AMD   = 0x21A2;
static const int WGL_GPU_RAM_AMD                   = 0x21A3;
static const int WGL_GPU_CLOCK_AMD                 = 0x21A4;
static const int WGL_GPU_NUM_PIPES_AMD             = 0x21A5;
static const int WGL_GPU_NUM_SIMD_AMD              = 0x21A6;
static const int WGL_GPU_NUM_RB_AMD                = 0x21A7;
static const int WGL_GPU_NUM_SPI_AMD               = 0x21A8;
]]

ffi.cdef[[
typedef UINT (__stdcall * PFNWGLGETGPUIDSAMDPROC) (UINT maxCount, UINT *ids);
typedef INT (__stdcall * PFNWGLGETGPUINFOAMDPROC) (UINT id, INT property, GLenum dataType, UINT size, void *data);
typedef UINT (__stdcall * PFNWGLGETCONTEXTGPUIDAMDPROC) (HGLRC hglrc);
typedef HGLRC (__stdcall * PFNWGLCREATEASSOCIATEDCONTEXTAMDPROC) (UINT id);
typedef HGLRC (__stdcall * PFNWGLCREATEASSOCIATEDCONTEXTATTRIBSAMDPROC) (UINT id, HGLRC hShareContext, const int *attribList);
typedef BOOL (__stdcall * PFNWGLDELETEASSOCIATEDCONTEXTAMDPROC) (HGLRC hglrc);
typedef BOOL (__stdcall * PFNWGLMAKEASSOCIATEDCONTEXTCURRENTAMDPROC) (HGLRC hglrc);
typedef HGLRC (__stdcall * PFNWGLGETCURRENTASSOCIATEDCONTEXTAMDPROC) (void);
typedef VOID (__stdcall * PFNWGLBLITCONTEXTFRAMEBUFFERAMDPROC) (HGLRC dstCtx, GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask, GLenum filter);
]]

if WGL_WGLEXT_PROTOTYPES then
ffi.cdef[[
UINT __stdcall wglGetGPUIDsAMD (UINT maxCount, UINT *ids);
INT __stdcall wglGetGPUInfoAMD (UINT id, INT property, GLenum dataType, UINT size, void *data);
UINT __stdcall wglGetContextGPUIDAMD (HGLRC hglrc);
HGLRC __stdcall wglCreateAssociatedContextAMD (UINT id);
HGLRC __stdcall wglCreateAssociatedContextAttribsAMD (UINT id, HGLRC hShareContext, const int *attribList);
BOOL __stdcall wglDeleteAssociatedContextAMD (HGLRC hglrc);
BOOL __stdcall wglMakeAssociatedContextCurrentAMD (HGLRC hglrc);
HGLRC __stdcall wglGetCurrentAssociatedContextAMD (void);
VOID __stdcall wglBlitContextFramebufferAMD (HGLRC dstCtx, GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask, GLenum filter);
]]
end
end  -- WGL_AMD_gpu_association */

--[=[
if not WGL_ATI_pixel_format_float then
#define WGL_ATI_pixel_format_float = 1
#define WGL_TYPE_RGBA_FLOAT_ATI           0x21A0
end  -- WGL_ATI_pixel_format_float */

if not WGL_ATI_render_texture_rectangle then
#define WGL_ATI_render_texture_rectangle = 1
#define WGL_TEXTURE_RECTANGLE_ATI         0x21A5
end  -- WGL_ATI_render_texture_rectangle */

if not WGL_EXT_colorspace then
#define WGL_EXT_colorspace = 1
#define WGL_COLORSPACE_EXT                0x309D
#define WGL_COLORSPACE_SRGB_EXT           0x3089
#define WGL_COLORSPACE_LINEAR_EXT         0x308A
end  -- WGL_EXT_colorspace */

if not WGL_EXT_create_context_es2_profile then
#define WGL_EXT_create_context_es2_profile  =1
#define WGL_CONTEXT_ES2_PROFILE_BIT_EXT   0x00000004
end  -- WGL_EXT_create_context_es2_profile */

if not WGL_EXT_create_context_es_profile then
#define WGL_EXT_create_context_es_profile = 1
#define WGL_CONTEXT_ES_PROFILE_BIT_EXT    0x00000004
end  -- WGL_EXT_create_context_es_profile */

if not WGL_EXT_depth_float then
#define WGL_EXT_depth_float = 1
#define WGL_DEPTH_FLOAT_EXT               0x2040
end  -- WGL_EXT_depth_float */

if not WGL_EXT_display_color_table then
#define WGL_EXT_display_color_table = 1
typedef GLboolean (__stdcall * PFNWGLCREATEDISPLAYCOLORTABLEEXTPROC) (GLushort id);
typedef GLboolean (__stdcall * PFNWGLLOADDISPLAYCOLORTABLEEXTPROC) (const GLushort *table, GLuint length);
typedef GLboolean (__stdcall * PFNWGLBINDDISPLAYCOLORTABLEEXTPROC) (GLushort id);
typedef VOID (__stdcall * PFNWGLDESTROYDISPLAYCOLORTABLEEXTPROC) (GLushort id);
if WGL_WGLEXT_PROTOTYPES
GLboolean __stdcall wglCreateDisplayColorTableEXT (GLushort id);
GLboolean __stdcall wglLoadDisplayColorTableEXT (const GLushort *table, GLuint length);
GLboolean __stdcall wglBindDisplayColorTableEXT (GLushort id);
VOID __stdcall wglDestroyDisplayColorTableEXT (GLushort id);
end
end  -- WGL_EXT_display_color_table */

if not WGL_EXT_extensions_string then
#define WGL_EXT_extensions_string = 1
typedef const char *(__stdcall * PFNWGLGETEXTENSIONSSTRINGEXTPROC) (void);

if WGL_WGLEXT_PROTOTYPES then
const char *__stdcall wglGetExtensionsStringEXT (void);
end
end  -- WGL_EXT_extensions_string */

if not WGL_EXT_framebuffer_sRGB then
#define WGL_EXT_framebuffer_sRGB = 1
#define WGL_FRAMEBUFFER_SRGB_CAPABLE_EXT  0x20A9
end  -- WGL_EXT_framebuffer_sRGB */

if not WGL_EXT_make_current_read then
#define WGL_EXT_make_current_read = 1
#define ERROR_INVALID_PIXEL_TYPE_EXT      0x2043
typedef BOOL (__stdcall * PFNWGLMAKECONTEXTCURRENTEXTPROC) (HDC hDrawDC, HDC hReadDC, HGLRC hglrc);
typedef HDC (__stdcall * PFNWGLGETCURRENTREADDCEXTPROC) (void);
if WGL_WGLEXT_PROTOTYPES
BOOL __stdcall wglMakeContextCurrentEXT (HDC hDrawDC, HDC hReadDC, HGLRC hglrc);
HDC __stdcall wglGetCurrentReadDCEXT (void);
end
end  -- WGL_EXT_make_current_read */
--]=]

if not WGL_EXT_multisample then
WGL_EXT_multisample =1
ffi.cdef[[
static const int WGL_SAMPLE_BUFFERS_EXT        = 0x2041;
static const int WGL_SAMPLES_EXT               = 0x2042;
]]
end  -- WGL_EXT_multisample */


if not WGL_EXT_pbuffer then
WGL_EXT_pbuffer =1

DECLARE_HANDLE("HPBUFFEREXT");

ffi.cdef[[
static const int WGL_DRAW_TO_PBUFFER_EXT          = 0x202D;
static const int WGL_MAX_PBUFFER_PIXELS_EXT       = 0x202E;
static const int WGL_MAX_PBUFFER_WIDTH_EXT        = 0x202F;
static const int WGL_MAX_PBUFFER_HEIGHT_EXT       = 0x2030;
static const int WGL_OPTIMAL_PBUFFER_WIDTH_EXT    = 0x2031;
static const int WGL_OPTIMAL_PBUFFER_HEIGHT_EXT   = 0x2032;
static const int WGL_PBUFFER_LARGEST_EXT          = 0x2033;
static const int WGL_PBUFFER_WIDTH_EXT            = 0x2034;
static const int WGL_PBUFFER_HEIGHT_EXT           = 0x2035;
]]

ffi.cdef[[
typedef HPBUFFEREXT (__stdcall * PFNWGLCREATEPBUFFEREXTPROC) (HDC hDC, int iPixelFormat, int iWidth, int iHeight, const int *piAttribList);
typedef HDC (__stdcall * PFNWGLGETPBUFFERDCEXTPROC) (HPBUFFEREXT hPbuffer);
typedef int (__stdcall * PFNWGLRELEASEPBUFFERDCEXTPROC) (HPBUFFEREXT hPbuffer, HDC hDC);
typedef BOOL (__stdcall * PFNWGLDESTROYPBUFFEREXTPROC) (HPBUFFEREXT hPbuffer);
typedef BOOL (__stdcall * PFNWGLQUERYPBUFFEREXTPROC) (HPBUFFEREXT hPbuffer, int iAttribute, int *piValue);
]]

if WGL_WGLEXT_PROTOTYPES then
ffi.cdef[[
HPBUFFEREXT __stdcall wglCreatePbufferEXT (HDC hDC, int iPixelFormat, int iWidth, int iHeight, const int *piAttribList);
HDC __stdcall wglGetPbufferDCEXT (HPBUFFEREXT hPbuffer);
int __stdcall wglReleasePbufferDCEXT (HPBUFFEREXT hPbuffer, HDC hDC);
BOOL __stdcall wglDestroyPbufferEXT (HPBUFFEREXT hPbuffer);
BOOL __stdcall wglQueryPbufferEXT (HPBUFFEREXT hPbuffer, int iAttribute, int *piValue);
]]
end
end  -- WGL_EXT_pbuffer */


if not WGL_EXT_pixel_format then
WGL_EXT_pixel_format = 1

ffi.cdef[[
static const int WGL_NUMBER_PIXEL_FORMATS_EXT      = 0x2000;
static const int WGL_DRAW_TO_WINDOW_EXT            = 0x2001;
static const int WGL_DRAW_TO_BITMAP_EXT            = 0x2002;
static const int WGL_ACCELERATION_EXT              = 0x2003;
static const int WGL_NEED_PALETTE_EXT              = 0x2004;
static const int WGL_NEED_SYSTEM_PALETTE_EXT       = 0x2005;
static const int WGL_SWAP_LAYER_BUFFERS_EXT        = 0x2006;
static const int WGL_SWAP_METHOD_EXT               = 0x2007;
static const int WGL_NUMBER_OVERLAYS_EXT           = 0x2008;
static const int WGL_NUMBER_UNDERLAYS_EXT          = 0x2009;
static const int WGL_TRANSPARENT_EXT               = 0x200A;
static const int WGL_TRANSPARENT_VALUE_EXT         = 0x200B;
static const int WGL_SHARE_DEPTH_EXT               = 0x200C;
static const int WGL_SHARE_STENCIL_EXT             = 0x200D;
static const int WGL_SHARE_ACCUM_EXT               = 0x200E;
static const int WGL_SUPPORT_GDI_EXT               = 0x200F;
static const int WGL_SUPPORT_OPENGL_EXT            = 0x2010;
static const int WGL_DOUBLE_BUFFER_EXT             = 0x2011;
static const int WGL_STEREO_EXT                    = 0x2012;
static const int WGL_PIXEL_TYPE_EXT                = 0x2013;
static const int WGL_COLOR_BITS_EXT                = 0x2014;
static const int WGL_RED_BITS_EXT                  = 0x2015;
static const int WGL_RED_SHIFT_EXT                 = 0x2016;
static const int WGL_GREEN_BITS_EXT                = 0x2017;
static const int WGL_GREEN_SHIFT_EXT               = 0x2018;
static const int WGL_BLUE_BITS_EXT                 = 0x2019;
static const int WGL_BLUE_SHIFT_EXT                = 0x201A;
static const int WGL_ALPHA_BITS_EXT                = 0x201B;
static const int WGL_ALPHA_SHIFT_EXT               = 0x201C;
static const int WGL_ACCUM_BITS_EXT                = 0x201D;
static const int WGL_ACCUM_RED_BITS_EXT            = 0x201E;
static const int WGL_ACCUM_GREEN_BITS_EXT          = 0x201F;
static const int WGL_ACCUM_BLUE_BITS_EXT           = 0x2020;
static const int WGL_ACCUM_ALPHA_BITS_EXT          = 0x2021;
static const int WGL_DEPTH_BITS_EXT                = 0x2022;
static const int WGL_STENCIL_BITS_EXT              = 0x2023;
static const int WGL_AUX_BUFFERS_EXT               = 0x2024;
static const int WGL_NO_ACCELERATION_EXT           = 0x2025;
static const int WGL_GENERIC_ACCELERATION_EXT      = 0x2026;
static const int WGL_FULL_ACCELERATION_EXT         = 0x2027;
static const int WGL_SWAP_EXCHANGE_EXT             = 0x2028;
static const int WGL_SWAP_COPY_EXT                 = 0x2029;
static const int WGL_SWAP_UNDEFINED_EXT            = 0x202A;
static const int WGL_TYPE_RGBA_EXT                 = 0x202B;
static const int WGL_TYPE_COLORINDEX_EXT           = 0x202C;
]]

ffi.cdef[[
typedef BOOL (__stdcall * PFNWGLGETPIXELFORMATATTRIBIVEXTPROC) (HDC hdc, int iPixelFormat, int iLayerPlane, UINT nAttributes, int *piAttributes, int *piValues);
typedef BOOL (__stdcall * PFNWGLGETPIXELFORMATATTRIBFVEXTPROC) (HDC hdc, int iPixelFormat, int iLayerPlane, UINT nAttributes, int *piAttributes, FLOAT *pfValues);
typedef BOOL (__stdcall * PFNWGLCHOOSEPIXELFORMATEXTPROC) (HDC hdc, const int *piAttribIList, const FLOAT *pfAttribFList, UINT nMaxFormats, int *piFormats, UINT *nNumFormats);
]]

if WGL_WGLEXT_PROTOTYPES then
ffi.cdef[[
BOOL __stdcall wglGetPixelFormatAttribivEXT (HDC hdc, int iPixelFormat, int iLayerPlane, UINT nAttributes, int *piAttributes, int *piValues);
BOOL __stdcall wglGetPixelFormatAttribfvEXT (HDC hdc, int iPixelFormat, int iLayerPlane, UINT nAttributes, int *piAttributes, FLOAT *pfValues);
BOOL __stdcall wglChoosePixelFormatEXT (HDC hdc, const int *piAttribIList, const FLOAT *pfAttribFList, UINT nMaxFormats, int *piFormats, UINT *nNumFormats);
]]
end
end --/* WGL_EXT_pixel_format */

--[=[
if not WGL_EXT_pixel_format_packed_float
#define WGL_EXT_pixel_format_packed_float 1
#define WGL_TYPE_RGBA_UNSIGNED_FLOAT_EXT  0x20A8
end  -- WGL_EXT_pixel_format_packed_float */

if not WGL_EXT_swap_control
#define WGL_EXT_swap_control 1
typedef BOOL (__stdcall * PFNWGLSWAPINTERVALEXTPROC) (int interval);
typedef int (__stdcall * PFNWGLGETSWAPINTERVALEXTPROC) (void);
if WGL_WGLEXT_PROTOTYPES
BOOL __stdcall wglSwapIntervalEXT (int interval);
int __stdcall wglGetSwapIntervalEXT (void);
end
end  -- WGL_EXT_swap_control */

if not WGL_EXT_swap_control_tear
#define WGL_EXT_swap_control_tear 1
end  -- WGL_EXT_swap_control_tear */

if not WGL_I3D_digital_video_control
#define WGL_I3D_digital_video_control 1
#define WGL_DIGITAL_VIDEO_CURSOR_ALPHA_FRAMEBUFFER_I3D 0x2050
#define WGL_DIGITAL_VIDEO_CURSOR_ALPHA_VALUE_I3D 0x2051
#define WGL_DIGITAL_VIDEO_CURSOR_INCLUDED_I3D 0x2052
#define WGL_DIGITAL_VIDEO_GAMMA_CORRECTED_I3D 0x2053
typedef BOOL (__stdcall * PFNWGLGETDIGITALVIDEOPARAMETERSI3DPROC) (HDC hDC, int iAttribute, int *piValue);
typedef BOOL (__stdcall * PFNWGLSETDIGITALVIDEOPARAMETERSI3DPROC) (HDC hDC, int iAttribute, const int *piValue);
if WGL_WGLEXT_PROTOTYPES
BOOL __stdcall wglGetDigitalVideoParametersI3D (HDC hDC, int iAttribute, int *piValue);
BOOL __stdcall wglSetDigitalVideoParametersI3D (HDC hDC, int iAttribute, const int *piValue);
end
end  -- WGL_I3D_digital_video_control */

if not WGL_I3D_gamma
#define WGL_I3D_gamma 1
#define WGL_GAMMA_TABLE_SIZE_I3D          0x204E
#define WGL_GAMMA_EXCLUDE_DESKTOP_I3D     0x204F
typedef BOOL (__stdcall * PFNWGLGETGAMMATABLEPARAMETERSI3DPROC) (HDC hDC, int iAttribute, int *piValue);
typedef BOOL (__stdcall * PFNWGLSETGAMMATABLEPARAMETERSI3DPROC) (HDC hDC, int iAttribute, const int *piValue);
typedef BOOL (__stdcall * PFNWGLGETGAMMATABLEI3DPROC) (HDC hDC, int iEntries, USHORT *puRed, USHORT *puGreen, USHORT *puBlue);
typedef BOOL (__stdcall * PFNWGLSETGAMMATABLEI3DPROC) (HDC hDC, int iEntries, const USHORT *puRed, const USHORT *puGreen, const USHORT *puBlue);
if WGL_WGLEXT_PROTOTYPES
BOOL __stdcall wglGetGammaTableParametersI3D (HDC hDC, int iAttribute, int *piValue);
BOOL __stdcall wglSetGammaTableParametersI3D (HDC hDC, int iAttribute, const int *piValue);
BOOL __stdcall wglGetGammaTableI3D (HDC hDC, int iEntries, USHORT *puRed, USHORT *puGreen, USHORT *puBlue);
BOOL __stdcall wglSetGammaTableI3D (HDC hDC, int iEntries, const USHORT *puRed, const USHORT *puGreen, const USHORT *puBlue);
end
end  -- WGL_I3D_gamma */
--]=]

if not WGL_I3D_genlock then
WGL_I3D_genlock = 1

ffi.cdef[[
static const int WGL_GENLOCK_SOURCE_MULTIVIEW_I3D  = 0x2044;
static const int WGL_GENLOCK_SOURCE_EXTERNAL_SYNC_I3D = 0x2045;
static const int WGL_GENLOCK_SOURCE_EXTERNAL_FIELD_I3D = 0x2046;
static const int WGL_GENLOCK_SOURCE_EXTERNAL_TTL_I3D = 0x2047;
static const int WGL_GENLOCK_SOURCE_DIGITAL_SYNC_I3D = 0x2048;
static const int WGL_GENLOCK_SOURCE_DIGITAL_FIELD_I3D = 0x2049;
static const int WGL_GENLOCK_SOURCE_EDGE_FALLING_I3D = 0x204A;
static const int WGL_GENLOCK_SOURCE_EDGE_RISING_I3D = 0x204B;
static const int WGL_GENLOCK_SOURCE_EDGE_BOTH_I3D  = 0x204C;
]]

ffi.cdef[[
typedef BOOL (__stdcall * PFNWGLENABLEGENLOCKI3DPROC) (HDC hDC);
typedef BOOL (__stdcall * PFNWGLDISABLEGENLOCKI3DPROC) (HDC hDC);
typedef BOOL (__stdcall * PFNWGLISENABLEDGENLOCKI3DPROC) (HDC hDC, BOOL *pFlag);
typedef BOOL (__stdcall * PFNWGLGENLOCKSOURCEI3DPROC) (HDC hDC, UINT uSource);
typedef BOOL (__stdcall * PFNWGLGETGENLOCKSOURCEI3DPROC) (HDC hDC, UINT *uSource);
typedef BOOL (__stdcall * PFNWGLGENLOCKSOURCEEDGEI3DPROC) (HDC hDC, UINT uEdge);
typedef BOOL (__stdcall * PFNWGLGETGENLOCKSOURCEEDGEI3DPROC) (HDC hDC, UINT *uEdge);
typedef BOOL (__stdcall * PFNWGLGENLOCKSAMPLERATEI3DPROC) (HDC hDC, UINT uRate);
typedef BOOL (__stdcall * PFNWGLGETGENLOCKSAMPLERATEI3DPROC) (HDC hDC, UINT *uRate);
typedef BOOL (__stdcall * PFNWGLGENLOCKSOURCEDELAYI3DPROC) (HDC hDC, UINT uDelay);
typedef BOOL (__stdcall * PFNWGLGETGENLOCKSOURCEDELAYI3DPROC) (HDC hDC, UINT *uDelay);
typedef BOOL (__stdcall * PFNWGLQUERYGENLOCKMAXSOURCEDELAYI3DPROC) (HDC hDC, UINT *uMaxLineDelay, UINT *uMaxPixelDelay);
]]

if WGL_WGLEXT_PROTOTYPES then
ffi.cdef[[
BOOL __stdcall wglEnableGenlockI3D (HDC hDC);
BOOL __stdcall wglDisableGenlockI3D (HDC hDC);
BOOL __stdcall wglIsEnabledGenlockI3D (HDC hDC, BOOL *pFlag);
BOOL __stdcall wglGenlockSourceI3D (HDC hDC, UINT uSource);
BOOL __stdcall wglGetGenlockSourceI3D (HDC hDC, UINT *uSource);
BOOL __stdcall wglGenlockSourceEdgeI3D (HDC hDC, UINT uEdge);
BOOL __stdcall wglGetGenlockSourceEdgeI3D (HDC hDC, UINT *uEdge);
BOOL __stdcall wglGenlockSampleRateI3D (HDC hDC, UINT uRate);
BOOL __stdcall wglGetGenlockSampleRateI3D (HDC hDC, UINT *uRate);
BOOL __stdcall wglGenlockSourceDelayI3D (HDC hDC, UINT uDelay);
BOOL __stdcall wglGetGenlockSourceDelayI3D (HDC hDC, UINT *uDelay);
BOOL __stdcall wglQueryGenlockMaxSourceDelayI3D (HDC hDC, UINT *uMaxLineDelay, UINT *uMaxPixelDelay);
]]
end
end  -- WGL_I3D_genlock */

--[=[
if not WGL_I3D_image_buffer
#define WGL_I3D_image_buffer 1
#define WGL_IMAGE_BUFFER_MIN_ACCESS_I3D   0x00000001
#define WGL_IMAGE_BUFFER_LOCK_I3D         0x00000002
typedef LPVOID (__stdcall * PFNWGLCREATEIMAGEBUFFERI3DPROC) (HDC hDC, DWORD dwSize, UINT uFlags);
typedef BOOL (__stdcall * PFNWGLDESTROYIMAGEBUFFERI3DPROC) (HDC hDC, LPVOID pAddress);
typedef BOOL (__stdcall * PFNWGLASSOCIATEIMAGEBUFFEREVENTSI3DPROC) (HDC hDC, const HANDLE *pEvent, const LPVOID *pAddress, const DWORD *pSize, UINT count);
typedef BOOL (__stdcall * PFNWGLRELEASEIMAGEBUFFEREVENTSI3DPROC) (HDC hDC, const LPVOID *pAddress, UINT count);
if WGL_WGLEXT_PROTOTYPES
LPVOID __stdcall wglCreateImageBufferI3D (HDC hDC, DWORD dwSize, UINT uFlags);
BOOL __stdcall wglDestroyImageBufferI3D (HDC hDC, LPVOID pAddress);
BOOL __stdcall wglAssociateImageBufferEventsI3D (HDC hDC, const HANDLE *pEvent, const LPVOID *pAddress, const DWORD *pSize, UINT count);
BOOL __stdcall wglReleaseImageBufferEventsI3D (HDC hDC, const LPVOID *pAddress, UINT count);
end
end  -- WGL_I3D_image_buffer */

if not WGL_I3D_swap_frame_lock
#define WGL_I3D_swap_frame_lock 1
typedef BOOL (__stdcall * PFNWGLENABLEFRAMELOCKI3DPROC) (void);
typedef BOOL (__stdcall * PFNWGLDISABLEFRAMELOCKI3DPROC) (void);
typedef BOOL (__stdcall * PFNWGLISENABLEDFRAMELOCKI3DPROC) (BOOL *pFlag);
typedef BOOL (__stdcall * PFNWGLQUERYFRAMELOCKMASTERI3DPROC) (BOOL *pFlag);
if WGL_WGLEXT_PROTOTYPES
BOOL __stdcall wglEnableFrameLockI3D (void);
BOOL __stdcall wglDisableFrameLockI3D (void);
BOOL __stdcall wglIsEnabledFrameLockI3D (BOOL *pFlag);
BOOL __stdcall wglQueryFrameLockMasterI3D (BOOL *pFlag);
end
end  -- WGL_I3D_swap_frame_lock */

if not WGL_I3D_swap_frame_usage
#define WGL_I3D_swap_frame_usage 1
typedef BOOL (__stdcall * PFNWGLGETFRAMEUSAGEI3DPROC) (float *pUsage);
typedef BOOL (__stdcall * PFNWGLBEGINFRAMETRACKINGI3DPROC) (void);
typedef BOOL (__stdcall * PFNWGLENDFRAMETRACKINGI3DPROC) (void);
typedef BOOL (__stdcall * PFNWGLQUERYFRAMETRACKINGI3DPROC) (DWORD *pFrameCount, DWORD *pMissedFrames, float *pLastMissedUsage);
if WGL_WGLEXT_PROTOTYPES
BOOL __stdcall wglGetFrameUsageI3D (float *pUsage);
BOOL __stdcall wglBeginFrameTrackingI3D (void);
BOOL __stdcall wglEndFrameTrackingI3D (void);
BOOL __stdcall wglQueryFrameTrackingI3D (DWORD *pFrameCount, DWORD *pMissedFrames, float *pLastMissedUsage);
end
end  -- WGL_I3D_swap_frame_usage */

if not WGL_NV_DX_interop
#define WGL_NV_DX_interop 1
#define WGL_ACCESS_READ_ONLY_NV           0x00000000
#define WGL_ACCESS_READ_WRITE_NV          0x00000001
#define WGL_ACCESS_WRITE_DISCARD_NV       0x00000002
typedef BOOL (__stdcall * PFNWGLDXSETRESOURCESHAREHANDLENVPROC) (void *dxObject, HANDLE shareHandle);
typedef HANDLE (__stdcall * PFNWGLDXOPENDEVICENVPROC) (void *dxDevice);
typedef BOOL (__stdcall * PFNWGLDXCLOSEDEVICENVPROC) (HANDLE hDevice);
typedef HANDLE (__stdcall * PFNWGLDXREGISTEROBJECTNVPROC) (HANDLE hDevice, void *dxObject, GLuint name, GLenum type, GLenum access);
typedef BOOL (__stdcall * PFNWGLDXUNREGISTEROBJECTNVPROC) (HANDLE hDevice, HANDLE hObject);
typedef BOOL (__stdcall * PFNWGLDXOBJECTACCESSNVPROC) (HANDLE hObject, GLenum access);
typedef BOOL (__stdcall * PFNWGLDXLOCKOBJECTSNVPROC) (HANDLE hDevice, GLint count, HANDLE *hObjects);
typedef BOOL (__stdcall * PFNWGLDXUNLOCKOBJECTSNVPROC) (HANDLE hDevice, GLint count, HANDLE *hObjects);
if WGL_WGLEXT_PROTOTYPES
BOOL __stdcall wglDXSetResourceShareHandleNV (void *dxObject, HANDLE shareHandle);
HANDLE __stdcall wglDXOpenDeviceNV (void *dxDevice);
BOOL __stdcall wglDXCloseDeviceNV (HANDLE hDevice);
HANDLE __stdcall wglDXRegisterObjectNV (HANDLE hDevice, void *dxObject, GLuint name, GLenum type, GLenum access);
BOOL __stdcall wglDXUnregisterObjectNV (HANDLE hDevice, HANDLE hObject);
BOOL __stdcall wglDXObjectAccessNV (HANDLE hObject, GLenum access);
BOOL __stdcall wglDXLockObjectsNV (HANDLE hDevice, GLint count, HANDLE *hObjects);
BOOL __stdcall wglDXUnlockObjectsNV (HANDLE hDevice, GLint count, HANDLE *hObjects);
end
end  -- WGL_NV_DX_interop */

if not WGL_NV_DX_interop2
#define WGL_NV_DX_interop2 1
end  -- WGL_NV_DX_interop2 */

if not WGL_NV_copy_image
#define WGL_NV_copy_image 1
typedef BOOL (__stdcall * PFNWGLCOPYIMAGESUBDATANVPROC) (HGLRC hSrcRC, GLuint srcName, GLenum srcTarget, GLint srcLevel, GLint srcX, GLint srcY, GLint srcZ, HGLRC hDstRC, GLuint dstName, GLenum dstTarget, GLint dstLevel, GLint dstX, GLint dstY, GLint dstZ, GLsizei width, GLsizei height, GLsizei depth);
if WGL_WGLEXT_PROTOTYPES
BOOL __stdcall wglCopyImageSubDataNV (HGLRC hSrcRC, GLuint srcName, GLenum srcTarget, GLint srcLevel, GLint srcX, GLint srcY, GLint srcZ, HGLRC hDstRC, GLuint dstName, GLenum dstTarget, GLint dstLevel, GLint dstX, GLint dstY, GLint dstZ, GLsizei width, GLsizei height, GLsizei depth);
end
end  -- WGL_NV_copy_image */

if not WGL_NV_delay_before_swap
#define WGL_NV_delay_before_swap 1
typedef BOOL (__stdcall * PFNWGLDELAYBEFORESWAPNVPROC) (HDC hDC, GLfloat seconds);
if WGL_WGLEXT_PROTOTYPES
BOOL __stdcall wglDelayBeforeSwapNV (HDC hDC, GLfloat seconds);
end
end  -- WGL_NV_delay_before_swap */

if not WGL_NV_float_buffer
#define WGL_NV_float_buffer 1
#define WGL_FLOAT_COMPONENTS_NV           0x20B0
#define WGL_BIND_TO_TEXTURE_RECTANGLE_FLOAT_R_NV 0x20B1
#define WGL_BIND_TO_TEXTURE_RECTANGLE_FLOAT_RG_NV 0x20B2
#define WGL_BIND_TO_TEXTURE_RECTANGLE_FLOAT_RGB_NV 0x20B3
#define WGL_BIND_TO_TEXTURE_RECTANGLE_FLOAT_RGBA_NV 0x20B4
#define WGL_TEXTURE_FLOAT_R_NV            0x20B5
#define WGL_TEXTURE_FLOAT_RG_NV           0x20B6
#define WGL_TEXTURE_FLOAT_RGB_NV          0x20B7
#define WGL_TEXTURE_FLOAT_RGBA_NV         0x20B8
end  -- WGL_NV_float_buffer */

if not WGL_NV_gpu_affinity
#define WGL_NV_gpu_affinity 1
DECLARE_HANDLE("HGPUNV");
struct _GPU_DEVICE {
    DWORD  cb;
    CHAR   DeviceName[32];
    CHAR   DeviceString[128];
    DWORD  Flags;
    RECT   rcVirtualScreen;
};
typedef struct _GPU_DEVICE *PGPU_DEVICE;
#define ERROR_INCOMPATIBLE_AFFINITY_MASKS_NV 0x20D0
#define ERROR_MISSING_AFFINITY_MASK_NV    0x20D1
typedef BOOL (__stdcall * PFNWGLENUMGPUSNVPROC) (UINT iGpuIndex, HGPUNV *phGpu);
typedef BOOL (__stdcall * PFNWGLENUMGPUDEVICESNVPROC) (HGPUNV hGpu, UINT iDeviceIndex, PGPU_DEVICE lpGpuDevice);
typedef HDC (__stdcall * PFNWGLCREATEAFFINITYDCNVPROC) (const HGPUNV *phGpuList);
typedef BOOL (__stdcall * PFNWGLENUMGPUSFROMAFFINITYDCNVPROC) (HDC hAffinityDC, UINT iGpuIndex, HGPUNV *hGpu);
typedef BOOL (__stdcall * PFNWGLDELETEDCNVPROC) (HDC hdc);
if WGL_WGLEXT_PROTOTYPES
BOOL __stdcall wglEnumGpusNV (UINT iGpuIndex, HGPUNV *phGpu);
BOOL __stdcall wglEnumGpuDevicesNV (HGPUNV hGpu, UINT iDeviceIndex, PGPU_DEVICE lpGpuDevice);
HDC __stdcall wglCreateAffinityDCNV (const HGPUNV *phGpuList);
BOOL __stdcall wglEnumGpusFromAffinityDCNV (HDC hAffinityDC, UINT iGpuIndex, HGPUNV *hGpu);
BOOL __stdcall wglDeleteDCNV (HDC hdc);
end
end  -- WGL_NV_gpu_affinity */

if not WGL_NV_multisample_coverage
#define WGL_NV_multisample_coverage 1
#define WGL_COVERAGE_SAMPLES_NV           0x2042
#define WGL_COLOR_SAMPLES_NV              0x20B9
end  -- WGL_NV_multisample_coverage */

if not WGL_NV_present_video
#define WGL_NV_present_video 1
DECLARE_HANDLE("HVIDEOOUTPUTDEVICENV");
#define WGL_NUM_VIDEO_SLOTS_NV            0x20F0
typedef int (__stdcall * PFNWGLENUMERATEVIDEODEVICESNVPROC) (HDC hDc, HVIDEOOUTPUTDEVICENV *phDeviceList);
typedef BOOL (__stdcall * PFNWGLBINDVIDEODEVICENVPROC) (HDC hDc, unsigned int uVideoSlot, HVIDEOOUTPUTDEVICENV hVideoDevice, const int *piAttribList);
typedef BOOL (__stdcall * PFNWGLQUERYCURRENTCONTEXTNVPROC) (int iAttribute, int *piValue);
if WGL_WGLEXT_PROTOTYPES
int __stdcall wglEnumerateVideoDevicesNV (HDC hDc, HVIDEOOUTPUTDEVICENV *phDeviceList);
BOOL __stdcall wglBindVideoDeviceNV (HDC hDc, unsigned int uVideoSlot, HVIDEOOUTPUTDEVICENV hVideoDevice, const int *piAttribList);
BOOL __stdcall wglQueryCurrentContextNV (int iAttribute, int *piValue);
end
end  -- WGL_NV_present_video */

if not WGL_NV_render_depth_texture
#define WGL_NV_render_depth_texture 1
#define WGL_BIND_TO_TEXTURE_DEPTH_NV      0x20A3
#define WGL_BIND_TO_TEXTURE_RECTANGLE_DEPTH_NV 0x20A4
#define WGL_DEPTH_TEXTURE_FORMAT_NV       0x20A5
#define WGL_TEXTURE_DEPTH_COMPONENT_NV    0x20A6
#define WGL_DEPTH_COMPONENT_NV            0x20A7
end  -- WGL_NV_render_depth_texture */

if not WGL_NV_render_texture_rectangle
#define WGL_NV_render_texture_rectangle 1
#define WGL_BIND_TO_TEXTURE_RECTANGLE_RGB_NV 0x20A0
#define WGL_BIND_TO_TEXTURE_RECTANGLE_RGBA_NV 0x20A1
#define WGL_TEXTURE_RECTANGLE_NV          0x20A2
end  -- WGL_NV_render_texture_rectangle */

if not WGL_NV_swap_group
#define WGL_NV_swap_group 1
typedef BOOL (__stdcall * PFNWGLJOINSWAPGROUPNVPROC) (HDC hDC, GLuint group);
typedef BOOL (__stdcall * PFNWGLBINDSWAPBARRIERNVPROC) (GLuint group, GLuint barrier);
typedef BOOL (__stdcall * PFNWGLQUERYSWAPGROUPNVPROC) (HDC hDC, GLuint *group, GLuint *barrier);
typedef BOOL (__stdcall * PFNWGLQUERYMAXSWAPGROUPSNVPROC) (HDC hDC, GLuint *maxGroups, GLuint *maxBarriers);
typedef BOOL (__stdcall * PFNWGLQUERYFRAMECOUNTNVPROC) (HDC hDC, GLuint *count);
typedef BOOL (__stdcall * PFNWGLRESETFRAMECOUNTNVPROC) (HDC hDC);
if WGL_WGLEXT_PROTOTYPES
BOOL __stdcall wglJoinSwapGroupNV (HDC hDC, GLuint group);
BOOL __stdcall wglBindSwapBarrierNV (GLuint group, GLuint barrier);
BOOL __stdcall wglQuerySwapGroupNV (HDC hDC, GLuint *group, GLuint *barrier);
BOOL __stdcall wglQueryMaxSwapGroupsNV (HDC hDC, GLuint *maxGroups, GLuint *maxBarriers);
BOOL __stdcall wglQueryFrameCountNV (HDC hDC, GLuint *count);
BOOL __stdcall wglResetFrameCountNV (HDC hDC);
end
end  -- WGL_NV_swap_group */

if not WGL_NV_vertex_array_range
#define WGL_NV_vertex_array_range 1
typedef void *(__stdcall * PFNWGLALLOCATEMEMORYNVPROC) (GLsizei size, GLfloat readfreq, GLfloat writefreq, GLfloat priority);
typedef void (__stdcall * PFNWGLFREEMEMORYNVPROC) (void *pointer);
if WGL_WGLEXT_PROTOTYPES
void *__stdcall wglAllocateMemoryNV (GLsizei size, GLfloat readfreq, GLfloat writefreq, GLfloat priority);
void __stdcall wglFreeMemoryNV (void *pointer);
end
end  -- WGL_NV_vertex_array_range */
--]=]

if not WGL_NV_video_capture then
WGL_NV_video_capture = 1
DECLARE_HANDLE("HVIDEOINPUTDEVICENV");

ffi.cdef[[
static const int WGL_UNIQUE_ID_NV                =  0x20CE;
static const int WGL_NUM_VIDEO_CAPTURE_SLOTS_NV  =  0x20CF;

typedef BOOL (__stdcall * PFNWGLBINDVIDEOCAPTUREDEVICENVPROC) (UINT uVideoSlot, HVIDEOINPUTDEVICENV hDevice);
typedef UINT (__stdcall * PFNWGLENUMERATEVIDEOCAPTUREDEVICESNVPROC) (HDC hDc, HVIDEOINPUTDEVICENV *phDeviceList);
typedef BOOL (__stdcall * PFNWGLLOCKVIDEOCAPTUREDEVICENVPROC) (HDC hDc, HVIDEOINPUTDEVICENV hDevice);
typedef BOOL (__stdcall * PFNWGLQUERYVIDEOCAPTUREDEVICENVPROC) (HDC hDc, HVIDEOINPUTDEVICENV hDevice, int iAttribute, int *piValue);
typedef BOOL (__stdcall * PFNWGLRELEASEVIDEOCAPTUREDEVICENVPROC) (HDC hDc, HVIDEOINPUTDEVICENV hDevice);
]]

if WGL_WGLEXT_PROTOTYPES then
ffi.cdef[[
BOOL __stdcall wglBindVideoCaptureDeviceNV (UINT uVideoSlot, HVIDEOINPUTDEVICENV hDevice);
UINT __stdcall wglEnumerateVideoCaptureDevicesNV (HDC hDc, HVIDEOINPUTDEVICENV *phDeviceList);
BOOL __stdcall wglLockVideoCaptureDeviceNV (HDC hDc, HVIDEOINPUTDEVICENV hDevice);
BOOL __stdcall wglQueryVideoCaptureDeviceNV (HDC hDc, HVIDEOINPUTDEVICENV hDevice, int iAttribute, int *piValue);
BOOL __stdcall wglReleaseVideoCaptureDeviceNV (HDC hDc, HVIDEOINPUTDEVICENV hDevice);
]]
end
end --/* WGL_NV_video_capture */

if not WGL_NV_video_output then
WGL_NV_video_output = 1
DECLARE_HANDLE("HPVIDEODEV");

ffi.cdef[[
static const int WGL_BIND_TO_VIDEO_RGB_NV         = 0x20C0;
static const int WGL_BIND_TO_VIDEO_RGBA_NV        = 0x20C1;
static const int WGL_BIND_TO_VIDEO_RGB_AND_DEPTH_NV = 0x20C2;
static const int WGL_VIDEO_OUT_COLOR_NV           = 0x20C3;
static const int WGL_VIDEO_OUT_ALPHA_NV           = 0x20C4;
static const int WGL_VIDEO_OUT_DEPTH_NV           = 0x20C5;
static const int WGL_VIDEO_OUT_COLOR_AND_ALPHA_NV = 0x20C6;
static const int WGL_VIDEO_OUT_COLOR_AND_DEPTH_NV = 0x20C7;
static const int WGL_VIDEO_OUT_FRAME              = 0x20C8;
static const int WGL_VIDEO_OUT_FIELD_1            = 0x20C9;
static const int WGL_VIDEO_OUT_FIELD_2            = 0x20CA;
static const int WGL_VIDEO_OUT_STACKED_FIELDS_1_2 = 0x20CB;
static const int WGL_VIDEO_OUT_STACKED_FIELDS_2_1 = 0x20CC;
]]

ffi.cdef[[
typedef BOOL (__stdcall * PFNWGLGETVIDEODEVICENVPROC) (HDC hDC, int numDevices, HPVIDEODEV *hVideoDevice);
typedef BOOL (__stdcall * PFNWGLRELEASEVIDEODEVICENVPROC) (HPVIDEODEV hVideoDevice);
typedef BOOL (__stdcall * PFNWGLBINDVIDEOIMAGENVPROC) (HPVIDEODEV hVideoDevice, HPBUFFERARB hPbuffer, int iVideoBuffer);
typedef BOOL (__stdcall * PFNWGLRELEASEVIDEOIMAGENVPROC) (HPBUFFERARB hPbuffer, int iVideoBuffer);
typedef BOOL (__stdcall * PFNWGLSENDPBUFFERTOVIDEONVPROC) (HPBUFFERARB hPbuffer, int iBufferType, unsigned long *pulCounterPbuffer, BOOL bBlock);
typedef BOOL (__stdcall * PFNWGLGETVIDEOINFONVPROC) (HPVIDEODEV hpVideoDevice, unsigned long *pulCounterOutputPbuffer, unsigned long *pulCounterOutputVideo);
]]

if WGL_WGLEXT_PROTOTYPES then
ffi.cdef[[
BOOL __stdcall wglGetVideoDeviceNV (HDC hDC, int numDevices, HPVIDEODEV *hVideoDevice);
BOOL __stdcall wglReleaseVideoDeviceNV (HPVIDEODEV hVideoDevice);
BOOL __stdcall wglBindVideoImageNV (HPVIDEODEV hVideoDevice, HPBUFFERARB hPbuffer, int iVideoBuffer);
BOOL __stdcall wglReleaseVideoImageNV (HPBUFFERARB hPbuffer, int iVideoBuffer);
BOOL __stdcall wglSendPbufferToVideoNV (HPBUFFERARB hPbuffer, int iBufferType, unsigned long *pulCounterPbuffer, BOOL bBlock);
BOOL __stdcall wglGetVideoInfoNV (HPVIDEODEV hpVideoDevice, unsigned long *pulCounterOutputPbuffer, unsigned long *pulCounterOutputVideo);
]]
end
end --/* WGL_NV_video_output */

if not WGL_OML_sync_control then
WGL_OML_sync_control = 1
ffi.cdef[[
typedef BOOL (__stdcall * PFNWGLGETSYNCVALUESOMLPROC) (HDC hdc, INT64 *ust, INT64 *msc, INT64 *sbc);
typedef BOOL (__stdcall * PFNWGLGETMSCRATEOMLPROC) (HDC hdc, INT32 *numerator, INT32 *denominator);
typedef INT64 (__stdcall * PFNWGLSWAPBUFFERSMSCOMLPROC) (HDC hdc, INT64 target_msc, INT64 divisor, INT64 remainder);
typedef INT64 (__stdcall * PFNWGLSWAPLAYERBUFFERSMSCOMLPROC) (HDC hdc, INT fuPlanes, INT64 target_msc, INT64 divisor, INT64 remainder);
typedef BOOL (__stdcall * PFNWGLWAITFORMSCOMLPROC) (HDC hdc, INT64 target_msc, INT64 divisor, INT64 remainder, INT64 *ust, INT64 *msc, INT64 *sbc);
typedef BOOL (__stdcall * PFNWGLWAITFORSBCOMLPROC) (HDC hdc, INT64 target_sbc, INT64 *ust, INT64 *msc, INT64 *sbc);
]]

if WGL_WGLEXT_PROTOTYPES then
ffi.cdef[[
BOOL __stdcall wglGetSyncValuesOML (HDC hdc, INT64 *ust, INT64 *msc, INT64 *sbc);
BOOL __stdcall wglGetMscRateOML (HDC hdc, INT32 *numerator, INT32 *denominator);
INT64 __stdcall wglSwapBuffersMscOML (HDC hdc, INT64 target_msc, INT64 divisor, INT64 remainder);
INT64 __stdcall wglSwapLayerBuffersMscOML (HDC hdc, INT fuPlanes, INT64 target_msc, INT64 divisor, INT64 remainder);
BOOL __stdcall wglWaitForMscOML (HDC hdc, INT64 target_msc, INT64 divisor, INT64 remainder, INT64 *ust, INT64 *msc, INT64 *sbc);
BOOL __stdcall wglWaitForSbcOML (HDC hdc, INT64 target_sbc, INT64 *ust, INT64 *msc, INT64 *sbc);
]]
end
end --/* WGL_OML_sync_control */



end
