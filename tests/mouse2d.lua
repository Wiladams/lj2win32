package.path = "../?.lua;"..package.path;

local graphicApp = require("graphicapp")
local gdi = require("win32.wingdi")
local random = math.random;

function loop()
    backgroundValues(51);
	fillValues(255, 0,0, 118);
	rect(mouseX, height / 2, mouseY / 2 + 10, mouseY / 2 + 10);
	fillValues(0,0,255, 118);
	int inverseX = width - mouseX;
	int inverseY = height - mouseY;
	rect(inverseX, height / 2, (inverseY / 2) + 10, (inverseY / 2) + 10);
end
