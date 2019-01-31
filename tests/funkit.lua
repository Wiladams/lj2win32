--[[
    Functional programming toolkit

    Inspired by luafun, but using coroutine iterator model, just for kicks

    The fundamental structure is a producer/consumer thing.
]]

local exports = {}

local function receive (prod)
    --print("receive, pulling")
    local results = {coroutine.resume(prod)}
    local status = results[1]
    --print("receive, status: ", status)
    if not status then return nil end
    
    table.remove(results, 1)
    
    return status, results
end
  
local  function send (...)
    coroutine.yield(...)
end

--[[
    Generators
]]


-- An iterator that returns no values
-- convenient for when the parameters don't
-- conform, but you MUST return a valid iterator
function exports.nil_gen()
    return coroutine.create(function()
        return nil
    end)
end

local function string_iter(str)
    return coroutine.create(function()
        for idx=1,#str do
            send(string.sub(str, idx, idx))
        end
    end)

end

function table_iter(tbl)
    return coroutine.create(function ()
        for i, value in ipairs(tbl) do
            send(value)
        end
    end)
end


--[[
    PRODUCERS
]]

function exports.duplicate(...)
    local nargs = select('#', ...)
    local args = select(1, ...)
    if nargs > 1 then
        args = {...}
    end

    local function duplicate_1_gen()
        while true do
            send(args)
        end
    end

    local function duplicate_table_gen()
        while true do
            send(unpack(args))
        end
    end
    
    if nargs <= 1 then
        return coroutine.wrap(duplicate_1_gen)
    end

    return coroutine.wrap(duplicate_table_gen)
end

local function ones_prod()
    return coroutine.create(function()
        while true do
            send(1)
        end
    end)
end

exports.ones = ones_prod


function exports.range(start, stop, step)

    if step == nil then
        if stop == nil then
            if start == 0 then
                return coroutine.wrap(nil_gen)
            end
            stop = start
            start = stop > 0 and 1 or -1
        end
        step = start <= stop and 1 or -1
    end
    
    assert(type(start) == "number", "start must be a number")
    assert(type(stop) == "number", "stop must be a number")
    assert(type(step) == "number", "step must be a number")
    assert(step ~= 0, "step must not be zero")

    if step < 0 then
        return coroutine.create(function ()
            local i = start
            while i >= stop do
                send(i)
                i = i + step;
            end
        end)
    end

    return coroutine.create(function ()
        local i = start
        while i <= stop do
            send(i)
            i = i + step;
        end
    end)
end

-- produces zeros forever
local function zeros_prod()
    return coroutine.create(function()
        while true do
            --print("zeros, sending")
            send(0)
        end
    end)
end

exports.zeros = zeros_prod

-- an iterator that returns single values
local function iterator_1(prod)

end
--[[
    REDUCING
]]
-- return true if all items from producer
-- match the predicate
function exports.all(predicate, prod)
    local iter = prod
    if type(prod) == "string" then
        iter = string_iter(prod)
    elseif type(prod) == "table" then
        iter = table_iter(prod)
    end

    while coroutine.status(iter) ~= "dead" do
        local results = {receive(iter)}
        if not #results == 0 then break end

        if not predicate(unpack(results)) then
            return false
        end
    end

    return true;
end
exports.every = exports.all

function exports.any(predicate, prod)
    local iter = prod
    if type(prod) == "string" then
        iter = string_iter(prod)
    elseif type(prod) == "table" then
        iter = table_iter(prod)
    end

    while coroutine.status(iter) ~= "dead" do
        if predicate(receive(iter)) then
            return true
        end
    end

    return false;
end

-- return a count of elements in iterator
function exports.length(prod)
    local counter = 0;
    while(receive(prod)) do
        counter = counter + 1;
    end
    
    return counter;
end

function exports.maximum(prod)
    local iter = prod
    if type(prod) == "string" then
        iter = string_iter(prod)
    elseif type(prod) == "table" then
        iter = table_iter(prod)
    end

    local maxval = nil
    while coroutine.status(iter) ~= "dead" do
        local value = receive(iter)
        if not maxval then maxval = value end
        if value > maxval then maxval = value end
    end

    return maxval
end

function exports.minimum(prod)
    local iter = prod
    if type(prod) == "string" then
        iter = string_iter(prod)
    elseif type(prod) == "table" then
        iter = table_iter(prod)
    end

    local retval = nil
    while coroutine.status(iter) ~= "dead" do
        local value = receive(iter)
        if not retval then retval = value end
        if value < retval then retval = value end
    end

    return retval
end



function exports.totable(prod)
    local tbl = {}

    local iter = prod
    if type(prod) == "string" then
        iter = string_iter(prod)
    elseif type(prod) == "table" then
        iter = table_iter(prod)
    end

    while coroutine.status(iter) ~= "dead" do
        table.insert(tbl, receive(iter))
    end

    return tbl
end

--[[
    SLICING
]]
-- take_n
-- Consumer/Producer
local function take_n_prod(n, prod)
    return coroutine.create(function ()
        local counter = 0;
        while coroutine.status(prod) ~= "dead" do
            counter = counter + 1
            --print("taken_n, counter: ", counter, n)
            if counter > n then
                return nil
            end

            send(receive(prod))
        end
    end)
end
exports.take_n = take_n_prod



-- return the 'nth' iterated value
-- Consumer, Produce single value
function exports.nth(n, prod)
    return coroutine.create(function()
        local counter = 0
        while coroutine.status(prod) ~= "dead" do
            counter = counter + 1
            if counter == n then
                send(receive(prod))
                break
            else
                receive(prod)
            end
        end
    end)
end

function exports.head(source)
    return exports.nth(1, source)
end

exports.car = exports.head






function exports.each(func, prod)
    if not func then return false end
    
    local iter = prod

    if type(prod) == "string" then
        iter = string_iter(prod)
    elseif type(prod) == "table" then
        iter = table_iter(prod)
    end

    local success, results = receive(prod)
    while success and #results > 0 do
        func(unpack(results))
        success, results = receive(prod)
    end

--[[
    while coroutine.status(iter) ~= "dead" do
        func(receive(prod))
    end
--]]
end


--[[
    FILTERING
]]
function exports.filter(predicate, srciter)

    local function iterator()
        for value in srciter do
            if not predicate then
                coroutine.yield(value);
            else
                if predicate(value) then
                    coroutine.yield(value)
                end
                -- move on to the next one
            end
        end
    end

    local co = coroutine.create(iterator)
    
    return function()
        local status, value = coroutine.resume(co)
        if not status then
            return nil;
        end
        return value;
    end
end

exports.remove_if = exports.filter 

function exports.grep(predicate, source)
    local fun = predicate
    if type(predicate) == "string" then
        fun = function(str) return string.find(str, predicate) ~= nil end
    end 

    return exports.filter(fun, source)
end

-- a special syntax sugar to export all functions to the global table
setmetatable(exports, {
    __call = function(t, override)
        for k, v in pairs(t) do
            if rawget(_G, k) ~= nil then
                local msg = 'function ' .. k .. ' already exists in global scope.'
                if override then
                    rawset(_G, k, v)
                    print('WARNING: ' .. msg .. ' Overwritten.')
                else
                    print('NOTICE: ' .. msg .. ' Skipped.')
                end
            else
                rawset(_G, k, v)
            end
        end
    end,
})


return exports

