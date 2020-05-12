local debugMessages = 1

local locations = {{'Kobuleti Blue','Kobuleti Red'},
                   {'Nigvziani Blue','Nigvziani Red'}}



function SwitchState(deadUnit)
  
  if (deadUnit == nil or deadUnit == '') then
    return
  end
  
  if debugMessages == 1 then
	trigger.action.outText("Received dead unit: " .. deadUnit, 10)
	env.info("RECEIVED DEAD UNIT: " .. deadUnit)
  end
  
  local spawnUnit = mytable[deadUnit]
  
  if (spawnUnit == nil or spawnUnit == '' ) then
      -- env.info('spawnUnit was nil or empty')
  else
    HypeMan.sendBotMessage('Area Captured!  ' .. deadUnit .. ' was killed.  Spawning in ' .. spawnUnit)
		
	if debugMessages == 1 then
		trigger.action.outText(" Spawning " .. spawnUnit, 10)	
	end
	
    mist.respawnGroup(spawnUnit, true)
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

mytable = MakeTable(locations)


-- loop through all of the units defined in the locations list
-- add a custom OnEventDead handler that calls the SwitchState
-- function.  When each group dies it triggers the respawn of the
-- opposite coalition unit
for i in pairs(mytable) do

  local mygroup = GROUP:FindByName( mytable[i] )
  
  if (mygroup == nil or mygroup == '') then
    env.info('MYGROUP WAS NIL FOR LOCATION: ' .. mytable[i])
  else
    mygroup:HandleEvent( EVENTS.Dead )
    
    function mygroup:OnEventDead( EventData )      
      -- debug message for the group size
      -- trigger.action.outText(EventData.IniGroupName  .. " size: " .. self:GetSize(), 10)	
      if self:GetSize() <= 1 then
        
        if debugMessages == 1 then
          trigger.action.outText(EventData.IniGroupName  .. "(group) is dead!", 10)			
          HypeMan.sendBotMessage(EventData.IniGroupName  .. "(group) is dead!")
        end
        
        SwitchState(EventData.IniGroupName)
      end		
    end	
  
  end
end