local ffi = require("ffi")

-- Basic socket definitions
--[[
 s_addr  S_un.S_addr /* can be used for most tcp & ip code */
 s_host  S_un.S_un_b.s_b2    // host on imp
 s_net   S_un.S_un_b.s_b1    // network
 s_imp   S_un.S_un_w.s_w2    // imp
 s_impno S_un.S_un_b.s_b4    // imp #
 s_lh    S_un.S_un_b.s_b3    // logical host
--]]

ffi.cdef[[
typedef struct in_addr {
    union {
        struct {
            uint8_t s_b1,s_b2,s_b3,s_b4;
            } S_un_b;
        struct {
            uint16_t s_w1,s_w2;
        } S_un_w;
        uint32_t S_addr;
    };
} IN_ADDR, *PIN_ADDR, *LPIN_ADDR;
]]

--[[
IN_ADDR = ffi.typeof("struct in_addr");
IN_ADDR_mt = {
    __tostring = function(self)
        local res = Lib.inet_ntoa(self)
        if res then
            return ffi.string(res)
        end

        return nil
    end,

    __index = {
        Assign = function(self, rhs)
            self.S_addr = rhs.S_addr
            return self
        end,

        Clone = function(self)
            local obj = IN_ADDR(self.S_addr)
            return obj
        end,

    },
}
ffi.metatype(IN_ADDR, IN_ADDR_mt)
--]]