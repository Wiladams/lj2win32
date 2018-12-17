

local ffi = require("ffi")




if not __REQUIRED_RPCNDR_H_VERSION__ then
__REQUIRED_RPCNDR_H_VERSION__ = 500
end


if not __REQUIRED_RPCSAL_H_VERSION__ then
__REQUIRED_RPCSAL_H_VERSION__ = 100
end

--#include "rpc.h"
require("win32.rpcndr")

if not __RPCNDR_H_VERSION__ then
error ("this stub requires an updated version of <rpcndr.h>")
end --/* __RPCNDR_H_VERSION__ */

if not COM_NO_WINDOWS_H then
require("win32.windows")
--require("win32.ole2")
end --/*COM_NO_WINDOWS_H*/

if not __objidlbase_h__ then
__objidlbase_h__ = true





if not __IMarshal_FWD_DEFINED__ then
__IMarshal_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IMarshal IMarshal;
]]
end 	-- __IMarshal_FWD_DEFINED__ 


if not __INoMarshal_FWD_DEFINED__ then
__INoMarshal_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct INoMarshal INoMarshal;
]]
end 	-- __INoMarshal_FWD_DEFINED__ 


if not __IAgileObject_FWD_DEFINED__ then
__IAgileObject_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IAgileObject IAgileObject;
]]
end 	-- __IAgileObject_FWD_DEFINED__ 


if not __IActivationFilter_FWD_DEFINED__ then
__IActivationFilter_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IActivationFilter IActivationFilter;
]]
end 	-- __IActivationFilter_FWD_DEFINED__ 


if not __IMarshal2_FWD_DEFINED__ then
__IMarshal2_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IMarshal2 IMarshal2;
]]
end 	-- __IMarshal2_FWD_DEFINED__ 


if not __IMalloc_FWD_DEFINED__ then
__IMalloc_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IMalloc IMalloc;
]]
end 	-- __IMalloc_FWD_DEFINED__ 


if not __IStdMarshalInfo_FWD_DEFINED__ then
__IStdMarshalInfo_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IStdMarshalInfo IStdMarshalInfo;
]]
end 	-- __IStdMarshalInfo_FWD_DEFINED__ 


if not __IExternalConnection_FWD_DEFINED__ then
__IExternalConnection_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IExternalConnection IExternalConnection;
]]
end 	-- __IExternalConnection_FWD_DEFINED__ 


if not __IMultiQI_FWD_DEFINED__ then
__IMultiQI_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IMultiQI IMultiQI;
]]
end 	-- __IMultiQI_FWD_DEFINED__ 


if not __AsyncIMultiQI_FWD_DEFINED__ then
__AsyncIMultiQI_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct AsyncIMultiQI AsyncIMultiQI;
]]
end 	-- __AsyncIMultiQI_FWD_DEFINED__ 


if not __IInternalUnknown_FWD_DEFINED__ then
__IInternalUnknown_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IInternalUnknown IInternalUnknown;
]]
end 	-- __IInternalUnknown_FWD_DEFINED__ 


if not __IEnumUnknown_FWD_DEFINED__ then
__IEnumUnknown_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IEnumUnknown IEnumUnknown;
]]
end 	-- __IEnumUnknown_FWD_DEFINED__ 


if not __IEnumString_FWD_DEFINED__ then
__IEnumString_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IEnumString IEnumString;
]]
end 	-- __IEnumString_FWD_DEFINED__ 


if not __ISequentialStream_FWD_DEFINED__ then
__ISequentialStream_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct ISequentialStream ISequentialStream;
]]
end 	-- __ISequentialStream_FWD_DEFINED__ 


if not __IStream_FWD_DEFINED__ then
__IStream_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IStream IStream;
]]
end 	-- __IStream_FWD_DEFINED__ 


if not __IRpcChannelBuffer_FWD_DEFINED__ then
__IRpcChannelBuffer_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IRpcChannelBuffer IRpcChannelBuffer;
]]
end 	-- __IRpcChannelBuffer_FWD_DEFINED__ 


if not __IRpcChannelBuffer2_FWD_DEFINED__ then
__IRpcChannelBuffer2_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IRpcChannelBuffer2 IRpcChannelBuffer2;
]]
end 	-- __IRpcChannelBuffer2_FWD_DEFINED__ 


if not __IAsyncRpcChannelBuffer_FWD_DEFINED__ then
__IAsyncRpcChannelBuffer_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IAsyncRpcChannelBuffer IAsyncRpcChannelBuffer;
]]
end 	-- __IAsyncRpcChannelBuffer_FWD_DEFINED__ 


if not __IRpcChannelBuffer3_FWD_DEFINED__ then
__IRpcChannelBuffer3_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IRpcChannelBuffer3 IRpcChannelBuffer3;
]]
end 	-- __IRpcChannelBuffer3_FWD_DEFINED__ 


if not __IRpcSyntaxNegotiate_FWD_DEFINED__ then
__IRpcSyntaxNegotiate_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IRpcSyntaxNegotiate IRpcSyntaxNegotiate;
]]
end 	-- __IRpcSyntaxNegotiate_FWD_DEFINED__ 


if not __IRpcProxyBuffer_FWD_DEFINED__ then
__IRpcProxyBuffer_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IRpcProxyBuffer IRpcProxyBuffer;
]]
end 	-- __IRpcProxyBuffer_FWD_DEFINED__ 


if not __IRpcStubBuffer_FWD_DEFINED__ then
__IRpcStubBuffer_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IRpcStubBuffer IRpcStubBuffer;
]]
end 	-- __IRpcStubBuffer_FWD_DEFINED__ 


if not __IPSFactoryBuffer_FWD_DEFINED__ then
__IPSFactoryBuffer_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IPSFactoryBuffer IPSFactoryBuffer;
]]
end 	-- __IPSFactoryBuffer_FWD_DEFINED__ 


if not __IChannelHook_FWD_DEFINED__ then
__IChannelHook_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IChannelHook IChannelHook;
]]
end 	-- __IChannelHook_FWD_DEFINED__ 


if not __IClientSecurity_FWD_DEFINED__ then
__IClientSecurity_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IClientSecurity IClientSecurity;
]]
end 	-- __IClientSecurity_FWD_DEFINED__ 


if not __IServerSecurity_FWD_DEFINED__ then
__IServerSecurity_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IServerSecurity IServerSecurity;
]]
end 	-- __IServerSecurity_FWD_DEFINED__ 


if not __IRpcOptions_FWD_DEFINED__ then
__IRpcOptions_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IRpcOptions IRpcOptions;
]]
end 	-- __IRpcOptions_FWD_DEFINED__ 


if not __IGlobalOptions_FWD_DEFINED__ then
__IGlobalOptions_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IGlobalOptions IGlobalOptions;
]]
end 	-- __IGlobalOptions_FWD_DEFINED__ 


if not __ISurrogate_FWD_DEFINED__ then
__ISurrogate_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct ISurrogate ISurrogate;
]]
end 	-- __ISurrogate_FWD_DEFINED__ 


if not __IGlobalInterfaceTable_FWD_DEFINED__ then
__IGlobalInterfaceTable_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IGlobalInterfaceTable IGlobalInterfaceTable;
]]
end 	-- __IGlobalInterfaceTable_FWD_DEFINED__ 


if not __ISynchronize_FWD_DEFINED__ then
__ISynchronize_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct ISynchronize ISynchronize;
]]
end 	-- __ISynchronize_FWD_DEFINED__ 


if not __ISynchronizeHandle_FWD_DEFINED__ then
__ISynchronizeHandle_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct ISynchronizeHandle ISynchronizeHandle;
]]
end 	-- __ISynchronizeHandle_FWD_DEFINED__ 


if not __ISynchronizeEvent_FWD_DEFINED__ then
__ISynchronizeEvent_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct ISynchronizeEvent ISynchronizeEvent;
]]
end 	-- __ISynchronizeEvent_FWD_DEFINED__ 


if not __ISynchronizeContainer_FWD_DEFINED__ then
__ISynchronizeContainer_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct ISynchronizeContainer ISynchronizeContainer;
]]
end 	-- __ISynchronizeContainer_FWD_DEFINED__ 


if not __ISynchronizeMutex_FWD_DEFINED__ then
__ISynchronizeMutex_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct ISynchronizeMutex ISynchronizeMutex;
]]
end 	-- __ISynchronizeMutex_FWD_DEFINED__ 


if not __ICancelMethodCalls_FWD_DEFINED__ then
__ICancelMethodCalls_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct ICancelMethodCalls ICancelMethodCalls;
]]
end 	-- __ICancelMethodCalls_FWD_DEFINED__ 


if not __IAsyncManager_FWD_DEFINED__ then
__IAsyncManager_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IAsyncManager IAsyncManager;
]]
end 	-- __IAsyncManager_FWD_DEFINED__ 


if not __ICallFactory_FWD_DEFINED__ then
__ICallFactory_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct ICallFactory ICallFactory;
]]
end 	-- __ICallFactory_FWD_DEFINED__ 


if not __IRpcHelper_FWD_DEFINED__ then
__IRpcHelper_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IRpcHelper IRpcHelper;
]]
end 	-- __IRpcHelper_FWD_DEFINED__ 


if not __IReleaseMarshalBuffers_FWD_DEFINED__ then
__IReleaseMarshalBuffers_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IReleaseMarshalBuffers IReleaseMarshalBuffers;
]]
end 	-- __IReleaseMarshalBuffers_FWD_DEFINED__ 


if not __IWaitMultiple_FWD_DEFINED__ then
__IWaitMultiple_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IWaitMultiple IWaitMultiple;
]]
end 	-- __IWaitMultiple_FWD_DEFINED__ 


if not __IAddrTrackingControl_FWD_DEFINED__ then
__IAddrTrackingControl_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IAddrTrackingControl IAddrTrackingControl;
]]
end 	-- __IAddrTrackingControl_FWD_DEFINED__ 


if not __IAddrExclusionControl_FWD_DEFINED__ then
__IAddrExclusionControl_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IAddrExclusionControl IAddrExclusionControl;
]]
end 	-- __IAddrExclusionControl_FWD_DEFINED__ 


if not __IPipeByte_FWD_DEFINED__ then
__IPipeByte_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IPipeByte IPipeByte;
]]
end 	-- __IPipeByte_FWD_DEFINED__ 


if not __AsyncIPipeByte_FWD_DEFINED__ then
__AsyncIPipeByte_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct AsyncIPipeByte AsyncIPipeByte;
]]
end 	-- __AsyncIPipeByte_FWD_DEFINED__ 


if not __IPipeLong_FWD_DEFINED__ then
__IPipeLong_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IPipeLong IPipeLong;
]]
end 	-- __IPipeLong_FWD_DEFINED__ 


if not __AsyncIPipeLong_FWD_DEFINED__ then
__AsyncIPipeLong_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct AsyncIPipeLong AsyncIPipeLong;
]]
end 	-- __AsyncIPipeLong_FWD_DEFINED__ 


if not __IPipeDouble_FWD_DEFINED__ then
__IPipeDouble_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IPipeDouble IPipeDouble;
]]
end 	-- __IPipeDouble_FWD_DEFINED__ 


if not __AsyncIPipeDouble_FWD_DEFINED__ then
__AsyncIPipeDouble_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct AsyncIPipeDouble AsyncIPipeDouble;
]]
end 	-- __AsyncIPipeDouble_FWD_DEFINED__ 


if not __IEnumContextProps_FWD_DEFINED__ then
__IEnumContextProps_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IEnumContextProps IEnumContextProps;
]]
end 	-- __IEnumContextProps_FWD_DEFINED__ 


if not __IContext_FWD_DEFINED__ then
__IContext_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IContext IContext;
]]
end 	-- __IContext_FWD_DEFINED__ 


if not __IObjContext_FWD_DEFINED__ then
__IObjContext_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IObjContext IObjContext;
]]
end 	-- __IObjContext_FWD_DEFINED__ 


if not __IComThreadingInfo_FWD_DEFINED__ then
__IComThreadingInfo_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IComThreadingInfo IComThreadingInfo;
]]
end 	-- __IComThreadingInfo_FWD_DEFINED__ 


if not __IProcessInitControl_FWD_DEFINED__ then
__IProcessInitControl_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IProcessInitControl IProcessInitControl;
]]
end 	-- __IProcessInitControl_FWD_DEFINED__ 


if not __IFastRundown_FWD_DEFINED__ then
__IFastRundown_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IFastRundown IFastRundown;
]]
end 	-- __IFastRundown_FWD_DEFINED__ 


if not __IMarshalingStream_FWD_DEFINED__ then
__IMarshalingStream_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IMarshalingStream IMarshalingStream;
]]
end 	-- __IMarshalingStream_FWD_DEFINED__ 


if not __IAgileReference_FWD_DEFINED__ then
__IAgileReference_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IAgileReference IAgileReference;
]]
end 	-- __IAgileReference_FWD_DEFINED__ 



require("win32.unknwnbase")
require("win32.winapifamily")

--[=[
//+-------------------------------------------------------------------------
//+-------------------------------------------------------------------------
//
//  Microsoft Windows
//  Copyright (c) Microsoft Corporation. All rights reserved.
//
//--------------------------------------------------------------------------
#if(NTDDI_VERSION >= NTDDI_VISTA && !defined(_WIN32_WINNT))
#define _WIN32_WINNT 0x0600
end
#if(NTDDI_VERSION >= NTDDI_WS03 && !defined(_WIN32_WINNT))
#define _WIN32_WINNT 0x0502
end
#if(NTDDI_VERSION >= NTDDI_WINXP && !defined(_WIN32_WINNT))
#define _WIN32_WINNT 0x0501
end
#if(NTDDI_VERSION >= NTDDI_WIN2K && !defined(_WIN32_WINNT))
#define _WIN32_WINNT 0x0500
end



#if ( _MSC_VER >= 800 )
#if _MSC_VER >= 1200
#pragma warning(push)
if not _MSC_EXTENSIONS
#pragma warning(disable:4309) /* truncation of constant value */
end
#pragma warning(disable:4820) /* padding added after data member */
end
#pragma warning(disable:4201)
end
#if ( _MSC_VER >= 1020 )
#pragma once
end
#include <limits.h>
if not _OBJIDLBASE_
#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


end /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)



end /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

typedef struct _COSERVERINFO
   {
   DWORD dwReserved1;
   LPWSTR pwszName;
   COAUTHINFO *pAuthInfo;
   DWORD dwReserved2;
   } 	COSERVERINFO;




extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0000_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0000_v0_0_s_ifspec;

if not __IMarshal_INTERFACE_DEFINED__
#define __IMarshal_INTERFACE_DEFINED__

/* interface IMarshal */
/* [uuid][object][local] */ 

typedef  IMarshal *LPMARSHAL;


EXTERN_C const IID IID_IMarshal;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000003-0000-0000-C000-000000000046")
   IMarshal : public IUnknown
   {
   public:
       virtual HRESULT __stdcall GetUnmarshalClass( 
            
             REFIID riid,
            
             void *pv,
            
             DWORD dwDestContext,
            
           _Reserved_  void *pvDestContext,
            
             DWORD mshlflags,
           /* [annotation][out] */ 
           _Out_  CLSID *pCid) = 0;
       
       virtual HRESULT __stdcall GetMarshalSizeMax( 
            
             REFIID riid,
            
             void *pv,
            
             DWORD dwDestContext,
            
           _Reserved_  void *pvDestContext,
            
             DWORD mshlflags,
           /* [annotation][out] */ 
           _Out_  DWORD *pSize) = 0;
       
       virtual HRESULT __stdcall MarshalInterface( 
            
             IStream *pStm,
            
             REFIID riid,
            
             void *pv,
            
             DWORD dwDestContext,
            
           _Reserved_  void *pvDestContext,
            
             DWORD mshlflags) = 0;
       
       virtual HRESULT __stdcall UnmarshalInterface( 
            
             IStream *pStm,
            
             REFIID riid,
           /* [annotation][out] */ 
           _Outptr_  void **ppv) = 0;
       
       virtual HRESULT __stdcall ReleaseMarshalData( 
            
             IStream *pStm) = 0;
       
       virtual HRESULT __stdcall DisconnectObject( 
            
             DWORD dwReserved) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IMarshalVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IMarshal * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IMarshal * This);
       
       ULONG ( __stdcall *Release )( 
           IMarshal * This);
       
       HRESULT ( __stdcall *GetUnmarshalClass )( 
           IMarshal * This,
            
             REFIID riid,
            
             void *pv,
            
             DWORD dwDestContext,
            
           _Reserved_  void *pvDestContext,
            
             DWORD mshlflags,
           /* [annotation][out] */ 
           _Out_  CLSID *pCid);
       
       HRESULT ( __stdcall *GetMarshalSizeMax )( 
           IMarshal * This,
            
             REFIID riid,
            
             void *pv,
            
             DWORD dwDestContext,
            
           _Reserved_  void *pvDestContext,
            
             DWORD mshlflags,
           /* [annotation][out] */ 
           _Out_  DWORD *pSize);
       
       HRESULT ( __stdcall *MarshalInterface )( 
           IMarshal * This,
            
             IStream *pStm,
            
             REFIID riid,
            
             void *pv,
            
             DWORD dwDestContext,
            
           _Reserved_  void *pvDestContext,
            
             DWORD mshlflags);
       
       HRESULT ( __stdcall *UnmarshalInterface )( 
           IMarshal * This,
            
             IStream *pStm,
            
             REFIID riid,
           /* [annotation][out] */ 
           _Outptr_  void **ppv);
       
       HRESULT ( __stdcall *ReleaseMarshalData )( 
           IMarshal * This,
            
             IStream *pStm);
       
       HRESULT ( __stdcall *DisconnectObject )( 
           IMarshal * This,
            
             DWORD dwReserved);
       
       END_INTERFACE
   } IMarshalVtbl;

   interface IMarshal
   {
       CONST_VTBL struct IMarshalVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IMarshal_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IMarshal_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IMarshal_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IMarshal_GetUnmarshalClass(This,riid,pv,dwDestContext,pvDestContext,mshlflags,pCid)	\
   ( (This)->lpVtbl -> GetUnmarshalClass(This,riid,pv,dwDestContext,pvDestContext,mshlflags,pCid) ) 

#define IMarshal_GetMarshalSizeMax(This,riid,pv,dwDestContext,pvDestContext,mshlflags,pSize)	\
   ( (This)->lpVtbl -> GetMarshalSizeMax(This,riid,pv,dwDestContext,pvDestContext,mshlflags,pSize) ) 

#define IMarshal_MarshalInterface(This,pStm,riid,pv,dwDestContext,pvDestContext,mshlflags)	\
   ( (This)->lpVtbl -> MarshalInterface(This,pStm,riid,pv,dwDestContext,pvDestContext,mshlflags) ) 

#define IMarshal_UnmarshalInterface(This,pStm,riid,ppv)	\
   ( (This)->lpVtbl -> UnmarshalInterface(This,pStm,riid,ppv) ) 

#define IMarshal_ReleaseMarshalData(This,pStm)	\
   ( (This)->lpVtbl -> ReleaseMarshalData(This,pStm) ) 

#define IMarshal_DisconnectObject(This,dwReserved)	\
   ( (This)->lpVtbl -> DisconnectObject(This,dwReserved) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IMarshal_INTERFACE_DEFINED__ */


if not __INoMarshal_INTERFACE_DEFINED__
#define __INoMarshal_INTERFACE_DEFINED__

/* interface INoMarshal */
/* [uuid][object][local] */ 


EXTERN_C const IID IID_INoMarshal;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("ecc8691b-c1db-4dc0-855e-65f6c551af49")
   INoMarshal : public IUnknown
   {
   public:
   };
   
   
#else 	/* C style interface */

   typedef struct INoMarshalVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           INoMarshal * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           INoMarshal * This);
       
       ULONG ( __stdcall *Release )( 
           INoMarshal * This);
       
       END_INTERFACE
   } INoMarshalVtbl;

   interface INoMarshal
   {
       CONST_VTBL struct INoMarshalVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define INoMarshal_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define INoMarshal_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define INoMarshal_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


end /* COBJMACROS */


end 	/* C style interface */




end 	/* __INoMarshal_INTERFACE_DEFINED__ */


if not __IAgileObject_INTERFACE_DEFINED__
#define __IAgileObject_INTERFACE_DEFINED__

/* interface IAgileObject */
/* [uuid][object][local] */ 


EXTERN_C const IID IID_IAgileObject;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("94ea2b94-e9cc-49e0-c0ff-ee64ca8f5b90")
   IAgileObject : public IUnknown
   {
   public:
   };
   
   
#else 	/* C style interface */

   typedef struct IAgileObjectVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IAgileObject * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IAgileObject * This);
       
       ULONG ( __stdcall *Release )( 
           IAgileObject * This);
       
       END_INTERFACE
   } IAgileObjectVtbl;

   interface IAgileObject
   {
       CONST_VTBL struct IAgileObjectVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IAgileObject_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IAgileObject_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IAgileObject_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IAgileObject_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_objidlbase_0000_0003 */
 

end /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#pragma region Desktop Family or OneCore Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0003_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0003_v0_0_s_ifspec;

if not __IActivationFilter_INTERFACE_DEFINED__
#define __IActivationFilter_INTERFACE_DEFINED__

/* interface IActivationFilter */
/* [uuid][object][local] */ 

typedef 
enum tagACTIVATIONTYPE
   {
       ACTIVATIONTYPE_UNCATEGORIZED	= 0,
       ACTIVATIONTYPE_FROM_MONIKER	= 0x1,
       ACTIVATIONTYPE_FROM_DATA	= 0x2,
       ACTIVATIONTYPE_FROM_STORAGE	= 0x4,
       ACTIVATIONTYPE_FROM_STREAM	= 0x8,
       ACTIVATIONTYPE_FROM_FILE	= 0x10
   } 	ACTIVATIONTYPE;


EXTERN_C const IID IID_IActivationFilter;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000017-0000-0000-C000-000000000046")
   IActivationFilter : public IUnknown
   {
   public:
       virtual HRESULT __stdcall HandleActivation( 
            DWORD dwActivationType,
            REFCLSID rclsid,
            CLSID *pReplacementClsId) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IActivationFilterVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IActivationFilter * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IActivationFilter * This);
       
       ULONG ( __stdcall *Release )( 
           IActivationFilter * This);
       
       HRESULT ( __stdcall *HandleActivation )( 
           IActivationFilter * This,
            DWORD dwActivationType,
            REFCLSID rclsid,
            CLSID *pReplacementClsId);
       
       END_INTERFACE
   } IActivationFilterVtbl;

   interface IActivationFilter
   {
       CONST_VTBL struct IActivationFilterVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IActivationFilter_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IActivationFilter_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IActivationFilter_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IActivationFilter_HandleActivation(This,dwActivationType,rclsid,pReplacementClsId)	\
   ( (This)->lpVtbl -> HandleActivation(This,dwActivationType,rclsid,pReplacementClsId) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IActivationFilter_INTERFACE_DEFINED__ */


if not __IMarshal2_INTERFACE_DEFINED__
#define __IMarshal2_INTERFACE_DEFINED__

/* interface IMarshal2 */
/* [uuid][object][local] */ 

typedef  IMarshal2 *LPMARSHAL2;


EXTERN_C const IID IID_IMarshal2;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("000001cf-0000-0000-C000-000000000046")
   IMarshal2 : public IMarshal
   {
   public:
   };
   
   
#else 	/* C style interface */

   typedef struct IMarshal2Vtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IMarshal2 * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IMarshal2 * This);
       
       ULONG ( __stdcall *Release )( 
           IMarshal2 * This);
       
       HRESULT ( __stdcall *GetUnmarshalClass )( 
           IMarshal2 * This,
            
             REFIID riid,
            
             void *pv,
            
             DWORD dwDestContext,
            
           _Reserved_  void *pvDestContext,
            
             DWORD mshlflags,
           /* [annotation][out] */ 
           _Out_  CLSID *pCid);
       
       HRESULT ( __stdcall *GetMarshalSizeMax )( 
           IMarshal2 * This,
            
             REFIID riid,
            
             void *pv,
            
             DWORD dwDestContext,
            
           _Reserved_  void *pvDestContext,
            
             DWORD mshlflags,
           /* [annotation][out] */ 
           _Out_  DWORD *pSize);
       
       HRESULT ( __stdcall *MarshalInterface )( 
           IMarshal2 * This,
            
             IStream *pStm,
            
             REFIID riid,
            
             void *pv,
            
             DWORD dwDestContext,
            
           _Reserved_  void *pvDestContext,
            
             DWORD mshlflags);
       
       HRESULT ( __stdcall *UnmarshalInterface )( 
           IMarshal2 * This,
            
             IStream *pStm,
            
             REFIID riid,
           /* [annotation][out] */ 
           _Outptr_  void **ppv);
       
       HRESULT ( __stdcall *ReleaseMarshalData )( 
           IMarshal2 * This,
            
             IStream *pStm);
       
       HRESULT ( __stdcall *DisconnectObject )( 
           IMarshal2 * This,
            
             DWORD dwReserved);
       
       END_INTERFACE
   } IMarshal2Vtbl;

   interface IMarshal2
   {
       CONST_VTBL struct IMarshal2Vtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IMarshal2_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IMarshal2_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IMarshal2_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IMarshal2_GetUnmarshalClass(This,riid,pv,dwDestContext,pvDestContext,mshlflags,pCid)	\
   ( (This)->lpVtbl -> GetUnmarshalClass(This,riid,pv,dwDestContext,pvDestContext,mshlflags,pCid) ) 

#define IMarshal2_GetMarshalSizeMax(This,riid,pv,dwDestContext,pvDestContext,mshlflags,pSize)	\
   ( (This)->lpVtbl -> GetMarshalSizeMax(This,riid,pv,dwDestContext,pvDestContext,mshlflags,pSize) ) 

#define IMarshal2_MarshalInterface(This,pStm,riid,pv,dwDestContext,pvDestContext,mshlflags)	\
   ( (This)->lpVtbl -> MarshalInterface(This,pStm,riid,pv,dwDestContext,pvDestContext,mshlflags) ) 

#define IMarshal2_UnmarshalInterface(This,pStm,riid,ppv)	\
   ( (This)->lpVtbl -> UnmarshalInterface(This,pStm,riid,ppv) ) 

#define IMarshal2_ReleaseMarshalData(This,pStm)	\
   ( (This)->lpVtbl -> ReleaseMarshalData(This,pStm) ) 

#define IMarshal2_DisconnectObject(This,dwReserved)	\
   ( (This)->lpVtbl -> DisconnectObject(This,dwReserved) ) 


end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IMarshal2_INTERFACE_DEFINED__ */
--]=]

if not __IMalloc_INTERFACE_DEFINED__ then
__IMalloc_INTERFACE_DEFINED__ = true

ffi.cdef[[
typedef  IMalloc *LPMALLOC;
]]

--EXTERN_C const IID IID_IMalloc;
--MIDL_INTERFACE("00000002-0000-0000-C000-000000000046")

ffi.cdef[[
   typedef struct IMallocVtbl
   {
       
       HRESULT ( __stdcall *QueryInterface )( 
           IMalloc * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IMalloc * This);
       
       ULONG ( __stdcall *Release )( 
           IMalloc * This);
       
       void *( __stdcall *Alloc )( 
           IMalloc * This,
            
             SIZE_T cb);
       
       void *( __stdcall *Realloc )( 
           IMalloc * This,
            
             void *pv,
            
             SIZE_T cb);
       
       void ( __stdcall *Free )( 
           IMalloc * This,
            
             void *pv);
       
       SIZE_T ( __stdcall *GetSize )( 
           IMalloc * This,
            
              void *pv);
       
       int ( __stdcall *DidAlloc )( 
           IMalloc * This,
            
             void *pv);
       
       void ( __stdcall *HeapMinimize )( 
           IMalloc * This);
       
   } IMallocVtbl;

   typedef struct IMalloc
   {
       const struct IMallocVtbl *lpVtbl;
   };
]]
   
--[[
#ifdef COBJMACROS


#define IMalloc_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IMalloc_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IMalloc_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IMalloc_Alloc(This,cb)	\
   ( (This)->lpVtbl -> Alloc(This,cb) ) 

#define IMalloc_Realloc(This,pv,cb)	\
   ( (This)->lpVtbl -> Realloc(This,pv,cb) ) 

#define IMalloc_Free(This,pv)	\
   ( (This)->lpVtbl -> Free(This,pv) ) 

#define IMalloc_GetSize(This,pv)	\
   ( (This)->lpVtbl -> GetSize(This,pv) ) 

#define IMalloc_DidAlloc(This,pv)	\
   ( (This)->lpVtbl -> DidAlloc(This,pv) ) 

#define IMalloc_HeapMinimize(This)	\
   ( (This)->lpVtbl -> HeapMinimize(This) ) 

end /* COBJMACROS */
--]]
end

--[=[
if not __IStdMarshalInfo_INTERFACE_DEFINED__
#define __IStdMarshalInfo_INTERFACE_DEFINED__

/* interface IStdMarshalInfo */
/* [uuid][object][local] */ 

typedef  IStdMarshalInfo *LPSTDMARSHALINFO;


EXTERN_C const IID IID_IStdMarshalInfo;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000018-0000-0000-C000-000000000046")
   IStdMarshalInfo : public IUnknown
   {
   public:
       virtual HRESULT __stdcall GetClassForHandler( 
            
             DWORD dwDestContext,
            
           _Reserved_  void *pvDestContext,
           /* [annotation][out] */ 
           _Out_  CLSID *pClsid) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IStdMarshalInfoVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IStdMarshalInfo * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IStdMarshalInfo * This);
       
       ULONG ( __stdcall *Release )( 
           IStdMarshalInfo * This);
       
       HRESULT ( __stdcall *GetClassForHandler )( 
           IStdMarshalInfo * This,
            
             DWORD dwDestContext,
            
           _Reserved_  void *pvDestContext,
           /* [annotation][out] */ 
           _Out_  CLSID *pClsid);
       
       END_INTERFACE
   } IStdMarshalInfoVtbl;

   interface IStdMarshalInfo
   {
       CONST_VTBL struct IStdMarshalInfoVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IStdMarshalInfo_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IStdMarshalInfo_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IStdMarshalInfo_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IStdMarshalInfo_GetClassForHandler(This,dwDestContext,pvDestContext,pClsid)	\
   ( (This)->lpVtbl -> GetClassForHandler(This,dwDestContext,pvDestContext,pClsid) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IStdMarshalInfo_INTERFACE_DEFINED__ */


if not __IExternalConnection_INTERFACE_DEFINED__
#define __IExternalConnection_INTERFACE_DEFINED__

/* interface IExternalConnection */
/* [uuid][local][object] */ 

typedef  IExternalConnection *LPEXTERNALCONNECTION;

typedef 
enum tagEXTCONN
   {
       EXTCONN_STRONG	= 0x1,
       EXTCONN_WEAK	= 0x2,
       EXTCONN_CALLABLE	= 0x4
   } 	EXTCONN;


EXTERN_C const IID IID_IExternalConnection;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000019-0000-0000-C000-000000000046")
   IExternalConnection : public IUnknown
   {
   public:
       virtual DWORD __stdcall AddConnection( 
            
             DWORD extconn,
            
             DWORD reserved) = 0;
       
       virtual DWORD __stdcall ReleaseConnection( 
            
             DWORD extconn,
            
             DWORD reserved,
            
             BOOL fLastReleaseCloses) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IExternalConnectionVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IExternalConnection * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IExternalConnection * This);
       
       ULONG ( __stdcall *Release )( 
           IExternalConnection * This);
       
       DWORD ( __stdcall *AddConnection )( 
           IExternalConnection * This,
            
             DWORD extconn,
            
             DWORD reserved);
       
       DWORD ( __stdcall *ReleaseConnection )( 
           IExternalConnection * This,
            
             DWORD extconn,
            
             DWORD reserved,
            
             BOOL fLastReleaseCloses);
       
       END_INTERFACE
   } IExternalConnectionVtbl;

   interface IExternalConnection
   {
       CONST_VTBL struct IExternalConnectionVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IExternalConnection_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IExternalConnection_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IExternalConnection_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IExternalConnection_AddConnection(This,extconn,reserved)	\
   ( (This)->lpVtbl -> AddConnection(This,extconn,reserved) ) 

#define IExternalConnection_ReleaseConnection(This,extconn,reserved,fLastReleaseCloses)	\
   ( (This)->lpVtbl -> ReleaseConnection(This,extconn,reserved,fLastReleaseCloses) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IExternalConnection_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_objidlbase_0000_0008 */
 

typedef    IMultiQI *LPMULTIQI;

end /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)
typedef struct tagMULTI_QI
   {
   const IID *pIID;
   IUnknown *pItf;
   HRESULT hr;
   } 	MULTI_QI;



extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0008_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0008_v0_0_s_ifspec;

if not __IMultiQI_INTERFACE_DEFINED__
#define __IMultiQI_INTERFACE_DEFINED__

/* interface IMultiQI */
/* [async_uuid][uuid][local][object] */ 


EXTERN_C const IID IID_IMultiQI;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000020-0000-0000-C000-000000000046")
   IMultiQI : public IUnknown
   {
   public:
       virtual HRESULT __stdcall QueryMultipleInterfaces( 
            
             ULONG cMQIs,
           /* [annotation][out][in] */ 
           _Inout_updates_(cMQIs)  MULTI_QI *pMQIs) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IMultiQIVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IMultiQI * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IMultiQI * This);
       
       ULONG ( __stdcall *Release )( 
           IMultiQI * This);
       
       HRESULT ( __stdcall *QueryMultipleInterfaces )( 
           IMultiQI * This,
            
             ULONG cMQIs,
           /* [annotation][out][in] */ 
           _Inout_updates_(cMQIs)  MULTI_QI *pMQIs);
       
       END_INTERFACE
   } IMultiQIVtbl;

   interface IMultiQI
   {
       CONST_VTBL struct IMultiQIVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IMultiQI_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IMultiQI_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IMultiQI_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IMultiQI_QueryMultipleInterfaces(This,cMQIs,pMQIs)	\
   ( (This)->lpVtbl -> QueryMultipleInterfaces(This,cMQIs,pMQIs) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IMultiQI_INTERFACE_DEFINED__ */


if not __AsyncIMultiQI_INTERFACE_DEFINED__
#define __AsyncIMultiQI_INTERFACE_DEFINED__

/* interface AsyncIMultiQI */
/* [uuid][local][object] */ 


EXTERN_C const IID IID_AsyncIMultiQI;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("000e0020-0000-0000-C000-000000000046")
   AsyncIMultiQI : public IUnknown
   {
   public:
       virtual HRESULT __stdcall Begin_QueryMultipleInterfaces( 
            
             ULONG cMQIs,
           /* [annotation][out][in] */ 
           _Inout_updates_(cMQIs)  MULTI_QI *pMQIs) = 0;
       
       virtual HRESULT __stdcall Finish_QueryMultipleInterfaces( 
           /* [annotation][out][in] */ 
           _Inout_updates_(cMQIs)  MULTI_QI *pMQIs) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct AsyncIMultiQIVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           AsyncIMultiQI * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           AsyncIMultiQI * This);
       
       ULONG ( __stdcall *Release )( 
           AsyncIMultiQI * This);
       
       HRESULT ( __stdcall *Begin_QueryMultipleInterfaces )( 
           AsyncIMultiQI * This,
            
             ULONG cMQIs,
           /* [annotation][out][in] */ 
           _Inout_updates_(cMQIs)  MULTI_QI *pMQIs);
       
       HRESULT ( __stdcall *Finish_QueryMultipleInterfaces )( 
           AsyncIMultiQI * This,
           /* [annotation][out][in] */ 
           _Inout_updates_(cMQIs)  MULTI_QI *pMQIs);
       
       END_INTERFACE
   } AsyncIMultiQIVtbl;

   interface AsyncIMultiQI
   {
       CONST_VTBL struct AsyncIMultiQIVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define AsyncIMultiQI_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define AsyncIMultiQI_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define AsyncIMultiQI_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define AsyncIMultiQI_Begin_QueryMultipleInterfaces(This,cMQIs,pMQIs)	\
   ( (This)->lpVtbl -> Begin_QueryMultipleInterfaces(This,cMQIs,pMQIs) ) 

#define AsyncIMultiQI_Finish_QueryMultipleInterfaces(This,pMQIs)	\
   ( (This)->lpVtbl -> Finish_QueryMultipleInterfaces(This,pMQIs) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __AsyncIMultiQI_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_objidlbase_0000_0009 */
 

end /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0009_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0009_v0_0_s_ifspec;

if not __IInternalUnknown_INTERFACE_DEFINED__
#define __IInternalUnknown_INTERFACE_DEFINED__

/* interface IInternalUnknown */
/* [uuid][local][object] */ 


EXTERN_C const IID IID_IInternalUnknown;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000021-0000-0000-C000-000000000046")
   IInternalUnknown : public IUnknown
   {
   public:
       virtual HRESULT __stdcall QueryInternalInterface( 
            
             REFIID riid,
           /* [annotation][out] */ 
           _Outptr_  void **ppv) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IInternalUnknownVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IInternalUnknown * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IInternalUnknown * This);
       
       ULONG ( __stdcall *Release )( 
           IInternalUnknown * This);
       
       HRESULT ( __stdcall *QueryInternalInterface )( 
           IInternalUnknown * This,
            
             REFIID riid,
           /* [annotation][out] */ 
           _Outptr_  void **ppv);
       
       END_INTERFACE
   } IInternalUnknownVtbl;

   interface IInternalUnknown
   {
       CONST_VTBL struct IInternalUnknownVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IInternalUnknown_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IInternalUnknown_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IInternalUnknown_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IInternalUnknown_QueryInternalInterface(This,riid,ppv)	\
   ( (This)->lpVtbl -> QueryInternalInterface(This,riid,ppv) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IInternalUnknown_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_objidlbase_0000_0010 */
 

end /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#pragma region Application Family or OneCore Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0010_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0010_v0_0_s_ifspec;

if not __IEnumUnknown_INTERFACE_DEFINED__
#define __IEnumUnknown_INTERFACE_DEFINED__

/* interface IEnumUnknown */
/* [unique][uuid][object] */ 

typedef    IEnumUnknown *LPENUMUNKNOWN;


EXTERN_C const IID IID_IEnumUnknown;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000100-0000-0000-C000-000000000046")
   IEnumUnknown : public IUnknown
   {
   public:
       virtual  HRESULT __stdcall Next( 
            
             ULONG celt,
           /* [annotation][out] */ 
           _Out_writes_to_(celt,*pceltFetched)  IUnknown **rgelt,
           /* [annotation][out] */ 
             ULONG *pceltFetched) = 0;
       
       virtual HRESULT __stdcall Skip( 
            ULONG celt) = 0;
       
       virtual HRESULT __stdcall Reset( void) = 0;
       
       virtual HRESULT __stdcall Clone( 
             IEnumUnknown **ppenum) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IEnumUnknownVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
            IEnumUnknown * This,
             REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
            IEnumUnknown * This);
       
       ULONG ( __stdcall *Release )( 
            IEnumUnknown * This);
       
        HRESULT ( __stdcall *Next )( 
           IEnumUnknown * This,
            
             ULONG celt,
           /* [annotation][out] */ 
           _Out_writes_to_(celt,*pceltFetched)  IUnknown **rgelt,
           /* [annotation][out] */ 
             ULONG *pceltFetched);
       
       HRESULT ( __stdcall *Skip )( 
            IEnumUnknown * This,
            ULONG celt);
       
       HRESULT ( __stdcall *Reset )( 
            IEnumUnknown * This);
       
       HRESULT ( __stdcall *Clone )( 
            IEnumUnknown * This,
             IEnumUnknown **ppenum);
       
       END_INTERFACE
   } IEnumUnknownVtbl;

   interface IEnumUnknown
   {
       CONST_VTBL struct IEnumUnknownVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IEnumUnknown_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IEnumUnknown_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IEnumUnknown_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IEnumUnknown_Next(This,celt,rgelt,pceltFetched)	\
   ( (This)->lpVtbl -> Next(This,celt,rgelt,pceltFetched) ) 

#define IEnumUnknown_Skip(This,celt)	\
   ( (This)->lpVtbl -> Skip(This,celt) ) 

#define IEnumUnknown_Reset(This)	\
   ( (This)->lpVtbl -> Reset(This) ) 

#define IEnumUnknown_Clone(This,ppenum)	\
   ( (This)->lpVtbl -> Clone(This,ppenum) ) 

end /* COBJMACROS */


end 	/* C style interface */



 HRESULT __stdcall IEnumUnknown_RemoteNext_Proxy( 
    IEnumUnknown * This,
    ULONG celt,
   /* [length_is][size_is][out] */ __RPC__out_ecount_part(celt, *pceltFetched) IUnknown **rgelt,
     ULONG *pceltFetched);


void  IEnumUnknown_RemoteNext_Stub(
   IRpcStubBuffer *This,
   IRpcChannelBuffer *_pRpcChannelBuffer,
   PRPC_MESSAGE _pRpcMessage,
   DWORD *_pdwStubPhase);



end 	/* __IEnumUnknown_INTERFACE_DEFINED__ */


if not __IEnumString_INTERFACE_DEFINED__
#define __IEnumString_INTERFACE_DEFINED__

/* interface IEnumString */
/* [unique][uuid][object] */ 

typedef    IEnumString *LPENUMSTRING;


EXTERN_C const IID IID_IEnumString;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000101-0000-0000-C000-000000000046")
   IEnumString : public IUnknown
   {
   public:
       virtual  HRESULT __stdcall Next( 
            ULONG celt,
            
           _Out_writes_to_(celt,*pceltFetched)  LPOLESTR *rgelt,
            
             ULONG *pceltFetched) = 0;
       
       virtual HRESULT __stdcall Skip( 
            ULONG celt) = 0;
       
       virtual HRESULT __stdcall Reset( void) = 0;
       
       virtual HRESULT __stdcall Clone( 
             IEnumString **ppenum) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IEnumStringVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
            IEnumString * This,
             REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
            IEnumString * This);
       
       ULONG ( __stdcall *Release )( 
            IEnumString * This);
       
        HRESULT ( __stdcall *Next )( 
           IEnumString * This,
            ULONG celt,
            
           _Out_writes_to_(celt,*pceltFetched)  LPOLESTR *rgelt,
            
             ULONG *pceltFetched);
       
       HRESULT ( __stdcall *Skip )( 
            IEnumString * This,
            ULONG celt);
       
       HRESULT ( __stdcall *Reset )( 
            IEnumString * This);
       
       HRESULT ( __stdcall *Clone )( 
            IEnumString * This,
             IEnumString **ppenum);
       
       END_INTERFACE
   } IEnumStringVtbl;

   interface IEnumString
   {
       CONST_VTBL struct IEnumStringVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IEnumString_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IEnumString_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IEnumString_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IEnumString_Next(This,celt,rgelt,pceltFetched)	\
   ( (This)->lpVtbl -> Next(This,celt,rgelt,pceltFetched) ) 

#define IEnumString_Skip(This,celt)	\
   ( (This)->lpVtbl -> Skip(This,celt) ) 

#define IEnumString_Reset(This)	\
   ( (This)->lpVtbl -> Reset(This) ) 

#define IEnumString_Clone(This,ppenum)	\
   ( (This)->lpVtbl -> Clone(This,ppenum) ) 

end /* COBJMACROS */


end 	/* C style interface */



 HRESULT __stdcall IEnumString_RemoteNext_Proxy( 
    IEnumString * This,
    ULONG celt,
   /* [length_is][size_is][out] */ __RPC__out_ecount_part(celt, *pceltFetched) LPOLESTR *rgelt,
     ULONG *pceltFetched);


void  IEnumString_RemoteNext_Stub(
   IRpcStubBuffer *This,
   IRpcChannelBuffer *_pRpcChannelBuffer,
   PRPC_MESSAGE _pRpcMessage,
   DWORD *_pdwStubPhase);



end 	/* __IEnumString_INTERFACE_DEFINED__ */


if not __ISequentialStream_INTERFACE_DEFINED__
#define __ISequentialStream_INTERFACE_DEFINED__

/* interface ISequentialStream */
/* [unique][uuid][object] */ 


EXTERN_C const IID IID_ISequentialStream;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("0c733a30-2a1c-11ce-ade5-00aa0044773d")
   ISequentialStream : public IUnknown
   {
   public:
       virtual  HRESULT __stdcall Read( 
            
             void *pv,
            
             ULONG cb,
            
             ULONG *pcbRead) = 0;
       
       virtual  HRESULT __stdcall Write( 
            
             const void *pv,
            
             ULONG cb,
            
             ULONG *pcbWritten) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct ISequentialStreamVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
            ISequentialStream * This,
             REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
            ISequentialStream * This);
       
       ULONG ( __stdcall *Release )( 
            ISequentialStream * This);
       
        HRESULT ( __stdcall *Read )( 
           ISequentialStream * This,
            
             void *pv,
            
             ULONG cb,
            
             ULONG *pcbRead);
       
        HRESULT ( __stdcall *Write )( 
           ISequentialStream * This,
            
             const void *pv,
            
             ULONG cb,
            
             ULONG *pcbWritten);
       
       END_INTERFACE
   } ISequentialStreamVtbl;

   interface ISequentialStream
   {
       CONST_VTBL struct ISequentialStreamVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define ISequentialStream_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define ISequentialStream_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define ISequentialStream_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define ISequentialStream_Read(This,pv,cb,pcbRead)	\
   ( (This)->lpVtbl -> Read(This,pv,cb,pcbRead) ) 

#define ISequentialStream_Write(This,pv,cb,pcbWritten)	\
   ( (This)->lpVtbl -> Write(This,pv,cb,pcbWritten) ) 

end /* COBJMACROS */


end 	/* C style interface */



 HRESULT __stdcall ISequentialStream_RemoteRead_Proxy( 
    ISequentialStream * This,
   /* [length_is][size_is][out] */ __RPC__out_ecount_part(cb, *pcbRead) byte *pv,
    ULONG cb,
     ULONG *pcbRead);


void  ISequentialStream_RemoteRead_Stub(
   IRpcStubBuffer *This,
   IRpcChannelBuffer *_pRpcChannelBuffer,
   PRPC_MESSAGE _pRpcMessage,
   DWORD *_pdwStubPhase);


 HRESULT __stdcall ISequentialStream_RemoteWrite_Proxy( 
    ISequentialStream * This,
   /* [size_is][in] */ __RPC__in_ecount_full(cb) const byte *pv,
    ULONG cb,
     ULONG *pcbWritten);


void  ISequentialStream_RemoteWrite_Stub(
   IRpcStubBuffer *This,
   IRpcChannelBuffer *_pRpcChannelBuffer,
   PRPC_MESSAGE _pRpcMessage,
   DWORD *_pdwStubPhase);



end 	/* __ISequentialStream_INTERFACE_DEFINED__ */
--]=]

if not __IStream_INTERFACE_DEFINED__ then
__IStream_INTERFACE_DEFINED__ = true


ffi.cdef[[
typedef    IStream *LPSTREAM;

typedef struct tagSTATSTG
   {
   LPOLESTR pwcsName;
   DWORD type;
   ULARGE_INTEGER cbSize;
   FILETIME mtime;
   FILETIME ctime;
   FILETIME atime;
   DWORD grfMode;
   DWORD grfLocksSupported;
   CLSID clsid;
   DWORD grfStateBits;
   DWORD reserved;
   } 	STATSTG;

typedef 
enum tagSTGTY
   {
       STGTY_STORAGE	= 1,
       STGTY_STREAM	= 2,
       STGTY_LOCKBYTES	= 3,
       STGTY_PROPERTY	= 4
   } 	STGTY;

typedef 
enum tagSTREAM_SEEK
   {
       STREAM_SEEK_SET	= 0,
       STREAM_SEEK_CUR	= 1,
       STREAM_SEEK_END	= 2
   } 	STREAM_SEEK;

typedef 
enum tagLOCKTYPE
   {
       LOCK_WRITE	= 1,
       LOCK_EXCLUSIVE	= 2,
       LOCK_ONLYONCE	= 4
   } 	LOCKTYPE;
]]

--EXTERN_C const IID IID_IStream;
--   MIDL_INTERFACE("0000000c-0000-0000-C000-000000000046")


ffi.cdef[[
   typedef struct IStreamVtbl
   {
       
       
       HRESULT ( __stdcall *QueryInterface )( 
            IStream * This,
             REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
            IStream * This);
       
       ULONG ( __stdcall *Release )( 
            IStream * This);
       
        HRESULT ( __stdcall *Read )( 
           IStream * This,
            
             void *pv,
            
             ULONG cb,
            
             ULONG *pcbRead);
       
        HRESULT ( __stdcall *Write )( 
           IStream * This,
            
             const void *pv,
            
             ULONG cb,
            
             ULONG *pcbWritten);
       
        HRESULT ( __stdcall *Seek )( 
           IStream * This,
            LARGE_INTEGER dlibMove,
            DWORD dwOrigin,
            
             ULARGE_INTEGER *plibNewPosition);
       
       HRESULT ( __stdcall *SetSize )( 
            IStream * This,
            ULARGE_INTEGER libNewSize);
       
        HRESULT ( __stdcall *CopyTo )( 
           IStream * This,
            
             IStream *pstm,
            ULARGE_INTEGER cb,
            
             ULARGE_INTEGER *pcbRead,
            
             ULARGE_INTEGER *pcbWritten);
       
       HRESULT ( __stdcall *Commit )( 
            IStream * This,
            DWORD grfCommitFlags);
       
       HRESULT ( __stdcall *Revert )( 
            IStream * This);
       
       HRESULT ( __stdcall *LockRegion )( 
            IStream * This,
            ULARGE_INTEGER libOffset,
            ULARGE_INTEGER cb,
            DWORD dwLockType);
       
       HRESULT ( __stdcall *UnlockRegion )( 
            IStream * This,
            ULARGE_INTEGER libOffset,
            ULARGE_INTEGER cb,
            DWORD dwLockType);
       
       HRESULT ( __stdcall *Stat )( 
            IStream * This,
             STATSTG *pstatstg,
            DWORD grfStatFlag);
       
       HRESULT ( __stdcall *Clone )( 
            IStream * This,
             IStream **ppstm);
       
       
   } IStreamVtbl;

   typedef struct IStream
   {
       const struct IStreamVtbl *lpVtbl;
   };
]]
   
--[[
#ifdef COBJMACROS


#define IStream_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IStream_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IStream_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IStream_Read(This,pv,cb,pcbRead)	\
   ( (This)->lpVtbl -> Read(This,pv,cb,pcbRead) ) 

#define IStream_Write(This,pv,cb,pcbWritten)	\
   ( (This)->lpVtbl -> Write(This,pv,cb,pcbWritten) ) 


#define IStream_Seek(This,dlibMove,dwOrigin,plibNewPosition)	\
   ( (This)->lpVtbl -> Seek(This,dlibMove,dwOrigin,plibNewPosition) ) 

#define IStream_SetSize(This,libNewSize)	\
   ( (This)->lpVtbl -> SetSize(This,libNewSize) ) 

#define IStream_CopyTo(This,pstm,cb,pcbRead,pcbWritten)	\
   ( (This)->lpVtbl -> CopyTo(This,pstm,cb,pcbRead,pcbWritten) ) 

#define IStream_Commit(This,grfCommitFlags)	\
   ( (This)->lpVtbl -> Commit(This,grfCommitFlags) ) 

#define IStream_Revert(This)	\
   ( (This)->lpVtbl -> Revert(This) ) 

#define IStream_LockRegion(This,libOffset,cb,dwLockType)	\
   ( (This)->lpVtbl -> LockRegion(This,libOffset,cb,dwLockType) ) 

#define IStream_UnlockRegion(This,libOffset,cb,dwLockType)	\
   ( (This)->lpVtbl -> UnlockRegion(This,libOffset,cb,dwLockType) ) 

#define IStream_Stat(This,pstatstg,grfStatFlag)	\
   ( (This)->lpVtbl -> Stat(This,pstatstg,grfStatFlag) ) 

#define IStream_Clone(This,ppstm)	\
   ( (This)->lpVtbl -> Clone(This,ppstm) ) 

end /* COBJMACROS */
--]]


--[[
ffi.cdef[[
 HRESULT __stdcall IStream_RemoteSeek_Proxy( 
    IStream * This,
    LARGE_INTEGER dlibMove,
    DWORD dwOrigin,
     ULARGE_INTEGER *plibNewPosition);


void  IStream_RemoteSeek_Stub(
   IRpcStubBuffer *This,
   IRpcChannelBuffer *_pRpcChannelBuffer,
   PRPC_MESSAGE _pRpcMessage,
   DWORD *_pdwStubPhase);


 HRESULT __stdcall IStream_RemoteCopyTo_Proxy( 
    IStream * This,
     IStream *pstm,
    ULARGE_INTEGER cb,
     ULARGE_INTEGER *pcbRead,
     ULARGE_INTEGER *pcbWritten);


void  IStream_RemoteCopyTo_Stub(
   IRpcStubBuffer *This,
   IRpcChannelBuffer *_pRpcChannelBuffer,
   PRPC_MESSAGE _pRpcMessage,
   DWORD *_pdwStubPhase);
]]
--]]

end 	--/* __IStream_INTERFACE_DEFINED__ */

--[=[
if not __IRpcChannelBuffer_INTERFACE_DEFINED__
#define __IRpcChannelBuffer_INTERFACE_DEFINED__

/* interface IRpcChannelBuffer */
/* [uuid][object][local] */ 

typedef ULONG RPCOLEDATAREP;

typedef struct tagRPCOLEMESSAGE
   {
   void *reserved1;
   RPCOLEDATAREP dataRepresentation;
   void *Buffer;
   ULONG cbBuffer;
   ULONG iMethod;
   void *reserved2[ 5 ];
   ULONG rpcFlags;
   } 	RPCOLEMESSAGE;

typedef RPCOLEMESSAGE *PRPCOLEMESSAGE;


EXTERN_C const IID IID_IRpcChannelBuffer;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("D5F56B60-593B-101A-B569-08002B2DBF7A")
   IRpcChannelBuffer : public IUnknown
   {
   public:
       virtual HRESULT __stdcall GetBuffer( 
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMessage,
            
             REFIID riid) = 0;
       
       virtual HRESULT __stdcall SendReceive( 
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMessage,
           /* [annotation][out] */ 
             ULONG *pStatus) = 0;
       
       virtual HRESULT __stdcall FreeBuffer( 
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMessage) = 0;
       
       virtual HRESULT __stdcall GetDestCtx( 
           /* [annotation][out] */ 
           _Out_  DWORD *pdwDestContext,
           /* [annotation][out] */ 
           _Outptr_result_maybenull_  void **ppvDestContext) = 0;
       
       virtual HRESULT __stdcall IsConnected( void) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IRpcChannelBufferVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IRpcChannelBuffer * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IRpcChannelBuffer * This);
       
       ULONG ( __stdcall *Release )( 
           IRpcChannelBuffer * This);
       
       HRESULT ( __stdcall *GetBuffer )( 
           IRpcChannelBuffer * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMessage,
            
             REFIID riid);
       
       HRESULT ( __stdcall *SendReceive )( 
           IRpcChannelBuffer * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMessage,
           /* [annotation][out] */ 
             ULONG *pStatus);
       
       HRESULT ( __stdcall *FreeBuffer )( 
           IRpcChannelBuffer * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMessage);
       
       HRESULT ( __stdcall *GetDestCtx )( 
           IRpcChannelBuffer * This,
           /* [annotation][out] */ 
           _Out_  DWORD *pdwDestContext,
           /* [annotation][out] */ 
           _Outptr_result_maybenull_  void **ppvDestContext);
       
       HRESULT ( __stdcall *IsConnected )( 
           IRpcChannelBuffer * This);
       
       END_INTERFACE
   } IRpcChannelBufferVtbl;

   interface IRpcChannelBuffer
   {
       CONST_VTBL struct IRpcChannelBufferVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IRpcChannelBuffer_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IRpcChannelBuffer_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IRpcChannelBuffer_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IRpcChannelBuffer_GetBuffer(This,pMessage,riid)	\
   ( (This)->lpVtbl -> GetBuffer(This,pMessage,riid) ) 

#define IRpcChannelBuffer_SendReceive(This,pMessage,pStatus)	\
   ( (This)->lpVtbl -> SendReceive(This,pMessage,pStatus) ) 

#define IRpcChannelBuffer_FreeBuffer(This,pMessage)	\
   ( (This)->lpVtbl -> FreeBuffer(This,pMessage) ) 

#define IRpcChannelBuffer_GetDestCtx(This,pdwDestContext,ppvDestContext)	\
   ( (This)->lpVtbl -> GetDestCtx(This,pdwDestContext,ppvDestContext) ) 

#define IRpcChannelBuffer_IsConnected(This)	\
   ( (This)->lpVtbl -> IsConnected(This) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IRpcChannelBuffer_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_objidlbase_0000_0015 */
 

end /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0015_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0015_v0_0_s_ifspec;

if not __IRpcChannelBuffer2_INTERFACE_DEFINED__
#define __IRpcChannelBuffer2_INTERFACE_DEFINED__

/* interface IRpcChannelBuffer2 */
/* [uuid][object][local] */ 


EXTERN_C const IID IID_IRpcChannelBuffer2;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("594f31d0-7f19-11d0-b194-00a0c90dc8bf")
   IRpcChannelBuffer2 : public IRpcChannelBuffer
   {
   public:
       virtual HRESULT __stdcall GetProtocolVersion( 
           /* [annotation][out] */ 
           _Out_  DWORD *pdwVersion) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IRpcChannelBuffer2Vtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IRpcChannelBuffer2 * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IRpcChannelBuffer2 * This);
       
       ULONG ( __stdcall *Release )( 
           IRpcChannelBuffer2 * This);
       
       HRESULT ( __stdcall *GetBuffer )( 
           IRpcChannelBuffer2 * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMessage,
            
             REFIID riid);
       
       HRESULT ( __stdcall *SendReceive )( 
           IRpcChannelBuffer2 * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMessage,
           /* [annotation][out] */ 
             ULONG *pStatus);
       
       HRESULT ( __stdcall *FreeBuffer )( 
           IRpcChannelBuffer2 * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMessage);
       
       HRESULT ( __stdcall *GetDestCtx )( 
           IRpcChannelBuffer2 * This,
           /* [annotation][out] */ 
           _Out_  DWORD *pdwDestContext,
           /* [annotation][out] */ 
           _Outptr_result_maybenull_  void **ppvDestContext);
       
       HRESULT ( __stdcall *IsConnected )( 
           IRpcChannelBuffer2 * This);
       
       HRESULT ( __stdcall *GetProtocolVersion )( 
           IRpcChannelBuffer2 * This,
           /* [annotation][out] */ 
           _Out_  DWORD *pdwVersion);
       
       END_INTERFACE
   } IRpcChannelBuffer2Vtbl;

   interface IRpcChannelBuffer2
   {
       CONST_VTBL struct IRpcChannelBuffer2Vtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IRpcChannelBuffer2_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IRpcChannelBuffer2_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IRpcChannelBuffer2_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IRpcChannelBuffer2_GetBuffer(This,pMessage,riid)	\
   ( (This)->lpVtbl -> GetBuffer(This,pMessage,riid) ) 

#define IRpcChannelBuffer2_SendReceive(This,pMessage,pStatus)	\
   ( (This)->lpVtbl -> SendReceive(This,pMessage,pStatus) ) 

#define IRpcChannelBuffer2_FreeBuffer(This,pMessage)	\
   ( (This)->lpVtbl -> FreeBuffer(This,pMessage) ) 

#define IRpcChannelBuffer2_GetDestCtx(This,pdwDestContext,ppvDestContext)	\
   ( (This)->lpVtbl -> GetDestCtx(This,pdwDestContext,ppvDestContext) ) 

#define IRpcChannelBuffer2_IsConnected(This)	\
   ( (This)->lpVtbl -> IsConnected(This) ) 


#define IRpcChannelBuffer2_GetProtocolVersion(This,pdwVersion)	\
   ( (This)->lpVtbl -> GetProtocolVersion(This,pdwVersion) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IRpcChannelBuffer2_INTERFACE_DEFINED__ */


if not __IAsyncRpcChannelBuffer_INTERFACE_DEFINED__
#define __IAsyncRpcChannelBuffer_INTERFACE_DEFINED__

/* interface IAsyncRpcChannelBuffer */
/* [unique][uuid][object][local] */ 


EXTERN_C const IID IID_IAsyncRpcChannelBuffer;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("a5029fb6-3c34-11d1-9c99-00c04fb998aa")
   IAsyncRpcChannelBuffer : public IRpcChannelBuffer2
   {
   public:
       virtual HRESULT __stdcall Send( 
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMsg,
            
             ISynchronize *pSync,
           /* [annotation][out] */ 
           _Out_  ULONG *pulStatus) = 0;
       
       virtual HRESULT __stdcall Receive( 
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMsg,
           /* [annotation][out] */ 
           _Out_  ULONG *pulStatus) = 0;
       
       virtual HRESULT __stdcall GetDestCtxEx( 
            
             RPCOLEMESSAGE *pMsg,
           /* [annotation][out] */ 
           _Out_  DWORD *pdwDestContext,
           /* [annotation][out] */ 
           _Outptr_opt_result_maybenull_  void **ppvDestContext) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IAsyncRpcChannelBufferVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IAsyncRpcChannelBuffer * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IAsyncRpcChannelBuffer * This);
       
       ULONG ( __stdcall *Release )( 
           IAsyncRpcChannelBuffer * This);
       
       HRESULT ( __stdcall *GetBuffer )( 
           IAsyncRpcChannelBuffer * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMessage,
            
             REFIID riid);
       
       HRESULT ( __stdcall *SendReceive )( 
           IAsyncRpcChannelBuffer * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMessage,
           /* [annotation][out] */ 
             ULONG *pStatus);
       
       HRESULT ( __stdcall *FreeBuffer )( 
           IAsyncRpcChannelBuffer * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMessage);
       
       HRESULT ( __stdcall *GetDestCtx )( 
           IAsyncRpcChannelBuffer * This,
           /* [annotation][out] */ 
           _Out_  DWORD *pdwDestContext,
           /* [annotation][out] */ 
           _Outptr_result_maybenull_  void **ppvDestContext);
       
       HRESULT ( __stdcall *IsConnected )( 
           IAsyncRpcChannelBuffer * This);
       
       HRESULT ( __stdcall *GetProtocolVersion )( 
           IAsyncRpcChannelBuffer * This,
           /* [annotation][out] */ 
           _Out_  DWORD *pdwVersion);
       
       HRESULT ( __stdcall *Send )( 
           IAsyncRpcChannelBuffer * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMsg,
            
             ISynchronize *pSync,
           /* [annotation][out] */ 
           _Out_  ULONG *pulStatus);
       
       HRESULT ( __stdcall *Receive )( 
           IAsyncRpcChannelBuffer * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMsg,
           /* [annotation][out] */ 
           _Out_  ULONG *pulStatus);
       
       HRESULT ( __stdcall *GetDestCtxEx )( 
           IAsyncRpcChannelBuffer * This,
            
             RPCOLEMESSAGE *pMsg,
           /* [annotation][out] */ 
           _Out_  DWORD *pdwDestContext,
           /* [annotation][out] */ 
           _Outptr_opt_result_maybenull_  void **ppvDestContext);
       
       END_INTERFACE
   } IAsyncRpcChannelBufferVtbl;

   interface IAsyncRpcChannelBuffer
   {
       CONST_VTBL struct IAsyncRpcChannelBufferVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IAsyncRpcChannelBuffer_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IAsyncRpcChannelBuffer_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IAsyncRpcChannelBuffer_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IAsyncRpcChannelBuffer_GetBuffer(This,pMessage,riid)	\
   ( (This)->lpVtbl -> GetBuffer(This,pMessage,riid) ) 

#define IAsyncRpcChannelBuffer_SendReceive(This,pMessage,pStatus)	\
   ( (This)->lpVtbl -> SendReceive(This,pMessage,pStatus) ) 

#define IAsyncRpcChannelBuffer_FreeBuffer(This,pMessage)	\
   ( (This)->lpVtbl -> FreeBuffer(This,pMessage) ) 

#define IAsyncRpcChannelBuffer_GetDestCtx(This,pdwDestContext,ppvDestContext)	\
   ( (This)->lpVtbl -> GetDestCtx(This,pdwDestContext,ppvDestContext) ) 

#define IAsyncRpcChannelBuffer_IsConnected(This)	\
   ( (This)->lpVtbl -> IsConnected(This) ) 


#define IAsyncRpcChannelBuffer_GetProtocolVersion(This,pdwVersion)	\
   ( (This)->lpVtbl -> GetProtocolVersion(This,pdwVersion) ) 


#define IAsyncRpcChannelBuffer_Send(This,pMsg,pSync,pulStatus)	\
   ( (This)->lpVtbl -> Send(This,pMsg,pSync,pulStatus) ) 

#define IAsyncRpcChannelBuffer_Receive(This,pMsg,pulStatus)	\
   ( (This)->lpVtbl -> Receive(This,pMsg,pulStatus) ) 

#define IAsyncRpcChannelBuffer_GetDestCtxEx(This,pMsg,pdwDestContext,ppvDestContext)	\
   ( (This)->lpVtbl -> GetDestCtxEx(This,pMsg,pdwDestContext,ppvDestContext) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IAsyncRpcChannelBuffer_INTERFACE_DEFINED__ */


if not __IRpcChannelBuffer3_INTERFACE_DEFINED__
#define __IRpcChannelBuffer3_INTERFACE_DEFINED__

/* interface IRpcChannelBuffer3 */
/* [uuid][object][local] */ 


EXTERN_C const IID IID_IRpcChannelBuffer3;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("25B15600-0115-11d0-BF0D-00AA00B8DFD2")
   IRpcChannelBuffer3 : public IRpcChannelBuffer2
   {
   public:
       virtual HRESULT __stdcall Send( 
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMsg,
           /* [annotation][out] */ 
           _Out_  ULONG *pulStatus) = 0;
       
       virtual HRESULT __stdcall Receive( 
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMsg,
            
             ULONG ulSize,
           /* [annotation][out] */ 
           _Out_  ULONG *pulStatus) = 0;
       
       virtual HRESULT __stdcall Cancel( 
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMsg) = 0;
       
       virtual HRESULT __stdcall GetCallContext( 
            
             RPCOLEMESSAGE *pMsg,
            
             REFIID riid,
           /* [annotation][out] */ 
           _Outptr_  void **pInterface) = 0;
       
       virtual HRESULT __stdcall GetDestCtxEx( 
            
             RPCOLEMESSAGE *pMsg,
           /* [annotation][out] */ 
           _Out_  DWORD *pdwDestContext,
           /* [annotation][out] */ 
           _Outptr_opt_result_maybenull_  void **ppvDestContext) = 0;
       
       virtual HRESULT __stdcall GetState( 
            
             RPCOLEMESSAGE *pMsg,
           /* [annotation][out] */ 
           _Out_  DWORD *pState) = 0;
       
       virtual HRESULT __stdcall RegisterAsync( 
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMsg,
            
             IAsyncManager *pAsyncMgr) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IRpcChannelBuffer3Vtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IRpcChannelBuffer3 * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IRpcChannelBuffer3 * This);
       
       ULONG ( __stdcall *Release )( 
           IRpcChannelBuffer3 * This);
       
       HRESULT ( __stdcall *GetBuffer )( 
           IRpcChannelBuffer3 * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMessage,
            
             REFIID riid);
       
       HRESULT ( __stdcall *SendReceive )( 
           IRpcChannelBuffer3 * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMessage,
           /* [annotation][out] */ 
             ULONG *pStatus);
       
       HRESULT ( __stdcall *FreeBuffer )( 
           IRpcChannelBuffer3 * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMessage);
       
       HRESULT ( __stdcall *GetDestCtx )( 
           IRpcChannelBuffer3 * This,
           /* [annotation][out] */ 
           _Out_  DWORD *pdwDestContext,
           /* [annotation][out] */ 
           _Outptr_result_maybenull_  void **ppvDestContext);
       
       HRESULT ( __stdcall *IsConnected )( 
           IRpcChannelBuffer3 * This);
       
       HRESULT ( __stdcall *GetProtocolVersion )( 
           IRpcChannelBuffer3 * This,
           /* [annotation][out] */ 
           _Out_  DWORD *pdwVersion);
       
       HRESULT ( __stdcall *Send )( 
           IRpcChannelBuffer3 * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMsg,
           /* [annotation][out] */ 
           _Out_  ULONG *pulStatus);
       
       HRESULT ( __stdcall *Receive )( 
           IRpcChannelBuffer3 * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMsg,
            
             ULONG ulSize,
           /* [annotation][out] */ 
           _Out_  ULONG *pulStatus);
       
       HRESULT ( __stdcall *Cancel )( 
           IRpcChannelBuffer3 * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMsg);
       
       HRESULT ( __stdcall *GetCallContext )( 
           IRpcChannelBuffer3 * This,
            
             RPCOLEMESSAGE *pMsg,
            
             REFIID riid,
           /* [annotation][out] */ 
           _Outptr_  void **pInterface);
       
       HRESULT ( __stdcall *GetDestCtxEx )( 
           IRpcChannelBuffer3 * This,
            
             RPCOLEMESSAGE *pMsg,
           /* [annotation][out] */ 
           _Out_  DWORD *pdwDestContext,
           /* [annotation][out] */ 
           _Outptr_opt_result_maybenull_  void **ppvDestContext);
       
       HRESULT ( __stdcall *GetState )( 
           IRpcChannelBuffer3 * This,
            
             RPCOLEMESSAGE *pMsg,
           /* [annotation][out] */ 
           _Out_  DWORD *pState);
       
       HRESULT ( __stdcall *RegisterAsync )( 
           IRpcChannelBuffer3 * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMsg,
            
             IAsyncManager *pAsyncMgr);
       
       END_INTERFACE
   } IRpcChannelBuffer3Vtbl;

   interface IRpcChannelBuffer3
   {
       CONST_VTBL struct IRpcChannelBuffer3Vtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IRpcChannelBuffer3_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IRpcChannelBuffer3_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IRpcChannelBuffer3_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IRpcChannelBuffer3_GetBuffer(This,pMessage,riid)	\
   ( (This)->lpVtbl -> GetBuffer(This,pMessage,riid) ) 

#define IRpcChannelBuffer3_SendReceive(This,pMessage,pStatus)	\
   ( (This)->lpVtbl -> SendReceive(This,pMessage,pStatus) ) 

#define IRpcChannelBuffer3_FreeBuffer(This,pMessage)	\
   ( (This)->lpVtbl -> FreeBuffer(This,pMessage) ) 

#define IRpcChannelBuffer3_GetDestCtx(This,pdwDestContext,ppvDestContext)	\
   ( (This)->lpVtbl -> GetDestCtx(This,pdwDestContext,ppvDestContext) ) 

#define IRpcChannelBuffer3_IsConnected(This)	\
   ( (This)->lpVtbl -> IsConnected(This) ) 


#define IRpcChannelBuffer3_GetProtocolVersion(This,pdwVersion)	\
   ( (This)->lpVtbl -> GetProtocolVersion(This,pdwVersion) ) 


#define IRpcChannelBuffer3_Send(This,pMsg,pulStatus)	\
   ( (This)->lpVtbl -> Send(This,pMsg,pulStatus) ) 

#define IRpcChannelBuffer3_Receive(This,pMsg,ulSize,pulStatus)	\
   ( (This)->lpVtbl -> Receive(This,pMsg,ulSize,pulStatus) ) 

#define IRpcChannelBuffer3_Cancel(This,pMsg)	\
   ( (This)->lpVtbl -> Cancel(This,pMsg) ) 

#define IRpcChannelBuffer3_GetCallContext(This,pMsg,riid,pInterface)	\
   ( (This)->lpVtbl -> GetCallContext(This,pMsg,riid,pInterface) ) 

#define IRpcChannelBuffer3_GetDestCtxEx(This,pMsg,pdwDestContext,ppvDestContext)	\
   ( (This)->lpVtbl -> GetDestCtxEx(This,pMsg,pdwDestContext,ppvDestContext) ) 

#define IRpcChannelBuffer3_GetState(This,pMsg,pState)	\
   ( (This)->lpVtbl -> GetState(This,pMsg,pState) ) 

#define IRpcChannelBuffer3_RegisterAsync(This,pMsg,pAsyncMgr)	\
   ( (This)->lpVtbl -> RegisterAsync(This,pMsg,pAsyncMgr) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IRpcChannelBuffer3_INTERFACE_DEFINED__ */


if not __IRpcSyntaxNegotiate_INTERFACE_DEFINED__
#define __IRpcSyntaxNegotiate_INTERFACE_DEFINED__

/* interface IRpcSyntaxNegotiate */
/* [uuid][object][local] */ 


EXTERN_C const IID IID_IRpcSyntaxNegotiate;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("58a08519-24c8-4935-b482-3fd823333a4f")
   IRpcSyntaxNegotiate : public IUnknown
   {
   public:
       virtual HRESULT __stdcall NegotiateSyntax( 
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMsg) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IRpcSyntaxNegotiateVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IRpcSyntaxNegotiate * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IRpcSyntaxNegotiate * This);
       
       ULONG ( __stdcall *Release )( 
           IRpcSyntaxNegotiate * This);
       
       HRESULT ( __stdcall *NegotiateSyntax )( 
           IRpcSyntaxNegotiate * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMsg);
       
       END_INTERFACE
   } IRpcSyntaxNegotiateVtbl;

   interface IRpcSyntaxNegotiate
   {
       CONST_VTBL struct IRpcSyntaxNegotiateVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IRpcSyntaxNegotiate_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IRpcSyntaxNegotiate_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IRpcSyntaxNegotiate_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IRpcSyntaxNegotiate_NegotiateSyntax(This,pMsg)	\
   ( (This)->lpVtbl -> NegotiateSyntax(This,pMsg) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IRpcSyntaxNegotiate_INTERFACE_DEFINED__ */


if not __IRpcProxyBuffer_INTERFACE_DEFINED__
#define __IRpcProxyBuffer_INTERFACE_DEFINED__

/* interface IRpcProxyBuffer */
/* [uuid][object][local] */ 


EXTERN_C const IID IID_IRpcProxyBuffer;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("D5F56A34-593B-101A-B569-08002B2DBF7A")
   IRpcProxyBuffer : public IUnknown
   {
   public:
       virtual HRESULT __stdcall Connect( 
            
             IRpcChannelBuffer *pRpcChannelBuffer) = 0;
       
       virtual void __stdcall Disconnect( void) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IRpcProxyBufferVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IRpcProxyBuffer * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IRpcProxyBuffer * This);
       
       ULONG ( __stdcall *Release )( 
           IRpcProxyBuffer * This);
       
       HRESULT ( __stdcall *Connect )( 
           IRpcProxyBuffer * This,
            
             IRpcChannelBuffer *pRpcChannelBuffer);
       
       void ( __stdcall *Disconnect )( 
           IRpcProxyBuffer * This);
       
       END_INTERFACE
   } IRpcProxyBufferVtbl;

   interface IRpcProxyBuffer
   {
       CONST_VTBL struct IRpcProxyBufferVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IRpcProxyBuffer_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IRpcProxyBuffer_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IRpcProxyBuffer_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IRpcProxyBuffer_Connect(This,pRpcChannelBuffer)	\
   ( (This)->lpVtbl -> Connect(This,pRpcChannelBuffer) ) 

#define IRpcProxyBuffer_Disconnect(This)	\
   ( (This)->lpVtbl -> Disconnect(This) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IRpcProxyBuffer_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_objidlbase_0000_0020 */
 

end /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#pragma region Application Family or OneCore Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0020_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0020_v0_0_s_ifspec;

if not __IRpcStubBuffer_INTERFACE_DEFINED__
#define __IRpcStubBuffer_INTERFACE_DEFINED__

/* interface IRpcStubBuffer */
/* [uuid][object][local] */ 


EXTERN_C const IID IID_IRpcStubBuffer;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("D5F56AFC-593B-101A-B569-08002B2DBF7A")
   IRpcStubBuffer : public IUnknown
   {
   public:
       virtual HRESULT __stdcall Connect( 
            
             IUnknown *pUnkServer) = 0;
       
       virtual void __stdcall Disconnect( void) = 0;
       
       virtual HRESULT __stdcall Invoke( 
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *_prpcmsg,
            
             IRpcChannelBuffer *_pRpcChannelBuffer) = 0;
       
       virtual IRpcStubBuffer *__stdcall IsIIDSupported( 
            
             REFIID riid) = 0;
       
       virtual ULONG __stdcall CountRefs( void) = 0;
       
       virtual HRESULT __stdcall DebugServerQueryInterface( 
           /* [annotation][out] */ 
           _Outptr_  void **ppv) = 0;
       
       virtual void __stdcall DebugServerRelease( 
            
             void *pv) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IRpcStubBufferVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IRpcStubBuffer * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IRpcStubBuffer * This);
       
       ULONG ( __stdcall *Release )( 
           IRpcStubBuffer * This);
       
       HRESULT ( __stdcall *Connect )( 
           IRpcStubBuffer * This,
            
             IUnknown *pUnkServer);
       
       void ( __stdcall *Disconnect )( 
           IRpcStubBuffer * This);
       
       HRESULT ( __stdcall *Invoke )( 
           IRpcStubBuffer * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *_prpcmsg,
            
             IRpcChannelBuffer *_pRpcChannelBuffer);
       
       IRpcStubBuffer *( __stdcall *IsIIDSupported )( 
           IRpcStubBuffer * This,
            
             REFIID riid);
       
       ULONG ( __stdcall *CountRefs )( 
           IRpcStubBuffer * This);
       
       HRESULT ( __stdcall *DebugServerQueryInterface )( 
           IRpcStubBuffer * This,
           /* [annotation][out] */ 
           _Outptr_  void **ppv);
       
       void ( __stdcall *DebugServerRelease )( 
           IRpcStubBuffer * This,
            
             void *pv);
       
       END_INTERFACE
   } IRpcStubBufferVtbl;

   interface IRpcStubBuffer
   {
       CONST_VTBL struct IRpcStubBufferVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IRpcStubBuffer_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IRpcStubBuffer_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IRpcStubBuffer_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IRpcStubBuffer_Connect(This,pUnkServer)	\
   ( (This)->lpVtbl -> Connect(This,pUnkServer) ) 

#define IRpcStubBuffer_Disconnect(This)	\
   ( (This)->lpVtbl -> Disconnect(This) ) 

#define IRpcStubBuffer_Invoke(This,_prpcmsg,_pRpcChannelBuffer)	\
   ( (This)->lpVtbl -> Invoke(This,_prpcmsg,_pRpcChannelBuffer) ) 

#define IRpcStubBuffer_IsIIDSupported(This,riid)	\
   ( (This)->lpVtbl -> IsIIDSupported(This,riid) ) 

#define IRpcStubBuffer_CountRefs(This)	\
   ( (This)->lpVtbl -> CountRefs(This) ) 

#define IRpcStubBuffer_DebugServerQueryInterface(This,ppv)	\
   ( (This)->lpVtbl -> DebugServerQueryInterface(This,ppv) ) 

#define IRpcStubBuffer_DebugServerRelease(This,pv)	\
   ( (This)->lpVtbl -> DebugServerRelease(This,pv) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IRpcStubBuffer_INTERFACE_DEFINED__ */


if not __IPSFactoryBuffer_INTERFACE_DEFINED__
#define __IPSFactoryBuffer_INTERFACE_DEFINED__

/* interface IPSFactoryBuffer */
/* [uuid][object][local] */ 


EXTERN_C const IID IID_IPSFactoryBuffer;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("D5F569D0-593B-101A-B569-08002B2DBF7A")
   IPSFactoryBuffer : public IUnknown
   {
   public:
       virtual HRESULT __stdcall CreateProxy( 
            
             IUnknown *pUnkOuter,
            
             REFIID riid,
           /* [annotation][out] */ 
           _Outptr_  IRpcProxyBuffer **ppProxy,
           /* [annotation][out] */ 
           _Outptr_  void **ppv) = 0;
       
       virtual HRESULT __stdcall CreateStub( 
            
             REFIID riid,
            
             IUnknown *pUnkServer,
           /* [annotation][out] */ 
           _Outptr_  IRpcStubBuffer **ppStub) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IPSFactoryBufferVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IPSFactoryBuffer * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IPSFactoryBuffer * This);
       
       ULONG ( __stdcall *Release )( 
           IPSFactoryBuffer * This);
       
       HRESULT ( __stdcall *CreateProxy )( 
           IPSFactoryBuffer * This,
            
             IUnknown *pUnkOuter,
            
             REFIID riid,
           /* [annotation][out] */ 
           _Outptr_  IRpcProxyBuffer **ppProxy,
           /* [annotation][out] */ 
           _Outptr_  void **ppv);
       
       HRESULT ( __stdcall *CreateStub )( 
           IPSFactoryBuffer * This,
            
             REFIID riid,
            
             IUnknown *pUnkServer,
           /* [annotation][out] */ 
           _Outptr_  IRpcStubBuffer **ppStub);
       
       END_INTERFACE
   } IPSFactoryBufferVtbl;

   interface IPSFactoryBuffer
   {
       CONST_VTBL struct IPSFactoryBufferVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IPSFactoryBuffer_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IPSFactoryBuffer_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IPSFactoryBuffer_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IPSFactoryBuffer_CreateProxy(This,pUnkOuter,riid,ppProxy,ppv)	\
   ( (This)->lpVtbl -> CreateProxy(This,pUnkOuter,riid,ppProxy,ppv) ) 

#define IPSFactoryBuffer_CreateStub(This,riid,pUnkServer,ppStub)	\
   ( (This)->lpVtbl -> CreateStub(This,riid,pUnkServer,ppStub) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IPSFactoryBuffer_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_objidlbase_0000_0022 */
 

end /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)
#if  (_WIN32_WINNT >= 0x0400 ) || defined(_WIN32_DCOM) // DCOM
// This interface is only valid on Windows NT 4.0
typedef struct SChannelHookCallInfo
   {
   IID iid;
   DWORD cbSize;
   GUID uCausality;
   DWORD dwServerPid;
   DWORD iMethod;
   void *pObject;
   } 	SChannelHookCallInfo;



extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0022_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0022_v0_0_s_ifspec;

if not __IChannelHook_INTERFACE_DEFINED__
#define __IChannelHook_INTERFACE_DEFINED__

/* interface IChannelHook */
/* [uuid][object][local] */ 


EXTERN_C const IID IID_IChannelHook;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("1008c4a0-7613-11cf-9af1-0020af6e72f4")
   IChannelHook : public IUnknown
   {
   public:
       virtual void __stdcall ClientGetSize( 
            
             REFGUID uExtent,
            
             REFIID riid,
           /* [annotation][out] */ 
           _Out_  ULONG *pDataSize) = 0;
       
       virtual void __stdcall ClientFillBuffer( 
            
             REFGUID uExtent,
            
             REFIID riid,
           /* [annotation][out][in] */ 
           _Inout_  ULONG *pDataSize,
            
             void *pDataBuffer) = 0;
       
       virtual void __stdcall ClientNotify( 
            
             REFGUID uExtent,
            
             REFIID riid,
            
             ULONG cbDataSize,
            
             void *pDataBuffer,
            
             DWORD lDataRep,
            
             HRESULT hrFault) = 0;
       
       virtual void __stdcall ServerNotify( 
            
             REFGUID uExtent,
            
             REFIID riid,
            
             ULONG cbDataSize,
            
             void *pDataBuffer,
            
             DWORD lDataRep) = 0;
       
       virtual void __stdcall ServerGetSize( 
            
             REFGUID uExtent,
            
             REFIID riid,
            
             HRESULT hrFault,
           /* [annotation][out] */ 
           _Out_  ULONG *pDataSize) = 0;
       
       virtual void __stdcall ServerFillBuffer( 
            
             REFGUID uExtent,
            
             REFIID riid,
           /* [annotation][out][in] */ 
           _Inout_  ULONG *pDataSize,
            
             void *pDataBuffer,
            
             HRESULT hrFault) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IChannelHookVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IChannelHook * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IChannelHook * This);
       
       ULONG ( __stdcall *Release )( 
           IChannelHook * This);
       
       void ( __stdcall *ClientGetSize )( 
           IChannelHook * This,
            
             REFGUID uExtent,
            
             REFIID riid,
           /* [annotation][out] */ 
           _Out_  ULONG *pDataSize);
       
       void ( __stdcall *ClientFillBuffer )( 
           IChannelHook * This,
            
             REFGUID uExtent,
            
             REFIID riid,
           /* [annotation][out][in] */ 
           _Inout_  ULONG *pDataSize,
            
             void *pDataBuffer);
       
       void ( __stdcall *ClientNotify )( 
           IChannelHook * This,
            
             REFGUID uExtent,
            
             REFIID riid,
            
             ULONG cbDataSize,
            
             void *pDataBuffer,
            
             DWORD lDataRep,
            
             HRESULT hrFault);
       
       void ( __stdcall *ServerNotify )( 
           IChannelHook * This,
            
             REFGUID uExtent,
            
             REFIID riid,
            
             ULONG cbDataSize,
            
             void *pDataBuffer,
            
             DWORD lDataRep);
       
       void ( __stdcall *ServerGetSize )( 
           IChannelHook * This,
            
             REFGUID uExtent,
            
             REFIID riid,
            
             HRESULT hrFault,
           /* [annotation][out] */ 
           _Out_  ULONG *pDataSize);
       
       void ( __stdcall *ServerFillBuffer )( 
           IChannelHook * This,
            
             REFGUID uExtent,
            
             REFIID riid,
           /* [annotation][out][in] */ 
           _Inout_  ULONG *pDataSize,
            
             void *pDataBuffer,
            
             HRESULT hrFault);
       
       END_INTERFACE
   } IChannelHookVtbl;

   interface IChannelHook
   {
       CONST_VTBL struct IChannelHookVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IChannelHook_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IChannelHook_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IChannelHook_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IChannelHook_ClientGetSize(This,uExtent,riid,pDataSize)	\
   ( (This)->lpVtbl -> ClientGetSize(This,uExtent,riid,pDataSize) ) 

#define IChannelHook_ClientFillBuffer(This,uExtent,riid,pDataSize,pDataBuffer)	\
   ( (This)->lpVtbl -> ClientFillBuffer(This,uExtent,riid,pDataSize,pDataBuffer) ) 

#define IChannelHook_ClientNotify(This,uExtent,riid,cbDataSize,pDataBuffer,lDataRep,hrFault)	\
   ( (This)->lpVtbl -> ClientNotify(This,uExtent,riid,cbDataSize,pDataBuffer,lDataRep,hrFault) ) 

#define IChannelHook_ServerNotify(This,uExtent,riid,cbDataSize,pDataBuffer,lDataRep)	\
   ( (This)->lpVtbl -> ServerNotify(This,uExtent,riid,cbDataSize,pDataBuffer,lDataRep) ) 

#define IChannelHook_ServerGetSize(This,uExtent,riid,hrFault,pDataSize)	\
   ( (This)->lpVtbl -> ServerGetSize(This,uExtent,riid,hrFault,pDataSize) ) 

#define IChannelHook_ServerFillBuffer(This,uExtent,riid,pDataSize,pDataBuffer,hrFault)	\
   ( (This)->lpVtbl -> ServerFillBuffer(This,uExtent,riid,pDataSize,pDataBuffer,hrFault) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IChannelHook_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_objidlbase_0000_0023 */
 

end //DCOM
end /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#if  (_WIN32_WINNT >= 0x0400 ) || defined(_WIN32_DCOM) // DCOM
// This interface is only valid on Windows NT 4.0
#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0023_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0023_v0_0_s_ifspec;

if not __IClientSecurity_INTERFACE_DEFINED__
#define __IClientSecurity_INTERFACE_DEFINED__

/* interface IClientSecurity */
/* [uuid][object][local] */ 

typedef struct tagSOLE_AUTHENTICATION_SERVICE
   {
   DWORD dwAuthnSvc;
   DWORD dwAuthzSvc;
   OLECHAR *pPrincipalName;
   HRESULT hr;
   } 	SOLE_AUTHENTICATION_SERVICE;

typedef SOLE_AUTHENTICATION_SERVICE *PSOLE_AUTHENTICATION_SERVICE;

typedef 
enum tagEOLE_AUTHENTICATION_CAPABILITIES
   {
       EOAC_NONE	= 0,
       EOAC_MUTUAL_AUTH	= 0x1,
       EOAC_STATIC_CLOAKING	= 0x20,
       EOAC_DYNAMIC_CLOAKING	= 0x40,
       EOAC_ANY_AUTHORITY	= 0x80,
       EOAC_MAKE_FULLSIC	= 0x100,
       EOAC_DEFAULT	= 0x800,
       EOAC_SECURE_REFS	= 0x2,
       EOAC_ACCESS_CONTROL	= 0x4,
       EOAC_APPID	= 0x8,
       EOAC_DYNAMIC	= 0x10,
       EOAC_REQUIRE_FULLSIC	= 0x200,
       EOAC_AUTO_IMPERSONATE	= 0x400,
       EOAC_DISABLE_AAA	= 0x1000,
       EOAC_NO_CUSTOM_MARSHAL	= 0x2000,
       EOAC_RESERVED1	= 0x4000
   } 	EOLE_AUTHENTICATION_CAPABILITIES;

#define	COLE_DEFAULT_PRINCIPAL	( ( OLECHAR * )( INT_PTR  )-1 )

#define	COLE_DEFAULT_AUTHINFO	( ( void * )( INT_PTR  )-1 )

typedef struct tagSOLE_AUTHENTICATION_INFO
   {
   DWORD dwAuthnSvc;
   DWORD dwAuthzSvc;
   void *pAuthInfo;
   } 	SOLE_AUTHENTICATION_INFO;

typedef struct tagSOLE_AUTHENTICATION_INFO *PSOLE_AUTHENTICATION_INFO;

typedef struct tagSOLE_AUTHENTICATION_LIST
   {
   DWORD cAuthInfo;
   SOLE_AUTHENTICATION_INFO *aAuthInfo;
   } 	SOLE_AUTHENTICATION_LIST;

typedef struct tagSOLE_AUTHENTICATION_LIST *PSOLE_AUTHENTICATION_LIST;


EXTERN_C const IID IID_IClientSecurity;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("0000013D-0000-0000-C000-000000000046")
   IClientSecurity : public IUnknown
   {
   public:
       virtual HRESULT __stdcall QueryBlanket( 
            
             IUnknown *pProxy,
           /* [annotation][out] */ 
           _Out_  DWORD *pAuthnSvc,
           /* [annotation][out] */ 
             DWORD *pAuthzSvc,
           /* [annotation][out] */ 
             OLECHAR **pServerPrincName,
           /* [annotation][out] */ 
             DWORD *pAuthnLevel,
           /* [annotation][out] */ 
             DWORD *pImpLevel,
           /* [annotation][out] */ 
           _Outptr_result_maybenull_  void **pAuthInfo,
           /* [annotation][out] */ 
             DWORD *pCapabilites) = 0;
       
       virtual HRESULT __stdcall SetBlanket( 
            
             IUnknown *pProxy,
            
             DWORD dwAuthnSvc,
            
             DWORD dwAuthzSvc,
            
             OLECHAR *pServerPrincName,
            
             DWORD dwAuthnLevel,
            
             DWORD dwImpLevel,
            
             void *pAuthInfo,
            
             DWORD dwCapabilities) = 0;
       
       virtual HRESULT __stdcall CopyProxy( 
            
             IUnknown *pProxy,
           /* [annotation][out] */ 
           _Outptr_  IUnknown **ppCopy) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IClientSecurityVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IClientSecurity * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IClientSecurity * This);
       
       ULONG ( __stdcall *Release )( 
           IClientSecurity * This);
       
       HRESULT ( __stdcall *QueryBlanket )( 
           IClientSecurity * This,
            
             IUnknown *pProxy,
           /* [annotation][out] */ 
           _Out_  DWORD *pAuthnSvc,
           /* [annotation][out] */ 
             DWORD *pAuthzSvc,
           /* [annotation][out] */ 
             OLECHAR **pServerPrincName,
           /* [annotation][out] */ 
             DWORD *pAuthnLevel,
           /* [annotation][out] */ 
             DWORD *pImpLevel,
           /* [annotation][out] */ 
           _Outptr_result_maybenull_  void **pAuthInfo,
           /* [annotation][out] */ 
             DWORD *pCapabilites);
       
       HRESULT ( __stdcall *SetBlanket )( 
           IClientSecurity * This,
            
             IUnknown *pProxy,
            
             DWORD dwAuthnSvc,
            
             DWORD dwAuthzSvc,
            
             OLECHAR *pServerPrincName,
            
             DWORD dwAuthnLevel,
            
             DWORD dwImpLevel,
            
             void *pAuthInfo,
            
             DWORD dwCapabilities);
       
       HRESULT ( __stdcall *CopyProxy )( 
           IClientSecurity * This,
            
             IUnknown *pProxy,
           /* [annotation][out] */ 
           _Outptr_  IUnknown **ppCopy);
       
       END_INTERFACE
   } IClientSecurityVtbl;

   interface IClientSecurity
   {
       CONST_VTBL struct IClientSecurityVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IClientSecurity_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IClientSecurity_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IClientSecurity_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IClientSecurity_QueryBlanket(This,pProxy,pAuthnSvc,pAuthzSvc,pServerPrincName,pAuthnLevel,pImpLevel,pAuthInfo,pCapabilites)	\
   ( (This)->lpVtbl -> QueryBlanket(This,pProxy,pAuthnSvc,pAuthzSvc,pServerPrincName,pAuthnLevel,pImpLevel,pAuthInfo,pCapabilites) ) 

#define IClientSecurity_SetBlanket(This,pProxy,dwAuthnSvc,dwAuthzSvc,pServerPrincName,dwAuthnLevel,dwImpLevel,pAuthInfo,dwCapabilities)	\
   ( (This)->lpVtbl -> SetBlanket(This,pProxy,dwAuthnSvc,dwAuthzSvc,pServerPrincName,dwAuthnLevel,dwImpLevel,pAuthInfo,dwCapabilities) ) 

#define IClientSecurity_CopyProxy(This,pProxy,ppCopy)	\
   ( (This)->lpVtbl -> CopyProxy(This,pProxy,ppCopy) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IClientSecurity_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_objidlbase_0000_0024 */
 

end /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0024_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0024_v0_0_s_ifspec;

if not __IServerSecurity_INTERFACE_DEFINED__
#define __IServerSecurity_INTERFACE_DEFINED__

/* interface IServerSecurity */
/* [uuid][object][local] */ 


EXTERN_C const IID IID_IServerSecurity;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("0000013E-0000-0000-C000-000000000046")
   IServerSecurity : public IUnknown
   {
   public:
       virtual HRESULT __stdcall QueryBlanket( 
           /* [annotation][out] */ 
             DWORD *pAuthnSvc,
           /* [annotation][out] */ 
             DWORD *pAuthzSvc,
           /* [annotation][out] */ 
             OLECHAR **pServerPrincName,
           /* [annotation][out] */ 
             DWORD *pAuthnLevel,
           /* [annotation][out] */ 
             DWORD *pImpLevel,
           /* [annotation][out] */ 
           _Outptr_result_maybenull_  void **pPrivs,
           /* [annotation][out][in] */ 
           _Inout_opt_  DWORD *pCapabilities) = 0;
       
       virtual HRESULT __stdcall ImpersonateClient( void) = 0;
       
       virtual HRESULT __stdcall RevertToSelf( void) = 0;
       
       virtual BOOL __stdcall IsImpersonating( void) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IServerSecurityVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IServerSecurity * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IServerSecurity * This);
       
       ULONG ( __stdcall *Release )( 
           IServerSecurity * This);
       
       HRESULT ( __stdcall *QueryBlanket )( 
           IServerSecurity * This,
           /* [annotation][out] */ 
             DWORD *pAuthnSvc,
           /* [annotation][out] */ 
             DWORD *pAuthzSvc,
           /* [annotation][out] */ 
             OLECHAR **pServerPrincName,
           /* [annotation][out] */ 
             DWORD *pAuthnLevel,
           /* [annotation][out] */ 
             DWORD *pImpLevel,
           /* [annotation][out] */ 
           _Outptr_result_maybenull_  void **pPrivs,
           /* [annotation][out][in] */ 
           _Inout_opt_  DWORD *pCapabilities);
       
       HRESULT ( __stdcall *ImpersonateClient )( 
           IServerSecurity * This);
       
       HRESULT ( __stdcall *RevertToSelf )( 
           IServerSecurity * This);
       
       BOOL ( __stdcall *IsImpersonating )( 
           IServerSecurity * This);
       
       END_INTERFACE
   } IServerSecurityVtbl;

   interface IServerSecurity
   {
       CONST_VTBL struct IServerSecurityVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IServerSecurity_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IServerSecurity_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IServerSecurity_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IServerSecurity_QueryBlanket(This,pAuthnSvc,pAuthzSvc,pServerPrincName,pAuthnLevel,pImpLevel,pPrivs,pCapabilities)	\
   ( (This)->lpVtbl -> QueryBlanket(This,pAuthnSvc,pAuthzSvc,pServerPrincName,pAuthnLevel,pImpLevel,pPrivs,pCapabilities) ) 

#define IServerSecurity_ImpersonateClient(This)	\
   ( (This)->lpVtbl -> ImpersonateClient(This) ) 

#define IServerSecurity_RevertToSelf(This)	\
   ( (This)->lpVtbl -> RevertToSelf(This) ) 

#define IServerSecurity_IsImpersonating(This)	\
   ( (This)->lpVtbl -> IsImpersonating(This) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IServerSecurity_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_objidlbase_0000_0025 */
 

typedef 
enum tagRPCOPT_PROPERTIES
   {
       COMBND_RPCTIMEOUT	= 0x1,
       COMBND_SERVER_LOCALITY	= 0x2,
       COMBND_RESERVED1	= 0x4,
       COMBND_RESERVED2	= 0x5,
       COMBND_RESERVED3	= 0x8,
       COMBND_RESERVED4	= 0x10
   } 	RPCOPT_PROPERTIES;

typedef 
enum tagRPCOPT_SERVER_LOCALITY_VALUES
   {
       SERVER_LOCALITY_PROCESS_LOCAL	= 0,
       SERVER_LOCALITY_MACHINE_LOCAL	= 1,
       SERVER_LOCALITY_REMOTE	= 2
   } 	RPCOPT_SERVER_LOCALITY_VALUES;



extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0025_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0025_v0_0_s_ifspec;

if not __IRpcOptions_INTERFACE_DEFINED__
#define __IRpcOptions_INTERFACE_DEFINED__

/* interface IRpcOptions */
/* [uuid][local][object] */ 


EXTERN_C const IID IID_IRpcOptions;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000144-0000-0000-C000-000000000046")
   IRpcOptions : public IUnknown
   {
   public:
       virtual HRESULT __stdcall Set( 
            
             IUnknown *pPrx,
            
             RPCOPT_PROPERTIES dwProperty,
            
             ULONG_PTR dwValue) = 0;
       
       virtual HRESULT __stdcall Query( 
            
             IUnknown *pPrx,
            
             RPCOPT_PROPERTIES dwProperty,
           /* [annotation][out] */ 
           _Out_  ULONG_PTR *pdwValue) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IRpcOptionsVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IRpcOptions * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IRpcOptions * This);
       
       ULONG ( __stdcall *Release )( 
           IRpcOptions * This);
       
       HRESULT ( __stdcall *Set )( 
           IRpcOptions * This,
            
             IUnknown *pPrx,
            
             RPCOPT_PROPERTIES dwProperty,
            
             ULONG_PTR dwValue);
       
       HRESULT ( __stdcall *Query )( 
           IRpcOptions * This,
            
             IUnknown *pPrx,
            
             RPCOPT_PROPERTIES dwProperty,
           /* [annotation][out] */ 
           _Out_  ULONG_PTR *pdwValue);
       
       END_INTERFACE
   } IRpcOptionsVtbl;

   interface IRpcOptions
   {
       CONST_VTBL struct IRpcOptionsVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IRpcOptions_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IRpcOptions_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IRpcOptions_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IRpcOptions_Set(This,pPrx,dwProperty,dwValue)	\
   ( (This)->lpVtbl -> Set(This,pPrx,dwProperty,dwValue) ) 

#define IRpcOptions_Query(This,pPrx,dwProperty,pdwValue)	\
   ( (This)->lpVtbl -> Query(This,pPrx,dwProperty,pdwValue) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IRpcOptions_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_objidlbase_0000_0026 */
 

end /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)
typedef 
enum tagGLOBALOPT_PROPERTIES
   {
       COMGLB_EXCEPTION_HANDLING	= 1,
       COMGLB_APPID	= 2,
       COMGLB_RPC_THREADPOOL_SETTING	= 3,
       COMGLB_RO_SETTINGS	= 4,
       COMGLB_UNMARSHALING_POLICY	= 5,
       COMGLB_PROPERTIES_RESERVED1	= 6,
       COMGLB_PROPERTIES_RESERVED2	= 7
   } 	GLOBALOPT_PROPERTIES;

typedef 
enum tagGLOBALOPT_EH_VALUES
   {
       COMGLB_EXCEPTION_HANDLE	= 0,
       COMGLB_EXCEPTION_DONOT_HANDLE_FATAL	= 1,
       COMGLB_EXCEPTION_DONOT_HANDLE	= COMGLB_EXCEPTION_DONOT_HANDLE_FATAL,
       COMGLB_EXCEPTION_DONOT_HANDLE_ANY	= 2
   } 	GLOBALOPT_EH_VALUES;

typedef 
enum tagGLOBALOPT_RPCTP_VALUES
   {
       COMGLB_RPC_THREADPOOL_SETTING_DEFAULT_POOL	= 0,
       COMGLB_RPC_THREADPOOL_SETTING_PRIVATE_POOL	= 1
   } 	GLOBALOPT_RPCTP_VALUES;

typedef 
enum tagGLOBALOPT_RO_FLAGS
   {
       COMGLB_STA_MODALLOOP_REMOVE_TOUCH_MESSAGES	= 0x1,
       COMGLB_STA_MODALLOOP_SHARED_QUEUE_REMOVE_INPUT_MESSAGES	= 0x2,
       COMGLB_STA_MODALLOOP_SHARED_QUEUE_DONOT_REMOVE_INPUT_MESSAGES	= 0x4,
       COMGLB_FAST_RUNDOWN	= 0x8,
       COMGLB_RESERVED1	= 0x10,
       COMGLB_RESERVED2	= 0x20,
       COMGLB_RESERVED3	= 0x40,
       COMGLB_STA_MODALLOOP_SHARED_QUEUE_REORDER_POINTER_MESSAGES	= 0x80,
       COMGLB_RESERVED4	= 0x100,
       COMGLB_RESERVED5	= 0x200,
       COMGLB_RESERVED6	= 0x400
   } 	GLOBALOPT_RO_FLAGS;

typedef 
enum tagGLOBALOPT_UNMARSHALING_POLICY_VALUES
   {
       COMGLB_UNMARSHALING_POLICY_NORMAL	= 0,
       COMGLB_UNMARSHALING_POLICY_STRONG	= 1,
       COMGLB_UNMARSHALING_POLICY_HYBRID	= 2
   } 	GLOBALOPT_UNMARSHALING_POLICY_VALUES;



extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0026_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0026_v0_0_s_ifspec;

if not __IGlobalOptions_INTERFACE_DEFINED__
#define __IGlobalOptions_INTERFACE_DEFINED__

/* interface IGlobalOptions */
/* [uuid][unique][local][object] */ 


EXTERN_C const IID IID_IGlobalOptions;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("0000015B-0000-0000-C000-000000000046")
   IGlobalOptions : public IUnknown
   {
   public:
       virtual HRESULT __stdcall Set( 
            
             GLOBALOPT_PROPERTIES dwProperty,
            
             ULONG_PTR dwValue) = 0;
       
       virtual HRESULT __stdcall Query( 
            
             GLOBALOPT_PROPERTIES dwProperty,
           /* [annotation][out] */ 
           _Out_  ULONG_PTR *pdwValue) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IGlobalOptionsVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IGlobalOptions * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IGlobalOptions * This);
       
       ULONG ( __stdcall *Release )( 
           IGlobalOptions * This);
       
       HRESULT ( __stdcall *Set )( 
           IGlobalOptions * This,
            
             GLOBALOPT_PROPERTIES dwProperty,
            
             ULONG_PTR dwValue);
       
       HRESULT ( __stdcall *Query )( 
           IGlobalOptions * This,
            
             GLOBALOPT_PROPERTIES dwProperty,
           /* [annotation][out] */ 
           _Out_  ULONG_PTR *pdwValue);
       
       END_INTERFACE
   } IGlobalOptionsVtbl;

   interface IGlobalOptions
   {
       CONST_VTBL struct IGlobalOptionsVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IGlobalOptions_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IGlobalOptions_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IGlobalOptions_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IGlobalOptions_Set(This,dwProperty,dwValue)	\
   ( (This)->lpVtbl -> Set(This,dwProperty,dwValue) ) 

#define IGlobalOptions_Query(This,dwProperty,pdwValue)	\
   ( (This)->lpVtbl -> Query(This,dwProperty,pdwValue) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IGlobalOptions_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_objidlbase_0000_0027 */
 

end /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
end //DCOM
#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0027_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0027_v0_0_s_ifspec;

if not __ISurrogate_INTERFACE_DEFINED__
#define __ISurrogate_INTERFACE_DEFINED__

/* interface ISurrogate */
/* [object][unique][version][uuid] */ 

typedef    ISurrogate *LPSURROGATE;


EXTERN_C const IID IID_ISurrogate;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000022-0000-0000-C000-000000000046")
   ISurrogate : public IUnknown
   {
   public:
       virtual HRESULT __stdcall LoadDllServer( 
             REFCLSID Clsid) = 0;
       
       virtual HRESULT __stdcall FreeSurrogate( void) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct ISurrogateVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
            ISurrogate * This,
             REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
            ISurrogate * This);
       
       ULONG ( __stdcall *Release )( 
            ISurrogate * This);
       
       HRESULT ( __stdcall *LoadDllServer )( 
            ISurrogate * This,
             REFCLSID Clsid);
       
       HRESULT ( __stdcall *FreeSurrogate )( 
            ISurrogate * This);
       
       END_INTERFACE
   } ISurrogateVtbl;

   interface ISurrogate
   {
       CONST_VTBL struct ISurrogateVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define ISurrogate_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define ISurrogate_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define ISurrogate_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define ISurrogate_LoadDllServer(This,Clsid)	\
   ( (This)->lpVtbl -> LoadDllServer(This,Clsid) ) 

#define ISurrogate_FreeSurrogate(This)	\
   ( (This)->lpVtbl -> FreeSurrogate(This) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __ISurrogate_INTERFACE_DEFINED__ */


if not __IGlobalInterfaceTable_INTERFACE_DEFINED__
#define __IGlobalInterfaceTable_INTERFACE_DEFINED__

/* interface IGlobalInterfaceTable */
/* [uuid][object][local] */ 

typedef  IGlobalInterfaceTable *LPGLOBALINTERFACETABLE;


EXTERN_C const IID IID_IGlobalInterfaceTable;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000146-0000-0000-C000-000000000046")
   IGlobalInterfaceTable : public IUnknown
   {
   public:
       virtual HRESULT __stdcall RegisterInterfaceInGlobal( 
            
             IUnknown *pUnk,
            
             REFIID riid,
           /* [annotation][out] */ 
           _Out_  DWORD *pdwCookie) = 0;
       
       virtual HRESULT __stdcall RevokeInterfaceFromGlobal( 
            
             DWORD dwCookie) = 0;
       
       virtual HRESULT __stdcall GetInterfaceFromGlobal( 
            
             DWORD dwCookie,
            
             REFIID riid,
            
           _Outptr_  void **ppv) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IGlobalInterfaceTableVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IGlobalInterfaceTable * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IGlobalInterfaceTable * This);
       
       ULONG ( __stdcall *Release )( 
           IGlobalInterfaceTable * This);
       
       HRESULT ( __stdcall *RegisterInterfaceInGlobal )( 
           IGlobalInterfaceTable * This,
            
             IUnknown *pUnk,
            
             REFIID riid,
           /* [annotation][out] */ 
           _Out_  DWORD *pdwCookie);
       
       HRESULT ( __stdcall *RevokeInterfaceFromGlobal )( 
           IGlobalInterfaceTable * This,
            
             DWORD dwCookie);
       
       HRESULT ( __stdcall *GetInterfaceFromGlobal )( 
           IGlobalInterfaceTable * This,
            
             DWORD dwCookie,
            
             REFIID riid,
            
           _Outptr_  void **ppv);
       
       END_INTERFACE
   } IGlobalInterfaceTableVtbl;

   interface IGlobalInterfaceTable
   {
       CONST_VTBL struct IGlobalInterfaceTableVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IGlobalInterfaceTable_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IGlobalInterfaceTable_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IGlobalInterfaceTable_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IGlobalInterfaceTable_RegisterInterfaceInGlobal(This,pUnk,riid,pdwCookie)	\
   ( (This)->lpVtbl -> RegisterInterfaceInGlobal(This,pUnk,riid,pdwCookie) ) 

#define IGlobalInterfaceTable_RevokeInterfaceFromGlobal(This,dwCookie)	\
   ( (This)->lpVtbl -> RevokeInterfaceFromGlobal(This,dwCookie) ) 

#define IGlobalInterfaceTable_GetInterfaceFromGlobal(This,dwCookie,riid,ppv)	\
   ( (This)->lpVtbl -> GetInterfaceFromGlobal(This,dwCookie,riid,ppv) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IGlobalInterfaceTable_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_objidlbase_0000_0029 */
 

end /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0029_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0029_v0_0_s_ifspec;

if not __ISynchronize_INTERFACE_DEFINED__
#define __ISynchronize_INTERFACE_DEFINED__

/* interface ISynchronize */
/* [uuid][object] */ 


EXTERN_C const IID IID_ISynchronize;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000030-0000-0000-C000-000000000046")
   ISynchronize : public IUnknown
   {
   public:
       virtual HRESULT __stdcall Wait( 
            DWORD dwFlags,
            DWORD dwMilliseconds) = 0;
       
       virtual HRESULT __stdcall Signal( void) = 0;
       
       virtual HRESULT __stdcall Reset( void) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct ISynchronizeVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
            ISynchronize * This,
             REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
            ISynchronize * This);
       
       ULONG ( __stdcall *Release )( 
            ISynchronize * This);
       
       HRESULT ( __stdcall *Wait )( 
            ISynchronize * This,
            DWORD dwFlags,
            DWORD dwMilliseconds);
       
       HRESULT ( __stdcall *Signal )( 
            ISynchronize * This);
       
       HRESULT ( __stdcall *Reset )( 
            ISynchronize * This);
       
       END_INTERFACE
   } ISynchronizeVtbl;

   interface ISynchronize
   {
       CONST_VTBL struct ISynchronizeVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define ISynchronize_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define ISynchronize_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define ISynchronize_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define ISynchronize_Wait(This,dwFlags,dwMilliseconds)	\
   ( (This)->lpVtbl -> Wait(This,dwFlags,dwMilliseconds) ) 

#define ISynchronize_Signal(This)	\
   ( (This)->lpVtbl -> Signal(This) ) 

#define ISynchronize_Reset(This)	\
   ( (This)->lpVtbl -> Reset(This) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __ISynchronize_INTERFACE_DEFINED__ */


if not __ISynchronizeHandle_INTERFACE_DEFINED__
#define __ISynchronizeHandle_INTERFACE_DEFINED__

/* interface ISynchronizeHandle */
/* [uuid][object][local] */ 


EXTERN_C const IID IID_ISynchronizeHandle;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000031-0000-0000-C000-000000000046")
   ISynchronizeHandle : public IUnknown
   {
   public:
       virtual HRESULT __stdcall GetHandle( 
           /* [annotation][out] */ 
           _Out_  HANDLE *ph) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct ISynchronizeHandleVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           ISynchronizeHandle * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           ISynchronizeHandle * This);
       
       ULONG ( __stdcall *Release )( 
           ISynchronizeHandle * This);
       
       HRESULT ( __stdcall *GetHandle )( 
           ISynchronizeHandle * This,
           /* [annotation][out] */ 
           _Out_  HANDLE *ph);
       
       END_INTERFACE
   } ISynchronizeHandleVtbl;

   interface ISynchronizeHandle
   {
       CONST_VTBL struct ISynchronizeHandleVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define ISynchronizeHandle_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define ISynchronizeHandle_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define ISynchronizeHandle_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define ISynchronizeHandle_GetHandle(This,ph)	\
   ( (This)->lpVtbl -> GetHandle(This,ph) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __ISynchronizeHandle_INTERFACE_DEFINED__ */


if not __ISynchronizeEvent_INTERFACE_DEFINED__
#define __ISynchronizeEvent_INTERFACE_DEFINED__

/* interface ISynchronizeEvent */
/* [uuid][object][local] */ 


EXTERN_C const IID IID_ISynchronizeEvent;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000032-0000-0000-C000-000000000046")
   ISynchronizeEvent : public ISynchronizeHandle
   {
   public:
       virtual HRESULT __stdcall SetEventHandle( 
            
             HANDLE *ph) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct ISynchronizeEventVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           ISynchronizeEvent * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           ISynchronizeEvent * This);
       
       ULONG ( __stdcall *Release )( 
           ISynchronizeEvent * This);
       
       HRESULT ( __stdcall *GetHandle )( 
           ISynchronizeEvent * This,
           /* [annotation][out] */ 
           _Out_  HANDLE *ph);
       
       HRESULT ( __stdcall *SetEventHandle )( 
           ISynchronizeEvent * This,
            
             HANDLE *ph);
       
       END_INTERFACE
   } ISynchronizeEventVtbl;

   interface ISynchronizeEvent
   {
       CONST_VTBL struct ISynchronizeEventVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define ISynchronizeEvent_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define ISynchronizeEvent_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define ISynchronizeEvent_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define ISynchronizeEvent_GetHandle(This,ph)	\
   ( (This)->lpVtbl -> GetHandle(This,ph) ) 


#define ISynchronizeEvent_SetEventHandle(This,ph)	\
   ( (This)->lpVtbl -> SetEventHandle(This,ph) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __ISynchronizeEvent_INTERFACE_DEFINED__ */


if not __ISynchronizeContainer_INTERFACE_DEFINED__
#define __ISynchronizeContainer_INTERFACE_DEFINED__

/* interface ISynchronizeContainer */
/* [uuid][object][local] */ 


EXTERN_C const IID IID_ISynchronizeContainer;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000033-0000-0000-C000-000000000046")
   ISynchronizeContainer : public IUnknown
   {
   public:
       virtual HRESULT __stdcall AddSynchronize( 
            
             ISynchronize *pSync) = 0;
       
       virtual HRESULT __stdcall WaitMultiple( 
            
             DWORD dwFlags,
            
             DWORD dwTimeOut,
           /* [annotation][out] */ 
           _Outptr_  ISynchronize **ppSync) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct ISynchronizeContainerVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           ISynchronizeContainer * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           ISynchronizeContainer * This);
       
       ULONG ( __stdcall *Release )( 
           ISynchronizeContainer * This);
       
       HRESULT ( __stdcall *AddSynchronize )( 
           ISynchronizeContainer * This,
            
             ISynchronize *pSync);
       
       HRESULT ( __stdcall *WaitMultiple )( 
           ISynchronizeContainer * This,
            
             DWORD dwFlags,
            
             DWORD dwTimeOut,
           /* [annotation][out] */ 
           _Outptr_  ISynchronize **ppSync);
       
       END_INTERFACE
   } ISynchronizeContainerVtbl;

   interface ISynchronizeContainer
   {
       CONST_VTBL struct ISynchronizeContainerVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define ISynchronizeContainer_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define ISynchronizeContainer_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define ISynchronizeContainer_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define ISynchronizeContainer_AddSynchronize(This,pSync)	\
   ( (This)->lpVtbl -> AddSynchronize(This,pSync) ) 

#define ISynchronizeContainer_WaitMultiple(This,dwFlags,dwTimeOut,ppSync)	\
   ( (This)->lpVtbl -> WaitMultiple(This,dwFlags,dwTimeOut,ppSync) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __ISynchronizeContainer_INTERFACE_DEFINED__ */


if not __ISynchronizeMutex_INTERFACE_DEFINED__
#define __ISynchronizeMutex_INTERFACE_DEFINED__

/* interface ISynchronizeMutex */
/* [uuid][object][local] */ 


EXTERN_C const IID IID_ISynchronizeMutex;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000025-0000-0000-C000-000000000046")
   ISynchronizeMutex : public ISynchronize
   {
   public:
       virtual HRESULT __stdcall ReleaseMutex( void) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct ISynchronizeMutexVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           ISynchronizeMutex * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           ISynchronizeMutex * This);
       
       ULONG ( __stdcall *Release )( 
           ISynchronizeMutex * This);
       
       HRESULT ( __stdcall *Wait )( 
           ISynchronizeMutex * This,
            DWORD dwFlags,
            DWORD dwMilliseconds);
       
       HRESULT ( __stdcall *Signal )( 
           ISynchronizeMutex * This);
       
       HRESULT ( __stdcall *Reset )( 
           ISynchronizeMutex * This);
       
       HRESULT ( __stdcall *ReleaseMutex )( 
           ISynchronizeMutex * This);
       
       END_INTERFACE
   } ISynchronizeMutexVtbl;

   interface ISynchronizeMutex
   {
       CONST_VTBL struct ISynchronizeMutexVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define ISynchronizeMutex_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define ISynchronizeMutex_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define ISynchronizeMutex_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define ISynchronizeMutex_Wait(This,dwFlags,dwMilliseconds)	\
   ( (This)->lpVtbl -> Wait(This,dwFlags,dwMilliseconds) ) 

#define ISynchronizeMutex_Signal(This)	\
   ( (This)->lpVtbl -> Signal(This) ) 

#define ISynchronizeMutex_Reset(This)	\
   ( (This)->lpVtbl -> Reset(This) ) 


#define ISynchronizeMutex_ReleaseMutex(This)	\
   ( (This)->lpVtbl -> ReleaseMutex(This) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __ISynchronizeMutex_INTERFACE_DEFINED__ */


if not __ICancelMethodCalls_INTERFACE_DEFINED__
#define __ICancelMethodCalls_INTERFACE_DEFINED__

/* interface ICancelMethodCalls */
/* [uuid][object][local] */ 

typedef  ICancelMethodCalls *LPCANCELMETHODCALLS;


EXTERN_C const IID IID_ICancelMethodCalls;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000029-0000-0000-C000-000000000046")
   ICancelMethodCalls : public IUnknown
   {
   public:
       virtual HRESULT __stdcall Cancel( 
            
             ULONG ulSeconds) = 0;
       
       virtual HRESULT __stdcall TestCancel( void) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct ICancelMethodCallsVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           ICancelMethodCalls * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           ICancelMethodCalls * This);
       
       ULONG ( __stdcall *Release )( 
           ICancelMethodCalls * This);
       
       HRESULT ( __stdcall *Cancel )( 
           ICancelMethodCalls * This,
            
             ULONG ulSeconds);
       
       HRESULT ( __stdcall *TestCancel )( 
           ICancelMethodCalls * This);
       
       END_INTERFACE
   } ICancelMethodCallsVtbl;

   interface ICancelMethodCalls
   {
       CONST_VTBL struct ICancelMethodCallsVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define ICancelMethodCalls_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define ICancelMethodCalls_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define ICancelMethodCalls_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define ICancelMethodCalls_Cancel(This,ulSeconds)	\
   ( (This)->lpVtbl -> Cancel(This,ulSeconds) ) 

#define ICancelMethodCalls_TestCancel(This)	\
   ( (This)->lpVtbl -> TestCancel(This) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __ICancelMethodCalls_INTERFACE_DEFINED__ */


if not __IAsyncManager_INTERFACE_DEFINED__
#define __IAsyncManager_INTERFACE_DEFINED__

/* interface IAsyncManager */
/* [uuid][object][local] */ 

typedef 
enum tagDCOM_CALL_STATE
   {
       DCOM_NONE	= 0,
       DCOM_CALL_COMPLETE	= 0x1,
       DCOM_CALL_CANCELED	= 0x2
   } 	DCOM_CALL_STATE;


EXTERN_C const IID IID_IAsyncManager;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("0000002A-0000-0000-C000-000000000046")
   IAsyncManager : public IUnknown
   {
   public:
       virtual HRESULT __stdcall CompleteCall( 
            
             HRESULT Result) = 0;
       
       virtual HRESULT __stdcall GetCallContext( 
            
             REFIID riid,
           /* [annotation][out] */ 
           _Outptr_  void **pInterface) = 0;
       
       virtual HRESULT __stdcall GetState( 
           /* [annotation][out] */ 
           _Out_  ULONG *pulStateFlags) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IAsyncManagerVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IAsyncManager * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IAsyncManager * This);
       
       ULONG ( __stdcall *Release )( 
           IAsyncManager * This);
       
       HRESULT ( __stdcall *CompleteCall )( 
           IAsyncManager * This,
            
             HRESULT Result);
       
       HRESULT ( __stdcall *GetCallContext )( 
           IAsyncManager * This,
            
             REFIID riid,
           /* [annotation][out] */ 
           _Outptr_  void **pInterface);
       
       HRESULT ( __stdcall *GetState )( 
           IAsyncManager * This,
           /* [annotation][out] */ 
           _Out_  ULONG *pulStateFlags);
       
       END_INTERFACE
   } IAsyncManagerVtbl;

   interface IAsyncManager
   {
       CONST_VTBL struct IAsyncManagerVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IAsyncManager_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IAsyncManager_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IAsyncManager_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IAsyncManager_CompleteCall(This,Result)	\
   ( (This)->lpVtbl -> CompleteCall(This,Result) ) 

#define IAsyncManager_GetCallContext(This,riid,pInterface)	\
   ( (This)->lpVtbl -> GetCallContext(This,riid,pInterface) ) 

#define IAsyncManager_GetState(This,pulStateFlags)	\
   ( (This)->lpVtbl -> GetState(This,pulStateFlags) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IAsyncManager_INTERFACE_DEFINED__ */


if not __ICallFactory_INTERFACE_DEFINED__
#define __ICallFactory_INTERFACE_DEFINED__

/* interface ICallFactory */
/* [unique][uuid][object][local] */ 


EXTERN_C const IID IID_ICallFactory;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("1c733a30-2a1c-11ce-ade5-00aa0044773d")
   ICallFactory : public IUnknown
   {
   public:
       virtual HRESULT __stdcall CreateCall( 
            
             REFIID riid,
            
             IUnknown *pCtrlUnk,
            
             REFIID riid2,
            
           _Outptr_  IUnknown **ppv) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct ICallFactoryVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           ICallFactory * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           ICallFactory * This);
       
       ULONG ( __stdcall *Release )( 
           ICallFactory * This);
       
       HRESULT ( __stdcall *CreateCall )( 
           ICallFactory * This,
            
             REFIID riid,
            
             IUnknown *pCtrlUnk,
            
             REFIID riid2,
            
           _Outptr_  IUnknown **ppv);
       
       END_INTERFACE
   } ICallFactoryVtbl;

   interface ICallFactory
   {
       CONST_VTBL struct ICallFactoryVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define ICallFactory_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define ICallFactory_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define ICallFactory_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define ICallFactory_CreateCall(This,riid,pCtrlUnk,riid2,ppv)	\
   ( (This)->lpVtbl -> CreateCall(This,riid,pCtrlUnk,riid2,ppv) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __ICallFactory_INTERFACE_DEFINED__ */


if not __IRpcHelper_INTERFACE_DEFINED__
#define __IRpcHelper_INTERFACE_DEFINED__

/* interface IRpcHelper */
/* [object][local][unique][version][uuid] */ 


EXTERN_C const IID IID_IRpcHelper;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000149-0000-0000-C000-000000000046")
   IRpcHelper : public IUnknown
   {
   public:
       virtual HRESULT __stdcall GetDCOMProtocolVersion( 
           /* [annotation][out] */ 
           _Out_  DWORD *pComVersion) = 0;
       
       virtual HRESULT __stdcall GetIIDFromOBJREF( 
            
             void *pObjRef,
           /* [annotation][out] */ 
           _Outptr_  IID **piid) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IRpcHelperVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IRpcHelper * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IRpcHelper * This);
       
       ULONG ( __stdcall *Release )( 
           IRpcHelper * This);
       
       HRESULT ( __stdcall *GetDCOMProtocolVersion )( 
           IRpcHelper * This,
           /* [annotation][out] */ 
           _Out_  DWORD *pComVersion);
       
       HRESULT ( __stdcall *GetIIDFromOBJREF )( 
           IRpcHelper * This,
            
             void *pObjRef,
           /* [annotation][out] */ 
           _Outptr_  IID **piid);
       
       END_INTERFACE
   } IRpcHelperVtbl;

   interface IRpcHelper
   {
       CONST_VTBL struct IRpcHelperVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IRpcHelper_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IRpcHelper_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IRpcHelper_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IRpcHelper_GetDCOMProtocolVersion(This,pComVersion)	\
   ( (This)->lpVtbl -> GetDCOMProtocolVersion(This,pComVersion) ) 

#define IRpcHelper_GetIIDFromOBJREF(This,pObjRef,piid)	\
   ( (This)->lpVtbl -> GetIIDFromOBJREF(This,pObjRef,piid) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IRpcHelper_INTERFACE_DEFINED__ */


if not __IReleaseMarshalBuffers_INTERFACE_DEFINED__
#define __IReleaseMarshalBuffers_INTERFACE_DEFINED__

/* interface IReleaseMarshalBuffers */
/* [uuid][object][local] */ 


EXTERN_C const IID IID_IReleaseMarshalBuffers;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("eb0cb9e8-7996-11d2-872e-0000f8080859")
   IReleaseMarshalBuffers : public IUnknown
   {
   public:
       virtual HRESULT __stdcall ReleaseMarshalBuffer( 
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMsg,
            
             DWORD dwFlags,
            
             IUnknown *pChnl) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IReleaseMarshalBuffersVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IReleaseMarshalBuffers * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IReleaseMarshalBuffers * This);
       
       ULONG ( __stdcall *Release )( 
           IReleaseMarshalBuffers * This);
       
       HRESULT ( __stdcall *ReleaseMarshalBuffer )( 
           IReleaseMarshalBuffers * This,
           /* [annotation][out][in] */ 
           _Inout_  RPCOLEMESSAGE *pMsg,
            
             DWORD dwFlags,
            
             IUnknown *pChnl);
       
       END_INTERFACE
   } IReleaseMarshalBuffersVtbl;

   interface IReleaseMarshalBuffers
   {
       CONST_VTBL struct IReleaseMarshalBuffersVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IReleaseMarshalBuffers_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IReleaseMarshalBuffers_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IReleaseMarshalBuffers_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IReleaseMarshalBuffers_ReleaseMarshalBuffer(This,pMsg,dwFlags,pChnl)	\
   ( (This)->lpVtbl -> ReleaseMarshalBuffer(This,pMsg,dwFlags,pChnl) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IReleaseMarshalBuffers_INTERFACE_DEFINED__ */


if not __IWaitMultiple_INTERFACE_DEFINED__
#define __IWaitMultiple_INTERFACE_DEFINED__

/* interface IWaitMultiple */
/* [uuid][object][local] */ 


EXTERN_C const IID IID_IWaitMultiple;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("0000002B-0000-0000-C000-000000000046")
   IWaitMultiple : public IUnknown
   {
   public:
       virtual HRESULT __stdcall WaitMultiple( 
            
             DWORD timeout,
           /* [annotation][out] */ 
           _Outptr_  ISynchronize **pSync) = 0;
       
       virtual HRESULT __stdcall AddSynchronize( 
            
             ISynchronize *pSync) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IWaitMultipleVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IWaitMultiple * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IWaitMultiple * This);
       
       ULONG ( __stdcall *Release )( 
           IWaitMultiple * This);
       
       HRESULT ( __stdcall *WaitMultiple )( 
           IWaitMultiple * This,
            
             DWORD timeout,
           /* [annotation][out] */ 
           _Outptr_  ISynchronize **pSync);
       
       HRESULT ( __stdcall *AddSynchronize )( 
           IWaitMultiple * This,
            
             ISynchronize *pSync);
       
       END_INTERFACE
   } IWaitMultipleVtbl;

   interface IWaitMultiple
   {
       CONST_VTBL struct IWaitMultipleVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IWaitMultiple_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IWaitMultiple_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IWaitMultiple_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IWaitMultiple_WaitMultiple(This,timeout,pSync)	\
   ( (This)->lpVtbl -> WaitMultiple(This,timeout,pSync) ) 

#define IWaitMultiple_AddSynchronize(This,pSync)	\
   ( (This)->lpVtbl -> AddSynchronize(This,pSync) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IWaitMultiple_INTERFACE_DEFINED__ */


if not __IAddrTrackingControl_INTERFACE_DEFINED__
#define __IAddrTrackingControl_INTERFACE_DEFINED__

/* interface IAddrTrackingControl */
/* [uuid][object][local] */ 

typedef  IAddrTrackingControl *LPADDRTRACKINGCONTROL;


EXTERN_C const IID IID_IAddrTrackingControl;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000147-0000-0000-C000-000000000046")
   IAddrTrackingControl : public IUnknown
   {
   public:
       virtual HRESULT __stdcall EnableCOMDynamicAddrTracking( void) = 0;
       
       virtual HRESULT __stdcall DisableCOMDynamicAddrTracking( void) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IAddrTrackingControlVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IAddrTrackingControl * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IAddrTrackingControl * This);
       
       ULONG ( __stdcall *Release )( 
           IAddrTrackingControl * This);
       
       HRESULT ( __stdcall *EnableCOMDynamicAddrTracking )( 
           IAddrTrackingControl * This);
       
       HRESULT ( __stdcall *DisableCOMDynamicAddrTracking )( 
           IAddrTrackingControl * This);
       
       END_INTERFACE
   } IAddrTrackingControlVtbl;

   interface IAddrTrackingControl
   {
       CONST_VTBL struct IAddrTrackingControlVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IAddrTrackingControl_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IAddrTrackingControl_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IAddrTrackingControl_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IAddrTrackingControl_EnableCOMDynamicAddrTracking(This)	\
   ( (This)->lpVtbl -> EnableCOMDynamicAddrTracking(This) ) 

#define IAddrTrackingControl_DisableCOMDynamicAddrTracking(This)	\
   ( (This)->lpVtbl -> DisableCOMDynamicAddrTracking(This) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IAddrTrackingControl_INTERFACE_DEFINED__ */


if not __IAddrExclusionControl_INTERFACE_DEFINED__
#define __IAddrExclusionControl_INTERFACE_DEFINED__

/* interface IAddrExclusionControl */
/* [uuid][object][local] */ 

typedef  IAddrExclusionControl *LPADDREXCLUSIONCONTROL;


EXTERN_C const IID IID_IAddrExclusionControl;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000148-0000-0000-C000-000000000046")
   IAddrExclusionControl : public IUnknown
   {
   public:
       virtual HRESULT __stdcall GetCurrentAddrExclusionList( 
            
             REFIID riid,
            
           _Outptr_  void **ppEnumerator) = 0;
       
       virtual HRESULT __stdcall UpdateAddrExclusionList( 
            
             IUnknown *pEnumerator) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IAddrExclusionControlVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IAddrExclusionControl * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IAddrExclusionControl * This);
       
       ULONG ( __stdcall *Release )( 
           IAddrExclusionControl * This);
       
       HRESULT ( __stdcall *GetCurrentAddrExclusionList )( 
           IAddrExclusionControl * This,
            
             REFIID riid,
            
           _Outptr_  void **ppEnumerator);
       
       HRESULT ( __stdcall *UpdateAddrExclusionList )( 
           IAddrExclusionControl * This,
            
             IUnknown *pEnumerator);
       
       END_INTERFACE
   } IAddrExclusionControlVtbl;

   interface IAddrExclusionControl
   {
       CONST_VTBL struct IAddrExclusionControlVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IAddrExclusionControl_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IAddrExclusionControl_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IAddrExclusionControl_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IAddrExclusionControl_GetCurrentAddrExclusionList(This,riid,ppEnumerator)	\
   ( (This)->lpVtbl -> GetCurrentAddrExclusionList(This,riid,ppEnumerator) ) 

#define IAddrExclusionControl_UpdateAddrExclusionList(This,pEnumerator)	\
   ( (This)->lpVtbl -> UpdateAddrExclusionList(This,pEnumerator) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IAddrExclusionControl_INTERFACE_DEFINED__ */


if not __IPipeByte_INTERFACE_DEFINED__
#define __IPipeByte_INTERFACE_DEFINED__

/* interface IPipeByte */
/* [unique][async_uuid][uuid][object] */ 


EXTERN_C const IID IID_IPipeByte;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("DB2F3ACA-2F86-11d1-8E04-00C04FB9989A")
   IPipeByte : public IUnknown
   {
   public:
       virtual HRESULT __stdcall Pull( 
           /* [length_is][size_is][out] */ __RPC__out_ecount_part(cRequest, *pcReturned) BYTE *buf,
            ULONG cRequest,
             ULONG *pcReturned) = 0;
       
       virtual HRESULT __stdcall Push( 
           /* [size_is][in] */ __RPC__in_ecount_full(cSent) BYTE *buf,
            ULONG cSent) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IPipeByteVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
            IPipeByte * This,
             REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
            IPipeByte * This);
       
       ULONG ( __stdcall *Release )( 
            IPipeByte * This);
       
       HRESULT ( __stdcall *Pull )( 
            IPipeByte * This,
           /* [length_is][size_is][out] */ __RPC__out_ecount_part(cRequest, *pcReturned) BYTE *buf,
            ULONG cRequest,
             ULONG *pcReturned);
       
       HRESULT ( __stdcall *Push )( 
            IPipeByte * This,
           /* [size_is][in] */ __RPC__in_ecount_full(cSent) BYTE *buf,
            ULONG cSent);
       
       END_INTERFACE
   } IPipeByteVtbl;

   interface IPipeByte
   {
       CONST_VTBL struct IPipeByteVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IPipeByte_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IPipeByte_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IPipeByte_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IPipeByte_Pull(This,buf,cRequest,pcReturned)	\
   ( (This)->lpVtbl -> Pull(This,buf,cRequest,pcReturned) ) 

#define IPipeByte_Push(This,buf,cSent)	\
   ( (This)->lpVtbl -> Push(This,buf,cSent) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IPipeByte_INTERFACE_DEFINED__ */


if not __AsyncIPipeByte_INTERFACE_DEFINED__
#define __AsyncIPipeByte_INTERFACE_DEFINED__

/* interface AsyncIPipeByte */
/* [uuid][unique][object] */ 


EXTERN_C const IID IID_AsyncIPipeByte;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("DB2F3ACB-2F86-11d1-8E04-00C04FB9989A")
   AsyncIPipeByte : public IUnknown
   {
   public:
       virtual HRESULT __stdcall Begin_Pull( 
            ULONG cRequest) = 0;
       
       virtual HRESULT __stdcall Finish_Pull( 
           /* [length_is][size_is][out] */ __RPC__out_xcount_part(cRequest, *pcReturned) BYTE *buf,
             ULONG *pcReturned) = 0;
       
       virtual HRESULT __stdcall Begin_Push( 
           /* [size_is][in] */ __RPC__in_xcount_full(cSent) BYTE *buf,
            ULONG cSent) = 0;
       
       virtual HRESULT __stdcall Finish_Push( void) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct AsyncIPipeByteVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
            AsyncIPipeByte * This,
             REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
            AsyncIPipeByte * This);
       
       ULONG ( __stdcall *Release )( 
            AsyncIPipeByte * This);
       
       HRESULT ( __stdcall *Begin_Pull )( 
            AsyncIPipeByte * This,
            ULONG cRequest);
       
       HRESULT ( __stdcall *Finish_Pull )( 
            AsyncIPipeByte * This,
           /* [length_is][size_is][out] */ __RPC__out_xcount_part(cRequest, *pcReturned) BYTE *buf,
             ULONG *pcReturned);
       
       HRESULT ( __stdcall *Begin_Push )( 
            AsyncIPipeByte * This,
           /* [size_is][in] */ __RPC__in_xcount_full(cSent) BYTE *buf,
            ULONG cSent);
       
       HRESULT ( __stdcall *Finish_Push )( 
            AsyncIPipeByte * This);
       
       END_INTERFACE
   } AsyncIPipeByteVtbl;

   interface AsyncIPipeByte
   {
       CONST_VTBL struct AsyncIPipeByteVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define AsyncIPipeByte_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define AsyncIPipeByte_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define AsyncIPipeByte_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define AsyncIPipeByte_Begin_Pull(This,cRequest)	\
   ( (This)->lpVtbl -> Begin_Pull(This,cRequest) ) 

#define AsyncIPipeByte_Finish_Pull(This,buf,pcReturned)	\
   ( (This)->lpVtbl -> Finish_Pull(This,buf,pcReturned) ) 

#define AsyncIPipeByte_Begin_Push(This,buf,cSent)	\
   ( (This)->lpVtbl -> Begin_Push(This,buf,cSent) ) 

#define AsyncIPipeByte_Finish_Push(This)	\
   ( (This)->lpVtbl -> Finish_Push(This) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __AsyncIPipeByte_INTERFACE_DEFINED__ */


if not __IPipeLong_INTERFACE_DEFINED__
#define __IPipeLong_INTERFACE_DEFINED__

/* interface IPipeLong */
/* [unique][async_uuid][uuid][object] */ 


EXTERN_C const IID IID_IPipeLong;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("DB2F3ACC-2F86-11d1-8E04-00C04FB9989A")
   IPipeLong : public IUnknown
   {
   public:
       virtual HRESULT __stdcall Pull( 
           /* [length_is][size_is][out] */ __RPC__out_ecount_part(cRequest, *pcReturned) LONG *buf,
            ULONG cRequest,
             ULONG *pcReturned) = 0;
       
       virtual HRESULT __stdcall Push( 
           /* [size_is][in] */ __RPC__in_ecount_full(cSent) LONG *buf,
            ULONG cSent) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IPipeLongVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
            IPipeLong * This,
             REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
            IPipeLong * This);
       
       ULONG ( __stdcall *Release )( 
            IPipeLong * This);
       
       HRESULT ( __stdcall *Pull )( 
            IPipeLong * This,
           /* [length_is][size_is][out] */ __RPC__out_ecount_part(cRequest, *pcReturned) LONG *buf,
            ULONG cRequest,
             ULONG *pcReturned);
       
       HRESULT ( __stdcall *Push )( 
            IPipeLong * This,
           /* [size_is][in] */ __RPC__in_ecount_full(cSent) LONG *buf,
            ULONG cSent);
       
       END_INTERFACE
   } IPipeLongVtbl;

   interface IPipeLong
   {
       CONST_VTBL struct IPipeLongVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IPipeLong_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IPipeLong_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IPipeLong_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IPipeLong_Pull(This,buf,cRequest,pcReturned)	\
   ( (This)->lpVtbl -> Pull(This,buf,cRequest,pcReturned) ) 

#define IPipeLong_Push(This,buf,cSent)	\
   ( (This)->lpVtbl -> Push(This,buf,cSent) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IPipeLong_INTERFACE_DEFINED__ */


if not __AsyncIPipeLong_INTERFACE_DEFINED__
#define __AsyncIPipeLong_INTERFACE_DEFINED__

/* interface AsyncIPipeLong */
/* [uuid][unique][object] */ 


EXTERN_C const IID IID_AsyncIPipeLong;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("DB2F3ACD-2F86-11d1-8E04-00C04FB9989A")
   AsyncIPipeLong : public IUnknown
   {
   public:
       virtual HRESULT __stdcall Begin_Pull( 
            ULONG cRequest) = 0;
       
       virtual HRESULT __stdcall Finish_Pull( 
           /* [length_is][size_is][out] */ __RPC__out_xcount_part(cRequest, *pcReturned) LONG *buf,
             ULONG *pcReturned) = 0;
       
       virtual HRESULT __stdcall Begin_Push( 
           /* [size_is][in] */ __RPC__in_xcount_full(cSent) LONG *buf,
            ULONG cSent) = 0;
       
       virtual HRESULT __stdcall Finish_Push( void) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct AsyncIPipeLongVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
            AsyncIPipeLong * This,
             REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
            AsyncIPipeLong * This);
       
       ULONG ( __stdcall *Release )( 
            AsyncIPipeLong * This);
       
       HRESULT ( __stdcall *Begin_Pull )( 
            AsyncIPipeLong * This,
            ULONG cRequest);
       
       HRESULT ( __stdcall *Finish_Pull )( 
            AsyncIPipeLong * This,
           /* [length_is][size_is][out] */ __RPC__out_xcount_part(cRequest, *pcReturned) LONG *buf,
             ULONG *pcReturned);
       
       HRESULT ( __stdcall *Begin_Push )( 
            AsyncIPipeLong * This,
           /* [size_is][in] */ __RPC__in_xcount_full(cSent) LONG *buf,
            ULONG cSent);
       
       HRESULT ( __stdcall *Finish_Push )( 
            AsyncIPipeLong * This);
       
       END_INTERFACE
   } AsyncIPipeLongVtbl;

   interface AsyncIPipeLong
   {
       CONST_VTBL struct AsyncIPipeLongVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define AsyncIPipeLong_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define AsyncIPipeLong_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define AsyncIPipeLong_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define AsyncIPipeLong_Begin_Pull(This,cRequest)	\
   ( (This)->lpVtbl -> Begin_Pull(This,cRequest) ) 

#define AsyncIPipeLong_Finish_Pull(This,buf,pcReturned)	\
   ( (This)->lpVtbl -> Finish_Pull(This,buf,pcReturned) ) 

#define AsyncIPipeLong_Begin_Push(This,buf,cSent)	\
   ( (This)->lpVtbl -> Begin_Push(This,buf,cSent) ) 

#define AsyncIPipeLong_Finish_Push(This)	\
   ( (This)->lpVtbl -> Finish_Push(This) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __AsyncIPipeLong_INTERFACE_DEFINED__ */


if not __IPipeDouble_INTERFACE_DEFINED__
#define __IPipeDouble_INTERFACE_DEFINED__

/* interface IPipeDouble */
/* [unique][async_uuid][uuid][object] */ 


EXTERN_C const IID IID_IPipeDouble;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("DB2F3ACE-2F86-11d1-8E04-00C04FB9989A")
   IPipeDouble : public IUnknown
   {
   public:
       virtual HRESULT __stdcall Pull( 
           /* [length_is][size_is][out] */ __RPC__out_ecount_part(cRequest, *pcReturned) DOUBLE *buf,
            ULONG cRequest,
             ULONG *pcReturned) = 0;
       
       virtual HRESULT __stdcall Push( 
           /* [size_is][in] */ __RPC__in_ecount_full(cSent) DOUBLE *buf,
            ULONG cSent) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IPipeDoubleVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
            IPipeDouble * This,
             REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
            IPipeDouble * This);
       
       ULONG ( __stdcall *Release )( 
            IPipeDouble * This);
       
       HRESULT ( __stdcall *Pull )( 
            IPipeDouble * This,
           /* [length_is][size_is][out] */ __RPC__out_ecount_part(cRequest, *pcReturned) DOUBLE *buf,
            ULONG cRequest,
             ULONG *pcReturned);
       
       HRESULT ( __stdcall *Push )( 
            IPipeDouble * This,
           /* [size_is][in] */ __RPC__in_ecount_full(cSent) DOUBLE *buf,
            ULONG cSent);
       
       END_INTERFACE
   } IPipeDoubleVtbl;

   interface IPipeDouble
   {
       CONST_VTBL struct IPipeDoubleVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IPipeDouble_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IPipeDouble_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IPipeDouble_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IPipeDouble_Pull(This,buf,cRequest,pcReturned)	\
   ( (This)->lpVtbl -> Pull(This,buf,cRequest,pcReturned) ) 

#define IPipeDouble_Push(This,buf,cSent)	\
   ( (This)->lpVtbl -> Push(This,buf,cSent) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IPipeDouble_INTERFACE_DEFINED__ */


if not __AsyncIPipeDouble_INTERFACE_DEFINED__
#define __AsyncIPipeDouble_INTERFACE_DEFINED__

/* interface AsyncIPipeDouble */
/* [uuid][unique][object] */ 


EXTERN_C const IID IID_AsyncIPipeDouble;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("DB2F3ACF-2F86-11d1-8E04-00C04FB9989A")
   AsyncIPipeDouble : public IUnknown
   {
   public:
       virtual HRESULT __stdcall Begin_Pull( 
            ULONG cRequest) = 0;
       
       virtual HRESULT __stdcall Finish_Pull( 
           /* [length_is][size_is][out] */ __RPC__out_xcount_part(cRequest, *pcReturned) DOUBLE *buf,
             ULONG *pcReturned) = 0;
       
       virtual HRESULT __stdcall Begin_Push( 
           /* [size_is][in] */ __RPC__in_xcount_full(cSent) DOUBLE *buf,
            ULONG cSent) = 0;
       
       virtual HRESULT __stdcall Finish_Push( void) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct AsyncIPipeDoubleVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
            AsyncIPipeDouble * This,
             REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
            AsyncIPipeDouble * This);
       
       ULONG ( __stdcall *Release )( 
            AsyncIPipeDouble * This);
       
       HRESULT ( __stdcall *Begin_Pull )( 
            AsyncIPipeDouble * This,
            ULONG cRequest);
       
       HRESULT ( __stdcall *Finish_Pull )( 
            AsyncIPipeDouble * This,
           /* [length_is][size_is][out] */ __RPC__out_xcount_part(cRequest, *pcReturned) DOUBLE *buf,
             ULONG *pcReturned);
       
       HRESULT ( __stdcall *Begin_Push )( 
            AsyncIPipeDouble * This,
           /* [size_is][in] */ __RPC__in_xcount_full(cSent) DOUBLE *buf,
            ULONG cSent);
       
       HRESULT ( __stdcall *Finish_Push )( 
            AsyncIPipeDouble * This);
       
       END_INTERFACE
   } AsyncIPipeDoubleVtbl;

   interface AsyncIPipeDouble
   {
       CONST_VTBL struct AsyncIPipeDoubleVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define AsyncIPipeDouble_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define AsyncIPipeDouble_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define AsyncIPipeDouble_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define AsyncIPipeDouble_Begin_Pull(This,cRequest)	\
   ( (This)->lpVtbl -> Begin_Pull(This,cRequest) ) 

#define AsyncIPipeDouble_Finish_Pull(This,buf,pcReturned)	\
   ( (This)->lpVtbl -> Finish_Pull(This,buf,pcReturned) ) 

#define AsyncIPipeDouble_Begin_Push(This,buf,cSent)	\
   ( (This)->lpVtbl -> Begin_Push(This,buf,cSent) ) 

#define AsyncIPipeDouble_Finish_Push(This)	\
   ( (This)->lpVtbl -> Finish_Push(This) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __AsyncIPipeDouble_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_objidlbase_0000_0045 */
 

#if defined USE_COM_CONTEXT_DEF || defined BUILDTYPE_COMSVCS || defined _COMBASEAPI_ || defined _OLE32_
typedef DWORD CPFLAGS;

typedef struct tagContextProperty
   {
   GUID policyId;
   CPFLAGS flags;
    IUnknown *pUnk;
   } 	ContextProperty;



extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0045_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0045_v0_0_s_ifspec;

if not __IEnumContextProps_INTERFACE_DEFINED__
#define __IEnumContextProps_INTERFACE_DEFINED__

/* interface IEnumContextProps */
/* [unique][uuid][object][local] */ 

typedef  IEnumContextProps *LPENUMCONTEXTPROPS;


EXTERN_C const IID IID_IEnumContextProps;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("000001c1-0000-0000-C000-000000000046")
   IEnumContextProps : public IUnknown
   {
   public:
       virtual HRESULT __stdcall Next( 
            
             ULONG celt,
           /* [annotation][length_is][size_is][out] */ 
           _Out_writes_to_(celt, *pceltFetched)  ContextProperty *pContextProperties,
           /* [annotation][out] */ 
           _Out_  ULONG *pceltFetched) = 0;
       
       virtual HRESULT __stdcall Skip( 
            
             ULONG celt) = 0;
       
       virtual HRESULT __stdcall Reset( void) = 0;
       
       virtual HRESULT __stdcall Clone( 
           /* [annotation][out] */ 
           _Outptr_  IEnumContextProps **ppEnumContextProps) = 0;
       
       virtual HRESULT __stdcall Count( 
           /* [annotation][out] */ 
           _Out_  ULONG *pcelt) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IEnumContextPropsVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IEnumContextProps * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IEnumContextProps * This);
       
       ULONG ( __stdcall *Release )( 
           IEnumContextProps * This);
       
       HRESULT ( __stdcall *Next )( 
           IEnumContextProps * This,
            
             ULONG celt,
           /* [annotation][length_is][size_is][out] */ 
           _Out_writes_to_(celt, *pceltFetched)  ContextProperty *pContextProperties,
           /* [annotation][out] */ 
           _Out_  ULONG *pceltFetched);
       
       HRESULT ( __stdcall *Skip )( 
           IEnumContextProps * This,
            
             ULONG celt);
       
       HRESULT ( __stdcall *Reset )( 
           IEnumContextProps * This);
       
       HRESULT ( __stdcall *Clone )( 
           IEnumContextProps * This,
           /* [annotation][out] */ 
           _Outptr_  IEnumContextProps **ppEnumContextProps);
       
       HRESULT ( __stdcall *Count )( 
           IEnumContextProps * This,
           /* [annotation][out] */ 
           _Out_  ULONG *pcelt);
       
       END_INTERFACE
   } IEnumContextPropsVtbl;

   interface IEnumContextProps
   {
       CONST_VTBL struct IEnumContextPropsVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IEnumContextProps_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IEnumContextProps_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IEnumContextProps_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IEnumContextProps_Next(This,celt,pContextProperties,pceltFetched)	\
   ( (This)->lpVtbl -> Next(This,celt,pContextProperties,pceltFetched) ) 

#define IEnumContextProps_Skip(This,celt)	\
   ( (This)->lpVtbl -> Skip(This,celt) ) 

#define IEnumContextProps_Reset(This)	\
   ( (This)->lpVtbl -> Reset(This) ) 

#define IEnumContextProps_Clone(This,ppEnumContextProps)	\
   ( (This)->lpVtbl -> Clone(This,ppEnumContextProps) ) 

#define IEnumContextProps_Count(This,pcelt)	\
   ( (This)->lpVtbl -> Count(This,pcelt) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IEnumContextProps_INTERFACE_DEFINED__ */


if not __IContext_INTERFACE_DEFINED__
#define __IContext_INTERFACE_DEFINED__

/* interface IContext */
/* [unique][uuid][object][local] */ 


EXTERN_C const IID IID_IContext;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("000001c0-0000-0000-C000-000000000046")
   IContext : public IUnknown
   {
   public:
       virtual HRESULT __stdcall SetProperty( 
            
             REFGUID rpolicyId,
            
             CPFLAGS flags,
            
             IUnknown *pUnk) = 0;
       
       virtual HRESULT __stdcall RemoveProperty( 
            
             REFGUID rPolicyId) = 0;
       
       virtual HRESULT __stdcall GetProperty( 
            
             REFGUID rGuid,
           /* [annotation][out] */ 
           _Out_  CPFLAGS *pFlags,
           /* [annotation][out] */ 
           _Outptr_  IUnknown **ppUnk) = 0;
       
       virtual HRESULT __stdcall EnumContextProps( 
           /* [annotation][out] */ 
           _Outptr_  IEnumContextProps **ppEnumContextProps) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IContextVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IContext * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IContext * This);
       
       ULONG ( __stdcall *Release )( 
           IContext * This);
       
       HRESULT ( __stdcall *SetProperty )( 
           IContext * This,
            
             REFGUID rpolicyId,
            
             CPFLAGS flags,
            
             IUnknown *pUnk);
       
       HRESULT ( __stdcall *RemoveProperty )( 
           IContext * This,
            
             REFGUID rPolicyId);
       
       HRESULT ( __stdcall *GetProperty )( 
           IContext * This,
            
             REFGUID rGuid,
           /* [annotation][out] */ 
           _Out_  CPFLAGS *pFlags,
           /* [annotation][out] */ 
           _Outptr_  IUnknown **ppUnk);
       
       HRESULT ( __stdcall *EnumContextProps )( 
           IContext * This,
           /* [annotation][out] */ 
           _Outptr_  IEnumContextProps **ppEnumContextProps);
       
       END_INTERFACE
   } IContextVtbl;

   interface IContext
   {
       CONST_VTBL struct IContextVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IContext_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IContext_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IContext_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IContext_SetProperty(This,rpolicyId,flags,pUnk)	\
   ( (This)->lpVtbl -> SetProperty(This,rpolicyId,flags,pUnk) ) 

#define IContext_RemoveProperty(This,rPolicyId)	\
   ( (This)->lpVtbl -> RemoveProperty(This,rPolicyId) ) 

#define IContext_GetProperty(This,rGuid,pFlags,ppUnk)	\
   ( (This)->lpVtbl -> GetProperty(This,rGuid,pFlags,ppUnk) ) 

#define IContext_EnumContextProps(This,ppEnumContextProps)	\
   ( (This)->lpVtbl -> EnumContextProps(This,ppEnumContextProps) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IContext_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_objidlbase_0000_0047 */
 

#if !defined BUILDTYPE_COMSVCS && ! (defined _COMBASEAPI_ || defined _OLE32_)


extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0047_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0047_v0_0_s_ifspec;

if not __IObjContext_INTERFACE_DEFINED__
#define __IObjContext_INTERFACE_DEFINED__

/* interface IObjContext */
/* [unique][uuid][object][local] */ 


EXTERN_C const IID IID_IObjContext;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("000001c6-0000-0000-C000-000000000046")
   IObjContext : public IContext
   {
   public:
       virtual void __stdcall Reserved1( void) = 0;
       
       virtual void __stdcall Reserved2( void) = 0;
       
       virtual void __stdcall Reserved3( void) = 0;
       
       virtual void __stdcall Reserved4( void) = 0;
       
       virtual void __stdcall Reserved5( void) = 0;
       
       virtual void __stdcall Reserved6( void) = 0;
       
       virtual void __stdcall Reserved7( void) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IObjContextVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IObjContext * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IObjContext * This);
       
       ULONG ( __stdcall *Release )( 
           IObjContext * This);
       
       HRESULT ( __stdcall *SetProperty )( 
           IObjContext * This,
            
             REFGUID rpolicyId,
            
             CPFLAGS flags,
            
             IUnknown *pUnk);
       
       HRESULT ( __stdcall *RemoveProperty )( 
           IObjContext * This,
            
             REFGUID rPolicyId);
       
       HRESULT ( __stdcall *GetProperty )( 
           IObjContext * This,
            
             REFGUID rGuid,
           /* [annotation][out] */ 
           _Out_  CPFLAGS *pFlags,
           /* [annotation][out] */ 
           _Outptr_  IUnknown **ppUnk);
       
       HRESULT ( __stdcall *EnumContextProps )( 
           IObjContext * This,
           /* [annotation][out] */ 
           _Outptr_  IEnumContextProps **ppEnumContextProps);
       
       void ( __stdcall *Reserved1 )( 
           IObjContext * This);
       
       void ( __stdcall *Reserved2 )( 
           IObjContext * This);
       
       void ( __stdcall *Reserved3 )( 
           IObjContext * This);
       
       void ( __stdcall *Reserved4 )( 
           IObjContext * This);
       
       void ( __stdcall *Reserved5 )( 
           IObjContext * This);
       
       void ( __stdcall *Reserved6 )( 
           IObjContext * This);
       
       void ( __stdcall *Reserved7 )( 
           IObjContext * This);
       
       END_INTERFACE
   } IObjContextVtbl;

   interface IObjContext
   {
       CONST_VTBL struct IObjContextVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IObjContext_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IObjContext_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IObjContext_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IObjContext_SetProperty(This,rpolicyId,flags,pUnk)	\
   ( (This)->lpVtbl -> SetProperty(This,rpolicyId,flags,pUnk) ) 

#define IObjContext_RemoveProperty(This,rPolicyId)	\
   ( (This)->lpVtbl -> RemoveProperty(This,rPolicyId) ) 

#define IObjContext_GetProperty(This,rGuid,pFlags,ppUnk)	\
   ( (This)->lpVtbl -> GetProperty(This,rGuid,pFlags,ppUnk) ) 

#define IObjContext_EnumContextProps(This,ppEnumContextProps)	\
   ( (This)->lpVtbl -> EnumContextProps(This,ppEnumContextProps) ) 


#define IObjContext_Reserved1(This)	\
   ( (This)->lpVtbl -> Reserved1(This) ) 

#define IObjContext_Reserved2(This)	\
   ( (This)->lpVtbl -> Reserved2(This) ) 

#define IObjContext_Reserved3(This)	\
   ( (This)->lpVtbl -> Reserved3(This) ) 

#define IObjContext_Reserved4(This)	\
   ( (This)->lpVtbl -> Reserved4(This) ) 

#define IObjContext_Reserved5(This)	\
   ( (This)->lpVtbl -> Reserved5(This) ) 

#define IObjContext_Reserved6(This)	\
   ( (This)->lpVtbl -> Reserved6(This) ) 

#define IObjContext_Reserved7(This)	\
   ( (This)->lpVtbl -> Reserved7(This) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IObjContext_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_objidlbase_0000_0048 */
 

end
end
end /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)
typedef 
enum _APTTYPEQUALIFIER
   {
       APTTYPEQUALIFIER_NONE	= 0,
       APTTYPEQUALIFIER_IMPLICIT_MTA	= 1,
       APTTYPEQUALIFIER_NA_ON_MTA	= 2,
       APTTYPEQUALIFIER_NA_ON_STA	= 3,
       APTTYPEQUALIFIER_NA_ON_IMPLICIT_MTA	= 4,
       APTTYPEQUALIFIER_NA_ON_MAINSTA	= 5,
       APTTYPEQUALIFIER_APPLICATION_STA	= 6
   } 	APTTYPEQUALIFIER;

typedef 
enum _APTTYPE
   {
       APTTYPE_CURRENT	= -1,
       APTTYPE_STA	= 0,
       APTTYPE_MTA	= 1,
       APTTYPE_NA	= 2,
       APTTYPE_MAINSTA	= 3
   } 	APTTYPE;

end /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)
typedef 
enum _THDTYPE
   {
       THDTYPE_BLOCKMESSAGES	= 0,
       THDTYPE_PROCESSMESSAGES	= 1
   } 	THDTYPE;

typedef DWORD APARTMENTID;



extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0048_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0048_v0_0_s_ifspec;

if not __IComThreadingInfo_INTERFACE_DEFINED__
#define __IComThreadingInfo_INTERFACE_DEFINED__

/* interface IComThreadingInfo */
/* [unique][uuid][object][local] */ 


EXTERN_C const IID IID_IComThreadingInfo;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("000001ce-0000-0000-C000-000000000046")
   IComThreadingInfo : public IUnknown
   {
   public:
       virtual HRESULT __stdcall GetCurrentApartmentType( 
           /* [annotation][out] */ 
           _Out_  APTTYPE *pAptType) = 0;
       
       virtual HRESULT __stdcall GetCurrentThreadType( 
           /* [annotation][out] */ 
           _Out_  THDTYPE *pThreadType) = 0;
       
       virtual HRESULT __stdcall GetCurrentLogicalThreadId( 
           /* [annotation][out] */ 
           _Out_  GUID *pguidLogicalThreadId) = 0;
       
       virtual HRESULT __stdcall SetCurrentLogicalThreadId( 
            
             REFGUID rguid) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IComThreadingInfoVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IComThreadingInfo * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IComThreadingInfo * This);
       
       ULONG ( __stdcall *Release )( 
           IComThreadingInfo * This);
       
       HRESULT ( __stdcall *GetCurrentApartmentType )( 
           IComThreadingInfo * This,
           /* [annotation][out] */ 
           _Out_  APTTYPE *pAptType);
       
       HRESULT ( __stdcall *GetCurrentThreadType )( 
           IComThreadingInfo * This,
           /* [annotation][out] */ 
           _Out_  THDTYPE *pThreadType);
       
       HRESULT ( __stdcall *GetCurrentLogicalThreadId )( 
           IComThreadingInfo * This,
           /* [annotation][out] */ 
           _Out_  GUID *pguidLogicalThreadId);
       
       HRESULT ( __stdcall *SetCurrentLogicalThreadId )( 
           IComThreadingInfo * This,
            
             REFGUID rguid);
       
       END_INTERFACE
   } IComThreadingInfoVtbl;

   interface IComThreadingInfo
   {
       CONST_VTBL struct IComThreadingInfoVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IComThreadingInfo_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IComThreadingInfo_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IComThreadingInfo_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IComThreadingInfo_GetCurrentApartmentType(This,pAptType)	\
   ( (This)->lpVtbl -> GetCurrentApartmentType(This,pAptType) ) 

#define IComThreadingInfo_GetCurrentThreadType(This,pThreadType)	\
   ( (This)->lpVtbl -> GetCurrentThreadType(This,pThreadType) ) 

#define IComThreadingInfo_GetCurrentLogicalThreadId(This,pguidLogicalThreadId)	\
   ( (This)->lpVtbl -> GetCurrentLogicalThreadId(This,pguidLogicalThreadId) ) 

#define IComThreadingInfo_SetCurrentLogicalThreadId(This,rguid)	\
   ( (This)->lpVtbl -> SetCurrentLogicalThreadId(This,rguid) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IComThreadingInfo_INTERFACE_DEFINED__ */


if not __IProcessInitControl_INTERFACE_DEFINED__
#define __IProcessInitControl_INTERFACE_DEFINED__

/* interface IProcessInitControl */
/* [uuid][unique][object] */ 


EXTERN_C const IID IID_IProcessInitControl;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("72380d55-8d2b-43a3-8513-2b6ef31434e9")
   IProcessInitControl : public IUnknown
   {
   public:
       virtual HRESULT __stdcall ResetInitializerTimeout( 
            DWORD dwSecondsRemaining) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IProcessInitControlVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
            IProcessInitControl * This,
             REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
            IProcessInitControl * This);
       
       ULONG ( __stdcall *Release )( 
            IProcessInitControl * This);
       
       HRESULT ( __stdcall *ResetInitializerTimeout )( 
            IProcessInitControl * This,
            DWORD dwSecondsRemaining);
       
       END_INTERFACE
   } IProcessInitControlVtbl;

   interface IProcessInitControl
   {
       CONST_VTBL struct IProcessInitControlVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IProcessInitControl_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IProcessInitControl_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IProcessInitControl_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IProcessInitControl_ResetInitializerTimeout(This,dwSecondsRemaining)	\
   ( (This)->lpVtbl -> ResetInitializerTimeout(This,dwSecondsRemaining) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IProcessInitControl_INTERFACE_DEFINED__ */


if not __IFastRundown_INTERFACE_DEFINED__
#define __IFastRundown_INTERFACE_DEFINED__

/* interface IFastRundown */
/* [uuid][unique][local][object] */ 


EXTERN_C const IID IID_IFastRundown;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("00000040-0000-0000-C000-000000000046")
   IFastRundown : public IUnknown
   {
   public:
   };
   
   
#else 	/* C style interface */

   typedef struct IFastRundownVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IFastRundown * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IFastRundown * This);
       
       ULONG ( __stdcall *Release )( 
           IFastRundown * This);
       
       END_INTERFACE
   } IFastRundownVtbl;

   interface IFastRundown
   {
       CONST_VTBL struct IFastRundownVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IFastRundown_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IFastRundown_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IFastRundown_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IFastRundown_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_objidlbase_0000_0051 */
 

typedef 
enum CO_MARSHALING_CONTEXT_ATTRIBUTES
   {
       CO_MARSHALING_SOURCE_IS_APP_CONTAINER	= 0,
       CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_1	= 0x80000000,
       CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_2	= 0x80000001,
       CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_3	= 0x80000002,
       CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_4	= 0x80000003,
       CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_5	= 0x80000004,
       CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_6	= 0x80000005,
       CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_7	= 0x80000006,
       CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_8	= 0x80000007,
       CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_9	= 0x80000008,
       CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_10	= 0x80000009,
       CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_11	= 0x8000000a,
       CO_MARSHALING_CONTEXT_ATTRIBUTE_RESERVED_12	= 0x8000000b
   } 	CO_MARSHALING_CONTEXT_ATTRIBUTES;



extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0051_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0051_v0_0_s_ifspec;

if not __IMarshalingStream_INTERFACE_DEFINED__
#define __IMarshalingStream_INTERFACE_DEFINED__

/* interface IMarshalingStream */
/* [unique][uuid][object][local] */ 


EXTERN_C const IID IID_IMarshalingStream;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("D8F2F5E6-6102-4863-9F26-389A4676EFDE")
   IMarshalingStream : public IStream
   {
   public:
       virtual HRESULT __stdcall GetMarshalingContextAttribute( 
            CO_MARSHALING_CONTEXT_ATTRIBUTES attribute,
            ULONG_PTR *pAttributeValue) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IMarshalingStreamVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IMarshalingStream * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IMarshalingStream * This);
       
       ULONG ( __stdcall *Release )( 
           IMarshalingStream * This);
       
        HRESULT ( __stdcall *Read )( 
           IMarshalingStream * This,
            
             void *pv,
            
             ULONG cb,
            
             ULONG *pcbRead);
       
        HRESULT ( __stdcall *Write )( 
           IMarshalingStream * This,
            
             const void *pv,
            
             ULONG cb,
            
             ULONG *pcbWritten);
       
        HRESULT ( __stdcall *Seek )( 
           IMarshalingStream * This,
            LARGE_INTEGER dlibMove,
            DWORD dwOrigin,
            
             ULARGE_INTEGER *plibNewPosition);
       
       HRESULT ( __stdcall *SetSize )( 
           IMarshalingStream * This,
            ULARGE_INTEGER libNewSize);
       
        HRESULT ( __stdcall *CopyTo )( 
           IMarshalingStream * This,
            
             IStream *pstm,
            ULARGE_INTEGER cb,
            
             ULARGE_INTEGER *pcbRead,
            
             ULARGE_INTEGER *pcbWritten);
       
       HRESULT ( __stdcall *Commit )( 
           IMarshalingStream * This,
            DWORD grfCommitFlags);
       
       HRESULT ( __stdcall *Revert )( 
           IMarshalingStream * This);
       
       HRESULT ( __stdcall *LockRegion )( 
           IMarshalingStream * This,
            ULARGE_INTEGER libOffset,
            ULARGE_INTEGER cb,
            DWORD dwLockType);
       
       HRESULT ( __stdcall *UnlockRegion )( 
           IMarshalingStream * This,
            ULARGE_INTEGER libOffset,
            ULARGE_INTEGER cb,
            DWORD dwLockType);
       
       HRESULT ( __stdcall *Stat )( 
           IMarshalingStream * This,
            STATSTG *pstatstg,
            DWORD grfStatFlag);
       
       HRESULT ( __stdcall *Clone )( 
           IMarshalingStream * This,
            IStream **ppstm);
       
       HRESULT ( __stdcall *GetMarshalingContextAttribute )( 
           IMarshalingStream * This,
            CO_MARSHALING_CONTEXT_ATTRIBUTES attribute,
            ULONG_PTR *pAttributeValue);
       
       END_INTERFACE
   } IMarshalingStreamVtbl;

   interface IMarshalingStream
   {
       CONST_VTBL struct IMarshalingStreamVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IMarshalingStream_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IMarshalingStream_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IMarshalingStream_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IMarshalingStream_Read(This,pv,cb,pcbRead)	\
   ( (This)->lpVtbl -> Read(This,pv,cb,pcbRead) ) 

#define IMarshalingStream_Write(This,pv,cb,pcbWritten)	\
   ( (This)->lpVtbl -> Write(This,pv,cb,pcbWritten) ) 


#define IMarshalingStream_Seek(This,dlibMove,dwOrigin,plibNewPosition)	\
   ( (This)->lpVtbl -> Seek(This,dlibMove,dwOrigin,plibNewPosition) ) 

#define IMarshalingStream_SetSize(This,libNewSize)	\
   ( (This)->lpVtbl -> SetSize(This,libNewSize) ) 

#define IMarshalingStream_CopyTo(This,pstm,cb,pcbRead,pcbWritten)	\
   ( (This)->lpVtbl -> CopyTo(This,pstm,cb,pcbRead,pcbWritten) ) 

#define IMarshalingStream_Commit(This,grfCommitFlags)	\
   ( (This)->lpVtbl -> Commit(This,grfCommitFlags) ) 

#define IMarshalingStream_Revert(This)	\
   ( (This)->lpVtbl -> Revert(This) ) 

#define IMarshalingStream_LockRegion(This,libOffset,cb,dwLockType)	\
   ( (This)->lpVtbl -> LockRegion(This,libOffset,cb,dwLockType) ) 

#define IMarshalingStream_UnlockRegion(This,libOffset,cb,dwLockType)	\
   ( (This)->lpVtbl -> UnlockRegion(This,libOffset,cb,dwLockType) ) 

#define IMarshalingStream_Stat(This,pstatstg,grfStatFlag)	\
   ( (This)->lpVtbl -> Stat(This,pstatstg,grfStatFlag) ) 

#define IMarshalingStream_Clone(This,ppstm)	\
   ( (This)->lpVtbl -> Clone(This,ppstm) ) 


#define IMarshalingStream_GetMarshalingContextAttribute(This,attribute,pAttributeValue)	\
   ( (This)->lpVtbl -> GetMarshalingContextAttribute(This,attribute,pAttributeValue) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IMarshalingStream_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_objidlbase_0000_0052 */
 

end /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0052_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0052_v0_0_s_ifspec;

if not __IAgileReference_INTERFACE_DEFINED__
#define __IAgileReference_INTERFACE_DEFINED__

/* interface IAgileReference */
/* [unique][uuid][object][local] */ 

#if defined(__cplusplus) && !defined(CINTERFACE)
   EXTERN_C const IID IID_IAgileReference;
   extern "C++"
   {
       MIDL_INTERFACE("C03F6A43-65A4-9818-987E-E0B810D2A6F2")
       IAgileReference : public IUnknown
       {
       public:
           virtual HRESULT __stdcall Resolve( 
                REFIID riid,
               /* [iid_is][retval][out] */ void **ppvObjectReference) = 0;

           template<class Q>
           HRESULT
#ifdef _M_CEE_PURE
           __clrcall
#else
           __stdcall
end
           Resolve( Q** pp)
           {
               return Resolve(__uuidof(Q), (void **)pp);
           }

       };
   } // extern C++
#else

EXTERN_C const IID IID_IAgileReference;

#if defined(__cplusplus) && !defined(CINTERFACE)
   
   MIDL_INTERFACE("C03F6A43-65A4-9818-987E-E0B810D2A6F2")
   IAgileReference : public IUnknown
   {
   public:
       virtual HRESULT __stdcall Resolve( 
            REFIID riid,
           /* [iid_is][retval][out] */ void **ppvObjectReference) = 0;
       
   };
   
   
#else 	/* C style interface */

   typedef struct IAgileReferenceVtbl
   {
       BEGIN_INTERFACE
       
       HRESULT ( __stdcall *QueryInterface )( 
           IAgileReference * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IAgileReference * This);
       
       ULONG ( __stdcall *Release )( 
           IAgileReference * This);
       
       HRESULT ( __stdcall *Resolve )( 
           IAgileReference * This,
            REFIID riid,
           /* [iid_is][retval][out] */ void **ppvObjectReference);
       
       END_INTERFACE
   } IAgileReferenceVtbl;

   interface IAgileReference
   {
       CONST_VTBL struct IAgileReferenceVtbl *lpVtbl;
   };

   

#ifdef COBJMACROS


#define IAgileReference_QueryInterface(This,riid,ppvObject)	\
   ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IAgileReference_AddRef(This)	\
   ( (This)->lpVtbl -> AddRef(This) ) 

#define IAgileReference_Release(This)	\
   ( (This)->lpVtbl -> Release(This) ) 


#define IAgileReference_Resolve(This,riid,ppvObjectReference)	\
   ( (This)->lpVtbl -> Resolve(This,riid,ppvObjectReference) ) 

end /* COBJMACROS */


end 	/* C style interface */




end 	/* __IAgileReference_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_objidlbase_0000_0053 */
 

end
end /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)
EXTERN_C const GUID  IID_ICallbackWithNoReentrancyToApplicationSTA;
end /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
#pragma endregion
#define _OBJIDLBASE_
end
#if ( _MSC_VER >= 800 )
#if _MSC_VER >= 1200
#pragma warning(pop)
#else
#pragma warning(default:4201)
end
end


extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0053_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_objidlbase_0000_0053_v0_0_s_ifspec;

/* Additional Prototypes for ALL interfaces */

 HRESULT __stdcall IEnumUnknown_Next_Proxy( 
   IEnumUnknown * This,
    
     ULONG celt,
   /* [annotation][out] */ 
   _Out_writes_to_(celt,*pceltFetched)  IUnknown **rgelt,
   /* [annotation][out] */ 
     ULONG *pceltFetched);


 HRESULT __stdcall IEnumUnknown_Next_Stub( 
    IEnumUnknown * This,
    ULONG celt,
   /* [length_is][size_is][out] */ __RPC__out_ecount_part(celt, *pceltFetched) IUnknown **rgelt,
     ULONG *pceltFetched);

 HRESULT __stdcall IEnumString_Next_Proxy( 
   IEnumString * This,
    ULONG celt,
    
   _Out_writes_to_(celt,*pceltFetched)  LPOLESTR *rgelt,
    
     ULONG *pceltFetched);


 HRESULT __stdcall IEnumString_Next_Stub( 
    IEnumString * This,
    ULONG celt,
   /* [length_is][size_is][out] */ __RPC__out_ecount_part(celt, *pceltFetched) LPOLESTR *rgelt,
     ULONG *pceltFetched);

 HRESULT __stdcall ISequentialStream_Read_Proxy( 
   ISequentialStream * This,
    
     void *pv,
    
     ULONG cb,
    
     ULONG *pcbRead);


 HRESULT __stdcall ISequentialStream_Read_Stub( 
    ISequentialStream * This,
   /* [length_is][size_is][out] */ __RPC__out_ecount_part(cb, *pcbRead) byte *pv,
    ULONG cb,
     ULONG *pcbRead);

 HRESULT __stdcall ISequentialStream_Write_Proxy( 
   ISequentialStream * This,
    
     const void *pv,
    
     ULONG cb,
    
     ULONG *pcbWritten);


 HRESULT __stdcall ISequentialStream_Write_Stub( 
    ISequentialStream * This,
   /* [size_is][in] */ __RPC__in_ecount_full(cb) const byte *pv,
    ULONG cb,
     ULONG *pcbWritten);

 HRESULT __stdcall IStream_Seek_Proxy( 
   IStream * This,
    LARGE_INTEGER dlibMove,
    DWORD dwOrigin,
    
     ULARGE_INTEGER *plibNewPosition);


 HRESULT __stdcall IStream_Seek_Stub( 
    IStream * This,
    LARGE_INTEGER dlibMove,
    DWORD dwOrigin,
     ULARGE_INTEGER *plibNewPosition);

 HRESULT __stdcall IStream_CopyTo_Proxy( 
   IStream * This,
    
     IStream *pstm,
    ULARGE_INTEGER cb,
    
     ULARGE_INTEGER *pcbRead,
    
     ULARGE_INTEGER *pcbWritten);


 HRESULT __stdcall IStream_CopyTo_Stub( 
    IStream * This,
     IStream *pstm,
    ULARGE_INTEGER cb,
     ULARGE_INTEGER *pcbRead,
     ULARGE_INTEGER *pcbWritten);
--]=]




end


