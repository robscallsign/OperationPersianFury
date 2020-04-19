-- Debug menu to be able to run code on demand from a menu to speed up debugging

function runFile()
assert(loadfile("C:/HypeMan/skynet/debug_code.lua"))()
end

function CommandMenuFunction()
	 trigger.action.outText("Running debug_code.lua:",10)
	 
	local statusflag, name = pcall(runFile)
	
	if statusflag == false then
		return false, nil;
	end
	 
end

local debug_menu=MENU_MISSION:New("Debug")

MENU_MISSION_COMMAND:New("Run debug_code.lua", debug_menu, CommandMenuFunction, "")