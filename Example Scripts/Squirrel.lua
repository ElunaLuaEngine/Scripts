print "---------- Squirrel attack ---"

local NPCsquirel = 1412
local function Squirel(event, creature, player)
	player:SendAreaTriggerMessage("Squirrels are our friends !!! Let them live !")
	player:AddAura(28271, player)
end
RegisterCreatureEvent(NPCsquirel , 9, Squirel)
