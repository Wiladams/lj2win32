package.path = "../?.lua;"..package.path

require("sdkddkver")

local ScreenCapture = require("ScreenCapture");
local FileStream = require("FileStream");

local screenCap = ScreenCapture();

local snapscreen = function(filename)
	local fs = FileStream.Open(filename, "wb+");
	screenCap:captureScreen();

	local contentlength = screenCap.CapturedStream:GetPosition()

	fs:writeBytes(screenCap.CapturedStream.Buffer, contentlength)
	fs:Close();
end

snapscreen("screen1.bmp");
print("snapshot taken")

