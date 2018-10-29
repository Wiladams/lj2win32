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
    backgroundImage = function(image) return {command='backgroundImage', params={image=image}} end;
    clear = function() return {command='clear'} end;
    colorMode = function(mode, max1, max2, max3, maxA) return {command='colorMode', params={mode=mode,max1=max1,max2=max2,max3= max3, maxA = maxA}} end;

    noFill = function() return {command='noFill'} end;
}


--[[
--DPPIXELVAL color(v1, v2 = -1, v3 = -1, alpha = -1);
--function marshalers.colorMode();
--]]

function marshalers.fillValues(v1, v2, v3, alpha)
    return {command='fillValues', params={v1=v1,v2=v2,v3=v3,alpha=alpha}}
end

function marshalers.fill(value)
    return {command='fill', params={value=value}}
end

function marshalers.noStroke()
    return {command='noStroke'}
end

function marshalers.stroke(value)
    return {command='stroke', params={value = value}}
end

function marshalers.strokeValues(v1, v2, v3, alpha)
    return {command='strokeValues'}
end

-- attributes
function marshalers.ellipseMode(mode)
    return {command='ellipseMode'}
end

function marshalers.noSmooth()
    return {command='noSmooth'}
end

function marshalers.rectMode(mode)
    return {command='rectMode', params={mode=mode}}
end

function marshalers.smooth()
    return {command='smooth'}
end

function marshalers.strokeCap()
    return {command='strokeCap'}
end

function marshalers.strokeJoin()
    return {command='strokeJoin'}
end

function marshalers.strokeWeight(weight)
    return {command='strokeWeight', params={weight=weight}}
end


-- 2D primitives
function marshalers.bezier(x1, y1, x2, y2, x3, y3, segments)
    return {command='bezier', params={x1=x1,y1=y1,x2=x2,y2=y2,x3=x3,y3=y3,segments=segments}}
end

function marshalers.ellipse(a, b, c, d)
    return {command='ellipse', params={a=a, b=b,c=c,d=d}})
end

function marshalers.line(x1, y1, x2, y2)
    return {command='line', params={x1=x1,y1=y1,x2=x2,y2=y2}}
end

function marshalers.lineloop(nPtr, pts)
    return {command='lineloop'}
end

function marshalers.point(x, y)
    return {command='point'}
end

function marshalers.rect(a, b, c, d)
    return {command='rect'}
end

function marshalers.quad(x1, y1, x2, y2, x3, y3, x4, y4)
    return {command='quad'}
end

function marshalers.triangle(x1, y1, x2, y2, x3, y3)
    return {command='triangle'}
end

function marshalers.polygon(nverts, a)
    return {command='polygon'}
end

-- Text

-- createFont
-- loadFont()
function marshalers.setFont(fontdata)
    return {command='setFont'}
end

function marshalers.text(str, x, y)
    return {command='text'}
end

--function marshalers.textFont(font_t *font);
function marshalers.textAlign(alignX, alignY)
    return {command='textAlign'}
end

-- textLeading()
-- textMode()
function marshalers.textSize(size)
    return {command='textSize'}
end

-- textWidth()
-- textAscent()
-- textDescent()

-- Shape
function marshalers.beginShape(shapeKind)
    return {command='beginShape'}
end

function marshalers.vertex(x, y)
    return {command='vertex'}
end

function marshalers.bezierVertex(x1, y1, x2, y2, x3, y3)
    return {command='bezierVertex'}
end

function marshalers.endShape(kindOfClose)
    return {command='endShape'}
end

-- Images
function marshalers.image(img, a, b, c, d)
    return {command='image'}
end

--[[
PSD loadImage(filename, extension)
end
--]]

-- Coordinate transformation
function marshalers.applyMatrix()
    return {command='applyMatrix'}
end

function marshalers.popMatrix()
    return {command='popMatrix'}
end

function marshalers.printMatrix()
    return {command='printMatrix'}
end

function marshalers.pushMatrix()
    return {command='pushMatrix'}
end

function marshalers.resetMatrix()
    return {command='resetMatrix'}
end

function marshalers.rotate(angle, x, y, z)
    return {command='rotate'}
end

function marshalers.rotateX(anglex)
    return {command='rotateX'}
end

function marshalers.rotateY(angley)
    return {command='rotateY'}
end

function marshalers.rotateZ(anglez)
    return {command='rotateZ'}
end

function marshalers.scale(a, b, c)
    return {command='scale'}
end

function marshalers.shearX()
    return {command='shearX'}
end

function marshalers.shearY()
    return {command='shearY'}
end

function marshalers.shearZ()
    return {command='shearZ'}
end

function marshalers.translate(x, y, z)
    return {command='translate'}
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
