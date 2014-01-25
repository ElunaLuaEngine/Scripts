--[[	How to add new locations!
		
		Example:
		
		The first line will be the main menu ID (Here [1], 
		increment this for each main menu option!),
		the main menu gossip title (Here "Horde Cities"),
		as well as which faction can use the said menu (Here 1 (Horde)). 
		0 = Alliance, 1 = Horde, 2 = Both
		
		The second line is the name of the main menu's sub menus, 
		separated by name (Here "Orgrimmar") and teleport coordinates
		using Map, X, Y, Z, O (Here 1, 1503, -4415.5, 22, 0)
		
		[1] = { "Horde Cities", 1,	--  
			{"Orgrimmar", 1, 1503, -4415.5, 22, 0},
		},
		
		You can copy paste the above into the script and change the values as informed.
]]


local UnitEntry = 1

local T = {
	[1] = { "Horde Cities", 1, -- This will be the main menu title, as well as which faction can use the said menu. 0 = Alliance, 1 = Horde, 2 = Both
		{"Orgrimmar", 1, 1503, -4415.5, 22, 0},
		{"Undercity", 0, 1831, 238.5, 61.6, 0},
		{"Thunderbluff", 1, -1278, 122, 132, 0},
		{"Silvermoon", 530, 9484, -7294, 15, 0},
	},
	[2] = { "Alliance Cities", 0,
		{"Stormwind", 0, -8905, 560, 94, 0.62},
		{"Ironforge", 0, -4795, -1117, 499, 0},
		{"Darnassus", 1, 9952, 2280.5, 1342, 1.6},
		{"The Exodar", 530, -3863, -11736, -106, 2},
	},
	[3] = { "Outlands Locations", 2,
		{"Blade's Edge Mountains", 530, 1481, 6829, 107, 6},
		{"Hellfire Peninsula", 530, -249, 947, 85, 2},
		{"Nagrand", 530, -1769, 7150, -9, 2},
		{"Netherstorm", 530, 3043, 3645, 143, 2},
		{"Shadowmoon Valley", 530, -3034, 2937, 87, 5},
		{"Terokkar Forest", 530, -1942, 4689, -2, 5},
		{"Zangarmarsh", 530, -217, 5488, 23, 2},
		{"Shattrath", 530, -1822, 5417, 1, 3},
	},
	[4] = { "Northrend Locations", 2,
		{"Borean Tundra", 571, 3230, 5279, 47, 3},
		{"Crystalsong Forest", 571, 5732, 1016, 175, 3.6},
		{"Dragonblight", 571, 3547, 274, 46, 1.6},
		{"Grizzly Hills", 571, 3759, -2672, 177, 3},
		{"Howling Fjord", 571, 772, -2905, 7, 5},
		{"Icecrown Glaicer", 571, 8517, 676, 559, 4.7},
		{"Sholazar Basin", 571, 5571, 5739, -75, 2},
		{"Storm Peaks", 571, 6121, -1025, 409, 4.7},
		{"Wintergrasp", 571, 5135, 2840, 408, 3},
		{"Zul'Drak", 571, 5761, -3547, 387, 5},
		{"Dalaran", 571, 5826, 470, 659, 1.4},
	},
	[5] = { "PvP Locations", 2,
		{"Gurubashi Arena", 0, -13229, 226, 33, 1},
		{"Dire Maul Arena", 1, -3669, 1094, 160, 3},
		{"Nagrand Arena", 530, -1983, 6562, 12, 2},
		{"Blade's Edge Arena", 530, 2910, 5976, 2, 4},
	},
};

--[[ CODE STUFFS! DO NOT EDIT BELOW ]]--
--[[ UNLESS YOU KNOW WHAT YOU'RE DOING! ]]--

function Teleporter_Gossip(event, player, unit)
	if (#T <= 10) then
		for i, v in ipairs(T) do
			if(v[2] == 2 or v[2] == player:GetTeam()) then
				player:GossipMenuAddItem(0, v[1], 0, i)
			end
		end
		player:GossipSendMenu(1, unit)
	else
		print("This teleporter only supports 10 different menus.")
	end
end	

function Teleporter_Event(event, player, unit, sender, intid, code)
	if(intid == 0) then
		Teleporter_Gossip(event, player, unit)
	elseif(intid <= 10) then
		for i, v in ipairs(T[intid]) do
			if (i > 2) then
				player:GossipMenuAddItem(0, v[1], 0, intid..i)
			end
		end
		player:GossipMenuAddItem(0, "Back", 0, 0)
		player:GossipSendMenu(1, unit)
	elseif(intid > 10) then
		for i = 1, #T do
			for j, v in ipairs(T[i]) do
				if(intid == tonumber(i..j)) then
					player:GossipComplete()
					player:Teleport(v[2], v[3], v[4], v[5], v[6])
				end
			end
		end
	end
end

RegisterCreatureGossipEvent(UnitEntry, 1, Teleporter_Gossip)
RegisterCreatureGossipEvent(UnitEntry, 2, Teleporter_Event)