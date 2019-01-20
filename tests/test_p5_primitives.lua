package.path = "../?.lua;"..package.path;

require("p5")

function setup()
    angleArc(200, 100, 50, 30, 300);
end


go({width=1024, height=768});
