--[[
	EmuDevs <http://emudevs.com/forum.php>
	Eluna Lua Engine <https://github.com/ElunaLuaEngine/Eluna>
	Eluna Scripts <https://github.com/ElunaLuaEngine/Scripts>
	Eluna Wiki <http://wiki.emudevs.com/doku.php?id=eluna>

	-= Script Information =-
	* Script Type: Boss Fight
	* Npc: Jergosh the Invoker <11518>
--]]

local Jergosh = {};

function Jergosh.OnEnterCombat(event, creature, target)
	creature:RegisterEvent(Jergosh.Immolate, 12000, 0)
	creature:RegisterEvent(Jergosh.Curse_of_Weakness, 30000, 0)
end

function Jergosh.Immolate(event, delay, pCall, creature)
	if (math.random(1, 100) <= 85) then
		creature:CastSpell(creature:GetVictim(), 20800)
	end
end

function Jergosh.Curse_of_Weakness(event, delay, pCall, creature)
	if (math.random(1, 100) <= 75) then
		local players = creature:GetPlayersInRange()
		creature:CastSpell(players[math.random(1, #players)], 11980)
	end
end

function Jergosh.Reset(event, creature)
	creature:RemoveEvents()
end

RegisterCreatureEvent(11518, 1, Jergosh.OnEnterCombat)
RegisterCreatureEvent(11518, 2, Jergosh.Reset) -- OnLeaveCombat
RegisterCreatureEvent(11518, 4, Jergosh.Reset) -- OnDied