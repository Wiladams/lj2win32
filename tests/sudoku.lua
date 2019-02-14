--[[
    program for Sudoku generator
    original Java version: https:--www.geeksforgeeks.org/program-sudoku-generator/
--]]

local ffi = require("ffi")


	-- Random generator 
local function randomGenerator(num) 	
	return math.floor((math.random(1,num))); 
end
    

local Sudoku = {}
setmetatable(Sudoku, {
    __call = function (self, ...)
        return self:init(...)
    end
})
local Sudoku_mt = {
    __index = Sudoku;
}


function Sudoku.init(self, N, K) 
    --print("init: ", N, K)

    -- luajit parameterized type
    local arr = ffi.typeof("int[$][$]", N, N)
    print(arr)  -- ctype<int [9][9]>

    local obj = {
        N = N;      -- number of columns/rows. 
        K = K;      -- No. Of missing digits
        mat = ffi.new(arr)
    }

	-- Compute square root of N 
	obj.SRNd = math.sqrt(N); -- square root of N
    obj.SRN = math.floor(obj.SRNd)

    setmetatable(obj, Sudoku_mt)

    return obj
end

-- Sudoku Generator 
function Sudoku.fillValues(self) 
	-- Fill the diagonal of SRN x SRN matrices 
	self:fillDiagonal(); 

	-- Fill remaining blocks 
	self:fillRemaining(0, self.SRN); 

	-- Remove Randomly K digits to make game 
    self:removeKDigits(); 
end 

-- Fill the diagonal SRN number of SRN x SRN matrices 
function Sudoku.fillDiagonal(self) 

    for i = 0, self.N-1, self.SRN do
		-- for diagonal box, start coordinates->i==j 
		self:fillBox(i, i); 
    end
end

	-- Returns false if given 3 x 3 block contains num. 
function Sudoku.unUsedInBox(self, rowStart, colStart, num) 

	for i = 0, self.SRN-1 do
		for j = 0, self.SRN-1 do
	    	if (self.mat[rowStart+i][colStart+j]==num) then 
                return false; 
            end
        end
    end

	return true; 
end 

-- Fill a 3 x 3 matrix. 
function	Sudoku.fillBox(self, row, col) 
	local num; 
	for i=0, self.SRN-1 do
		for j=0, self.SRN-1 do 
			repeat	
				num = randomGenerator(self.N);  
            until (self:unUsedInBox(row, col, num)) 

			self.mat[row+i][col+j] = num; 
        end
    end
end



	-- Check if safe to put in cell 
function Sudoku.CheckIfSafe(self, i, j, num) 
	return (self:unUsedInRow(i, num) and
		self:unUsedInCol(j, num) and
		self:unUsedInBox(i-i%self.SRN, j-j%self.SRN, num)); 
end

-- check in the row for existence 
function Sudoku.unUsedInRow(self, i, num) 
	for j = 0, self.N-1 do 
		if (self.mat[i][j] == num) then 
            return false; 
        end
    end
    
    return true; 
end

-- check in the row for existence 
function Sudoku.unUsedInCol(self, j, num) 

	for i = 0, self.N-1 do 
			if (self.mat[i][j] == num) then 
                return false; 
            end
    end
    
    return true; 
end 

-- A recursive function to fill remaining 
-- matrix 
function Sudoku.fillRemaining(self, i, j)
	if (j>=self.N and i<self.N-1) then 
		i = i + 1; 
		j = 0; 
    end 

	if i>=self.N and j>=self.N then 
		return true; 
    end

	if (i < self.SRN) then 
		
		if (j < self.SRN) then 
            j = self.SRN;
        end 
		 
	elseif (i < self.N-self.SRN) then 
		
			if j == math.floor(i/self.SRN)*self.SRN then 
                j = j + self.SRN; 
            end
		 
	else
		if (j == self.N-self.SRN) then 
			
			i = i + 1; 
			j = 0; 
			if (i>=self.N) then
                return true;
            end 
        end 
    end

	for num = 1, self.N do
		if self:CheckIfSafe(i, j, num) then 
			self.mat[i][j] = num; 
    
            if (self:fillRemaining(i, j+1)) then 
                return true; 
            end

			self.mat[i][j] = 0; 
        end 
    end

	return false; 
end

-- Remove the K no. of digits to 
-- complete game 
function Sudoku.removeKDigits(self) 

	local count = self.K; 
	while (count ~= 0) do 	
		local cellId = randomGenerator(self.N*self.N); 

		-- print(cellId); 
		-- extract coordinates i and j 
		local i = (cellId/self.N); 
		local j = cellId%9; 
		if (j ~= 0) then 
			j = j - 1; 
        end
            
        -- print(i+" "+j); 
		if (self.mat[i][j] ~= 0) then 		
			count = count - 1; 
    		self.mat[i][j] = 0; 
        end
    end 
end

return Sudoku
