package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

require("win32.sdkddkver")
require("win32.wingdi")
local unic = require("unicode_util")

--[[
Call ScriptItemize on your input string. This will itentify the “runs” in the string that consist of a single direction of text. Most of the rest of the Uniscribe functions operate on these runs individually, so you’ll have to keep track of them yourself.
Call ScriptLayout to convert your list of runs to the order that they should appear on the screen, from left to right. This allows you to have a sequence of runs that are right to left, embedded in runs that are left to right.
Call ScriptShape with the text of each run to convert it to a series of glyph indices (these are internal references to the font you selected that identifies the glyph to use). One character in the input may be composed of 0, 1, or more than one glyphs.
Call ScriptPlace with the glyph indices of each run to find out where they should be placed relative to each other. After this, you will also be able to measure the width of your run.
Optional: call ScriptJustify to fill the text out to a given width.
Optional: call ScriptCPtoX and ScriptXtoCP as needed to convert between character offsets and pixel positions in a run.
Call ScriptTextOut to draw the placed glyphs on the screen.
--]]
--print("typeof: ABC => ", ffi.typeof("ABC"));

local usp = require("win32.usp10")



print("SGCM_RTL: ", ffi.C.SGCM_RTL);

local function printChars(chars, count)
    for i=0, count-1 do 
        io.write(string.char(chars[i]));
    end
end

local function printItems(items, count)
    for i=0,count-1 do
        print(string.format("pos: %d", items[i].iCharPos));
    end

end

--[[
    scriptItemize
    Take a simple string and divide it into a number
    of items.  Each item is a run of characters that have
    the same style and direction.
--]]
local function scriptItemize(str)
    local pwcInChars, cInChars = unic.toUnicode("Hello, World")
    local cMaxItems = math.floor((1.5*cInChars)+16);
    local psControl = ffi.new("SCRIPT_CONTROL");
    local psState = ffi.new("SCRIPT_STATE");
    local pItems = ffi.new("SCRIPT_ITEM[?]", cMaxItems);
    local pcItems = ffi.new("int[1]");

    local res = usp.ScriptItemize(pwcInChars, cInChars,
        cMaxItems,psControl,psState,
        pItems,pcItems);

    local success = (res == 0);

    if not success then
        return false, res;
    end

    return pItems, pcItems[0];
end

--[[
HRESULT  ScriptLayout(
    int                             cRuns,                  // In   Number of runs to process
    const BYTE    *pbLevel,               // In   Array of run embedding levels
    int *piVisualToLogical,     // Out  List of run indices in visual order
    int *piLogicalToVisual);    // Out  List of visual run positions
--]]
local function scriptLayout()
end

local function test_ScriptItemize()
    items, count = scriptItemize("Hello, World");
    if not items then
        print("scriptItemize failed: ", count)
        return false;
    end

    printItems(items, count)

    -- free items
end

local function test_unicode()
    local pwcInChars, cInChars = unic.toUnicode("Hello, World")
    print("cInChars: ", cInChars);


    for i=0, cInChars-1 do 
        print("char: ", string.char(pwcInChars[i]));
    end
end

test_ScriptItemize();
--test_unicode();