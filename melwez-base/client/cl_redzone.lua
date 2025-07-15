local redZoneCoords = Config.RedZoneCoords
local redZoneRadius = Config.RedZoneRadius
local redZoneDamageInterval = Config.RedZoneDamageInterval
local redZoneDamageAmount = Config.RedZoneDamageAmount

CreateThread(function()
    local blip = AddBlipForRadius(redZoneCoords.x, redZoneCoords.y, redZoneCoords.z, redZoneRadius)
    SetBlipColour(blip, 1) -- Kırmızı renk
    SetBlipAlpha(blip, 128)
    SetBlipAsShortRange(blip, true)

    local markerBlip = AddBlipForCoord(redZoneCoords.x, redZoneCoords.y, redZoneCoords.z)
    SetBlipSprite(markerBlip, 161)
    SetBlipColour(markerBlip, 1)
    SetBlipScale(markerBlip, 1.0)
    SetBlipAsShortRange(markerBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Red Zone")
    EndTextCommandSetBlipName(markerBlip)
end)

CreateThread(function()
    local notifiedPlayers = {}
    while true do
        Wait(redZoneDamageInterval)
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        local distance = #(playerPos - redZoneCoords)
        local playerVeh = GetVehiclePedIsIn(playerPed, false)

        if playerVeh ~= 0 and distance <= redZoneRadius then
            if not notifiedPlayers[playerPed] then
                exports['mythic_notify']:SendAlert('error', 'Araçla Redzone Bölgesine Girdin! Hasar alıyorsunuz.')
                notifiedPlayers[playerPed] = true
            end
            local currentHealth = GetEntityHealth(playerPed)
            local newHealth = math.max(currentHealth - redZoneDamageAmount, 150)
            SetEntityHealth(playerPed, newHealth)
        else
            notifiedPlayers[playerPed] = nil
        end
    end
end)
