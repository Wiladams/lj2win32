package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
require("p5")

--[[
    https://p5js.org/examples/simulate-game-of-life.html

    BUGBUG - generate not quite working correctly
]]

local floor = math.floor

local w=8;     -- size of a cell
local columns=0;    -- will be calculated
local rows = 0;     -- will be calculated
local board = nil;  -- will be generated
local next = nil;

-- just for debugging
local function printArray(arr, cols, rows)
    for row=0,rows-1 do
        for col=0,cols-1 do
            io.write(arr[col][row])
            io.write(' ')
        end
        print()
    end
end


-- use ffi parameterized type to create 2D array
local function Array2D(rows, columns)
    local arrtype = ffi.typeof("int[$][$]", columns, rows)
    return arrtype()    -- initialized with all 0
end



-- Fill board randomly
local function init() 
    for i = 0,columns-1 do
        for j = 0, rows-1 do
            -- Lining the edges with 0s
            if (i == 0 or j == 0 or i == columns-1 or j == rows-1) then
                board[i][j] = 0;
            else 
                board[i][j] = floor(random(0,1));
            end
            next[i][j] = 0;
        end
    end
end

-- The process of creating the new generation
local function generate()

    -- Loop through every spot in our 2D array and check spots neighbors
    for x = 1, columns - 2 do
        for y = 1, rows - 2 do
            -- Add up all the states in a 3x3 surrounding grid
            local neighbors = 0;
            for i = -1, 1 do
                for j = -1, 1 do
                    neighbors = neighbors + board[x+i][y+j];
                end
            end

            -- A little trick to subtract the current cell's state since
            -- we added it in the above loop
            neighbors = neighbors - board[x][y];
            --neighborHood[x-1][y-1] = neighbors

            -- Rules of Life
            if      ((board[x][y] == 1) and (neighbors <  2)) then 
                --print("lonely")
                next[x][y] = 0;           -- Loneliness
            elseif ((board[x][y] == 1) and (neighbors >  3)) then 
                --print("over")
                next[x][y] = 0;           -- Overpopulation
            elseif ((board[x][y] == 0) and (neighbors == 3)) then 
                --print("repro")
                next[x][y] = 1;           -- Reproduction
            else            
                --print("stasis")                                 
                next[x][y] = board[x][y]; -- Stasis
            end
        end
    end

    --print("BOARD")
    --printArray(board, columns, rows)
    --print("NEIGHBORHOOD")
    --printArray(neighborHood, columns-2,rows-2)
    -- Swap!
    local temp = board;
    board = next;
    next = temp;
end



function setup()
    -- Calculate columns and rows
    columns = floor(width/w);
    rows = floor(height/w);


    board = Array2D(rows, columns)
    next = Array2D(rows, columns)

    neighborHood = Array2D(rows-2, columns-2)

    init();
    --noLoop()
end

function draw()
    background(255);
    generate();


    for i = 0, columns-1 do
        for j = 0, rows-1 do
            if (board[i][j] == 1) then
                fill(0);
            else 
                fill(255); 
            end

            --print("rect: ", row, column)
            stroke(0);
            rect(i*w, j*w, w-1, w-1);
        end
    end
end

-- reset board when mouse is pressed
function mousePressed() 
  init();
end


go {width = 1024, height=768, title = "Game Of Life"}