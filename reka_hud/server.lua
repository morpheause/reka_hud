RegisterNetEvent('reka_hud:server:enabledCruiseForPassengers')
AddEventHandler('reka_hud:server:enabledCruiseForPassengers', function(target, value)
    TriggerClientEvent('reka_hud:client:enabledCruiseForPassengers', target, value)
end)

RegisterNetEvent('reka_hud:server:closedCruiseForPassengers')
AddEventHandler('reka_hud:server:closedCruiseForPassengers', function(target, value)
    TriggerClientEvent('reka_hud:client:closedCruiseForPassengers', target, value)
end)