package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C
local bit = require("bit")
local bor, band = bit.bor, bit.band

require("win32.sdkddkver")


require("win32.minwindef")
require("win32.minwinbase")

local playsoundapi = require("win32.playsoundapi")

local hmod = nil
local fdwSound = bor(C.SND_FILENAME, C.SND_SYNC)

--local result = playsoundapi.PlaySoundA("media\\riff\\Chimes.wav",hmod, fdwSound);
--local result = playsoundapi.PlaySoundA("media\\riff\\6_Channel_ID.wav",hmod, fdwSound);
local result = playsoundapi.PlaySoundA("media\\riff\\8_Channel_ID.wav",hmod, fdwSound);

--local result = playsoundapi.PlaySoundA("media\\riff\\GLASS.wav",hmod, fdwSound);

print("PlaySound: ", result)