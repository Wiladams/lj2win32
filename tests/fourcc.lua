local ffi = require("ffi")

function MAKEFOURCC(ch0, ch1, ch2, ch3)                              
    return            DWORD(bor(ffi.cast("BYTE",ch0) , lshift(ffi.cast("BYTE",ch1) , 8) ,   
                lshift(ffi.cast("BYTE",ch2) , 16) , lshift(ffi.cast("BYTE",ch3) , 24 )))
end
