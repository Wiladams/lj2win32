package.path = "../?.lua;"..package.path;

require("p5")

function setup()
    line(30, 20, 85, 20);
    stroke(126);
    line(85, 20, 85, 75);
    stroke(255);
    line(85, 75, 30, 75);
end


go({width=1024, height=768, title="test_menu"});