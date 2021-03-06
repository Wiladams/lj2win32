--[[
    This file is a general memory stream interface.
    The primary objective is to satisfy the needs of the 
    truetype parser, but it can be used in general cases.

    It differs from the MemoryStream object in that it can't
    write, and it has more specific data type reading 
    convenience calls.

    More specifically, all of the numeric reading assumes the
    data in the stream is formatted in 'big-endian' order.  That
    is, the high order bytes come first.
]]
local ffi = require("ffi")
local bit = require("bit")
local bor, lshift = bit.bor, bit.lshift
local min = math.min

--[[
    Standard 'object' construct.
    __call is implemented so we get a 'constructor'
    sort of feel:
    binstream(data, size, position)
]]
local binstream = {
    bigend = true;
}
setmetatable(binstream, {
		__call = function(self, ...)
		return self:new(...)
	end,
})

local binstream_mt = {
	__index = binstream;
}


function binstream.init(self, data, size, position, littleendian)
    position = position or 0
--print("SIZE: ", data, size, position, littleendian)
    assert(size > 0);

    local obj = {
        bigend = not littleendian;
        data = data;
        size = tonumber(size);
        cursor = tonumber(position);
    }
 
    setmetatable(obj, binstream_mt)
    return obj
end

function binstream.new(self, data, size, position, littleendian)
    return self:init(data, size, position, littleendian);
end

-- get a subrange of the memory stream
-- returning a new memory stream
function binstream.range(self, size, pos)
    pos = pos or self.cursor;

    if pos < 0 or size < 0 then
        return false, "pos or size < 0"
    end

    if pos > self.size then
        return false, "pos > self.size"
    end

    if size > self:remaining() then 
        -- truncate
        size = self:remaining()
        --return false, "size is greater than remainder";
    end

    return binstream(self.data+pos, size, 0 , not self.bigend)
end

-- report how many bytes remain to be read
-- from stream
function binstream.remaining(self)
    return tonumber(self.size - self.cursor)
end

function binstream.EOF(self)
    return self:remaining() < 1
end

 -- move to a particular position, in bytes
function binstream.seek(self, pos)
    -- if position specified outside of range
    -- just set it past end of stream
    if (pos > self.size)  or (pos < 0) then
        self.cursor = self.size
        return false, self.cursor;
    else
        self.cursor = tonumber(pos);
    end
 
    return true;
end


-- Report the current cursor position.
function binstream.tell(self)
    return self.cursor;
end


-- move the cursor ahead by the amount
-- specified in the offset
-- seek, relative to current position
function binstream.skip(self, offset)
    --print("SKIP: ", offset)
     return self:seek(self.cursor + offset);
end

-- Seek forward to an even numbered byte boundary
-- This could be expanded to seek to next highest
-- alignment, based on any number, defaulting to 2
function binstream.skipToEven(self)
    self:skip(self.cursor % 2);
end

function binstream.alignTo(self, num)
    self:skip(self.cursor % num)
end

function binstream.getPositionPointer(self)
    return self.data + self.cursor;
end

-- get 8 bits, and don't advance the cursor
function binstream.peekOctet(self)
    if (self.cursor >= self.size) then
        return false;
    end

    return self.data[self.cursor];
end



-- get 8 bits, and advance the cursor
function binstream.readOctet(self)
    --print("self.cursor: ", self.cursor, self.size)
    if (self.cursor >= self.size) then
       return false, "EOF";
    end

    self.cursor = self.cursor + 1;
    
    return self.data[self.cursor-1]
 end
 


-- Read an integer value
-- The parameter 'n' determines how many bytes to read.
-- 'n' can be up to 8 
-- The routine will deal with big or little endian

function binstream.read(self, n)
    local v = 0;
    local i = 0;

    if self:remaining() < n then
        return false, "NOT ENOUGH DATA AVAILABLE"
    end

    if self.bigend then
        while  (i < n) do
            v = bor(lshift(v, 8), self:readOctet());
            i = i + 1;
        end 
    else
        while  (i < n) do
            v = bor(v, lshift(self:readOctet(), 8*i));
            i = i + 1;
        end 
    end

    return v;
end



-- BUGBUG, do error checking against end of stream
function binstream.readBytes(self, n, bytes)
    if n < 1 then 
        return false, "must specify more then 0 bytes" 
    end

    -- see how many bytes are remaining to be read
    local nActual = min(n, self:remaining())
    -- read the minimum between remaining and 'n'
    bytes = bytes or ffi.new("uint8_t[?]", nActual)
    local ptr = self.data+self.cursor
    ffi.copy(bytes, ptr, nActual)
    self:skip(nActual)

    -- if minimum is less than n, return false, and the number
    -- actually read
    if nActual < n then
        return false, nActual;
    end

    return bytes, nActual;
end

function binstream.readByteBuffer(self, n, buff)
    --print("readByteBuffer, BEGIN: ", n, buff)
    if not buff or n < 1 then 
        return false, "must specify more then 0 bytes" 
    end
    --print("readByteBuffer, 1.0: ")

    -- see how many bytes are remaining to be read
    local nActual = min(n, self:remaining())
    --print("readByteBuffer, 2.0: ")
    -- read the minimum between remaining and 'n'
    local ptr = self.data+self.cursor
    --print("readByteBuffer, 3.0: ", ptr, nActual)
    ffi.copy(buff, ptr, nActual)
    --print("readByteBuffer, 4.0: ")
    self:skip(nActual)
    --print("readByteBuffer, 4.0: ")

    -- if nActual is less than n, return nActual
    if nActual < 1 then
        return false, "EOF"
    end

    --print("readByteBuffer, END")

    return nActual
end


-- Read bytes and turn into a Lua string
-- Read up to 'n' bytes, or up to a '\0' if
-- 'n' is not specified.
function binstream.readString(self, n)
    local str = nil;

    --print("BS: ", self:remaining())
    if self:EOF() then
        return false, "EOF"
    end

    if not n then
        -- read to null terminator

        str = ffi.string(self.data+self.cursor)
        --print("binstream, STR: ", str)
        self.cursor = self.cursor + #str + 1;
    else
        -- read a specific number of bytes, turn into Lua string
        str = ffi.string(self.data+self.cursor, n)
        self.cursor = self.cursor + n;
    end

    return str;
end



function binstream.readNumber(self, n)
    return tonumber(self:read(n));
end


-- Read 8-bit signed integer
function binstream.readInt8(self)
    return tonumber(ffi.cast('int8_t', self:read(1)))
end

-- Read 8-bit unsigned integer
function binstream.readUInt8(self)
    return tonumber(ffi.cast('uint8_t', self:read(1)))
end

-- Read 16-bit signed integer
function binstream.readInt16(self)
    return tonumber(ffi.cast('int16_t', self:read(2)))
end

-- Read 16-bit unsigned integer
function binstream.readUInt16(self)
    return tonumber(ffi.cast('uint16_t', self:read(2)))
end

-- Read Signed 32-bit integer
function binstream.readInt32(self)
    return tonumber(ffi.cast('int32_t', self:read(4)))
end

-- Read unsigned 32-bit integer
function binstream.readUInt32(self)
    return tonumber(ffi.cast('uint32_t', self:read(4)))
end

-- Read signed 64-bit integer
function binstream.readInt64(self)
    return tonumber(ffi.cast('int64_t', self:read(8)))
end



-- Read unsigned 64-bit integer
-- we don't convert to a lua number because those
-- can't actually represent the full range of a 64-bit integer
function binstream.readUInt64(self)
    local v = 0ULL;
    --ffi.cast("uint64_t", 0);
    local i = 0;

    if self.bigend then
        while  (i < 8) do
            v = bor(lshift(v, 8), self:readOctet());
            i = i + 1;
        end 
    else
        while  (i < 8) do
            local byte = ffi.cast("uint64_t",self:readOctet());
            local shifted = lshift(byte, 8*i)
            v = bor(v, lshift(byte, 8*i));
            i = i + 1;
        end 
    end

    return v;
end

--[[
    Writing to a binary stream
]]
function binstream.writeOctet(self, octet)
    if (self.cursor >= self.size) then
        return false, "EOF";
    end

    self.data[self.cursor] = octet;
    self.cursor = self.cursor + 1;

    return true;
end

function binstream.writeInt(self, value, n)


    if self:remaining() < n then
        return false, "NOT ENOUGH DATA AVAILABLE"
    end

    if self.bigend then
        local i = n-1;
        while  (i >= 0) do
            self:writeOctet(band(rshift(value,i*8), 0xff))
            i = i - 1;
        end 
    else
        local i = 0;
        while  (i < n) do
            self:writeOctet(band(rshift(value,i*8), 0xff))
            i = i + 1;
        end 
    end

    return v;
end

function binstream.writeBytes(self, bytes, n)
    n = n or #bytes
    if n > self:remaining() then 
        return false, "Not enough space"
    end

    ffi.copy(self.data+self.cursor, ffi.cast("const char *", bytes, n))
    self:skip(n)

    return true;
end

function binstream.writeString(self, str)
    return self:writeBytes(str)
end

function binstream.writeInt8(self, n)
    return self:writeInt(n, 1);
end

function binstream.writeUInt8(self, n)
    return self:writeInt(ffi.cast("uint8_t",n), 1)
end

function binstream.writeInt16(self, n)
    return self:writeInt(ffi.cast("int16_t",n), 2);
end

function binstream.writeUint16(self, n)
    return self:writeInt(ffi.cast("uint16_t",n), 2);
end

function binstream.writeInt32(self, n)
    return self:writeInt(ffi.cast("int32_t",n), 4);
end

function binstream.writeUInt32(self, n)
    return self:writeInt(ffi.cast("uint32_t",n), 4);
end

function binstream.writeInt64(self, n)
    return self:writeInt(ffi.cast("int64_t",n), 8);
end

function binstream.writeUInt64(self, n)
    return self:writeInt(ffi.cast("uint64_t",n), 8);
end

-- Some various fixed formats
function binstream.readFixed(self)
    local decimal = self:readInt16();
    local fraction = self:readUInt16();

    return decimal + fraction / 65535;
end

function binstream.readF2Dot14(self)
    return self:readInt16() / 16384;
end



-- Convenient types named in the documentation
binstream.readFWord = binstream.readInt16;
binstream.readUFWord = binstream.readUInt16;
binstream.readOffset16 = binstream.readUInt16;
binstream.readOffset32 = binstream.readUInt32;
binstream.readWORD = binstream.readUInt16;
binstream.readDWORD = binstream.readUInt32;
binstream.readBYTE = binstream.readOctet;

return binstream