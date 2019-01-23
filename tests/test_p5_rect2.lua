package.path = "../?.lua;"..package.path;

require("p5")

function setup()
    rect(30, 20, 55, 55, 20);
end


go({width=320, height=240, title="test_menu"});
