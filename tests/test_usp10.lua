package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

require("win32.sdkddkver")

local unis = require("uniscriber")

--[[
Call ScriptItemize on your input string. This will itentify the “runs” in the string that consist of a single direction of text. Most of the rest of the Uniscribe functions operate on these runs individually, so you’ll have to keep track of them yourself.
Call ScriptLayout to convert your list of runs to the order that they should appear on the screen, from left to right. This allows you to have a sequence of runs that are right to left, embedded in runs that are left to right.
Call ScriptShape with the text of each run to convert it to a series of glyph indices (these are internal references to the font you selected that identifies the glyph to use). One character in the input may be composed of 0, 1, or more than one glyphs.
Call ScriptPlace with the glyph indices of each run to find out where they should be placed relative to each other. After this, you will also be able to measure the width of your run.
Optional: call ScriptJustify to fill the text out to a given width.
Optional: call ScriptCPtoX and ScriptXtoCP as needed to convert between character offsets and pixel positions in a run.
Call ScriptTextOut to draw the placed glyphs on the screen.
--]]

print("SGCM_RTL: ", ffi.C.SGCM_RTL);

local function printChars(chars, count)
    for i=0, count-1 do 
        io.write(string.char(chars[i]));
    end
end

local function printItems(runs)
    print(string.format("== Items[%d] ==", #runs));

    for i=1,#runs do
        print(string.format("pos: %d", ryns[i].position));
    end

end

local function printLayout(layout)
    print("-- LAYOUT --");
    --print("cRuns: ", layout.cRuns);
    print(string.format("visualToLogical: %p", layout.visualToLogical))
    print(string.format("logicalToVisual: %p", layout.logicalToVisual))

    for i=1,#layout.items-1 do
        print(string.format("-- ITEM [%d]--", i))
        print(string.format("      level: %d", layout.levels[i-1]))

        if layout.logicalToVisual then
            print(string.format("   toVisual: %d", layout.logicalToVisual[i-1]))
        end
    end
end







local function test_ScriptItemize()
    -- itemize should return a table of glyph runs, which 
    -- will then need to be layed out, shaped, and placed
    local runs, count, nChars = unis.scriptItemize("Hello, World");
    if not runs then
        print("scriptItemize failed: ", count)
        return false;
    end

    printItems(runs)
end

local function test_Layout()
    print("==== test_LayoutAndShape ====")

    -- First itemize
    local items, count, nChars = unis.scriptItemize("Hello, World");
    if not items then
        print("scriptItemize failed: ", count)
        return false;
    end

    -- Do Layout
    local layout, err = unis.scriptLayout(items);
    if not layout then
        print("scriptLayout ERROR: ", err)
        return false;
    end

    printLayout(layout);

end

local function test_Shape()
    print("==== test_ShapeAndPlace ====")
    
    -- First itemize
    local paragraph = "Hello, World";
    local items, count, nChars = unis.scriptItemize(paragraph);
    if not items then
        print("scriptItemize failed: ", count)
        return false;
    end

    -- do layout
    local layout, err = unis.scriptLayout(items)

    if not layout then
        print("scriptLayout failed: ", err);
        return false;
    end

    -- Then Shape, figure out which glyphs to use for each run
    local arun, err = unis.scriptShape(items)
    if not arun then
        print(string.format("scriptShape error: %d", err));
        return false;
    end

end





--test_ScriptItemize();
--test_Layout();
test_Shape();
--test_ShapeAndPlace()