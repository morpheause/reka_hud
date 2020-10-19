local toghud = true
local seatbeltenabled = false
local currentmode = 2
local cruisecontrolenabled, cruisevalue = false, nil
local compass = false
local isTalking, isTalkingOnRadio = false, false

RegisterCommand('hud', function(_)
    toghud = not toghud
    SendNUIMessage({
        action = 'toggleHUD',
        show = toghud,
    })
end)

AddEventHandler('playerSpawned', function()
    Citizen.Wait(8000)
    SendNUIMessage({
        action = 'toggleHUD',
        show = toghud,
    })
    setVoipMode(currentmode)
end)

Citizen.CreateThread(function()
    while true do
        TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
            TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)

                local myhunger = hunger.getPercent()
                local mythirst = thirst.getPercent()
                
                SendNUIMessage({
                    action = "updateStatusHTHud",
                    hunger = math.ceil(myhunger),
                    thirst = math.ceil(mythirst)
                })
            end)
        end)
        Citizen.Wait(5000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        local player = PlayerPedId()
        local health = math.floor(GetEntityHealth(player) - 100)
        if health < 1 then
            health = 1
        end
        if health == 100 and IsEntityPlayingAnim(player, 'misslamar1dead_body', 'dead_idle', 3) then
            health = 1
        end

        local armor = GetPedArmour(player)
        if armor < 1 then
            armor = false
        end

        local oxy = false
        if IsPedSwimmingUnderWater(player) then
            oxy = math.ceil(GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10)
            if oxy < 1 then
                oxy = 1
            end
        else
            oxy = false
        end

        local stamina = false
        if not IsPedInAnyVehicle(player, false) then
            stamina = math.ceil(100 - GetPlayerSprintStaminaRemaining(PlayerId()))
        else
            stamina = false
        end

        local parachute = HasPedGotWeapon(player, `gadget_parachute`, false)
        if parachute then
            parachute = 100
        end
        
        SendNUIMessage({
            action = 'updateStatusHAOSHud',
            health = health,
            armor = armor,
            oxygen = oxy,
            stamina = stamina,
            parachute = parachute
        })
        Citizen.Wait(500)
    end
end)

--main thread
local currSpeed = 0.0
local prevVelocity = {x = 0.0, y = 0.0, z = 0.0}
local vehIsMovingFwd = 0
local seatbeltEjectSpeed = 165.0
local seatbeltEjectAccel = 80.0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        local player = PlayerPedId()
        
        local fuel = false
        local km = false
        local enginehealth = false
        local seatbelt = false
        local cruise = false
        local time = false
        local street = false
        local direction = false
        if IsPedInAnyVehicle(player, false) then
            local vehicle = GetVehiclePedIsIn(player, false)
            if not seatbeltenabled then
                seatbelt = 100
            else
                seatbelt = false
            end

            if not IsThisModelABicycle(GetEntityModel(vehicle)) and
            not IsThisModelABoat(GetEntityModel(vehicle)) and
            not IsThisModelAHeli(GetEntityModel(vehicle)) and
            -- not IsThisModelAJetski(GetEntityModel(vehicle)) and
            not IsThisModelABike(GetEntityModel(vehicle)) and
            not IsThisModelAPlane(GetEntityModel(vehicle)) then
                fuel = math.ceil(exports["LegacyFuel"]:GetFuel(vehicle))
            end
            
            km = math.ceil(GetEntitySpeed(vehicle) * 3.6)
            if km < 1 then
                km = 1
            end
            if not seatbeltenabled then
                local prevSpeed = currSpeed
                currSpeed = GetEntitySpeed(vehicle)
                local position = GetEntityCoords(player)
                vehIsMovingFwd = GetEntitySpeedVector(vehicle, true).y > 1.0
                local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()

                if (vehIsMovingFwd and (prevSpeed > (seatbeltEjectSpeed/2.237)) and (vehAcc > (seatbeltEjectAccel*9.81))) then
                    SetEntityCoords(player, position.x, position.y, position.z - 0.47, true, true, true)
                    SetEntityVelocity(player, prevVelocity.x, prevVelocity.y, prevVelocity.z)
                    Citizen.Wait(1)
                    SetPedToRagdoll(player, 1000, 1000, 0, 0, 0, 0)
                else
                    prevVelocity = GetEntityVelocity(vehicle)
                end
            end
            local enginevalue = (GetVehicleEngineHealth(vehicle) - 990) * -1
            if enginevalue > 1000 then
                enginevalue = 1000
            elseif enginevalue < 0 then
                enginevalue = 10
            end
            enginehealth = math.floor(enginevalue / 10)
            if cruisecontrolenabled then
                cruise = math.floor(cruisevalue * 3.6) + 1
                SetEntityMaxSpeed(vehicle, cruisevalue)
            else
                cruise = false
                SetEntityMaxSpeed(vehicle, GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel"))
            end
            if IsVehicleSeatFree(vehicle, -1) then
                cruise = false
                cruisecontrolenabled, cruisevalue = false, nil
                SetEntityMaxSpeed(vehicle, GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel"))
            end

            if compass then
                local x, y, z = table.unpack(GetEntityCoords(player, true))
                local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
                currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
                intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
                zone = tostring(GetNameOfZone(x, y, z))
                local area = GetLabelText(zone)
                playerStreetsLocation = area

                if not zone then
                    zone = "UNKNOWN"
                end

                if intersectStreetName ~= nil and intersectStreetName ~= "" then
                    playerStreetsLocation = currentStreetName .. " | " .. intersectStreetName .. " | [" .. area .. "]"
                elseif currentStreetName ~= nil and currentStreetName ~= "" then
                    playerStreetsLocation = currentStreetName .. " | [" .. area .. "]"
                else
                    playerStreetsLocation = "[".. area .. "]"
                end

                local hours = GetClockHours()
                if string.len(tostring(hours)) == 1 then
                    trash = '0'..hours
                else
                    trash = hours
                end
        
                local mins = GetClockMinutes()
                if string.len(tostring(mins)) == 1 then
                    mins = '0'..mins
                else
                    mins = mins
                end
                time = hours .. ':' .. mins
                street = playerStreetsLocation
                direction = math.floor(calcHeading(-GetGameplayCamRot().z % 360))
            end
        else
            seatbeltenabled = false
            cruisecontrolenabled, cruisevalue = false, nil
            Citizen.Wait(70)
        end
        SendNUIMessage({
            action = 'updateStatusFKHud',
            km = km,
            fuel = fuel,
            enginehealth = enginehealth
        })
        SendNUIMessage({
            action = 'updateSeatbeltHud',
            seatbelt = seatbelt
        })
        SendNUIMessage({
            action = 'updateCruiseHud',
            cruisecontrol = cruise
        })
        SendNUIMessage({
            action = "updateCSTHud",
            time = time,
            street = street,
            direction = direction,
        })

        if isTalking and not isTalkingOnRadio then
            if currentMode == 1 then
                SendNUIMessage({
                    action = "setVoipTalking1",
                })
            elseif currentMode == 2 then
                SendNUIMessage({
                    action = "setVoipTalking2",
                })
            elseif currentMode == 3 then
                SendNUIMessage({
                    action = "setVoipTalking3",
                })
            end
        elseif not isTalking and not isTalkingOnRadio then
            if currentMode == 1 then
                SendNUIMessage({
                    action = "setVoipMode1",
                })
            elseif currentMode == 2 then
                SendNUIMessage({
                    action = "setVoipMode2",
                })
            elseif currentMode == 3 then
                SendNUIMessage({
                    action = "setVoipMode3",
                })
            end
        elseif isTalkingOnRadio then
            if currentMode == 1 then
                SendNUIMessage({
                    action = "setVoipTalkingOnRadio1",
                })
            elseif currentMode == 2 then
                SendNUIMessage({
                    action = "setVoipTalkingOnRadio2",
                })
            elseif currentMode == 3 then
                SendNUIMessage({
                    action = "setVoipTalkingOnRadio3",
                })
            end
        end
    end
end)

RegisterCommand('+seatbelt', function()
    local player = PlayerPedId()

    local seatbelt = false
    if IsPedInAnyVehicle(player, false) then
        local vehicle = GetVehiclePedIsIn(player, false)

        if not seatbeltenabled then
            seatbelt = 100
        end
        if not seatbeltenabled then
            seatbeltenabled = true
            TriggerEvent('InteractSound_CL:PlayOnOne', 'buckle', 0.5)
            PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
        elseif seatbeltenabled then
            seatbeltenabled = false
            PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
            TriggerEvent('InteractSound_CL:PlayOnOne', 'unbuckle', 0.5)
        end
    end

    SendNUIMessage({
        action = 'updateSeatbeltHud',
        seatbelt = seatbelt
    })
end)

RegisterCommand('+cruisecontrol', function()
    local player = PlayerPedId()

    local cruise = false
    if IsPedInAnyVehicle(player, false) then
        local vehicle = GetVehiclePedIsIn(player, false)

        if GetPedInVehicleSeat(vehicle, -1) == player then
            if not cruisecontrolenabled then
                cruisevalue = GetEntitySpeed(vehicle)
                exports['mythic_notify']:SendAlert('success', 'Hızınız '..(math.floor(cruisevalue * 3.6) + 1)..' km/h\'a sabitlendi.')
                cruisecontrolenabled = true
                cruise = math.floor(cruisevalue * 3.6) + 1
                for i=1, GetVehicleModelNumberOfSeats(GetEntityModel(vehicle)) do
                    if i ~= 1 then
                        if not IsVehicleSeatFree(vehicle, i-2) then 
                            local otherPlayerId = GetPedInVehicleSeat(vehicle, i-2) 
                            local playerHandle = NetworkGetPlayerIndexFromPed(otherPlayerId)
                            local playerServerId = GetPlayerServerId(playerHandle)
                            TriggerServerEvent('reka_hud:server:enabledCruiseForPassengers', playerServerId, cruisevalue)
                        end
                    end
                end
            else
                exports['mythic_notify']:SendAlert('error', 'Hız sabitlemesi kaldırıldı.')
                cruisecontrolenabled, cruisevalue = false, nil
                for i=1, GetVehicleModelNumberOfSeats(GetEntityModel(vehicle)) do
                    if i ~= 1 then
                        if not IsVehicleSeatFree(vehicle, i-2) then 
                            local otherPlayerId = GetPedInVehicleSeat(vehicle, i-2) 
                            local playerHandle = NetworkGetPlayerIndexFromPed(otherPlayerId)
                            local playerServerId = GetPlayerServerId(playerHandle)
                            TriggerServerEvent('reka_hud:server:closedCruiseForPassengers', playerServerId)
                        end
                    end
                end
            end
        else
            exports['mythic_notify']:SendAlert('error', 'Sürücü koltuğunda olmanız gerekiyor.')
        end
    end
    SendNUIMessage({
        action = 'updateCruiseHud',
        cruisecontrol = cruise
    })
end)

RegisterCommand("hizsabitle", function(_, args)
    local player = PlayerPedId()
    if IsPedInAnyVehicle(player, false) then
        local vehicle = GetVehiclePedIsIn(player, false)
        if args[1] ~= nil then
            if GetPedInVehicleSeat(vehicle, -1) == player then
                if tonumber(args[1]) > 0 then
                    cruisevalue = tonumber(args[1]) / 3.6
                    cruisecontrolenabled = true
                    exports['mythic_notify']:SendAlert('inform', 'Hızınız '..tonumber(args[1])..'km/h\'a sabitlendi.')
                    SendNUIMessage({
                        action = 'updateCruiseHud',
                        cruisecontrol = tonumber(args[1])
                    })
                    for i=1, GetVehicleModelNumberOfSeats(GetEntityModel(vehicle)) do
                        if i ~= 1 then
                            if not IsVehicleSeatFree(vehicle, i-2) then 
                                local otherPlayerId = GetPedInVehicleSeat(vehicle, i-2) 
                                local playerHandle = NetworkGetPlayerIndexFromPed(otherPlayerId)
                                local playerServerId = GetPlayerServerId(playerHandle)
                                TriggerServerEvent('reka_hud:server:enabledCruiseForPassengers', playerServerId, cruisevalue)
                            end
                        end
                    end
                elseif tonumber(args[1]) < 1 then
                    cruisecontrolenabled, cruisevalue = false, nil
                    exports['mythic_notify']:SendAlert('error', 'Hız sabitlemesi kaldırıldı.')
                    SendNUIMessage({
                        action = 'updateCruiseHud',
                        cruisecontrol = false
                    })
                    for i=1, GetVehicleModelNumberOfSeats(GetEntityModel(vehicle)) do
                        if i ~= 1 then
                            if not IsVehicleSeatFree(vehicle, i-2) then 
                                local otherPlayerId = GetPedInVehicleSeat(vehicle, i-2) 
                                local playerHandle = NetworkGetPlayerIndexFromPed(otherPlayerId)
                                local playerServerId = GetPlayerServerId(playerHandle)
                                TriggerServerEvent('reka_hud:server:closedCruiseForPassengers', playerServerId)
                            end
                        end
                    end
                end
            else
                exports['mythic_notify']:SendAlert('error', 'Sürücü koltuğunda olmanız gerekiyor.')
            end
        else
            cruisecontrolenabled, cruisevalue = false, nil
            exports['mythic_notify']:SendAlert('error', 'Hız sabitlemesi kaldırıldı.')
            SendNUIMessage({
                action = 'updateCruiseHud',
                cruisecontrol = false
            })
            for i=1, GetVehicleModelNumberOfSeats(GetEntityModel(vehicle)) do
                if i ~= 1 then
                    if not IsVehicleSeatFree(vehicle, i-2) then 
                        local otherPlayerId = GetPedInVehicleSeat(vehicle, i-2) 
                        local playerHandle = NetworkGetPlayerIndexFromPed(otherPlayerId)
                        local playerServerId = GetPlayerServerId(playerHandle)
                        TriggerServerEvent('reka_hud:server:closedCruiseForPassengers', playerServerId)
                    end
                end
            end
        end
    else
        exports['mythic_notify']:SendAlert('inform', 'Araç içinde olmanız gerekiyor.')
    end
end)

RegisterCommand('pusula', function()
    compass = not compass
end)

RegisterNetEvent('reka_hud:client:enabledCruiseForPassengers')
AddEventHandler('reka_hud:client:enabledCruiseForPassengers', function(value)
    print(value)
    cruisevalue = value
    cruisecontrolenabled = true
    SendNUIMessage({
        action = 'updateCruiseHud',
        cruisecontrol = math.floor(value * 3.6) + 1
    })
end)

RegisterNetEvent('reka_hud:client:closedCruiseForPassengers')
AddEventHandler('reka_hud:client:closedCruiseForPassengers', function()
    cruisecontrolenabled, cruisevalue = false, nil
    SendNUIMessage({
        action = 'updateCruiseHud',
        cruisecontrol = false
    })
end)

RegisterKeyMapping('+cruisecontrol', 'Hız Sabitleme', 'keyboard', 'y')
RegisterKeyMapping('+seatbelt', 'Kemer Takma', 'keyboard', 'k')

local pausemenu = false
local isPause = false
local uiHidden = false
Citizen.CreateThread(function()
    while true do
        if IsPauseMenuActive() then
            pausemenu = true
            SendNUIMessage({
                action = 'toggleHUD',
                show = false,
            })
        elseif not IsPauseMenuActive() and pausemenu then
            SendNUIMessage({
                action = 'toggleHUD',
                show = toghud,
            })
        end
        if IsBigmapActive() or IsPauseMenuActive() or not IsPedInAnyVehicle(PlayerPedId(), false) and not isPause then
			if not uiHidden then
				SendNUIMessage({
                    action = "toggleCircle",
                    value = "hide"
				})
				uiHidden = true
			end
		elseif uiHidden or IsPauseMenuActive() and isPause then
			SendNUIMessage({
				action = "toggleCircle",
                value = "show"
			})
			uiHidden = false
        end
        
        Citizen.Wait(500)
    end
end)

local imageWidth = 100 -- leave this variable, related to pixel size of the directions
local containerWidth = 100 -- width of the image container

-- local width =  (imageWidth / containerWidth) * 100; -- used to convert image width if changed
local width =  0;
local south = (-imageWidth) + width
local west = (-imageWidth * 2) + width
local north = (-imageWidth * 3) + width
local east = (-imageWidth * 4) + width
local south2 = (-imageWidth * 5) + width

function calcHeading(direction)
    if (direction < 90) then
        return lerp(north, east, direction / 90)
    elseif (direction < 180) then
        return lerp(east, south2, rangePercent(90, 180, direction))
    elseif (direction < 270) then
        return lerp(south, west, rangePercent(180, 270, direction))
    elseif (direction <= 360) then
        return lerp(west, north, rangePercent(270, 360, direction))
    end
end

function rangePercent(min, max, amt)
    return (((amt - min) * 100) / (max - min)) / 100
end

function lerp(min, max, amt)
    return (1 - amt) * min + amt * max
end

posX = 0.01
posY = 0.0-- 0.0152

width = 0.183
height = 0.32--0.354

Citizen.CreateThread(function()
	RequestStreamedTextureDict("circlemap", false)
	while not HasStreamedTextureDictLoaded("circlemap") do
		Wait(100)
	end

	AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

	SetMinimapClipType(1) -- native added by cfx.re, it restores beta gta5 minimap (round)
	SetMinimapComponentPosition('minimap', 'L', 'B', posX, posY, width, height)
	SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.14, 0.14, 0.1, 0.1)
	SetMinimapComponentPosition('minimap_blur', 'L', 'B', 0.012, 0.022, 0.256, 0.337)

    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)

    while true do
        Citizen.Wait(1)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
        if IsBigmapActive() or IsBigmapFull() then
            SetBigmapActive(false, false)
        end
    end
end)

function setVoipMode(mode)
    currentMode = mode
end

function isTalkingWithoutRadio(value)
    isTalking = value
end

function isTalkingWithRadio(mode, value)
    currentMode = mode
    isTalkingOnRadio = value
end

--exports.reka_hud:setVoipMode(mVoice.currentMode)
--exports.reka_hud:isTalking(mVoice.currentMode)
--exports.reka_hud:isTalkingWithRadio(mVoice.currentMode)