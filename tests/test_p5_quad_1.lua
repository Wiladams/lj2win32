package.path = "../?.lua;"..package.path;

require("p5")

function setup()
    quad(38, 31, 86, 20, 69, 63, 30, 76);
end


go({width=1024, height=768, title="test_p5_quad_1"});