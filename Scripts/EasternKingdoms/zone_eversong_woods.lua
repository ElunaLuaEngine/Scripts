--[[
    EmuDevs <http://emudevs.com/forum.php>
    Eluna Lua Engine <https://github.com/ElunaLuaEngine/Eluna>
    Eluna Scripts <https://github.com/ElunaLuaEngine/Scripts>
    Eluna Wiki <http://wiki.emudevs.com/doku.php?id=eluna>

    -= Script Information =-
    * Zone: Eversong Woods
    * QuestId: 8488 / 8490
    * Script Type: Gossip, CreatureAI and Quest
    * Npc: Apprentice Mirveda <15402>, Infused Crystal <16364>
--]]
local killCount = 0
local playerGUID = 0

-- Apprentice Mirveda
function Mirveda_QuestAccept(event, player, creature, quest)
    if (quest:GetId() == 8488) then
        playerGUID = player:GetGUIDLow()
        creature:RegisterEvent(Mirveda_SpawnCreature, 1200, 1)
        creature:RegisterEvent(Mirveda_QuestComplete, 1000, 0)
    end
end

function Mirveda_SpawnCreature(event, delay, pCall, creature)
    creature:SpawnCreature(15958, 8725, -7153.93, 35.23, 0, 2, 4000)
    creature:SpawnCreature(15656, 8725, -7153.93, 35.23, 0, 2, 4000)
    creature:SpawnCreature(15656, 8725, -7153.93, 35.23, 0, 2, 4000)
end

function Mirveda_QuestComplete(event, delay, pCall, creature)
    if (killCount >= 3 and playerGUID > 0) then
        creature:RemoveEventById(event)
        local player = GetPlayerByGUID(playerGUID)
        if (player ~= nil) then
            player:CompleteQuest(8488)
        end
    end
end

function Mirveda_Reset()
    killCount = 0
    playerGUID = 0
end

function Mirveda_Died(event, creature, killer)
    creature:RemoveEvents()
    if (playerGUID > 0) then
        local player = GetPlayerByGUID(playerGUID)
        if (player ~= nil) then
            player:FailQuest(8488)
        end
    end
end

function Mirveda_JustSummoned(event, creature, summoned)
    summoned:AttackStart(creature)
    summoned:MoveChase(creature)
end

function Mirveda_SummonedDespawn(event, creature, summoned)
    killCount = killCount + 1
end

RegisterCreatureEvent(15402, 4, Mirveda_Died)
RegisterCreatureEvent(15402, 19, Mirveda_JustSummoned)
RegisterCreatureEvent(15402, 20, Mirveda_SummonedDespawn)
RegisterCreatureEvent(15402, 23, Mirveda_Reset)
RegisterCreatureEvent(15402, 31, Mirveda_QuestAccept)

-- Infused Crystal

local Spawns =
{
    { 8270.68, -7188.53, 139.619 },
    { 8284.27, -7187.78, 139.603 },
    { 8297.43, -7193.53, 139.603 },
    { 8303.5, -7201.96, 139.577 },
    { 8273.22, -7241.82, 139.382 },
    { 8254.89, -7222.12, 139.603 },
    { 8278.51, -7242.13, 139.162 },
    { 8267.97, -7239.17, 139.517 }
}

local completed = false
local started = false
local crystalPlayerGUID = 0

function Crystal_Died(event, creature, killer)
    creature:RemoveEvents()
    if (crystalPlayerGUID > 0 and not completed) then
        local player = GetPlayerByGUID(crystalPlayerGUID)
        if (player ~= nil) then
            player:FailQuest(8490)
        end
    end
end

function Crystal_Reset(event, creature)
    crystalPlayerGUID = 0
    started = false
    completed = false
end

function Crystal_MoveLOS(event, creature, unit)
    if (unit:GetUnitType() == "Player" and creature:IsWithinDistInMap(unit, 10) and not started) then
        if (unit:GetQuestStatus(8490) == 3) then
            crystalPlayerGUID = unit:GetGUIDLow()
            creature:RegisterEvent(Crystal_WaveStart, 1000, 1)
            creature:RegisterEvent(Crystal_Completed, 60000, 1)
            started = true
        end
    end
end

function Crystal_WaveStart(event, delay, pCall, creature)
    if (started and not completed) then
        local rand1 = math.random(8)
        local rand2 = math.random(8)
        local rand3 = math.random(8)
        creature:SpawnCreature(17086, Spawns[rand1][1], Spawns[rand1][2], Spawns[rand1][3], 0, 2, 10000)
        creature:SpawnCreature(17086, Spawns[rand2][1], Spawns[rand2][2], Spawns[rand2][3], 0, 2, 10000)
        creature:SpawnCreature(17086, Spawns[rand3][1], Spawns[rand3][2], Spawns[rand3][3], 0, 2, 10000)
        creature:RegisterEvent(Crystal_WaveStart, 30000, 0)
    end
end

function Crystal_Completed(event, delay, pCall, creature)
    if (started) then
        creature:RemoveEvents()
        creature:SendCreatureTalk(0, crystalPlayerGUID)
        completed = true
        if (crystalPlayerGUID > 0) then
            local player = GetPlayerByGUID(crystalPlayerGUID)
            if (player ~= nil) then
                player:CompleteQuest(8490)
            end
        end
        creature:DealDamage(creature, creature:GetHealth())
        creature:RemoveCorpse()
    end
end

function Crystal_Summoned(event, creature, summoned)
    local player = GetPlayerByGUID(crystalPlayerGUID)
    if (player ~= nil) then
        summoned:AttackStart(player)
    end
end

RegisterCreatureEvent(16364, 4, Crystal_Died)
RegisterCreatureEvent(16364, 19, Crystal_Summoned)
RegisterCreatureEvent(16364, 23, Crystal_Reset)
RegisterCreatureEvent(16364, 27, Crystal_MoveLOS)