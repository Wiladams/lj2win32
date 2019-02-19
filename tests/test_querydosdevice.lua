package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

require("win32.fileapi")
local core_string = require("unicode_util");

local L = core_string.toUnicode;

-- given a unicode string which contains
-- null terminated strings
-- return individual ansi strings
local function wmstrziter(data, datalength)

	local maxLen = 255;
	local idx = -1;

	local nameBuff = ffi.new("char[?]", maxLen+1)

	local function closure()
		idx = idx + 1;
        local len = 0;
        
--print("closure: ", idx, datalength)
		while len < maxLen do 
			--print("char: ", string.char(lpBuffer[idx]))
			if data[idx] == 0 then
				break
			end
--print("LEN, IDX: ", len, idx, data[idx])
			nameBuff[len] = data[idx];
			len = len + 1;
			idx = idx + 1;
		end

		if len == 0 then
			return nil;
		end

		return ffi.string(nameBuff, len);
	end

	return closure;
end

local function getDevicePath(deviceName)
    if deviceName then
        deviceName = core_string.toUnicode(deviceName)
    end

    local ucchMax = 1024*64;
    local lpTargetPath = ffi.new("wchar_t[?]", ucchMax);

    local res = C.QueryDosDeviceW(deviceName, lpTargetPath,ucchMax);

    if res == 0 then
        return false, ffi.errno();
    end

    return lpTargetPath, res
    --return core_string.toAnsi(lpTargetPath, res), res
end


local function printAll(alldevs, size)
    for name in wmstrziter(alldevs, size) do
        path, err = getDevicePath(name)
        if not path then
            print("NO PATH FOR Name: ", name)
        else
            path = core_string.toAnsi(path, err)
            print(string.format("{NT = [[%s]], DOS = [[%s]]};", path, name))
            --print("NAME, PATH: ", name, path)
        end
    end
end



local function test_enumerate()
    --print("==== test_enumerate ====")

    -- first get all devices
    local targetPath, err = getDevicePath(nil);

    --print("targetPath: ",targetPath)

    if not targetPath then
        print("Error: ", err)
        return false, err;
    end

    -- print(lpTargetPath)
    printAll(targetPath, err)
end

test_enumerate();