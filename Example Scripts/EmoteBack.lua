print "----------- NPC Emote back ---"

local emotenpc = 28993
local emoteback = "Sorry, you're not my type !"
local function Npc_example(event, creature, plr, emoteid)
	if (emoteid) then
		creature:SendUnitSay(emoteback, 0)
	end
end
RegisterCreatureEvent(emotenpc , 8, Npc_example, 17)
