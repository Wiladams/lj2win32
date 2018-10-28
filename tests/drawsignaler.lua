--[[
-- these should go into a utility library
-- Math
double dist(int x1, int y1, int x2, int y2);
double randomRange(low, high);
double random(high);
inline double sq(const double value) { return value*value; }
--]]


local exports = {}

-- List of all the signals we can give
local marshalers = {
    backgroundValues = function(v1, v2, v3, alpha) return {command = 'backgroundValues', params={v1=v1, v2=v2, v3=v3, alpha=alpha}} end;
    background = function(value) return {command='background', params={value = value}} end;
    clear = function() return {command='clear'} end;
    colorMode = function(mode, max1, max2, max3, maxA) return {command='colorMode', params={mode=mode,max1=max1,max2=max2,max3= max3, maxA = maxA}} end;

    noFill = function() return {command='noFill'} end;
}

-- Setting colors
--[[
function exports.colorMode(mode, max1, max2, max3, maxA)
    signalAll('draw_colorMode', {command='colorMode', params={mode = mode, max1=max1, max2=max2, maxA=maxA}})
end
--DPPIXELVAL color(v1, v2 = -1, v3 = -1, alpha = -1);

function exports.backgroundValues(v1, v2, v3, alpha)
    signalAll('draw_backgroundValues', {command='backgroundValues', params={v1=v1, v2=v2,v3=v3,alpha=alpha}})
end


function exports.background(value)
    signalAll('draw_background', {command='background', params={value=value}})
end
--]]

function exports.backgroundImage(image)
    signalAll('draw_backgroundImage', {command = 'backgroundImage', image = image});
end

--[[
function exports.clear()
    print("CLEAR")
    signalAll('draw_clear', {command='clear'})
end
--]]

--function exports.colorMode();
--[[
    function exports.noFill()
    signalAll('draw_noFill', {command='noFill'})
end
--]]

function exports.fillValues(v1, v2, v3, alpha)
    signalAll('draw_fillValues', {command='fillValues', params={v1=v1,v2=v2,v3=v3,alpha=alpha}})
end

function exports.fill(value)
    signalAll('draw_fill', {command='fill', params={value=value}})
end

function exports.noStroke()
    signalAll('draw_noStroke', {command='noStroke'})
end

function exports.stroke(value)
    signalAll('draw_stroke', {command='stroke'})
end

function exports.strokeValues(v1, v2, v3, alpha)
    signalAll('draw_strokeValues', {command='strokeValues'})
end

-- attributes
function exports.ellipseMode(mode)
    signalAll('draw_ellipseMode', {command='ellipseMode'})
end

function exports.noSmooth()
    signalAll('draw_noSmooth', {command='noSmooth'})
end

function exports.rectMode(mode)
    signalAll('draw_rectMode', {command='rectMode'})
end

function exports.smooth()
    signalAll('draw_smooth', {command='smooth'})
end

function exports.strokeCap()
    signalAll('draw_strokeCap', {command='strokeCap'})
end

function exports.strokeJoin()
    signalAll('draw_strokeJoin', {command='strokeJoin'})
end

function exports.strokeWeight(weight)
    signalAll('draw_strokeWeight', {command='strokeWeight'})
end


-- 2D primitives
function exports.bezier(x1, y1, x2, y2, x3, y3, segments)
    signalAll('draw_bezier', {command='bezier'})
end

function exports.ellipse(a, b, c, d)
    signalAll('draw_ellipse', {command='ellipse'})
end

function exports.line(x1, y1, x2, y2)
    signalAll('draw_line', {command='line'})
end

function exports.lineloop(nPtr, pts)
    signalAll('draw_lineloop', {command='lineloop'})
end

function exports.point(x, y)
    signalAll('draw_point', {command='point'})
end

function exports.rect(a, b, c, d)
    signalAll('draw_rect', {command='rect'})
end

function exports.quad(x1, y1, x2, y2, x3, y3, x4, y4)
    signalAll('draw_quad', {command='quad'})
end

function exports.triangle(x1, y1, x2, y2, x3, y3)
    signalAll('draw_triangle', {command='triangle'})
end

function exports.polygon(nverts, a)
    signalAll('draw_polygon', {command='polygon'})
end

-- Text

-- createFont
-- loadFont()
function exports.setFont(fontdata)
    signalAll('draw_setFont', {command='setFont'})
end

function exports.text(str, x, y)
    signalAll('draw_text', {command='text'})
end

--function exports.textFont(font_t *font);
function exports.textAlign(alignX, alignY)
    signalAll('draw_textAlign', {command='textAlign'})
end

-- textLeading()
-- textMode()
function exports.textSize(size)
    signalAll('draw_textSize', {command='textSize'})
end

-- textWidth()
-- textAscent()
-- textDescent()

-- Shape
function exports.beginShape(shapeKind)
    signalAll('draw_beginShape', {command='beginShape'})
end

function exports.vertex(x, y)
    signalAll('draw_vertex', {command='vertex'})
end

function exports.bezierVertex(x1, y1, x2, y2, x3, y3)
    signalAll('draw_bezierVertex', {command='bezierVertex'})
end

function exports.endShape(kindOfClose)
    signalAll('draw_endShape', {command='endShape'})
end

-- Images
function exports.image(img, a, b, c, d)
    signalAll('draw_image', {command='image'})
end

--[[
PSD loadImage(filename, extension)
end
--]]

-- Coordinate transformation
function exports.applyMatrix()
    signalAll('draw_applyMatrix', {command='applyMatrix'})
end

function exports.popMatrix()
    signalAll('draw_popMatrix', {command='popMatrix'})
end

function exports.printMatrix()
    signalAll('draw_printMatrix', {command='printMatrix'})
end

function exports.pushMatrix()
    signalAll('draw_pushMatrix', {command='pushMatrix'})
end

function exports.resetMatrix()
    signalAll('draw_resetMatrix', {command='resetMatrix'})
end

function exports.rotate(angle, x, y, z)
    signalAll('draw_rotate', {command='rotate'})
end

function exports.rotateX(anglex)
    signalAll('draw_rotateX', {command='rotateX'})
end

function exports.rotateY(angley)
    signalAll('draw_rotateY', {command='rotateY'})
end

function exports.rotateZ(anglez)
    signalAll('draw_rotateZ', {command='rotateZ'})
end

function exports.scale(a, b, c)
    signalAll('draw_scale', {command='scale'})
end

function exports.shearX()
    signalAll('draw_shearX', {command='shearX'})
end

function exports.shearY()
    signalAll('draw_shearY', {command='shearY'})
end

function exports.shearZ()
    signalAll('draw_shearZ', {command='shearZ'})
end

function exports.translate(x, y, z)
    signalAll('draw_translate', {command='translate'})
end



local function signaler(funcname)
    local marshaler = marshalers[funcname]

    --print("SIGNALER: ", funcname, marshaler)

    if not marshaler then 
        return nil;
    end
    
    local signame = 'draw_'..funcname;

    local function closure(...)
        local event = marshaler(...);
        --print("signaling: ", signame, event)
        --print("signaler: ", signalAll(signame, event))
        signalAll(signame, event)
    end

    return closure
end

exports.signals = marshalers
setmetatable(exports, {
    __index = function(self, value)
        return signaler(value);
    end;
})


return exports
