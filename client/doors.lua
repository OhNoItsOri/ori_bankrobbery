local sharedConfig = require 'shared.config'

--OKAY SO ALRIGHT LETS THINK ABOUT THIS AGAIN.

--so the timer sends info to the server. The servers sees that and changes the isOpen = true,
--the client scripts watch for that and if its marked as open, they begin to open the door.
-- if its been opened it will freeze the entity there for 10 minutes before it allows it to reset

--Okay so where you're at. Doors are 'networked' now. only issue is that they reset every time the thread
-- iterates... so either have to add a new thing to the config to handle the states, orrrrrrrrrrr something else
-- look man IDK what im doing.

----------------
-- Timer Function
----------------
----------------
-- VAULTDOOR
----------------

local function vaultDoorIsOpen(index, door)
    local entHeading = sharedConfig.fleeca.doors[index].openHeading
    local currentHeading = GetEntityHeading(door)
    if math.abs(currentHeading - entHeading) > 0.01 then
        SetEntityHeading(door, entHeading)
    end
end

local function vaultOpen(index, door)
    if not door then
        lib.print.info('no door data recieved', door)
        return
    end

    local entHeading = sharedConfig.fleeca.doors[index].heading
    local openHeading = sharedConfig.fleeca.doors[index].openHeading
    if door ~= 0 then
        CreateThread(function()
            local increment = 0.5
            if entHeading > openHeading then
                increment = -0.5
            end
            while entHeading ~= openHeading do
                entHeading = entHeading + increment
                SetEntityHeading(door, entHeading)
                TriggerServerEvent('ori_bankrobbery:server:markVault', index)
                Wait(10)
            end
            SetEntityHeading(door, entHeading)
            FreezeEntityPosition(door, true)
        end)
    end
end

local function getVaultDoor(index)
    local coords = sharedConfig.fleeca.doors[index].coords
    local door = GetClosestObjectOfType(coords.x, coords.y, coords.z, 100.0, sharedConfig.fleecaDoorModel, false, false, false)
    --lib.print.info('door info', door)
    vaultOpen(index, door)
end

--will launch the function to start door opening.
local function onVaultStatusChange(index, isOpen)
    if isOpen then
        --lib.print.info('a vault has been opened', index)
        getVaultDoor(index)
    end
end

--does stuff. sends info. yert
local function updateVaultStatus(index, isOpen)
    sharedConfig.fleeca.doors[index].isOpen = isOpen
    onVaultStatusChange(index, isOpen)
end

--Recieves alert to check config 
RegisterNetEvent('ori_bankrobbery:client:vaultChangeRecieved', function(index, isOpen)
    updateVaultStatus(index, isOpen)
end)

----------------
-- THERMITE GATE
----------------


local function gateDoorIsOpen(index, door)
    local openHeading = sharedConfig.fleeca.gateDoor[index].heading + 90
    local currentHeading = GetEntityHeading(door)
    if math.abs(currentHeading - openHeading) > 0.01 then
        SetEntityHeading(door, openHeading)
    end
end


local function gateOpen(index, door)
    if not door then
        lib.print.info('no door data recieved', door)
        return
    end

    local entHeading = sharedConfig.fleeca.gateDoor[index].heading
    local openHeading = entHeading + 90
    if door ~= 0 then
        CreateThread(function()
            local increment = 0.5
            FreezeEntityPosition(door, false)
            if entHeading > openHeading then
                increment = -0.5
            end
            while entHeading ~= openHeading do
                entHeading = entHeading + increment
                SetEntityHeading(door, entHeading)
                TriggerServerEvent('ori_bankrobbery:server:markGate', index)
                Wait(10)
            end
        end)
    end
end

local function getGateDoor(index)
    local coords = sharedConfig.fleeca.gateDoor[index].coords
    local door = GetClosestObjectOfType(coords.x, coords.y, coords.z, 100.0, sharedConfig.fleecaGateModel, false, false, false)
    lib.print.info('door info', door)
    gateOpen(index, door)
end

local function onGateStatusChange(index, isOpen)
    if isOpen then
        lib.print.info('a gate has been opened', index)
        getGateDoor(index)
    end
end

local function updateGateStatus(index, isOpen)
    sharedConfig.fleeca.gateDoor[index].isOpen = isOpen
    onGateStatusChange(index, isOpen)
end

RegisterNetEvent('ori_bankrobbery:client:gateChangeRecieved', function(index, isOpen)
    updateGateStatus(index, isOpen)
end)

RegisterNetEvent('ori_bankrobbery:client:gateFreeze', function(index)
    local coords = sharedConfig.fleeca.gateDoor[index].coords
    local door = GetClosestObjectOfType(coords.x, coords.y, coords.z, 100.0, sharedConfig.fleecaGateModel, false, false, false)
    FreezeEntityPosition(door, true)
end)

RegisterNetEvent('ori_bankrobbery:client:resetDoors', function(index)
    local vaultCoords = sharedConfig.fleeca.doors[index].coords
    local gateCoords = sharedConfig.fleeca.gateDoor[index].coords
    local vault = GetClosestObjectOfType(vaultCoords.x, vaultCoords.y, vaultCoords.z, 100.0, sharedConfig.fleecaGateModel, false, false, false)
    local gate = GetClosestObjectOfType(gateCoords.x, gateCoords.y, gateCoords.z, 100.0, sharedConfig.fleecaDoorModel, false, false, false)

    SetEntityHeading(vault, sharedConfig.fleeca.doors[index].heading)
    SetEntityHeading(gate, sharedConfig.fleeca.gateDoors[index].heading)
end)


--Maybe use below as an idea for distance checks for these
CreateThread(function()
    while true do
        Wait(2000)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        for index, vaultData in pairs(sharedConfig.fleeca.doors) do
            local bankDist = #(pos - vaultData.coords)
            if bankDist < 15 then
                if vaultData.isOpen then
                    local coords = vaultData.coords
                    local door = GetClosestObjectOfType(coords.x, coords.y, coords.z, 100.0, sharedConfig.fleecaDoorModel, false, false, false)
                    vaultDoorIsOpen(index, door)
                end
            end
        end

        for index, gateData in pairs(sharedConfig.fleeca.gateDoor) do
            local gateDist = #(pos - gateData.coords)
            if gateDist < 15 then
                if gateData.isOpen then
                    local coords = gateData.coords
                    local door = GetClosestObjectOfType(coords.x, coords.y, coords.z, 15.0, sharedConfig.fleecaGateModel, false, false, false)
                    gateDoorIsOpen(index, door)
                end
            end
        end
        Wait(100)
    end
end)