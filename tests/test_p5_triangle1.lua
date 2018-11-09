package.path = "../?.lua;"..package.path;

require("p5")

function setup()
    triangle(30, 75, 58, 20, 86, 75);
end


go({width=1024, height=768, title="test_triangle_1"});