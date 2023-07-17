Customer = {}
Customer.__index = Customer

Customer = {}
Customer.__index = Customer

function GetDistance(coords1, coords2)
    return #(vector3(coords1.x, coords1.y, coords1.z) - vector3(coords2.x, coords2.y, coords2.z))
end

function Customer.new()
    local self = setmetatable({}, Customer)
    self.locations = Config.locations
    local playerPed = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerPed)
    local nearestIndex = 1
    local nearestDistance = GetDistance(self.locations[1].startLocation, playerCoords)
    for i = 2, #self.locations do
        local distance = GetDistance(self.locations[i].startLocation, playerCoords)
        if distance < nearestDistance then
            nearestIndex = i
            nearestDistance = distance
        end
    end
    self.startLocation = self.locations[nearestIndex].startLocation
    self.endLocation = self.locations[nearestIndex].endLocation
    self.minSalary = self.locations[nearestIndex].minSalary
    self.maxSalary = self.locations[nearestIndex].maxSalary
    self.ped = self.locations[nearestIndex].pedModel
    return self
end

function Customer:getStartLocation()
    return self.startLocation
end

function Customer:getEndLocation()
    return self.endLocation
end

function Customer:getRandomSalary()
    return math.random(self.minSalary, self.maxSalary)
end

function Customer:getPed()
    return self.ped
end
