local ffim = require("ffi")



if not __REQUIRED_RPCNDR_H_VERSION__ then
__REQUIRED_RPCNDR_H_VERSION__ = 500
end


if not __REQUIRED_RPCSAL_H_VERSION__ then
__REQUIRED_RPCSAL_H_VERSION__ = 100
end

--#include "rpc.h"
require("win32.rpcndr")

--#ifndef __RPCNDR_H_VERSION__
--#error this stub requires an updated version of <rpcndr.h>
--#endif /* __RPCNDR_H_VERSION__ */

if not COM_NO_WINDOWS_H then
require("win32.windows")
--require("win32.ole2")
end --/*COM_NO_WINDOWS_H*/

if not __unknwnbase_h__ then
__unknwnbase_h__ = true


--[=[
/* Forward Declarations */ 

#ifndef __IUnknown_FWD_DEFINED__
#define __IUnknown_FWD_DEFINED__
typedef struct IUnknown IUnknown;

#endif 	/* __IUnknown_FWD_DEFINED__ */


#ifndef __AsyncIUnknown_FWD_DEFINED__
#define __AsyncIUnknown_FWD_DEFINED__
typedef interface AsyncIUnknown AsyncIUnknown;

#endif 	/* __AsyncIUnknown_FWD_DEFINED__ */


#ifndef __IClassFactory_FWD_DEFINED__
#define __IClassFactory_FWD_DEFINED__
typedef interface IClassFactory IClassFactory;

#endif 	/* __IClassFactory_FWD_DEFINED__ */


/* header files for imported files */
#include "wtypesbase.h"

#ifdef __cplusplus
extern "C"{
#endif 


/* interface __MIDL_itf_unknwnbase_0000_0000 */
 

#include <winapifamily.h>
//+-------------------------------------------------------------------------
//
//  Microsoft Windows
//  Copyright (c) Microsoft Corporation. All rights reserved.
//
//--------------------------------------------------------------------------
#if ( _MSC_VER >= 1020 )
#pragma once
#endif
#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


extern RPC_IF_HANDLE __MIDL_itf_unknwnbase_0000_0000_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_unknwnbase_0000_0000_v0_0_s_ifspec;

#ifndef __IUnknown_INTERFACE_DEFINED__
#define __IUnknown_INTERFACE_DEFINED__

/* interface IUnknown */
/* [uuid][object][local] */ 

typedef /*  */ IUnknown *LPUNKNOWN;

//////////////////////////////////////////////////////////////////
// IID_IUnknown and all other system IIDs are provided in UUID.LIB
// Link that library in with your proxies, clients and servers
//////////////////////////////////////////////////////////////////

#if (_MSC_VER >= 1100) && defined(__cplusplus) && !defined(CINTERFACE)
   EXTERN_C const IID IID_IUnknown;
   extern "C++"
   {
       MIDL_INTERFACE("00000000-0000-0000-C000-000000000046")
       IUnknown
       {
       public:
           BEGIN_INTERFACE
           virtual HRESULT STDMETHODCALLTYPE QueryInterface( 
                REFIID riid,
                 void __RPC_FAR *__RPC_FAR *ppvObject) = 0;

           virtual ULONG STDMETHODCALLTYPE AddRef( void) = 0;

           virtual ULONG STDMETHODCALLTYPE Release( void) = 0;

           template<class Q>
           HRESULT
#ifdef _M_CEE_PURE
           __clrcall
#else
           STDMETHODCALLTYPE
#endif
           QueryInterface( Q** pp)
           {
               return QueryInterface(__uuidof(Q), (void **)pp);
           }

           END_INTERFACE
       };
   } // extern C++
   HRESULT STDMETHODCALLTYPE IUnknown_QueryInterface_Proxy(
       IUnknown __RPC_FAR * This,
        REFIID riid,
        __RPC__deref_out void __RPC_FAR *__RPC_FAR *ppvObject);
   
   void __RPC_STUB IUnknown_QueryInterface_Stub(
       IRpcStubBuffer *This,
       IRpcChannelBuffer *_pRpcChannelBuffer,
       PRPC_MESSAGE _pRpcMessage,
       DWORD *_pdwStubPhase);
   
   ULONG STDMETHODCALLTYPE IUnknown_AddRef_Proxy(
       IUnknown __RPC_FAR * This);
   
   void __RPC_STUB IUnknown_AddRef_Stub(
       IRpcStubBuffer *This,
       IRpcChannelBuffer *_pRpcChannelBuffer,
       PRPC_MESSAGE _pRpcMessage,
       DWORD *_pdwStubPhase);
   
   ULONG STDMETHODCALLTYPE IUnknown_Release_Proxy(
       IUnknown __RPC_FAR * This);
   
   void __RPC_STUB IUnknown_Release_Stub(
       IRpcStubBuffer *This,
       IRpcChannelBuffer *_pRpcChannelBuffer,
       PRPC_MESSAGE _pRpcMessage,
       DWORD *_pdwStubPhase);
#else

EXTERN_C const IID IID_IUnknown;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000000-0000-0000-C000-000000000046")
   IUnknown
   {
   public:
       BEGIN_INTERFACE
       virtual HRESULT STDMETHODCALLTYPE QueryInterface( 
            REFIID riid,
            
             void **ppvObject) = 0;
       
       virtual ULONG STDMETHODCALLTYPE AddRef( void) = 0;
       
       virtual ULONG STDMETHODCALLTYPE Release( void) = 0;
       
       END_INTERFACE
   };
   
   
#else 	/* C style interface */

   typedef struct IUnknownVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
           IUnknown * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( STDMETHODCALLTYPE *AddRef )( 
           IUnknown * This);
       
       ULONG ( STDMETHODCALLTYPE *Release )( 
           IUnknown * This);
       
       END_INTERFACE
   } IUnknownVtbl;

   interface IUnknown
   {
       CONST_VTBL struct IUnknownVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IUnknown_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IUnknown_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IUnknown_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */



HRESULT STDMETHODCALLTYPE IUnknown_QueryInterface_Proxy( 
   IUnknown * This,
    REFIID riid,
    
     void **ppvObject);


void __RPC_STUB IUnknown_QueryInterface_Stub(
   IRpcStubBuffer *This,
   IRpcChannelBuffer *_pRpcChannelBuffer,
   PRPC_MESSAGE _pRpcMessage,
   DWORD *_pdwStubPhase);


ULONG STDMETHODCALLTYPE IUnknown_AddRef_Proxy( 
   IUnknown * This);


void __RPC_STUB IUnknown_AddRef_Stub(
   IRpcStubBuffer *This,
   IRpcChannelBuffer *_pRpcChannelBuffer,
   PRPC_MESSAGE _pRpcMessage,
   DWORD *_pdwStubPhase);


ULONG STDMETHODCALLTYPE IUnknown_Release_Proxy( 
   IUnknown * This);


void __RPC_STUB IUnknown_Release_Stub(
   IRpcStubBuffer *This,
   IRpcChannelBuffer *_pRpcChannelBuffer,
   PRPC_MESSAGE _pRpcMessage,
   DWORD *_pdwStubPhase);



#endif 	/* __IUnknown_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_unknwnbase_0000_0001 */
 

#endif
#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


extern RPC_IF_HANDLE __MIDL_itf_unknwnbase_0000_0001_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_unknwnbase_0000_0001_v0_0_s_ifspec;

#ifndef __AsyncIUnknown_INTERFACE_DEFINED__
#define __AsyncIUnknown_INTERFACE_DEFINED__

/* interface AsyncIUnknown */
/* [uuid][object][local] */ 


EXTERN_C const IID IID_AsyncIUnknown;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("000e0000-0000-0000-C000-000000000046")
   AsyncIUnknown : public IUnknown
   {
   public:
       virtual HRESULT STDMETHODCALLTYPE Begin_QueryInterface( 
            REFIID riid) = 0;
       
       virtual HRESULT STDMETHODCALLTYPE Finish_QueryInterface( 
           /* [out] */ 
           __RPC__deref_out  void **ppvObject) = 0;
       
       virtual HRESULT STDMETHODCALLTYPE Begin_AddRef( void) = 0;
       
       virtual ULONG STDMETHODCALLTYPE Finish_AddRef( void) = 0;
       
       virtual HRESULT STDMETHODCALLTYPE Begin_Release( void) = 0;
       
       virtual ULONG STDMETHODCALLTYPE Finish_Release( void) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct AsyncIUnknownVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
           AsyncIUnknown * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( STDMETHODCALLTYPE *AddRef )( 
           AsyncIUnknown * This);
       
       ULONG ( STDMETHODCALLTYPE *Release )( 
           AsyncIUnknown * This);
       
       HRESULT ( STDMETHODCALLTYPE *Begin_QueryInterface )( 
           AsyncIUnknown * This,
            REFIID riid);
       
       HRESULT ( STDMETHODCALLTYPE *Finish_QueryInterface )( 
           AsyncIUnknown * This,
           /* [out] */ 
           __RPC__deref_out  void **ppvObject);
       
       HRESULT ( STDMETHODCALLTYPE *Begin_AddRef )( 
           AsyncIUnknown * This);
       
       ULONG ( STDMETHODCALLTYPE *Finish_AddRef )( 
           AsyncIUnknown * This);
       
       HRESULT ( STDMETHODCALLTYPE *Begin_Release )( 
           AsyncIUnknown * This);
       
       ULONG ( STDMETHODCALLTYPE *Finish_Release )( 
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


/* interface __MIDL_itf_unknwnbase_0000_0002 */
 

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


extern RPC_IF_HANDLE __MIDL_itf_unknwnbase_0000_0002_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_unknwnbase_0000_0002_v0_0_s_ifspec;

#ifndef __IClassFactory_INTERFACE_DEFINED__
#define __IClassFactory_INTERFACE_DEFINED__

/* interface IClassFactory */
/* [uuid][object] */ 

typedef /*  */  __RPC_unique_pointer IClassFactory *LPCLASSFACTORY;


EXTERN_C const IID IID_IClassFactory;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000001-0000-0000-C000-000000000046")
   IClassFactory : public IUnknown
   {
   public:
       virtual  HRESULT STDMETHODCALLTYPE CreateInstance( 
            
             IUnknown *pUnkOuter,
            
             REFIID riid,
            
             void **ppvObject) = 0;
       
       virtual  HRESULT STDMETHODCALLTYPE LockServer( 
            BOOL fLock) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IClassFactoryVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            IClassFactory * This,
             REFIID riid,
            
             void **ppvObject);
       
       ULONG ( STDMETHODCALLTYPE *AddRef )( 
            IClassFactory * This);
       
       ULONG ( STDMETHODCALLTYPE *Release )( 
            IClassFactory * This);
       
        HRESULT ( STDMETHODCALLTYPE *CreateInstance )( 
           IClassFactory * This,
            
             IUnknown *pUnkOuter,
            
             REFIID riid,
            
             void **ppvObject);
       
        HRESULT ( STDMETHODCALLTYPE *LockServer )( 
           IClassFactory * This,
            BOOL fLock);
       
       END_INTERFACE
   } IClassFactoryVtbl;

   interface IClassFactory
   {
       CONST_VTBL struct IClassFactoryVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


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

#endif /* COBJMACROS */


#endif 	/* C style interface */



 HRESULT STDMETHODCALLTYPE IClassFactory_RemoteCreateInstance_Proxy( 
    IClassFactory * This,
     REFIID riid,
     IUnknown **ppvObject);


void __RPC_STUB IClassFactory_RemoteCreateInstance_Stub(
   IRpcStubBuffer *This,
   IRpcChannelBuffer *_pRpcChannelBuffer,
   PRPC_MESSAGE _pRpcMessage,
   DWORD *_pdwStubPhase);


 HRESULT __stdcall IClassFactory_RemoteLockServer_Proxy( 
    IClassFactory * This,
    BOOL fLock);


void __RPC_STUB IClassFactory_RemoteLockServer_Stub(
   IRpcStubBuffer *This,
   IRpcChannelBuffer *_pRpcChannelBuffer,
   PRPC_MESSAGE _pRpcMessage,
   DWORD *_pdwStubPhase);



#endif 	/* __IClassFactory_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_unknwnbase_0000_0003 */
 

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion


extern RPC_IF_HANDLE __MIDL_itf_unknwnbase_0000_0003_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_unknwnbase_0000_0003_v0_0_s_ifspec;

/* Additional Prototypes for ALL interfaces */

 HRESULT STDMETHODCALLTYPE IClassFactory_CreateInstance_Proxy( 
   IClassFactory * This,
    
     IUnknown *pUnkOuter,
    
     REFIID riid,
    
     void **ppvObject);


 HRESULT STDMETHODCALLTYPE IClassFactory_CreateInstance_Stub( 
    IClassFactory * This,
     REFIID riid,
     IUnknown **ppvObject);

 HRESULT STDMETHODCALLTYPE IClassFactory_LockServer_Proxy( 
   IClassFactory * This,
    BOOL fLock);


 HRESULT __stdcall IClassFactory_LockServer_Stub( 
    IClassFactory * This,
    BOOL fLock);
--]=]




end


