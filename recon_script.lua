-- DCS RECON SCRIPT
-- Description:
-- Client aircraft with Group Names starting with 'Recon' are considered reconnaissance units.
-- Every 2 seconds the script checks for enemy units within a given radius around the aircraft.
-- If enemy units are spotted their location is written to Discord in a reconnaissance report.
-- Once an enemy unit has been spotted it won't be reported again.
--
-- This script is a preliminary work in progress.
-- Requires Mist, Moose, HypeMan (https://aggressors.ca/HypeManII, https://github.com/robscallsign/HypeMan)

local searchRadius=2000
local reconGroupPrefix = 'Recon'

local BlueClientSet = SET_CLIENT:New():FilterActive():FilterStart()

local function starts_with(str, start)
   return str:sub(1, #start) == start
end

local spottedUnits = {}

function doClientRecon ( Client )	
  
  if starts_with(Client:GetClientGroupName(), reconGroupPrefix) then
    local unitname = Client:GetClientGroupDCSUnit():getName()
    if unitname ~= nil then
			retval = mist.getUnitsInMovingZones(mist.makeUnitTable({'[red]'}), {unitname}, searchRadius, 'cylinder' )
			
			if retval ~= nil and next(retval) ~= nil then        
        local unitArray = {}
        local count = 0
        for i = 1, #retval do  
          local curId = retval[i]           
          
          if spottedUnits[curId.id_] == nil then
            
            count = count + 1
            
            local obj={}                      
						obj['type'] = Unit.getTypeName(curId)
						-- obj['cat'] = Unit.getCategory(curId)
						local _lat, _lon = coord.LOtoLL(Unit.getPosition(retval[i]).p)
						--obj['lat'] = _lat
						--obj['lon'] = _lon
						obj['ll'] = mist.tostringLL(_lat, _lon, 3, true)
						obj['mgrs'] = mist.tostringMGRS(coord.LLtoMGRS(coord.LOtoLL(Unit.getPosition(retval[i]).p)), 5)
            obj['r']=0
            
            local pos = Unit.getPoint(curId)
            obj['elev'] = pos.y
            
            unitArray[count] = obj
            spottedUnits[curId.id_] = true 
            
           -- HypeMan.sendDebugMessage('building unit array count = ' .. tostring(count))
          end -- if spotted was nil (i.e. unit not already spotted)
        end -- for i=1, #retval
        
        if count ~= 0 then
        --  HypeMan.sendDebugMessage('count ~= 0 send table')
          local sendTable = {}
          sendTable['pilot'] = Client:GetPlayerName()
          sendTable['airframe'] = Client:GetClientGroupDCSUnit():getTypeName()
          sendTable['units'] = unitArray
          sendTable['r']=0
          sendTable.messageType = 5
          HypeMan.sendBotTable(sendTable)
        end              
			end	 -- retval not nil?		      
    end -- unitname ~= nil then 
  end -- starts_with(Client:GetClientGroupName(), reconGroupPrefix) then
end
	
	
function RunReconTimer(ourArgument, time)	
	BlueClientSet:ForEachClient(doClientRecon)	
  return time + 2
end

timer.scheduleFunction(RunReconTimer,1, timer.getTime() + 2)
