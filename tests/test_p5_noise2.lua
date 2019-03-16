package.path = "../?.lua;"..package.path;

require("p5")

local perlin = require("stb_perlin_noise")
local noise = perlin.noise3

local noiseScale=0.005;

function setup()

    local noiseVal = noise(128/4, 72/4,0.3);
print("noiseVal: ", noiseVal)

--[[
    for row = 0, height-1 do
        for col =0, width-1 do
            local noiseVal = noise(col, row);
            io.write(noiseVal,' ')
        end
        print()
    end
--]]
    noLoop();
end


local function draw()
    if not mouseX then
        return 
    end

    background(0);


    for x=0, width-1 do
        local noiseVal = noise((mouseX+x)*noiseScale, mouseY*noiseScale);
        local g = math.floor(abs(noiseVal) * 255)    -- scale color
        --print(noiseVal, g)
        stroke(g);
        local y = mouseY + math.floor(noiseVal*80)
        line(x, y, x, height);
    end
end

go({width=320, height=240})