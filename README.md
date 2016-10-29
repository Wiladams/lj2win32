# lj2win32
module supporting win32 ffi binding

If you are writing LuaJIT code on the Windows platform, the binding code here
will make that task easier.  The code was originally borrowed from TINN.  The
difference is, whereas TINN provides an entire application shell within which
you run your code, this project just provides raw low level bindings, without
all the application level stuff.  This makes is possible for you to write simple
applications by just requiring the bits and pieces of this package as your
needs dictate.

The ultimate goal is that you'd be able to use luarocks to install this thing.
Without luarocks, you can simply copy the win32 directory and its contents into 
you luajit distribution directly and you're good to go.

In the TINN project, there are core low level win32 bindings, as well as lots 
of higher level Lua 'object' modules.  That makes for an entire package of 
convenience.  It makes it easy to throw together applications from simple Windows
on the screen to complex high scale internet services.  This is great, but if you
don't like the object models, it's kind of a pain to tease apart.  In this 
project, you primarily get the bindings, with fewer object abstractions.  The
abstractions are saved for the sample code and experimental area.

The directory 'core' contains the bulk of the bindings.  These bindings follow 
the lowest level library structure within Windows.  It's different from the more
traditional 'Kernel32', 'GDI', 'User32', etc.  It breaks down into how windows 
actually layers the libraries to minimize interdependencies.  If you know what 
specific functions you're looking for, then you can 'require' at this level:

```lua 
require ("win32.core.console_l1_1_0")
require ("win32.core.datetime_l1_1_1")
```

Design Concepts
===============

There are a few guiding design concepts that drive the creation of this body 
of work.  Collectively, they define the set of expectations that any consumer
of the library can rely on.  They are meant to enhance the ability to use
the routines in conjunction with other libraries and routines, as well as 
make for a faithful rendering of the underlying Win32 APIs.

* Nothing should be placed in the global address space
* All integer constants that can be, should be accessible through ffi.C
* Lowest level ffi binding should be true to native functions
