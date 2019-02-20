package.path = "../?.lua;"..package.path;

require("p5")

function setup()
    --local img = loadImage("images\\rgb_UL.tga")
    --local img = loadImage("images\\rgb_a_UL.tga")
    local img = loadImage("images\\rgb_a_UR.tga")


    image(img)

    noLoop()
end

go()