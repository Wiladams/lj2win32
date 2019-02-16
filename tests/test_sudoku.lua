local Sudoku = require("Sudoku")

-- Print sudoku 
local function printSudoku(sud) 

	for i = 0, sud.N-1 do 
		for j = 0, sud.N-1 do 
            io.write(sud.mat[i][j], " "); 
        end
		print(); 
    end
    print();
end 

local function main() 
    local N = 9
    local K = 20; 
	sud = Sudoku(N, K); 
	sud:fillValues(); 
	printSudoku(sud); 
end

main()
