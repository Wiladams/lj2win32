package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

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

local dataKind = {
[C.REG_NONE]                    = "REG_NONE"; 
[C.REG_SZ]                      = "REG_SZ"; 
[C.REG_EXPAND_SZ]               = "REG_EXPAND_SZ"; 
[C.REG_BINARY]                  = "REG_BINARY";
[C.REG_DWORD]                   = "REG_DWORD"; 
--[C.REG_DWORD_LITTLE_ENDIAN     = 4; 
[C.REG_DWORD_BIG_ENDIAN]        = "REG_DWORD_BIG_ENDIAN"; 
[C.REG_LINK]                    = "REG_LINK"; 
[C.REG_MULTI_SZ]                = "REG_MULTI_SZ"; 
[C.REG_RESOURCE_LIST]           = "REG_RESOURCE_LIST"; 
[C.REG_FULL_RESOURCE_DESCRIPTOR] = "REG_FULL_RESOURCE_DESCRIPTOR"; 
[C.REG_RESOURCE_REQUIREMENTS_LIST] = "REG_RESOURCE_REQUIREMENTS_LIST";
[C.REG_QWORD]                   = "REG_QWORD"; 
--[C.REG_QWORD_LITTLE_ENDIAN     = 11; 
}


local printKey = nil
printKey = function (akey, name, level)
    level = level or 0
    printTab(level, string.format("%s = {", name))

    -- print attributes of the key
    local info = akey:getInfo()

    if info.Class then
    printTab(level, "  Class = ", string.format("'%s';", info.Class))
    end
    --printTab(level, "  Subkeys = ", string.format("%d;",info.NumSubKeys))
    --printTab(level, "  MaxSubKeyLength = ", string.format("%d;",info.MaxSubKeyLength))
    --printTab(level, "  Values = ", string.format("%d;", info.NumValues))
    --printTab(level, "  MaxValueNameLength = ", string.format("%d;", info.MaxValueNameLength))
    --printTab(level, "  MaxValueLength = ", string.format("%d;", info.MaxValueLength))
    --printTab(level, "  SecurityDescriptor = ", string.format("0x%08x;", info.SecurityDescriptor))

    --print values of the key
    for value in akey:values() do
        local valuestr = nil
        if value.kind == C.REG_SZ then
            valuestr = string.format("'%s'", value.value);
        elseif value.kind == C.REG_MULTI_SZ then
            valuestr = string.format("'%s'", table.concat(value.value,', '))
        elseif value.kind == C.REG_DWORD then
            valuestr = string.format("%d", value.value);
        else 
            valuestr = string.format("%s", dataKind[value.kind])
        end

        printTab(level+1, string.format("['%s'] = %s;",value.name, valuestr))
    end

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
--printKey(Registry.HKEY_CURRENT_USER.AppEvents, "HKEY_CURRENT_USER/AppEvents")

--printKey(Registry.HKEY_LOCAL_MACHINE, "HKEY_LOCAL_MACHINE")
--printKey(Registry.HKEY_LOCAL_MACHINE.SYSTEM, "HKEY_LOCAL_MACHINE/SYSTEM")
printKey(Registry.HKEY_LOCAL_MACHINE.HARDWARE.DESCRIPTION, "HKEY_LOCAL_MACHINE.HARDWARE.DESCRIPTION")
--printKey(Registry.HKEY_LOCAL_MACHINE.HARDWARE.DEVICEMAP, "HKEY_LOCAL_MACHINE.HARDWARE.DEVICEMAP")

--printKey(Registry.HKEY_USERS, "HKEY_USERS")
--printKey(Registry.HKEY_PERFORMANCE_DATA, "HKEY_PERFORMANCE_DATA")
--printKey(Registry.HKEY_PERFORMANCE_TEXT, "HKEY_PERFORMANCE_TEXT")
--printKey(Registry.HKEY_PERFORMANCE_NLSTEXT, "HKEY_PERFORMANCE_NLSTEXT")
