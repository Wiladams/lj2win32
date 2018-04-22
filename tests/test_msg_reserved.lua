-- test_wm_reserved.lua
package.path = "../?.lua;"..package.path;

--local wmmsgs = require("wmmsgs")
--local wmmsgs = require("wm_reserved")

---[[
local wmmsgs = {
    WM_NULL = 0x0000;
    WM_CREATE = 0x01;
    WM_DESTROY = 0x02;
    WM_MOVE = 0x03;
}

--for k,v in pairs(wmmsgs) do print(k,v) end


function wmmsgs.lookup(self, num)
	for k, v in pairs(self) do 
		if v == num then
			return k
		end
	end 

	return tostring(string.format("UNKNOWN: 0x%04x", num))
end 

print(wmmsgs:lookup(0));
print(wmmsgs:lookup(1));
print(wmmsgs:lookup(2));
print(wmmsgs:lookup(3));
print(wmmsgs:lookup(4));

--[[
local i = 0;
while i < 0x0400 do
    print(wmmsgs:lookup(i));
    i = i + 1;
end
]]

print("Hello")