--[[
    How to read Windows '.fnt' format for font information

    .fon files are PE executables with font resources inside.  Those resources
    use the .fnt format.

    In order to go from a .fon to a .fnt, you'll need to parse the .fon using 
    a PE parser, then parse the .fnt stuff from there.

-- Ancient documentation
http://www.os2museum.com/files/docs/win10sdk/windows-1.03-sdk-prgref-1986.pdf
page 435
--]]


local function readFNT(bs, res)
    local res = res or {}

    res.Version = bs:readUInt16();
    res.Size = bs:readUInt32();
    res.Copyright = bs:readString(60);
    res.Type = bs:readUInt16();
    res.Points = bs:readUInt16();
    res.VertRes = bs:readUInt16();
    res.HorizRes = bs:readUInt16();
    res.Ascent = bs:readUInt16();
    res.InternalLeading = bs:readUInt16();
    res.ExternalLeading = bs:readUInt16();
    res.Italic = bs:readUInt8();
    res.Underline = bs:readUInt8();
    res.StrikeOut = bs:readUInt8();
    res.Weight = bs:readUInt8();
    res.CharSet = bs:readUInt8();
    res.PixWidth = bs:readUInt16();
    res.PixHeight = bs:readUInt16();
    res.PitchAndFamily = bs:readUInt8();
    res.AvgWidth = bs:readUInt16();
    res.MaxWidth = bs:readUInt16();
    res.FirstChar = bs:readUInt8();
    res.LastChar = bs:readUInt8();
    res.DefaultChar = bs:readUInt8();
    res.BreakChar = bs:readUInt8();
    res.WidthBytes = bs:readUInt16();
    res.Device = bs:readUInt32();
    res.Face = bs:readUInt32();
    res.BitsPointer = bs:readUInt32();
    res.BitsOffset = bs:readUInt32();
    res.CharOffset = bs:readUInt16();
    res.Facename = bs:readString();
    res.DeviceName = bs:readString();

    -- create an array of actual bitmaps
    -- res.bitmaps = bs:readBytes(some number of bytes);
    return res
end


return readFNT