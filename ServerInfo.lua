package.path  = package.path..";.\\LuaSocket\\?.lua"
package.cpath = package.cpath..";.\\LuaSocket\\?.dll"

local socket = require("socket")

local rangeExportSocket = socket.udp()
rangeExportSocket:setsockname("*", 65001)
rangeExportSocket:setoption('broadcast', true)
rangeExportSocket:settimeout(.001) 

local serverTime0 = timer.getAbsTime()

local function round2(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

local function RunInfoReceive(ourArgument, time)		
	data = rangeExportSocket:receive()
	if data then
		--HypeMan.sendBotMessage('Mission time command received from inside DCS... ')
		--HypeMan.sendDebugMessage(data)
		local objectInfo = JSON:decode(data)
	end
	-- HypeMan.sendDebugMessage('.')
   return time + 1
end

timer.scheduleFunction(RunInfoReceive, 1, timer.getTime() + 1)

