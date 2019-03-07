package.path = "../?.lua;"..package.path;

require("p5")

function setup()
    ellipse(56, 46, 55, 55);

    noLoop()
end


go();
