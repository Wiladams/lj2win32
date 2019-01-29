require("funkit")()

local function test_all()
    print(all(function(x) return x end, {true, true, true, true}))
    print(all(function(x) return x end, {true, true, true, false}))
    
    print("all(function(x) return x end, 'aaaaaaaa')")
    print(all(function(x) return x end, "aaaaaaaa"))

    print("all(function(x) return x end, 'aaabaaaa')")
    print(all(function(x) return x end, "aaabaaaa"))
end

local function test_length()
    print("== test_length ==")
    print("print(length(range(0)))")
    print(length(range(0)))
    
    print("print(length(range(5)))")
    print(length(range(5)))
end

local function test_maximum()
    print('maximum({"f", "b", "c", "d", "e"})')
    print(maximum({"f", "b", "c", "d", "e"}))
end

local function test_minimum()
    print('minimum({"f", "d", "c", "d", "e"})')
    print(minimum({"f", "d", "c", "d", "e"}))
end

local function test_range()
    print("range(5)")
    each(print, range(5))

    print("range(-5)")
    each(print, range(-5))

    print("range(1,5)")
    each(print, range(1,5))

    print("range(0,20,5)")
    each(print, range(0,20,5))

    print("range(0,10,3)")
    each(print, range(0,10,3))

    print("range(0,1.5,0.2)")
    each(print, range(0,1.5,0.2))

    print("range(0)")
    each(print, range(0))

    print("range(1)")
    each(print, range(1))

    print("range(1,0")
    each(print, range(1,0))

    print("range(0,10,0) [ERROR]")
    each(print, range(0,10,0))
end


local function test_nth()
    print(nth(2, range(5)))
    print(nth(10, range(5)))
end

local function test_take_n()
    each(print, take_n(5, range(10)))
end

local function test_grep()
    print("== test_grep ==")
    local lines_to_grep = {
        [[Emily]],
        [[Chloe]],
        [[Megan]],
        [[Jessica]],
        [[Emma]],
        [[Sarah]],
        [[Elizabeth]],
        [[Sophie]],
        [[Olivia]],
        [[Lauren]]
    }

    each(print, grep(function(x) return x%3 == 0 end, range(10)))
end


local function test_duplicate()
    --each(print, take_n(3, duplicate('a', 'b', 'c')))
    --each(print, take_n(3, duplicate('x')))
    each(print, duplicate('a', 'b', 'c'))
end

local function test_each()
    each(print, "hello, world!")
end

local function test_totable()
    local tab = totable("abcdef")
    print(type(tab), #tab)
    
    each(print, tab)
end

--test_all();
--test_duplicate();
--test_each();
--test_grep();
--test_length();
test_maximum();
--test_minimum();
--test_nth();
--test_range();
--test_take_n();
--test_totable();

