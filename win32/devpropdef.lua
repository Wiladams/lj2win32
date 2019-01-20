local ffi = require("ffi")

require("win32.winapifamily")


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

if not _DEVPROPDEF_H_ then
_DEVPROPDEF_H_ = true

ffi.cdef[[
typedef ULONG DEVPROPTYPE, *PDEVPROPTYPE;
]]

ffi.cdef[[
//
// Property type modifiers.  Used to modify base DEVPROP_TYPE_ values, as
// appropriate.  Not valid as standalone DEVPROPTYPE values.
//
static const int DEVPROP_TYPEMOD_ARRAY                   = 0x00001000;  // array of fixed-sized data elements
static const int DEVPROP_TYPEMOD_LIST                    = 0x00002000;  // list of variable-sized data elements
]]

ffi.cdef[[
//
// Property data types.
//
static const int DEVPROP_TYPE_EMPTY                      = 0x00000000;  // nothing, no property data
static const int DEVPROP_TYPE_NULL                       = 0x00000001;  // null property data
static const int DEVPROP_TYPE_SBYTE                      = 0x00000002;  // 8-bit signed int (SBYTE)
static const int DEVPROP_TYPE_BYTE                       = 0x00000003;  // 8-bit unsigned int (BYTE)
static const int DEVPROP_TYPE_INT16                      = 0x00000004;  // 16-bit signed int (SHORT)
static const int DEVPROP_TYPE_UINT16                     = 0x00000005;  // 16-bit unsigned int (USHORT)
static const int DEVPROP_TYPE_INT32                      = 0x00000006;  // 32-bit signed int (LONG)
static const int DEVPROP_TYPE_UINT32                     = 0x00000007;  // 32-bit unsigned int (ULONG)
static const int DEVPROP_TYPE_INT64                      = 0x00000008;  // 64-bit signed int (LONG64)
static const int DEVPROP_TYPE_UINT64                     = 0x00000009;  // 64-bit unsigned int (ULONG64)
static const int DEVPROP_TYPE_FLOAT                      = 0x0000000A;  // 32-bit floating-point (FLOAT)
static const int DEVPROP_TYPE_DOUBLE                     = 0x0000000B;  // 64-bit floating-point (DOUBLE)
static const int DEVPROP_TYPE_DECIMAL                    = 0x0000000C;  // 128-bit data (DECIMAL)
static const int DEVPROP_TYPE_GUID                       = 0x0000000D;  // 128-bit unique identifier (GUID)
static const int DEVPROP_TYPE_CURRENCY                   = 0x0000000E;  // 64 bit signed int currency value (CURRENCY)
static const int DEVPROP_TYPE_DATE                       = 0x0000000F;  // date (DATE)
static const int DEVPROP_TYPE_FILETIME                   = 0x00000010;  // file time (FILETIME)
static const int DEVPROP_TYPE_BOOLEAN                    = 0x00000011;  // 8-bit boolean (DEVPROP_BOOLEAN)
static const int DEVPROP_TYPE_STRING                     = 0x00000012;  // null-terminated string
static const int DEVPROP_TYPE_STRING_LIST = (DEVPROP_TYPE_STRING|DEVPROP_TYPEMOD_LIST); // multi-sz string list
static const int DEVPROP_TYPE_SECURITY_DESCRIPTOR        = 0x00000013;  // self-relative binary SECURITY_DESCRIPTOR
static const int DEVPROP_TYPE_SECURITY_DESCRIPTOR_STRING = 0x00000014;  // security descriptor string (SDDL format)
static const int DEVPROP_TYPE_DEVPROPKEY                 = 0x00000015;  // device property key (DEVPROPKEY)
static const int DEVPROP_TYPE_DEVPROPTYPE                = 0x00000016;  // device property type (DEVPROPTYPE)
static const int DEVPROP_TYPE_BINARY     = (DEVPROP_TYPE_BYTE|DEVPROP_TYPEMOD_ARRAY);  // custom binary data
static const int DEVPROP_TYPE_ERROR                      = 0x00000017;  // 32-bit Win32 system error code
static const int DEVPROP_TYPE_NTSTATUS                   = 0x00000018;  // 32-bit NTSTATUS code
static const int DEVPROP_TYPE_STRING_INDIRECT            = 0x00000019;  // string resource (@[path\]<dllname>,-<strId>)

//
// Max base DEVPROP_TYPE_ and DEVPROP_TYPEMOD_ values.
//
static const int MAX_DEVPROP_TYPE                        = 0x00000019;  // max valid DEVPROP_TYPE_ value
static const int MAX_DEVPROP_TYPEMOD                     = 0x00002000;  // max valid DEVPROP_TYPEMOD_ value

//
// Bitmasks for extracting DEVPROP_TYPE_ and DEVPROP_TYPEMOD_ values.
//
static const int DEVPROP_MASK_TYPE                       = 0x00000FFF;  // range for base DEVPROP_TYPE_ values
static const int DEVPROP_MASK_TYPEMOD                    = 0x0000F000;  // mask for DEVPROP_TYPEMOD_ type modifiers
]]

ffi.cdef[[
//
// Property type specific data types.
//

// 8-bit boolean type definition for DEVPROP_TYPE_BOOLEAN (True=-1, False=0)
typedef CHAR DEVPROP_BOOLEAN, *PDEVPROP_BOOLEAN;
static const int DEVPROP_TRUE  = ((DEVPROP_BOOLEAN)-1);
static const int DEVPROP_FALSE = ((DEVPROP_BOOLEAN) 0);
]]


if not DEVPROPKEY_DEFINED then
DEVPROPKEY_DEFINED = true

ffi.cdef[[
typedef GUID  DEVPROPGUID, *PDEVPROPGUID;
typedef ULONG DEVPROPID,   *PDEVPROPID;

typedef struct _DEVPROPKEY {
    DEVPROPGUID fmtid;
    DEVPROPID   pid;
} DEVPROPKEY, *PDEVPROPKEY;
]]
end --// DEVPROPKEY_DEFINED

--[[
#ifndef IsEqualDevPropKey
#ifdef __cplusplus
#define IsEqualDevPropKey(a, b)   (((a).pid == (b).pid) && IsEqualGUID((a).fmtid, (b).fmtid))
#ifdef _SYS_GUID_OPERATOR_EQ_
extern "C++" {
inline bool operator==(const DEVPROPKEY &a, const DEVPROPKEY &b) { return ((a.pid == b.pid) && (a.fmtid == b.fmtid)); }
inline bool operator!=(const DEVPROPKEY &a, const DEVPROPKEY &b) { return !(a == b); }
}
#endif // _SYS_GUID_OPERATOR_EQ_
#else // !__cplusplus
#define IsEqualDevPropKey(a, b)   (((a).pid == (b).pid) && IsEqualGUID(&(a).fmtid, &(b).fmtid))
#endif // __cplusplus
#endif // !IsEqualDevPropKey
--]]

ffi.cdef[[
//
// DEVPROPSTORE Enumeration
//
// This enumeration describes where a property is stored.
//

typedef 
enum _DEVPROPSTORE {
    DEVPROP_STORE_SYSTEM,
    DEVPROP_STORE_USER
} DEVPROPSTORE, *PDEVPROPSTORE;
]]

ffi.cdef[[
//
// DEVPROPCOMPKEY structure
//
// This structure represents a compound key for a property.
//

typedef struct _DEVPROPCOMPKEY {
    DEVPROPKEY Key;
    DEVPROPSTORE Store;
    PCWSTR LocaleName;
} DEVPROPCOMPKEY, *PDEVPROPCOMPKEY;
]]

--[[
#ifndef IsEqualLocaleName
#define IsEqualLocaleName(a, b) (((a) == (b)) || (((a) != NULL) && ((b) != NULL) && (_wcsicmp((a), (b)) == 0)))
#endif

#ifndef IsEqualDevPropCompKey
#define IsEqualDevPropCompKey(a, b) (IsEqualDevPropKey((a).Key, (b).Key) && ((a).Store == (b).Store) && IsEqualLocaleName((a).LocaleName, (b).LocaleName))
#ifdef __cplusplus
#ifdef _SYS_GUID_OPERATOR_EQ_
extern "C++" {
inline bool operator==(const DEVPROPCOMPKEY &a, const DEVPROPCOMPKEY &b) { return ((a.Key == b.Key) && (a.Store == b.Store) && IsEqualLocaleName(a.LocaleName, b.LocaleName)); }
inline bool operator!=(const DEVPROPCOMPKEY &a, const DEVPROPCOMPKEY &b) { return !(a == b); }
}
#endif // _SYS_GUID_OPERATOR_EQ_
#endif // __cplusplus
#endif // !IsEqualDevPropCompKey
--]]

ffi.cdef[[
//
// DEVPROPERTY structure
//

typedef struct _DEVPROPERTY {
    DEVPROPCOMPKEY CompKey;
    DEVPROPTYPE Type;
    ULONG BufferSize;
    PVOID Buffer;
} DEVPROPERTY, *PDEVPROPERTY;
]]

ffi.cdef[[
//
// All valid DEVPROPKEY definitions must use a PROPID that is equal to or greater
// than DEVPROPID_FIRST_USABLE.
//
static const int DEVPROPID_FIRST_USABLE = 2;
]]
end --// _DEVPROPDEF_H_

--[[
if DEFINE_DEVPROPKEY then
DEFINE_DEVPROPKEY = nil
end

if INITGUID then
#define DEFINE_DEVPROPKEY(name, l, w1, w2, b1, b2, b3, b4, b5, b6, b7, b8, pid) EXTERN_C const DEVPROPKEY DECLSPEC_SELECTANY name = { { l, w1, w2, { b1, b2,  b3,  b4,  b5,  b6,  b7,  b8 } }, pid }
else
#define DEFINE_DEVPROPKEY(name, l, w1, w2, b1, b2, b3, b4, b5, b6, b7, b8, pid) EXTERN_C const DEVPROPKEY name
end --// INITGUID
--]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



