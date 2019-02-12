local ffi = require("ffi")
local C = ffi.C 

require("win32.fileapi")
local unicode = require("unicode_util")
local strdelim = require("strdelim")

local Volume = {}
setmetatable(Volume, {
    __call = function(self, ...)
        return self:new(...)
    end,
})
local Volume_mt = {
    __index = Volume;

    __tostring = function(self)
        return self.Name
    end;
}

function Volume.init(self, name)
    local obj = {
        Name = name
    }
    setmetatable(obj, Volume_mt)

    return obj
end

function Volume.new(self, name)
    return self:init(name)
end

--[[
function Volume.getInfo(self)
    local lpRootPathName = nil
    local lpVolumeNameBuffer = ffi.new("char [?]", C.MAX_PATH+1)
    local nVolumeNameSize = C.MAX_PATH+1
    local lpVolumeSerialNumber = ffi.new("DWORD[1]")
    local lpMaximumComponentLength = ffi.new("DWORD[1]")
    local lpFileSystemFlags = ffi.new("DWORD[1]")
    local lpFileSystemNameBuffer = ffi.new("char [?]", C.MAX_PATH+1)
    local nFileSystemNameSize = C.MAX_PATH+1

    local success =  GetVolumeInformationA(
        LPCSTR  lpRootPathName,
        LPSTR   lpVolumeNameBuffer,
        DWORD   nVolumeNameSize,
        LPDWORD lpVolumeSerialNumber,
        LPDWORD lpMaximumComponentLength,
        LPDWORD lpFileSystemFlags,
        LPSTR   lpFileSystemNameBuffer,
        DWORD   nFileSystemNameSize) ~= 0

    if not success then 
        return false, C.GetLastError()
    end


end
--]]

function Volume.paths(self)
    local lpszVolumeName = unicode.toUnicode(self.Name)
    local cchBufferLength = 0
    local lpszVolumePathNames = nil
    local lpcchReturnLength = ffi.new("DWORD[1]")

    local success = C.GetVolumePathNamesForVolumeNameW(lpszVolumeName,
        lpszVolumePathNames, cchBufferLength,lpcchReturnLength) ~= 0;

    local err = C.GetLastError()
--print(".paths, success: ", success, lpcchReturnLength[0], err)
    
    if not success and err ~= C.ERROR_MORE_DATA then
        return false, err
    end

    cchBufferLength = lpcchReturnLength[0]
    lpszVolumePathNames = ffi.new("wchar_t[?]", cchBufferLength)
    local success = C.GetVolumePathNamesForVolumeNameW(lpszVolumeName,
        lpszVolumePathNames, cchBufferLength,lpcchReturnLength) ~= 0;
--print(".paths, success(2): ", success, lpcchReturnLength[0], err)

print(unicode.toAnsi(lpszVolumePathNames))
--[[
    for _, str in  strdelim.mstriter({
        data = lpszVolumePathNames, 
        datalength = lpcchReturnLength[0],
        basetype = ffi.typeof("wchar_t")
    }) do 
        print(str)
    end
--]]
end


return Volume