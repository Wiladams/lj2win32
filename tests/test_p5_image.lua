package.path = "../?.lua;"..package.path;

require("p5")

function setup()
    img = loadImage("images\\rgb_UL.tga")

    image(img)

    noLoop()
end

go()