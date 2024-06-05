local sharedConfig = require 'shared.config'
local vaultStates = {}

----------------
-- doors. I hate life. Please end me
----------------
RegisterNetEvent('ori_bankrobbery:server:vaultIdSent', function(index)
    local vault = sharedConfig.fleeca.doors
    lib.print.info('svmain.9', vault[index].isOpen)
    TriggerClientEvent('ori_bankrobbery:client:vaultChangeRecieved', -1,  index, true)
end)

RegisterNetEvent('ori_bankrobbery:server:markVault', function(index)
    local vault = sharedConfig.fleeca.doors
    vault[index].isOpen = true
end)

RegisterNetEvent('ori_bankrobbery:server:gateIdSent', function(index)
    local gate = sharedConfig.fleeca.gateDoor
    gate[index].isOpen = true
    lib.print.info('svmain.17', gate[index].isOpen)
    TriggerClientEvent('ori_bankrobbery:client:gateChangeRecieved', -1,  index, gate[index].isOpen)
end)

RegisterNetEvent('ori_bankrobbery:server:markGate', function(index)
    local gateDoor = sharedConfig.fleeca.gateDoor
    gateDoor[index].isOpen = true
end)

----------------
-- Timer Functions
----------------

RegisterNetEvent('ori_bankrobbery:server:timerStart', function(index)
    local timer = sharedConfig.resetDuration * 60000
    local vault = sharedConfig.fleeca.doors
    local gate = sharedConfig.fleeca.gateDoor
    lib.print.info('timer starts on', index)
    SetTimeout(timer, function()
        vault[index].isOpen = false
        gate[index].isOpen = false
        exports.qbx_core:Notify('doors have been reset', 'success')
        lib.print.info('doors have been reset')
        TriggerEvent('ori_bankrobbery:client:resetDoors', index)
    end)
end)

----------------
-- police Things
----------------

lib.callback.register('ori_bankrobbery:server:copCheck', function()
    local amount = exports.qbx_core:GetDutyCountType('leo')
    return amount >= sharedConfig.minimumPolice
end)

----------------
-- Item related things
----------------

lib.callback.register('ori_bankrobbery:server:removeSecurityCard', function(source)
    local player = exports.qbx_core:GetPlayer(source)
    player.Functions.RemoveItem(sharedConfig.panelItem, 1)
end)

lib.callback.register('ori_bankrobbery:server:removeThermite', function(source)
    local player = exports.qbx_core:GetPlayer(source)
    player.Functions.RemoveItem(sharedConfig.thermiteItem, 1)
end)

lib.callback.register('ori_bankrobbery:server:addCash', function(source)
    local player = exports.qbx_core:GetPlayer(source)
    player.Functions.AddItem(sharedConfig.dirtyItem, sharedConfig.lockerAmount)
end)

lib.callback.register('ori_bankrobbery:server:addItem', function(source)
    local player = exports.qbx_core:GetPlayer(source)
    local number = math.random(1,100)
    if number <= 33 then
        player.Functions.AddItem(sharedConfig.lockerItem2, math.random(1,3))
    elseif number <= 66 then
        player.Functions.AddItem(sharedConfig.lockerItem3, 1)
    else
        player.Functions.AddItem(sharedConfig.lockerItem4, math.random(1,2))
    end
end)
