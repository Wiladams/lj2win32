package.path = "../?.lua;"..package.path;

require("p5")

function setup()
    --local img = loadImage("images\\rgb_UL.tga")
    
    local img_ul = loadImage("images\\rgb_a_UL.tga")
    local img_ur = loadImage("images\\rgb_a_UR.tga")
    local img_ll = loadImage("images\\rgb_a_LL.tga")
    local img_lr = loadImage("images\\rgb_a_LR.tga")


    image(img_ul)
    image(img_ur, 256,0)
    image(img_ll, 0,256)
    image(img_lr, 256,256)
    
    noLoop()
end

go({width=512,height=512})