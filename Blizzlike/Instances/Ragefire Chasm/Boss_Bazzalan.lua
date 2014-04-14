--[[
	EmuDevs <http://emudevs.com/forum.php>
	Eluna Lua Engine <https://github.com/ElunaLuaEngine/Eluna>
	Eluna Scripts <https://github.com/ElunaLuaEngine/Scripts>
	Eluna Wiki <http://wiki.emudevs.com/doku.php?id=eluna>

	-= Script Information =-
	* Script Type: Boss Fight
	* Npc: Bazzalan <11519>
--]]

local Bazzalan = {};

function Bazzalan.OnEnterCombat(event, creature, target)
	creature:RegisterEvent(Bazzalan.Poison, math.random(3000, 5000), 0)
	creature:RegisterEvent(Bazzalan.Sinister_Strike, 8000, 0)
end

function Bazzalan.Poison(event, delay, pCall, creature)
	if (math.random(1, 100) <= 75) then
		creature:CastSpell(creature:GetVictim(), 744)
	end
end

function Bazzalan.Sinister_Strike(event, delay, pCall, creature)
	if (math.random(1, 100) <= 85) then
		creature:CastSpell(creature:GetVictim(), 14873)
	end
end

function Bazzalan.Reset(event, creature)
	creature:RemoveEvents()
end

RegisterCreatureEvent(11519, 1, Bazzalan.OnEnterCombat)
RegisterCreatureEvent(11519, 2, Bazzalan.Reset) -- OnLeaveCombat
RegisterCreatureEvent(11519, 4, Bazzalan.Reset) -- OnDied