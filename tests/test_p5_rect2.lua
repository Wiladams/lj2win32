package.path = "../?.lua;"..package.path;

require("p5")

function setup()
    rect(30, 20, 55, 55, 20);
end


go({width=1024, height=768, title="test_menu"});
