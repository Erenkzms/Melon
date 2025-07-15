QBCore = exports['qb-core']:GetCoreObject()

local merkez = nil
local genislik = nil

-- CreateThread(function()
-- 	blip = AddBlipForRadius(2443.7249, 4976.4385, 51.5854, 400.0)
-- 	SetBlipColour(blip, 1)
-- 	SetBlipAlpha(blip, 128)
-- end)

RegisterNetEvent('alan-ayarla', function(seviye)
	if seviye == "sil" then
		if blip then
			RemoveBlip(blip)
		end
		merkez = nil
		genislik = nil
	end
	if blip then
		RemoveBlip(blip)
	end
	if tonumber(seviye) == 1 then
		merkez = vector3(5147.6284179688,-4599.6909179688,3.4211642742157) 
		genislik = 80.0
		blip = AddBlipForRadius(5147.6284179688,-4599.6909179688,3.4211642742157, 100.0)
		SetBlipColour(blip, 1)
		SetBlipAlpha(blip, 128)
	elseif tonumber(seviye) == 2 then
		merkez = vector3(4930.54296875,-4713.8100585938,12.014558792114)
		genislik = 180.0
		blip = AddBlipForRadius(4930.54296875,-4713.8100585938,12.014558792114, 150.0)
		SetBlipColour(blip, 1)
		SetBlipAlpha(blip, 128)
	elseif tonumber(seviye) == 3 then
		merkez = vector3(4994.5551757813,-5173.4174804688,2.5705380439758)
		genislik = 700.0
		blip = AddBlipForRadius(4994.5551757813,-5173.4174804688,2.5705380439758, 400.0)
		SetBlipColour(blip, 1)
		SetBlipAlpha(blip, 128)
	elseif tonumber(seviye) == 4 then
		merkez = vector3(5028.3330, -5027.4434, 2.6969)
		genislik = 1000.0
		blip = AddBlipForRadius(5028.3330, -5027.4434, 2.6969, 1000.0)
		SetBlipColour(blip, 1)
		SetBlipAlpha(blip, 128)
	end
end)

CreateThread(function()
	while true do
		if GetDistanceBetweenCoords(4879.5898, -5120.3115, 2.3267, GetEntityCoords(PlayerPedId()), false) < 1200 then
			if merkez then
				if GetDistanceBetweenCoords(merkez, GetEntityCoords(PlayerPedId()), false) > genislik then
					SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) - 10)
					QBCore.Functions.Notify('Alan dışında olduğun için hasar alıyorsun!', 'error')
					Wait(7500)
				end
			end
		end
		Wait(1000)
	end
end)

RegisterCommand('nuifix', function()
	SetNuiFocus(false, false)
end)

RegisterNetEvent('herkesi-isinla', function()
	if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), -1022.53, -2971.7, 13.95, false) < 200 then
		local ParachuteData = {
            outfitData = {
                ["bag"]   = { item = 45, texture = 22},  -- Adding Parachute Clothing
            }
        }
        TriggerEvent('qb-clothing:client:loadOutfit', ParachuteData)
		local ped = PlayerPedId()
		TriggerServerEvent('env-sifirla')
		GiveWeaponToPed(ped, `GADGET_PARACHUTE`, 1, false, false)
		Wait(1000)
		TriggerServerEvent('haso-base:additem', 'weapon_heavypistol', 1)
		TriggerServerEvent('haso-base:additem', 'clip', 1)
		TriggerServerEvent('haso-base:additem', 'etkinlik_mermi', 20)
		TriggerServerEvent('haso-base:additem', 'medikit', 20)
		TriggerServerEvent('haso-base:additem', 'armor', 20)
		TriggerServerEvent('haso-base:additem', 'enerji_icecegi', 20)
		TriggerServerEvent('haso-base:additem', 'radio', 1)
		-- TriggerServerEvent('haso-base:additem', 'lockpick', 10)
		Wait(500)
		SetEntityCoords(PlayerPedId(), 5091.62 + math.random(1, 50), -5076.54 + math.random(1, 50), 1559.9)
	end
end)

RegisterNetEvent('herkesi-isinla2', function()
	if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), -962.14385986328,-3190.9753417969,14.273668289185, false) < 25 then
		local ParachuteData = {
            outfitData = {
                ["bag"]   = { item = 45, texture = 22},  -- Adding Parachute Clothing
            }
        }
        TriggerEvent('qb-clothing:client:loadOutfit', ParachuteData)
		local ped = PlayerPedId()
		TriggerServerEvent('env-sifirla')
		GiveWeaponToPed(ped, `GADGET_PARACHUTE`, 1, false, false)
		Wait(1000)
		TriggerServerEvent('haso-base:additem', 'weapon_heavypistol', 1)
		TriggerServerEvent('haso-base:additem', 'clip', 1)
		TriggerServerEvent('haso-base:additem', 'ammo-9', 20)
		TriggerServerEvent('haso-base:additem', 'medikit', 20)
		TriggerServerEvent('haso-base:additem', 'armor', 20)
		TriggerServerEvent('haso-base:additem', 'enerji_icecegi', 20)
		TriggerServerEvent('haso-base:additem', 'radio', 1)
		-- TriggerServerEvent('haso-base:additem', 'lockpick', 10)
		Wait(500)
		SetEntityCoords(PlayerPedId(), 5091.62, -5076.54, 1559.9)
	end
end)