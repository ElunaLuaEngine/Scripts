--[[
4.0
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
    {"Update menu", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Remove all transmogrifications", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Remove transmogrifications from all equipped items?", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Using this item for transmogrify will bind it to you and make it non-refundable and non-tradeable.\nDo you wish to continue?", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Remove transmogrification from %s?", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Back..", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Remove transmogrification", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Transmogrifications removed from equipped items", nil, nil, nil, nil, nil, nil, nil, nil},
    {"You have no transmogrified items equipped", nil, nil, nil, nil, nil, nil, nil, nil},
    {"%s transmogrification removed", nil, nil, nil, nil, nil, nil, nil, nil},
    {"No transmogrification on %s slot", nil, nil, nil, nil, nil, nil, nil, nil},
    {"%s transmogrified", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Selected items are not suitable", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Selected item does not exist", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Equipment slot is empty", nil, nil, nil, nil, nil, nil, nil, nil},
    {"You don't have enough %ss", nil, nil, nil, nil, nil, nil, nil, nil},
    {"Not enough money", nil, nil, nil, nil, nil, nil, nil, nil},
}
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
static transmogData dataMap -- dataMap[iGUID] = pGUID
]]
local entryMap = {}
local dataMap = {}

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
    local guid = item and item:GetGUIDLow()
    if guid and dataMap[guid] then
        if entryMap[dataMap[guid]] then
            return entryMap[dataMap[guid]][guid]
        end
    end
end

local function DeleteFakeFromDB(itemGUID)
    if dataMap[itemGUID] then
        if entryMap[dataMap[itemGUID]] then
            entryMap[dataMap[itemGUID]][itemGUID] = nil
        end
        dataMap[itemGUID] = nil
    end
    CharDBExecute("DELETE FROM custom_transmogrification WHERE GUID = "..itemGUID)
end

local function DeleteFakeEntry(item)
    if not GetFakeEntry(item) then
        return false
    end
    item:GetOwner():UpdateUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (item:GetSlot() * ITEM_SLOT_MULTIPLIER), item:GetEntry())
    DeleteFakeFromDB(item:GetGUIDLow())
    return true
end

local function SetFakeEntry(item, entry)
    local player = item:GetOwner()
    if player then
        local pGUID = player:GetGUIDLow()
        local iGUID = item:GetGUIDLow()
        player:UpdateUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (item:GetSlot() * ITEM_SLOT_MULTIPLIER), entry)
        if not entryMap[pGUID] then
            entryMap[pGUID] = {}
        end
        entryMap[pGUID][iGUID] = entry
        dataMap[iGUID] = pGUID
        CharDBExecute("REPLACE INTO custom_transmogrification (GUID, FakeEntry, Owner) VALUES ("..iGUID..", "..entry..", "..pGUID..")")
    end
end

local function IsRangedWeapon(Class, SubClass)
    return Class == ITEM_CLASS_WEAPON and (
    SubClass == ITEM_SUBCLASS_WEAPON_BOW or
    SubClass == ITEM_SUBCLASS_WEAPON_GUN or
    SubClass == ITEM_SUBCLASS_WEAPON_CROSSBOW)
end

local function SuitableForTransmogrification(player, transmogrified, transmogrifier)
    if not transmogrified or not transmogrifier then
        return false
    end

    if not Qualities[transmogrifier:GetQuality()] then
        return false
    end

    if not Qualities[transmogrified:GetQuality()] then
        return false
    end

    if transmogrified:GetDisplayId() == transmogrifier:GetDisplayId() then
        return false
    end

    local fentry = GetFakeEntry(transmogrified)
    if fentry and fentry == transmogrifier:GetEntry() then
        return false
    end

    if not player:CanUseItem(transmogrifier) then
        return false
    end

    local fierClass = transmogrifier:GetClass()
    local fiedClass = transmogrified:GetClass()
    local fierSubClass = transmogrifier:GetSubClass()
    local fiedSubClass = transmogrified:GetSubClass()
    local fierInventorytype = transmogrifier:GetInventoryType()
    local fiedInventorytype = transmogrified:GetInventoryType()

    if fiedInventorytype == INVTYPE_BAG or
    fiedInventorytype == INVTYPE_RELIC or
    -- fiedInventorytype == INVTYPE_BODY or
    fiedInventorytype == INVTYPE_FINGER or
    fiedInventorytype == INVTYPE_TRINKET or
    fiedInventorytype == INVTYPE_AMMO or
    fiedInventorytype == INVTYPE_QUIVER then
        return false
    end

    if fierInventorytype == INVTYPE_BAG or
    fierInventorytype == INVTYPE_RELIC or
    -- fierInventorytype == INVTYPE_BODY or
    fierInventorytype == INVTYPE_FINGER or
    fierInventorytype == INVTYPE_TRINKET or
    fierInventorytype == INVTYPE_AMMO or
    fierInventorytype == INVTYPE_QUIVER then
        return false
    end

    if fierClass ~= fiedClass then
        return false
    end

    if IsRangedWeapon(fiedClass, fiedSubClass) ~= IsRangedWeapon(fierClass, fierSubClass) then
        return false
    end

    if fierSubClass ~= fiedSubClass and not IsRangedWeapon(fiedClass, fiedSubClass) then
        if fierClass == ITEM_CLASS_ARMOR and not AllowMixedArmorTypes then
            return false
        end
        if fierClass == ITEM_CLASS_WEAPON and not AllowMixedWeaponTypes then
            return false
        end
    end

    if (fierInventorytype ~= fiedInventorytype) then
        if (fierClass == ITEM_CLASS_WEAPON and not ((IsRangedWeapon(fiedClass, fiedSubClass) or
            ((fiedInventorytype == INVTYPE_WEAPON or fiedInventorytype == INVTYPE_2HWEAPON) and
                (fierInventorytype == INVTYPE_WEAPON or fierInventorytype == INVTYPE_2HWEAPON)) or
            ((fiedInventorytype == INVTYPE_WEAPONMAINHAND or fiedInventorytype == INVTYPE_WEAPONOFFHAND) and
                (fierInventorytype == INVTYPE_WEAPON or fierInventorytype == INVTYPE_2HWEAPON))))) then
            return false
        end
        if (fierClass == ITEM_CLASS_ARMOR and
            not ((fierInventorytype == INVTYPE_CHEST or fierInventorytype == INVTYPE_ROBE) and
                (fiedInventorytype == INVTYPE_CHEST or fiedInventorytype == INVTYPE_ROBE))) then
            return false
        end
    end

    return true
end

local menu_id = math.random(1000)

local function OnGossipHello(event, player, creature)
    player:GossipClearMenu()
    for slot = EQUIPMENT_SLOT_START, EQUIPMENT_SLOT_END-1 do
        local transmogrified = player:GetItemByPos(INVENTORY_SLOT_BAG_0, slot)
        if transmogrified then
            if Qualities[transmogrified:GetQuality()] then
                local slotName = GetSlotName(slot, player:GetDbcLocale())
                if slotName then
                    player:GossipMenuAddItem(3, slotName, EQUIPMENT_SLOT_END, slot)
                end
            end
        end
    end
    player:GossipMenuAddItem(4, LocText(2, player), EQUIPMENT_SLOT_END+2, 0, false, LocText(3, player), 0)
    player:GossipMenuAddItem(7, LocText(1, player), EQUIPMENT_SLOT_END+1, 0)
    player:GossipSendMenu(100, creature, menu_id)
end

local _items = {}
local function OnGossipSelect(event, player, creature, slotid, uiAction)
    if slotid == EQUIPMENT_SLOT_END then -- Show items you can use
        local transmogrified = player:GetItemByPos(INVENTORY_SLOT_BAG_0, uiAction)
        if transmogrified then
            local lowGUID = player:GetGUIDLow()
            _items[lowGUID] = {} -- Remove this with logix
            local limit = 0
            local price = 0
            if RequireGold == 1 then
                price = GetFakePrice(transmogrified)*GoldModifier
            elseif RequireGold == 2 then
                price = GoldCost
            end

            for i = INVENTORY_SLOT_ITEM_START, INVENTORY_SLOT_ITEM_END-1 do
                if limit > 30 then
                    break
                end
                local transmogrifier = player:GetItemByPos(INVENTORY_SLOT_BAG_0, i)
                if transmogrifier then
                    local display = transmogrifier:GetDisplayId()
                    if SuitableForTransmogrification(player, transmogrified, transmogrifier) then
                        if not _items[lowGUID][display] then
                            limit = limit + 1
                            _items[lowGUID][display] = {transmogrifier:GetBagSlot(), transmogrifier:GetSlot()}
                            local popup = LocText(4, player).."\n\n"..transmogrifier:GetItemLink(player:GetDbcLocale()).."\n"
                            if RequireToken then
                                popup = popup.."\n"..TokenAmount.." x "..GetItemLink(TokenEntry, player:GetDbcLocale())
                            end
                            player:GossipMenuAddItem(4, transmogrifier:GetItemLink(player:GetDbcLocale()), uiAction, display, false, popup, price)
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
                        local transmogrifier = player:GetItemByPos(i, j)
                        if transmogrifier then
                            local display = transmogrifier:GetDisplayId()
                            if SuitableForTransmogrification(player, transmogrified, transmogrifier) then
                                if not _items[lowGUID][display] then
                                    limit = limit + 1
                                    _items[lowGUID][display] = {transmogrifier:GetBagSlot(), transmogrifier:GetSlot()}
                                    player:GossipMenuAddItem(4, transmogrifier:GetItemLink(player:GetDbcLocale()), uiAction, display, false, popup, price)
                                end
                            end
                        end
                    end
                end
            end

            player:GossipMenuAddItem(4, LocText(7, player), EQUIPMENT_SLOT_END+3, uiAction, false, LocText(5, player):format(GetSlotName(uiAction, player:GetDbcLocale())))
            player:GossipMenuAddItem(7, LocText(6, player), EQUIPMENT_SLOT_END+1, 0)
            player:GossipSendMenu(100, creature, menu_id)
        else
            OnGossipHello(event, player, creature)
        end
    elseif slotid == EQUIPMENT_SLOT_END+1 then -- Back
        OnGossipHello(event, player, creature)
    elseif slotid == EQUIPMENT_SLOT_END+2 then -- Remove Transmogrifications
        local removed = false
        for slot = EQUIPMENT_SLOT_START, EQUIPMENT_SLOT_END-1 do
            local transmogrifier = player:GetItemByPos(INVENTORY_SLOT_BAG_0, slot)
            if transmogrifier then
                if DeleteFakeEntry(transmogrifier) and not removed then
                    removed = true
                end
            end
        end
        if removed then
            player:SendAreaTriggerMessage(LocText(8, player))
            -- player:PlayDirectSound(3337)
        else
            player:SendNotification(LocText(9, player))
        end
        OnGossipHello(event, player, creature)
    elseif slotid == EQUIPMENT_SLOT_END+3 then -- Remove Transmogrification from single item
        local transmogrifier = player:GetItemByPos(INVENTORY_SLOT_BAG_0, uiAction)
        if transmogrifier then
            if DeleteFakeEntry(transmogrifier) then
                player:SendAreaTriggerMessage(LocText(10, player):format(GetSlotName(uiAction, player:GetDbcLocale())))
                -- player:PlayDirectSound(3337)
            else
                player:SendNotification(LocText(11, player):format(GetSlotName(uiAction, player:GetDbcLocale())))
            end
        end
        OnGossipSelect(event, player, creature, EQUIPMENT_SLOT_END, uiAction)
    else -- Transmogrify
        local lowGUID = player:GetGUIDLow()
        if not RequireToken or player:GetItemCount(TokenEntry) >= TokenAmount then
            local transmogrified = player:GetItemByPos(INVENTORY_SLOT_BAG_0, slotid)
            if transmogrified then
                if _items[lowGUID] and _items[lowGUID][uiAction] and _items[lowGUID][uiAction] then
                    local transmogrifier = player:GetItemByPos(_items[lowGUID][uiAction][1], _items[lowGUID][uiAction][2])
                    if transmogrifier:GetOwnerGUID() == player:GetGUID() and (transmogrifier:IsInBag() or transmogrifier:GetBagSlot() == INVENTORY_SLOT_BAG_0) and SuitableForTransmogrification(player, transmogrified, transmogrifier) then
                        local price
                        if RequireGold == 1 then
                            price = GetFakePrice(transmogrified)*GoldModifier
                        elseif RequireGold == 2 then
                            price = GoldCost
                        end
                        if price then
                            if player:GetCoinage() >= price then
                                player:ModifyMoney(-1*price)
                                if RequireToken then
                                    player:RemoveItem(TokenEntry, TokenAmount)
                                end
                                SetFakeEntry(transmogrified, transmogrifier:GetEntry())
                                -- transmogrifier:SetNotRefundable(player)
                                transmogrifier:SetBinding(true)
                                -- player:PlayDirectSound(3337)
                                player:SendAreaTriggerMessage(LocText(12, player):format(GetSlotName(slotid, player:GetDbcLocale())))
                            else
                                player:SendNotification(LocText(17, player))
                            end
                        end
                    else
                        player:SendNotification(LocText(13, player))
                    end
                else
                    player:SendNotification(LocText(14, player))
                end
            else
                player:SendNotification(LocText(15, player))
            end
        else
            player:SendNotification(LocText(16, player):format(GetItemLink(TokenEntry, player:GetDbcLocale())))
        end
        _items[lowGUID] = {}
        OnGossipSelect(event, player, creature, EQUIPMENT_SLOT_END, slotid)
    end
end

local function OnLogin(event, player)
    local playerGUID = player:GetGUIDLow()
    entryMap[playerGUID] = {}
    local result = CharDBQuery("SELECT GUID, FakeEntry FROM custom_transmogrification WHERE Owner = "..playerGUID)
    if result then
        repeat
            local itemGUID = result:GetUInt32(0)
            local fakeEntry = result:GetUInt32(1)
            -- if sObjectMgr:GetItemTemplate(fakeEntry) then
            -- {
            dataMap[itemGUID] = playerGUID
            entryMap[playerGUID][itemGUID] = fakeEntry
            -- }
            -- else
            --     sLog:outError(LOG_FILTER_SQL, "Item entry (Entry: %u, itemGUID: %u, playerGUID: %u) does not exist, deleting.", fakeEntry, itemGUID, playerGUID)
            --     Transmogrification::DeleteFakeFromDB(itemGUID)
            -- end
        until not result:NextRow()

        for slot = EQUIPMENT_SLOT_START, EQUIPMENT_SLOT_END-1 do
            local item = player:GetItemByPos(INVENTORY_SLOT_BAG_0, slot)
            if item then
                if entryMap[playerGUID] then
                    if entryMap[playerGUID][item:GetGUIDLow()] then
                        player:UpdateUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (item:GetSlot() * ITEM_SLOT_MULTIPLIER), entryMap[playerGUID][item:GetGUIDLow()])
                    end
                end
            end
        end
    end
end

local function OnLogout(event, player)
    local pGUID = player:GetGUIDLow()
    entryMap[pGUID] = nil
end

local function OnEquip(event, player, item, bag, slot)
    local fentry = GetFakeEntry(item)
    if fentry then
        if item:GetOwnerGUID() ~= player:GetGUID() then
            DeleteFakeFromDB(item:GetGUIDLow())
            return
        end
        player:SetUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (slot * ITEM_SLOT_MULTIPLIER), fentry)
    end
end

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

print("Deleting non-existing transmogrification entries...")
CharDBQuery("DELETE FROM custom_transmogrification WHERE NOT EXISTS (SELECT 1 FROM item_instance WHERE item_instance.guid = custom_transmogrification.GUID)")

RegisterPlayerEvent(3, OnLogin)
RegisterPlayerEvent(4, OnLogout)
RegisterPlayerEvent(29, OnEquip)

-- Test code
--RegisterPlayerEvent(18, function(e,p,m,t,l) if m == "test" then OnGossipHello(e,p,p) end end)
--RegisterPlayerGossipEvent(menu_id, 2, OnGossipSelect)

RegisterCreatureGossipEvent(NPC_Entry, 1, OnGossipHello)
RegisterCreatureGossipEvent(NPC_Entry, 2, OnGossipSelect)

local plrs = GetPlayersInWorld()
if plrs then
    for k, player in ipairs(plrs) do
        OnLogin(k, player)
    end
end
