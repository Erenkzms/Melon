local QBCore = exports['qb-core']:GetCoreObject()


QBCore.Commands.Add("givecar", "Bir oyuncunun datasına araç ver", {}, true, function(source, args)
	TriggerClientEvent("ra1der:givecar", source)
end, "god")

QBCore.Functions.CreateCallback("ra1der:givecar:check", function(source, cb, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args.input))
	if Player == nil then
		cb(false) 
	else
		TriggerClientEvent('QBCore:Command:SpawnVehicle', tonumber(args.input), args.input2, true)
		cb(true)
	end
end)

local function GeneratePlate()
	local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
	local result = exports.oxmysql:execute('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
	if result then
		return GeneratePlate()
	else
		return plate:upper()
	end
end

QBCore.Functions.CreateCallback("ra1der:givecar:check", function(source, cb, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args.input))
	if Player == nil then
		cb(false) 
	else
		TriggerClientEvent('spawnVehicle:client', tonumber(args.input), args.input2, GeneratePlate(), true)
		cb(true)
	end
end)

RegisterServerEvent("giveCar", function(vehicleProps, vehiclemodel, vehicle)
	local pData = QBCore.Functions.GetPlayer(source)
	exports.oxmysql:execute('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
		pData.PlayerData.license,
		pData.PlayerData.citizenid,
		vehiclemodel,
		GetHashKey(vehiclemodel),
		json.encode(vehicleProps),
		vehicleProps.plate,
		'',
		0
	}, function() 
		TriggerClientEvent("QBCore:Notify", pData.PlayerData.source, vehicleProps.plate.." plakalı araç artık senin")
	end)
end)




