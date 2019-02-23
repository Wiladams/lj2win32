package.path = "../?.lua;"..package.path;

require("p5")

local noiseScale=0.03;


function draw()
    if not mouseX then
        return 
    end

    background(0);
    for x=0, width-1 do
        local noiseVal = noise((mouseX+x)*noiseScale, mouseY*noiseScale);
        stroke(noiseVal*255);
        line(x, mouseY+noiseVal*80, x, height);
    end
end

go()