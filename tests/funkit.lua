--[[
    Functional programming toolkit

    Inspired by luafun, but using coroutine iterator model, just for kicks
]]
--[[
    Generators
]]
local exports = {}

-- An iterator that returns no values
-- convenient for when the parameters don't
-- conform, but you MUST return a valid iterator
function exports.nil_gen()
    local function iterator()
        return nil
    end
end


--[[
    GENERATORS
]]

function exports.duplicate(...)
    local nargs = select('#', ...)
    local args = select(1, ...)
    if nargs > 1 then
        args = {...}
    end

    local function duplicate_1_gen()
        while true do
            coroutine.yield(args)
        end
    end

    local function duplicate_table_gen()
        while true do
            coroutine.yield(unpack(args))
        end
    end
    
    if nargs <= 1 then
        return coroutine.wrap(duplicate_1_gen)
    end

    return coroutine.wrap(duplicate_table_gen)
end



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
            coroutine.yield(i)
            i = i + step;
        end
    end

    local function range_gen_rev()
        local i = start
        while i >= stop do
            coroutine.yield(i)
            i = i + step;
        end
    end

    if step > 0 then
        return coroutine.wrap(range_gen)
    end

    return coroutine.wrap(range_gen_rev)
end

--[[
    SLICING
]]
function exports.take_n(n, source)
    local function take_n_gen()
        local counter = 1;
        for value in source do
            if counter > n then
                return nil;
            end
            coroutine.yield(value);
            counter = counter + 1
        end
    end

    return coroutine.wrap(take_n_gen)
end

-- return the 'nth' iterated value
function exports.nth(n, source)
    local counter = 1

    for value in source do
        if counter == n then
            return value;
        end
        counter = counter + 1
    end

    return nil
end

function exports.head(source)
    return exports.nth(1, source)
end







function exports.each(func, source)
    for value in source do
        if func then
            func(value)
        end
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

