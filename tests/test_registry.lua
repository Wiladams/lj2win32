package.path = "../?.lua;"..package.path;

require("win32.sdkddkver")

require("win32.winerror")
local Registry = require("registry")

--print ("HKEY_LOCAL_MACHINE: ", Registry.HKEY_LOCAL_MACHINE)

local indention = '    '

local function printTab(level, ...)
    --print("LEVEL: ", level)
    io.write(string.rep("    ", level))
    print(...)
end

local printKey = nil
printKey = function (akey, name, level)
    level = level or 0
    printTab(level, string.format("%s = {", name))

    -- print attributes of the key
    local info = akey:getInfo()

    if info.Class then
    printTab(level, "  Class = ", string.format("'%s';", info.Class))
    end
    printTab(level, "  Subkeys = ", string.format("%d;",info.NumSubKeys))
    printTab(level, "  MaxSubKeyLength = ", string.format("%d;",info.MaxSubKeyLength))
    printTab(level, "  Values = ", string.format("%d;", info.NumValues))
    printTab(level, "  MaxValueNameLength = ", string.format("%d;", info.MaxValueNameLength))
    printTab(level, "  MaxValueLength = ", string.format("%d;", info.MaxValueLength))
    printTab(level, "  SecurityDescriptor = ", string.format("0x%08x;", info.SecurityDescriptor))

    --print values of the key

    -- print subkeys
    for subkeyname in akey:subkeys() do
        --printTab(level+1, subkeyname)
        local subkey = akey:subkey(subkeyname)
        if subkey then
            printKey(subkey, subkeyname, level+1)
        end
    end
    
    printTab(level, "};")
end

--printKey(Registry.HKEY_CLASSES_ROOT, "HKEY_CLASSES_ROOT")
--printKey(Registry.HKEY_CURRENT_USER, "HKEY_CURRENT_USER")
--printKey(Registry.HKEY_LOCAL_MACHINE, "HKEY_LOCAL_MACHINE")
printKey(Registry.HKEY_USERS, "HKEY_USERS")
--printKey(Registry.HKEY_PERFORMANCE_DATA, "HKEY_PERFORMANCE_DATA")
--printKey(Registry.HKEY_PERFORMANCE_TEXT, "HKEY_PERFORMANCE_TEXT")
--printKey(Registry.HKEY_PERFORMANCE_NLSTEXT, "HKEY_PERFORMANCE_NLSTEXT")
