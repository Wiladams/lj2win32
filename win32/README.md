minwindef.lua - The most bare mininum of types.  This is typically required within apisets, and anything else above that.

You can use windows.lua, as is typical with typical 'C' based windows applications, but that will pull in a ton of stuff that's not typically needed, and will slow down the load time of your application.

So, when using an apiset, like libloaderapi, require the minimal amount you need, rather than the maximum.
