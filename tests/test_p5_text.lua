package.path = "../?.lua;"..package.path;

require("p5")

function setup()
    textSize(32);
    text('word', 10, 30);
    fill(0, 102, 153);
    text('word', 10, 60);
    fill(0, 102, 153, 51);
    text('word', 10, 90);
end


go({title="test_menu"});