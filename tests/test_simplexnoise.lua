local SimplexNoise = require("simplexnoise")

for i=-1,1,0.025 do
    print(i, SimplexNoise.Noise1(i))
end