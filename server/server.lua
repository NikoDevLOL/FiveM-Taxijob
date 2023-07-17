ESX.RegisterServerCallback('vn-taxijob-moneycheck', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = xPlayer.getInventoryItem('money')
    local check = false

    if money.count >= Config.DepositAmount then
        check = true
        xPlayer.removeAccountMoney('money', Config.DepositAmount)
    else
        xPlayer.showNotification('Nie posiadasz wystarczającej ilości gotówki!')
    end

    cb({
        data = check
    })
end)


ESX.RegisterServerCallback('vn-taxijob-returnmoney', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addAccountMoney('money', Config.DepositAmount)
    xPlayer.showNotification("Otrzymales zwrot zaliczki " .. Config.DepositAmount .. "$")
end)


ESX.RegisterServerCallback('vn-taxijob-givesalary', function(source, cb, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addAccountMoney('money', amount)
    xPlayer.showNotification("Otrzymales pieniadze za kurs kwota to: " .. amount .. "$")
end)
