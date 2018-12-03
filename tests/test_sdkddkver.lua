package.path = "../?.lua;"..package.path;

_WIN32_WINNT = 0x0400;

require("win32.sdkddkver")

local winvers = {
[_WIN32_WINNT_NT4]                    = "_WIN32_WINNT_NT4";
[_WIN32_WINNT_WIN2K]                  = "_WIN32_WINNT_WIN2K";
[_WIN32_WINNT_WINXP]                  = "_WIN32_WINNT_WINXP";
[_WIN32_WINNT_WS03]                   = "_WIN32_WINNT_WS03";
[_WIN32_WINNT_WIN6]                   = "_WIN32_WINNT_WIN6";
[_WIN32_WINNT_VISTA]                  = "_WIN32_WINNT_VISTA";
[_WIN32_WINNT_WS08]                   = "_WIN32_WINNT_WS08";
[_WIN32_WINNT_LONGHORN]               = "_WIN32_WINNT_LONGHORN";
[_WIN32_WINNT_WIN7]                   = "_WIN32_WINNT_WIN7";
[_WIN32_WINNT_WIN8]                   = "_WIN32_WINNT_WIN8";
[_WIN32_WINNT_WINBLUE]                = "_WIN32_WINNT_WINBLUE";

[_WIN32_WINNT_WIN10]                  = "_WIN32_WINNT_WIN10"; 
}



print(" _WIN32_WINNT: ", string.format("0x%x", _WIN32_WINNT), winvers[_WIN32_WINNT])
print("       WINVER: ", string.format("0x%x",WINVER))
print("NTDDI_VERSION: ", string.format("0x%x",NTDDI_VERSION))
print("    _WIN32_IE: ", string.format("0x%x", _WIN32_IE))