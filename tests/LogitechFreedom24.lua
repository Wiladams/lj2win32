--Input device name: "Logitech Logitech Freedom 2.4"
--Input device ID: bus 0x3 vendor 0x46d product 0xc213


local profile = {
-- base
{EV_KEY, 	BTN_BASE, 		"7", 	{0,1}};
{EV_KEY, 	BTN_BASE2, 		"8", 	{0,1}};
{EV_KEY, 	BTN_BASE3, 		"9", 	{0,1}};
{EV_KEY, 	BTN_BASE4, 		"10", 	{0,1}};

-- throttle
{EV_ABS,	ABS_THROTTLE, 	"+/-", {0,255}};

-- rotate stick
{EV_ABS,	ABS_RZ,			"",		{0,255}};

-- button thumb side of stick
{EV_KEY,	BTN_THUMB,		"thumb",		{0,1}};

-- trigger on front of stick
{EV_KEY,	BTN_TRIGGER,	"trigger",	{0,1}};

-- hat on top of stick
{EV_ABS,	ABS_HAT0X,		"hatx",		{-1,1}};
{EV_ABS,	ABS_HAT0Y,		"haty",		{-1,1}};

-- buttons on top of stick
{EV_KEY,	BTN_THUMB2,		"3",		{0,1}};
{EV_KEY,	BTN_TOP,		"4",		{0,1}};
{EV_KEY,	BTN_TOP2,		"5",		{0,1}};
{EV_KEY,	BTN_PINKIE,		"6",		{0,1}};

-- stick movement
{EV_ABS,	ABS_Y,			"",			{0,1023}};
{EV_ABS,	ABS_X,			"",			{0,1023}};
}
