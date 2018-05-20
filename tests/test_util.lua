package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

require("win32.util")
local util = ffi.C


local function main()

    -- ascending pitch beep
    for i=37, 32768 do
        util.Beep (i,100);
    end

    -- descending pitch beep
    --for i=3000, 1, -10 do
    --   util.Beep (i,100);
    --    i = i - 10;
    --end

end

util.Beep(16384, 1000)
--main();
