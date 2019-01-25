package.path = "../?.lua;"..package.path;

require("p5")


local WindowSize = 800;
local MinimumX = 0;   -- the minimum input value
local MaximumX = 500; -- the maximum input value

function setup()
   --size(WindowSize, WindowSize);
   background(255);

   local border = 20;                      -- leave a gap around the plot
   local windowMin = border;               -- left and bottom
   local windowMax = WindowSize - border;  -- right and top

   -- draw a box around the plot
   noFill();
   stroke(0, 0, 0);
   rect(windowMin, windowMin, windowMax-windowMin, windowMax-windowMin);

   -- run through the function and find the output range
   local yMin = plotFunction(MinimumX);
   local yMax = yMin;
   for screenX=windowMin, windowMax-2 do
      local xValue = map(screenX, windowMin, windowMax, MinimumX, MaximumX);
      local yValue = plotFunction(xValue);
      if (yValue < yMin) then yMin = yValue; end
      if (yValue > yMax) then yMax = yValue; end
   end

   -- now run through the values again, and plot them
   local oldx = 0;
   local oldy = 0;
   for screenX=windowMin, windowMax-1 do
      local xValue = map(screenX, windowMin, windowMax, MinimumX, MaximumX);
      local yValue = plotFunction(xValue);

      local screenY = map(yValue, yMin, yMax, windowMax, windowMin);
      if (screenX > windowMin) then
         line(oldx, oldy, screenX, screenY);
      end
      oldx = screenX;
      oldy = screenY;
    end
end

function plotFunction(x)

   local v = abs(cos(x/40.0));
   local bounceHeight = max(0, map(x, 0, 600, 1, 0));
   local y = v * bounceHeight;
   return(y);
end


go({width=WindowSize, height = WindowSize});
