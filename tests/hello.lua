-- experiments in object sub-classing
-- 
local animal = {}
setmetatable(animal, {
    __call = function(self, ...)
        return self:new(...)
    end
})
local animal_mt = {
    __index = animal
}

function animal.new(self, ...)
    local obj = {
        kind = "animal"
    }
    setmetatable(obj, animal_mt)
    return obj
end

function animal.speak(self)
    print("speak:animal")
end

local dog = {}
setmetatable(dog, {
    __index = animal;

    __call = function(self, ...)
        return self:new(...)
    end,
})
local dog_mt = {
    __index = dog
}

function dog.new(self, ...)
    local obj = {}
    setmetatable(obj, dog_mt)
    return obj
end

function dog.speak(self, ...)
    print("dog.kind: ", self.kind)
    print("dog:speak - ", "bowwow")
end



local function test_animal()
    local a1 = animal()
    a1:speak()
end


local function test_dog()
    local d1 = dog()
    d1:speak()
end



test_dog()
