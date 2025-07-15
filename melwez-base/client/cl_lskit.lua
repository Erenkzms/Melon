RegisterNetEvent('giveBagItems')
AddEventHandler('giveBagItems', function()
    TriggerServerEvent('server:giveBagItems')
end)
