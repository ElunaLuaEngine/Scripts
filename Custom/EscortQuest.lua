--IDs. NPC is the questgiver/escort NPC. Quest ID is obviously the ID of the quest. Spawn 1-3 is the mobs you want spawned at the "resting" location.
local NPC_ID = 70025
local QUEST_ID = 70025
local SpawnID1 = 70013
local SpawnID2 = 70013
local SpawnID3 = 70013

--Gossip and Menu Texts
local GossipText = "I'm ready to move out, shall we leave?"
local GossipTextOnQuest = "All these spiders makes me feel all tingly. I need to get out of here, as soon as possible!"
local GossipCompletedText = "I must thank you for helping me earlier, but I seem to have been caught in the same situation again... I don't wish to bore you with helping me again. So I'll just wait here for another hero"
local MenuOptionText = "Lets go!"

--Creature say texts
local OnMoveSay = "Finally, away from these spiders we go!"
local OnMidPointSay = "Look at all these skittering abominations... I just wanna stomp 'em"
local OnBreakSay = "Hold on a minute, I really need to catch my breath..."
local FightSay = "Ahhhhh, spiders. Stomp them! DO SOMETHING!"
local NearEndSay = "We're starting to get near the main road."
local EndEscortSay = "Thanks for helping me, $n!"
local OnDeathSay = "You failed me hero! The spiders... they're everywhere!"


--World coordinates of the enemy spawn positions. You can add more spawns by editing the code below, only do this if you know what you're doing.
local Spawn1x = 931.7633
local Spawn1y = 43.700
local Spawn1z = 305.384
local Spawn1o = 4.2377

local Spawn2x = 938.268
local Spawn2y = 16.79170
local Spawn2z = 305.0134
local Spawn2o = 2.335

local Spawn3x = 909.232
local Spawn3y = 21.558
local Spawn3z = 305.6565
local Spawn3o = 0.571




-----------------------------------------------------
--DO NOT EDIT BELOW THIS LINE
--DO NOT EDIT BELOW THIS LINE
--DO NOT EDIT BELOW THIS LINE
--DO NOT EDIT BELOW THIS LINE
--DO NOT EDIT BELOW THIS LINE... unless you're a god <3
-----------------------------------------------------



--Variables
local startPlayer = nil

local OnTheMove = false
local NearEnd = false
local EscortComplete = false
local EnemySpawn = false
local ReachedMid = false


--CHANGE THESE TO THE WAYPOINT IDS YOU WANT. Midpoint = halfway to break (attack point), after attack is between end and fight.
local MidPoint = 6
local BreakPoint = 10
local AfterAttackPoint = 11
local CompletePoint = 13

local Respawn = false
--End of variables

local function OnGossipHello(event, player, creature)

	--If the player has quest and is not on the move.
	if (player:GetQuestStatus(QUEST_ID) == 3 and not OnTheMove) then
		player:GossipSetText(GossipTextOnQuest)
		player:GossipMenuAddItem(0, MenuOptionText, 1, 0)
	--If the player doesnt have the quest and not on the move.
	elseif (player:GetQuestStatus(QUEST_ID) == 0 and not OnTheMove) then
		player:GossipSetText(GossipText)
		player:GossipAddQuests(creature)
	--If the player has completed and is not on the move.
	elseif (player:GetQuestStatus(QUEST_ID) == 6 and not OnTheMove) then
		player:GossipSetText(GossipCompletedText)
    end
	
	
	--Send menu to player.
    player:GossipSendMenu(0x7FFFFFFF, creature)
end	



--There's only one option in the gossip so no need to make it complicated. Just start the script according to the following logic.
local function OnGossipSelect(event, player, creature, sender, intid, code)
    creature:SendUnitSay(OnMoveSay, 7)
	creature:RegisterEvent(Escort_Move, 250, 1)
	OnTheMove = true
	creature:SetNPCFlags(0)
	

	startPlayer = player:GetName()

	
    player:GossipComplete()
end

--Move the escort and start the update tick to check for stuff.
function Escort_Move(event, delay, pCall, creature)
	creature:RegisterEvent(Escort_Update, 500, 0)
	creature:MoveWaypoint(0)
end

--Update conditions for the quest, like fail if you get too far away.
function Escort_Update(event, delay, pCall, creature)
	local plr = GetPlayerByName(startPlayer)
	if creature:GetDistance(plr) >= 73 then
		if (startPlayer ~= nil) then
			local plr = GetPlayerByName(startPlayer)
			if (plr:GetGroup() ~= nil) then
				local group = plr:GetGroup()
				local players = group:GetMembers()
				for a, plrs in pairs(players) do
					if plrs ~= nil then
						if plrs:HasQuest(QUEST_ID) then
							plrs:FailQuest(QUEST_ID)
						end
					end
				end
			elseif plr ~= nil then
				plr:FailQuest(QUEST_ID)
			end
			creature:RegisterEvent(Escort_Respawn, 100, 1)
		end
	end


	--If we reached halfway to breakpoint
	if (creature:GetCurrentWaypointId() == MidPoint and not ReachedMid) then
		creature:SendUnitSay(OnMidPointSay, 7)
		ReachedMid = true
	--We reached the location to take a break.
	elseif (creature:GetCurrentWaypointId() == BreakPoint and not EnemySpawn and ReachedMid) then
		creature:MoveStop()
		creature:SendUnitSay(OnBreakSay, 7)
		EnemySpawn = true
		creature:RegisterEvent(Escort_Spawn, 5000, 1)
	elseif (creature:GetCurrentWaypointId() == AfterAttackPoint and not NearEnd and ReachedMid) then
		creature:SendUnitSay(NearEndSay, 7)
		NearEnd = true
	elseif (creature:GetCurrentWaypointId() == CompletePoint and not EscortComplete and ReachedMid) then
		creature:RegisterEvent(Escort_Complete, 200, 1)
		creature:RegisterEvent(Escort_Respawn, 5000, 1)
		EscortComplete = true
	end
	
end

--Spawn enemy mobs
function Escort_Spawn(event, delay, pCall, creature)
	creature:SendUnitSay(FightSay, 7)
	local x = creature:GetX()
	local y = creature:GetY()
	local z = creature:GetZ()
    local spawn1 = creature:SpawnCreature(SpawnID1, Spawn1x, Spawn1y, Spawn1z, Spawn1o, 2, 90000)
    local spawn2 = creature:SpawnCreature(SpawnID2, Spawn2x, Spawn2y, Spawn2z, Spawn2o, 2, 90000)
    local spawn3 = creature:SpawnCreature(SpawnID3, Spawn3x, Spawn3y, Spawn3z, Spawn3o, 2, 90000)
	spawn1:AttackStart(creature)
	spawn2:AttackStart(creature)
	spawn3:AttackStart(creature)
end


--Complete the escort for the player and group members if any.
function Escort_Complete(event, delay, pCall, creature)
	creature:SendUnitSay(EndEscortSay, 7)
	creature:SetWalk(false)
	if (startPlayer ~= nil) then
		local plr = GetPlayerByName(startPlayer)
		if (plr:GetGroup() ~= nil) then
			local group = plr:GetGroup()
			local players = group:GetMembers()
			for a, plrs in pairs(players) do
				if plrs ~= nil and creature:GetDistance(plrs) <= 20 then
					if plrs:HasQuest(QUEST_ID) then
						plrs:CompleteQuest(QUEST_ID)
					end
				end
			end
		elseif  creature:GetDistance(plr) <= 20 then
			plr:CompleteQuest(QUEST_ID)
		end
	end
end


--Respawn the escort NPC
function Escort_Respawn(event, delay, pCall, creature)
	creature:RemoveEvents()
	OnTheMove = false
	SayAfterFight = false
	EscortComplete = false
	EnemySpawn = false
	ReachedMid = false
	startPlayer = nil
	Respawn = true
	creature:Kill(creature)
	creature:Respawn()
	creature:SetNPCFlags(3)
end


--On death
function Died(event, creature, killer)
	creature:RemoveEvents()
	if (startPlayer ~= nil) and not Respawn then
		creature:SendUnitSay(OnDeathSay, 7)
		local plr = GetPlayerByName(startPlayer)
		if (plr:GetGroup() ~= nil) then
			local group = plr:GetGroup()
			local players = group:GetMembers()
			for a, plrs in pairs(players) do
				if plrs ~= nil then
					if plrs:HasQuest(QUEST_ID) then
						plrs:FailQuest(QUEST_ID)
					end
				end
			end
		elseif plr ~= nil then
			plr:FailQuest(QUEST_ID)
		end
	end
	OnTheMove = false
	SayAfterFight = false
	EscortComplete = false
	EnemySpawn = false
	ReachedMid = false
	startPlayer = nil
	creature:Respawn()
	creature:SetNPCFlags(3)
end


--Setup on spawn
function OnSpawn(event, creature)
	OnTheMove = false
	SayAfterFight = false
	EscortComplete = false
	EnemySpawn = false
	ReachedMid = false
	startPlayer = nil
	creature:SetNPCFlags(3)
end

RegisterCreatureGossipEvent(NPC_ID, 1, OnGossipHello)
RegisterCreatureGossipEvent(NPC_ID, 2, OnGossipSelect)
RegisterCreatureEvent(NPC_ID, 4, Died)
RegisterCreatureEvent(NPC_ID, 5, OnSpawn)
