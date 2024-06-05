local sharedConfig = require 'shared.config'
local panelStates = {}
local robbedSpots = {}
local robbedItemSpots = {}
local lastAlertTime = 0


----------------
-- UTILS
----------------

local function createProgressCircle(duration, label, useWhileDead, canCancel, position, disable, anim)
    return lib.progressCircle({
        duration = duration,
        label = label,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        position = position or 'bottom',
        disable = disable or { car = true, move = true },
        anim = anim,
    })
end

local function addSphereZone(coords, radius, options)
    exports.ox_target:addSphereZone({
        coords = coords,
        debug = sharedConfig.debug,
        radius = radius,
        drawSprite = true,
        options = options,
    })
end

----------------
-- States
----------------
local function getPanelStates(playerId)
    if not panelStates[playerId] then
        panelStates[playerId] = { minigameSuccess = false, doorOpen = false, thermiteSuccess = false}
    end
    return panelStates[playerId]
end

----------------
-- Vault Timer
----------------
--Timer is in minutes. Once the timer is over will send request to open door to the server 
local function createTimer(coords,index)
    --local timer = sharedConfig.vaultTime * 60000 -- this for vaultTime to be in minutes
    local timer = sharedConfig.vaultTime * 5000
    exports.qbx_core:Notify('Door will open in '..sharedConfig.vaultTime..' minutes', 'success')
    SetTimeout(timer, function()
        exports.qbx_core:Notify('Door Is Open', 'success')
        PlaySoundFrontend( -1, 'Beep_Red', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', true)
        TriggerEvent('ori_bankrobbery:client:onCardComplete')
        TriggerServerEvent('ori_bankrobbery:server:vaultIdSent', index)
        TriggerServerEvent('ori_bankrobbery:server:timerStart', index)
    end)
end

local function resetPanelStates(playerId)
    if panelStates[playerId] then
        panelStates[playerId].minigameSuccess = false
        panelStates[playerId].doorOpen = false
        panelStates[playerId].thermiteSuccess = false
    end
end

local function stateTimer(playerId)
    local timer = sharedConfig.resetDuration * 600000
    SetTimeout(timer, function()
        lib.print.info('states have been reset')
        resetPanelStates(playerId)
    end)
end

----------------
-- Lockers
----------------

local function createCashTar(index)
    local door = sharedConfig.fleeca.doors[index]
    for spotIndex, spot in ipairs(door.tarCash) do
        local currentIndex = spotIndex
        addSphereZone(spot, sharedConfig.tarRadius, {
            {
                label = 'Hack The Locker',
                icon = 'fas fa-fire',
                onSelect = function()
                    local hasItem = exports.ox_inventory:Search('count', sharedConfig.lockerItem) > 0
                    if hasItem then
                        if robbedSpots[index] and robbedSpots[index][currentIndex] then
                            exports.qbx_core:Notify('Already Been Melted', 'error')
                        else
                            createProgressCircle( 2000, 'Unlocking Safe...', false, false, 'bottom', { car = true, move = true}, {dict = 'mp_common_heist', clip = 'a_atm_mugging', flag = 1})
                            exports["glow_minigames"]:StartMinigame(function(success)
                                if success then
                                    createProgressCircle(sharedConfig.lootDuration, 'Looting Safe', false, false, 'bottom', { car = true, move = true}, {dict = 'anim@heists@ornate_bank@grab_cash', clip = 'grab', flag = 1})
                                    lib.callback.await('ori_bankrobbery:server:addCash')
                                else
                                    exports.qbx_core:Notify('try again!', 'success')

                                end
                            end, "spot")
                            -- Mark the spot as robbed
                            if not robbedSpots[index] then
                                robbedSpots[index] = {}
                            end
                            robbedSpots[index][currentIndex] = true
                            -- Optionally, you can also perform other actions like updating the UI or notifying players
                        end
                    else
                        exports.qbx_core:Notify('might need a special hacking device', 'error')
                    end
                end
            }
        })
    end
end

local function createItemTar(index)
    local door = sharedConfig.fleeca.doors[index]
    for spotIndex, spot in ipairs(door.tarItems) do
        local currentIndex = spotIndex -- Capture the current value of spotIndex
        addSphereZone(spot, sharedConfig.tarRadius, {
            {
                label = 'Hack The Locker',
                icon = 'fas fa-fire',
                onSelect = function()
                    local hasItem = exports.ox_inventory:Search('count', sharedConfig.lockerItem) > 0
                    if hasItem then
                        if robbedItemSpots[index] and robbedItemSpots[index][currentIndex] then
                            exports.qbx_core:Notify('Already Been Melted', 'error')
                        else
                            createProgressCircle( 2000, 'Unlocking Safe...', false, false, 'bottom', { car = true, move = true}, {dict = 'mp_common_heist', clip = 'a_atm_mugging', flag = 1})
                            exports["glow_minigames"]:StartMinigame(function(success)
                                if success then
                                    createProgressCircle(sharedConfig.lootDuration, 'Looting Safe', false, false, 'bottom', { car = true, move = true}, {dict = 'anim@heists@ornate_bank@grab_cash', clip = 'grab', flag = 1})
                                    lib.callback.await('ori_bankrobbery:server:addItem')
                                else
                                    exports.qbx_core:Notify('try again!', 'success')

                                end
                            end, "spot")
                            -- Mark the spot as robbed
                            if not robbedItemSpots[index] then
                                robbedItemSpots[index] = {}
                            end
                            robbedItemSpots[index][currentIndex] = true
                            -- Optionally, you can also perform other actions like updating the UI or notifying players
                        end
                    else
                        exports.qbx_core:Notify('might need a special hacking device', 'error')
                    end
                end
            },
            -- {
            --     label = 'reset the vault',
            --     icon  = 'fas fa-fire',
            --     onSelect = function()
            --         TriggerServerEvent('ori_bankrobbery:server:resetVault', index)
            --     end
            -- }
        })
    end
end



----------------
-- Panel & progcircles
----------------

--Creates a progressbar and then places thermite at the door 
local function thermiteProg(playerId, index)
    local hasItem = exports.ox_inventory:Search('count', sharedConfig.thermiteItem) > 0
    local hasLighter = exports.ox_inventory:Search('count', sharedConfig.lighterItem) > 0
    local state = getPanelStates(playerId)
    if hasItem and hasLighter then
        if not state.doorOpen then
            exports.qbx_core:Notify('Door not open. Grats on Cheating', playerId)
            return
        end
        createProgressCircle(2000, 'Getting Thermite Ready', false, false, 'bottom', { car = true, move = true}, {dict = 'mp_common_heist', clip = 'a_atm_mugging', flag = 1})
        TriggerEvent('ori_bankrobbery:client:lockerAnim')
        if sharedConfig.animDebug then
            TriggerEvent('ori_bankrobbery:client:getAnim', index)
            ClearPedTasks(PlayerPedId())
            state.thermiteSuccess = true
            lib.callback.await('ori_bankrobbery:server:removeThermite')
        return end
        exports["glow_minigames"]:StartMinigame(function(success)
            if success then
                TriggerEvent('ori_bankrobbery:client:getAnim', index)
                ClearPedTasks(PlayerPedId())
                state.thermiteSuccess = true
                lib.callback.await('ori_bankrobbery:server:removeThermite')
                stateTimer(playerId)
            else
                exports.qbx_core:Notify('Thermite aint lighting', 'error')
                ClearPedTasks(PlayerPedId())
            end
        end, "path")

    else
        exports.qbx_core:Notify('Where did you put the lighter?', 'error')
    end
end

--Creates a progressbar that sets the timer,
local function cardProg(coords, playerId, index)
    local hasItem = exports.ox_inventory:Search('count', sharedConfig.panelItem) > 0
    local state = getPanelStates(playerId)
    if hasItem then
        if state.minigameSuccess then
            exports.qbx_core:Notify('Terminal already hacked', playerId)
            return
        end
        createProgressCircle( 2000, 'Inserting Card', false, false, 'bottom', { car = true, move = true}, {dict = 'mp_common_heist', clip = 'a_atm_mugging', flag = 1})
        TriggerEvent('ori_bankrobbery:client:cardAnim')
        local minigameInProgress = true
        if sharedConfig.animDebug then
            createCashTar(index)
            createItemTar(index)
            createTimer(coords, index)
            state.minigameSuccess = true
            TriggerEvent('ori_bankrobbery:client:gateFreeze', index)
            lib.callback.await('ori_bankrobbery:server:removeSecurityCard')
            ClearPedTasks(PlayerPedId())
            exports['ps-dispatch']:FleecaBankRobbery()
        return end
        exports['boii_minigames']:chip_hack({
            style = 'default', -- Style template
            loading_time = 8000, -- Total time to complete loading sequence in (ms)
            chips = 2, -- Amount of chips required to find
            timer = 30000 -- Total allowed game time in (ms)
        }, function(success)
            if minigameInProgress then
                minigameInProgress = false
                ClearPedTasks(PlayerPedId())
                if success then
                    createCashTar(index)
                    createItemTar(index)
                    createTimer(coords)
                    state.minigameSuccess = true
                    lib.callback.await('ori_bankrobbery:server:removeSecurityCard')
                    exports['ps-dispatch']:FleecaBankRobbery()
                else
                    local breakChance = math.random(1,100)
                    if breakChance <= 50 then
                        lib.callback.await('ori_bankrobbery:server:removeSecurityCard')
                        exports['ps-dispatch']:FleecaBankRobbery()

                        exports.qbx_core:Notify('your card corrupts in the terminal', 'error')
                    else
                        exports.qbx_core:Notify('It didnt work', 'error')
                    end
                end
            end
        end)
    else
        exports.qbx_core:Notify('Looks like it needs a card', 'error')
    end
end

---------------
-- Police Related Functions
----------------

local function checkCopAmount(doorCoords, playerId, index)
    if lib.callback.await('ori_bankrobbery:server:copCheck') then
        cardProg(doorCoords, playerId, index)
    else
        exports.qbx_core:Notify('Not Enough Cops', 'error')
    end
end

local function checkCopAmountThermite(playerId, index)
    if lib.callback.await('ori_bankrobbery:server:copCheck') then
        thermiteProg(playerId, index)
    else
        exports.qbx_core:Notify('Not Enough Cops', 'error')
    end
end

----------------
-- Events
----------------

RegisterNetEvent('ori_bankrobbery:client:onCardComplete')
AddEventHandler('ori_bankrobbery:client:onCardComplete', function()
    local playerId = cache.PlayerId
    local state = getPanelStates(playerId)
    state.doorOpen = true
end)

RegisterNetEvent('ori_bankrobbery:client:onThermiteComplete')
AddEventHandler('ori_bankrobbery:client:onThermiteComplete', function()
    local playerId = cache.PlayerId
    local state = getPanelStates(playerId)
    state.thermiteSuccess = true
end)

RegisterNetEvent('ori_bankrobbery:client:useSecurityCard')
AddEventHandler('ori_bankrobbery:client:useSecurityCard', function()
    local playerId = cache.PlayerId
    local playerCoords = GetEntityCoords(PlayerPedId())
    local state = getPanelStates(playerId)
    
    for index , panel in ipairs(sharedConfig.fleeca.panels) do
        local distance = #(playerCoords - panel.coords)
        local interactionRadius = 0.6
        local doorCoords = sharedConfig.fleeca.doors[index].coords
        if distance < interactionRadius then
            local isRobbed = state[index] or false
            if not isRobbed then
                checkCopAmount(doorCoords, playerId, index)
            end
        end
    end
end)

RegisterNetEvent('ori_bankrobbery:client:useThermite')
AddEventHandler('ori_bankrobbery:client:useThermite', function()
    local playerId = cache.PlayerId
    local playerCoords = GetEntityCoords(PlayerPedId())
    local state = getPanelStates(playerId)

    if state.doorOpen then
        for index, gatePanel in ipairs(sharedConfig.fleeca.gates) do
            local distance = #(playerCoords - gatePanel.coords)
            local isRobbed = state[index] or false
            local interactionRadius = 1.0
            if distance < interactionRadius then
                if not isRobbed then
                    checkCopAmountThermite(playerId, index)
                end
            end
        end
    end
end)