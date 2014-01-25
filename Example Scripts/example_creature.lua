local npcId = 123

local function CastFrostbolt(eventId, dely, calls, creature)
    creature:CastSpell(creature:GetVictim(), 11, true)
end

local function OnEnterCombat(event, creature, target)
    creature:RegisterEvent(CastFrostbolt, 5000, 0)
end

local function OnLeaveCombat(event, creature)
    creature:SendUnitYell("Haha, I'm out of combat!", 0)
    creature:RemoveEvents()
end

local function OnDied(event, creature, killer)
    if(killer:GetObjectType() == "Player") then
        killer:SendBroadcastMessage("You killed " ..creature:GetName().."!")
    end
    creature:RemoveEvents()
end

RegisterCreatureEvent(npcId, 1, OnEnterCombat)
RegisterCreatureEvent(npcId, 2, OnLeaveCombat)
RegisterCreatureEvent(npcId, 4, OnDied)