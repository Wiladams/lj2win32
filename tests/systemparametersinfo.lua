local ffi = require("ffi")

local wtypes = require("win32.wtypes")
local errorhandling = require("win32.core.errorhandling_l1_1_1");

ffi.cdef[[
BOOL SystemParametersInfo(
  UINT  uiAction,
  UINT  uiParam,
  PVOID pvParam,
  UINT  fWinIni
);
]]

local function getBool(what)
    local pBool = ffi.new("BOOL",0)
    local value = ffi.C.SystemParametersInfo(what, 0, pBool, 0)

    print(value, pBool)

    return pBool
end

-- Parameter for SystemParametersInfo.
local names = {
    SPI_GETBEEP                  = {value = 0x0001, converter = getBool },
    SPI_SETBEEP                  = {value = 0x0002},
    SPI_GETMOUSE                 = {value = 0x0003},
    SPI_SETMOUSE                 = {value = 0x0004},
    SPI_GETBORDER                = {value = 0x0005},
    SPI_SETBORDER                = {value = 0x0006},
    SPI_GETKEYBOARDSPEED         = {value = 0x000A},
    SPI_SETKEYBOARDSPEED         = {value = 0x000B},
    SPI_LANGDRIVER               = {value = 0x000C},
    SPI_ICONHORIZONTALSPACING    = {value = 0x000D},
    SPI_GETSCREENSAVETIMEOUT     = {value = 0x000E},
    SPI_SETSCREENSAVETIMEOUT     = {value = 0x000F},
    SPI_GETSCREENSAVEACTIVE      = {value = 0x0010},
    SPI_SETSCREENSAVEACTIVE      = {value = 0x0011},
    SPI_GETGRIDGRANULARITY       = {value = 0x0012},
    SPI_SETGRIDGRANULARITY       = {value = 0x0013},
    SPI_SETDESKWALLPAPER         = {value = 0x0014},
    SPI_SETDESKPATTERN           = {value = 0x0015},
    SPI_GETKEYBOARDDELAY         = {value = 0x0016},
    SPI_SETKEYBOARDDELAY         = {value = 0x0017},
    SPI_ICONVERTICALSPACING      = {value = 0x0018},
    SPI_GETICONTITLEWRAP         = {value = 0x0019},
    SPI_SETICONTITLEWRAP         = {value = 0x001A},
    SPI_GETMENUDROPALIGNMENT     = {value = 0x001B},
    SPI_SETMENUDROPALIGNMENT     = {value = 0x001C},
    SPI_SETDOUBLECLKWIDTH        = {value = 0x001D},
    SPI_SETDOUBLECLKHEIGHT       = {value = 0x001E},
    SPI_GETICONTITLELOGFONT      = {value = 0x001F},
    SPI_SETDOUBLECLICKTIME       = {value = 0x0020},
    SPI_SETMOUSEBUTTONSWAP       = {value = 0x0021},
    SPI_SETICONTITLELOGFONT      = {value = 0x0022},
    SPI_GETFASTTASKSWITCH        = {value = 0x0023},
    SPI_SETFASTTASKSWITCH        = {value = 0x0024},

    SPI_SETDRAGFULLWINDOWS       = {value = 0x0025},
    SPI_GETDRAGFULLWINDOWS       = {value = 0x0026},
    SPI_GETNONCLIENTMETRICS      = {value = 0x0029},
    SPI_SETNONCLIENTMETRICS      = {value = 0x002A},
    SPI_GETMINIMIZEDMETRICS      = {value = 0x002B},
    SPI_SETMINIMIZEDMETRICS      = {value = 0x002C},
    SPI_GETICONMETRICS           = {value = 0x002D},
    SPI_SETICONMETRICS           = {value = 0x002E},
    SPI_SETWORKAREA              = {value = 0x002F},
    SPI_GETWORKAREA              = {value = 0x0030},
    SPI_SETPENWINDOWS            = {value = 0x0031},

    SPI_GETHIGHCONTRAST          = {value = 0x0042},
    SPI_SETHIGHCONTRAST          = {value = 0x0043},
    SPI_GETKEYBOARDPREF          = {value = 0x0044},
    SPI_SETKEYBOARDPREF          = {value = 0x0045},
    SPI_GETSCREENREADER          = {value = 0x0046},
    SPI_SETSCREENREADER          = {value = 0x0047},
    SPI_GETANIMATION             = {value = 0x0048},
    SPI_SETANIMATION             = {value = 0x0049},
    SPI_GETFONTSMOOTHING         = {value = 0x004A},
    SPI_SETFONTSMOOTHING         = {value = 0x004B},
    SPI_SETDRAGWIDTH             = {value = 0x004C},
    SPI_SETDRAGHEIGHT            = {value = 0x004D},
    SPI_SETHANDHELD              = {value = 0x004E},
    SPI_GETLOWPOWERTIMEOUT       = {value = 0x004F},
    SPI_GETPOWEROFFTIMEOUT       = {value = 0x0050},
    SPI_SETLOWPOWERTIMEOUT       = {value = 0x0051},
    SPI_SETPOWEROFFTIMEOUT       = {value = 0x0052},
    SPI_GETLOWPOWERACTIVE        = {value = 0x0053},
    SPI_GETPOWEROFFACTIVE        = {value = 0x0054},
    SPI_SETLOWPOWERACTIVE        = {value = 0x0055},
    SPI_SETPOWEROFFACTIVE        = {value = 0x0056},
    SPI_SETCURSORS               = {value = 0x0057},
    SPI_SETICONS                 = {value = 0x0058},
    SPI_GETDEFAULTINPUTLANG      = {value = 0x0059},
    SPI_SETDEFAULTINPUTLANG      = {value = 0x005A},
    SPI_SETLANGTOGGLE            = {value = 0x005B},
    SPI_GETWINDOWSEXTENSION      = {value = 0x005C},
    SPI_SETMOUSETRAILS           = {value = 0x005D},
    SPI_GETMOUSETRAILS           = {value = 0x005E},
    SPI_SETSCREENSAVERRUNNING    = {value = 0x0061},
    --SPI_SCREENSAVERRUNNING     SPI_SETSCREENSAVERRUNNING

    SPI_GETFILTERKEYS           = {value = 0x0032},
    SPI_SETFILTERKEYS           = {value = 0x0033},
    SPI_GETTOGGLEKEYS           = {value = 0x0034},
    SPI_SETTOGGLEKEYS           = {value = 0x0035},
    SPI_GETMOUSEKEYS            = {value = 0x0036},
    SPI_SETMOUSEKEYS            = {value = 0x0037},
    SPI_GETSHOWSOUNDS           = {value = 0x0038},
    SPI_SETSHOWSOUNDS           = {value = 0x0039},
    SPI_GETSTICKYKEYS           = {value = 0x003A},
    SPI_SETSTICKYKEYS           = {value = 0x003B},
    SPI_GETACCESSTIMEOUT        = {value = 0x003C},
    SPI_SETACCESSTIMEOUT        = {value = 0x003D},

    SPI_GETSERIALKEYS           = {value = 0x003E},
    SPI_SETSERIALKEYS           = {value = 0x003F},

    SPI_GETSOUNDSENTRY          = {value = 0x0040},
    SPI_SETSOUNDSENTRY          = {value = 0x0041},

    SPI_GETSNAPTODEFBUTTON      = {value = 0x005F},
    SPI_SETSNAPTODEFBUTTON      = {value = 0x0060},


    SPI_GETMOUSEHOVERWIDTH      = {value = 0x0062},
    SPI_SETMOUSEHOVERWIDTH      = {value = 0x0063},
    SPI_GETMOUSEHOVERHEIGHT     = {value = 0x0064},
    SPI_SETMOUSEHOVERHEIGHT     = {value = 0x0065},
    SPI_GETMOUSEHOVERTIME       = {value = 0x0066},
    SPI_SETMOUSEHOVERTIME       = {value = 0x0067},
    SPI_GETWHEELSCROLLLINES     = {value = 0x0068},
    SPI_SETWHEELSCROLLLINES     = {value = 0x0069},
    SPI_GETMENUSHOWDELAY        = {value = 0x006A},
    SPI_SETMENUSHOWDELAY        = {value = 0x006B},


    SPI_GETWHEELSCROLLCHARS    = {value = 0x006C},
    SPI_SETWHEELSCROLLCHARS    = {value = 0x006D},


    SPI_GETSHOWIMEUI           = {value = 0x006E},
    SPI_SETSHOWIMEUI           = {value = 0x006F},




    SPI_GETMOUSESPEED          = {value = 0x0070},
    SPI_SETMOUSESPEED          = {value = 0x0071},
    SPI_GETSCREENSAVERRUNNING  = {value = 0x0072},
    SPI_GETDESKWALLPAPER       = {value = 0x0073},



    SPI_GETAUDIODESCRIPTION    = {value = 0x0074},
    SPI_SETAUDIODESCRIPTION    = {value = 0x0075},

    SPI_GETSCREENSAVESECURE    = {value = 0x0076},
    SPI_SETSCREENSAVESECURE    = {value = 0x0077},



    SPI_GETHUNGAPPTIMEOUT            = {value = 0x0078},
    SPI_SETHUNGAPPTIMEOUT            = {value = 0x0079},
    SPI_GETWAITTOKILLTIMEOUT         = {value = 0x007A},
    SPI_SETWAITTOKILLTIMEOUT         = {value = 0x007B},
    SPI_GETWAITTOKILLSERVICETIMEOUT  = {value = 0x007C},
    SPI_SETWAITTOKILLSERVICETIMEOUT  = {value = 0x007D},
    SPI_GETMOUSEDOCKTHRESHOLD        = {value = 0x007E},
    SPI_SETMOUSEDOCKTHRESHOLD        = {value = 0x007F},
    SPI_GETPENDOCKTHRESHOLD          = {value = 0x0080},
    SPI_SETPENDOCKTHRESHOLD          = {value = 0x0081},
    SPI_GETWINARRANGING              = {value = 0x0082},
    SPI_SETWINARRANGING              = {value = 0x0083},
    SPI_GETMOUSEDRAGOUTTHRESHOLD     = {value = 0x0084},
    SPI_SETMOUSEDRAGOUTTHRESHOLD     = {value = 0x0085},
    SPI_GETPENDRAGOUTTHRESHOLD       = {value = 0x0086},
    SPI_SETPENDRAGOUTTHRESHOLD       = {value = 0x0087},
    SPI_GETMOUSESIDEMOVETHRESHOLD    = {value = 0x0088},
    SPI_SETMOUSESIDEMOVETHRESHOLD    = {value = 0x0089},
    SPI_GETPENSIDEMOVETHRESHOLD      = {value = 0x008A},
    SPI_SETPENSIDEMOVETHRESHOLD      = {value = 0x008B},
    SPI_GETDRAGFROMMAXIMIZE          = {value = 0x008C},
    SPI_SETDRAGFROMMAXIMIZE          = {value = 0x008D},
    SPI_GETSNAPSIZING                = {value = 0x008E},
    SPI_SETSNAPSIZING                = {value = 0x008F},
    SPI_GETDOCKMOVING                = {value = 0x0090},
    SPI_SETDOCKMOVING                = {value = 0x0091},



    SPI_GETACTIVEWINDOWTRACKING          = {value = 0x1000},
    SPI_SETACTIVEWINDOWTRACKING          = {value = 0x1001},
    SPI_GETMENUANIMATION                 = {value = 0x1002},
    SPI_SETMENUANIMATION                 = {value = 0x1003},
    SPI_GETCOMBOBOXANIMATION             = {value = 0x1004},
    SPI_SETCOMBOBOXANIMATION             = {value = 0x1005},
    SPI_GETLISTBOXSMOOTHSCROLLING        = {value = 0x1006},
    SPI_SETLISTBOXSMOOTHSCROLLING        = {value = 0x1007},
    SPI_GETGRADIENTCAPTIONS              = {value = 0x1008},
    SPI_SETGRADIENTCAPTIONS              = {value = 0x1009},
    SPI_GETKEYBOARDCUES                  = {value = 0x100A},
    SPI_SETKEYBOARDCUES                  = {value = 0x100B},
    --SPI_GETMENUUNDERLINES               SPI_GETKEYBOARDCUES
    --SPI_SETMENUUNDERLINES               SPI_SETKEYBOARDCUES
    SPI_GETACTIVEWNDTRKZORDER            = {value = 0x100C},
    SPI_SETACTIVEWNDTRKZORDER            = {value = 0x100D},
    SPI_GETHOTTRACKING                   = {value = 0x100E},
    SPI_SETHOTTRACKING                   = {value = 0x100F},
    SPI_GETMENUFADE                      = {value = 0x1012},
    SPI_SETMENUFADE                      = {value = 0x1013},
    SPI_GETSELECTIONFADE                 = {value = 0x1014},
    SPI_SETSELECTIONFADE                 = {value = 0x1015},
    SPI_GETTOOLTIPANIMATION              = {value = 0x1016},
    SPI_SETTOOLTIPANIMATION              = {value = 0x1017},
    SPI_GETTOOLTIPFADE                   = {value = 0x1018},
    SPI_SETTOOLTIPFADE                   = {value = 0x1019},
    SPI_GETCURSORSHADOW                  = {value = 0x101A},
    SPI_SETCURSORSHADOW                  = {value = 0x101B},

    SPI_GETMOUSESONAR                    = {value = 0x101C},
    SPI_SETMOUSESONAR                    = {value = 0x101D},
    SPI_GETMOUSECLICKLOCK                = {value = 0x101E},
    SPI_SETMOUSECLICKLOCK                = {value = 0x101F},
    SPI_GETMOUSEVANISH                   = {value = 0x1020},
    SPI_SETMOUSEVANISH                   = {value = 0x1021},
    SPI_GETFLATMENU                      = {value = 0x1022},
    SPI_SETFLATMENU                      = {value = 0x1023},
    SPI_GETDROPSHADOW                    = {value = 0x1024},
    SPI_SETDROPSHADOW                    = {value = 0x1025},
    SPI_GETBLOCKSENDINPUTRESETS          = {value = 0x1026},
    SPI_SETBLOCKSENDINPUTRESETS          = {value = 0x1027},


    SPI_GETUIEFFECTS                     = {value = 0x103E},
    SPI_SETUIEFFECTS                     = {value = 0x103F},


    SPI_GETDISABLEOVERLAPPEDCONTENT      = {value = 0x1040},
    SPI_SETDISABLEOVERLAPPEDCONTENT      = {value = 0x1041},
    SPI_GETCLIENTAREAANIMATION           = {value = 0x1042},
    SPI_SETCLIENTAREAANIMATION           = {value = 0x1043},
    SPI_GETCLEARTYPE                     = {value = 0x1048},
    SPI_SETCLEARTYPE                     = {value = 0x1049},
    SPI_GETSPEECHRECOGNITION             = {value = 0x104A},
    SPI_SETSPEECHRECOGNITION             = {value = 0x104B},


    SPI_GETFOREGROUNDLOCKTIMEOUT         = {value = 0x2000},
    SPI_SETFOREGROUNDLOCKTIMEOUT         = {value = 0x2001},
    SPI_GETACTIVEWNDTRKTIMEOUT           = {value = 0x2002},
    SPI_SETACTIVEWNDTRKTIMEOUT           = {value = 0x2003},
    SPI_GETFOREGROUNDFLASHCOUNT          = {value = 0x2004},
    SPI_SETFOREGROUNDFLASHCOUNT          = {value = 0x2005},
    SPI_GETCARETWIDTH                    = {value = 0x2006},
    SPI_SETCARETWIDTH                    = {value = 0x2007},


    SPI_GETMOUSECLICKLOCKTIME            = {value = 0x2008},
    SPI_SETMOUSECLICKLOCKTIME            = {value = 0x2009},
    SPI_GETFONTSMOOTHINGTYPE             = {value = 0x200A},
    SPI_SETFONTSMOOTHINGTYPE             = {value = 0x200B},

-- constants for SPI_GETFONTSMOOTHINGTYPE and SPI_SETFONTSMOOTHINGTYPE:
    FE_FONTSMOOTHINGSTANDARD             = {value = 0x0001},
    FE_FONTSMOOTHINGCLEARTYPE            = {value = 0x0002},

    SPI_GETFONTSMOOTHINGCONTRAST            = {value = 0x200C},
    SPI_SETFONTSMOOTHINGCONTRAST            = {value = 0x200D},

    SPI_GETFOCUSBORDERWIDTH              = {value = 0x200E},
    SPI_SETFOCUSBORDERWIDTH              = {value = 0x200F},
    SPI_GETFOCUSBORDERHEIGHT             = {value = 0x2010},
    SPI_SETFOCUSBORDERHEIGHT             = {value = 0x2011},

    SPI_GETFONTSMOOTHINGORIENTATION            = {value = 0x2012},
    SPI_SETFONTSMOOTHINGORIENTATION            = {value = 0x2013},

-- constants for SPI_GETFONTSMOOTHINGORIENTATION and SPI_SETFONTSMOOTHINGORIENTATION:
    FE_FONTSMOOTHINGORIENTATIONBGR    = {value = 0x0000},
    FE_FONTSMOOTHINGORIENTATIONRGB    = {value = 0x0001},



    SPI_GETMINIMUMHITRADIUS              = {value = 0x2014},
    SPI_SETMINIMUMHITRADIUS              = {value = 0x2015},
    SPI_GETMESSAGEDURATION               = {value = 0x2016},
    SPI_SETMESSAGEDURATION               = {value = 0x2017},
}



-- Notification flags
local Flags = {
    SPIF_UPDATEINIFILE     = 0x0001;
    SPIF_SENDWININICHANGE  = 0x0002;
    --SPIF_SENDCHANGE       SPIF_SENDWININICHANGE
}

local exports = {}

local function getSystemParameterInfo(what)
    -- lookup the value based on the what
    local entry = names[what]
    if not entry then
        return false;
    end

    if entry.converter then
        return entry.converter()
    end

    return false;
    
end

local function setSystemParameterInfo()
end

local function SystemParametersInfo()
end

setmetatable(exports, {
	__index = function(self, what)
		return getSystemParameterInfo(what)
	end,
})

return exports
