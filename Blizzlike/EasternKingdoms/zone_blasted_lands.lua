--[[
    EmuDevs <http://emudevs.com/forum.php>
    Eluna Lua Engine <https://github.com/ElunaLuaEngine/Eluna>
    Eluna Scripts <https://github.com/ElunaLuaEngine/Scripts>
    Eluna Wiki <http://wiki.emudevs.com/doku.php?id=eluna>

    -= Script Information =-
    * Zone: Blasted Lands
    * QuestId: 3628 <GetQuestStatus>
    * Script Type: Quest Gossip
    * Npc: Deathly Usher <8816>
--]]

function DeathlyUsher_OnGossipHello(event, player, creature)
    if (player:GetQuestStatus(3628) == 3 and player:HasItem(10757)) then
        player:GossipMenuAddItem(0, "I wish to visit the Rise of the Defiler.", 0, 1)
    end
    player:GossipSendMenu(player:GetGossipTextId(creature), creature)
end

function DeathlyUsher_OnGossipSelect(event, player, creature, sender, intid, code)
    player:GossipClearMenu()
    if (intid == 1) then
        player:GossipComplete()
        creature:CastSpell(player, 12885, true)
    end
end

RegisterCreatureGossipEvent(8816, 1, DeathlyUsher_OnGossipHello)
RegisterCreatureGossipEvent(8816, 2, DeathlyUsher_OnGossipSelect)