package.path = "../?.lua;"..package.path;

local graphicApp = require("graphicapp")

local function onMouseMove(event)
    print("MOUSE MOVE: ", event.x, event.y)
end

local function onMouseDown(event)
    print("MOUSE DOWN: ", event.x, event.y, event.lbutton, event.mbutton, event.rbutton)
end

local function onMouseUp(event)
    print("MOUSE UP: ", event.x, event.y, event.lbutton, event.mbutton, event.rbutton)
end

local function onMouseActivity(event)
    print("MOUSE: ", event.activity, event.x, event.y, event.lbutton, event.mbutton, event.rbutton, event.xbutton1, event.xbutton2)
end

--on('mousemove', onMouseMove);
--on('mousedown', onMouseDown);
--on('mouseup', onMouseUp);

on('mousedown', onMouseActivity);
on('mouseup', onMouseActivity);
--on('mousemove', onMouseActivity);
on('mousewheel', onMouseActivity);

graphicApp.run();