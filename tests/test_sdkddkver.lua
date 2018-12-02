package.path = "../?.lua;"..package.path;

_WIN32_WINNT = 

require("win32.sdkddkver")

local winvers = {
[_WIN32_WINNT_NT4]                    = 0x0400;
[_WIN32_WINNT_WIN2K]                  = 0x0500;
[_WIN32_WINNT_WINXP]                  = 0x0501;
[_WIN32_WINNT_WS03]                   = 0x0502;
[_WIN32_WINNT_WIN6]                   = 0x0600;
[_WIN32_WINNT_VISTA]                  = 0x0600;
[_WIN32_WINNT_WS08]                   = 0x0600;
[_WIN32_WINNT_LONGHORN]               = 0x0600;
[_WIN32_WINNT_WIN7]                   = 0x0601;
[_WIN32_WINNT_WIN8]                   = 0x0602;
[_WIN32_WINNT_WINBLUE]                = "_WIN32_WINNT_WINBLUE";

[_WIN32_WINNT_WIN10]                  = "_WIN32_WINNT_WIN10"; 
}

print(" _WIN32_WINNT: ", string.format("0x%x", _WIN32_WINNT), winvers[_WIN32_WINNT])
print("       WINVER: ", string.format("0x%x",WINVER))
print("NTDDI_VERSION: ", string.format("0x%x",NTDDI_VERSION))