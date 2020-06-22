-- assert(loadfile("C:/HypeMan/OperationPersianFury/demo_missions/capture_and_hold_persistence_demo_loader.lua"))()
-- To use this loader create a Trigger in the mission
-- Time more (1), DO SCRIPT:
-- assert(loadfile("C:/HypeMan/OperationPersianFury/demo_missions/capture_and_hold_demo_loader.lua"))()

assert(loadfile("C:/HypeMan/mist.lua"))()
assert(loadfile("C:/HypeMan/Moose.lua"))()
JSON = (loadfile "C:/HypeMan/skynet/JSON.lua")() -- one-time load of the routines
assert(loadfile("C:/HypeMan/OperationPersianFury/HypeMan.lua"))()

assert(loadfile("C:/HypeMan/OperationPersianFury/CaptureAndHold.lua"))()

locations= {{'Kobuleti_Blue','Kobuleti_Red'},
                   {'Batumi_Blue','Batumi_Red'}}

CaptureAndHoldSetup(locations)

-- Load the persistent db
dbGroupFile = 'db_group_capture_and_hold_demo.lua'
dbStaticFile = 'db_static_capture_and_hold_demo.lua'


assert(loadfile("C:/HypeMan/OperationPersianFury/Snowfox Persistent World - Output.lua"))()

function SpawnBlueF18()
-- local group = Group.getByName('BlueF18_01')
--  group:activate()

 -- local group2 = Group.getByName('BlueF18_02')
 -- group2:activate()
	 
   mist.respawnGroup('BlueF18_01', true)
   mist.respawnGroup('BlueF18_02', true)
end

function DestroyBlueF18()
  local group = Group.getByName('BlueF18_01')
  group:destroy();
  
  local group2 = Group.getByName('BlueF18_02')
  group2:destroy();  
end

function SpawnRed()
  mist.respawnGroup('Red01', true)
  mist.respawnGroup('Red02', true)
end

function DestroyRed()
  local group = Group.getByName('Red01')
  group:destroy();  
  
  local group2 = Group.getByName('Red02')
  group2:destroy();    
end



local debug_menu=MENU_MISSION:New("Capture and Hold Demo")

MENU_MISSION_COMMAND:New("Respawn BLUE F18", debug_menu, SpawnBlueF18, "")
MENU_MISSION_COMMAND:New("Destroy BLUE F18", debug_menu, DestroyBlueF18, "")
MENU_MISSION_COMMAND:New("Redspawn RED Su25", debug_menu, SpawnRed, "")
MENU_MISSION_COMMAND:New("Destroy RED Su25", debug_menu, DestroyRed, "")


