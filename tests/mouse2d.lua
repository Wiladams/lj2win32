package.path = "../?.lua;"..package.path;

require("p5")



function draw()
	background(51);
	
	if not mouseY then return false; end

	fill(255, 0,0, 118);
	rect(mouseX, height / 2, mouseY / 2 + 10, mouseY / 2 + 10);
	

	local inverseX = width - mouseX;
	local inverseY = height - mouseY;
	fill(0,0,255, 118);
	rect(inverseX, height / 2, (inverseY / 2) + 10, (inverseY / 2) + 10);

end


go({width=640, height=480, title="mouse2d"})