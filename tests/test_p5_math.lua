package.path = "../?.lua;"..package.path;

require("p5")


local function test_exp()
    print("== test_exp ==")
    print("exp(0): ", exp(0))
    print("exp(1): ", exp(1))
    print("exp(2): ", exp(2))
end

local function test_lerp()
    print("== test_lerp ==")
    print("lerp(3,7,0): ", lerp(3,7,0))
    print("lerp(3,7,.125): ", lerp(3,7,.125))
    print("lerp(3,7,.25): ", lerp(3,7,.25))
    print("lerp(3,7,.5): ", lerp(3,7,.5))
    print("lerp(3,7,1): ", lerp(3,7,1))
    print("lerp(3,7,-2): ", lerp(3,7,-2))
    print("lerp(3,7,2): ", lerp(3,7,2))
end

local function test_mag()
    print("== test_mag ==")
    print("mag(0,0): ", mag(0,0))
    print("mag(1,0): ", mag(1,0))
    print("mag(1,1): ", mag(1,1))
end

local function test_map()
    print("== test_map ==")
    print("map(3,3,5,10,20): ", map(3,3,5,10,20))
    print("map(4,3,5,10,20): ", map(4,3,5,10,20))
    print("map(5,3,5,10,20): ", map(5,3,5,10,20))
    print("map(0.5,0,1,0,width): ", map(0.5,0,1,0,width))
end

local function test_pow()
    print("== test_pow ==")
    print("pow(2,3): ", pow(2,3))
    print("pow(2,3.5): ", pow(2,3.5))
    print("pow(2,4): ", pow(2,4))
end

function setup()
    --test_exp();
    --test_lerp();
    --test_mag();
    --test_map();
    test_pow();
end


go({width=320, height=240, title="test_p5_math"});