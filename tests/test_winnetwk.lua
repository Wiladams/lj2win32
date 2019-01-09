package.path = "../?.lua;"..package.path;

--[[
     Reference

     https://docs.microsoft.com/en-us/windows/desktop/WNet/enumerating-network-resources
]]
local ffi = require("ffi")
local bit = require("bit")
local band, bor = bit.band, bit.bor

require("win32.sdkddkver")
require("win32.wingdi")
require("win32.winuser")
require("win32.winerror")

local winnet = require ("win32.winnetwk")

print(winnet)

local function printf(fmt, ...)
     io.write(string.format(fmt,...))
end

local function cstring(str)
     if str ~= nil then
          return ffi.string(str)
     end
     return ""
end

local scopes = {
     [ffi.C.RESOURCE_CONNECTED] = "connected";
     [ffi.C.RESOURCE_GLOBALNET] = "all resources";
     [ffi.C.RESOURCE_REMEMBERED] = "remembered";
}

local types = {
[ffi.C.RESOURCETYPE_ANY] = "any";
[ffi.C.RESOURCETYPE_DISK] = "disk";
[ffi.C.RESOURCETYPE_PRINT] = "print";
}

local displayTypes = {
     [ffi.C.RESOURCEDISPLAYTYPE_GENERIC] = "generic";
     [ffi.C.RESOURCEDISPLAYTYPE_DOMAIN] = "domain";
     [ffi.C.RESOURCEDISPLAYTYPE_SERVER] = "server";
     [ffi.C.RESOURCEDISPLAYTYPE_SHARE] = "share";
     [ffi.C.RESOURCEDISPLAYTYPE_FILE] = "file";
     [ffi.C.RESOURCEDISPLAYTYPE_GROUP] = "group";
     [ffi.C.RESOURCEDISPLAYTYPE_NETWORK] = "network";
}

local function DisplayStruct(i, lpnrLocal)

    printf("NETRESOURCE[%d] Scope: ", i);
    print(scopes[lpnrLocal.dwScope] or "unknown scope")

    printf("NETRESOURCE[%d] Type (%d): ", i, lpnrLocal.dwType);
    print(types[lpnrLocal.dwType] or "unknown type")

    printf("NETRESOURCE[%d] DisplayType (%d): ", i, lpnrLocal.dwDisplayType);
    print(displayTypes[lpnrLocal.dwDisplayType] or "unknown display type")



    printf("NETRESOURCE[%d] Usage: 0x%x = ", i, lpnrLocal.dwUsage);
    if band(lpnrLocal.dwUsage, ffi.C.RESOURCEUSAGE_CONNECTABLE) ~= 0 then
        io.write("connectable ");
     end
    if band(lpnrLocal.dwUsage, ffi.C.RESOURCEUSAGE_CONTAINER) ~= 0 then
        io.write("container ");
     end
    print();

    printf("NETRESOURCE[%d] Localname: %s\n", i, cstring(lpnrLocal.lpLocalName))
    printf("NETRESOURCE[%d] Remotename: %s\n", i, cstring(lpnrLocal.lpRemoteName))
    printf("NETRESOURCE[%d] Comment: %s\n", i, cstring(lpnrLocal.lpComment))
    printf("NETRESOURCE[%d] Provider: %s\n", i, cstring(lpnrLocal.lpProvider))


    print("_______________________________________")
    
end

local function EnumerateContainer(lpNetResource)
     local dwScope = ffi.C.RESOURCE_GLOBALNET;
     local dwType = ffi.C.RESOURCETYPE_ANY;
     local dwUsage = 0;
     local lphEnum = ffi.new("HANDLE [1]");
     local numEntries = math.floor(16 * 1024/ffi.sizeof("NETRESOURCEA"))
     local bufferSize = numEntries * ffi.sizeof("NETRESOURCEA")
     local cbBuffer =  ffi.new("DWORD[1]", bufferSize);   -- roughly 16K buffer
--print("EnumerateContainer 1.0 ", lpNetResource)
     local success = winnet.WNetOpenEnumA(dwScope, dwType, dwUsage, lpNetResource, lphEnum) == 0;
--print("EnumerateContainer 1.0.1, WNetOpenEnumA: ", success)
     if not success then
          return false;
     end

     local lpnrLocal = ffi.new("NETRESOURCEA[?]", numEntries) 
     local dwResultEnum = 0;
     local cEntries = ffi.new("DWORD[1]",-1)

     repeat
          ffi.fill(lpnrLocal, bufferSize)

          dwResultEnum = winnet.WNetEnumResourceA(lphEnum[0], cEntries, lpnrLocal, cbBuffer);
--print("dwResultEnum: ", dwResultEnum)

          if (dwResultEnum == 0) then   -- no error
--print("EnumerateContainer: 1.1 ", cEntries[0])
               for i = 0, cEntries[0]-1 do

                   DisplayStruct(i, lpnrLocal[i]);
   
                   -- If the NETRESOURCE structure represents a container resource, 
                   --  call the EnumerateFunc function recursively.
--print(string.format("EnumerateContainer 1.2, dwUsage: 0x%x", lpnrLocal[i].dwUsage))   
                   if ffi.C.RESOURCEUSAGE_CONTAINER == band(lpnrLocal[i].dwUsage, ffi.C.RESOURCEUSAGE_CONTAINER) then
--print("EnumerateContainer 1.3")
                       if (not EnumerateContainer(lpnrLocal[i])) then
                           print("EnumerateFunc returned FALSE");
                       end
                    end
               end

          elseif (dwResultEnum ~= ffi.C.ERROR_NO_MORE_ITEMS) then
               print(string.format("WNetEnumResource failed with error %d", dwResultEnum));
               break;
          end
--          print("repeat")
     until dwResultEnum == ffi.C.ERROR_NO_MORE_ITEMS
     
     dwResult = winnet.WNetCloseEnum(lphEnum[0]);

     return true;
end


local function main()
     print("main: ", EnumerateContainer(nil));
end

main()
