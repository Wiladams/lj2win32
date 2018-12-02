local ffi = require("ffi")

--* realtimeapi.h -- ApiSet Contract for api-ms-win-core-realtime-l1              *


--#ifndef _APISETREALTIME_
--#define _APISETREALTIME_

--#include <apiset.h>
--#include <apisetcconv.h>
require("win32.minwindef")




if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

--#if (_WIN32_WINNT >= 0x0600)

ffi.cdef[[
BOOL
__stdcall
QueryThreadCycleTime(
     HANDLE ThreadHandle,
     PULONG64 CycleTime
    );



BOOL
__stdcall
QueryProcessCycleTime(
     HANDLE ProcessHandle,
     PULONG64 CycleTime
    );



BOOL
__stdcall
QueryIdleProcessorCycleTime(
     PULONG BufferLength,
     PULONG64 ProcessorIdleCycleTime
    );
]]

--#endif

--#if (_WIN32_WINNT >= 0x0601)

ffi.cdef[[
BOOL
__stdcall
QueryIdleProcessorCycleTimeEx(
     USHORT Group,
     PULONG BufferLength,
     PULONG64 ProcessorIdleCycleTime
    );
]]
    
--#endif // (_WIN32_WINNT >= 0x0601)

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
VOID
__stdcall
QueryInterruptTimePrecise(
     PULONGLONG lpInterruptTimePrecise
    );



VOID
__stdcall
QueryUnbiasedInterruptTimePrecise(
     PULONGLONG lpUnbiasedInterruptTimePrecise
    );



VOID
__stdcall
QueryInterruptTime(
     PULONGLONG lpInterruptTime
    );
]]

--#if (_WIN32_WINNT >= 0x0601)

ffi.cdef[[
BOOL
__stdcall
QueryUnbiasedInterruptTime(
     PULONGLONG UnbiasedTime
    );
]]

--#endif // (_WIN32_WINNT >= 0x0601)

ffi.cdef[[
HRESULT
__stdcall
QueryAuxiliaryCounterFrequency(
     PULONGLONG lpAuxiliaryCounterFrequency
    );



HRESULT
__stdcall
ConvertAuxiliaryCounterToPerformanceCounter(
     ULONGLONG ullAuxiliaryCounterValue,
     PULONGLONG lpPerformanceCounterValue,
     PULONGLONG lpConversionError
    );



HRESULT
__stdcall
ConvertPerformanceCounterToAuxiliaryCounter(
     ULONGLONG ullPerformanceCounterValue,
     PULONGLONG lpAuxiliaryCounterValue,
     PULONGLONG lpConversionError
    );
]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */




--#endif // _APISETREALTIME_
