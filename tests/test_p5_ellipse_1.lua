package.path = "../?.lua;"..package.path;

require("p5")

function setup()
    ellipse(56, 46, 55, 55);
end


go({width=1024, height=768, title="test_menu"});
