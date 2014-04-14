--[[
	EmuDevs <http://emudevs.com/forum.php>
	Eluna Lua Engine <https://github.com/ElunaLuaEngine/Eluna>
	Eluna Scripts <https://github.com/ElunaLuaEngine/Scripts>
	Eluna Wiki <http://wiki.emudevs.com/doku.php?id=eluna>

	-= Script Information =-
	* Script Type: Trash Mob
	* Npc: Earthborer <11320>
--]]

local Earthborer = {};

function Earthborer.OnEnterCombat(event, creature, target)
	creature:RegisterEvent(Earthborer.Earthborer_Acid, 6000, 0)
end

function Earthborer.Earthborer_Acid(event, delay, pCall, creature)
	if (math.random(1, 100) <= 70) then
		creature:CastSpell(creature:GetVictim(), 18070)
	end
end

function Earthborer.Reset(event, creature)
	creature:RemoveEvents()
end

RegisterCreatureEvent(11320, 1, Earthborer.OnEnterCombat)
RegisterCreatureEvent(11320, 2, Earthborer.Reset) -- OnLeaveCombat
RegisterCreatureEvent(11320, 4, Earthborer.Reset) -- OnDied