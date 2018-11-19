package.path = "../?.lua;"..package.path;

require("p5")

--[[
    https://p5js.org/examples/simulate-game-of-life.html

    BUGBUG - generate not quite working correctly
]]

local floor = math.floor

local w=0;
local columns=0;
local rows = 0;
local board = false;
local next = false;

-- Wacky way to make a 2D array is Lua
local function make2DArray(nRows, nCols)
    local arr = {}

    for i=1,nRows do
        arr[i]={}
        for j=1,nCols do
            arr[i][j] = 0;
        end
    end

    return arr
end

-- Fill board randomly
local function init() 
    --print("init, rows-cols: ", rows, columns)

    for row = 1,rows do
        for column = 1, columns do
            -- Lining the edges with 0s
            if (row == 1 or column == 1 or row == rows or j == columns) then
                board[row][column] = 0;
            else 
                board[row][column] = floor(random(2));
            end
            next[row][column] = 0;
        end
    end
end

-- The process of creating the new generation
local function generate() 

    -- Loop through every spot in our 2D array and check spots neighbors
    for x = 2, columns - 1 do
        for y = 2, rows - 1 do
            -- Add up all the states in a 3x3 surrounding grid
            local neighbors = 0;
            for i = -1, 1 do
                for j = -1, 1 do
                    neighbors = neighbors + board[y+j][x+i];
                end
            end

            -- A little trick to subtract the current cell's state since
            -- we added it in the above loop
            neighbors = neighbors - board[y][x];

            -- Rules of Life
            if      ((board[y][x] == 1) and (neighbors <  2)) then 
                --print("lonely")
                next[y][x] = 0;           -- Loneliness
            elseif ((board[y][x] == 1) and (neighbors >  3)) then 
                --print("over")
                next[y][x] = 0;           -- Overpopulation
            elseif ((board[y][x] == 0) and (neighbors == 3)) then 
                --print("repro")
                next[y][x] = 1;           -- Reproduction
            else                                             
                next[y][x] = board[y][x]; -- Stasis
            end
        end
    end

    -- Swap!
    local temp = board;
    board = next;
    next = temp;
end


function setup()
  --createCanvas(720, 400);
    w = 20;
    
    -- Calculate columns and rows
    columns = floor(width/w);
    rows = floor(height/w);


    board = make2DArray(rows, columns)
    next = make2DArray(rows, columns)

    init();
end

function draw()
    background(255);
    generate();

    --print("draw, rows;cols: ", rows, columns)

    for row = 1, rows do
        for column = 1, columns do
            if (board[row][column] == 1) then
                fill(0);
            else 
                fill(255); 
            end

            --print("rect: ", row, column)
            stroke(0);
            rect((column-1)*w, (row-1)*w, w-1, w-1);
        end
    end
end

-- reset board when mouse is pressed
function mousePressed() 
  init();
end





go {width = 720, height=400, title = "Game Of Life"}