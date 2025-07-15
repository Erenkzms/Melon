local PlayerPed = PlayerPedId
local playerCoords = GetEntityCoords(PlayerPed())

local lastWeapon = nil 
local hasNotifiedOutOfArea = false

function isPlayerInArea()
    local playerPed = PlayerPed()
    local playerCoords = GetEntityCoords(playerPed)
    return #(playerCoords - Config.Location) < Config.Radius
end

function isWeaponAllowed(weapon)
    return weapon == GetHashKey(Config.AllowedWeapon)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) 
        local playerPed = PlayerPed()
        local currentWeapon = GetSelectedPedWeapon(playerPed)

        if currentWeapon ~= lastWeapon then
            lastWeapon = currentWeapon

            if not isPlayerInArea() and isWeaponAllowed(currentWeapon) then
                if not hasNotifiedOutOfArea then
                    exports['mythic_notify']:SendAlert('error', 'Etkinlik Alanında Değilsiniz.')
                    hasNotifiedOutOfArea = true
                end

                SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)
            elseif isPlayerInArea() and isWeaponAllowed(currentWeapon) then
                exports['mythic_notify']:SendAlert('success', 'Etkinlik Silahınız Bu Alanda Kullanılabilir.')
                hasNotifiedOutOfArea = false
            end
        end
    end
end)

-- hastane pit atmazsın
local safeZoneCenter = vector3(299.5, -584.74, 43.26)
local safeZoneRadius = 150.0 -- Radius

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pedPos = GetEntityCoords(ped)
        local vehList = GetGamePool('CVehicle')
        
       
        if #(pedPos - safeZoneCenter) <= safeZoneRadius then
            for _, vehicle in pairs(vehList) do
                
                SetEntityNoCollisionEntity(vehicle, ped, true)

                
                for _, otherVehicle in pairs(vehList) do
                    if vehicle ~= otherVehicle then
                        SetEntityNoCollisionEntity(vehicle, otherVehicle, true)
                    end
                end
            end
        end

        Citizen.Wait(1) 
    end
end)