--[[
    Representation of a single HID device
]]

local ffi = require("ffi")
local C = ffi.C 
local bit = require("bit")
local band, bor = bit.band, bit.bor
local lshift, rshift = bit.lshift, bit.rshift

require("win32.winbase")
require("win32.fileapi")
require("win32.winreg")
require("win32.wingdi")
require("win32.winuser")
require("win32.errhandlingapi")
require("win32.winerror")

local setupapi = require("win32.setupapi")
local hidsdi = require("win32.hidsdi")
local hidclass = require("win32.hidclass")

local HID_OUT_CTL_CODE = hidclass.HID_OUT_CTL_CODE
local IOCTL_HID_GET_FEATURE = C.IOCTL_HID_GET_FEATURE

local function openDevice(path, enumerate)
    local desiredAccess = 0    
    if not enumerate then
    desiredAccess = bor(C.GENERIC_WRITE , C.GENERIC_READ)
    end
    local shareMode = bor(C.FILE_SHARE_READ, C.FILE_SHARE_WRITE)

    local handle = C.CreateFileA(path, desiredAccess, shareMode,
        nil, C.OPEN_EXISTING, C.FILE_FLAG_OVERLAPPED, nil)

    if handle == INVALID_HANDLE_VALUE then
        return false, "failed to open file"
    end

    return handle
end

local HIDDevice = {}
setmetatable(HIDDevice, {
    __call = function(self, path)
        return self:new(path)
    end,
})
local HIDDevice_mt = {
    __index = HIDDevice;
}


function HIDDevice.init(self, path)
    local obj = {
        path = path
    }
    setmetatable(obj, HIDDevice_mt)

    -- get all the particulars
    -- vendor and product ID
    local success, err = obj:initAttributes()

    if not success then
        print("FAILED initAttributes: ", err)
        return nil, err;
    end

    -- usage
    -- serial number
    -- manufacturer
    -- product string
    -- interface number
    
    return obj;
end


function HIDDevice.new(self, path)
    -- hand the raw handle to init
    return self:init(path)
end

function HIDDevice.initAttributes(self)
    print("== initAttributes ==")

    local rawhandle = openDevice(self.path, true)
    
    local attrib = ffi.new("HIDD_ATTRIBUTES")
    attrib.Size = ffi.sizeof("HIDD_ATTRIBUTES")
    local status = hidsdi.HidD_GetAttributes(rawhandle, attrib)

    -- close the file handle
    C.CloseHandle(rawhandle)

    if status == 0 then
        local err = C.GetLastError()
        return false, err
    end


    self.VendorID = tonumber(attrib.VendorID);
    self.ProductID = tonumber(attrib.ProductID);
    self.VersionNumber = tonumber(attrib.VersionNumber);

    return self
end


return HIDDevice

