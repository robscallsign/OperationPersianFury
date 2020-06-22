-- Capture and Hold is a game mechanic that once a Group is dead, it spawns in a
-- Acknowledgements:  Moosehead of the 425 originally developed this mechanic for the Elbrus Archer mission using
-- triggers in the mission editor.
--
-- USAGE:
--
-- Create a table with two columns, and N rows.  The first column specifies the BLUE unit, and the second column
-- specifies the RED unit.
-- Initial conditions are set using the mission editor by late activating the unit that is not to be spawned in
--
-- Example:
--
-- local locations = {{'Kobuleti_Blue','Kobuleti_Red'},
--                   {'Batumi_Blue','Batumi_Red'}}
--
--CaptureAndHoldSetup(locations)
-- 
-- and then when the Kobuleti_Blue group is dead, then the Kobuleti_Red group is spawned in.
-- When placed at airfields or FARPs this can change the coalition of the FARP.  It does not
-- remove client slots from the airfield.


local debugMessages = 0

local CaptureHold_SwitchTable = {}

function SwitchState(deadUnit)
  
  if (deadUnit == nil or deadUnit == '') then
    return
  end
  
  if debugMessages == 1 then
    trigger.action.outText("Received dead unit: " .. deadUnit, 10)
    env.info("RECEIVED DEAD UNIT: " .. deadUnit)
    -- HypeMan.sendDebugMessage('Receive dead unit: " .. deadUnit)
  end
  
  local spawnUnit = CaptureHold_SwitchTable[deadUnit]
  
  if (spawnUnit == nil or spawnUnit == '' ) then
      -- env.info('spawnUnit was nil or empty')
  else
    HypeMan.sendBotMessage('Area Captured!  ' .. deadUnit .. ' was killed.  Spawning in ' .. spawnUnit)
		
	if debugMessages == 1 then
		trigger.action.outText(" Spawning " .. spawnUnit, 10)	
	end
	
    mist.respawnGroup(spawnUnit, true)
    DbRestoreGroup(spawnUnit)
  end 
end
				   				   
function MakeTable(loc)  
  local redTable = {}
  
  for i in pairs(loc) do    
    redTable[loc[i][1]]=loc[i][2]
    redTable[loc[i][2]]=loc[i][1]
  end
  
  return redTable
end

local function CheckStatus(locations)
  for i in pairs(locations) do
    if locations[i][3] == 1 then
      g = locations[i][1]
    else
      g = locations[i][2]
    end
    
    HypeMan.sendDebugMessage('Checking status of ' .. g)
    local grp = Group.getByName(g)
    
    if grp == nil then
      HypeMan.sendDebugMessage('Group was NIL')
    else
      HypeMan.sendDebugMessage('Group was NOT NIL.  Size was ' .. grp:getSize())
          
    end
    
  end
end

MyUnitList = {}

local function MakeUnitList_group(groupName)
  local g = Group.getByName(groupName)
  
  if g ~= nil then
    
    MyUnitList[groupName] = {}
    for index, u in pairs(g:getUnits()) do
      local unitName = u:getName()            
      table.insert(MyUnitList[groupName], unitName)
    end
  end
  
end

local function MakeUnitList(locations)
  for index in ipairs(locations) do   
    MakeUnitList_group(locations[index][1])
    MakeUnitList_group(locations[index][2])
  end  
end

-- This doesn't work - it bypasses the persistence db
local function CaptureAndHold_SpawnFirstColumn(locations)
  for index in ipairs(locations) do
    HypeMan.sendDebugMessage('Trying to respawn ' .. locations[index][1])
    mist.respawnGroup(locations[index][1], true)
  end
end


function CaptureAndHoldSetup(locations)
 -- put into SnowFox Persistent World
    UnitList = MakeUnitList(locations)
 
	CaptureHold_SwitchTable = MakeTable(locations)
 -- CheckStatus(locations)
	-- loop through all of the units defined in the locations list
	-- add a custom OnEventDead handler that calls the SwitchState
	-- function.  When each group dies it triggers the respawn of the
	-- opposite coalition unit
  
	for i in pairs(CaptureHold_SwitchTable) do

	  local mygroup = GROUP:FindByName( CaptureHold_SwitchTable[i] )
	  
	  if (mygroup == nil or mygroup == '') then
      -- env.info('MYGROUP WAS NIL FOR LOCATION: ' .. CaptureHold_SwitchTable[i])
	  else
      mygroup:HandleEvent( EVENTS.Dead )
		
      function mygroup:OnEventDead( EventData )      
        -- debug message for the group size
        -- trigger.action.outText(EventData.IniGroupName  .. " size: " .. self:GetSize(), 10)	
        if self:GetSize() <= 1 then
			
          --if debugMessages == 1 then
           -- trigger.action.outText(EventData.IniGroupName  .. "(group) is dead!", 10)			
           -- HypeMan.sendBotMessage(EventData.IniGroupName  .. "(group) is dead!")
          --end			
          SwitchState(EventData.IniGroupName)
        end		
      end	  
    end    
  end -- loop over the table
  
end -- end function




