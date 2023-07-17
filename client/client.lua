local variables = Variables.new(GetPlayerServerId())
variables:change("clothesChecking", false)


local createTaxiPed = function()
    create_taxiped = CreatePed(0, Config.TaxiPed.pedmodel, Config.TaxiPed.coords.x, Config.TaxiPed.coords.y,
        Config.TaxiPed.coords.z - 1, Config.TaxiPed.coords.w)
    FreezeEntityPosition(create_taxiped, true)
    SetEntityInvincible(create_taxiped, true)
    SetBlockingOfNonTemporaryEvents(create_taxiped, true)
end

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    local repeater = 0
    repeat
        Wait(1)
        repeater = HasAnimDictLoaded(dict)
    until (repeater == 1)
end

Citizen.CreateThread(function()
    local repeater = 0
    modelHash = GetHashKey(Config.TaxiPed.pedmodel)
    RequestModel(modelHash)
    repeat
        Wait(50)
        repeater = HasModelLoaded(modelHash)
    until (repeater == 1)
    createTaxiPed()
end)


local loadPedModel = function(ped, startLocationX, startLocationY, startLocationZ, startLocationH)
    Citizen.CreateThread(function()
        local repeater = 0
        modelHash = GetHashKey(ped)
        RequestModel(modelHash)
        repeat
            Wait(50)
            repeater = HasModelLoaded(modelHash)
        until (repeater == 1)
        variables:change("ped", CreatePed(4, ped, startLocationX, startLocationY, startLocationZ - 1, startLocationH))
        SetEntityInvincible(variables.ped, true)
        SetBlockingOfNonTemporaryEvents(variables.ped, true)
    end)
end


local changeClothes = function(id)
    local player = PlayerPedId()
    loadAnimDict('move_m@_idles@shake_off')

    if id == 1 then
        variables:change("clothesChecking", true)
        ESX.ShowNotification("Przebierasz się")
        TaskPlayAnim(player, "move_m@_idles@shake_off", "shakeoff_1", 8.0, 8.0, -1, 0, 1, true, true, true)
        Wait(2000)
        TriggerEvent('skinchanger:getSkin', function(skin)
            variables:change("playerSkin", skin)
            local uniformObject
            if skin.sex == 0 then
                uniformObject = Config.Clothes.male
            else
                uniformObject = Config.Clothes.female
            end
            if uniformObject then
                TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
            end
        end)
    elseif id == 2 then
        variables:change("clothesChecking", false)
        ESX.ShowNotification("Przebierasz się")
        TaskPlayAnim(player, "move_m@_idles@shake_off", "shakeoff_1", 8.0, 8.0, -1, 0, 1, true, true, true)
        Wait(2000)
        TriggerEvent('skinchanger:loadClothes', variables.playerSkin)
        variables:delete("playerSkin")
    end
end

local startRiding = function()
    ESX.ShowNotification("Poczekaj na zgloszenie!")
    variables:change("awaiter", math.random(3000, 10000))
    variables:change("didawait", false)
    Wait(variables.awaiter)
    variables:change("didawait", true)
    ESX.ShowNotification("Zaznaczono zgloszenie na GPS!")
    local customer = Customer.new()
    local startLocation = customer:getStartLocation()
    local endLocation = customer:getEndLocation()
    local salary = customer:getRandomSalary()
    local pedModel = customer:getPed()
    variables:change("counter", true)
    variables:change("counter2", true)
    variables:change("counter3", true)
    variables:change("blip", AddBlipForCoord(startLocation.x, startLocation.y))
    SetBlipSprite(variables.blip, 480)
    SetBlipColour(variables.blip, 5)
    SetBlipAsShortRange(variables.blip, true)
    SetBlipRoute(variables.blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Klient')
    EndTextCommandSetBlipName(variables.blip)
    loadPedModel(pedModel, startLocation.x, startLocation.y, startLocation.z, startLocation.h)
    variables:change("salary", salary)
    variables:change("endLocation", endLocation)
    variables:change("isRiding", true)
end


local routeToDestination = function()
    ESX.ShowNotification("Zawiez klienta w miejsce docelowe")
    variables:change("blip", AddBlipForCoord(variables.endLocation.x, variables.endLocation.y))
    SetBlipSprite(variables.blip, 480)
    SetBlipColour(variables.blip, 5)
    SetBlipAsShortRange(variables.blip, true)
    SetBlipRoute(variables.blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('#Miejsce do dowiezienia klienta')
    EndTextCommandSetBlipName(variables.blip)
end



Citizen.CreateThread(function()
    while true do
        if variables.isRiding and not IsPedInVehicle(variables.ped, variables.vehicle, false) then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local pedCoords = GetEntityCoords(variables.ped)
            local distance = #(playerCoords - pedCoords)
            if distance <= 35.0 and variables.counter2 then
                ESX.ShowNotification("Zatrab aby zaprosic klienta")
                variables:change("counter2", false)
            end
            if distance <= 15.0 and IsControlJustPressed(0, 38) then
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                local vehicle2 = GetEntityModel(vehicle)
                if vehicle2 == GetHashKey("taxi") then
                    variables:change("vehicle2", vehicle)
                    TaskEnterVehicle(variables.ped, vehicle, -1, 2, 2.0, 1, 0)
                    Citizen.CreateThread(function()
                        while true do
                            Wait(10)
                            if IsPedInVehicle(variables.ped, vehicle, false) and variables.counter == true then
                                variables:change("counter", false)
                                RemoveBlip(variables.blip)
                                variables:delete("blip")
                                routeToDestination()
                                break
                            end
                        end
                    end)
                else
                    ESX.ShowNotification("Klient: Nie wsiade do takiego gowna!")
                end
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        if variables.isRiding and IsPedInVehicle(variables.ped, variables.vehicle, false) then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z,
                variables.endLocation.x, variables.endLocation.y, variables.endLocation.z, true)
            if distance <= 35.0 and variables.counter3 then
                ESX.ShowNotification("Zatrab aby wypuscic klienta")
                variables:change("counter3", false)
            end
            if distance <= 20.0 and IsControlJustPressed(0, 38) then
                TaskLeaveVehicle(variables.ped, variables.vehicle, 0)
                TaskWanderStandard(variables.ped, 10, 10)
                ESX.TriggerServerCallback('vn-taxijob-givesalary', function() end, variables.salary)
                RemoveBlip(variables.blip)
                Wait(5000)
                DeleteEntity(variables.ped)
                variables:delete("ped")
                startRiding()
            end
        end
        Citizen.Wait(5)
    end
end)

local takeCar = function()
    if IsAnyVehicleNearPoint(896.6879, -153.3415, 76.16522, 10.0) then
        ESX.ShowNotification("Miejsce do wziecia taksowki jest zajete! Zwolnij je")
    else
        ESX.TriggerServerCallback('vn-taxijob-moneycheck', function(cb)
            if cb.data then
                ESX.Game.SpawnVehicle('taxi', {
                    x = 896.6879,
                    y = -153.3415,
                    z = 76.16522
                }, 326.1926, function(vehicle)
                    SetEntityAsMissionEntity(vehicle, true, true);
                    variables:change("vehiclePlate", GetVehicleNumberPlateText(vehicle))
                    variables:change("vehicle", vehicle)
                    variables:change("hasVehicle", true)
                    variables:change("isWorking", true)
                    startRiding()
                end)
            end
        end)
    end
end

local returnCar = function()
    if variables.isWorking and variables.hasVehicle then
        local taxiCoords = GetEntityCoords(variables.vehicle)
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)
        if GetDistanceBetweenCoords(playerCoords, taxiCoords, true) <= 25.0 then
            DeleteEntity(variables.vehicle)
            variables:delete("vehiclePlate")
            variables:delete("vehicle")
            variables:change("hasVehicle", false)
            variables:change("isWorking", true)
            ESX.TriggerServerCallback('vn-taxijob-returnmoney')
        else
            ESX.ShowNotification("Pojazd jest za daleko zeby go oddac!")
        end
    end
end

local cancelJob = function()
    ESX.ShowNotification('Zakonczono prace')
    variables:delete("vehiclePlate")
    variables:delete("vehicle")
    variables:change("hasVehicle", false)
    variables:change("isWorking", false)
    variables:change("isRiding", false)
    if variables.didawait then
        RemoveBlip(variables.blip)
        DeleteEntity(variables.ped)
        variables:delete("blip", false)
        variables:delete("ped", false)
    else
        Wait(variables.awaiter + 300)
        RemoveBlip(variables.blip)
        DeleteEntity(variables.ped)
        variables:delete("blip", false)
        variables:delete("ped", false)
    end
end

Citizen.CreateThread(function()
    exports.qtarget:AddBoxZone(Config.Targets[1].name, Config.Targets[1].pos, Config.Targets[1].width,
        Config.Targets[1].length, {
        name = Config.Targets[1].name,
        heading = Config.Targets[1].heading,
        debugPoly = false,
        minZ = Config.Targets[1].minZ,
        maxZ = Config.Targets[1].maxZ,
    }, {
        options = {
            {
                action = function(id)
                    changeClothes(1)
                end,
                icon = "fas fa-arrow-right-to-bracket",
                label = 'Strój roboczy',
                canInteract = function()
                    return not variables.clothesChecking
                end,
            },
            {
                action = function(id)
                    changeClothes(2)
                end,
                icon = "fas fa-arrow-right-to-bracket",
                label = 'Strój Prywatny',
                canInteract = function()
                    return variables.clothesChecking
                end,
            },
            {
                action = function()
                    takeCar()
                end,
                icon = "fas fa-arrow-right-to-bracket",
                label = 'Weź Pojazd (' .. Config.DepositAmount .. ')$',
                canInteract = function()
                    return variables.clothesChecking and not variables.hasVehicle
                end,
            },
            {
                action = function()
                    returnCar()
                end,
                icon = "fas fa-arrow-right-to-bracket",
                label = 'Zwróć Pojazd',
                canInteract = function()
                    return variables.isWorking and variables.hasVehicle
                end,
            },
            {
                action = function()
                    cancelJob()
                end,
                icon = "fas fa-arrow-right-to-bracket",
                label = 'Zakoncz prace',
                canInteract = function()
                    return variables.isWorking
                end,
            },
        },
        distance = 2
    })
end)
