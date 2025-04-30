local notFoundTrailer = true
local globalSearch = function()
	return GetVehicleInDirection(GetEntityCoords(PlayerPedId()), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0), nil)
end

AddEventHandler("baseevents:leftVehicle", function(currentVehicle, currentSeat, vehicleDisplayName, vehicleNetId)
	if not DoesEntityExist(currentVehicle) then
		return
	end
	local vehicleOffsetCoords = GetOffsetFromEntityInWorldCoords(currentVehicle, 0.0, 0.0, -1.0)
	local vehicleCoords = GetEntityCoords(currentVehicle)
	local testNb = 0.0
	local trailerFound = nil;
	local haveToBreak = false;
	while not trailerFound do
		trailerFound = GetVehicleInDirection(vector3(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z), vector3(vehicleOffsetCoords.x, vehicleOffsetCoords.y, vehicleOffsetCoords.z - testNb), currentVehicle)
		testNb = testNb + 0.1
		if not string.match(GetDisplayNameFromVehicleModel(GetEntityModel(trailerFound)), "TRAILER") then
			trailerFound = nil
		end
		if trailerFound == nil or trailerFound == 0 then
			Citizen.SetTimeout(5000, function()
				haveToBreak = true
			end)
		else
			haveToBreak = true
		end
		if haveToBreak then
			break
		end
		Citizen.Wait(0)
	end
	if tonumber(trailerFound) == 0 or trailerFound == nil then
		return ;
	end
	for i = 0, 5 do
		SetVehicleDoorShut(currentVehicle, i, true) -- will close all doors from 0-5
	end
	AttachEntityToEntity(currentVehicle, trailerFound, GetEntityBoneIndexByName(trailerFound, 'chassis'), GetOffsetFromEntityGivenWorldCoords(trailerFound, vehicleCoords), 0.0, 0.0, 0.0, false, false, true, false, 20, true)
	trailerFound = nil
end)

AddEventHandler("baseevents:enteredVehicle", function(currentVehicle, currentSeat, vehicleDisplayName)
	if DoesEntityExist(currentVehicle) and IsEntityAttached(currentVehicle) then
		DetachEntity(currentVehicle, true, true)
		notFoundTrailer = true
	end
end)

local CommandTable = {
	["openrampetr2"] = function()
		local trailerfind = globalSearch()
		if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
			if GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) == 'TRAILER' then
				SetVehicleDoorOpen(trailerfind, 4, false, false)
			end
			trailerfind = nil
			notFoundTrailer = true
		else
			Config.SendNotification(Config.Lang["TrailerNotFind"])
		end
	end,
	["closerampetr2"] = function()
		local trailerfind = globalSearch()
		if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
			if GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) == 'TRAILER' then
				SetVehicleDoorShut(trailerfind, 4, false, false)
			end
			trailerfind = nil
			notFoundTrailer = true
		else
			Config.SendNotification(Config.Lang["TrailerNotFind"])
		end
	end,
	["opentrunktr2"] = function()
		local trailerfind = globalSearch()
		if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
			if GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) == 'TRAILER' then
				SetVehicleDoorOpen(trailerfind, 5, false, false)
			end
			trailerfind = nil
			notFoundTrailer = true
		else
			Config.SendNotification(Config.Lang["TrailerNotFind"])
		end
	end,
	["closetrunktr2"] = function()
		local trailerfind = globalSearch()
		if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
			if GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) == 'TRAILER' then
				SetVehicleDoorShut(trailerfind, 5, true, false)
			end
			trailerfind = nil
			notFoundTrailer = true
		else
			Config.SendNotification(Config.Lang["TrailerNotFind"])
		end
	end
}

for k, v in pairs(Config.Command) do
	RegisterCommand(v, function()
		CommandTable[k]()
	end)
end

function GetVehicleInDirection(cFrom, cTo, vehId)
	if vehId == nil or vehId == 0 then
		vehId = PlayerPedId()
	end
	notFoundTrailer = true
	local rayHandle = CastRayPointToPoint(cFrom.x, cFrom.y, cFrom.z, cTo.x, cTo.y, cTo.z, 10, vehId, 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
	notFoundTrailer = vehicle == 0
	return vehicle
end
