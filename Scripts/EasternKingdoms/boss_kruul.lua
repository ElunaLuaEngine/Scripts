--[[
    EmuDevs <http://emudevs.com/forum.php>
    Eluna Lua Engine <https://github.com/ElunaLuaEngine/Eluna>
    Eluna Scripts <https://github.com/ElunaLuaEngine/Scripts>
    Eluna Wiki <http://wiki.emudevs.com/doku.php?id=eluna>

    -= Script Information =-
    * Script Type: Boss Fight
    * Npc: Kruul <18338>
--]]

function Kruul_EnterCombat(event, creature, target)
    creature:RegisterEvent(Kruul_ShadowVolley, 10000, 0)
    creature:RegisterEvent(Kruul_Cleave, 14000, 0)
    creature:RegisterEvent(Kruul_ThunderClap, 20000, 0)
    creature:RegisterEvent(Kruul_TwistedReflection, 25000, 0)
    creature:RegisterEvent(Kruul_VoidBolt, 30000, 0)
    creature:RegisterEvent(Kruul_Rage, 60000, 0)
    creature:RegisterEvent(Kruul_SpawnHounds, 8000, 1)
end

function Kruul_KilledTarget(event, creature, victim)
    creature:CastSpell(creature, 21054)
end

function Kruul_LeaveCombat(event, creature)
    creature:RemoveEvents()
end

function Kruul_Died(event, creature, killer)
    creature:RemoveEvents()
end

function Kruul_ShadowVolley(event, delay, pCall, creature)
    creature:CastSpell(creature:GetVictim(), 21341)
end

function Kruul_Cleave(event, delay, pCall, creature)
    creature:CastSpell(creature:GetVictim(), 20677)
end

function Kruul_ThunderClap(event, delay, pCall, creature)
    creature:CastSpell(creature:GetVictim(), 23931)
end

function Kruul_TwistedReflection(event, delay, pCall, creature)
    creature:CastSpell(creature:GetVictim(), 21063)
end

function Kruul_VoidBolt(event, delay, pCall, creature)
    creature:CastSpell(creature:GetVictim(), 21066)
end

function Kruul_Rage(event, delay, pCall, creature)
    creature:CastSpell(creature, 21340)
end

function SummonHounds(creature, target)
    local hound = creature:SpawnCreature(19207, creature:GetX() - math.random(9), creature:GetY() - math.random(9), creature:GetZ(), 0, 2, 300000)
    if (hound ~= nil) then
        hound:AttackStart(target)
    end
end

function Kruul_SpawnHounds(event, delay, pCall, creature)
    SummonHounds(creature, creature:GetVictim())
    SummonHounds(creature, creature:GetVictim())
    SummonHounds(creature, creature:GetVictim())
    creature:RegisterEvent(Kruul_SpawnHounds, 45000, 0)
end

RegisterCreatureEvent(18338, 1, Kruul_EnterCombat)
RegisterCreatureEvent(18338, 2, Kruul_LeaveCombat)
RegisterCreatureEvent(18338, 3, Kruul_KilledTarget)
RegisterCreatureEvent(18338, 4, Kruul_Died)