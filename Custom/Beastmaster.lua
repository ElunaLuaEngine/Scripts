local Beastmaster = {
    entry = 823, -- Beastmaster entry.
    maxObj = 13, -- 13 = Max amt. of menu objects.
}

function Beastmaster.OnHello(event, player, unit)
    -- Check whether the player is actually a hunter or not.
    if(player:GetClass() == 3) then
        -- Check if player is able to tame pets.
        if(player:HasSpell(1515)) then
            Beastmaster.GenerateMenu(1, player, unit);
        else
            player:SendBroadcastMessage("[Eluna Beastmaster]: You are not able to tame pets.")
        end
    else
        player:SendBroadcastMessage("[Eluna Beastmaster]: Only Hunters can use this service!")
    end
end

function Beastmaster.OnSelect(event, player, unit, sender, intid, code)
    -- Intid 0 is used solely for menu pages and 1 for pet selection.
    if(intid == 0) then
        Beastmaster.GenerateMenu(sender, player, unit);
    elseif(intid == 1) then
        -- Spawn a temporary, friendly version of the selected creature and force tame it.
        local pet = PerformIngameSpawn(1, sender, unit:GetMapId(), unit:GetInstanceId(), unit:GetX(), unit:GetY(), unit:GetZ(), unit:GetO(), false, 5000)
        pet:SetFaction(35)
        player:CastSpell(pet, 2650, true)
        player:GossipComplete()
    end
end

function Beastmaster.GenerateMenu(id, player, unit)
    local low = ((Beastmaster.maxObj*id)-Beastmaster.maxObj+1)
    local high = Beastmaster.maxObj*id
    
    -- Retrieve the current page sets' gossip option information.
    for i = low, high do
        local t = Beastmaster["Cache"][i]
        
        if t then -- show "i" if only exists in the table
            -- Do not list gossip options with creatures above the players level.
            if(player:GetLevel() >= t["level"]) then
                player:GossipMenuAddItem(2, "Level: "..t["level"].." - "..t["name"], t["entry"], 1)
            end
        end
    end
    
    -- If the menu is not the first menu, show Previous button.
    if(id ~= 1) then
        player:GossipMenuAddItem(4, "<-- Previous", id-1, 0)
    end
    
    -- If the next menu has available objects and object is within player level, show Next button.
    if(Beastmaster["Cache"][high+1]) and (player:GetLevel() >= Beastmaster["Cache"][high+1]["level"]) then
        player:GossipMenuAddItem(4, "Next -->", id+1, 0)
    end
    
    player:GossipSendMenu(1, unit)
end

function Beastmaster.LoadCache()
    Beastmaster["Cache"] = {}
    local i = 1;
    local Query;
    
    if(GetCoreName() == "MaNGOS") then
        Query = WorldDBQuery("SELECT Entry, Name, MaxLevel FROM creature_template WHERE CreatureType=1 AND CreatureTypeFlags&1 <> 0 AND Family!=0 ORDER BY MaxLevel ASC;")
    elseif(GetCoreName() == "TrinityCore") then
        Query = WorldDBQuery("SELECT Entry, Name, MaxLevel FROM creature_template WHERE Type=1 AND Type_Flags&1 <> 0 AND Family!=0 ORDER BY MaxLevel ASC;")
    end
    
    if(Query) then
        repeat
            Beastmaster["Cache"][i] = {
                entry = Query:GetUInt32(0),
                name = Query:GetString(1),
                level = Query:GetUInt32(2)
            };
            i = i+1
        until not Query:NextRow()
        print("[Eluna Beastmaster]: Cache initialized. Loaded "..Query:GetRowCount().." tameable beasts.")
    else
        print("[Eluna Beastmaster]: Cache initialized. No results found.")
    end
end

Beastmaster.LoadCache()
RegisterCreatureGossipEvent(Beastmaster.entry, 1, Beastmaster.OnHello)
RegisterCreatureGossipEvent(Beastmaster.entry, 2, Beastmaster.OnSelect)
