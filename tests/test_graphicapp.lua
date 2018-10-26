package.path = "../?.lua;"..package.path;

local graphicApp = require("graphicapp")

local function onMouseMove(event)
    print("MOUSE MOVE: ", event.x, event.y)
end

local function onMouseDown(event)
    print("MOUSE DOWN: ", event.x, event.y)
end

local function onMouseUp(event)
    print("MOUSE UP: ", event.x, event.y)
end

local function onMouseActivity(event)
    print(string.format("{activity ='%s'; x = %d; y = %d }; ", 
        event.activity, event.x, event.y));
end

--whenever('mousemove', onMouseMove);
--whenever('mousedown', onMouseDown);
--whenever('mouseup', onMouseUp);

whenever('mousedown', onMouseActivity);
whenever('mouseup', onMouseActivity);
whenever('mousemove', onMouseActivity);

graphicApp.run();