package.path = "../?.lua;"..package.path;

require("p5")

local perlin = require("stb_perlin_noise")
local noise = perlin.noise3

local noiseScale=0.005;


function draw()
    if not mouseX then
        return 
    end

    background(0);
    for x=0, width-1 do
        local noiseVal = noise((mouseX+x)*noiseScale, mouseY*noiseScale);
        local g = noiseVal * 255    -- scale color
        print(noiseVal, g)
        stroke(g);
        line(x, mouseY+noiseVal*80, x, height);
    end
end

go()