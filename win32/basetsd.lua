--[[
    Some core types have been defined since the earliest days
    of Windows.  Types such as BYTE, SHORT, CHAR, WORD, DWORD, etc

    Why do such definitions even exist?  Because Windows predates
    the invention of things like int8_t, uint32_t and the like.
    So, those early APIs defined these, and they've stuck around
    ever since.
    
    You will find these types littered throughout the various
    Windows APIs, so they are defined here.  The definitions 
    here follow those in the Windows sdk basetsd.h file.  A more
    typical way of including these types is to require the
    win32.wtypes.lua file in your project, but really, requiring
    one of the higher leve API files will automatically pull
    these in, so you're not likely to require it directly.

    Reference
    https://msdn.microsoft.com/en-us/library/windows/desktop/aa383751(v=vs.85).aspx
]]
local ffi = require("ffi");

-- start with core definitions found in intsafe
require ("win32.intsafe")


ffi.cdef[[
typedef uint64_t        *PDWORDLONG;
]]

ffi.cdef[[
typedef int8_t          INT8, *PINT8;
typedef int16_t         INT16, *PINT16;
typedef int32_t         INT32, *PINT32;
typedef int64_t         INT64, *PINT64;
typedef uint8_t         UINT8, *PUINT8;
typedef uint16_t        UINT16, *PUINT16;
typedef uint32_t        UINT32, *PUINT32;
typedef uint64_t        UINT64, *PUINT64;
]]

ffi.cdef[[
//
// The following types are guaranteed to be signed and 32 bits wide.
//

typedef int32_t LONG32, *PLONG32;

//
// The following types are guaranteed to be unsigned and 32 bits wide.
//

typedef uint32_t  ULONG32, *PULONG32;
typedef uint32_t  DWORD32, *PDWORD32;
]]



ffi.cdef[[
typedef INT_PTR     *PINT_PTR;
typedef UINT_PTR    *PUINT_PTR;
typedef LONG_PTR    *PLONG_PTR;
typedef ULONG_PTR   *PULONG_PTR;
]]

ffi.cdef[[
typedef SIZE_T *PSIZE_T;
typedef SSIZE_T *PSSIZE_T;
]]


ffi.cdef[[
//
// Add Windows flavor DWORD_PTR types
//

typedef DWORD_PTR *PDWORD_PTR;

//
// The following types are guaranteed to be signed and 64 bits wide.
//

typedef LONG64 *PLONG64;

//
// The following types are guaranteed to be unsigned and 64 bits wide.
//

typedef ULONG64 *PULONG64;
typedef DWORD64 *PDWORD64;

//
// Structure to represent a group-specific affinity, such as that of a
// thread.  Specifies the group number and the affinity within that group.
//
typedef ULONG_PTR KAFFINITY;
typedef KAFFINITY *PKAFFINITY;
]]
