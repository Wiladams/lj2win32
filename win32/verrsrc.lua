local ffi = require("ffi")

require("win32.winapifamily")

--[[
/*****************************************************************************\
*                                                                             *
* verrsrc.h -   Version Resource definitions                                  *
*                                                                             *
*               Include file declaring version resources in rc files          *
*                                                                             *
*               Copyright (c) Microsoft Corporation. All rights reserved.     *
*                                                                             *
\*****************************************************************************/
--]]

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
static const int RT_VERSION   = 16;   // MAKEINTRESOURCE(16), from WinUser
]]

ffi.cdef[[
/* ----- Symbols ----- */
static const int VS_FILE_INFO         =   RT_VERSION;
static const int VS_VERSION_INFO        = 1;
static const int VS_USER_DEFINED        = 100;

/* ----- VS_VERSION.dwFileFlags ----- */
static const int VS_FFI_SIGNATURE        = 0xFEEF04BDL;

static const int VS_FFI_STRUCVERSION     = 0x00010000L;
static const int VS_FFI_FILEFLAGSMASK    = 0x0000003FL;

/* ----- VS_VERSION.dwFileFlags ----- */
static const int VS_FF_DEBUG             = 0x00000001L;
static const int VS_FF_PRERELEASE        = 0x00000002L;
static const int VS_FF_PATCHED           = 0x00000004L;
static const int VS_FF_PRIVATEBUILD      = 0x00000008L;
static const int VS_FF_INFOINFERRED      = 0x00000010L;
static const int VS_FF_SPECIALBUILD      = 0x00000020L;

/* ----- VS_VERSION.dwFileOS ----- */
static const int VOS_UNKNOWN             = 0x00000000L;
static const int VOS_DOS                 = 0x00010000L;
static const int VOS_OS216               = 0x00020000L;
static const int VOS_OS232               = 0x00030000L;
static const int VOS_NT                  = 0x00040000L;
static const int VOS_WINCE               = 0x00050000L;

static const int VOS__BASE               = 0x00000000L;
static const int VOS__WINDOWS16          = 0x00000001L;
static const int VOS__PM16               = 0x00000002L;
static const int VOS__PM32               = 0x00000003L;
static const int VOS__WINDOWS32          = 0x00000004L;

static const int VOS_DOS_WINDOWS16       = 0x00010001L;
static const int VOS_DOS_WINDOWS32       = 0x00010004L;
static const int VOS_OS216_PM16          = 0x00020002L;
static const int VOS_OS232_PM32          = 0x00030003L;
static const int VOS_NT_WINDOWS32        = 0x00040004L;

/* ----- VS_VERSION.dwFileType ----- */
static const int VFT_UNKNOWN             = 0x00000000L;
static const int VFT_APP                 = 0x00000001L;
static const int VFT_DLL                 = 0x00000002L;
static const int VFT_DRV                 = 0x00000003L;
static const int VFT_FONT                = 0x00000004L;
static const int VFT_VXD                 = 0x00000005L;
static const int VFT_STATIC_LIB          = 0x00000007L;

/* ----- VS_VERSION.dwFileSubtype for VFT_WINDOWS_DRV ----- */
static const int VFT2_UNKNOWN            = 0x00000000L;
static const int VFT2_DRV_PRINTER        = 0x00000001L;
static const int VFT2_DRV_KEYBOARD       = 0x00000002L;
static const int VFT2_DRV_LANGUAGE       = 0x00000003L;
static const int VFT2_DRV_DISPLAY        = 0x00000004L;
static const int VFT2_DRV_MOUSE          = 0x00000005L;
static const int VFT2_DRV_NETWORK        = 0x00000006L;
static const int VFT2_DRV_SYSTEM         = 0x00000007L;
static const int VFT2_DRV_INSTALLABLE    = 0x00000008L;
static const int VFT2_DRV_SOUND          = 0x00000009L;
static const int VFT2_DRV_COMM           = 0x0000000AL;
static const int VFT2_DRV_INPUTMETHOD    = 0x0000000BL;
static const int VFT2_DRV_VERSIONED_PRINTER    = 0x0000000CL;

/* ----- VS_VERSION.dwFileSubtype for VFT_WINDOWS_FONT ----- */
static const int VFT2_FONT_RASTER        = 0x00000001L;
static const int VFT2_FONT_VECTOR        = 0x00000002L;
static const int VFT2_FONT_TRUETYPE      = 0x00000003L;
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
/* ----- VerFindFile() flags ----- */
static const int VFFF_ISSHAREDFILE       = 0x0001;

static const int VFF_CURNEDEST           = 0x0001;
static const int VFF_FILEINUSE           = 0x0002;
static const int VFF_BUFFTOOSMALL        = 0x0004;

/* ----- VerInstallFile() flags ----- */
static const int VIFF_FORCEINSTALL       = 0x0001;
static const int VIFF_DONTDELETEOLD      = 0x0002;

static const int VIF_TEMPFILE            = 0x00000001L;
static const int VIF_MISMATCH            = 0x00000002L;
static const int VIF_SRCOLD              = 0x00000004L;

static const int VIF_DIFFLANG            = 0x00000008L;
static const int VIF_DIFFCODEPG          = 0x00000010L;
static const int VIF_DIFFTYPE            = 0x00000020L;

static const int VIF_WRITEPROT           = 0x00000040L;
static const int VIF_FILEINUSE           = 0x00000080L;
static const int VIF_OUTOFSPACE          = 0x00000100L;
static const int VIF_ACCESSVIOLATION     = 0x00000200L;
static const int VIF_SHARINGVIOLATION    = 0x00000400L;
static const int VIF_CANNOTCREATE        = 0x00000800L;
static const int VIF_CANNOTDELETE        = 0x00001000L;
static const int VIF_CANNOTRENAME        = 0x00002000L;
static const int VIF_CANNOTDELETECUR     = 0x00004000L;
static const int VIF_OUTOFMEMORY         = 0x00008000L;

static const int VIF_CANNOTREADSRC       = 0x00010000L;
static const int VIF_CANNOTREADDST       = 0x00020000L;

static const int VIF_BUFFTOOSMALL        = 0x00040000L;
static const int VIF_CANNOTLOADLZ32      = 0x00080000L;
static const int VIF_CANNOTLOADCABINET   = 0x00100000L;
]]

if not RC_INVOKED  then            --/* RC doesn't need to see the rest of this */


ffi.cdef[[    
/* 
    FILE_VER_GET_... flags are for use by 
    GetFileVersionInfoSizeEx
    GetFileVersionInfoExW
*/
static const int FILE_VER_GET_LOCALISED  = 0x01;
static const int FILE_VER_GET_NEUTRAL    = 0x02;
static const int FILE_VER_GET_PREFETCHED = 0x04;
]]

ffi.cdef[[
/* ----- Types and structures ----- */

typedef struct tagVS_FIXEDFILEINFO
{
    DWORD   dwSignature;            /* e.g. = 0xfeef04bd */
    DWORD   dwStrucVersion;         /* e.g. = 0x00000042 = "0.42" */
    DWORD   dwFileVersionMS;        /* e.g. = 0x00030075 = "3.75" */
    DWORD   dwFileVersionLS;        /* e.g. = 0x00000031 = "0.31" */
    DWORD   dwProductVersionMS;     /* e.g. = 0x00030010 = "3.10" */
    DWORD   dwProductVersionLS;     /* e.g. = 0x00000031 = "0.31" */
    DWORD   dwFileFlagsMask;        /* = = 0x3F for version "0.42" */
    DWORD   dwFileFlags;            /* e.g. VFF_DEBUG | VFF_PRERELEASE */
    DWORD   dwFileOS;               /* e.g. VOS_DOS_WINDOWS16 */
    DWORD   dwFileType;             /* e.g. VFT_DRIVER */
    DWORD   dwFileSubtype;          /* e.g. VFT2_DRV_KEYBOARD */
    DWORD   dwFileDateMS;           /* e.g. 0 */
    DWORD   dwFileDateLS;           /* e.g. 0 */
} VS_FIXEDFILEINFO;
]]


end  --/* !RC_INVOKED */

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


