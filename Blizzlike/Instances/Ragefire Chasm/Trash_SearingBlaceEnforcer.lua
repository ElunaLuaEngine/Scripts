--[[
	EmuDevs <http://emudevs.com/forum.php>
	Eluna Lua Engine <https://github.com/ElunaLuaEngine/Eluna>
	Eluna Scripts <https://github.com/ElunaLuaEngine/Scripts>
	Eluna Wiki <http://wiki.emudevs.com/doku.php?id=eluna>

	-= Script Information =-
	* Script Type: Trash Mob
	* Npc: Searing Blade Enforcer <11323>
--]]

local Searing_Blade_Enforcer = {};

function Searing_Blade_Enforcer.OnEnterCombat(event, creature, target)
	creature:RegisterEvent(Searing_Blade_Enforcer.Shield_Slam, 8000, 0)
end

function Searing_Blade_Enforcer.Shield_Slam(event, delay, pCall, creature)
	if (math.random(1, 100) <= 75) then
		creature:CastSpell(creature:GetVictim(), 8242)
	end
end

function Searing_Blade_Enforcer.Reset(event, creature)
	creature:RemoveEvents()
end

RegisterCreatureEvent(11323, 1, Searing_Blade_Enforcer.OnEnterCombat)
RegisterCreatureEvent(11323, 2, Searing_Blade_Enforcer.Reset) -- OnLeaveCombat
RegisterCreatureEvent(11323, 4, Searing_Blade_Enforcer.Reset) -- OnDied