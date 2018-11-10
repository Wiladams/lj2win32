package.path = "../?.lua;"..package.path;

require("p5")

function setup()
    rect(30, 20, 55, 55);
end


go({title="test_rect_1"});
