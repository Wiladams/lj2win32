require("win32.wingdi")
local usp = require("win32.usp10")
local unic = require("unicode_util")

local exports = {}

--[[
    scriptItemize
    Take a simple string and divide it into a number
    of items.  Each item is a run of characters that have
    the same style and direction.
--]]
function exports.scriptItemize(str)
    local pwcInChars, cInChars = unic.toUnicode("Hello, World")
    local cMaxItems = math.floor((1.5*cInChars)+16);
    local psControl = ffi.new("SCRIPT_CONTROL");
    local psState = ffi.new("SCRIPT_STATE");
    local pItems = ffi.new("SCRIPT_ITEM[?]", cMaxItems+1);
    local pcItems = ffi.new("int[1]");

    local res = usp.ScriptItemize(pwcInChars, cInChars,
        cMaxItems,psControl,psState,
        pItems,pcItems);

    local success = (res == 0);

    if not success then
        return false, res;
    end

    -- There's a trick here.  Even though pcItems[0] contains
    -- the number of items, the ScriptItemize() function put one
    -- more entry in there with a position at the end of the string
    -- so, you have to include that last item as well if you want
    -- to have a uniform way of knowing the length of each run.
    local results = {}
    for i=0,pcItems[0] do
        table.insert(results, {position = pItems[i].iCharPos, analysis = pItems[i].a})
    end


    return results
end

--[[
HRESULT  ScriptLayout(
    int                             cRuns,                  // In   Number of runs to process
    const BYTE    *pbLevel,               // In   Array of run embedding levels
    int *piVisualToLogical,     // Out  List of run indices in visual order
    int *piLogicalToVisual);    // Out  List of visual run positions
--]]
function exports.scriptLayout(items)
    local cRuns = #items;
    local pbLevel = ffi.new("BYTE[?]", cRuns);    -- start with left to right bias
    
    -- We're going to do only the logicalToPhysical
    --local piVisualToLogical = ffi.new("int[?]", cRuns);
    local piVisualToLogical = nil
    local piLogicalToVisual = ffi.new("int[?]", cRuns);


    -- Setup the directions
    for i=1,cRuns-1 do
        local value = items[i].analysis.s.uBidiLevel;
        print("bidi: ", value)
        pbLevel[i-1] = value;
    end

    local res = usp.ScriptLayout(cRuns-1, pbLevel, piVisualToLogical, piLogicalToVisual);

    if not (res == 0) then
        return false, res;
    end

    return {
        items = items;
        levels = pbLevel;
        visualToLogical = piVisualToLogical;
        logicalToVisual = piLogicalToVisual;
    }
end

--[[
    HRESULT  ScriptShape(
    HDC  hdc,            // In    Optional (see under caching)
    SCRIPT_CACHE  *psc,           // InOut Cache handle
    const WCHAR   *pwcChars,      // In    Logical unicode run
    int           cChars,         // In    Length of unicode run
    int           cMaxGlyphs,     // In    Max glyphs to generate
    SCRIPT_ANALYSIS                      *psa,           // InOut Result of ScriptItemize (may have fNoGlyphIndex set)
    WORD             *pwOutGlyphs,   // Out   Output glyph buffer
    WORD                           *pwLogClust,    // Out   Logical clusters
    SCRIPT_VISATTR   *psva,          // Out   Visual glyph attributes
    int                                     *pcGlyphs);     // Out   Count of glyphs generated
]]

local exports.scriptShape(aRun)
    glyphRun.cache = aRun.cache or ffi.new("SCRIPT_CACHE[1]")
    local pwcChars = aRun.chars;    -- the actual characters
    local cChars = aRun.nChars;
    local cMaxGlyphs = 256;
    local pwOutGlyphs = ffi.new("WORD[?]", cMaxGlyphs)
    local pwLogClust = ffi.new("WORD[?]", cMaxGlyphs)
    local psva = ffi.new("SCRIPT_VISATTR")
    local pcGlyphs = ffi.new("int[1]")

    -- The hdc must already have the intended font selected
    local res = usp.ScriptShape(hdc, psc,
        pwcChars,cChars,cMaxGlyphs,psa,
        pwOutGlyphs,pwLogClust,psva,pcGlyphs);

    if res ~= 0 then
        return false, res;
    end

    -- We have shaped the glyphRun
    -- pack it in a table and return it.
    return aRun;
end


return exports
