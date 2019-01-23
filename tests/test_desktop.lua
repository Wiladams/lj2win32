package.path = "../?.lua;"..package.path;

require("win32.sdkddkver")

local Desktop = require("desktopclass")

-- Get the names of the current desktops
function test_GetDesktops()
    print("==== GetDesktops ====")
	local desktops = Desktop:desktopNames();
	for _, name in ipairs(desktops) do 
		print(name);
	end
end

-- Get the handles for the windows in the desktop
function test_desktopwindows()
    print("==== desktopwindows ====")
	local dtop = Desktop:openThreadDesktop();

	local wins = dtop:getWindowHandles();

	for winid, hwnd in pairs(wins) do
		print("HWND: ", winid, hwnd);
	end
end


test_GetDesktops();
test_desktopwindows();
