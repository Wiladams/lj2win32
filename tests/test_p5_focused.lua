package.path = "../?.lua;"..package.path;

require("p5")
local wmmsgs = require("wm_reserved")



-- To demonstrate, put two windows side by side.
-- Click on the window that the p5 sketch isn't in!
function draw()
    --print("focused: ", focused)
    background(200);
    noStroke();
    fill(0, 200, 0);
    ellipse(25, 25, 50, 50);

    if not focused then
        --print("NO FOCUS")

        stroke(200, 0, 0);
        line(0, 0, 100, 100);
        line(100, 0, 0, 100);
    end
end

go()

