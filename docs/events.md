How many different ways are there to get keyboard and mouse events in Windows?

standard winuser messages - standard WM_ messaging stuff, very baked

raw input - read from raw devices, next best thing to reading usb

event hooks - can be set within an application

system hooks - need a separate .dll to contain a hooking callback

usb transfers - could do this, but possibly reserved by the OS?

