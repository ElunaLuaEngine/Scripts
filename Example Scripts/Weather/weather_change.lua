function Item_GossipHello(event, player, item)
    player:GossipMenuAddItem(0, "Test Weather", 0, 1)
	player:GossipMenuAddItem(0, "Nevermind..", 0, 2)
	player:GossipSendMenu(1, item)
end

function Item_GossipSelect(event, player, item, sender, intid, code)
    player:GossipClearMenu()	
	if (intid == 1) then
	    local weather = FindWeather(player:GetZoneId())		
		if (weather == nil) then
		    weather = AddWeather(player:GetZoneId())
		end

		print (weather:GetZoneId())
		print (weather:GetScriptId())
		
		weather:SetWeather(2, 3)
		player:GossipComplete()
	elseif (intid == 2) then
	    player:GossipComplete()
	end
end

RegisterItemGossipEvent(60000, 1, Item_GossipHello)
RegisterItemGossipEvent(60000, 2, Item_GossipSelect)