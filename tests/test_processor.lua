package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C

require("win32.sdkddkver")
require("win32.windef")
require("win32.processthreadsapi")

local features = {
    PF_FLOATING_POINT_PRECISION_ERRATA      = C.PF_FLOATING_POINT_PRECISION_ERRATA;   
    PF_FLOATING_POINT_EMULATED              = C.PF_FLOATING_POINT_EMULATED;   
    PF_COMPARE_EXCHANGE_DOUBLE              = C.PF_COMPARE_EXCHANGE_DOUBLE;   
    PF_MMX_INSTRUCTIONS_AVAILABLE           = C.PF_MMX_INSTRUCTIONS_AVAILABLE;   
    PF_PPC_MOVEMEM_64BIT_OK                 = C.PF_PPC_MOVEMEM_64BIT_OK;   
    PF_ALPHA_BYTE_INSTRUCTIONS              = C.PF_ALPHA_BYTE_INSTRUCTIONS;   
    PF_XMMI_INSTRUCTIONS_AVAILABLE          = C.PF_XMMI_INSTRUCTIONS_AVAILABLE;   
    PF_3DNOW_INSTRUCTIONS_AVAILABLE         = C.PF_3DNOW_INSTRUCTIONS_AVAILABLE;   
    PF_RDTSC_INSTRUCTION_AVAILABLE          = C.PF_RDTSC_INSTRUCTION_AVAILABLE;   
    PF_PAE_ENABLED                          = C.PF_PAE_ENABLED;   
    PF_XMMI64_INSTRUCTIONS_AVAILABLE       = C.PF_XMMI64_INSTRUCTIONS_AVAILABLE;   
    PF_SSE_DAZ_MODE_AVAILABLE              = C.PF_SSE_DAZ_MODE_AVAILABLE;   
    PF_NX_ENABLED                          = C.PF_NX_ENABLED;   
    PF_SSE3_INSTRUCTIONS_AVAILABLE         = C.PF_SSE3_INSTRUCTIONS_AVAILABLE;   
    PF_COMPARE_EXCHANGE128                 = C.PF_COMPARE_EXCHANGE128;   
    PF_COMPARE64_EXCHANGE128               = C.PF_COMPARE64_EXCHANGE128;   
    PF_CHANNELS_ENABLED                    = C.PF_CHANNELS_ENABLED;   
    PF_XSAVE_ENABLED                       = C.PF_XSAVE_ENABLED;   
    PF_ARM_VFP_32_REGISTERS_AVAILABLE      = C.PF_ARM_VFP_32_REGISTERS_AVAILABLE;   
    PF_ARM_NEON_INSTRUCTIONS_AVAILABLE     = C.PF_ARM_NEON_INSTRUCTIONS_AVAILABLE;   
    PF_SECOND_LEVEL_ADDRESS_TRANSLATION    = C.PF_SECOND_LEVEL_ADDRESS_TRANSLATION;   
    PF_VIRT_FIRMWARE_ENABLED               = C.PF_VIRT_FIRMWARE_ENABLED;   
    PF_RDWRFSGSBASE_AVAILABLE              = C.PF_RDWRFSGSBASE_AVAILABLE;   
    PF_FASTFAIL_AVAILABLE                  = C.PF_FASTFAIL_AVAILABLE;   
    PF_ARM_DIVIDE_INSTRUCTION_AVAILABLE    = C.PF_ARM_DIVIDE_INSTRUCTION_AVAILABLE;   
    PF_ARM_64BIT_LOADSTORE_ATOMIC          = C.PF_ARM_64BIT_LOADSTORE_ATOMIC;   
    PF_ARM_EXTERNAL_CACHE_AVAILABLE        = C.PF_ARM_EXTERNAL_CACHE_AVAILABLE;   
    PF_ARM_FMAC_INSTRUCTIONS_AVAILABLE     = C.PF_ARM_FMAC_INSTRUCTIONS_AVAILABLE;   
    PF_RDRAND_INSTRUCTION_AVAILABLE        = C.PF_RDRAND_INSTRUCTION_AVAILABLE;   
    PF_ARM_V8_INSTRUCTIONS_AVAILABLE       = C.PF_ARM_V8_INSTRUCTIONS_AVAILABLE;   
    PF_ARM_V8_CRYPTO_INSTRUCTIONS_AVAILABLE = C.PF_ARM_V8_CRYPTO_INSTRUCTIONS_AVAILABLE;   
    PF_ARM_V8_CRC32_INSTRUCTIONS_AVAILABLE  = C.PF_ARM_V8_CRC32_INSTRUCTIONS_AVAILABLE;   
    PF_RDTSCP_INSTRUCTION_AVAILABLE         = C.PF_RDTSCP_INSTRUCTION_AVAILABLE;   
}

--[[
    An iterator for the positive processor features
]]
local function processorFeatures()

    local function visit()
        for k,v in pairs(features) do 
            if C.IsProcessorFeaturePresent(v) ~= 0 then
                coroutine.yield(k)
            end
        end

        return nil
    end

    local co = coroutine.create(visit)

    return function()
        local status, name = coroutine.resume(co)
        if status then
            return name
        else
            return nil
        end
    end
end

print("== Processor Features ==")
for name, value  in processorFeatures() do 
    print(name)
end
