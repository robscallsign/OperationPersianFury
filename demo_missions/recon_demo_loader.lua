-- To use this loader create a Trigger in the mission
-- Time more (1), DO SCRIPT:
-- assert(loadfile("C:/HypeMan/OperationPersianFury/demo_missions/recon_demo_loader.lua"))()

assert(loadfile("C:/HypeMan/mist.lua"))()
assert(loadfile("C:/HypeMan/Moose.lua"))()
JSON = (loadfile "C:/HypeMan/skynet/JSON.lua")() -- one-time load of the routines
assert(loadfile("C:/HypeMan/HypeMan.lua"))()

assert(loadfile("C:/HypeMan/OperationPersianFury/recon_script.lua"))()