RegisterNetEvent("baseevents:leftVehicle")
AddEventHandler("baseevents:leftVehicle", function(currentVehicle, currentSeat, vehicleDisplayName, vehicleNetId)
    TriggerClientEvent("trailer:leftVehicle",-1, currentVehicle)
end)

RegisterNetEvent("baseevents:enteredVehicle")
AddEventHandler("baseevents:enteredVehicle", function(currentVehicle, currentSeat, vehicleDisplayName)
    TriggerClientEvent("trailer:enteredVehicle",-1, currentVehicle)
end)