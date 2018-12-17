local ffi = require("ffi")

require("win32.winapifamily")


--[[
//+---------------------------------------------------------------------------
//
//  Microsoft Windows
//  Copyright (c) Microsoft Corporation. All rights reserved.
//
//  File:       OLE2.h
//  Contents:   Main OLE2 header; Defines Linking and Emmebbeding interfaces, and API's.
//              Also includes .h files for the compobj, and oleauto  subcomponents.
//
//----------------------------------------------------------------------------
--]]
--#if !defined( _OLE2_H_ )
--#define _OLE2_H_


ffi.cdef[[
    #pragma pack (push, 8)
]]
--// Set packing to 8
--#include <pshpack8.h>

--// Make 100% sure WIN32 is defined
if not WIN32 then
WIN32   = 100  -- 100 == NT version 1.0
end


-- SET to remove _export from interface definitions

require("win32.winerror")
require("win32.objbase")
--require("win32.oleauto")        -- NYI
require("win32.coml2api")

--[[
// View OBJECT Error Codes

#define E_DRAW                  VIEW_E_DRAW

// IDataObject Error Codes
#define DATA_E_FORMATETC        DV_E_FORMATETC
--]]

ffi.cdef[[
// Common stuff gleamed from OLE.2,

/* verbs */
static const int OLEIVERB_PRIMARY           = 0;
static const int OLEIVERB_SHOW              = -1;
static const int OLEIVERB_OPEN              = -2;
static const int OLEIVERB_HIDE              = -3;
static const int OLEIVERB_UIACTIVATE        = -4;
static const int OLEIVERB_INPLACEACTIVATE   = -5;
static const int OLEIVERB_DISCARDUNDOSTATE  = -6;

// for OleCreateEmbeddingHelper flags; roles in low word; options in high word
static const int EMBDHLP_INPROC_HANDLER  = 0x0000;
static const int EMBDHLP_INPROC_SERVER   = 0x0001;
static const int EMBDHLP_CREATENOW   = 0x00000000;
static const int EMBDHLP_DELAYCREATE = 0x00010000;

/* extended create function flags */
static const int OLECREATE_LEAVERUNNING	=0x00000001;
]]

--/* pull in the MIDL generated header */
--#include <oleidl.h>



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then
--[[
/****** DV APIs ***********************************************************/


/* This function is declared in objbase.h and ole2.h.
   IsolationAware support is via objbase.h.
*/
#if    !defined(ISOLATION_AWARE_ENABLED) \
    || !ISOLATION_AWARE_ENABLED \
    || !defined(_OBJBASE_H_) \
    || !defined(CreateDataAdviseHolder)
HRESULT __stdcall CreateDataAdviseHolder( LPDATAADVISEHOLDER * ppDAHolder);
#endif
--]]

ffi.cdef[[
/****** OLE API Prototypes ************************************************/

DWORD __stdcall OleBuildVersion( VOID );

 HRESULT __stdcall WriteFmtUserTypeStg ( LPSTORAGE pstg,  CLIPFORMAT cf, _In_z_ LPOLESTR lpszUserType);
HRESULT __stdcall ReadFmtUserTypeStg ( LPSTORAGE pstg,  CLIPFORMAT * pcf, _Outptr_opt_result_z_ LPOLESTR * lplpszUserType);


/* init/term */

 HRESULT __stdcall OleInitialize( LPVOID pvReserved);
void __stdcall OleUninitialize(void);


/* APIs to query whether (Embedded/Linked) object can be created from
   the data object */

HRESULT __stdcall  OleQueryLinkFromData( LPDATAOBJECT pSrcDataObject);
HRESULT __stdcall  OleQueryCreateFromData( LPDATAOBJECT pSrcDataObject);


/* Object creation APIs */

HRESULT __stdcall  OleCreate( REFCLSID rclsid,  REFIID riid,  DWORD renderopt,
                 LPFORMATETC pFormatEtc,  LPOLECLIENTSITE pClientSite,
                 LPSTORAGE pStg,  LPVOID * ppvObj);


HRESULT __stdcall  OleCreateEx( REFCLSID rclsid,  REFIID riid,  DWORD dwFlags,
                 DWORD renderopt,  ULONG cFormats,  DWORD* rgAdvf,
                 LPFORMATETC rgFormatEtc,  IAdviseSink * lpAdviseSink,
                 DWORD * rgdwConnection,  LPOLECLIENTSITE pClientSite,
                 LPSTORAGE pStg,  LPVOID * ppvObj);

HRESULT __stdcall  OleCreateFromData( LPDATAOBJECT pSrcDataObj,  REFIID riid,
                 DWORD renderopt,  LPFORMATETC pFormatEtc,
                 LPOLECLIENTSITE pClientSite,  LPSTORAGE pStg,
                 LPVOID * ppvObj);


HRESULT __stdcall  OleCreateFromDataEx( LPDATAOBJECT pSrcDataObj,  REFIID riid,
                 DWORD dwFlags,  DWORD renderopt,  ULONG cFormats,  DWORD* rgAdvf,
                 LPFORMATETC rgFormatEtc,  IAdviseSink * lpAdviseSink,
                 DWORD * rgdwConnection,  LPOLECLIENTSITE pClientSite,
                 LPSTORAGE pStg,  LPVOID * ppvObj);

HRESULT __stdcall  OleCreateLinkFromData( LPDATAOBJECT pSrcDataObj,  REFIID riid,
                 DWORD renderopt,  LPFORMATETC pFormatEtc,
                 LPOLECLIENTSITE pClientSite,  LPSTORAGE pStg,
                 LPVOID * ppvObj);


HRESULT __stdcall  OleCreateLinkFromDataEx( LPDATAOBJECT pSrcDataObj,  REFIID riid,
                 DWORD dwFlags,  DWORD renderopt,  ULONG cFormats,  DWORD* rgAdvf,
                 LPFORMATETC rgFormatEtc,  IAdviseSink * lpAdviseSink,
                  DWORD * rgdwConnection,  LPOLECLIENTSITE pClientSite,
                 LPSTORAGE pStg,  LPVOID * ppvObj);

HRESULT __stdcall  OleCreateStaticFromData( LPDATAOBJECT pSrcDataObj,  REFIID iid,
                 DWORD renderopt,  LPFORMATETC pFormatEtc,
                 LPOLECLIENTSITE pClientSite,  LPSTORAGE pStg,
                 LPVOID * ppvObj);


HRESULT __stdcall  OleCreateLink( LPMONIKER pmkLinkSrc,  REFIID riid,
             DWORD renderopt,  LPFORMATETC lpFormatEtc,
             LPOLECLIENTSITE pClientSite,  LPSTORAGE pStg,  LPVOID * ppvObj);

HRESULT __stdcall  OleCreateLinkEx( LPMONIKER pmkLinkSrc,  REFIID riid,
             DWORD dwFlags,  DWORD renderopt,  ULONG cFormats,  DWORD* rgAdvf,
             LPFORMATETC rgFormatEtc,  IAdviseSink * lpAdviseSink,
             DWORD * rgdwConnection,  LPOLECLIENTSITE pClientSite,
             LPSTORAGE pStg,  LPVOID * ppvObj);

HRESULT __stdcall  OleCreateLinkToFile( LPCOLESTR lpszFileName,  REFIID riid,
             DWORD renderopt,  LPFORMATETC lpFormatEtc,
             LPOLECLIENTSITE pClientSite,  LPSTORAGE pStg,  LPVOID * ppvObj);

HRESULT __stdcall  OleCreateLinkToFileEx( LPCOLESTR lpszFileName,  REFIID riid,
             DWORD dwFlags,  DWORD renderopt,  ULONG cFormats,  DWORD* rgAdvf,
             LPFORMATETC rgFormatEtc,  IAdviseSink * lpAdviseSink,
             DWORD * rgdwConnection,  LPOLECLIENTSITE pClientSite,
             LPSTORAGE pStg,  LPVOID * ppvObj);

HRESULT __stdcall  OleCreateFromFile( REFCLSID rclsid,  LPCOLESTR lpszFileName,  REFIID riid,
             DWORD renderopt,  LPFORMATETC lpFormatEtc,
             LPOLECLIENTSITE pClientSite,  LPSTORAGE pStg,  LPVOID * ppvObj);


HRESULT __stdcall  OleCreateFromFileEx( REFCLSID rclsid,  LPCOLESTR lpszFileName,  REFIID riid,
             DWORD dwFlags,  DWORD renderopt,  ULONG cFormats,  DWORD* rgAdvf,
             LPFORMATETC rgFormatEtc,  IAdviseSink * lpAdviseSink,
             DWORD * rgdwConnection,  LPOLECLIENTSITE pClientSite,
             LPSTORAGE pStg,  LPVOID * ppvObj);

HRESULT __stdcall  OleLoad( LPSTORAGE pStg,  REFIID riid,  LPOLECLIENTSITE pClientSite,
             LPVOID * ppvObj);

HRESULT __stdcall  OleSave(_In_ LPPERSISTSTORAGE pPS, _In_ LPSTORAGE pStg, _In_ BOOL fSameAsLoad);

HRESULT __stdcall  OleLoadFromStream(  LPSTREAM pStm,  REFIID iidInterface,  LPVOID * ppvObj);
HRESULT __stdcall  OleSaveToStream(  LPPERSISTSTREAM pPStm,  LPSTREAM pStm );


HRESULT __stdcall  OleSetContainedObject( LPUNKNOWN pUnknown,  BOOL fContained);
HRESULT __stdcall  OleNoteObjectVisible( LPUNKNOWN pUnknown,  BOOL fVisible);


/* Drag/Drop APIs */

HRESULT __stdcall  RegisterDragDrop( HWND hwnd,  LPDROPTARGET pDropTarget);
HRESULT __stdcall  RevokeDragDrop( HWND hwnd);
HRESULT __stdcall  DoDragDrop( LPDATAOBJECT pDataObj,  LPDROPSOURCE pDropSource,
             DWORD dwOKEffects,  LPDWORD pdwEffect);

/* Clipboard APIs */

HRESULT __stdcall  OleSetClipboard( LPDATAOBJECT pDataObj);
HRESULT __stdcall  OleGetClipboard( LPDATAOBJECT * ppDataObj);
]]

if (NTDDI_VERSION >= NTDDI_WIN10_RS1) then
ffi.cdef[[
    HRESULT __stdcall  OleGetClipboardWithEnterpriseInfo(_Outptr_result_nullonfailure_ IDataObject** dataObject,
            _Outptr_result_nullonfailure_ PWSTR* dataEnterpriseId,
            _Outptr_result_nullonfailure_ PWSTR* sourceDescription,
            _Outptr_result_nullonfailure_ PWSTR* targetDescription,
            _Outptr_result_nullonfailure_ PWSTR* dataDescription);
]]
end


ffi.cdef[[
HRESULT __stdcall  OleFlushClipboard(void);   
HRESULT __stdcall  OleIsCurrentClipboard( LPDATAOBJECT pDataObj);   

/* InPlace Editing APIs */

HOLEMENU __stdcall   OleCreateMenuDescriptor ( HMENU hmenuCombined,
                                 LPOLEMENUGROUPWIDTHS lpMenuWidths);
HRESULT __stdcall              OleSetMenuDescriptor ( HOLEMENU holemenu,  HWND hwndFrame,
                                 HWND hwndActiveObject,
                                 LPOLEINPLACEFRAME lpFrame,
                                 LPOLEINPLACEACTIVEOBJECT lpActiveObj);
HRESULT __stdcall              OleDestroyMenuDescriptor ( HOLEMENU holemenu);

HRESULT __stdcall              OleTranslateAccelerator ( LPOLEINPLACEFRAME lpFrame,
                             LPOLEINPLACEFRAMEINFO lpFrameInfo,  LPMSG lpmsg);


/* Helper APIs */

HANDLE  __stdcall OleDuplicateData ( HANDLE hSrc,  CLIPFORMAT cfFormat,
                         UINT uiFlags);



HRESULT __stdcall          OleDraw ( LPUNKNOWN pUnknown,  DWORD dwAspect,  HDC hdcDraw,
                     LPCRECT lprcBounds);

 HRESULT __stdcall          OleRun( LPUNKNOWN pUnknown);
BOOL  __stdcall OleIsRunning( LPOLEOBJECT pObject);
HRESULT __stdcall          OleLockRunning( LPUNKNOWN pUnknown,  BOOL fLock,  BOOL fLastUnlockCloses);

void __stdcall  ReleaseStgMedium( LPSTGMEDIUM);

HRESULT __stdcall          CreateOleAdviseHolder(_Out_ LPOLEADVISEHOLDER * ppOAHolder);

HRESULT __stdcall          OleCreateDefaultHandler( REFCLSID clsid,  LPUNKNOWN pUnkOuter,
                     REFIID riid,  LPVOID * lplpObj);

HRESULT __stdcall          OleCreateEmbeddingHelper( REFCLSID clsid,  LPUNKNOWN pUnkOuter,
                     DWORD flags,  LPCLASSFACTORY pCF,
                     REFIID riid,  LPVOID * lplpObj);

BOOL __stdcall   IsAccelerator( HACCEL hAccel,  int cAccelEntries,  LPMSG lpMsg,
                                         WORD * lpwCmd);
/* Icon extraction Helper APIs */

HGLOBAL __stdcall OleGetIconOfFile(_In_ LPOLESTR lpszPath,  BOOL fUseFileAsLabel);

HGLOBAL  __stdcall OleGetIconOfClass( REFCLSID rclsid, _In_opt_ LPOLESTR lpszLabel,
                                         BOOL fUseTypeAsLabel);

HGLOBAL  __stdcall OleMetafilePictFromIconAndLabel( HICON hIcon, _In_ LPOLESTR lpszLabel,
                                        _In_ LPOLESTR lpszSourceFile,  UINT iIconIndex);



/* Registration Database Helper APIs */

 HRESULT __stdcall                  OleRegGetUserType ( REFCLSID clsid,  DWORD dwFormOfType,
                                         LPOLESTR * pszUserType);

HRESULT __stdcall                  OleRegGetMiscStatus     ( REFCLSID clsid,  DWORD dwAspect,
                                         DWORD * pdwStatus);

HRESULT __stdcall OleRegEnumFormatEtc( REFCLSID clsid,  DWORD dwDirection,
                               LPENUMFORMATETC * ppenum);

HRESULT __stdcall OleRegEnumVerbs ( REFCLSID clsid,  LPENUMOLEVERB * ppenum);
]]

ffi.cdef[[
/* OLE 1.0 conversion APIS */

/***** OLE 1.0 OLESTREAM declarations *************************************/

typedef struct _OLESTREAM *  LPOLESTREAM;

typedef struct _OLESTREAMVTBL
{
    DWORD (CALLBACK* Get)(LPOLESTREAM, void *, DWORD);
    DWORD (CALLBACK* Put)(LPOLESTREAM, const void *, DWORD);
} OLESTREAMVTBL;
typedef  OLESTREAMVTBL *  LPOLESTREAMVTBL;

typedef struct _OLESTREAM
{
    LPOLESTREAMVTBL lpstbl;
} OLESTREAM;
]]

ffi.cdef[[
HRESULT __stdcall OleConvertOLESTREAMToIStorage
    ( LPOLESTREAM                lpolestream,
     LPSTORAGE                   pstg,
     const DVTARGETDEVICE *   ptd);

HRESULT __stdcall OleConvertIStorageToOLESTREAM
    ( LPSTORAGE      pstg,
     LPOLESTREAM     lpolestream);


/* ConvertTo APIS */

HRESULT __stdcall OleDoAutoConvert( LPSTORAGE pStg,  LPCLSID pClsidNew);
HRESULT __stdcall OleGetAutoConvert( REFCLSID clsidOld,  LPCLSID pClsidNew);
HRESULT __stdcall OleSetAutoConvert( REFCLSID clsidOld,  REFCLSID clsidNew);

HRESULT __stdcall SetConvertStg( LPSTORAGE pStg,  BOOL fConvert);


HRESULT __stdcall OleConvertIStorageToOLESTREAMEx
    ( LPSTORAGE          pstg,
                                    // Presentation data to OLESTREAM
      CLIPFORMAT         cfFormat,   //      format
      LONG               lWidth,     //      width
      LONG               lHeight,    //      height
      DWORD              dwSize,     //      size in bytes
      LPSTGMEDIUM        pmedium,    //      bits
      LPOLESTREAM        polestm);

HRESULT __stdcall OleConvertOLESTREAMToIStorageEx
    ( LPOLESTREAM        polestm,
      LPSTORAGE          pstg,
                                    // Presentation data from OLESTREAM
      CLIPFORMAT *    pcfFormat,  //      format
      LONG *          plwWidth,   //      width
      LONG *          plHeight,   //      height
      DWORD *         pdwSize,    //      size in bytes
      LPSTGMEDIUM        pmedium);   //      bits
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


ffi.cdef[[
    #pragma pack (pop)
]]
