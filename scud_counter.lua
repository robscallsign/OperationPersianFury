
 local scudGroup = 'Red_Scud'
 local targetZone = 'Khasab_Zone'
 
-- call it once outside of the scheduled function to test and catch any errors
--local target = {}
--target.x = trigger.misc.getZone(targetZone).point.x
--target.y = trigger.misc.getZone(targetZone).point.z
--target.radius = trigger.misc.getZone(targetZone).radius
--target.expendQty = 2
--target.expendQtyEnabled = true
--local fire = {id = 'FireAtPoint', params = target}
--Group.getByName(scudGroup):getController():pushTask(fire)
	 
 function RunScudShooter(ourArgument, time)	
	HypeMan.sendBotMessage('Cruise missile launch detected from the Iranian Coast!  Scramble or head to the bomb shelters.')
	trigger.action.outText("Scud Counter Ran",45)
	 local target = {}
	 target.x = trigger.misc.getZone(targetZone).point.x
	 target.y = trigger.misc.getZone(targetZone).point.z
	 target.radius = trigger.misc.getZone(targetZone).radius
	 target.expendQty = 2
	 target.expendQtyEnabled = true
	 local fire = {id = 'FireAtPoint', params = target}
	 Group.getByName(scudGroup):getController():pushTask(fire)
 
   return time + 600
end

timer.scheduleFunction(RunScudShooter, 1, timer.getTime() + 660)