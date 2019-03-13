local db = require("usbvendordb")
--local fun = require("fun")()
local funkit = require("funkit")()
local spairs = require("spairs")

local function order(t, a, b)
    return t[a].name < t[b].name
end

for k,v in spairs(db, order) do
    print(string.format("[0x%x] = '%s';", k, v.name))
end