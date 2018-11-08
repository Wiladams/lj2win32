package.path = "../?.lua;"..package.path;

require("p5")

function setup()
    line(30, 20, 85, 75);
end


go({width=1024, height=768, title="test_menu"});
