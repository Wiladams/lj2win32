package.path = "../?.lua;"..package.path;

require("p5")

function setup()
    point(30, 20);
    point(85, 20);
    point(85, 75);
    point(30, 75);
end


go({width=1024, height=768, title="test_menu"});
