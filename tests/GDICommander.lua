-- Send GDI commands to the interface
-- and this class will apply then against a graphics context
-- assumes the scheduler is used for signaling

local queue = require("queue")

local GDICommander = {}
setmetatable(GDICommander, {
    __call = function(self, ...)
        return self:new(...);
    end
})
local GDICommander_mt = {
    __index = GDICommander;
}


function GDICommander.init(self, ...)
    local obj = {
        commandQueue = queue();
    }
    setmetatable(obj, GDICommander_mt)
    
    return obj;
end

function GDICommander.new(self, ...)
    return self:init(...)
end

function GDICommander.send(self, cmd)
    self.commandQueue:enqueue(cmd);
    signalAll("gdi_command_ready");
end

function GDICommander.start(self)
    while true do
        -- drain the queue of any commands
        while self.commandQueue:length() >0 do
            local cmd = self.commandQueue:dequeue();
            if cmd == "QUIT" then
                halt();
            end
            self:execCommand(cmd)
        end

        yield();
    end
    halt();
end

function GDICommander.execCommand(self, cmd)
    print("execCommand: ", cmd)
end

return GDICommander