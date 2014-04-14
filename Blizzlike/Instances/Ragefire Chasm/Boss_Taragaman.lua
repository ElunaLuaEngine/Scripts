--[[
	EmuDevs <http://emudevs.com/forum.php>
	Eluna Lua Engine <https://github.com/ElunaLuaEngine/Eluna>
	Eluna Scripts <https://github.com/ElunaLuaEngine/Scripts>
	Eluna Wiki <http://wiki.emudevs.com/doku.php?id=eluna>

	-= Script Information =-
	* Script Type: Boss Fight
	* Npc: Taragaman the Hungerer <11520>
--]]

local Taragaman = {};

function Taragaman.OnEnterCombat(event, creature, target)
	creature:RegisterEvent(Taragaman.Uppercut, 5000, 0)
	creature:RegisterEvent(Taragaman.Fire_Nova, 8000, 0)
end

function Taragaman.Uppercut(event, delay, pCall, creature)
	if (math.random(1, 100) <= 85) then
		creature:CastSpell(creature:GetVictim(), 18072)
	end
end

function Taragaman.Fire_Nova(event, delay, pCall, creature)
	if (math.random(1, 100) <= 75) then
		creature:CastSpell(creature:GetVictim(), 11970)
	end
end

function Taragaman.Reset(event, creature)
	creature:RemoveEvents()
end

RegisterCreatureEvent(11520, 1, Taragaman.OnEnterCombat)
RegisterCreatureEvent(11520, 2, Taragaman.Reset) -- OnLeaveCombat
RegisterCreatureEvent(11520, 4, Taragaman.Reset) -- OnDied