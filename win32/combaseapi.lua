local ffi = require ("ffi")

--#include <apiset.h>
--#include <apisetcconv.h>


--#include <rpc.h>
require("win32.rpcndr")

--[[
if (NTDDI_VERSION >= NTDDI_VISTA && !defined(_WIN32_WINNT))
#define _WIN32_WINNT 0x0600
#endif

if (NTDDI_VERSION >= NTDDI_WS03 && !defined(_WIN32_WINNT))
#define _WIN32_WINNT 0x0502
#endif

if (NTDDI_VERSION >= NTDDI_WINXP && !defined(_WIN32_WINNT))
#define _WIN32_WINNT 0x0501
#endif

if (NTDDI_VERSION >= NTDDI_WIN2K && !defined(_WIN32_WINNT))
#define _WIN32_WINNT 0x0500
#endif
--]]

--if !defined(_COMBASEAPI_H_)
--#define _COMBASEAPI_H_


ffi.cdef[[
    #pragma pack (push, 8)
]]

--[[
--//TODO change _OLE32_ to _COMBASEAPI_
if _OLE32_
    #define WINOLEAPI        STDAPI
    #define WINOLEAPI_(type) STDAPI_(type)
else
    if _68K_
        if not REQUIRESAPPLEPASCAL
            #define WINOLEAPI        EXTERN_C DECLSPEC_IMPORT HRESULT PASCAL
            #define WINOLEAPI_(type) EXTERN_C DECLSPEC_IMPORT type PASCAL
        else
            #define WINOLEAPI        EXTERN_C DECLSPEC_IMPORT PASCAL HRESULT
            #define WINOLEAPI_(type) EXTERN_C DECLSPEC_IMPORT PASCAL type
        end
    else
        #define WINOLEAPI        EXTERN_C DECLSPEC_IMPORT HRESULT __stdcall
        #define WINOLEAPI_(type) EXTERN_C DECLSPEC_IMPORT type __stdcall
    end
end
--]]


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then


 --[[
if defined(__cplusplus) && !defined(CINTERFACE)
//#define interface               struct 

#ifdef COM_STDMETHOD_CAN_THROW
#define COM_DECLSPEC_NOTHROW
#else
#define COM_DECLSPEC_NOTHROW DECLSPEC_NOTHROW
#endif


#define __STRUCT__ struct
#define interface __STRUCT__
#define STDMETHOD(method)        virtual COM_DECLSPEC_NOTHROW HRESULT STDMETHODCALLTYPE method
#define STDMETHOD_(type,method)  virtual COM_DECLSPEC_NOTHROW type STDMETHODCALLTYPE method
#define STDMETHODV(method)       virtual COM_DECLSPEC_NOTHROW HRESULT STDMETHODVCALLTYPE method
#define STDMETHODV_(type,method) virtual COM_DECLSPEC_NOTHROW type STDMETHODVCALLTYPE method
#define PURE                    = 0
#define THIS_
#define THIS                    void
#define DECLARE_INTERFACE(iface)                        interface DECLSPEC_NOVTABLE iface
#define DECLARE_INTERFACE_(iface, baseiface)            interface DECLSPEC_NOVTABLE iface : public baseiface
#define DECLARE_INTERFACE_IID(iface, iid)               interface DECLSPEC_UUID(iid) DECLSPEC_NOVTABLE iface
#define DECLARE_INTERFACE_IID_(iface, baseiface, iid)   interface DECLSPEC_UUID(iid) DECLSPEC_NOVTABLE iface : public baseiface
--]]
--[=[
#define IFACEMETHOD(method)         __override STDMETHOD(method)
#define IFACEMETHOD_(type,method)   __override STDMETHOD_(type,method)
#define IFACEMETHODV(method)        __override STDMETHODV(method)
#define IFACEMETHODV_(type,method)  __override STDMETHODV_(type,method)

if !defined(BEGIN_INTERFACE)
if defined(_MPPC_) && ((defined(_MSC_VER) or defined(__SC__) or defined(__MWERKS__)) && !defined(NO_NULL_VTABLE_ENTRY))
   #define BEGIN_INTERFACE virtual void a() {}
   #define END_INTERFACE
#else
   #define BEGIN_INTERFACE
   #define END_INTERFACE
#endif
#endif



#define IID_PPV_ARGS(ppType) __uuidof(**(ppType)), IID_PPV_ARGS_Helper(ppType)

#else

#define interface               struct

#define STDMETHOD(method)       HRESULT (STDMETHODCALLTYPE * method)
#define STDMETHOD_(type,method) type (STDMETHODCALLTYPE * method)
#define STDMETHODV(method)       HRESULT (STDMETHODVCALLTYPE * method)
#define STDMETHODV_(type,method) type (STDMETHODVCALLTYPE * method)

#define IFACEMETHOD(method)         __override STDMETHOD(method)
#define IFACEMETHOD_(type,method)   __override STDMETHOD_(type,method)
#define IFACEMETHODV(method)        __override STDMETHODV(method)
#define IFACEMETHODV_(type,method)  __override STDMETHODV_(type,method)

if !defined(BEGIN_INTERFACE)
if defined(_MPPC_)
    #define BEGIN_INTERFACE       void    *b;
    #define END_INTERFACE
#else
    #define BEGIN_INTERFACE
    #define END_INTERFACE
#endif
#endif

#define PURE
#define THIS_                   INTERFACE * This,
#define THIS                    INTERFACE * This
#ifdef CONST_VTABLE
#undef CONST_VTBL
#define CONST_VTBL const
#define DECLARE_INTERFACE(iface)    typedef interface iface { \
                                    const struct iface##Vtbl * lpVtbl; \
                                } iface; \
                                typedef const struct iface##Vtbl iface##Vtbl; \
                                const struct iface##Vtbl
#else
#undef CONST_VTBL
#define CONST_VTBL
#define DECLARE_INTERFACE(iface)    typedef interface iface { \
                                    struct iface##Vtbl * lpVtbl; \
                                } iface; \
                                typedef struct iface##Vtbl iface##Vtbl; \
                                struct iface##Vtbl
#endif
#define DECLARE_INTERFACE_(iface, baseiface)    DECLARE_INTERFACE(iface)
#define DECLARE_INTERFACE_IID(iface, iid)               DECLARE_INTERFACE(iface)
#define DECLARE_INTERFACE_IID_(iface, baseiface, iid)   DECLARE_INTERFACE_(iface, baseiface)
#endif

/****** Additional basic types **********************************************/

#ifndef FARSTRUCT
#ifdef __cplusplus
#define FARSTRUCT   
#else
#define FARSTRUCT
#endif  // __cplusplus
#endif  // FARSTRUCT

#ifndef HUGEP
if defined(_WIN32) or defined(_MPPC_)
#define HUGEP
#else
#define HUGEP __huge
end  -- WIN32
end  -- HUGEP

#include <stdlib.h>

#define LISet32(li, v) ((li).HighPart = ((LONG) (v)) < 0 ? -1 : 0, (li).LowPart = (v))

#define ULISet32(li, v) ((li).HighPart = 0, (li).LowPart = (v))

#define CLSCTX_INPROC           (CLSCTX_INPROC_SERVER|CLSCTX_INPROC_HANDLER)

// With DCOM, CLSCTX_REMOTE_SERVER should be included
// DCOM
if (_WIN32_WINNT >= 0x0400) or _WIN32_DCOM
#define CLSCTX_ALL              (CLSCTX_INPROC_SERVER| \
                                 CLSCTX_INPROC_HANDLER| \
                                 CLSCTX_LOCAL_SERVER| \
                                 CLSCTX_REMOTE_SERVER)

#define CLSCTX_SERVER           (CLSCTX_INPROC_SERVER|CLSCTX_LOCAL_SERVER|CLSCTX_REMOTE_SERVER)
#else
#define CLSCTX_ALL              (CLSCTX_INPROC_SERVER| \
                                 CLSCTX_INPROC_HANDLER| \
                                 CLSCTX_LOCAL_SERVER )

#define CLSCTX_SERVER           (CLSCTX_INPROC_SERVER|CLSCTX_LOCAL_SERVER)
#endif

// class registration flags; passed to CoRegisterClassObject
typedef enum tagREGCLS
{
    REGCLS_SINGLEUSE = 0,       // class object only generates one instance
    REGCLS_MULTIPLEUSE = 1,     // same class object genereates multiple inst.
                                // and local automatically goes into inproc tbl.
    REGCLS_MULTI_SEPARATE = 2,  // multiple use, but separate control over each
                                // context.
    REGCLS_SUSPENDED      = 4,  // register is as suspended, will be activated
                                // when app calls CoResumeClassObjects
    REGCLS_SURROGATE      = 8,  // must be used when a surrogate process
                                // is registering a class object that will be
                                // loaded in the surrogate
if (NTDDI_VERSION >= NTDDI_WINTHRESHOLD)
    REGCLS_AGILE = 0x10,        // Class object aggregates the free-threaded marshaler
                                // and will be made visible to all inproc apartments.
                                // Can be used together with other flags - for example,
                                // REGCLS_AGILE | REGCLS_MULTIPLEUSE to register a
                                // class object that can be used multiple times from
                                // different apartments. Without other flags, behavior
                                // will retain REGCLS_SINGLEUSE semantics in that only
                                // one instance can be generated.
#endif
} REGCLS;

/* here is where we pull in the MIDL generated headers for the interfaces */
typedef interface    IRpcStubBuffer     IRpcStubBuffer;
typedef interface    IRpcChannelBuffer  IRpcChannelBuffer;

// COM initialization flags; passed to CoInitialize.
typedef enum tagCOINITBASE
{
// DCOM
if (_WIN32_WINNT >= 0x0400) or _WIN32_DCOM
  // These constants are only valid on Windows NT 4.0
  COINITBASE_MULTITHREADED      = 0x0,      // OLE calls objects on any thread.
end  -- DCOM
} COINITBASE;
--]=]

require("win32.wtypesbase")
require("win32.unknwnbase")

require("win32.objidlbase")

require("win32.guiddef")

if not INITGUID then
--// TODO change to cguidbase.h
--#include <cguid.h>
end

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
 HRESULT __stdcall
CoGetMalloc(
     DWORD dwMemContext,
     LPMALLOC   * ppMalloc
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
 HRESULT __stdcall
CreateStreamOnHGlobal(
    HGLOBAL hGlobal,
     BOOL fDeleteOnRelease,
     LPSTREAM   * ppstm
    );


 HRESULT __stdcall
GetHGlobalFromStream(
     LPSTREAM pstm,
     HGLOBAL   * phglobal
    );




void
CoUninitialize(
    void
    );
]]
end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
DWORD 
CoGetCurrentProcess(
    void
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


-- DCOM
if (_WIN32_WINNT >= 0x0400) or _WIN32_DCOM


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
 HRESULT __stdcall
CoInitializeEx(
     LPVOID pvReserved,
     DWORD dwCoInit
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
HRESULT __stdcall
CoGetCallerTID(
     LPDWORD lpdwTID
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
HRESULT __stdcall
CoGetCurrentLogicalThreadId(
     GUID* pguid
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then


end  -- DCOM

--[=[
if (_WIN32_WINNT >= 0x0501)


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

 HRESULT __stdcall
CoGetContextToken(
     ULONG_PTR* pToken
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

 HRESULT __stdcall
CoGetDefaultContext(
     APTTYPE aptType,
     REFIID riid,
     void** ppv
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


#endif


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

// definition for Win7 new APIs

if (NTDDI_VERSION >= NTDDI_WIN7)

 HRESULT __stdcall
CoGetApartmentType(
     APTTYPE* pAptType,
     APTTYPEQUALIFIER* pAptQualifier
    );


#endif

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then


// definition for Win8 new APIs

if (NTDDI_VERSION >= NTDDI_WIN8)


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

typedef struct tagServerInformation
{
    DWORD  dwServerPid;
    DWORD  dwServerTid;
    UINT64 ui64ServerAddress;
} ServerInformation, *PServerInformation;

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

 HRESULT __stdcall
CoDecodeProxy(
     DWORD dwClientPid,
     UINT64 ui64ProxyAddress,
     PServerInformation pServerInformation
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

DECLARE_HANDLE(CO_MTA_USAGE_COOKIE);

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

 HRESULT __stdcall
CoIncrementMTAUsage(
     CO_MTA_USAGE_COOKIE* pCookie
    );

               HRESULT __stdcall
CoDecrementMTAUsage(
     CO_MTA_USAGE_COOKIE Cookie
    );


HRESULT __stdcall
CoAllowUnmarshalerCLSID(
     REFCLSID clsid
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


#endif


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

 HRESULT __stdcall
CoGetObjectContext(
     REFIID riid,
     LPVOID   * ppv
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

/* register/revoke/get class objects */

 HRESULT __stdcall
CoGetClassObject(
     REFCLSID rclsid,
     DWORD dwClsContext,
     LPVOID pvReserved,
     REFIID riid,
     LPVOID   * ppv
    );

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

 HRESULT __stdcall
CoRegisterClassObject(
     REFCLSID rclsid,
     LPUNKNOWN pUnk,
     DWORD dwClsContext,
     DWORD flags,
     LPDWORD lpdwRegister
    );

HRESULT __stdcall
CoRevokeClassObject(
     DWORD dwRegister
    );

 HRESULT __stdcall
CoResumeClassObjects(
    void
    );

 HRESULT __stdcall
CoSuspendClassObjects(
    void
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ULONG __stdcall
CoAddRefServerProcess(
    void
    );


ULONG  __stdcall
CoReleaseServerProcess(
    void
    );


 HRESULT __stdcall
CoGetPSClsid(
     REFIID riid,
     CLSID* pClsid
    );

 HRESULT __stdcall
CoRegisterPSClsid(
     REFIID riid,
     REFCLSID rclsid
    );


// Registering surrogate processes
 HRESULT __stdcall
CoRegisterSurrogate(
     LPSURROGATE pSurrogate
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

/* marshaling interface pointers */

 HRESULT __stdcall
CoGetMarshalSizeMax(
     ULONG* pulSize,
     REFIID riid,
     LPUNKNOWN pUnk,
     DWORD dwDestContext,
     LPVOID pvDestContext,
     DWORD mshlflags
    );

 HRESULT __stdcall
CoMarshalInterface(
     LPSTREAM pStm,
     REFIID riid,
     LPUNKNOWN pUnk,
     DWORD dwDestContext,
     LPVOID pvDestContext,
     DWORD mshlflags
    );

 HRESULT __stdcall
CoUnmarshalInterface(
     LPSTREAM pStm,
     REFIID riid,
     LPVOID   * ppv
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

HRESULT __stdcall
CoMarshalHresult(
     LPSTREAM pstm,
     HRESULT hresult
    );

HRESULT __stdcall
CoUnmarshalHresult(
     LPSTREAM pstm,
     HRESULT   * phresult
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

 HRESULT __stdcall
CoReleaseMarshalData(
     LPSTREAM pStm
    );

 HRESULT __stdcall
CoDisconnectObject(
     LPUNKNOWN pUnk,
     DWORD dwReserved
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

 HRESULT __stdcall
CoLockObjectExternal(
     LPUNKNOWN pUnk,
     BOOL fLock,
     BOOL fLastUnlockReleases
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

 HRESULT __stdcall
CoGetStandardMarshal(
     REFIID riid,
     LPUNKNOWN pUnk,
     DWORD dwDestContext,
     LPVOID pvDestContext,
     DWORD mshlflags,
     LPMARSHAL   * ppMarshal
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

 HRESULT __stdcall
CoGetStdMarshalEx(
     LPUNKNOWN pUnkOuter,
     DWORD smexflags,
     LPUNKNOWN   * ppUnkInner
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

/* flags for CoGetStdMarshalEx */
typedef enum tagSTDMSHLFLAGS
{
    SMEXF_SERVER     = 0x01,       // server side aggregated std marshaler
    SMEXF_HANDLER    = 0x02        // client side (handler) agg std marshaler
} STDMSHLFLAGS;

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

BOOL __stdcall
CoIsHandlerConnected(
     LPUNKNOWN pUnk
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

// Apartment model inter-thread interface passing helpers
 HRESULT __stdcall
CoMarshalInterThreadInterfaceInStream(
     REFIID riid,
     LPUNKNOWN pUnk,
     LPSTREAM* ppStm
    );


 HRESULT __stdcall
CoGetInterfaceAndReleaseStream(
     LPSTREAM pStm,
     REFIID iid,
     LPVOID   * ppv
    );


 HRESULT __stdcall
CoCreateFreeThreadedMarshaler(
     LPUNKNOWN punkOuter,
     LPUNKNOWN* ppunkMarshal
    );


void __stdcall
CoFreeUnusedLibraries(
    void
    );

if (_WIN32_WINNT >= 0x0501) then
void __stdcall
CoFreeUnusedLibrariesEx(
     DWORD dwUnloadDelay,
     DWORD dwReserved
    );

#endif

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then


if (_WIN32_WINNT >= 0x0600)


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

 HRESULT __stdcall
CoDisconnectContext(
    DWORD dwTimeout
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


#endif

// DCOM
if (_WIN32_WINNT >= 0x0400) or _WIN32_DCOM


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

/* Call Security. */

 HRESULT __stdcall
CoInitializeSecurity(
     PSECURITY_DESCRIPTOR pSecDesc,
     LONG cAuthSvc,
    _In_reads_opt_(cAuthSvc) SOLE_AUTHENTICATION_SERVICE* asAuthSvc,
     void* pReserved1,
     DWORD dwAuthnLevel,
     DWORD dwImpLevel,
     void* pAuthList,
     DWORD dwCapabilities,
     void* pReserved3
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

 HRESULT __stdcall
CoGetCallContext(
     REFIID riid,
     void** ppInterface
    );


 HRESULT __stdcall
CoQueryProxyBlanket(
     IUnknown* pProxy,
    _Out_opt_ DWORD* pwAuthnSvc,
    _Out_opt_ DWORD* pAuthzSvc,
    _Outptr_opt_ LPOLESTR* pServerPrincName,
    _Out_opt_ DWORD* pAuthnLevel,
    _Out_opt_ DWORD* pImpLevel,
    _Out_opt_ RPC_AUTH_IDENTITY_HANDLE* pAuthInfo,
    _Out_opt_ DWORD* pCapabilites
    );


 HRESULT __stdcall
CoSetProxyBlanket(
     IUnknown* pProxy,
     DWORD dwAuthnSvc,
     DWORD dwAuthzSvc,
     OLECHAR* pServerPrincName,
     DWORD dwAuthnLevel,
     DWORD dwImpLevel,
     RPC_AUTH_IDENTITY_HANDLE pAuthInfo,
     DWORD dwCapabilities
    );


 HRESULT __stdcall
CoCopyProxy(
     IUnknown* pProxy,
     IUnknown** ppCopy
    );


 HRESULT __stdcall
CoQueryClientBlanket(
    _Out_opt_ DWORD* pAuthnSvc,
    _Out_opt_ DWORD* pAuthzSvc,
    _Outptr_opt_ LPOLESTR* pServerPrincName,
    _Out_opt_ DWORD* pAuthnLevel,
    _Out_opt_ DWORD* pImpLevel,
    _Outptr_opt_result_buffer_(_Inexpressible_("depends on pAuthnSvc")) RPC_AUTHZ_HANDLE* pPrivs,
    _Inout_opt_ DWORD* pCapabilities
    );


 HRESULT __stdcall
CoImpersonateClient(
    void
    );


 HRESULT __stdcall
CoRevertToSelf(
    void
    );


 HRESULT __stdcall
CoQueryAuthenticationServices(
     DWORD* pcAuthSvc,
    _Outptr_result_buffer_(*pcAuthSvc) SOLE_AUTHENTICATION_SERVICE** asAuthSvc
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

 HRESULT __stdcall
CoSwitchCallContext(
     IUnknown* pNewObject,
     IUnknown** ppOldObject
    );


#define COM_RIGHTS_EXECUTE 1
#define COM_RIGHTS_EXECUTE_LOCAL 2
#define COM_RIGHTS_EXECUTE_REMOTE 4
#define COM_RIGHTS_ACTIVATE_LOCAL 8
#define COM_RIGHTS_ACTIVATE_REMOTE 16

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then


end  -- DCOM


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

/* helper for creating instances */

 HRESULT __stdcall
CoCreateInstance(
     REFCLSID rclsid,
     LPUNKNOWN pUnkOuter,
     DWORD dwClsContext,
     REFIID riid,
     _At_(*ppv, _Post_readable_size_(_Inexpressible_(varies))) LPVOID   * ppv
    );


// DCOM
if (_WIN32_WINNT >= 0x0400) or _WIN32_DCOM

 HRESULT __stdcall
CoCreateInstanceEx(
     REFCLSID Clsid,
     IUnknown* punkOuter,
     DWORD dwClsCtx,
     COSERVERINFO* pServerInfo,
     DWORD dwCount,
    _Inout_updates_(dwCount) MULTI_QI* pResults
    );


end  -- DCOM

HRESULT __stdcall
CoRegisterActivationFilter(
     IActivationFilter* pActivationFilter
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


if (_WIN32_WINNT >= 0x0602)


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

 HRESULT __stdcall
CoCreateInstanceFromApp(
     REFCLSID Clsid,
     IUnknown* punkOuter,
     DWORD dwClsCtx,
     PVOID reserved,
     DWORD dwCount,
    _Inout_updates_(dwCount) MULTI_QI* pResults
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then


#endif

#pragma region Not Desktop or OneCore Family
if WINAPI_PARTITION_APP && !(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

__inline  HRESULT CoCreateInstance(
         REFCLSID rclsid,
     LPUNKNOWN pUnkOuter,
         DWORD dwClsContext,
         REFIID riid,
     _At_(*ppv, _Post_readable_size_(_Inexpressible_(varies))) LPVOID * ppv)
{
    MULTI_QI    OneQI;
    HRESULT     hr;

    OneQI.pItf = NULL;

#ifdef __cplusplus
    OneQI.pIID = &riid;
#else
    OneQI.pIID = riid;
#endif

    hr = CoCreateInstanceFromApp( rclsid, pUnkOuter, dwClsContext, NULL, 1, &OneQI );

#ifdef _PREFAST_
    if (SUCCEEDED(hr) && SUCCEEDED(OneQI.hr))
        _Analysis_assume_(OneQI.pItf != NULL);
    else
        _Analysis_assume_(OneQI.pItf == NULL);
#endif

    *ppv = OneQI.pItf;
    return FAILED(hr) ? hr : OneQI.hr;
}

__inline  HRESULT CoCreateInstanceEx(
     REFCLSID                      Clsid,
     IUnknown     *            punkOuter,
     DWORD                         dwClsCtx,
     COSERVERINFO *            pServerInfo,
     DWORD                         dwCount,
    _Inout_updates_(dwCount) MULTI_QI *pResults )
{
    return CoCreateInstanceFromApp(Clsid, punkOuter, dwClsCtx, pServerInfo, dwCount, pResults);
}

end  -- WINAPI_PARTITION_APP && !(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


/* Call related APIs */
// DCOM
if (_WIN32_WINNT >= 0x0500) or _WIN32_DCOM


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

 HRESULT __stdcall
CoGetCancelObject(
     DWORD dwThreadId,
     REFIID iid,
     void** ppUnk
    );


 HRESULT __stdcall
CoSetCancelObject(
     IUnknown* pUnk
    );


 HRESULT __stdcall
CoCancelCall(
     DWORD dwThreadId,
     ULONG ulTimeout
    );


 HRESULT __stdcall
CoTestCancel(
    void
    );


 HRESULT __stdcall
CoEnableCallCancellation(
     LPVOID pReserved
    );


 HRESULT __stdcall
CoDisableCallCancellation(
     LPVOID pReserved
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


#endif


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

/* other helpers */

 HRESULT __stdcall
StringFromCLSID(
     REFCLSID rclsid,
     LPOLESTR   * lplpsz
    );

 HRESULT __stdcall
CLSIDFromString(
     LPCOLESTR lpsz,
     LPCLSID pclsid
    );

 HRESULT __stdcall
StringFromIID(
     REFIID rclsid,
     LPOLESTR   * lplpsz
    );

 HRESULT __stdcall
IIDFromString(
     LPCOLESTR lpsz,
     LPIID lpiid
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

 HRESULT __stdcall
ProgIDFromCLSID(
     REFCLSID clsid,
     LPOLESTR   * lplpszProgID
    );

 HRESULT __stdcall
CLSIDFromProgID(
     LPCOLESTR lpszProgID,
     LPCLSID lpclsid
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

int __stdcall
StringFromGUID2(
     REFGUID rguid,
    _Out_writes_to_(cchMax,return) LPOLESTR lpsz,
     int cchMax
    );


 HRESULT __stdcall
CoCreateGuid(
     GUID   * pguid
    );


/* Prop variant support */

typedef struct tagPROPVARIANT PROPVARIANT;


HRESULT __stdcall
PropVariantCopy(
     PROPVARIANT* pvarDest,
     const PROPVARIANT* pvarSrc
    );


HRESULT __stdcall
PropVariantClear(
    _Inout_ PROPVARIANT* pvar
    );


HRESULT __stdcall
FreePropVariantArray(
     ULONG cVariants,
    _Inout_updates_(cVariants) PROPVARIANT* rgvars
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then


// DCOM
if (_WIN32_WINNT >= 0x0400) or _WIN32_DCOM


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


end  -- DCOM

// DCOM
if (_WIN32_WINNT >= 0x0400) or _WIN32_DCOM
/* Synchronization API */


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

 HRESULT __stdcall
CoWaitForMultipleHandles(
     DWORD dwFlags,
     DWORD dwTimeout,
     ULONG cHandles,
    _In_reads_(cHandles) LPHANDLE pHandles,
     LPDWORD lpdwindex
    );


/* Flags for Synchronization API and Classes */

typedef enum tagCOWAIT_FLAGS
{
  COWAIT_DEFAULT = 0,
  COWAIT_WAITALL = 1,
  COWAIT_ALERTABLE = 2,
  COWAIT_INPUTAVAILABLE = 4,
  COWAIT_DISPATCH_CALLS = 8,
  COWAIT_DISPATCH_WINDOW_MESSAGES = 0x10,
}COWAIT_FLAGS;

if (NTDDI_VERSION >= NTDDI_WIN8)

typedef enum CWMO_FLAGS
{
  CWMO_DEFAULT = 0,
  CWMO_DISPATCH_CALLS = 1,
  CWMO_DISPATCH_WINDOW_MESSAGES = 2,
} CWMO_FLAGS;

HRESULT __stdcall
CoWaitForMultipleObjects(
     DWORD dwFlags,
     DWORD dwTimeout,
     ULONG cHandles,
    _In_reads_(cHandles) const HANDLE* pHandles,
     LPDWORD lpdwindex
    );


end  -- (NTDDI_VERSION >= NTDDI_WIN8)

#define CWMO_MAX_HANDLES 56

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


end  -- DCOM


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

 HRESULT __stdcall
CoGetTreatAsClass(
     REFCLSID clsidOld,
     LPCLSID pClsidNew
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


/* for flushing OLESCM remote binding handles */

if (_WIN32_WINNT >= 0x0501)


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

 HRESULT __stdcall
CoInvalidateRemoteMachineBindings(
     LPOLESTR pszMachineName
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


#endif
--]=]

if (NTDDI_VERSION >= NTDDI_WINBLUE) then


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
enum AgileReferenceOptions
{
    AGILEREFERENCE_DEFAULT        = 0,
    AGILEREFERENCE_DELAYEDMARSHAL = 1,
};

 HRESULT __stdcall
RoGetAgileReference(
     enum AgileReferenceOptions options,
     REFIID riid,
     IUnknown* pUnk,
     IAgileReference** ppAgileReference
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then


end


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
/* the server dlls must define their DllGetClassObject and DllCanUnloadNow
 * to match these; the typedefs are located here to ensure all are changed at
 * the same time.
 */

typedef HRESULT (__stdcall * LPFNGETCLASSOBJECT) (REFCLSID, REFIID, LPVOID *);
typedef HRESULT (__stdcall * LPFNCANUNLOADNOW)(void);


HRESULT __stdcall  DllGetClassObject( REFCLSID rclsid,  REFIID riid,  LPVOID * ppv);


HRESULT __stdcall  DllCanUnloadNow(void);
]]

ffi.cdef[[
/****** Default Memory Allocation ******************************************/
LPVOID __stdcall
CoTaskMemAlloc(
     SIZE_T cb
    );

LPVOID __stdcall
CoTaskMemRealloc(
       LPVOID pv,
     SIZE_T cb
    );

void __stdcall
CoTaskMemFree(
     LPVOID pv
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM)



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
HRESULT __stdcall
CoFileTimeNow(
     FILETIME   * lpFileTime
    );

 HRESULT __stdcall
CLSIDFromProgIDEx(
     LPCOLESTR lpszProgID,
     LPCLSID lpclsid
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


ffi.cdef[[
    #pragma push (pop)
]]


