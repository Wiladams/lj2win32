package.path = "../?.lua;"..package.path;

require("p5")

function setup()

    -- left circle
    ellipse(0, 50, 33, 33); -- Left circle

    -- Middle circle
    -- Start a new drawing state
    push(); 
    strokeWeight(10);
    fill(204, 153, 0);
    translate(50, 0);
    ellipse(0, 50, 33, 33); 
    pop(); -- Restore original state

    -- right circle
    ellipse(100, 50, 33, 33);
end

go()