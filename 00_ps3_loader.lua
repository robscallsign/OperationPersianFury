-- Place this 
-- assert(loadfile("C:/HypeMan/ps3_tech/00_ps3_loader.lua"))()

assert(loadfile("C:/HypeMan/mist.lua"))()
assert(loadfile("C:/HypeMan/Moose.lua"))()
--assert(loadfile("C:/HypeMan/skynet/JSON.lua"))()

JSON = (loadfile "C:/HypeMan/skynet/JSON.lua")() -- one-time load of the routines

assert(loadfile("C:/HypeMan/HypeMan.lua"))()

-- assert(loadfile("C:/HypeMan/skynet/SGS.lua"))()

--assert(loadfile("C:/HypeMan/skynet/debug_menu.lua"))()
--assert(loadfile("C:/HypeMan/skynet/recon_script.lua"))()
--assert(loadfile("C:/HypeMan/skynet/scud_counter.lua"))()

assert(loadfile("C:/HypeMan/ps3_tech/recon_script.lua"))()

-- assert(loadfile("C:/HypeMan/skynet/elbrus_events.lua"))()
-- assert(loadfile("C:/HypeMan/skynet/skynet-iads-compiled.lua"))()
--assert(loadfile("C:/HypeMan/skynet/skynet_test01.lua"))()