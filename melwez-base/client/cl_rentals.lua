local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("qb-rental:vehiclelist", function()
  for i = 1, #Config.vehicleList do
      if Config.setupMenu == 'nh-context' then
        TriggerEvent('nh-context:sendMenu', {
          {
            id = Config.vehicleList[i].model,
            header = Config.vehicleList[i].name,
            txt = "$"..Config.vehicleList[i].price..".00",
            params = {
              event = "qb-rental:attemptvehiclespawn",
              args = {
                id = Config.vehicleList[i].model,
                price = Config.vehicleList[i].price,
              }
            }
          },
        })
      elseif Config.setupMenu == 'qb-menu' then
        	local MenuOptions = {
        		{
        			header = "Araç Kirala",
        			isMenuHeader = true
        		},
        	}
        	for k, v in pairs(Config.vehicleList) do
          
          
        		MenuOptions[#MenuOptions+1] = {
        			header = "<h8>"..v.name.."</h>",
              txt = "$"..v.price..".00",
        			params = {
                event = "qb-rental:attemptvehiclespawn",
                args = {
                  id = v.model,
                  price = v.price
                }
        			}
        		}
        	end
        	exports['qb-menu']:openMenu(MenuOptions)
      end
    end
end)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


RegisterNetEvent("qb-rental:boatList", function()
  for i = 1, #Config.BoatList do
      if Config.setupMenu == 'nh-context' then
        TriggerEvent('nh-context:sendMenu', {
          {
            id = Config.BoatList[i].model,
            header = Config.BoatList[i].name,
            txt = "$"..Config.BoatList[i].price..".00",
            params = {
              event = "qb-rental:attemptboatsspawn",
              args = {
                id = Config.BoatList[i].model,
                price = Config.BoatList[i].price,
              }
            }
          },
        })
      elseif Config.setupMenu == 'qb-menu' then
        	local MenuOptions = {
        		{
        			header = "Tekne Kirala",
        			isMenuHeader = true
        		},
        	}
        	for k, v in pairs(Config.BoatList) do
          
          
        		MenuOptions[#MenuOptions+1] = {
        			header = "<h8>"..v.name.."</h>",
              txt = "$"..v.price..".00",
        			params = {
                event = "qb-rental:attemptboatsspawn",
                args = {
                  id = v.model,
                  price = v.price
                }
        			}
        		}
        	end
        	exports['qb-menu']:openMenu(MenuOptions)
      end
    end
end)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("qb-rental:attemptvehiclespawn", function(vehicle)
    TriggerServerEvent("qb-rental:attemptPurchase",vehicle.id, vehicle.price)
end)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("qb-rental:attemptboatsspawn", function(vehicle)
  TriggerServerEvent("qb-rental:rdaBotPurchase",vehicle.id, vehicle.price)
end)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("qb-rental:attemptvehiclespawnfail", function()
  QBCore.Functions.Notify("Yeterince paran yok!", "error")
end)

local PlayerName = nil

RegisterNetEvent("qb-rental:giverentalpaperClient", function(model, plate, name)

  local info = {
    data = "Model : "..tostring(model).." | Plate : "..tostring(plate)..""
  }
  TriggerServerEvent('QBCore:Server:AddItem', "rentalpapers", 1, info)
end)

RegisterNetEvent("qb-rental:returnvehicle", function()
  local car = GetVehiclePedIsIn(PlayerPedId(),true)

  if car ~= 0 then
    local plate = GetVehicleNumberPlateText(car)
    local vehname = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(car)))
    if string.find(tostring(plate), "SA") then
      QBCore.Functions.TriggerCallback('qb-rental:server:hasrentalpapers', function(HasItem)
        if HasItem then
          TriggerServerEvent("qb-rental:server:removeitem", "rentalpapers", 1)
          TriggerServerEvent('qb-rental:server:payreturn',vehname)
          QBCore.Functions.DeleteVehicle(car)
        else
          QBCore.Functions.Notify("Belgen olmadan aracı iade edemezsin!", "error")
        end
      end)
    else
      QBCore.Functions.Notify("Bu araç kiralık değil!", "error")
    end

  else
    QBCore.Functions.Notify("Kiralık araç göremiyorum, yakınlarda olduğundan emin olun", "error")
  end
end)

RegisterNetEvent("qb-rental:vehiclespawn", function(data, cb)
  local model = data

  local closestDist = 10000
  local closestSpawn = nil
  local pcoords = GetEntityCoords(PlayerPedId())
  
  for i, v in ipairs(Config.vehicleSpawn) do
      local dist = #(v.workSpawn.coords - pcoords)
  
      if dist < closestDist then
          closestDist = dist
          closestSpawn = v.workSpawn
      end
  end

  RequestModel(model)
  while not HasModelLoaded(model) do
      Citizen.Wait(0)
  end
  SetModelAsNoLongerNeeded(model)

  QBCore.Functions.SpawnVehicle(model, function(veh)
    SetVehicleNumberPlateText(veh, "SA"..tostring(math.random(1000, 9999)))
    SetEntityHeading(veh, closestSpawn.heading)
    exports['LegacyFuel']:SetFuel(veh, 100.0)
    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    SetEntityAsMissionEntity(veh, true, true)
    TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh), exports["haso-getkey"]:GetKey())
    SetVehicleEngineOn(veh, true, true)
    CurrentPlate = QBCore.Functions.GetPlate(veh)
  end, closestSpawn.coords, true)

  local plateText = GetVehicleNumberPlateText(veh)
  TriggerServerEvent("qb-rental:giverentalpaperServer",model ,plateText)

  local timeout = 10
  while not NetworkDoesEntityExistWithNetworkId(veh) and timeout > 0 do
      timeout = timeout - 1
      Wait(1000)
  end
end)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("qb-rental:boatspawn", function(data, cb)
  local model = data

  local closestDist = 10000
  local closestSpawn = nil
  local pcoords = GetEntityCoords(PlayerPedId())
  
  for i, v in ipairs(Config.boatspawn) do 
      local dist = #(v.workSpawn2.coords - pcoords)
  
      if dist < closestDist then
          closestDist = dist
          closestSpawn = v.workSpawn2
      end
  end

  RequestModel(model)
  while not HasModelLoaded(model) do
      Citizen.Wait(0)
  end
  SetModelAsNoLongerNeeded(model)

  QBCore.Functions.SpawnVehicle(model, function(veh)
    SetVehicleNumberPlateText(veh, "SA"..tostring(math.random(1000, 9999)))
    SetEntityHeading(veh, closestSpawn.heading)
    exports['LegacyFuel']:SetFuel(veh, 100.0)
    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    SetEntityAsMissionEntity(veh, true, true)
    TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh), exports["haso-getkey"]:GetKey())
    SetVehicleEngineOn(veh, true, true)
    CurrentPlate = QBCore.Functions.GetPlate(veh)
  end, closestSpawn.coords, true)

  local plateText = GetVehicleNumberPlateText(veh)
  TriggerServerEvent("qb-rental:giverentalpaperServer",model ,plateText)

  local timeout = 10
  while not NetworkDoesEntityExistWithNetworkId(veh) and timeout > 0 do
      timeout = timeout - 1
      Wait(1000)
  end
end)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler("qb-inventory:itemUsed", function(item, info)
  if item == "rentalpapers" then

    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
      data = json.decode(info)
      local vin = GetVehicleNumberPlateText(plyVeh)
      local isRental = vin ~= nil and string.sub(vin, 2, 3) == "SA"
      if isRental then
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh), exports["haso-getkey"]:GetKey())
        QBCore.Functions.Notify("Aracın anahtarını aldın", "success")
      else
        QBCore.Functions.Notify("Bu kiralama mevcut değil", "success")
      end
  end
end)

-- Adding Blips in config folder # MoneSuper
CreateThread(function()
  for _, rental in pairs(Config.Locations["rentalstations"]) do
      local blip = AddBlipForCoord(rental.coords.x, rental.coords.y, rental.coords.z)
      SetBlipSprite(blip, 525)
      SetBlipAsShortRange(blip, true)
      SetBlipScale(blip, 0.5)
      SetBlipColour(blip, 0)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(rental.label)
      EndTextCommandSetBlipName(blip)
  end
end)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CreateThread(function()
  for _, rental in pairs(Config.Locations2["bunudegisiyom"]) do
      local blip = AddBlipForCoord(rental.coords.x, rental.coords.y, rental.coords.z)
      SetBlipSprite(blip, 525)
      SetBlipAsShortRange(blip, true)
      SetBlipScale(blip, 0.5)
      SetBlipColour(blip, 0)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(rental.label)
      EndTextCommandSetBlipName(blip)
  end
end)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CreateThread(function()
  for i = 1, #Config.rentacarped do
      RegisterPed(Config.rentacarped[i])
  end
end)

RegisterPed = function(cData)
  RegisterModel(cData.model)
  cData.handle = CreatePed(4, cData.model, cData.pos, cData.heading, false, true)

  exports['qb-target']:AddTargetEntity(cData.handle, {
      options = {
          {
              event = "qb-rental:vehiclelist",
              icon = "fas fa-circle",
              label = "Araç Kirala",
          },
          {
              event = "qb-rental:returnvehicle",
              icon = "fas fa-circle",
              label = "Araç iade et (Maliyetin %50'sini geri al)",
          },
      },
      distance = 2
  })

  SetEntityAsMissionEntity(cData.handle, true, false)
  FreezeEntityPosition(cData.handle, true)
  SetPedCanRagdoll(cData.handle, false)
  TaskSetBlockingOfNonTemporaryEvents(cData.handle, 1)
  SetBlockingOfNonTemporaryEvents(cData.handle, 1)
  SetPedFleeAttributes(cData.handle, 0, 0)
  SetPedCombatAttributes(cData.handle, 17, 1)
  SetEntityInvincible(cData.handle, true)
  SetPedSeeingRange(cData.handle, 0)    
end

RegisterModel = function(model)
  RequestModel(GetHashKey(model))
  while not HasModelLoaded(GetHashKey(model)) do
    Wait(1)
  end
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CreateThread(function()
  for i = 1, #Config.rentacarboatped do
      RegisterPed2(Config.rentacarboatped[i])
  end
end)

RegisterPed2 = function(cData)
  RegisterModel2(cData.model)
  cData.handle = CreatePed(4, cData.model, cData.pos, cData.heading, false, true)

  exports['qb-target']:AddTargetEntity(cData.handle, {
    options = {
        {
            event = "qb-rental:boatList",
            icon = "fas fa-circle",
            label = "Tekne Kirala",
        },
        {
            event = "qb-rental:returnvehicle",
            icon = "fas fa-circle",
            label = "Tekne iade et (Maliyetin %50'sini geri al)",
        },
    },
    distance = 2
  })

  SetEntityAsMissionEntity(cData.handle, true, false)
  FreezeEntityPosition(cData.handle, true)
  SetPedCanRagdoll(cData.handle, false)
  TaskSetBlockingOfNonTemporaryEvents(cData.handle, 1)
  SetBlockingOfNonTemporaryEvents(cData.handle, 1)
  SetPedFleeAttributes(cData.handle, 0, 0)
  SetPedCombatAttributes(cData.handle, 17, 1)
  SetEntityInvincible(cData.handle, true)
  SetPedSeeingRange(cData.handle, 0)    
end

RegisterModel2 = function(model)
  RequestModel(GetHashKey(model))
  while not HasModelLoaded(GetHashKey(model)) do
    Wait(1)
  end
end