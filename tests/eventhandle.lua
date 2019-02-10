local ffi = require("ffi")
local C = ffi.C 

require("win32.handleapi")
require("win32.errhandlingapi")
require("win32.winbase")
ffi.cdef[[
typedef struct _EventHandle {
    HANDLE Handle;
} EventHandle;
]]

local EventHandle = {}
local EventHandle_mt = {
    __gc = function(self)
        C.CloseHandle(self.Handle)
    end,

    __new = function(ct, params)
        params = params or {}
        local attr = params.Attributes
        local manual = C.CREATE_EVENT_MANUAL_RESET
        if not params.ManualReset then 
            manual = C.CREATE_EVENT_INITIAL_SET
        end
        local initialState = 0
        if params.initialState then
            initialState = 1
        end
        local name = params.name

        local rawhandle = C.CreateEventA(attr, manual, initialState, name)

        local err = C.GetLastError()
        if not rawhandle then
            return nil, err
        end

        return ffi.new(ct, rawhandle)
    end,

    __index = EventHandle
}
ffi.metatype("EventHandle", EventHandle_mt)


function EventHandle.reset(self)
    local success = C.ResetEvent(self.Handle) ~= 0
    if not success then
        return false, C.GetLastError();
    end

    return true
end

function EventHandle.set(self)
end

return ffi.typeof("EventHandle")
