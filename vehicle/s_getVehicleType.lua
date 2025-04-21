-- Server-side fix for getVehicleType with custom vehicle models (negative IDs)
local vt = getVehicleType
function getVehicleType( vehicle )
    -- Check if it's a model ID (number) or a vehicle element
    if type(vehicle) == "number" then
        -- If it's a negative number (custom model), get the base model
        if vehicle < 0 then
            vehicle = exports.vehicle:getVehicleBaseModel(vehicle)
        end
    end
    
    local ret = vt( vehicle )
    return ret
end
