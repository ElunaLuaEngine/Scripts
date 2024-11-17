--[[
4.3
Transmogrification for Classic & TBC & WoTLK - Gossip Menu
By Rochet2

Eluna version

TODO:
Make DB saving even better (Deleting)? What about coding?

Fix the cost formula

TODO in the distant future:

Are the qualities right? Blizzard might have changed the quality requirements.
What can and cant be used as source or target..?

Cant transmogrify:
rediculus items -- Foereaper: would be fun to stab people with a fish
-- Cant think of any good way to handle this easily

Cataclysm:
Test on cata : implement UI xD?
Item link icon to Are You sure text
]]

local NPC_Entry = 60000

local RequireGold = 1
local GoldModifier = 1.0
local GoldCost = 100000

local RequireToken = false
local TokenEntry = 49426
local TokenAmount = 1

local AllowMixedArmorTypes = false
local AllowMixedWeaponTypes = false

local Qualities =
{
    [0]  = false, -- AllowPoor
    [1]  = false, -- AllowCommon
    [2]  = true , -- AllowUncommon
    [3]  = true , -- AllowRare
    [4]  = true , -- AllowEpic
    [5]  = false, -- AllowLegendary
    [6]  = false, -- AllowArtifact
    [7]  = true , -- AllowHeirloom
}

local EQUIPMENT_SLOT_START        = 0
local EQUIPMENT_SLOT_HEAD         = 0
local EQUIPMENT_SLOT_NECK         = 1
local EQUIPMENT_SLOT_SHOULDERS    = 2
local EQUIPMENT_SLOT_BODY         = 3
local EQUIPMENT_SLOT_CHEST        = 4
local EQUIPMENT_SLOT_WAIST        = 5
local EQUIPMENT_SLOT_LEGS         = 6
local EQUIPMENT_SLOT_FEET         = 7
local EQUIPMENT_SLOT_WRISTS       = 8
local EQUIPMENT_SLOT_HANDS        = 9
local EQUIPMENT_SLOT_FINGER1      = 10
local EQUIPMENT_SLOT_FINGER2      = 11
local EQUIPMENT_SLOT_TRINKET1     = 12
local EQUIPMENT_SLOT_TRINKET2     = 13
local EQUIPMENT_SLOT_BACK         = 14
local EQUIPMENT_SLOT_MAINHAND     = 15
local EQUIPMENT_SLOT_OFFHAND      = 16
local EQUIPMENT_SLOT_RANGED       = 17
local EQUIPMENT_SLOT_TABARD       = 18
local EQUIPMENT_SLOT_END          = 19

local INVENTORY_SLOT_BAG_START    = 19
local INVENTORY_SLOT_BAG_END      = 23

local INVENTORY_SLOT_ITEM_START   = 23
local INVENTORY_SLOT_ITEM_END     = 39

local INVTYPE_CHEST               = 5
local INVTYPE_WEAPON              = 13
local INVTYPE_ROBE                = 20
local INVTYPE_WEAPONMAINHAND      = 21
local INVTYPE_WEAPONOFFHAND       = 22

local ITEM_CLASS_WEAPON           = 2
local ITEM_CLASS_ARMOR            = 4

local ITEM_SUBCLASS_WEAPON_BOW          = 2
local ITEM_SUBCLASS_WEAPON_GUN          = 3
local ITEM_SUBCLASS_WEAPON_CROSSBOW     = 18
local ITEM_SUBCLASS_WEAPON_FISHING_POLE = 20

local EXPANSION_WOTLK = 2
local EXPANSION_TBC = 1
local PLAYER_VISIBLE_ITEM_1_ENTRYID
local ITEM_SLOT_MULTIPLIER
if GetCoreExpansion() < EXPANSION_TBC then
    PLAYER_VISIBLE_ITEM_1_ENTRYID = 260
    ITEM_SLOT_MULTIPLIER = 12
elseif GetCoreExpansion() < EXPANSION_WOTLK then
    PLAYER_VISIBLE_ITEM_1_ENTRYID = 346
    ITEM_SLOT_MULTIPLIER = 16
else
    PLAYER_VISIBLE_ITEM_1_ENTRYID = 283
    ITEM_SLOT_MULTIPLIER = 2
end

local INVENTORY_SLOT_BAG_0        = 255

local SlotNames = {
    [EQUIPMENT_SLOT_HEAD      ] = {"Head",         nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_SHOULDERS ] = {"Shoulders",    nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_BODY      ] = {"Shirt",        nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_CHEST     ] = {"Chest",        nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_WAIST     ] = {"Waist",        nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_LEGS      ] = {"Legs",         nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_FEET      ] = {"Feet",         nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_WRISTS    ] = {"Wrists",       nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_HANDS     ] = {"Hands",        nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_BACK      ] = {"Back",         nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_MAINHAND  ] = {"Main hand",    nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_OFFHAND   ] = {"Off hand",     nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_RANGED    ] = {"Ranged",       nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_TABARD    ] = {"Tabard",       nil, nil, nil, nil, nil, nil, nil, nil},
}

local Locales = {
    ["UPDATE_MENU_OPTION"]                  = {"Update menu", nil, nil, nil, nil, nil, nil, nil, nil},
    ["REMOVE_ALL_TRANSMOGS_OPTION"]         = {"Remove all transmogrifications", nil, nil, nil, nil, nil, nil, nil, nil},
    ["GO_BACK_OPTION"]                      = {"Back..", nil, nil, nil, nil, nil, nil, nil, nil},
    ["REMOVE_TRANSMOG_SLOT_OPTION"]         = {"Remove transmogrification", nil, nil, nil, nil, nil, nil, nil, nil},
    ["CONFIRM_REMOVE_EQUIPPED_TRANSMOGS"]   = {"Remove transmogrifications from all equipped items?", nil, nil, nil, nil, nil, nil, nil, nil},
    ["CONFIRM_REMOVE_TRANSMOG_SLOT"]        = {"Remove transmogrification from %s?", nil, nil, nil, nil, nil, nil, nil, nil},
    ["TRANSMOGGED_SUCCESS"]                 = {"%s transmogrified", nil, nil, nil, nil, nil, nil, nil, nil},
    ["ALL_TRANSMOGS_REMOVED_SUCCESS"]       = {"Transmogrifications removed from equipped items", nil, nil, nil, nil, nil, nil, nil, nil},
    ["SLOT_TRANSMOGS_REMOVED_SUCCESS"]      = {"%s transmogrification removed", nil, nil, nil, nil, nil, nil, nil, nil},
    ["TRANSMOG_BIND_WARNING"]               = {"Using this item for transmogrify will bind it to you and make it non-refundable and non-tradeable.\nDo you wish to continue?", nil, nil, nil, nil, nil, nil, nil, nil},
    ["NO_TRANSMOGGED_ITEMS_FOUND"]          = {"You have no transmogrified items equipped", nil, nil, nil, nil, nil, nil, nil, nil},
    ["NO_TRANSMOG_IN_SLOT"]                 = {"No transmogrification on %s slot", nil, nil, nil, nil, nil, nil, nil, nil},
    ["INVALID_ITEMS_ERROR"]                 = {"Selected items are not suitable", nil, nil, nil, nil, nil, nil, nil, nil},
    ["NON_EXISTENT_ITEM_ERROR"]             = {"Selected item does not exist", nil, nil, nil, nil, nil, nil, nil, nil},
    ["EMPTY_EQUIPMENT_SLOT"]                = {"Equipment slot is empty", nil, nil, nil, nil, nil, nil, nil, nil},
    ["INSUFFICIENT_RESOURCES_ERROR"]        = {"You don't have enough %ss", nil, nil, nil, nil, nil, nil, nil, nil},
    ["INSUFFICIENT_FUNDS_ERROR"]            = {"Not enough money", nil, nil, nil, nil, nil, nil, nil, nil},
}

-- Only run queries in the world state
if GetStateMapId() == -1 then
    -- Note, Query is instant when Execute is delayed
    CharDBQuery([[
    CREATE TABLE IF NOT EXISTS `custom_transmogrification` (
    `GUID` INT(10) UNSIGNED NOT NULL COMMENT 'Item guidLow',
    `FakeEntry` INT(10) UNSIGNED NOT NULL COMMENT 'Item entry',
    `Owner` INT(10) UNSIGNED NOT NULL COMMENT 'Player guidLow',
    PRIMARY KEY (`GUID`)
    )
    COMMENT='version 4.0'
    COLLATE='latin1_swedish_ci'
    ENGINE=InnoDB;
    ]])

    PrintInfo("Deleting non-existing transmogrification entries...")
    CharDBQuery("DELETE FROM custom_transmogrification WHERE NOT EXISTS (SELECT 1 FROM item_instance WHERE item_instance.guid = custom_transmogrification.GUID)")
    
    -- Only load script on MAP states in multistate mode
    if not IsCompatibilityMode() then return end
end

local function LocText(id, p) -- "%s":format("test")
    if Locales[id] then
        local s = Locales[id][p:GetDbcLocale()+1] or Locales[id][1]
        if s then
            return s
        end
    end
    return "Text not found: "..(id or 0)
end
--[[
typedef UNORDERED_MAP<uint32, uint32> transmogData
typedef UNORDERED_MAP<uint32, transmogData> transmogMap
static transmogMap entryMap -- entryMap[pGUID][iGUID] = entry
]]

local function SetEntryMap(player, data)
    return player:Data():Set("TransmogEntryMap", data)
end

local function GetEntryMap(player)
    local data = player:Data():Get("TransmogEntryMap")
    if not data then
        data = SetEntryMap(player, {})
    end
    return data:AsTable()
end

local function GetSlotName(slot, locale)
    if not SlotNames[slot] then return end
    return locale and SlotNames[slot][locale+1] or SlotNames[slot][1]
end

local function GetFakePrice(item)
    local sellPrice = item:GetSellPrice()
    local minPrice = 10000
    if sellPrice < minPrice then
        sellPrice = minPrice
    end
    return sellPrice
end

local function GetFakeEntry(item)
    local player = item:GetOwner()
    if player then
        local entryMap = GetEntryMap(player)
        local guid = item and item:GetGUIDLow()
        if guid then
            return entryMap[guid]
        end
    end
end

local function DeleteFakeFromStorage(item)
    local player = item:GetOwner()
    local iGUID = item:GetGUIDLow()
    if player then
        local entryMap = GetEntryMap(player)
        entryMap[iGUID] = nil
        SetEntryMap(player, entryMap)
        CharDBExecute("DELETE FROM custom_transmogrification WHERE GUID = "..iGUID)
    end
end

local function DeleteFakeEntry(item)
    if not GetFakeEntry(item) then
        return false
    end
    item:GetOwner():SetUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (item:GetSlot() * ITEM_SLOT_MULTIPLIER), item:GetEntry())
    DeleteFakeFromStorage(item)
    return true
end

local function SetFakeEntry(item, entry)
    local player = item:GetOwner()
    if player then
        local pGUID = player:GetGUIDLow()
        local iGUID = item:GetGUIDLow()
        local entryMap = GetEntryMap(player)
        entryMap[iGUID] = entry
        SetEntryMap(player, entryMap)
        player:SetUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (item:GetSlot() * ITEM_SLOT_MULTIPLIER), entry)
        CharDBExecute("REPLACE INTO custom_transmogrification (GUID, FakeEntry, Owner) VALUES ("..iGUID..", "..entry..", "..pGUID..")")
    end
end

local function IsRangedWeapon(Class, SubClass)
    return Class == ITEM_CLASS_WEAPON and (
    SubClass == ITEM_SUBCLASS_WEAPON_BOW or
    SubClass == ITEM_SUBCLASS_WEAPON_GUN or
    SubClass == ITEM_SUBCLASS_WEAPON_CROSSBOW)
end

local function SuitableForTransmogrification(player, target, source)
    if not target or not source then
        return false
    end

    if not Qualities[target:GetQuality()] or not Qualities[source:GetQuality()] then
        return false
    end

    if target:GetDisplayId() == source:GetDisplayId() then
        return false
    end

    local fentry = GetFakeEntry(target)
    if fentry and fentry == source:GetEntry() then
        return false
    end

    if not player:CanUseItem(source) then
        return false
    end

    local sourceClass = source:GetClass()
    local sourceSubClass = source:GetSubClass()
    local sourceInvType = source:GetInventoryType()
    
    local targetClass = target:GetClass()
    local targetSubClass = target:GetSubClass()
    local targetInvType = target:GetInventoryType()

    if targetInvType == INVTYPE_BAG or
    targetInvType == INVTYPE_RELIC or
    -- targetInvType == INVTYPE_BODY or
    targetInvType == INVTYPE_FINGER or
    targetInvType == INVTYPE_TRINKET or
    targetInvType == INVTYPE_AMMO or
    targetInvType == INVTYPE_QUIVER then
        return false
    end

    if sourceInvType == INVTYPE_BAG or
    sourceInvType == INVTYPE_RELIC or
    -- sourceInvType == INVTYPE_BODY or
    sourceInvType == INVTYPE_FINGER or
    sourceInvType == INVTYPE_TRINKET or
    sourceInvType == INVTYPE_AMMO or
    sourceInvType == INVTYPE_QUIVER then
        return false
    end

    if sourceClass ~= targetClass then
        return false
    end

    if IsRangedWeapon(targetClass, targetSubClass) ~= IsRangedWeapon(sourceClass, sourceSubClass) then
        return false
    end

    if sourceSubClass ~= targetSubClass and not IsRangedWeapon(targetClass, targetSubClass) then
        if sourceClass == ITEM_CLASS_ARMOR and not AllowMixedArmorTypes then
            return false
        end
        if sourceClass == ITEM_CLASS_WEAPON and not AllowMixedWeaponTypes then
            return false
        end
    end

    if (sourceInvType ~= targetInvType) then
        if (sourceClass == ITEM_CLASS_WEAPON and not ((IsRangedWeapon(targetClass, targetSubClass) or
            ((targetInvType == INVTYPE_WEAPON or targetInvType == INVTYPE_2HWEAPON) and
                (sourceInvType == INVTYPE_WEAPON or sourceInvType == INVTYPE_2HWEAPON)) or
            ((targetInvType == INVTYPE_WEAPONMAINHAND or targetInvType == INVTYPE_WEAPONOFFHAND) and
                (sourceInvType == INVTYPE_WEAPON or sourceInvType == INVTYPE_2HWEAPON))))) then
            return false
        end
        if (sourceClass == ITEM_CLASS_ARMOR and
            not ((sourceInvType == INVTYPE_CHEST or sourceInvType == INVTYPE_ROBE) and
                (targetInvType == INVTYPE_CHEST or targetInvType == INVTYPE_ROBE))) then
            return false
        end
    end

    return true
end

local menu_id = math.random(1000)

local function OnGossipHello(event, player, creature)
    player:GossipClearMenu()
    for slot = EQUIPMENT_SLOT_START, EQUIPMENT_SLOT_END-1 do
        local target = player:GetItemByPos(INVENTORY_SLOT_BAG_0, slot)
        if target then
            if Qualities[target:GetQuality()] then
                local slotName = GetSlotName(slot, player:GetDbcLocale())
                if slotName then
                    player:GossipMenuAddItem(3, slotName, EQUIPMENT_SLOT_END, slot)
                end
            end
        end
    end
    player:GossipMenuAddItem(4, LocText("REMOVE_ALL_TRANSMOGS_OPTION", player), EQUIPMENT_SLOT_END+2, 0, false, LocText("CONFIRM_REMOVE_EQUIPPED_TRANSMOGS", player), 0)
    player:GossipMenuAddItem(7, LocText("UPDATE_MENU_OPTION", player), EQUIPMENT_SLOT_END+1, 0)
    player:GossipSendMenu(100, creature, menu_id)
end

local _items = {}
local function OnGossipSelect(event, player, creature, slotid, uiAction)
    local lowGUID = player:GetGUIDLow()
    if slotid == EQUIPMENT_SLOT_END then -- Show items you can use
        local target = player:GetItemByPos(INVENTORY_SLOT_BAG_0, uiAction)
        if target then
            _items[lowGUID] = {} -- Remove this with logix
            local limit = 0
            local price = 0
            if RequireGold == 1 then
                price = GetFakePrice(target)*GoldModifier
            elseif RequireGold == 2 then
                price = GoldCost
            end

            for i = INVENTORY_SLOT_ITEM_START, INVENTORY_SLOT_ITEM_END-1 do
                if limit > 30 then
                    break
                end
                local source = player:GetItemByPos(INVENTORY_SLOT_BAG_0, i)
                if source then
                    local display = source:GetDisplayId()
                    if SuitableForTransmogrification(player, target, source) then
                        if not _items[lowGUID][display] then
                            limit = limit + 1
                            _items[lowGUID][display] = {source:GetBagSlot(), source:GetSlot()}
                            local popup = LocText("TRANSMOG_BIND_WARNING", player).."\n\n"..source:GetItemLink(player:GetDbcLocale()).."\n"
                            if RequireToken then
                                popup = popup.."\n"..TokenAmount.." x "..GetItemLink(TokenEntry, player:GetDbcLocale())
                            end
                            player:GossipMenuAddItem(4, source:GetItemLink(player:GetDbcLocale()), uiAction, display, false, popup, price)
                        end
                    end
                end
            end

            for i = INVENTORY_SLOT_BAG_START, INVENTORY_SLOT_BAG_END-1 do
                local bag = player:GetItemByPos(INVENTORY_SLOT_BAG_0, i)
                if bag then
                    for j = 0, bag:GetBagSize()-1 do
                        if limit > 30 then
                            break
                        end
                        local source = player:GetItemByPos(i, j)
                        if source then
                            local display = source:GetDisplayId()
                            if SuitableForTransmogrification(player, target, source) then
                                if not _items[lowGUID][display] then
                                    limit = limit + 1
                                    _items[lowGUID][display] = {source:GetBagSlot(), source:GetSlot()}
                                    player:GossipMenuAddItem(4, source:GetItemLink(player:GetDbcLocale()), uiAction, display, false, popup, price)
                                end
                            end
                        end
                    end
                end
            end

            player:GossipMenuAddItem(4, LocText("REMOVE_TRANSMOG_SLOT_OPTION", player), EQUIPMENT_SLOT_END+3, uiAction, false, LocText("CONFIRM_REMOVE_TRANSMOG_SLOT", player):format(GetSlotName(uiAction, player:GetDbcLocale())))
            player:GossipMenuAddItem(7, LocText("GO_BACK_OPTION", player), EQUIPMENT_SLOT_END+1, 0)
            player:GossipSendMenu(100, creature, menu_id)
        else
            OnGossipHello(event, player, creature)
        end
    elseif slotid == EQUIPMENT_SLOT_END+1 then -- Back
        OnGossipHello(event, player, creature)
    elseif slotid == EQUIPMENT_SLOT_END+2 then -- Remove Transmogrifications
        local removed = false
        for slot = EQUIPMENT_SLOT_START, EQUIPMENT_SLOT_END-1 do
            local target = player:GetItemByPos(INVENTORY_SLOT_BAG_0, slot)
            if target then
                if DeleteFakeEntry(target) and not removed then
                    removed = true
                end
            end
        end
        if removed then
            player:SendAreaTriggerMessage(LocText("ALL_TRANSMOGS_REMOVED_SUCCESS", player))
            -- player:PlayDirectSound(3337)
        else
            player:SendNotification(LocText("NO_TRANSMOGGED_ITEMS_FOUND", player))
        end
        OnGossipHello(event, player, creature)
    elseif slotid == EQUIPMENT_SLOT_END+3 then -- Remove Transmogrification from single item
        local target = player:GetItemByPos(INVENTORY_SLOT_BAG_0, uiAction)
        if target then
            if DeleteFakeEntry(target) then
                player:SendAreaTriggerMessage(LocText("SLOT_TRANSMOGS_REMOVED_SUCCESS", player):format(GetSlotName(uiAction, player:GetDbcLocale())))
                -- player:PlayDirectSound(3337)
            else
                player:SendNotification(LocText("NO_TRANSMOG_IN_SLOT", player):format(GetSlotName(uiAction, player:GetDbcLocale())))
            end
        end
        OnGossipSelect(event, player, creature, EQUIPMENT_SLOT_END, uiAction)
    else -- Transmogrify
        -- Check if player has sufficient tokens if required
        if RequireToken and player:GetItemCount(TokenEntry) < TokenAmount then
            player:SendNotification(LocText("INSUFFICIENT_RESOURCES_ERROR", player):format(GetItemLink(TokenEntry, player:GetDbcLocale())))
            return
        end

        -- Retrieve the target item
        local target = player:GetItemByPos(INVENTORY_SLOT_BAG_0, slotid)
        if not target then
            player:SendNotification(LocText("EMPTY_EQUIPMENT_SLOT", player))
            return
        end

        -- Ensure _items entry exists and contains valid data
        if not (_items[lowGUID] and _items[lowGUID][uiAction] and _items[lowGUID][uiAction]) then
            player:SendNotification(LocText("NON_EXISTENT_ITEM_ERROR", player))
            return
        end

        -- Retrieve the source item
        local source = player:GetItemByPos(_items[lowGUID][uiAction][1], _items[lowGUID][uiAction][2])
        if not (source and GetGUIDLow(source:GetOwnerGUID()) == lowGUID and (source:IsInBag() or source:GetBagSlot() == INVENTORY_SLOT_BAG_0) and SuitableForTransmogrification(player, target, source)) then
            player:SendNotification(LocText("INVALID_ITEMS_ERROR", player))
            return
        end

        -- Determine the price for transmogrification
        local price
        if RequireGold == 1 then
            price = GetFakePrice(target) * GoldModifier
        elseif RequireGold == 2 then
            price = GoldCost
        end

        -- Check if player has sufficient money if required
        if price and player:GetCoinage() < price then
            player:SendNotification(LocText("INSUFFICIENT_FUNDS_ERROR", player))
            return
        end

        -- Deduct the price and tokens (if required), and apply transmogrification
        if price then
            player:ModifyMoney(-price)
        end
        if RequireToken then
            player:RemoveItem(TokenEntry, TokenAmount)
        end

        SetFakeEntry(target, source:GetEntry())
        source:SetBinding(true)
        -- player:PlayDirectSound(3337)
        player:SendAreaTriggerMessage(LocText("TRANSMOGGED_SUCCESS", player):format(GetSlotName(slotid, player:GetDbcLocale())))

        _items[lowGUID] = {}
        OnGossipSelect(event, player, creature, EQUIPMENT_SLOT_END, slotid)
    end
end

local function RunQuery(result, playerGUID)
    local player
    if IsCompatibilityMode() then
        player = GetPlayerByGUID(GetPlayerGUID(playerGUID))
    else
        player = GetStateMap():GetWorldObject(GetPlayerGUID(playerGUID))
    end

    if result and player then
        local entryMap = GetEntryMap(player)
        repeat
            local itemGUID = result:GetUInt32(0)
            local fakeEntry = result:GetUInt32(1)
            entryMap[itemGUID] = fakeEntry
        until not result:NextRow()

        for slot = EQUIPMENT_SLOT_START, EQUIPMENT_SLOT_END-1 do
            local item = player:GetItemByPos(INVENTORY_SLOT_BAG_0, slot)
            if item then
                if entryMap[item:GetGUIDLow()] then
                    player:SetUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (item:GetSlot() * ITEM_SLOT_MULTIPLIER), entryMap[item:GetGUIDLow()])
                end
            end
        end
        -- set an identifier so we know that the entryMap is filled with the DB cache
        entryMap["DBCache"] = true
        SetEntryMap(player, entryMap)
    end
end

local function OnMapChange(event, player)
    local playerGUID = player:GetGUIDLow()
    local entryMap = GetEntryMap(player)

    if not entryMap["DBCache"] then
        local query = "SELECT GUID, FakeEntry FROM custom_transmogrification WHERE Owner = "
        CharDBQueryAsync(query..playerGUID, function(result) RunQuery(result, playerGUID) end)
    end
end

local function OnEquip(event, player, item, bag, slot)
    local fentry = GetFakeEntry(item)
    if fentry then
        if GetGUIDLow(item:GetOwnerGUID()) ~= player:GetGUIDLow() then
            DeleteFakeFromStorage(item)
            return
        end
        player:SetUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (slot * ITEM_SLOT_MULTIPLIER), fentry)
    end
end

RegisterPlayerEvent(28, OnMapChange)
RegisterPlayerEvent(29, OnEquip)

RegisterCreatureGossipEvent(NPC_Entry, 1, OnGossipHello)
RegisterCreatureGossipEvent(NPC_Entry, 2, OnGossipSelect)

-- Test code
--RegisterPlayerEvent(18, function(e,p,m,t,l) if m == "test" then OnGossipHello(e,p,p) end end)
--RegisterPlayerGossipEvent(menu_id, 2, OnGossipSelect)
