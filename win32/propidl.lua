--[[

/* this ALWAYS GENERATED file contains the definitions for the interfaces */


/* File created by MIDL compiler version 8.01.0622 */
/* @@MIDL_FILE_HEADING(  ) */
--]]

local ffi = require("ffi")

--[[
/* verify that the <rpcndr.h> version is high enough to compile this file*/
#ifndef __REQUIRED_RPCNDR_H_VERSION__
#define __REQUIRED_RPCNDR_H_VERSION__ 500
#endif

/* verify that the <rpcsal.h> version is high enough to compile this file*/
#ifndef __REQUIRED_RPCSAL_H_VERSION__
#define __REQUIRED_RPCSAL_H_VERSION__ 100
#endif

#include "rpc.h"
#include "rpcndr.h"

#ifndef __RPCNDR_H_VERSION__
#error this stub requires an updated version of <rpcndr.h>
#endif /* __RPCNDR_H_VERSION__ */

#ifndef COM_NO_WINDOWS_H
#include "windows.h"
#include "ole2.h"
#endif /*COM_NO_WINDOWS_H*/
--]]

if not __propidl_h__ then
__propidl_h__ = true



--/* Forward Declarations */ 

--#ifndef __IPropertyStorage_FWD_DEFINED__
--#define __IPropertyStorage_FWD_DEFINED__
typedef interface IPropertyStorage IPropertyStorage;

--#endif 	/* __IPropertyStorage_FWD_DEFINED__ */


--#ifndef __IPropertySetStorage_FWD_DEFINED__
--#define __IPropertySetStorage_FWD_DEFINED__
typedef interface IPropertySetStorage IPropertySetStorage;

--#endif 	/* __IPropertySetStorage_FWD_DEFINED__ */


--#ifndef __IEnumSTATPROPSTG_FWD_DEFINED__
--#define __IEnumSTATPROPSTG_FWD_DEFINED__
typedef interface IEnumSTATPROPSTG IEnumSTATPROPSTG;

--#endif 	/* __IEnumSTATPROPSTG_FWD_DEFINED__ */


--#ifndef __IEnumSTATPROPSETSTG_FWD_DEFINED__
--#define __IEnumSTATPROPSETSTG_FWD_DEFINED__
typedef interface IEnumSTATPROPSETSTG IEnumSTATPROPSETSTG;

--#endif 	/* __IEnumSTATPROPSETSTG_FWD_DEFINED__ */


/* header files for imported files */
require("win32.objidl")
require("win32.oaidl")




/* interface __MIDL_itf_propidl_0000_0000 */
 

//+-------------------------------------------------------------------------
//
//  Microsoft Windows
//  Copyright (c) Microsoft Corporation. All rights reserved.
//
//--------------------------------------------------------------------------


#if ( _MSC_VER >= 800 )
#if _MSC_VER >= 1200
#pragma warning(push)
#pragma warning(disable:4820)    /* padding added after data member */
#endif
#pragma warning(disable:4201)    /* Nameless struct/union */
#pragma warning(disable:4237)    /* obsolete member named 'bool' */
#endif



#include <winapifamily.h>

if not _PROPIDLBASE_ then

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then


ffi.cdef[[
typedef struct tagVersionedStream
   {
   GUID guidVersion;
   IStream *pStream;
   } 	VERSIONEDSTREAM;

typedef struct tagVersionedStream *LPVERSIONEDSTREAM;
]]

ffi.cdef[[
// Flags for IPropertySetStorage::Create
#define	PROPSETFLAG_DEFAULT	( 0 )

#define	PROPSETFLAG_NONSIMPLE	( 1 )

#define	PROPSETFLAG_ANSI	( 2 )

//   (This flag is only supported on StgCreatePropStg & StgOpenPropStg
#define	PROPSETFLAG_UNBUFFERED	( 4 )

//   (This flag causes a version-1 property set to be created
#define	PROPSETFLAG_CASE_SENSITIVE	( 8 )


// Flags for the reserved PID_BEHAVIOR property
#define	PROPSET_BEHAVIOR_CASE_SENSITIVE	( 1 )
]]

ffi.cdef[[
// This is the standard C layout of the PROPVARIANT.
typedef struct tagPROPVARIANT PROPVARIANT;
]]

ffi.cdef[[
typedef struct tagCAC
   {
   ULONG cElems;
   /* [size_is] */ CHAR *pElems;
   } 	CAC;

typedef struct tagCAUB
   {
   ULONG cElems;
   /* [size_is] */ UCHAR *pElems;
   } 	CAUB;

typedef struct tagCAI
   {
   ULONG cElems;
   /* [size_is] */ SHORT *pElems;
   } 	CAI;

typedef struct tagCAUI
   {
   ULONG cElems;
   /* [size_is] */ USHORT *pElems;
   } 	CAUI;

typedef struct tagCAL
   {
   ULONG cElems;
   /* [size_is] */ LONG *pElems;
   } 	CAL;

typedef struct tagCAUL
   {
   ULONG cElems;
   /* [size_is] */ ULONG *pElems;
   } 	CAUL;

typedef struct tagCAFLT
   {
   ULONG cElems;
   /* [size_is] */ FLOAT *pElems;
   } 	CAFLT;

typedef struct tagCADBL
   {
   ULONG cElems;
   /* [size_is] */ DOUBLE *pElems;
   } 	CADBL;

typedef struct tagCACY
   {
   ULONG cElems;
   /* [size_is] */ CY *pElems;
   } 	CACY;

typedef struct tagCADATE
   {
   ULONG cElems;
   /* [size_is] */ DATE *pElems;
   } 	CADATE;

typedef struct tagCABSTR
   {
   ULONG cElems;
   /* [size_is] */ BSTR *pElems;
   } 	CABSTR;

typedef struct tagCABSTRBLOB
   {
   ULONG cElems;
   /* [size_is] */ BSTRBLOB *pElems;
   } 	CABSTRBLOB;

typedef struct tagCABOOL
   {
   ULONG cElems;
   /* [size_is] */ VARIANT_BOOL *pElems;
   } 	CABOOL;

typedef struct tagCASCODE
   {
   ULONG cElems;
   /* [size_is] */ SCODE *pElems;
   } 	CASCODE;

typedef struct tagCAPROPVARIANT
   {
   ULONG cElems;
   /* [size_is] */ PROPVARIANT *pElems;
   } 	CAPROPVARIANT;

typedef struct tagCAH
   {
   ULONG cElems;
   /* [size_is] */ LARGE_INTEGER *pElems;
   } 	CAH;

typedef struct tagCAUH
   {
   ULONG cElems;
   /* [size_is] */ ULARGE_INTEGER *pElems;
   } 	CAUH;

typedef struct tagCALPSTR
   {
   ULONG cElems;
   /* [size_is] */ LPSTR *pElems;
   } 	CALPSTR;

typedef struct tagCALPWSTR
   {
   ULONG cElems;
   /* [size_is] */ LPWSTR *pElems;
   } 	CALPWSTR;

typedef struct tagCAFILETIME
   {
   ULONG cElems;
   /* [size_is] */ FILETIME *pElems;
   } 	CAFILETIME;

typedef struct tagCACLIPDATA
   {
   ULONG cElems;
   /* [size_is] */ CLIPDATA *pElems;
   } 	CACLIPDATA;

typedef struct tagCACLSID
   {
   ULONG cElems;
   /* [size_is] */ CLSID *pElems;
   } 	CACLSID;
]]


ffi.cdef[[
// This is the standard C layout of the structure.
typedef WORD PROPVAR_PAD1;
typedef WORD PROPVAR_PAD2;
typedef WORD PROPVAR_PAD3;
]]
--#define tag_inner_PROPVARIANT


if not _MSC_EXTENSIONS then
ffi.cdef[[
struct tagPROPVARIANT;
]]
else

ffi.cdef[[
struct tagPROPVARIANT {
 union {

struct tag_inner_PROPVARIANT
   {
   VARTYPE vt;
   PROPVAR_PAD1 wReserved1;
   PROPVAR_PAD2 wReserved2;
   PROPVAR_PAD3 wReserved3;
   /* [switch_is] */ /* [switch_type] */ union 
       {
       /* [case()] */  /* Empty union arm */ 
       /* [case()] */ CHAR cVal;
       /* [case()] */ UCHAR bVal;
       /* [case()] */ SHORT iVal;
       /* [case()] */ USHORT uiVal;
       /* [case()] */ LONG lVal;
       /* [case()] */ ULONG ulVal;
       /* [case()] */ INT intVal;
       /* [case()] */ UINT uintVal;
       /* [case()] */ LARGE_INTEGER hVal;
       /* [case()] */ ULARGE_INTEGER uhVal;
       /* [case()] */ FLOAT fltVal;
       /* [case()] */ DOUBLE dblVal;
       /* [case()] */ VARIANT_BOOL boolVal;
       /* [case()] */ _VARIANT_BOOL bool;
       /* [case()] */ SCODE scode;
       /* [case()] */ CY cyVal;
       /* [case()] */ DATE date;
       /* [case()] */ FILETIME filetime;
       /* [case()] */ CLSID *puuid;
       /* [case()] */ CLIPDATA *pclipdata;
       /* [case()] */ BSTR bstrVal;
       /* [case()] */ BSTRBLOB bstrblobVal;
       /* [case()] */ BLOB blob;
       /* [case()] */ LPSTR pszVal;
       /* [case()] */ LPWSTR pwszVal;
       /* [case()] */ IUnknown *punkVal;
       /* [case()] */ IDispatch *pdispVal;
       /* [case()] */ IStream *pStream;
       /* [case()] */ IStorage *pStorage;
       /* [case()] */ LPVERSIONEDSTREAM pVersionedStream;
       /* [case()] */ LPSAFEARRAY parray;
       /* [case()] */ CAC cac;
       /* [case()] */ CAUB caub;
       /* [case()] */ CAI cai;
       /* [case()] */ CAUI caui;
       /* [case()] */ CAL cal;
       /* [case()] */ CAUL caul;
       /* [case()] */ CAH cah;
       /* [case()] */ CAUH cauh;
       /* [case()] */ CAFLT caflt;
       /* [case()] */ CADBL cadbl;
       /* [case()] */ CABOOL cabool;
       /* [case()] */ CASCODE cascode;
       /* [case()] */ CACY cacy;
       /* [case()] */ CADATE cadate;
       /* [case()] */ CAFILETIME cafiletime;
       /* [case()] */ CACLSID cauuid;
       /* [case()] */ CACLIPDATA caclipdata;
       /* [case()] */ CABSTR cabstr;
       /* [case()] */ CABSTRBLOB cabstrblob;
       /* [case()] */ CALPSTR calpstr;
       /* [case()] */ CALPWSTR calpwstr;
       /* [case()] */ CAPROPVARIANT capropvar;
       /* [case()] */ CHAR *pcVal;
       /* [case()] */ UCHAR *pbVal;
       /* [case()] */ SHORT *piVal;
       /* [case()] */ USHORT *puiVal;
       /* [case()] */ LONG *plVal;
       /* [case()] */ ULONG *pulVal;
       /* [case()] */ INT *pintVal;
       /* [case()] */ UINT *puintVal;
       /* [case()] */ FLOAT *pfltVal;
       /* [case()] */ DOUBLE *pdblVal;
       /* [case()] */ VARIANT_BOOL *pboolVal;
       /* [case()] */ DECIMAL *pdecVal;
       /* [case()] */ SCODE *pscode;
       /* [case()] */ CY *pcyVal;
       /* [case()] */ DATE *pdate;
       /* [case()] */ BSTR *pbstrVal;
       /* [case()] */ IUnknown **ppunkVal;
       /* [case()] */ IDispatch **ppdispVal;
       /* [case()] */ LPSAFEARRAY *pparray;
       /* [case()] */ PROPVARIANT *pvarVal;
       } 	;
   } ;

   DECIMAL decVal;
 };
};
]]

end --/* _MSC_EXTENSIONS */



ffi.cdef[[
// This is the standard C layout of the PROPVARIANT.
typedef struct tagPROPVARIANT * LPPROPVARIANT;
]]

if not _REFPROPVARIANT_DEFINED then
_REFPROPVARIANT_DEFINED = true;
ffi.cdef[[
typedef  const PROPVARIANT * const  REFPROPVARIANT
]]
end


ffi.cdef[[
// Reserved global Property IDs
static const int 	PID_DICTIONARY	         = 0;
static const int 	PID_CODEPAGE	         = 0x1;
static const int 	PID_FIRST_USABLE	      = 0x2;
static const int 	PID_FIRST_NAME_DEFAULT	= 0xfff;
static const int 	PID_LOCALE	            = 0x80000000;
static const int 	PID_MODIFY_TIME	      = 0x80000001;
static const int 	PID_SECURITY	         = 0x80000002;
static const int 	PID_BEHAVIOR	         = 0x80000003;
static const int 	PID_ILLEGAL	            = 0xffffffff;
]]

ffi.cdef[[
// Range which is read-only to downlevel implementations
static const int 	PID_MIN_READONLY	= 0x80000000;
static const int 	PID_MAX_READONLY	= 0xbfffffff;
static const int 	PRSPEC_INVALID	   = 0xffffffff;
static const int 	PRSPEC_LPWSTR	   = 0;
static const int 	PRSPEC_PROPID	   = 1;
]]

ffi.cdef[[
typedef struct tagPROPSPEC
   {
   ULONG ulKind;
   /* [switch_is] */ /* [switch_type] */ union 
       {
       /* [case()] */ PROPID propid;
       /* [case()] */ LPOLESTR lpwstr;
       /* [default] */  /* Empty union arm */ 
       } 	DUMMYUNIONNAME;
   } 	PROPSPEC;

typedef struct tagSTATPROPSTG
   {
   LPOLESTR lpwstrName;
   PROPID propid;
   VARTYPE vt;
   } 	STATPROPSTG;
]]


// Macros for parsing the OS Version of the Property Set Header
local function PROPSETHDR_OSVER_KIND(dwOSVer)     return HIWORD( (dwOSVer) ) end
local function PROPSETHDR_OSVER_MAJOR(dwOSVer)    return LOBYTE(LOWORD( (dwOSVer) )) end
local function PROPSETHDR_OSVER_MINOR(dwOSVer)    return HIBYTE(LOWORD( (dwOSVer) )) end

ffi.cdef[[
static const int PROPSETHDR_OSVERSION_UNKNOWN      =  0xFFFFFFFF;
]]

ffi.cdef[[
typedef struct tagSTATPROPSETSTG
   {
   FMTID fmtid;
   CLSID clsid;
   DWORD grfFlags;
   FILETIME mtime;
   FILETIME ctime;
   FILETIME atime;
   DWORD dwOSVersion;
   } 	STATPROPSETSTG;
]]


--extern RPC_IF_HANDLE __MIDL_itf_propidl_0000_0000_v0_0_c_ifspec;
--extern RPC_IF_HANDLE __MIDL_itf_propidl_0000_0000_v0_0_s_ifspec;

#ifndef __IPropertyStorage_INTERFACE_DEFINED__
#define __IPropertyStorage_INTERFACE_DEFINED__

/* interface IPropertyStorage */
/* [unique][uuid][object] */ 


 const IID IID_IPropertyStorage;
 MIDL_INTERFACE("00000138-0000-0000-C000-000000000046")



   typedef struct IPropertyStorageVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
            IPropertyStorage * This,
             REFIID riid,
           /* [annotation][iid_is][out] */ 
           _COM_Outptr_  void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
            IPropertyStorage * This);
       
       ULONG ( __stdcall *Release )( 
            IPropertyStorage * This);
       
       HRESULT ( __stdcall *ReadMultiple )( 
            IPropertyStorage * This,
            ULONG cpspec,
           /* [size_is][in] */  const PROPSPEC rgpspec[  ],
           /* [size_is][out] */  PROPVARIANT rgpropvar[  ]);
       
       HRESULT ( __stdcall *WriteMultiple )( 
            IPropertyStorage * This,
            ULONG cpspec,
           /* [size_is][in] */  const PROPSPEC rgpspec[  ],
           /* [size_is][in] */  const PROPVARIANT rgpropvar[  ],
            PROPID propidNameFirst);
       
       HRESULT ( __stdcall *DeleteMultiple )( 
            IPropertyStorage * This,
            ULONG cpspec,
           /* [size_is][in] */  const PROPSPEC rgpspec[  ]);
       
       HRESULT ( __stdcall *ReadPropertyNames )( 
            IPropertyStorage * This,
            ULONG cpropid,
           /* [size_is][in] */ __RPC__in_ecount_full(cpropid) const PROPID rgpropid[  ],
           /* [size_is][out] */ __RPC__out_ecount_full(cpropid) LPOLESTR rglpwstrName[  ]);
       
       HRESULT ( __stdcall *WritePropertyNames )( 
            IPropertyStorage * This,
            ULONG cpropid,
           /* [size_is][in] */ __RPC__in_ecount_full(cpropid) const PROPID rgpropid[  ],
           /* [size_is][in] */ __RPC__in_ecount_full(cpropid) const LPOLESTR rglpwstrName[  ]);
       
       HRESULT ( __stdcall *DeletePropertyNames )( 
            IPropertyStorage * This,
            ULONG cpropid,
           /* [size_is][in] */ __RPC__in_ecount_full(cpropid) const PROPID rgpropid[  ]);
       
       HRESULT ( __stdcall *Commit )( 
            IPropertyStorage * This,
            DWORD grfCommitFlags);
       
       HRESULT ( __stdcall *Revert )( 
            IPropertyStorage * This);
       
       HRESULT ( __stdcall *Enum )( 
            IPropertyStorage * This,
            __RPC__deref_out_opt IEnumSTATPROPSTG **ppenum);
       
       HRESULT ( __stdcall *SetTimes )( 
            IPropertyStorage * This,
             const FILETIME *pctime,
             const FILETIME *patime,
             const FILETIME *pmtime);
       
       HRESULT ( __stdcall *SetClass )( 
            IPropertyStorage * This,
             REFCLSID clsid);
       
       HRESULT ( __stdcall *Stat )( 
            IPropertyStorage * This,
             STATPROPSETSTG *pstatpsstg);
       
       END_INTERFACE
   } IPropertyStorageVtbl;

   interface IPropertyStorage
   {
       CONST_VTBL struct IPropertyStorageVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IPropertyStorage_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IPropertyStorage_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IPropertyStorage_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IPropertyStorage_ReadMultiple(This,cpspec,rgpspec,rgpropvar)	\
   ( (This)->lpVtbl -> ReadMultiple(This,cpspec,rgpspec,rgpropvar) ) 

#define IPropertyStorage_WriteMultiple(This,cpspec,rgpspec,rgpropvar,propidNameFirst)	\
   ( (This)->lpVtbl -> WriteMultiple(This,cpspec,rgpspec,rgpropvar,propidNameFirst) ) 

#define IPropertyStorage_DeleteMultiple(This,cpspec,rgpspec)	\
   ( (This)->lpVtbl -> DeleteMultiple(This,cpspec,rgpspec) ) 

#define IPropertyStorage_ReadPropertyNames(This,cpropid,rgpropid,rglpwstrName)	\
   ( (This)->lpVtbl -> ReadPropertyNames(This,cpropid,rgpropid,rglpwstrName) ) 

#define IPropertyStorage_WritePropertyNames(This,cpropid,rgpropid,rglpwstrName)	\
   ( (This)->lpVtbl -> WritePropertyNames(This,cpropid,rgpropid,rglpwstrName) ) 

#define IPropertyStorage_DeletePropertyNames(This,cpropid,rgpropid)	\
   ( (This)->lpVtbl -> DeletePropertyNames(This,cpropid,rgpropid) ) 

#define IPropertyStorage_Commit(This,grfCommitFlags)	\
   ( (This)->lpVtbl -> Commit(This,grfCommitFlags) ) 

#define IPropertyStorage_Revert(This)	\
   ( (This)->lpVtbl -> Revert(This) ) 

#define IPropertyStorage_Enum(This,ppenum)	\
   ( (This)->lpVtbl -> Enum(This,ppenum) ) 

#define IPropertyStorage_SetTimes(This,pctime,patime,pmtime)	\
   ( (This)->lpVtbl -> SetTimes(This,pctime,patime,pmtime) ) 

#define IPropertyStorage_SetClass(This,clsid)	\
   ( (This)->lpVtbl -> SetClass(This,clsid) ) 

#define IPropertyStorage_Stat(This,pstatpsstg)	\
   ( (This)->lpVtbl -> Stat(This,pstatpsstg) ) 

#endif /* COBJMACROS */







#endif 	/* __IPropertyStorage_INTERFACE_DEFINED__ */


#ifndef __IPropertySetStorage_INTERFACE_DEFINED__
#define __IPropertySetStorage_INTERFACE_DEFINED__

/* interface IPropertySetStorage */
/* [unique][uuid][object] */ 

typedef /* [unique] */  __RPC_unique_pointer IPropertySetStorage *LPPROPERTYSETSTORAGE;


 const IID IID_IPropertySetStorage;
 MIDL_INTERFACE("0000013A-0000-0000-C000-000000000046")



   typedef struct IPropertySetStorageVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
            IPropertySetStorage * This,
             REFIID riid,
           /* [annotation][iid_is][out] */ 
           _COM_Outptr_  void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
            IPropertySetStorage * This);
       
       ULONG ( __stdcall *Release )( 
            IPropertySetStorage * This);
       
       HRESULT ( __stdcall *Create )( 
            IPropertySetStorage * This,
             REFFMTID rfmtid,
           /* [unique][in] */ __RPC__in_opt const CLSID *pclsid,
            DWORD grfFlags,
            DWORD grfMode,
            __RPC__deref_out_opt IPropertyStorage **ppprstg);
       
       HRESULT ( __stdcall *Open )( 
            IPropertySetStorage * This,
             REFFMTID rfmtid,
            DWORD grfMode,
            __RPC__deref_out_opt IPropertyStorage **ppprstg);
       
       HRESULT ( __stdcall *Delete )( 
            IPropertySetStorage * This,
             REFFMTID rfmtid);
       
       HRESULT ( __stdcall *Enum )( 
            IPropertySetStorage * This,
            __RPC__deref_out_opt IEnumSTATPROPSETSTG **ppenum);
       
       END_INTERFACE
   } IPropertySetStorageVtbl;

   interface IPropertySetStorage
   {
       CONST_VTBL struct IPropertySetStorageVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IPropertySetStorage_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IPropertySetStorage_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IPropertySetStorage_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IPropertySetStorage_Create(This,rfmtid,pclsid,grfFlags,grfMode,ppprstg)	\
   ( (This)->lpVtbl -> Create(This,rfmtid,pclsid,grfFlags,grfMode,ppprstg) ) 

#define IPropertySetStorage_Open(This,rfmtid,grfMode,ppprstg)	\
   ( (This)->lpVtbl -> Open(This,rfmtid,grfMode,ppprstg) ) 

#define IPropertySetStorage_Delete(This,rfmtid)	\
   ( (This)->lpVtbl -> Delete(This,rfmtid) ) 

#define IPropertySetStorage_Enum(This,ppenum)	\
   ( (This)->lpVtbl -> Enum(This,ppenum) ) 

#endif /* COBJMACROS */






#endif 	/* __IPropertySetStorage_INTERFACE_DEFINED__ */


#ifndef __IEnumSTATPROPSTG_INTERFACE_DEFINED__
#define __IEnumSTATPROPSTG_INTERFACE_DEFINED__

/* interface IEnumSTATPROPSTG */
/* [unique][uuid][object] */ 

typedef /* [unique] */  __RPC_unique_pointer IEnumSTATPROPSTG *LPENUMSTATPROPSTG;


 const IID IID_IEnumSTATPROPSTG;
 MIDL_INTERFACE("00000139-0000-0000-C000-000000000046")



   typedef struct IEnumSTATPROPSTGVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
            IEnumSTATPROPSTG * This,
             REFIID riid,
           /* [annotation][iid_is][out] */ 
           _COM_Outptr_  void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
            IEnumSTATPROPSTG * This);
       
       ULONG ( __stdcall *Release )( 
            IEnumSTATPROPSTG * This);
       
        HRESULT ( __stdcall *Next )( 
           IEnumSTATPROPSTG * This,
            ULONG celt,
            
             STATPROPSTG *rgelt,
            
              ULONG *pceltFetched);
       
       HRESULT ( __stdcall *Skip )( 
            IEnumSTATPROPSTG * This,
            ULONG celt);
       
       HRESULT ( __stdcall *Reset )( 
            IEnumSTATPROPSTG * This);
       
       HRESULT ( __stdcall *Clone )( 
            IEnumSTATPROPSTG * This,
            __RPC__deref_out_opt IEnumSTATPROPSTG **ppenum);
       
       END_INTERFACE
   } IEnumSTATPROPSTGVtbl;

   interface IEnumSTATPROPSTG
   {
       CONST_VTBL struct IEnumSTATPROPSTGVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IEnumSTATPROPSTG_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IEnumSTATPROPSTG_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IEnumSTATPROPSTG_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IEnumSTATPROPSTG_Next(This,celt,rgelt,pceltFetched)	\
   ( (This)->lpVtbl -> Next(This,celt,rgelt,pceltFetched) ) 

#define IEnumSTATPROPSTG_Skip(This,celt)	\
   ( (This)->lpVtbl -> Skip(This,celt) ) 

#define IEnumSTATPROPSTG_Reset(This)	\
   ( (This)->lpVtbl -> Reset(This) ) 

#define IEnumSTATPROPSTG_Clone(This,ppenum)	\
   ( (This)->lpVtbl -> Clone(This,ppenum) ) 

#endif /* COBJMACROS */





ffi.cdef[[
 HRESULT __stdcall IEnumSTATPROPSTG_RemoteNext_Proxy( 
    IEnumSTATPROPSTG * This,
    ULONG celt,
     STATPROPSTG *rgelt,
     ULONG *pceltFetched);


void __RPC_STUB IEnumSTATPROPSTG_RemoteNext_Stub(
   IRpcStubBuffer *This,
   IRpcChannelBuffer *_pRpcChannelBuffer,
   PRPC_MESSAGE _pRpcMessage,
   DWORD *_pdwStubPhase);
]]


#endif 	/* __IEnumSTATPROPSTG_INTERFACE_DEFINED__ */


#ifndef __IEnumSTATPROPSETSTG_INTERFACE_DEFINED__
#define __IEnumSTATPROPSETSTG_INTERFACE_DEFINED__

/* interface IEnumSTATPROPSETSTG */
/* [unique][uuid][object] */ 

typedef /* [unique] */  __RPC_unique_pointer IEnumSTATPROPSETSTG *LPENUMSTATPROPSETSTG;


 const IID IID_IEnumSTATPROPSETSTG;
 MIDL_INTERFACE("0000013B-0000-0000-C000-000000000046")



   typedef struct IEnumSTATPROPSETSTGVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
            IEnumSTATPROPSETSTG * This,
             REFIID riid,
           /* [annotation][iid_is][out] */ 
           _COM_Outptr_  void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
            IEnumSTATPROPSETSTG * This);
       
       ULONG ( __stdcall *Release )( 
            IEnumSTATPROPSETSTG * This);
       
        HRESULT ( __stdcall *Next )( 
           IEnumSTATPROPSETSTG * This,
            ULONG celt,
            
             STATPROPSETSTG *rgelt,
            
              ULONG *pceltFetched);
       
       HRESULT ( __stdcall *Skip )( 
            IEnumSTATPROPSETSTG * This,
            ULONG celt);
       
       HRESULT ( __stdcall *Reset )( 
            IEnumSTATPROPSETSTG * This);
       
       HRESULT ( __stdcall *Clone )( 
            IEnumSTATPROPSETSTG * This,
            __RPC__deref_out_opt IEnumSTATPROPSETSTG **ppenum);
       
       END_INTERFACE
   } IEnumSTATPROPSETSTGVtbl;

   interface IEnumSTATPROPSETSTG
   {
       CONST_VTBL struct IEnumSTATPROPSETSTGVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IEnumSTATPROPSETSTG_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IEnumSTATPROPSETSTG_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IEnumSTATPROPSETSTG_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IEnumSTATPROPSETSTG_Next(This,celt,rgelt,pceltFetched)	\
   ( (This)->lpVtbl -> Next(This,celt,rgelt,pceltFetched) ) 

#define IEnumSTATPROPSETSTG_Skip(This,celt)	\
   ( (This)->lpVtbl -> Skip(This,celt) ) 

#define IEnumSTATPROPSETSTG_Reset(This)	\
   ( (This)->lpVtbl -> Reset(This) ) 

#define IEnumSTATPROPSETSTG_Clone(This,ppenum)	\
   ( (This)->lpVtbl -> Clone(This,ppenum) ) 

#endif /* COBJMACROS */





ffi.cdef[[
 HRESULT __stdcall IEnumSTATPROPSETSTG_RemoteNext_Proxy( 
    IEnumSTATPROPSETSTG * This,
    ULONG celt,
     STATPROPSETSTG *rgelt,
     ULONG *pceltFetched);


void __RPC_STUB IEnumSTATPROPSETSTG_RemoteNext_Stub(
   IRpcStubBuffer *This,
   IRpcChannelBuffer *_pRpcChannelBuffer,
   PRPC_MESSAGE _pRpcMessage,
   DWORD *_pdwStubPhase);
]]


#endif 	/* __IEnumSTATPROPSETSTG_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_propidl_0000_0004 */
 

typedef /* [unique] */  __RPC_unique_pointer IPropertyStorage *LPPROPERTYSTORAGE;

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


#define _PROPIDLBASE_
#endif
#include <coml2api.h>

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
-- Property IDs for the DiscardableInformation Property Set

ffi.cdef[[
static const int PIDDI_THUMBNAIL          = 0x00000002; // VT_BLOB
]]

ffi.cdef[[
// Property IDs for the SummaryInformation Property Set

static const int PIDSI_TITLE               = 0x00000002;  // VT_LPSTR
static const int PIDSI_SUBJECT             = 0x00000003;  // VT_LPSTR
static const int PIDSI_AUTHOR              = 0x00000004;  // VT_LPSTR
static const int PIDSI_KEYWORDS            = 0x00000005;  // VT_LPSTR
static const int PIDSI_COMMENTS            = 0x00000006;  // VT_LPSTR
static const int PIDSI_TEMPLATE            = 0x00000007;  // VT_LPSTR
static const int PIDSI_LASTAUTHOR          = 0x00000008;  // VT_LPSTR
static const int PIDSI_REVNUMBER           = 0x00000009;  // VT_LPSTR
static const int PIDSI_EDITTIME            = 0x0000000a;  // VT_FILETIME (UTC)
static const int PIDSI_LASTPRINTED         = 0x0000000b;  // VT_FILETIME (UTC)
static const int PIDSI_CREATE_DTM          = 0x0000000c;  // VT_FILETIME (UTC)
static const int PIDSI_LASTSAVE_DTM        = 0x0000000d;  // VT_FILETIME (UTC)
static const int PIDSI_PAGECOUNT           = 0x0000000e;  // VT_I4
static const int PIDSI_WORDCOUNT           = 0x0000000f;  // VT_I4
static const int PIDSI_CHARCOUNT           = 0x00000010;  // VT_I4
static const int PIDSI_THUMBNAIL           = 0x00000011;  // VT_CF
static const int PIDSI_APPNAME             = 0x00000012;  // VT_LPSTR
static const int PIDSI_DOC_SECURITY        = 0x00000013;  // VT_I4
]]

ffi.cdef[[
// Property IDs for the DocSummaryInformation Property Set

static const int PIDDSI_CATEGORY          = 0x00000002; // VT_LPSTR
static const int PIDDSI_PRESFORMAT        = 0x00000003; // VT_LPSTR
static const int PIDDSI_BYTECOUNT         = 0x00000004; // VT_I4
static const int PIDDSI_LINECOUNT         = 0x00000005; // VT_I4
static const int PIDDSI_PARCOUNT          = 0x00000006; // VT_I4
static const int PIDDSI_SLIDECOUNT        = 0x00000007; // VT_I4
static const int PIDDSI_NOTECOUNT         = 0x00000008; // VT_I4
static const int PIDDSI_HIDDENCOUNT       = 0x00000009; // VT_I4
static const int PIDDSI_MMCLIPCOUNT       = 0x0000000A; // VT_I4
static const int PIDDSI_SCALE             = 0x0000000B; // VT_BOOL
static const int PIDDSI_HEADINGPAIR       = 0x0000000C; // VT_VARIANT | VT_VECTOR
static const int PIDDSI_DOCPARTS          = 0x0000000D; // VT_LPSTR | VT_VECTOR
static const int PIDDSI_MANAGER           = 0x0000000E; // VT_LPSTR
static const int PIDDSI_COMPANY           = 0x0000000F; // VT_LPSTR
static const int PIDDSI_LINKSDIRTY        = 0x00000010; // VT_BOOL
]]

ffi.cdef[[
//  FMTID_MediaFileSummaryInfo - Property IDs

static const int PIDMSI_EDITOR                   = 0x00000002;  // VT_LPWSTR
static const int PIDMSI_SUPPLIER                 = 0x00000003;  // VT_LPWSTR
static const int PIDMSI_SOURCE                   = 0x00000004;  // VT_LPWSTR
static const int PIDMSI_SEQUENCE_NO              = 0x00000005;  // VT_LPWSTR
static const int PIDMSI_PROJECT                  = 0x00000006;  // VT_LPWSTR
static const int PIDMSI_STATUS                   = 0x00000007;  // VT_UI4
static const int PIDMSI_OWNER                    = 0x00000008;  // VT_LPWSTR
static const int PIDMSI_RATING                   = 0x00000009;  // VT_LPWSTR
static const int PIDMSI_PRODUCTION               = 0x0000000A;  // VT_FILETIME (UTC)
static const int PIDMSI_COPYRIGHT                = 0x0000000B;  // VT_LPWSTR
]]

ffi.cdef[[
//  PIDMSI_STATUS value definitions

enum PIDMSI_STATUS_VALUE
   {
       PIDMSI_STATUS_NORMAL	= 0,
       PIDMSI_STATUS_NEW	= ( PIDMSI_STATUS_NORMAL + 1 ) ,
       PIDMSI_STATUS_PRELIM	= ( PIDMSI_STATUS_NEW + 1 ) ,
       PIDMSI_STATUS_DRAFT	= ( PIDMSI_STATUS_PRELIM + 1 ) ,
       PIDMSI_STATUS_INPROGRESS	= ( PIDMSI_STATUS_DRAFT + 1 ) ,
       PIDMSI_STATUS_EDIT	= ( PIDMSI_STATUS_INPROGRESS + 1 ) ,
       PIDMSI_STATUS_REVIEW	= ( PIDMSI_STATUS_EDIT + 1 ) ,
       PIDMSI_STATUS_PROOF	= ( PIDMSI_STATUS_REVIEW + 1 ) ,
       PIDMSI_STATUS_FINAL	= ( PIDMSI_STATUS_PROOF + 1 ) ,
       PIDMSI_STATUS_OTHER	= 0x7fff
   } ;
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
HRESULT __stdcall PropVariantCopy(PROPVARIANT* pvarDest, const PROPVARIANT * pvarSrc);

HRESULT __stdcall PropVariantClear( PROPVARIANT* pvar);

HRESULT __stdcall FreePropVariantArray(ULONG cVariants, PROPVARIANT* rgvars);
]]

--[=[
if _MSC_EXTENSIONS

#define _PROPVARIANTINIT_DEFINED_
#ifdef __cplusplus

inline void PropVariantInit ( PROPVARIANT * pvar )
{
   memset ( pvar, 0, sizeof(PROPVARIANT) );
}

#else
#define PropVariantInit(pvar) memset ( (pvar), 0, sizeof(PROPVARIANT) )
#endif


end --/* _MSC_EXTENSIONS */
--]=]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

if not _SERIALIZEDPROPERTYVALUE_DEFINED_ then
_SERIALIZEDPROPERTYVALUE_DEFINED_ = true
ffi.cdef[[
typedef struct tagSERIALIZEDPROPERTYVALUE
{
   DWORD	dwType;
   BYTE	rgb[1];
} SERIALIZEDPROPERTYVALUE;
]]
end

ffi.cdef[[
SERIALIZEDPROPERTYVALUE* __stdcall
StgConvertVariantToProperty(
            const PROPVARIANT* pvar,
            USHORT CodePage,
            SERIALIZEDPROPERTYVALUE* pprop,
            ULONG* pcb,
            PROPID pid,
            BOOLEAN fReserved,
            ULONG* pcIndirect);
]]

--[[
#ifdef __cplusplus
class PMemoryAllocator;


BOOLEAN __stdcall
StgConvertPropertyToVariant(
            const SERIALIZEDPROPERTYVALUE* pprop,
            USHORT CodePage,
            PROPVARIANT* pvar,
            PMemoryAllocator* pma);
#endif
--]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


--[[
#if _MSC_VER >= 1200
#pragma warning(pop)
#else
#pragma warning(default:4201)    /* Nameless struct/union */
#pragma warning(default:4237)    /* keywords bool, true, false, etc.. */
#endif
--]]

--extern RPC_IF_HANDLE __MIDL_itf_propidl_0000_0004_v0_0_c_ifspec;
--extern RPC_IF_HANDLE __MIDL_itf_propidl_0000_0004_v0_0_s_ifspec;

ffi.cdef[[
/* Additional Prototypes for ALL interfaces */

unsigned long   __stdcall  BSTR_UserSize(      unsigned long *, unsigned long            ,  BSTR * ); 
unsigned char * __stdcall  BSTR_UserMarshal(   unsigned long *,  unsigned char *,  BSTR * ); 
unsigned char * __stdcall  BSTR_UserUnmarshal( unsigned long *,  unsigned char *,  BSTR * ); 
void            __stdcall  BSTR_UserFree(      unsigned long *,  BSTR * ); 

unsigned long   __stdcall  LPSAFEARRAY_UserSize(      unsigned long *, unsigned long            ,  LPSAFEARRAY * ); 
unsigned char * __stdcall  LPSAFEARRAY_UserMarshal(   unsigned long *,  unsigned char *,  LPSAFEARRAY * ); 
unsigned char * __stdcall  LPSAFEARRAY_UserUnmarshal( unsigned long *,  unsigned char *,  LPSAFEARRAY * ); 
void            __stdcall  LPSAFEARRAY_UserFree(      unsigned long *,  LPSAFEARRAY * ); 

unsigned long   __stdcall  BSTR_UserSize64(      unsigned long *, unsigned long            ,  BSTR * ); 
unsigned char * __stdcall  BSTR_UserMarshal64(   unsigned long *,  unsigned char *,  BSTR * ); 
unsigned char * __stdcall  BSTR_UserUnmarshal64( unsigned long *,  unsigned char *,  BSTR * ); 
void            __stdcall  BSTR_UserFree64(      unsigned long *,  BSTR * ); 

unsigned long   __stdcall  LPSAFEARRAY_UserSize64(      unsigned long *, unsigned long            ,  LPSAFEARRAY * ); 
unsigned char * __stdcall  LPSAFEARRAY_UserMarshal64(   unsigned long *,  unsigned char *,  LPSAFEARRAY * ); 
unsigned char * __stdcall  LPSAFEARRAY_UserUnmarshal64( unsigned long *,  unsigned char *,  LPSAFEARRAY * ); 
void            __stdcall  LPSAFEARRAY_UserFree64(      unsigned long *,  LPSAFEARRAY * ); 
]]

ffi.cdef[[
 HRESULT __stdcall IEnumSTATPROPSTG_Next_Proxy( 
   IEnumSTATPROPSTG * This,
    ULONG celt,
    
     STATPROPSTG *rgelt,
    
      ULONG *pceltFetched);


 HRESULT __stdcall IEnumSTATPROPSTG_Next_Stub( 
    IEnumSTATPROPSTG * This,
    ULONG celt,
     STATPROPSTG *rgelt,
     ULONG *pceltFetched);

 HRESULT __stdcall IEnumSTATPROPSETSTG_Next_Proxy( 
   IEnumSTATPROPSETSTG * This,
    ULONG celt,
    
     STATPROPSETSTG *rgelt,
    
      ULONG *pceltFetched);


 HRESULT __stdcall IEnumSTATPROPSETSTG_Next_Stub( 
    IEnumSTATPROPSETSTG * This,
    ULONG celt,
     STATPROPSETSTG *rgelt,
     ULONG *pceltFetched);
]]


-- end of Additional Prototypes

end


