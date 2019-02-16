package.path = "../?.lua;"..package.path;

require("p5")

local Sudoku = require("sudoku")
local cellWidth = 40
local cellHeight = 40
local gridWidth = cellWidth * 9
local gridHeight = cellHeight * 9


local game = Sudoku(9, 30)

function drawGrid()
    -- vertical lines
    StrokeWidth = 2;
    stroke(0,0xff, 0xff)
    for column=1,8 do
        line(column*cellWidth, 0, column*cellWidth, gridHeight)
    end
    
    -- horizontal lines
    for row=1,8 do
        line(0,row*cellHeight, gridWidth, row*cellHeight)
    end
    
    -- group lines
    StrokeWidth = 4;
    stroke(0xff,0, 0)
    for column=1,2 do
        line(column*cellWidth*3, 0, column*cellWidth*3, gridHeight)
    end
    
    for row=1,2 do
        line(0,row*cellHeight*3, gridWidth, row*cellHeight*3)
    end
end

local function drawGame()
    textSize(36)
    textAlign(CENTER, CENTER)
    local xoffset = (cellWidth - 36) + 8

    for i = 0, game.N-1 do 
        for j = 0, game.N-1 do
            --print(i,j,game.mat[i][j])
            if game.mat[i][j] ~= 0 then
                local y = cellHeight * i
                local x = cellWidth * j + xoffset
                text(tostring(game.mat[i][j]), x, y)
            end 
        end
    end
end

function setup()
    background(0, 0xCC, 0xff)
    --cellWidth = width / 9
    --cellHeight = height / 9

    drawGrid()
    drawGame()
end


go({width=gridWidth + 200, height=gridHeight + 40, title="Sudoku"});
