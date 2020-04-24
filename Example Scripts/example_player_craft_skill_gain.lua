local function OnCraftSkillChange(event, player, spellid, skillAmount)
	player:SendBroadcastMessage("Congratulations you received +1 craft skill.")
	return skillAmount + 1
end

RegisterPlayerEvent(40, OnCraftSkillChange)
