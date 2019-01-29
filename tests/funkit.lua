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
    
    return unpack(results)
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
    local function iterator()
        return nil
    end

    return coroutine.wrap(iterator)
end

function exports.string_iter(str)
    local state = 1

    local function iterator()
        while true do
            if state > #str then
                return nil
            end

            local r = string.sub(str, state, state)
            send(r)
            state = state + 1
        end
    end

    return coroutine.wrap(iterator)
end

function exports.table_iter(tbl)
    local function iterator()
        for i, value in ipairs(tbl) do
            send(value)
        end
    end

    return coroutine.wrap(iterator)
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
    
--print("start, stop, step: ", start, stop, step)

    assert(type(start) == "number", "start must be a number")
    assert(type(stop) == "number", "stop must be a number")
    assert(type(step) == "number", "step must be a number")
    assert(step ~= 0, "step must not be zero")


    local function range_gen()
        local i = start
        while i <= stop do
            send(i)
            i = i + step;
        end
    end

    local function range_gen_rev()
        local i = start
        while i >= stop do
            send(i)
            i = i + step;
        end
    end

    if step > 0 then
        return coroutine.wrap(range_gen)
    end

    return coroutine.wrap(range_gen_rev)
end

local function zeroes_prod()
    return coroutine.create(function()
        while true do
            --print("zeroes, sending")
            send(0)
        end
    end)
end

exports.zeroes = zeroes_prod



--[[
    REDUCING
]]
function exports.all(predicate, source)
    local iter = source
    if type(source) == "string" then
        iter = exports.string_iter(source)
    elseif type(source) == "table" then
        iter = exports.table_iter(source)
    end

    for value in iter do
        --print (value)
        if not predicate(value) then
            return false
        end
    end

    return true;
end
exports.every = exports.all

function exports.any(predicate, source)
    local iter = source
    if type(source) == "string" then
        iter = exports.string_iter(source)
    elseif type(source) == "table" then
        iter = exports.table_iter(source)
    end

    for value in iter do
        if predicate(value) then
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

function exports.maximum(source)
    local iter = source
    if type(source) == "string" then
        iter = exports.string_iter(source)
    elseif type(source) == "table" then
        iter = exports.table_iter(source)
    end

    local maxval = nil
    for value in iter do
        if not maxval then maxval = value end
        if value > maxval then maxval = value end
    end

    return maxval
end

function exports.minimum(source)
    local iter = source
    if type(source) == "string" then
        iter = exports.string_iter(source)
    elseif type(source) == "table" then
        iter = exports.table_iter(source)
    end

    local minval = nil
    for value in iter do
        if not minval then minval = value end
        if value < minval then minval = value end
    end

    return minval
end

function exports.totable(source)
    local tbl = {}

    local iter = source
    if type(source) == "string" then
        iter = exports.string_iter(source)
    elseif type(source) == "table" then
        iter = exports.table_iter(source)
    end

    for value in iter do
        table.insert(tbl, value)
    end
    return tbl
end

--[[
    SLICING
]]
local function take_n_prod(n, prod)
    return coroutine.create(function ()
        local counter = 0;
        while true do
            counter = counter + 1
            --print("taken_n, counter: ", counter, n)
            if counter > n then
                return nil
            end

            local results = {receive(prod)}
            
            --print("take_n, receive: ", #results)
            if #results == 0 then break end

            send(unpack(results))
        end

    end)
end
exports.take_n = take_n_prod



-- return the 'nth' iterated value
function exports.nth(n, prod)
    local counter = 0

    while true do
        counter = counter + 1
        local results = {receive(prod)}
        if #results == 0 then break end

        if counter == n then
            return unpack(results)
        end
    end

    return nil
end

function exports.head(source)
    return exports.nth(1, source)
end

exports.car = exports.head






function exports.each(func, prod)
    if not func then return false end
    
    local iter = prod

    if type(prod) == "string" then
        iter = exports.string_iter(source)
    elseif type(source) == "table" then
        iter = exports.table_iter(source)
    end

    while true do
        local results = {receive(prod)}
        if #results == 0 then break end

        func(unpack(results))
    end
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

