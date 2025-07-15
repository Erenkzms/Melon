QBCore = exports['qb-core']:GetCoreObject()

-- RegisterCommand('alanseviye', function(source, args)
--     local src = source
--     if src == 0 then
--         TriggerClientEvent('alan-ayarla', -1, args[1])
--     end
-- end)

QBCore.Commands.Add("alanseviye", "Pubg alan ayarla (admin)", {}, false, function(source, args)
    TriggerClientEvent('alan-ayarla', -1, args[1])
end, "admin")

QBCore.Commands.Add("herkesicek", "Pubg Başlatır (admin)", {}, false, function(source, args)
    TriggerClientEvent('herkesi-isinla', -1, args[1])
end, "god")

QBCore.Commands.Add("herkesicek2", "Pubg Başlatır (admin)", {}, false, function(source, args)
    TriggerClientEvent('herkesi-isinla', -1, args[1])
end, "god")

RegisterNetEvent('env-sifirla', function()
    exports.ox_inventory:ClearInventory(source)
end)
