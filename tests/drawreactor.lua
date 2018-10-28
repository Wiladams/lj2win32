

local DrawingSurface = false;

local function draw_Handler(event)
    print("DRAW HANDLER: ", event.command)

    local dc = DrawingSurface.DC;
    dc:UseDCPen(true);
    dc:UseDCBrush(true);

    dc:SetDCPenColor(RGB(255,0,0))
    dc:SetDCBrushColor(RGB(0,0,255))

    dc:Rectangle(100, 100, 400,400);
    drawNow();
end



local DrawReactor = {}
setmetatable(DrawReactor, {
    __call = function(self,...)
        return self:new(...)
    end,
})

local DrawReactor_mt = {
    __index = DrawReactor;
}

function DrawReactor.init(self, dsignaler, dsurface)
    DrawingSurface = dsurface;
    obj = {
        surface = dsurface;
    }
    setmetatable(obj, DrawReactor_mt);
    
    for k,v in pairs(dsignaler.signals) do
        local signame = 'draw_'..k;
        if type(v)=='function' then
            --print("setup handler: ", signame, draw_Handler)
            on(signame, draw_Handler)
        end
    end

    return obj;
end

function DrawReactor.new(self, dsignaler, dsurface)
    return DrawReactor:init(dsignaler, dsurface)
end

return DrawReactor
