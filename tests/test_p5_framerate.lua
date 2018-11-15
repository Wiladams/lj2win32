package.path = "../?.lua;"..package.path;

require("p5")

function draw()
    print("time: ", millis()/1000)
end

go({title="test_framerate", frameRate=4});