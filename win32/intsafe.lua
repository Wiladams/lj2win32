local ffi = require("ffi")

-- Define _WIN64 from the very beginning because various
-- other data structures are dependent on it. 
-- Make it global for ease.
_WIN64 = (ffi.os == "Windows") and ffi.abi("64bit");

ffi.cdef[[
    typedef char                CHAR;
    typedef signed char         INT8;
    typedef unsigned char       UCHAR;
    typedef unsigned char       UINT8;
    typedef unsigned char       BYTE;
    typedef int16_t             SHORT;
    typedef int16_t             INT16;
    typedef uint16_t            USHORT;
    typedef uint16_t            UINT16;
    typedef uint16_t            WORD;
    typedef int                 INT;
    typedef int32_t             INT32;
    typedef unsigned int        UINT;
    typedef unsigned int        UINT32;
    typedef long                LONG;
    typedef unsigned long       ULONG;
    typedef unsigned long       DWORD;
    typedef int64_t             LONGLONG;
    typedef int64_t             LONG64;
    typedef int64_t             INT64;
    typedef uint64_t            ULONGLONG;
    typedef uint64_t            DWORDLONG;
    typedef uint64_t            ULONG64;
    typedef uint64_t            DWORD64;
    typedef uint64_t            UINT64;
]]

if _WIN64 then
    ffi.cdef[[
    typedef int64_t   INT_PTR;
    typedef uint64_t  UINT_PTR;
    typedef int64_t   LONG_PTR;
    typedef uint64_t  ULONG_PTR;
    ]]
    else
    ffi.cdef[[
    typedef int             INT_PTR;
    typedef unsigned int    UINT_PTR;
    typedef long            LONG_PTR;
    typedef unsigned long   ULONG_PTR;
    ]]
end

ffi.cdef[[
typedef ULONG_PTR   DWORD_PTR;
typedef LONG_PTR    SSIZE_T;
typedef ULONG_PTR   SIZE_T;
]]
