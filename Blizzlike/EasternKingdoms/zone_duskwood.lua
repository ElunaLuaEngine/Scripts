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

function TwilightCorrupter_OnTrigger(event, player, triggerId)
    if (triggerId == 4017 and player:HasQuestForItem(21149) and corrupter == nil) then
        corrupter = player:SpawnCreature(15625, -10328.16, -489.57, 49.95, 0, 1, 60000)
        if (corrupter ~= nil) then
            corrupter:SetFaction(14)
            corrupter:SetMaxHealth(832750)
            corrupter:SendCreatureTalk(0, player:GetGUID())
        end
    end
end

function TwilightCorrupter_OnReset(event, creature)
    creature:RemoveEvents()
    killCount = 0
end

function TwilightCorrupter_OnEnterCombat(event, creature, target)
    creature:RegisterEvent(TwilightCorrupter_SoulCorruption, math.random(4000) + 15000, 0)
    creature:RegisterEvent(TwilightCorrupter_CreatureOfNightmare, 45000, 0)
end

function TwilightCorrupter_OnKilledUnit(event, creature, victim)
    if (victim:GetUnitType() == "Player") then
        killCount = killCount + 1
        creature:SendCreatureTalk(2, victim:GetGUID())
        if (killCount == 3) then
            creature:CastSpell(creature, 24312, true)
            killCount = 0
        end
    end
end

function TwilightCorrupter_OnDied(event, creature, killer)
    creature:RemoveEvents()
    corrupter = nil
end

function TwilightCorrupter_SoulCorruption(event, delay, pCall, creature)
    creature:CastSpell(creature:GetVictim(), 25805)
end

function TwilightCorrupter_CreatureOfNightmare(event, delay, pCall, creature)
    creature:CastSpell(creature:GetVictim(), 25806)
end

RegisterServerEvent(24, TwilightCorrupter_OnTrigger)
RegisterCreatureEvent(15625, 1, TwilightCorrupter_OnEnterCombat)
RegisterCreatureEvent(15625, 3, TwilightCorrupter_OnKilledUnit)
RegisterCreatureEvent(15625, 4, TwilightCorrupter_OnDied)
RegisterCreatureEvent(15625, 23, TwilightCorrupter_OnReset)
