--[[
    Draw a checkerboard pattern, assuming the p5 environment
]]

local Checkerboard = {}
setmetatable(Checkerboard, {
    __call = function(self, ...)
        return self:new(...)
    end
})
local Checkerboard_mt = {
    __index = Checkerboard
}

function Checkerboard.init(self, params)
    params = params or {}
    params.x = params.x or 0
    params.y = params.y or 0
    params.width = params.width or 640
    params.height = params.height or 640
    params.columns = params.columns or 8
    params.rows = params.rows or 8
    params.color1 = params.color1 or color(0)
    params.color2 = params.color2 or color(255)
    setmetatable(params, Checkerboard_mt)

    return params
end

function Checkerboard.new(self, params)
    return self:init(params)
end



function Checkerboard.draw(self)
	local tilewidth = self.width / self.columns;
	local tileheight = self.height / self.rows;
	local boxwidth = tilewidth / 2;
	local boxheight = tileheight / 2;

	noStroke();

    rectMode(CORNER);
    
    local c1 = self.color1;
    local c2 = self.color2;

    for r = 0, self.rows-1 do
        -- Flip which color comes first
        -- per each row
        if r % 2 == 0 then
            c1 = self.color1
            c2 = self.color2
        else
            c1 = self.color2;
            c2 = self.color1;
        end

        for c = 0, (self.columns)-1 do
            -- alternate colors per column
            if c % 2 == 0 then
		        fill(c1);
                rect(c*tilewidth, r*tileheight, tilewidth, tileheight);
            else
                fill(c2)
                rect(c*tilewidth, r*tileheight, tilewidth, tileheight);
            end
        end
    end
end

return Checkerboard
