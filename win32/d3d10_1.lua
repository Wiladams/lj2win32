local ffi = require("ffi")



/* verify that the <rpcndr.h> version is high enough to compile this file*/
if not __REQUIRED_RPCNDR_H_VERSION__ then
__REQUIRED_RPCNDR_H_VERSION__ = 500
end

/* verify that the <rpcsal.h> version is high enough to compile this file*/
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

if not __d3d10_1_h__ then
__d3d10_1_h__ = true



-- Forward Declarations 
if not __ID3D10BlendState1_FWD_DEFINED__ then
__ID3D10BlendState1_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct ID3D10BlendState1 ID3D10BlendState1;
]]
end 	--/* __ID3D10BlendState1_FWD_DEFINED__ */


if not __ID3D10ShaderResourceView1_FWD_DEFINED__ then
__ID3D10ShaderResourceView1_FWD_DEFINED__  = true
ffi.cdef[[
typedef struct ID3D10ShaderResourceView1 ID3D10ShaderResourceView1;
]]
end 	--/* __ID3D10ShaderResourceView1_FWD_DEFINED__ */


if not __ID3D10Device1_FWD_DEFINED__ then
__ID3D10Device1_FWD_DEFINED__ = true
ffi.cdef[[
typedef struct ID3D10Device1 ID3D10Device1;
]]
end 	--/* __ID3D10Device1_FWD_DEFINED__ */


--/* header files for imported files */
require("win32.oaidl")
require("win32.ocidl")



if __d3d10_h__ and not D3D10_ARBITRARY_HEADER_ORDERING then
error([[d3d10.h is included before d3d10_1.h, and it will confuse tools that honor SAL annotations.
If possibly targeting d3d10.1, include d3d10_1.h instead of d3d10.h, or ensure d3d10_1.h is included before d3d10.h]])
end

if not _D3D10_1_CONSTANTS then
_D3D10_1_CONSTANTS = true

D3D10_1_FLOAT16_FUSED_TOLERANCE_IN_ULP	0.6;
D3D10_1_FLOAT32_TO_INTEGER_TOLERANCE_IN_ULP	= 0.6f;

ffi.cdef[[
static const int 	D3D10_1_DEFAULT_SAMPLE_MASK	== 0xffffffff;

static const int 	D3D10_1_GS_INPUT_REGISTER_COUNT	= 32;

static const int 	D3D10_1_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT	= 32;

static const int 	D3D10_1_IA_VERTEX_INPUT_STRUCTURE_ELEMENTS_COMPONENTS	= 128;

static const int 	D3D10_1_IA_VERTEX_INPUT_STRUCTURE_ELEMENT_COUNT	= 32;

static const int 	D3D10_1_PS_OUTPUT_MASK_REGISTER_COMPONENTS	= 1;

static const int 	D3D10_1_PS_OUTPUT_MASK_REGISTER_COMPONENT_BIT_COUNT	= 32;

static const int 	D3D10_1_PS_OUTPUT_MASK_REGISTER_COUNT	= 1;

static const int 	D3D10_1_SHADER_MAJOR_VERSION	= 4;

static const int 	D3D10_1_SHADER_MINOR_VERSION	= 1;

static const int 	D3D10_1_SO_BUFFER_MAX_STRIDE_IN_BYTES	= 2048;

static const int 	D3D10_1_SO_BUFFER_MAX_WRITE_WINDOW_IN_BYTES	= 256;

static const int 	D3D10_1_SO_BUFFER_SLOT_COUNT	= 4;

static const int 	D3D10_1_SO_MULTIPLE_BUFFER_ELEMENTS_PER_BUFFER	= 1;

static const int 	D3D10_1_SO_SINGLE_BUFFER_COMPONENT_LIMIT	= 64;

static const int 	D3D10_1_STANDARD_VERTEX_ELEMENT_COUNT	= 32;

static const int 	D3D10_1_SUBPIXEL_FRACTIONAL_BIT_COUNT	= 8;

static const int 	D3D10_1_VS_INPUT_REGISTER_COUNT	= 32;

static const int 	D3D10_1_VS_OUTPUT_REGISTER_COUNT	= 32;
]]
end

require("win32.winapifamily")
require("win32.d3d10") 


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then
ffi.cdef[[
typedef 
enum D3D10_FEATURE_LEVEL1
    {
        D3D10_FEATURE_LEVEL_10_0	= 0xa000,
        D3D10_FEATURE_LEVEL_10_1	= 0xa100,
        D3D10_FEATURE_LEVEL_9_1	= 0x9100,
        D3D10_FEATURE_LEVEL_9_2	= 0x9200,
        D3D10_FEATURE_LEVEL_9_3	= 0x9300
    } 	D3D10_FEATURE_LEVEL1;

typedef struct D3D10_RENDER_TARGET_BLEND_DESC1
    {
    BOOL BlendEnable;
    D3D10_BLEND SrcBlend;
    D3D10_BLEND DestBlend;
    D3D10_BLEND_OP BlendOp;
    D3D10_BLEND SrcBlendAlpha;
    D3D10_BLEND DestBlendAlpha;
    D3D10_BLEND_OP BlendOpAlpha;
    UINT8 RenderTargetWriteMask;
    } 	D3D10_RENDER_TARGET_BLEND_DESC1;

typedef struct D3D10_BLEND_DESC1
    {
    BOOL AlphaToCoverageEnable;
    BOOL IndependentBlendEnable;
    D3D10_RENDER_TARGET_BLEND_DESC1 RenderTarget[ 8 ];
    } 	D3D10_BLEND_DESC1;
]]


--extern RPC_IF_HANDLE __MIDL_itf_d3d10_1_0000_0000_v0_0_c_ifspec;
--extern RPC_IF_HANDLE __MIDL_itf_d3d10_1_0000_0000_v0_0_s_ifspec;

if not __ID3D10BlendState1_INTERFACE_DEFINED__ then
__ID3D10BlendState1_INTERFACE_DEFINED__ = true

--EXTERN_C const IID IID_ID3D10BlendState1;
--MIDL_INTERFACE("EDAD8D99-8A35-4d6d-8566-2EA276CDE161")

ffi.cdef[[
    typedef struct ID3D10BlendState1Vtbl
    {
        
        
        HRESULT ( __stdcall *QueryInterface )( 
            ID3D10BlendState1 * This,
             REFIID riid,
             
              void **ppvObject);
        
        ULONG ( __stdcall *AddRef )( 
            ID3D10BlendState1 * This);
        
        ULONG ( __stdcall *Release )( 
            ID3D10BlendState1 * This);
        
        void ( __stdcall *GetDevice )( 
            ID3D10BlendState1 * This,
             
              ID3D10Device **ppDevice);
        
        HRESULT ( __stdcall *GetPrivateData )( 
            ID3D10BlendState1 * This,
             
              REFGUID guid,
             
              UINT *pDataSize,
             
              void *pData);
        
        HRESULT ( __stdcall *SetPrivateData )( 
            ID3D10BlendState1 * This,
             
              REFGUID guid,
             
              UINT DataSize,
             
              const void *pData);
        
        HRESULT ( __stdcall *SetPrivateDataInterface )( 
            ID3D10BlendState1 * This,
             
              REFGUID guid,
             
              const IUnknown *pData);
        
        void ( __stdcall *GetDesc )( 
            ID3D10BlendState1 * This,
             
              D3D10_BLEND_DESC *pDesc);
        
        void ( __stdcall *GetDesc1 )( 
            ID3D10BlendState1 * This,
             
              D3D10_BLEND_DESC1 *pDesc);
        
        
    } ID3D10BlendState1Vtbl;

    struct ID3D10BlendState1
    {
        const struct ID3D10BlendState1Vtbl *lpVtbl;
    };
]]
    

if COBJMACROS then


#define ID3D10BlendState1_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define ID3D10BlendState1_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define ID3D10BlendState1_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define ID3D10BlendState1_GetDevice(This,ppDevice)	\
    ( (This)->lpVtbl -> GetDevice(This,ppDevice) ) 

#define ID3D10BlendState1_GetPrivateData(This,guid,pDataSize,pData)	\
    ( (This)->lpVtbl -> GetPrivateData(This,guid,pDataSize,pData) ) 

#define ID3D10BlendState1_SetPrivateData(This,guid,DataSize,pData)	\
    ( (This)->lpVtbl -> SetPrivateData(This,guid,DataSize,pData) ) 

#define ID3D10BlendState1_SetPrivateDataInterface(This,guid,pData)	\
    ( (This)->lpVtbl -> SetPrivateDataInterface(This,guid,pData) ) 


#define ID3D10BlendState1_GetDesc(This,pDesc)	\
    ( (This)->lpVtbl -> GetDesc(This,pDesc) ) 


#define ID3D10BlendState1_GetDesc1(This,pDesc)	\
    ( (This)->lpVtbl -> GetDesc1(This,pDesc) ) 

end --/* COBJMACROS */



end 	--/* __ID3D10BlendState1_INTERFACE_DEFINED__ */

ffi.cdef[[
typedef struct D3D10_TEXCUBE_ARRAY_SRV1
    {
    UINT MostDetailedMip;
    UINT MipLevels;
    UINT First2DArrayFace;
    UINT NumCubes;
    } 	D3D10_TEXCUBE_ARRAY_SRV1;

typedef D3D_SRV_DIMENSION D3D10_SRV_DIMENSION1;

typedef struct D3D10_SHADER_RESOURCE_VIEW_DESC1
    {
    DXGI_FORMAT Format;
    D3D10_SRV_DIMENSION1 ViewDimension;
    union 
        {
        D3D10_BUFFER_SRV Buffer;
        D3D10_TEX1D_SRV Texture1D;
        D3D10_TEX1D_ARRAY_SRV Texture1DArray;
        D3D10_TEX2D_SRV Texture2D;
        D3D10_TEX2D_ARRAY_SRV Texture2DArray;
        D3D10_TEX2DMS_SRV Texture2DMS;
        D3D10_TEX2DMS_ARRAY_SRV Texture2DMSArray;
        D3D10_TEX3D_SRV Texture3D;
        D3D10_TEXCUBE_SRV TextureCube;
        D3D10_TEXCUBE_ARRAY_SRV1 TextureCubeArray;
        } 	;
    } 	D3D10_SHADER_RESOURCE_VIEW_DESC1;
]]


--extern RPC_IF_HANDLE __MIDL_itf_d3d10_1_0000_0001_v0_0_c_ifspec;
--extern RPC_IF_HANDLE __MIDL_itf_d3d10_1_0000_0001_v0_0_s_ifspec;

if not __ID3D10ShaderResourceView1_INTERFACE_DEFINED__ then
__ID3D10ShaderResourceView1_INTERFACE_DEFINED__ = true



--EXTERN_C const IID IID_ID3D10ShaderResourceView1;
--MIDL_INTERFACE("9B7E4C87-342C-4106-A19F-4F2704F689F0")


ffi.cdef[[
    typedef struct ID3D10ShaderResourceView1Vtbl
    {
        
        
        HRESULT ( __stdcall *QueryInterface )( 
            ID3D10ShaderResourceView1 * This,
             REFIID riid,
             
              void **ppvObject);
        
        ULONG ( __stdcall *AddRef )( 
            ID3D10ShaderResourceView1 * This);
        
        ULONG ( __stdcall *Release )( 
            ID3D10ShaderResourceView1 * This);
        
        void ( __stdcall *GetDevice )( 
            ID3D10ShaderResourceView1 * This,
             
              ID3D10Device **ppDevice);
        
        HRESULT ( __stdcall *GetPrivateData )( 
            ID3D10ShaderResourceView1 * This,
             
              REFGUID guid,
             
              UINT *pDataSize,
             
              void *pData);
        
        HRESULT ( __stdcall *SetPrivateData )( 
            ID3D10ShaderResourceView1 * This,
             
              REFGUID guid,
             
              UINT DataSize,
             
              const void *pData);
        
        HRESULT ( __stdcall *SetPrivateDataInterface )( 
            ID3D10ShaderResourceView1 * This,
             
              REFGUID guid,
             
              const IUnknown *pData);
        
        void ( __stdcall *GetResource )( 
            ID3D10ShaderResourceView1 * This,
             
              ID3D10Resource **ppResource);
        
        void ( __stdcall *GetDesc )( 
            ID3D10ShaderResourceView1 * This,
             
              D3D10_SHADER_RESOURCE_VIEW_DESC *pDesc);
        
        void ( __stdcall *GetDesc1 )( 
            ID3D10ShaderResourceView1 * This,
             
              D3D10_SHADER_RESOURCE_VIEW_DESC1 *pDesc);
        
        
    } ID3D10ShaderResourceView1Vtbl;

    struct ID3D10ShaderResourceView1
    {
        const struct ID3D10ShaderResourceView1Vtbl *lpVtbl;
    };
]]
    

if COBJMACROS then


#define ID3D10ShaderResourceView1_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define ID3D10ShaderResourceView1_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define ID3D10ShaderResourceView1_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define ID3D10ShaderResourceView1_GetDevice(This,ppDevice)	\
    ( (This)->lpVtbl -> GetDevice(This,ppDevice) ) 

#define ID3D10ShaderResourceView1_GetPrivateData(This,guid,pDataSize,pData)	\
    ( (This)->lpVtbl -> GetPrivateData(This,guid,pDataSize,pData) ) 

#define ID3D10ShaderResourceView1_SetPrivateData(This,guid,DataSize,pData)	\
    ( (This)->lpVtbl -> SetPrivateData(This,guid,DataSize,pData) ) 

#define ID3D10ShaderResourceView1_SetPrivateDataInterface(This,guid,pData)	\
    ( (This)->lpVtbl -> SetPrivateDataInterface(This,guid,pData) ) 


#define ID3D10ShaderResourceView1_GetResource(This,ppResource)	\
    ( (This)->lpVtbl -> GetResource(This,ppResource) ) 


#define ID3D10ShaderResourceView1_GetDesc(This,pDesc)	\
    ( (This)->lpVtbl -> GetDesc(This,pDesc) ) 


#define ID3D10ShaderResourceView1_GetDesc1(This,pDesc)	\
    ( (This)->lpVtbl -> GetDesc1(This,pDesc) ) 

end --/* COBJMACROS */




end 	--/* __ID3D10ShaderResourceView1_INTERFACE_DEFINED__ */



ffi.cdef[[
typedef 
enum D3D10_STANDARD_MULTISAMPLE_QUALITY_LEVELS
    {
        D3D10_STANDARD_MULTISAMPLE_PATTERN	= 0xffffffff,
        D3D10_CENTER_MULTISAMPLE_PATTERN	= 0xfffffffe
    } 	D3D10_STANDARD_MULTISAMPLE_QUALITY_LEVELS;
]]


--extern RPC_IF_HANDLE __MIDL_itf_d3d10_1_0000_0002_v0_0_c_ifspec;
--extern RPC_IF_HANDLE __MIDL_itf_d3d10_1_0000_0002_v0_0_s_ifspec;

if not __ID3D10Device1_INTERFACE_DEFINED__ then
__ID3D10Device1_INTERFACE_DEFINED__ = true


--EXTERN_C const IID IID_ID3D10Device1;
--MIDL_INTERFACE("9B7E4C8F-342C-4106-A19F-4F2704F689F0")
    
ffi.cdef[[
    typedef struct ID3D10Device1Vtbl
    {
        
        
        HRESULT ( __stdcall *QueryInterface )( 
            ID3D10Device1 * This,
             REFIID riid,
             
              void **ppvObject);
        
        ULONG ( __stdcall *AddRef )( 
            ID3D10Device1 * This);
        
        ULONG ( __stdcall *Release )( 
            ID3D10Device1 * This);
        
        void ( __stdcall *VSSetConstantBuffers )( 
            ID3D10Device1 * This,
             
              UINT StartSlot,
             
              UINT NumBuffers,
             
              ID3D10Buffer *const *ppConstantBuffers);
        
        void ( __stdcall *PSSetShaderResources )( 
            ID3D10Device1 * This,
             
              UINT StartSlot,
             
              UINT NumViews,
             
              ID3D10ShaderResourceView *const *ppShaderResourceViews);
        
        void ( __stdcall *PSSetShader )( 
            ID3D10Device1 * This,
             
              ID3D10PixelShader *pPixelShader);
        
        void ( __stdcall *PSSetSamplers )( 
            ID3D10Device1 * This,
             
              UINT StartSlot,
             
              UINT NumSamplers,
             
             ID3D10SamplerState *const *ppSamplers);
        
        void ( __stdcall *VSSetShader )( 
            ID3D10Device1 * This,
             
              ID3D10VertexShader *pVertexShader);
        
        void ( __stdcall *DrawIndexed )( 
            ID3D10Device1 * This,
             
              UINT IndexCount,
             
              UINT StartIndexLocation,
             
              INT BaseVertexLocation);
        
        void ( __stdcall *Draw )( 
            ID3D10Device1 * This,
             
              UINT VertexCount,
             
              UINT StartVertexLocation);
        
        void ( __stdcall *PSSetConstantBuffers )( 
            ID3D10Device1 * This,
             
              UINT StartSlot,
             
              UINT NumBuffers,
             
              ID3D10Buffer *const *ppConstantBuffers);
        
        void ( __stdcall *IASetInputLayout )( 
            ID3D10Device1 * This,
             
              ID3D10InputLayout *pInputLayout);
        
        void ( __stdcall *IASetVertexBuffers )( 
            ID3D10Device1 * This,
             
              UINT StartSlot,
             
              UINT NumBuffers,
             
              ID3D10Buffer *const *ppVertexBuffers,
             
              const UINT *pStrides,
             
              const UINT *pOffsets);
        
        void ( __stdcall *IASetIndexBuffer )( 
            ID3D10Device1 * This,
             
              ID3D10Buffer *pIndexBuffer,
             
              DXGI_FORMAT Format,
             
              UINT Offset);
        
        void ( __stdcall *DrawIndexedInstanced )( 
            ID3D10Device1 * This,
             
              UINT IndexCountPerInstance,
             
              UINT InstanceCount,
             
              UINT StartIndexLocation,
             
              INT BaseVertexLocation,
             
              UINT StartInstanceLocation);
        
        void ( __stdcall *DrawInstanced )( 
            ID3D10Device1 * This,
             
              UINT VertexCountPerInstance,
             
              UINT InstanceCount,
             
              UINT StartVertexLocation,
             
              UINT StartInstanceLocation);
        
        void ( __stdcall *GSSetConstantBuffers )( 
            ID3D10Device1 * This,
             
              UINT StartSlot,
             
              UINT NumBuffers,
             
              ID3D10Buffer *const *ppConstantBuffers);
        
        void ( __stdcall *GSSetShader )( 
            ID3D10Device1 * This,
             
              ID3D10GeometryShader *pShader);
        
        void ( __stdcall *IASetPrimitiveTopology )( 
            ID3D10Device1 * This,
             
              D3D10_PRIMITIVE_TOPOLOGY Topology);
        
        void ( __stdcall *VSSetShaderResources )( 
            ID3D10Device1 * This,
             
              UINT StartSlot,
             
              UINT NumViews,
             
              ID3D10ShaderResourceView *const *ppShaderResourceViews);
        
        void ( __stdcall *VSSetSamplers )( 
            ID3D10Device1 * This,
             
              UINT StartSlot,
             
              UINT NumSamplers,
             
             ID3D10SamplerState *const *ppSamplers);
        
        void ( __stdcall *SetPredication )( 
            ID3D10Device1 * This,
             
              ID3D10Predicate *pPredicate,
             
              BOOL PredicateValue);
        
        void ( __stdcall *GSSetShaderResources )( 
            ID3D10Device1 * This,
             
              UINT StartSlot,
             
              UINT NumViews,
             
              ID3D10ShaderResourceView *const *ppShaderResourceViews);
        
        void ( __stdcall *GSSetSamplers )( 
            ID3D10Device1 * This,
             
              UINT StartSlot,
             
              UINT NumSamplers,
             
             ID3D10SamplerState *const *ppSamplers);
        
        void ( __stdcall *OMSetRenderTargets )( 
            ID3D10Device1 * This,
             
              UINT NumViews,
             
              ID3D10RenderTargetView *const *ppRenderTargetViews,
             
              ID3D10DepthStencilView *pDepthStencilView);
        
        void ( __stdcall *OMSetBlendState )( 
            ID3D10Device1 * This,
             
              ID3D10BlendState *pBlendState,
             
              const FLOAT BlendFactor[ 4 ],
             
              UINT SampleMask);
        
        void ( __stdcall *OMSetDepthStencilState )( 
            ID3D10Device1 * This,
             
              ID3D10DepthStencilState *pDepthStencilState,
             
              UINT StencilRef);
        
        void ( __stdcall *SOSetTargets )( 
            ID3D10Device1 * This,
             
              UINT NumBuffers,
             
              ID3D10Buffer *const *ppSOTargets,
             
              const UINT *pOffsets);
        
        void ( __stdcall *DrawAuto )( 
            ID3D10Device1 * This);
        
        void ( __stdcall *RSSetState )( 
            ID3D10Device1 * This,
             
              ID3D10RasterizerState *pRasterizerState);
        
        void ( __stdcall *RSSetViewports )( 
            ID3D10Device1 * This,
             
              UINT NumViewports,
             
              const D3D10_VIEWPORT *pViewports);
        
        void ( __stdcall *RSSetScissorRects )( 
            ID3D10Device1 * This,
             
              UINT NumRects,
             
             const D3D10_RECT *pRects);
        
        void ( __stdcall *CopySubresourceRegion )( 
            ID3D10Device1 * This,
             
              ID3D10Resource *pDstResource,
             
              UINT DstSubresource,
             
              UINT DstX,
             
              UINT DstY,
             
              UINT DstZ,
             
              ID3D10Resource *pSrcResource,
             
              UINT SrcSubresource,
             
              const D3D10_BOX *pSrcBox);
        
        void ( __stdcall *CopyResource )( 
            ID3D10Device1 * This,
             
              ID3D10Resource *pDstResource,
             
              ID3D10Resource *pSrcResource);
        
        void ( __stdcall *UpdateSubresource )( 
            ID3D10Device1 * This,
             
              ID3D10Resource *pDstResource,
             
              UINT DstSubresource,
             
              const D3D10_BOX *pDstBox,
             
              const void *pSrcData,
             
              UINT SrcRowPitch,
             
              UINT SrcDepthPitch);
        
        void ( __stdcall *ClearRenderTargetView )( 
            ID3D10Device1 * This,
             
              ID3D10RenderTargetView *pRenderTargetView,
             
              const FLOAT ColorRGBA[ 4 ]);
        
        void ( __stdcall *ClearDepthStencilView )( 
            ID3D10Device1 * This,
             
              ID3D10DepthStencilView *pDepthStencilView,
             
              UINT ClearFlags,
             
              FLOAT Depth,
             
              UINT8 Stencil);
        
        void ( __stdcall *GenerateMips )( 
            ID3D10Device1 * This,
             
              ID3D10ShaderResourceView *pShaderResourceView);
        
        void ( __stdcall *ResolveSubresource )( 
            ID3D10Device1 * This,
             
              ID3D10Resource *pDstResource,
             
              UINT DstSubresource,
             
              ID3D10Resource *pSrcResource,
             
              UINT SrcSubresource,
             
              DXGI_FORMAT Format);
        
        void ( __stdcall *VSGetConstantBuffers )( 
            ID3D10Device1 * This,
             
              UINT StartSlot,
             
              UINT NumBuffers,
             
              ID3D10Buffer **ppConstantBuffers);
        
        void ( __stdcall *PSGetShaderResources )( 
            ID3D10Device1 * This,
             
              UINT StartSlot,
             
              UINT NumViews,
             
             ID3D10ShaderResourceView **ppShaderResourceViews);
        
        void ( __stdcall *PSGetShader )( 
            ID3D10Device1 * This,
             
              ID3D10PixelShader **ppPixelShader);
        
        void ( __stdcall *PSGetSamplers )( 
            ID3D10Device1 * This,
             
              UINT StartSlot,
             
              UINT NumSamplers,
             
              ID3D10SamplerState **ppSamplers);
        
        void ( __stdcall *VSGetShader )( 
            ID3D10Device1 * This,
             
              ID3D10VertexShader **ppVertexShader);
        
        void ( __stdcall *PSGetConstantBuffers )( 
            ID3D10Device1 * This,
             
              UINT StartSlot,
             
              UINT NumBuffers,
             
              ID3D10Buffer **ppConstantBuffers);
        
        void ( __stdcall *IAGetInputLayout )( 
            ID3D10Device1 * This,
             
              ID3D10InputLayout **ppInputLayout);
        
        void ( __stdcall *IAGetVertexBuffers )( 
            ID3D10Device1 * This,
             
              UINT StartSlot,
             
              UINT NumBuffers,
             
              ID3D10Buffer **ppVertexBuffers,
             
              UINT *pStrides,
             
              UINT *pOffsets);
        
        void ( __stdcall *IAGetIndexBuffer )( 
            ID3D10Device1 * This,
             
              ID3D10Buffer **pIndexBuffer,
             
              DXGI_FORMAT *Format,
             
              UINT *Offset);
        
        void ( __stdcall *GSGetConstantBuffers )( 
            ID3D10Device1 * This,
             
              UINT StartSlot,
             
              UINT NumBuffers,
             
              ID3D10Buffer **ppConstantBuffers);
        
        void ( __stdcall *GSGetShader )( 
            ID3D10Device1 * This,
             
              ID3D10GeometryShader **ppGeometryShader);
        
        void ( __stdcall *IAGetPrimitiveTopology )( 
            ID3D10Device1 * This,
             
              D3D10_PRIMITIVE_TOPOLOGY *pTopology);
        
        void ( __stdcall *VSGetShaderResources )( 
            ID3D10Device1 * This,
             
              UINT StartSlot,
             
              UINT NumViews,
             
             ID3D10ShaderResourceView **ppShaderResourceViews);
        
        void ( __stdcall *VSGetSamplers )( 
            ID3D10Device1 * This,
             
              UINT StartSlot,
             
              UINT NumSamplers,
             
              ID3D10SamplerState **ppSamplers);
        
        void ( __stdcall *GetPredication )( 
            ID3D10Device1 * This,
             
              ID3D10Predicate **ppPredicate,
             
              BOOL *pPredicateValue);
        
        void ( __stdcall *GSGetShaderResources )( 
            ID3D10Device1 * This,
             
              UINT StartSlot,
             
              UINT NumViews,
             
             ID3D10ShaderResourceView **ppShaderResourceViews);
        
        void ( __stdcall *GSGetSamplers )( 
            ID3D10Device1 * This,
             
              UINT StartSlot,
             
              UINT NumSamplers,
             
              ID3D10SamplerState **ppSamplers);
        
        void ( __stdcall *OMGetRenderTargets )( 
            ID3D10Device1 * This,
             
              UINT NumViews,
             
             ID3D10RenderTargetView **ppRenderTargetViews,
             
              ID3D10DepthStencilView **ppDepthStencilView);
        
        void ( __stdcall *OMGetBlendState )( 
            ID3D10Device1 * This,
             
              ID3D10BlendState **ppBlendState,
             
              FLOAT BlendFactor[ 4 ],
             
              UINT *pSampleMask);
        
        void ( __stdcall *OMGetDepthStencilState )( 
            ID3D10Device1 * This,
             
              ID3D10DepthStencilState **ppDepthStencilState,
             
              UINT *pStencilRef);
        
        void ( __stdcall *SOGetTargets )( 
            ID3D10Device1 * This,
             
             UINT NumBuffers,
             
              ID3D10Buffer **ppSOTargets,
             
              UINT *pOffsets);
        
        void ( __stdcall *RSGetState )( 
            ID3D10Device1 * This,
             
              ID3D10RasterizerState **ppRasterizerState);
        
        void ( __stdcall *RSGetViewports )( 
            ID3D10Device1 * This,
             
                UINT *NumViewports,
             
             D3D10_VIEWPORT *pViewports);
        
        void ( __stdcall *RSGetScissorRects )( 
            ID3D10Device1 * This,
             
                UINT *NumRects,
             
             D3D10_RECT *pRects);
        
        HRESULT ( __stdcall *GetDeviceRemovedReason )( 
            ID3D10Device1 * This);
        
        HRESULT ( __stdcall *SetExceptionMode )( 
            ID3D10Device1 * This,
            UINT RaiseFlags);
        
        UINT ( __stdcall *GetExceptionMode )( 
            ID3D10Device1 * This);
        
        HRESULT ( __stdcall *GetPrivateData )( 
            ID3D10Device1 * This,
             
              REFGUID guid,
             
              UINT *pDataSize,
             
              void *pData);
        
        HRESULT ( __stdcall *SetPrivateData )( 
            ID3D10Device1 * This,
             
              REFGUID guid,
             
              UINT DataSize,
             
              const void *pData);
        
        HRESULT ( __stdcall *SetPrivateDataInterface )( 
            ID3D10Device1 * This,
             
              REFGUID guid,
             
              const IUnknown *pData);
        
        void ( __stdcall *ClearState )( 
            ID3D10Device1 * This);
        
        void ( __stdcall *Flush )( 
            ID3D10Device1 * This);
        
        HRESULT ( __stdcall *CreateBuffer )( 
            ID3D10Device1 * This,
             
              const D3D10_BUFFER_DESC *pDesc,
             
              const D3D10_SUBRESOURCE_DATA *pInitialData,
             
              ID3D10Buffer **ppBuffer);
        
        HRESULT ( __stdcall *CreateTexture1D )( 
            ID3D10Device1 * This,
             
              const D3D10_TEXTURE1D_DESC *pDesc,
             
             const D3D10_SUBRESOURCE_DATA *pInitialData,
             
              ID3D10Texture1D **ppTexture1D);
        
        HRESULT ( __stdcall *CreateTexture2D )( 
            ID3D10Device1 * This,
             
              const D3D10_TEXTURE2D_DESC *pDesc,
             
             const D3D10_SUBRESOURCE_DATA *pInitialData,
             
              ID3D10Texture2D **ppTexture2D);
        
        HRESULT ( __stdcall *CreateTexture3D )( 
            ID3D10Device1 * This,
             
              const D3D10_TEXTURE3D_DESC *pDesc,
             
             const D3D10_SUBRESOURCE_DATA *pInitialData,
             
              ID3D10Texture3D **ppTexture3D);
        
        HRESULT ( __stdcall *CreateShaderResourceView )( 
            ID3D10Device1 * This,
             
              ID3D10Resource *pResource,
             
              const D3D10_SHADER_RESOURCE_VIEW_DESC *pDesc,
             
              ID3D10ShaderResourceView **ppSRView);
        
        HRESULT ( __stdcall *CreateRenderTargetView )( 
            ID3D10Device1 * This,
             
              ID3D10Resource *pResource,
             
              const D3D10_RENDER_TARGET_VIEW_DESC *pDesc,
             
              ID3D10RenderTargetView **ppRTView);
        
        HRESULT ( __stdcall *CreateDepthStencilView )( 
            ID3D10Device1 * This,
             
              ID3D10Resource *pResource,
             
              const D3D10_DEPTH_STENCIL_VIEW_DESC *pDesc,
             
              ID3D10DepthStencilView **ppDepthStencilView);
        
        HRESULT ( __stdcall *CreateInputLayout )( 
            ID3D10Device1 * This,
             
              const D3D10_INPUT_ELEMENT_DESC *pInputElementDescs,
             
              UINT NumElements,
             
              const void *pShaderBytecodeWithInputSignature,
             
              SIZE_T BytecodeLength,
             
              ID3D10InputLayout **ppInputLayout);
        
        HRESULT ( __stdcall *CreateVertexShader )( 
            ID3D10Device1 * This,
             
              const void *pShaderBytecode,
             
              SIZE_T BytecodeLength,
             
              ID3D10VertexShader **ppVertexShader);
        
        HRESULT ( __stdcall *CreateGeometryShader )( 
            ID3D10Device1 * This,
             
              const void *pShaderBytecode,
             
              SIZE_T BytecodeLength,
             
              ID3D10GeometryShader **ppGeometryShader);
        
        HRESULT ( __stdcall *CreateGeometryShaderWithStreamOutput )( 
            ID3D10Device1 * This,
             
              const void *pShaderBytecode,
             
              SIZE_T BytecodeLength,
             
              const D3D10_SO_DECLARATION_ENTRY *pSODeclaration,
             
              UINT NumEntries,
             
              UINT OutputStreamStride,
             
              ID3D10GeometryShader **ppGeometryShader);
        
        HRESULT ( __stdcall *CreatePixelShader )( 
            ID3D10Device1 * This,
             
              const void *pShaderBytecode,
             
              SIZE_T BytecodeLength,
             
              ID3D10PixelShader **ppPixelShader);
        
        HRESULT ( __stdcall *CreateBlendState )( 
            ID3D10Device1 * This,
             
              const D3D10_BLEND_DESC *pBlendStateDesc,
             
              ID3D10BlendState **ppBlendState);
        
        HRESULT ( __stdcall *CreateDepthStencilState )( 
            ID3D10Device1 * This,
             
              const D3D10_DEPTH_STENCIL_DESC *pDepthStencilDesc,
             
              ID3D10DepthStencilState **ppDepthStencilState);
        
        HRESULT ( __stdcall *CreateRasterizerState )( 
            ID3D10Device1 * This,
             
              const D3D10_RASTERIZER_DESC *pRasterizerDesc,
             
              ID3D10RasterizerState **ppRasterizerState);
        
        HRESULT ( __stdcall *CreateSamplerState )( 
            ID3D10Device1 * This,
             
              const D3D10_SAMPLER_DESC *pSamplerDesc,
             
              ID3D10SamplerState **ppSamplerState);
        
        HRESULT ( __stdcall *CreateQuery )( 
            ID3D10Device1 * This,
             
              const D3D10_QUERY_DESC *pQueryDesc,
             
              ID3D10Query **ppQuery);
        
        HRESULT ( __stdcall *CreatePredicate )( 
            ID3D10Device1 * This,
             
              const D3D10_QUERY_DESC *pPredicateDesc,
             
              ID3D10Predicate **ppPredicate);
        
        HRESULT ( __stdcall *CreateCounter )( 
            ID3D10Device1 * This,
             
              const D3D10_COUNTER_DESC *pCounterDesc,
             
              ID3D10Counter **ppCounter);
        
        HRESULT ( __stdcall *CheckFormatSupport )( 
            ID3D10Device1 * This,
             
              DXGI_FORMAT Format,
             
              UINT *pFormatSupport);
        
        HRESULT ( __stdcall *CheckMultisampleQualityLevels )( 
            ID3D10Device1 * This,
             
              DXGI_FORMAT Format,
             
              UINT SampleCount,
             
              UINT *pNumQualityLevels);
        
        void ( __stdcall *CheckCounterInfo )( 
            ID3D10Device1 * This,
             
              D3D10_COUNTER_INFO *pCounterInfo);
        
        HRESULT ( __stdcall *CheckCounter )( 
            ID3D10Device1 * This,
             
              const D3D10_COUNTER_DESC *pDesc,
             
              D3D10_COUNTER_TYPE *pType,
             
              UINT *pActiveCounters,
             
              LPSTR szName,
             
              UINT *pNameLength,
             
              LPSTR szUnits,
             
              UINT *pUnitsLength,
             
              LPSTR szDescription,
             
              UINT *pDescriptionLength);
        
        UINT ( __stdcall *GetCreationFlags )( 
            ID3D10Device1 * This);
        
        HRESULT ( __stdcall *OpenSharedResource )( 
            ID3D10Device1 * This,
             
              HANDLE hResource,
             
              REFIID ReturnedInterface,
             
              void **ppResource);
        
        void ( __stdcall *SetTextFilterSize )( 
            ID3D10Device1 * This,
             
              UINT Width,
             
              UINT Height);
        
        void ( __stdcall *GetTextFilterSize )( 
            ID3D10Device1 * This,
             
              UINT *pWidth,
             
              UINT *pHeight);
        
        HRESULT ( __stdcall *CreateShaderResourceView1 )( 
            ID3D10Device1 * This,
             
              ID3D10Resource *pResource,
             
              const D3D10_SHADER_RESOURCE_VIEW_DESC1 *pDesc,
             
              ID3D10ShaderResourceView1 **ppSRView);
        
        HRESULT ( __stdcall *CreateBlendState1 )( 
            ID3D10Device1 * This,
             
              const D3D10_BLEND_DESC1 *pBlendStateDesc,
             
              ID3D10BlendState1 **ppBlendState);
        
        D3D10_FEATURE_LEVEL1 ( __stdcall *GetFeatureLevel )( 
            ID3D10Device1 * This);
        
        
    } ID3D10Device1Vtbl;

    struct ID3D10Device1
    {
        const struct ID3D10Device1Vtbl *lpVtbl;
    };
]]
    

if COBJMACROS then


#define ID3D10Device1_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define ID3D10Device1_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define ID3D10Device1_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define ID3D10Device1_VSSetConstantBuffers(This,StartSlot,NumBuffers,ppConstantBuffers)	\
    ( (This)->lpVtbl -> VSSetConstantBuffers(This,StartSlot,NumBuffers,ppConstantBuffers) ) 

#define ID3D10Device1_PSSetShaderResources(This,StartSlot,NumViews,ppShaderResourceViews)	\
    ( (This)->lpVtbl -> PSSetShaderResources(This,StartSlot,NumViews,ppShaderResourceViews) ) 

#define ID3D10Device1_PSSetShader(This,pPixelShader)	\
    ( (This)->lpVtbl -> PSSetShader(This,pPixelShader) ) 

#define ID3D10Device1_PSSetSamplers(This,StartSlot,NumSamplers,ppSamplers)	\
    ( (This)->lpVtbl -> PSSetSamplers(This,StartSlot,NumSamplers,ppSamplers) ) 

#define ID3D10Device1_VSSetShader(This,pVertexShader)	\
    ( (This)->lpVtbl -> VSSetShader(This,pVertexShader) ) 

#define ID3D10Device1_DrawIndexed(This,IndexCount,StartIndexLocation,BaseVertexLocation)	\
    ( (This)->lpVtbl -> DrawIndexed(This,IndexCount,StartIndexLocation,BaseVertexLocation) ) 

#define ID3D10Device1_Draw(This,VertexCount,StartVertexLocation)	\
    ( (This)->lpVtbl -> Draw(This,VertexCount,StartVertexLocation) ) 

#define ID3D10Device1_PSSetConstantBuffers(This,StartSlot,NumBuffers,ppConstantBuffers)	\
    ( (This)->lpVtbl -> PSSetConstantBuffers(This,StartSlot,NumBuffers,ppConstantBuffers) ) 

#define ID3D10Device1_IASetInputLayout(This,pInputLayout)	\
    ( (This)->lpVtbl -> IASetInputLayout(This,pInputLayout) ) 

#define ID3D10Device1_IASetVertexBuffers(This,StartSlot,NumBuffers,ppVertexBuffers,pStrides,pOffsets)	\
    ( (This)->lpVtbl -> IASetVertexBuffers(This,StartSlot,NumBuffers,ppVertexBuffers,pStrides,pOffsets) ) 

#define ID3D10Device1_IASetIndexBuffer(This,pIndexBuffer,Format,Offset)	\
    ( (This)->lpVtbl -> IASetIndexBuffer(This,pIndexBuffer,Format,Offset) ) 

#define ID3D10Device1_DrawIndexedInstanced(This,IndexCountPerInstance,InstanceCount,StartIndexLocation,BaseVertexLocation,StartInstanceLocation)	\
    ( (This)->lpVtbl -> DrawIndexedInstanced(This,IndexCountPerInstance,InstanceCount,StartIndexLocation,BaseVertexLocation,StartInstanceLocation) ) 

#define ID3D10Device1_DrawInstanced(This,VertexCountPerInstance,InstanceCount,StartVertexLocation,StartInstanceLocation)	\
    ( (This)->lpVtbl -> DrawInstanced(This,VertexCountPerInstance,InstanceCount,StartVertexLocation,StartInstanceLocation) ) 

#define ID3D10Device1_GSSetConstantBuffers(This,StartSlot,NumBuffers,ppConstantBuffers)	\
    ( (This)->lpVtbl -> GSSetConstantBuffers(This,StartSlot,NumBuffers,ppConstantBuffers) ) 

#define ID3D10Device1_GSSetShader(This,pShader)	\
    ( (This)->lpVtbl -> GSSetShader(This,pShader) ) 

#define ID3D10Device1_IASetPrimitiveTopology(This,Topology)	\
    ( (This)->lpVtbl -> IASetPrimitiveTopology(This,Topology) ) 

#define ID3D10Device1_VSSetShaderResources(This,StartSlot,NumViews,ppShaderResourceViews)	\
    ( (This)->lpVtbl -> VSSetShaderResources(This,StartSlot,NumViews,ppShaderResourceViews) ) 

#define ID3D10Device1_VSSetSamplers(This,StartSlot,NumSamplers,ppSamplers)	\
    ( (This)->lpVtbl -> VSSetSamplers(This,StartSlot,NumSamplers,ppSamplers) ) 

#define ID3D10Device1_SetPredication(This,pPredicate,PredicateValue)	\
    ( (This)->lpVtbl -> SetPredication(This,pPredicate,PredicateValue) ) 

#define ID3D10Device1_GSSetShaderResources(This,StartSlot,NumViews,ppShaderResourceViews)	\
    ( (This)->lpVtbl -> GSSetShaderResources(This,StartSlot,NumViews,ppShaderResourceViews) ) 

#define ID3D10Device1_GSSetSamplers(This,StartSlot,NumSamplers,ppSamplers)	\
    ( (This)->lpVtbl -> GSSetSamplers(This,StartSlot,NumSamplers,ppSamplers) ) 

#define ID3D10Device1_OMSetRenderTargets(This,NumViews,ppRenderTargetViews,pDepthStencilView)	\
    ( (This)->lpVtbl -> OMSetRenderTargets(This,NumViews,ppRenderTargetViews,pDepthStencilView) ) 

#define ID3D10Device1_OMSetBlendState(This,pBlendState,BlendFactor,SampleMask)	\
    ( (This)->lpVtbl -> OMSetBlendState(This,pBlendState,BlendFactor,SampleMask) ) 

#define ID3D10Device1_OMSetDepthStencilState(This,pDepthStencilState,StencilRef)	\
    ( (This)->lpVtbl -> OMSetDepthStencilState(This,pDepthStencilState,StencilRef) ) 

#define ID3D10Device1_SOSetTargets(This,NumBuffers,ppSOTargets,pOffsets)	\
    ( (This)->lpVtbl -> SOSetTargets(This,NumBuffers,ppSOTargets,pOffsets) ) 

#define ID3D10Device1_DrawAuto(This)	\
    ( (This)->lpVtbl -> DrawAuto(This) ) 

#define ID3D10Device1_RSSetState(This,pRasterizerState)	\
    ( (This)->lpVtbl -> RSSetState(This,pRasterizerState) ) 

#define ID3D10Device1_RSSetViewports(This,NumViewports,pViewports)	\
    ( (This)->lpVtbl -> RSSetViewports(This,NumViewports,pViewports) ) 

#define ID3D10Device1_RSSetScissorRects(This,NumRects,pRects)	\
    ( (This)->lpVtbl -> RSSetScissorRects(This,NumRects,pRects) ) 

#define ID3D10Device1_CopySubresourceRegion(This,pDstResource,DstSubresource,DstX,DstY,DstZ,pSrcResource,SrcSubresource,pSrcBox)	\
    ( (This)->lpVtbl -> CopySubresourceRegion(This,pDstResource,DstSubresource,DstX,DstY,DstZ,pSrcResource,SrcSubresource,pSrcBox) ) 

#define ID3D10Device1_CopyResource(This,pDstResource,pSrcResource)	\
    ( (This)->lpVtbl -> CopyResource(This,pDstResource,pSrcResource) ) 

#define ID3D10Device1_UpdateSubresource(This,pDstResource,DstSubresource,pDstBox,pSrcData,SrcRowPitch,SrcDepthPitch)	\
    ( (This)->lpVtbl -> UpdateSubresource(This,pDstResource,DstSubresource,pDstBox,pSrcData,SrcRowPitch,SrcDepthPitch) ) 

#define ID3D10Device1_ClearRenderTargetView(This,pRenderTargetView,ColorRGBA)	\
    ( (This)->lpVtbl -> ClearRenderTargetView(This,pRenderTargetView,ColorRGBA) ) 

#define ID3D10Device1_ClearDepthStencilView(This,pDepthStencilView,ClearFlags,Depth,Stencil)	\
    ( (This)->lpVtbl -> ClearDepthStencilView(This,pDepthStencilView,ClearFlags,Depth,Stencil) ) 

#define ID3D10Device1_GenerateMips(This,pShaderResourceView)	\
    ( (This)->lpVtbl -> GenerateMips(This,pShaderResourceView) ) 

#define ID3D10Device1_ResolveSubresource(This,pDstResource,DstSubresource,pSrcResource,SrcSubresource,Format)	\
    ( (This)->lpVtbl -> ResolveSubresource(This,pDstResource,DstSubresource,pSrcResource,SrcSubresource,Format) ) 

#define ID3D10Device1_VSGetConstantBuffers(This,StartSlot,NumBuffers,ppConstantBuffers)	\
    ( (This)->lpVtbl -> VSGetConstantBuffers(This,StartSlot,NumBuffers,ppConstantBuffers) ) 

#define ID3D10Device1_PSGetShaderResources(This,StartSlot,NumViews,ppShaderResourceViews)	\
    ( (This)->lpVtbl -> PSGetShaderResources(This,StartSlot,NumViews,ppShaderResourceViews) ) 

#define ID3D10Device1_PSGetShader(This,ppPixelShader)	\
    ( (This)->lpVtbl -> PSGetShader(This,ppPixelShader) ) 

#define ID3D10Device1_PSGetSamplers(This,StartSlot,NumSamplers,ppSamplers)	\
    ( (This)->lpVtbl -> PSGetSamplers(This,StartSlot,NumSamplers,ppSamplers) ) 

#define ID3D10Device1_VSGetShader(This,ppVertexShader)	\
    ( (This)->lpVtbl -> VSGetShader(This,ppVertexShader) ) 

#define ID3D10Device1_PSGetConstantBuffers(This,StartSlot,NumBuffers,ppConstantBuffers)	\
    ( (This)->lpVtbl -> PSGetConstantBuffers(This,StartSlot,NumBuffers,ppConstantBuffers) ) 

#define ID3D10Device1_IAGetInputLayout(This,ppInputLayout)	\
    ( (This)->lpVtbl -> IAGetInputLayout(This,ppInputLayout) ) 

#define ID3D10Device1_IAGetVertexBuffers(This,StartSlot,NumBuffers,ppVertexBuffers,pStrides,pOffsets)	\
    ( (This)->lpVtbl -> IAGetVertexBuffers(This,StartSlot,NumBuffers,ppVertexBuffers,pStrides,pOffsets) ) 

#define ID3D10Device1_IAGetIndexBuffer(This,pIndexBuffer,Format,Offset)	\
    ( (This)->lpVtbl -> IAGetIndexBuffer(This,pIndexBuffer,Format,Offset) ) 

#define ID3D10Device1_GSGetConstantBuffers(This,StartSlot,NumBuffers,ppConstantBuffers)	\
    ( (This)->lpVtbl -> GSGetConstantBuffers(This,StartSlot,NumBuffers,ppConstantBuffers) ) 

#define ID3D10Device1_GSGetShader(This,ppGeometryShader)	\
    ( (This)->lpVtbl -> GSGetShader(This,ppGeometryShader) ) 

#define ID3D10Device1_IAGetPrimitiveTopology(This,pTopology)	\
    ( (This)->lpVtbl -> IAGetPrimitiveTopology(This,pTopology) ) 

#define ID3D10Device1_VSGetShaderResources(This,StartSlot,NumViews,ppShaderResourceViews)	\
    ( (This)->lpVtbl -> VSGetShaderResources(This,StartSlot,NumViews,ppShaderResourceViews) ) 

#define ID3D10Device1_VSGetSamplers(This,StartSlot,NumSamplers,ppSamplers)	\
    ( (This)->lpVtbl -> VSGetSamplers(This,StartSlot,NumSamplers,ppSamplers) ) 

#define ID3D10Device1_GetPredication(This,ppPredicate,pPredicateValue)	\
    ( (This)->lpVtbl -> GetPredication(This,ppPredicate,pPredicateValue) ) 

#define ID3D10Device1_GSGetShaderResources(This,StartSlot,NumViews,ppShaderResourceViews)	\
    ( (This)->lpVtbl -> GSGetShaderResources(This,StartSlot,NumViews,ppShaderResourceViews) ) 

#define ID3D10Device1_GSGetSamplers(This,StartSlot,NumSamplers,ppSamplers)	\
    ( (This)->lpVtbl -> GSGetSamplers(This,StartSlot,NumSamplers,ppSamplers) ) 

#define ID3D10Device1_OMGetRenderTargets(This,NumViews,ppRenderTargetViews,ppDepthStencilView)	\
    ( (This)->lpVtbl -> OMGetRenderTargets(This,NumViews,ppRenderTargetViews,ppDepthStencilView) ) 

#define ID3D10Device1_OMGetBlendState(This,ppBlendState,BlendFactor,pSampleMask)	\
    ( (This)->lpVtbl -> OMGetBlendState(This,ppBlendState,BlendFactor,pSampleMask) ) 

#define ID3D10Device1_OMGetDepthStencilState(This,ppDepthStencilState,pStencilRef)	\
    ( (This)->lpVtbl -> OMGetDepthStencilState(This,ppDepthStencilState,pStencilRef) ) 

#define ID3D10Device1_SOGetTargets(This,NumBuffers,ppSOTargets,pOffsets)	\
    ( (This)->lpVtbl -> SOGetTargets(This,NumBuffers,ppSOTargets,pOffsets) ) 

#define ID3D10Device1_RSGetState(This,ppRasterizerState)	\
    ( (This)->lpVtbl -> RSGetState(This,ppRasterizerState) ) 

#define ID3D10Device1_RSGetViewports(This,NumViewports,pViewports)	\
    ( (This)->lpVtbl -> RSGetViewports(This,NumViewports,pViewports) ) 

#define ID3D10Device1_RSGetScissorRects(This,NumRects,pRects)	\
    ( (This)->lpVtbl -> RSGetScissorRects(This,NumRects,pRects) ) 

#define ID3D10Device1_GetDeviceRemovedReason(This)	\
    ( (This)->lpVtbl -> GetDeviceRemovedReason(This) ) 

#define ID3D10Device1_SetExceptionMode(This,RaiseFlags)	\
    ( (This)->lpVtbl -> SetExceptionMode(This,RaiseFlags) ) 

#define ID3D10Device1_GetExceptionMode(This)	\
    ( (This)->lpVtbl -> GetExceptionMode(This) ) 

#define ID3D10Device1_GetPrivateData(This,guid,pDataSize,pData)	\
    ( (This)->lpVtbl -> GetPrivateData(This,guid,pDataSize,pData) ) 

#define ID3D10Device1_SetPrivateData(This,guid,DataSize,pData)	\
    ( (This)->lpVtbl -> SetPrivateData(This,guid,DataSize,pData) ) 

#define ID3D10Device1_SetPrivateDataInterface(This,guid,pData)	\
    ( (This)->lpVtbl -> SetPrivateDataInterface(This,guid,pData) ) 

#define ID3D10Device1_ClearState(This)	\
    ( (This)->lpVtbl -> ClearState(This) ) 

#define ID3D10Device1_Flush(This)	\
    ( (This)->lpVtbl -> Flush(This) ) 

#define ID3D10Device1_CreateBuffer(This,pDesc,pInitialData,ppBuffer)	\
    ( (This)->lpVtbl -> CreateBuffer(This,pDesc,pInitialData,ppBuffer) ) 

#define ID3D10Device1_CreateTexture1D(This,pDesc,pInitialData,ppTexture1D)	\
    ( (This)->lpVtbl -> CreateTexture1D(This,pDesc,pInitialData,ppTexture1D) ) 

#define ID3D10Device1_CreateTexture2D(This,pDesc,pInitialData,ppTexture2D)	\
    ( (This)->lpVtbl -> CreateTexture2D(This,pDesc,pInitialData,ppTexture2D) ) 

#define ID3D10Device1_CreateTexture3D(This,pDesc,pInitialData,ppTexture3D)	\
    ( (This)->lpVtbl -> CreateTexture3D(This,pDesc,pInitialData,ppTexture3D) ) 

#define ID3D10Device1_CreateShaderResourceView(This,pResource,pDesc,ppSRView)	\
    ( (This)->lpVtbl -> CreateShaderResourceView(This,pResource,pDesc,ppSRView) ) 

#define ID3D10Device1_CreateRenderTargetView(This,pResource,pDesc,ppRTView)	\
    ( (This)->lpVtbl -> CreateRenderTargetView(This,pResource,pDesc,ppRTView) ) 

#define ID3D10Device1_CreateDepthStencilView(This,pResource,pDesc,ppDepthStencilView)	\
    ( (This)->lpVtbl -> CreateDepthStencilView(This,pResource,pDesc,ppDepthStencilView) ) 

#define ID3D10Device1_CreateInputLayout(This,pInputElementDescs,NumElements,pShaderBytecodeWithInputSignature,BytecodeLength,ppInputLayout)	\
    ( (This)->lpVtbl -> CreateInputLayout(This,pInputElementDescs,NumElements,pShaderBytecodeWithInputSignature,BytecodeLength,ppInputLayout) ) 

#define ID3D10Device1_CreateVertexShader(This,pShaderBytecode,BytecodeLength,ppVertexShader)	\
    ( (This)->lpVtbl -> CreateVertexShader(This,pShaderBytecode,BytecodeLength,ppVertexShader) ) 

#define ID3D10Device1_CreateGeometryShader(This,pShaderBytecode,BytecodeLength,ppGeometryShader)	\
    ( (This)->lpVtbl -> CreateGeometryShader(This,pShaderBytecode,BytecodeLength,ppGeometryShader) ) 

#define ID3D10Device1_CreateGeometryShaderWithStreamOutput(This,pShaderBytecode,BytecodeLength,pSODeclaration,NumEntries,OutputStreamStride,ppGeometryShader)	\
    ( (This)->lpVtbl -> CreateGeometryShaderWithStreamOutput(This,pShaderBytecode,BytecodeLength,pSODeclaration,NumEntries,OutputStreamStride,ppGeometryShader) ) 

#define ID3D10Device1_CreatePixelShader(This,pShaderBytecode,BytecodeLength,ppPixelShader)	\
    ( (This)->lpVtbl -> CreatePixelShader(This,pShaderBytecode,BytecodeLength,ppPixelShader) ) 

#define ID3D10Device1_CreateBlendState(This,pBlendStateDesc,ppBlendState)	\
    ( (This)->lpVtbl -> CreateBlendState(This,pBlendStateDesc,ppBlendState) ) 

#define ID3D10Device1_CreateDepthStencilState(This,pDepthStencilDesc,ppDepthStencilState)	\
    ( (This)->lpVtbl -> CreateDepthStencilState(This,pDepthStencilDesc,ppDepthStencilState) ) 

#define ID3D10Device1_CreateRasterizerState(This,pRasterizerDesc,ppRasterizerState)	\
    ( (This)->lpVtbl -> CreateRasterizerState(This,pRasterizerDesc,ppRasterizerState) ) 

#define ID3D10Device1_CreateSamplerState(This,pSamplerDesc,ppSamplerState)	\
    ( (This)->lpVtbl -> CreateSamplerState(This,pSamplerDesc,ppSamplerState) ) 

#define ID3D10Device1_CreateQuery(This,pQueryDesc,ppQuery)	\
    ( (This)->lpVtbl -> CreateQuery(This,pQueryDesc,ppQuery) ) 

#define ID3D10Device1_CreatePredicate(This,pPredicateDesc,ppPredicate)	\
    ( (This)->lpVtbl -> CreatePredicate(This,pPredicateDesc,ppPredicate) ) 

#define ID3D10Device1_CreateCounter(This,pCounterDesc,ppCounter)	\
    ( (This)->lpVtbl -> CreateCounter(This,pCounterDesc,ppCounter) ) 

#define ID3D10Device1_CheckFormatSupport(This,Format,pFormatSupport)	\
    ( (This)->lpVtbl -> CheckFormatSupport(This,Format,pFormatSupport) ) 

#define ID3D10Device1_CheckMultisampleQualityLevels(This,Format,SampleCount,pNumQualityLevels)	\
    ( (This)->lpVtbl -> CheckMultisampleQualityLevels(This,Format,SampleCount,pNumQualityLevels) ) 

#define ID3D10Device1_CheckCounterInfo(This,pCounterInfo)	\
    ( (This)->lpVtbl -> CheckCounterInfo(This,pCounterInfo) ) 

#define ID3D10Device1_CheckCounter(This,pDesc,pType,pActiveCounters,szName,pNameLength,szUnits,pUnitsLength,szDescription,pDescriptionLength)	\
    ( (This)->lpVtbl -> CheckCounter(This,pDesc,pType,pActiveCounters,szName,pNameLength,szUnits,pUnitsLength,szDescription,pDescriptionLength) ) 

#define ID3D10Device1_GetCreationFlags(This)	\
    ( (This)->lpVtbl -> GetCreationFlags(This) ) 

#define ID3D10Device1_OpenSharedResource(This,hResource,ReturnedInterface,ppResource)	\
    ( (This)->lpVtbl -> OpenSharedResource(This,hResource,ReturnedInterface,ppResource) ) 

#define ID3D10Device1_SetTextFilterSize(This,Width,Height)	\
    ( (This)->lpVtbl -> SetTextFilterSize(This,Width,Height) ) 

#define ID3D10Device1_GetTextFilterSize(This,pWidth,pHeight)	\
    ( (This)->lpVtbl -> GetTextFilterSize(This,pWidth,pHeight) ) 


#define ID3D10Device1_CreateShaderResourceView1(This,pResource,pDesc,ppSRView)	\
    ( (This)->lpVtbl -> CreateShaderResourceView1(This,pResource,pDesc,ppSRView) ) 

#define ID3D10Device1_CreateBlendState1(This,pBlendStateDesc,ppBlendState)	\
    ( (This)->lpVtbl -> CreateBlendState1(This,pBlendStateDesc,ppBlendState) ) 

#define ID3D10Device1_GetFeatureLevel(This)	\
    ( (This)->lpVtbl -> GetFeatureLevel(This) ) 

end /* COBJMACROS */





end 	/* __ID3D10Device1_INTERFACE_DEFINED__ */



D3D10_1_SDK_VERSION	= ( 0 + 0x20 );

require("win32.d3d10_1shader") 

ffi.cdef[[
typedef HRESULT (__stdcall* PFN_D3D10_CREATE_DEVICE1)(IDXGIAdapter *, 
    D3D10_DRIVER_TYPE, HMODULE, UINT, D3D10_FEATURE_LEVEL1, UINT, ID3D10Device1**);

HRESULT __stdcall D3D10CreateDevice1(
     IDXGIAdapter *pAdapter,
    D3D10_DRIVER_TYPE DriverType,
    HMODULE Software,
    UINT Flags,
    D3D10_FEATURE_LEVEL1 HardwareLevel,
    UINT SDKVersion,
     ID3D10Device1 **ppDevice);

typedef HRESULT (__stdcall* PFN_D3D10_CREATE_DEVICE_AND_SWAP_CHAIN1)(IDXGIAdapter *, 
    D3D10_DRIVER_TYPE, HMODULE, UINT, D3D10_FEATURE_LEVEL1, UINT, DXGI_SWAP_CHAIN_DESC *, IDXGISwapChain **, ID3D10Device1 **);

HRESULT __stdcall D3D10CreateDeviceAndSwapChain1(
     IDXGIAdapter *pAdapter,
    D3D10_DRIVER_TYPE DriverType,
    HMODULE Software,
    UINT Flags,
    D3D10_FEATURE_LEVEL1 HardwareLevel,
    UINT SDKVersion,
     DXGI_SWAP_CHAIN_DESC *pSwapChainDesc,
     IDXGISwapChain **ppSwapChain,
     ID3D10Device1 **ppDevice);
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


IID_ID3D10BlendState1 = DEFINE_GUID("IID_ID3D10BlendState1",0xEDAD8D99,0x8A35,0x4d6d,0x85,0x66,0x2E,0xA2,0x76,0xCD,0xE1,0x61);
IID_ID3D10ShaderResourceView1 = DEFINE_GUID("IID_ID3D10ShaderResourceView1",0x9B7E4C87,0x342C,0x4106,0xA1,0x9F,0x4F,0x27,0x04,0xF6,0x89,0xF0);
IID_ID3D10Device1 = DEFINE_GUID("IID_ID3D10Device1",0x9B7E4C8F,0x342C,0x4106,0xA1,0x9F,0x4F,0x27,0x04,0xF6,0x89,0xF0);


end


