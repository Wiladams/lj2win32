package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 


require("win32.winnls")
require("win32.errhandlingapi")
local unicode = require("unicode_util")
local locale = require("locale")

print("NTDDI_VERSION: ", string.format("0x%8x", NTDDI_VERSION));


print("SystemLocaleName: ", locale.SystemLocaleName)
print("UserLocaleName: ", locale.UserLocaleName)
print("UserGeoName: ", locale.UserGeoName)

for name in locale:geoNames() do
    print("GEO: ", name)
end 

--C.EnumSystemGeoNames(0, function(arg1, arg2) 
--    print(arg1, arg2) return 1 end, 0);
