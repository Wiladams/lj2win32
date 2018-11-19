package.path = "../?.lua;"..package.path;

require("p5")

-- Drag the mouse across the page
-- to change its value

local value = 0;

function draw() 
  fill(value);
  rect(25, 25, 50, 50);
end

---[[
function mouseDragged() 
  value = value + 5;
  if (value > 255) then
    value = 0;
  end
end
--]]

--[[
function mouseDragged()
    ellipse(mouseX, mouseY, 5, 5);
    
    -- prevent default
    return false;
end
--]]

go({title="test_p5_mousedragged.lua"})
