local playerPed = PlayerPedId()
local playerCoords = GetEntityCoords(playerPed)
local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    while true do
        sleep = 2000
        playerPed = PlayerPedId()
        playerCoords = GetEntityCoords(playerPed)

        for _, depo in pairs(Config.Depolar) do
            local distance = #(playerCoords - depo.coords)

            if distance < Config.Distance then
                sleep = 0
                if not depo.personal then
                    DrawText3D(depo.coords.x, depo.coords.y, depo.coords.z, '[E] Depo')
                else
                    DrawText3D(depo.coords.x, depo.coords.y, depo.coords.z, '[E] Kisisel Depo')
                end

                if distance < 1.5 and IsControlJustReleased(0, 38) then
                    if depo.jobs then
                        if QBCore.Functions.GetPlayerData().job.name ~= depo.jobs then
                            QBCore.Functions.Notify("Bu depoyu açma iznin yok.", "error")
                            break
                        end
                    elseif depo.gangs then
                        if QBCore.Functions.GetPlayerData().gang.name ~= depo.gangs then
                            QBCore.Functions.Notify("Bu depoyu açma iznin yok.", "error")
                            break
                        end
                    end

                    local stashId = depo.id
                    if depo.personal then
                        stashId = depo.shared and "Personal_"..QBCore.Functions.GetPlayerData().citizenid or stashId.."_"..QBCore.Functions.GetPlayerData().citizenid
                    end

                    if exports.ox_inventory:openInventory('stash', stashId) == false then
                        TriggerServerEvent('atomik-stash:server:depo', stashId, depo.label, depo.slots, depo.weight, depo.jobs)
                        exports.ox_inventory:openInventory('stash', stashId)
                    end
                end
            end
        end
        Wait(sleep) 
    end
end)



function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local scale = 0.35

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextEntry("STRING")
        SetTextCentre(1)
        SetTextColour(255, 255, 255, 215)

        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 150)
    end
end
