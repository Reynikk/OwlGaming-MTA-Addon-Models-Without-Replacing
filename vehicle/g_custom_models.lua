--[[
* ***********************************************************************************************************************
* Copyright (c) 2023 MTA Tacky Server - All Rights Reserved
* All rights reserved. This program and the accompanying materials are private property belongs to MTA Tacky Server
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* ***********************************************************************************************************************
]]

-- Load newmodels functions, which allow usage of custom model IDs "as if they were normal IDs"
loadstring(exports.newmodels_azul:import())()

-- Utility functions for custom vehicle models

-- Check if a model ID is a custom model (negative ID)
function isCustomVehicleModel(modelId)
    return tonumber(modelId) and tonumber(modelId) < 0
end

-- Get the base model for a custom model
function getVehicleBaseModel(modelId)
    if not isCustomVehicleModel(modelId) then
        return modelId -- Return the same ID if it's not a custom model
    end

    -- For custom models, use the appropriate function from newmodels_azul
    -- Check if we're dealing with an element or just a model ID
    local baseModel
    if isElement(modelId) then
        -- If it's an element, use getElementBaseModel
        if getElementType(modelId) == "vehicle" then
            baseModel = getElementBaseModel(modelId)
        else
            -- If it's not a vehicle element, return default
            return 400
        end
    else
        -- If it's just a model ID, use a hardcoded mapping for now
        -- This should be replaced with a proper function from newmodels_azul
        -- Common base models for custom vehicles
        local customModelMap = {
            [-1] = 411, -- Infernus
            [-2] = 468, -- Sanchez
            [-3] = 429, -- Banshee
            [-4] = 402, -- Buffalo
            [-5] = 541, -- Bullet
            [-6] = 415, -- Cheetah
            [-7] = 480, -- Comet
            [-8] = 562, -- Elegy
            [-9] = 587, -- Euros
            [-10] = 565 -- Flash
        }

        baseModel = customModelMap[modelId] or 400
    end

    return baseModel or 400 -- Default to 400 (Landstalker) if base model can't be determined
end

-- Create a vehicle with support for custom models
function createVehicleWithCustomModel(modelId, x, y, z, rx, ry, rz, plate, direction, variant1, variant2)
    -- Load the newmodels functions if not already loaded
    if not _G.getElementBaseModel then
        loadstring(exports.newmodels_azul:import())()
    end

    -- Store the original model ID for reference
    local originalModelId = modelId
    local isCustom = isCustomVehicleModel(modelId)

    outputDebugString("VEHICLE / Creating vehicle with model ID " .. tostring(modelId) .. ", Is custom: " .. tostring(isCustom))

    -- Create the vehicle using the model ID (works for both standard and custom models)
    local vehicle = createVehicle(modelId, x, y, z, rx, ry, rz, plate, direction, variant1, variant2)

    -- If creation failed, try to create with a default model
    if not vehicle and isCustom then
        outputDebugString("Failed to create custom vehicle with ID " .. modelId .. ". Trying with base model.", 2)
        local baseModel = getVehicleBaseModel(modelId)
        vehicle = createVehicle(baseModel, x, y, z, rx, ry, rz, plate, direction, variant1, variant2)

        if vehicle then
            -- Store the custom model ID for reference
            exports.anticheat:setEld(vehicle, "custom_model_id", modelId, 'all')
            exports.anticheat:setEld(vehicle, "vehicle:originalModel", modelId, 'all')
            outputDebugString("Created vehicle with base model " .. baseModel .. " for custom model " .. modelId, 3)
        end
    end

    -- If vehicle was created successfully, store the original model ID
    if vehicle then
        if isCustom then
            -- Store the custom model ID for reference
            exports.anticheat:setEld(vehicle, "custom_model_id", originalModelId, 'all')
            exports.anticheat:setEld(vehicle, "vehicle:originalModel", originalModelId, 'all')
            outputDebugString("Stored custom model ID " .. originalModelId .. " for vehicle", 3)

            -- Set vehicle shop ID if available
            local shopID = exports.mysql:query_fetch_assoc("SELECT `id` FROM `vehicles_shop` WHERE `vehmtamodel`='"..tostring(originalModelId).."' LIMIT 1")
            if shopID and shopID.id then
                exports.anticheat:setEld(vehicle, "vehicle_shop_id", tonumber(shopID.id), 'all')
                outputDebugString("Set vehicle_shop_id to " .. shopID.id .. " for custom model " .. originalModelId, 3)
            end
        end
    end

    return vehicle
end

-- Get the appropriate model ID for fuel calculations and other operations
function getEffectiveVehicleModel(vehicle)
    if isElement(vehicle) then
        local modelId = getElementModel(vehicle)
        if isCustomVehicleModel(modelId) then
            return getVehicleBaseModel(modelId)
        else
            return modelId
        end
    end
    return nil
end
