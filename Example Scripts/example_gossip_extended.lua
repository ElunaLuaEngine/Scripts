local npcId = 123

local function GossipHello(event, plr, unit)
    plr:GossipMenuAddItem(0, "I would like to place a bounty", 0, 1, true, "Who would you like to place a bounty on?", 10000) -- icon, text, sender, intid, use code (true/false), prompt text, how much gold (amount)
    plr:GossipMenuAddItem(0, "Nevermind..", 0, 2)
    plr:GossipSendMenu(1, unit)
end

local function GossipSelect(event, player, creature, sender, intid, code)
    if (intid == 1) then -- Deal with code / bounty stuff
        local victim = GetPlayerByName(code)
        if (victim ~= nil) then
            player:SendBroadcastMessage("NAME:" ..victim:GetName().."!")
            player:ModifyMoney(-10000) -- Remove the gold amount
        end
    end
end

RegisterCreatureGossipEvent(npcId, 1, GossipHello)
RegisterCreatureGossipEvent(npcId, 2, GossipSelect)