
local ffi = require("ffi")
local C = ffi.C

require("win32.windef") -- to pickup HWND

local joystickapi = require("win32.joystickapi")

local Joystick = {}
setmetatable(Joystick, {
    __call = function(self, ...)
        return self:new(...)
    end
})
local Joystick_mt = {
    __index = Joystick
}

function Joystick.init(self, id)
    local obj = {
        ID = id;
        info = ffi.new("JOYINFOEX")
    }
    obj.info.dwSize = ffi.sizeof("JOYINFOEX")

    setmetatable(obj, Joystick_mt)

    obj.caps = obj:getCapabilities()

    return obj
end

function Joystick.new(self, id)
    return self:init(id)
end

-- An enumeration of attached joysticks
function Joystick:sticks()
    local function enumerator()
        local numDevs = joystickapi.joyGetNumDevs();
        local pji = ffi.new("JOYINFO")

        for i = 0, numDevs-1 do
            -- use getting the position to determine if
            -- the joystick is connected
            local result = joystickapi.joyGetPos(i, pji)


            if result == C.JOYERR_NOERROR then
                local joy = Joystick(i)
                coroutine.yield(joy)
            end
        end
    end

    return coroutine.wrap(enumerator)
end


function Joystick.getCapabilities(self, res)

    local res = res or {}
    local pjc = ffi.new("JOYCAPSA")
    local cbjc = ffi.sizeof("JOYCAPSA")

    local result = joystickapi.joyGetDevCapsA(self.ID, pjc, cbjc);
    if result ~= 0 then
        return false, result
    end

    res.Mid = pjc.wMid;
    res.Pid = pjc.wPid;
    res.name = ffi.string(pjc.szPname)  -- MAXPNAMELEN
    res.xMin = pjc.wXmin;
    res.xMax = pjc.wXmax;
    res.yMin = pjc.wYmin;
    res.yMax = pjc.wYmax;
    res.zMin = pjc.wZmin;
    res.zMax = pjc.wZmax;
    res.numButtons = pjc.wNumButtons;
    res.periodMin = pjc.wPeriodMin;
    res.periodMax = pjc.wPeriodMax;
    res.rMin = pjc.wRmin;
    res.rMax = pjc.wRmax;
    res.uMin = pjc.wUmin;
    res.uMax = pjc.wUmax;
    res.vMin = pjc.wVmin;
    res.vMax = pjc.wVmax;
    res.caps = pjc.wCaps;
    res.maxAxes = pjc.wMaxAxes;
    res.numAxes = pjc.wNumAxes;
    res.maxButtons = pjc.wMaxButtons;
    res.regKey = ffi.string(pjc.szRegKey);
    res.OEMVxD = ffi.string(pjc.szOEMVxD);

    return res
end

local function joymap(x, olow, ohigh, rlow, rhigh)
    rlow = rlow or olow
    rhigh = rhigh or ohigh
    return rlow + (x-olow)*((rhigh-rlow)/(ohigh-olow))
end


function Joystick.getPosition(self, res)
    res = res or {}
    self.info.dwFlags = C.JOY_RETURNALL

    local result = joystickapi.joyGetPosEx(self.ID, self.info)
    if result ~= 0 then
        return false, result
    end

    local caps = self.caps
    res.x = joymap(self.info.dwXpos, caps.xMin, caps.xMax, -1,1);
    res.y = joymap(self.info.dwYpos, caps.yMin, caps.yMax, -1,1);
    res.z = joymap(self.info.dwZpos, caps.zMin, caps.zMax, 1,0); -- throttle reverse
    res.r = joymap(self.info.dwRpos, caps.rMin, caps.rMax, -1,1);
    res.u = joymap(self.info.dwUpos, caps.uMin, caps.uMax, -1,1);
    res.v = joymap(self.info.dwVpos, caps.vMin, caps.vMax, -1,1);
    
    res.flags = self.info.dwFlags;
    res.buttons = self.info.dwButtons;
    res.numberOfButtons = self.info.dwButtonNumber;

    if self.info.dwPOV == 0xffff then
        res.POV = false;
    else
        res.POV = self.info.dwPOV / 100;
    end


    return res
end


function Joystick.getState(self, res)
    res = res or {}

    self.info.dwFlags = C.JOY_RETURNALL

    local result = joystickapi.joyGetPosEx(self.ID, self.info)
    if result ~= 0 then
        return false, result
    end

    res.x = self.info.dwXpos;
    res.y = self.info.dwYpos;
    res.z = self.info.dwZpos;
    res.r = self.info.dwRpos;
    res.u = self.info.dwUpos;
    res.v = self.info.dwVpos;
    
    res.buttons = self.info.dwButtons;
    res.numberOfButtons = self.info.dwButtonNumber;

    if self.info.dwPOV == 0xffff then
        res.POV = false;
    else
        res.POV = self.info.dwPOV / 100;
    end

    return res;
end

function Joystick.capture(self, hwnd)
    local fChanged = 1;
    local uPeriod = 0;

    local result = joystickapi.joySetCapture(hwnd,self.ID,uPeriod, fChanged);

    return result == 0
end

function Joystick.release(self)
    local result = joystickapi.joyReleaseCapture(self.ID);

    return result == 0
end

return Joystick