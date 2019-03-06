package.path = "../?.lua;"..package.path;

require("p5")

-- Click within the image to change
-- the value of the rectangle
-- after the mouse has been clicked

local  value = 0;

function draw() 
  fill(value);
  rect(25, 25, 50, 50);
end

function mouseClicked()
    value = 255 - value
end

go()