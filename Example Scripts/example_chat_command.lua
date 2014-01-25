local ChatPrefix = "#example"

local function ChatSystem(event, player, msg, _, lang)
    if (msg:find(ChatPrefix) == 1) then
        player:SendNotification("Example Chat Command Works")
    end
end

RegisterPlayerEvent(18, ChatSystem)