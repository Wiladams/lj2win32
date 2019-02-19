package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

require("win32.winreg")
local strdelim = require("strdelim")


--[[
    Registry Keys
]]
local RegistryKey = {}
setmetatable(RegistryKey, {
    __call = function(self, ...)
        return self:new(...)
    end
})
local RegistryKey_mt = {
    __call = function(self)
        return self:subkeys();
    end;

    __index = function(tbl, key)
        if RegistryKey[key] then return RegistryKey[key] end
    
        -- try to return a subkey
        return RegistryKey.subkey(tbl, key)
    end;
}

function RegistryKey.init(self, key, isOwned)
    local obj = {
        Key = key;
        isOwned = isOwned;
    }
    setmetatable(obj, RegistryKey_mt)

    return obj;
end

function RegistryKey.new(self, parent, subname, options, SAMDesired)
    options = options or 0
    SAMDesired = SAMDesired or C.KEY_READ

    -- Open the key
    phkResult = ffi.new("HKEY[1]")
    local status = C.RegOpenKeyExA(parent, subname, options, SAMDesired, phkResult)

    if status ~= C.ERROR_SUCCESS then
        return nil;
    end

    local hkResult = phkResult[0]

    return self:init(hkResult, true)
end



function RegistryKey.getInfo(self, res)
    res = res or {}

    local lpClass = ffi.new("char[256]")
    local lpcchClass = ffi.new("DWORD[1]", 256)
    local lpReserved = nil;
    local lpcSubKeys = ffi.new("DWORD[1]")
    local lpcbMaxSubKeyLen = ffi.new("DWORD[1]")
    local lpcbMaxClassLen = ffi.new("DWORD[1]")
    local lpcValues = ffi.new("DWORD[1]")
    local lpcbMaxValueNameLen = ffi.new("DWORD[1]")
    local lpcbMaxValueLen = ffi.new("DWORD[1]")
    local lpcbSecurityDescriptor = ffi.new("DWORD[1]")
    local lpftLastWriteTime = ffi.new("FILETIME")

    local status = C.RegQueryInfoKeyA(self.Key,
        lpClass, lpcchClass,
        lpReserved,
        lpcSubKeys,
        lpcbMaxSubKeyLen,
        lpcbMaxClassLen,
        lpcValues,
        lpcbMaxValueNameLen,
        lpcbMaxValueLen,
        lpcbSecurityDescriptor,
        lpftLastWriteTime);

    if lpcchClass[0] > 0 then
    res.Class = ffi.string(lpClass, lpcchClass[0])
    end
    res.NumSubKeys = lpcSubKeys[0];
    res.MaxSubKeyLength = lpcbMaxSubKeyLen[0];
    res.MaxClassLength = lpcbMaxClassLen[0];
    res.NumValues = lpcValues[0];
    res.MaxValueNameLength = lpcbMaxValueNameLen[0];
    res.MaxValueLength = lpcbMaxValueLen[0];
    res.SecurityDescriptor = lpcbSecurityDescriptor[0];
    res.LastWriteTime = lpftLastWriteTime;


    return res;
end

function RegistryKey.subkey(self, subkeyname, options, SAMDesired)
    return RegistryKey(self.Key, subkeyname, options, SAMDesired)
end

function RegistryKey.subkeys(self)
    local dwIndex = 0;
    local function closure()
        local lpcchName = ffi.new("DWORD[1]");
        lpcchName[0] = 255;
        local lpName = ffi.new("char[?]", 256)
        local lpReserved = nil;
        local lpClass = nil;
        local lpcchClass = nil;
        local lpftLastWriteTime = nil;

        local status = C.RegEnumKeyExA(self.Key, dwIndex, 
            lpName, lpcchName, 
            lpReserved,
            lpClass, lpcchClass, 
            lpftLastWriteTime)
        
        dwIndex = dwIndex + 1;

        if status == C.ERROR_NO_MORE_ITEMS then
            return nil;
        end

        if status ~= C.ERROR_SUCCESS then
            return nil;
        end

        return ffi.string(lpName, lpcchName[0])
    end

    return closure
end

local function tblfrommultinull(multinull, res)
    res = res or {}
    for i, str in strdelim.multinullstrings(multinull) do
        table.insert(res, str)
    end

    return res;
end

--[[
    return an iterator over all the value fields

    Reading this type: REG_FULL_RESOURCE_DESCRIPTOR
    https://stackoverflow.com/questions/50418343/which-struct-is-used-to-extract-information-from-a-registry-value-data-of-type-r

    https://docs.microsoft.com/en-us/windows-hardware/drivers/ddi/content/wdm/ns-wdm-_cm_full_resource_descriptor


    In general, we need specific code to read each of the value types and turn them into something
    that is easily consumed.
]]
local function read_FULL_RESOURCE_DESCRIPTION(data, len, res)
    res = res or {}
end

--[[
Values for the lpType field
REG_NONE                    = 0; // No value type
--REG_SZ                      = 1; // Unicode nul terminated string
REG_EXPAND_SZ               = 2; // Unicode nul terminated string
                                            // (with environment variable references)
REG_BINARY                  = 3; // Free form binary
--REG_DWORD                   = 4; // 32-bit number
REG_DWORD_LITTLE_ENDIAN     = 4; // 32-bit number (same as REG_DWORD)
REG_DWORD_BIG_ENDIAN        = 5; // 32-bit number
REG_LINK                    = 6; // Symbolic Link (unicode)
--REG_MULTI_SZ                = 7; // Multiple Unicode strings
REG_RESOURCE_LIST           = 8; // Resource list in the resource map
REG_FULL_RESOURCE_DESCRIPTOR = 9; // Resource list in the hardware description
REG_RESOURCE_REQUIREMENTS_LIST = 10;
REG_QWORD                   = 11; // 64-bit number
REG_QWORD_LITTLE_ENDIAN     = 11; // 64-bit number (same as REG_QWORD)
]]
function RegistryKey.values(self)
    local dwIndex = 0;

    local function closure()
        local lpValueName = ffi.new("char[256]")
        local lpcchValueName = ffi.new("DWORD[1]", 256)
        local lpReserved = nil;
        local lpType = ffi.new("DWORD[1]")
        local lpData = ffi.new("BYTE[?]", 256)
        local lpcbData = ffi.new("DWORD[1]", 256)

        local status = C.RegEnumValueA(
            self.Key,
            dwIndex,
            lpValueName,
            lpcchValueName,
            lpReserved,
            lpType,
            lpData,
            lpcbData);

        dwIndex = dwIndex + 1;

        if status == C.ERROR_NO_MORE_ITEMS then
            return nil;
        end

        if status ~= C.ERROR_SUCCESS then
            return nil;
        end


        local res = {
            name = ffi.string(lpValueName, lpcchValueName[0]);
            kind = lpType[0];
            data = lpData;
            datalen = lpcbData[0];
        }

        local len = lpcbData[0]
        if lpType[0] == C.REG_SZ then
            if len > 0 then len = len - 1 end
            res.value = ffi.string(lpData, len)
        elseif lpType[0] == C.REG_MULTI_SZ then
            res.value = tblfrommultinull(lpData) 
        elseif lpType[0] == C.REG_DWORD then
            res.value = ffi.cast("DWORD *",lpData)[0]
        elseif lpType[0] == C.REG_FULL_RESOURCE_DESCRIPTOR then
            res.value = read_FULL_RESOURCE_DESCRIPTION(lpData, len)
        end

        return res
    end

    return closure
end




--[[
    The Registry itself
]]
local Registry = {

}
setmetatable(Registry, {
    __call = function(self, ...)
        return self:new(...)
    end
})
local Registry_mt = {
    __index = Registry
}

function Registry.init(self, key)
    local obj = {
        Key = key;
    }
    setmetatable(obj, Registry_mt)

    return obj;
end

function Registry.new(self, ...)
    return self:init(...)
end

-- Top Level Registry Keys
-- Since they are already open, we don't need to 'new' then
-- don't have to worry about closing them either, as they are always open
Registry.HKEY_CLASSES_ROOT = RegistryKey:init(HKEY_CLASSES_ROOT)
Registry.HKEY_CURRENT_USER = RegistryKey:init(HKEY_CURRENT_USER)
Registry.HKEY_LOCAL_MACHINE = RegistryKey:init(HKEY_LOCAL_MACHINE)
Registry.HKEY_USERS = RegistryKey:init(HKEY_USERS)
Registry.HKEY_PERFORMANCE_DATA = RegistryKey:init(HKEY_PERFORMANCE_DATA)
Registry.HKEY_PERFORMANCE_TEXT = RegistryKey:init(HKEY_PERFORMANCE_TEXT)
Registry.HKEY_PERFORMANCE_NLSTEXT = RegistryKey:init(HKEY_PERFORMANCE_NLSTEXT)



return Registry
