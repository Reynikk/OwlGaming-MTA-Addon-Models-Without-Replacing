-- temp fix for MTA Issue 6846: getVehicleType with trailers returns empty string client-side
-- Also handles custom vehicle models (negative IDs)
local vt = getVehicleType
function getVehicleType( vehicle )
	-- Check if it's a model ID (number) or a vehicle element
	if type(vehicle) == "number" then
		-- If it's a negative number (custom model), get the base model
		if vehicle < 0 and exports.vehicle then
			vehicle = exports.vehicle:getVehicleBaseModel(vehicle)
		end
	end

	local ret = vt( vehicle )
	if ret == "" then
		return "Trailer"
	end
	return ret
end
