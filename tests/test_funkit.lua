require("funkit")()



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


--test_range();
--test_nth();
--test_take_n();
--test_grep();
test_duplicate();