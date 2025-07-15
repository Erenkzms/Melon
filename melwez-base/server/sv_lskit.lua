    local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem("lskit", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        TriggerClientEvent('giveBagItems', source)
    end
end)

RegisterNetEvent('server:giveBagItems')
AddEventHandler('server:giveBagItems', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        local bagItems = {
            {name = 'weapon_browning', amount = 1},
            {name = 'ammo-9', amount = 30},
            {name = 'armor', amount = 15},
            {name = 'enerji_icecegi', amount = 20},
            {name = 'bandage', amount = 15},
            {name = 'medikit', amount = 15},
            {name = 'radio', amount = 1},
            {name = 'cay', amount = 1},
            {name = 'simit', amount = 1},
        }

        for _, item in ipairs(bagItems) do
            Player.Functions.AddItem(item.name, item.amount)
        end

        Player.Functions.RemoveItem("lskit", 1)

        TriggerClientEvent('QBCore:Notify', src, "Kit Kullanıldı!", "success")
    end
end)
