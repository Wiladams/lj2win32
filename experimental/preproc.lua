local stdout = io.stdout
local format = string.format
local write = io.write

-- pass through lines that start with '#'
local function processLine(aline)
    local str, nreps = string.gsub(aline, "#define", "static const int", 1)
    if nreps < 1 then
        return nil;
    end

    return str
end

local function processFile(fp)
    -- run over lines
    for line in fp:lines() do
        local newline = processLine(line)
        if newline then
            print(newline)
        end
    end
end


-- oppen file
local filename = select(1,...)

if not filename then 
    print("Usage: luajit preproc.lua <filename>")
    return false;
end

local fp, err = io.open(filename)
if not fp then
    write(format("====== ERROR: %s: %s\n", filename, err))
end

processFile(fp)
fp:close()

