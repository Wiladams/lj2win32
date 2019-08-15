--[[
-- first do this
    copy the blend2d.h file into this directory

    copy c:\repos\blendwsp\blend2d\src\blend2d.h .

then

    
-- cl /EP blend2d.h > blend2d_ffi.txt

--Then run this file on the resulting blend2d_ffi.txt
-- luajit preproc.lua blend2d_ffi.txt > blend2d_ffi.lua
--
-- look for the line starting: typedef struct BLRange BLRange;
-- and delete everything before that

Of Note:

some union/structs are collapsed
--]]


for line in io.lines(arg[1]) do
    if line ~= "" and line ~= "  " then
        if string.sub(line, 1, 1) ~= '#' then
            if not string.find(line, "__pragma") then
                print(line)
            end
        end
    end
end
