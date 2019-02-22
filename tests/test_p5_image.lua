package.path = "../?.lua;"..package.path;

require("p5")

local ffi = require("ffi")
local C = ffi.C 

-- load images
local img_ul = loadImage("images\\rgb_a_UL.tga")
local img_ur = loadImage("images\\rgb_a_UR.tga")
local img_ll = loadImage("images\\rgb_a_LL.tga")
local img_lr = loadImage("images\\rgb_a_LR.tga")

local gray_img_ul = loadImage("images\\grayscale_UL.tga")
local gray_img_ur = loadImage("images\\grayscale_UR.tga")
local gray_img_ll = loadImage("images\\grayscale_LL.tga")
local gray_img_lr = loadImage("images\\grayscale_LR.tga")

local ctc24 = loadImage("images\\ctc24.tga")
local ctc32 = loadImage("images\\ctc32.tga")

local utc24 = loadImage("images\\utc24.tga")
local utc32 = loadImage("images\\utc32.tga")
local ubw8 = loadImage("images\\ubw8.tga")

local FLAG_B16 = loadImage("images\\FLAG_B16.tga")
local FLAG_B24 = loadImage("images\\FLAG_B24.tga")
local FLAG_B32 = loadImage("images\\FLAG_B32.tga")
local FLAG_T16 = loadImage("images\\FLAG_T16.tga")
local FLAG_T32 = loadImage("images\\FLAG_T32.tga")

local XING_B16 = loadImage("images\\XING_B16.tga")
local XING_B24 = loadImage("images\\XING_B24.tga")
local XING_B32 = loadImage("images\\XING_B32.tga")
local XING_T16 = loadImage("images\\XING_T16.tga")
local XING_T24 = loadImage("images\\XING_T24.tga")
local XING_T32 = loadImage("images\\XING_T32.tga")

local MARBLES = loadImage("images\\MARBLES.tga")



local function drawOrientation()
    image(img_ul)
    image(img_ur, 256,0)
    image(img_ll, 0,256)
    image(img_lr, 256,256)
end

local function drawGrays()
    image(gray_img_ul, 0,0)
    image(gray_img_ur, 256,0)
    image(gray_img_ll, 0,256)
    image(gray_img_lr, 256,256)
end

local randomimages = {
    ubw8,
    
    utc24,
    utc32,

    ctc24,
    ctc32,

}
local function drawRandomImage()
    local num = math.random(1,#randomimages)
    image(randomimages[num], 0,0)
end

local playlist = {
    MARBLES,
    FLAG_B16,
    FLAG_B24,
    FLAG_B32,
    FLAG_T16,
    FLAG_T32,
    XING_B16,
    XING_B24,
    XING_B32,
    XING_T16,
    XING_T24,
    XING_T32
}
local nItems = #playlist
local currentItem = 1


local function drawPlaylist()
    image(playlist[currentItem],0,0)
end

local drawRoutines = {
    --drawOrientation,
    --drawGrays,
    --drawRandomImage,
    drawPlaylist,
}

local nRoutines = #drawRoutines
local currentRoutine = 1



function setup()
    noLoop()
end

function draw()
    background(0xcc)
    drawRoutines[currentRoutine]()
end

function keyPressed()
    --print("Key: ", keyCode)

    if keyCode == C.VK_RIGHT then
        currentItem = currentItem + 1
        if currentItem > nItems then
            currentItem = 1
        end
    elseif keyCode == C.VK_LEFT then
        currentItem = currentItem - 1
        if currentItem < 1 then
            currentItem = nItems 
        end
    end

    redraw()
end

function keyTyped()
    --print("keyTyped()")
    print("Key: ",key)
    currentRoutine = currentRoutine + 1
    if currentRoutine > nRoutines then
        currentRoutine = 1
    end

    redraw()
end

go({width=1024,height=512})