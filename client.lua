while GetResourceState('qs-smartphone-pro') ~= 'started' do
    Wait(500)
end

local ui = 'https://cfx-nui-' .. GetCurrentResourceName() .. '/html/'

local function addApp()
    local added = exports['qs-smartphone-pro']:addCustomApp({
        app = 'template',
        image = ui .. 'icon.png',
        ui = ui .. 'index.html',
        label = 'Template',
        job = false,
        blockedJobs = {},
        timeout = 5000,
        creator = 'Quasar Store',
        category = 'social',
        isGame = false,
        description = 'This is your first testing app, I hope you manage to create incredible things!',
        age = '16+',
        extraDescription = {
            {
                header = 'Test',
                head = 'Test application',
                image = 'https://media.istockphoto.com/photos/abstract-background-wallpaper-picture-id952039286?b=1&k=20&m=952039286&s=170667a&w=0&h=LmOcMt7FHxFUAr2bOSfTUPV9sQhME6ABtAYLM0cMkR4=',
                footer = 'This is your first testing app, I hope you manage to create incredible things!'
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

-- Lua script for qs-vehiclekeysapp

function doorToggle(door)
    if GetVehicleDoorAngleRatio(cache.vehicle, door) > 0.0 then
        SetVehicleDoorShut(cache.vehicle, door, false, false)
    else
        SetVehicleDoorOpen(cache.vehicle, door, false, false)
    end
end

function changeSeat(seat)
    if (IsVehicleSeatFree(cache.vehicle, seat)) then
        SetPedIntoVehicle(cache.ped, cache.vehicle, seat)
    end
end

local windows = { true, true, true, true }

function windowToggle(window, door)
    if GetIsDoorValid(cache.vehicle, door) and windows[window + 1] then
        RollDownWindow(cache.vehicle, window)
        windows[window + 1] = false
    else
        RollUpWindow(cache.vehicle, window)
        windows[window + 1] = true
    end
end

RegisterNUICallback('doorToggle', function(data, cb)
local vehicle = GetClosestVehicle()
if vehicle ~= nil and vehicle ~= 0 then
exports["qs-vehiclekeys"]:DoorLogic(vehicle, true)
end
cb('Callback received successfully!')
end)

RegisterNUICallback('windowToggle', function(data, cb)
    local windowType = data.window
    local doorType = data.door
    windowToggle(windowType, doorType)
    cb('Callback received successfully!')
end)

RegisterNUICallback('doorLock', function(data, cb)
    local windowType = data.window
    local doorType = data.door
    windowToggle(windowType, doorType)
    cb('Callback received successfully!')
end)

RegisterNUICallback('changeSeat', function(data, cb)
    local seatType = data.seat
    changeSeat(seatType)
    cb('Callback received successfully!')
end)
