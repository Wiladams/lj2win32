# lj2win32
module supporting win32 ffi binding

If you are writing LuaJIT code on the Windows platform, the binding code here
will make that task easier.  The code was originally borrowed from TINN.  The
difference is, whereas TINN provides an entire application shell within which
you run your code, this project just provides raw low level bindings, without
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
don't like the object models, it's kind of a pain to tease apart.  In this 
project, you primarily get the bindings, with fewer object abstractions.  The
abstractions are saved for the sample code and experimental area.

The primary bindings found in the win32 directory cover the standard APIs as
are found in gdi32, user32, opengl32, kernel32, and some others that are of 
common usage.

The directory 'experimental/apiset' contains the much more slenderized 'apiset' 
representation of the APIs.  These are new style as of Windows 8, where much
smaller libraries can be pulled in without dragging in as many dependencies.

These might be the subject of a future project which is faithful to the apiset
approach rather than this more standard 'win32' approach.

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
