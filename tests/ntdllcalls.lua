--[[
    These are the functions with declarations in the winternl.lua file

    The ntdll.dll library contains a lot more functions than these, but
    these are the ones that are somewhat 'public'
]]

--[[
NtClose
NtCreateFile
NtOpenFile

NtRenameKey
NtNotifyChangeMultipleKeys
NtQueryMultipleValueKey
NtSetInformationKey

NtDeviceIoControlFile
NtWaitForSingleObject



NtQueryInformationProcess
NtQueryInformationThread
NtQueryObject
NtQuerySystemInformation
NtQuerySystemTime

RtlIsNameLegalDOS8Dot3
RtlNtStatusToDosError
RtlLocalTimeToSystemTime
RtlTimeToSecondsSince1970
RtlFreeAnsiString
RtlFreeUnicodeString
RtlFreeOemString
RtlInitString
RtlInitStringEx
RtlInitAnsiString
RtlInitAnsiStringEx
RtlInitUnicodeString
RtlAnsiStringToUnicodeString
RtlUnicodeStringToAnsiString
RtlUnicodeStringToOemString
RtlUnicodeToMultiByteSize
RtlCharToInteger
RtlConvertSidToUnicodeString
RtlUniform
--]]


local lib = ffi.load("ntdll")

return lib
