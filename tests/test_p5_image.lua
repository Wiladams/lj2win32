package.path = "../?.lua;"..package.path;

require("p5")

local ffi = require("ffi")
local C = ffi.C 

local function loadImages(imageList)
    for _, name in ipairs(imageList) do 
        _G[name] = loadImage(string.format("images\\%s.tga", name))
    end

    return true;
end

local imageList = {
    "rgba_UL",
    "rgba_UR",
    "rgba_LL",
    "rgba_LR",

    "grayscale_UL",
    "grayscale_UR",
    "grayscale_LL",
    "grayscale_LR",

    "indexed_UL",
    "indexed_UR",
    "indexed_LL",
    "indexed_LR",

    "ctc24",
    "ctc32",
    "utc24",
    "utc32",
    "ubw8",

    "FLAG_B16",
    "FLAG_B24",
    "FLAG_B32",
    "FLAG_T16",
    "FLAG_T32",

    "XING_B16",
    "XING_B24",
    "XING_B32",
    "XING_T16",
    "XING_T24",
    "XING_T32",

    "MARBLES"
}


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


local playlist = {
    --ubw8,
    
    --utc24,
    --utc32,
    
    ctc24,
    ctc32,

    indexed_ul,
    indexed_ur,
    indexed_ll,
    indexed_lr,
---[[
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
    --]]
    XING_T32
}
local nItems = #playlist
local currentItem = 1


local function drawPlaylist()
    image(playlist[currentItem],0,0)
end

local drawRoutines = {
--    drawOrientation,
--    drawGrays,
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