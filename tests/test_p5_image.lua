package.path = "../?.lua;"..package.path;

require("p5")

function setup()
    --local img = loadImage("images\\rgb_UL.tga")
---[[
    local img_ul = loadImage("images\\rgb_a_UL.tga")
    local img_ur = loadImage("images\\rgb_a_UR.tga")
    local img_ll = loadImage("images\\rgb_a_LL.tga")
    local img_lr = loadImage("images\\rgb_a_LR.tga")

    image(img_ul)
    image(img_ur, 256,0)
    image(img_ll, 0,256)
    image(img_lr, 256,256)
--]]

    local gray_img_ul = loadImage("images\\grayscale_UL.tga")
    local gray_img_ur = loadImage("images\\grayscale_UR.tga")
    local gray_img_ll = loadImage("images\\grayscale_LL.tga")
    local gray_img_lr = loadImage("images\\grayscale_LR.tga")

    image(gray_img_ul, 512,0)
    image(gray_img_ur, 768,0)
    image(gray_img_ll, 512,256)
    image(gray_img_lr, 768,256)

    noLoop()
end

go({width=1024,height=512})