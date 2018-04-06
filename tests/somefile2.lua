GET_INPUT = nil
function getInput()
    print("Getting input")
end

print("     _G: ", _G)
print("_G meta: ", getmetatable(_G))

setmetatable(_G, {__index = 
function(t,k)
    print("index: ", t, k)

    if k == "GET_INPUT" then
        return getInput()
    end

    return nil
end
})


if GET_INPUT then 
    print("Hello")
end
