package.path = "../?.lua;"..package.path;

require("p5")

--[[
    Torture test for creating pens
]]

local N = 36;
local theta = 3.14159 * 2 / N;
local centerX = 0;
local centerY = 0;

function setup()
    centerX = width/2;
    centerY = height/2;
    stroke(255, 0,0)
end 

function draw()
    local x = 0;
    local y = 0;


	local Radius = (height / 2) - 5;

    for p = 0, N-1 do
		local num = floor((p / N) * 254.0);
        local r = random(0, num);
		local g = random(0, num);
		local b = random(0, num);
        stroke(r, g, b)

		for q = 0, p-1 do
		    line(floor(centerX + Radius * sin(p * theta)), floor(centerY + Radius * cos(p * theta)),
				floor(centerX + Radius * sin(q * theta)), floor(centerY + Radius * cos(q * theta)));
        end
    end

end


go()
