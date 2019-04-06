local ffi = require("ffi")
--/  Contents:   Structured storage, property sets, and related APIs.


--#include <apiset.h>
--#include <apisetcconv.h>

require("win32.combaseapi")
--require("win32.objidl")
--require("win32.propidlbase")


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) then
--[=[
//
// Common typedefs for paramaters used in Storage APIs, gleamed from storage.h
// Also contains Storage error codes, which should be moved into the storage
// idl files.
//

#define CWCSTORAGENAME 32

/* Storage instantiation modes */
#define STGM_DIRECT             0x00000000L
#define STGM_TRANSACTED         0x00010000L
#define STGM_SIMPLE             0x08000000L

#define STGM_READ               0x00000000L
#define STGM_WRITE              0x00000001L
#define STGM_READWRITE          0x00000002L

#define STGM_SHARE_DENY_NONE    0x00000040L
#define STGM_SHARE_DENY_READ    0x00000030L
#define STGM_SHARE_DENY_WRITE   0x00000020L
#define STGM_SHARE_EXCLUSIVE    0x00000010L

#define STGM_PRIORITY           0x00040000L
#define STGM_DELETEONRELEASE    0x04000000L
#if (WINVER >= 400)
#define STGM_NOSCRATCH          0x00100000L
#endif /* WINVER */

#define STGM_CREATE             0x00001000L
#define STGM_CONVERT            0x00020000L
#define STGM_FAILIFTHERE        0x00000000L

#define STGM_NOSNAPSHOT         0x00200000L
#if (_WIN32_WINNT >= 0x0500)
#define STGM_DIRECT_SWMR        0x00400000L
#endif

typedef DWORD STGFMT;

#define STGFMT_STORAGE          0
#define STGFMT_NATIVE           1
#define STGFMT_FILE             3
#define STGFMT_ANY              4
#define STGFMT_DOCFILE          5

// This is a legacy define to allow old component to builds
#define STGFMT_DOCUMENT         0

// Structured storage APIs

HRESULT __stdcall
StgCreateDocfile(
      const WCHAR* pwcsName,
     DWORD grfMode,
     DWORD reserved,
     IStorage** ppstgOpen
    );



HRESULT __stdcall
StgCreateDocfileOnILockBytes(
     ILockBytes* plkbyt,
     DWORD grfMode,
     DWORD reserved,
     IStorage** ppstgOpen
    );



HRESULT __stdcall
StgOpenStorage(
      const WCHAR* pwcsName,
     IStorage* pstgPriority,
     DWORD grfMode,
    _In_opt_z_ SNB snbExclude,
     DWORD reserved,
     IStorage** ppstgOpen
    );



HRESULT __stdcall
StgOpenStorageOnILockBytes(
     ILockBytes* plkbyt,
     IStorage* pstgPriority,
     DWORD grfMode,
    _In_opt_z_ SNB snbExclude,
     DWORD reserved,
     IStorage** ppstgOpen
    );



HRESULT __stdcall
StgIsStorageFile(
      const WCHAR* pwcsName
    );



HRESULT __stdcall
StgIsStorageILockBytes(
     ILockBytes* plkbyt
    );



HRESULT __stdcall
StgSetTimes(
      const WCHAR* lpszName,
     const FILETIME* pctime,
     const FILETIME* patime,
     const FILETIME* pmtime
    );


// STG initialization options for StgCreateStorageEx and StgOpenStorageEx
#if _WIN32_WINNT == 0x500
#define STGOPTIONS_VERSION 1
#elif _WIN32_WINNT > 0x500
#define STGOPTIONS_VERSION 2
#else
#define STGOPTIONS_VERSION 0
#endif

typedef struct tagSTGOPTIONS
{
    USHORT usVersion;            // Versions 1 and 2 supported
    USHORT reserved;             // must be 0 for padding
    ULONG ulSectorSize;          // docfile header sector size (512)
#if STGOPTIONS_VERSION >= 2
    const WCHAR *pwcsTemplateFile;  // version 2 or above
#endif
} STGOPTIONS;


HRESULT __stdcall
StgCreateStorageEx(
      const WCHAR* pwcsName,
     DWORD grfMode,
     DWORD stgfmt,
     DWORD grfAttrs,
    _Inout_opt_ STGOPTIONS* pStgOptions,
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
     REFIID riid,
     void** ppObjectOpen
    );



HRESULT __stdcall
StgOpenStorageEx(
      const WCHAR* pwcsName,
     DWORD grfMode,
     DWORD stgfmt,
     DWORD grfAttrs,
    _Inout_opt_ STGOPTIONS* pStgOptions,
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
     REFIID riid,
     void** ppObjectOpen
    );
--]=]

if not _STGCREATEPROPSTG_DEFINED_ then

ffi.cdef[[
HRESULT __stdcall
StgCreatePropStg(
     IUnknown* pUnk,
     REFFMTID fmtid,
     const CLSID* pclsid,
     DWORD grfFlags,
     DWORD dwReserved,
     IPropertyStorage** ppPropStg
    );



HRESULT __stdcall
StgOpenPropStg(
     IUnknown* pUnk,
     REFFMTID fmtid,
     DWORD grfFlags,
     DWORD dwReserved,
     IPropertyStorage** ppPropStg
    );



HRESULT __stdcall
StgCreatePropSetStg(
     IStorage* pStorage,
     DWORD dwReserved,
     IPropertySetStorage** ppPropSetStg
    );


static const int CCH_MAX_PROPSTG_NAME   = 31;


HRESULT __stdcall
FmtIdToPropStgName(
     const FMTID* pfmtid,
     LPOLESTR oszName
    );



HRESULT __stdcall
PropStgNameToFmtId(
     const LPOLESTR oszName,
     FMTID* pfmtid
    );
]]

end --// _STGCREATEPROPSTG_DEFINED_

ffi.cdef[[
// Helper functions
HRESULT __stdcall
ReadClassStg(
     LPSTORAGE pStg,
     CLSID  FAR * pclsid
    );


HRESULT __stdcall
WriteClassStg(
     LPSTORAGE pStg,
     REFCLSID rclsid
    );


HRESULT __stdcall
ReadClassStm(
     LPSTREAM pStm,
     CLSID  FAR * pclsid
    );


HRESULT __stdcall
WriteClassStm(
     LPSTREAM pStm,
     REFCLSID rclsid
    );
 

// Storage utility APIs

HRESULT __stdcall
GetHGlobalFromILockBytes(
     LPLOCKBYTES plkbyt,
     HGLOBAL  FAR * phglobal
    );



HRESULT __stdcall
CreateILockBytesOnHGlobal(
     HGLOBAL hGlobal,
     BOOL fDeleteOnRelease,
     LPLOCKBYTES  FAR * pplkbyt
    );


// ConvertTo APIs
HRESULT __stdcall
GetConvertStg(
     LPSTORAGE pStg
    );
]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */



