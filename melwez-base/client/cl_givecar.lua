local QBCore = exports['qb-core']:GetCoreObject()
PlayerData = QBCore.Functions.GetPlayerData()




RegisterNetEvent('spawnVehicle:client')
AddEventHandler('spawnVehicle:client', function(vehiclemodel, plate, type)
	local PlayerData = QBCore.Functions.GetPlayerData()
	local playerPed = PlayerPedId()
	local pCoords = GetEntityCoords(playerPed)
	pCoords = vector4(pCoords.x, pCoords.y, pCoords.z, GetEntityHeading(PlayerPedId()))
	QBCore.Functions.SpawnVehicle(vehiclemodel, function(vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

		local newPlate     = plate
		local vehicleProps = QBCore.Functions.GetVehicleProperties(vehicle)
		vehicleProps.plate = newPlate
		SetVehicleNumberPlateText(vehicle, newPlate)
		TriggerServerEvent('giveCar', vehicleProps, vehiclemodel, type)
		-- TriggerEvent("qb-vehiclekeys:client:GiveKeys", GetPlayerServerId(PlayerId()))
		TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(vehicle))
	end, pCoords, 1)
end)

RegisterNetEvent("ra1der:givecar", function()
	local keyboard = exports['qb-input']:ShowInput({
		header = "Bir oyuncuya araç verin",
		submitText = "Onayla",
		inputs = {
			{
				type = 'text',
				isRequired = true,
				text = "Oyuncu ID",
				name = 'input',
			},
			{
				type = 'text',
				isRequired = true,
				text = "Araç İsmi",
				name = 'input2',
			}
		}
	})
	-- if not IsModelValid(keyboard.input2) then 
	-- 	QBCore.Functions.Notify(keyboard.input2.. " İsimli Araç Bulunamadı", "error")
	-- 	return 
	-- end
	QBCore.Functions.TriggerCallback('ra1der:givecar:check', function(result)
		if result then 
			QBCore.Functions.Notify(keyboard.input.. " ID'li kişiye" ..keyboard.input2.. " İsimli Araç Verildi", "success", 5000)
		else 
			QBCore.Functions.Notify(keyboard.input.. " ID'li oyuncu bulunamadı", "error")
		end
	
	end, keyboard)
end)





