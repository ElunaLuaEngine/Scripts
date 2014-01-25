local NpcId = 123

local function OnGossipHello(event, player, unit)
    player:GossipMenuAddItem(0, "Test Weather", 1, 1)
    player:GossipMenuAddItem(0, "Nevermind..", 1, 2)
    player:GossipSendMenu(1, unit)
end

local function OnGossipSelect(event, plr, unit, sender, action, code)
    if (action == 1) then
        local weather = FindWeather(plr:GetZoneId()) or AddWeather(plr:GetZoneId())
        if (not weather) then
            print("The zone has no weather")
            return
        end

        print (weather:GetZoneId())
        print (weather:GetScriptId())

        weather:SetWeather(2, 3)
        plr:GossipComplete()
    elseif (action == 2) then
        plr:GossipComplete()
    end
end

RegisterCreatureGossipEvent(NpcId, 1, OnHello)
RegisterCreatureGossipEvent(NpcId, 2, OnSelect)