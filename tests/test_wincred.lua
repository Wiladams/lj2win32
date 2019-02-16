package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 


require("win32.sdkddkver")

local wincred = require("win32.wincred")
require("win32.errhandlingapi")


local Filter = nil;
local Flags = C.CRED_ENUMERATE_ALL_CREDENTIALS
local Count = ffi.new("DWORD[1]")
local Credential = ffi.new("PCREDENTIALA *[1]") -- PCREDENTIALA **Credential
local success = wincred.CredEnumerateA (Filter, Flags, Count, Credential) ~= 0;

if not success then
    print("FAILED: ", C.GetLastError())
    return false
end 

print("Count: ", Count[0])

--[[
    typedef struct _CREDENTIALA {
    DWORD Flags;
    DWORD Type;
    LPSTR TargetName;
    LPSTR Comment;
    FILETIME LastWritten;
    DWORD CredentialBlobSize;
     LPBYTE CredentialBlob;
    DWORD Persist;
    DWORD AttributeCount;
    PCREDENTIAL_ATTRIBUTEA Attributes;
    LPSTR TargetAlias;
    LPSTR UserName;
} CREDENTIALA, *PCREDENTIALA;
]]

local function safestr(str)
    if str == nil then
        return ""
    end
    return ffi.string(str)
end

local function printCredential(cred)
    print("== Credential ==")
    print("TargetName: ", safestr(cred[0].TargetName))
    print("Comment: ", safestr(cred.Comment))
    print("TargetAlias: ", safestr(cred.TargetAlias))
    print("UserName: ", safestr(cred.UserName))
end

local credArray = Credential[0]
for i=0, Count[0]-1 do 
    printCredential(credArray[i])
end
