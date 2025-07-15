QBCore = exports['qb-core']:GetCoreObject()

local function UpdateBlips()
    local dutyPlayers = {}
    local players = QBCore.Functions.GetQBPlayers()
    for k, v in pairs(players) do
        if (v.PlayerData.job.name == Config.job1 or v.PlayerData.job.name == Config.job2 or v.PlayerData.job.name == Config.job3 or v.PlayerData.job.name == Config.job4 or v.PlayerData.job.name == Config.job5 or v.PlayerData.job.name == Config.job6 or v.PlayerData.job.name == Config.job7) and v.PlayerData.metadata["gpsacik"] then
            local coords = GetEntityCoords(GetPlayerPed(v.PlayerData.source))
            local heading = GetEntityHeading(GetPlayerPed(v.PlayerData.source))
            local helikopteraq = helikopter(v.PlayerData.source)
            local arac = arac(v.PlayerData.source)
            dutyPlayers[v.PlayerData.source] = {
                source = v.PlayerData.source,
                label = "." ..v.PlayerData.metadata["callsign"] .." [" .. v.PlayerData.charinfo["firstname"] .." " .. v.PlayerData.charinfo["lastname"] .. "]",
                job = v.PlayerData.job.name,
                location = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                    w = heading
                },
                gpsacik = v.PlayerData.metadata["gpsacik"],
                helikopter = helikopteraq,
                arac = arac
            }
        end
    end
    TriggerClientEvent("haso:client:UpdateBlips", -1, dutyPlayers)
end

CreateThread(function()
    while true do
        Wait(2000)
        UpdateBlips()
    end
end)

function arac(source)
    local arac = GetVehiclePedIsIn(GetPlayerPed(source), false)
    if arac == 0 then 
        return false
    else
        return true
    end
end

function helikopter(source)
    local arac = GetVehiclePedIsIn(GetPlayerPed(source), false)
    local tip = GetVehicleType(arac)
    if tip == "heli" then
        return true
    else
        return false
    end
end

QBCore.Functions.CreateUseableItem("gps", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        TriggerClientEvent('gps:ackapat', src)
    end
end)

RegisterNetEvent('QBCore:Server:SetMetaData', function(name, deger)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.SetMetaData(name, deger)
end)