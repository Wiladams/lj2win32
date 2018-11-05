package.path = "../?.lua;"..package.path;

local guid = require("win32.guiddef")

DEFINE_GUID( "GUID_DEVINTERFACE_KEYBOARD", 0x884b96c3, 0x56ef, 0x11d1, 0xbc, 0x8c, 0x00, 0xa0, 0xc9, 0x14, 0x05, 0xdd);

print(GUID_DEVINTERFACE_KEYBOARD)

--[[
// Maximum Power Savings - indicates that very aggressive power savings measures will be used to help
//                         stretch battery life.
//
// {a1841308-3541-4fab-bc81-f71556f20b4a}
--]]
DEFINE_GUID( "GUID_MAX_POWER_SAVINGS", 0xA1841308, 0x3541, 0x4FAB, 0xBC, 0x81, 0xF7, 0x15, 0x56, 0xF2, 0x0B, 0x4A );

assert("a1841308-3541-4fab-bc81-f71556f20b4a" == tostring(GUID_MAX_POWER_SAVINGS))
