package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 


require("win32.sdkddkver")

local wincred = require("win32.wincred")
local credui = ffi.load("credui")
require("win32.errhandlingapi")

-- turn null terminated char * into lua string
-- return blank string if nil
local function safestr(str)
    if str == nil then
        return ""
    end
    return ffi.string(str)
end


local function test_credenum()
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
wincred.CredFree(credArray)
end

local function test_credpromtcli()
    local blankStr = ffi.new("char[1]",0)
    local pszTargetName = "localhost"
    local pContext = nil
    local dwAuthError = 0
    local UserName = blankStr
    local ulUserBufferSize = 0
    local pszPassword = blankStr
    local ulPasswordBufferSize = 0
    local pfSave = nil
    local dwFlags = 0


    local result = credui.CredUICmdLinePromptForCredentialsA(pszTargetName,
        pContext,
        dwAuthError,
        UserName,
        ulUserBufferSize,
        pszPassword,
        ulPasswordBufferSize,
        pfSave,
        dwFlags);

    print("RESULT: ", result)
end

test_credpromtcli()

--test_credenum()