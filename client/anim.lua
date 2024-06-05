local sharedConfig = require 'shared.config'

local function thermiteEffect(thermiteEntity, index)
    local coords = sharedConfig.fleeca.thermite[index].coords
    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Citizen.Wait(50)
    end

    UseParticleFxAssetNextCall("scr_ornate_heist")
    local effect = StartParticleFxLoopedOnEntity("scr_heist_ornate_thermal_burn", thermiteEntity, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false)
    SetParticleFxLoopedOffsets(effect, 0.0, 0.0, 0.0, -1.0)
    Citizen.Wait(10000)
    StopParticleFxLooped(effect, 0)
    AddExplosion(coords.x, coords.y, coords.z, 2, 1.0, true, false, 1.0)
    TriggerServerEvent('ori_bankrobbery:server:gateIdSent', index)
end

local function thermiteAnim(coords, heading, index)
    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestModel("hei_p_m_bag_var22_arm_s")
    RequestModel("hei_prop_heist_thermite")
    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") or not HasModelLoaded("hei_p_m_bag_var22_arm_s") or not HasModelLoaded("hei_prop_heist_thermite") or not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Citizen.Wait(50)
    end

    local playerPed = PlayerPedId()
    SetEntityHeading(playerPed, heading)
    Citizen.Wait(100)

    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(playerPed)))
    local bagscene = NetworkCreateSynchronisedScene(coords.x, coords.y, coords.z, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), coords.x, coords.y, coords.z, true, true, false)
    SetEntityCollision(bag, false, true)

    local thermite = CreateObject(GetHashKey("hei_prop_heist_thermite"), coords.x, coords.y, coords.z + 0.2, true, true, true)
    SetEntityCollision(thermite, false, true)
    AttachEntityToEntity(thermite, playerPed, GetPedBoneIndex(playerPed, 28422), 0, 0, 0, 0, 0, 0.0, true, true, false, true, 1, true)

    NetworkAddPedToSynchronisedScene(playerPed, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    SetPedComponentVariation(playerPed, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)

    Citizen.Wait(5000)
    DetachEntity(thermite, true, true)
    FreezeEntityPosition(thermite, true)
    DeleteObject(bag)
    NetworkStopSynchronisedScene(bagscene)
    Citizen.CreateThread(function()
        Citizen.Wait(15000)
        DeleteEntity(thermite)
    end)
    thermiteEffect(thermite, index)
end

RegisterNetEvent('ori_bankrobbery:client:getAnim')
AddEventHandler('ori_bankrobbery:client:getAnim', function(index)
    local thermiteData = sharedConfig.fleeca.thermite[index]
    if thermiteData then
        local coords = thermiteData.coords
        local heading = thermiteData.heading
        thermiteAnim(coords, heading, index)
    else
        lib.print.info('Thermite Data not here', thermiteData)
    end
end)

RegisterNetEvent('ori_bankrobbery:client:requestAnim', function( playerPed, animDict, animName)
    RequestAnimDict(animDict) 
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
    end
    TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)
end)

RegisterNetEvent('ori_bankrobbery:client:cardAnim', function()
    local animDict = 'mp_prison_break'
    local animName = 'hack_loop'
    local ped = PlayerPedId()
    TriggerEvent('ori_bankrobbery:client:requestAnim', ped, animDict, animName)
end)

RegisterNetEvent('ori_bankrobbery:client:lockerAnim', function()
    local animDict = 'mp_prison_break'
    local animName = 'hack_loop'
    local ped = PlayerPedId()
    TriggerEvent('ori_bankrobbery:client:requestAnim', ped, animDict, animName)
end)
