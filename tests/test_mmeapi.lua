package.path = "../?.lua;"..package.path;

--require("win32.minwindef")
--require("win32.minwinbase")
require("win32.windef")

local mmeapi = require("win32.mmeapi")

local result = mmeapi.waveInGetNumDevs()

print("waveInGetNumDevs(): ", result)

local numOuts = mmeapi.waveOutGetNumDevs()
print("waveOutGetNumDevs: ", numOuts)