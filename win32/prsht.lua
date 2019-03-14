local ffi = require("ffi")

require("win32.winapifamily")


-- prsht.h - - Interface for the Windows Property Sheet Pages                  *

--[[
//
// Define API decoration for direct importing of DLL references.
//
#ifndef WINCOMMCTRLAPI
#if !defined(_COMCTL32_) && defined(_WIN32)
#define WINCOMMCTRLAPI DECLSPEC_IMPORT
#else
#define WINCOMMCTRLAPI
#endif
#endif // WINCOMMCTRLAPI
--]]


--[[
#ifdef _WIN64
#include <pshpack8.h>
#else
#include <pshpack4.h>
#endif
--]]



--if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

--[[
#ifndef SNDMSG
#ifdef __cplusplus
#ifndef _MAC
#define SNDMSG ::SendMessage
#else
#define SNDMSG ::AfxSendMessage
#endif
#else
#ifndef _MAC
#define SNDMSG SendMessage
#else
#define SNDMSG AfxSendMessage
#endif
#endif
#endif // ifndef SNDMSG
--]]


--[[
#ifndef PSTMSG
#ifdef __cplusplus
#define PSTMSG ::PostMessage
#else
#define PSTMSG PostMessage
#endif
#endif // ifndef PSTMSG
--]]

ffi.cdef[[
static const int MAXPROPPAGES  = 100;

struct _PSP;
typedef struct _PSP * HPROPSHEETPAGE;
]]

ffi.cdef[[
struct _PROPSHEETPAGEA;
struct _PROPSHEETPAGEW;
]]

ffi.cdef[[
typedef UINT (__stdcall *LPFNPSPCALLBACKA)(HWND hwnd, UINT uMsg, struct _PROPSHEETPAGEA *ppsp);
typedef UINT (__stdcall *LPFNPSPCALLBACKW)(HWND hwnd, UINT uMsg, struct _PROPSHEETPAGEW *ppsp);
]]

--[[
#ifdef UNICODE
#define LPFNPSPCALLBACK         LPFNPSPCALLBACKW
#else
#define LPFNPSPCALLBACK         LPFNPSPCALLBACKA
#endif
--]]

ffi.cdef[[
static const int PSP_DEFAULT              =  0x00000000;
static const int PSP_DLGINDIRECT          =  0x00000001;
static const int PSP_USEHICON             =  0x00000002;
static const int PSP_USEICONID            =  0x00000004;
static const int PSP_USETITLE             =  0x00000008;
static const int PSP_RTLREADING           =  0x00000010;

static const int PSP_HASHELP              =  0x00000020;
static const int PSP_USEREFPARENT         =  0x00000040;
static const int PSP_USECALLBACK          =  0x00000080;
static const int PSP_PREMATURE            =  0x00000400;

//----- New flags for wizard97 --------------
static const int PSP_HIDEHEADER           =  0x00000800;
static const int PSP_USEHEADERTITLE       =  0x00001000;
static const int PSP_USEHEADERSUBTITLE    =  0x00002000;
]]


if (NTDDI_VERSION >= NTDDI_WINXP) or ISOLATION_AWARE_ENABLED then
ffi.cdef[[
static const int PSP_USEFUSIONCONTEXT     =  0x00004000;
]]
end

ffi.cdef[[
static const int PSPCB_ADDREF          =  0;
static const int PSPCB_RELEASE         =  1;
static const int PSPCB_CREATE          =  2;
]]


if _WIN32 then
ffi.cdef[[
typedef LPCDLGTEMPLATE PROPSHEETPAGE_RESOURCE;
]]
else
ffi.cdef[[
typedef const VOID* PROPSHEETPAGE_RESOURCE;
]]
end

--[=[
#define PROPSHEETPAGEA_V1_FIELDS   \
    DWORD           dwSize;        \
    DWORD           dwFlags;       \
    HINSTANCE       hInstance;     \
    union                          \
    {                              \
        LPCSTR      pszTemplate;   \
        PROPSHEETPAGE_RESOURCE pResource; \
    } ;              \
    union                          \
    {                              \
        HICON        hIcon;        \
        LPCSTR       pszIcon;      \
    } ;             \
    LPCSTR           pszTitle;     \
    DLGPROC          pfnDlgProc;   \
    LPARAM           lParam;       \
    LPFNPSPCALLBACKA pfnCallback;  \
    UINT             *pcRefParent; \

#define PROPSHEETPAGEW_V1_FIELDS   \
    DWORD           dwSize;        \
    DWORD           dwFlags;       \
    HINSTANCE       hInstance;     \
    union                          \
    {                              \
        LPCWSTR     pszTemplate;   \
        PROPSHEETPAGE_RESOURCE pResource; \
    } ;              \
    union                          \
    {                              \
        HICON        hIcon;        \
        LPCWSTR      pszIcon;      \
    } ;             \
    LPCWSTR          pszTitle;     \
    DLGPROC          pfnDlgProc;   \
    LPARAM           lParam;       \
    LPFNPSPCALLBACKW pfnCallback;  \
    UINT             *pcRefParent; \
--]=]

--[[
if (NTDDI_VERSION >= NTDDI_VISTA) then
#define  _PROPSHEETPAGEA_V4 _PROPSHEETPAGEA
#define  _PROPSHEETPAGEW_V4 _PROPSHEETPAGEW
#elif (NTDDI_VERSION >= NTDDI_WINXP) or ISOLATION_AWARE_ENABLED
#define  _PROPSHEETPAGEA_V3 _PROPSHEETPAGEA
#define  _PROPSHEETPAGEW_V3 _PROPSHEETPAGEW
#else
#define  _PROPSHEETPAGEA_V2 _PROPSHEETPAGEA
#define  _PROPSHEETPAGEW_V2 _PROPSHEETPAGEW
#endif
--]]

ffi.cdef[[
typedef struct _PROPSHEETPAGEA_V1
{
    DWORD           dwSize;        
    DWORD           dwFlags;       
    HINSTANCE       hInstance;     
    union                          
    {                              
        LPCSTR      pszTemplate;   
        PROPSHEETPAGE_RESOURCE pResource; 
    } ;              
    union                          
    {                              
        HICON        hIcon;        
        LPCSTR       pszIcon;      
    } ;             
    LPCSTR           pszTitle;     
    DLGPROC          pfnDlgProc;   
    LPARAM           lParam;       
    LPFNPSPCALLBACKA pfnCallback;  
    UINT             *pcRefParent; 
} PROPSHEETPAGEA_V1, *LPPROPSHEETPAGEA_V1;
typedef const PROPSHEETPAGEA_V1 *LPCPROPSHEETPAGEA_V1;
]]

ffi.cdef[[
typedef struct _PROPSHEETPAGEA_V2
{
    DWORD           dwSize;        
    DWORD           dwFlags;       
    HINSTANCE       hInstance;     
    union                          
    {                              
        LPCSTR      pszTemplate;   
        PROPSHEETPAGE_RESOURCE pResource; 
    } ;              
    union                          
    {                              
        HICON        hIcon;        
        LPCSTR       pszIcon;      
    } ;             
    LPCSTR           pszTitle;     
    DLGPROC          pfnDlgProc;   
    LPARAM           lParam;       
    LPFNPSPCALLBACKA pfnCallback;  
    UINT             *pcRefParent; 

    LPCSTR           pszHeaderTitle;    // this is displayed in the header
    LPCSTR           pszHeaderSubTitle; //
} PROPSHEETPAGEA_V2, *LPPROPSHEETPAGEA_V2;
typedef const PROPSHEETPAGEA_V2 *LPCPROPSHEETPAGEA_V2;
]]

ffi.cdef[[
typedef struct _PROPSHEETPAGEA_V3
{
    DWORD           dwSize;        
    DWORD           dwFlags;       
    HINSTANCE       hInstance;     
    union                          
    {                              
        LPCSTR      pszTemplate;   
        PROPSHEETPAGE_RESOURCE pResource; 
    } ;              
    union                          
    {                              
        HICON        hIcon;        
        LPCSTR       pszIcon;      
    } ;             
    LPCSTR           pszTitle;     
    DLGPROC          pfnDlgProc;   
    LPARAM           lParam;       
    LPFNPSPCALLBACKA pfnCallback;  
    UINT             *pcRefParent; 

    LPCSTR           pszHeaderTitle;    // this is displayed in the header
    LPCSTR           pszHeaderSubTitle; //

    HANDLE           hActCtx;
} PROPSHEETPAGEA_V3, *LPPROPSHEETPAGEA_V3;
typedef const PROPSHEETPAGEA_V3 *LPCPROPSHEETPAGEA_V3;
]]

if (NTDDI_VERSION >= NTDDI_VISTA) then
ffi.cdef[[
typedef struct _PROPSHEETPAGEA_V4
{
    DWORD           dwSize;        
    DWORD           dwFlags;       
    HINSTANCE       hInstance;     
    union                          
    {                              
        LPCSTR      pszTemplate;   
        PROPSHEETPAGE_RESOURCE pResource; 
    } ;              
    union                          
    {                              
        HICON        hIcon;        
        LPCSTR       pszIcon;      
    } ;             
    LPCSTR           pszTitle;     
    DLGPROC          pfnDlgProc;   
    LPARAM           lParam;       
    LPFNPSPCALLBACKA pfnCallback;  
    UINT             *pcRefParent; 

    LPCSTR           pszHeaderTitle;    // this is displayed in the header
    LPCSTR           pszHeaderSubTitle; //

    HANDLE           hActCtx;

    union 
    {
        HBITMAP     hbmHeader;
        LPCSTR      pszbmHeader;
    } ;

} PROPSHEETPAGEA_V4, *LPPROPSHEETPAGEA_V4;
typedef const PROPSHEETPAGEA_V4 *LPCPROPSHEETPAGEA_V4;
]]
end


ffi.cdef[[
typedef struct _PROPSHEETPAGEW_V1
{
    DWORD           dwSize;        
    DWORD           dwFlags;       
    HINSTANCE       hInstance;     
    union                          
    {                              
        LPCWSTR     pszTemplate;   
        PROPSHEETPAGE_RESOURCE pResource; 
    } ;              
    union                          
    {                              
        HICON        hIcon;        
        LPCWSTR      pszIcon;      
    } ;             
    LPCWSTR          pszTitle;     
    DLGPROC          pfnDlgProc;   
    LPARAM           lParam;       
    LPFNPSPCALLBACKW pfnCallback;  
    UINT             *pcRefParent; 
} PROPSHEETPAGEW_V1, *LPPROPSHEETPAGEW_V1;
typedef const PROPSHEETPAGEW_V1 *LPCPROPSHEETPAGEW_V1;
]]

ffi.cdef[[
typedef struct _PROPSHEETPAGEW_V2
{
    DWORD           dwSize;        
    DWORD           dwFlags;       
    HINSTANCE       hInstance;     
    union                          
    {                              
        LPCWSTR     pszTemplate;   
        PROPSHEETPAGE_RESOURCE pResource; 
    } ;              
    union                          
    {                              
        HICON        hIcon;        
        LPCWSTR      pszIcon;      
    } ;             
    LPCWSTR          pszTitle;     
    DLGPROC          pfnDlgProc;   
    LPARAM           lParam;       
    LPFNPSPCALLBACKW pfnCallback;  
    UINT             *pcRefParent; 

    LPCWSTR           pszHeaderTitle;    // this is displayed in the header
    LPCWSTR           pszHeaderSubTitle; //
} PROPSHEETPAGEW_V2, *LPPROPSHEETPAGEW_V2;
typedef const PROPSHEETPAGEW_V2 *LPCPROPSHEETPAGEW_V2;
]]

ffi.cdef[[
typedef struct _PROPSHEETPAGEW_V3
{
    DWORD           dwSize;        
    DWORD           dwFlags;       
    HINSTANCE       hInstance;     
    union                          
    {                              
        LPCWSTR     pszTemplate;   
        PROPSHEETPAGE_RESOURCE pResource; 
    } ;              
    union                          
    {                              
        HICON        hIcon;        
        LPCWSTR      pszIcon;      
    } ;             
    LPCWSTR          pszTitle;     
    DLGPROC          pfnDlgProc;   
    LPARAM           lParam;       
    LPFNPSPCALLBACKW pfnCallback;  
    UINT             *pcRefParent; 

    LPCWSTR           pszHeaderTitle;    // this is displayed in the header
    LPCWSTR           pszHeaderSubTitle; //

    HANDLE           hActCtx;
} PROPSHEETPAGEW_V3, *LPPROPSHEETPAGEW_V3;
typedef const PROPSHEETPAGEW_V3 *LPCPROPSHEETPAGEW_V3;
]]


if (NTDDI_VERSION >= NTDDI_VISTA) then
ffi.cdef[[
typedef struct _PROPSHEETPAGEW_V4
{
    DWORD           dwSize;        
    DWORD           dwFlags;       
    HINSTANCE       hInstance;     
    union                          
    {                              
        LPCWSTR     pszTemplate;   
        PROPSHEETPAGE_RESOURCE pResource; 
    } ;              
    union                          
    {                              
        HICON        hIcon;        
        LPCWSTR      pszIcon;      
    } ;             
    LPCWSTR          pszTitle;     
    DLGPROC          pfnDlgProc;   
    LPARAM           lParam;       
    LPFNPSPCALLBACKW pfnCallback;  
    UINT             *pcRefParent; 

    LPCWSTR           pszHeaderTitle;    // this is displayed in the header
    LPCWSTR           pszHeaderSubTitle; //

    HANDLE            hActCtx;

    union 
    {
        HBITMAP     hbmHeader;
        LPCWSTR     pszbmHeader;
    } ;

} PROPSHEETPAGEW_V4, *LPPROPSHEETPAGEW_V4;
typedef const PROPSHEETPAGEW_V4 *LPCPROPSHEETPAGEW_V4;
]]
end


--[[
#define PROPSHEETPAGEA_V1_SIZE sizeof(PROPSHEETPAGEA_V1)
#define PROPSHEETPAGEW_V1_SIZE sizeof(PROPSHEETPAGEW_V1)

#define PROPSHEETPAGEA_V2_SIZE sizeof(PROPSHEETPAGEA_V2)
#define PROPSHEETPAGEW_V2_SIZE sizeof(PROPSHEETPAGEW_V2)

#define PROPSHEETPAGEA_V3_SIZE sizeof(PROPSHEETPAGEA_V3)
#define PROPSHEETPAGEW_V3_SIZE sizeof(PROPSHEETPAGEW_V3)

#if (NTDDI_VERSION >= NTDDI_VISTA)
#define PROPSHEETPAGEA_V4_SIZE sizeof(PROPSHEETPAGEA_V4)
#define PROPSHEETPAGEW_V4_SIZE sizeof(PROPSHEETPAGEW_V4)
#endif
--]]

--[[
#if (NTDDI_VERSION >= NTDDI_VISTA)
typedef    PROPSHEETPAGEA_V4    PROPSHEETPAGEA_LATEST;
typedef    PROPSHEETPAGEW_V4    PROPSHEETPAGEW_LATEST;
typedef  LPPROPSHEETPAGEA_V4  LPPROPSHEETPAGEA_LATEST;
typedef  LPPROPSHEETPAGEW_V4  LPPROPSHEETPAGEW_LATEST;
typedef LPCPROPSHEETPAGEA_V4 LPCPROPSHEETPAGEA_LATEST;
typedef LPCPROPSHEETPAGEW_V4 LPCPROPSHEETPAGEW_LATEST;
#else
typedef    PROPSHEETPAGEA_V3    PROPSHEETPAGEA_LATEST;
typedef    PROPSHEETPAGEW_V3    PROPSHEETPAGEW_LATEST;
typedef  LPPROPSHEETPAGEA_V3  LPPROPSHEETPAGEA_LATEST;
typedef  LPPROPSHEETPAGEW_V3  LPPROPSHEETPAGEW_LATEST;
typedef LPCPROPSHEETPAGEA_V3 LPCPROPSHEETPAGEA_LATEST;
typedef LPCPROPSHEETPAGEW_V3 LPCPROPSHEETPAGEW_LATEST;
#endif
--]]

if (NTDDI_VERSION >= NTDDI_VISTA) then
ffi.cdef[[
typedef    PROPSHEETPAGEA_V4    PROPSHEETPAGEA;
typedef    PROPSHEETPAGEW_V4    PROPSHEETPAGEW;
typedef  LPPROPSHEETPAGEA_V4  LPPROPSHEETPAGEA;
typedef  LPPROPSHEETPAGEW_V4  LPPROPSHEETPAGEW;
typedef LPCPROPSHEETPAGEA_V4 LPCPROPSHEETPAGEA;
typedef LPCPROPSHEETPAGEW_V4 LPCPROPSHEETPAGEW;
]]
elseif (NTDDI_VERSION >= NTDDI_WINXP) or ISOLATION_AWARE_ENABLED then
ffi.cdef[[
typedef    PROPSHEETPAGEA_V3    PROPSHEETPAGEA;
typedef    PROPSHEETPAGEW_V3    PROPSHEETPAGEW;
typedef  LPPROPSHEETPAGEA_V3  LPPROPSHEETPAGEA;
typedef  LPPROPSHEETPAGEW_V3  LPPROPSHEETPAGEW;
typedef LPCPROPSHEETPAGEA_V3 LPCPROPSHEETPAGEA;
typedef LPCPROPSHEETPAGEW_V3 LPCPROPSHEETPAGEW;
]]
else
ffi.cdef[[
typedef    PROPSHEETPAGEA_V2    PROPSHEETPAGEA;
typedef    PROPSHEETPAGEW_V2    PROPSHEETPAGEW;
typedef  LPPROPSHEETPAGEA_V2  LPPROPSHEETPAGEA;
typedef  LPPROPSHEETPAGEW_V2  LPPROPSHEETPAGEW;
typedef LPCPROPSHEETPAGEA_V2 LPCPROPSHEETPAGEA;
typedef LPCPROPSHEETPAGEW_V2 LPCPROPSHEETPAGEW;
]]
end


--[[
#ifdef UNICODE
#define    PROPSHEETPAGE           PROPSHEETPAGEW
#define  LPPROPSHEETPAGE         LPPROPSHEETPAGEW
#define LPCPROPSHEETPAGE        LPCPROPSHEETPAGEW
#define    PROPSHEETPAGE_V1_SIZE   PROPSHEETPAGEW_V1_SIZE
#define    PROPSHEETPAGE_V2_SIZE   PROPSHEETPAGEW_V2_SIZE
#define    PROPSHEETPAGE_V1        PROPSHEETPAGEW_V1
#define  LPPROPSHEETPAGE_V1      LPPROPSHEETPAGEW_V1
#define LPCPROPSHEETPAGE_V1     LPCPROPSHEETPAGEW_V1
#define    PROPSHEETPAGE_V2        PROPSHEETPAGEW_V2
#define  LPPROPSHEETPAGE_V2      LPPROPSHEETPAGEW_V2
#define LPCPROPSHEETPAGE_V2     LPCPROPSHEETPAGEW_V2
#define    PROPSHEETPAGE_V3        PROPSHEETPAGEW_V3
#define  LPPROPSHEETPAGE_V3      LPPROPSHEETPAGEW_V3
#define LPCPROPSHEETPAGE_V3     LPCPROPSHEETPAGEW_V3
#if (NTDDI_VERSION >= NTDDI_VISTA)
#define    PROPSHEETPAGE_V4        PROPSHEETPAGEW_V4
#define  LPPROPSHEETPAGE_V4      LPPROPSHEETPAGEW_V4
#define LPCPROPSHEETPAGE_V4     LPCPROPSHEETPAGEW_V4
#endif
#define    PROPSHEETPAGE_LATEST    PROPSHEETPAGEW_LATEST
#define  LPPROPSHEETPAGE_LATEST  LPPROPSHEETPAGEW_LATEST
#define LPCPROPSHEETPAGE_LATEST LPCPROPSHEETPAGEW_LATEST
#else
#define    PROPSHEETPAGE           PROPSHEETPAGEA
#define  LPPROPSHEETPAGE         LPPROPSHEETPAGEA
#define LPCPROPSHEETPAGE        LPCPROPSHEETPAGEA
#define    PROPSHEETPAGE_V1_SIZE   PROPSHEETPAGEA_V1_SIZE
#define    PROPSHEETPAGE_V2_SIZE   PROPSHEETPAGEA_V2_SIZE
#define    PROPSHEETPAGE_V1        PROPSHEETPAGEA_V1
#define  LPPROPSHEETPAGE_V1      LPPROPSHEETPAGEA_V1
#define LPCPROPSHEETPAGE_V1     LPCPROPSHEETPAGEA_V1
#define    PROPSHEETPAGE_V2        PROPSHEETPAGEA_V2
#define  LPPROPSHEETPAGE_V2      LPPROPSHEETPAGEA_V2
#define LPCPROPSHEETPAGE_V2     LPCPROPSHEETPAGEA_V2
#define    PROPSHEETPAGE_V3        PROPSHEETPAGEA_V3
#define  LPPROPSHEETPAGE_V3      LPPROPSHEETPAGEA_V3
#define LPCPROPSHEETPAGE_V3     LPCPROPSHEETPAGEA_V3
#if (NTDDI_VERSION >= NTDDI_VISTA)
#define    PROPSHEETPAGE_V4        PROPSHEETPAGEA_V4
#define  LPPROPSHEETPAGE_V4      LPPROPSHEETPAGEA_V4
#define LPCPROPSHEETPAGE_V4     LPCPROPSHEETPAGEA_V4
#endif
#define    PROPSHEETPAGE_LATEST    PROPSHEETPAGEA_LATEST
#define  LPPROPSHEETPAGE_LATEST  LPPROPSHEETPAGEA_LATEST
#define LPCPROPSHEETPAGE_LATEST LPCPROPSHEETPAGEA_LATEST
#endif
--]]

ffi.cdef[[
//----- PropSheet Header related ---------

static const int PSH_DEFAULT           =  0x00000000;
static const int PSH_PROPTITLE         =  0x00000001;
static const int PSH_USEHICON          =  0x00000002;
static const int PSH_USEICONID         =  0x00000004;
static const int PSH_PROPSHEETPAGE     =  0x00000008;

static const int PSH_WIZARDHASFINISH   =  0x00000010;
static const int PSH_WIZARD            =  0x00000020;
static const int PSH_USEPSTARTPAGE     =  0x00000040;
static const int PSH_NOAPPLYNOW        =  0x00000080;

static const int PSH_USECALLBACK       =  0x00000100;
static const int PSH_HASHELP           =  0x00000200;
static const int PSH_MODELESS          =  0x00000400;
static const int PSH_RTLREADING        =  0x00000800;

static const int PSH_WIZARDCONTEXTHELP =  0x00001000;
]]

----- New flags for wizard97 -----------
if (_WIN32_IE < 0x0500) then
ffi.cdef[[
static const int PSH_WIZARD97          =  0x00002000;
]]
else
ffi.cdef[[
static const int PSH_WIZARD97          =  0x01000000;
]]
end

ffi.cdef[[
static const int PSH_WATERMARK         =  0x00008000;

static const int PSH_USEHBMWATERMARK   =  0x00010000;  // user pass in a hbmWatermark instead of pszbmWatermark
static const int PSH_USEHPLWATERMARK   =  0x00020000;  //
static const int PSH_STRETCHWATERMARK  =  0x00040000;  // stretchwatermark also applies for the header
static const int PSH_HEADER            =  0x00080000;

static const int PSH_USEHBMHEADER      =  0x00100000;
static const int PSH_USEPAGELANG       =  0x00200000;  // use frame dialog template matched to page
//----------------------------------------

//----- New flags for wizard-lite --------
static const int PSH_WIZARD_LITE       =  0x00400000;
static const int PSH_NOCONTEXTHELP     =  0x02000000;

]]

if (NTDDI_VERSION >= NTDDI_VISTA) then
ffi.cdef[[
static const int PSH_AEROWIZARD                         = 0x00004000;

static const int PSH_RESIZABLE                          = 0x04000000;
static const int PSH_HEADERBITMAP                       = 0x08000000;
static const int PSH_NOMARGIN                           = 0x10000000;
]]
end


ffi.cdef[[
typedef int (__stdcall *PFNPROPSHEETCALLBACK)(HWND, UINT, LPARAM);
]]

--[[
#define PROPSHEETHEADERA_V1_FIELDS      \
        DWORD           dwSize;         \
        DWORD           dwFlags;        \
        HWND            hwndParent;     \
        HINSTANCE       hInstance;      \
        union                           \
        {                               \
            HICON       hIcon;          \
            LPCSTR      pszIcon;        \
        } ;               \
        LPCSTR          pszCaption;     \
        UINT            nPages;         \
        union                           \
        {                               \
            UINT        nStartPage;     \
            LPCSTR      pStartPage;     \
        } ;              \
        union                           \
        {                               \
            LPCPROPSHEETPAGEA ppsp;     \
            HPROPSHEETPAGE *phpage;     \
        } ;              \
        PFNPROPSHEETCALLBACK pfnCallback;   
--]]

ffi.cdef[[
typedef struct _PROPSHEETHEADERA_V1
{
        DWORD           dwSize;         
        DWORD           dwFlags;        
        HWND            hwndParent;     
        HINSTANCE       hInstance;      
        union                           
        {                               
            HICON       hIcon;          
            LPCSTR      pszIcon;        
        } ;               
        LPCSTR          pszCaption;     
        UINT            nPages;         
        union                           
        {                               
            UINT        nStartPage;     
            LPCSTR      pStartPage;     
        } ;              
        union                           
        {                               
            LPCPROPSHEETPAGEA ppsp;     
            HPROPSHEETPAGE *phpage;     
        } ;              
        PFNPROPSHEETCALLBACK pfnCallback;   
} PROPSHEETHEADERA_V1, *LPPROPSHEETHEADERA_V1;
typedef const PROPSHEETHEADERA_V1 *LPCPROPSHEETHEADERA_V1;
]]

ffi.cdef[[
typedef struct _PROPSHEETHEADERA_V2
{
        DWORD           dwSize;         
        DWORD           dwFlags;        
        HWND            hwndParent;     
        HINSTANCE       hInstance;      
        union                           
        {                               
            HICON       hIcon;          
            LPCSTR      pszIcon;        
        } ;               
        LPCSTR          pszCaption;     
        UINT            nPages;         
        union                           
        {                               
            UINT        nStartPage;     
            LPCSTR      pStartPage;     
        } ;              
        union                           
        {                               
            LPCPROPSHEETPAGEA ppsp;     
            HPROPSHEETPAGE *phpage;     
        } ;              
        PFNPROPSHEETCALLBACK pfnCallback;  

    union 
    {
        HBITMAP hbmWatermark;
        LPCSTR pszbmWatermark;
    } ;
    HPALETTE hplWatermark;
    union 
    {
        HBITMAP hbmHeader;     // Header  bitmap shares the palette with watermark
        LPCSTR pszbmHeader;
    } ;
} PROPSHEETHEADERA_V2, *LPPROPSHEETHEADERA_V2;
typedef const PROPSHEETHEADERA_V2 *LPCPROPSHEETHEADERA_V2;
]]

--[[
#define PROPSHEETHEADERW_V1_FIELDS      \
        DWORD           dwSize;         \
        DWORD           dwFlags;        \
        HWND            hwndParent;     \
        HINSTANCE       hInstance;      \
        union                           \
        {                               \
            HICON       hIcon;          \
            LPCWSTR     pszIcon;        \
        } ;               \
        LPCWSTR         pszCaption;     \
        UINT            nPages;         \
        union                           \
        {                               \
            UINT        nStartPage;     \
            LPCWSTR     pStartPage;     \
        } ;              \
        union                           \
        {                               \
            LPCPROPSHEETPAGEW ppsp;     \
            HPROPSHEETPAGE *phpage;     \
        } ;              \
        PFNPROPSHEETCALLBACK pfnCallback;  
--]]
ffi.cdef[[
typedef struct _PROPSHEETHEADERW_V1
{
        DWORD           dwSize;         
        DWORD           dwFlags;        
        HWND            hwndParent;     
        HINSTANCE       hInstance;      
        union                           
        {                               
            HICON       hIcon;          
            LPCWSTR     pszIcon;        
        } ;               
        LPCWSTR         pszCaption;     
        UINT            nPages;         
        union                           
        {                               
            UINT        nStartPage;     
            LPCWSTR     pStartPage;     
        } ;              
        union                           
        {                               
            LPCPROPSHEETPAGEW ppsp;     
            HPROPSHEETPAGE *phpage;     
        } ;              
        PFNPROPSHEETCALLBACK pfnCallback;  
} PROPSHEETHEADERW_V1, *LPPROPSHEETHEADERW_V1;
typedef const PROPSHEETHEADERW_V1 *LPCPROPSHEETHEADERW_V1;
]]


ffi.cdef[[
typedef struct _PROPSHEETHEADERW_V2
{
        DWORD           dwSize;         
        DWORD           dwFlags;        
        HWND            hwndParent;     
        HINSTANCE       hInstance;      
        union                           
        {                               
            HICON       hIcon;          
            LPCWSTR     pszIcon;        
        } ;               
        LPCWSTR         pszCaption;     
        UINT            nPages;         
        union                           
        {                               
            UINT        nStartPage;     
            LPCWSTR     pStartPage;     
        } ;              
        union                           
        {                               
            LPCPROPSHEETPAGEW ppsp;     
            HPROPSHEETPAGE *phpage;     
        } ;              
        PFNPROPSHEETCALLBACK pfnCallback;  

    union 
    {
        HBITMAP hbmWatermark;
        LPCWSTR pszbmWatermark;
    } ;
    HPALETTE hplWatermark;
    union 
    {
        HBITMAP hbmHeader;     // Header  bitmap shares the palette with watermark
        LPCWSTR pszbmHeader;
    } ;
} PROPSHEETHEADERW_V2, *LPPROPSHEETHEADERW_V2;
typedef const PROPSHEETHEADERW_V2 *LPCPROPSHEETHEADERW_V2;
]]

ffi.cdef[[
static const int PROPSHEETHEADERA_V1_SIZE =sizeof(PROPSHEETHEADERA_V1);
static const int PROPSHEETHEADERW_V1_SIZE =sizeof(PROPSHEETHEADERW_V1);
]]

ffi.cdef[[
static const int PROPSHEETHEADERA_V2_SIZE =sizeof(PROPSHEETHEADERA_V2);
static const int PROPSHEETHEADERW_V2_SIZE =sizeof(PROPSHEETHEADERW_V2);
]]

--#define    _PROPSHEETHEADERA        PROPSHEETHEADERA_V2;
--#define    _PROPSHEETHEADERW        PROPSHEETHEADERW_V2;

ffi.cdef[[
typedef    PROPSHEETHEADERA_V2      PROPSHEETHEADERA;
typedef    PROPSHEETHEADERW_V2      PROPSHEETHEADERW;
typedef  LPPROPSHEETHEADERA_V2      LPPROPSHEETHEADERA;
typedef  LPPROPSHEETHEADERW_V2      LPPROPSHEETHEADERW;
typedef LPCPROPSHEETHEADERA_V2      LPCPROPSHEETHEADERA;
typedef LPCPROPSHEETHEADERW_V2      LPCPROPSHEETHEADERW;
]]

--[[
#ifdef UNICODE
#define PROPSHEETHEADER         PROPSHEETHEADERW
#define LPPROPSHEETHEADER       LPPROPSHEETHEADERW
#define LPCPROPSHEETHEADER      LPCPROPSHEETHEADERW
#define PROPSHEETHEADER_V1_SIZE PROPSHEETHEADERW_V1_SIZE
#define PROPSHEETHEADER_V2_SIZE PROPSHEETHEADERW_V2_SIZE
#else
#define PROPSHEETHEADER         PROPSHEETHEADERA
#define LPPROPSHEETHEADER       LPPROPSHEETHEADERA
#define LPCPROPSHEETHEADER      LPCPROPSHEETHEADERA
#define PROPSHEETHEADER_V1_SIZE PROPSHEETHEADERA_V1_SIZE
#define PROPSHEETHEADER_V2_SIZE PROPSHEETHEADERA_V2_SIZE
#endif
--]]

ffi.cdef[[
static const int PSCB_INITIALIZED  = 1;
static const int PSCB_PRECREATE    = 2;
]]

--[=[
#if (NTDDI_VERSION >= NTDDI_WINXP)
// PSCB_BUTTONPRESSED will be sent when the user clicks a button in the
// property dialog (OK, Cancel, Apply, or Close).  The message will be sent
// to PROPSHEETHEADER's pfnCallback if the PSH_USECALLBACK flag was specified.
// The LPARAM will be equal to one of the following based on the button pressed:
// This message is only supported on comctl32 v6.
// PSBTN_FINISH (Close), PSBTN_OK, PSBTN_APPLYNOW, or PSBTN_CANCEL

#define PSCB_BUTTONPRESSED 3
#endif  // NTDDI_VERSION >= NTDDI_WINXP

WINCOMMCTRLAPI HPROPSHEETPAGE WINAPI CreatePropertySheetPageA(LPCPROPSHEETPAGEA constPropSheetPagePointer);
WINCOMMCTRLAPI HPROPSHEETPAGE WINAPI CreatePropertySheetPageW(LPCPROPSHEETPAGEW constPropSheetPagePointer);
WINCOMMCTRLAPI BOOL           WINAPI DestroyPropertySheetPage(HPROPSHEETPAGE);

WINCOMMCTRLAPI INT_PTR        WINAPI PropertySheetA(LPCPROPSHEETHEADERA);

WINCOMMCTRLAPI INT_PTR        WINAPI PropertySheetW(LPCPROPSHEETHEADERW);

--[[
#ifdef UNICODE
#define CreatePropertySheetPage  CreatePropertySheetPageW
#define PropertySheet            PropertySheetW
#else
#define CreatePropertySheetPage  CreatePropertySheetPageA
#define PropertySheet            PropertySheetA
#endif
--]]

ffi.cdef[[
typedef BOOL (__stdcall *LPFNADDPROPSHEETPAGE)(HPROPSHEETPAGE, LPARAM);
typedef BOOL (__stdcall *LPFNADDPROPSHEETPAGES)(LPVOID, LPFNADDPROPSHEETPAGE, LPARAM);


typedef struct _PSHNOTIFY
{
    NMHDR hdr;
    LPARAM lParam;
} PSHNOTIFY, *LPPSHNOTIFY;
]]

ffi.cdef[[
#define PSN_FIRST               (0U-200U);
#define PSN_LAST                (0U-299U);


#define PSN_SETACTIVE           (PSN_FIRST-0);
#define PSN_KILLACTIVE          (PSN_FIRST-1);
// #define PSN_VALIDATE            (PSN_FIRST-1);
#define PSN_APPLY               (PSN_FIRST-2);
#define PSN_RESET               (PSN_FIRST-3);
// #define PSN_CANCEL              (PSN_FIRST-3);
#define PSN_HELP                (PSN_FIRST-5);
#define PSN_WIZBACK             (PSN_FIRST-6);
#define PSN_WIZNEXT             (PSN_FIRST-7);
#define PSN_WIZFINISH           (PSN_FIRST-8);
#define PSN_QUERYCANCEL         (PSN_FIRST-9);
#define PSN_GETOBJECT           (PSN_FIRST-10);
#define PSN_TRANSLATEACCELERATOR (PSN_FIRST-12);
#define PSN_QUERYINITIALFOCUS   (PSN_FIRST-13);
#define PSNRET_NOERROR              0;
#define PSNRET_INVALID              1;
#define PSNRET_INVALID_NOCHANGEPAGE 2;
#define PSNRET_MESSAGEHANDLED       3;
]]

#define PSM_SETCURSEL           (WM_USER + 101)
#define PropSheet_SetCurSel(hDlg, hpage, index) \
        SNDMSG(hDlg, PSM_SETCURSEL, (WPARAM)(index), (LPARAM)(hpage))


#define PSM_REMOVEPAGE          (WM_USER + 102)
#define PropSheet_RemovePage(hDlg, index, hpage) \
        SNDMSG(hDlg, PSM_REMOVEPAGE, index, (LPARAM)(hpage))


#define PSM_ADDPAGE             (WM_USER + 103)
#define PropSheet_AddPage(hDlg, hpage) \
        SNDMSG(hDlg, PSM_ADDPAGE, 0, (LPARAM)(hpage))


#define PSM_CHANGED             (WM_USER + 104)
#define PropSheet_Changed(hDlg, hwnd) \
        SNDMSG(hDlg, PSM_CHANGED, (WPARAM)(hwnd), 0L)


#define PSM_RESTARTWINDOWS      (WM_USER + 105)
#define PropSheet_RestartWindows(hDlg) \
        SNDMSG(hDlg, PSM_RESTARTWINDOWS, 0, 0L)


#define PSM_REBOOTSYSTEM        (WM_USER + 106)
#define PropSheet_RebootSystem(hDlg) \
        SNDMSG(hDlg, PSM_REBOOTSYSTEM, 0, 0L)


#define PSM_CANCELTOCLOSE       (WM_USER + 107)
#define PropSheet_CancelToClose(hDlg) \
        PostMessage(hDlg, PSM_CANCELTOCLOSE, 0, 0L)


#define PSM_QUERYSIBLINGS       (WM_USER + 108)
#define PropSheet_QuerySiblings(hDlg, wParam, lParam) \
        SNDMSG(hDlg, PSM_QUERYSIBLINGS, wParam, lParam)


#define PSM_UNCHANGED         =  (WM_USER + 109);
#define PropSheet_UnChanged(hDlg, hwnd) \
        SNDMSG(hDlg, PSM_UNCHANGED, (WPARAM)(hwnd), 0L)


#define PSM_APPLY             =  (WM_USER + 110);
#define PropSheet_Apply(hDlg) \
        SNDMSG(hDlg, PSM_APPLY, 0, 0L)


#define PSM_SETTITLEA         =  (WM_USER + 111);
#define PSM_SETTITLEW         =  (WM_USER + 120);

--[[
#ifdef UNICODE
#define PSM_SETTITLE            PSM_SETTITLEW
#else
#define PSM_SETTITLE            PSM_SETTITLEA
#endif
--]]

#define PropSheet_SetTitle(hDlg, wStyle, lpszText)\
        SNDMSG(hDlg, PSM_SETTITLE, wStyle, (LPARAM)(LPCTSTR)(lpszText))


#define PSM_SETWIZBUTTONS     =  (WM_USER + 112);
#define PropSheet_SetWizButtons(hDlg, dwFlags) \
        PostMessage(hDlg, PSM_SETWIZBUTTONS, 0, (LPARAM)(dwFlags))

ffi.cdef[[
static const int PSWIZB_BACK           =  0x00000001;
static const int PSWIZB_NEXT            = 0x00000002;
static const int PSWIZB_FINISH          = 0x00000004;
static const int PSWIZB_DISABLEDFINISH  = 0x00000008;

static const int PSWIZBF_ELEVATIONREQUIRED   0x00000001;
]]

if (NTDDI_VERSION >= NTDDI_VISTA) then
ffi.cdef[[
// Only for PSH_AEROWIZARD - used in PSM_SHOWWIZBUTTONS
static const int PSWIZB_CANCEL        =   0x00000010;
]]
end --// 0x0605


#define PSM_PRESSBUTTON        = (WM_USER + 113);
#define PropSheet_PressButton(hDlg, iButton) \
        PostMessage(hDlg, PSM_PRESSBUTTON, (WPARAM)(iButton), 0)


static const int PSBTN_BACK            =  0;
static const int PSBTN_NEXT            =  1;
static const int PSBTN_FINISH          =  2;
static const int PSBTN_OK              =  3;
static const int PSBTN_APPLYNOW        =  4;
static const int PSBTN_CANCEL          =  5;
static const int PSBTN_HELP            =  6;
static const int PSBTN_MAX             =  6;



#define PSM_SETCURSELID       =  (WM_USER + 114);
#define PropSheet_SetCurSelByID(hDlg, id) \
        SNDMSG(hDlg, PSM_SETCURSELID, 0, (LPARAM)(id))


#define PSM_SETFINISHTEXTA    =  (WM_USER + 115);
#define PSM_SETFINISHTEXTW    =  (WM_USER + 121);

--[[
#ifdef UNICODE
#define PSM_SETFINISHTEXT       PSM_SETFINISHTEXTW
#else
#define PSM_SETFINISHTEXT       PSM_SETFINISHTEXTA
#endif
--]]

#define PropSheet_SetFinishText(hDlg, lpszText) \
        SNDMSG(hDlg, PSM_SETFINISHTEXT, 0, (LPARAM)(lpszText))


#define PSM_GETTABCONTROL       (WM_USER + 116)
#define PropSheet_GetTabControl(hDlg) \
        (HWND)SNDMSG(hDlg, PSM_GETTABCONTROL, 0, 0)

#define PSM_ISDIALOGMESSAGE     (WM_USER + 117)
#define PropSheet_IsDialogMessage(hDlg, pMsg) \
        (BOOL)SNDMSG(hDlg, PSM_ISDIALOGMESSAGE, 0, (LPARAM)(pMsg))

#define PSM_GETCURRENTPAGEHWND  (WM_USER + 118)
#define PropSheet_GetCurrentPageHwnd(hDlg) \
        (HWND)SNDMSG(hDlg, PSM_GETCURRENTPAGEHWND, 0, 0L)

static const int  PSM_INSERTPAGE       =   (WM_USER + 119);
#define PropSheet_InsertPage(hDlg, index, hpage) \
        SNDMSG(hDlg, PSM_INSERTPAGE, (WPARAM)(index), (LPARAM)(hpage))

if (NTDDI_VERSION >= NTDDI_VISTA) then
// Only for PSH_AEROWIZARD - used in PSM_SETHEADERTITLE
static const int PSWIZF_SETCOLOR       =  ((UINT)(-1));
end

#define PSM_SETHEADERTITLEA     (WM_USER + 125)
#define PSM_SETHEADERTITLEW     (WM_USER + 126)

--[[
#ifdef UNICODE
#define PSM_SETHEADERTITLE      PSM_SETHEADERTITLEW
#else
#define PSM_SETHEADERTITLE      PSM_SETHEADERTITLEA
#endif
--]]

#define PropSheet_SetHeaderTitle(hDlg, index, lpszText) \
        SNDMSG(hDlg, PSM_SETHEADERTITLE, (WPARAM)(index), (LPARAM)(lpszText))


#define PSM_SETHEADERSUBTITLEA     (WM_USER + 127)
#define PSM_SETHEADERSUBTITLEW     (WM_USER + 128)

--[[
#ifdef UNICODE
#define PSM_SETHEADERSUBTITLE      PSM_SETHEADERSUBTITLEW
#else
#define PSM_SETHEADERSUBTITLE      PSM_SETHEADERSUBTITLEA
#endif
--]]

#define PropSheet_SetHeaderSubTitle(hDlg, index, lpszText) \
        SNDMSG(hDlg, PSM_SETHEADERSUBTITLE, (WPARAM)(index), (LPARAM)(lpszText))

#define PSM_HWNDTOINDEX            (WM_USER + 129)
#define PropSheet_HwndToIndex(hDlg, hwnd) \
        (int)SNDMSG(hDlg, PSM_HWNDTOINDEX, (WPARAM)(hwnd), 0)

#define PSM_INDEXTOHWND            (WM_USER + 130)
#define PropSheet_IndexToHwnd(hDlg, i) \
        (HWND)SNDMSG(hDlg, PSM_INDEXTOHWND, (WPARAM)(i), 0)

#define PSM_PAGETOINDEX            (WM_USER + 131)
#define PropSheet_PageToIndex(hDlg, hpage) \
        (int)SNDMSG(hDlg, PSM_PAGETOINDEX, 0, (LPARAM)(hpage))

#define PSM_INDEXTOPAGE            (WM_USER + 132)
#define PropSheet_IndexToPage(hDlg, i) \
        (HPROPSHEETPAGE)SNDMSG(hDlg, PSM_INDEXTOPAGE, (WPARAM)(i), 0)

#define PSM_IDTOINDEX              (WM_USER + 133)
#define PropSheet_IdToIndex(hDlg, id) \
        (int)SNDMSG(hDlg, PSM_IDTOINDEX, 0, (LPARAM)(id))

#define PSM_INDEXTOID              (WM_USER + 134)
#define PropSheet_IndexToId(hDlg, i) \
        SNDMSG(hDlg, PSM_INDEXTOID, (WPARAM)(i), 0)

#define PSM_GETRESULT              (WM_USER + 135)
#define PropSheet_GetResult(hDlg) \
        SNDMSG(hDlg, PSM_GETRESULT, 0, 0)

#define PSM_RECALCPAGESIZES        (WM_USER + 136)
#define PropSheet_RecalcPageSizes(hDlg) \
        SNDMSG(hDlg, PSM_RECALCPAGESIZES, 0, 0)

#if (NTDDI_VERSION >= NTDDI_VISTA)
// Only UNICODE
// These messages are only for Aero Wizard style wizards. The Wizard author
// needs to specify the PSH_AEROWIZARD flag in the dwFlags member of the PROPSHEETHEADER
// structure to get this behavior.

#define PSM_SETNEXTTEXTW          (WM_USER + 137)
#define PSM_SETNEXTTEXT           PSM_SETNEXTTEXTW

#define PropSheet_SetNextText(hDlg, lpszText) \
        SNDMSG(hDlg, PSM_SETNEXTTEXT, 0, (LPARAM)(lpszText))

#define PSWIZB_SHOW                     0
#define PSWIZB_RESTORE                  1


#define PSM_SHOWWIZBUTTONS              (WM_USER + 138)
#define PropSheet_ShowWizButtons(hDlg, dwFlag, dwButton) \
        PSTMSG(hDlg, PSM_SHOWWIZBUTTONS, (WPARAM)(dwFlag), (LPARAM)(dwButton))


#define PSM_ENABLEWIZBUTTONS            (WM_USER + 139)
#define PropSheet_EnableWizButtons(hDlg, dwState, dwMask) \
        PSTMSG(hDlg, PSM_ENABLEWIZBUTTONS, (WPARAM)(dwState), (LPARAM)(dwMask))


#define PSM_SETBUTTONTEXTW         (WM_USER + 140)
#define PSM_SETBUTTONTEXT          PSM_SETBUTTONTEXTW
#define PropSheet_SetButtonText(hDlg, dwButton, lpszText) \
        SNDMSG(hDlg, PSM_SETBUTTONTEXT, (WPARAM)(dwButton), (LPARAM)(lpszText))


end -- 0x0600
--]=]

ffi.cdef[[
static const int ID_PSRESTARTWINDOWS     =0x2;
static const int ID_PSREBOOTSYSTEM       =(ID_PSRESTARTWINDOWS | 0x1);


static const int WIZ_CXDLG               =276;
static const int WIZ_CYDLG               =140;

static const int WIZ_CXBMP               =80;

static const int WIZ_BODYX               =92;
static const int WIZ_BODYCX              =184;

static const int PROP_SM_CXDLG           =212;
static const int PROP_SM_CYDLG           =188;

static const int PROP_MED_CXDLG          =227;
static const int PROP_MED_CYDLG          =215;

static const int PROP_LG_CXDLG           =252;
static const int PROP_LG_CYDLG           =218;
]]

--end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */



--[=[
#if !defined(RC_INVOKED) /* RC complains about long symbols in #ifs */
#if defined(ISOLATION_AWARE_ENABLED) && (ISOLATION_AWARE_ENABLED != 0)
#include "prsht.inl"
#endif /* ISOLATION_AWARE_ENABLED */
#endif /* RC */


#include <poppack.h>
--]=]

