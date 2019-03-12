package.path = "../?.lua;"..package.path;

require("p5")

local ffi = require("ffi")
local C = ffi.C 

-- A list of images to be loaded
-- The names here match the actual filenames 
-- without the .tga extension
local imageList = {
    "rgb_a_UL",
    "rgb_a_UR",
    "rgb_a_LL",
    "rgb_a_LR",

    "rgb_UL",
    "rgb_UR",
    "rgb_LL",
    "rgb_LR",

    "grayscale_UL",
    "grayscale_UR",
    "grayscale_LL",
    "grayscale_LR",

    "grayscale_a_UL",
    "grayscale_a_UR",
    "grayscale_a_LL",
    "grayscale_a_LR",

    "indexed_UL",
    "indexed_UR",
    "indexed_LL",
    "indexed_LR",

    "ctc16",
    "ctc24",
    "ctc32",

    "cbw8",
    "ccm8",

    "ubw8",
    "ucm8",

    "utc16",
    "utc24",
    "utc32",


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

local function loadImages(imageList)
    for _, name in ipairs(imageList) do 
        local img = loadImage(string.format("images\\tga\\%s.tga", name))
        _G[name] = img
        --print("LOADING: ", name, img)
    end

    return true;
end

loadImages(imageList)


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
--[[
    ubw8,
    ucm8,
--]]

--[[
    cbw8,
    ccm8,
--]]

--[[
    utc16,
    utc24,
    utc32,
--]]

--[[
    ctc16,
    ctc24,
    ctc32,
--]]

--[[
    grayscale_a_UL,
    grayscale_a_UR,
    grayscale_a_LL,
    grayscale_a_LR,
--]]

--[[
    grayscale_UL,
    grayscale_UR,
    grayscale_LL,
    grayscale_LR,
--]]

--[[
    indexed_UL,
    indexed_UR,
    indexed_LL,
    indexed_LR,
--]]

    MARBLES,

---[[
    FLAG_B16,
    FLAG_B24,
    FLAG_B32,
    FLAG_T16,
    FLAG_T32,
--]]

---[[
    XING_B16,
    XING_B24,
    XING_B32,
    XING_T16,
    XING_T24,
    XING_T32
--]]

--[[
    rgb_UL,
    rgb_UR,
    rgb_LL,
    rgb_LR,
--]]

--[[
    rgb_a_UL,
    rgb_a_UR,
    rgb_a_LL,
    rgb_a_LR,
--]]
}
local nItems = #playlist
local currentItem = 1


local function drawPlaylist()
--print("drawPlaylist: ", currentItem, playlist[currentItem])
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

go({width=1920,height=1080})
--go()