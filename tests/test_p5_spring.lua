package.path = "../?.lua;"..package.path;

require("p5")

-- Spring drawing constants for top bar
local springHeight = 32;
local    left;
local    right;
local    maxHeight = 200;
local    minHeight = 100;
local    over = false;
local    move = false;

-- Spring simulation constants
local M = 0.8;  -- Mass
local    K = 0.2;  -- Spring constant
local    D = 0.92; -- Damping
local    R = 150;  -- Rest position

-- Spring simulation letiables
local ps = R;   -- Position
local    vs = 0.0; -- Velocity
local    as = 0;   -- Acceleration
local    f = 0;    -- Force

function setup()

  rectMode(CORNERS);
  noStroke();
  left = width / 2 - 100;
  right = width / 2 + 100;
end

function draw() 
    if not mouseX then return end
    
  background(102);
  updateSpring();
  drawSpring();
end

function drawSpring() 
  -- Draw base
  fill(0.2);
  local baseWidth = 0.5 * ps + -8;
  rect(width / 2 - baseWidth, ps + springHeight, width / 2 + baseWidth, height);

  -- Set color and draw top bar
  if (over or move) then
    fill(255);
  else 
    fill(204);
  end

  rect(left, ps, right, ps + springHeight);
end

function updateSpring() 
  -- Update the spring position
  if not move  then
    f = -K * ( ps - R ); -- f=-ky
    as = f / M;          -- Set the acceleration, f=ma == a=f/m
    vs = D * (vs + as);  -- Set the velocity
    ps = ps + vs;        -- Updated position
  end

  if (abs(vs) < 0.1) then
    vs = 0.0;
  end

  -- Test if mouse if over the top bar
  if (mouseX > left and mouseX < right and mouseY > ps and mouseY < ps + springHeight) then
    over = true;
  else
    over = false;
  end

  -- Set and constrain the position of top bar
  if (move) then
    ps = mouseY - springHeight / 2;
    ps = constrain(ps, minHeight, maxHeight);
  end
end

function mousePressed()
    if over then
        move = true;
    end
end

function mouseReleased() 
  move = false;
end

go {width=710, height=400}