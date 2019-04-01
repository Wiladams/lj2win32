package.path = "../?.lua;"..package.path;

--require("win32.minwindef")
--require("win32.minwinbase")
require("win32.windef")

local mmsystem = require("win32.mmsystem")

local numIns = mmsystem.waveInGetNumDevs()
print("waveInGetNumDevs(): ", numIns)

local numOuts = mmsystem.waveOutGetNumDevs()
print("waveOutGetNumDevs: ", numOuts)