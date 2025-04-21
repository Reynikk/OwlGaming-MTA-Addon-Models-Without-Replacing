--[[
* ***********************************************************************************************************************
* Copyright (c) 2023 MTA Tacky Server - All Rights Reserved
* All rights reserved. This program and the accompanying materials are private property belongs to MTA Tacky Server
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* ***********************************************************************************************************************
]]

-- This script demonstrates how to use custom vehicle models with the modified vehicle system

-- Load newmodels functions, which allow usage of custom model IDs "as if they were normal IDs"
loadstring(exports.newmodels_azul:import())()

-- Vehicle model, x,y,z, rx,ry,rz, interior,dimension
local VEHICLE_SPAWNS = {
    {-1, 2893.3359375, -853.580078125, 10.875, 356.28, 356.34, 204.01, 0, 0},
    {-2, 2462.3876953125, -1143.4794921875, 35.601566314697, 356.28, 356.34, 204.01, 0, 0},
}

local function createTestVehicles()
    for i, data in ipairs(VEHICLE_SPAWNS) do
        local model, x, y, z, rx, ry, rz, interior, dimension = unpack(data)
        local vehicle = exports.vehicle:createVehicleWithCustomModel(model, x, y, z, rx, ry, rz)
        if vehicle then
            setElementInterior(vehicle, interior)
            setElementDimension(vehicle, dimension)

            -- Set some properties for the test vehicles
            exports.anticheat:setEld(vehicle, "fuel", exports.vehicle_fuel:getMaxFuel(exports.vehicle:getEffectiveVehicleModel(vehicle)))
            exports.anticheat:setEld(vehicle, "owner", -1)
            exports.anticheat:setEld(vehicle, "faction", -1)

            outputDebugString("#" .. i .. " - Created test vehicle with custom ID " .. model .. " at " .. x .. ", " .. y .. ", " .. z)
        else
            outputDebugString("Failed to create test vehicle with custom ID " .. model, 1)
        end
    end
end

-- Command to spawn test vehicles
function spawnTestVehicles(thePlayer, commandName)
    if exports.integration:isPlayerTrialAdmin(thePlayer) then
        createTestVehicles()
        outputChatBox("Test vehicles with custom models have been spawned.", thePlayer, 0, 255, 0)
    else
        outputChatBox("You don't have permission to use this command.", thePlayer, 255, 0, 0)
    end
end
addCommandHandler("spawncustomvehicles", spawnTestVehicles)

-- Command to check vehicle model information
function checkVehicleModel(thePlayer, commandName)
    if not isPedInVehicle(thePlayer) then
        outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
        return
    end

    local vehicle = getPedOccupiedVehicle(thePlayer)
    local model = getElementModel(vehicle)
    local baseModel = getElementBaseModel(vehicle)

    if exports.vehicle:isCustomVehicleModel(model) then
        outputChatBox("This vehicle has a custom model ID: " .. model, thePlayer, 0, 255, 0)
        outputChatBox("Base model ID: " .. baseModel .. " (" .. getVehicleName(vehicle) .. ")", thePlayer, 0, 255, 0)
        outputChatBox("Fuel capacity: " .. exports.vehicle_fuel:getMaxFuel(exports.vehicle:getEffectiveVehicleModel(vehicle)) .. " liters", thePlayer, 0, 255, 0)
    else
        outputChatBox("This vehicle has a standard model ID: " .. model .. " (" .. getVehicleName(vehicle) .. ")", thePlayer, 0, 255, 0)
        outputChatBox("Fuel capacity: " .. exports.vehicle_fuel:getMaxFuel(model) .. " liters", thePlayer, 0, 255, 0)
    end
end
addCommandHandler("checkvehmodel", checkVehicleModel)

-- Command to add a custom vehicle to the vehicle library
function addCustomVehicleToLibrary(thePlayer, commandName, modelId, baseModelId)
    if not exports.integration:isPlayerVehicleConsultant(thePlayer) and not exports.integration:isPlayerLeadAdmin(thePlayer) then
        outputChatBox("You don't have permission to use this command.", thePlayer, 255, 0, 0)
        return
    end

    modelId = tonumber(modelId)
    baseModelId = tonumber(baseModelId)

    if not modelId or not baseModelId then
        outputChatBox("SYNTAX: /" .. commandName .. " [customModelId] [baseModelId]", thePlayer, 255, 194, 14)
        outputChatBox("Example: /" .. commandName .. " -1 490", thePlayer, 255, 194, 14)
        return
    end

    if modelId >= 0 then
        outputChatBox("Custom model ID must be a negative number.", thePlayer, 255, 0, 0)
        return
    end

    if baseModelId < 400 or baseModelId > 611 then
        outputChatBox("Base model ID must be a valid GTA vehicle model (400-611).", thePlayer, 255, 0, 0)
        return
    end

    -- Get base model information
    local baseModelName = getVehicleNameFromModel(baseModelId) or "Unknown"

    -- Create a vehicle record in the library
    local veh = {}
    veh.mtaModel = tostring(modelId)
    veh.brand = "Custom"
    veh.model = "Custom " .. baseModelName
    veh.year = tostring(getRealTime().year)
    veh.price = "100000"
    veh.tax = "10000"
    veh.note = "Custom vehicle model based on " .. baseModelName .. " (ID: " .. baseModelId .. ")"
    veh.enabled = true
    veh.update = false
    veh.spawnto = 0
    veh.doortype = 0
    veh.stock = 10
    veh.rate = 10

    triggerServerEvent("vehlib:createVehicle", thePlayer, veh)

    outputChatBox("Added custom vehicle model " .. modelId .. " to the vehicle library.", thePlayer, 0, 255, 0)
end
addCommandHandler("addcustomveh", addCustomVehicleToLibrary)
