--[[
* ***********************************************************************************************************************
* Copyright (c) 2015 OwlGaming Community - All Rights Reserved
* All rights reserved. This program and the accompanying materials are private property belongs to OwlGaming Community
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* ***********************************************************************************************************************
]]

function createUniqueVehicle(data, existed)
	if not data then
		outputDebugString("VEHICLE MANAGER / createUniqueVehicle / NO DATA RECIEVED FROM CLIENT")
		return false
	end

	data.doortype = getRealDoorType(data.doortype) or 'NULL'

	local vehicle = exports.pool:getElement("vehicle", tonumber(data.id))
	local forumText = [=[
[B]General Information[/B]:
[INDENT]Vehicle ID:   [B]]=] ..tostring(data.id) ..[=[[/B][/INDENT]
[INDENT]Current Owner:   [B]]=] ..tostring(getVehicleOwner(vehicle)) ..[=[[/B][/INDENT]
[INDENT]Edited by:   [B]]=] ..tostring(getElementData(client, "account:username")) ..[=[[/B][/INDENT]
[B]New Vehicle Data[/B]:
[INDENT]Brand:   [B]]=] ..tostring(data.brand) ..[=[[/B][/INDENT]
[INDENT]Model:   [B]]=] ..tostring(data.model) ..[=[[/B][/INDENT]
[INDENT]Year:    [B]]=] ..tostring(data.year) ..[=[[/B][/INDENT]
[INDENT]Price:   [B]]=] ..tostring(data.price) ..[=[[/B][/INDENT]
[INDENT]Tax:     [B]]=] ..tostring(data.tax) ..[=[[/B][/INDENT]
[INDENT]Door Type: [B]]=] ..tostring(data.doortype) ..[=[[/B][/INDENT]
[B]Old Vehicle Data[/B]:
[INDENT]Brand:   [B]]=] ..tostring(getElementData(vehicle, "brand")) ..[=[[/B][/INDENT]
[INDENT]Model:   [B]]=] ..tostring(getElementData(vehicle, "maximemodel")) ..[=[[/B][/INDENT]
[INDENT]Year:    [B]]=] ..tostring(getElementData(vehicle, "year")) ..[=[[/B][/INDENT]
[INDENT]Price:   [B]]=] ..tostring(getElementData(vehicle, "carshop:cost")) ..[=[[/B][/INDENT]
[INDENT]Tax:     [B]]=] ..tostring(getElementData(vehicle, "carshop:taxcost")) ..[=[[/B][/INDENT]
[INDENT]Door Type: [B]]=] ..tostring(getElementData(vehicle, "vDoorType") or 'NULL') ..[=[[/B][/INDENT]]=]

	if not existed then
		dbExec( exports.mysql:getConn('mta'), "REPLACE INTO vehicles_custom SET id=?, brand=?, model=?, year=?, price=?, tax=?, createdby=?, handling=(SELECT s.handling FROM vehicles_shop s WHERE s.id=?), doortype="..data.doortype, data.id, data.brand, data.model, data.year, data.price, data.tax, getElementData(client, "account:id"), getElementData( vehicle, 'vehicle_shop_id' ) )
		outputChatBox("[VEHICLE MANAGER] Unique vehicle created.", client, 0,255,0)
		exports.logs:dbLog(client, 6, { client }, " Created unique vehicle #"..data.id..".")
		exports.global:sendMessageToAdmins("[VEHICLE-MANAGER]: "..getElementData(client, "account:username").." has created new unique vehicle #"..data.id..".")
		exports.vehicle:reloadVehicle(tonumber(data.id))
		local topicLink = createForumThread(getElementData(client, "account:username").." created unique vehicle #"..data.id, forumText)
		addVehicleLogs(tonumber(data.id), 'editveh: ' .. (topicLink or "DB error"), client)
		return true
	else
		dbExec( exports.mysql:getConn('mta'), "UPDATE vehicles_custom SET brand=?, model=?, year=?, price=?, tax=?, updatedby=?, updatedate=NOW(), doortype="..data.doortype.." WHERE id=?", data.brand, data.model, data.year, data.price, data.tax, getElementData(client, "account:id"), data.id )
		outputChatBox("[VEHICLE MANAGER] You have updated unique vehicle #"..data.id..".", client, 0,255,0)
		exports.logs:dbLog(client, 6, { client }, " Updated unique vehicle #"..data.id..".")
		exports.global:sendMessageToAdmins("[VEHICLE-MANAGER]: "..getElementData(client, "account:username").." has updated unique vehicle #"..data.id..".")
		exports.vehicle:reloadVehicle(tonumber(data.id))
		local topicLink = createForumThread(getElementData(client, "account:username").." updated unique vehicle #"..data.id, forumText)
		addVehicleLogs(tonumber(data.id), 'editveh: ' .. (topicLink or "DB Error"), client)
		return true
	end
end
addEvent("vehlib:handling:createUniqueVehicle", true)
addEventHandler("vehlib:handling:createUniqueVehicle", getRootElement(), createUniqueVehicle)

function resetUniqueVehicle(vehID)
	if not vehID or not tonumber(vehID) then
		outputDebugString("VEHICLE MANAGER / resetUniqueVehicle / NO DATA RECIEVED FROM CLIENT")
		return false
	end

	local mQuery1 = mysql:query_free("DELETE FROM `vehicles_custom` WHERE `id`='"..toSQL(vehID).."' ")
	if not mQuery1 then
		outputDebugString("VEHICLE MANAGER / VEHICLE LIB / resetUniqueVehicle / DATABASE ERROR")
		outputChatBox("[VEHICLE MANAGER] Remove unique vehicle #"..vehID.." failed.", client, 255,0,0)
		return false
	end
	outputChatBox("[VEHICLE MANAGER] You have removed unique vehicle #"..vehID..".", client, 0,255,0)
	exports.logs:dbLog(client, 6, { client }, " Removed unique vehicle #"..vehID..".")
	exports.global:sendMessageToAdmins("[VEHICLE-MANAGER]: "..getElementData(client, "account:username").." has removed unique vehicle #"..vehID..".")
	exports.vehicle:reloadVehicle(tonumber(vehID))

	local vehicle = exports.pool:getElement("vehicle", tonumber(vehID))
	local forumText = [=[
		[INDENT]Vehicle ID:   [B]]=] ..tostring(vehID) ..[=[[/B][/INDENT]
		[INDENT]Current Owner:   [B]]=] ..tostring(getVehicleOwner(vehicle)) ..[=[[/B][/INDENT]
		[INDENT]Edited by:   [B]]=] ..tostring(getElementData(client, "account:username")) ..[=[[/B][/INDENT]]=]
	local topicLink = createForumThread(getElementData(client, "account:username").." reset unique vehicle #"..vehID, forumText)
	addVehicleLogs(tonumber(vehID), 'editveh reset: ' .. ( topicLink or "DB Error"), client)
	return true
end
addEvent("vehlib:handling:resetUniqueVehicle", true)
addEventHandler("vehlib:handling:resetUniqueVehicle", getRootElement(), resetUniqueVehicle)

---HANDLINGS
function openUniqueHandling(vehdbid, existed)
	if exports.integration:isPlayerVehicleConsultant(client) or exports.integration:isPlayerLeadAdmin(client) then
		local theVehicle = getPedOccupiedVehicle(client) or false
		if not theVehicle then
			outputChatBox( "You must be in a vehicle.", client, 255, 194, 14)
			return false
		end

		local vehID = getElementData(theVehicle, "dbid") or false
		if not vehID or vehID < 0 then
			outputChatBox("This vehicle can not have custom properties.", client, 255, 194, 14)
			return false
		end

		-- For custom models, always treat as if existed is true
		local originalModelID = getElementData(theVehicle, "custom_model_id") or getElementData(theVehicle, "vehicle:originalModel")
		local modelID = getElementModel(theVehicle)
		local isCustomModel = exports.vehicle:isCustomVehicleModel(originalModelID or modelID)
		if isCustomModel then
			existed = true
			outputDebugString("VEHICLE MANAGER / HANDLING / Custom model detected, forcing existed=true for vehicle ID #" .. vehID)
		end
		outputDebugString("VEHICLE MANAGER / HANDLING / Opening handling editor for vehicle ID #" .. vehID .. ": Model=" .. modelID .. ", Original model=" .. tostring(originalModelID) .. ", Is custom: " .. tostring(isCustomModel))

		if existed then
			-- Check if record exists in vehicles_custom
			local row = mysql:query_fetch_assoc("SELECT `handling` FROM `vehicles_custom` WHERE `id` = '" .. mysql:escape_string(vehdbid) .. "' LIMIT 1" ) or false
			if not row then
				-- If no record exists, create one for custom models
				if isCustomModel then
					outputDebugString("VEHICLE MANAGER / HANDLING / No record found in vehicles_custom for vehicle ID #" .. vehID .. ", creating one")

					-- Get vehicle data
					local brand = getElementData(theVehicle, "brand") or "Custom"
					local model = getElementData(theVehicle, "maximemodel") or "Custom Vehicle"
					local year = getElementData(theVehicle, "year") or tostring(getRealTime().year)
					local price = getElementData(theVehicle, "carshop:cost") or "100000"
					local tax = getElementData(theVehicle, "carshop:taxcost") or "10000"
					local doortype = getElementData(theVehicle, "vDoorType") or 0

					-- Create record in vehicles_custom
					local shopID = getElementData(theVehicle, "vehicle_shop_id")
					local handlingQuery = ""
					if shopID then
						handlingQuery = ", handling=(SELECT s.handling FROM vehicles_shop s WHERE s.id='" .. mysql:escape_string(shopID) .. "')"
					end

					-- Check if mtamodel column exists in vehicles_custom table
					local columnsQuery = mysql:query("SHOW COLUMNS FROM vehicles_custom LIKE 'mtamodel'")
					local mtamodelExists = false
					if columnsQuery then
						local row = mysql:fetch_assoc(columnsQuery)
						if row then
							mtamodelExists = true
						end
						mysql:free_result(columnsQuery)
					end

					local query = "INSERT INTO vehicles_custom SET id='"..mysql:escape_string(vehdbid).."', brand='"..toSQL(brand).."', model='"..toSQL(model).."', year='"..toSQL(year).."', price='"..toSQL(price).."', tax='"..toSQL(tax).."', createdby='"..getElementData(client, "account:id").."', doortype='"..toSQL(doortype).."'" .. handlingQuery

					-- Add mtamodel column if it exists
					if mtamodelExists then
						query = "INSERT INTO vehicles_custom SET id='"..mysql:escape_string(vehdbid).."', brand='"..toSQL(brand).."', model='"..toSQL(model).."', year='"..toSQL(year).."', price='"..toSQL(price).."', tax='"..toSQL(tax).."', createdby='"..getElementData(client, "account:id").."', mtamodel='"..toSQL(originalModelID).."', doortype='"..toSQL(doortype).."'" .. handlingQuery
					end
					outputDebugString("VEHICLE MANAGER / HANDLING / Query: " .. query)

					local success = mysql:query_free(query)
					if not success then
						outputChatBox( "[VEHICLE-MANAGER] Failed to create record in vehicles_custom.", client, 255, 194, 14)
						outputDebugString("VEHICLE MANAGER / openUniqueHandling / DATABASE ERROR CREATING RECORD")
						return false
					end

					-- Try to get the record again
					row = mysql:query_fetch_assoc("SELECT `handling` FROM `vehicles_custom` WHERE `id` = '" .. mysql:escape_string(vehdbid) .. "' LIMIT 1" ) or false
					if not row then
						outputChatBox( "[VEHICLE-MANAGER] Failed to retrieve current handlings from SQL.", client, 255, 194, 14)
						outputDebugString("VEHICLE MANAGER / openUniqueHandling / DATABASE ERROR AFTER CREATION")
						return false
					end

					outputChatBox("[VEHICLE-MANAGER] Created unique vehicle record for vehicle ID #"..vehdbid..". You can now edit its handling.", client, 0, 255, 0)
				else
					outputChatBox( "[VEHICLE-MANAGER] Failed to retrieve current handlings from SQL.", client, 255, 194, 14)
					outputDebugString("VEHICLE MANAGER / openUniqueHandling / DATABASE ERROR")
					return false
				end
			end

			-- Check if handling exists in database
			if row.handling and row.handling ~= "" then
				-- Handling exists, load it
				outputDebugString("VEHICLE MANAGER / HANDLING / Loading existing handling from database for vehicle ID #" .. vehID)
				triggerClientEvent(client, "veh-manager:handling:edithandling", client, 1)
			else
				-- Handling doesn't exist, load default handling for this model
				outputDebugString("VEHICLE MANAGER / HANDLING / No handling found in database for vehicle ID #" .. vehID .. ", loading default handling")

				-- Get handling from vehicle shop if it's a custom model
				if isCustomModel then
					local shopID = getElementData(theVehicle, "vehicle_shop_id")
					if shopID then
						local shopRow = mysql:query_fetch_assoc("SELECT `handling` FROM `vehicles_shop` WHERE `id` = '" .. mysql:escape_string(shopID) .. "' LIMIT 1" ) or false
						if shopRow and shopRow.handling and shopRow.handling ~= "" then
							-- Update the handling in vehicles_custom with the one from vehicles_shop
							mysql:query_free("UPDATE `vehicles_custom` SET `handling`='"..toSQL(shopRow.handling).."' WHERE `id`='"..tostring(vehdbid).."' ")
							outputDebugString("VEHICLE MANAGER / HANDLING / Copied handling from vehicle shop ID #" .. shopID .. " for vehicle ID #" .. vehID)
						end
					end
				end

				triggerClientEvent(client, "veh-manager:handling:edithandling", client, 1)
			end
		else
			triggerClientEvent(client, "veh-manager:handling:edithandling", client, 1)
		end

		return true
	end
end
addEvent("vehlib:handling:openUniqueHandling", true)
addEventHandler("vehlib:handling:openUniqueHandling", getRootElement(), openUniqueHandling)

function toSQL(stuff)
	if stuff == nil then
		return "NULL"
	end
	return mysql:escape_string(tostring(stuff))
end
