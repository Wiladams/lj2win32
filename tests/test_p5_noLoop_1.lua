package.path = "../?.lua;"..package.path;

require("p5")

function setup() 
    createCanvas(100, 100);
    background(200);
    noLoop();
end
  
function draw() 
    line(10, 10, 90, 90);
end


go({title="test_p5_noLoop"});