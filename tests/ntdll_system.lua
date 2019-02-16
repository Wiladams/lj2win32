package.path = "../?.lua;"..package.path;

--[[
    References:

]]

local ffi = require("ffi")
local C = ffi.C 


local ntdll = require("win32.winternl")
local enum = require("enum")

ffi.cdef[[
static const int STATUS_SUCCESS                  = ((NTSTATUS)0x00000000L);
static const int STATUS_INVALID_INFO_CLASS       = ((NTSTATUS)0xC0000003L);
static const int STATUS_INFO_LENGTH_MISMATCH     = ((NTSTATUS)0xC0000004L);

]]

local exports = {}

--[[
    The SYSTEM_INFORMATION_CLASS enum is an elusive beast.  The 
    one Microsoft 'supports' has a cdef in the winternl file.  that
    only has 19 entries.

    The the power of the internet, more of the names/values have 
    been found, up through Windows 10.

    http://www.geoffchappell.com/studies/windows/km/ntoskrnl/api/ex/sysinfo/query.htm
    https://stackoverflow.com/questions/28858849/where-is-system-information-class-defined

]]
-- full on database
-- most complete
local SYSTEM_INFORMATION_CLASS = enum {
SystemBasicInformation = 0x00,
SystemProcessorInformation =0x01 ,
SystemPerformanceInformation = 0x02 ,
SystemTimeOfDayInformation =0x03 ,
SystemPathInformation =0x04 ,
SystemProcessInformation =0x05 ,
SystemCallCountInformation =0x06 ,
SystemDeviceInformation =0x07 ,
SystemProcessorPerformanceInformation =0x08 ,
SystemFlagsInformation =0x09 ,
SystemCallTimeInformation =0x0A ,
SystemModuleInformation =0x0B ,
SystemLocksInformation =0x0C ,
SystemStackTraceInformation =0x0D ,
SystemPagedPoolInformation =0x0E ,
SystemNonPagedPoolInformation =0x0F ,
SystemHandleInformation =0x10 ,
SystemObjectInformation =0x11 ,
SystemPageFileInformation =0x12 ,
SystemVdmInstemulInformation =0x13 ,
SystemVdmBopInformation =0x14 ,
SystemFileCacheInformation =0x15 ,
SystemPoolTagInformation =0x16 ,
SystemInterruptInformation =0x17 ,
SystemDpcBehaviorInformation =0x18 ,
SystemFullMemoryInformation =0x19 ,
SystemLoadGdiDriverInformation =0x1A ,
SystemUnloadGdiDriverInformation =0x1B ,
SystemTimeAdjustmentInformation =0x1C ,
SystemSummaryMemoryInformation =0x1D ,
SystemMirrorMemoryInformation =0x1E ,
SystemPerformanceTraceInformation =0x1F ,
SystemObsolete0 =0x20 ,
SystemExceptionInformation =0x21 ,
SystemCrashDumpStateInformation =0x22 ,
SystemKernelDebuggerInformation =0x23 ,
SystemContextSwitchInformation =0x24 ,
SystemRegistryQuotaInformation =0x25 ,
SystemExtendedServiceTableInformation =0x26 ,
SystemPrioritySeparation =0x27 ,
SystemVerifierAddDriverInformation =0x28 ,
SystemVerifierRemoveDriverInformation =0x29 ,
SystemProcessorIdleInformation =0x2A ,
SystemLegacyDriverInformation =0x2B ,
SystemCurrentTimeZoneInformation =0x2C ,
SystemLookasideInformation =0x2D ,
SystemTimeSlipNotification =0x2E ,
SystemSessionCreate =0x2F ,
SystemSessionDetach =0x30 ,
SystemSessionInformation =0x31 ,
SystemRangeStartInformation =0x32 ,
SystemVerifierInformation =0x33 ,
SystemVerifierThunkExtend =0x34 ,
SystemSessionProcessInformation =0x35 ,
SystemLoadGdiDriverInSystemSpace =0x36 ,
SystemNumaProcessorMap =0x37 ,
SystemPrefetcherInformation =0x38 ,
SystemExtendedProcessInformation =0x39 ,
SystemRecommendedSharedDataAlignment =0x3A ,
SystemComPlusPackage =0x3B ,
SystemNumaAvailableMemory =0x3C ,
SystemProcessorPowerInformation =0x3D ,
SystemEmulationBasicInformation =0x3E ,
SystemEmulationProcessorInformation =0x3F ,
SystemExtendedHandleInformation =0x40 ,
SystemLostDelayedWriteInformation =0x41 ,
SystemBigPoolInformation =0x42 ,
SystemSessionPoolTagInformation =0x43 ,
SystemSessionMappedViewInformation =0x44 ,
SystemHotpatchInformation =0x45 ,
SystemObjectSecurityMode =0x46 ,
SystemWatchdogTimerHandler =0x47 ,
SystemWatchdogTimerInformation =0x48 ,
SystemLogicalProcessorInformation =0x49 ,
SystemWow64SharedInformationObsolete =0x4A ,
SystemRegisterFirmwareTableInformationHandler =0x4B ,
SystemFirmwareTableInformation =0x4C ,
SystemModuleInformationEx =0x4D ,
SystemVerifierTriageInformation =0x4E ,
SystemSuperfetchInformation =0x4F ,
SystemMemoryListInformation =0x50 ,
SystemFileCacheInformationEx =0x51 ,
SystemThreadPriorityClientIdInformation =0x52 ,
SystemProcessorIdleCycleTimeInformation =0x53 ,
SystemVerifierCancellationInformation =0x54 ,
SystemProcessorPowerInformationEx =0x55 ,
SystemRefTraceInformation =0x56 ,
SystemSpecialPoolInformation =0x57 ,
SystemProcessIdInformation =0x58 ,
SystemErrorPortInformation =0x59 ,
SystemBootEnvironmentInformation =0x5A ,
SystemHypervisorInformation =0x5B ,
SystemVerifierInformationEx =0x5C ,
SystemTimeZoneInformation =0x5D ,
SystemImageFileExecutionOptionsInformation =0x5E ,
SystemCoverageInformation =0x5F ,
SystemPrefetchPatchInformation =0x60 ,
SystemVerifierFaultsInformation =0x61 ,
SystemSystemPartitionInformation =0x62 ,
SystemSystemDiskInformation =0x63 ,
SystemProcessorPerformanceDistribution =0x64 ,
SystemNumaProximityNodeInformation =0x65 ,
SystemDynamicTimeZoneInformation =0x66 ,
SystemCodeIntegrityInformation =0x67 ,
SystemProcessorMicrocodeUpdateInformation =0x68 ,
SystemProcessorBrandString =0x69 ,
SystemVirtualAddressInformation =0x6A ,
SystemLogicalProcessorAndGroupInformation =0x6B ,
SystemProcessorCycleTimeInformation =0x6C ,
SystemStoreInformation =0x6D ,
SystemRegistryAppendString =0x6E ,
SystemAitSamplingValue =0x6F ,
SystemVhdBootInformation =0x70 ,
SystemCpuQuotaInformation =0x71 ,
SystemNativeBasicInformation =0x72 ,
SystemErrorPortTimeouts =0x73 ,
SystemLowPriorityIoInformation =0x74 ,
SystemBootEntropyInformation =0x75 ,
SystemVerifierCountersInformation =0x76 ,
SystemPagedPoolInformationEx =0x77 ,
SystemSystemPtesInformationEx =0x78 ,
SystemNodeDistanceInformation =0x79 ,
SystemAcpiAuditInformation =0x7A ,
SystemBasicPerformanceInformation =0x7B ,
SystemQueryPerformanceCounterInformation =0x7C ,
SystemSessionBigPoolInformation =0x7D ,
SystemBootGraphicsInformation =0x7E ,
SystemScrubPhysicalMemoryInformation =0x7F ,
SystemBadPageInformation =0x80 ,
SystemProcessorProfileControlArea =0x81 ,
SystemCombinePhysicalMemoryInformation =0x82 ,
SystemEntropyInterruptTimingInformation =0x83 ,
SystemConsoleInformation =0x84 ,
SystemPlatformBinaryInformation =0x85 ,

--6.2 0nly
--SystemThrottleNotificationInformation =0x86 ,
 
SystemPolicyInformation =0x86 ,
SystemHypervisorProcessorCountInformation =0x87 ,
SystemDeviceDataInformation =0x88 ,
SystemDeviceDataEnumerationInformation =0x89 ,
SystemMemoryTopologyInformation =0x8A ,
SystemMemoryChannelInformation =0x8B ,
SystemBootLogoInformation =0x8C ,
SystemProcessorPerformanceInformationEx =0x8D ,
SystemSpare0 =0x8E ,
SystemSecureBootPolicyInformation =0x8F ,
SystemPageFileInformationEx =0x90 ,
SystemSecureBootInformation =0x91 ,
SystemEntropyInterruptTimingRawInformation =0x92 ,
SystemPortableWorkspaceEfiLauncherInformation =0x93 ,
SystemFullProcessInformation =0x94 ,
SystemKernelDebuggerInformationEx =0x95 ,
SystemBootMetadataInformation =0x96 ,
SystemSoftRebootInformation =0x97 ,
SystemElamCertificateInformation =0x98 ,
SystemOfflineDumpConfigInformation =0x99 ,
SystemProcessorFeaturesInformation =0x9A ,
SystemRegistryReconciliationInformation =0x9B ,
SystemEdidInformation =0x9C ,
SystemManufacturingInformation =0x9D ,
SystemEnergyEstimationConfigInformation =0x9E ,
SystemHypervisorDetailInformation =0x9F ,
SystemProcessorCycleStatsInformation =0xA0 ,
SystemVmGenerationCountInformation =0xA1 ,
SystemTrustedPlatformModuleInformation =0xA2 ,
SystemKernelDebuggerFlags =0xA3 ,
SystemCodeIntegrityPolicyInformation =0xA4 ,
SystemIsolatedUserModeInformation =0xA5 ,
SystemHardwareSecurityTestInterfaceResultsInformation =0xA6 ,
SystemSingleModuleInformation =0xA7 ,
SystemAllowedCpuSetsInformation =0xA8 ,
SystemDmaProtectionInformation =0xA9 ,
SystemInterruptCpuSetsInformation =0xAA ,
SystemSecureBootPolicyFullInformation =0xAB ,
SystemCodeIntegrityPolicyFullInformation =0xAC ,
SystemAffinitizedInterruptProcessorInformation =0xAD ,
SystemRootSiloInformation =0xAE ,
SystemCpuSetInformation =0xAF ,
SystemCpuSetTagInformation =0xB0 ,
SystemWin32WerStartCallout =0xB1 ,
SystemSecureKernelProfileInformation =0xB2 ,
SystemCodeIntegrityPlatformManifestInformation =0xB3 ,
SystemInterruptSteeringInformation =0xB4 ,
SystemSuppportedProcessorArchitectures =0xB5 ,
SystemMemoryUsageInformation =0xB6 ,
SystemCodeIntegrityCertificateInformation =0xB7 ,
SystemPhysicalMemoryInformation =0xB8 ,
SystemControlFlowTransition =0xB9 ,
SystemKernelDebuggingAllowed =0xBA ,
SystemActivityModerationExeState =0xBB ,
SystemActivityModerationUserSettings =0xBC ,
SystemCodeIntegrityPoliciesFullInformation =0xBD ,
SystemCodeIntegrityUnlockInformation =0xBE ,
SystemIntegrityQuotaInformation =0xBF ,
SystemFlushInformation =0xC0 ,
SystemProcessorIdleMaskInformation =0xC1 ,
SystemSecureDumpEncryptionInformation =0xC2 ,
SystemWriteConstraintInformation =0xC3 ,
}

--[[
0x95 (6.2); 
0x9D (6.3); 
0xB1 (10.0); 
0xB3 (1511); 
0xB8 (1607); 
0xC1 (1703); 
0xC4 (1709) 
MaxSystemInfoClass 
--]]


--[[
    getSystemInformation

    Retrieves system information by calling the  NtQuerySystemInformation function.
    This is a matter of convenience, as it deals with getting the proper size of buffer
    to pass to the function.  

    Return
    buffer, bufferSize

    or nil, error on failure

    infoClass can be either string or numeric representation
]]
function exports.getSystemInformation(infoClass)
    --print("getSystemInformation, infoClass: ", infoClass)

    if type(infoClass) == "string" then
        infoClass = SYSTEM_INFORMATION_CLASS[infoClass]
    end
    
    if type(infoClass) ~= "number" then
        return nil, infoClass;
    end

    --print("Info Class: ", SYSTEM_INFORMATION_CLASS[infoClass])

    local SystemInformationLength = 0;
    local SystemInformation = nil;
    local pReturnLength = ffi.new("ULONG[1]",0)

    --  call once to see how much space we need to allocate
    local status = ntdll.NtQuerySystemInformation (
        infoClass,
        SystemInformation,
        SystemInformationLength,
        pReturnLength );

    --print("first status, length: ", string.format("0x%x",status), pReturnLength[0])
    if status ~= C.STATUS_INFO_LENGTH_MISMATCH then
        return false, status;
    end

    -- now we know length, so call again with a properly sized buffer
    SystemInformationLength = pReturnLength[0]
    print("InformationLength: ", string.format("0x%x", SystemInformationLength))
    if SystemInformationLength < 0 then
        return false, "Size Negative"
    end
    SystemInformation = ffi.new("uint8_t[?]", SystemInformationLength)
    status = ntdll.NtQuerySystemInformation (infoClass,
        SystemInformation, SystemInformationLength,
        pReturnLength );

    --print("second status, length: ", string.format("0x%x",status), pReturnLength[0])
    if status ~= C.STATUS_SUCCESS then
        return false, status;
    end

    return SystemInformation, pReturnLength[0]
end

exports.SYSTEM_INFORMATION_CLASS = SYSTEM_INFORMATION_CLASS


return exports