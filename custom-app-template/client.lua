while true do
    if GetResourceState('qs-smartphone-pro') == 'started' and GetResourceState('qs-vehiclekeys') == 'started' then
        break
    end
    Wait(500)
end

local ui = 'https://cfx-nui-' .. GetCurrentResourceName() .. '/html/'

local function addApp()
    local added = exports['qs-smartphone-pro']:addCustomApp({
        app = 'template',
        image = ui .. 'icon.png',
        ui = ui .. 'index.html',
        label = 'Vehicle',
        job = false,
        blockedJobs = {},
        timeout = 5000,
        creator = 'Ju',
        category = 'Utilities',
        isGame = false,
        description = 'A convenient app to manage your vehicle doors, windows, and more.',
        age = '16+',
        extraDescription = {
            {
            header = 'Car Control',
            head = 'Unlock, Lock, and Control Your Car',
                image = 'https://media.istockphoto.com/photos/abstract-background-wallpaper-picture-id952039286?b=1&k=20&m=952039286&s=170667a&w=0&h=LmOcMt7FHxFUAr2bOSfTUPV9sQhME6ABtAYLM0cMkR4=',
                footer = 'A convenient app to manage your vehicle doors, windows, and more.'
            }
        }
    })
    if not added then
        return print('Failed to add app')
    end
    print('App added')
end

local function removeApp()
    local removed = exports['qs-smartphone-pro']:removeCustomApp('template')
    if not removed then
        return print('Failed to remove app')
    end
    print('App removed')
end

RegisterCommand('removeapp', function()
    removeApp()
end, false)

CreateThread(addApp)

AddEventHandler('onResourceStart', function(resource)
    if resource == 'qs-smartphone-pro' then
        addApp()
    end
end)

function getDoorState(door)
    local currentDoorAngle = GetVehicleDoorAngleRatio(cache.vehicle, door)

    if currentDoorAngle > 0.0 then
        return "closed"
    else
        return "open"
    end
end

local windows = { true, true, true, true }

function windowToggle(window, door)
    if door and GetIsDoorValid(cache.vehicle, door) and windows[door + 1] then
        RollDownWindow(cache.vehicle, door)
        windows[door + 1] = false
    elseif door then
        RollUpWindow(cache.vehicle, door)
        windows[door + 1] = true
    end
end

-- Function to handle window toggling
RegisterNUICallback('windowToggle', function(data, cb)
    if data then
        local windowType = data.window
        local doorType = data.door
        windowToggle(windowType, doorType)
    end
end)

-- Function to check if the player is inside the vehicle
function isPlayerInsideVehicle()
    local vehicle, _ = getClosestVehicle(GetEntityCoords(PlayerPedId()), 5.0, true)
    return DoesEntityExist(vehicle)
end

-- Function to check if the player is outside the vehicle
function isPlayerOutsideVehicle()
    return not isPlayerInsideVehicle()
end

-- Function to get the closest vehicle and its coordinates
function getClosestVehicle(coords, maxDistance, includePlayerVehicle)
    return lib.getClosestVehicle(coords, maxDistance, includePlayerVehicle)
end

-- Function to handle door locking and unlocking
RegisterNUICallback('doorLock', function(data, cb)
    -- Get the closest vehicle and its coordinates
    local playerCoords = GetEntityCoords(PlayerPedId())
    local vehicle, vehicleCoords = getClosestVehicle(playerCoords, 5.0, true)

    if vehicle then

        -- Update the cache with the new vehicle value
        cache.vehicle = vehicle

        -- Check if the player has the key for the vehicle
        local plate = GetVehicleNumberPlateText(vehicle)
        local hasKey = exports['qs-vehiclekeys']:GetKey(plate)

        if hasKey then

            -- Implement door locking/unlocking logic here
            exports["qs-vehiclekeys"]:DoorLogic(vehicle, true)

            for door = 0, 5 do
                SetVehicleDoorShut(vehicle, door, false, false)
            end
        else
        exports['qs-smartphone-pro']:SendTempNotificationOld({
        title = 'You don\'t have the keys.',
        content = '',
        type = 'info',
        timeout = 5000,
        disableBadge = false, -- Disables the badge on the app icon.
        })
        end
    else
    exports['qs-smartphone-pro']:SendTempNotificationOld({
    title = 'No vehicle nearby.',
    content = '',
    type = 'info',
    timeout = 5000,
    disableBadge = false, -- Disables the badge on the app icon.
    })
    end
end)

function doorToggle(door)
    if GetVehicleDoorAngleRatio(cache.vehicle, door) > 0.0 then
        SetVehicleDoorShut(cache.vehicle, door, false, false)
    else
        SetVehicleDoorOpen(cache.vehicle, door, false, false)
    end
end

-- RegisterNUICallback for doorToggle
RegisterNUICallback('doorToggle', function(data, cb)
    if data then

        local vehicle = cache.vehicle -- Assuming cache is the object storing cached values

        if vehicle == nil or vehicle == 0 or not DoesEntityExist(vehicle) then
            -- Fetch the closest vehicle
            vehicle, _ = getClosestVehicle(GetEntityCoords(PlayerPedId()), 5.0, true)
        end

        if vehicle and DoesEntityExist(vehicle) then

            -- Update the cache with the new vehicle value
            cache.vehicle = vehicle

            -- Check if the player has the key for the vehicle
            local plate = GetVehicleNumberPlateText(vehicle)
            local hasKey = exports['qs-vehiclekeys']:GetKey(plate)

            if hasKey then

                -- Get the current state of the door
                local doorState = getDoorState(data.door)

                -- Toggle the door based on the current state
                if doorState == "closed" then
                    -- The skipAnimation parameter, when set to true, skips the lock/unlock animation (default is false).
                    -- The forcedDoorStatus parameter, when provided, forces the door status to the specified value.
                    -- The skipNotification parameter, when set to true, skips displaying notifications (default is false).
                    -- The skipSound parameter, when set to true, skips playing default vehicle door sounds (default is false).
                    -- The skipFlickerLights parameter, when set to true, skips flickering lights (default is false).
                    exports["qs-vehiclekeys"]:DoorLogic(vehicle, true, 1, true, true, true) -- Open
                    TriggerEvent('updateDoorState', 1)
                    Wait(250) -- Wait for 250 milliseconds
                    doorToggle(data.door)
                else
                    -- The skipAnimation parameter, when set to true, skips the lock/unlock animation (default is false).
                    -- The forcedDoorStatus parameter, when provided, forces the door status to the specified value.
                    -- The skipNotification parameter, when set to true, skips displaying notifications (default is false).
                    -- The skipSound parameter, when set to true, skips playing default vehicle door sounds (default is false).
                    -- The skipFlickerLights parameter, when set to true, skips flickering lights (default is false).
                    exports["qs-vehiclekeys"]:DoorLogic(vehicle, true, 2, true, true, true) -- Lock

                    TriggerEvent('updateDoorState', 2)
                    Wait(250) -- Wait for 250 milliseconds
                    doorToggle(data.door)
                end
            else
            exports['qs-smartphone-pro']:SendTempNotificationOld({
            title = 'You don\'t have the keys.',
            content = '',
            type = 'info',
            timeout = 5000,
            disableBadge = false, -- Disables the badge on the app icon.
            })
            end
        else
        exports['qs-smartphone-pro']:SendTempNotificationOld({
        title = 'No vehicle nearby.',
        content = '',
        type = 'info',
        timeout = 5000,
        disableBadge = false, -- Disables the badge on the app icon.
        })
        end
    end
end)

function changeSeat(seat) -- Check seat is empty and move to it
    if (IsVehicleSeatFree(cache.vehicle, seat)) then
        SetPedIntoVehicle(cache.ped, cache.vehicle, seat)
        --exports['qs-vehiclekeys']:initKeys(cache.vehicle)
    end
end

-- Function to handle seat changing
RegisterNUICallback('changeSeat', function(data, cb)
    if data then
        local seatType = data.seat
        changeSeat(seatType)
    end
end)
