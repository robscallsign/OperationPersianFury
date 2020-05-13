-- Persistent AI Squadron Strength
-- Writes an inventory file that gets loaded at mission start

local inventoryFile = 'inventory.lua'

local function defaultInventory()
	local inventory = {  
	   ["F-14A"]=12,
	   ["MiG-21Bis"]=12,
	   ["F-5E-3"]=12,
	   ["MiG-29A"]=12,
	   ["F-4E"]=12,
	}	
	return inventory
end   

local function fileExists(name)
    if lfs.attributes(name) then
    return true
    else
    return false end 
end

local function writeInventoryFile(tbl, filename)
	local raw_json_text    = JSON:encode(tbl)    
    local file,err = io.open( filename, "w+" )
    if err then return err end
      
    file:write( raw_json_text )
    file:close()	
end
   
local function readInventoryFile(filename)	
    local file,err = io.open( filename, "r" )
    if err then return nil end
	
	local raw_json_text = file:read("*all")
	local lua_table = JSON:decode(raw_json_text)
	
	return lua_table
end

-- make the inventory global
RedAirInventory = {}

if fileExists(inventoryFile) then
	env.info("HYPEMAN - Inventory file: " .. inventoryFile .. " exists, loading ...")
	
	RedAirInventory = readInventoryFile(inventoryFile)
	
	if RedAirInventory == nil then
		env.info("HYPEMAN - error reading inventory file, setting default.")
		RedAirInventory = defaultInventory()
	end
else
	RedAirInventory = defaultInventory()
	env.info("HYPEMAN - Inventory does  not exist, writing ...")	
	writeInventoryFile(RedAirInventory, inventoryFile)
end 


function RunInventoryTimer(ourArgument, time)		
	writeInventoryFile(RedAirInventory, inventoryFile)
   return time + 31
end

timer.scheduleFunction(RunInventoryTimer, 1, timer.getTime() + 31)

HypeMan.sendBotMessage('-------------- Reloading Mission ----------------------')

DetectionSetGroup = SET_GROUP:New()
DetectionSetGroup:FilterPrefixes( { "EWR_AWACS", "EWR_RED" } )
DetectionSetGroup:FilterStart()


Detection = DETECTION_AREAS:New( DetectionSetGroup, 40000 )

-- Setup the A2A dispatcher, and initialize it.
A2ADispatcher = AI_A2A_DISPATCHER:New( Detection )
A2ADispatcher:SetTacticalDisplay( true )
A2ADispatcher:SetDefaultGrouping(4)
CapZone = ZONE_POLYGON:New( "RED_CAP_ZONE", GROUP:FindByName( "RED_CAP_ZONE" ) )
A2ADispatcher:SetBorderZone( CapZone )

CCCPBorderZone = ZONE_POLYGON:New( "CCCP Border", GROUP:FindByName( "RED_BORDER_ZONE" ) )
A2ADispatcher:SetBorderZone( CCCPBorderZone )
A2ADispatcher:SetDefaultDamageThreshold( 0.90 )
A2ADispatcher:SetDefaultCapTimeInterval( 400, 400)

local f14inventory = RedAirInventory['F-14A']

function RunSquadronInterval(squadronName, time)	
	A2ADispatcher:SetSquadronCapInterval( squadronName, 1, 30, 60)
end

if f14inventory > 1 then
	HypeMan.sendBotMessage('HypeMan loading persistent AI squadrons.  F14 inventory: ' .. tostring(f14inventory))
	A2ADispatcher:SetSquadron( "Bandar", AIRBASE.PersianGulf.Bandar_Abbas_Intl, { "REDCAP_BANDAR_F14" }, f14inventory)
	A2ADispatcher:SetSquadronTakeoffInAir("Bandar", 1000)

	A2ADispatcher:SetSquadronCap( "Bandar", CapZone, 1500, 40000, 600, 800, 800, 1200, "BARO" )
	A2ADispatcher:SetSquadronCapInterval( "Bandar", 1, 15, 45)
	timer.scheduleFunction(RunSquadronInterval, "Bandar", timer.getTime() + 60)	
else
	HypeMan.sendBotMessage('HypeMan loading persistent AI squadrons.  F14 inventory DEPLETED!!!')
end

A2ADispatcher:Start()

alreadyCounted = {}

local function HandleInventory(event)
				
	if Unit.getCoalition(event.initiator) ~= 1 then
		return
	end
	
	name = Unit.getName(event.initiator)
		
	if name == nil then		
		return
	end	
		
	local typeName = Unit.getTypeName(event.initiator)
	
	if typeName == nil or typeName == '' then
		return
	end
	
	if RedAirInventory[typeName] ~= nil then	
		if alreadyCounted[name] == nil then
			alreadyCounted[name] =  1
					
			RedAirInventory[typeName] = RedAirInventory[typeName]  - 1

			msgString = 'Red Aircraft Inventory Update: ' .. typeName .. ' removed inventory. Number remaining: ' .. tostring(RedAirInventory[typeName])
			env.info(msgString)
			HypeMan.sendBotMessage(msgString)
		
		else
			-- msgString = 'HYPEMAN - ALREADY COUNTED FOR THIS name: ' .. name		 
			-- env.info(msgString)		
		end
	end
end

local function DispatchDeadHandler(event)	
	if event.id == world.event.S_EVENT_DEAD then
		env.info('HYPEMAN - S_EVENT_DEAD')
		HandleInventory(event)		
	end
	
	if event.id == world.event.S_EVENT_CRASH then
		env.info('HYPEMAN - S_EVENT_CRASH')
		HandleInventory(event)
	end
	
	if event.id == world.event.S_EVENT_EJECTION then
		name = Unit.getName(event.initiator)
		env.info('HYPEMAN - EJECTION Unit.getName: ' .. name)
		HandleInventory(event)
	end
end 

mist.addEventHandler(DispatchDeadHandler)

