-- Fix the Scarlet balista bug

SBalista_NPC = 29104
SBalista_Spell = 53117

function SBalista_UnderAttack(event, creature, player)
	creature:AttackStart(player)
end
RegisterCreatureEvent(SBalista_NPC , 9, SBalista_UnderAttack)

function SBalista_EnterCombat(event, creature, target)
	creature:RegisterEvent(SBalista_Cast, 2000, 0)
end
function SBalista_KilledTarget(event, creature, victim)
    creature:RemoveEvents()
end
function SBalista_LeaveCombat(event, creature)
    creature:RemoveEvents()
end
function SBalista_Died(event, creature, killer)
    creature:RemoveEvents()
end
function SBalista_Cast(event, delay, pCall, creature)
	creature:CastSpell(creature:GetVictim(), SBalista_Spell)
end
RegisterCreatureEvent(SBalista_NPC, 1, SBalista_EnterCombat)
RegisterCreatureEvent(SBalista_NPC, 2, SBalista_LeaveCombat)
RegisterCreatureEvent(SBalista_NPC, 3, SBalista_KilledTarget)
RegisterCreatureEvent(SBalista_NPC, 4, SBalista_Died)
