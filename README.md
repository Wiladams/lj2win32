# lj2win32
LuaJIT ffi bindings to Win32

If you are writing LuaJIT code on the Windows platform, the binding code here
will make that task easier.  The code was originally borrowed from TINN.  The
difference is, TINN provides an entire runtime environment for
you to run your code in, lj2win32 just provides raw low level bindings, without
all the application level stuff.  This makes it possible for you to write simple
applications by just requiring the bits and pieces of this package as your
needs dictate.

The ultimate goal is that you'd be able to use luarocks to install this thing.
Without luarocks, you can simply copy the win32 directory and its contents into 
you luajit distribution directly and you're good to go.

In the TINN project, there are core low level win32 bindings, as well as lots 
of higher level Lua 'object' modules.  That makes for an entire package of 
convenience.  It makes it easy to throw together applications from simple Windows
on the screen to complex high scale internet services.  This is great, but if you
don't like the object models, it's kind of a pain to tease apart.  In lj2win32, 
you primarily get the bindings, with fewer object abstractions.  But, there are
plenty of abstractions and object models in the test and experimental areas.

The primary bindings found in the win32 directory cover the standard APIs as
are found in gdi32, user32, opengl32, kernel32, and many more along the way.


Design Concepts
---------------

There are a few guiding design concepts that drive the creation of this body 
of work.  Collectively, they define the set of expectations that any consumer
of the library can rely on.  They are meant to enhance the ability to use
the routines in conjunction with other libraries and routines, as well as 
make for a faithful rendering of the underlying Win32 APIs.

* Nothing should be placed in the global address space (with a couple of exceptions)
* All integer constants that can be, should be accessible through ffi.C.*
* Lowest level ffi binding should be true to native functions
