QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('onResourceStart', function(resource)
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
    onDuty = PlayerJob.onduty
    TriggerServerEvent("QBCore:Server:SetMetaData", "gpsacik", false)
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
    onDuty = PlayerJob.onduty
    TriggerServerEvent("QBCore:Server:SetMetaData", "gpsacik", false)
    TriggerEvent('gps:itemgg')
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerJob = job
    TriggerServerEvent("QBCore:Server:SetMetaData", "gpsacik", false)
    TriggerEvent('gps:itemgg')
end)

DutyBlips = {}
RegisterNetEvent('haso:client:UpdateBlips', function(players)
    if PlayerJob and (PlayerJob.name == Config.job1 or PlayerJob.name == Config.job2 or PlayerJob.name == Config.job3 or PlayerJob.name == Config.job4 or PlayerJob.name == Config.job5 or PlayerJob.name == Config.job6 or PlayerJob.name == Config.job7) and gpsacik then
        if DutyBlips then
            for k, v in pairs(DutyBlips) do
                if players[k] then
                    SetBlipCoords(v, players[k].location.x, players[k].location.y, players[k].location.z)
                else
                    RemoveBlip(v)
                    DutyBlips[k] = nil
                end
            end
        end
        -- DutyBlips = {}
        if players then
            for k, data in pairs(players) do
                local id = GetPlayerFromServerId(data.source)
                CreateDutyBlips(id, data.label, data.job, data.location, data.gpsacik, data.helikopter, data.source, data.arac)
            end
        end
    end
end)

RegisterNetEvent('gps:ackapat')
AddEventHandler('gps:ackapat', function()
    if PlayerJob and (PlayerJob.name == Config.job1 or PlayerJob.name == Config.job2 or PlayerJob.name == Config.job3 or PlayerJob.name == Config.job4 or PlayerJob.name == Config.job5 or PlayerJob.name == Config.job6 or PlayerJob.name == Config.job7) then
        if gpsacik then
            gpsacik = false
            SetBlipDisplay(GetMainPlayerBlipId(), 4)
            QBCore.Functions.Notify('GPS Kapatıldı')
            TriggerServerEvent("QBCore:Server:SetMetaData", "gpsacik", false)
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
                DutyBlips[k] = nil
            end
        else
            local dialog = exports['qb-input']:ShowInput({
                header = "GPS Kodunuzu Girin",
                submitText = "",
                inputs = {
                    {
                        text = "GPS Kodu",
                        name = "gpskodu",
                        type = "text",
                        isRequired = true 
                    },
                },
            })
            TriggerServerEvent("QBCore:Server:SetMetaData", "callsign", dialog.gpskodu)
            Citizen.Wait(1000)
            gpsacik = true
            SetBlipDisplay(GetMainPlayerBlipId(), 1)
            QBCore.Functions.Notify('GPS Açıldı')
            TriggerServerEvent("QBCore:Server:SetMetaData", "gpsacik", true)
        end
    else
        QBCore.Functions.Notify('Bunu kullanamazsın bro', 'error', 7500)
    end
end)

RegisterNetEvent('gps:itemgg')
AddEventHandler('gps:itemgg', function()
    gpsacik = false
    SetBlipDisplay(GetMainPlayerBlipId(), 4)
    QBCore.Functions.Notify('GPS Kapatıldı')
    TriggerServerEvent("QBCore:Server:SetMetaData", "gpsacik", false)
    if DutyBlips then
        for k, v in pairs(DutyBlips) do
            RemoveBlip(v)
            DutyBlips[k] = nil
        end
    end
end)

function CreateDutyBlips(playerId, playerLabel, playerJob, playerLocation, gpsacik, helikopter, playerids, arac)
    if gpsacik then
        local ped = GetPlayerPed(playerId)
        local blip = GetBlipFromEntity(ped)
        -- if not DoesBlipExist(blip) then
            if not DutyBlips[playerids] then
                if NetworkIsPlayerActive(playerId) then
                    if playerids == GetPlayerServerId(PlayerId()) then
                        blip = AddBlipForEntity(ped)
                    else
                        blip = AddBlipForCoord(playerLocation.x, playerLocation.y, playerLocation.z)
                    end
                else
                    if DutyBlips[playerids] then
                    else
                        blip = AddBlipForCoord(playerLocation.x, playerLocation.y, playerLocation.z)
                    end
                end
                ShowHeadingIndicatorOnBlip(blip, true)
                SetBlipRotation(blip, math.ceil(playerLocation.w))
                if helikopter then
                    SetBlipSprite(blip, 43)
                else
                    SetBlipSprite(blip, 1)
                end
                if playerJob == Config.job1 then
                    SetBlipColour(blip, Config.job1color)
                elseif playerJob == Config.job2 then
                    SetBlipColour(blip, Config.job2color)
                elseif playerJob == Config.job3 then
                    SetBlipColour(blip, Config.job3color)
                elseif playerJob == Config.job4 then
                    SetBlipColour(blip, Config.job4color)
                elseif playerJob == Config.job5 then
                    SetBlipColour(blip, 25)
                elseif playerJob == Config.job6 then
                    SetBlipColour(blip, 37)
                elseif playerJob == Config.job7 then
                    SetBlipColour(blip, 27)
                else
                    SetBlipColour(blip, 8)
                end
                if arac then
                    if IsPedInAnyHeli(ped) then
                        SetBlipScale(blip, 0.68)
                    else
                        SetBlipScale(blip, 0.70)
                    end
                else
                    SetBlipScale(blip, 0.4)
                end
                if helikopter then
                    SetBlipScale(blip, 0.68)
                end
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString(playerLabel)
                EndTextCommandSetBlipName(blip)
                DutyBlips[playerids] = blip
            else
                ShowHeadingIndicatorOnBlip(DutyBlips[playerids], true)
                SetBlipRotation(DutyBlips[playerids], math.ceil(playerLocation.w))
                if helikopter then
                    SetBlipSprite(DutyBlips[playerids], 43)
                else
                    SetBlipSprite(DutyBlips[playerids], 1)
                end
                if playerJob == Config.job1 then
                    SetBlipColour(DutyBlips[playerids], Config.job1color)
                elseif playerJob == Config.job2 then
                    SetBlipColour(DutyBlips[playerids], Config.job2color)
                elseif playerJob == Config.job3 then
                    SetBlipColour(DutyBlips[playerids], 46)
                elseif playerJob == Config.job4 then
                    SetBlipColour(DutyBlips[playerids], Config.job4color)
                elseif playerJob == Config.job5 then
                    SetBlipColour(DutyBlips[playerids], 25)
                elseif playerJob == Config.job6 then
                    SetBlipColour(DutyBlips[playerids], 37)
                elseif playerJob == Config.job7 then
                    SetBlipColour(DutyBlips[playerids], 27)
                else
                    SetBlipColour(DutyBlips[playerids], 8)
                end
                if arac then
                    if IsPedInAnyHeli(ped) then
                        SetBlipScale(DutyBlips[playerids], 0.68)
                    else
                        SetBlipScale(DutyBlips[playerids], 0.70)
                    end
                else
                    SetBlipScale(DutyBlips[playerids], 0.4)
                end
                if helikopter then
                    SetBlipScale(DutyBlips[playerids], 0.68)
                end
                SetBlipAsShortRange(DutyBlips[playerids], true)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString(playerLabel)
                EndTextCommandSetBlipName(DutyBlips[playerids])
            end
        -- end

        if GetBlipFromEntity(PlayerPedId()) == blip then
            -- Ensure we remove our own blip.
            -- RemoveBlip(blip)
        end
    else
        return
    end
end

RegisterCommand('gps', function(source, args)
    if gpsacik then
        if args[1] then
            QBCore.Functions.Notify("GPS Kodu " .. args[1] .. " olarak güncellendi.", "success")
            TriggerServerEvent("QBCore:Server:SetMetaData", "callsign", args[1])
        else
            QBCore.Functions.Notify('Örnek kullanım: /gps PR-823 vb.')
        end
    else
        QBCore.Functions.Notify('GPS Kapalı', "error")
    end
end)