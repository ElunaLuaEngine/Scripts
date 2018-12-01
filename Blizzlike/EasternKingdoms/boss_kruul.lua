--[[
    EmuDevs <http://emudevs.com/forum.php>
    Eluna Lua Engine <https://github.com/ElunaLuaEngine/Eluna>
    Eluna Scripts <https://github.com/ElunaLuaEngine/Scripts>
    Eluna Wiki <http://wiki.emudevs.com/doku.php?id=eluna>

    -= Script Information =-
    * Script Type: Boss Fight
    * Npc: Kruul <18338>
--]]

local Kruul = {}

function Kruul.EnterCombat(event, creature, target)
    creature:RegisterEvent(Kruul.ShadowVolley, 10000, 0)
    creature:RegisterEvent(Kruul.Cleave, 14000, 0)
    creature:RegisterEvent(Kruul.ThunderClap, 20000, 0)
    creature:RegisterEvent(Kruul.TwistedReflection, 25000, 0)
    creature:RegisterEvent(Kruul.VoidBolt, 30000, 0)
    creature:RegisterEvent(Kruul.Rage, 60000, 0)
    creature:RegisterEvent(Kruul.SpawnHounds, 8000, 1)
end

function Kruul.KilledTarget(event, creature, victim)
    creature:CastSpell(creature, 21054)
end

function Kruul.LeaveCombat(event, creature)
    creature:RemoveEvents()
end

function Kruul.Died(event, creature, killer)
    creature:RemoveEvents()
end

function Kruul.ShadowVolley(event, delay, pCall, creature)
    creature:CastSpell(creature:GetVictim(), 21341)
end

function Kruul.Cleave(event, delay, pCall, creature)
    creature:CastSpell(creature:GetVictim(), 20677)
end

function Kruul.ThunderClap(event, delay, pCall, creature)
    creature:CastSpell(creature:GetVictim(), 23931)
end

function Kruul.TwistedReflection(event, delay, pCall, creature)
    creature:CastSpell(creature:GetVictim(), 21063)
end

function Kruul.VoidBolt(event, delay, pCall, creature)
    creature:CastSpell(creature:GetVictim(), 21066)
end

function Kruul.Rage(event, delay, pCall, creature)
    creature:CastSpell(creature, 21340)
end

function Kruul.SummonHounds(creature, target)
    local x, y, z = creature:GetRelativePoint(math.random()*9, math.random()*math.pi*2)
    local hound = creature:SpawnCreature(19207, x, y, z, 0, 2, 300000)
    if (hound) then
        hound:AttackStart(target)
    end
end

function Kruul.SpawnHounds(event, delay, pCall, creature)
    Kruul.SummonHounds(creature, creature:GetVictim())
    Kruul.SummonHounds(creature, creature:GetVictim())
    Kruul.SummonHounds(creature, creature:GetVictim())
    creature:RegisterEvent(Kruul.SpawnHounds, 45000, 1)
end

RegisterCreatureEvent(18338, 1, Kruul.EnterCombat)
RegisterCreatureEvent(18338, 2, Kruul.LeaveCombat)
RegisterCreatureEvent(18338, 3, Kruul.KilledTarget)
RegisterCreatureEvent(18338, 4, Kruul.Died)
