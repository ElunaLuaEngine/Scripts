--[[
	EmuDevs <http://emudevs.com/forum.php>
	Eluna Lua Engine <https://github.com/ElunaLuaEngine/Eluna>
	Eluna Scripts <https://github.com/ElunaLuaEngine/Scripts>
	Eluna Wiki <http://wiki.emudevs.com/doku.php?id=eluna>

	-= Script Information =-
	* Script Type: Boss Fight
	* Npc: Oggleflint <11517>
--]]

local Oggleflint = {};

function Oggleflint.OnEnterCombat(event, creature, target)
	creature:RegisterEvent(Oggleflint.Cleave, 8000, 0)
end

function Oggleflint.Cleave(event, delay, pCall, creature)
	if (math.random(1, 100) <= 70) then
		creature:CastSpell(creature:GetVictim(), 40505)
	end
end

function Oggleflint.Reset(event, creature)
	creature:RemoveEvents()
end

RegisterCreatureEvent(11517, 1, Oggleflint.OnEnterCombat)
RegisterCreatureEvent(11517, 2, Oggleflint.Reset) -- OnLeaveCombat
RegisterCreatureEvent(11517, 4, Oggleflint.Reset) -- OnDied