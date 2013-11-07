--[[
    EmuDevs <http://emudevs.com/forum.php>
    Eluna Lua Engine <https://github.com/ElunaLuaEngine/Eluna>
    Eluna Scripts <https://github.com/ElunaLuaEngine/Scripts>
    Eluna Wiki <http://wiki.emudevs.com/doku.php?id=eluna>

    -= Script Information =-
    * Zone: Duskwood
    * ItemId: 21149
    * AreaTrigger: Twilight Grove
    * Script Type: AreaTrigger & Boss Fight
    * Npc: Twilight Corrupter <15625>
--]]
local killCount = 0
local corrupter = nil

function OnTrigger(event, player, triggerId)
    if (triggerId == 4017 and player:HasQuestForItem(21149) and corrupter == nil) then
        corrupter = player:SpawnCreature(15625, -10328.16, -489.57, 49.95, 0, 1, 60000)
        if (corrupter ~= nil) then
            corrupter:SetFaction(14)
            corrupter:SetMaxHealth(832750)
            corrupter:SendCreatureTalk(0, player:GetGUID())
        end
    end
end

function OnReset(event, creature)
    creature:RemoveEvents()
    killCount = 0
end

function OnEnterCombat(event, creature, target)
    creature:RegisterEvent(SoulCorruption, math.random(4000) + 15000, 0)
    creature:RegisterEvent(CreatureOfNightmare, 45000, 0)
end

function OnKilledUnit(event, creature, victim)
    if (victim:GetUnitType() == "Player") then
        killCount = killCount + 1
        creature:SendCreatureTalk(2, victim:GetGUID())
        if (killCount == 3) then
            creature:CastSpell(creature, 24312, true)
            killCount = 0
        end
    end
end

function OnDied(event, creature, killer)
    creature:RemoveEvents()
    corrupter = nil
end

function SoulCorruption(event, delay, pCall, creature)
    creature:CastSpell(creature:GetVictim(), 25805)
end

function CreatureOfNightmare(event, delay, pCall, creature)
    creature:CastSpell(creature:GetVictim(), 25806)
end

RegisterServerHook(63, OnTrigger)
RegisterCreatureEvent(15625, 1, OnEnterCombat)
RegisterCreatureEvent(15625, 3, OnKilledUnit)
RegisterCreatureEvent(15625, 4, OnDied)
RegisterCreatureEvent(15625, 23, OnReset)
