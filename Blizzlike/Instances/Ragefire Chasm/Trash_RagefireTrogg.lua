--[[
	EmuDevs <http://emudevs.com/forum.php>
	Eluna Lua Engine <https://github.com/ElunaLuaEngine/Eluna>
	Eluna Scripts <https://github.com/ElunaLuaEngine/Scripts>
	Eluna Wiki <http://wiki.emudevs.com/doku.php?id=eluna>

	-= Script Information =-
	* Script Type: Trash Mob
	* Npc: Ragefire Trogg <11318>
--]]

local Ragefire_Trogg = {};

function Ragefire_Trogg.OnEnterCombat(event, creature, target)
	creature:RegisterEvent(Ragefire_Trogg.Strike, 5000, 0)
end

function Ragefire_Trogg.Strike(event, delay, pCall, creature)
	creature:CastSpell(creature:GetVictim(), 11976)
end

function Ragefire_Trogg.Reset(event, creature)
	creature:RemoveEvents()
end

RegisterCreatureEvent(11318, 1, Ragefire_Trogg.OnEnterCombat)
RegisterCreatureEvent(11318, 2, Ragefire_Trogg.Reset) -- OnLeaveCombat
RegisterCreatureEvent(11318, 4, Ragefire_Trogg.Reset) -- OnDied