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
require("win32.ioapiset")
require("win32.errhandlingapi")
require("win32.winerror")

local setupapi = require("win32.setupapi")
local hidsdi = require("win32.hidsdi")
local hidclass = require("win32.hidclass")
local unicode = require("unicode_util")
local FileHandle = require("filehandle")

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

    return obj;
end


function HIDDevice.new(self, path)
    -- hand the raw handle to init
    return self:init(path)
end

function HIDDevice.initAttributes(self)
    --print("== initAttributes ==")

    local iohandle = FileHandle({RawFileHandle = openDevice(self.path, true)})
    
    local attrib = ffi.new("HIDD_ATTRIBUTES")
    attrib.Size = ffi.sizeof("HIDD_ATTRIBUTES")
    local status = hidsdi.HidD_GetAttributes(iohandle.Handle, attrib)


    if status == 0 then
        local err = C.GetLastError()
        return false, err
    end


    self.VendorID = tonumber(attrib.VendorID);
    self.ProductID = tonumber(attrib.ProductID);
    self.VersionNumber = tonumber(attrib.VersionNumber);


    -- usage
    local ppdata = ffi.new("PHIDP_PREPARSED_DATA[1]")
    local status = hidsdi.HidD_GetPreparsedData(iohandle.Handle, ppdata)
    if status == 0 then
        return nil, C.GetLastError();
    end

    local caps = ffi.new("HIDP_CAPS")
    status = hidsdi.HidP_GetCaps(ppdata[0], caps)
    self.UsagePage = caps.UsagePage;
    self.Usage = caps.Usage;
    self.InputReportByteLength = caps.InputReportByteLength
    self.OutputReportByteLength = caps.OutputReportByteLength
    self.FeatureReportByteLength = caps.FeatureReportByteLength
    self.NumberLinkCollectionNodes = caps.NumberLinkCollectionNodes     -- HidP_GetLinkCollectionNodes
    self.NumberInputButtonCaps = caps.NumberInputButtonCaps             -- HidP_GetButtonCaps
    self.NumberInputValueCaps = caps.NumberInputValueCaps               -- HidP_GetValueCaps
    self.NumberInputDataIndices = caps.NumberInputDataIndices
    self.NumberOutputButtonCaps = caps.NumberOutputButtonCaps           -- HidP_GetButtonCaps 
    self.NumberOutputValueCaps = caps.NumberOutputValueCaps             -- HidP_GetValueCaps 
    self.NumberOutputDataIndices = caps.NumberOutputDataIndices
    self.NumberFeatureButtonCaps = caps.NumberFeatureButtonCaps         -- HidP_GetButtonCaps
    self.NumberFeatureValueCaps = caps.NumberFeatureValueCaps           -- HidP_GetValueCaps 
    self.NumberFeatureDataIndices = caps.NumberFeatureDataIndices

    hidsdi.HidD_FreePreparsedData(ppdata[0])

    -- serial number
    local wstr = ffi.new("wchar_t[?]", 128)
    local wstrLen = ffi.sizeof(wstr)

    status = hidsdi.HidD_GetSerialNumberString(iohandle.Handle, wstr, wstrLen)
    self.SerialNumber = unicode.toAnsi(wstr)

    -- manufacturer
    status = hidsdi.HidD_GetManufacturerString(iohandle.Handle, wstr, wstrLen)
    self.Manufacturer = unicode.toAnsi(wstr)

    -- product string
    status = hidsdi.HidD_GetProductString(iohandle.Handle, wstr, wstrLen)
    self.Product = unicode.toAnsi(wstr)

    -- interface number

    -- close the file handle
    iohandle:close()
    -- let file handle go out of scope
    --C.CloseHandle(iohandle)

    return self
end

function HIDDevice.open(self)
    -- get a handle we can use for reading and writing
    self.Handle = FileHandle(openDevice(self.path, false))

    -- Set the Input Report buffer size to 64 reports.
    local res = hidsdi.HidD_SetNumInputBuffers(self.Handle.Handle, 64);
    --if (!res) {
    --register_error(dev, "HidD_SetNumInputBuffers");
    --goto err;
    --}
    
    -- Create a buffer we can read/write
    self.InputReportBuffer = ffi.new("uint8_t[?]", self.InputReportByteLength)
end

function HIDDevice.write(self, data, len)
    local ol = ffi.new("OVERLAPPED")
    local buf = data

    res = C.WriteFile(self.Handle.Handle, buf, len, nil, ol)

    -- wait for the write to be finished
    local bytesWritten = ffi.new("DWORD[1]")
    res = C.GetOverlappedResult(self.Handle.Handle, ol, bytesWritten, 1)

    if res == 0 then
        return false, "WriteFile"
    end

    return bytesWritten
end

function HIDDevice.read(self, data, len )
    return self:readTimeout(data, len)
end

-- Send a feature report to the device
function HIDDevice.sendFeatureReport(self, data, len)
    local res = hidsdi.HidD_SetFeature(self.Handle.Handle, data, len)
    if res == 0 then
        return false, "HidD_SetFeature"
    end

    return len
end

return HIDDevice

