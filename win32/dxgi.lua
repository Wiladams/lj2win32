

local ffi = require("ffi")

if not __REQUIRED_RPCNDR_H_VERSION__ then
__REQUIRED_RPCNDR_H_VERSION__ = 500;
end


if not __REQUIRED_RPCSAL_H_VERSION__ then
__REQUIRED_RPCSAL_H_VERSION__ = 100
end

--require("win32.rpc")
require("win32.rpcndr")

if not __RPCNDR_H_VERSION__ then
error ("this stub requires an updated version of <rpcndr.h>")
end --/* __RPCNDR_H_VERSION__ */

if not COM_NO_WINDOWS_H then
require("win32.windows")
require("win32.ole2")
end --/*COM_NO_WINDOWS_H*/


local com_meta = {
    __index = function (self, key)
        return self.lpVtbl[key]
    end;
}


if not __dxgi_h__ then
__dxgi_h__ = true



if not __IDXGIObject_FWD_DEFINED__ then
__IDXGIObject_FWD_DEFINED__ = true;
ffi.cdef[[
    typedef struct IDXGIObject IDXGIObject;
]]
end 	--/* __IDXGIObject_FWD_DEFINED__ */


if not __IDXGIDeviceSubObject_FWD_DEFINED__ then
__IDXGIDeviceSubObject_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IDXGIDeviceSubObject IDXGIDeviceSubObject;
]]
end 	--/* __IDXGIDeviceSubObject_FWD_DEFINED__ */


if not  __IDXGIResource_FWD_DEFINED__ then
__IDXGIResource_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IDXGIResource IDXGIResource;
]]
end 	--/* __IDXGIResource_FWD_DEFINED__ */


if not __IDXGIKeyedMutex_FWD_DEFINED__ then
__IDXGIKeyedMutex_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct IDXGIKeyedMutex IDXGIKeyedMutex;
]]
end 	--/* __IDXGIKeyedMutex_FWD_DEFINED__ */


if not __IDXGISurface_FWD_DEFINED__ then
__IDXGISurface_FWD_DEFINED__ = true;
ffi.cdef[[
    typedef struct IDXGISurface IDXGISurface;
]]
end 	--/* __IDXGISurface_FWD_DEFINED__ */

ffi.cdef[[
typedef struct IDXGISurface1 IDXGISurface1;
typedef struct IDXGIAdapter IDXGIAdapter;
typedef struct IDXGIOutput IDXGIOutput;
typedef struct IDXGISwapChain IDXGISwapChain;
typedef struct IDXGIFactory IDXGIFactory;
typedef struct IDXGIDevice IDXGIDevice;
typedef struct IDXGIFactory1 IDXGIFactory1;
typedef struct IDXGIAdapter1 IDXGIAdapter1;
typedef struct IDXGIDevice1 IDXGIDevice1;
]]



--#include "oaidl.h"
--#include "ocidl.h"
require("win32.dxgicommon")
require("win32.dxgitype")



require("win32.winapifamily")

--[[
-- these are in dxgitype
ffi.cdef[[
static const int DXGI_CPU_ACCESS_NONE               = 0;
static const int DXGI_CPU_ACCESS_DYNAMIC            = 1;
static const int DXGI_CPU_ACCESS_READ_WRITE         = 2;
static const int DXGI_CPU_ACCESS_SCRATCH            = 3;
static const int DXGI_CPU_ACCESS_FIELD              = 15;
]]
--]]

ffi.cdef[[
static const int DXGI_USAGE_SHADER_INPUT           =  0x00000010;
static const int DXGI_USAGE_RENDER_TARGET_OUTPUT   =  0x00000020;
static const int DXGI_USAGE_BACK_BUFFER            =  0x00000040;
static const int DXGI_USAGE_SHARED                 =  0x00000080;
static const int DXGI_USAGE_READ_ONLY              =  0x00000100;
static const int DXGI_USAGE_DISCARD_ON_PRESENT     =  0x00000200;
static const int DXGI_USAGE_UNORDERED_ACCESS       =  0x00000400;
]]

ffi.cdef[[
typedef UINT DXGI_USAGE;

typedef struct DXGI_FRAME_STATISTICS
   {
   UINT PresentCount;
   UINT PresentRefreshCount;
   UINT SyncRefreshCount;
   LARGE_INTEGER SyncQPCTime;
   LARGE_INTEGER SyncGPUTime;
   } 	DXGI_FRAME_STATISTICS;

typedef struct DXGI_MAPPED_RECT
   {
   INT Pitch;
   BYTE *pBits;
   } 	DXGI_MAPPED_RECT;
]]

--[[
#ifdef __midl
#ifndef LUID_DEFINED
#define LUID_DEFINED 1
typedef struct _LUID
   {
   DWORD LowPart;
   LONG HighPart;
   } 	LUID;

typedef struct _LUID *PLUID;

end
end
--]]

ffi.cdef[[
typedef struct DXGI_ADAPTER_DESC
   {
   WCHAR Description[ 128 ];
   UINT VendorId;
   UINT DeviceId;
   UINT SubSysId;
   UINT Revision;
   SIZE_T DedicatedVideoMemory;
   SIZE_T DedicatedSystemMemory;
   SIZE_T SharedSystemMemory;
   LUID AdapterLuid;
   } 	DXGI_ADAPTER_DESC;
]]

--[[
if !defined(HMONITOR_DECLARED) and !defined(HMONITOR) and (WINVER < 0x0500) then
HMONITOR_DECLARED = true

DECLARE_HANDLE("HMONITOR");
end
--]]

ffi.cdef[[
typedef struct DXGI_OUTPUT_DESC
   {
   WCHAR DeviceName[ 32 ];
   RECT DesktopCoordinates;
   BOOL AttachedToDesktop;
   DXGI_MODE_ROTATION Rotation;
   HMONITOR Monitor;
   } 	DXGI_OUTPUT_DESC;

typedef struct DXGI_SHARED_RESOURCE
   {
   HANDLE Handle;
   } 	DXGI_SHARED_RESOURCE;
]]

ffi.cdef[[
static const int 	DXGI_RESOURCE_PRIORITY_MINIMUM	= 0x28000000;
static const int 	DXGI_RESOURCE_PRIORITY_LOW	= 0x50000000;
static const int 	DXGI_RESOURCE_PRIORITY_NORMAL	= 0x78000000;
static const int 	DXGI_RESOURCE_PRIORITY_HIGH	= 0xa0000000;
static const int 	DXGI_RESOURCE_PRIORITY_MAXIMUM	= 0xc8000000;
]]

ffi.cdef[[
typedef 
enum DXGI_RESIDENCY
   {
       DXGI_RESIDENCY_FULLY_RESIDENT	= 1,
       DXGI_RESIDENCY_RESIDENT_IN_SHARED_MEMORY	= 2,
       DXGI_RESIDENCY_EVICTED_TO_DISK	= 3
   } 	DXGI_RESIDENCY;

typedef struct DXGI_SURFACE_DESC
   {
   UINT Width;
   UINT Height;
   DXGI_FORMAT Format;
   DXGI_SAMPLE_DESC SampleDesc;
   } 	DXGI_SURFACE_DESC;

typedef 
enum DXGI_SWAP_EFFECT
   {
       DXGI_SWAP_EFFECT_DISCARD	= 0,
       DXGI_SWAP_EFFECT_SEQUENTIAL	= 1,
       DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL	= 3,
       DXGI_SWAP_EFFECT_FLIP_DISCARD	= 4
   } 	DXGI_SWAP_EFFECT;

typedef 
enum DXGI_SWAP_CHAIN_FLAG
   {
       DXGI_SWAP_CHAIN_FLAG_NONPREROTATED	= 1,
       DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH	= 2,
       DXGI_SWAP_CHAIN_FLAG_GDI_COMPATIBLE	= 4,
       DXGI_SWAP_CHAIN_FLAG_RESTRICTED_CONTENT	= 8,
       DXGI_SWAP_CHAIN_FLAG_RESTRICT_SHARED_RESOURCE_DRIVER	= 16,
       DXGI_SWAP_CHAIN_FLAG_DISPLAY_ONLY	= 32,
       DXGI_SWAP_CHAIN_FLAG_FRAME_LATENCY_WAITABLE_OBJECT	= 64,
       DXGI_SWAP_CHAIN_FLAG_FOREGROUND_LAYER	= 128,
       DXGI_SWAP_CHAIN_FLAG_FULLSCREEN_VIDEO	= 256,
       DXGI_SWAP_CHAIN_FLAG_YUV_VIDEO	= 512,
       DXGI_SWAP_CHAIN_FLAG_HW_PROTECTED	= 1024,
       DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING	= 2048,
       DXGI_SWAP_CHAIN_FLAG_RESTRICTED_TO_ALL_HOLOGRAPHIC_DISPLAYS	= 4096
   } 	DXGI_SWAP_CHAIN_FLAG;

typedef struct DXGI_SWAP_CHAIN_DESC
   {
   DXGI_MODE_DESC BufferDesc;
   DXGI_SAMPLE_DESC SampleDesc;
   DXGI_USAGE BufferUsage;
   UINT BufferCount;
   HWND OutputWindow;
   BOOL Windowed;
   DXGI_SWAP_EFFECT SwapEffect;
   UINT Flags;
   } 	DXGI_SWAP_CHAIN_DESC;
]]



--EXTERN_C const IID IID_IDXGIObject;


ffi.cdef[[

   typedef struct IDXGIObjectVtbl
   {
       
       
       HRESULT ( __stdcall *QueryInterface )( 
           IDXGIObject * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IDXGIObject * This);
       
       ULONG ( __stdcall *Release )( 
           IDXGIObject * This);
       
       HRESULT ( __stdcall *SetPrivateData )( 
           IDXGIObject * This,
           
             REFGUID Name,
            UINT DataSize,
           
             const void *pData);
       
       HRESULT ( __stdcall *SetPrivateDataInterface )( 
           IDXGIObject * This,
           
             REFGUID Name,
           
             const IUnknown *pUnknown);
       
       HRESULT ( __stdcall *GetPrivateData )( 
           IDXGIObject * This,
           
             REFGUID Name,
            
             UINT *pDataSize,
            
             void *pData);
       
       HRESULT ( __stdcall *GetParent )( 
           IDXGIObject * This,
           
             REFIID riid,
            
             void **ppParent);
       
       
   } IDXGIObjectVtbl;

   typedef struct IDXGIObject
   {
       const struct IDXGIObjectVtbl *lpVtbl;
   };
]]
   





--EXTERN_C const IID IID_IDXGIDeviceSubObject;


ffi.cdef[[
   typedef struct IDXGIDeviceSubObjectVtbl
   {
       
       
       HRESULT ( __stdcall *QueryInterface )( 
           IDXGIDeviceSubObject * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IDXGIDeviceSubObject * This);
       
       ULONG ( __stdcall *Release )( 
           IDXGIDeviceSubObject * This);
       
       HRESULT ( __stdcall *SetPrivateData )( 
           IDXGIDeviceSubObject * This,
           
             REFGUID Name,
            UINT DataSize,
           
             const void *pData);
       
       HRESULT ( __stdcall *SetPrivateDataInterface )( 
           IDXGIDeviceSubObject * This,
           
             REFGUID Name,
           
             const IUnknown *pUnknown);
       
       HRESULT ( __stdcall *GetPrivateData )( 
           IDXGIDeviceSubObject * This,
           
             REFGUID Name,
            
             UINT *pDataSize,
            
             void *pData);
       
       HRESULT ( __stdcall *GetParent )( 
           IDXGIDeviceSubObject * This,
           
             REFIID riid,
            
             void **ppParent);
       
       HRESULT ( __stdcall *GetDevice )( 
           IDXGIDeviceSubObject * This,
           
             REFIID riid,
            
             void **ppDevice);
       
       
   } IDXGIDeviceSubObjectVtbl;

   struct IDXGIDeviceSubObject
   {
       const struct IDXGIDeviceSubObjectVtbl *lpVtbl;
   };
]]
   




--EXTERN_C const IID IID_IDXGIResource;

ffi.cdef[[
   typedef struct IDXGIResourceVtbl
   {
       
       
       HRESULT ( __stdcall *QueryInterface )( 
           IDXGIResource * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IDXGIResource * This);
       
       ULONG ( __stdcall *Release )( 
           IDXGIResource * This);
       
       HRESULT ( __stdcall *SetPrivateData )( 
           IDXGIResource * This,
           
             REFGUID Name,
            UINT DataSize,
           
             const void *pData);
       
       HRESULT ( __stdcall *SetPrivateDataInterface )( 
           IDXGIResource * This,
           
             REFGUID Name,
           
             const IUnknown *pUnknown);
       
       HRESULT ( __stdcall *GetPrivateData )( 
           IDXGIResource * This,
           
             REFGUID Name,
            
             UINT *pDataSize,
            
             void *pData);
       
       HRESULT ( __stdcall *GetParent )( 
           IDXGIResource * This,
           
             REFIID riid,
            
             void **ppParent);
       
       HRESULT ( __stdcall *GetDevice )( 
           IDXGIResource * This,
           
             REFIID riid,
            
             void **ppDevice);
       
       HRESULT ( __stdcall *GetSharedHandle )( 
           IDXGIResource * This,
            
             HANDLE *pSharedHandle);
       
       HRESULT ( __stdcall *GetUsage )( 
           IDXGIResource * This,
            DXGI_USAGE *pUsage);
       
       HRESULT ( __stdcall *SetEvictionPriority )( 
           IDXGIResource * This,
            UINT EvictionPriority);
       
       HRESULT ( __stdcall *GetEvictionPriority )( 
           IDXGIResource * This,
            
             UINT *pEvictionPriority);
       
       
   } IDXGIResourceVtbl;

   struct IDXGIResource
   {
       const struct IDXGIResourceVtbl *lpVtbl;
   };
]]





ffi.cdef[[
   typedef struct IDXGIKeyedMutexVtbl
   {
       
       
       HRESULT ( __stdcall *QueryInterface )( 
           IDXGIKeyedMutex * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IDXGIKeyedMutex * This);
       
       ULONG ( __stdcall *Release )( 
           IDXGIKeyedMutex * This);
       
       HRESULT ( __stdcall *SetPrivateData )( 
           IDXGIKeyedMutex * This,
           
             REFGUID Name,
            UINT DataSize,
           
             const void *pData);
       
       HRESULT ( __stdcall *SetPrivateDataInterface )( 
           IDXGIKeyedMutex * This,
           
             REFGUID Name,
           
             const IUnknown *pUnknown);
       
       HRESULT ( __stdcall *GetPrivateData )( 
           IDXGIKeyedMutex * This,
           
             REFGUID Name,
            
             UINT *pDataSize,
            
             void *pData);
       
       HRESULT ( __stdcall *GetParent )( 
           IDXGIKeyedMutex * This,
           
             REFIID riid,
            
             void **ppParent);
       
       HRESULT ( __stdcall *GetDevice )( 
           IDXGIKeyedMutex * This,
           
             REFIID riid,
            
             void **ppDevice);
       
       HRESULT ( __stdcall *AcquireSync )( 
           IDXGIKeyedMutex * This,
            UINT64 Key,
            DWORD dwMilliseconds);
       
       HRESULT ( __stdcall *ReleaseSync )( 
           IDXGIKeyedMutex * This,
            UINT64 Key);
       
       
   } IDXGIKeyedMutexVtbl;

   struct IDXGIKeyedMutex
   {
       const struct IDXGIKeyedMutexVtbl *lpVtbl;
   };
]]




ffi.cdef[[
static const int	DXGI_MAP_READ	= 1;
static const int	DXGI_MAP_WRITE	= 2;
static const int	DXGI_MAP_DISCARD	= 4;
]]




ffi.cdef[[
   typedef struct IDXGISurfaceVtbl
   {
       
       
       HRESULT ( __stdcall *QueryInterface )( 
           IDXGISurface * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IDXGISurface * This);
       
       ULONG ( __stdcall *Release )( 
           IDXGISurface * This);
       
       HRESULT ( __stdcall *SetPrivateData )( 
           IDXGISurface * This,
           
             REFGUID Name,
            UINT DataSize,
           
             const void *pData);
       
       HRESULT ( __stdcall *SetPrivateDataInterface )( 
           IDXGISurface * This,
           
             REFGUID Name,
           
             const IUnknown *pUnknown);
       
       HRESULT ( __stdcall *GetPrivateData )( 
           IDXGISurface * This,
           
             REFGUID Name,
            
             UINT *pDataSize,
            
             void *pData);
       
       HRESULT ( __stdcall *GetParent )( 
           IDXGISurface * This,
           
             REFIID riid,
            
             void **ppParent);
       
       HRESULT ( __stdcall *GetDevice )( 
           IDXGISurface * This,
           
             REFIID riid,
            
             void **ppDevice);
       
       HRESULT ( __stdcall *GetDesc )( 
           IDXGISurface * This,
            
             DXGI_SURFACE_DESC *pDesc);
       
       HRESULT ( __stdcall *Map )( 
           IDXGISurface * This,
            
             DXGI_MAPPED_RECT *pLockedRect,
            UINT MapFlags);
       
       HRESULT ( __stdcall *Unmap )( 
           IDXGISurface * This);
       
       
   } IDXGISurfaceVtbl;

   struct IDXGISurface
   {
       const struct IDXGISurfaceVtbl *lpVtbl;
   };
]]





ffi.cdef[[
   typedef struct IDXGISurface1Vtbl
   {
       
       
       HRESULT ( __stdcall *QueryInterface )( 
           IDXGISurface1 * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IDXGISurface1 * This);
       
       ULONG ( __stdcall *Release )( 
           IDXGISurface1 * This);
       
       HRESULT ( __stdcall *SetPrivateData )( 
           IDXGISurface1 * This,
           
             REFGUID Name,
            UINT DataSize,
           
             const void *pData);
       
       HRESULT ( __stdcall *SetPrivateDataInterface )( 
           IDXGISurface1 * This,
           
             REFGUID Name,
           
             const IUnknown *pUnknown);
       
       HRESULT ( __stdcall *GetPrivateData )( 
           IDXGISurface1 * This,
           
             REFGUID Name,
            
             UINT *pDataSize,
            
             void *pData);
       
       HRESULT ( __stdcall *GetParent )( 
           IDXGISurface1 * This,
           
             REFIID riid,
            
             void **ppParent);
       
       HRESULT ( __stdcall *GetDevice )( 
           IDXGISurface1 * This,
           
             REFIID riid,
            
             void **ppDevice);
       
       HRESULT ( __stdcall *GetDesc )( 
           IDXGISurface1 * This,
            
             DXGI_SURFACE_DESC *pDesc);
       
       HRESULT ( __stdcall *Map )( 
           IDXGISurface1 * This,
            
             DXGI_MAPPED_RECT *pLockedRect,
            UINT MapFlags);
       
       HRESULT ( __stdcall *Unmap )( 
           IDXGISurface1 * This);
       
       HRESULT ( __stdcall *GetDC )( 
           IDXGISurface1 * This,
            BOOL Discard,
            
             HDC *phdc);
       
       HRESULT ( __stdcall *ReleaseDC )( 
           IDXGISurface1 * This,
           
             RECT *pDirtyRect);
       
       
   } IDXGISurface1Vtbl;

   struct IDXGISurface1
   {
       const struct IDXGISurface1Vtbl *lpVtbl;
   };
]]





ffi.cdef[[
   typedef struct IDXGIAdapterVtbl
   {
       
       
       HRESULT ( __stdcall *QueryInterface )( 
           IDXGIAdapter * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IDXGIAdapter * This);
       
       ULONG ( __stdcall *Release )( 
           IDXGIAdapter * This);
       
       HRESULT ( __stdcall *SetPrivateData )( 
           IDXGIAdapter * This,
           
             REFGUID Name,
            UINT DataSize,
           
             const void *pData);
       
       HRESULT ( __stdcall *SetPrivateDataInterface )( 
           IDXGIAdapter * This,
           
             REFGUID Name,
           
             const IUnknown *pUnknown);
       
       HRESULT ( __stdcall *GetPrivateData )( 
           IDXGIAdapter * This,
           
             REFGUID Name,
            
             UINT *pDataSize,
            
             void *pData);
       
       HRESULT ( __stdcall *GetParent )( 
           IDXGIAdapter * This,
           
             REFIID riid,
            
             void **ppParent);
       
       HRESULT ( __stdcall *EnumOutputs )( 
           IDXGIAdapter * This,
            UINT Output,
            
             IDXGIOutput **ppOutput);
       
       HRESULT ( __stdcall *GetDesc )( 
           IDXGIAdapter * This,
            
             DXGI_ADAPTER_DESC *pDesc);
       
       HRESULT ( __stdcall *CheckInterfaceSupport )( 
           IDXGIAdapter * This,
           
             REFGUID InterfaceName,
            
             LARGE_INTEGER *pUMDVersion);
       
       
   } IDXGIAdapterVtbl;

   struct IDXGIAdapter
   {
       const struct IDXGIAdapterVtbl *lpVtbl;
   };
]]
   






ffi.cdef[[
static const int	DXGI_ENUM_MODES_INTERLACED	= 1;
static const int	DXGI_ENUM_MODES_SCALING	 = 2;
]]



ffi.cdef[[
   typedef struct IDXGIOutputVtbl
   {
       
       
       HRESULT ( __stdcall *QueryInterface )( 
           IDXGIOutput * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IDXGIOutput * This);
       
       ULONG ( __stdcall *Release )( 
           IDXGIOutput * This);
       
       HRESULT ( __stdcall *SetPrivateData )( 
           IDXGIOutput * This,
           
             REFGUID Name,
            UINT DataSize,
           
             const void *pData);
       
       HRESULT ( __stdcall *SetPrivateDataInterface )( 
           IDXGIOutput * This,
           
             REFGUID Name,
           
             const IUnknown *pUnknown);
       
       HRESULT ( __stdcall *GetPrivateData )( 
           IDXGIOutput * This,
           
             REFGUID Name,
            
             UINT *pDataSize,
            
             void *pData);
       
       HRESULT ( __stdcall *GetParent )( 
           IDXGIOutput * This,
           
             REFIID riid,
            
             void **ppParent);
       
       HRESULT ( __stdcall *GetDesc )( 
           IDXGIOutput * This,
            
             DXGI_OUTPUT_DESC *pDesc);
       
       HRESULT ( __stdcall *GetDisplayModeList )( 
           IDXGIOutput * This,
            DXGI_FORMAT EnumFormat,
            UINT Flags,
            
             UINT *pNumModes,
            
           _Out_writes_to_opt_(*pNumModes,*pNumModes)  DXGI_MODE_DESC *pDesc);
       
       HRESULT ( __stdcall *FindClosestMatchingMode )( 
           IDXGIOutput * This,
           
             const DXGI_MODE_DESC *pModeToMatch,
            
             DXGI_MODE_DESC *pClosestMatch,
           
             IUnknown *pConcernedDevice);
       
       HRESULT ( __stdcall *WaitForVBlank )( 
           IDXGIOutput * This);
       
       HRESULT ( __stdcall *TakeOwnership )( 
           IDXGIOutput * This,
           
             IUnknown *pDevice,
           BOOL Exclusive);
       
       void ( __stdcall *ReleaseOwnership )( 
           IDXGIOutput * This);
       
       HRESULT ( __stdcall *GetGammaControlCapabilities )( 
           IDXGIOutput * This,
            
             DXGI_GAMMA_CONTROL_CAPABILITIES *pGammaCaps);
       
       HRESULT ( __stdcall *SetGammaControl )( 
           IDXGIOutput * This,
           
             const DXGI_GAMMA_CONTROL *pArray);
       
       HRESULT ( __stdcall *GetGammaControl )( 
           IDXGIOutput * This,
            
             DXGI_GAMMA_CONTROL *pArray);
       
       HRESULT ( __stdcall *SetDisplaySurface )( 
           IDXGIOutput * This,
           
             IDXGISurface *pScanoutSurface);
       
       HRESULT ( __stdcall *GetDisplaySurfaceData )( 
           IDXGIOutput * This,
           
             IDXGISurface *pDestination);
       
       HRESULT ( __stdcall *GetFrameStatistics )( 
           IDXGIOutput * This,
            
             DXGI_FRAME_STATISTICS *pStats);
       
       
   } IDXGIOutputVtbl;

   typedef struct IDXGIOutput
   {
       const struct IDXGIOutputVtbl *lpVtbl;
   };
]]
   





ffi.cdef[[
static const int DXGI_MAX_SWAP_CHAIN_BUFFERS        = 16;
static const int DXGI_PRESENT_TEST                      = 0x00000001UL;
static const int DXGI_PRESENT_DO_NOT_SEQUENCE           = 0x00000002UL;
static const int DXGI_PRESENT_RESTART                   = 0x00000004UL;
static const int DXGI_PRESENT_DO_NOT_WAIT               = 0x00000008UL;
static const int DXGI_PRESENT_STEREO_PREFER_RIGHT       = 0x00000010UL;
static const int DXGI_PRESENT_STEREO_TEMPORARY_MONO     = 0x00000020UL;
static const int DXGI_PRESENT_RESTRICT_TO_OUTPUT        = 0x00000040UL;
static const int DXGI_PRESENT_USE_DURATION              = 0x00000100UL;
static const int DXGI_PRESENT_ALLOW_TEARING             = 0x00000200UL;
]]


ffi.cdef[[
   typedef struct IDXGISwapChainVtbl
   {
       
       
       HRESULT ( __stdcall *QueryInterface )( 
           IDXGISwapChain * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IDXGISwapChain * This);
       
       ULONG ( __stdcall *Release )( 
           IDXGISwapChain * This);
       
       HRESULT ( __stdcall *SetPrivateData )( 
           IDXGISwapChain * This,
           
             REFGUID Name,
            UINT DataSize,
           
             const void *pData);
       
       HRESULT ( __stdcall *SetPrivateDataInterface )( 
           IDXGISwapChain * This,
           
             REFGUID Name,
           
             const IUnknown *pUnknown);
       
       HRESULT ( __stdcall *GetPrivateData )( 
           IDXGISwapChain * This,
           
             REFGUID Name,
            
             UINT *pDataSize,
            
             void *pData);
       
       HRESULT ( __stdcall *GetParent )( 
           IDXGISwapChain * This,
           
             REFIID riid,
            
             void **ppParent);
       
       HRESULT ( __stdcall *GetDevice )( 
           IDXGISwapChain * This,
           
             REFIID riid,
            
             void **ppDevice);
       
       HRESULT ( __stdcall *Present )( 
           IDXGISwapChain * This,
            UINT SyncInterval,
            UINT Flags);
       
       HRESULT ( __stdcall *GetBuffer )( 
           IDXGISwapChain * This,
            UINT Buffer,
           
             REFIID riid,
            
             void **ppSurface);
       
       HRESULT ( __stdcall *SetFullscreenState )( 
           IDXGISwapChain * This,
            BOOL Fullscreen,
           
             IDXGIOutput *pTarget);
       
       HRESULT ( __stdcall *GetFullscreenState )( 
           IDXGISwapChain * This,
            
           _Out_opt_  BOOL *pFullscreen,
            
           _COM_Outptr_opt_result_maybenull_  IDXGIOutput **ppTarget);
       
       HRESULT ( __stdcall *GetDesc )( 
           IDXGISwapChain * This,
            
             DXGI_SWAP_CHAIN_DESC *pDesc);
       
       HRESULT ( __stdcall *ResizeBuffers )( 
           IDXGISwapChain * This,
            UINT BufferCount,
            UINT Width,
            UINT Height,
            DXGI_FORMAT NewFormat,
            UINT SwapChainFlags);
       
       HRESULT ( __stdcall *ResizeTarget )( 
           IDXGISwapChain * This,
           
             const DXGI_MODE_DESC *pNewTargetParameters);
       
       HRESULT ( __stdcall *GetContainingOutput )( 
           IDXGISwapChain * This,
            
             IDXGIOutput **ppOutput);
       
       HRESULT ( __stdcall *GetFrameStatistics )( 
           IDXGISwapChain * This,
            
             DXGI_FRAME_STATISTICS *pStats);
       
       HRESULT ( __stdcall *GetLastPresentCount )( 
           IDXGISwapChain * This,
            
             UINT *pLastPresentCount);
       
       
   } IDXGISwapChainVtbl;

   typedef struct IDXGISwapChain
   {
       const struct IDXGISwapChainVtbl *lpVtbl;
   };
]]
   






ffi.cdef[[
static const int DXGI_MWA_NO_WINDOW_CHANGES     = 1 << 0;
static const int DXGI_MWA_NO_ALT_ENTER          = 1 << 1;
static const int DXGI_MWA_NO_PRINT_SCREEN       = 1 << 2;
static const int DXGI_MWA_VALID                 = 0x7;
]]



ffi.cdef[[
   typedef struct IDXGIFactoryVtbl
   {
       
       
       HRESULT ( __stdcall *QueryInterface )( 
           IDXGIFactory * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IDXGIFactory * This);
       
       ULONG ( __stdcall *Release )( 
           IDXGIFactory * This);
       
       HRESULT ( __stdcall *SetPrivateData )( 
           IDXGIFactory * This,
           
             REFGUID Name,
            UINT DataSize,
           
             const void *pData);
       
       HRESULT ( __stdcall *SetPrivateDataInterface )( 
           IDXGIFactory * This,
           
             REFGUID Name,
           
             const IUnknown *pUnknown);
       
       HRESULT ( __stdcall *GetPrivateData )( 
           IDXGIFactory * This,
           
             REFGUID Name,
            
             UINT *pDataSize,
            
             void *pData);
       
       HRESULT ( __stdcall *GetParent )( 
           IDXGIFactory * This,
           
             REFIID riid,
            
             void **ppParent);
       
       HRESULT ( __stdcall *EnumAdapters )( 
           IDXGIFactory * This,
            UINT Adapter,
            
             IDXGIAdapter **ppAdapter);
       
       HRESULT ( __stdcall *MakeWindowAssociation )( 
           IDXGIFactory * This,
           HWND WindowHandle,
           UINT Flags);
       
       HRESULT ( __stdcall *GetWindowAssociation )( 
           IDXGIFactory * This,
            
             HWND *pWindowHandle);
       
       HRESULT ( __stdcall *CreateSwapChain )( 
           IDXGIFactory * This,
           
             IUnknown *pDevice,
           
             DXGI_SWAP_CHAIN_DESC *pDesc,
            
             IDXGISwapChain **ppSwapChain);
       
       HRESULT ( __stdcall *CreateSoftwareAdapter )( 
           IDXGIFactory * This,
            HMODULE Module,
            
             IDXGIAdapter **ppAdapter);
       
       
   } IDXGIFactoryVtbl;

   typedef struct IDXGIFactory
   {
       const struct IDXGIFactoryVtbl *lpVtbl;
   };
]]
   







if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then
ffi.cdef[[
HRESULT __stdcall CreateDXGIFactory(REFIID riid,  void **ppFactory);
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */

ffi.cdef[[
HRESULT WINAPI CreateDXGIFactory1(REFIID riid,  void **ppFactory);
]]


ffi.cdef[[
   typedef struct IDXGIDeviceVtbl
   {
       
       
       HRESULT ( __stdcall *QueryInterface )( 
           IDXGIDevice * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IDXGIDevice * This);
       
       ULONG ( __stdcall *Release )( 
           IDXGIDevice * This);
       
       HRESULT ( __stdcall *SetPrivateData )( 
           IDXGIDevice * This,
           
             REFGUID Name,
            UINT DataSize,
           
             const void *pData);
       
       HRESULT ( __stdcall *SetPrivateDataInterface )( 
           IDXGIDevice * This,
           
             REFGUID Name,
           
             const IUnknown *pUnknown);
       
       HRESULT ( __stdcall *GetPrivateData )( 
           IDXGIDevice * This,
           
             REFGUID Name,
            
             UINT *pDataSize,
            
             void *pData);
       
       HRESULT ( __stdcall *GetParent )( 
           IDXGIDevice * This,
           
             REFIID riid,
            
             void **ppParent);
       
       HRESULT ( __stdcall *GetAdapter )( 
           IDXGIDevice * This,
            
             IDXGIAdapter **pAdapter);
       
       HRESULT ( __stdcall *CreateSurface )( 
           IDXGIDevice * This,
           
             const DXGI_SURFACE_DESC *pDesc,
            UINT NumSurfaces,
            DXGI_USAGE Usage,
           
             const DXGI_SHARED_RESOURCE *pSharedResource,
            
             IDXGISurface **ppSurface);
       
       HRESULT ( __stdcall *QueryResourceResidency )( 
           IDXGIDevice * This,
           /* [annotation][size_is][in] */ 
           _In_reads_(NumResources)  IUnknown *const *ppResources,
           /* [annotation][size_is][out] */ 
           _Out_writes_(NumResources)  DXGI_RESIDENCY *pResidencyStatus,
            UINT NumResources);
       
       HRESULT ( __stdcall *SetGPUThreadPriority )( 
           IDXGIDevice * This,
            INT Priority);
       
       HRESULT ( __stdcall *GetGPUThreadPriority )( 
           IDXGIDevice * This,
            
             INT *pPriority);
       
       
   } IDXGIDeviceVtbl;

   typedef struct IDXGIDevice
   {
       const struct IDXGIDeviceVtbl *lpVtbl;
   };
]]
   






ffi.cdef[[
typedef 
enum DXGI_ADAPTER_FLAG
   {
       DXGI_ADAPTER_FLAG_NONE	= 0,
       DXGI_ADAPTER_FLAG_REMOTE	= 1,
       DXGI_ADAPTER_FLAG_SOFTWARE	= 2,
       DXGI_ADAPTER_FLAG_FORCE_DWORD	= 0xffffffff
   } 	DXGI_ADAPTER_FLAG;

typedef struct DXGI_ADAPTER_DESC1
   {
   WCHAR Description[ 128 ];
   UINT VendorId;
   UINT DeviceId;
   UINT SubSysId;
   UINT Revision;
   SIZE_T DedicatedVideoMemory;
   SIZE_T DedicatedSystemMemory;
   SIZE_T SharedSystemMemory;
   LUID AdapterLuid;
   UINT Flags;
   } 	DXGI_ADAPTER_DESC1;

typedef struct DXGI_DISPLAY_COLOR_SPACE
   {
   FLOAT PrimaryCoordinates[ 8 ][ 2 ];
   FLOAT WhitePoints[ 16 ][ 2 ];
   } 	DXGI_DISPLAY_COLOR_SPACE;
]]



ffi.cdef[[
   typedef struct IDXGIFactory1Vtbl
   {
       
       
       HRESULT ( __stdcall *QueryInterface )( 
           IDXGIFactory1 * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IDXGIFactory1 * This);
       
       ULONG ( __stdcall *Release )( 
           IDXGIFactory1 * This);
       
       HRESULT ( __stdcall *SetPrivateData )( 
           IDXGIFactory1 * This,
           
             REFGUID Name,
            UINT DataSize,
           
             const void *pData);
       
       HRESULT ( __stdcall *SetPrivateDataInterface )( 
           IDXGIFactory1 * This,
           
             REFGUID Name,
           
             const IUnknown *pUnknown);
       
       HRESULT ( __stdcall *GetPrivateData )( 
           IDXGIFactory1 * This,
           
             REFGUID Name,
            
             UINT *pDataSize,
            
             void *pData);
       
       HRESULT ( __stdcall *GetParent )( 
           IDXGIFactory1 * This,
           
             REFIID riid,
            
             void **ppParent);
       
       HRESULT ( __stdcall *EnumAdapters )( 
           IDXGIFactory1 * This,
            UINT Adapter,
            
             IDXGIAdapter **ppAdapter);
       
       HRESULT ( __stdcall *MakeWindowAssociation )( 
           IDXGIFactory1 * This,
           HWND WindowHandle,
           UINT Flags);
       
       HRESULT ( __stdcall *GetWindowAssociation )( 
           IDXGIFactory1 * This,
            
             HWND *pWindowHandle);
       
       HRESULT ( __stdcall *CreateSwapChain )( 
           IDXGIFactory1 * This,
           
             IUnknown *pDevice,
           
             DXGI_SWAP_CHAIN_DESC *pDesc,
            
             IDXGISwapChain **ppSwapChain);
       
       HRESULT ( __stdcall *CreateSoftwareAdapter )( 
           IDXGIFactory1 * This,
            HMODULE Module,
            
             IDXGIAdapter **ppAdapter);
       
       HRESULT ( __stdcall *EnumAdapters1 )( 
           IDXGIFactory1 * This,
            UINT Adapter,
            
             IDXGIAdapter1 **ppAdapter);
       
       BOOL ( __stdcall *IsCurrent )( 
           IDXGIFactory1 * This);
       
       
   } IDXGIFactory1Vtbl;

   typedef struct IDXGIFactory1
   {
       const struct IDXGIFactory1Vtbl *lpVtbl;
   };
]]
   


 

ffi.cdef[[
   typedef struct IDXGIAdapter1Vtbl
   {

       HRESULT ( __stdcall *QueryInterface )( 
           IDXGIAdapter1 * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IDXGIAdapter1 * This);
       
       ULONG ( __stdcall *Release )( 
           IDXGIAdapter1 * This);
       
       HRESULT ( __stdcall *SetPrivateData )( 
           IDXGIAdapter1 * This,
           
             REFGUID Name,
            UINT DataSize,
           
             const void *pData);
       
       HRESULT ( __stdcall *SetPrivateDataInterface )( 
           IDXGIAdapter1 * This,
           
             REFGUID Name,
           
             const IUnknown *pUnknown);
       
       HRESULT ( __stdcall *GetPrivateData )( 
           IDXGIAdapter1 * This,
           
             REFGUID Name,
            
             UINT *pDataSize,
            
             void *pData);
       
       HRESULT ( __stdcall *GetParent )( 
           IDXGIAdapter1 * This,
           
             REFIID riid,
            
             void **ppParent);
       
       HRESULT ( __stdcall *EnumOutputs )( 
           IDXGIAdapter1 * This,
            UINT Output,
            
             IDXGIOutput **ppOutput);
       
       HRESULT ( __stdcall *GetDesc )( 
           IDXGIAdapter1 * This,
            
             DXGI_ADAPTER_DESC *pDesc);
       
       HRESULT ( __stdcall *CheckInterfaceSupport )( 
           IDXGIAdapter1 * This,
           
             REFGUID InterfaceName,
            
             LARGE_INTEGER *pUMDVersion);
       
       HRESULT ( __stdcall *GetDesc1 )( 
           IDXGIAdapter1 * This,
            
             DXGI_ADAPTER_DESC1 *pDesc);
       
       
   } IDXGIAdapter1Vtbl;

   typedef struct IDXGIAdapter1
   {
       const struct IDXGIAdapter1Vtbl *lpVtbl;
   };
]]
   






ffi.cdef[[
   typedef struct IDXGIDevice1Vtbl
   {
       
       
       HRESULT ( __stdcall *QueryInterface )( 
           IDXGIDevice1 * This,
            REFIID riid,
            
             void **ppvObject);
       
       ULONG ( __stdcall *AddRef )( 
           IDXGIDevice1 * This);
       
       ULONG ( __stdcall *Release )( 
           IDXGIDevice1 * This);
       
       HRESULT ( __stdcall *SetPrivateData )( 
           IDXGIDevice1 * This,
           
             REFGUID Name,
            UINT DataSize,
           
             const void *pData);
       
       HRESULT ( __stdcall *SetPrivateDataInterface )( 
           IDXGIDevice1 * This,
           
             REFGUID Name,
           
             const IUnknown *pUnknown);
       
       HRESULT ( __stdcall *GetPrivateData )( 
           IDXGIDevice1 * This,
           
             REFGUID Name,
            
             UINT *pDataSize,
            
             void *pData);
       
       HRESULT ( __stdcall *GetParent )( 
           IDXGIDevice1 * This,
           
             REFIID riid,
            
             void **ppParent);
       
       HRESULT ( __stdcall *GetAdapter )( 
           IDXGIDevice1 * This,
            
             IDXGIAdapter **pAdapter);
       
       HRESULT ( __stdcall *CreateSurface )( 
           IDXGIDevice1 * This,
           
             const DXGI_SURFACE_DESC *pDesc,
            UINT NumSurfaces,
            DXGI_USAGE Usage,
           
             const DXGI_SHARED_RESOURCE *pSharedResource,
            
             IDXGISurface **ppSurface);
       
       HRESULT ( __stdcall *QueryResourceResidency )( 
           IDXGIDevice1 * This,
           /* [annotation][size_is][in] */ 
           _In_reads_(NumResources)  IUnknown *const *ppResources,
           /* [annotation][size_is][out] */ 
           _Out_writes_(NumResources)  DXGI_RESIDENCY *pResidencyStatus,
            UINT NumResources);
       
       HRESULT ( __stdcall *SetGPUThreadPriority )( 
           IDXGIDevice1 * This,
            INT Priority);
       
       HRESULT ( __stdcall *GetGPUThreadPriority )( 
           IDXGIDevice1 * This,
            
             INT *pPriority);
       
       HRESULT ( __stdcall *SetMaximumFrameLatency )( 
           IDXGIDevice1 * This,
            UINT MaxLatency);
       
       HRESULT ( __stdcall *GetMaximumFrameLatency )( 
           IDXGIDevice1 * This,
            
             UINT *pMaxLatency);
       
       
   } IDXGIDevice1Vtbl;

   typedef struct IDXGIDevice1
   {
       const struct IDXGIDevice1Vtbl *lpVtbl;
   };
]]
   



DEFINE_GUID("IID_IDXGIObject",0xaec22fb8,0x76f3,0x4639,0x9b,0xe0,0x28,0xeb,0x43,0xa6,0x7a,0x2e);
DEFINE_GUID("IID_IDXGIDeviceSubObject",0x3d3e0379,0xf9de,0x4d58,0xbb,0x6c,0x18,0xd6,0x29,0x92,0xf1,0xa6);
DEFINE_GUID("IID_IDXGIResource",0x035f3ab4,0x482e,0x4e50,0xb4,0x1f,0x8a,0x7f,0x8b,0xd8,0x96,0x0b);
DEFINE_GUID("IID_IDXGIKeyedMutex",0x9d8e1289,0xd7b3,0x465f,0x81,0x26,0x25,0x0e,0x34,0x9a,0xf8,0x5d);
DEFINE_GUID("IID_IDXGISurface",0xcafcb56c,0x6ac3,0x4889,0xbf,0x47,0x9e,0x23,0xbb,0xd2,0x60,0xec);
DEFINE_GUID("IID_IDXGISurface1",0x4AE63092,0x6327,0x4c1b,0x80,0xAE,0xBF,0xE1,0x2E,0xA3,0x2B,0x86);
DEFINE_GUID("IID_IDXGIAdapter",0x2411e7e1,0x12ac,0x4ccf,0xbd,0x14,0x97,0x98,0xe8,0x53,0x4d,0xc0);
DEFINE_GUID("IID_IDXGIOutput",0xae02eedb,0xc735,0x4690,0x8d,0x52,0x5a,0x8d,0xc2,0x02,0x13,0xaa);
DEFINE_GUID("IID_IDXGISwapChain",0x310d36a0,0xd2e7,0x4c0a,0xaa,0x04,0x6a,0x9d,0x23,0xb8,0x88,0x6a);
DEFINE_GUID("IID_IDXGIFactory",0x7b7166ec,0x21c7,0x44ae,0xb2,0x1a,0xc9,0xae,0x32,0x1a,0xe3,0x69);
DEFINE_GUID("IID_IDXGIDevice",0x54ec77fa,0x1377,0x44e6,0x8c,0x32,0x88,0xfd,0x5f,0x44,0xc8,0x4c);
DEFINE_GUID("IID_IDXGIFactory1",0x770aae78,0xf26f,0x4dba,0xa8,0x29,0x25,0x3c,0x83,0xd1,0xb3,0x87);
DEFINE_GUID("IID_IDXGIAdapter1",0x29038f61,0x3839,0x4626,0x91,0xfd,0x08,0x68,0x79,0x01,0x1a,0x05);
DEFINE_GUID("IID_IDXGIDevice1",0x77db970f,0x6276,0x48ba,0xba,0x28,0x07,0x01,0x43,0xb4,0x39,0x2c);




end


