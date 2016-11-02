
local user32 = require("win32.user32")
local errorhandling = require("win32.core.errorhandling_l1_1_1");

local exports = {}

local function SM_toBool(value)
	return value ~= 0
end

exports.names = {
    SM_CXSCREEN = {value = 0};
    SM_CYSCREEN = {value = 1};
    SM_CXVSCROLL = {value = 2};
    SM_CYHSCROLL = {value = 3};
    SM_CYCAPTION = {value = 4};
    SM_CXBORDER = {value = 5};
    SM_CYBORDER = {value = 6};
    SM_CXDLGFRAME = {value = 7};
    SM_CXFIXEDFRAME = {value = 7};
    SM_CYDLGFRAME = {value = 8};
    SM_CYFIXEDFRAME = {value = 8};
    SM_CYVTHUMB = {value = 9};
    SM_CXHTHUMB = {value = 10};
    SM_CXICON = {value = 11};
    SM_CYICON = {value = 12};
    SM_CXCURSOR = {value = 13};
    SM_CYCURSOR = {value = 14};
    SM_CYMENU = {value = 15};
    SM_CXFULLSCREEN = {value = 16};
    SM_CYFULLSCREEN = {value = 17};
    SM_CYKANJIWINDOW = {value = 18};
    SM_MOUSEPRESENT = {value = 19, converter = SM_toBool};
    SM_CYVSCROLL = {value = 20};
    SM_CXHSCROLL = {value = 21};
    SM_DEBUG = {value = 22, converter = SM_toBool};
    SM_SWAPBUTTON = {value = 23, converter = SM_toBool};
    SM_RESERVED1 = {value = 24, converter = SM_toBool};
    SM_RESERVED2 = {value = 25, converter = SM_toBool};
    SM_RESERVED3 = {value = 26, converter = SM_toBool};
    SM_RESERVED4 = {value = 27, converter = SM_toBool};
    SM_CXMIN = {value = 28};
    SM_CYMIN = {value = 29};
    SM_CXSIZE = {value = 30};
    SM_CYSIZE = {value = 31};
    SM_CXSIZEFRAME = {value = 32};
    SM_CXFRAME = {value = 32};
    SM_CYFRAME = {value = 33};
    SM_CYSIZEFRAME = {value = 33};
    SM_CXMINTRACK = {value = 34};
    SM_CYMINTRACK = {value = 35};
    SM_CXDOUBLECLK = {value = 36};
    SM_CYDOUBLECLK = {value = 37};
    SM_CXICONSPACING = {value = 38};
    SM_CYICONSPACING = {value = 39};
    SM_MENUDROPALIGNMENT = {value = 40};
    SM_PENWINDOWS = {value = 41};
    SM_DBCSENABLED = {value = 42, converter = SM_toBool};
    SM_CMOUSEBUTTONS = {value = 43};
    SM_SECURE = {value = 44, converter = SM_toBool};
    SM_CXEDGE = {value = 45};
    SM_CYEDGE = {value = 46};
    SM_CXMINSPACING = {value = 47};
    SM_CYMINSPACING = {value = 48};
    SM_CXSMICON = {value = 49};
    SM_CYSMICON = {value = 50};
    SM_CYSMCAPTION = {value = 51};
    SM_CXSMSIZE = {value = 52};
    SM_CYSMSIZE = {value = 53};
    SM_CXMENUSIZE = {value = 54};
    SM_CYMENUSIZE = {value = 55};
    SM_ARRANGE = {value = 56};
    SM_CXMINIMIZED = {value = 57};
    SM_CYMINIMIZED = {value = 58};
    SM_CXMAXTRACK = {value = 59};
    SM_CYMAXTRACK = {value = 60};
    SM_CXMAXIMIZED = {value = 61};
    SM_CYMAXIMIZED = {value = 62};
    SM_NETWORK = {value = 63};
    SM_CLEANBOOT = {value = 67};
    SM_CXDRAG = {value = 68};
    SM_CYDRAG = {value = 69};
    SM_SHOWSOUNDS = {value = 70, converter = SM_toBool};
    SM_CXMENUCHECK = {value = 71};
    SM_CYMENUCHECK = {value = 72};
    SM_SLOWMACHINE = {value = 73, converter = SM_toBool};
    SM_MIDEASTENABLED = {value = 74, converter = SM_toBool};
    SM_MOUSEWHEELPRESENT = {value = 75, converter = SM_toBool};
    SM_XVIRTUALSCREEN = {value = 76};
    SM_YVIRTUALSCREEN = {value = 77};
    SM_CXVIRTUALSCREEN = {value = 78};
    SM_CYVIRTUALSCREEN = {value = 79};
    SM_CMONITORS = {value = 80};
    SM_SAMEDISPLAYFORMAT = {value = 81};
    SM_IMMENABLED = {value = 82, converter = SM_toBool};
    SM_TABLETPC = {value = 86, converter = SM_toBool};
    SM_MEDIACENTER = {value = 87, converter = SM_toBool};
    SM_STARTER = {value = 88, converter = SM_toBool};
    SM_SERVERR2 = {value = 89, converter = SM_toBool};
    SM_MOUSEHORIZONTALWHEELPRESENT = {value = 91, converter = SM_toBool};
    SM_DIGITIZER = {value = 94};
    SM_MAXIMUMTOUCHES = {value = 95};

    SM_REMOTESESSION = {value = 0x1000, converter = SM_toBool};
    SM_SHUTTINGDOWN = {value = 0x2000, converter = SM_toBool};
    SM_REMOTECONTROL = {value = 0x2001, converter = SM_toBool};
    SM_CONVERTIBLESLATEMODE = {value = 0x2003, converter = SM_toBool};
    SM_SYSTEMDOCKED = {value = 0x2004, converter = SM_toBool};
}

local function lookupByNumber(num)
	for key, entry in pairs(exports.names) do
		if entry.value == num then
			return entry;
		end
	end

	return nil;
end

function exports.getSystemMetrics(what)
	local entry = nil;
	local idx = nil;

	if type(what) == "string" then
		entry = exports.names[what]
		idx = entry.value;
	else
		idx = tonumber(what)
		if not idx then 
			return nil;
		end
		
		entry = lookupByNumber(idx)

        if not entry then return nil end
	end

	local value = user32.GetSystemMetrics(idx)

    if entry.converter then
        value = entry.converter(value);
    end

    return value;
end

setmetatable(exports, {
	__index = function(self, what)
		return exports.getSystemMetrics(what)
	end,

	__call = function(self, what)
	end
})

return exports