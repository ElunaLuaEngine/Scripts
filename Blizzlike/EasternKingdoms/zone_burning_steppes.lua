--[[
    EmuDevs <http://emudevs.com/forum.php>
    Eluna Lua Engine <https://github.com/ElunaLuaEngine/Eluna>
    Eluna Scripts <https://github.com/ElunaLuaEngine/Scripts>
    Eluna Wiki <http://wiki.emudevs.com/doku.php?id=eluna>

    -= Script Information =-
    * Zone: Burning Steppes
    * QuestId: 4224 / 4866
    * Script Type: Quest Gossip
    * Npc: Ragged John <9563>
--]]

local Gossip =
{
    { 1, 2, "So what did you do?", 2714 },
    { 2, 3,  "Start making sense, dwarf. I don't want to have anything to do with your cracker, your pappy, or any sort of 'discreditin'.", 2715 },
    { 3, 4,  "Ironfoe?", 2716 },
    { 4, 5,  "Interesting... continue John.", 2717 },
    { 5, 6,  "So that's how Windsor died...", 2718 },
    { 6, 7,  "So how did he die?", 2719 },
    { 7, 8,  "Ok so where the hell is he? Wait a minute! Are you drunk?", 2720 },
    { 8, 9,  "WHY is he in Blackrock Depths?", 2721 },
    { 9, 10,  "300? So the Dark Irons killed him and dragged him into the Depths?", 2722 },
    { 10, 11,  "Ahh... Ironfoe", 2723 },
    { 11, 12,  "Thanks, Ragged John. Your story was very uplifting and informative", 2725 }
}

function RaggedJohn_OnGossipHello(event, player, creature)
    if (creature:IsQuestGiver()) then
        player:GossipAddQuests(creature)
    end

    if (player:GetQuestStatus(4224) == 3) then
        player:GossipMenuAddItem(0, "Official buisness, John. I need some information about Marsha Windsor. Tell me about the last time you saw him.", 0, 1)
    end
    player:GossipSendMenu(2713, creature)
end

function RaggedJohn_OnGossipSelect(event, player, creature, sender, intid, code)
    player:GossipClearMenu()
    if (intid == 12) then
        player:GossipComplete()
        player:AreaExploredOrEventHappens(4224)
        return
    end

    if (intid == Gossip[intid][1]) then
        player:GossipMenuAddItem(0, Gossip[intid][3], 0, Gossip[intid][2])
        player:GossipSendMenu(Gossip[intid][4], creature)
    end
end

function RaggedJohn_MoveInLOS(event, creature, unit)
    if (unit:HasAura(16468)) then
        if (unit:GetUnitType() == "Player" and creature:IsWithinDistInMap(unit, 15) and unit:IsInAccessiblePlaceFor(creature)) then
            creature:CastSpell(unit, 16472)
            unit:AreaExploredOrEventHappens(4866)
        end
    end
end

RegisterCreatureGossipEvent(9563, 1, RaggedJohn_OnGossipHello)
RegisterCreatureGossipEvent(9563, 2, RaggedJohn_OnGossipSelect)
RegisterCreatureEvent(9563, 27, RaggedJohn_MoveInLOS)