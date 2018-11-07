package.path = "../?.lua;"..package.path;

require("p5")

local c = color(255, 204, 0);   -- Define color 'c'
fill(c);                        --  Use color variable 'c' as fill color
noStroke();                     --  Don't draw a stroke around shapes
rect(30, 20, 55, 55);           --  Draw rectangle


p5.go({width=1024, height=768, title="test_menu"});