-- Projekt: Tablebased multimenu Teleportscript
-- Code: Kenuvis
-- Date: 23.07.2012
-- Convert to Eluna by Rochet2 on 9.6.2015

print("########")
print("Multiteleporter loaded...")

local NPCID = 40478
local teleport = {}

teleport.StandardTeleportIcon = 2
teleport.StandardMenuIcon = 3
teleport.WrongPassText = "Wrong Password!"

teleport.ports = {
    {name = "Location 1", mapid = 1, x = 2, y = 3, z = 4, o = 5},
    {name = "Location 2", mapid = 1, x = 2, y = 3, z = 4, o = 5, pass = "password"},
    {name = "Location 3", mapid = 1, x = 2, y = 3, z = 4, o = 5, icon = 4},
    {name = "SubMenu1",
        {name = "Location 4", mapid = 1, x = 2, y = 3, z = 4, o = 5},
        {name = "Location 5", mapid = 1, x = 2, y = 3, z = 4, o = 5},
        {name = "Location 6", mapid = 1, x = 2, y = 3, z = 4, o = 5},
        {name = "SubSubMenu1",
            {name = "Location 7", mapid = 1, x = 2, y = 3, z = 4, o = 5},
            {name = "Location 8", mapid = 1, x = 2, y = 3, z = 4, o = 5},
            {name = "Location 9", mapid = 1, x = 2, y = 3, z = 4, o = 5},
            {name = "test",
                {name = "Location 7", mapid = 1, x = 2, y = 3, z = 4, o = 5},
                {name = "Location 8", mapid = 1, x = 2, y = 3, z = 4, o = 5},
                {name = "Location 9", mapid = 1, x = 2, y = 3, z = 4, o = 5},
            },
        },
    },
}

------------------------------------------------------------------------------------
-- Nothing change after this! ---------------------------------------------------
------------------------------------------------------------------------------------

local IDcount = 1
teleport.Menu = {}

function teleport.Analyse(list, from)
    for k,v in ipairs(list) do

        v.ID = IDcount
        v.FROM = from
        v.ICON = v.icon or teleport.StandardTeleportIcon
        IDcount = IDcount + 1
        teleport.Menu[v.ID] = v

        if not v.mapid then
            teleport.Menu[v.ID].ICON = v.icon or teleport.StandardMenuIcon
            teleport.Analyse(v, v.ID)
        end
    end
end

print("Export Teleports...")
teleport.Analyse(teleport.ports, 0)
print("Export complete")

table.find = function(_table, _tofind, _index)
    for k,v in pairs(_table) do
        if _index then
            if v[_index] == _tofind then
                return k
            end
        else
            if v == _tofind then
                return k
            end
        end
    end
end

table.findall = function(_table, _tofind, _index)

    local result = {}
    for k,v in pairs(_table) do
        if _index then
            if v[_index] == _tofind then
                table.insert(result, v)
            end
        else
            if v == _tofind then
                table.insert(result, v)
            end
        end
    end
    return result
end

function teleport.BuildMenu(Unit, Player, from)
    local MenuTable = table.findall(teleport.Menu, from, "FROM")

    for _,entry in ipairs(MenuTable) do
        Player:GossipMenuAddItem(entry.ICON, entry.name, 0, entry.ID, entry.pass)
    end
    if from > 0 then
        local GoBack = teleport.Menu[table.find(teleport.Menu, from, "ID")].FROM
        Player:GossipMenuAddItem(7, "Back..", 0, GoBack)
    end
    Player:GossipSendMenu(1, Unit)
end

function teleport.OnTalk(Event, Player, Unit, _, ID, Password)
    if Event == 1 or ID == 0 then
        teleport.BuildMenu(Unit, Player, 0)
    else
        local M = teleport.Menu[table.find(teleport.Menu, ID, "ID")]
        if not M then error("This should not happend") end

        if M.pass then
            if Password ~= M.pass then
                Player:SendNotification(teleport.WrongPassText)
                Player:GossipComplete()
                return
            end
        end

        if M.mapid then
            Player:Teleport(M.mapid, M.x, M.y, M.z, M.o)
            Player:GossipComplete()
            return
        end

        teleport.BuildMenu(Unit, Player, ID)
    end
end

print("Register NPC: "..NPCID)
RegisterCreatureGossipEvent(NPCID, 1, teleport.OnTalk)
RegisterCreatureGossipEvent(NPCID, 2, teleport.OnTalk)

print("Multiteleporter loading complete")
print("########")
