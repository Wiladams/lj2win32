# lj2win32
module supporting win32 ffi binding

The lineage for this module is TINN.  Instead of being a part of a standalone LuaJIT shell, this project creates
a module that can be installed via luarocks.

This module strives to contain the essence of the win32 API.  As such, it's fairly minimal in terms
of Object abstractions and other details that are not essential to making it work.