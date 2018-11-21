
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
--]]

--[[
if not COM_NO_WINDOWS_H
require("win32.windows")
require("win32.ole2.h")
endif -- COM_NO_WINDOWS_H
--]]




-- Forward Declarations
if not __IUnknown_FWD_DEFINED__ then
__IUnknown_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IUnknown IUnknown;
]]
end


if not __AsyncIUnknown_FWD_DEFINED__ then
__AsyncIUnknown_FWD_DEFINED__ = true;
ffi.cdef[[
typedef struct AsyncIUnknown AsyncIUnknown;
]]
end


if not __IClassFactory_FWD_DEFINED__ then
__IClassFactory_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IClassFactory IClassFactory;
]]
end



require("win32.wtypes")


--extern RPC_IF_HANDLE __MIDL_itf_unknwn_0000_0000_v0_0_c_ifspec;
--extern RPC_IF_HANDLE __MIDL_itf_unknwn_0000_0000_v0_0_s_ifspec;

if not __IUnknown_INTERFACE_DEFINED__ then
__IUnknown_INTERFACE_DEFINED__ = true

ffi.cdef[[
typedef  IUnknown *LPUNKNOWN;
]]

--EXTERN_C const IID IID_IUnknown;
--MIDL_INTERFACE("00000000-0000-0000-C000-000000000046")

ffi.cdef[[
typedef struct IUnknownVtbl
{
       HRESULT ( __stdcall *QueryInterface )(IUnknown * This, REFIID riid, void **ppvObject);
       ULONG ( __stdcall *AddRef )(IUnknown * This);
       ULONG ( __stdcall *Release )(IUnknown * This);
} IUnknownVtbl;

struct IUnknown
{
    const struct IUnknownVtbl *lpVtbl;
};
]]
   
--[[
#ifdef COBJMACROS


#define IUnknown_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IUnknown_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IUnknown_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 

#endif /* COBJMACROS */
--]]



--[[

HRESULT __stdcall IUnknown_QueryInterface_Proxy( 
   IUnknown * This,
   /* [in] */ REFIID riid,
   /* [annotation][iid_is][out] */ 
     void **ppvObject);


void __RPC_STUB IUnknown_QueryInterface_Stub(
   IRpcStubBuffer *This,
   IRpcChannelBuffer *_pRpcChannelBuffer,
   PRPC_MESSAGE _pRpcMessage,
   DWORD *_pdwStubPhase);


ULONG __stdcall IUnknown_AddRef_Proxy( 
   IUnknown * This);


void __RPC_STUB IUnknown_AddRef_Stub(
   IRpcStubBuffer *This,
   IRpcChannelBuffer *_pRpcChannelBuffer,
   PRPC_MESSAGE _pRpcMessage,
   DWORD *_pdwStubPhase);


ULONG __stdcall IUnknown_Release_Proxy( 
   IUnknown * This);


void __RPC_STUB IUnknown_Release_Stub(
   IRpcStubBuffer *This,
   IRpcChannelBuffer *_pRpcChannelBuffer,
   PRPC_MESSAGE _pRpcMessage,
   DWORD *_pdwStubPhase);
]]


end 	--/* __IUnknown_INTERFACE_DEFINED__ */



--[[
#endif
#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


extern RPC_IF_HANDLE __MIDL_itf_unknwn_0000_0001_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_unknwn_0000_0001_v0_0_s_ifspec;

#ifndef __AsyncIUnknown_INTERFACE_DEFINED__
#define __AsyncIUnknown_INTERFACE_DEFINED__

/* interface AsyncIUnknown */
/* [unique][uuid][object][local] */ 


EXTERN_C const IID IID_AsyncIUnknown;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("000e0000-0000-0000-C000-000000000046")
   AsyncIUnknown : public IUnknown
   {
   public:
       virtual HRESULT __stdcall Begin_QueryInterface( 
           /* [in] */ REFIID riid) = 0;
       
       virtual HRESULT __stdcall Finish_QueryInterface( 
           /* [annotation][out] */ 
           __RPC__deref_out  void **ppvObject) = 0;
       
       virtual HRESULT __stdcall Begin_AddRef( void) = 0;
       
       virtual ULONG __stdcall Finish_AddRef( void) = 0;
       
       virtual HRESULT __stdcall Begin_Release( void) = 0;
       
       virtual ULONG __stdcall Finish_Release( void) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct AsyncIUnknownVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           AsyncIUnknown * This,
           /* [in] */ REFIID riid,
           /* [annotation][iid_is][out] */ 
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           AsyncIUnknown * This);
       
       ULONG ( __stdcall *Release )( 
           AsyncIUnknown * This);
       
       HRESULT ( __stdcall *Begin_QueryInterface )( 
           AsyncIUnknown * This,
           /* [in] */ REFIID riid);
       
       HRESULT ( __stdcall *Finish_QueryInterface )( 
           AsyncIUnknown * This,
           /* [annotation][out] */ 
           __RPC__deref_out  void **ppvObject);
       
       HRESULT ( __stdcall *Begin_AddRef )( 
           AsyncIUnknown * This);
       
       ULONG ( __stdcall *Finish_AddRef )( 
           AsyncIUnknown * This);
       
       HRESULT ( __stdcall *Begin_Release )( 
           AsyncIUnknown * This);
       
       ULONG ( __stdcall *Finish_Release )( 
           AsyncIUnknown * This);
       
       END_INTERFACE
   } AsyncIUnknownVtbl;

   interface AsyncIUnknown
   {
       CONST_VTBL struct AsyncIUnknownVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define AsyncIUnknown_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define AsyncIUnknown_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define AsyncIUnknown_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define AsyncIUnknown_Begin_QueryInterface(This,riid)	\
   ( (This)->lpVtbl -> Begin_QueryInterface(This,riid) ) 

#define AsyncIUnknown_Finish_QueryInterface(This,ppvObject)	\
   ( (This)->lpVtbl -> Finish_QueryInterface(This,ppvObject) ) 

#define AsyncIUnknown_Begin_AddRef(This)	\
   ( (This)->lpVtbl -> Begin_AddRef(This) ) 

#define AsyncIUnknown_Finish_AddRef(This)	\
   ( (This)->lpVtbl -> Finish_AddRef(This) ) 

#define AsyncIUnknown_Begin_Release(This)	\
   ( (This)->lpVtbl -> Begin_Release(This) ) 

#define AsyncIUnknown_Finish_Release(This)	\
   ( (This)->lpVtbl -> Finish_Release(This) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __AsyncIUnknown_INTERFACE_DEFINED__ */

--]]



if not __IClassFactory_INTERFACE_DEFINED__ then
__IClassFactory_INTERFACE_DEFINED__ = true;


ffi.cdef[[
typedef  IClassFactory *LPCLASSFACTORY;
]]

--EXTERN_C const IID IID_IClassFactory;

ffi.cdef[[
   typedef struct IClassFactoryVtbl
   {       
       HRESULT ( __stdcall *QueryInterface )( 
            IClassFactory * This,
             REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
            IClassFactory * This);
       
       ULONG ( __stdcall *Release )( 
            IClassFactory * This);
       
        HRESULT ( __stdcall *CreateInstance )( 
           IClassFactory * This,
           
             IUnknown *pUnkOuter,
           
             REFIID riid,
           
             void **ppvObject);
       
       HRESULT ( __stdcall *LockServer )( 
           IClassFactory * This,
            BOOL fLock);
       
       
   } IClassFactoryVtbl;

   struct IClassFactory
   {
       const struct IClassFactoryVtbl *lpVtbl;
   };
]]
   

--[[
#define IClassFactory_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IClassFactory_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IClassFactory_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IClassFactory_CreateInstance(This,pUnkOuter,riid,ppvObject)	\
   ( (This)->lpVtbl -> CreateInstance(This,pUnkOuter,riid,ppvObject) ) 

#define IClassFactory_LockServer(This,fLock)	\
   ( (This)->lpVtbl -> LockServer(This,fLock) ) 
--]]



--[[
/* [call_as] */ HRESULT __stdcall IClassFactory_RemoteCreateInstance_Proxy( 
    IClassFactory * This,
   /* [in] */  REFIID riid,
   /* [iid_is][out] */ __RPC__deref_out_opt IUnknown **ppvObject);


void __RPC_STUB IClassFactory_RemoteCreateInstance_Stub(
   IRpcStubBuffer *This,
   IRpcChannelBuffer *_pRpcChannelBuffer,
   PRPC_MESSAGE _pRpcMessage,
   DWORD *_pdwStubPhase);


/* [call_as] */ HRESULT __stdcall IClassFactory_RemoteLockServer_Proxy( 
    IClassFactory * This,
   /* [in] */ BOOL fLock);


void __RPC_STUB IClassFactory_RemoteLockServer_Stub(
   IRpcStubBuffer *This,
   IRpcChannelBuffer *_pRpcChannelBuffer,
   PRPC_MESSAGE _pRpcMessage,
   DWORD *_pdwStubPhase);
--]]


end 	-- __IClassFactory_INTERFACE_DEFINED__ 


--[[


extern RPC_IF_HANDLE __MIDL_itf_unknwn_0000_0003_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_unknwn_0000_0003_v0_0_s_ifspec;

/* Additional Prototypes for ALL interfaces */

 HRESULT __stdcall IClassFactory_CreateInstance_Proxy( 
   IClassFactory * This,
    
     IUnknown *pUnkOuter,
    
     REFIID riid,
 
     void **ppvObject);


/* [call_as] */ HRESULT __stdcall IClassFactory_CreateInstance_Stub( 
    IClassFactory * This,
   /* [in] */  REFIID riid,
   /* [iid_is][out] */ __RPC__deref_out_opt IUnknown **ppvObject);

/* [local] */ HRESULT __stdcall IClassFactory_LockServer_Proxy( 
   IClassFactory * This,
   /* [in] */ BOOL fLock);


/* [call_as] */ HRESULT __stdcall IClassFactory_LockServer_Stub( 
    IClassFactory * This,
   /* [in] */ BOOL fLock);



/* end of Additional Prototypes */



#endif

--]]
