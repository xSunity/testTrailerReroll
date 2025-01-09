local notfindtrailer = true
local globalSearch = function()
    return GetVehicleInDirection(GetEntityCoords(PlayerPedId()), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0), nil)
end

RegisterNetEvent('trailer:leftVehicle', function(vehId)
    if not DoesEntityExist(vehId) then
        return 
    end
    local vehicleOffsetCoords = GetOffsetFromEntityInWorldCoords(vehId, 0.0, 0.0, -1.0)
    local vehicleCoords = GetEntityCoords(vehId)
    havefindclass = false
    local testnb = 0.0
	local trailerFind = nil;
    local havetobreak = false;
    while not trailerFind do
        trailerFind = GetVehicleInDirection(vector3(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z), vector3(vehicleOffsetCoords.x, vehicleOffsetCoords.y, vehicleOffsetCoords.z - testnb), vehId)
        testnb = testnb + 0.1
		if not string.match(GetDisplayNameFromVehicleModel(GetEntityModel(trailerFind)),"TRAILER") then
			trailerFind = nil
		end
        if trailerFind == nil or trailerFind == 0 then
            Citizen.SetTimeout(5000, function()
                havetobreak = true
            end)
        else 
            havetobreak = true
        end
        if havetobreak then
            break
        end
        Citizen.Wait(0)
    end
    if tonumber(trailerFind) == 0 or trailerFind == nil then
		return;
	end
    for i = 0, 5 do
        SetVehicleDoorShut(vehId, i, true) -- will close all doors from 0-5
    end
    AttachEntityToEntity(vehId, trailerFind, GetEntityBoneIndexByName(trailerFind, 'chassis'), GetOffsetFromEntityGivenWorldCoords(trailerFind, vehicleCoords), 0.0, 0.0, 0.0, false, false, true, false, 20, true)
    trailerFind = nil
end)

RegisterNetEvent('trailer:enteredVehicle', function(vehId)
    if DoesEntityExist(vehId) and IsEntityAttached(vehId) then
        DetachEntity(vehId, true, true)
        notfindtrailer = true
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
            notfindtrailer = true
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
            notfindtrailer = true
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
            notfindtrailer = true
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
            notfindtrailer = true
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
    notfindtrailer = true
    local rayHandle = CastRayPointToPoint(cFrom.x, cFrom.y, cFrom.z, cTo.x, cTo.y, cTo.z, 10, vehId, 0)
    local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
    notfindtrailer = vehicle == 0
    return vehicle
end
