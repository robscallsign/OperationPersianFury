-- Operation Persian Fury - drone strikes

-- Needs four trigger zones defined, and the template UAV groupd:
-- "Shahed 129A" 
-- Task is to attack the map object at the triggerzone "MinadDroneAttack"
local function OnDroneSpawn(SpawnGroup)
	-- HypeMan.sendBotMessage('OnDroneSpawn...')
	
    local GroupName = SpawnGroup:GetName()
	-- HypeMan.sendBotMessage("Drone Group "..GroupName.." spawned.")
    -- local BomberTask = SpawnGroup:TaskBombingRunway(AIRBASE:FindByName(AIRBASE.PersianGulf.Al_Minhad_AB),nil,"All",3,nil,true)
	
	local TriggerZone = ZONE:FindByName( "MinadDroneAttack" )
	
	local bombTask = SpawnGroup:TaskAttackMapObject(TriggerZone:GetVec2())
    SpawnGroup:PushTask(bombTask, 1)
	
	--local LandingZone = ZONE:FindByName("Landing Zone")
	--local rtbTask = SpawnGroup:TaskLandAtZone(LandingZone)
	--local rtbTask = SpawnGroup:TaskReturnToBase(AIRBASE:FindByName(AIRBASE.PersianGulf.Dubai_Intl))
	-- SpawnGroup:PushTask(rtbTask, 10)
end

ZoneTable = { ZONE:New( "DroneSpawnQeshm" ), ZONE:New( "DroneSpawnMinab" ), ZONE:New("DroneSpawnJask"), ZONE:New("DroneSpawnBandar") }
local Drone02 = SPAWN:New( "Shahed 129A" ):InitRandomizeZones( ZoneTable):InitLimit(5,10):OnSpawnGroup(OnDroneSpawn):InitCleanUp( 20 ):SpawnScheduled( 60, 0.5 )
