package.path = "../?.lua;"..package.path;


local ffi = require("ffi")

require("win32.windows")

ffi.cdef[[
# pragma pack( push, 1 )

  typedef struct AUXCAPS {

    int wMid;

    int wPid;

    int vDriverVersion;



  } AUXCAPS;

# pragma pack( pop )
]]
