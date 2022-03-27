--[[
    EmuDevs <http://emudevs.com/forum.php>
    Eluna Lua Engine <https://github.com/ElunaLuaEngine/Eluna>
    Eluna Scripts <https://github.com/ElunaLuaEngine/Scripts>
    Eluna Wiki <http://wiki.emudevs.com/doku.php?id=eluna>

    -= Script Information =-
    * Zone: Eastern Plaugelands
    * QuestId: 5742 / 6164
    * Script Type: Gossip, CreatureAI and Quest
    * Npc: Ghoul Flayer <8530, 8531, 8532>, Augustus the Touched <12384>, Darrowshire Spirit <11064> 
    and Tirion Fordring <1855>
--]]

-- Ghoul Flayer
function Flayer_Died(event, creature, killer)
    if (killer:GetUnitType() == "Player") then
        creature:SpawnCreature(11064, 0, 0, 0, 0, 3, 60000)
    end
end

RegisterCreatureEvent(8530, 4, Flayer_Died)
RegisterCreatureEvent(8531, 4, Flayer_Died)
RegisterCreatureEvent(8532, 4, Flayer_Died)

-- Augustus the Touched
function Augustus_GossipHello(event, player, creature)
    if (creature:IsQuestGiver()) then
        player:GossipAddQuests(creature)
    end

    if (creature:IsVendor() and player:GetQuestRewardStatus(6164)) then
        player:GossipMenuAddItem(0, "I'd like to browse your goods.", 0, 1)
    end
    player:GossipSendMenu(player:GetGossipTextId(creature), creature)
end

function Augustus_GossipSelect(event, player, creature, sender, intid, code)
    player:GossipClearMenu()
    if (intid == 1) then
        player:SendListInventory(creature)
    end
end

RegisterCreatureGossipEvent(12384, 1, Augustus_GossipHello)
RegisterCreatureGossipEvent(12384, 2, Augustus_GossipSelect)

-- Darrowshire Spirit
function Darrowshire_GossipHello(event, player, creature)
    player:GossipSendMenu(3873, creature)
    player:TalkedToCreature(creature:GetEntry(), creature)
    creature:SetFlag(59, 33554432)
end

function Darrowshire_Reset(event, creature)
    creature:CastSpell(creature, 17321)
    creature:RemoveFlag(59, 33554432)
end

RegisterCreatureGossipEvent(11064, 1, Darrowshire_GossipHello)
RegisterCreatureEvent(11064, 23, Darrowshire_Reset)

-- Tirion Fordring
function Tirion_GossipHello(event, player, creature)
    if (creature:IsQuestGiver()) then
        player:GossipAddQuests(creature)
    end

    if (player:GetQuestStatus(5742) == 3 and player:GetStandState() == 1) then
        player:GossipMenuAddItem(0, "I am ready to hear your tale, Tirion.", 0, 1)
    end
    player:GossipSendMenu(player:GetGossipTextId(creature), creature)
end

function Tirion_GossipSelect(event, player, creature, sender, intid, code)
    player:GossipClearMenu()
    if (intid == 1) then
        player:GossipMenuAddItem(0, "Thank you, Tirion.  What of your identity?", 0, 2)
        player:GossipSendMenu(4493, creature)
    elseif (intid == 2) then
        player:GossipMenuAddItem(0, "That is terrible.", 0, 3)
        player:GossipSendMenu(4494, creature)
    elseif (intid == 3) then
        player:GossipMenuAddItem(0, "I will, Tirion.", 0, 4)
        player:GossipSendMenu(4495, creature)
    elseif (intid == 4) then
        player:GossipComplete()
        player:AreaExploredOrEventHappens(5742)
    end
end

RegisterCreatureGossipEvent(1855, 1, Tirion_GossipHello)
RegisterCreatureGossipEvent(1855, 2, Tirion_GossipSelect)
