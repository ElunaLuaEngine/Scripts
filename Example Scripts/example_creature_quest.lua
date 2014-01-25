local NpcId = 123
local QuestId = 123

local function OnQuestAccept(event, player, creature, quest)
    if (quest:GetId() == QuestId) then
        creature:SendUnitSay("You have accepted a quest!", 0)
    end
end

local function OnQuestComplete(event, player, creature, quest)
    if (quest:GetId() == QuestId) then
        creature:SendUnitSay("You have completed a quest!", 0)
    end
end

RegisterCreatureEvent(NpcId, 31, OnQuestAccept)
RegisterCreatureEvent(NpcId, 33, OnQuestComplete)