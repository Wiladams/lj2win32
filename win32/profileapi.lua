--[[
/********************************************************************************
*                                                                               *
* profileapi.h -- ApiSet Contract for api-ms-win-core-profile-l1                *  
*                                                                               *
* Copyright (c) Microsoft Corporation. All rights reserved.                     *
*                                                                               *
********************************************************************************/
--]]

local ffi = require("ffi")
require ("win32.minwindef")

ffi.cdef[[
BOOL __stdcall QueryPerformanceCounter(int64_t * lpPerformanceCount);
BOOL __stdcall QueryPerformanceFrequency(int64_t * lpFrequency);
]]


