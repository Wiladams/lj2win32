

local ffi = require("ffi")
local bit = require("bit")
local lshift, rshift = bit.lshift, bit.rshift
local band, bor = bit.band, bit.bor
local bnot = bit.bnot;

require("win32.windef")

local exports = {}


ffi.cdef[[
/* Binary raster ops */
static const int R2_BLACK           = 1;   /*  0       */
static const int R2_NOTMERGEPEN     = 2 ;  /* DPon     */
static const int R2_MASKNOTPEN      = 3;   /* DPna     */
static const int R2_NOTCOPYPEN      = 4;   /* PN       */
static const int R2_MASKPENNOT      = 5;   /* PDna     */
static const int R2_NOT             = 6;   /* Dn       */
static const int R2_XORPEN          = 7;   /* DPx      */
static const int R2_NOTMASKPEN      = 8;   /* DPan     */
static const int R2_MASKPEN         = 9;   /* DPa      */
static const int R2_NOTXORPEN       = 10;  /* DPxn     */
static const int R2_NOP             = 11;  /* D        */
static const int R2_MERGENOTPEN     = 12;  /* DPno     */
static const int R2_COPYPEN         = 13;  /* P        */
static const int R2_MERGEPENNOT     = 14;  /* PDno     */
static const int R2_MERGEPEN        = 15;  /* DPo      */
static const int R2_WHITE           = 16;  /*  1       */
static const int R2_LAST            = 16;
]]

ffi.cdef[[
/* Ternary raster operations */
static const int SRCCOPY           =  (DWORD)0x00CC0020; /* dest = source                   */
static const int SRCPAINT          =  (DWORD)0x00EE0086; /* dest = source OR dest           */
static const int SRCAND            =  (DWORD)0x008800C6; /* dest = source AND dest          */
static const int SRCINVERT         =  (DWORD)0x00660046; /* dest = source XOR dest          */
static const int SRCERASE          =  (DWORD)0x00440328; /* dest = source AND (NOT dest )   */
static const int NOTSRCCOPY        =  (DWORD)0x00330008; /* dest = (NOT source)             */
static const int NOTSRCERASE       =  (DWORD)0x001100A6; /* dest = (NOT src) AND (NOT dest) */
static const int MERGECOPY         =  (DWORD)0x00C000CA; /* dest = (source AND pattern)     */
static const int MERGEPAINT        =  (DWORD)0x00BB0226; /* dest = (NOT source) OR dest     */
static const int PATCOPY           =  (DWORD)0x00F00021; /* dest = pattern                  */
static const int PATPAINT          =  (DWORD)0x00FB0A09; /* dest = DPSnoo                   */
static const int PATINVERT         =  (DWORD)0x005A0049; /* dest = pattern XOR dest         */
static const int DSTINVERT         =  (DWORD)0x00550009; /* dest = (NOT dest)               */
static const int BLACKNESS         =  (DWORD)0x00000042; /* dest = BLACK                    */
static const int WHITENESS         =  (DWORD)0x00FF0062; /* dest = WHITE                    */
]]

--[[
#if(WINVER >= 0x0500)

#define NOMIRRORBITMAP               (DWORD)0x80000000 /* Do not Mirror the bitmap in this call */
#define CAPTUREBLT                   (DWORD)0x40000000 /* Include layered windows */
#endif /* WINVER >= 0x0500 */


/* Quaternary raster codes */
#define MAKEROP4(fore,back) (DWORD)((((back) << 8) & 0xFF000000) | (fore))

#endif /* NORASTEROPS */

#define GDI_ERROR (0xFFFFFFFFL)
#if (_WIN32_WINNT >= _WIN32_WINNT_WINXP)
#define HGDI_ERROR (LongToHandle(0xFFFFFFFFL))
#else
#define HGDI_ERROR ((HANDLE)-1)
#endif // (_WIN32_WINNT >= _WIN32_WINNT_WINXP)

/* Region Flags */
#define ERROR               0
#define NULLREGION          1
#define SIMPLEREGION        2
#define COMPLEXREGION       3
#define RGN_ERROR ERROR
--]]

ffi.cdef[[
/* CombineRgn() Styles */
static const int RGN_AND           =  1;
static const int RGN_OR            =  2;
static const int RGN_XOR           =  3;
static const int RGN_DIFF          =  4;
static const int RGN_COPY          =  5;
static const int RGN_MIN           =  RGN_AND;
static const int RGN_MAX           =  RGN_COPY;
]]

ffi.cdef[[
/* StretchBlt() Modes */
static const int BLACKONWHITE       =          1;
static const int WHITEONBLACK        =         2;
static const int COLORONCOLOR        =         3;
static const int HALFTONE            =         4;
static const int MAXSTRETCHBLTMODE   =         4;
]]

--[=[
#if(WINVER >= 0x0400)
/* New StretchBlt() Modes */
#define STRETCH_ANDSCANS    BLACKONWHITE
#define STRETCH_ORSCANS     WHITEONBLACK
#define STRETCH_DELETESCANS COLORONCOLOR
#define STRETCH_HALFTONE    HALFTONE
#endif /* WINVER >= 0x0400 */

/* PolyFill() Modes */
#define ALTERNATE                    1
#define WINDING                      2
#define POLYFILL_LAST                2

/* Layout Orientation Options */
#if(WINVER >= 0x0500)
#define LAYOUT_RTL                         0x00000001 // Right to left
#define LAYOUT_BTT                         0x00000002 // Bottom to top
#define LAYOUT_VBH                         0x00000004 // Vertical before horizontal
#define LAYOUT_ORIENTATIONMASK             (LAYOUT_RTL | LAYOUT_BTT | LAYOUT_VBH)
#define LAYOUT_BITMAPORIENTATIONPRESERVED  0x00000008
#endif /* WINVER >= 0x0500 */

/* Text Alignment Options */
#define TA_NOUPDATECP                0
#define TA_UPDATECP                  1

#define TA_LEFT                      0
#define TA_RIGHT                     2
#define TA_CENTER                    6

#define TA_TOP                       0
#define TA_BOTTOM                    8
#define TA_BASELINE                  24
#if (WINVER >= 0x0400)
#define TA_RTLREADING                256
#define TA_MASK       (TA_BASELINE+TA_CENTER+TA_UPDATECP+TA_RTLREADING)
#else
#define TA_MASK       (TA_BASELINE+TA_CENTER+TA_UPDATECP)
#endif

#define VTA_BASELINE TA_BASELINE
#define VTA_LEFT     TA_BOTTOM
#define VTA_RIGHT    TA_TOP
#define VTA_CENTER   TA_CENTER
#define VTA_BOTTOM   TA_RIGHT
#define VTA_TOP      TA_LEFT

#define ETO_OPAQUE                   0x0002
#define ETO_CLIPPED                  0x0004
#if(WINVER >= 0x0400)
#define ETO_GLYPH_INDEX              0x0010
#define ETO_RTLREADING               0x0080
#define ETO_NUMERICSLOCAL            0x0400
#define ETO_NUMERICSLATIN            0x0800
#define ETO_IGNORELANGUAGE           0x1000
#endif /* WINVER >= 0x0400 */
#if (_WIN32_WINNT >= _WIN32_WINNT_WIN2K)
#define ETO_PDY                      0x2000
#endif // (_WIN32_WINNT >= _WIN32_WINNT_WIN2K)
#if (_WIN32_WINNT >= _WIN32_WINNT_LONGHORN)
#define ETO_REVERSE_INDEX_MAP        0x10000
#endif

#define ASPECT_FILTERING             0x0001

/* Bounds Accumulation APIs */

#define DCB_RESET       0x0001
#define DCB_ACCUMULATE  0x0002
#define DCB_DIRTY       DCB_ACCUMULATE
#define DCB_SET         (DCB_RESET | DCB_ACCUMULATE)
#define DCB_ENABLE      0x0004
#define DCB_DISABLE     0x0008
--]=]

--[[
    The META_* definitions are for the original Windows Metafile format (1.0)

    The EMR_* definitions are for modern day Enhanced Metafile format
]]
ffi.cdef[[
/* Metafile Functions */
static const int META_SETBKCOLOR              = 0x0201;
static const int META_SETBKMODE               = 0x0102;
static const int META_SETMAPMODE              = 0x0103;
static const int META_SETROP2                 = 0x0104;
static const int META_SETRELABS               = 0x0105;
static const int META_SETPOLYFILLMODE         = 0x0106;
static const int META_SETSTRETCHBLTMODE       = 0x0107;
static const int META_SETTEXTCHAREXTRA        = 0x0108;
static const int META_SETTEXTCOLOR            = 0x0209;
static const int META_SETTEXTJUSTIFICATION    = 0x020A;
static const int META_SETWINDOWORG            = 0x020B;
static const int META_SETWINDOWEXT            = 0x020C;
static const int META_SETVIEWPORTORG          = 0x020D;
static const int META_SETVIEWPORTEXT          = 0x020E;
static const int META_OFFSETWINDOWORG         = 0x020F;
static const int META_SCALEWINDOWEXT          = 0x0410;
static const int META_OFFSETVIEWPORTORG       = 0x0211;
static const int META_SCALEVIEWPORTEXT        = 0x0412;
static const int META_LINETO                  = 0x0213;
static const int META_MOVETO                  = 0x0214;
static const int META_EXCLUDECLIPRECT         = 0x0415;
static const int META_INTERSECTCLIPRECT       = 0x0416;
static const int META_ARC                     = 0x0817;
static const int META_ELLIPSE                 = 0x0418;
static const int META_FLOODFILL               = 0x0419;
static const int META_PIE                     = 0x081A;
static const int META_RECTANGLE               = 0x041B;
static const int META_ROUNDRECT               = 0x061C;
static const int META_PATBLT                  = 0x061D;
static const int META_SAVEDC                  = 0x001E;
static const int META_SETPIXEL                = 0x041F;
static const int META_OFFSETCLIPRGN           = 0x0220;
static const int META_TEXTOUT                 = 0x0521;
static const int META_BITBLT                  = 0x0922;
static const int META_STRETCHBLT              = 0x0B23;
static const int META_POLYGON                 = 0x0324;
static const int META_POLYLINE                = 0x0325;
static const int META_ESCAPE                  = 0x0626;
static const int META_RESTOREDC               = 0x0127;
static const int META_FILLREGION              = 0x0228;
static const int META_FRAMEREGION             = 0x0429;
static const int META_INVERTREGION            = 0x012A;
static const int META_PAINTREGION             = 0x012B;
static const int META_SELECTCLIPREGION        = 0x012C;
static const int META_SELECTOBJECT            = 0x012D;
static const int META_SETTEXTALIGN            = 0x012E;
static const int META_CHORD                   = 0x0830;
static const int META_SETMAPPERFLAGS          = 0x0231;
static const int META_EXTTEXTOUT              = 0x0a32;
static const int META_SETDIBTODEV             = 0x0d33;
static const int META_SELECTPALETTE           = 0x0234;
static const int META_REALIZEPALETTE          = 0x0035;
static const int META_ANIMATEPALETTE          = 0x0436;
static const int META_SETPALENTRIES           = 0x0037;
static const int META_POLYPOLYGON             = 0x0538;
static const int META_RESIZEPALETTE           = 0x0139;
static const int META_DIBBITBLT               = 0x0940;
static const int META_DIBSTRETCHBLT           = 0x0b41;
static const int META_DIBCREATEPATTERNBRUSH   = 0x0142;
static const int META_STRETCHDIB              = 0x0f43;
static const int META_EXTFLOODFILL            = 0x0548;

static const int META_SETLAYOUT               = 0x0149;

static const int META_DELETEOBJECT            = 0x01f0;
static const int META_CREATEPALETTE           = 0x00f7;
static const int META_CREATEPATTERNBRUSH      = 0x01F9;
static const int META_CREATEPENINDIRECT       = 0x02FA;
static const int META_CREATEFONTINDIRECT      = 0x02FB;
static const int META_CREATEBRUSHINDIRECT     = 0x02FC;
static const int META_CREATEREGION            = 0x06FF;
]]

ffi.cdef[[
typedef struct _DRAWPATRECT {
        POINT ptPosition;
        POINT ptSize;
        WORD wStyle;
        WORD wPattern;
} DRAWPATRECT, *PDRAWPATRECT;
]]

--[=[
/* GDI Escapes */
#define NEWFRAME                     1
#define ABORTDOC                     2
#define NEXTBAND                     3
#define SETCOLORTABLE                4
#define GETCOLORTABLE                5
#define FLUSHOUTPUT                  6
#define DRAFTMODE                    7
#define QUERYESCSUPPORT              8
#define SETABORTPROC                 9
#define STARTDOC                     10
#define ENDDOC                       11
#define GETPHYSPAGESIZE              12
#define GETPRINTINGOFFSET            13
#define GETSCALINGFACTOR             14
#define MFCOMMENT                    15
#define GETPENWIDTH                  16
#define SETCOPYCOUNT                 17
#define SELECTPAPERSOURCE            18
#define DEVICEDATA                   19
#define PASSTHROUGH                  19
#define GETTECHNOLGY                 20
#define GETTECHNOLOGY                20
#define SETLINECAP                   21
#define SETLINEJOIN                  22
#define SETMITERLIMIT                23
#define BANDINFO                     24
#define DRAWPATTERNRECT              25
#define GETVECTORPENSIZE             26
#define GETVECTORBRUSHSIZE           27
#define ENABLEDUPLEX                 28
#define GETSETPAPERBINS              29
#define GETSETPRINTORIENT            30
#define ENUMPAPERBINS                31
#define SETDIBSCALING                32
#define EPSPRINTING                  33
#define ENUMPAPERMETRICS             34
#define GETSETPAPERMETRICS           35
#define POSTSCRIPT_DATA              37
#define POSTSCRIPT_IGNORE            38
#define MOUSETRAILS                  39
#define GETDEVICEUNITS               42

#define GETEXTENDEDTEXTMETRICS       256
#define GETEXTENTTABLE               257
#define GETPAIRKERNTABLE             258
#define GETTRACKKERNTABLE            259
#define EXTTEXTOUT                   512
#define GETFACENAME                  513
#define DOWNLOADFACE                 514
#define ENABLERELATIVEWIDTHS         768
#define ENABLEPAIRKERNING            769
#define SETKERNTRACK                 770
#define SETALLJUSTVALUES             771
#define SETCHARSET                   772

#define STRETCHBLT                   2048
#define METAFILE_DRIVER              2049
#define GETSETSCREENPARAMS           3072
#define QUERYDIBSUPPORT              3073
#define BEGIN_PATH                   4096
#define CLIP_TO_PATH                 4097
#define END_PATH                     4098
#define EXT_DEVICE_CAPS              4099
#define RESTORE_CTM                  4100
#define SAVE_CTM                     4101
#define SET_ARC_DIRECTION            4102
#define SET_BACKGROUND_COLOR         4103
#define SET_POLY_MODE                4104
#define SET_SCREEN_ANGLE             4105
#define SET_SPREAD                   4106
#define TRANSFORM_CTM                4107
#define SET_CLIP_BOX                 4108
#define SET_BOUNDS                   4109
#define SET_MIRROR_MODE              4110
#define OPENCHANNEL                  4110
#define DOWNLOADHEADER               4111
#define CLOSECHANNEL                 4112
#define POSTSCRIPT_PASSTHROUGH       4115
#define ENCAPSULATED_POSTSCRIPT      4116

#define POSTSCRIPT_IDENTIFY          4117   /* new escape for NT5 pscript driver */
#define POSTSCRIPT_INJECTION         4118   /* new escape for NT5 pscript driver */

#define CHECKJPEGFORMAT              4119
#define CHECKPNGFORMAT               4120

#define GET_PS_FEATURESETTING        4121   /* new escape for NT5 pscript driver */

#define GDIPLUS_TS_QUERYVER          4122   /* private escape */
#define GDIPLUS_TS_RECORD            4123   /* private escape */
--]=]

--[=[
/*
 * Return Values for MILCORE_TS_QUERYVER
 */


#define MILCORE_TS_QUERYVER_RESULT_FALSE        0x0
#define MILCORE_TS_QUERYVER_RESULT_TRUE  0x7FFFFFFF



#define SPCLPASSTHROUGH2             4568   /* new escape for NT5 pscript driver */

/*
 * Parameters for POSTSCRIPT_IDENTIFY escape
 */

#define PSIDENT_GDICENTRIC    0
#define PSIDENT_PSCENTRIC     1



/*
 * Header structure for the input buffer to POSTSCRIPT_INJECTION escape
 */

typedef struct _PSINJECTDATA {

    DWORD   DataBytes;      /* number of raw data bytes (NOT including this header) */
    WORD    InjectionPoint; /* injection point */
    WORD    PageNumber;     /* page number to apply the injection */

    /* Followed by raw data to be injected */

} PSINJECTDATA, *PPSINJECTDATA;


/*
 * Constants for PSINJECTDATA.InjectionPoint field
 */

#define PSINJECT_BEGINSTREAM                1
#define PSINJECT_PSADOBE                    2
#define PSINJECT_PAGESATEND                 3
#define PSINJECT_PAGES                      4

#define PSINJECT_DOCNEEDEDRES               5
#define PSINJECT_DOCSUPPLIEDRES             6
#define PSINJECT_PAGEORDER                  7
#define PSINJECT_ORIENTATION                8
#define PSINJECT_BOUNDINGBOX                9
#define PSINJECT_DOCUMENTPROCESSCOLORS      10

#define PSINJECT_COMMENTS                   11
#define PSINJECT_BEGINDEFAULTS              12
#define PSINJECT_ENDDEFAULTS                13
#define PSINJECT_BEGINPROLOG                14
#define PSINJECT_ENDPROLOG                  15
#define PSINJECT_BEGINSETUP                 16
#define PSINJECT_ENDSETUP                   17
#define PSINJECT_TRAILER                    18
#define PSINJECT_EOF                        19
#define PSINJECT_ENDSTREAM                  20
#define PSINJECT_DOCUMENTPROCESSCOLORSATEND 21

#define PSINJECT_PAGENUMBER                 100
#define PSINJECT_BEGINPAGESETUP             101
#define PSINJECT_ENDPAGESETUP               102
#define PSINJECT_PAGETRAILER                103
#define PSINJECT_PLATECOLOR                 104

#define PSINJECT_SHOWPAGE                   105
#define PSINJECT_PAGEBBOX                   106
#define PSINJECT_ENDPAGECOMMENTS            107

#define PSINJECT_VMSAVE                     200
#define PSINJECT_VMRESTORE                  201

/*
 * InjectionPoint for publisher mode PScript5 OEM plugin to
 * generate DSC comment for included font resource
 */
#define PSINJECT_DLFONT                     0xdddddddd

/*
 * Parameter for GET_PS_FEATURESETTING escape
 */

#define FEATURESETTING_NUP                  0
#define FEATURESETTING_OUTPUT               1
#define FEATURESETTING_PSLEVEL              2
#define FEATURESETTING_CUSTPAPER            3
#define FEATURESETTING_MIRROR               4
#define FEATURESETTING_NEGATIVE             5
#define FEATURESETTING_PROTOCOL             6


//
// The range of selectors between FEATURESETTING_PRIVATE_BEGIN and
// FEATURESETTING_PRIVATE_END is reserved by Microsoft for private use
//
#define FEATURESETTING_PRIVATE_BEGIN 0x1000
#define FEATURESETTING_PRIVATE_END   0x1FFF




/*
 * Information about output options
 */

typedef struct _PSFEATURE_OUTPUT {

    BOOL bPageIndependent;
    BOOL bSetPageDevice;

} PSFEATURE_OUTPUT, *PPSFEATURE_OUTPUT;

/*
 * Information about custom paper size
 */

typedef struct _PSFEATURE_CUSTPAPER {

    LONG lOrientation;
    LONG lWidth;
    LONG lHeight;
    LONG lWidthOffset;
    LONG lHeightOffset;

} PSFEATURE_CUSTPAPER, *PPSFEATURE_CUSTPAPER;



/* Value returned for FEATURESETTING_PROTOCOL */
#define PSPROTOCOL_ASCII             0
#define PSPROTOCOL_BCP               1
#define PSPROTOCOL_TBCP              2
#define PSPROTOCOL_BINARY            3

/* Flag returned from QUERYDIBSUPPORT */
#define QDI_SETDIBITS                1
#define QDI_GETDIBITS                2
#define QDI_DIBTOSCREEN              4
#define QDI_STRETCHDIB               8

/* Spooler Error Codes */
#define SP_NOTREPORTED               0x4000
#define SP_ERROR                     (-1)
#define SP_APPABORT                  (-2)
#define SP_USERABORT                 (-3)
#define SP_OUTOFDISK                 (-4)
#define SP_OUTOFMEMORY               (-5)

#define PR_JOBSTATUS                 0x0000

/* Object Definitions for EnumObjects() */
#define OBJ_PEN             1
#define OBJ_BRUSH           2
#define OBJ_DC              3
#define OBJ_METADC          4
#define OBJ_PAL             5
#define OBJ_FONT            6
#define OBJ_BITMAP          7
#define OBJ_REGION          8
#define OBJ_METAFILE        9
#define OBJ_MEMDC           10
#define OBJ_EXTPEN          11
#define OBJ_ENHMETADC       12
#define OBJ_ENHMETAFILE     13
#define OBJ_COLORSPACE      14

#define GDI_OBJ_LAST        OBJ_COLORSPACE

/* xform stuff */
#define MWT_IDENTITY        1
#define MWT_LEFTMULTIPLY    2
#define MWT_RIGHTMULTIPLY   3

#define MWT_MIN             MWT_IDENTITY
#define MWT_MAX             MWT_RIGHTMULTIPLY
--]=]

_XFORM_ = true;
ffi.cdef[[

typedef struct  tagXFORM
  {
    FLOAT   eM11;
    FLOAT   eM12;
    FLOAT   eM21;
    FLOAT   eM22;
    FLOAT   eDx;
    FLOAT   eDy;
  } XFORM, *PXFORM, *LPXFORM;
]]

ffi.cdef[[
/* Bitmap Header Definition */
typedef struct tagBITMAP
  {
    LONG        bmType;
    LONG        bmWidth;
    LONG        bmHeight;
    LONG        bmWidthBytes;
    WORD        bmPlanes;
    WORD        bmBitsPixel;
    LPVOID      bmBits;
  } BITMAP, *PBITMAP,  *NPBITMAP, *LPBITMAP;
]]



--#include <pshpack1.h>
ffi.cdef[[

typedef struct tagRGBTRIPLE {
        BYTE    rgbtBlue;
        BYTE    rgbtGreen;
        BYTE    rgbtRed;
} RGBTRIPLE, *PRGBTRIPLE,  *NPRGBTRIPLE, *LPRGBTRIPLE;
]]
--#include <poppack.h>

ffi.cdef[[
typedef struct tagRGBQUAD {
        BYTE    rgbBlue;
        BYTE    rgbGreen;
        BYTE    rgbRed;
        BYTE    rgbReserved;
} RGBQUAD;


typedef RGBQUAD * LPRGBQUAD;
]]



ffi.cdef[[
/* Image Color Matching color definitions */

static const int CS_ENABLE                      = 0x00000001L;
static const int CS_DISABLE                     = 0x00000002L;
static const int CS_DELETE_TRANSFORM            = 0x00000003L;
]]

ffi.cdef[[
static const int LCS_SIGNATURE           = 0x434F5350;    // 'PSOC';
static const int LCS_sRGB                = 0x42475273;    // 'sRGB';
static const int LCS_WINDOWS_COLOR_SPACE = 0x206E6957;    // 'Win ';  // Windows default color space
]]

ffi.cdef[[
typedef LONG   LCSCSTYPE;

static const int LCS_CALIBRATED_RGB             = 0x00000000L;

typedef LONG    LCSGAMUTMATCH;

static const int LCS_GM_BUSINESS                = 0x00000001L;
static const int LCS_GM_GRAPHICS                = 0x00000002L;
static const int LCS_GM_IMAGES                  = 0x00000004L;
static const int LCS_GM_ABS_COLORIMETRIC        = 0x00000008L;
]]

ffi.cdef[[
/* ICM Defines for results from CheckColorInGamut() */
static const int CM_OUT_OF_GAMUT                = 255;
static const int CM_IN_GAMUT                    = 0;
]]

ffi.cdef[[
/* UpdateICMRegKey Constants               */
static const int ICM_ADDPROFILE                 = 1;
static const int ICM_DELETEPROFILE              = 2;
static const int ICM_QUERYPROFILE               = 3;
static const int ICM_SETDEFAULTPROFILE          = 4;
static const int ICM_REGISTERICMATCHER          = 5;
static const int ICM_UNREGISTERICMATCHER        = 6;
static const int ICM_QUERYMATCH                 = 7;
]]



function exports.GetKValue(cmyk)  return    ffi.cast("BYTE",(cmyk)) end
function exports.GetYValue(cmyk)  return    ffi.cast("BYTE",rshift(cmyk, 8)) end
function exports.GetMValue(cmyk)  return    ffi.cast("BYTE",rshift(cmyk,16)) end
function exports.GetCValue(cmyk)  return    ffi.cast("BYTE",rshift(cmyk,24)) end

--function exports.CMYK(c,m,y,k)    return    ffi.cast("COLORREF",((((BYTE)(k)|((WORD)((BYTE)(y))<<8))|(((DWORD)(BYTE)(m))<<16))|(((DWORD)(BYTE)(c))<<24)))


ffi.cdef[[
typedef long            FXPT16DOT16, *LPFXPT16DOT16;
typedef long            FXPT2DOT30, *LPFXPT2DOT30;
]]

ffi.cdef[[
/* ICM Color Definitions */
// The following two structures are used for defining RGB's in terms of CIEXYZ.

typedef struct tagCIEXYZ
{
        FXPT2DOT30 ciexyzX;
        FXPT2DOT30 ciexyzY;
        FXPT2DOT30 ciexyzZ;
} CIEXYZ;


typedef CIEXYZ   *LPCIEXYZ;



typedef struct tagICEXYZTRIPLE
{
        CIEXYZ  ciexyzRed;
        CIEXYZ  ciexyzGreen;
        CIEXYZ  ciexyzBlue;
} CIEXYZTRIPLE;


typedef CIEXYZTRIPLE     *LPCIEXYZTRIPLE;
]]

ffi.cdef[[
// The next structures the logical color space. Unlike pens and brushes,
// but like palettes, there is only one way to create a LogColorSpace.
// A pointer to it must be passed, its elements can't be pushed as
// arguments.

typedef struct tagLOGCOLORSPACEA {
    DWORD lcsSignature;
    DWORD lcsVersion;
    DWORD lcsSize;
    LCSCSTYPE lcsCSType;
    LCSGAMUTMATCH lcsIntent;
    CIEXYZTRIPLE lcsEndpoints;
    DWORD lcsGammaRed;
    DWORD lcsGammaGreen;
    DWORD lcsGammaBlue;
    CHAR   lcsFilename[MAX_PATH];
} LOGCOLORSPACEA, *LPLOGCOLORSPACEA;

typedef struct tagLOGCOLORSPACEW {
    DWORD lcsSignature;
    DWORD lcsVersion;
    DWORD lcsSize;
    LCSCSTYPE lcsCSType;
    LCSGAMUTMATCH lcsIntent;
    CIEXYZTRIPLE lcsEndpoints;
    DWORD lcsGammaRed;
    DWORD lcsGammaGreen;
    DWORD lcsGammaBlue;
    WCHAR  lcsFilename[MAX_PATH];
} LOGCOLORSPACEW, *LPLOGCOLORSPACEW;
]]

--[[
#ifdef UNICODE
typedef LOGCOLORSPACEW LOGCOLORSPACE;
typedef LPLOGCOLORSPACEW LPLOGCOLORSPACE;
#else
typedef LOGCOLORSPACEA LOGCOLORSPACE;
typedef LPLOGCOLORSPACEA LPLOGCOLORSPACE;
#endif // UNICODE
--]]


ffi.cdef[[
/* structures for defining DIBs */
typedef struct tagBITMAPCOREHEADER {
        DWORD   bcSize;                 /* used to get to color table */
        WORD    bcWidth;
        WORD    bcHeight;
        WORD    bcPlanes;
        WORD    bcBitCount;
} BITMAPCOREHEADER,  *LPBITMAPCOREHEADER, *PBITMAPCOREHEADER;
]]

ffi.cdef[[
typedef struct tagBITMAPINFOHEADER{
        DWORD      biSize;
        LONG       biWidth;
        LONG       biHeight;
        WORD       biPlanes;
        WORD       biBitCount;
        DWORD      biCompression;
        DWORD      biSizeImage;
        LONG       biXPelsPerMeter;
        LONG       biYPelsPerMeter;
        DWORD      biClrUsed;
        DWORD      biClrImportant;
} BITMAPINFOHEADER,  *LPBITMAPINFOHEADER, *PBITMAPINFOHEADER;
]]


ffi.cdef[[
typedef struct {
        DWORD        bV4Size;
        LONG         bV4Width;
        LONG         bV4Height;
        WORD         bV4Planes;
        WORD         bV4BitCount;
        DWORD        bV4V4Compression;
        DWORD        bV4SizeImage;
        LONG         bV4XPelsPerMeter;
        LONG         bV4YPelsPerMeter;
        DWORD        bV4ClrUsed;
        DWORD        bV4ClrImportant;
        DWORD        bV4RedMask;
        DWORD        bV4GreenMask;
        DWORD        bV4BlueMask;
        DWORD        bV4AlphaMask;
        DWORD        bV4CSType;
        CIEXYZTRIPLE bV4Endpoints;
        DWORD        bV4GammaRed;
        DWORD        bV4GammaGreen;
        DWORD        bV4GammaBlue;
} BITMAPV4HEADER,  *LPBITMAPV4HEADER, *PBITMAPV4HEADER;
]]

ffi.cdef[[
typedef struct {
        DWORD        bV5Size;
        LONG         bV5Width;
        LONG         bV5Height;
        WORD         bV5Planes;
        WORD         bV5BitCount;
        DWORD        bV5Compression;
        DWORD        bV5SizeImage;
        LONG         bV5XPelsPerMeter;
        LONG         bV5YPelsPerMeter;
        DWORD        bV5ClrUsed;
        DWORD        bV5ClrImportant;
        DWORD        bV5RedMask;
        DWORD        bV5GreenMask;
        DWORD        bV5BlueMask;
        DWORD        bV5AlphaMask;
        DWORD        bV5CSType;
        CIEXYZTRIPLE bV5Endpoints;
        DWORD        bV5GammaRed;
        DWORD        bV5GammaGreen;
        DWORD        bV5GammaBlue;
        DWORD        bV5Intent;
        DWORD        bV5ProfileData;
        DWORD        bV5ProfileSize;
        DWORD        bV5Reserved;
} BITMAPV5HEADER,  *LPBITMAPV5HEADER, *PBITMAPV5HEADER;
]]


ffi.cdef[[
// Values for bV5CSType
static const int PROFILE_LINKED     =     0x4B4E494C;       // 'LINK';
static const int PROFILE_EMBEDDED   =     0x4445424D;       // 'MBED';
]]

ffi.cdef[[
/* constants for the biCompression field */
static const int BI_RGB       = 0;
static const int BI_RLE8      = 1;
static const int BI_RLE4      = 2;
static const int BI_BITFIELDS = 3;
static const int BI_JPEG      = 4;
static const int BI_PNG       = 5;
]]

ffi.cdef[[
typedef struct tagBITMAPINFO {
    BITMAPINFOHEADER    bmiHeader;
    RGBQUAD             bmiColors[1];
} BITMAPINFO,  *LPBITMAPINFO, *PBITMAPINFO;


typedef struct tagBITMAPCOREINFO {
    BITMAPCOREHEADER    bmciHeader;
    RGBTRIPLE           bmciColors[1];
} BITMAPCOREINFO,  *LPBITMAPCOREINFO, *PBITMAPCOREINFO;
]]


--#include <pshpack2.h>
ffi.cdef[[
typedef struct tagBITMAPFILEHEADER {
        WORD    bfType;
        DWORD   bfSize;
        WORD    bfReserved1;
        WORD    bfReserved2;
        DWORD   bfOffBits;
} BITMAPFILEHEADER,  *LPBITMAPFILEHEADER, *PBITMAPFILEHEADER;
]]

--#include <poppack.h>


--#define MAKEPOINTS(l)       (*((POINTS  *)&(l)))


ffi.cdef[[
typedef struct tagFONTSIGNATURE
{
    DWORD fsUsb[4];
    DWORD fsCsb[2];
} FONTSIGNATURE, *PFONTSIGNATURE, *LPFONTSIGNATURE;


typedef struct tagCHARSETINFO
{
    UINT ciCharset;
    UINT ciACP;
    FONTSIGNATURE fs;
} CHARSETINFO, *PCHARSETINFO,  *NPCHARSETINFO,  *LPCHARSETINFO;
]]

--[=[
#define TCI_SRCCHARSET  1
#define TCI_SRCCODEPAGE 2
#define TCI_SRCFONTSIG  3

#define TCI_SRCLOCALE   0x1000


typedef struct tagLOCALESIGNATURE
{
    DWORD lsUsb[4];
    DWORD lsCsbDefault[2];
    DWORD lsCsbSupported[2];
} LOCALESIGNATURE, *PLOCALESIGNATURE, *LPLOCALESIGNATURE;
--]=]


ffi.cdef[[
/* Clipboard Metafile Picture Structure */

typedef struct tagHANDLETABLE
  {
    HGDIOBJ     objectHandle[1];
  } HANDLETABLE, *PHANDLETABLE,  *LPHANDLETABLE;

typedef struct tagMETARECORD
  {
    DWORD       rdSize;
    WORD        rdFunction;
    WORD        rdParm[1];
  } METARECORD;
]]


ffi.cdef[[
typedef struct tagMETARECORD *PMETARECORD;

typedef struct tagMETARECORD  *LPMETARECORD;

typedef struct tagMETAFILEPICT
  {
    LONG        mm;
    LONG        xExt;
    LONG        yExt;
    HMETAFILE   hMF;
  } METAFILEPICT,  *LPMETAFILEPICT;
]]


--#include <pshpack2.h>


ffi.cdef[[
typedef struct tagMETAHEADER
{
    WORD        mtType;
    WORD        mtHeaderSize;
    WORD        mtVersion;
    DWORD       mtSize;
    WORD        mtNoObjects;
    DWORD       mtMaxRecord;
    WORD        mtNoParameters;
} METAHEADER;
typedef struct tagMETAHEADER  *PMETAHEADER;
typedef struct tagMETAHEADER   *LPMETAHEADER;
]]

--#include <poppack.h>

ffi.cdef[[
/* Enhanced Metafile structures */
typedef struct tagENHMETARECORD
{
    DWORD   iType;              // Record type EMR_XXX
    DWORD   nSize;              // Record size in bytes
    DWORD   dParm[1];           // Parameters
} ENHMETARECORD, *PENHMETARECORD, *LPENHMETARECORD;

typedef struct tagENHMETAHEADER
{
    DWORD   iType;              // Record typeEMR_HEADER
    DWORD   nSize;              // Record size in bytes.  This may be greater
                                // than the sizeof(ENHMETAHEADER).
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    RECTL   rclFrame;           // Inclusive-inclusive Picture Frame of metafile in .01 mm units
    DWORD   dSignature;         // Signature.  Must be ENHMETA_SIGNATURE.
    DWORD   nVersion;           // Version number
    DWORD   nBytes;             // Size of the metafile in bytes
    DWORD   nRecords;           // Number of records in the metafile
    WORD    nHandles;           // Number of handles in the handle table
                                // Handle index zero is reserved.
    WORD    sReserved;          // Reserved.  Must be zero.
    DWORD   nDescription;       // Number of chars in the unicode description string
                                // This is 0 if there is no description string
    DWORD   offDescription;     // Offset to the metafile description record.
                                // This is 0 if there is no description string
    DWORD   nPalEntries;        // Number of entries in the metafile palette.
    SIZEL   szlDevice;          // Size of the reference device in pels
    SIZEL   szlMillimeters;     // Size of the reference device in millimeters

    DWORD   cbPixelFormat;      // Size of PIXELFORMATDESCRIPTOR information
                                // This is 0 if no pixel format is set
    DWORD   offPixelFormat;     // Offset to PIXELFORMATDESCRIPTOR
                                // This is 0 if no pixel format is set
    DWORD   bOpenGL;            // TRUE if OpenGL commands are present in
                                // the metafile, otherwise FALSE


    SIZEL   szlMicrometers;     // Size of the reference device in micrometers


} ENHMETAHEADER, *PENHMETAHEADER, *LPENHMETAHEADER;
]]

ffi.cdef[[
/* tmPitchAndFamily flags */
static const int TMPF_FIXED_PITCH  =  0x01;
static const int TMPF_VECTOR       =  0x02;
static const int TMPF_DEVICE       =  0x08;
static const int TMPF_TRUETYPE     =  0x04;
]]


-- BCHAR definition for APPs
if UNICODE then
ffi.cdef[[
    typedef WCHAR BCHAR;
]]
else
ffi.cdef[[
    typedef BYTE BCHAR;
]]
end


--#include <pshpack4.h>
ffi.cdef[[
typedef struct tagTEXTMETRICA
{
    LONG        tmHeight;
    LONG        tmAscent;
    LONG        tmDescent;
    LONG        tmInternalLeading;
    LONG        tmExternalLeading;
    LONG        tmAveCharWidth;
    LONG        tmMaxCharWidth;
    LONG        tmWeight;
    LONG        tmOverhang;
    LONG        tmDigitizedAspectX;
    LONG        tmDigitizedAspectY;
    BYTE        tmFirstChar;
    BYTE        tmLastChar;
    BYTE        tmDefaultChar;
    BYTE        tmBreakChar;
    BYTE        tmItalic;
    BYTE        tmUnderlined;
    BYTE        tmStruckOut;
    BYTE        tmPitchAndFamily;
    BYTE        tmCharSet;
} TEXTMETRICA, *PTEXTMETRICA,  *NPTEXTMETRICA,  *LPTEXTMETRICA;
]]

ffi.cdef[[
typedef struct tagTEXTMETRICW
{
    LONG        tmHeight;
    LONG        tmAscent;
    LONG        tmDescent;
    LONG        tmInternalLeading;
    LONG        tmExternalLeading;
    LONG        tmAveCharWidth;
    LONG        tmMaxCharWidth;
    LONG        tmWeight;
    LONG        tmOverhang;
    LONG        tmDigitizedAspectX;
    LONG        tmDigitizedAspectY;
    WCHAR       tmFirstChar;
    WCHAR       tmLastChar;
    WCHAR       tmDefaultChar;
    WCHAR       tmBreakChar;
    BYTE        tmItalic;
    BYTE        tmUnderlined;
    BYTE        tmStruckOut;
    BYTE        tmPitchAndFamily;
    BYTE        tmCharSet;
} TEXTMETRICW, *PTEXTMETRICW,  *NPTEXTMETRICW,  *LPTEXTMETRICW;
]]

--[[
#ifdef UNICODE
typedef TEXTMETRICW TEXTMETRIC;
typedef PTEXTMETRICW PTEXTMETRIC;
typedef NPTEXTMETRICW NPTEXTMETRIC;
typedef LPTEXTMETRICW LPTEXTMETRIC;
#else
typedef TEXTMETRICA TEXTMETRIC;
typedef PTEXTMETRICA PTEXTMETRIC;
typedef NPTEXTMETRICA NPTEXTMETRIC;
typedef LPTEXTMETRICA LPTEXTMETRIC;
#endif // UNICODE
--]]


--#include <poppack.h>

--[=[
/* ntmFlags field flags */
#define NTM_REGULAR     0x00000040L
#define NTM_BOLD        0x00000020L
#define NTM_ITALIC      0x00000001L

/* new in NT 5.0 */

#define NTM_NONNEGATIVE_AC  0x00010000
#define NTM_PS_OPENTYPE     0x00020000
#define NTM_TT_OPENTYPE     0x00040000
#define NTM_MULTIPLEMASTER  0x00080000
#define NTM_TYPE1           0x00100000
#define NTM_DSIG            0x00200000
--]=]

--#include <pshpack4.h>

ffi.cdef[[
typedef struct tagNEWTEXTMETRICA
{
    LONG        tmHeight;
    LONG        tmAscent;
    LONG        tmDescent;
    LONG        tmInternalLeading;
    LONG        tmExternalLeading;
    LONG        tmAveCharWidth;
    LONG        tmMaxCharWidth;
    LONG        tmWeight;
    LONG        tmOverhang;
    LONG        tmDigitizedAspectX;
    LONG        tmDigitizedAspectY;
    BYTE        tmFirstChar;
    BYTE        tmLastChar;
    BYTE        tmDefaultChar;
    BYTE        tmBreakChar;
    BYTE        tmItalic;
    BYTE        tmUnderlined;
    BYTE        tmStruckOut;
    BYTE        tmPitchAndFamily;
    BYTE        tmCharSet;
    DWORD   ntmFlags;
    UINT    ntmSizeEM;
    UINT    ntmCellHeight;
    UINT    ntmAvgWidth;
} NEWTEXTMETRICA, *PNEWTEXTMETRICA,  *NPNEWTEXTMETRICA,  *LPNEWTEXTMETRICA;

typedef struct tagNEWTEXTMETRICW
{
    LONG        tmHeight;
    LONG        tmAscent;
    LONG        tmDescent;
    LONG        tmInternalLeading;
    LONG        tmExternalLeading;
    LONG        tmAveCharWidth;
    LONG        tmMaxCharWidth;
    LONG        tmWeight;
    LONG        tmOverhang;
    LONG        tmDigitizedAspectX;
    LONG        tmDigitizedAspectY;
    WCHAR       tmFirstChar;
    WCHAR       tmLastChar;
    WCHAR       tmDefaultChar;
    WCHAR       tmBreakChar;
    BYTE        tmItalic;
    BYTE        tmUnderlined;
    BYTE        tmStruckOut;
    BYTE        tmPitchAndFamily;
    BYTE        tmCharSet;
    DWORD   ntmFlags;
    UINT    ntmSizeEM;
    UINT    ntmCellHeight;
    UINT    ntmAvgWidth;
} NEWTEXTMETRICW, *PNEWTEXTMETRICW,  *NPNEWTEXTMETRICW,  *LPNEWTEXTMETRICW;
]]

--[[
#ifdef UNICODE
typedef NEWTEXTMETRICW NEWTEXTMETRIC;
typedef PNEWTEXTMETRICW PNEWTEXTMETRIC;
typedef NPNEWTEXTMETRICW NPNEWTEXTMETRIC;
typedef LPNEWTEXTMETRICW LPNEWTEXTMETRIC;
#else
typedef NEWTEXTMETRICA NEWTEXTMETRIC;
typedef PNEWTEXTMETRICA PNEWTEXTMETRIC;
typedef NPNEWTEXTMETRICA NPNEWTEXTMETRIC;
typedef LPNEWTEXTMETRICA LPNEWTEXTMETRIC;
#endif // UNICODE
--]]

--#include <poppack.h>



ffi.cdef[[
typedef struct tagNEWTEXTMETRICEXA
{
    NEWTEXTMETRICA  ntmTm;
    FONTSIGNATURE   ntmFontSig;
}NEWTEXTMETRICEXA;

typedef struct tagNEWTEXTMETRICEXW
{
    NEWTEXTMETRICW  ntmTm;
    FONTSIGNATURE   ntmFontSig;
}NEWTEXTMETRICEXW;
]]

--[[
#ifdef UNICODE
typedef NEWTEXTMETRICEXW NEWTEXTMETRICEX;
#else
typedef NEWTEXTMETRICEXA NEWTEXTMETRICEX;
#endif // UNICODE
--]]


--/* GDI Logical Objects: */

ffi.cdef[[
typedef struct tagPELARRAY
  {
    LONG        paXCount;
    LONG        paYCount;
    LONG        paXExt;
    LONG        paYExt;
    BYTE        paRGBs;
  } PELARRAY, *PPELARRAY,  *NPPELARRAY,  *LPPELARRAY;
]]

ffi.cdef[[
/* Logical Brush (or Pattern) */
typedef struct tagLOGBRUSH
  {
    UINT        lbStyle;
    COLORREF    lbColor;
    ULONG_PTR   lbHatch;
  } LOGBRUSH, *PLOGBRUSH,  *NPLOGBRUSH,  *LPLOGBRUSH;
]]

ffi.cdef[[
typedef struct tagLOGBRUSH32
  {
    UINT        lbStyle;
    COLORREF    lbColor;
    ULONG       lbHatch;
  } LOGBRUSH32, *PLOGBRUSH32,  *NPLOGBRUSH32,  *LPLOGBRUSH32;
]]


ffi.cdef[[
typedef LOGBRUSH            PATTERN;
typedef PATTERN             *PPATTERN;
typedef PATTERN         *NPPATTERN;
typedef PATTERN          *LPPATTERN;
]]


ffi.cdef[[
/* Logical Pen */
typedef struct tagLOGPEN
  {
    UINT        lopnStyle;
    POINT       lopnWidth;
    COLORREF    lopnColor;
  } LOGPEN, *PLOGPEN,  *NPLOGPEN,  *LPLOGPEN;
]]


ffi.cdef[[
typedef struct tagEXTLOGPEN {
    DWORD       elpPenStyle;
    DWORD       elpWidth;
    UINT        elpBrushStyle;
    COLORREF    elpColor;
    ULONG_PTR   elpHatch;
    DWORD       elpNumEntries;
    DWORD       elpStyleEntry[1];
} EXTLOGPEN, *PEXTLOGPEN,  *NPEXTLOGPEN,  *LPEXTLOGPEN;
]]

ffi.cdef[[
typedef struct tagEXTLOGPEN32 {
    DWORD       elpPenStyle;
    DWORD       elpWidth;
    UINT        elpBrushStyle;
    COLORREF    elpColor;
    ULONG       elpHatch;
    DWORD       elpNumEntries;
    DWORD       elpStyleEntry[1];
} EXTLOGPEN32, *PEXTLOGPEN32,  *NPEXTLOGPEN32,  *LPEXTLOGPEN32;
]]

ffi.cdef[[

typedef struct tagPALETTEENTRY {
    BYTE        peRed;
    BYTE        peGreen;
    BYTE        peBlue;
    BYTE        peFlags;
} PALETTEENTRY, *PPALETTEENTRY,  *LPPALETTEENTRY;



/* Logical Palette */
typedef struct tagLOGPALETTE {
    WORD        palVersion;
    WORD        palNumEntries;
    PALETTEENTRY        palPalEntry[1];
} LOGPALETTE, *PLOGPALETTE,  *NPLOGPALETTE,  *LPLOGPALETTE;
]]

ffi.cdef[[
/* Logical Font */
static const int LF_FACESIZE    =     32;

typedef struct tagLOGFONTA
{
    LONG      lfHeight;
    LONG      lfWidth;
    LONG      lfEscapement;
    LONG      lfOrientation;
    LONG      lfWeight;
    BYTE      lfItalic;
    BYTE      lfUnderline;
    BYTE      lfStrikeOut;
    BYTE      lfCharSet;
    BYTE      lfOutPrecision;
    BYTE      lfClipPrecision;
    BYTE      lfQuality;
    BYTE      lfPitchAndFamily;
    CHAR      lfFaceName[LF_FACESIZE];
} LOGFONTA, *PLOGFONTA,  *NPLOGFONTA,  *LPLOGFONTA;
]]

ffi.cdef[[
typedef struct tagLOGFONTW
{
    LONG      lfHeight;
    LONG      lfWidth;
    LONG      lfEscapement;
    LONG      lfOrientation;
    LONG      lfWeight;
    BYTE      lfItalic;
    BYTE      lfUnderline;
    BYTE      lfStrikeOut;
    BYTE      lfCharSet;
    BYTE      lfOutPrecision;
    BYTE      lfClipPrecision;
    BYTE      lfQuality;
    BYTE      lfPitchAndFamily;
    WCHAR     lfFaceName[LF_FACESIZE];
} LOGFONTW, *PLOGFONTW,  *NPLOGFONTW,  *LPLOGFONTW;
]]

--[[
#ifdef UNICODE
typedef LOGFONTW LOGFONT;
typedef PLOGFONTW PLOGFONT;
typedef NPLOGFONTW NPLOGFONT;
typedef LPLOGFONTW LPLOGFONT;
#else
typedef LOGFONTA LOGFONT;
typedef PLOGFONTA PLOGFONT;
typedef NPLOGFONTA NPLOGFONT;
typedef LPLOGFONTA LPLOGFONT;
#endif // UNICODE
--]]


ffi.cdef[[
static const int LF_FULLFACESIZE  =   64;


/* Structure passed to FONTENUMPROC */
typedef struct tagENUMLOGFONTA
{
    LOGFONTA elfLogFont;
    BYTE     elfFullName[LF_FULLFACESIZE];
    BYTE     elfStyle[LF_FACESIZE];
} ENUMLOGFONTA, * LPENUMLOGFONTA;

/* Structure passed to FONTENUMPROC */
typedef struct tagENUMLOGFONTW
{
    LOGFONTW elfLogFont;
    WCHAR    elfFullName[LF_FULLFACESIZE];
    WCHAR    elfStyle[LF_FACESIZE];
} ENUMLOGFONTW, * LPENUMLOGFONTW;
]]

--[[
#ifdef UNICODE
typedef ENUMLOGFONTW ENUMLOGFONT;
typedef LPENUMLOGFONTW LPENUMLOGFONT;
#else
typedef ENUMLOGFONTA ENUMLOGFONT;
typedef LPENUMLOGFONTA LPENUMLOGFONT;
#endif // UNICODE
--]]

ffi.cdef[[
typedef struct tagENUMLOGFONTEXA
{
    LOGFONTA    elfLogFont;
    BYTE        elfFullName[LF_FULLFACESIZE];
    BYTE        elfStyle[LF_FACESIZE];
    BYTE        elfScript[LF_FACESIZE];
} ENUMLOGFONTEXA,  *LPENUMLOGFONTEXA;

typedef struct tagENUMLOGFONTEXW
{
    LOGFONTW    elfLogFont;
    WCHAR       elfFullName[LF_FULLFACESIZE];
    WCHAR       elfStyle[LF_FACESIZE];
    WCHAR       elfScript[LF_FACESIZE];
} ENUMLOGFONTEXW,  *LPENUMLOGFONTEXW;
]]

--[[
#ifdef UNICODE
typedef ENUMLOGFONTEXW ENUMLOGFONTEX;
typedef LPENUMLOGFONTEXW LPENUMLOGFONTEX;
#else
typedef ENUMLOGFONTEXA ENUMLOGFONTEX;
typedef LPENUMLOGFONTEXA LPENUMLOGFONTEX;
#endif // UNICODE
--]]


--[=[
#define OUT_DEFAULT_PRECIS          0
#define OUT_STRING_PRECIS           1
#define OUT_CHARACTER_PRECIS        2
#define OUT_STROKE_PRECIS           3
#define OUT_TT_PRECIS               4
#define OUT_DEVICE_PRECIS           5
#define OUT_RASTER_PRECIS           6
#define OUT_TT_ONLY_PRECIS          7
#define OUT_OUTLINE_PRECIS          8
#define OUT_SCREEN_OUTLINE_PRECIS   9
#define OUT_PS_ONLY_PRECIS          10

#define CLIP_DEFAULT_PRECIS     0
#define CLIP_CHARACTER_PRECIS   1
#define CLIP_STROKE_PRECIS      2
#define CLIP_MASK               0xf
#define CLIP_LH_ANGLES          (1<<4)
#define CLIP_TT_ALWAYS          (2<<4)
#if (_WIN32_WINNT >= _WIN32_WINNT_LONGHORN)
#define CLIP_DFA_DISABLE        (4<<4)
#endif // (_WIN32_WINNT >= _WIN32_WINNT_LONGHORN)
#define CLIP_EMBEDDED           (8<<4)

#define DEFAULT_QUALITY         0
#define DRAFT_QUALITY           1
#define PROOF_QUALITY           2
#if(WINVER >= 0x0400)
#define NONANTIALIASED_QUALITY  3
#define ANTIALIASED_QUALITY     4
#endif /* WINVER >= 0x0400 */

#if (_WIN32_WINNT >= _WIN32_WINNT_WINXP)
#define CLEARTYPE_QUALITY       5
#define CLEARTYPE_NATURAL_QUALITY       6
#endif

#define DEFAULT_PITCH           0
#define FIXED_PITCH             1
#define VARIABLE_PITCH          2
#if(WINVER >= 0x0400)
#define MONO_FONT               8
#endif /* WINVER >= 0x0400 */

#define ANSI_CHARSET            0
#define DEFAULT_CHARSET         1
#define SYMBOL_CHARSET          2
#define SHIFTJIS_CHARSET        128
#define HANGEUL_CHARSET         129
#define HANGUL_CHARSET          129
#define GB2312_CHARSET          134
#define CHINESEBIG5_CHARSET     136
#define OEM_CHARSET             255
#if(WINVER >= 0x0400)
#define JOHAB_CHARSET           130
#define HEBREW_CHARSET          177
#define ARABIC_CHARSET          178
#define GREEK_CHARSET           161
#define TURKISH_CHARSET         162
#define VIETNAMESE_CHARSET      163
#define THAI_CHARSET            222
#define EASTEUROPE_CHARSET      238
#define RUSSIAN_CHARSET         204

#define MAC_CHARSET             77
#define BALTIC_CHARSET          186

#define FS_LATIN1               0x00000001L
#define FS_LATIN2               0x00000002L
#define FS_CYRILLIC             0x00000004L
#define FS_GREEK                0x00000008L
#define FS_TURKISH              0x00000010L
#define FS_HEBREW               0x00000020L
#define FS_ARABIC               0x00000040L
#define FS_BALTIC               0x00000080L
#define FS_VIETNAMESE           0x00000100L
#define FS_THAI                 0x00010000L
#define FS_JISJAPAN             0x00020000L
#define FS_CHINESESIMP          0x00040000L
#define FS_WANSUNG              0x00080000L
#define FS_CHINESETRAD          0x00100000L
#define FS_JOHAB                0x00200000L
#define FS_SYMBOL               0x80000000L
#endif /* WINVER >= 0x0400 */

/* Font Families */
#define FF_DONTCARE         (0<<4)  /* Don't care or don't know. */
#define FF_ROMAN            (1<<4)  /* Variable stroke width, serifed. */
                                    /* Times Roman, Century Schoolbook, etc. */
#define FF_SWISS            (2<<4)  /* Variable stroke width, sans-serifed. */
                                    /* Helvetica, Swiss, etc. */
#define FF_MODERN           (3<<4)  /* Constant stroke width, serifed or sans-serifed. */
                                    /* Pica, Elite, Courier, etc. */
#define FF_SCRIPT           (4<<4)  /* Cursive, etc. */
#define FF_DECORATIVE       (5<<4)  /* Old English, etc. */

/* Font Weights */
#define FW_DONTCARE         0
#define FW_THIN             100
#define FW_EXTRALIGHT       200
#define FW_LIGHT            300
#define FW_NORMAL           400
#define FW_MEDIUM           500
#define FW_SEMIBOLD         600
#define FW_BOLD             700
#define FW_EXTRABOLD        800
#define FW_HEAVY            900

#define FW_ULTRALIGHT       FW_EXTRALIGHT
#define FW_REGULAR          FW_NORMAL
#define FW_DEMIBOLD         FW_SEMIBOLD
#define FW_ULTRABOLD        FW_EXTRABOLD
#define FW_BLACK            FW_HEAVY

#define PANOSE_COUNT               10
#define PAN_FAMILYTYPE_INDEX        0
#define PAN_SERIFSTYLE_INDEX        1
#define PAN_WEIGHT_INDEX            2
#define PAN_PROPORTION_INDEX        3
#define PAN_CONTRAST_INDEX          4
#define PAN_STROKEVARIATION_INDEX   5
#define PAN_ARMSTYLE_INDEX          6
#define PAN_LETTERFORM_INDEX        7
#define PAN_MIDLINE_INDEX           8
#define PAN_XHEIGHT_INDEX           9

#define PAN_CULTURE_LATIN           0

#pragma region Application Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)
--]=]

ffi.cdef[[
typedef struct tagPANOSE
{
    BYTE    bFamilyType;
    BYTE    bSerifStyle;
    BYTE    bWeight;
    BYTE    bProportion;
    BYTE    bContrast;
    BYTE    bStrokeVariation;
    BYTE    bArmStyle;
    BYTE    bLetterform;
    BYTE    bMidline;
    BYTE    bXHeight;
} PANOSE, * LPPANOSE;
]]

ffi.cdef[[
static const int PAN_ANY                       =  0; /* Any                            */
static const int PAN_NO_FIT                    =  1; /* No Fit                         */

static const int PAN_FAMILY_TEXT_DISPLAY       =  2; /* Text and Display               */
static const int PAN_FAMILY_SCRIPT             =  3; /* Script                         */
static const int PAN_FAMILY_DECORATIVE         =  4; /* Decorative                     */
static const int PAN_FAMILY_PICTORIAL          =  5; /* Pictorial                      */

static const int PAN_SERIF_COVE                =  2; /* Cove                           */
static const int PAN_SERIF_OBTUSE_COVE         =  3; /* Obtuse Cove                    */
static const int PAN_SERIF_SQUARE_COVE         =  4; /* Square Cove                    */
static const int PAN_SERIF_OBTUSE_SQUARE_COVE  =  5; /* Obtuse Square Cove             */
static const int PAN_SERIF_SQUARE              =  6; /* Square                         */
static const int PAN_SERIF_THIN                =  7; /* Thin                           */
static const int PAN_SERIF_BONE                =  8; /* Bone                           */
static const int PAN_SERIF_EXAGGERATED         =  9; /* Exaggerated                    */
static const int PAN_SERIF_TRIANGLE            = 10; /* Triangle                       */
static const int PAN_SERIF_NORMAL_SANS         = 11; /* Normal Sans                    */
static const int PAN_SERIF_OBTUSE_SANS         = 12; /* Obtuse Sans                    */
static const int PAN_SERIF_PERP_SANS           = 13; /* Prep Sans                      */
static const int PAN_SERIF_FLARED              = 14; /* Flared                         */
static const int PAN_SERIF_ROUNDED             = 15; /* Rounded                        */

static const int PAN_WEIGHT_VERY_LIGHT         =  2; /* Very Light                     */
static const int PAN_WEIGHT_LIGHT              =  3; /* Light                          */
static const int PAN_WEIGHT_THIN               =  4; /* Thin                           */
static const int PAN_WEIGHT_BOOK               =  5; /* Book                           */
static const int PAN_WEIGHT_MEDIUM             =  6; /* Medium                         */
static const int PAN_WEIGHT_DEMI               =  7; /* Demi                           */
static const int PAN_WEIGHT_BOLD               =  8; /* Bold                           */
static const int PAN_WEIGHT_HEAVY              =  9; /* Heavy                          */
static const int PAN_WEIGHT_BLACK              = 10; /* Black                          */
static const int PAN_WEIGHT_NORD               = 11; /* Nord                           */

static const int PAN_PROP_OLD_STYLE            =  2; /* Old Style                      */
static const int PAN_PROP_MODERN               =  3; /* Modern                         */
static const int PAN_PROP_EVEN_WIDTH           =  4; /* Even Width                     */
static const int PAN_PROP_EXPANDED             =  5; /* Expanded                       */
static const int PAN_PROP_CONDENSED            =  6; /* Condensed                      */
static const int PAN_PROP_VERY_EXPANDED        =  7; /* Very Expanded                  */
static const int PAN_PROP_VERY_CONDENSED       =  8; /* Very Condensed                 */
static const int PAN_PROP_MONOSPACED           =  9; /* Monospaced                     */

static const int PAN_CONTRAST_NONE             =  2; /* None                           */
static const int PAN_CONTRAST_VERY_LOW         =  3; /* Very Low                       */
static const int PAN_CONTRAST_LOW              =  4; /* Low                            */
static const int PAN_CONTRAST_MEDIUM_LOW       =  5; /* Medium Low                     */
static const int PAN_CONTRAST_MEDIUM           =  6; /* Medium                         */
static const int PAN_CONTRAST_MEDIUM_HIGH      =  7; /* Mediim High                    */
static const int PAN_CONTRAST_HIGH             =  8; /* High                           */
static const int PAN_CONTRAST_VERY_HIGH        =  9; /* Very High                      */

static const int PAN_STROKE_GRADUAL_DIAG       =  2; /* Gradual/Diagonal               */
static const int PAN_STROKE_GRADUAL_TRAN       =  3; /* Gradual/Transitional           */
static const int PAN_STROKE_GRADUAL_VERT       =  4; /* Gradual/Vertical               */
static const int PAN_STROKE_GRADUAL_HORZ       =  5; /* Gradual/Horizontal             */
static const int PAN_STROKE_RAPID_VERT         =  6; /* Rapid/Vertical                 */
static const int PAN_STROKE_RAPID_HORZ         =  7; /* Rapid/Horizontal               */
static const int PAN_STROKE_INSTANT_VERT       =  8; /* Instant/Vertical               */

static const int PAN_STRAIGHT_ARMS_HORZ         = 2; /* Straight Arms/Horizontal       */
static const int PAN_STRAIGHT_ARMS_WEDGE        = 3; /* Straight Arms/Wedge            */
static const int PAN_STRAIGHT_ARMS_VERT         = 4; /* Straight Arms/Vertical         */
static const int PAN_STRAIGHT_ARMS_SINGLE_SERIF = 5; /* Straight Arms/Single-Serif     */
static const int PAN_STRAIGHT_ARMS_DOUBLE_SERIF = 6; /* Straight Arms/Double-Serif     */
static const int PAN_BENT_ARMS_HORZ             = 7; /* Non-Straight Arms/Horizontal   */
static const int PAN_BENT_ARMS_WEDGE            = 8; /* Non-Straight Arms/Wedge        */
static const int PAN_BENT_ARMS_VERT             = 9; /* Non-Straight Arms/Vertical     */
static const int PAN_BENT_ARMS_SINGLE_SERIF     =10; /* Non-Straight Arms/Single-Serif */
static const int PAN_BENT_ARMS_DOUBLE_SERIF     =11; /* Non-Straight Arms/Double-Serif */

static const int PAN_LETT_NORMAL_CONTACT        = 2; /* Normal/Contact                 */
static const int PAN_LETT_NORMAL_WEIGHTED       = 3; /* Normal/Weighted                */
static const int PAN_LETT_NORMAL_BOXED          = 4; /* Normal/Boxed                   */
static const int PAN_LETT_NORMAL_FLATTENED      = 5; /* Normal/Flattened               */
static const int PAN_LETT_NORMAL_ROUNDED        = 6; /* Normal/Rounded                 */
static const int PAN_LETT_NORMAL_OFF_CENTER     = 7; /* Normal/Off Center              */
static const int PAN_LETT_NORMAL_SQUARE         = 8; /* Normal/Square                  */
static const int PAN_LETT_OBLIQUE_CONTACT       = 9; /* Oblique/Contact                */
static const int PAN_LETT_OBLIQUE_WEIGHTED      =10; /* Oblique/Weighted               */
static const int PAN_LETT_OBLIQUE_BOXED         =11; /* Oblique/Boxed                  */
static const int PAN_LETT_OBLIQUE_FLATTENED     =12; /* Oblique/Flattened              */
static const int PAN_LETT_OBLIQUE_ROUNDED       =13; /* Oblique/Rounded                */
static const int PAN_LETT_OBLIQUE_OFF_CENTER    =14; /* Oblique/Off Center             */
static const int PAN_LETT_OBLIQUE_SQUARE        =15; /* Oblique/Square                 */

static const int PAN_MIDLINE_STANDARD_TRIMMED    =2; /* Standard/Trimmed               */
static const int PAN_MIDLINE_STANDARD_POINTED    =3; /* Standard/Pointed               */
static const int PAN_MIDLINE_STANDARD_SERIFED    =4; /* Standard/Serifed               */
static const int PAN_MIDLINE_HIGH_TRIMMED        =5; /* High/Trimmed                   */
static const int PAN_MIDLINE_HIGH_POINTED        =6; /* High/Pointed                   */
static const int PAN_MIDLINE_HIGH_SERIFED        =7; /* High/Serifed                   */
static const int PAN_MIDLINE_CONSTANT_TRIMMED    =8; /* Constant/Trimmed               */
static const int PAN_MIDLINE_CONSTANT_POINTED    =9; /* Constant/Pointed               */
static const int PAN_MIDLINE_CONSTANT_SERIFED   =10; /* Constant/Serifed               */
static const int PAN_MIDLINE_LOW_TRIMMED        =11; /* Low/Trimmed                    */
static const int PAN_MIDLINE_LOW_POINTED        =12; /* Low/Pointed                    */
static const int PAN_MIDLINE_LOW_SERIFED        =13; /* Low/Serifed                    */

static const int PAN_XHEIGHT_CONSTANT_SMALL     = 2; /* Constant/Small                 */
static const int PAN_XHEIGHT_CONSTANT_STD       = 3; /* Constant/Standard              */
static const int PAN_XHEIGHT_CONSTANT_LARGE     = 4; /* Constant/Large                 */
static const int PAN_XHEIGHT_DUCKING_SMALL      = 5; /* Ducking/Small                  */
static const int PAN_XHEIGHT_DUCKING_STD        = 6; /* Ducking/Standard               */
static const int PAN_XHEIGHT_DUCKING_LARGE      = 7; /* Ducking/Large                  */
]]

ffi.cdef[[
static const int ELF_VENDOR_SIZE  =   4;

/* The extended logical font       */
/* An extension of the ENUMLOGFONT */

typedef struct tagEXTLOGFONTA {
    LOGFONTA    elfLogFont;
    BYTE        elfFullName[LF_FULLFACESIZE];
    BYTE        elfStyle[LF_FACESIZE];
    DWORD       elfVersion;     /* 0 for the first release of NT */
    DWORD       elfStyleSize;
    DWORD       elfMatch;
    DWORD       elfReserved;
    BYTE        elfVendorId[ELF_VENDOR_SIZE];
    DWORD       elfCulture;     /* 0 for Latin                   */
    PANOSE      elfPanose;
} EXTLOGFONTA, *PEXTLOGFONTA,  *NPEXTLOGFONTA,  *LPEXTLOGFONTA;

typedef struct tagEXTLOGFONTW {
    LOGFONTW    elfLogFont;
    WCHAR       elfFullName[LF_FULLFACESIZE];
    WCHAR       elfStyle[LF_FACESIZE];
    DWORD       elfVersion;     /* 0 for the first release of NT */
    DWORD       elfStyleSize;
    DWORD       elfMatch;
    DWORD       elfReserved;
    BYTE        elfVendorId[ELF_VENDOR_SIZE];
    DWORD       elfCulture;     /* 0 for Latin                   */
    PANOSE      elfPanose;
} EXTLOGFONTW, *PEXTLOGFONTW,  *NPEXTLOGFONTW,  *LPEXTLOGFONTW;
]]

--[[
#ifdef UNICODE
typedef EXTLOGFONTW EXTLOGFONT;
typedef PEXTLOGFONTW PEXTLOGFONT;
typedef NPEXTLOGFONTW NPEXTLOGFONT;
typedef LPEXTLOGFONTW LPEXTLOGFONT;
#else
typedef EXTLOGFONTA EXTLOGFONT;
typedef PEXTLOGFONTA PEXTLOGFONT;
typedef NPEXTLOGFONTA NPEXTLOGFONT;
typedef LPEXTLOGFONTA LPEXTLOGFONT;
#endif // UNICODE
--]]


ffi.cdef[[
static const int ELF_VERSION        = 0;
static const int ELF_CULTURE_LATIN  = 0;

/* EnumFonts Masks */
static const int RASTER_FONTTYPE    = 0x0001;
static const int DEVICE_FONTTYPE    = 0x0002;
static const int TRUETYPE_FONTTYPE  = 0x0004;
]]

local function LOBYTE(val) return ffi.cast("BYTE",band(val,0xff)) end

function exports.GetRValue(rgb)    return  LOBYTE(rgb) end
function exports.GetGValue(rgb)    return  LOBYTE(rshift(rgb, 8)) end
function exports.GetBValue(rgb)    return  LOBYTE(rshift(rgb,16)) end

function exports.RGB(r,g,b)         return  ffi.cast("COLORREF",bor(ffi.cast("BYTE",r),lshift(ffi.cast("BYTE",g),8),lshift(b,16))) end
function exports.PALETTERGB(r,g,b)   return bor(0x02000000 , RGB(r,g,b)) end
--function exports.PALETTEINDEX(i)     ffi.cast("COLORREF", bor(0x01000000, (DWORD)(WORD)(i)))

ffi.cdef[[
/* palette entry flags */

static const int PC_RESERVED    = 0x01;    /* palette index used for animation */
static const int PC_EXPLICIT    = 0x02;    /* palette index is explicit to device */
static const int PC_NOCOLLAPSE  = 0x04;    /* do not match color to system palette */
]]




ffi.cdef[[
/* Background Modes */
static const int TRANSPARENT        = 1;
static const int OPAQUE             = 2;
static const int BKMODE_LAST        = 2;

/* Graphics Modes */

static const int GM_COMPATIBLE      = 1;
static const int GM_ADVANCED        = 2;
static const int GM_LAST            = 2;

/* PolyDraw and GetPath point types */
static const int PT_CLOSEFIGURE     = 0x01;
static const int PT_LINETO          = 0x02;
static const int PT_BEZIERTO        = 0x04;
static const int PT_MOVETO          = 0x06;

/* Mapping Modes */
static const int MM_TEXT            = 1;
static const int MM_LOMETRIC        = 2;
static const int MM_HIMETRIC        = 3;
static const int MM_LOENGLISH       = 4;
static const int MM_HIENGLISH       = 5;
static const int MM_TWIPS           = 6;
static const int MM_ISOTROPIC       = 7;
static const int MM_ANISOTROPIC     = 8;

/* Min and Max Mapping Mode values */
static const int MM_MIN             = MM_TEXT;
static const int MM_MAX             = MM_ANISOTROPIC;
static const int MM_MAX_FIXEDSCALE  = MM_TWIPS;
]]

ffi.cdef[[
/* Coordinate Modes */
static const int ABSOLUTE         =   1;
static const int RELATIVE         =   2;
]]

ffi.cdef[[
/* Stock Logical Objects */
static const int WHITE_BRUSH       =  0;
static const int LTGRAY_BRUSH      =  1;
static const int GRAY_BRUSH        =  2;
static const int DKGRAY_BRUSH      =  3;
static const int BLACK_BRUSH       =  4;
static const int NULL_BRUSH        =  5;
static const int HOLLOW_BRUSH      =  NULL_BRUSH;
static const int WHITE_PEN         =  6;
static const int BLACK_PEN         =  7;
static const int NULL_PEN          =  8;
static const int OEM_FIXED_FONT    =  10;
static const int ANSI_FIXED_FONT   =  11;
static const int ANSI_VAR_FONT     =  12;
static const int SYSTEM_FONT       =  13;
static const int DEVICE_DEFAULT_FONT= 14;
static const int DEFAULT_PALETTE    = 15;
static const int SYSTEM_FIXED_FONT  = 16;
static const int DEFAULT_GUI_FONT   = 17;



static const int DC_BRUSH           = 18;
static const int DC_PEN             = 19;

static const int STOCK_LAST         = 19;
]]

ffi.cdef[[
static const int CLR_INVALID     = 0xFFFFFFFF;

/* Brush Styles */
static const int BS_SOLID          =  0;
static const int BS_NULL           =  1;
static const int BS_HOLLOW         =  BS_NULL;
static const int BS_HATCHED        =  2;
static const int BS_PATTERN        =  3;
static const int BS_INDEXED        =  4;
static const int BS_DIBPATTERN     =  5;
static const int BS_DIBPATTERNPT   =  6;
static const int BS_PATTERN8X8     =  7;
static const int BS_DIBPATTERN8X8  =  8;
static const int BS_MONOPATTERN    =  9;
]]

ffi.cdef[[
/* Hatch Styles */
static const int HS_HORIZONTAL      = 0;       /* ----- */
static const int HS_VERTICAL        = 1;       /* ||||| */
static const int HS_FDIAGONAL       = 2;       /* \\\\\ */
static const int HS_BDIAGONAL       = 3;       /* ///// */
static const int HS_CROSS           = 4;       /* +++++ */
static const int HS_DIAGCROSS       = 5;       /* xxxxx */
static const int HS_API_MAX         = 12;
]]

ffi.cdef[[
/* Pen Styles */
static const int PS_SOLID            =0;
static const int PS_DASH             =1;      /* -------  */
static const int PS_DOT              =2;       /* .......  */
static const int PS_DASHDOT          =3;       /* _._._._  */
static const int PS_DASHDOTDOT       =4;       /* _.._.._  */
static const int PS_NULL             =5;
static const int PS_INSIDEFRAME      =6;
static const int PS_USERSTYLE        =7;
static const int PS_ALTERNATE        =8;
static const int PS_STYLE_MASK       =0x0000000F;

static const int PS_ENDCAP_ROUND     =0x00000000;
static const int PS_ENDCAP_SQUARE    =0x00000100;
static const int PS_ENDCAP_FLAT      =0x00000200;
static const int PS_ENDCAP_MASK      =0x00000F00;

static const int PS_JOIN_ROUND       =0x00000000;
static const int PS_JOIN_BEVEL       =0x00001000;
static const int PS_JOIN_MITER       =0x00002000;
static const int PS_JOIN_MASK        =0x0000F000;

static const int PS_COSMETIC         =0x00000000;
static const int PS_GEOMETRIC        =0x00010000;
static const int PS_TYPE_MASK        =0x000F0000;
]]

ffi.cdef[[
static const int AD_COUNTERCLOCKWISE =1;
static const int AD_CLOCKWISE        =2;
]]

ffi.cdef[[
/* Device Parameters for GetDeviceCaps() */
static const int DRIVERVERSION =0;     /* Device driver version                    */
static const int TECHNOLOGY    =2;     /* Device classification                    */
static const int HORZSIZE      =4;     /* Horizontal size in millimeters           */
static const int VERTSIZE      =6;     /* Vertical size in millimeters             */
static const int HORZRES       =8;     /* Horizontal width in pixels               */
static const int VERTRES       =10;    /* Vertical height in pixels                */
static const int BITSPIXEL     =12;    /* Number of bits per pixel                 */
static const int PLANES        =14;    /* Number of planes                         */
static const int NUMBRUSHES    =16;    /* Number of brushes the device has         */
static const int NUMPENS       =18;    /* Number of pens the device has            */
static const int NUMMARKERS    =20;    /* Number of markers the device has         */
static const int NUMFONTS      =22;    /* Number of fonts the device has           */
static const int NUMCOLORS     =24;    /* Number of colors the device supports     */
static const int PDEVICESIZE   =26;    /* Size required for device descriptor      */
static const int CURVECAPS     =28;    /* Curve capabilities                       */
static const int LINECAPS      =30;    /* Line capabilities                        */
static const int POLYGONALCAPS =32;    /* Polygonal capabilities                   */
static const int TEXTCAPS      =34;    /* Text capabilities                        */
static const int CLIPCAPS      =36;    /* Clipping capabilities                    */
static const int RASTERCAPS    =38;    /* Bitblt capabilities                      */
static const int ASPECTX       =40;    /* Length of the X leg                      */
static const int ASPECTY       =42;    /* Length of the Y leg                      */
static const int ASPECTXY      =44;    /* Length of the hypotenuse                 */

static const int LOGPIXELSX    =88;    /* Logical pixels/inch in X                 */
static const int LOGPIXELSY    =90;    /* Logical pixels/inch in Y                 */

static const int SIZEPALETTE  =104;    /* Number of entries in physical palette    */
static const int NUMRESERVED  =106;    /* Number of reserved entries in palette    */
static const int COLORRES     =108;    /* Actual color resolution                  */

// Printing related DeviceCaps. These replace the appropriate Escapes

static const int PHYSICALWIDTH   =110; /* Physical Width in device units           */
static const int PHYSICALHEIGHT  =111; /* Physical Height in device units          */
static const int PHYSICALOFFSETX =112; /* Physical Printable Area x margin         */
static const int PHYSICALOFFSETY =113; /* Physical Printable Area y margin         */
static const int SCALINGFACTORX  =114; /* Scaling factor x                         */
static const int SCALINGFACTORY  =115; /* Scaling factor y                         */

// Display driver specific

static const int VREFRESH        =116;  /* Current vertical refresh rate of the    */
                             /* display device (for displays only) in Hz*/
static const int DESKTOPVERTRES  =117;  /* Horizontal width of entire desktop in   */
                             /* pixels                                  */
static const int DESKTOPHORZRES  =118;  /* Vertical height of entire desktop in    */
                             /* pixels                                  */
static const int BLTALIGNMENT    =119;  /* Preferred blt alignment                 */


static const int SHADEBLENDCAPS  =120;  /* Shading and blending caps               */
static const int COLORMGMTCAPS   =121;  /* Color Management caps                   */
]]

--[[
#ifndef NOGDICAPMASKS

/* Device Capability Masks: */

/* Device Technologies */
#define DT_PLOTTER          0   /* Vector plotter                   */
#define DT_RASDISPLAY       1   /* Raster display                   */
#define DT_RASPRINTER       2   /* Raster printer                   */
#define DT_RASCAMERA        3   /* Raster camera                    */
#define DT_CHARSTREAM       4   /* Character-stream, PLP            */
#define DT_METAFILE         5   /* Metafile, VDM                    */
#define DT_DISPFILE         6   /* Display-file                     */

/* Curve Capabilities */
#define CC_NONE             0   /* Curves not supported             */
#define CC_CIRCLES          1   /* Can do circles                   */
#define CC_PIE              2   /* Can do pie wedges                */
#define CC_CHORD            4   /* Can do chord arcs                */
#define CC_ELLIPSES         8   /* Can do ellipese                  */
#define CC_WIDE             16  /* Can do wide lines                */
#define CC_STYLED           32  /* Can do styled lines              */
#define CC_WIDESTYLED       64  /* Can do wide styled lines         */
#define CC_INTERIORS        128 /* Can do interiors                 */
#define CC_ROUNDRECT        256 /*                                  */

/* Line Capabilities */
#define LC_NONE             0   /* Lines not supported              */
#define LC_POLYLINE         2   /* Can do polylines                 */
#define LC_MARKER           4   /* Can do markers                   */
#define LC_POLYMARKER       8   /* Can do polymarkers               */
#define LC_WIDE             16  /* Can do wide lines                */
#define LC_STYLED           32  /* Can do styled lines              */
#define LC_WIDESTYLED       64  /* Can do wide styled lines         */
#define LC_INTERIORS        128 /* Can do interiors                 */

/* Polygonal Capabilities */
#define PC_NONE             0   /* Polygonals not supported         */
#define PC_POLYGON          1   /* Can do polygons                  */
#define PC_RECTANGLE        2   /* Can do rectangles                */
#define PC_WINDPOLYGON      4   /* Can do winding polygons          */
#define PC_TRAPEZOID        4   /* Can do trapezoids                */
#define PC_SCANLINE         8   /* Can do scanlines                 */
#define PC_WIDE             16  /* Can do wide borders              */
#define PC_STYLED           32  /* Can do styled borders            */
#define PC_WIDESTYLED       64  /* Can do wide styled borders       */
#define PC_INTERIORS        128 /* Can do interiors                 */
#define PC_POLYPOLYGON      256 /* Can do polypolygons              */
#define PC_PATHS            512 /* Can do paths                     */

/* Clipping Capabilities */
#define CP_NONE             0   /* No clipping of output            */
#define CP_RECTANGLE        1   /* Output clipped to rects          */
#define CP_REGION           2   /* obsolete                         */

/* Text Capabilities */
#define TC_OP_CHARACTER     0x00000001  /* Can do OutputPrecision   CHARACTER      */
#define TC_OP_STROKE        0x00000002  /* Can do OutputPrecision   STROKE         */
#define TC_CP_STROKE        0x00000004  /* Can do ClipPrecision     STROKE         */
#define TC_CR_90            0x00000008  /* Can do CharRotAbility    90             */
#define TC_CR_ANY           0x00000010  /* Can do CharRotAbility    ANY            */
#define TC_SF_X_YINDEP      0x00000020  /* Can do ScaleFreedom      X_YINDEPENDENT */
#define TC_SA_DOUBLE        0x00000040  /* Can do ScaleAbility      DOUBLE         */
#define TC_SA_INTEGER       0x00000080  /* Can do ScaleAbility      INTEGER        */
#define TC_SA_CONTIN        0x00000100  /* Can do ScaleAbility      CONTINUOUS     */
#define TC_EA_DOUBLE        0x00000200  /* Can do EmboldenAbility   DOUBLE         */
#define TC_IA_ABLE          0x00000400  /* Can do ItalisizeAbility  ABLE           */
#define TC_UA_ABLE          0x00000800  /* Can do UnderlineAbility  ABLE           */
#define TC_SO_ABLE          0x00001000  /* Can do StrikeOutAbility  ABLE           */
#define TC_RA_ABLE          0x00002000  /* Can do RasterFontAble    ABLE           */
#define TC_VA_ABLE          0x00004000  /* Can do VectorFontAble    ABLE           */
#define TC_RESERVED         0x00008000
#define TC_SCROLLBLT        0x00010000  /* Don't do text scroll with blt           */

#endif /* NOGDICAPMASKS */
--]]

ffi.cdef[[
/* Raster Capabilities */
//static const int RC_NONE          = 0;
static const int RC_BITBLT           = 1;       /* Can do standard BLT.             */
static const int RC_BANDING          = 2;       /* Device requires banding support  */
static const int RC_SCALING          = 4;       /* Device requires scaling support  */
static const int RC_BITMAP64         = 8;       /* Device can support >64K bitmap   */
static const int RC_GDI20_OUTPUT     = 0x0010;      /* has 2.0 output calls         */
static const int RC_GDI20_STATE      = 0x0020;
static const int RC_SAVEBITMAP       = 0x0040;
static const int RC_DI_BITMAP        = 0x0080;      /* supports DIB to memory       */
static const int RC_PALETTE          = 0x0100;      /* supports a palette           */
static const int RC_DIBTODEV         = 0x0200;      /* supports DIBitsToDevice      */
static const int RC_BIGFONT          = 0x0400;      /* supports >64K fonts          */
static const int RC_STRETCHBLT       = 0x0800;      /* supports StretchBlt          */
static const int RC_FLOODFILL        = 0x1000;      /* supports FloodFill           */
static const int RC_STRETCHDIB       = 0x2000;      /* supports StretchDIBits       */
static const int RC_OP_DX_OUTPUT     = 0x4000;
static const int RC_DEVBITS          = 0x8000;



/* Shading and blending caps */
static const int SB_NONE             = 0x00000000;
static const int SB_CONST_ALPHA      = 0x00000001;
static const int SB_PIXEL_ALPHA      = 0x00000002;
static const int SB_PREMULT_ALPHA    = 0x00000004;

static const int SB_GRAD_RECT        = 0x00000010;
static const int SB_GRAD_TRI         = 0x00000020;

/* Color Management caps */
static const int CM_NONE             = 0x00000000;
static const int CM_DEVICE_ICM       = 0x00000001;
static const int CM_GAMMA_RAMP       = 0x00000002;
static const int CM_CMYK_COLOR       = 0x00000004;
]]

ffi.cdef[[
/* DIB color table identifiers */

static const int DIB_RGB_COLORS     = 0; /* color table in RGBs */
static const int DIB_PAL_COLORS     = 1; /* color table in palette indices */

/* constants for Get/SetSystemPaletteUse() */

static const int SYSPAL_ERROR   = 0;
static const int SYSPAL_STATIC  = 1;
static const int SYSPAL_NOSTATIC =2;
static const int SYSPAL_NOSTATIC256 =3;

/* constants for CreateDIBitmap */
static const int CBM_INIT       = 0x04L;   /* initialize bitmap */


/* ExtFloodFill style flags */
static const int  FLOODFILLBORDER  = 0;
static const int  FLOODFILLSURFACE = 1;
]]

if not CCHDEVICENAME then
CCHDEVICENAME = true;
ffi.cdef[[
/* size of a device name string */
static const int CCHDEVICENAME = 32;
]]
end

ffi.cdef[[
/* size of a form name string */
static const int CCHFORMNAME = 32;
]]



--#if (_WIN32_WINNT >= ((OSVER(NTDDI_WINXPSP2)) >> 16))
-- will only work past windows XP SP2
ffi.cdef[[
typedef struct _devicemodeA {
    BYTE   dmDeviceName[CCHDEVICENAME];
    WORD dmSpecVersion;
    WORD dmDriverVersion;
    WORD dmSize;
    WORD dmDriverExtra;
    DWORD dmFields;
    union {
      /* printer only fields */
      struct {
        short dmOrientation;
        short dmPaperSize;
        short dmPaperLength;
        short dmPaperWidth;
        short dmScale;
        short dmCopies;
        short dmDefaultSource;
        short dmPrintQuality;
      } ;
      /* display only fields */
      struct {
        POINTL dmPosition;
        DWORD  dmDisplayOrientation;
        DWORD  dmDisplayFixedOutput;
      } ;
    } ;
    short dmColor;
    short dmDuplex;
    short dmYResolution;
    short dmTTOption;
    short dmCollate;
    BYTE   dmFormName[CCHFORMNAME];
    WORD   dmLogPixels;
    DWORD  dmBitsPerPel;
    DWORD  dmPelsWidth;
    DWORD  dmPelsHeight;
    union {
        DWORD  dmDisplayFlags;
        DWORD  dmNup;
    } ;
    DWORD  dmDisplayFrequency;

    DWORD  dmICMMethod;
    DWORD  dmICMIntent;
    DWORD  dmMediaType;
    DWORD  dmDitherType;
    DWORD  dmReserved1;
    DWORD  dmReserved2;

    DWORD  dmPanningWidth;
    DWORD  dmPanningHeight;


} DEVMODEA, *PDEVMODEA, *NPDEVMODEA, *LPDEVMODEA;
]]

ffi.cdef[[
typedef struct _devicemodeW {
    WCHAR  dmDeviceName[CCHDEVICENAME];
    WORD dmSpecVersion;
    WORD dmDriverVersion;
    WORD dmSize;
    WORD dmDriverExtra;
    DWORD dmFields;
    union {
      /* printer only fields */
      struct {
        short dmOrientation;
        short dmPaperSize;
        short dmPaperLength;
        short dmPaperWidth;
        short dmScale;
        short dmCopies;
        short dmDefaultSource;
        short dmPrintQuality;
      } ;
      /* display only fields */
      struct {
        POINTL dmPosition;
        DWORD  dmDisplayOrientation;
        DWORD  dmDisplayFixedOutput;
      } ;
    } ;
    short dmColor;
    short dmDuplex;
    short dmYResolution;
    short dmTTOption;
    short dmCollate;
    WCHAR  dmFormName[CCHFORMNAME];
    WORD   dmLogPixels;
    DWORD  dmBitsPerPel;
    DWORD  dmPelsWidth;
    DWORD  dmPelsHeight;
    union {
        DWORD  dmDisplayFlags;
        DWORD  dmNup;
    } ;
    DWORD  dmDisplayFrequency;

    DWORD  dmICMMethod;
    DWORD  dmICMIntent;
    DWORD  dmMediaType;
    DWORD  dmDitherType;
    DWORD  dmReserved1;
    DWORD  dmReserved2;

    DWORD  dmPanningWidth;
    DWORD  dmPanningHeight;

} DEVMODEW, *PDEVMODEW, *NPDEVMODEW, *LPDEVMODEW;
]]

--[[
#ifdef UNICODE
typedef DEVMODEW DEVMODE;
typedef PDEVMODEW PDEVMODE;
typedef NPDEVMODEW NPDEVMODE;
typedef LPDEVMODEW LPDEVMODE;
#else
typedef DEVMODEA DEVMODE;
typedef PDEVMODEA PDEVMODE;
typedef NPDEVMODEA NPDEVMODE;
typedef LPDEVMODEA LPDEVMODE;
#endif // UNICODE
--]]




ffi.cdef[[
/* current version of specification */
static const int DM_SPECVERSION = 0x0401;
]]

ffi.cdef[[
static const int DM_SPECVERSION = 0x0400;
]]

--[=[
/* field selection bits */
#define DM_ORIENTATION          0x00000001L
#define DM_PAPERSIZE            0x00000002L
#define DM_PAPERLENGTH          0x00000004L
#define DM_PAPERWIDTH           0x00000008L
#define DM_SCALE                0x00000010L
#if(WINVER >= 0x0500)
#define DM_POSITION             0x00000020L
#define DM_NUP                  0x00000040L
#endif /* WINVER >= 0x0500 */
#if(WINVER >= 0x0501)
#define DM_DISPLAYORIENTATION   0x00000080L
#endif /* WINVER >= 0x0501 */
#define DM_COPIES               0x00000100L
#define DM_DEFAULTSOURCE        0x00000200L
#define DM_PRINTQUALITY         0x00000400L
#define DM_COLOR                0x00000800L
#define DM_DUPLEX               0x00001000L
#define DM_YRESOLUTION          0x00002000L
#define DM_TTOPTION             0x00004000L
#define DM_COLLATE              0x00008000L
#define DM_FORMNAME             0x00010000L
#define DM_LOGPIXELS            0x00020000L
#define DM_BITSPERPEL           0x00040000L
#define DM_PELSWIDTH            0x00080000L
#define DM_PELSHEIGHT           0x00100000L
#define DM_DISPLAYFLAGS         0x00200000L
#define DM_DISPLAYFREQUENCY     0x00400000L
#if(WINVER >= 0x0400)
#define DM_ICMMETHOD            0x00800000L
#define DM_ICMINTENT            0x01000000L
#define DM_MEDIATYPE            0x02000000L
#define DM_DITHERTYPE           0x04000000L
#define DM_PANNINGWIDTH         0x08000000L
#define DM_PANNINGHEIGHT        0x10000000L
#endif /* WINVER >= 0x0400 */
#if(WINVER >= 0x0501)
#define DM_DISPLAYFIXEDOUTPUT   0x20000000L
#endif /* WINVER >= 0x0501 */


/* orientation selections */
#define DMORIENT_PORTRAIT   1
#define DMORIENT_LANDSCAPE  2

/* paper selections */
#define DMPAPER_FIRST                DMPAPER_LETTER
#define DMPAPER_LETTER               1  /* Letter 8 1/2 x 11 in               */
#define DMPAPER_LETTERSMALL          2  /* Letter Small 8 1/2 x 11 in         */
#define DMPAPER_TABLOID              3  /* Tabloid 11 x 17 in                 */
#define DMPAPER_LEDGER               4  /* Ledger 17 x 11 in                  */
#define DMPAPER_LEGAL                5  /* Legal 8 1/2 x 14 in                */
#define DMPAPER_STATEMENT            6  /* Statement 5 1/2 x 8 1/2 in         */
#define DMPAPER_EXECUTIVE            7  /* Executive 7 1/4 x 10 1/2 in        */
#define DMPAPER_A3                   8  /* A3 297 x 420 mm                    */
#define DMPAPER_A4                   9  /* A4 210 x 297 mm                    */
#define DMPAPER_A4SMALL             10  /* A4 Small 210 x 297 mm              */
#define DMPAPER_A5                  11  /* A5 148 x 210 mm                    */
#define DMPAPER_B4                  12  /* B4 (JIS) 250 x 354                 */
#define DMPAPER_B5                  13  /* B5 (JIS) 182 x 257 mm              */
#define DMPAPER_FOLIO               14  /* Folio 8 1/2 x 13 in                */
#define DMPAPER_QUARTO              15  /* Quarto 215 x 275 mm                */
#define DMPAPER_10X14               16  /* 10x14 in                           */
#define DMPAPER_11X17               17  /* 11x17 in                           */
#define DMPAPER_NOTE                18  /* Note 8 1/2 x 11 in                 */
#define DMPAPER_ENV_9               19  /* Envelope #9 3 7/8 x 8 7/8          */
#define DMPAPER_ENV_10              20  /* Envelope #10 4 1/8 x 9 1/2         */
#define DMPAPER_ENV_11              21  /* Envelope #11 4 1/2 x 10 3/8        */
#define DMPAPER_ENV_12              22  /* Envelope #12 4 \276 x 11           */
#define DMPAPER_ENV_14              23  /* Envelope #14 5 x 11 1/2            */
#define DMPAPER_CSHEET              24  /* C size sheet                       */
#define DMPAPER_DSHEET              25  /* D size sheet                       */
#define DMPAPER_ESHEET              26  /* E size sheet                       */
#define DMPAPER_ENV_DL              27  /* Envelope DL 110 x 220mm            */
#define DMPAPER_ENV_C5              28  /* Envelope C5 162 x 229 mm           */
#define DMPAPER_ENV_C3              29  /* Envelope C3  324 x 458 mm          */
#define DMPAPER_ENV_C4              30  /* Envelope C4  229 x 324 mm          */
#define DMPAPER_ENV_C6              31  /* Envelope C6  114 x 162 mm          */
#define DMPAPER_ENV_C65             32  /* Envelope C65 114 x 229 mm          */
#define DMPAPER_ENV_B4              33  /* Envelope B4  250 x 353 mm          */
#define DMPAPER_ENV_B5              34  /* Envelope B5  176 x 250 mm          */
#define DMPAPER_ENV_B6              35  /* Envelope B6  176 x 125 mm          */
#define DMPAPER_ENV_ITALY           36  /* Envelope 110 x 230 mm              */
#define DMPAPER_ENV_MONARCH         37  /* Envelope Monarch 3.875 x 7.5 in    */
#define DMPAPER_ENV_PERSONAL        38  /* 6 3/4 Envelope 3 5/8 x 6 1/2 in    */
#define DMPAPER_FANFOLD_US          39  /* US Std Fanfold 14 7/8 x 11 in      */
#define DMPAPER_FANFOLD_STD_GERMAN  40  /* German Std Fanfold 8 1/2 x 12 in   */
#define DMPAPER_FANFOLD_LGL_GERMAN  41  /* German Legal Fanfold 8 1/2 x 13 in */
#if(WINVER >= 0x0400)
#define DMPAPER_ISO_B4              42  /* B4 (ISO) 250 x 353 mm              */
#define DMPAPER_JAPANESE_POSTCARD   43  /* Japanese Postcard 100 x 148 mm     */
#define DMPAPER_9X11                44  /* 9 x 11 in                          */
#define DMPAPER_10X11               45  /* 10 x 11 in                         */
#define DMPAPER_15X11               46  /* 15 x 11 in                         */
#define DMPAPER_ENV_INVITE          47  /* Envelope Invite 220 x 220 mm       */
#define DMPAPER_RESERVED_48         48  /* RESERVED--DO NOT USE               */
#define DMPAPER_RESERVED_49         49  /* RESERVED--DO NOT USE               */
#define DMPAPER_LETTER_EXTRA        50  /* Letter Extra 9 \275 x 12 in        */
#define DMPAPER_LEGAL_EXTRA         51  /* Legal Extra 9 \275 x 15 in         */
#define DMPAPER_TABLOID_EXTRA       52  /* Tabloid Extra 11.69 x 18 in        */
#define DMPAPER_A4_EXTRA            53  /* A4 Extra 9.27 x 12.69 in           */
#define DMPAPER_LETTER_TRANSVERSE   54  /* Letter Transverse 8 \275 x 11 in   */
#define DMPAPER_A4_TRANSVERSE       55  /* A4 Transverse 210 x 297 mm         */
#define DMPAPER_LETTER_EXTRA_TRANSVERSE 56 /* Letter Extra Transverse 9\275 x 12 in */
#define DMPAPER_A_PLUS              57  /* SuperA/SuperA/A4 227 x 356 mm      */
#define DMPAPER_B_PLUS              58  /* SuperB/SuperB/A3 305 x 487 mm      */
#define DMPAPER_LETTER_PLUS         59  /* Letter Plus 8.5 x 12.69 in         */
#define DMPAPER_A4_PLUS             60  /* A4 Plus 210 x 330 mm               */
#define DMPAPER_A5_TRANSVERSE       61  /* A5 Transverse 148 x 210 mm         */
#define DMPAPER_B5_TRANSVERSE       62  /* B5 (JIS) Transverse 182 x 257 mm   */
#define DMPAPER_A3_EXTRA            63  /* A3 Extra 322 x 445 mm              */
#define DMPAPER_A5_EXTRA            64  /* A5 Extra 174 x 235 mm              */
#define DMPAPER_B5_EXTRA            65  /* B5 (ISO) Extra 201 x 276 mm        */
#define DMPAPER_A2                  66  /* A2 420 x 594 mm                    */
#define DMPAPER_A3_TRANSVERSE       67  /* A3 Transverse 297 x 420 mm         */
#define DMPAPER_A3_EXTRA_TRANSVERSE 68  /* A3 Extra Transverse 322 x 445 mm   */
#endif /* WINVER >= 0x0400 */

#if(WINVER >= 0x0500)
#define DMPAPER_DBL_JAPANESE_POSTCARD 69 /* Japanese Double Postcard 200 x 148 mm */
#define DMPAPER_A6                  70  /* A6 105 x 148 mm                 */
#define DMPAPER_JENV_KAKU2          71  /* Japanese Envelope Kaku #2       */
#define DMPAPER_JENV_KAKU3          72  /* Japanese Envelope Kaku #3       */
#define DMPAPER_JENV_CHOU3          73  /* Japanese Envelope Chou #3       */
#define DMPAPER_JENV_CHOU4          74  /* Japanese Envelope Chou #4       */
#define DMPAPER_LETTER_ROTATED      75  /* Letter Rotated 11 x 8 1/2 11 in */
#define DMPAPER_A3_ROTATED          76  /* A3 Rotated 420 x 297 mm         */
#define DMPAPER_A4_ROTATED          77  /* A4 Rotated 297 x 210 mm         */
#define DMPAPER_A5_ROTATED          78  /* A5 Rotated 210 x 148 mm         */
#define DMPAPER_B4_JIS_ROTATED      79  /* B4 (JIS) Rotated 364 x 257 mm   */
#define DMPAPER_B5_JIS_ROTATED      80  /* B5 (JIS) Rotated 257 x 182 mm   */
#define DMPAPER_JAPANESE_POSTCARD_ROTATED 81 /* Japanese Postcard Rotated 148 x 100 mm */
#define DMPAPER_DBL_JAPANESE_POSTCARD_ROTATED 82 /* Double Japanese Postcard Rotated 148 x 200 mm */
#define DMPAPER_A6_ROTATED          83  /* A6 Rotated 148 x 105 mm         */
#define DMPAPER_JENV_KAKU2_ROTATED  84  /* Japanese Envelope Kaku #2 Rotated */
#define DMPAPER_JENV_KAKU3_ROTATED  85  /* Japanese Envelope Kaku #3 Rotated */
#define DMPAPER_JENV_CHOU3_ROTATED  86  /* Japanese Envelope Chou #3 Rotated */
#define DMPAPER_JENV_CHOU4_ROTATED  87  /* Japanese Envelope Chou #4 Rotated */
#define DMPAPER_B6_JIS              88  /* B6 (JIS) 128 x 182 mm           */
#define DMPAPER_B6_JIS_ROTATED      89  /* B6 (JIS) Rotated 182 x 128 mm   */
#define DMPAPER_12X11               90  /* 12 x 11 in                      */
#define DMPAPER_JENV_YOU4           91  /* Japanese Envelope You #4        */
#define DMPAPER_JENV_YOU4_ROTATED   92  /* Japanese Envelope You #4 Rotated*/
#define DMPAPER_P16K                93  /* PRC 16K 146 x 215 mm            */
#define DMPAPER_P32K                94  /* PRC 32K 97 x 151 mm             */
#define DMPAPER_P32KBIG             95  /* PRC 32K(Big) 97 x 151 mm        */
#define DMPAPER_PENV_1              96  /* PRC Envelope #1 102 x 165 mm    */
#define DMPAPER_PENV_2              97  /* PRC Envelope #2 102 x 176 mm    */
#define DMPAPER_PENV_3              98  /* PRC Envelope #3 125 x 176 mm    */
#define DMPAPER_PENV_4              99  /* PRC Envelope #4 110 x 208 mm    */
#define DMPAPER_PENV_5              100 /* PRC Envelope #5 110 x 220 mm    */
#define DMPAPER_PENV_6              101 /* PRC Envelope #6 120 x 230 mm    */
#define DMPAPER_PENV_7              102 /* PRC Envelope #7 160 x 230 mm    */
#define DMPAPER_PENV_8              103 /* PRC Envelope #8 120 x 309 mm    */
#define DMPAPER_PENV_9              104 /* PRC Envelope #9 229 x 324 mm    */
#define DMPAPER_PENV_10             105 /* PRC Envelope #10 324 x 458 mm   */
#define DMPAPER_P16K_ROTATED        106 /* PRC 16K Rotated                 */
#define DMPAPER_P32K_ROTATED        107 /* PRC 32K Rotated                 */
#define DMPAPER_P32KBIG_ROTATED     108 /* PRC 32K(Big) Rotated            */
#define DMPAPER_PENV_1_ROTATED      109 /* PRC Envelope #1 Rotated 165 x 102 mm */
#define DMPAPER_PENV_2_ROTATED      110 /* PRC Envelope #2 Rotated 176 x 102 mm */
#define DMPAPER_PENV_3_ROTATED      111 /* PRC Envelope #3 Rotated 176 x 125 mm */
#define DMPAPER_PENV_4_ROTATED      112 /* PRC Envelope #4 Rotated 208 x 110 mm */
#define DMPAPER_PENV_5_ROTATED      113 /* PRC Envelope #5 Rotated 220 x 110 mm */
#define DMPAPER_PENV_6_ROTATED      114 /* PRC Envelope #6 Rotated 230 x 120 mm */
#define DMPAPER_PENV_7_ROTATED      115 /* PRC Envelope #7 Rotated 230 x 160 mm */
#define DMPAPER_PENV_8_ROTATED      116 /* PRC Envelope #8 Rotated 309 x 120 mm */
#define DMPAPER_PENV_9_ROTATED      117 /* PRC Envelope #9 Rotated 324 x 229 mm */
#define DMPAPER_PENV_10_ROTATED     118 /* PRC Envelope #10 Rotated 458 x 324 mm */
#endif /* WINVER >= 0x0500 */

#if (WINVER >= 0x0500)
#define DMPAPER_LAST                DMPAPER_PENV_10_ROTATED
#elif (WINVER >= 0x0400)
#define DMPAPER_LAST                DMPAPER_A3_EXTRA_TRANSVERSE
#else
#define DMPAPER_LAST                DMPAPER_FANFOLD_LGL_GERMAN
#endif

#define DMPAPER_USER                256

/* bin selections */
#define DMBIN_FIRST         DMBIN_UPPER
#define DMBIN_UPPER         1
#define DMBIN_ONLYONE       1
#define DMBIN_LOWER         2
#define DMBIN_MIDDLE        3
#define DMBIN_MANUAL        4
#define DMBIN_ENVELOPE      5
#define DMBIN_ENVMANUAL     6
#define DMBIN_AUTO          7
#define DMBIN_TRACTOR       8
#define DMBIN_SMALLFMT      9
#define DMBIN_LARGEFMT      10
#define DMBIN_LARGECAPACITY 11
#define DMBIN_CASSETTE      14
#define DMBIN_FORMSOURCE    15
#define DMBIN_LAST          DMBIN_FORMSOURCE

#define DMBIN_USER          256     /* device specific bins start here */

/* print qualities */
#define DMRES_DRAFT         (-1)
#define DMRES_LOW           (-2)
#define DMRES_MEDIUM        (-3)
#define DMRES_HIGH          (-4)

/* color enable/disable for color printers */
#define DMCOLOR_MONOCHROME  1
#define DMCOLOR_COLOR       2

/* duplex enable */
#define DMDUP_SIMPLEX    1
#define DMDUP_VERTICAL   2
#define DMDUP_HORIZONTAL 3

/* TrueType options */
#define DMTT_BITMAP     1       /* print TT fonts as graphics */
#define DMTT_DOWNLOAD   2       /* download TT fonts as soft fonts */
#define DMTT_SUBDEV     3       /* substitute device fonts for TT fonts */
#if(WINVER >= 0x0400)
#define DMTT_DOWNLOAD_OUTLINE 4 /* download TT fonts as outline soft fonts */
#endif /* WINVER >= 0x0400 */

/* Collation selections */
#define DMCOLLATE_FALSE  0
#define DMCOLLATE_TRUE   1

#if(WINVER >= 0x0501)
/* DEVMODE dmDisplayOrientation specifiations */
#define DMDO_DEFAULT    0
#define DMDO_90         1
#define DMDO_180        2
#define DMDO_270        3

/* DEVMODE dmDisplayFixedOutput specifiations */
#define DMDFO_DEFAULT   0
#define DMDFO_STRETCH   1
#define DMDFO_CENTER    2
#endif /* WINVER >= 0x0501 */

/* DEVMODE dmDisplayFlags flags */

// #define DM_GRAYSCALE            0x00000001 /* This flag is no longer valid */
#define DM_INTERLACED           0x00000002
#define DMDISPLAYFLAGS_TEXTMODE 0x00000004

/* dmNup , multiple logical page per physical page options */
#define DMNUP_SYSTEM        1
#define DMNUP_ONEUP         2


/* ICM methods */
#define DMICMMETHOD_NONE    1   /* ICM disabled */
#define DMICMMETHOD_SYSTEM  2   /* ICM handled by system */
#define DMICMMETHOD_DRIVER  3   /* ICM handled by driver */
#define DMICMMETHOD_DEVICE  4   /* ICM handled by device */

#define DMICMMETHOD_USER  256   /* Device-specific methods start here */

/* ICM Intents */
#define DMICM_SATURATE          1   /* Maximize color saturation */
#define DMICM_CONTRAST          2   /* Maximize color contrast */
#define DMICM_COLORIMETRIC       3   /* Use specific color metric */
#define DMICM_ABS_COLORIMETRIC   4   /* Use specific color metric */

#define DMICM_USER        256   /* Device-specific intents start here */

/* Media types */

#define DMMEDIA_STANDARD      1   /* Standard paper */
#define DMMEDIA_TRANSPARENCY  2   /* Transparency */
#define DMMEDIA_GLOSSY        3   /* Glossy paper */

#define DMMEDIA_USER        256   /* Device-specific media start here */

/* Dither types */
#define DMDITHER_NONE       1      /* No dithering */
#define DMDITHER_COARSE     2      /* Dither with a coarse brush */
#define DMDITHER_FINE       3      /* Dither with a fine brush */
#define DMDITHER_LINEART    4      /* LineArt dithering */
#define DMDITHER_ERRORDIFFUSION 5  /* LineArt dithering */
#define DMDITHER_RESERVED6      6      /* LineArt dithering */
#define DMDITHER_RESERVED7      7      /* LineArt dithering */
#define DMDITHER_RESERVED8      8      /* LineArt dithering */
#define DMDITHER_RESERVED9      9      /* LineArt dithering */
#define DMDITHER_GRAYSCALE  10     /* Device does grayscaling */

#define DMDITHER_USER     256   /* Device-specific dithers start here */
--]=]


ffi.cdef[[
typedef struct _DISPLAY_DEVICEA {
    DWORD  cb;
    CHAR   DeviceName[32];
    CHAR   DeviceString[128];
    DWORD  StateFlags;
    CHAR   DeviceID[128];
    CHAR   DeviceKey[128];
} DISPLAY_DEVICEA, *PDISPLAY_DEVICEA, *LPDISPLAY_DEVICEA;

typedef struct _DISPLAY_DEVICEW {
    DWORD  cb;
    WCHAR  DeviceName[32];
    WCHAR  DeviceString[128];
    DWORD  StateFlags;
    WCHAR  DeviceID[128];
    WCHAR  DeviceKey[128];
} DISPLAY_DEVICEW, *PDISPLAY_DEVICEW, *LPDISPLAY_DEVICEW;
]]

--[[
#ifdef UNICODE
typedef DISPLAY_DEVICEW DISPLAY_DEVICE;
typedef PDISPLAY_DEVICEW PDISPLAY_DEVICE;
typedef LPDISPLAY_DEVICEW LPDISPLAY_DEVICE;
#else
typedef DISPLAY_DEVICEA DISPLAY_DEVICE;
typedef PDISPLAY_DEVICEA PDISPLAY_DEVICE;
typedef LPDISPLAY_DEVICEA LPDISPLAY_DEVICE;
#endif // UNICODE
--]]


ffi.cdef[[
static const int DISPLAY_DEVICE_ATTACHED_TO_DESKTOP      = 0x00000001;
static const int DISPLAY_DEVICE_MULTI_DRIVER             = 0x00000002;
static const int DISPLAY_DEVICE_PRIMARY_DEVICE           = 0x00000004;
static const int DISPLAY_DEVICE_MIRRORING_DRIVER         = 0x00000008;
static const int DISPLAY_DEVICE_VGA_COMPATIBLE           = 0x00000010;

static const int DISPLAY_DEVICE_REMOVABLE                = 0x00000020;


static const int DISPLAY_DEVICE_ACC_DRIVER               = 0x00000040;

static const int DISPLAY_DEVICE_MODESPRUNED              = 0x08000000;

static const int DISPLAY_DEVICE_RDPUDD                   = 0x01000000;
static const int DISPLAY_DEVICE_REMOTE                   = 0x04000000;
static const int DISPLAY_DEVICE_DISCONNECT               = 0x02000000;

static const int DISPLAY_DEVICE_TS_COMPATIBLE            = 0x00200000;

static const int DISPLAY_DEVICE_UNSAFE_MODES_ON          = 0x00080000;


/* Child device state */

static const int DISPLAY_DEVICE_ACTIVE              = 0x00000001;
static const int DISPLAY_DEVICE_ATTACHED            = 0x00000002;
]]

ffi.cdef[[
static const int DISPLAYCONFIG_MAXPATH = 1024;        // Maximum display path in system.
                                          // Max adapter (16) * Max source (16) *
                                          // Max clone pre source (4)


typedef struct DISPLAYCONFIG_RATIONAL
{
    UINT32    Numerator;
    UINT32    Denominator;
} DISPLAYCONFIG_RATIONAL;

typedef enum
{
    DISPLAYCONFIG_OUTPUT_TECHNOLOGY_OTHER                   = -1,
    DISPLAYCONFIG_OUTPUT_TECHNOLOGY_HD15                    =  0,
    DISPLAYCONFIG_OUTPUT_TECHNOLOGY_SVIDEO                  =  1,
    DISPLAYCONFIG_OUTPUT_TECHNOLOGY_COMPOSITE_VIDEO         =  2,
    DISPLAYCONFIG_OUTPUT_TECHNOLOGY_COMPONENT_VIDEO         =  3,
    DISPLAYCONFIG_OUTPUT_TECHNOLOGY_DVI                     =  4,
    DISPLAYCONFIG_OUTPUT_TECHNOLOGY_HDMI                    =  5,
    DISPLAYCONFIG_OUTPUT_TECHNOLOGY_LVDS                    =  6,
    DISPLAYCONFIG_OUTPUT_TECHNOLOGY_D_JPN                   =  8,
    DISPLAYCONFIG_OUTPUT_TECHNOLOGY_SDI                     =  9,
    DISPLAYCONFIG_OUTPUT_TECHNOLOGY_DISPLAYPORT_EXTERNAL    = 10,
    DISPLAYCONFIG_OUTPUT_TECHNOLOGY_DISPLAYPORT_EMBEDDED    = 11,
    DISPLAYCONFIG_OUTPUT_TECHNOLOGY_UDI_EXTERNAL            = 12,
    DISPLAYCONFIG_OUTPUT_TECHNOLOGY_UDI_EMBEDDED            = 13,
    DISPLAYCONFIG_OUTPUT_TECHNOLOGY_SDTVDONGLE              = 14,
    DISPLAYCONFIG_OUTPUT_TECHNOLOGY_MIRACAST                = 15,
	DISPLAYCONFIG_OUTPUT_TECHNOLOGY_INDIRECT_WIRED          = 16,
    DISPLAYCONFIG_OUTPUT_TECHNOLOGY_INTERNAL                = 0x80000000,
    DISPLAYCONFIG_OUTPUT_TECHNOLOGY_FORCE_UINT32            = 0xFFFFFFFF
} DISPLAYCONFIG_VIDEO_OUTPUT_TECHNOLOGY;
]]

ffi.cdef[[
typedef enum
{
    DISPLAYCONFIG_SCANLINE_ORDERING_UNSPECIFIED                 = 0,
    DISPLAYCONFIG_SCANLINE_ORDERING_PROGRESSIVE                 = 1,
    DISPLAYCONFIG_SCANLINE_ORDERING_INTERLACED                  = 2,
    DISPLAYCONFIG_SCANLINE_ORDERING_INTERLACED_UPPERFIELDFIRST  = DISPLAYCONFIG_SCANLINE_ORDERING_INTERLACED,
    DISPLAYCONFIG_SCANLINE_ORDERING_INTERLACED_LOWERFIELDFIRST  = 3,
    DISPLAYCONFIG_SCANLINE_ORDERING_FORCE_UINT32                = 0xFFFFFFFF
} DISPLAYCONFIG_SCANLINE_ORDERING;
]]

ffi.cdef[[
typedef struct DISPLAYCONFIG_2DREGION
{
    UINT32 cx;
    UINT32 cy;
} DISPLAYCONFIG_2DREGION;
]]

ffi.cdef[[
typedef struct DISPLAYCONFIG_VIDEO_SIGNAL_INFO
{
    UINT64                          pixelRate;
    DISPLAYCONFIG_RATIONAL          hSyncFreq;
    DISPLAYCONFIG_RATIONAL          vSyncFreq;
    DISPLAYCONFIG_2DREGION          activeSize;
    DISPLAYCONFIG_2DREGION          totalSize;

    union
    {
        struct
        {
            UINT32 videoStandard : 16;

            // Vertical refresh frequency divider
            UINT32 vSyncFreqDivider : 6;

            UINT32 reserved : 10;
        } AdditionalSignalInfo;

        UINT32 videoStandard;
    } ;

    // Scan line ordering (e.g. progressive, interlaced).
    DISPLAYCONFIG_SCANLINE_ORDERING scanLineOrdering;
} DISPLAYCONFIG_VIDEO_SIGNAL_INFO;
]]

ffi.cdef[[
typedef enum
{
    DISPLAYCONFIG_SCALING_IDENTITY                  = 1,
    DISPLAYCONFIG_SCALING_CENTERED                  = 2,
    DISPLAYCONFIG_SCALING_STRETCHED                 = 3,
    DISPLAYCONFIG_SCALING_ASPECTRATIOCENTEREDMAX    = 4,
    DISPLAYCONFIG_SCALING_CUSTOM                    = 5,
    DISPLAYCONFIG_SCALING_PREFERRED                 = 128,
    DISPLAYCONFIG_SCALING_FORCE_UINT32              = 0xFFFFFFFF
} DISPLAYCONFIG_SCALING;

typedef enum
{
    DISPLAYCONFIG_ROTATION_IDENTITY     = 1,
    DISPLAYCONFIG_ROTATION_ROTATE90     = 2,
    DISPLAYCONFIG_ROTATION_ROTATE180    = 3,
    DISPLAYCONFIG_ROTATION_ROTATE270    = 4,
    DISPLAYCONFIG_ROTATION_FORCE_UINT32 = 0xFFFFFFFF
} DISPLAYCONFIG_ROTATION;

typedef enum
{
    DISPLAYCONFIG_MODE_INFO_TYPE_SOURCE        = 1,
    DISPLAYCONFIG_MODE_INFO_TYPE_TARGET        = 2,
    DISPLAYCONFIG_MODE_INFO_TYPE_DESKTOP_IMAGE = 3,
    DISPLAYCONFIG_MODE_INFO_TYPE_FORCE_UINT32 = 0xFFFFFFFF
} DISPLAYCONFIG_MODE_INFO_TYPE;

typedef enum
{
    DISPLAYCONFIG_PIXELFORMAT_8BPP          = 1,
    DISPLAYCONFIG_PIXELFORMAT_16BPP         = 2,
    DISPLAYCONFIG_PIXELFORMAT_24BPP         = 3,
    DISPLAYCONFIG_PIXELFORMAT_32BPP         = 4,
    DISPLAYCONFIG_PIXELFORMAT_NONGDI        = 5,
    DISPLAYCONFIG_PIXELFORMAT_FORCE_UINT32  = 0xffffffff
} DISPLAYCONFIG_PIXELFORMAT;
]]

ffi.cdef[[
typedef struct DISPLAYCONFIG_SOURCE_MODE
{
    UINT32                      width;
    UINT32                      height;
    DISPLAYCONFIG_PIXELFORMAT   pixelFormat;
    POINTL                      position;
} DISPLAYCONFIG_SOURCE_MODE;

typedef struct DISPLAYCONFIG_TARGET_MODE
{
    DISPLAYCONFIG_VIDEO_SIGNAL_INFO   targetVideoSignalInfo;
} DISPLAYCONFIG_TARGET_MODE;

typedef struct DISPLAYCONFIG_DESKTOP_IMAGE_INFO
{
    POINTL PathSourceSize;
    RECTL DesktopImageRegion;
    RECTL DesktopImageClip;
} DISPLAYCONFIG_DESKTOP_IMAGE_INFO;

typedef struct DISPLAYCONFIG_MODE_INFO
{
    DISPLAYCONFIG_MODE_INFO_TYPE    infoType;
    UINT32                          id;
    LUID                            adapterId;
    union
    {
        DISPLAYCONFIG_TARGET_MODE   targetMode;
        DISPLAYCONFIG_SOURCE_MODE   sourceMode;
        DISPLAYCONFIG_DESKTOP_IMAGE_INFO    desktopImageInfo;
    } ;
} DISPLAYCONFIG_MODE_INFO;
]]

ffi.cdef[[
static const int DISPLAYCONFIG_PATH_MODE_IDX_INVALID            = 0xffffffff;
static const int DISPLAYCONFIG_PATH_TARGET_MODE_IDX_INVALID     = 0xffff;
static const int DISPLAYCONFIG_PATH_DESKTOP_IMAGE_IDX_INVALID   = 0xffff;
static const int DISPLAYCONFIG_PATH_SOURCE_MODE_IDX_INVALID     = 0xffff;
static const int DISPLAYCONFIG_PATH_CLONE_GROUP_INVALID         = 0xffff;
]]

ffi.cdef[[
typedef struct DISPLAYCONFIG_PATH_SOURCE_INFO
{
    LUID    adapterId;
    UINT32  id;
    union
    {
        UINT32 modeInfoIdx;
        struct
        {
            UINT32 cloneGroupId       : 16;
            UINT32 sourceModeInfoIdx  : 16;
        } ;
    } ;

    UINT32  statusFlags;
} DISPLAYCONFIG_PATH_SOURCE_INFO;
]]

ffi.cdef[[
//
// Flags for source info structure (from OS to application through QDC)
//

static const int DISPLAYCONFIG_SOURCE_IN_USE   =  0x00000001;

typedef struct DISPLAYCONFIG_PATH_TARGET_INFO
{
    LUID                                    adapterId;
    UINT32                                  id;
    union
    {
        UINT32                                  modeInfoIdx;
        struct
        {
            UINT32 desktopModeInfoIdx : 16;
            UINT32 targetModeInfoIdx  : 16;
        } ;
    } ;
    DISPLAYCONFIG_VIDEO_OUTPUT_TECHNOLOGY   outputTechnology;
    DISPLAYCONFIG_ROTATION                  rotation;
    DISPLAYCONFIG_SCALING                   scaling;
    DISPLAYCONFIG_RATIONAL                  refreshRate;
    DISPLAYCONFIG_SCANLINE_ORDERING         scanLineOrdering;
    BOOL                                    targetAvailable;
    UINT32                                  statusFlags;
} DISPLAYCONFIG_PATH_TARGET_INFO;
]]

ffi.cdef[[
//
// Status flags for target info structure (from OS to application through QDC)
//
static const int DISPLAYCONFIG_TARGET_IN_USE                       =  0x00000001;
static const int DISPLAYCONFIG_TARGET_FORCIBLE                     =  0x00000002;
static const int DISPLAYCONFIG_TARGET_FORCED_AVAILABILITY_BOOT     =  0x00000004;
static const int DISPLAYCONFIG_TARGET_FORCED_AVAILABILITY_PATH     =  0x00000008;
static const int DISPLAYCONFIG_TARGET_FORCED_AVAILABILITY_SYSTEM   =  0x00000010;
static const int DISPLAYCONFIG_TARGET_IS_HMD                       =  0x00000020;
]]

ffi.cdef[[
typedef struct DISPLAYCONFIG_PATH_INFO
{
    DISPLAYCONFIG_PATH_SOURCE_INFO  sourceInfo;
    DISPLAYCONFIG_PATH_TARGET_INFO  targetInfo;
    UINT32                          flags;
} DISPLAYCONFIG_PATH_INFO;
]]

ffi.cdef[[
//
// Flags for path info structure (from OS to application through QDC)
//

static const int DISPLAYCONFIG_PATH_ACTIVE              = 0x00000001;
static const int DISPLAYCONFIG_PATH_PREFERRED_UNSCALED  = 0x00000004;
static const int DISPLAYCONFIG_PATH_SUPPORT_VIRTUAL_MODE= 0x00000008;
static const int DISPLAYCONFIG_PATH_VALID_FLAGS         = 0x0000000D;

typedef enum
{
      DISPLAYCONFIG_TOPOLOGY_INTERNAL       = 0x00000001,
      DISPLAYCONFIG_TOPOLOGY_CLONE          = 0x00000002,
      DISPLAYCONFIG_TOPOLOGY_EXTEND         = 0x00000004,
      DISPLAYCONFIG_TOPOLOGY_EXTERNAL       = 0x00000008,
      DISPLAYCONFIG_TOPOLOGY_FORCE_UINT32   = 0xFFFFFFFF
} DISPLAYCONFIG_TOPOLOGY_ID;


typedef enum
{
      DISPLAYCONFIG_DEVICE_INFO_GET_SOURCE_NAME                 = 1,
      DISPLAYCONFIG_DEVICE_INFO_GET_TARGET_NAME                 = 2,
      DISPLAYCONFIG_DEVICE_INFO_GET_TARGET_PREFERRED_MODE       = 3,
      DISPLAYCONFIG_DEVICE_INFO_GET_ADAPTER_NAME                = 4,
      DISPLAYCONFIG_DEVICE_INFO_SET_TARGET_PERSISTENCE          = 5,
      DISPLAYCONFIG_DEVICE_INFO_GET_TARGET_BASE_TYPE            = 6,
      DISPLAYCONFIG_DEVICE_INFO_GET_SUPPORT_VIRTUAL_RESOLUTION  = 7,
      DISPLAYCONFIG_DEVICE_INFO_SET_SUPPORT_VIRTUAL_RESOLUTION  = 8,
      DISPLAYCONFIG_DEVICE_INFO_FORCE_UINT32                = 0xFFFFFFFF
} DISPLAYCONFIG_DEVICE_INFO_TYPE;
]]

ffi.cdef[[
typedef struct DISPLAYCONFIG_DEVICE_INFO_HEADER
{
    DISPLAYCONFIG_DEVICE_INFO_TYPE  type;
    UINT32                          size;
    LUID                            adapterId;
    UINT32                          id;
} DISPLAYCONFIG_DEVICE_INFO_HEADER;
]]

ffi.cdef[[
typedef struct DISPLAYCONFIG_SOURCE_DEVICE_NAME
{
    DISPLAYCONFIG_DEVICE_INFO_HEADER            header;
    WCHAR                                       viewGdiDeviceName[CCHDEVICENAME];
} DISPLAYCONFIG_SOURCE_DEVICE_NAME;
]]

ffi.cdef[[
typedef struct DISPLAYCONFIG_TARGET_DEVICE_NAME_FLAGS
{
    union
    {
        struct
        {
            UINT32  friendlyNameFromEdid : 1;
            UINT32  friendlyNameForced : 1;
            UINT32  edidIdsValid : 1;
            UINT32  reserved : 29;
        } ;
        UINT32  value;
    } ;
} DISPLAYCONFIG_TARGET_DEVICE_NAME_FLAGS;
]]

ffi.cdef[[
typedef struct DISPLAYCONFIG_TARGET_DEVICE_NAME
{
    DISPLAYCONFIG_DEVICE_INFO_HEADER            header;
    DISPLAYCONFIG_TARGET_DEVICE_NAME_FLAGS      flags;
    DISPLAYCONFIG_VIDEO_OUTPUT_TECHNOLOGY       outputTechnology;
    UINT16                                      edidManufactureId;
    UINT16                                      edidProductCodeId;
    UINT32                                      connectorInstance;
    WCHAR                                       monitorFriendlyDeviceName[64];
    WCHAR                                       monitorDevicePath[128];
} DISPLAYCONFIG_TARGET_DEVICE_NAME;
]]

ffi.cdef[[
typedef struct DISPLAYCONFIG_TARGET_PREFERRED_MODE
{
    DISPLAYCONFIG_DEVICE_INFO_HEADER    header;
    UINT32                              width;
    UINT32                              height;
    DISPLAYCONFIG_TARGET_MODE           targetMode;
} DISPLAYCONFIG_TARGET_PREFERRED_MODE;
]]

ffi.cdef[[
typedef struct DISPLAYCONFIG_ADAPTER_NAME
{
    DISPLAYCONFIG_DEVICE_INFO_HEADER    header;
    WCHAR                               adapterDevicePath[128];
} DISPLAYCONFIG_ADAPTER_NAME;

typedef struct DISPLAYCONFIG_TARGET_BASE_TYPE {
    DISPLAYCONFIG_DEVICE_INFO_HEADER      header;
    DISPLAYCONFIG_VIDEO_OUTPUT_TECHNOLOGY baseOutputTechnology;
} DISPLAYCONFIG_TARGET_BASE_TYPE;
]]

ffi.cdef[[
typedef struct DISPLAYCONFIG_SET_TARGET_PERSISTENCE
{
    DISPLAYCONFIG_DEVICE_INFO_HEADER    header;
    union
    {
        struct
        {
            UINT32 bootPersistenceOn    : 1;
            UINT32 reserved             : 31;
        } ;
        UINT32 value;
    } ;
} DISPLAYCONFIG_SET_TARGET_PERSISTENCE;

typedef struct DISPLAYCONFIG_SUPPORT_VIRTUAL_RESOLUTION
{
    DISPLAYCONFIG_DEVICE_INFO_HEADER    header;
    union
    {
        struct
        {
            UINT32 disableMonitorVirtualResolution  : 1;
            UINT32 reserved                         : 31;
        } ;
        UINT32 value;
    } ;
} DISPLAYCONFIG_SUPPORT_VIRTUAL_RESOLUTION;
]]


ffi.cdef[[
static const int QDC_ALL_PATHS                              =   0x00000001;
static const int QDC_ONLY_ACTIVE_PATHS                      =   0x00000002;
static const int QDC_DATABASE_CURRENT                       =   0x00000004;
static const int QDC_VIRTUAL_MODE_AWARE                     =   0x00000010;
]]

ffi.cdef[[
//
// Definitions used by SetDisplayConfig.
//

static const int SDC_TOPOLOGY_INTERNAL            = 0x00000001;
static const int SDC_TOPOLOGY_CLONE               = 0x00000002;
static const int SDC_TOPOLOGY_EXTEND              = 0x00000004;
static const int SDC_TOPOLOGY_EXTERNAL            = 0x00000008;
static const int SDC_TOPOLOGY_SUPPLIED            = 0x00000010;
static const int SDC_USE_DATABASE_CURRENT         = (SDC_TOPOLOGY_INTERNAL | SDC_TOPOLOGY_CLONE | SDC_TOPOLOGY_EXTEND | SDC_TOPOLOGY_EXTERNAL);

static const int SDC_USE_SUPPLIED_DISPLAY_CONFIG  = 0x00000020;
static const int SDC_VALIDATE                     = 0x00000040;
static const int SDC_APPLY                        = 0x00000080;
static const int SDC_NO_OPTIMIZATION              = 0x00000100;
static const int SDC_SAVE_TO_DATABASE             = 0x00000200;
static const int SDC_ALLOW_CHANGES                = 0x00000400;
static const int SDC_PATH_PERSIST_IF_REQUIRED     = 0x00000800;
static const int SDC_FORCE_MODE_ENUMERATION       = 0x00001000;
static const int SDC_ALLOW_PATH_ORDER_CHANGES     = 0x00002000;
static const int SDC_VIRTUAL_MODE_AWARE           = 0x00008000;
]]

ffi.cdef[[
/* GetRegionData/ExtCreateRegion */

static const int RDH_RECTANGLES  = 1;

typedef struct _RGNDATAHEADER {
    DWORD   dwSize;
    DWORD   iType;
    DWORD   nCount;
    DWORD   nRgnSize;
    RECT    rcBound;
} RGNDATAHEADER, *PRGNDATAHEADER;

typedef struct _RGNDATA {
    RGNDATAHEADER   rdh;
    char            Buffer[1];
} RGNDATA, *PRGNDATA, *NPRGNDATA,  *LPRGNDATA;
]]

ffi.cdef[[
/* for GetRandomRgn */
static const int SYSRGN = 4;

typedef struct _ABC {
    int     abcA;
    UINT    abcB;
    int     abcC;
} ABC, *PABC,  *NPABC,  *LPABC;

typedef struct _ABCFLOAT {
    FLOAT   abcfA;
    FLOAT   abcfB;
    FLOAT   abcfC;
} ABCFLOAT, *PABCFLOAT,  *NPABCFLOAT,  *LPABCFLOAT;
]]

--[[
#ifndef NOTEXTMETRIC

#ifdef _MAC
#include "pshpack4.h"
#endif
--]]


ffi.cdef[[
typedef struct _OUTLINETEXTMETRICA {
    UINT    otmSize;
    TEXTMETRICA otmTextMetrics;
    BYTE    otmFiller;
    PANOSE  otmPanoseNumber;
    UINT    otmfsSelection;
    UINT    otmfsType;
     int    otmsCharSlopeRise;
     int    otmsCharSlopeRun;
     int    otmItalicAngle;
    UINT    otmEMSquare;
     int    otmAscent;
     int    otmDescent;
    UINT    otmLineGap;
    UINT    otmsCapEmHeight;
    UINT    otmsXHeight;
    RECT    otmrcFontBox;
     int    otmMacAscent;
     int    otmMacDescent;
    UINT    otmMacLineGap;
    UINT    otmusMinimumPPEM;
    POINT   otmptSubscriptSize;
    POINT   otmptSubscriptOffset;
    POINT   otmptSuperscriptSize;
    POINT   otmptSuperscriptOffset;
    UINT    otmsStrikeoutSize;
     int    otmsStrikeoutPosition;
     int    otmsUnderscoreSize;
     int    otmsUnderscorePosition;
    PSTR    otmpFamilyName;
    PSTR    otmpFaceName;
    PSTR    otmpStyleName;
    PSTR    otmpFullName;
} OUTLINETEXTMETRICA, *POUTLINETEXTMETRICA,  *NPOUTLINETEXTMETRICA,  *LPOUTLINETEXTMETRICA;
]]

ffi.cdef[[
typedef struct _OUTLINETEXTMETRICW {
    UINT    otmSize;
    TEXTMETRICW otmTextMetrics;
    BYTE    otmFiller;
    PANOSE  otmPanoseNumber;
    UINT    otmfsSelection;
    UINT    otmfsType;
     int    otmsCharSlopeRise;
     int    otmsCharSlopeRun;
     int    otmItalicAngle;
    UINT    otmEMSquare;
     int    otmAscent;
     int    otmDescent;
    UINT    otmLineGap;
    UINT    otmsCapEmHeight;
    UINT    otmsXHeight;
    RECT    otmrcFontBox;
     int    otmMacAscent;
     int    otmMacDescent;
    UINT    otmMacLineGap;
    UINT    otmusMinimumPPEM;
    POINT   otmptSubscriptSize;
    POINT   otmptSubscriptOffset;
    POINT   otmptSuperscriptSize;
    POINT   otmptSuperscriptOffset;
    UINT    otmsStrikeoutSize;
     int    otmsStrikeoutPosition;
     int    otmsUnderscoreSize;
     int    otmsUnderscorePosition;
    PSTR    otmpFamilyName;
    PSTR    otmpFaceName;
    PSTR    otmpStyleName;
    PSTR    otmpFullName;
} OUTLINETEXTMETRICW, *POUTLINETEXTMETRICW,  *NPOUTLINETEXTMETRICW,  *LPOUTLINETEXTMETRICW;
]]

--[[
#ifdef UNICODE
typedef OUTLINETEXTMETRICW OUTLINETEXTMETRIC;
typedef POUTLINETEXTMETRICW POUTLINETEXTMETRIC;
typedef NPOUTLINETEXTMETRICW NPOUTLINETEXTMETRIC;
typedef LPOUTLINETEXTMETRICW LPOUTLINETEXTMETRIC;
#else
typedef OUTLINETEXTMETRICA OUTLINETEXTMETRIC;
typedef POUTLINETEXTMETRICA POUTLINETEXTMETRIC;
typedef NPOUTLINETEXTMETRICA NPOUTLINETEXTMETRIC;
typedef LPOUTLINETEXTMETRICA LPOUTLINETEXTMETRIC;
#endif // UNICODE
--]]

ffi.cdef[[
typedef struct tagPOLYTEXTA
{
    int       x;
    int       y;
    UINT      n;
    LPCSTR    lpstr;
    UINT      uiFlags;
    RECT      rcl;
    int      *pdx;
} POLYTEXTA, *PPOLYTEXTA,  *NPPOLYTEXTA,  *LPPOLYTEXTA;
]]

ffi.cdef[[
typedef struct tagPOLYTEXTW
{
    int       x;
    int       y;
    UINT      n;
    LPCWSTR   lpstr;
    UINT      uiFlags;
    RECT      rcl;
    int      *pdx;
} POLYTEXTW, *PPOLYTEXTW,  *NPPOLYTEXTW,  *LPPOLYTEXTW;
]]

--[[
#ifdef UNICODE
typedef POLYTEXTW POLYTEXT;
typedef PPOLYTEXTW PPOLYTEXT;
typedef NPPOLYTEXTW NPPOLYTEXT;
typedef LPPOLYTEXTW LPPOLYTEXT;
#else
typedef POLYTEXTA POLYTEXT;
typedef PPOLYTEXTA PPOLYTEXT;
typedef NPPOLYTEXTA NPPOLYTEXT;
typedef LPPOLYTEXTA LPPOLYTEXT;
#endif // UNICODE
--]]

ffi.cdef[[
typedef struct _FIXED {
    short   value;
    WORD    fract;
} FIXED;


typedef struct _MAT2 {
     FIXED  eM11;
     FIXED  eM12;
     FIXED  eM21;
     FIXED  eM22;
} MAT2,  *LPMAT2;



typedef struct _GLYPHMETRICS {
    UINT    gmBlackBoxX;
    UINT    gmBlackBoxY;
    POINT   gmptGlyphOrigin;
    short   gmCellIncX;
    short   gmCellIncY;
} GLYPHMETRICS,  *LPGLYPHMETRICS;
]]

ffi.cdef[[
//  GetGlyphOutline constants

static const int GGO_METRICS        = 0;
static const int GGO_BITMAP         = 1;
static const int GGO_NATIVE         = 2;
static const int GGO_BEZIER         = 3;


static const int  GGO_GRAY2_BITMAP   = 4;
static const int  GGO_GRAY4_BITMAP   = 5;
static const int  GGO_GRAY8_BITMAP   = 6;
static const int  GGO_GLYPH_INDEX    = 0x0080;



static const int  GGO_UNHINTED      = 0x0100;


static const int TT_POLYGON_TYPE   = 24;

static const int TT_PRIM_LINE      = 1;
static const int TT_PRIM_QSPLINE   = 2;
static const int TT_PRIM_CSPLINE   = 3;
]]

ffi.cdef[[
typedef struct tagPOINTFX
{
    FIXED x;
    FIXED y;
} POINTFX, * LPPOINTFX;

typedef struct tagTTPOLYCURVE
{
    WORD    wType;
    WORD    cpfx;
    POINTFX apfx[1];
} TTPOLYCURVE, * LPTTPOLYCURVE;

typedef struct tagTTPOLYGONHEADER
{
    DWORD   cb;
    DWORD   dwType;
    POINTFX pfxStart;
} TTPOLYGONHEADER, * LPTTPOLYGONHEADER;
]]


--[=[
#if(WINVER >= 0x0400)
#define GCP_DBCS           0x0001
#define GCP_REORDER        0x0002
#define GCP_USEKERNING     0x0008
#define GCP_GLYPHSHAPE     0x0010
#define GCP_LIGATE         0x0020
////#define GCP_GLYPHINDEXING  0x0080
#define GCP_DIACRITIC      0x0100
#define GCP_KASHIDA        0x0400
#define GCP_ERROR          0x8000
#define FLI_MASK           0x103B

#define GCP_JUSTIFY        0x00010000L
////#define GCP_NODIACRITICS   0x00020000L
#define FLI_GLYPHS         0x00040000L
#define GCP_CLASSIN        0x00080000L
#define GCP_MAXEXTENT      0x00100000L
#define GCP_JUSTIFYIN      0x00200000L
#define GCP_DISPLAYZWG      0x00400000L
#define GCP_SYMSWAPOFF      0x00800000L
#define GCP_NUMERICOVERRIDE 0x01000000L
#define GCP_NEUTRALOVERRIDE 0x02000000L
#define GCP_NUMERICSLATIN   0x04000000L
#define GCP_NUMERICSLOCAL   0x08000000L

#define GCPCLASS_LATIN                  1
#define GCPCLASS_HEBREW                 2
#define GCPCLASS_ARABIC                 2
#define GCPCLASS_NEUTRAL                3
#define GCPCLASS_LOCALNUMBER            4
#define GCPCLASS_LATINNUMBER            5
#define GCPCLASS_LATINNUMERICTERMINATOR 6
#define GCPCLASS_LATINNUMERICSEPARATOR  7
#define GCPCLASS_NUMERICSEPARATOR       8
#define GCPCLASS_PREBOUNDLTR         0x80
#define GCPCLASS_PREBOUNDRTL         0x40
#define GCPCLASS_POSTBOUNDLTR        0x20
#define GCPCLASS_POSTBOUNDRTL        0x10

#define GCPGLYPH_LINKBEFORE          0x8000
#define GCPGLYPH_LINKAFTER           0x4000
--]=]

ffi.cdef[[
typedef struct tagGCP_RESULTSA
    {
    DWORD   lStructSize;
    LPSTR     lpOutString;
    UINT  *lpOrder;
    int   *lpDx;
    int   *lpCaretPos;
    LPSTR   lpClass;
    LPWSTR  lpGlyphs;
    UINT    nGlyphs;
    int     nMaxFit;
    } GCP_RESULTSA, * LPGCP_RESULTSA;

typedef struct tagGCP_RESULTSW
    {
    DWORD   lStructSize;
    LPWSTR    lpOutString;
    UINT  *lpOrder;
    int   *lpDx;
    int   *lpCaretPos;
    LPSTR   lpClass;
    LPWSTR  lpGlyphs;
    UINT    nGlyphs;
    int     nMaxFit;
    } GCP_RESULTSW, * LPGCP_RESULTSW;
]]

--[[
#ifdef UNICODE
typedef GCP_RESULTSW GCP_RESULTS;
typedef LPGCP_RESULTSW LPGCP_RESULTS;
#else
typedef GCP_RESULTSA GCP_RESULTS;
typedef LPGCP_RESULTSA LPGCP_RESULTS;
#endif // UNICODE
--]]


ffi.cdef[[
typedef struct _RASTERIZER_STATUS {
    short   nSize;
    short   wFlags;
    short   nLanguageID;
} RASTERIZER_STATUS,  *LPRASTERIZER_STATUS;
]]

ffi.cdef[[
/* bits defined in wFlags of RASTERIZER_STATUS */
static const int TT_AVAILABLE   = 0x0001;
static const int TT_ENABLED     = 0x0002;



/* Pixel format descriptor */
typedef struct tagPIXELFORMATDESCRIPTOR
{
    WORD  nSize;
    WORD  nVersion;
    DWORD dwFlags;
    BYTE  iPixelType;
    BYTE  cColorBits;
    BYTE  cRedBits;
    BYTE  cRedShift;
    BYTE  cGreenBits;
    BYTE  cGreenShift;
    BYTE  cBlueBits;
    BYTE  cBlueShift;
    BYTE  cAlphaBits;
    BYTE  cAlphaShift;
    BYTE  cAccumBits;
    BYTE  cAccumRedBits;
    BYTE  cAccumGreenBits;
    BYTE  cAccumBlueBits;
    BYTE  cAccumAlphaBits;
    BYTE  cDepthBits;
    BYTE  cStencilBits;
    BYTE  cAuxBuffers;
    BYTE  iLayerType;
    BYTE  bReserved;
    DWORD dwLayerMask;
    DWORD dwVisibleMask;
    DWORD dwDamageMask;
} PIXELFORMATDESCRIPTOR, *PPIXELFORMATDESCRIPTOR,  *LPPIXELFORMATDESCRIPTOR;
]]


ffi.cdef[[
/* pixel types */
static const int PFD_TYPE_RGBA       = 0;
static const int PFD_TYPE_COLORINDEX = 1;

/* layer types */
static const int PFD_MAIN_PLANE      = 0;
static const int PFD_OVERLAY_PLANE   = 1;
static const int PFD_UNDERLAY_PLANE  = (-1);

/* PIXELFORMATDESCRIPTOR flags */
static const int PFD_DOUBLEBUFFER           = 0x00000001;
static const int PFD_STEREO                 = 0x00000002;
static const int PFD_DRAW_TO_WINDOW         = 0x00000004;
static const int PFD_DRAW_TO_BITMAP         = 0x00000008;
static const int PFD_SUPPORT_GDI            = 0x00000010;
static const int PFD_SUPPORT_OPENGL         = 0x00000020;
static const int PFD_GENERIC_FORMAT         = 0x00000040;
static const int PFD_NEED_PALETTE           = 0x00000080;
static const int PFD_NEED_SYSTEM_PALETTE    = 0x00000100;
static const int PFD_SWAP_EXCHANGE          = 0x00000200;
static const int PFD_SWAP_COPY              = 0x00000400;
static const int PFD_SWAP_LAYER_BUFFERS     = 0x00000800;
static const int PFD_GENERIC_ACCELERATED    = 0x00001000;
static const int PFD_SUPPORT_DIRECTDRAW     = 0x00002000;
static const int PFD_DIRECT3D_ACCELERATED   = 0x00004000;
static const int PFD_SUPPORT_COMPOSITION    = 0x00008000;

/* PIXELFORMATDESCRIPTOR flags for use in ChoosePixelFormat only */
static const int PFD_DEPTH_DONTCARE         = 0x20000000;
static const int PFD_DOUBLEBUFFER_DONTCARE  = 0x40000000;
static const int PFD_STEREO_DONTCARE        = 0x80000000;
]]



ffi.cdef[[
typedef int (__stdcall* OLDFONTENUMPROCA)(const LOGFONTA *, const TEXTMETRICA *, DWORD, LPARAM);
typedef int (__stdcall* OLDFONTENUMPROCW)(const LOGFONTW *, const TEXTMETRICW *, DWORD, LPARAM);
]]

--[[
#ifdef UNICODE
#define OLDFONTENUMPROC  OLDFONTENUMPROCW
#else
#define OLDFONTENUMPROC  OLDFONTENUMPROCA
#endif // !UNICODE
--]]


ffi.cdef[[
typedef OLDFONTENUMPROCA    FONTENUMPROCA;
typedef OLDFONTENUMPROCW    FONTENUMPROCW;
]]

--[[
#ifdef UNICODE
typedef FONTENUMPROCW FONTENUMPROC;
#else
typedef FONTENUMPROCA FONTENUMPROC;
#endif // UNICODE
--]]

ffi.cdef[[
typedef int (__stdcall* GOBJENUMPROC)(LPVOID, LPARAM);
typedef VOID (__stdcall* LINEDDAPROC)(int, int, LPARAM);
]]



ffi.cdef[[
 int __stdcall AddFontResourceA( LPCSTR);
 int __stdcall AddFontResourceW( LPCWSTR);
]]

 --[[
#ifdef UNICODE
#define AddFontResource  AddFontResourceW
#else
#define AddFontResource  AddFontResourceA
#endif // !UNICODE
--]]

ffi.cdef[[
  BOOL  __stdcall AnimatePalette(  HPALETTE hPal,  UINT iStartIndex,   UINT cEntries, const PALETTEENTRY * ppe);
  BOOL  __stdcall Arc(  HDC hdc,  int x1,  int y1,  int x2,  int y2,  int x3,  int y3,  int x4,  int y4);
  BOOL  __stdcall BitBlt(  HDC hdc,  int x,  int y,  int cx,  int cy,  HDC hdcSrc,  int x1,  int y1,  DWORD rop);
 BOOL  __stdcall CancelDC(  HDC hdc);
  BOOL  __stdcall Chord(  HDC hdc,  int x1,  int y1,  int x2,  int y2,  int x3,  int y3,  int x4,  int y4);
 int   __stdcall ChoosePixelFormat(  HDC hdc,  const PIXELFORMATDESCRIPTOR *ppfd);
 HMETAFILE  __stdcall CloseMetaFile(  HDC hdc);
 int     __stdcall CombineRgn(  HRGN hrgnDst,  HRGN hrgnSrc1,  HRGN hrgnSrc2,  int iMode);
 HMETAFILE __stdcall CopyMetaFileA(  HMETAFILE,  LPCSTR);
 HMETAFILE __stdcall CopyMetaFileW(  HMETAFILE,  LPCWSTR);
]]

--[[
#ifdef UNICODE
#define CopyMetaFile  CopyMetaFileW
#else
#define CopyMetaFile  CopyMetaFileA
#endif // !UNICODE
--]]

ffi.cdef[[
  HBITMAP __stdcall CreateBitmap(  int nWidth,  int nHeight,  UINT nPlanes,  UINT nBitCount,  const VOID *lpBits);
  HBITMAP __stdcall CreateBitmapIndirect(  const BITMAP *pbm);
  HBRUSH  __stdcall CreateBrushIndirect(  const LOGBRUSH *plbrush);
 HBITMAP __stdcall CreateCompatibleBitmap(  HDC hdc,  int cx,  int cy);
 HBITMAP __stdcall CreateDiscardableBitmap(  HDC hdc,  int cx,  int cy);
 HDC     __stdcall CreateCompatibleDC(  HDC hdc);
 HDC     __stdcall CreateDCA(  LPCSTR pwszDriver,  LPCSTR pwszDevice,  LPCSTR pszPort,  const DEVMODEA * pdm);
 HDC     __stdcall CreateDCW(  LPCWSTR pwszDriver,  LPCWSTR pwszDevice,  LPCWSTR pszPort,  const DEVMODEW * pdm);
]]

--[[
#ifdef UNICODE
#define CreateDC  CreateDCW
#else
#define CreateDC  CreateDCA
#endif // !UNICODE
--]]

ffi.cdef[[
 HBITMAP __stdcall CreateDIBitmap(  HDC hdc,  const BITMAPINFOHEADER *pbmih,  DWORD flInit,  const VOID *pjBits,  const BITMAPINFO *pbmi,  UINT iUsage);
 HBRUSH  __stdcall CreateDIBPatternBrush(  HGLOBAL h,  UINT iUsage);
  HBRUSH  __stdcall CreateDIBPatternBrushPt(  const VOID *lpPackedDIB,  UINT iUsage);
 HRGN    __stdcall CreateEllipticRgn(  int x1,  int y1,  int x2,  int y2);
 HRGN    __stdcall CreateEllipticRgnIndirect(  const RECT *lprect);
  HFONT   __stdcall CreateFontIndirectA(  const LOGFONTA *lplf);
  HFONT   __stdcall CreateFontIndirectW(  const LOGFONTW *lplf);
]]

--[[
#ifdef UNICODE
#define CreateFontIndirect  CreateFontIndirectW
#else
#define CreateFontIndirect  CreateFontIndirectA
#endif // !UNICODE
--]]

ffi.cdef[[
 HFONT   __stdcall CreateFontA(  int cHeight,  int cWidth,  int cEscapement,  int cOrientation,  int cWeight,  DWORD bItalic,
                              DWORD bUnderline,  DWORD bStrikeOut,  DWORD iCharSet,  DWORD iOutPrecision,  DWORD iClipPrecision,
                              DWORD iQuality,  DWORD iPitchAndFamily,  LPCSTR pszFaceName);
 HFONT   __stdcall CreateFontW(  int cHeight,  int cWidth,  int cEscapement,  int cOrientation,  int cWeight,  DWORD bItalic,
                              DWORD bUnderline,  DWORD bStrikeOut,  DWORD iCharSet,  DWORD iOutPrecision,  DWORD iClipPrecision,
                              DWORD iQuality,  DWORD iPitchAndFamily,  LPCWSTR pszFaceName);
]]

--[[
#ifdef UNICODE
#define CreateFont  CreateFontW
#else
#define CreateFont  CreateFontA
#endif // !UNICODE
--]]

ffi.cdef[[
 HBRUSH  __stdcall CreateHatchBrush(  int iHatch,  COLORREF color);
 HDC     __stdcall CreateICA(  LPCSTR pszDriver,  LPCSTR pszDevice,  LPCSTR pszPort,  const DEVMODEA * pdm);
 HDC     __stdcall CreateICW(  LPCWSTR pszDriver,  LPCWSTR pszDevice,  LPCWSTR pszPort,  const DEVMODEW * pdm);
]]

--[[
#ifdef UNICODE
#define CreateIC  CreateICW
#else
#define CreateIC  CreateICA
#endif // !UNICODE
--]]

ffi.cdef[[
 HDC     __stdcall CreateMetaFileA(  LPCSTR pszFile);
 HDC     __stdcall CreateMetaFileW(  LPCWSTR pszFile);
]]

--[[
#ifdef UNICODE
#define CreateMetaFile  CreateMetaFileW
#else
#define CreateMetaFile  CreateMetaFileA
#endif // !UNICODE
--]]

ffi.cdef[[
  HPALETTE __stdcall CreatePalette(const LOGPALETTE * plpal);
 HPEN    __stdcall CreatePen(  int iStyle,  int cWidth,  COLORREF color);
  HPEN    __stdcall CreatePenIndirect(  const LOGPEN *plpen);
 HRGN    __stdcall CreatePolyPolygonRgn(   const POINT *pptl,
                                                const INT  *pc,
                                                 int cPoly,
                                                 int iMode);
  HBRUSH  __stdcall CreatePatternBrush(  HBITMAP hbm);
 HRGN    __stdcall CreateRectRgn(  int x1,  int y1,  int x2,  int y2);
 HRGN    __stdcall CreateRectRgnIndirect(  const RECT *lprect);
 HRGN    __stdcall CreateRoundRectRgn(  int x1,  int y1,  int x2,  int y2,  int w,  int h);
 BOOL    __stdcall CreateScalableFontResourceA(  DWORD fdwHidden,  LPCSTR lpszFont,  LPCSTR lpszFile,  LPCSTR lpszPath);
 BOOL    __stdcall CreateScalableFontResourceW(  DWORD fdwHidden,  LPCWSTR lpszFont,  LPCWSTR lpszFile,  LPCWSTR lpszPath);
]]

--[[
#ifdef UNICODE
#define CreateScalableFontResource  CreateScalableFontResourceW
#else
#define CreateScalableFontResource  CreateScalableFontResourceA
#endif // !UNICODE
--]]

ffi.cdef[[
 HBRUSH  __stdcall CreateSolidBrush(  COLORREF color);

 BOOL __stdcall DeleteDC(  HDC hdc);
 BOOL __stdcall DeleteMetaFile(  HMETAFILE hmf);
  BOOL __stdcall DeleteObject(  HGDIOBJ ho);
 int  __stdcall DescribePixelFormat(   HDC hdc,
                                             int iPixelFormat,
                                             UINT nBytes,
                                            LPPIXELFORMATDESCRIPTOR ppfd);
]]

--[=[
/* define types of pointers to ExtDeviceMode() and DeviceCapabilities()
 * functions for Win 3.1 compatibility
 */

typedef UINT   (CALLBACK* LPFNDEVMODE)(HWND, HMODULE, LPDEVMODE, LPSTR, LPSTR, LPDEVMODE, LPSTR, UINT);

typedef DWORD  (CALLBACK* LPFNDEVCAPS)(LPSTR, LPSTR, UINT, LPSTR, LPDEVMODE);



/* mode selections for the device mode function */
#define DM_UPDATE           1
#define DM_COPY             2
#define DM_PROMPT           4
#define DM_MODIFY           8

#define DM_IN_BUFFER        DM_MODIFY
#define DM_IN_PROMPT        DM_PROMPT
#define DM_OUT_BUFFER       DM_COPY
#define DM_OUT_DEFAULT      DM_UPDATE

/* device capabilities indices */
#define DC_FIELDS           1
#define DC_PAPERS           2
#define DC_PAPERSIZE        3
#define DC_MINEXTENT        4
#define DC_MAXEXTENT        5
#define DC_BINS             6
#define DC_DUPLEX           7
#define DC_SIZE             8
#define DC_EXTRA            9
#define DC_VERSION          10
#define DC_DRIVER           11
#define DC_BINNAMES         12
#define DC_ENUMRESOLUTIONS  13
#define DC_FILEDEPENDENCIES 14
#define DC_TRUETYPE         15
#define DC_PAPERNAMES       16
#define DC_ORIENTATION      17
#define DC_COPIES           18
#if(WINVER >= 0x0400)
#define DC_BINADJUST            19
#define DC_EMF_COMPLIANT        20
#define DC_DATATYPE_PRODUCED    21
#define DC_COLLATE              22
#define DC_MANUFACTURER         23
#define DC_MODEL                24
#endif /* WINVER >= 0x0400 */

#if(WINVER >= 0x0500)
#define DC_PERSONALITY          25
#define DC_PRINTRATE            26
#define DC_PRINTRATEUNIT        27
#define   PRINTRATEUNIT_PPM     1
#define   PRINTRATEUNIT_CPS     2
#define   PRINTRATEUNIT_LPM     3
#define   PRINTRATEUNIT_IPM     4
#define DC_PRINTERMEM           28
#define DC_MEDIAREADY           29
#define DC_STAPLE               30
#define DC_PRINTRATEPPM         31
#define DC_COLORDEVICE          32
#define DC_NUP                  33

#define DC_MEDIATYPENAMES       34
#define DC_MEDIATYPES           35


/* bit fields of the return value (DWORD) for DC_TRUETYPE */
#define DCTT_BITMAP             0x0000001L
#define DCTT_DOWNLOAD           0x0000002L
#define DCTT_SUBDEV             0x0000004L

#define DCTT_DOWNLOAD_OUTLINE   0x0000008L

/* return values for DC_BINADJUST */
#define DCBA_FACEUPNONE       0x0000
#define DCBA_FACEUPCENTER     0x0001
#define DCBA_FACEUPLEFT       0x0002
#define DCBA_FACEUPRIGHT      0x0003
#define DCBA_FACEDOWNNONE     0x0100
#define DCBA_FACEDOWNCENTER   0x0101
#define DCBA_FACEDOWNLEFT     0x0102
#define DCBA_FACEDOWNRIGHT    0x0103

--]=]

ffi.cdef[[
int
__stdcall
DeviceCapabilitiesA(
                    LPCSTR         pDevice,
                LPCSTR         pPort,
                    WORD             fwCapability,
    LPSTR          pOutput,
                const DEVMODEA   *pDevMode
    );

int
__stdcall
DeviceCapabilitiesW(
                    LPCWSTR         pDevice,
                LPCWSTR         pPort,
                    WORD             fwCapability,
     LPWSTR          pOutput,
                const DEVMODEW   *pDevMode
    );
]]

--[[
#ifdef UNICODE
#define DeviceCapabilities  DeviceCapabilitiesW
#else
#define DeviceCapabilities  DeviceCapabilitiesA
#endif // !UNICODE
--]]

ffi.cdef[[
 int  __stdcall DrawEscape(    HDC    hdc,
                                     int    iEscape,
                                     int    cjIn,
                                    LPCSTR lpIn);

  BOOL __stdcall Ellipse(  HDC hdc,  int left,  int top,   int right,  int bottom);


 int  __stdcall EnumFontFamiliesExA(  HDC hdc,  LPLOGFONTA lpLogfont,  FONTENUMPROCA lpProc,  LPARAM lParam,  DWORD dwFlags);
 int  __stdcall EnumFontFamiliesExW(  HDC hdc,  LPLOGFONTW lpLogfont,  FONTENUMPROCW lpProc,  LPARAM lParam,  DWORD dwFlags);
]]

--[[
#ifdef UNICODE
#define EnumFontFamiliesEx  EnumFontFamiliesExW
#else
#define EnumFontFamiliesEx  EnumFontFamiliesExA
#endif // !UNICODE
--]]


ffi.cdef[[
 int  __stdcall EnumFontFamiliesA(  HDC hdc,  LPCSTR lpLogfont,  FONTENUMPROCA lpProc,  LPARAM lParam);
 int  __stdcall EnumFontFamiliesW(  HDC hdc,  LPCWSTR lpLogfont,  FONTENUMPROCW lpProc,  LPARAM lParam);
]]

--[[
#ifdef UNICODE
#define EnumFontFamilies  EnumFontFamiliesW
#else
#define EnumFontFamilies  EnumFontFamiliesA
#endif // !UNICODE
--]]

ffi.cdef[[
 int  __stdcall EnumFontsA(  HDC hdc,  LPCSTR lpLogfont,   FONTENUMPROCA lpProc,  LPARAM lParam);
 int  __stdcall EnumFontsW(  HDC hdc,  LPCWSTR lpLogfont,   FONTENUMPROCW lpProc,  LPARAM lParam);
]]

--[[
#ifdef UNICODE
#define EnumFonts  EnumFontsW
#else
#define EnumFonts  EnumFontsA
#endif // !UNICODE
--]]

ffi.cdef[[
int  __stdcall EnumObjects(  HDC hdc,  int nType,  GOBJENUMPROC lpFunc,  LPARAM lParam);
]]


ffi.cdef[[
 BOOL __stdcall EqualRgn(  HRGN hrgn1,  HRGN hrgn2);
  int  __stdcall Escape(    HDC hdc,
                                 int iEscape,
                                 int cjIn,
                                LPCSTR pvIn,
                                 LPVOID pvOut);
 int  __stdcall ExtEscape(     HDC hdc,
                                     int iEscape,
                                     int cjInput,
                                     LPCSTR lpInData,
                                     int cjOutput,
                                     LPSTR lpOutData);
  int  __stdcall ExcludeClipRect(HDC hdc,  int left,  int top,  int right,  int bottom);
  HRGN __stdcall ExtCreateRegion(  const XFORM * lpx,  DWORD nCount, const RGNDATA * lpData);
  BOOL __stdcall ExtFloodFill(HDC hdc,  int x,  int y,  COLORREF color,  UINT type);
  BOOL __stdcall FillRgn(HDC hdc,  HRGN hrgn,  HBRUSH hbr);
  BOOL __stdcall FloodFill(HDC hdc,  int x,  int y,  COLORREF color);
  BOOL __stdcall FrameRgn(HDC hdc,  HRGN hrgn,  HBRUSH hbr,  int w,  int h);
 int  __stdcall GetROP2(HDC hdc);
 BOOL __stdcall GetAspectRatioFilterEx(  HDC hdc, LPSIZE lpsize);
 COLORREF __stdcall GetBkColor(  HDC hdc);


 COLORREF __stdcall GetDCBrushColor(  HDC hdc);
 COLORREF __stdcall GetDCPenColor(  HDC hdc);
]]

ffi.cdef[[
int
__stdcall
GetBkMode(
     HDC hdc
    );


LONG
__stdcall
GetBitmapBits(
     HBITMAP hbit,
     LONG cb,
    LPVOID lpvBits
    );

 BOOL  __stdcall GetBitmapDimensionEx(  HBITMAP hbit,  LPSIZE lpsize);
 UINT  __stdcall GetBoundsRect(  HDC hdc,  LPRECT lprect,  UINT flags);

 BOOL  __stdcall GetBrushOrgEx(  HDC hdc,  LPPOINT lppt);

 BOOL  __stdcall GetCharWidthA(  HDC hdc,  UINT iFirst,  UINT iLast, LPINT lpBuffer);
 BOOL  __stdcall GetCharWidthW(  HDC hdc,  UINT iFirst,  UINT iLast,  LPINT lpBuffer);
]]

--[[
#ifdef UNICODE
#define GetCharWidth  GetCharWidthW
#else
#define GetCharWidth  GetCharWidthA
#endif // !UNICODE
--]]

ffi.cdef[[
 BOOL  __stdcall GetCharWidth32A(  HDC hdc,  UINT iFirst,  UINT iLast,   LPINT lpBuffer);
 BOOL  __stdcall GetCharWidth32W(  HDC hdc,  UINT iFirst,  UINT iLast,  LPINT lpBuffer);
]]

--[[
#ifdef UNICODE
#define GetCharWidth32  GetCharWidth32W
#else
#define GetCharWidth32  GetCharWidth32A
#endif // !UNICODE
--]]

ffi.cdef[[
 BOOL  __stdcall GetCharWidthFloatA(  HDC hdc,  UINT iFirst,  UINT iLast, PFLOAT lpBuffer);
 BOOL  __stdcall GetCharWidthFloatW(  HDC hdc,  UINT iFirst,  UINT iLast, PFLOAT lpBuffer);
 ]]

--[[
#ifdef UNICODE
#define GetCharWidthFloat  GetCharWidthFloatW
#else
#define GetCharWidthFloat  GetCharWidthFloatA
#endif // !UNICODE
--]]

ffi.cdef[[
 BOOL  __stdcall GetCharABCWidthsA(  HDC hdc,
                                             UINT wFirst,
                                             UINT wLast,
                                             LPABC lpABC);
 BOOL  __stdcall GetCharABCWidthsW(  HDC hdc,
                                             UINT wFirst,
                                             UINT wLast,
                                            LPABC lpABC);
]]

--[[
#ifdef UNICODE
#define GetCharABCWidths  GetCharABCWidthsW
#else
#define GetCharABCWidths  GetCharABCWidthsA
#endif // !UNICODE
--]]

ffi.cdef[[
 BOOL  __stdcall GetCharABCWidthsFloatA(  HDC hdc,  UINT iFirst,  UINT iLast, LPABCFLOAT lpABC);
 BOOL  __stdcall GetCharABCWidthsFloatW(  HDC hdc,  UINT iFirst,  UINT iLast, LPABCFLOAT lpABC);
]]

 --[[
#ifdef UNICODE
#define GetCharABCWidthsFloat  GetCharABCWidthsFloatW
#else
#define GetCharABCWidthsFloat  GetCharABCWidthsFloatA
#endif // !UNICODE
--]]

ffi.cdef[[
 int   __stdcall GetClipBox(  HDC hdc,   LPRECT lprect);
 int   __stdcall GetClipRgn(  HDC hdc,  HRGN hrgn);
 int   __stdcall GetMetaRgn(  HDC hdc,  HRGN hrgn);
 HGDIOBJ __stdcall GetCurrentObject(  HDC hdc,  UINT type);
 BOOL  __stdcall GetCurrentPositionEx(  HDC hdc,   LPPOINT lppt);
 int   __stdcall GetDeviceCaps(  HDC hdc,  int index);
 int   __stdcall GetDIBits(  HDC hdc,  HBITMAP hbm,  UINT start,  UINT cLines,
     LPVOID lpvBits,  LPBITMAPINFO lpbmi,  UINT usage);  // SAL actual size of lpbmi is computed from structure elements
]]

ffi.cdef[[
 DWORD __stdcall GetFontData (     HDC     hdc,
                                         DWORD   dwTable,
                                         DWORD   dwOffset,
                                         PVOID pvBuffer,
                                         DWORD   cjBuffer
                                        );

 DWORD __stdcall GetGlyphOutlineA(     HDC hdc,
                                             UINT uChar,
                                             UINT fuFormat,
                                            LPGLYPHMETRICS lpgm,
                                             DWORD cjBuffer,
                                            LPVOID pvBuffer,
                                             const MAT2 *lpmat2
                                        );
 DWORD __stdcall GetGlyphOutlineW(     HDC hdc,
                                             UINT uChar,
                                             UINT fuFormat,
                                            LPGLYPHMETRICS lpgm,
                                             DWORD cjBuffer,
                                            LPVOID pvBuffer,
                                             const MAT2 *lpmat2
                                        );
]]

--[[
#ifdef UNICODE
#define GetGlyphOutline  GetGlyphOutlineW
#else
#define GetGlyphOutline  GetGlyphOutlineA
#endif // !UNICODE
--]]

ffi.cdef[[
 int   __stdcall GetGraphicsMode(  HDC hdc);
 int   __stdcall GetMapMode(  HDC hdc);
 UINT  __stdcall GetMetaFileBitsEx( HMETAFILE hMF,  UINT cbBuffer, LPVOID lpData);
 HMETAFILE   __stdcall GetMetaFileA(  LPCSTR lpName);
 HMETAFILE   __stdcall GetMetaFileW(  LPCWSTR lpName);
]]

 --[[
#ifdef UNICODE
#define GetMetaFile  GetMetaFileW
#else
#define GetMetaFile  GetMetaFileA
#endif // !UNICODE
--]]

ffi.cdef[[
 COLORREF __stdcall GetNearestColor(  HDC hdc,  COLORREF color);
 UINT  __stdcall GetNearestPaletteIndex(  HPALETTE h,  COLORREF color);
 DWORD __stdcall GetObjectType(  HGDIOBJ h);
]]


ffi.cdef[[
 UINT __stdcall GetOutlineTextMetricsA(  HDC hdc,
                                                 UINT cjCopy,
                                                 LPOUTLINETEXTMETRICA potm);
 UINT __stdcall GetOutlineTextMetricsW(  HDC hdc,
                                                 UINT cjCopy,
                                                 LPOUTLINETEXTMETRICW potm);
]]

--[[
#ifdef UNICODE
#define GetOutlineTextMetrics  GetOutlineTextMetricsW
#else
#define GetOutlineTextMetrics  GetOutlineTextMetricsA
#endif // !UNICODE
--]]


ffi.cdef[[
 UINT  __stdcall GetPaletteEntries(    HPALETTE hpal,
                                             UINT iStart,
                                             UINT cEntries,
                                             LPPALETTEENTRY pPalEntries);
 COLORREF __stdcall GetPixel(  HDC hdc,  int x,  int y);
 int   __stdcall GetPixelFormat(  HDC hdc);
 int   __stdcall GetPolyFillMode(  HDC hdc);
 BOOL  __stdcall GetRasterizerCaps(    LPRASTERIZER_STATUS lpraststat,
                                             UINT cjBytes);

 int   __stdcall GetRandomRgn ( HDC hdc,  HRGN hrgn,  INT i);
 DWORD __stdcall GetRegionData(    HRGN hrgn,
                                         DWORD nCount,
                                        LPRGNDATA lpRgnData);
 int   __stdcall GetRgnBox(  HRGN hrgn,  LPRECT lprc);
 HGDIOBJ __stdcall GetStockObject(  int i);
 int   __stdcall GetStretchBltMode( HDC hdc);
]]

ffi.cdef[[
UINT
__stdcall
GetSystemPaletteEntries(
     HDC  hdc,
     UINT iStart,
     UINT cEntries,
     LPPALETTEENTRY pPalEntries
    );

 UINT  __stdcall GetSystemPaletteUse( HDC hdc);
 int   __stdcall GetTextCharacterExtra( HDC hdc);
 UINT  __stdcall GetTextAlign( HDC hdc);
 COLORREF __stdcall GetTextColor( HDC hdc);
]]

ffi.cdef[[
BOOL
__stdcall
GetTextExtentPointA(
     HDC hdc,
    LPCSTR lpString,
     int c,
    LPSIZE lpsz
    );

BOOL
__stdcall
GetTextExtentPointW(
     HDC hdc,
    LPCWSTR lpString,
     int c,
    LPSIZE lpsz
    );
]]

--[[
#ifdef UNICODE
#define GetTextExtentPoint  GetTextExtentPointW
#else
#define GetTextExtentPoint  GetTextExtentPointA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
GetTextExtentPoint32A(
     HDC hdc,
    LPCSTR lpString,
     int c,
    LPSIZE psizl
    );

BOOL
__stdcall
GetTextExtentPoint32W(
     HDC hdc,
    LPCWSTR lpString,
     int c,
    LPSIZE psizl
    );
]]

--[[
#ifdef UNICODE
#define GetTextExtentPoint32  GetTextExtentPoint32W
#else
#define GetTextExtentPoint32  GetTextExtentPoint32A
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
GetTextExtentExPointA(
     HDC hdc,
    LPCSTR lpszString,
     int cchString,
     int nMaxExtent,
     LPINT lpnFit,
    LPINT lpnDx,
    LPSIZE lpSize
    );

BOOL
__stdcall
GetTextExtentExPointW(
     HDC hdc,
    LPCWSTR lpszString,
     int cchString,
     int nMaxExtent,
     LPINT lpnFit,
    LPINT lpnDx,
    LPSIZE lpSize
    );
]]

--[[
#ifdef UNICODE
#define GetTextExtentExPoint  GetTextExtentExPointW
#else
#define GetTextExtentExPoint  GetTextExtentExPointA
#endif // !UNICODE
--]]

ffi.cdef[[
 int __stdcall GetTextCharset(  HDC hdc);
 int __stdcall GetTextCharsetInfo(  HDC hdc,  LPFONTSIGNATURE lpSig,  DWORD dwFlags);
 BOOL __stdcall TranslateCharsetInfo( DWORD  *lpSrc, LPCHARSETINFO lpCs,  DWORD dwFlags);
 DWORD __stdcall GetFontLanguageInfo(  HDC hdc);
 DWORD __stdcall GetCharacterPlacementA(   HDC hdc, LPCSTR lpString,  int nCount,  int nMexExtent, LPGCP_RESULTSA lpResults,  DWORD dwFlags);
 DWORD __stdcall GetCharacterPlacementW(   HDC hdc, LPCWSTR lpString,  int nCount,  int nMexExtent, LPGCP_RESULTSW lpResults,  DWORD dwFlags);
]]

 --[[
#ifdef UNICODE
#define GetCharacterPlacement  GetCharacterPlacementW
#else
#define GetCharacterPlacement  GetCharacterPlacementA
#endif // !UNICODE
--]]


ffi.cdef[[
typedef struct tagWCRANGE
{
    WCHAR  wcLow;
    USHORT cGlyphs;
} WCRANGE, *PWCRANGE, *LPWCRANGE;


typedef struct tagGLYPHSET
{
    DWORD    cbThis;
    DWORD    flAccel;
    DWORD    cGlyphsSupported;
    DWORD    cRanges;
    WCRANGE  ranges[1];
} GLYPHSET, *PGLYPHSET,  *LPGLYPHSET;
]]

--[=[
/* flAccel flags for the GLYPHSET structure above */

#define GS_8BIT_INDICES     0x00000001

/* flags for GetGlyphIndices */

#define GGI_MARK_NONEXISTING_GLYPHS  0X0001

 DWORD __stdcall GetFontUnicodeRanges(  HDC hdc,  LPGLYPHSET lpgs);
 DWORD __stdcall GetGlyphIndicesA(  HDC hdc, _In_reads_(c) LPCSTR lpstr,  int c, _Out_writes_(c) LPWORD pgi,  DWORD fl);
 DWORD __stdcall GetGlyphIndicesW(  HDC hdc, _In_reads_(c) LPCWSTR lpstr,  int c, _Out_writes_(c) LPWORD pgi,  DWORD fl);
--]=]

--[[
#ifdef UNICODE
#define GetGlyphIndices  GetGlyphIndicesW
#else
#define GetGlyphIndices  GetGlyphIndicesA
#endif // !UNICODE
--]]

ffi.cdef[[
 BOOL  __stdcall GetTextExtentPointI( HDC hdc, LPWORD pgiIn,  int cgi, LPSIZE psize);
 BOOL  __stdcall GetTextExtentExPointI (   HDC hdc,
                                                LPWORD lpwszString,
                                                 int cwchString,
                                                 int nMaxExtent,
                                                 LPINT lpnFit,
                                                LPINT lpnDx,
                                                 LPSIZE lpSize
                                                );

 BOOL  __stdcall GetCharWidthI(    HDC hdc,
                                         UINT giFirst,
                                         UINT cgi,
                                         LPWORD pgi,
                                         LPINT piWidths
                                        );

 BOOL  __stdcall GetCharABCWidthsI(    HDC    hdc,
                                             UINT   giFirst,
                                             UINT   cgi,
                                             LPWORD pgi,
                                             LPABC  pabc
                                        );
]]

ffi.cdef[[
//#define STAMP_DESIGNVECTOR  (0x8000000 + 'd' + ('v' << 8))
//#define STAMP_AXESLIST      (0x8000000 + 'a' + ('l' << 8))
static const int MM_MAX_NUMAXES     = 16;
]]

ffi.cdef[[
typedef struct tagDESIGNVECTOR
{
    DWORD  dvReserved;
    DWORD  dvNumAxes;
    LONG   dvValues[MM_MAX_NUMAXES];
} DESIGNVECTOR, *PDESIGNVECTOR,  *LPDESIGNVECTOR;

 int  __stdcall AddFontResourceExA(  LPCSTR name,  DWORD fl,  PVOID res);
 int  __stdcall AddFontResourceExW(  LPCWSTR name,  DWORD fl,  PVOID res);
]]

--[[
#ifdef UNICODE
#define AddFontResourceEx  AddFontResourceExW
#else
#define AddFontResourceEx  AddFontResourceExA
#endif // !UNICODE
--]]

ffi.cdef[[
 BOOL __stdcall RemoveFontResourceExA(  LPCSTR name,  DWORD fl,  PVOID pdv);
 BOOL __stdcall RemoveFontResourceExW(  LPCWSTR name,  DWORD fl,  PVOID pdv);
]]

--[[
#ifdef UNICODE
#define RemoveFontResourceEx  RemoveFontResourceExW
#else
#define RemoveFontResourceEx  RemoveFontResourceExA
#endif // !UNICODE
--]]

ffi.cdef[[
 HANDLE __stdcall AddFontMemResourceEx(  PVOID pFileView,
                                                 DWORD cjSize,
                                                 PVOID pvResrved,
                                                 DWORD* pNumFonts);

 BOOL __stdcall RemoveFontMemResourceEx(  HANDLE h);

static const int FR_PRIVATE     = 0x10;
static const int FR_NOT_ENUM    = 0x20;
]]

ffi.cdef[[
// The actual size of the DESIGNVECTOR and ENUMLOGFONTEXDV structures
// is determined by dvNumAxes,
// MM_MAX_NUMAXES only detemines the maximal size allowed

static const int MM_MAX_AXES_NAMELEN  = 16;

typedef struct tagAXISINFOA
{
    LONG   axMinValue;
    LONG   axMaxValue;
    BYTE   axAxisName[MM_MAX_AXES_NAMELEN];
} AXISINFOA, *PAXISINFOA,  *LPAXISINFOA;
typedef struct tagAXISINFOW
{
    LONG   axMinValue;
    LONG   axMaxValue;
    WCHAR  axAxisName[MM_MAX_AXES_NAMELEN];
} AXISINFOW, *PAXISINFOW,  *LPAXISINFOW;
]]

--[[
#ifdef UNICODE
typedef AXISINFOW AXISINFO;
typedef PAXISINFOW PAXISINFO;
typedef LPAXISINFOW LPAXISINFO;
#else
typedef AXISINFOA AXISINFO;
typedef PAXISINFOA PAXISINFO;
typedef LPAXISINFOA LPAXISINFO;
#endif // UNICODE
--]]

ffi.cdef[[
typedef struct tagAXESLISTA
{
    DWORD     axlReserved;
    DWORD     axlNumAxes;
    AXISINFOA axlAxisInfo[MM_MAX_NUMAXES];
} AXESLISTA, *PAXESLISTA,  *LPAXESLISTA;
typedef struct tagAXESLISTW
{
    DWORD     axlReserved;
    DWORD     axlNumAxes;
    AXISINFOW axlAxisInfo[MM_MAX_NUMAXES];
} AXESLISTW, *PAXESLISTW,  *LPAXESLISTW;
]]

--[[
#ifdef UNICODE
typedef AXESLISTW AXESLIST;
typedef PAXESLISTW PAXESLIST;
typedef LPAXESLISTW LPAXESLIST;
#else
typedef AXESLISTA AXESLIST;
typedef PAXESLISTA PAXESLIST;
typedef LPAXESLISTA LPAXESLIST;
#endif // UNICODE
--]]

ffi.cdef[[
// The actual size of the AXESLIST and ENUMTEXTMETRIC structure is
// determined by axlNumAxes,
// MM_MAX_NUMAXES only detemines the maximal size allowed

typedef struct tagENUMLOGFONTEXDVA
{
    ENUMLOGFONTEXA elfEnumLogfontEx;
    DESIGNVECTOR   elfDesignVector;
} ENUMLOGFONTEXDVA, *PENUMLOGFONTEXDVA,  *LPENUMLOGFONTEXDVA;

typedef struct tagENUMLOGFONTEXDVW
{
    ENUMLOGFONTEXW elfEnumLogfontEx;
    DESIGNVECTOR   elfDesignVector;
} ENUMLOGFONTEXDVW, *PENUMLOGFONTEXDVW,  *LPENUMLOGFONTEXDVW;
]]

--[[
#ifdef UNICODE
typedef ENUMLOGFONTEXDVW ENUMLOGFONTEXDV;
typedef PENUMLOGFONTEXDVW PENUMLOGFONTEXDV;
typedef LPENUMLOGFONTEXDVW LPENUMLOGFONTEXDV;
#else
typedef ENUMLOGFONTEXDVA ENUMLOGFONTEXDV;
typedef PENUMLOGFONTEXDVA PENUMLOGFONTEXDV;
typedef LPENUMLOGFONTEXDVA LPENUMLOGFONTEXDV;
#endif // UNICODE
--]]

ffi.cdef[[
 HFONT  __stdcall CreateFontIndirectExA(  const ENUMLOGFONTEXDVA *);
 HFONT  __stdcall CreateFontIndirectExW(  const ENUMLOGFONTEXDVW *);
]]

 --[[
#ifdef UNICODE
#define CreateFontIndirectEx  CreateFontIndirectExW
#else
#define CreateFontIndirectEx  CreateFontIndirectExA
#endif // !UNICODE
--]]

ffi.cdef[[
typedef struct tagENUMTEXTMETRICA
{
    NEWTEXTMETRICEXA etmNewTextMetricEx;
    AXESLISTA        etmAxesList;
} ENUMTEXTMETRICA, *PENUMTEXTMETRICA,  *LPENUMTEXTMETRICA;
typedef struct tagENUMTEXTMETRICW
{
    NEWTEXTMETRICEXW etmNewTextMetricEx;
    AXESLISTW        etmAxesList;
} ENUMTEXTMETRICW, *PENUMTEXTMETRICW,  *LPENUMTEXTMETRICW;
]]

--[[
#ifdef UNICODE
typedef ENUMTEXTMETRICW ENUMTEXTMETRIC;
typedef PENUMTEXTMETRICW PENUMTEXTMETRIC;
typedef LPENUMTEXTMETRICW LPENUMTEXTMETRIC;
#else
typedef ENUMTEXTMETRICA ENUMTEXTMETRIC;
typedef PENUMTEXTMETRICA PENUMTEXTMETRIC;
typedef LPENUMTEXTMETRICA LPENUMTEXTMETRIC;
#endif // UNICODE
#endif /* NOTEXTMETRIC */
--]]



ffi.cdef[[
 BOOL  __stdcall GetViewportExtEx(  HDC hdc, LPSIZE lpsize);
 BOOL  __stdcall GetViewportOrgEx(  HDC hdc, LPPOINT lppoint);
 BOOL  __stdcall GetWindowExtEx(  HDC hdc, LPSIZE lpsize);
 BOOL  __stdcall GetWindowOrgEx(  HDC hdc, LPPOINT lppoint);

  int  __stdcall IntersectClipRect(  HDC hdc,  int left,  int top,  int right,  int bottom);
  BOOL __stdcall InvertRgn(  HDC hdc,  HRGN hrgn);
 BOOL __stdcall LineDDA(  int xStart,  int yStart,  int xEnd,  int yEnd,  LINEDDAPROC lpProc,  LPARAM data);
  BOOL __stdcall LineTo(  HDC hdc,  int x,  int y);
 BOOL __stdcall MaskBlt(  HDC hdcDest,  int xDest,  int yDest,  int width,  int height,
               HDC hdcSrc,  int xSrc,  int ySrc,  HBITMAP hbmMask,  int xMask,  int yMask,  DWORD rop);
 BOOL __stdcall PlgBlt(  HDC hdcDest, const POINT * lpPoint,  HDC hdcSrc,  int xSrc,  int ySrc,  int width,
                      int height,  HBITMAP hbmMask,  int xMask,  int yMask);

  int  __stdcall OffsetClipRgn( HDC hdc,  int x,  int y);
 int  __stdcall OffsetRgn( HRGN hrgn,  int x,  int y);
  BOOL __stdcall PatBlt( HDC hdc,  int x,  int y,  int w,  int h,  DWORD rop);
  BOOL __stdcall Pie( HDC hdc,  int left,  int top,  int right,  int bottom,  int xr1,  int yr1,  int xr2,  int yr2);
 BOOL __stdcall PlayMetaFile( HDC hdc,  HMETAFILE hmf);
  BOOL __stdcall PaintRgn( HDC hdc,  HRGN hrgn);
  BOOL __stdcall PolyPolygon( HDC hdc,   const POINT *apt,  const INT *asz,   int csz);
 BOOL __stdcall PtInRegion( HRGN hrgn,  int x,  int y);
 BOOL __stdcall PtVisible( HDC hdc,  int x,  int y);
 BOOL __stdcall RectInRegion( HRGN hrgn,  const RECT * lprect);
 BOOL __stdcall RectVisible( HDC hdc,  const RECT * lprect);
  BOOL __stdcall Rectangle( HDC hdc,  int left,  int top,  int right,  int bottom);
  BOOL __stdcall RestoreDC( HDC hdc,  int nSavedDC);
  HDC  __stdcall ResetDCA( HDC hdc,  const DEVMODEA * lpdm);
  HDC  __stdcall ResetDCW( HDC hdc,  const DEVMODEW * lpdm);
]]

--[[
#ifdef UNICODE
#define ResetDC  ResetDCW
#else
#define ResetDC  ResetDCA
#endif // !UNICODE
  UINT __stdcall RealizePalette( HDC hdc);
 BOOL __stdcall RemoveFontResourceA( LPCSTR lpFileName);
 BOOL __stdcall RemoveFontResourceW( LPCWSTR lpFileName);
--]]

--[[
#ifdef UNICODE
#define RemoveFontResource  RemoveFontResourceW
#else
#define RemoveFontResource  RemoveFontResourceA
#endif // !UNICODE
--]]

ffi.cdef[[
  BOOL  __stdcall RoundRect( HDC hdc,  int left,  int top,  int right,  int bottom,  int width,  int height);
  BOOL __stdcall ResizePalette( HPALETTE hpal,  UINT n);

  int  __stdcall SaveDC( HDC hdc);
  int  __stdcall SelectClipRgn( HDC hdc,  HRGN hrgn);
 int  __stdcall ExtSelectClipRgn( HDC hdc,  HRGN hrgn,  int mode);
 int  __stdcall SetMetaRgn( HDC hdc);
  HGDIOBJ __stdcall SelectObject( HDC hdc,  HGDIOBJ h);
  HPALETTE __stdcall SelectPalette( HDC hdc,  HPALETTE hPal,  BOOL bForceBkgd);
  COLORREF __stdcall SetBkColor( HDC hdc,  COLORREF color);


 COLORREF __stdcall SetDCBrushColor( HDC hdc,  COLORREF color);
 COLORREF __stdcall SetDCPenColor( HDC hdc,  COLORREF color);


  int   __stdcall SetBkMode( HDC hdc,  int mode);


LONG __stdcall
SetBitmapBits(
     HBITMAP hbm,
     DWORD cb,
    const VOID *pvBits);

 UINT  __stdcall SetBoundsRect( HDC hdc,  const RECT * lprect,  UINT flags);
 int   __stdcall SetDIBits( HDC hdc,  HBITMAP hbm,  UINT start,  UINT cLines,  const VOID *lpBits,  const BITMAPINFO * lpbmi,  UINT ColorUse);
  int   __stdcall SetDIBitsToDevice( HDC hdc,  int xDest,  int yDest,  DWORD w,  DWORD h,  int xSrc,
         int ySrc,  UINT StartScan,  UINT cLines,  const VOID * lpvBits,  const BITMAPINFO * lpbmi,  UINT ColorUse);
  DWORD __stdcall SetMapperFlags( HDC hdc,  DWORD flags);
 int   __stdcall SetGraphicsMode( HDC hdc,  int iMode);
  int   __stdcall SetMapMode( HDC hdc,  int iMode);
]]

ffi.cdef[[
DWORD __stdcall SetLayout( HDC hdc,  DWORD l);
DWORD __stdcall GetLayout( HDC hdc);
]]

ffi.cdef[[
 HMETAFILE   __stdcall SetMetaFileBitsEx( UINT cbBuffer, const BYTE *lpData);
]]

ffi.cdef[[
  UINT  __stdcall SetPaletteEntries(    HPALETTE hpal,
                                             UINT iStart,
                                             UINT cEntries,
                                            const PALETTEENTRY *pPalEntries);
  COLORREF __stdcall SetPixel( HDC hdc,  int x,  int y,  COLORREF color);
 BOOL   __stdcall SetPixelV( HDC hdc,  int x,  int y,  COLORREF color);
 BOOL  __stdcall SetPixelFormat( HDC hdc,  int format,  const PIXELFORMATDESCRIPTOR * ppfd);
  int   __stdcall SetPolyFillMode( HDC hdc,  int mode);
  BOOL  __stdcall StretchBlt( HDC hdcDest,  int xDest,  int yDest,  int wDest,  int hDest,  HDC hdcSrc,  int xSrc,  int ySrc,  int wSrc,  int hSrc,  DWORD rop);
 BOOL   __stdcall SetRectRgn( HRGN hrgn,  int left,  int top,  int right,  int bottom);
  int   __stdcall StretchDIBits( HDC hdc,  int xDest,  int yDest,  int DestWidth,  int DestHeight,  int xSrc,  int ySrc,  int SrcWidth,  int SrcHeight,
         const VOID * lpBits,  const BITMAPINFO * lpbmi,  UINT iUsage,  DWORD rop);
  int   __stdcall SetROP2( HDC hdc,  int rop2);
  int   __stdcall SetStretchBltMode( HDC hdc,  int mode);
 UINT  __stdcall SetSystemPaletteUse( HDC hdc,  UINT use);
  int   __stdcall SetTextCharacterExtra( HDC hdc,  int extra);
  COLORREF __stdcall SetTextColor( HDC hdc,  COLORREF color);
  UINT  __stdcall SetTextAlign( HDC hdc,  UINT align);
  BOOL  __stdcall SetTextJustification( HDC hdc,  int extra,  int count);
 BOOL  __stdcall UpdateColors( HDC hdc);
]]



ffi.cdef[[
typedef PVOID   (__stdcall *GDIMARSHALLOC)(DWORD dwSize,  LPVOID pGdiRef);

typedef HRESULT (__stdcall *DDRAWMARSHCALLBACKMARSHAL)( HGDIOBJ hGdiObj,  LPVOID pGdiRef, LPVOID *ppDDrawRef);
typedef HRESULT (__stdcall *DDRAWMARSHCALLBACKUNMARSHAL)( LPVOID pData, HDC *phdc, LPVOID *ppDDrawRef);
typedef HRESULT (__stdcall *DDRAWMARSHCALLBACKRELEASE)( LPVOID pDDrawRef);
]]

ffi.cdef[[
static const int GDIREGISTERDDRAWPACKETVERSION   = 0x1;

typedef struct {
    DWORD                       dwSize;
    DWORD                       dwVersion;
    DDRAWMARSHCALLBACKMARSHAL   pfnDdMarshal;
    DDRAWMARSHCALLBACKUNMARSHAL pfnDdUnmarshal;
    DDRAWMARSHCALLBACKRELEASE   pfnDdRelease;
} GDIREGISTERDDRAWPACKET, *PGDIREGISTERDDRAWPACKET;

 BOOL    __stdcall   GdiRegisterDdraw( PGDIREGISTERDDRAWPACKET pPacket, GDIMARSHALLOC *ppfnGdiAlloc);

 ULONG   __stdcall   GdiMarshalSize(void);
 VOID    __stdcall   GdiMarshal(DWORD dwProcessIdTo,  HGDIOBJ hGdiObj, PVOID pData, ULONG ulFlags);
 HGDIOBJ __stdcall   GdiUnmarshal( PVOID pData, ULONG ulFlags);
]]

ffi.cdef[[
//
// image blt
//

typedef USHORT COLOR16;

typedef struct _TRIVERTEX
{
    LONG    x;
    LONG    y;
    COLOR16 Red;
    COLOR16 Green;
    COLOR16 Blue;
    COLOR16 Alpha;
}TRIVERTEX,*PTRIVERTEX,*LPTRIVERTEX;
]]



ffi.cdef[[
typedef struct _GRADIENT_TRIANGLE
{
    ULONG Vertex1;
    ULONG Vertex2;
    ULONG Vertex3;
} GRADIENT_TRIANGLE,*PGRADIENT_TRIANGLE,*LPGRADIENT_TRIANGLE;

typedef struct _GRADIENT_RECT
{
    ULONG UpperLeft;
    ULONG LowerRight;
}GRADIENT_RECT,*PGRADIENT_RECT,*LPGRADIENT_RECT;
]]


ffi.cdef[[
typedef struct _BLENDFUNCTION
{
    BYTE   BlendOp;
    BYTE   BlendFlags;
    BYTE   SourceConstantAlpha;
    BYTE   AlphaFormat;
}BLENDFUNCTION,*PBLENDFUNCTION;
]]



ffi.cdef[[
static const int AC_SRC_OVER                = 0x00;
static const int AC_SRC_ALPHA               = 0x01;

 BOOL __stdcall AlphaBlend(
     HDC hdcDest,
     int xoriginDest,
     int yoriginDest,
     int wDest,
     int hDest,
     HDC hdcSrc,
     int xoriginSrc,
     int yoriginSrc,
     int wSrc,
     int hSrc,
     BLENDFUNCTION ftn);

 BOOL __stdcall TransparentBlt(
     HDC hdcDest,
     int xoriginDest,
     int yoriginDest,
     int wDest,
     int hDest,
     HDC hdcSrc,
     int xoriginSrc,
     int yoriginSrc,
     int wSrc,
     int hSrc,
     UINT crTransparent);
]]

ffi.cdef[[
//
// gradient drawing modes
//

static const int GRADIENT_FILL_RECT_H   = 0x00000000;
static const int GRADIENT_FILL_RECT_V   = 0x00000001;
static const int GRADIENT_FILL_TRIANGLE = 0x00000002;
static const int GRADIENT_FILL_OP_FLAG  = 0x000000ff;


BOOL
__stdcall
GradientFill(
     HDC hdc,
    PTRIVERTEX pVertex,
     ULONG nVertex,
     PVOID pMesh,
     ULONG nMesh,
     ULONG ulMode
    );



 BOOL  __stdcall GdiAlphaBlend( HDC hdcDest,  int xoriginDest,  int yoriginDest,  int wDest,  int hDest,  HDC hdcSrc,  int xoriginSrc,  int yoriginSrc,  int wSrc,  int hSrc,  BLENDFUNCTION ftn);

 BOOL  __stdcall GdiTransparentBlt( HDC hdcDest, int xoriginDest,  int yoriginDest,  int wDest,  int hDest,  HDC hdcSrc,
                                            int xoriginSrc,  int yoriginSrc,  int wSrc,  int hSrc,  UINT crTransparent);

 BOOL  __stdcall GdiGradientFill(  HDC hdc,
                                        PTRIVERTEX pVertex,
                                         ULONG nVertex,
                                         PVOID pMesh,
                                         ULONG nCount,
                                         ULONG ulMode);


]]

ffi.cdef[[
 BOOL  __stdcall PlayMetaFileRecord(   HDC hdc,
                                            LPHANDLETABLE lpHandleTable,
                                             LPMETARECORD lpMR,
                                             UINT noObjs);

typedef int (__stdcall * MFENUMPROC)(  HDC hdc,  HANDLETABLE * lpht,  METARECORD * lpMR,  int nObj,  LPARAM param);
 BOOL  __stdcall EnumMetaFile(  HDC hdc,  HMETAFILE hmf,  MFENUMPROC proc,  LPARAM param);

typedef int (__stdcall * ENHMFENUMPROC)( HDC hdc,  HANDLETABLE * lpht,  const ENHMETARECORD * lpmr,  int nHandles,  LPARAM data);
]]

ffi.cdef[[
// Enhanced Metafile Function Declarations

 HENHMETAFILE __stdcall CloseEnhMetaFile(  HDC hdc);
 HENHMETAFILE __stdcall CopyEnhMetaFileA(  HENHMETAFILE hEnh,  LPCSTR lpFileName);
 HENHMETAFILE __stdcall CopyEnhMetaFileW(  HENHMETAFILE hEnh,  LPCWSTR lpFileName);
]]
 --[[
#ifdef UNICODE
#define CopyEnhMetaFile  CopyEnhMetaFileW
#else
#define CopyEnhMetaFile  CopyEnhMetaFileA
#endif // !UNICODE
--]]

ffi.cdef[[
 HDC   __stdcall CreateEnhMetaFileA(  HDC hdc,  LPCSTR lpFilename,  const RECT *lprc,  LPCSTR lpDesc);
 HDC   __stdcall CreateEnhMetaFileW(  HDC hdc,  LPCWSTR lpFilename,  const RECT *lprc,  LPCWSTR lpDesc);
]]

--[[
 #ifdef UNICODE
#define CreateEnhMetaFile  CreateEnhMetaFileW
#else
#define CreateEnhMetaFile  CreateEnhMetaFileA
#endif // !UNICODE
--]]

ffi.cdef[[
 BOOL  __stdcall DeleteEnhMetaFile(  HENHMETAFILE hmf);
 BOOL  __stdcall EnumEnhMetaFile(  HDC hdc,  HENHMETAFILE hmf,  ENHMFENUMPROC proc,
                                         LPVOID param,  const RECT * lpRect);
 HENHMETAFILE  __stdcall GetEnhMetaFileA(  LPCSTR lpName);
 HENHMETAFILE  __stdcall GetEnhMetaFileW(  LPCWSTR lpName);
]]


 --[[
#ifdef UNICODE
#define GetEnhMetaFile  GetEnhMetaFileW
#else
#define GetEnhMetaFile  GetEnhMetaFileA
#endif // !UNICODE
--]]

ffi.cdef[[
 UINT  __stdcall GetEnhMetaFileBits(   HENHMETAFILE hEMF,
                                             UINT nSize,
                                            LPBYTE lpData);
 UINT  __stdcall GetEnhMetaFileDescriptionA(   HENHMETAFILE hemf,
                                                     UINT cchBuffer,
                                                    LPSTR lpDescription);
 UINT  __stdcall GetEnhMetaFileDescriptionW(   HENHMETAFILE hemf,
                                                     UINT cchBuffer,
                                                     LPWSTR lpDescription);
]]

--[[
#ifdef UNICODE
#define GetEnhMetaFileDescription  GetEnhMetaFileDescriptionW
#else
#define GetEnhMetaFileDescription  GetEnhMetaFileDescriptionA
#endif // !UNICODE
--]]

ffi.cdef[[
 UINT  __stdcall GetEnhMetaFileHeader(     HENHMETAFILE hemf,
                                                 UINT nSize,
                                                 LPENHMETAHEADER lpEnhMetaHeader);
 UINT  __stdcall GetEnhMetaFilePaletteEntries( HENHMETAFILE hemf,
                                                     UINT nNumEntries,
                                                    LPPALETTEENTRY lpPaletteEntries);

 UINT  __stdcall GetEnhMetaFilePixelFormat(    HENHMETAFILE hemf,
                                                     UINT cbBuffer,
                                                     PIXELFORMATDESCRIPTOR *ppfd);
 UINT  __stdcall GetWinMetaFileBits(   HENHMETAFILE hemf,
                                             UINT cbData16,
                                             LPBYTE pData16,
                                             INT iMapMode,
                                             HDC hdcRef);
 BOOL  __stdcall PlayEnhMetaFile(  HDC hdc,  HENHMETAFILE hmf,  const RECT * lprect);
 BOOL  __stdcall PlayEnhMetaFileRecord(    HDC hdc,
                                                 LPHANDLETABLE pht,
                                                 const ENHMETARECORD *pmr,
                                                 UINT cht);

 HENHMETAFILE  __stdcall SetEnhMetaFileBits(   UINT nSize,
                                                    const BYTE * pb);

 HENHMETAFILE  __stdcall SetWinMetaFileBits(   UINT nSize,
                                                     const BYTE *lpMeta16Data,
                                                     HDC hdcRef,
                                                     const METAFILEPICT *lpMFP);
 BOOL  __stdcall GdiComment( HDC hdc,  UINT nSize,  const BYTE *lpData);
]]


ffi.cdef[[
 BOOL __stdcall GetTextMetricsA(  HDC hdc, LPTEXTMETRICA lptm);
 BOOL __stdcall GetTextMetricsW(  HDC hdc, LPTEXTMETRICW lptm);
]]

 --[[
 #ifdef UNICODE
#define GetTextMetrics  GetTextMetricsW
#else
#define GetTextMetrics  GetTextMetricsA
#endif // !UNICODE
--]]

ffi.cdef[[
typedef struct tagDIBSECTION {
    BITMAP       dsBm;
    BITMAPINFOHEADER    dsBmih;
    DWORD               dsBitfields[3];
    HANDLE              dshSection;
    DWORD               dsOffset;
} DIBSECTION,  *LPDIBSECTION, *PDIBSECTION;
]]

ffi.cdef[[
 BOOL __stdcall AngleArc(  HDC hdc,  int x,  int y,  DWORD r,  FLOAT StartAngle,  FLOAT SweepAngle);
 BOOL __stdcall PolyPolyline( HDC hdc,  const POINT *apt, const DWORD *asz,  DWORD csz);
 BOOL __stdcall GetWorldTransform(  HDC hdc, LPXFORM lpxf);
 BOOL __stdcall SetWorldTransform(  HDC hdc,  const XFORM * lpxf);
 BOOL __stdcall ModifyWorldTransform(  HDC hdc,  const XFORM * lpxf,  DWORD mode);
 BOOL __stdcall CombineTransform(LPXFORM lpxfOut,  const XFORM *lpxf1,  const XFORM *lpxf2);
]]


function exports.GDI_WIDTHBYTES(bits) 
    return band((bits+31), bnot(31)) / 8
end

function exports.GDI_DIBWIDTHBYTES(bi) 
    return GDI_WIDTHBYTES(bi.biWidth * bi.biBitCount);
end

function exports.GDI__DIBSIZE(bi) 
    return exports.GDI_DIBWIDTHBYTES(bi) * bi.biHeight
end

function exports.GDI_DIBSIZE(bi) 
    if bi.biHeight < 0 then 
        return -1*exports.GDI__DIBSIZE(bi); 
    end
    
    return exports.GDI__DIBSIZE(bi);
end


ffi.cdef[[
HBITMAP __stdcall CreateDIBSection(
            HDC               hdc,
            const BITMAPINFO *pbmi,
            UINT              usage,
            VOID            **ppvBits,
            HANDLE            hSection,
            DWORD             offset);
]]

ffi.cdef[[

 UINT __stdcall GetDIBColorTable(  HDC  hdc,
                                         UINT iStart,
                                         UINT cEntries,
                                        RGBQUAD *prgbq);
 UINT __stdcall SetDIBColorTable(  HDC  hdc,
                                         UINT iStart,
                                         UINT cEntries,
                                        const RGBQUAD *prgbq);
]]

--[=[
/* Flags value for COLORADJUSTMENT */
#define CA_NEGATIVE                 0x0001
#define CA_LOG_FILTER               0x0002

/* IlluminantIndex values */
#define ILLUMINANT_DEVICE_DEFAULT   0
#define ILLUMINANT_A                1
#define ILLUMINANT_B                2
#define ILLUMINANT_C                3
#define ILLUMINANT_D50              4
#define ILLUMINANT_D55              5
#define ILLUMINANT_D65              6
#define ILLUMINANT_D75              7
#define ILLUMINANT_F2               8
#define ILLUMINANT_MAX_INDEX        ILLUMINANT_F2

#define ILLUMINANT_TUNGSTEN         ILLUMINANT_A
#define ILLUMINANT_DAYLIGHT         ILLUMINANT_C
#define ILLUMINANT_FLUORESCENT      ILLUMINANT_F2
#define ILLUMINANT_NTSC             ILLUMINANT_C

/* Min and max for RedGamma, GreenGamma, BlueGamma */
#define RGB_GAMMA_MIN               (WORD)02500
#define RGB_GAMMA_MAX               (WORD)65000

/* Min and max for ReferenceBlack and ReferenceWhite */
#define REFERENCE_WHITE_MIN         (WORD)6000
#define REFERENCE_WHITE_MAX         (WORD)10000
#define REFERENCE_BLACK_MIN         (WORD)0
#define REFERENCE_BLACK_MAX         (WORD)4000

/* Min and max for Contrast, Brightness, Colorfulness, RedGreenTint */
#define COLOR_ADJ_MIN               (SHORT)-100
#define COLOR_ADJ_MAX               (SHORT)100
--]=]

ffi.cdef[[
typedef struct  tagCOLORADJUSTMENT {
    WORD   caSize;
    WORD   caFlags;
    WORD   caIlluminantIndex;
    WORD   caRedGamma;
    WORD   caGreenGamma;
    WORD   caBlueGamma;
    WORD   caReferenceBlack;
    WORD   caReferenceWhite;
    SHORT  caContrast;
    SHORT  caBrightness;
    SHORT  caColorfulness;
    SHORT  caRedGreenTint;
} COLORADJUSTMENT, *PCOLORADJUSTMENT,  *LPCOLORADJUSTMENT;
]]

ffi.cdef[[
 BOOL __stdcall SetColorAdjustment(  HDC hdc,  const COLORADJUSTMENT *lpca);
 BOOL __stdcall GetColorAdjustment(  HDC hdc,  LPCOLORADJUSTMENT lpca);
 HPALETTE __stdcall CreateHalftonePalette(  HDC hdc);
]]

ffi.cdef[[
typedef BOOL (__stdcall* ABORTPROC)(  HDC,  int);
]]

ffi.cdef[[
typedef struct _DOCINFOA {
    int     cbSize;
    LPCSTR   lpszDocName;
    LPCSTR   lpszOutput;
    LPCSTR   lpszDatatype;
    DWORD    fwType;
} DOCINFOA, *LPDOCINFOA;


typedef struct _DOCINFOW {
    int     cbSize;
    LPCWSTR  lpszDocName;
    LPCWSTR  lpszOutput;
    LPCWSTR  lpszDatatype;
    DWORD    fwType;
} DOCINFOW, *LPDOCINFOW;
]]

--[[
#ifdef UNICODE
typedef DOCINFOW DOCINFO;
typedef LPDOCINFOW LPDOCINFO;
#else
typedef DOCINFOA DOCINFO;
typedef LPDOCINFOA LPDOCINFO;
#endif // UNICODE
--]]

ffi.cdef[[
static const int DI_APPBANDING              = 0x00000001;
static const int DI_ROPS_READ_DESTINATION   = 0x00000002;


  int __stdcall StartDocA( HDC hdc,  const DOCINFOA *lpdi);
  int __stdcall StartDocW( HDC hdc,  const DOCINFOW *lpdi);
]]

--[[
#ifdef UNICODE
#define StartDoc  StartDocW
#else
#define StartDoc  StartDocA
#endif // !UNICODE
--]]

ffi.cdef[[
  int __stdcall EndDoc( HDC hdc);
  int __stdcall StartPage( HDC hdc);
  int __stdcall EndPage( HDC hdc);
  int __stdcall AbortDoc( HDC hdc);
 int __stdcall SetAbortProc( HDC hdc,  ABORTPROC proc);
]]

ffi.cdef[[
 BOOL __stdcall AbortPath( HDC hdc);
 BOOL __stdcall ArcTo( HDC hdc,  int left,  int top,  int right,  int bottom,  int xr1,  int yr1,  int xr2,  int yr2);
 BOOL __stdcall BeginPath( HDC hdc);
 BOOL __stdcall CloseFigure( HDC hdc);
 BOOL __stdcall EndPath( HDC hdc);
 BOOL __stdcall FillPath( HDC hdc);
 BOOL __stdcall FlattenPath( HDC hdc);
 int  __stdcall GetPath( HDC hdc,  LPPOINT apt,  LPBYTE aj, int cpt);
 HRGN __stdcall PathToRegion( HDC hdc);
 BOOL __stdcall PolyDraw( HDC hdc,  const POINT * apt,  const BYTE * aj,  int cpt);
 BOOL __stdcall SelectClipPath( HDC hdc,  int mode);
 int  __stdcall SetArcDirection( HDC hdc,  int dir);
 BOOL __stdcall SetMiterLimit( HDC hdc,  FLOAT limit,  PFLOAT old);
 BOOL __stdcall StrokeAndFillPath( HDC hdc);
 BOOL __stdcall StrokePath( HDC hdc);
 BOOL __stdcall WidenPath( HDC hdc);
 HPEN __stdcall ExtCreatePen(  DWORD iPenStyle,
                                     DWORD cWidth,
                                     const LOGBRUSH *plbrush,
                                     DWORD cStyle,
                                    const DWORD *pstyle);
 BOOL __stdcall GetMiterLimit( HDC hdc, PFLOAT plimit);
 int  __stdcall GetArcDirection( HDC hdc);

 int   __stdcall GetObjectA( HANDLE h,  int c, LPVOID pv);
 int   __stdcall GetObjectW( HANDLE h,  int c, LPVOID pv);
 ]]

--[[ 
#ifdef UNICODE
#define GetObject  GetObjectW
#else
#define GetObject  GetObjectA
#endif // !UNICODE
--]]

ffi.cdef[[
  BOOL  __stdcall MoveToEx(  HDC hdc,  int x,  int y,  LPPOINT lppt);
  BOOL  __stdcall TextOutA(  HDC hdc,  int x,  int y,  LPCSTR lpString,  int c);
  BOOL  __stdcall TextOutW(  HDC hdc,  int x,  int y, LPCWSTR lpString,  int c);
]]

--[[
#ifdef UNICODE
#define TextOut  TextOutW
#else
#define TextOut  TextOutA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL  __stdcall ExtTextOutA(  HDC hdc,  int x,  int y,  UINT options,  const RECT * lprect,  LPCSTR lpString,  UINT c,  const INT * lpDx);
BOOL  __stdcall ExtTextOutW(  HDC hdc,  int x,  int y,  UINT options,  const RECT * lprect,  LPCWSTR lpString,  UINT c,  const INT * lpDx);
]]

--[[
#ifdef UNICODE
#define ExtTextOut  ExtTextOutW
#else
#define ExtTextOut  ExtTextOutA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL  __stdcall PolyTextOutA( HDC hdc,  const POLYTEXTA * ppt,  int nstrings);
BOOL  __stdcall PolyTextOutW( HDC hdc,  const POLYTEXTW * ppt,  int nstrings);
]]

--[[
#ifdef UNICODE
#define PolyTextOut  PolyTextOutW
#else
#define PolyTextOut  PolyTextOutA
#endif // !UNICODE
--]]

ffi.cdef[[
 HRGN  __stdcall CreatePolygonRgn(     const POINT *pptl,
                                             int cPoint,
                                             int iMode);
 BOOL  __stdcall DPtoLP(  HDC hdc,  LPPOINT lppt,  int c);
 BOOL  __stdcall LPtoDP(  HDC hdc,  LPPOINT lppt,  int c);
  BOOL  __stdcall Polygon( HDC hdc,  const POINT *apt,  int cpt);
  BOOL  __stdcall Polyline( HDC hdc,  const POINT *apt,  int cpt);

 BOOL  __stdcall PolyBezier( HDC hdc,  const POINT * apt,  DWORD cpt);
 BOOL  __stdcall PolyBezierTo( HDC hdc,  const POINT * apt,  DWORD cpt);
 BOOL  __stdcall PolylineTo( HDC hdc,  const POINT * apt,  DWORD cpt);

  BOOL  __stdcall SetViewportExtEx(  HDC hdc,  int x,  int y,  LPSIZE lpsz);
  BOOL  __stdcall SetViewportOrgEx(  HDC hdc,  int x,  int y,  LPPOINT lppt);
  BOOL  __stdcall SetWindowExtEx(  HDC hdc,  int x,  int y,  LPSIZE lpsz);
  BOOL  __stdcall SetWindowOrgEx(  HDC hdc,  int x,  int y,  LPPOINT lppt);

  BOOL  __stdcall OffsetViewportOrgEx(  HDC hdc,  int x,  int y,  LPPOINT lppt);
  BOOL  __stdcall OffsetWindowOrgEx(  HDC hdc,  int x,  int y,  LPPOINT lppt);
  BOOL  __stdcall ScaleViewportExtEx(  HDC hdc,  int xn,  int dx,  int yn,  int yd,  LPSIZE lpsz);
  BOOL  __stdcall ScaleWindowExtEx(  HDC hdc,  int xn,  int xd,  int yn,  int yd,  LPSIZE lpsz);
 BOOL  __stdcall SetBitmapDimensionEx(  HBITMAP hbm,  int w,  int h,  LPSIZE lpsz);
 BOOL  __stdcall SetBrushOrgEx(  HDC hdc,  int x,  int y,  LPPOINT lppt);
]]

ffi.cdef[[
BOOL __stdcall ScaleRgn( HDC hdc,  HRGN hrgn);
BOOL __stdcall ScaleValues( HDC hdc,  LPLONG pl,  UINT cl);
LONG __stdcall GetDCDpiScaleValue( HDC hdc);
LONG __stdcall GetBitmapDpiScaleValue( HBITMAP hsurf);


 int   __stdcall GetTextFaceA(  HDC hdc,  int c,   LPSTR lpName);
 int   __stdcall GetTextFaceW(  HDC hdc,  int c,   LPWSTR lpName);
]]

 --[[
#ifdef UNICODE
#define GetTextFace  GetTextFaceW
#else
#define GetTextFace  GetTextFaceA
#endif // !UNICODE
--]]

--[=[
#define FONTMAPPER_MAX 10

typedef struct tagKERNINGPAIR {
   WORD wFirst;
   WORD wSecond;
   int  iKernAmount;
} KERNINGPAIR, *LPKERNINGPAIR;

 DWORD __stdcall GetKerningPairsA(     HDC hdc,
                                             DWORD nPairs,
                                            _Out_writes_to_opt_(nPairs, return) LPKERNINGPAIR   lpKernPair);
 DWORD __stdcall GetKerningPairsW(     HDC hdc,
                                             DWORD nPairs,
                                            _Out_writes_to_opt_(nPairs, return) LPKERNINGPAIR   lpKernPair);
--[[
#ifdef UNICODE
#define GetKerningPairs  GetKerningPairsW
#else
#define GetKerningPairs  GetKerningPairsA
#endif // !UNICODE
--]]
--]=]

ffi.cdef[[
 BOOL  __stdcall GetDCOrgEx(  HDC hdc,  LPPOINT lppt);
 BOOL  __stdcall FixBrushOrgEx(  HDC hdc,  int x,  int y,   LPPOINT ptl);
 BOOL  __stdcall UnrealizeObject(  HGDIOBJ h);

 BOOL  __stdcall GdiFlush(void);
 DWORD __stdcall GdiSetBatchLimit(  DWORD dw);
 DWORD __stdcall GdiGetBatchLimit(void);
]]

ffi.cdef[[
static const int ICM_OFF              = 1;
static const int ICM_ON               = 2;
static const int ICM_QUERY            = 3;
static const int ICM_DONE_OUTSIDEDC   = 4;
]]

ffi.cdef[[
typedef int (__stdcall* ICMENUMPROCA)(LPSTR, LPARAM);
typedef int (__stdcall* ICMENUMPROCW)(LPWSTR, LPARAM);
]]

--[[
#ifdef UNICODE
#define ICMENUMPROC  ICMENUMPROCW
#else
#define ICMENUMPROC  ICMENUMPROCA
#endif // !UNICODE
--]]

ffi.cdef[[
 int         __stdcall SetICMMode(  HDC hdc,  int mode);
 BOOL        __stdcall CheckColorsInGamut(     HDC hdc,
                                                    LPRGBTRIPLE lpRGBTriple,
                                                    LPVOID dlpBuffer,
                                                     DWORD nCount);

 HCOLORSPACE __stdcall GetColorSpace(  HDC hdc);
 BOOL        __stdcall GetLogColorSpaceA(  HCOLORSPACE hColorSpace,
                                                LPLOGCOLORSPACEA lpBuffer,
                                                 DWORD nSize);
 BOOL        __stdcall GetLogColorSpaceW(  HCOLORSPACE hColorSpace,
                                                LPLOGCOLORSPACEW lpBuffer,
                                                 DWORD nSize);
]]

--[[
#ifdef UNICODE
#define GetLogColorSpace  GetLogColorSpaceW
#else
#define GetLogColorSpace  GetLogColorSpaceA
#endif // !UNICODE
--]]

ffi.cdef[[
 HCOLORSPACE __stdcall CreateColorSpaceA(  LPLOGCOLORSPACEA lplcs);
 HCOLORSPACE __stdcall CreateColorSpaceW(  LPLOGCOLORSPACEW lplcs);
]]

--[[
 #ifdef UNICODE
#define CreateColorSpace  CreateColorSpaceW
#else
#define CreateColorSpace  CreateColorSpaceA
#endif // !UNICODE
--]]

ffi.cdef[[
 HCOLORSPACE __stdcall SetColorSpace(  HDC hdc,  HCOLORSPACE hcs);
 BOOL        __stdcall DeleteColorSpace(  HCOLORSPACE hcs);
 BOOL        __stdcall GetICMProfileA(     HDC hdc,
                                                LPDWORD pBufSize,
                                                LPSTR pszFilename);
 BOOL        __stdcall GetICMProfileW(     HDC hdc,
                                                LPDWORD pBufSize,
                                                LPWSTR pszFilename);
]]

--[[
#ifdef UNICODE
#define GetICMProfile  GetICMProfileW
#else
#define GetICMProfile  GetICMProfileA
#endif // !UNICODE
--]]

ffi.cdef[[
 BOOL        __stdcall SetICMProfileA(  HDC hdc,  LPSTR lpFileName);
 BOOL        __stdcall SetICMProfileW(  HDC hdc,  LPWSTR lpFileName);
]]

--[[
#ifdef UNICODE
#define SetICMProfile  SetICMProfileW
#else
#define SetICMProfile  SetICMProfileA
#endif // !UNICODE
-]]

ffi.cdef[[
 BOOL        __stdcall GetDeviceGammaRamp(  HDC hdc, LPVOID lpRamp);
 BOOL        __stdcall SetDeviceGammaRamp(  HDC hdc, LPVOID lpRamp);
 BOOL        __stdcall ColorMatchToTarget(  HDC hdc,  HDC hdcTarget,  DWORD action);
 int         __stdcall EnumICMProfilesA(  HDC hdc,  ICMENUMPROCA proc,  LPARAM param);
 int         __stdcall EnumICMProfilesW(  HDC hdc,  ICMENUMPROCW proc,  LPARAM param);
]]

--[[
#ifdef UNICODE
#define EnumICMProfiles  EnumICMProfilesW
#else
#define EnumICMProfiles  EnumICMProfilesA
#endif // !UNICODE
--]]


ffi.cdef[[
 BOOL        __stdcall ColorCorrectPalette(  HDC hdc,  HPALETTE hPal,  DWORD deFirst,  DWORD num);
]]


--if not NOMETAFILE
ffi.cdef[[
static const int ENHMETA_SIGNATURE     =  0x464D4520;   // ' ELF'
]]


ffi.cdef[[
// Stock object flag used in the object handle index in the enhanced
// metafile records.
// E.g. The object handle index (META_STOCK_OBJECT | BLACK_BRUSH)
// represents the stock object BLACK_BRUSH.

static const int ENHMETA_STOCK_OBJECT    = 0x80000000;
]]

ffi.cdef[[
// Enhanced metafile record types.

static const int EMR_HEADER                    =  1;
static const int EMR_POLYBEZIER                =  2;
static const int EMR_POLYGON                   =  3;
static const int EMR_POLYLINE                  =  4;
static const int EMR_POLYBEZIERTO              =  5;
static const int EMR_POLYLINETO                =  6;
static const int EMR_POLYPOLYLINE              =  7;
static const int EMR_POLYPOLYGON               =  8;
static const int EMR_SETWINDOWEXTEX            =  9;
static const int EMR_SETWINDOWORGEX            =  10;
static const int EMR_SETVIEWPORTEXTEX          =  11;
static const int EMR_SETVIEWPORTORGEX          =  12;
static const int EMR_SETBRUSHORGEX             =  13;
static const int EMR_EOF                       =  14;
static const int EMR_SETPIXELV                 =  15;
static const int EMR_SETMAPPERFLAGS            =  16;
static const int EMR_SETMAPMODE                =  17;
static const int EMR_SETBKMODE                 =  18;
static const int EMR_SETPOLYFILLMODE           =  19;
static const int EMR_SETROP2                   =  20;
static const int EMR_SETSTRETCHBLTMODE         =  21;
static const int EMR_SETTEXTALIGN              =  22;
static const int EMR_SETCOLORADJUSTMENT        =  23;
static const int EMR_SETTEXTCOLOR              =  24;
static const int EMR_SETBKCOLOR                =  25;
static const int EMR_OFFSETCLIPRGN             =  26;
static const int EMR_MOVETOEX                  =  27;
static const int EMR_SETMETARGN                =  28;
static const int EMR_EXCLUDECLIPRECT           =  29;
static const int EMR_INTERSECTCLIPRECT         =  30;
static const int EMR_SCALEVIEWPORTEXTEX        =  31;
static const int EMR_SCALEWINDOWEXTEX          =  32;
static const int EMR_SAVEDC                    =  33;
static const int EMR_RESTOREDC                 =  34;
static const int EMR_SETWORLDTRANSFORM         =  35;
static const int EMR_MODIFYWORLDTRANSFORM      =  36;
static const int EMR_SELECTOBJECT              =  37;
static const int EMR_CREATEPEN                 =  38;
static const int EMR_CREATEBRUSHINDIRECT       =  39;
static const int EMR_DELETEOBJECT              =  40;
static const int EMR_ANGLEARC                  =  41;
static const int EMR_ELLIPSE                   =  42;
static const int EMR_RECTANGLE                 =  43;
static const int EMR_ROUNDRECT                 =  44;
static const int EMR_ARC                       =  45;
static const int EMR_CHORD                     =  46;
static const int EMR_PIE                       =  47;
static const int EMR_SELECTPALETTE             =  48;
static const int EMR_CREATEPALETTE             =  49;
static const int EMR_SETPALETTEENTRIES         =  50;
static const int EMR_RESIZEPALETTE             =  51;
static const int EMR_REALIZEPALETTE            =  52;
static const int EMR_EXTFLOODFILL              =  53;
static const int EMR_LINETO                    =  54;
static const int EMR_ARCTO                     =  55;
static const int EMR_POLYDRAW                  =  56;
static const int EMR_SETARCDIRECTION           =  57;
static const int EMR_SETMITERLIMIT             =  58;
static const int EMR_BEGINPATH                 =  59;
static const int EMR_ENDPATH                   =  60;
static const int EMR_CLOSEFIGURE               =  61;
static const int EMR_FILLPATH                  =  62;
static const int EMR_STROKEANDFILLPATH         =  63;
static const int EMR_STROKEPATH                =  64;
static const int EMR_FLATTENPATH               =  65;
static const int EMR_WIDENPATH                 =  66;
static const int EMR_SELECTCLIPPATH            =  67;
static const int EMR_ABORTPATH                 =  68;

static const int EMR_GDICOMMENT                =  70;
static const int EMR_FILLRGN                   =  71;
static const int EMR_FRAMERGN                  =  72;
static const int EMR_INVERTRGN                 =  73;
static const int EMR_PAINTRGN                  =  74;
static const int EMR_EXTSELECTCLIPRGN          =  75;
static const int EMR_BITBLT                    =  76;
static const int EMR_STRETCHBLT                =  77;
static const int EMR_MASKBLT                   =  78;
static const int EMR_PLGBLT                    =  79;
static const int EMR_SETDIBITSTODEVICE         =  80;
static const int EMR_STRETCHDIBITS             =  81;
static const int EMR_EXTCREATEFONTINDIRECTW    =  82;
static const int EMR_EXTTEXTOUTA               =  83;
static const int EMR_EXTTEXTOUTW               =  84;
static const int EMR_POLYBEZIER16              =  85;
static const int EMR_POLYGON16                 =  86;
static const int EMR_POLYLINE16                =  87;
static const int EMR_POLYBEZIERTO16            =  88;
static const int EMR_POLYLINETO16              =  89;
static const int EMR_POLYPOLYLINE16            =  90;
static const int EMR_POLYPOLYGON16             =  91;
static const int EMR_POLYDRAW16                =  92;
static const int EMR_CREATEMONOBRUSH           =  93;
static const int EMR_CREATEDIBPATTERNBRUSHPT   =  94;
static const int EMR_EXTCREATEPEN              =  95;
static const int EMR_POLYTEXTOUTA              =  96;
static const int EMR_POLYTEXTOUTW              =  97;


static const int EMR_SETICMMODE                =  98;
static const int EMR_CREATECOLORSPACE          =  99;
static const int EMR_SETCOLORSPACE             = 100;
static const int EMR_DELETECOLORSPACE          = 101;
static const int EMR_GLSRECORD                 = 102;
static const int EMR_GLSBOUNDEDRECORD          = 103;
static const int EMR_PIXELFORMAT               = 104;



static const int EMR_RESERVED_105              = 105;
static const int EMR_RESERVED_106              = 106;
static const int EMR_RESERVED_107              = 107;
static const int EMR_RESERVED_108              = 108;
static const int EMR_RESERVED_109              = 109;
static const int EMR_RESERVED_110              = 110;
static const int EMR_COLORCORRECTPALETTE       = 111;
static const int EMR_SETICMPROFILEA            = 112;
static const int EMR_SETICMPROFILEW            = 113;
static const int EMR_ALPHABLEND                = 114;
static const int EMR_SETLAYOUT                 = 115;
static const int EMR_TRANSPARENTBLT            = 116;

static const int EMR_RESERVED_117              = 117;

static const int EMR_GRADIENTFILL              = 118;
static const int EMR_RESERVED_119              = 119;
static const int EMR_RESERVED_120              = 120;
static const int EMR_COLORMATCHTOTARGETW       = 121;
static const int EMR_CREATECOLORSPACEW         = 122;
]]

ffi.cdef[[
static const int EMR_MIN                        =  1;

static const int EMR_MAX                        = 122;
]]

ffi.cdef[[
// Base record type for the enhanced metafile.

typedef struct tagEMR
{
    DWORD   iType;              // Enhanced metafile record type
    DWORD   nSize;              // Length of the record in bytes.
                                // This must be a multiple of 4.
} EMR, *PEMR;
]]

ffi.cdef[[
// Base text record type for the enhanced metafile.

typedef struct tagEMRTEXT
{
    POINTL  ptlReference;
    DWORD   nChars;
    DWORD   offString;          // Offset to the string
    DWORD   fOptions;
    RECTL   rcl;
    DWORD   offDx;              // Offset to the inter-character spacing array.
                                // This is always given.
} EMRTEXT, *PEMRTEXT;
]]

ffi.cdef[[
// Record structures for the enhanced metafile.

typedef struct tagABORTPATH
{
    EMR     emr;
} EMRABORTPATH,      *PEMRABORTPATH,
  EMRBEGINPATH,      *PEMRBEGINPATH,
  EMRENDPATH,        *PEMRENDPATH,
  EMRCLOSEFIGURE,    *PEMRCLOSEFIGURE,
  EMRFLATTENPATH,    *PEMRFLATTENPATH,
  EMRWIDENPATH,      *PEMRWIDENPATH,
  EMRSETMETARGN,     *PEMRSETMETARGN,
  EMRSAVEDC,         *PEMRSAVEDC,
  EMRREALIZEPALETTE, *PEMRREALIZEPALETTE;
]]

ffi.cdef[[
typedef struct tagEMRSELECTCLIPPATH
{
    EMR     emr;
    DWORD   iMode;
} EMRSELECTCLIPPATH,    *PEMRSELECTCLIPPATH,
  EMRSETBKMODE,         *PEMRSETBKMODE,
  EMRSETMAPMODE,        *PEMRSETMAPMODE,
  EMRSETLAYOUT,         *PEMRSETLAYOUT,
  EMRSETPOLYFILLMODE,   *PEMRSETPOLYFILLMODE,
  EMRSETROP2,           *PEMRSETROP2,
  EMRSETSTRETCHBLTMODE, *PEMRSETSTRETCHBLTMODE,
  EMRSETICMMODE,        *PEMRSETICMMODE,
  EMRSETTEXTALIGN,      *PEMRSETTEXTALIGN;
]]

ffi.cdef[[
typedef struct tagEMRSETMITERLIMIT
{
    EMR     emr;
    FLOAT   eMiterLimit;
} EMRSETMITERLIMIT, *PEMRSETMITERLIMIT;
]]

ffi.cdef[[
typedef struct tagEMRRESTOREDC
{
    EMR     emr;
    LONG    iRelative;          // Specifies a relative instance
} EMRRESTOREDC, *PEMRRESTOREDC;

typedef struct tagEMRSETARCDIRECTION
{
    EMR     emr;
    DWORD   iArcDirection;      // Specifies the arc direction in the
                                // advanced graphics mode.
} EMRSETARCDIRECTION, *PEMRSETARCDIRECTION;

typedef struct tagEMRSETMAPPERFLAGS
{
    EMR     emr;
    DWORD   dwFlags;
} EMRSETMAPPERFLAGS, *PEMRSETMAPPERFLAGS;

typedef struct tagEMRSETTEXTCOLOR
{
    EMR     emr;
    COLORREF crColor;
} EMRSETBKCOLOR,   *PEMRSETBKCOLOR,
  EMRSETTEXTCOLOR, *PEMRSETTEXTCOLOR;
]]

ffi.cdef[[
typedef struct tagEMRSELECTOBJECT
{
    EMR     emr;
    DWORD   ihObject;           // Object handle index
} EMRSELECTOBJECT, *PEMRSELECTOBJECT,
  EMRDELETEOBJECT, *PEMRDELETEOBJECT;

typedef struct tagEMRSELECTPALETTE
{
    EMR     emr;
    DWORD   ihPal;              // Palette handle index, background mode only
} EMRSELECTPALETTE, *PEMRSELECTPALETTE;

typedef struct tagEMRRESIZEPALETTE
{
    EMR     emr;
    DWORD   ihPal;              // Palette handle index
    DWORD   cEntries;
} EMRRESIZEPALETTE, *PEMRRESIZEPALETTE;
]]

ffi.cdef[[
typedef struct tagEMRSETPALETTEENTRIES
{
    EMR     emr;
    DWORD   ihPal;              // Palette handle index
    DWORD   iStart;
    DWORD   cEntries;
    PALETTEENTRY aPalEntries[1];// The peFlags fields do not contain any flags
} EMRSETPALETTEENTRIES, *PEMRSETPALETTEENTRIES;

typedef struct tagEMRSETCOLORADJUSTMENT
{
    EMR     emr;
    COLORADJUSTMENT ColorAdjustment;
} EMRSETCOLORADJUSTMENT, *PEMRSETCOLORADJUSTMENT;

typedef struct tagEMRGDICOMMENT
{
    EMR     emr;
    DWORD   cbData;             // Size of data in bytes
    BYTE    Data[1];
} EMRGDICOMMENT, *PEMRGDICOMMENT;

typedef struct tagEMREOF
{
    EMR     emr;
    DWORD   nPalEntries;        // Number of palette entries
    DWORD   offPalEntries;      // Offset to the palette entries
    DWORD   nSizeLast;          // Same as nSize and must be the last DWORD
                                // of the record.  The palette entries,
                                // if exist, precede this field.
} EMREOF, *PEMREOF;

typedef struct tagEMRLINETO
{
    EMR     emr;
    POINTL  ptl;
} EMRLINETO,   *PEMRLINETO,
  EMRMOVETOEX, *PEMRMOVETOEX;

typedef struct tagEMROFFSETCLIPRGN
{
    EMR     emr;
    POINTL  ptlOffset;
} EMROFFSETCLIPRGN, *PEMROFFSETCLIPRGN;

typedef struct tagEMRFILLPATH
{
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
} EMRFILLPATH,          *PEMRFILLPATH,
  EMRSTROKEANDFILLPATH, *PEMRSTROKEANDFILLPATH,
  EMRSTROKEPATH,        *PEMRSTROKEPATH;

typedef struct tagEMREXCLUDECLIPRECT
{
    EMR     emr;
    RECTL   rclClip;
} EMREXCLUDECLIPRECT,   *PEMREXCLUDECLIPRECT,
  EMRINTERSECTCLIPRECT, *PEMRINTERSECTCLIPRECT;
]]

ffi.cdef[[
typedef struct tagEMRSETVIEWPORTORGEX
{
    EMR     emr;
    POINTL  ptlOrigin;
} EMRSETVIEWPORTORGEX, *PEMRSETVIEWPORTORGEX,
  EMRSETWINDOWORGEX,   *PEMRSETWINDOWORGEX,
  EMRSETBRUSHORGEX,    *PEMRSETBRUSHORGEX;

typedef struct tagEMRSETVIEWPORTEXTEX
{
    EMR     emr;
    SIZEL   szlExtent;
} EMRSETVIEWPORTEXTEX, *PEMRSETVIEWPORTEXTEX,
  EMRSETWINDOWEXTEX,   *PEMRSETWINDOWEXTEX;

typedef struct tagEMRSCALEVIEWPORTEXTEX
{
    EMR     emr;
    LONG    xNum;
    LONG    xDenom;
    LONG    yNum;
    LONG    yDenom;
} EMRSCALEVIEWPORTEXTEX, *PEMRSCALEVIEWPORTEXTEX,
  EMRSCALEWINDOWEXTEX,   *PEMRSCALEWINDOWEXTEX;

typedef struct tagEMRSETWORLDTRANSFORM
{
    EMR     emr;
    XFORM   xform;
} EMRSETWORLDTRANSFORM, *PEMRSETWORLDTRANSFORM;

typedef struct tagEMRMODIFYWORLDTRANSFORM
{
    EMR     emr;
    XFORM   xform;
    DWORD   iMode;
} EMRMODIFYWORLDTRANSFORM, *PEMRMODIFYWORLDTRANSFORM;

typedef struct tagEMRSETPIXELV
{
    EMR     emr;
    POINTL  ptlPixel;
    COLORREF crColor;
} EMRSETPIXELV, *PEMRSETPIXELV;
]]

ffi.cdef[[
typedef struct tagEMREXTFLOODFILL
{
    EMR     emr;
    POINTL  ptlStart;
    COLORREF crColor;
    DWORD   iMode;
} EMREXTFLOODFILL, *PEMREXTFLOODFILL;

typedef struct tagEMRELLIPSE
{
    EMR     emr;
    RECTL   rclBox;             // Inclusive-inclusive bounding rectangle
} EMRELLIPSE,  *PEMRELLIPSE,
  EMRRECTANGLE, *PEMRRECTANGLE;


typedef struct tagEMRROUNDRECT
{
    EMR     emr;
    RECTL   rclBox;             // Inclusive-inclusive bounding rectangle
    SIZEL   szlCorner;
} EMRROUNDRECT, *PEMRROUNDRECT;

typedef struct tagEMRARC
{
    EMR     emr;
    RECTL   rclBox;             // Inclusive-inclusive bounding rectangle
    POINTL  ptlStart;
    POINTL  ptlEnd;
} EMRARC,   *PEMRARC,
  EMRARCTO, *PEMRARCTO,
  EMRCHORD, *PEMRCHORD,
  EMRPIE,   *PEMRPIE;

typedef struct tagEMRANGLEARC
{
    EMR     emr;
    POINTL  ptlCenter;
    DWORD   nRadius;
    FLOAT   eStartAngle;
    FLOAT   eSweepAngle;
} EMRANGLEARC, *PEMRANGLEARC;
]]

ffi.cdef[[
typedef struct tagEMRPOLYLINE
{
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   cptl;
    POINTL  aptl[1];
} EMRPOLYLINE,     *PEMRPOLYLINE,
  EMRPOLYBEZIER,   *PEMRPOLYBEZIER,
  EMRPOLYGON,      *PEMRPOLYGON,
  EMRPOLYBEZIERTO, *PEMRPOLYBEZIERTO,
  EMRPOLYLINETO,   *PEMRPOLYLINETO;

typedef struct tagEMRPOLYLINE16
{
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   cpts;
    POINTS  apts[1];
} EMRPOLYLINE16,     *PEMRPOLYLINE16,
  EMRPOLYBEZIER16,   *PEMRPOLYBEZIER16,
  EMRPOLYGON16,      *PEMRPOLYGON16,
  EMRPOLYBEZIERTO16, *PEMRPOLYBEZIERTO16,
  EMRPOLYLINETO16,   *PEMRPOLYLINETO16;

typedef struct tagEMRPOLYDRAW
{
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   cptl;               // Number of points
    POINTL  aptl[1];            // Array of points
    BYTE    abTypes[1];         // Array of point types
} EMRPOLYDRAW, *PEMRPOLYDRAW;

typedef struct tagEMRPOLYDRAW16
{
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   cpts;               // Number of points
    POINTS  apts[1];            // Array of points
    BYTE    abTypes[1];         // Array of point types
} EMRPOLYDRAW16, *PEMRPOLYDRAW16;

typedef struct tagEMRPOLYPOLYLINE
{
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   nPolys;             // Number of polys
    DWORD   cptl;               // Total number of points in all polys
    DWORD   aPolyCounts[1];     // Array of point counts for each poly
    POINTL  aptl[1];            // Array of points
} EMRPOLYPOLYLINE, *PEMRPOLYPOLYLINE,
  EMRPOLYPOLYGON,  *PEMRPOLYPOLYGON;

typedef struct tagEMRPOLYPOLYLINE16
{
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   nPolys;             // Number of polys
    DWORD   cpts;               // Total number of points in all polys
    DWORD   aPolyCounts[1];     // Array of point counts for each poly
    POINTS  apts[1];            // Array of points
} EMRPOLYPOLYLINE16, *PEMRPOLYPOLYLINE16,
  EMRPOLYPOLYGON16,  *PEMRPOLYPOLYGON16;
]]

ffi.cdef[[
typedef struct tagEMRINVERTRGN
{
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   cbRgnData;          // Size of region data in bytes
    BYTE    RgnData[1];
} EMRINVERTRGN, *PEMRINVERTRGN,
  EMRPAINTRGN,  *PEMRPAINTRGN;

typedef struct tagEMRFILLRGN
{
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   cbRgnData;          // Size of region data in bytes
    DWORD   ihBrush;            // Brush handle index
    BYTE    RgnData[1];
} EMRFILLRGN, *PEMRFILLRGN;

typedef struct tagEMRFRAMERGN
{
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   cbRgnData;          // Size of region data in bytes
    DWORD   ihBrush;            // Brush handle index
    SIZEL   szlStroke;
    BYTE    RgnData[1];
} EMRFRAMERGN, *PEMRFRAMERGN;

typedef struct tagEMREXTSELECTCLIPRGN
{
    EMR     emr;
    DWORD   cbRgnData;          // Size of region data in bytes
    DWORD   iMode;
    BYTE    RgnData[1];
} EMREXTSELECTCLIPRGN, *PEMREXTSELECTCLIPRGN;
]]

ffi.cdef[[
typedef struct tagEMREXTTEXTOUTA
{
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   iGraphicsMode;      // Current graphics mode
    FLOAT   exScale;            // X and Y scales from Page units to .01mm units
    FLOAT   eyScale;            //   if graphics mode is GM_COMPATIBLE.
    EMRTEXT emrtext;            // This is followed by the string and spacing
                                // array
} EMREXTTEXTOUTA, *PEMREXTTEXTOUTA,
  EMREXTTEXTOUTW, *PEMREXTTEXTOUTW;

typedef struct tagEMRPOLYTEXTOUTA
{
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   iGraphicsMode;      // Current graphics mode
    FLOAT   exScale;            // X and Y scales from Page units to .01mm units
    FLOAT   eyScale;            //   if graphics mode is GM_COMPATIBLE.
    LONG    cStrings;
    EMRTEXT aemrtext[1];        // Array of EMRTEXT structures.  This is
                                // followed by the strings and spacing arrays.
} EMRPOLYTEXTOUTA, *PEMRPOLYTEXTOUTA,
  EMRPOLYTEXTOUTW, *PEMRPOLYTEXTOUTW;
]]

ffi.cdef[[
typedef struct tagEMRBITBLT
{
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    LONG    xDest;
    LONG    yDest;
    LONG    cxDest;
    LONG    cyDest;
    DWORD   dwRop;
    LONG    xSrc;
    LONG    ySrc;
    XFORM   xformSrc;           // Source DC transform
    COLORREF crBkColorSrc;      // Source DC BkColor in RGB
    DWORD   iUsageSrc;          // Source bitmap info color table usage
                                // (DIB_RGB_COLORS)
    DWORD   offBmiSrc;          // Offset to the source BITMAPINFO structure
    DWORD   cbBmiSrc;           // Size of the source BITMAPINFO structure
    DWORD   offBitsSrc;         // Offset to the source bitmap bits
    DWORD   cbBitsSrc;          // Size of the source bitmap bits
} EMRBITBLT, *PEMRBITBLT;

typedef struct tagEMRSTRETCHBLT
{
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    LONG    xDest;
    LONG    yDest;
    LONG    cxDest;
    LONG    cyDest;
    DWORD   dwRop;
    LONG    xSrc;
    LONG    ySrc;
    XFORM   xformSrc;           // Source DC transform
    COLORREF crBkColorSrc;      // Source DC BkColor in RGB
    DWORD   iUsageSrc;          // Source bitmap info color table usage
                                // (DIB_RGB_COLORS)
    DWORD   offBmiSrc;          // Offset to the source BITMAPINFO structure
    DWORD   cbBmiSrc;           // Size of the source BITMAPINFO structure
    DWORD   offBitsSrc;         // Offset to the source bitmap bits
    DWORD   cbBitsSrc;          // Size of the source bitmap bits
    LONG    cxSrc;
    LONG    cySrc;
} EMRSTRETCHBLT, *PEMRSTRETCHBLT;

typedef struct tagEMRMASKBLT
{
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    LONG    xDest;
    LONG    yDest;
    LONG    cxDest;
    LONG    cyDest;
    DWORD   dwRop;
    LONG    xSrc;
    LONG    ySrc;
    XFORM   xformSrc;           // Source DC transform
    COLORREF crBkColorSrc;      // Source DC BkColor in RGB
    DWORD   iUsageSrc;          // Source bitmap info color table usage
                                // (DIB_RGB_COLORS)
    DWORD   offBmiSrc;          // Offset to the source BITMAPINFO structure
    DWORD   cbBmiSrc;           // Size of the source BITMAPINFO structure
    DWORD   offBitsSrc;         // Offset to the source bitmap bits
    DWORD   cbBitsSrc;          // Size of the source bitmap bits
    LONG    xMask;
    LONG    yMask;
    DWORD   iUsageMask;         // Mask bitmap info color table usage
    DWORD   offBmiMask;         // Offset to the mask BITMAPINFO structure if any
    DWORD   cbBmiMask;          // Size of the mask BITMAPINFO structure if any
    DWORD   offBitsMask;        // Offset to the mask bitmap bits if any
    DWORD   cbBitsMask;         // Size of the mask bitmap bits if any
} EMRMASKBLT, *PEMRMASKBLT;

typedef struct tagEMRPLGBLT
{
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    POINTL  aptlDest[3];
    LONG    xSrc;
    LONG    ySrc;
    LONG    cxSrc;
    LONG    cySrc;
    XFORM   xformSrc;           // Source DC transform
    COLORREF crBkColorSrc;      // Source DC BkColor in RGB
    DWORD   iUsageSrc;          // Source bitmap info color table usage
                                // (DIB_RGB_COLORS)
    DWORD   offBmiSrc;          // Offset to the source BITMAPINFO structure
    DWORD   cbBmiSrc;           // Size of the source BITMAPINFO structure
    DWORD   offBitsSrc;         // Offset to the source bitmap bits
    DWORD   cbBitsSrc;          // Size of the source bitmap bits
    LONG    xMask;
    LONG    yMask;
    DWORD   iUsageMask;         // Mask bitmap info color table usage
    DWORD   offBmiMask;         // Offset to the mask BITMAPINFO structure if any
    DWORD   cbBmiMask;          // Size of the mask BITMAPINFO structure if any
    DWORD   offBitsMask;        // Offset to the mask bitmap bits if any
    DWORD   cbBitsMask;         // Size of the mask bitmap bits if any
} EMRPLGBLT, *PEMRPLGBLT;
]]

ffi.cdef[[
typedef struct tagEMRSETDIBITSTODEVICE
{
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    LONG    xDest;
    LONG    yDest;
    LONG    xSrc;
    LONG    ySrc;
    LONG    cxSrc;
    LONG    cySrc;
    DWORD   offBmiSrc;          // Offset to the source BITMAPINFO structure
    DWORD   cbBmiSrc;           // Size of the source BITMAPINFO structure
    DWORD   offBitsSrc;         // Offset to the source bitmap bits
    DWORD   cbBitsSrc;          // Size of the source bitmap bits
    DWORD   iUsageSrc;          // Source bitmap info color table usage
    DWORD   iStartScan;
    DWORD   cScans;
} EMRSETDIBITSTODEVICE, *PEMRSETDIBITSTODEVICE;

typedef struct tagEMRSTRETCHDIBITS
{
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    LONG    xDest;
    LONG    yDest;
    LONG    xSrc;
    LONG    ySrc;
    LONG    cxSrc;
    LONG    cySrc;
    DWORD   offBmiSrc;          // Offset to the source BITMAPINFO structure
    DWORD   cbBmiSrc;           // Size of the source BITMAPINFO structure
    DWORD   offBitsSrc;         // Offset to the source bitmap bits
    DWORD   cbBitsSrc;          // Size of the source bitmap bits
    DWORD   iUsageSrc;          // Source bitmap info color table usage
    DWORD   dwRop;
    LONG    cxDest;
    LONG    cyDest;
} EMRSTRETCHDIBITS, *PEMRSTRETCHDIBITS;
]]

ffi.cdef[[
typedef struct tagEMREXTCREATEFONTINDIRECTW
{
    EMR     emr;
    DWORD   ihFont;             // Font handle index
    EXTLOGFONTW elfw;
} EMREXTCREATEFONTINDIRECTW, *PEMREXTCREATEFONTINDIRECTW;

typedef struct tagEMRCREATEPALETTE
{
    EMR     emr;
    DWORD   ihPal;              // Palette handle index
    LOGPALETTE lgpl;            // The peFlags fields in the palette entries
                                // do not contain any flags
} EMRCREATEPALETTE, *PEMRCREATEPALETTE;
]]

ffi.cdef[[
typedef struct tagEMRCREATEPEN
{
    EMR     emr;
    DWORD   ihPen;              // Pen handle index
    LOGPEN  lopn;
} EMRCREATEPEN, *PEMRCREATEPEN;

typedef struct tagEMREXTCREATEPEN
{
    EMR     emr;
    DWORD   ihPen;              // Pen handle index
    DWORD   offBmi;             // Offset to the BITMAPINFO structure if any
    DWORD   cbBmi;              // Size of the BITMAPINFO structure if any
                                // The bitmap info is followed by the bitmap
                                // bits to form a packed DIB.
    DWORD   offBits;            // Offset to the brush bitmap bits if any
    DWORD   cbBits;             // Size of the brush bitmap bits if any
    EXTLOGPEN32 elp;            // The extended pen with the style array.
} EMREXTCREATEPEN, *PEMREXTCREATEPEN;

typedef struct tagEMRCREATEBRUSHINDIRECT
{
    EMR        emr;
    DWORD      ihBrush;          // Brush handle index
    LOGBRUSH32 lb;               // The style must be BS_SOLID, BS_HOLLOW,
                                 // BS_NULL or BS_HATCHED.
} EMRCREATEBRUSHINDIRECT, *PEMRCREATEBRUSHINDIRECT;

typedef struct tagEMRCREATEMONOBRUSH
{
    EMR     emr;
    DWORD   ihBrush;            // Brush handle index
    DWORD   iUsage;             // Bitmap info color table usage
    DWORD   offBmi;             // Offset to the BITMAPINFO structure
    DWORD   cbBmi;              // Size of the BITMAPINFO structure
    DWORD   offBits;            // Offset to the bitmap bits
    DWORD   cbBits;             // Size of the bitmap bits
} EMRCREATEMONOBRUSH, *PEMRCREATEMONOBRUSH;
]]

ffi.cdef[[
typedef struct tagEMRCREATEDIBPATTERNBRUSHPT
{
    EMR     emr;
    DWORD   ihBrush;            // Brush handle index
    DWORD   iUsage;             // Bitmap info color table usage
    DWORD   offBmi;             // Offset to the BITMAPINFO structure
    DWORD   cbBmi;              // Size of the BITMAPINFO structure
                                // The bitmap info is followed by the bitmap
                                // bits to form a packed DIB.
    DWORD   offBits;            // Offset to the bitmap bits
    DWORD   cbBits;             // Size of the bitmap bits
} EMRCREATEDIBPATTERNBRUSHPT, *PEMRCREATEDIBPATTERNBRUSHPT;

typedef struct tagEMRFORMAT
{
    DWORD   dSignature;         // Format signature, e.g. ENHMETA_SIGNATURE.
    DWORD   nVersion;           // Format version number.
    DWORD   cbData;             // Size of data in bytes.
    DWORD   offData;            // Offset to data from GDICOMMENT_IDENTIFIER.
                                // It must begin at a DWORD offset.
} EMRFORMAT, *PEMRFORMAT;
]]


ffi.cdef[[
typedef struct tagEMRGLSRECORD
{
    EMR     emr;
    DWORD   cbData;             // Size of data in bytes
    BYTE    Data[1];
} EMRGLSRECORD, *PEMRGLSRECORD;

typedef struct tagEMRGLSBOUNDEDRECORD
{
    EMR     emr;
    RECTL   rclBounds;          // Bounds in recording coordinates
    DWORD   cbData;             // Size of data in bytes
    BYTE    Data[1];
} EMRGLSBOUNDEDRECORD, *PEMRGLSBOUNDEDRECORD;

typedef struct tagEMRPIXELFORMAT
{
    EMR     emr;
    PIXELFORMATDESCRIPTOR pfd;
} EMRPIXELFORMAT, *PEMRPIXELFORMAT;

typedef struct tagEMRCREATECOLORSPACE
{
    EMR             emr;
    DWORD           ihCS;       // ColorSpace handle index
    LOGCOLORSPACEA  lcs;        // Ansi version of LOGCOLORSPACE
} EMRCREATECOLORSPACE, *PEMRCREATECOLORSPACE;

typedef struct tagEMRSETCOLORSPACE
{
    EMR     emr;
    DWORD   ihCS;               // ColorSpace handle index
} EMRSETCOLORSPACE,    *PEMRSETCOLORSPACE,
  EMRSELECTCOLORSPACE, *PEMRSELECTCOLORSPACE,
  EMRDELETECOLORSPACE, *PEMRDELETECOLORSPACE;

]]

ffi.cdef[[

typedef struct tagEMREXTESCAPE
{
    EMR     emr;
    INT     iEscape;            // Escape code
    INT     cbEscData;          // Size of escape data
    BYTE    EscData[1];         // Escape data
} EMREXTESCAPE,  *PEMREXTESCAPE,
  EMRDRAWESCAPE, *PEMRDRAWESCAPE;

typedef struct tagEMRNAMEDESCAPE
{
    EMR     emr;
    INT     iEscape;            // Escape code
    INT     cbDriver;           // Size of driver name
    INT     cbEscData;          // Size of escape data
    BYTE    EscData[1];         // Driver name and Escape data
} EMRNAMEDESCAPE, *PEMRNAMEDESCAPE;
]]

ffi.cdef[[
static const int SETICMPROFILE_EMBEDED          = 0x00000001;

typedef struct tagEMRSETICMPROFILE
{
    EMR     emr;
    DWORD   dwFlags;            // flags
    DWORD   cbName;             // Size of desired profile name
    DWORD   cbData;             // Size of raw profile data if attached
    BYTE    Data[1];            // Array size is cbName + cbData
} EMRSETICMPROFILE,  *PEMRSETICMPROFILE,
  EMRSETICMPROFILEA, *PEMRSETICMPROFILEA,
  EMRSETICMPROFILEW, *PEMRSETICMPROFILEW;
]]

ffi.cdef[[
static const int CREATECOLORSPACE_EMBEDED     =   0x00000001;

typedef struct tagEMRCREATECOLORSPACEW
{
    EMR             emr;
    DWORD           ihCS;       // ColorSpace handle index
    LOGCOLORSPACEW  lcs;        // Unicode version of logical color space structure
    DWORD           dwFlags;    // flags
    DWORD           cbData;     // size of raw source profile data if attached
    BYTE            Data[1];    // Array size is cbData
} EMRCREATECOLORSPACEW, *PEMRCREATECOLORSPACEW;
]]

ffi.cdef[[
static const int COLORMATCHTOTARGET_EMBEDED     = 0x00000001;

typedef struct tagCOLORMATCHTOTARGET
{
    EMR     emr;
    DWORD   dwAction;           // CS_ENABLE, CS_DISABLE or CS_DELETE_TRANSFORM
    DWORD   dwFlags;            // flags
    DWORD   cbName;             // Size of desired target profile name
    DWORD   cbData;             // Size of raw target profile data if attached
    BYTE    Data[1];            // Array size is cbName + cbData
} EMRCOLORMATCHTOTARGET, *PEMRCOLORMATCHTOTARGET;
]]

ffi.cdef[[
typedef struct tagCOLORCORRECTPALETTE
{
    EMR     emr;
    DWORD   ihPalette;          // Palette handle index
    DWORD   nFirstEntry;        // Index of first entry to correct
    DWORD   nPalEntries;        // Number of palette entries to correct
    DWORD   nReserved;          // Reserved
} EMRCOLORCORRECTPALETTE, *PEMRCOLORCORRECTPALETTE;
]]

ffi.cdef[[
typedef struct tagEMRALPHABLEND
{
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    LONG    xDest;
    LONG    yDest;
    LONG    cxDest;
    LONG    cyDest;
    DWORD   dwRop;
    LONG    xSrc;
    LONG    ySrc;
    XFORM   xformSrc;           // Source DC transform
    COLORREF crBkColorSrc;      // Source DC BkColor in RGB
    DWORD   iUsageSrc;          // Source bitmap info color table usage
                                // (DIB_RGB_COLORS)
    DWORD   offBmiSrc;          // Offset to the source BITMAPINFO structure
    DWORD   cbBmiSrc;           // Size of the source BITMAPINFO structure
    DWORD   offBitsSrc;         // Offset to the source bitmap bits
    DWORD   cbBitsSrc;          // Size of the source bitmap bits
    LONG    cxSrc;
    LONG    cySrc;
} EMRALPHABLEND, *PEMRALPHABLEND;
]]

ffi.cdef[[
typedef struct tagEMRGRADIENTFILL
{
    EMR       emr;
    RECTL     rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD     nVer;
    DWORD     nTri;
    ULONG     ulMode;
    TRIVERTEX Ver[1];
}EMRGRADIENTFILL,*PEMRGRADIENTFILL;
]]

ffi.cdef[[
typedef struct tagEMRTRANSPARENTBLT
{
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    LONG    xDest;
    LONG    yDest;
    LONG    cxDest;
    LONG    cyDest;
    DWORD   dwRop;
    LONG    xSrc;
    LONG    ySrc;
    XFORM   xformSrc;           // Source DC transform
    COLORREF crBkColorSrc;      // Source DC BkColor in RGB
    DWORD   iUsageSrc;          // Source bitmap info color table usage
                                // (DIB_RGB_COLORS)
    DWORD   offBmiSrc;          // Offset to the source BITMAPINFO structure
    DWORD   cbBmiSrc;           // Size of the source BITMAPINFO structure
    DWORD   offBitsSrc;         // Offset to the source bitmap bits
    DWORD   cbBitsSrc;          // Size of the source bitmap bits
    LONG    cxSrc;
    LONG    cySrc;
} EMRTRANSPARENTBLT, *PEMRTRANSPARENTBLT;
]]

ffi.cdef[[
static const int GDICOMMENT_IDENTIFIER          = 0x43494447;
static const int GDICOMMENT_WINDOWS_METAFILE    = 0x80000001;
static const int GDICOMMENT_BEGINGROUP          = 0x00000002;
static const int GDICOMMENT_ENDGROUP            = 0x00000003;
static const int GDICOMMENT_MULTIFORMATS        = 0x40000004;
static const int EPS_SIGNATURE                  = 0x46535045;
static const int GDICOMMENT_UNICODE_STRING      = 0x00000040;
static const int GDICOMMENT_UNICODE_END         = 0x00000080;
]]

ffi.cdef[[
// OpenGL wgl prototypes

 BOOL  __stdcall wglCopyContext(HGLRC, HGLRC, UINT);
 HGLRC __stdcall wglCreateContext(HDC);
 HGLRC __stdcall wglCreateLayerContext(HDC, int);
 BOOL  __stdcall wglDeleteContext(HGLRC);
 HGLRC __stdcall wglGetCurrentContext(VOID);
 HDC   __stdcall wglGetCurrentDC(VOID);
 PROC  __stdcall wglGetProcAddress(LPCSTR);
 BOOL  __stdcall wglMakeCurrent(HDC, HGLRC);
 BOOL  __stdcall wglShareLists(HGLRC, HGLRC);
 BOOL  __stdcall wglUseFontBitmapsA(HDC, DWORD, DWORD, DWORD);
 BOOL  __stdcall wglUseFontBitmapsW(HDC, DWORD, DWORD, DWORD);
]]

--[[
#ifdef UNICODE
#define wglUseFontBitmaps  wglUseFontBitmapsW
#else
#define wglUseFontBitmaps  wglUseFontBitmapsA
#endif // !UNICODE
--]]

ffi.cdef[[
 BOOL  __stdcall SwapBuffers(HDC);

typedef struct _POINTFLOAT {
    FLOAT   x;
    FLOAT   y;
} POINTFLOAT, *PPOINTFLOAT;

typedef struct _GLYPHMETRICSFLOAT {
    FLOAT       gmfBlackBoxX;
    FLOAT       gmfBlackBoxY;
    POINTFLOAT  gmfptGlyphOrigin;
    FLOAT       gmfCellIncX;
    FLOAT       gmfCellIncY;
} GLYPHMETRICSFLOAT, *PGLYPHMETRICSFLOAT, *LPGLYPHMETRICSFLOAT;
]]

ffi.cdef[[
static const int WGL_FONT_LINES     = 0;
static const int WGL_FONT_POLYGONS  = 1;

 BOOL  __stdcall wglUseFontOutlinesA(HDC, DWORD, DWORD, DWORD, FLOAT,
                                           FLOAT, int, LPGLYPHMETRICSFLOAT);
 BOOL  __stdcall wglUseFontOutlinesW(HDC, DWORD, DWORD, DWORD, FLOAT,
                                           FLOAT, int, LPGLYPHMETRICSFLOAT);
]]

--[[
#ifdef UNICODE
#define wglUseFontOutlines  wglUseFontOutlinesW
#else
#define wglUseFontOutlines  wglUseFontOutlinesA
#endif // !UNICODE
--]]

ffi.cdef[[
/* Layer plane descriptor */
typedef struct tagLAYERPLANEDESCRIPTOR { // lpd
    WORD  nSize;
    WORD  nVersion;
    DWORD dwFlags;
    BYTE  iPixelType;
    BYTE  cColorBits;
    BYTE  cRedBits;
    BYTE  cRedShift;
    BYTE  cGreenBits;
    BYTE  cGreenShift;
    BYTE  cBlueBits;
    BYTE  cBlueShift;
    BYTE  cAlphaBits;
    BYTE  cAlphaShift;
    BYTE  cAccumBits;
    BYTE  cAccumRedBits;
    BYTE  cAccumGreenBits;
    BYTE  cAccumBlueBits;
    BYTE  cAccumAlphaBits;
    BYTE  cDepthBits;
    BYTE  cStencilBits;
    BYTE  cAuxBuffers;
    BYTE  iLayerPlane;
    BYTE  bReserved;
    COLORREF crTransparent;
} LAYERPLANEDESCRIPTOR, *PLAYERPLANEDESCRIPTOR, *LPLAYERPLANEDESCRIPTOR;
]]

ffi.cdef[[
/* LAYERPLANEDESCRIPTOR flags */
static const int LPD_DOUBLEBUFFER       = 0x00000001;
static const int LPD_STEREO             = 0x00000002;
static const int LPD_SUPPORT_GDI        = 0x00000010;
static const int LPD_SUPPORT_OPENGL     = 0x00000020;
static const int LPD_SHARE_DEPTH        = 0x00000040;
static const int LPD_SHARE_STENCIL      = 0x00000080;
static const int LPD_SHARE_ACCUM        = 0x00000100;
static const int LPD_SWAP_EXCHANGE      = 0x00000200;
static const int LPD_SWAP_COPY          = 0x00000400;
static const int LPD_TRANSPARENT        = 0x00001000;

static const int LPD_TYPE_RGBA       = 0;
static const int LPD_TYPE_COLORINDEX = 1;

/* wglSwapLayerBuffers flags */
static const int WGL_SWAP_MAIN_PLANE    = 0x00000001;
static const int WGL_SWAP_OVERLAY1      = 0x00000002;
static const int WGL_SWAP_OVERLAY2      = 0x00000004;
static const int WGL_SWAP_OVERLAY3      = 0x00000008;
static const int WGL_SWAP_OVERLAY4      = 0x00000010;
static const int WGL_SWAP_OVERLAY5      = 0x00000020;
static const int WGL_SWAP_OVERLAY6      = 0x00000040;
static const int WGL_SWAP_OVERLAY7      = 0x00000080;
static const int WGL_SWAP_OVERLAY8      = 0x00000100;
static const int WGL_SWAP_OVERLAY9      = 0x00000200;
static const int WGL_SWAP_OVERLAY10     = 0x00000400;
static const int WGL_SWAP_OVERLAY11     = 0x00000800;
static const int WGL_SWAP_OVERLAY12     = 0x00001000;
static const int WGL_SWAP_OVERLAY13     = 0x00002000;
static const int WGL_SWAP_OVERLAY14     = 0x00004000;
static const int WGL_SWAP_OVERLAY15     = 0x00008000;
static const int WGL_SWAP_UNDERLAY1     = 0x00010000;
static const int WGL_SWAP_UNDERLAY2     = 0x00020000;
static const int WGL_SWAP_UNDERLAY3     = 0x00040000;
static const int WGL_SWAP_UNDERLAY4     = 0x00080000;
static const int WGL_SWAP_UNDERLAY5     = 0x00100000;
static const int WGL_SWAP_UNDERLAY6     = 0x00200000;
static const int WGL_SWAP_UNDERLAY7     = 0x00400000;
static const int WGL_SWAP_UNDERLAY8     = 0x00800000;
static const int WGL_SWAP_UNDERLAY9     = 0x01000000;
static const int WGL_SWAP_UNDERLAY10    = 0x02000000;
static const int WGL_SWAP_UNDERLAY11    = 0x04000000;
static const int WGL_SWAP_UNDERLAY12    = 0x08000000;
static const int WGL_SWAP_UNDERLAY13    = 0x10000000;
static const int WGL_SWAP_UNDERLAY14    = 0x20000000;
static const int WGL_SWAP_UNDERLAY15    = 0x40000000;
]]

ffi.cdef[[
 BOOL  __stdcall wglDescribeLayerPlane(HDC, int, int, UINT,
                                             LPLAYERPLANEDESCRIPTOR);
 int   __stdcall wglSetLayerPaletteEntries(HDC, int, int, int,
                                                 const COLORREF *);
 int   __stdcall wglGetLayerPaletteEntries(HDC, int, int, int,
                                                 COLORREF *);
 BOOL  __stdcall wglRealizeLayerPalette(HDC, int, BOOL);
 BOOL  __stdcall wglSwapLayerBuffers(HDC, UINT);
]]

ffi.cdef[[
typedef struct _WGLSWAP
{
    HDC hdc;
    UINT uiFlags;
} WGLSWAP, *PWGLSWAP,  *LPWGLSWAP;

static const int WGL_SWAPMULTIPLE_MAX = 16;

 DWORD __stdcall wglSwapMultipleBuffers(UINT, const WGLSWAP *);
]]

return exports
