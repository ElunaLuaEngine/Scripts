local npcId = 90000

function OnEnterCombat(event, creature, target)
    creature:CastSpell(target, 20000, true)
end

function OnLeaveCombat(event, creature)
    creature:SendUnitYell("Haha, I'm out of combat!", 0)
end

function OnDied(event, creature, killer)
    killer:SendBroadcastMessage("You killed " ..creature:GetName().."!")
end

RegisterCreatureEvent(npcId, 1, OnEnterCombat)
RegisterCreatureEvent(npcId, 2, OnLeaveCombat)
RegisterCreatureEvent(npcId, 4, OnDied)