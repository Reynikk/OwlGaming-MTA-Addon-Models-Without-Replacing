-- Loads newmodels functions, which allow usage of custom model IDs "as if they were normal IDs"
loadstring(exports.newmodels_azul:import())()

-- Vehicle model, x,y,z, rx,ry,rz, interior,dimension
local VEHICLE_SPAWNS = {
    {-1, 2893.3359375, -853.580078125, 10.875, 356.28, 356.34, 204.01, 0, 0},
    {-2, 2462.3876953125, -1143.4794921875, 35.601566314697, 356.28, 356.34, 204.01, 0, 0},
}

local function createVehicles()
    for i, data in ipairs(VEHICLE_SPAWNS) do
        local model, x, y, z, rx, ry, rz, interior, dimension = unpack(data)
        local vehicle = createVehicle(model, x, y, z, rx, ry, rz)
        if vehicle then
            setElementInterior(vehicle, interior)
            setElementDimension(vehicle, dimension)
            print("#" .. i .. " - Created vehicle with ID " .. model .. " at " .. x .. ", " .. y .. ", " .. z)
        end
    end
end
addEventHandler("onResourceStart", resourceRoot, createVehicles, false)

-- Outputs, for example:
-- This vehicle has the custom model ID -1, which is based on the default model ID 490 (FBI Rancher)
addCommandHandler("myvehicle", function(player)
    local vehicle = getPedOccupiedVehicle(player)
    if not vehicle then
        outputChatBox("You are not in a vehicle", player, 255, 0, 0)
        return
    end
    local model = getElementModel(vehicle)
    local baseModel = getElementBaseModel(vehicle)
    if model == baseModel then
        outputChatBox("This vehicle has the default model ID " .. model .. " ("..(tostring(getVehicleNameFromModel(model)) or "")..")", player, 0, 255, 0)
    else
        if not baseModel then
            outputChatBox("This vehicle has the custom model ID " .. model .. ", but the base model ID could not be determined", player, 255, 0, 0)
            return
        end
        outputChatBox("This vehicle has the custom model ID " .. model .. ", which is based on the default model ID " .. baseModel .. " ("..(tostring(getVehicleNameFromModel(baseModel)) or "")..")", player, 0, 255, 0)
    end
end, false, false)
