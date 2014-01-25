local function OnEvents(event, player, msg, Type, lang)
    if (msg == "asd") then
        print "asd"
    end
end

RegisterPlayerEvent(18, OnEvents)