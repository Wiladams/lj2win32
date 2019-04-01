

local ffi = require("ffi")
require("win32.winapifamily")


if not s6_addr then
s6_addr = true



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
//
// IPv6 Internet address (RFC 2553)
// This is an 'on-wire' format structure.
//
typedef struct in6_addr {
    union {
        UCHAR       Byte[16];
        USHORT      Word[8];
    } u;
} IN6_ADDR, *PIN6_ADDR, *LPIN6_ADDR;
]]

ffi.cdef[[
//#define in_addr6 in6_addr
typedef struct in6_addr in_addr6;
]]

--[[
//
// Defines to match RFC 2553.
//
#define _S6_un      u
#define _S6_u8      Byte
#define s6_addr     _S6_un._S6_u8
--]]

--[[
//
// Defines for our implementation.
//
#define s6_bytes    u.Byte
#define s6_words    u.Word
--]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


end
