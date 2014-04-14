--[[
	EmuDevs <http://emudevs.com/forum.php>
	Eluna Lua Engine <https://github.com/ElunaLuaEngine/Eluna>
	Eluna Scripts <https://github.com/ElunaLuaEngine/Scripts>
	Eluna Wiki <http://wiki.emudevs.com/doku.php?id=eluna>

	-= Script Information =-
	* Script Type: Trash Mob
	* Npc: Searing Blade Cultist <11322>
--]]

local Searing_Blade_Cultist = {};

function Searing_Blade_Cultist.OnEnterCombat(event, creature, target)
	creature:RegisterEvent(Searing_Blade_Cultist.Curse_of_Agony, 12000, 0)
end

function Searing_Blade_Cultist.Curse_of_Agony(event, delay, pCall, creature)
	if (math.random(1, 100) <= 85) then
		local players = creature:GetPlayersInRange()
		creature:CastSpell(players[math.random(1, #players)], 18266)
	end
end

function Searing_Blade_Cultist.Reset(event, creature)
	creature:RemoveEvents()
end

RegisterCreatureEvent(11322, 1, Searing_Blade_Cultist.OnEnterCombat)
RegisterCreatureEvent(11322, 2, Searing_Blade_Cultist.Reset) -- OnLeaveCombat
RegisterCreatureEvent(11322, 4, Searing_Blade_Cultist.Reset) -- OnDied