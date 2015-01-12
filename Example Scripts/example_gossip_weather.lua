local NpcId = 123

local function OnGossipHello(event, player, unit)
    player:GossipMenuAddItem(0, "Test Weather", 1, 1)
    player:GossipMenuAddItem(0, "Nevermind..", 1, 2)
    player:GossipSendMenu(1, unit)
end

local function OnGossipSelect(event, plr, unit, sender, action, code)
    if (action == 1) then
        plr:GetMap():SetWeather(plr:GetZoneId(), math.random(0, 3), 1) -- random weather
        plr:GossipComplete()
    elseif (action == 2) then
        plr:GossipComplete()
    end
end

RegisterCreatureGossipEvent(NpcId, 1, OnHello)
RegisterCreatureGossipEvent(NpcId, 2, OnSelect)
