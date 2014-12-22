local GobId = 123
local NpcId = 123
local ItemId = 123 -- Item needs to have spell on use
local MenuId = 123 -- Unique ID to recognice player gossip menu among others

local function OnGossipHello(event, player, object)
    player:GossipClearMenu() -- required for player gossip
    player:GossipMenuAddItem(0, "Open submenu", 1, 1)
    player:GossipMenuAddItem(0, "Test popup box", 1, 2, false, "Test popup")
    player:GossipMenuAddItem(0, "Test codebox", 1, 3, true, nil)
    player:GossipMenuAddItem(0, "Test money requirement", 1, 4, nil, nil, 50000)
    player:GossipSendMenu(1, object, MenuId) -- MenuId required for player gossip
end

local function OnGossipSelect(event, player, object, sender, intid, code, menuid)
    if (intid == 1) then
        player:GossipMenuAddItem(0, "Close gossip", 1, 5)
        player:GossipMenuAddItem(0, "Back ..", 1, 6)
        player:GossipSendMenu(1, object, MenuId) -- MenuId required for player gossip
    elseif (intid == 2) then
        OnGossipHello(event, player, object)
    elseif (intid == 3) then
        player:SendBroadcastMessage(code)
        OnGossipHello(event, player, object)
    elseif (intid == 4) then
        if (player:GetCoinage() >= 50000) then
            player:ModifyMoney(-50000)
        end
        OnGossipHello(event, player, object)
    elseif (intid == 5) then
        player:GossipComplete()
    elseif (intid == 6) then
        OnGossipHello(event, player, object)
    end
end

local function OnPlayerCommand(event, player, command)
    if (command == "test gossip") then
        OnGossipHello(event, player, player)
        return false
    end
end

RegisterCreatureGossipEvent(NpcId, 1, OnGossipHello)
RegisterCreatureGossipEvent(NpcId, 2, OnGossipSelect)

RegisterGameObjectGossipEvent(GobId, 1, OnGossipHello)
RegisterGameObjectGossipEvent(GobId, 2, OnGossipSelect)

RegisterItemGossipEvent(ItemId, 1, OnGossipHello)
RegisterItemGossipEvent(ItemId, 2, OnGossipSelect)

RegisterPlayerEvent(42, OnPlayerCommand)
RegisterPlayerGossipEvent(MenuId, 2, OnGossipSelect)
