* Doing preprocessing<p>

In order to do interop with C function from LuaJIT, it's almost <p>
as easy as just including the header.h files you require into your <p>
project, and going on from there using the LuaJIT ffi mechanism.<p>

Those headers need a little bit of processing first though.  If<p>
you run these couple of commands, they will get the files closer to<p>
the format need to be included in LuaJIT.<p>


luajit \tools\lcpp mfapi.h -DWINAPI_FAMILY_PARTITION(args)=1 -o mfapi.txt <p>
luajit stripblanklines.lua mfapi.txt mfapi.lua <p>

The first command, runs whatever C/C++ compiler you have on your machine <p>
in pre-processor mode.  The idea is to flatten the header, expanding on the<p> 
various #define statements, and other header inclusions.  This gives you<p>
the 'kitchen sink'.<p>

The second command strips out a ton of the blanks lines that are in the file<p>
and makes it look like the format required for inclusion in LuaJIT.<p>
