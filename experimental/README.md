Doing preprocessing

luajit \tools\lcpp mfapi.h -DWINAPI_FAMILY_PARTITION(args)=1 -o mfapi.txt
luajit stripblanklines.lua mfapi.txt mfapi.lua
