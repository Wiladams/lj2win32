local PixelBuffer = require("PixelBuffer")

local pb = PixelBuffer(header.Width, header.Height)

local DrawingCanvas = {}
local DrawingCanvas_mt = {
    __index = DrawingCanvas;
}

function DrawingCanvas.init(self, width, height, x, y)
    x = x or 0
    y = y or 0

    local obj = {
        x = x;
        y = y;
        pixelBuff = PixelBuffer(width, height)
    }
    setmetatable(obj, DrawingCanvas_mt)

    return obj
end

function DrawingCanvas.draw(self)
    image(self.pixelBuff, self.x, self.y)
end
